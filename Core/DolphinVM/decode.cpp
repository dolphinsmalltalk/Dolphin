/*
==========
Decode.cpp
==========
Decodes byte codes to stdout
*/

#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#pragma code_seg(DEBUG_SEG)

#include <sstream>

#include "Interprt.h"
#include "bytecdes.h"

#include "STObject.h"
#include "STMethod.h"		// For CompiledMethod
#include "STArray.h"
#include "STByteArray.h"
#include "STString.h"
#include "STAssoc.h"
#include "STBehavior.h"
#include "STInteger.h"
#include "STCharacter.h"
#include "STProcess.h"
#include "STClassDesc.h"
#include "STMessage.h"
#include "STContext.h"
#include "STBlockClosure.h"
#include "InterprtProc.inl"
#include "disassembler.h"
#include "Utf16StringBuf.h"

tracestream thinDump;

class UnknownOTE : public OTE {};

using namespace std;

static void printChars(wostream& stream, const char16_t* pwsz, size_t len)
{
	size_t end = min(len, 80);
	for (size_t i = 0; i < end; i++)
	{
		wchar_t ch = pwsz[i];
		if (!iswprint(ch))
		{
			stream << L"\\x" << std::hex << (unsigned)ch;
		}
		else
		{
			stream << ch;
		}
	}

	if (len > end)
		stream << L"...";

	//	stream.unlock();
}


std::wostream& __stdcall operator<<(std::wostream& stream, const std::string& str)
{
	Utf16StringBuf buf(reinterpret_cast<const char8_t*>(str.c_str()), str.size());
	printChars(stream, buf, buf.Count);
	return stream;
}

// Helper to dump characters to the tracestream
// Unprintable characters are printed in hex
wostream& operator<<(wostream& stream, const StringOTE* oteChars)
{
	//    stream.lock();

	if (isNil(oteChars)) return stream << L"nil";
	if (!oteChars->isNullTerminated())
	{
		stream << L"**Non-string object: " << (OTE*)oteChars << L"**";
	}
	else
	{
		StringEncoding encoding = oteChars->m_oteClass->m_location->m_instanceSpec.m_encoding;
		switch (encoding)
		{
		case StringEncoding::Ansi:
		{
			Utf16StringBuf buf(reinterpret_cast<const AnsiStringOTE*>(oteChars));
			printChars(stream, buf, buf.Count);
			break;
		}
		case StringEncoding::Utf8:
		{
			Utf16StringBuf buf(reinterpret_cast<const Utf8StringOTE*>(oteChars));
			printChars(stream, buf, buf.Count);
			break;
		}
		case StringEncoding::Utf16:
		{
			auto oteUtf16 = reinterpret_cast<const Utf16StringOTE*>(oteChars);
			printChars(stream, oteUtf16->m_location->m_characters, oteUtf16->Count);
			break;
		}
		default:
		case StringEncoding::Utf32:
			stream << L"String with encoding " << (int)encoding;
			break;
		}
	}

	return stream;
}

wostream& operator<<(wostream& st, const CompiledMethod& method)
{
	return st << method.m_methodClass << L">>" << method.m_selector;
}

wostream& operator<<(wostream& st, const MethodOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	BehaviorOTE* oteClass = ote->m_oteClass;
	if (oteClass == Pointers.ClassCompiledExpression)
	{
		st << L"a CompiledExpression";
	}
	else if (oteClass == Pointers.ClassCompiledMethod || oteClass == Pointers.ClassExternalMethod)
	{
		st << *ote->m_location;
	}
	else
	{
		st << L"**Non-method: " << reinterpret_cast<const OTE*>(ote) << L"**";
	}
	return st;
}

wostream& operator<<(wostream& st, const AnsiStringOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassAnsiString))
	{
		// Expected a String Oop, but got something else
		st << L"**Non-ByteString: " << reinterpret_cast<const OTE*>(ote) << L"**";
	}
	else
	{
		st << L"'";
		Utf16StringBuf buf(ote->m_location->m_characters, ote->bytesSize());
		printChars(st, buf, buf.Count);
		st << L"'";

	}
	return st;
}

wostream& operator<<(wostream& st, const Utf8StringOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassUtf8String))
	{
		// Expected a String Oop, but got something else
		st << L"**Non-Utf8String: " << reinterpret_cast<const OTE*>(ote) << L"**";
	}
	else
	{
		st << L"8'";
		Utf16StringBuf buf(ote->m_location->m_characters, ote->bytesSize());
		printChars(st, buf, buf.Count);
		st << L"'";

	}
	return st;
}

wostream& operator<<(wostream& st, const Utf16StringOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassUtf16String))
	{
		// Expected a String Oop, but got something else
		st << L"**Non-Utf16String: " << reinterpret_cast<const OTE*>(ote) << L"**";
	}
	else
	{
		st << L"L'";
		printChars(st, ote->m_location->m_characters, ote->bytesSize()/sizeof(Utf16String::CU));
		st << L"'";

	}
	return st;
}

inline wostream& operator<<(wostream& stream, const Class& cl)
{
	return stream << (StringOTE*)cl.m_name;
}


