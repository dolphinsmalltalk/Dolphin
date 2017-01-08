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

tracestream thinDump;

class UnknownOTE : public OTE {};

typedef TOTE<VariantCharObject> VariantCharOTE;

void printChars(ostream& stream, const VariantCharOTE* oteChars)
{
	ASSERT(oteChars->isBytes());

	unsigned len = oteChars->bytesSize();
	VariantCharObject* string = oteChars->m_location;
	unsigned end = min(len, 80);
	for (unsigned i = 0; i < end; i++)
	{
		unsigned char ch = (unsigned char)string->m_characters[i];
		//if (ch = '\0') break;
		if (ch < 32 || ch > 127)
		{
			static char hexChars[16 + 1] = "0123456789ABCDEF";
			stream << '\\' << hexChars[ch >> 4] << hexChars[ch & 0xF] << '\\';
		}
		else
			stream << ch;
	}

	if (len > end)
		stream << "...";

	//	stream.unlock();
}

// Helper to dump characters to the tracestream
// Unprintable characters are printed in hex
ostream& operator<<(ostream& stream, const VariantCharOTE* oteChars)
{
	//    stream.lock();

	if (oteChars->isNil()) return stream << "nil";
	if (!oteChars->isBytes())
	{
		stream << "**Non-byte object: " << (OTE*)oteChars << "**";
	}
	else
	{
		printChars(stream, oteChars);
	}

	return stream;
}

ostream& operator<<(ostream& st, const CompiledMethod& method)
{
	return st << method.m_methodClass << ">>" << method.m_selector;
}

ostream& operator<<(ostream& st, const MethodOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	BehaviorOTE* oteClass = ote->m_oteClass;
	if (oteClass == Pointers.ClassCompiledExpression)
	{
		st << "a CompiledExpression";
	}
	else if (oteClass == Pointers.ClassCompiledMethod || oteClass == Pointers.ClassExternalMethod)
	{
		st << *ote->m_location;
	}
	else
	{
		st << "**Non-method: " << reinterpret_cast<const OTE*>(ote) << "**";
	}
	return st;
}

ostream& operator<<(ostream& st, const StringOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassString))
	{
		// Expected a String Oop, but got something else
		st << "**Non-String: " << reinterpret_cast<const OTE*>(ote) << "**";
	}
	else
	{
		st << "'";
		printChars(st, reinterpret_cast<const VariantCharOTE*>(ote));
		st << "'";
	}
	return st;
}

//inline ostream& operator<<(ostream& st, const Symbol& symbol)
//{
//	return st << '#' << (const VariantCharObject&)symbol;
//}

inline ostream& operator<<(ostream& stream, const Class& cl)
{
	return stream << (VariantCharOTE*)cl.m_name;
}


ostream& operator<<(ostream& stream, const ClassOTE* ote)
{
	if (ote->isNil()) return stream << "nil";

	if (!ote->m_oteClass->isMetaclass())
		// Expected a Class Oop, but got something else
		return stream << "**Non-class: " << reinterpret_cast<const OTE*>(ote) << "**";
	else
		return stream << *ote->m_location;
}

ostream& operator<<(ostream& stream, const MetaClass& meta)
{
	return stream << meta.m_instanceClass << " class";
}

ostream& operator<<(ostream& stream, const SymbolOTE* ote)
{
	if (ote->isNil()) return stream << "nil";

	if (!ObjectMemory::isKindOf(Oop(ote), Pointers.ClassSymbol))
		// Expected a Symbol Oop, but got something else
		return stream << "**Non-symbol: " << reinterpret_cast<const OTE*>(ote) << "**";
	else
		// Dump without a # prefix
		return stream << reinterpret_cast<const VariantCharOTE*>(ote);
}

ostream& operator<<(ostream& stream, const BehaviorOTE* ote)
{
	if (ote->isNil()) return stream << "nil";

	if (!ObjectMemory::isBehavior(Oop(ote)))
		// Expected a class Oop, but got something else
		return stream << "**Non-behaviour: " << reinterpret_cast<const OTE*>(ote) << "**";
	else
		return ote->isMetaclass() ?
		stream << *static_cast<MetaClass*>(ote->m_location) :
		stream << *static_cast<Class*>(ote->m_location);
}

