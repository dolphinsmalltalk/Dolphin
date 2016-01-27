/*
============
DolphinIF.cpp
============
Interface to the Dolphin interpreter for use from external DLLs
*/
							
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#pragma code_seg(XIF_SEG)

#include "Interprt.h"
#include "ObjMem.h"
#include <stdarg.h>
#include <wtypes.h>
#include "rc_vm.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"


// Smalltalk classes
#include "STByteArray.h"
#include "STString.h"		// For instantiating new strings
#include "STInteger.h"		// NewDWORD uses to create new integer, also for winproc return
#include "STArray.h"	
#include "STCharacter.h"
#include "STFloat.h"

#if 1
	// Boot version combines compiler into VM
	#define _DOLPHINAPI(x) x __stdcall
#else
	#define _DOLPHINAPI(x) __declspec(dllexport) x __stdcall
#endif

extern VMPointers _Pointers;

#undef POTE

namespace DolphinIF 
{
	struct VMPointers;
	typedef void* POTE;

	_DOLPHINAPI(DolphinIF::VMPointers&) __stdcall GetVMPointers()
	{
		return *(DolphinIF::VMPointers*)&_Pointers;
	}

	_DOLPHINAPI(void) AddReference(Oop objectPointer)
	{
		ObjectMemory::countUp(objectPointer);
	}

	_DOLPHINAPI(void) RemoveReference(Oop objectPointer)
	{
		ObjectMemory::countDown(objectPointer);
	}

	_DOLPHINAPI(POTE) FetchClassOf(Oop objectPointer)
	{
		return ObjectMemory::fetchClassOf(objectPointer);
	}

	_DOLPHINAPI(bool) InheritsFrom(const POTE behaviorPointer, const POTE classPointer)
	{
		return ObjectMemory::inheritsFrom((const BehaviorOTE*)behaviorPointer, (const BehaviorOTE*)classPointer);
	}


	_DOLPHINAPI(bool) IsBehavior(Oop objectPointer)
	{
		return ObjectMemory::isBehavior(objectPointer);
	}

	_DOLPHINAPI(bool) IsAMetaclass(const POTE ote)
	{
		return ObjectMemory::isAMetaclass(reinterpret_cast<OTE*>(ote));
	}

	_DOLPHINAPI(bool) IsAClass(const POTE ote)
	{
		return IsAMetaclass(FetchClassOf(Oop(ote)));
	}

	_DOLPHINAPI(Oop) Perform(Oop receiver, POTE selector)
	{
		return Interpreter::perform(receiver, reinterpret_cast<SymbolOTE*>(selector));
	}

	_DOLPHINAPI(Oop) PerformWith(Oop receiver, POTE selector, Oop arg)
	{
		return Interpreter::performWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg);
	}

	_DOLPHINAPI(Oop) PerformWithWith(Oop receiver, POTE selector, Oop arg1, Oop arg2)
	{
		return Interpreter::performWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2);
	}

	_DOLPHINAPI(Oop) PerformWithWithWith(Oop receiver, POTE selector, Oop arg1, Oop arg2, Oop arg3)
	{
		return Interpreter::performWithWithWith(receiver, reinterpret_cast<SymbolOTE*>(selector), arg1, arg2, arg3);
	}

	_DOLPHINAPI(Oop) PerformWithArguments(Oop receiver, POTE selector, Oop argArray)
	{
		return Interpreter::performWithArguments(receiver, reinterpret_cast<SymbolOTE*>(selector), argArray);
	}

	_DOLPHINAPI(POTE) NewObject(POTE classPointer)
	{
		return ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer));
	}

	_DOLPHINAPI(POTE) NewObjectWithPointers(POTE classPointer, unsigned size)
	{
		return ObjectMemory::newPointerObject(reinterpret_cast<BehaviorOTE*>(classPointer), size);
	}

	_DOLPHINAPI(POTE) NewByteArray(unsigned len)
	{
		return ByteArray::New(len);
	}

	_DOLPHINAPI(POTE) NewStringWithLen(const char* value, unsigned len)
	{
		return String::NewWithLen(value, len);
	}

	_DOLPHINAPI(Oop) NewSignedInteger(SDWORD value)
	{
		return Integer::NewSigned32(value);
	}

	//_DOLPHINAPI(Oop) NewSignedInteger(SQWORD value);
	_DOLPHINAPI(Oop) NewUnsignedInteger(DWORD value)
	{
		return Integer::NewUnsigned32(value);
	}

	//_DOLPHINAPI(Oop) NewUnsignedInteger(QWORD value);

	_DOLPHINAPI(POTE) NewCharacter(unsigned char value)
	{
		return Character::New(value);
	}

	_DOLPHINAPI(POTE) NewArray(unsigned size)
	{
		return Array::New(size);
	}

	_DOLPHINAPI(POTE) NewFloat(double fValue)
	{
		return Float::New(fValue);
	}

	_DOLPHINAPI(POTE) InternSymbol(const char* name)
	{
		return Interpreter::NewSymbol(name);
	}

	_DOLPHINAPI(void) StorePointerWithValue(Oop& oopSlot, Oop oopValue)
	{
		ObjectMemory::storePointerWithValue(oopSlot, oopValue);
	}

	_DOLPHINAPI(BOOL) DisableInterrupts(BOOL bDisable)
	{
		return Interpreter::disableInterrupts(bDisable?true:false);
	}

	_DOLPHINAPI(int) CallbackExceptionFilter(LPEXCEPTION_POINTERS info)
	{
		return Interpreter::callbackExceptionFilter(info);
	}

#ifdef _DEBUG
	_DOLPHINAPI(void) DecodeMethod(POTE methodPointer, void* stream)
	{
		Interpreter::decodeMethod(static_cast<CompiledMethod*>(static_cast<OTE*>(methodPointer)->m_location), 
				static_cast<ostream*>(stream));
	}
#endif

	_DOLPHINAPI(BOOL) DisableAsyncGC(BOOL bDisable)
	{
		return Interpreter::disableAsyncGC(bDisable?true:false);
	}

	_DOLPHINAPI(VOID) MakeImmutable(POTE ote, BOOL bImmutable)
	{
		if (bImmutable)
			static_cast<OTE*>(ote)->beImmutable();
		else
			static_cast<OTE*>(ote)->beMutable();
	}

	_DOLPHINAPI(BOOL) IsImmutable(Oop oop)
	{
		return isIntegerObject(oop) || (reinterpret_cast<OTE*>(oop)->isImmutable());
	}

};