wostream& operator<<(wostream& stream, const ClassOTE* ote)
{
	if (isNil(ote)) return stream << L"nil";

	if (!isMetaclass(ote->m_oteClass))
		// Expected a Class Oop, but got something else
		return stream << L"**Non-class: " << reinterpret_cast<const OTE*>(ote) << L"**";
	else
		return stream << *ote->m_location;
}

wostream& operator<<(wostream& stream, const MetaClass& meta)
{
	return stream << meta.m_instanceClass << L" class";
}

wostream& operator<<(wostream& stream, const SymbolOTE* ote)
{
	if (isNil(ote)) return stream << L"nil";

	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassSymbol))
		// Expected a Symbol Oop, but got something else
		return stream << L"**Non-symbol: " << reinterpret_cast<const OTE*>(ote) << L"**";
	else
		// Dump without a # prefix
		return stream << reinterpret_cast<const StringOTE*>(ote);
}

wostream& operator<<(wostream& stream, const BehaviorOTE* ote)
{
	if (isNil(ote)) return stream << L"nil";

	if (!ObjectMemory::isBehavior(Oop(ote)))
		// Expected a class Oop, but got something else
		return stream << L"**Non-behaviour: " << reinterpret_cast<const OTE*>(ote) << L"**";
	else
		return isMetaclass(ote) ?
		stream << *static_cast<MetaClass*>(ote->m_location) :
		stream << *static_cast<Class*>(ote->m_location);
}

wostream& operator<<(wostream& st, const UnknownOTE* ote)
{
	if (isNil(ote)) return st << L"nil";

	return st << L"a " << ote->m_oteClass;
}

wostream& operator<<(wostream& st, const LargeIntegerOTE* ote)
{
	static constexpr int MaxWords = 20;

	if (isNil(ote)) return st << L"nil";

	LargeInteger* li = ote->m_location;
	st << L"a LargeInteger(" << std::hex << setfill(L'0');
	const size_t size = ote->getWordSize();
	if (size < MaxWords)
	{
		for (ptrdiff_t i = size - 1; i >= 0; i--)
			st << setw(8) << li->m_digits[i] << L' ';
	}
	else
	{
		// Dump only the top and bottom 10 words with middle ellipsis
		for (size_t i = size - 1; i >= size - (MaxWords/2); i--)
			st << setw(8) << li->m_digits[i] << L' ';
		st << L"... ";
		for (ptrdiff_t i = (MaxWords/2)-1; i >= 0; i--)
			st << setw(8) << li->m_digits[i] << L' ';
	}

	return st << setfill(L' ') << L')';
}

wostream& operator<<(wostream& st, const BlockOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	BlockClosure* block = ote->m_location;
	return st << L"[] @ " << std::dec << block->initialIP() << L" in " << block->m_method;
}


wostream& operator<<(wostream& st, const ContextOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	Context* ctx = ote->m_location;
	return st << L"a Context for: " << ctx->m_block
		<< L" frame: " << std::hex << ctx->m_frame;
}

wostream& operator<<(wostream& st, const VariableBindingOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	VariableBinding* var = ote->m_location;
	return st << var->m_key << L" -> " << reinterpret_cast<const OTE*>(var->m_value);
}

wostream& operator<<(wostream& st, const ProcessOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	Process* proc = ote->m_location;
	st << reinterpret_cast<const UnknownOTE*>(ote) << L"(" << reinterpret_cast<const OTE*>(proc->Name()) << L" base " << proc->getHeader();
	StackFrame* topFrame;
	Oop* sp = NULL;
	if (proc == Interpreter::actualActiveProcess())
	{
		st << L"*";
		topFrame = Interpreter::activeFrame();
	}
	else
	{
		Oop suspFrame = proc->SuspendedFrame();
		if (!ObjectMemoryIsIntegerObject(suspFrame))
		{
			st << L" frame=" << reinterpret_cast<OTE*>(suspFrame) << L")";
			return st;
		}

		topFrame = StackFrame::FromFrameOop(suspFrame);
		sp = topFrame->stackPointer();
	}

	return st << L" in " << topFrame->m_method << L" sp=" << sp
		<< L" ip=" << reinterpret_cast<OTE*>(topFrame->m_ip)
		<< L" list=" << proc->SuspendingList() << L")";
}

wostream& operator<<(wostream& st, const CharOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	Character* ch = ote->m_location;
	if (IsBadReadPtr(&ch, sizeof(Character)))
		return st << L"***Bad Character: " << ch;

	st << L'$';
	char32_t codePoint = ch->CodePoint;
	if (!ch->IsUtf8Surrogate)
	{
		if (u_isgraph(codePoint))
		{
			if (U_IS_BMP(codePoint))
			{
				return st << static_cast<wchar_t>(codePoint);
			}
			else
			{
				// Emit as surrogate pair
				return st << static_cast<wchar_t>((codePoint >> 10) + 0xd7c0) << static_cast<wchar_t>(codePoint & 0x3ff | 0xdc00);
			}
		}
	}

	return st << L"\\x" << std::hex << static_cast<uint32_t>(codePoint);
}