ostream& operator<<(ostream& st, const UnknownOTE* ote)
{
	if (ote->isNil()) return st << "nil";

	return st << "a " << ote->m_oteClass;
}

ostream& operator<<(ostream& st, const LargeIntegerOTE* ote)
{
	if (ote->isNil()) return st << "nil";

	LargeInteger* li = ote->m_location;
	st << "a LargeInteger(" << hex << setfill('0');
	const int size = ote->getWordSize();
	for (int i = size - 1; i >= 0; i--)
		st << setw(8) << li->m_digits[i] << ' ';
	return st << setfill(' ') << ')';
}

ostream& operator<<(ostream& st, const BlockOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	BlockClosure* block = ote->m_location;
	return st << "[] @ " << dec << block->initialIP() << " in " << block->m_method;
}


ostream& operator<<(ostream& st, const ContextOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	Context* ctx = ote->m_location;
	return st << "a Context for: " << ctx->m_block
		<< " frame: " << hex << ctx->m_frame;
}

ostream& operator<<(ostream& st, const VariableBindingOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	VariableBinding* var = ote->m_location;
	return st << var->m_key << " -> " << reinterpret_cast<const OTE*>(var->m_value);
}

ostream& operator<<(ostream& st, const ProcessOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	Process* proc = ote->m_location;
	st << reinterpret_cast<const UnknownOTE*>(ote) << "(" << reinterpret_cast<const OTE*>(proc->Name()) << " base " << proc->getHeader();
	StackFrame* topFrame;
	Oop* sp = NULL;
	if (proc == Interpreter::actualActiveProcess())
	{
		st << " [ACTIVE]";
		topFrame = Interpreter::activeFrame();
	}
	else
	{
		Oop suspFrame = proc->SuspendedFrame();
		if (!ObjectMemoryIsIntegerObject(suspFrame))
		{
			st << " frame=" << reinterpret_cast<OTE*>(suspFrame) << ")";
			return st;
		}

		topFrame = StackFrame::FromFrameOop(suspFrame);
		sp = topFrame->stackPointer();
	}

	return st << " in " << topFrame->m_method << " sp=" << sp
		<< " ip=" << reinterpret_cast<OTE*>(topFrame->m_ip)
		<< " list=" << proc->SuspendingList() << ")";
}

ostream& operator<<(ostream& st, const CharOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	Character* ch = ote->m_location;
	if (IsBadReadPtr(&ch, sizeof(Character)))
		return st << "***Bad Character: " << ch;
	else
		return st << '$' << char(ObjectMemoryIntegerValueOf(ch->m_asciiValue));
}

ostream& operator<<(ostream& st, const FloatOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	Float* fp = ote->m_location;
	if (IsBadReadPtr(fp, sizeof(Float)))
		return st << "***Bad Float: " << &fp;
	else
		return st << fp->m_fValue;
}

ostream& operator<<(ostream& st, const MessageOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	Message* msg = ote->m_location;
	if (IsBadReadPtr(msg, sizeof(Message)))
		return st << "***Bad Message: " << msg;
	else
		return st << "Message selector: " << msg->m_selector << " arguments: " << msg->m_args;
}

ostream& operator<<(ostream& st, const HandleOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	ExternalHandle* h = ote->m_location;
	st << reinterpret_cast<const UnknownOTE*>(ote) << '(';
	if (IsBadReadPtr(h, sizeof(ExternalHandle)))
		st << "***Bad Handle: " << (void*)h;
	else
		st << hex << h->m_handle;
	return st << ')';
}

ostream& operator<<(ostream& st, const ArrayOTE* ote)
{
	if (ote->isNil()) return st << "nil";
	int size = ote->pointersSize();
	st << "#(";
	if (size > 0)
	{
		Array* array = ote->m_location;
		if (IsBadReadPtr(array, SizeOfPointers(size)))
			return st << "***Bad Array: " << (void*)array;
		else
		{
			int size = ote->pointersSize();
			int end = min(40, size);
			for (int i = 0; i < end; i++)
				st << reinterpret_cast<OTE*>(array->m_elements[i]) << " ";
			if (end < size)
				st << "...";
		}
	}
	return st << ")";
}

