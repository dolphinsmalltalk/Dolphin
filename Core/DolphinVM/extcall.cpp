/******************************************************************************

	File: ExtCall.cpp

	Description:

	Implementation of the Interpreter class' generic external call primitive 
	methods (but see also ExternalCall.asm).

******************************************************************************/
#include "Ist.h"

#pragma code_seg(FFI_SEG)

// Prevent warning of redefinition of WIN32_LEAN_AND_MEAN in atldef.h
#define ATL_NO_LEAN_AND_MEAN
#include <atlconv.h>

#include "ObjMem.h"
#include "Interprt.h"
#include "DolphinX.h"
using namespace DolphinX;
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk Classes
#include "STBehavior.h"
#include "STExternal.h"
#include "STByteArray.h"
#include "STString.h"
#include "STMethod.h"
#include "STCharacter.h"
#include "STInteger.h"
#include "STFloat.h"
#include "STContext.h"
#include "STBlockClosure.h"

static AnsiStringOTE* (__fastcall *ForceNonInlineNewByteStringFromUtf16)(LPCWSTR) = &AnsiString::New;
static AnsiStringOTE* (__fastcall *ForceNonInlineNewByteStringWithLen)(const char * __restrict, size_t) = &AnsiString::New;

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// Helpers for creating new structures and structure pointers.
// N.B. Requires intimate knowledge of the layout of the ExternalStructure
// subclasses!!

StructureOTE* __fastcall ExternalStructure::NewRefStruct(BehaviorOTE* classPointer, void* ptr)
{
	StructureOTE* resultPointer = reinterpret_cast<StructureOTE*>(ObjectMemory::newPointerObject(classPointer));
	ExternalStructure& extStruct = *resultPointer->m_location;
	AddressOTE* oteAddress = ExternalAddress::New(ptr);
	extStruct.m_contents = reinterpret_cast<BytesOTE*>(oteAddress);
	extStruct.m_contents->m_count = 1;
	return resultPointer;
}

///////////////////////////////////////////////////////////////////////////////
// Answer a new ExternalStructure pointer of the specified class with the specified pointer value

OTE* __fastcall ExternalStructure::NewPointer(BehaviorOTE* classPointer, void* ptr)
{
	OTE* resultPointer;
	Behavior& behavior = *classPointer->m_location;
	if (behavior.isPointers())
	{
		resultPointer = reinterpret_cast<OTE*>(NewRefStruct(classPointer, ptr));
	}
	else
	{
		if (behavior.isIndirect())
		{
			AddressOTE* oteBytes = reinterpret_cast<AddressOTE*>(ObjectMemory::newByteObject<false, false>(classPointer, sizeof(uint8_t*)));
			ExternalAddress* extAddress = static_cast<ExternalAddress*>(oteBytes->m_location);
			extAddress->m_pointer = ptr;
			resultPointer = reinterpret_cast<OTE*>(oteBytes);
		}
		else
		{
			size_t nSize = behavior.extraSpec();
			BytesOTE* oteBytes = ObjectMemory::newByteObject(classPointer, nSize, ptr);
			resultPointer = reinterpret_cast<OTE*>(oteBytes);
		}
		classPointer->countUp();
	}

	return resultPointer;
}


///////////////////////////////////////////////////////////////////////////////
// Answer a new ExternalStructure pointer of the specified class with the specified pointer value

OTE* __fastcall ExternalStructure::New(BehaviorOTE* classPointer, void* ptr)
{
	OTE* resultPointer;
	Behavior& behavior = *classPointer->m_location;
	BytesOTE* bytesPointer;
	auto size = behavior.extraSpec();
	if (behavior.isPointers())
	{
		StructureOTE* otePointers = reinterpret_cast<StructureOTE*>(ObjectMemory::newPointerObject(classPointer));
		ExternalStructure* extStruct = otePointers->m_location;
		bytesPointer = ObjectMemory::newByteObject<false, false>(Pointers.ClassByteArray, size);
		extStruct->m_contents = bytesPointer;
		bytesPointer->m_count = 1;
		resultPointer = reinterpret_cast<OTE*>(otePointers);
	}
	else
	{
		bytesPointer = ObjectMemory::newByteObject<false, false>(classPointer, size);
		// N.B. newByteObject does not inc. ref count of class when not initializing
		classPointer->countUp();
		resultPointer =	reinterpret_cast<OTE*>(bytesPointer);
	}

	VariantByteObject* bytes = bytesPointer->m_location;
	memcpy(bytes->m_fields, ptr, size);
	return resultPointer;
}

///////////////////////////////////////////////////////////////////////////////
// Answer a new BSTR from the specified UTF16 string

AddressOTE* __fastcall NewBSTR(const char16_t* pChars, size_t len)
{
	AddressOTE* resultPointer = reinterpret_cast<AddressOTE*>(ObjectMemory::newByteObject<false, false>(Pointers.ClassBSTR, sizeof(uint8_t*)));
	ExternalAddress* extAddress = resultPointer->m_location;
	if (len > 0)
	{
		extAddress->m_pointer = reinterpret_cast<uint8_t*>(::SysAllocStringLen((const OLECHAR*)pChars, len));
		resultPointer->beFinalizable();
	}
	else
		extAddress->m_pointer = 0;
	return resultPointer;
}

// Answer a new BSTR converted from the a byte string with the specified encoding
template <codepage_t CP, class TChar> static AddressOTE* __fastcall NewBSTR(const TChar* psz, size_t cch)
{
	const UINT cp = CP == CP_ACP ? Interpreter::m_ansiCodePage : CP;
	int cwch = cch * 2;
	char16_t* buf = reinterpret_cast<char16_t*>(_malloca(cwch * 2));
	cwch = ::MultiByteToWideChar(cp, 0, reinterpret_cast<LPCCH>(psz), cch, reinterpret_cast<LPWSTR>(buf), cwch);
	AddressOTE* bstr = NewBSTR(buf, cwch);
	_freea(buf);
	return bstr;
}