wostream& operator<<(wostream& st, const FloatOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	Float* fp = ote->m_location;
	if (IsBadReadPtr(fp, sizeof(Float)))
		return st << L"***Bad Float: " << &fp;
	else
		return st << fp->m_fValue;
}

wostream& operator<<(wostream& st, const MessageOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	Message* msg = ote->m_location;
	if (IsBadReadPtr(msg, sizeof(Message)))
		return st << L"***Bad Message: " << msg;
	else
		return st << L"Message selector: " << msg->m_selector << L" arguments: " << msg->m_args;
}

wostream& operator<<(wostream& st, const HandleOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	ExternalHandle* h = ote->m_location;
	st << reinterpret_cast<const UnknownOTE*>(ote) << L'(';
	if (IsBadReadPtr(h, sizeof(ExternalHandle)))
		st << L"***Bad Handle: " << (void*)h;
	else
		st << std::hex << h->m_handle;
	return st << L')';
}

wostream& operator<<(wostream& st, const ArrayOTE* ote)
{
	if (isNil(ote)) return st << L"nil";
	size_t size = ote->pointersSize();
	st << L"#(";
	if (size > 0)
	{
		Array* array = ote->m_location;
		if (IsBadReadPtr(array, SizeOfPointers(size)))
			return st << L"***Bad Array: " << (void*)array;
		else
		{
			size_t size = ote->pointersSize();
			size_t end = min(40, size);
			for (size_t i = 0; i < end; i++)
				st << reinterpret_cast<OTE*>(array->m_elements[i]) << L" ";
			if (end < size)
				st << L"...";
		}
	}
	return st << L")";
}

wostream& operator<<(wostream& stream, const OTE* ote)
{
	if (ObjectMemoryIsIntegerObject(ote))
		return stream << std::dec << ObjectMemoryIntegerValueOf(ote);

	if (ote == NULL)
		return stream << L"NULL Oop";

	// First try an access into the OTE to check if free. If this fails then
	// the OTE is bad
	__try
	{
		if (ote->isFree())
			return stream << L"***Freed object with Oop: " << PVOID(ote) <<
			", class: " << ote->m_oteClass;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		return stream << L"***Bad Oop: " << PVOID(ote);
	}

	// Handle specific object types
	if (ote == Pointers.Nil)
		stream << L"nil";
	else if (ote == Pointers.True)
		stream << L"true";
	else if (ote == Pointers.False)
		stream << L"false";
	else
	{
		// We need to examine the class to see what it is
		__try
		{
			const BehaviorOTE* classPointer = ote->m_oteClass;

			__try
			{
				if (classPointer->isFree())
					return stream << L"***Object (Oop " << PVOID(ote) << L") of the freed class Oop: " << PVOID(classPointer);
			}
			__except (EXCEPTION_EXECUTE_HANDLER)
			{
				// Class OTE is bad
				return stream << L"***Object (Oop " << PVOID(ote) << L") with bad class Oop: " << PVOID(classPointer);
			}

			if (isBehavior(ote))
				stream << reinterpret_cast<const BehaviorOTE*>(ote);
			else
			{
				if (classPointer == Pointers.ClassSymbol)
					stream << reinterpret_cast<const SymbolOTE*>(ote);
				else if (classPointer == Pointers.ClassAnsiString)
					stream << reinterpret_cast<const AnsiStringOTE*>(ote);
				else if (classPointer == Pointers.ClassUtf8String)
					stream << reinterpret_cast<const Utf8StringOTE*>(ote);
				else if (classPointer == Pointers.ClassUtf16String)
					stream << reinterpret_cast<const Utf16StringOTE*>(ote);
				else if (classPointer == Pointers.ClassCharacter)
					stream << reinterpret_cast<const CharOTE*>(ote);
				else if (classPointer == Pointers.ClassVariableBinding)
					stream << reinterpret_cast<const VariableBindingOTE*>(ote);
				else if (classPointer == Pointers.ClassProcess)
					stream << reinterpret_cast<const ProcessOTE*>(ote);
				else if (classPointer == Pointers.ClassLargeInteger)
					stream << reinterpret_cast<const LargeIntegerOTE*>(ote);
				else if (ObjectMemory::isKindOf(ote, Pointers.ClassCompiledMethod))
					stream << reinterpret_cast<const MethodOTE*>(ote);
				else if (classPointer == Pointers.ClassBlockClosure)
					stream << reinterpret_cast<const BlockOTE*>(ote);
				else if (classPointer == Pointers.ClassContext)
					stream << reinterpret_cast<const ContextOTE*>(ote);
				else if (classPointer == Pointers.ClassMessage)
					stream << reinterpret_cast<const MessageOTE*>(ote);
				else if (classPointer == Pointers.ClassFloat)
					stream << reinterpret_cast<const FloatOTE*>(ote);
				else if (classPointer == Pointers.ClassExternalHandle)
					stream << reinterpret_cast<const HandleOTE*>(ote);
#ifdef _DEBUG
				else if (classPointer == Pointers.ClassArray)
					stream << reinterpret_cast<const ArrayOTE*>(ote);
#endif
				else
					stream << reinterpret_cast<const UnknownOTE*>(ote);
			}
		}
		__except (EXCEPTION_EXECUTE_HANDLER)
		{
			stream << L"***Bad OTE or Object: " << LPVOID(ote) << L'(' << ote->m_location << L')';
		}
	}

	return stream;
}