ostream& operator<<(ostream& stream, const OTE* ote)
{
	if (ObjectMemoryIsIntegerObject(ote))
		return stream << dec << ObjectMemoryIntegerValueOf(ote);

	if (ote == NULL)
		return stream << "NULL Oop";

	// First try an access into the OTE to check if free. If this fails then
	// the OTE is bad
	__try
	{
		if (ote->isFree())
			return stream << "***Freed object with Oop: " << PVOID(ote) <<
			", class: " << ote->m_oteClass;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		return stream << "***Bad Oop: " << PVOID(ote);
	}

	// Handle specific object types
	if (ote == Pointers.Nil)
		stream << "nil";
	else if (ote == Pointers.True)
		stream << "true";
	else if (ote == Pointers.False)
		stream << "false";
	else
	{
		// We need to examine the class to see what it is
		__try
		{
			const BehaviorOTE* classPointer = ote->m_oteClass;

			__try
			{
				if (classPointer->isFree())
					return stream << "***Object (Oop " << PVOID(ote) << ") of the freed class Oop: " << PVOID(classPointer);
			}
			__except (EXCEPTION_EXECUTE_HANDLER)
			{
				// Class OTE is bad
				return stream << "***Object (Oop " << PVOID(ote) << ") with bad class Oop: " << PVOID(classPointer);
			}

			if (ote->isBehavior())
				stream << reinterpret_cast<const BehaviorOTE*>(ote);
			else
			{
				if (classPointer == Pointers.ClassSymbol)
					stream << reinterpret_cast<const SymbolOTE*>(ote);
				else if (classPointer == Pointers.ClassString)
					stream << reinterpret_cast<const StringOTE*>(ote);
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
			stream << "***Bad OTE or Object: " << LPVOID(ote) << '(' << ote->m_location << ')';
		}
	}

	return stream;
}

SMALLUNSIGNED Interpreter::indexOfSP(Oop* sp)
{
	return actualActiveProcess()->indexOfSP(sp);
}

void DumpStackEntry(Oop* sp, Process* pProc, ostream& stream)
{
	__try
	{
		stream << "[" << sp << ": " << dec << pProc->indexOfSP(sp) << "]-->";
		Oop objectPointer = *sp;
		OTE* ote = reinterpret_cast<OTE*>(objectPointer);
		stream << ote;
#ifdef _DEBUG
		if (!ObjectMemoryIsIntegerObject(objectPointer))
			stream << ", refs " << dec << int(ote->m_count);
#endif
		stream << endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		stream << endl << '\t' << "***CORRUPT STACK ENTRY" << endl;
	}
}

// determine number of elements in an array (not bytes)
#ifndef _countof
#define _countof(array) (sizeof(array)/sizeof(array[0]))
#endif

/////////////////////////////////////////////////////////////////////////////
// Formatted output

void HexDump(tracestream out, LPCTSTR lpszLine, BYTE* pby,
	int nBytes, int nWidth)
	// do a simple hex-dump (8 per line) to a tracestream
	//  the "lpszLine" is a string to print at the start of each line
	//    (%lx should be used to expand the current address)
{
	ASSERT(nBytes > 0);
	ASSERT(nWidth > 0);

	int nRow = 0;

	char oldFill = out.fill('0');
	out << hex;
	out.setf(ios::uppercase);
	while (nBytes--)
	{
		if (nRow == 0)
		{
			char szBuffer[32];
			wsprintf(szBuffer, lpszLine, pby);
			out << szBuffer;
		}

		out << ' ' << setw(2) << *pby++;

		if (++nRow >= nWidth)
		{
			out << endl;
			nRow = 0;
		}
	}
	if (nRow != 0)
		out << endl;

	out.unsetf(ios::uppercase);
	out.fill(oldFill);
}

/////////////////////////////////////////////////////////////////////////////
// Diagnostic Stream output

//////////////////////////////////////////////////////////
// Dump Active Process info.
static void DumpProcess(ProcessOTE* oteProc, ostream& logStream)
{
	Process* pProc = oteProc->m_location;
	if (IsBadReadPtr(pProc, sizeof(Process)))
		logStream << "(***Bad pointer: " << PVOID(pProc) << ")";
	else
	{
		logStream << '{' << pProc << ':'
			<< "size " << dec << oteProc->getWordSize()
			<< " words, suspended frame " << reinterpret_cast<LPVOID>(pProc->SuspendedFrame())
			<< dec << ", priority " << pProc->Priority()
			<< ", callbacks " << pProc->CallbackDepth() << endl;
		logStream << "last failure " << pProc->PrimitiveFailureCode()
			<< ":" << reinterpret_cast<OTE*>(pProc->PrimitiveFailureData())
			<< ", FPE mask " << pProc->FpeMask()
			<< ", thread " << pProc->Thread();
	}
	logStream << '}' << endl;
}

//////////////////////////////////////////////////////////
// Current Method info.

static void DumpIP(BYTE* ip, CompiledMethod* pMethod, ostream& logStream)
{
	if (IsBadReadPtr(ip, 1))
		logStream << "(Bad pointer: " << PVOID(ip) << ")";
	else
	{
		// Show the IP index
		if (IsBadReadPtr(pMethod, sizeof(CompiledMethod)))
		{
			logStream << "(Unable to calculate IP index from " << PVOID(ip) << ")";
		}
		else
		{
			int offsetFromBeginningOfByteCodesObject = ip - ObjectMemory::ByteAddressOfObject(pMethod->m_byteCodes);
			logStream << LPVOID(ip) << " (" << dec << offsetFromBeginningOfByteCodesObject << ')';
		}
	}
	logStream << endl;
}

static void DumpStack(Oop* sp, Process* pProcess, ostream& logStream, unsigned nDepth)
{
	if (IsBadReadPtr(sp, sizeof(Oop)))
		logStream << "***Bad stack pointer: " << PVOID(sp) << endl;
	else
	{
		// Show the SP index
		if (IsBadReadPtr(pProcess, sizeof(Process)))
		{
			logStream << "***Invalid process pointer: " << PVOID(pProcess) << endl;
		}
		else
		{
			// A short stack trace
			unsigned i = 0;
			unsigned nSlots = sp - pProcess->m_stack;
			if (nSlots > nDepth)
			{
				unsigned nHalfDepth = nDepth / 2;
				while (sp >= pProcess->m_stack && i < nHalfDepth)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
					i++;
				}
				logStream << "..." << endl
					<< "<" << dec << nSlots - nDepth << " slots omitted>" << endl
					<< "..." << endl;

				sp = pProcess->m_stack + nHalfDepth;
				while (sp >= pProcess->m_stack)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
					i++;
				}
			}
			else
				while (sp >= pProcess->m_stack)
				{
					DumpStackEntry(sp, pProcess, logStream);
					sp--;
				}

			logStream << "<Bottom of stack>" << endl;
		}
	}
}