AddressOTE* __fastcall NewBSTR(OTE* ote)
{
	if (ote->isNullTerminated())
	{
		StringClass* strClass = reinterpret_cast<StringClass*>(ote->m_oteClass->m_location);
		switch (strClass->Encoding)
		{
		case StringEncoding::Ansi:
			return NewBSTR<CP_ACP, AnsiString::CU>(reinterpret_cast<AnsiStringOTE*>(ote)->m_location->m_characters, ote->getSize());
		case StringEncoding::Utf8:
			return NewBSTR<CP_UTF8, Utf8String::CU>(reinterpret_cast<Utf8StringOTE*>(ote)->m_location->m_characters, ote->getSize());
		case StringEncoding::Utf16:
			return NewBSTR(reinterpret_cast<Utf16StringOTE*>(ote)->m_location->m_characters, ote->getSize() / sizeof(Utf16String::CU));
		case StringEncoding::Utf32:
			return nullptr;

		default:
			// Unrecognised encoding
			__assume(false);
			break;
		}
	}

	return nullptr;
}

///////////////////////////////////////////////////////////////////////////////
// Answer a new wide string converted from any othre type of string
// Used for lpwstr arguments

Utf16StringOTE* __fastcall ST::Utf16String::New(OTE* oteString)
{
	ASSERT(oteString->isNullTerminated());

	switch (oteString->m_oteClass->m_location->m_instanceSpec.m_encoding)

	{
	case StringEncoding::Ansi:
		return Utf16String::New<CP_ACP>(reinterpret_cast<const AnsiStringOTE*>(oteString)->m_location->m_characters, oteString->getSize());
	case StringEncoding::Utf8:
		return Utf16String::New<CP_UTF8>(reinterpret_cast<const Utf8StringOTE*>(oteString)->m_location->m_characters, oteString->getSize());
	case StringEncoding::Utf16:
		ASSERT(FALSE);
		return reinterpret_cast<Utf16StringOTE*>(oteString);
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return nullptr;
	default:
		__assume(false);
		break;
	}
	return nullptr;
}

///////////////////////////////////////////////////////////////////////////////
// 

inline void Interpreter::push(LPCWSTR pStr)
{
   	if (pStr)
	{
		pushNewObject((OTE*)ST::Utf16String::New(pStr));
	}
	else
		pushNil();
}

BytesOTE* __fastcall NewGUID(GUID* rguid)
{
	return ObjectMemory::newByteObject(Pointers.ClassGUID, sizeof(GUID), rguid);
}

FARPROC Interpreter::GetDllCallProcAddress(DolphinX::ExternalMethodDescriptor* descriptor, LibraryOTE* oteReceiver)
{
	HMODULE hModule = static_cast<HMODULE>(oteReceiver->m_location->m_handle->m_location->m_handle);
	LPCSTR procName = reinterpret_cast<LPCSTR>(descriptor->m_descriptor.m_args + descriptor->m_descriptor.m_argsLen);
	int ordinal = atoi(procName);
	if (ordinal != 0)
	{
		procName = reinterpret_cast<LPCSTR>(ordinal);
	}

	FARPROC proc = ::GetProcAddress(hModule, procName);
	descriptor->m_proc = proc;

	return proc;
}