SmallUinteger Interpreter::indexOfSP(Oop* sp)
{
	return actualActiveProcess()->indexOfSP(sp);
}

void DumpStackEntry(Oop* sp, Process* pProc, wostream& stream)
{
	__try
	{
		stream << L"[" << sp << L": " << std::dec << pProc->indexOfSP(sp) << L"]-->";
		Oop objectPointer = *sp;
		OTE* ote = reinterpret_cast<OTE*>(objectPointer);
		stream << ote;
#ifdef _DEBUG
		if (!ObjectMemoryIsIntegerObject(objectPointer))
			stream << L", refs " << std::dec << int(ote->m_count);
#endif
		stream << std::endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		stream << std::endl << L'\t' << L"***CORRUPT STACK ENTRY" << std::endl;
	}
}

/////////////////////////////////////////////////////////////////////////////
// Formatted output

void HexDump(tracestream out, LPCTSTR lpszLine, uint8_t* pby,
	size_t nBytes, size_t nWidth)
	// do a simple hex-dump (8 per line) to a tracestream
	//  the "lpszLine" is a string to print at the start of each line
	//    (%lx should be used to expand the current address)
{
	ASSERT(nBytes > 0);
	ASSERT(nWidth > 0);

	size_t nRow = 0;

	tracestream::char_type oldFill = out.fill('0');
	out << std::hex;
	out.setf(ios::uppercase);
	while (nBytes--)
	{
		if (nRow == 0)
		{
			wchar_t szBuffer[32];
			wsprintf(szBuffer, lpszLine, pby);
			out << szBuffer;
		}

		out << L' ' << setw(2) << *pby++;

		if (++nRow >= nWidth)
		{
			out << std::endl;
			nRow = 0;
		}
	}
	if (nRow != 0)
		out << std::endl;

	out.unsetf(ios::uppercase);
	out.fill(oldFill);
}

/////////////////////////////////////////////////////////////////////////////
// Diagnostic Stream output

//////////////////////////////////////////////////////////
// Dump Active Process info.
static void DumpProcess(ProcessOTE* oteProc, wostream& logStream)
{
	Process* pProc = oteProc->m_location;
	if (IsBadReadPtr(pProc, sizeof(Process)))
		logStream << L"(***Bad pointer: " << PVOID(pProc) << L")";
	else
	{
		logStream << L'{' << pProc << L':'
			<< L"size " << std::dec << oteProc->getWordSize()
			<< L" words, suspended frame " << reinterpret_cast<LPVOID>(pProc->SuspendedFrame())
			<< std::dec << L", priority " << pProc->Priority()
			<< L", callbacks " << pProc->CallbackDepth()
			<< L", FP control " << std::hex << pProc->FpControl()
			<< L", thread " << pProc->Thread();
	}
	logStream << L'}' << std::endl;
}

//////////////////////////////////////////////////////////
// Current Method info.

static void DumpIP(uint8_t* ip, CompiledMethod* pMethod, wostream& logStream)
{
	if (IsBadReadPtr(ip, 1))
		logStream << L"(Bad pointer: " << PVOID(ip) << L")";
	else
	{
		// Show the IP index
		if (IsBadReadPtr(pMethod, sizeof(CompiledMethod)))
		{
			logStream << L"(Unable to calculate IP index from " << PVOID(ip) << L")";
		}
		else
		{
			ptrdiff_t offsetFromBeginningOfByteCodesObject = ip - ObjectMemory::ByteAddressOfObject(pMethod->m_byteCodes);
			logStream << LPVOID(ip) << L" (" << std::dec << offsetFromBeginningOfByteCodesObject << L')';
		}
	}
	logStream << std::endl;
}

static void DumpStack(Oop* sp, Process* pProcess, wostream& logStream, size_t nDepth)
{
	if (IsBadReadPtr(sp, sizeof(Oop)))
		logStream << L"***Bad stack pointer: " << PVOID(sp) << std::endl;
	else
	{
		// Show the SP index
		if (IsBadReadPtr(pProcess, sizeof(Process)))
		{
			logStream << L"***Invalid process pointer: " << PVOID(pProcess) << std::endl;
		}
		else
		{
			// A short stack trace
			size_t i = 0;
			ptrdiff_t nSlots = sp - pProcess->m_stack;
			if (static_cast<size_t>(nSlots) > nDepth)
			{
				size_t nHalfDepth = nDepth / 2;
				while (sp >= pProcess->m_stack && i < nHalfDepth)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
					i++;
				}
				logStream << L"..." << std::endl
					<< L"<" << std::dec << nSlots - nDepth << L" slots omitted>" << std::endl
					<< L"..." << std::endl;

				sp = pProcess->m_stack + nHalfDepth;
				while (sp >= pProcess->m_stack)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
					i++;
				}
			}
			else
			{
				while (sp >= pProcess->m_stack)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
				}
			}

			logStream << L"<Bottom of stack>" << std::endl;
		}
	}
}