static void DumpBP(Oop* bp, Process* pProcess, ostream& logStream)
{
	if (IsBadReadPtr(bp, sizeof(Oop)))
		logStream << "(Bad pointer: " << PVOID(bp) << ")";
	else
	{
		// Show the BP index
		if (IsBadReadPtr(pProcess, sizeof(Process)))
		{
			logStream << "(Unable to calculate SP index from " << PVOID(bp) << ')';
		}
		else
		{
			int index = pProcess->indexOfSP(bp);
			logStream << bp << " (" << dec << index << ')';
		}
	}
	logStream << endl;
}

ostream& operator<<(ostream& stream, StackFrame *pFrame)
{
	if (IsBadReadPtr(pFrame, sizeof(StackFrame)))
		stream << "***Bad frame pointer: " << LPVOID(pFrame);
	else
	{
		Oop* bp = pFrame->basePointer();
		MethodOTE* oteMethod = pFrame->m_method;
		CompiledMethod* method = oteMethod->m_location;
		int ip = ObjectMemoryIntegerValueOf(pFrame->m_ip);
		if (ip != 0)
			ip += isIntegerObject(method->m_byteCodes) ? 1 : -(int(ObjectByteSize) - 1);

		stream << '{' << LPVOID(pFrame)	// otherwise would be recursive!
			<< ": cf " << LPVOID(pFrame->m_caller)
			<< ", sp " << pFrame->stackPointer()
			<< ", bp " << bp
			<< ", ip " << dec << ip
			<< ", ";

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

		unsigned argc;
		unsigned stackTempCount;
		if (ctx != NULL && ctx->isBlockContext())
		{
			stream << "[] in ";
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
				stream << '(' << method->m_methodClass << ')';
		}
		stream << ">>" << method->m_selector
			<< '}' << endl;

		stream << "	receiver: " << reinterpret_cast<OTE*>(receiver) << endl;
		unsigned i = 0;
		for (i = 0; i < argc; i++)
			stream << "	arg[" << dec << i << "]: " << reinterpret_cast<OTE*>(*(bp + i)) << endl;
		for (i = 0; i < stackTempCount; i++)
			stream << "	stack temp[" << dec << i << "]: " << reinterpret_cast<OTE*>(*(bp + i + argc)) << endl;

		if (ctx != NULL)
		{
			const unsigned envTempCount = oteContext->pointersSize() - Context::FixedSize;
			for (i = 0; i < envTempCount; i++)
				stream << "	env temp[" << dec << i << "]: " << reinterpret_cast<OTE*>(ctx->m_tempFrame[i]) << endl;
		}

		stream << endl;

	}
	return stream;
}