///////////////////////////////////////////////////////////////////////////////
//
argcount_t Interpreter::pushArgsAt(const ExternalDescriptor* descriptor, uint8_t* lpParms)
{
	DescriptorOTE* oteTypes = descriptor->m_descriptor;
	const DescriptorBytes* types = oteTypes->m_location;
	const auto argsLen = types->argsLen(oteTypes);
	auto i=0u;
	while (i<argsLen)
	{
		uint8_t arg = types->m_args[i++];
		// Similar to primitiveDLL32Call return values, but VOID is not supported as a parameter type
		switch(ExtCallArgType(arg))
		{
			case ExtCallArgType::Void:					// Not a valid argument
				HARDASSERT(FALSE);
				pushNil();
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::LPVoid:
				pushNewObject((OTE*)ExternalAddress::New(*(uint8_t**)lpParms));
				lpParms += sizeof(uint8_t*);
				break;

			case ExtCallArgType::Char:
				pushObject((OTE*)Character::NewUnicode(*reinterpret_cast<char32_t*>(lpParms)));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::UInt8:
				pushSmallInteger(*lpParms);
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Int8:
				pushSmallInteger(*reinterpret_cast<char*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;
			
			case ExtCallArgType::UInt16:
				pushSmallInteger(*reinterpret_cast<uint16_t*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Int16:
				pushSmallInteger(*reinterpret_cast<int16_t*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::UInt32:
				pushUint32(*reinterpret_cast<uint32_t*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Int32:
			case ExtCallArgType::HResult:
			case ExtCallArgType::NTStatus:
				pushInt32(*reinterpret_cast<int32_t*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Bool:
				pushBool(*reinterpret_cast<BOOL*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Handle:
				pushHandle(*reinterpret_cast<HANDLE*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Double:
				push(*reinterpret_cast<double*>(lpParms));
				// Yup, even doubles passed on main stack
				lpParms += sizeof(DOUBLE);
				break;

			case ExtCallArgType::LPStr:
				push(*reinterpret_cast<LPCSTR*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Oop:
			case ExtCallArgType::Ote:
				push(*reinterpret_cast<Oop*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Float:
				push(static_cast<double>(*reinterpret_cast<float*>(lpParms)));
				// Yup, even floats passed on main stack
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::LPPVoid:
				// Push an LPVOID* instance onto the stack
				pushNewObject(ExternalStructure::NewPointer(Pointers.ClassLPVOID, *(uint8_t**)lpParms));
				lpParms += sizeof(uint8_t*);
				break;

			case ExtCallArgType::LPWStr:
				push(*reinterpret_cast<LPWSTR*>(lpParms));
				lpParms += sizeof(LPWSTR);
				break;
				
			case ExtCallArgType::UInt64:
				push(Integer::NewUnsigned64(*reinterpret_cast<uint64_t*>(lpParms)));
				lpParms += sizeof(uint64_t);
				break;
				
			case ExtCallArgType::Int64:
				push(Integer::NewSigned64(*reinterpret_cast<int64_t*>(lpParms)));
				lpParms += sizeof(int64_t);
				break;
			
			case ExtCallArgType::Bstr:
				push(*reinterpret_cast<LPWSTR*>(lpParms));
				lpParms += sizeof(BSTR);
				break;
				
			case ExtCallArgType::Variant:
				pushNewObject(ExternalStructure::New(Pointers.ClassVARIANT, lpParms));
				lpParms += sizeof(VARIANT);
				break;

			case ExtCallArgType::Date:
				pushNewObject(ExternalStructure::New(Pointers.ClassDATE, lpParms));
				lpParms += sizeof(DATE);
				break;

			case ExtCallArgType::VarBool:
				pushBool(*reinterpret_cast<VARIANT_BOOL*>(lpParms));
				lpParms += sizeof(uintptr_t);
				break;

			case ExtCallArgType::Guid:
				pushNewObject((OTE*)NewGUID(reinterpret_cast<GUID*>(lpParms)));
				lpParms += sizeof(GUID);
				break;

			case ExtCallArgType::UIntPtr:
				pushUintPtr(*reinterpret_cast<UINT_PTR*>(lpParms));
				lpParms += sizeof(UINT_PTR);
				break;

			case ExtCallArgType::IntPtr:
				pushIntPtr(*reinterpret_cast<INT_PTR*>(lpParms));
				lpParms += sizeof(INT_PTR);
				break;

			case ExtCallArgType::Struct:
				{
					arg = types->m_args[i++];
					BehaviorOTE* behaviorPointer = reinterpret_cast<BehaviorOTE*>(descriptor->m_literals[arg]);
					pushNewObject(ExternalStructure::New(behaviorPointer, lpParms));
					lpParms += behaviorPointer->m_location->extraSpec();
				}
				break;

			case ExtCallArgType::Struct32:
				{
					arg = types->m_args[i++];
					BehaviorOTE* behaviorPointer = reinterpret_cast<BehaviorOTE*>(descriptor->m_literals[arg]);
					pushNewObject(ExternalStructure::New(behaviorPointer, lpParms));
					lpParms += sizeof(uintptr_t);
				}
				break;

			case ExtCallArgType::Struct64:
				{
					arg = types->m_args[i++];
					BehaviorOTE* behaviorPointer = reinterpret_cast<BehaviorOTE*>(descriptor->m_literals[arg]);
					pushNewObject(ExternalStructure::New(behaviorPointer, lpParms));
					lpParms += 8;
				}
				break;

			case ExtCallArgType::LPStruct:
				{
					arg = types->m_args[i++];
					BehaviorOTE* behaviorPointer = reinterpret_cast<BehaviorOTE*>(descriptor->m_literals[arg]);
					pushNewObject(ExternalStructure::NewPointer(behaviorPointer, *(uint8_t**)lpParms));
					lpParms += sizeof(uint8_t*);
				}
				break;

			case ExtCallArgType::LPPStruct:							// Not a valid argument
				arg = types->m_args[i++];
				pushNewObject(ExternalStructure::NewPointer(Pointers.ClassLPVOID, *(uint8_t**)lpParms));
				lpParms += sizeof(uint8_t*);
				break;

			case ExtCallArgType::ComPtr:
				{
					arg = types->m_args[i++];
					IUnknown* punk = *(IUnknown**)lpParms;
					BehaviorOTE* behaviorPointer = reinterpret_cast<BehaviorOTE*>(descriptor->m_literals[arg]);
					StructureOTE* oteUnknown = ExternalStructure::NewRefStruct(behaviorPointer, punk);
					if (punk != NULL)
					{
						punk->AddRef();
						oteUnknown->beFinalizable();
					}
					pushNewObject((OTE*)oteUnknown);
					lpParms += sizeof(IUnknown*);
				}
				break;

			default:
				__assume(false);
		}
	}
	return types->m_argumentCount;
}


///////////////////////////////////////////////////////////////////////////////
//
Oop* __fastcall Interpreter::primitivePerformWithArgsAt(Oop* const sp, primargcount_t)
{
	Oop oopDescriptor = *sp;
	if (ObjectMemoryIsIntegerObject(oopDescriptor))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);
	OTE* descriptorPointer = reinterpret_cast<OTE*>(oopDescriptor);
	if (descriptorPointer->isBytes())
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);

	Oop oopSelector = *(sp-2);
	if (ObjectMemoryIsIntegerObject(oopSelector))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	TODO("Should really check that it is actually a symbol?");
	SymbolOTE* selectorPointer = reinterpret_cast<SymbolOTE*>(oopSelector);

	// Decode the address argument
	Oop oopAddress = *(sp-1);
	uint8_t* lpParms;
	if (ObjectMemoryIsIntegerObject(oopAddress))
		lpParms = reinterpret_cast<uint8_t*>(ObjectMemoryIntegerValueOf(oopAddress));
	else
	{
		OTE* args = reinterpret_cast<OTE*>(oopAddress);
		if (args->isPointers())
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
		else
		{
			lpParms = static_cast<uint8_t*>(static_cast<ExternalAddress*>(args->m_location)->m_pointer);
		}
	}

	// Pop the descriptor and address and the selector
	m_registers.m_stackPointer = sp - 3;

	argcount_t argCount;
	// NEW FORMAT
	ExternalDescriptor* descriptor = static_cast<ExternalDescriptor*>(descriptorPointer->m_location);
	argCount = pushArgsAt(descriptor, lpParms);

	// Now we can throw away the descriptor
	sendSelectorArgumentCount(selectorPointer, argCount);

	return primitiveSuccess(0);
}

///////////////////////////////////////////////////////////////////////////////
// N.B. THIS IS VERY SIMILAR TO primitiveValueWithArgs()!
Oop* __fastcall Interpreter::primitiveValueWithArgsAt(Oop* const sp, primargcount_t)
{
	Oop oopDescriptor = *sp;
	if (ObjectMemoryIsIntegerObject(oopDescriptor))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
	OTE* descriptorPointer = reinterpret_cast<OTE*>(oopDescriptor);
	if (descriptorPointer->isBytes())
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);

	Oop argPointer = *(sp-1);
	uint8_t* lpParms;
	if (ObjectMemoryIsIntegerObject(argPointer))
		lpParms = reinterpret_cast<uint8_t*>(ObjectMemoryIntegerValueOf(argPointer));
	else
	{
		OTE* args = reinterpret_cast<OTE*>(argPointer);
		if (args->isPointers())
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
		else
			lpParms = static_cast<uint8_t*>(static_cast<ExternalAddress*>(args->m_location)->m_pointer);
	}

	BlockOTE* oteBlock = reinterpret_cast<BlockOTE*>(*(sp-2));
	HARDASSERT(ObjectMemory::fetchClassOf(Oop(oteBlock)) == Pointers.ClassBlockClosure);
	BlockClosure* block = oteBlock->m_location;
	const auto blockArgumentCount = block->m_info.argumentCount;

	const ExternalDescriptor* descriptor = static_cast<ExternalDescriptor*>(descriptorPointer->m_location);
	const DescriptorBytes* types = static_cast<DescriptorBytes*>(descriptor->m_descriptor->m_location);
	const auto argCount = types->m_argumentCount;
	
	if (argCount != blockArgumentCount)
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);

	// Pop off args and receiver block.
	m_registers.m_stackPointer = sp - 3;

	// Store old context details from interpreter registers
	m_registers.StoreContextRegisters();

	push(block->m_receiver);		// Note that this overwrites the block itself

	// BP of new frame points at first arg
	Oop* bp = m_registers.m_stackPointer+1;

	// With new block closures, args must be on the stack immediate after receiver (i.e. at BP)
	pushArgsAt(descriptor, lpParms);

	Oop* localSp = m_registers.m_stackPointer + 1;

	const auto copiedValues = block->copiedValuesCount(oteBlock);
	{
		for (auto i=0u;i<copiedValues;i++)
		{
			Oop oopCopied = block->m_copiedValues[i];
			*localSp++ = oopCopied;
		}
	}

	const auto extraTemps = block->stackTempsCount();
	{
		const Oop nilPointer = Oop(Pointers.Nil);
		for (auto i=0u;i<extraTemps;i++)
			*localSp++ = nilPointer;
	}

	// Stack frame follows args...
	StackFrame* pFrame = reinterpret_cast<StackFrame*>(localSp);

	m_registers.m_stackPointer = reinterpret_cast<Oop*>(reinterpret_cast<uint8_t*>(pFrame)+sizeof(StackFrame)) - 1;

	pFrame->m_caller = m_registers.activeFrameOop();	// This overwrites receiver in stack, ref. count used for m_base
	// We don't need to store down correct IP and SP into the frame until it is suspended,
	// but we do need to initialize the slots so they don't contain old garbage
	pFrame->m_ip = ZeroPointer;
	pFrame->m_sp = ZeroPointer;

	HARDASSERT(ObjectMemory::isKindOf(block->m_method, Pointers.ClassCompiledMethod));
	pFrame->m_method = block->m_method;
	
	// Note that ref. count remains the same due to overwritten receiver slot
	const auto envTemps = block->envTempsCount();
	if (envTemps > 0)
	{
		ContextOTE* oteContext = Context::New(envTemps, reinterpret_cast<Oop>(block->m_outer));
		pFrame->m_environment = reinterpret_cast<Oop>(oteContext);
		Context* context = oteContext->m_location;
		context->m_block = oteBlock;
		oteBlock->countUp();
	}
	else
		pFrame->m_environment = reinterpret_cast<Oop>(oteBlock);

	pFrame->m_bp = reinterpret_cast<Oop>(bp)+1;
	m_registers.m_basePointer = bp;

	CompiledMethod* pMethod = pFrame->m_method->m_location;
	m_registers.m_pMethod = pMethod;

	m_registers.m_instructionPointer = ObjectMemory::ByteAddressOfObjectContents(pMethod->m_byteCodes) +
											block->initialIP() - 1;
	m_registers.m_pActiveFrame = pFrame;

	return m_registers.m_stackPointer;
}


///////////////////////////////////////////////////////////////////////////////
//
#ifdef _DEBUG
	// Some test functions

	extern "C" {

		__declspec(dllexport) uint32_t __stdcall answerArg(uint32_t intParm)
		{
			return intParm;
		}

		__declspec(dllexport) float __stdcall answerFloatFromDouble(double fParm)
		{
			return static_cast<float>(fParm);
		}

		__declspec(dllexport) float __stdcall answerFloatFromFloat(float fParm)
		{
			return fParm;
		}

		__declspec(dllexport) double __stdcall answerDoubleFromInt(int32_t intParm)
		{
			return intParm;
		}

		__declspec(dllexport) double __stdcall addDoubles(double parm1, double parm2)
		{
			return parm1 + parm2;
		}

		__declspec(dllexport) double __stdcall incDouble(double parm1)
		{
			double blah = addDoubles(parm1, 1.0);
			return blah;
		}

	};

#endif


/*
// Debug example for returning struct by value
struct Blah
{
	int32_t a;
	int32_t b;
	int32_t c;
};

extern "C" __declspec(dllexport) Blah __stdcall makeBlah(int32_t a, int32_t b, int32_t c)
{
	Blah answer;
	answer.a = a;
	answer.b = b;
	answer.c = c;
	return answer;
}

void doBlah()
{
	Blah x = makeBlah(1, 2, 3);
	printf("%d %d %d", x.a, x.b, x.c);
}
*/

///////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////////////////////////////////////////////
// CPP Implementation (with inline assembler)
// N.B. THESE ARE NOT UP TO DATE WITH THE VERSIONS IN ExternalCall.asm
//
///////////////////////////////////////////////////////////////////////////////

#ifndef _M_IX86
	extern "C" BOOL __stdcall callExternalFunction(FARPROC pProc, argcount_t argCount, uint8_t* argTypes, BOOL isVirtual);

	BOOL __fastcall Interpreter::primitiveVirtualCall(Oop* const sp, primargcount_t argCount)
	{
		// Calling out may initiate a callback to Smalltalk
		// We need to ensure that this primitive is reentrant so we
		// save any cached registers of the interpreter.
		//

		CompiledMethod& method = *m_registers.m_oopNewMethod->m_location;

		OTE* objectPointer = *(sp - argCount);

		#ifdef _DEBUG
			// SmallIntegers are not valid receivers
			if (ObjectMemoryIsIntegerObject(objectPointer))
				return primitiveFailure(0);		// invalid receiver
		#endif

		if (ote->isPointers())
		{
			// If a pointer object, may be OK if the first byte is a byte object >= 4 bytes
			objectPointer = static_cast<VariantObject*>(ote->m_location)->m_fields[0];
			if (ObjectMemory::isPointers(objectPointer))
				return primitiveFailure(0);		// invalid receiver
		}

		ByteArray* receiverBytes = reinterpretcast<ByteArray*>(ote->m_location);
		if (ObjectMemory::fetchByteLengthOf(receiverBytes) < 4)
			return primitiveFailure(0);			// invalid receiver

		uint8_t* thisPointer;
		if (ObjectMemory::isIndirect(receiverBytes.m_class))
		{
			thisPointer = static_cast<ExternalAddress*>(receiverBytes)->m_pointer;
		}
		else
			thisPointer = receiverBytes.m_elements;

  		// We must leave arguments on the stack until after the call to
		// ensure that any callbacks to Smalltalk don't overwrite them
		// prematurely.
		//
		OTE* arrayPointer = method.m_aLiterals[LibCallArgArray];
		ByteArray* argTypes = static_cast<ByteArray*>(arrayPointer->m_location);

		// Compiler should have generated a literal array of argument types
		ASSERT(isNil(arrayPointer) || argTypes->m_class == Pointers.ClassByteArray);

		FARPROC pVirtualProc = reinterpret_cast<FARPROC*>(reinterpret_cast<uintptr_t*>(thisPointer)->[argTypes->m_elements[VirtualCallOffset]]);
			
		return ::callExternalFunction(pVirtualProc, argCount, argTypes->m_elements, TRUE);
	}

	// Compiler generates a special literal frame for this special primitive. The first literal
	// is a byte array containing:
	//
	//		0..3	Proc address cache (may not be used)
	//		4		calling convention (#stdcall, #api, #pascal, #c)
	//		5..N	Array of argument types (last is return type)
	//		N+1..M	Symbolic name of function to be called, or ordinal number
	//
	// This primitive does not check that enough types are specified, because it
	// assumes that the compiler does this.
	//
	BOOL __fastcall Interpreter::primitiveDLL32Call(Oop* const sp, primargcount_t argCount)
	{
		CompiledMethod& method = *m_registers.m_oopNewMethod->m_location;

		// Calling out may initiate a callback to Smalltalk
		// We need to ensure that this primitive is reentrant so we
		// save any cached registers of the interpreter.
		//

		// We must leave arguments on the stack until after the call to
		// ensure that any callbacks to Smalltalk don't overwrite them
		// prematurely.
		//
		Oop arrayPointer = method.m_aLiterals[LibCallArgArray];
		ByteArray* argTypes = static_cast<ByteArray*>(ObjectMemory::GetObj(arrayPointer));

		// Compiler should have generated a literal array of argument types
		ASSERT(isNil(arrayPointer) || argTypes.m_class == Pointers.ClassByteArray);

		// Try the cached address
		FARPROC pLibProc = *reinterpret_cast<FARPROC*>(argTypes.m_elements);
		if (!pLibProc)
		{
			size_t procNameOffset = argCount+ExtCallArgStart;
			#ifdef _DEBUG
				// Compiler should have ensured number of arg types = argumentCount
				size_t argsLength = ObjectMemory::fetchByteLengthOf(arrayPointer);
				ASSERT(argsLength > procNameOffset);
				// Compiler allocates space for a null terminator
				ASSERT(argTypes.m_elements[argsLength-1] == 0);
			#endif
			char* procName = reinterpret_cast<char*>(argTypes.m_elements)+procNameOffset;

			OTE* handlePointer = *(sp - argCount);
			ASSERT(!ObjectMemory::isBytes(handlePointer));
			handlePointer = reinterpret_cast<OTE*>(ObjectMemory::fetchPointerOfObject(0, handlePointer));
			HMODULE hModule = static_cast<HMODULE>((static_cast<ExternalHandle*>(handlePointer->m_location)->m_handle);

			// Compiler generates string for ordinals too
			unsigned ordinal = atoi(procName);
			pLibProc = ::GetProcAddress(hModule, ordinal?(LPCSTR)ordinal:procName);

			// Cache the value back in the method for later use
			*reinterpret_cast<FARPROC*>(argTypes.m_elements) = pLibProc;
		}

		if (pLibProc)
		{
			TODO("Implement thiscall and fastcall");
			ASSERT(argTypes.m_elements[ExtCallConvention] < ExtCallThisCall);
			//TRACE((char*)(argTypes).m_elements+argCount+6); TRACESTREAM<< L"\n";
			return ::callExternalFunction(pLibProc, argCount, argTypes.m_elements, FALSE);
		}
		else
			return primitiveFailure(1);	// procedure not found
	}

	// Returns true/false for success/failure. Also sets the failure code.
	BOOL __stdcall Interpreter::callExternalFunction(FARPROC pProc, argcount_t argCount, uint8_t* argTypes, BOOL isVirtual)
	{
		Oop arg;
		uintptr_t retValue;

		TODO("Rewrite the whole lot in assembler for speed")
		TODO("Fix all the sign extension stuff")
		
		// Compiler optimises out unless we pretend its volatile
		StackFrame volatile* pCallingFrame = (StackFrame volatile*)m_pActiveFrame;
		
		uintptr_t savedSP;
		_asm {
			mov		eax, esp
			mov		DWORD PTR[savedSP], eax
		}

		size_t pushCount = argCount + isVirtual - 1;
		Oop* stackPointer = m_stackPointer - pushCount;

		// Push args from Smalltalk stack onto machine stack
		for (auto i = pushCount;i >= 0;i--)
		{
			arg = stackPointer[i];
			switch (argTypes[ExtCallArgStart+i])
			{
				case ExtCallArgVOID:
					// Compiler should not generate this
					goto preCallFail;

				case ExtCallArgLPSTR:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jnz		preCallFail				// Yes? an error
						//jz		skipZero
						//cmp		eax, 1
						//je		integerPointer
						//jmp		preCallFail
					//skipZero:
						test	BYTE PTR([eax].m_flags), 2	// Is it a pointer object?
						jnz		tryNil					// Yes, OK only if Nil object
						mov		ecx, [eax].m_oteClass	// Load the class Oop
						mov		eax, [eax].m_location	// Load object pointer
						add		eax, sizeof(Object)		// Skip the object header
						cmp		ecx, [Pointers.ClassByteString]
						jne		preCallFail				// Not a String? an error
						push	eax						// Push pointer to object data
					}
					break;

				case ExtCallArgLPVOID:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jnz		integerPointer			// Yes, try as pointer
						test	BYTE PTR([eax].m_flags), 2	// Is it a pointer object?
						jz		pushByteObjectAddress	// No, skip handling for ExternalStructures
						cmp		eax, [Pointers.Nil]		// Is it nil?
						je		pushNil					// Yes, then push 0 and continue
						mov		eax, [eax].m_location	// Load pointer to object
						cmp		[eax].m_size, sizeof(Object)+sizeof(Oop)		// Byte Length of at least 12?
						jl		preCallFail				// No, not valid
						mov		eax, DWORD PTR [eax+sizeof(Object)]	// Load Oop of first inst var
						test	al, 1					// Is the first inst var a SmallInteger
						jnz		integerPointer			// Yes
						test	BYTE PTR([eax].m_flags), 2	// Is it a pointer object?
						jnz		preCallFail				// If still pointer object, then fail it

					pushByteObjectAddress:
						mov		ecx, [eax].m_oteClass	// Load the class Oop
						mov		eax, [eax].m_location	// Load object pointer
						add		eax, sizeof(Object)		// Skip the object header
						mov		ecx, [ecx].m_location	// Load address of class object
						TODO("YUCK, makes difficult to change - do some other way")
						test	BYTE PTR[ecx].m_instanceSpec+3, 0x10	// Test indirection bit
						jz		skipIndirection
						mov		eax, [eax]				// Object contains an address so deref it
					skipIndirection:
						push	eax						// Push pointer to object data
					}
					continue;
					integerPointer:
					_asm 
					{
						sar		eax, 1
						push	eax
					}
					break;

				case ExtCallArgCHAR:
					_asm
					{
						mov		eax, DWORD PTR [arg]		// Load Oop
						test	al, 1						// Is it a SmallInteger?
						jnz		preCallFail					// Yes, no good
						mov		ecx, [eax].m_oteClass		// Load the class Oop
						mov		eax, [eax].m_location		// Load object pointer
						cmp		ecx, [Pointers.ClassCharacter]
						jne		preCallFail					// Not a character
						mov		eax, [eax].m_codePoint		// Load ascii value of char (SmallInteger)
						sar		eax, 1						// Convert to SmallInteger
						push	eax
					}
					break;					

				case ExtCallArgBYTE:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		preCallFail
						sar		eax, 1
						cmp		eax, 0xFF
						ja		preCallFail				// Fail if above 16rFF (unsigned comparison)
						push	eax
					}
					break;

				case ExtCallArgSBYTE:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		preCallFail
						sar		eax, 1
						cmp		eax, 127
						jg		preCallFail				// Fail if > 127 (signed comparison)
						cmp		eax, -128
						jl		preCallFail				
						and		eax, 0xFF
						push	eax
					}
					break;

				case ExtCallArgWORD:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		wordFromBytes			// No
						sar		eax, 1
						and		eax, 0xFFFF
						push	eax
					}
					continue;
					wordFromBytes:
					_asm {
						test	BYTE PTR([eax].m_flags), 2	// Is it a pointer object?
						jnz		tryNil						// Yes, no good unless nil
						mov		eax, [eax].m_location		// Load address of object
						cmp		[eax].m_size, sizeof(Object)+2		// Byte Length of 2?
						jne		preCallFail					// No, no good
						movzx	eax, WORD PTR[eax+sizeof(Object)]	// Load first word after header (zero extend)
						push	eax
					}
					break;

				case ExtCallArgSWORD:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		swordFromBytes			// No
						sar		eax, 1
						and		eax, 0xFFFF
						push	eax
					}
					continue;
					swordFromBytes:
					_asm {
						test	BYTE PTR[eax+4], 2		// Is it a pointer object?
						jnz		tryNil					// Yes, no good
						mov		eax, [eax].m_location	// Load address of object
						cmp		[eax].m_size, sizeof(Object)+2		// Byte Length of 2?
						jne		preCallFail				// No, no good
						movsx	eax, WORD PTR[eax+sizeof(Object)]	// Load first word after header (sign extend)
						push	eax
					}
					break;

				case ExtCallArgHANDLE:
				case ExtCallArgSDWORD:
				case ExtCallArgDWORD:
				case ExtCallArgHRESULT:
				case ExtCallArgNTSTATUS:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		dwordFromBytes			// No
						sar		eax, 1
						push	eax
					}
					continue;
					dwordFromBytes:
					_asm {
						test	BYTE PTR([eax].m_flags), 2		// Is it a pointer object?
						jnz		tryNil							// Yes, but might be nil
						mov		eax, [eax].m_location			// Load address of object
						cmp		[eax].m_size, sizeof(Object)+4	// Byte Length of 4?
						jne		preCallFail							// No, no good
						mov		eax, DWORD PTR[eax+sizeof(Object)]	// Load first word after header (zero extend)
						push	eax
					}
					continue;
					tryNil:
						_asm cmp	eax, [Pointers.Nil]
						_asm jne	preCallFail
					pushNil:
						_asm push	0x00000000
					break;

				case ExtCallArgBOOL:
					_asm 
					{
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jz		tryTrue					// No
						sar		eax, 1					// Convert to machine representation
						push	eax						// and push it
					}
					continue;
					tryTrue:
					_asm 
					{
						cmp		eax, DWORD PTR [Pointers.True]
						jne		tryFalse
						push	0x00000001				// True value is 1
					}
					continue;
					tryFalse:
					_asm {
						cmp		eax, DWORD PTR [Pointers.False]
						jne		preCallFail				// Neither true nor false, so fail
						push	0x00000000				// False value is 0
					}
					break;

				case ExtCallArgOOP:
					_asm
					{
						mov		eax, DWORD PTR[arg]
						push	eax
					}
					break;

				case ExtCallArgDATE:
				case ExtCallArgDOUBLE:
					_asm
					{
						//inc		[dwordsToPop]
						mov		eax, DWORD PTR[arg]
						test	al, 1					// SmallInteger?
						jz		pushDouble				// No
						sar		eax, 1					// Convert to machine representation
						mov		DWORD PTR[arg], eax
						fild	DWORD PTR[arg]
  						sub		esp, 8
  						fstp	QWORD PTR [esp]
  					}
					continue;
					pushDouble:
					_asm {
						mov		edx, [eax].m_oteClass		// Load class of object
						mov		eax, [eax].m_location		// Load address of object
						cmp		edx, [Pointers.ClassFloat]	// Is it a Float
						jne		preCallFail				// No
						mov		edx, DWORD PTR[eax+sizeof(Object)+4]	// Load second dword after header
						push	edx
						mov		edx, DWORD PTR[eax+sizeof(Object)]	// Load first dword after header
						push	edx
					}
					break;

				case ExtCallArgFLOAT:
					_asm
					{
						mov		eax, DWORD PTR[arg]
						test	al, 1					// SmallInteger?
						jz		pushFloat				// No
						sar		eax, 1					// Convert to machine representation
						mov		DWORD PTR[arg], eax
						fild	DWORD PTR[arg]
  						sub		esp, 4
  						fstp	DWORD PTR [esp]
  					}
					continue;
					pushFloat:
					_asm {
						mov		edx, [eax].m_oteClass		// Load class of object
						mov		eax, [eax].m_location		// Load address of object
						cmp		edx, [Pointers.ClassFloat]		// Is it a Float
						jne		preCallFail				// No
						fld		QWORD PTR[eax+sizeof(Object)]
						sub		esp, 4
						fstp	DWORD PTR[esp]
					}
					break;

				case ExtCallArgLPPVOID:
					_asm {
						mov		eax, DWORD PTR [arg]	// Load Oop
						test	al, 1					// Is it a SmallInteger?
						jnz		preCallFail				// Yes, fail it
						test	BYTE PTR([eax].m_flags), 2		// Is it a pointer object?
						jz		pushAddress				// No, skip handling for ExternalStructures
						mov		eax, [eax].m_location	// Load pointer to object
						cmp		[eax], sizeof(Object)+4	// Byte Length of at least 12?
						jl		preCallFail				// No, not valid
						mov		eax, DWORD PTR [eax+sizeof(Object)]	// Load Oop of first inst var
						test	al, 1					// Is the first inst var a SmallInteger
						jnz		preCallFail				// Yes, fail it
						test	BYTE PTR([eax].m_flags), 2	// Is the first inst var a pointer object
						jnz		preCallFail				// If still pointer object, then fail it

					pushAddress:
						mov		ecx, [eax].m_oteClass	// Load the class Oop
						mov		eax, [eax].m_location	// Load object pointer
						add		eax, sizeof(Object)		// Skip the object header
						mov		ecx, [ecx].m_location	// Load address of class object
						TODO("YUCK, makes difficult to change - do some other way")
						test	BYTE PTR[ecx].m_instanceSpec+3, 0x10	// Test indirection bit
						jz		preCallFail				// only ExternalAddress acceptable
						push	eax						// Push pointer to object data
					}
					break;

				default:
					// Unsupported type
					goto preCallFail;
			}
		}

		// Do the call and store the result.
		// Note that the arguments are left on the stack for the duration of the call
		// to prevent a recursive invocation overwriting them and causing them to be
		// deallocated and also in case of a GP fault in the library procedure
		retValue = (*pProc)();

		// Reset the stack
		_asm
		{
			mov 	eax, DWORD PTR[savedSP]
			mov		esp, eax
		}

		// If an error occurs during a DLL call which causes a callback to Smalltalk, then the
		// Smalltalk stack may be being unwound past the return from this primitive, so we simply
		// do nothing (which will allow any unwind blocks to run), otherwise we must adjust the stack 
		// for arguments, and push the result.
		if	(pCallingFrame == m_pActiveFrame)
		{
			#ifdef _DEBUG
				stackPointer += pushCount;
				if (stackPointer != m_stackPointer)
				{
					TRACE("primitiveDLL32Call WARNING: before call SP %p, after call SP %p\n\r", stackPointer, m_stackPointer);
					const ptrdiff_t extra = m_stackPointer - stackPointer;
					if (extra > 0)
					{
						for (auto i=0;i<extra;i++)
						{
							printStackTop(m_stackPointer, TRACESTREAM);
							m_stackPointer--;
						}
						ASSERT(m_stackPointer == stackPointer);
					}
					m_stackPointer = stackPointer;
				}
			#endif
			
			// Place return value on Smalltalk stack.
			// It may appear that the pop() to clear down the stack is common, but it isn't because
			// HRESULT returns can fail the primitive at this late stage. Note also that VOID return
			// value causes the method to answer self.
			switch(argTypes[ExtCallReturnType])
			{
				case ExtCallArgLPPVOID:
					// Compiler should not generate as a return type, but if it does, treat as lpvoid
				case ExtCallArgLPVOID:
					pop(argCount);
					replaceStackTopObjectWithNewObject(NewExternalAddress(reinterpret_cast<uint8_t*>(retValue));
					break;

				case ExtCallArgCHAR:
					pop(argCount);
					replaceStackTopObjectNoRefCnt(NewChar(static_cast<char>(retValue)));
					break;

				case ExtCallArgBYTE:
					pop(argCount);
					replaceStackTopObjectNoRefCnt(ObjectMemoryIntegerObjectOf(static_cast<uint8_t>(retValue));
					break;

				case ExtCallArgSBYTE:
				{
					pop(argCount);
					char signedChar = static_cast<char>(retValue);
					replaceStackTopObjectNoRefCnt(ObjectMemoryIntegerObjectOf(static_cast<SmallInteger>(signedChar)));
					break;
				}

				case ExtCallArgWORD:
					pop(argCount);
					replaceStackTopObjectNoRefCnt(ObjectMemoryIntegerObjectOf(static_cast<uint16_t>(retValue));
					break;

				case ExtCallArgSWORD:
				{
					pop(argCount);
					int16_t signedWord = static_cast<int16_t>(retValue);
					replaceStackTopObjectNoRefCnt(ObjectMemoryIntegerObjectOf(static_cast<SmallInteger>(signedWord)));
					break;
				}

				case ExtCallArgHRESULT:
				case ExtCallArgNTSTATUS:
				{
					HRESULT hresult = static_cast<HRESULT>(retValue);
					if (FAILED(hresult))
						return primitiveFailure(NewSigned(hresult));	// Fail it, leaving stack as it was
				}
				// Deliberately drop through, so handled same as #dword

				case ExtCallArgDWORD:
					pop(argCount);
					replaceObjectAtStackTopWith(NewUnsigned(retValue));
					break;

				case ExtCallArgSDWORD:
					pop(argCount);
					replaceObjectAtStackTopWith(NewSigned(retValue));
					break;

				case ExtCallArgBOOL:
					pop(argCount);
					replaceStackTopObjectNoRefCnt(retValue ? Pointers.True : Pointers.False);
					break;

				case ExtCallArgHANDLE:
					pop(argCount);
					if (!dwValue)
						replaceStackTopObjectNoRefCnt(Pointers.Nil);
					else
						replaceStackTopObjectWithNewObject(NewExternalHandle(static_cast<HANDLE>(retValue)));
					break;

				case ExtCallArgDATE:
				case ExtCallArgDOUBLE:
				case ExtCallArgFLOAT:
				{
					double fResult;
					_asm fstp	QWORD PTR [fResult]
					pop(argCount);
					replaceStackTopObjectWithNewObject(NewFloat(fResult));
					break;
				}

				case ExtCallArgLPSTR:
					pop(argCount);
					if (!dwValue)
						replaceStackTopObjectNoRefCnt(Pointers.Nil);
					else
						replaceStackTopObjectWithNewObject(NewString((const char*)retValue));
					break;

				// For future use with User Primitive Kit
				case ExtCallArgOOP:
					pop(argCount);
					ASSERT(!ObjectMemoryIsIntegerObject(retValue));
					*m_registers.m_stackPointer = dwValue;
					break;

				case ExtCallArgVOID:
					// Do nothing - leaving receiver on stack
				default:
					pop(argCount);
					break;					// Not a valid return type
			}
		}
		else
			TRACE("Unwinding %s\n", argTypes+ExtCallArgStart+argCount);

		return primitiveSuccess();

	preCallFail:
		// Reset the stack following failure to set up correctly
		_asm 
		{
			mov 	eax, DWORD PTR[savedSP]
			mov		esp, eax
		}

		return primitiveFailure(16+i);
	}
#endif