static void DumpBP(Oop* bp, Process* pProcess, wostream& logStream)
{
	if (IsBadReadPtr(bp, sizeof(Oop)))
		logStream << L"(Bad pointer: " << PVOID(bp) << L")";
	else
	{
		// Show the BP index
		if (IsBadReadPtr(pProcess, sizeof(Process)))
		{
			logStream << L"(Unable to calculate SP index from " << PVOID(bp) << L')';
		}
		else
		{
			SmallUinteger index = pProcess->indexOfSP(bp);
			logStream << bp << L" (" << std::dec << index << L')';
		}
	}
	logStream << std::endl;
}

wostream& operator<<(wostream& stream, StackFrame *pFrame)
{
	if (IsBadReadPtr(pFrame, sizeof(StackFrame)))
		stream << L"***Bad frame pointer: " << LPVOID(pFrame);
	else
	{
		Oop* bp = pFrame->basePointer();
		MethodOTE* oteMethod = pFrame->m_method;
		CompiledMethod* method = oteMethod->m_location;
		SmallInteger ip = ObjectMemoryIntegerValueOf(pFrame->m_ip);
		if (ip != 0)
			ip += isIntegerObject(method->m_byteCodes) ? 1 : -(static_cast<int>(ObjectByteSize) - 1);

		stream << L'{' << LPVOID(pFrame)	// otherwise would be recursive!
			<< L": cf " << LPVOID(pFrame->m_caller)
			<< L", sp " << pFrame->stackPointer()
			<< L", bp " << bp
			<< L", ip " << std::dec << ip
			<< L", ";

		ContextOTE* oteContext;
		Context* ctx;
		if (pFrame->hasContext())
		{
			oteContext = reinterpret_cast<ContextOTE*>(pFrame->m_environment);
			ctx = oteContext->m_location;
		}
		else
		{
			oteContext = NULL;
			ctx = NULL;
		}

		methodargcount_t argc;
		stacktempcount_t stackTempCount;
		if (ctx != NULL && ctx->isBlockContext())
		{
			stream << L"[] in ";
			const BlockClosure* block;

			if (oteContext->m_oteClass == Pointers.ClassBlockClosure)
			{
				block = reinterpret_cast<const BlockOTE*>(oteContext)->m_location;
				ctx = NULL;
			}
			else
				block = ctx->m_block->m_location;

			argc = block->argumentCount();
			stackTempCount = block->stackTempsCount();
		}
		else
		{
			argc = method->m_header.argumentCount;
			stackTempCount = method->m_header.stackTempCount;
		}

		Oop receiver = *(bp - 1);
		if (receiver == Oop(Pointers.Nil))
		{
			stream << method->m_methodClass;
		}
		else
		{
			BehaviorOTE* receiverClass = (BehaviorOTE*)ObjectMemory::fetchClassOf(receiver);
			//HARDASSERT(ObjectMemory::isKindOf(pFrame->m_method, superclassOf(Pointers.ClassCompiledMethod)));
			stream << receiverClass;
			if (method->m_methodClass != receiverClass)
				stream << L'(' << method->m_methodClass << L')';
		}
		stream << L">>" << method->m_selector
			<< '}' << std::endl;

		stream << L"	receiver: " << reinterpret_cast<OTE*>(receiver) << std::endl;
		for (auto i = 0u; i < argc; i++)
			stream << L"	arg[" << std::dec << i << L"]: " << reinterpret_cast<OTE*>(*(bp + i)) << std::endl;
		for (auto i = 0u; i < stackTempCount; i++)
			stream << L"	stack temp[" << std::dec << i << L"]: " << reinterpret_cast<OTE*>(*(bp + i + argc)) << std::endl;

		if (ctx != NULL)
		{
			const auto envTempCount = oteContext->pointersSize() - Context::FixedSize;
			for (auto i = 0u; i < envTempCount; i++)
				stream << L"	env temp[" << std::dec << i << L"]: " << reinterpret_cast<OTE*>(ctx->m_tempFrame[i]) << std::endl;
		}

		stream << std::endl;

	}
	return stream;
}

//////////////////////////////////////////////////////////
// Dump the interpreter context
void Interpreter::DumpContext(EXCEPTION_POINTERS *pExceptionInfo, wostream& logStream)
{
	saveContextAfterFault(pExceptionInfo);
	DumpContext(logStream);
}