//////////////////////////////////////////////////////////
// Dump the interpreter context
void Interpreter::DumpContext(EXCEPTION_POINTERS *pExceptionInfo, ostream& logStream)
{
	saveContextAfterFault(pExceptionInfo, isInPrimitive());
	DumpContext(logStream);
}

void Interpreter::DumpContext(ostream& logStream)
{
	logStream << "*----> VM Context <----*" << endl;

	__try
	{
		logStream << "Process: ";
		DumpProcess(m_registers.m_oteActiveProcess, logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT ACTIVE PROCESS OR CONTEXT";
	}

	__try
	{
		logStream << "Active Method: " << *m_registers.m_pMethod;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT CURRENT METHOD OR CONTEXT";
	}

	__try
	{
		logStream << endl << "IP: ";
		DumpIP(m_registers.m_instructionPointer, m_registers.m_pMethod, logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT IP, METHOD, OR CONTEXT";
	}

	logStream << "SP: " << m_registers.m_stackPointer << endl;

	__try
	{
		logStream << "BP: ";
		DumpBP(m_registers.m_basePointer, actualActiveProcess(), logStream);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT SP, PROCESS, OR CONTEXT" << endl;
	}

	__try
	{
		logStream << "ActiveFrame: " << m_registers.m_pActiveFrame << endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT ACTIVE FRAME OR CONTEXT" << endl;
	}

	__try
	{
		logStream << "New Method: " << Interpreter::m_registers.m_oopNewMethod << endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT NEW METHOD OR CONTEXT" << endl;
	}

	__try
	{
		logStream << "Message Selector: " << Interpreter::m_oopMessageSelector << endl;
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT SELECTOR OR CONTEXT" << endl;
	}
}

/////////////////////////////////////////////////////////////////////////////

void Interpreter::DumpStack(ostream& logStream, unsigned nStackDepth)
{
	if (nStackDepth == 0)
		return;

	logStream << endl << "*----> Stack <----*" << endl;
	__try
	{
		::DumpStack(m_registers.m_stackPointer, actualActiveProcess(), logStream, nStackDepth);
	}
	__except (EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT STACK" << endl;
	}
}

void Interpreter::StackTraceOn(ostream& dc, StackFrame* pFrame, unsigned depth)
{
	if (!pFrame)
		pFrame = m_registers.m_pActiveFrame;
	Oop returnFrame;
	do
	{
		if (::IsBadReadPtr(pFrame, sizeof(StackFrame)))
		{
			dc << "***Invalid frame pointer: " << LPVOID(pFrame) << endl;
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

	dc << (depth == 0 ? "<...more...>" : "<Bottom of stack>") << endl;
}

#if defined(_DEBUG)

void Interpreter::WarningWithStackTraceBody(const char* warningCaption, StackFrame* pFrame)
{
	TRACESTREAM << endl << warningCaption << endl;
	StackTraceOn(TRACESTREAM, pFrame);
	TRACESTREAM << endl;
	//		decodeMethod((pFrame?pFrame:m_registers.m_pActiveFrame)->m_method, dc);
	TRACESTREAM << endl << flush;
}

void Interpreter::WarningWithStackTrace(const char* warningCaption, StackFrame* pFrame)
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

void Interpreter::AppendAllInstVarNames(ClassDescriptionOTE* oteClass, std::vector<string>& instVarNames)
{
	if (reinterpret_cast<POTE>(oteClass) != Pointers.Nil)
	{
		ClassDescription* pClass = oteClass->m_location;
		// Recursively walk up to the top of the inheritance hierarchy (found by reaching nil), then append names at 
		// each level on the way back down
		AppendAllInstVarNames(reinterpret_cast<ClassDescriptionOTE*>(pClass->m_superclass), instVarNames);
		if (pClass->m_instanceVariables->m_oteClass == Pointers.ClassString)
		{
			StringOTE* oteNamesString = reinterpret_cast<StringOTE*>(pClass->m_instanceVariables);
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
			for (MWORD i = 0; i < oteNamesArray->pointersSize(); i++)
			{
				_ASSERTE(ObjectMemory::isKindOf(pNames->m_elements[i], Pointers.ClassString));
				StringOTE* oteEach = (StringOTE*)pNames->m_elements[i];
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
			cBytes = sizeof(SMALLINTEGER);
			pBytes = reinterpret_cast<BYTE*>(&(method->m_byteCodes));
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

	BYTE GetBytecode(size_t ip) {
		_ASSERTE(ip < cBytes);
		return pBytes[ip];
	}

	std::string GetInstVar(size_t index) { 
		if (!instVarNamesInitialized)
		{
			Interpreter::AppendAllInstVarNames(reinterpret_cast<ClassDescriptionOTE*>(method->m_methodClass), instVarNames);
			instVarNamesInitialized = true;
		}
		return instVarNames[index]; 
	}

	std::string GetLiteralAsString(size_t index) {
		return Interpreter::PrintString(literalFrame[index]);
	}

	std::string GetSpecialSelector(size_t index) {
		_ASSERTE(index < NumSpecialSelectors);
		return Pointers.specialSelectors[index]->m_location->m_characters;
	}

private:
	CompiledMethod* method;
	unsigned cBytes;
	BYTE* pBytes;
	Oop* literalFrame;
	vector<string> instVarNames;
	bool instVarNamesInitialized;
};

void Interpreter::decodeMethod(CompiledMethod* method, ostream* pstream)
{
	ostream& stream = pstream != NULL ? *pstream : (ostream&)TRACESTREAM;

	// Report method header
	STMethodHeader hdr = method->m_header;
	stream << "Method " << method;
	if (hdr.primitiveIndex > 7)
		stream << ", primitive=" << dec << int(hdr.primitiveIndex);
	if (hdr.argumentCount > 0)
		stream << "; args=" << dec << int(hdr.argumentCount);
	if (hdr.stackTempCount > 0)
		stream << "; stack temps=" << dec << int(hdr.stackTempCount);
	int envTemps = hdr.envTempCount;
	if (envTemps > 0)
	{
		if (envTemps > 1)
			stream << "; env temps=" << dec << envTemps - 1;
		stream << "; needs context";
	}
	stream << endl;

	DisassemblyContext info(method);
	BytecodeDisassembler<DisassemblyContext> disassembler(info);

	const size_t size = ObjectMemoryIsIntegerObject(method->m_byteCodes)
		? sizeof(SMALLINTEGER)
		: reinterpret_cast<ByteArrayOTE*>(method->m_byteCodes)->bytesSize();

	size_t i = 0;
	while (i < size)
	{
		i += disassembler.DisassembleAt(i, stream);
	}
}

void Interpreter::decodeMethodAt(CompiledMethod* method, unsigned ip, ostream& stream)
{
	DisassemblyContext info(method);
	BytecodeDisassembler<DisassemblyContext> disassembler(info);
	disassembler.DisassembleAt(ip, stream);
	stream.flush();
}

#endif

#include <sstream>


std::string Interpreter::PrintString(Oop oop)
{
	std::stringstream st;
	st << reinterpret_cast<POTE>(oop);
	return st.str();
}

void DumpObject(const POTE pote)
{
	TRACESTREAM << pote << endl;
}

#ifdef _DEBUG

// A useful little method to determine if the next fifty
// stack entries are still valid - detects bugs in the 
// interpreter
void Interpreter::checkStack(Oop* sp)
{
	/*		for (unsigned i=1;i<=50;i++)
	{
	Oop objectPointer = sp[i];
	if (!ObjectMemoryIsIntegerObject(objectPointer) &&
	((reinterpret_cast<OTE*>(objectPointer)->getCount() < MAXCOUNT)
	{
	TRACESTREAM << "WARNING: sp+" << i << " contains " << objectPointer << endl;
	}
	}
		*/		if (abs(executionTrace) > 3)
		{
			ProcessOTE* oteActive = m_registers.m_oteActiveProcess;
			MWORD size = oteActive->getSize();
			m_registers.ResizeProcess();
			ObjectMemory::checkReferences();
			oteActive->setSize(size);
		}
}

void __fastcall Interpreter::debugReturnToMethod(Oop* sp)
{
	tracelock lock(TRACESTREAM);
	TRACESTREAM << endl << "** Returned to Method: " << *m_registers.m_pMethod << endl;
}

void __fastcall Interpreter::debugMethodActivated(Oop* sp)
{
	tracelock lock(TRACESTREAM);
	TRACESTREAM << endl << "** Method activated: " << m_registers.m_pActiveFrame->m_method << endl;
	if (executionTrace > 1)
	{
		decodeMethod(m_registers.m_pMethod, NULL);
		TRACESTREAM << endl;
	}

}

void __fastcall Interpreter::debugExecTrace(BYTE* ip, Oop* sp)
{
	//for (unsigned i=0;i<contextDepth;i++)
	//	TRACESTREAM << ".";

	// To avoid covering bugs, we make sure we don't update the
	// context for longer than the duration of the trace
	BYTE* oldIP = m_registers.m_instructionPointer;
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
		int ipIndex = int(ip - ObjectMemory::ByteAddressOfObjectContents(method->m_byteCodes));
		HARDASSERT(ipIndex >= 0 && ipIndex < 1024);
		//for (i=0;i<contextDepth;i++)
		//	TRACESTREAM << ".";
		TRACESTREAM << "{" << method << "} ";
		decodeMethodAt(method, unsigned(ipIndex), TRACESTREAM);

		if (false)
			decodeMethod(method);

		TRACESTREAM.flush();
	}

	HARDASSERT(!m_registers.m_pActiveProcess->IsWaiting());
	HARDASSERT(m_registers.m_pActiveProcess->Next()->isNil());

	m_registers.m_instructionPointer = oldIP;
	m_registers.m_stackPointer = oldSP;
}

extern "C" __declspec(dllexport) int __stdcall ExecutionTrace(int execTrace)
{
	int existing = Interpreter::executionTrace;
	Interpreter::executionTrace = execTrace;
	return existing;
}

const char* Interpreter::activeMethod()
{
	static string lastPrinted;
	std::stringstream stream;
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

extern "C" unsigned byteCodeCounters[];
extern "C" unsigned byteCodePairs[];

void DumpBytecodeCounts(bool bClear)
{

	TRACESTREAM << endl << "Bytecode invocation counts" << endl << "-----------------------------" << endl;
	for (int i = 0; i < 256; i++)
	{
		TRACESTREAM << dec << i << ": " << byteCodeCounters[i] << endl;
		if (bClear) byteCodeCounters[i] = 0;
	}
	TRACESTREAM << "-----------------------------" << endl << endl;

	TRACESTREAM << endl << "Bytecode pair counts" << endl << "-----------------------------" << endl;
	for (int i = 0; i < 256; i++)
	{
		for (int j = 0; j < 256; j++)
		{
			TRACESTREAM << byteCodePairs[i * 256 + j] << ' ';
			if (bClear) byteCodePairs[i * 256 + j] = 0;
		}
		TRACESTREAM << endl;
	}
	TRACESTREAM << "-----------------------------" << endl << endl;

}

extern "C" unsigned primitiveCounters[];

void DumpPrimitiveCounts(bool bClear)
{
	TRACESTREAM << endl << "Primitive invocation counts" << endl << "-----------------------------" << endl;
	for (int i = 0; i <= PRIMITIVE_MAX; i++)
	{
		TRACESTREAM << dec << i << ": " << primitiveCounters[i] << endl;
		if (bClear) primitiveCounters[i] = 0;
	}

	TRACESTREAM << "-----------------------------" << endl << endl;
}
#endif	// defined(_DEBUG)