void Interpreter::DumpContext(wostream& logStream)
{
	logStream << L"*----> VM Context <----*" << std::endl;

	__try
	{
		logStream << L"Process: ";
		DumpProcess(m_registers.m_oteActiveProcess, logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT ACTIVE PROCESS OR CONTEXT";
	}

	__try
	{
		logStream << L"Active Method: " << *m_registers.m_pMethod;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT CURRENT METHOD OR CONTEXT";
	}

	__try
	{
		logStream << std::endl << L"IP: ";
		DumpIP(m_registers.m_instructionPointer, m_registers.m_pMethod, logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT IP, METHOD, OR CONTEXT";
	}

	logStream << L"SP: " << m_registers.m_stackPointer << std::endl;

	__try
	{
		logStream << L"BP: ";
		DumpBP(m_registers.m_basePointer, actualActiveProcess(), logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT SP, PROCESS, OR CONTEXT" << std::endl;
	}

	__try
	{
		logStream << L"ActiveFrame: " << m_registers.m_pActiveFrame;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT ACTIVE FRAME OR CONTEXT" << std::endl;
	}

	__try
	{
		logStream << L"New Method: " << Interpreter::m_registers.m_oopNewMethod << std::endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT NEW METHOD OR CONTEXT" << std::endl;
	}

	__try
	{
		logStream << L"Message Selector: " << Interpreter::m_oopMessageSelector << std::endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT SELECTOR OR CONTEXT" << std::endl;
	}
}

/////////////////////////////////////////////////////////////////////////////

void Interpreter::DumpStack(wostream& logStream, size_t nStackDepth)
{
	if (nStackDepth == 0)
		return;

	logStream << std::endl << L"*----> Stack <----*" << std::endl;
	__try
	{
		::DumpStack(m_registers.m_stackPointer, actualActiveProcess(), logStream, nStackDepth);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << std::endl << L'\t' << L"***CORRUPT STACK" << std::endl;
	}
}

void Interpreter::StackTraceOn(wostream& dc, StackFrame* pFrame, size_t depth)
{
	if (!pFrame)
		pFrame = m_registers.m_pActiveFrame;
	Oop returnFrame;
	do
	{
		if (::IsBadReadPtr(pFrame, sizeof(StackFrame)))
		{
			dc << L"***Invalid frame pointer: " << LPVOID(pFrame) << std::endl;
			// Can't continue
			break;
		}

		dc << pFrame;

		returnFrame = pFrame->m_caller;
		pFrame = StackFrame::FromFrameOop(returnFrame);
		depth--;
	} while (depth > 0 && returnFrame != ZeroPointer
#if 0 //def _DEBUG
		&& !isCallbackFrame(returnFrame));
#else
		);
#endif

	dc << (depth == 0 ? "<...more...>" : "<Bottom of stack>") << std::endl;
}

#if defined(_DEBUG)

void Interpreter::WarningWithStackTraceBody(const wchar_t* warningCaption, StackFrame* pFrame)
{
	TRACESTREAM << std::endl << warningCaption << std::endl;
	StackTraceOn(TRACESTREAM, pFrame);
	TRACESTREAM << std::endl;
	//		decodeMethod((pFrame?pFrame:m_registers.m_pActiveFrame)->m_method, dc);
	TRACESTREAM << std::endl << flush;
}

void Interpreter::WarningWithStackTrace(const wchar_t* warningCaption, StackFrame* pFrame)
{
	__try
	{
		WarningWithStackTraceBody(warningCaption, pFrame);
	}
	// This used for debugging in exception handlers, so don't permit recursive exception
	__except (GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ? EXCEPTION_EXECUTE_HANDLER : EXCEPTION_CONTINUE_SEARCH)
	{
	}

}
#endif

/////////////////////////////////////////////////////////////////////////////

#if defined(_DEBUG)

// This is thoroughly nasty, but I don't care because it only required for debugging when C++ walkback might
// be used.
BOOL Interpreter::isCallbackFrame(Oop framePointer)
{
	StackFrame* pFrame = StackFrame::FromFrameOop(framePointer);
	BOOL bRet;
	if (pFrame->isBlockFrame())
		bRet = FALSE;
	else
	{
		CompiledMethod* cm = pFrame->m_method->m_location;
		SymbolOTE* selector = cm->m_selector;
		// Yucky yuck!
		bRet = selector == reinterpret_cast<SymbolOTE*>(Pointers.Nil) ||
			selector == Pointers.callbackPerformSymbol ||
			selector == Pointers.callbackPerformWithSymbol ||
			selector == Pointers.callbackPerformWithWithSymbol ||
			selector == Pointers.callbackPerformWithWithWithSymbol ||
			selector == Pointers.callbackPerformWithArgumentsSymbol ||
			selector == Pointers.wndProcSelector ||
			selector == Pointers.InternSelector;
	}
	return bRet;
}

void AppendAllInstVarNames(ClassDescriptionOTE* oteClass, std::vector<string>& instVarNames)
{
	if (reinterpret_cast<POTE>(oteClass) != Pointers.Nil)
	{
		ClassDescription* pClass = oteClass->m_location;
		// Recursively walk up to the top of the inheritance hierarchy (found by reaching nil), then append names at 
		// each level on the way back down
		AppendAllInstVarNames(reinterpret_cast<ClassDescriptionOTE*>(pClass->m_superclass), instVarNames);
		if (pClass->m_instanceVariables->m_oteClass == Pointers.ClassAnsiString)
		{
			// TODO: Use Utf8String
			AnsiStringOTE* oteNamesString = reinterpret_cast<AnsiStringOTE*>(pClass->m_instanceVariables);
			stringstream words(oteNamesString->m_location->m_characters);
			string each;
			while (getline(words, each, ' '))
			{
				if (!each.empty())
				{
					instVarNames.push_back(each);
				}
			}
		}
		else if (pClass->m_instanceVariables->m_oteClass == Pointers.ClassArray)
		{
			ArrayOTE* oteNamesArray = pClass->m_instanceVariables;
			Array* pNames = oteNamesArray->m_location;
			for (size_t i = 0; i < oteNamesArray->pointersSize(); i++)
			{
				// TODO: Use Utf8String
				AnsiStringOTE* oteEach = (AnsiStringOTE*)pNames->m_elements[i];
				instVarNames.push_back(oteEach->m_location->m_characters);
			}
		}
		// else ignore (could be nil legitimately)
	}
}

class DisassemblyContext
{
public:
	DisassemblyContext(CompiledMethod* method)
	{
		this->method = method;
		if (ObjectMemoryIsIntegerObject(method->m_byteCodes))
		{
			cBytes = sizeof(SmallInteger);
			pBytes = reinterpret_cast<uint8_t*>(&(method->m_byteCodes));
		}
		else
		{
			ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(method->m_byteCodes);
			cBytes = oteBytes->bytesSize();
			pBytes = oteBytes->m_location->m_elements;
		}

		literalFrame = &(method->m_aLiterals[0]);
		instVarNamesInitialized = false;
	}

	uint8_t GetBytecode(size_t ip) {
		_ASSERTE(ip < cBytes);
		return pBytes[ip];
	}

	std::string GetInstVar(size_t index) { 
		if (!instVarNamesInitialized)
		{
			AppendAllInstVarNames(reinterpret_cast<ClassDescriptionOTE*>(method->m_methodClass), instVarNames);
			instVarNamesInitialized = true;
		}
		return index < instVarNames.size() ? instVarNames[index] : "instvar-" + std::to_string(index);
	}

	std::wstring GetLiteralAsString(size_t index) {
		return Interpreter::PrintString(literalFrame[index]);
	}

	std::string GetSpecialSelector(size_t index) {
		_ASSERTE(index < NumSpecialSelectors);
		return reinterpret_cast<LPCSTR>(Pointers.specialSelectors[index]->m_location->m_characters);
	}

	intptr_t GetJumpTarget(size_t ip) {
		// Should not be needed for normal method disassembly, only by the compiler before jump bytecodes fully generated
		return ip;
	}

private:
	CompiledMethod* method;
	size_t cBytes;
	uint8_t* pBytes;
	Oop* literalFrame;
	vector<string> instVarNames;
	bool instVarNamesInitialized;
};

void Interpreter::decodeMethod(CompiledMethod* method, wostream* pstream)
{
	wostream& stream = pstream != NULL ? *pstream : (wostream&)TRACESTREAM;

	// Report method header
	STMethodHeader hdr = method->m_header;
	stream << L"Method " << method;
	if (hdr.primitiveIndex > 7)
		stream << L", primitive=" << std::dec << static_cast<int>(hdr.primitiveIndex);
	if (hdr.argumentCount > 0)
		stream << L"; args=" << std::dec << static_cast<int>(hdr.argumentCount);
	if (hdr.stackTempCount > 0)
		stream << L"; stack temps=" << std::dec << static_cast<int>(hdr.stackTempCount);
	int envTemps = hdr.envTempCount;
	if (envTemps > 0)
	{
		if (envTemps > 1)
			stream << L"; env temps=" << std::dec << envTemps - 1;
		stream << L"; needs context";
	}
	stream << std::endl;

	DisassemblyContext info(method);
	BytecodeDisassembler<DisassemblyContext, size_t> disassembler(info);

	const size_t size = ObjectMemoryIsIntegerObject(method->m_byteCodes)
		? sizeof(SmallInteger)
		: reinterpret_cast<ByteArrayOTE*>(method->m_byteCodes)->bytesSize();

	size_t i = 0;
	while (i < size)
	{
		i += disassembler.DisassembleAt(i, stream);
	}
}

void Interpreter::decodeMethodAt(CompiledMethod* method, size_t ip, wostream& stream)
{
	DisassemblyContext info(method);
	BytecodeDisassembler<DisassemblyContext, size_t> disassembler(info);
	disassembler.DisassembleAt(ip, stream);
	stream.flush();
}

#endif

std::wstring Interpreter::PrintString(Oop oop)
{
	std::wstringstream st;
	st << reinterpret_cast<POTE>(oop);
	return st.str();
}

void DumpObject(const POTE pote)
{
	TRACESTREAM << pote << std::endl;
}

#ifdef _DEBUG

// A useful little method to determine if the next fifty
// stack entries are still valid - detects bugs in the 
// interpreter
void Interpreter::checkStack(Oop* sp)
{
	/*		for (auto i=1;i<=50;i++)
	{
	Oop objectPointer = sp[i];
	if (!ObjectMemoryIsIntegerObject(objectPointer) &&
	((reinterpret_cast<OTE*>(objectPointer)->getCount() < MAXCOUNT)
	{
	TRACESTREAM << L"WARNING: sp+" << i << L" contains " << objectPointer << std::endl;
	}
	}
		*/		if (abs(executionTrace) > 3)
		{
			ProcessOTE* oteActive = m_registers.m_oteActiveProcess;
			size_t size = oteActive->getSize();
			m_registers.ResizeProcess();
			ObjectMemory::checkReferences();
			oteActive->setSize(size);
		}
}

void __fastcall Interpreter::debugReturnToMethod(Oop* sp)
{
	tracelock lock(TRACESTREAM);
	TRACESTREAM << std::endl << L"** Returned to Method: " << *m_registers.m_pMethod << std::endl;
}

void __fastcall Interpreter::debugMethodActivated(Oop* sp)
{
	tracelock lock(TRACESTREAM);
	TRACESTREAM << std::endl << L"** Method activated: " << m_registers.m_pActiveFrame->m_method << std::endl;
	if (executionTrace > 1)
	{
		decodeMethod(m_registers.m_pMethod, NULL);
		TRACESTREAM << std::endl;
	}

}

void __fastcall Interpreter::debugExecTrace(uint8_t* ip, Oop* sp)
{
	// To avoid covering bugs, we make sure we don't update the
	// context for longer than the duration of the trace
	uint8_t* oldIP = m_registers.m_instructionPointer;
	Oop* oldSP = m_registers.m_stackPointer;
	m_registers.m_stackPointer = sp;
	m_registers.m_instructionPointer = ip;

	if (abs(executionTrace) > 3)
		checkStack(sp);

	if (executionTrace > 0)
	{
		tracelock lock(TRACESTREAM);
		DumpStackEntry(sp, m_registers.m_pActiveProcess, TRACESTREAM);
		TODO("Get rid of this bodge by changing the way decode works")
			CompiledMethod* method = m_registers.m_pMethod;
		ptrdiff_t ipIndex = ip - ObjectMemory::ByteAddressOfObjectContents(method->m_byteCodes);
		HARDASSERT(ipIndex >= 0 && ipIndex < 1024);
		TRACESTREAM << L"{" << method << L"} ";
		decodeMethodAt(method, ipIndex, TRACESTREAM);

		if (false)
			decodeMethod(method);

		TRACESTREAM.flush();
	}

	HARDASSERT(!m_registers.m_pActiveProcess->IsWaiting());
	HARDASSERT(isNil(m_registers.m_pActiveProcess->Next()));

	m_registers.m_instructionPointer = oldIP;
	m_registers.m_stackPointer = oldSP;
}

extern "C" __declspec(dllexport) int __stdcall ExecutionTrace(int execTrace)
{
	int existing = Interpreter::executionTrace;
	Interpreter::executionTrace = execTrace;
	return existing;
}

const wchar_t* Interpreter::activeMethod()
{
	static wstring lastPrinted;
	std::wstringstream stream;
	stream << *Interpreter::m_registers.m_pMethod;
	lastPrinted = stream.str();
	return lastPrinted.c_str();
}

void DumpMethod(CompiledMethod* method)
{
	Interpreter::decodeMethod(method);
}

void DumpMethod(OTE* oteMethod)
{
	DumpMethod(static_cast<CompiledMethod*>(oteMethod->m_location));
}

extern "C" size_t byteCodeCounters[];
extern "C" size_t byteCodePairs[];

void DumpBytecodeCounts(bool bClear)
{

	TRACESTREAM << std::endl << L"Bytecode invocation counts" << std::endl << L"-----------------------------" << std::endl;
	for (auto i = 0; i < 256; i++)
	{
		TRACESTREAM << std::dec << i << L": " << byteCodeCounters[i] << std::endl;
		if (bClear) byteCodeCounters[i] = 0;
	}
	TRACESTREAM << L"-----------------------------" << std::endl << std::endl;

	TRACESTREAM << std::endl << L"Bytecode pair counts" << std::endl << L"-----------------------------" << std::endl;
	for (auto i = 0; i < 256; i++)
	{
		for (auto j = 0; j < 256; j++)
		{
			TRACESTREAM << byteCodePairs[i * 256 + j] << L' ';
			if (bClear) byteCodePairs[i * 256 + j] = 0;
		}
		TRACESTREAM << std::endl;
	}
	TRACESTREAM << L"-----------------------------" << std::endl << std::endl;

}

extern "C" size_t primitiveCounters[];

void DumpPrimitiveCounts(bool bClear)
{
	TRACESTREAM << std::endl << L"Primitive invocation counts" << std::endl << L"-----------------------------" << std::endl;
	for (auto i = 0; i <= PRIMITIVE_MAX; i++)
	{
		TRACESTREAM << std::dec << i << L": " << primitiveCounters[i] << std::endl;
		if (bClear) primitiveCounters[i] = 0;
	}

	TRACESTREAM << L"-----------------------------" << std::endl << std::endl;
}
#endif	// defined(_DEBUG)
