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

tracestream thinDump;

class UnknownOTE : public OTE {};

typedef TOTE<VariantCharObject> VariantCharOTE;

// Helper to dump characters to the tracestream
// Unprintable characters are printed in hex
ostream& operator<<(ostream& stream, const VariantCharOTE* oteChars)
{
//    stream.lock();

	ASSERT(oteChars->isBytes());

	unsigned len=oteChars->bytesSize();
	VariantCharObject* string = oteChars->m_location;
	unsigned end = min(len, 80);
	for(unsigned i=0; i<end; i++)
	{
		unsigned char ch = (unsigned char) string->m_characters[i];
		//if (ch = '\0') break;
		if (ch < 32 || ch > 127)
		{
			static char hexChars[16+1] = "0123456789ABCDEF";
			stream << '\\' << hexChars[ch >> 4] << hexChars[ch & 0xF] << '\\';
		}
		else
			stream << ch;
	}

	if (len > end)
		stream << "...";
	
//	stream.unlock();

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
		st << "'" << reinterpret_cast<const VariantCharOTE*>(ote) << "'";
	}
	return st;
}

//inline ostream& operator<<(ostream& st, const Symbol& symbol)
//{
//	return st << '#' << (const VariantCharObject&)symbol;
//}

inline ostream& operator<<(ostream& stream, const Class& cl)
{
	return stream << cl.m_name;
}


ostream& operator<<(ostream& stream, const ClassOTE* ote)
{
	if (ote->isNil()) return stream << "nil";

	if (!(ObjectMemory::isBehavior(Oop(ote) && !ObjectMemory::isAMetaclass(reinterpret_cast<const OTE*>(ote)))))
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
		return stream << "**Non-symbol: " << reinterpret_cast<const OTE*>(ote) <<"**";
	else
		// Dump without a # prefix
		return stream << reinterpret_cast<const VariantCharOTE*>(ote);
}

ostream& operator<<(ostream& stream, const BehaviorOTE* ote)
{
	if (ote->isNil()) return stream << "nil";

	if (!ObjectMemory::isBehavior(Oop(ote)))
		// Expected a class Oop, but got something else
		return stream << "**Non-behaviour: " << reinterpret_cast<const OTE*>(ote) <<"**";
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
	for (int i=size-1;i>=0;i--)
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
			<< " frame: " << hex << ctx->m_frame ;
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
			for (int i=0;i<end;i++)
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
	__except(EXCEPTION_EXECUTE_HANDLER)
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
			__except(EXCEPTION_EXECUTE_HANDLER)
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
		__except(EXCEPTION_EXECUTE_HANDLER)
		{
			stream << "***Bad OTE or Object: " << LPVOID(ote) << '(' << ote->m_location << ')';
		}
	}
	
	return stream;
}

SMALLUNSIGNED Interpreter::indexOfSP(Oop* sp)
{
	return m_registers.activeProcess()->indexOfSP(sp);
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
	__except(EXCEPTION_EXECUTE_HANDLER)
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
			unsigned i=0;
			unsigned nSlots = sp - pProcess->m_stack;
			if (nSlots > nDepth)
			{
				unsigned nHalfDepth = nDepth/2;
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
			ip += isIntegerObject(method->m_byteCodes) ? 1 : -(int(ObjectByteSize)-1);

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
		
		Oop receiver = *(bp-1);
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
		unsigned i=0;
		for (i=0;i<argc;i++)
			stream << "	arg[" << dec << i << "]: " << reinterpret_cast<OTE*>(*(bp+i)) << endl;
		for (i=0;i<stackTempCount;i++)
			stream << "	stack temp[" << dec << i << "]: " << reinterpret_cast<OTE*>(*(bp+i+argc)) << endl;

		if (ctx != NULL)
		{
			const unsigned envTempCount = oteContext->pointersSize() - Context::FixedSize;
			for (i=0;i<envTempCount;i++)
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
	saveContextAfterFault(pExceptionInfo);
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
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT ACTIVE PROCESS OR CONTEXT";
	}
	
	__try
	{
		logStream << "Active Method: " << *m_registers.m_pMethod;
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT CURRENT METHOD OR CONTEXT";
	}
	
	__try
	{
		logStream << endl << "IP: ";
		DumpIP(m_registers.m_instructionPointer, m_registers.m_pMethod, logStream);
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT IP, METHOD, OR CONTEXT";
	}

	logStream << "SP: " << m_registers.m_stackPointer << endl;

	__try
	{
		logStream << "BP: ";
		DumpBP(m_registers.m_basePointer, m_registers.activeProcess(), logStream);
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT SP, PROCESS, OR CONTEXT" << endl;
	}
	
	__try
	{
		logStream << "ActiveFrame: " << m_registers.m_pActiveFrame << endl;
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT ACTIVE FRAME OR CONTEXT" << endl;
	}

	__try
	{
		logStream << "New Method: " << Interpreter::m_registers.m_oopNewMethod<< endl;
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
	{
		logStream << endl << '\t' << "***CORRUPT NEW METHOD OR CONTEXT" << endl;
	}
	
	__try
	{
		logStream << "Message Selector: " << Interpreter::m_oopMessageSelector << endl;
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
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
		::DumpStack(m_registers.m_stackPointer, m_registers.activeProcess(), logStream, nStackDepth);
	}
	__except(EXCEPTION_EXECUTE_HANDLER)
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
	}
	while (depth > 0 && returnFrame != ZeroPointer 
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
	__except(GetExceptionCode() == EXCEPTION_ACCESS_VIOLATION ? EXCEPTION_EXECUTE_HANDLER : EXCEPTION_CONTINUE_SEARCH)
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
		bRet =	selector == reinterpret_cast<SymbolOTE*>(Pointers.Nil) ||
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


void Interpreter::decodeMethod(CompiledMethod* meth, ostream* pstream)
{
	ostream& stream = pstream != NULL ? *pstream : (ostream&)TRACESTREAM;

	// Report method header
	STMethodHeader hdr = meth->m_header;
	stream << "Method "<< meth;
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
	
	BYTE* bytecodes=ObjectMemory::ByteAddressOfObjectContents(meth->m_byteCodes);
	unsigned size=ObjectMemoryIsIntegerObject(meth->m_byteCodes) ?
		sizeof(SMALLINTEGER) : reinterpret_cast<ByteArrayOTE*>(meth->m_byteCodes)->bytesSize();
	
	BYTE* b=bytecodes;
	while (b<bytecodes+size) 
	{
		int ip=b-bytecodes;
		decodeMethodAt(meth, ip, stream);
		b += lengthOfByteCode(*b);
	}
	stream << endl;
}

void Interpreter::decodeMethodAt(CompiledMethod* meth, unsigned ip, ostream& stream)
{
	BYTE* bp=(ObjectMemory::ByteAddressOfObjectContents(meth->m_byteCodes))+ip;
	Oop* literalFrame=&(meth->m_aLiterals[0]);
	
	const int opcode = bp[0];
	stream << dec << setw(5) << ip << ":	" << dec << opcode << '	';
	
	switch (opcode) 
	{
	case Break:
		stream << "Debug Break";
		break;

	case ShortPushInstVar+0:
	case ShortPushInstVar+1:
	case ShortPushInstVar+2:
	case ShortPushInstVar+3:
	case ShortPushInstVar+4:
	case ShortPushInstVar+5:
	case ShortPushInstVar+6:
	case ShortPushInstVar+7:
	case ShortPushInstVar+8:
	case ShortPushInstVar+9:
	case ShortPushInstVar+10:
	case ShortPushInstVar+11:
	case ShortPushInstVar+12:
	case ShortPushInstVar+13:
	case ShortPushInstVar+14:
	case ShortPushInstVar+15:
		stream << "Short Push InstVar[" << dec << int(opcode - ShortPushInstVar) << ']';
		break;
		
	case ShortPushTemp+0:
	case ShortPushTemp+1:
	case ShortPushTemp+2:
	case ShortPushTemp+3:
	case ShortPushTemp+4:
	case ShortPushTemp+5:
	case ShortPushTemp+6:
	case ShortPushTemp+7:
		stream << "Short Push Temp[" << dec << int(opcode - ShortPushTemp) << "]";
		break;
		
	case ShortPushConst+0:
	case ShortPushConst+1:
	case ShortPushConst+2:
	case ShortPushConst+3:
	case ShortPushConst+4:
	case ShortPushConst+5:
	case ShortPushConst+6:
	case ShortPushConst+7:
	case ShortPushConst+8:
	case ShortPushConst+9:
	case ShortPushConst+10:
	case ShortPushConst+11:
	case ShortPushConst+12:
	case ShortPushConst+13:
	case ShortPushConst+14:
	case ShortPushConst+15:
		{
			int literal = opcode - ShortPushConst;
			stream << "Short Push Const[" << literal << "]: " << reinterpret_cast<OTE*>(literalFrame[literal]);
		}
		break;
		
	case ShortPushStatic+0:
	case ShortPushStatic+1:
	case ShortPushStatic+2:
	case ShortPushStatic+3:
	case ShortPushStatic+4:
	case ShortPushStatic+5:
	case ShortPushStatic+6:
	case ShortPushStatic+7:
	case ShortPushStatic+8:
	case ShortPushStatic+9:
	case ShortPushStatic+10:
	case ShortPushStatic+11:
		{
			int literal = opcode - ShortPushStatic;
			stream << "Short Push Static[" << literal << "]: " << reinterpret_cast<OTE*>(literalFrame[literal]);
		}
		break;
		
	case ShortPushNil:
		stream << "Short Push Nil";
		break;
		
	case ShortPushTrue:
		stream << "Short Push True";
		break;
		
	case ShortPushFalse:
		stream << "Short Push False";
		break;
		
	case ShortPushSelf:
		stream << "Short Push Self";
		break;
		
	case ShortPushMinusOne:
		stream << "Short Push -1";
		break;
		
	case ShortPushZero:
		stream << "Short Push 0";
		break;
		
	case ShortPushOne:
		stream << "Short Push 1";
		break;
		
	case ShortPushTwo:
		stream << "Short Push 2";
		break;

	case ShortPushSelfAndTemp+0:
	case ShortPushSelfAndTemp+1:
	case ShortPushSelfAndTemp+2:	
	case ShortPushSelfAndTemp+3:
		stream << "Push Self and Temp[" << dec << int(opcode - ShortPushSelfAndTemp) << ']';
		break;

	case ShortStoreTemp+0:
	case ShortStoreTemp+1:
	case ShortStoreTemp+2:
	case ShortStoreTemp+3:
		stream << "Short Store Temp[" << dec << int(opcode - ShortStoreTemp) << "]";
		break;

	case ShortPopPushTemp+0:
	case ShortPopPushTemp+1:
		stream << "Pop & Push Temp[" << dec << int(opcode - ShortPopPushTemp) << "]";
		break;

	case PopPushSelf:
		stream << "Pop & Push Self";
		break;

	case PopDup:
		stream << "Pop & Dup";
		break;

	case ShortPushContextTemp+0:
	case ShortPushContextTemp+1:	
		stream << "Push Outer[0] Temp[" << dec << int(opcode - ShortPushContextTemp) << "]";
		break;

	case ShortPushOuterTemp+0:
	case ShortPushOuterTemp+1:
		stream << "Push Outer[1] Temp[" << dec << int(opcode - ShortPushOuterTemp) << "]";
		break;

	case PopStoreContextTemp+0:
	case PopStoreContextTemp+1:
		stream << "Pop Store Outer[0] Temp[" << dec << int(opcode - PopStoreContextTemp) << "]";
		break;

	case ShortPopStoreOuterTemp+0:
	case ShortPopStoreOuterTemp+1:
		stream << "Pop Store Outer[1] Temp[" << dec << int(opcode - ShortPopStoreOuterTemp) << "]";
		break;

	case ShortPopStoreInstVar+0:
	case ShortPopStoreInstVar+1:
	case ShortPopStoreInstVar+2:
	case ShortPopStoreInstVar+3:
	case ShortPopStoreInstVar+4:
	case ShortPopStoreInstVar+5:
	case ShortPopStoreInstVar+6:
	case ShortPopStoreInstVar+7:
		stream << "Short Pop Store InstVar[" << dec << int(opcode - ShortPopStoreInstVar) << "]";
		break;
		
	case  ShortPopStoreTemp+0:
	case  ShortPopStoreTemp+1:
	case  ShortPopStoreTemp+2:
	case  ShortPopStoreTemp+3:
	case  ShortPopStoreTemp+4:
	case  ShortPopStoreTemp+5:
	case  ShortPopStoreTemp+6:
	case  ShortPopStoreTemp+7:
		stream << "Short Pop Store Temp[" << dec << int(opcode - ShortPopStoreTemp) << "]";
		break;
		
	case PopStackTop:
		stream << "Pop Stack Top";
		break;
		
	case DuplicateStackTop:
		stream << "Duplicate Stack Top";
		break;
		
	case PushActiveFrame:
		stream << "Push Active Frame";
		break;
		
	case IncrementStackTop:
		stream << "Increment Stack Top";
		break;
		
	case DecrementStackTop:
		stream << "Decrement Stack Top";
		break;
		
	case ReturnNil:
		stream << "Return Nil";
		break;
		
	case ReturnTrue:
		stream << "Return True";
		break;
		
	case ReturnFalse:
		stream << "Return False";
		break;
		
	case ReturnSelf:
		stream << "Return Self";
		break;

	case PopReturnSelf:
		stream << "Pop & Return Self";
		break;

	case ReturnMessageStackTop:
		stream << "Return Message stack top";
		break;
		
	case ReturnBlockStackTop:
		stream << "Return Block stack top";
		break;

	case FarReturn:
		stream << "Far Return";
		break;

	case Nop:
		stream << "Nop";
		break;
		
	case  ShortJump+0:
	case  ShortJump+1:
	case  ShortJump+2:
	case  ShortJump+3:
	case  ShortJump+4:
	case  ShortJump+5:
	case  ShortJump+6:
	case  ShortJump+7:
		{
			BYTE offset = bp[0] - ShortJump;
			stream << "Short Jump to " << dec << int(offset + ip + 1 + 1) << " (offset " << dec << int(offset) << ")";
		}
		break;
		
	case  ShortJumpIfFalse+0:
	case  ShortJumpIfFalse+1:
	case  ShortJumpIfFalse+2:
	case  ShortJumpIfFalse+3:
	case  ShortJumpIfFalse+4:
	case  ShortJumpIfFalse+5:
	case  ShortJumpIfFalse+6:
	case  ShortJumpIfFalse+7:
		{
			BYTE offset = bp[0] - ShortJumpIfFalse;
			stream << "Short Jump to " << dec << int(offset + ip + 1 + 1) << " If False (offset " << dec << int(offset) << ")";
		}
		break;
		
	case SendArithmeticAdd:
	case SendArithmeticSub:
	case ShortSpecialSend+2:
	case ShortSpecialSend+3:
	case ShortSpecialSend+4:
	case ShortSpecialSend+5:
	case ShortSpecialSend+6:
	case ShortSpecialSend+7:
	case ShortSpecialSend+8:
	case ShortSpecialSend+9:
	case ShortSpecialSend+10:
	case ShortSpecialSend+11:
	case ShortSpecialSend+12:
	case ShortSpecialSend+13:
	case ShortSpecialSend+14:
	case ShortSpecialSend+15:
	case ShortSpecialSend+16:
	case ShortSpecialSend+17:
	case ShortSpecialSend+18:
	case ShortSpecialSend+19:
	case ShortSpecialSend+20:
	case ShortSpecialSend+21:
	case ShortSpecialSend+22:
	case ShortSpecialSend+23:
	case ShortSpecialSend+24:
	case ShortSpecialSend+25:
	case ShortSpecialSend+26:
	case ShortSpecialSend+27:
	case ShortSpecialSend+28:
	case ShortSpecialSend+29:
	case ShortSpecialSend+30:
	case ShortSpecialSend+31:
		{
			SymbolOTE*const* pSpecialSelectors = Pointers.specialSelectors;
			const SymbolOTE* stringPointer = pSpecialSelectors[opcode - ShortSpecialSend];
			_ASSERTE(ObjectMemory::isKindOf(stringPointer, Pointers.ClassString));
			stream << "Short Special Send " << stringPointer;
		}
		break;
		
		
	case ShortSendWithNoArgs+0:
	case ShortSendWithNoArgs+1:
	case ShortSendWithNoArgs+2:
	case ShortSendWithNoArgs+3:
	case ShortSendWithNoArgs+4:
	case ShortSendWithNoArgs+5:
	case ShortSendWithNoArgs+6:
	case ShortSendWithNoArgs+7:
	case ShortSendWithNoArgs+8:
	case ShortSendWithNoArgs+9:
	case ShortSendWithNoArgs+10:
	case ShortSendWithNoArgs+11:
	case ShortSendWithNoArgs+12:
		{
			int literal = opcode - ShortSendWithNoArgs;
			stream << "Short Send " << reinterpret_cast<SymbolOTE*>(literalFrame[literal]) << 
				" with no args (literal " << dec << literal << ')';
		}
		break;
		
	case ShortSendSelfWithNoArgs+0:
	case ShortSendSelfWithNoArgs+1:	
	case ShortSendSelfWithNoArgs+2:	
	case ShortSendSelfWithNoArgs+3:
	case ShortSendSelfWithNoArgs+4:
		{
			int literal = opcode - ShortSendSelfWithNoArgs;
			stream << "Short Send Self " << reinterpret_cast<OTE*>(literalFrame[literal]) << 
				" with no args (literal " << dec << literal << ')';
		}
		break;

	case ShortSendWith1Arg+0:
	case ShortSendWith1Arg+1:
	case ShortSendWith1Arg+2:
	case ShortSendWith1Arg+3:
	case ShortSendWith1Arg+4:
	case ShortSendWith1Arg+5:
	case ShortSendWith1Arg+6:
	case ShortSendWith1Arg+7:
	case ShortSendWith1Arg+8:
	case ShortSendWith1Arg+9:
	case ShortSendWith1Arg+10:
	case ShortSendWith1Arg+11:
	case ShortSendWith1Arg+12:
	case ShortSendWith1Arg+13:
		{
			int literal = opcode - ShortSendWith1Arg;
			stream << "Short Send " << reinterpret_cast<OTE*>(literalFrame[literal]) <<
				" with 1 arg (literal " << dec << literal << ')';
		}
		break;
		
	case ShortSendWith2Args+0:
	case ShortSendWith2Args+1:
	case ShortSendWith2Args+2:
	case ShortSendWith2Args+3:
	case ShortSendWith2Args+4:
	case ShortSendWith2Args+5:
	case ShortSendWith2Args+6:
	case ShortSendWith2Args+7:
		{
			int literal = opcode - ShortSendWith2Args;
			stream << "Short Send " << reinterpret_cast<OTE*>(literalFrame[literal]) <<
				" with 2 args (literal " << dec << literal << ')';
		}
		break;
		
	case SpecialSendIsZero:
		stream << "Special Send Is Zero";
		break;

	case PushInstVar:
		stream << "Push Instance Variable[" << dec << int(bp[1]) << ']';
		break;
		
	case PushTemp:
		stream << "Push Temp[" << dec << int(bp[1]) << ']';
		break;
		
	case PushOuterTemp:
		stream << "Push Outer[" << dec << int(bp[1] >> 5) <<
			"] Temp[" << dec << int(bp[1] & 0x1F) << ']';
		break;

	case PushConst:
		stream << "Push Const[" << dec << int(bp[1]) << "]: "
			<< reinterpret_cast<OTE*>(literalFrame[bp[1]]);
		break;
		
	case PushStatic:
		stream << "Push Static[" << dec << int(bp[1]) << "]: "
			<< reinterpret_cast<OTE*>(literalFrame[bp[1]]);
		break;
		
	case StoreInstVar:
		stream << "Store Instance Variable[" << dec << int(bp[1]) << ']';
		break;
		
	case StoreTemp:
		stream << "Store Temp[" << dec << int(bp[1]) << ']';
		break;
	
	case StoreOuterTemp:
		stream << "Store Outer[" << dec << int(bp[1] >> 5) <<
			"] Temp[" << dec << int(bp[1] & 0x1F) << ']';
		break;

	case StoreStatic:
		stream << "Store Static[" << dec << int(bp[1]) << "]: " << reinterpret_cast<OTE*>(literalFrame[bp[1]]);
		break;
		
	case PopStoreInstVar:
		stream << "Pop And Store Instance Variable[" << dec << int(bp[1]) << ']';
		break;
		
	case PopStoreTemp:
		stream << "Pop And Store Temp[" << dec << int(bp[1]) << ']';
		break;

	case PopStoreOuterTemp:
		stream << "Pop And Store Outer[" << dec << int(bp[1] >> 5) <<
			"] Temp[" << dec << int(bp[1] & 0x1F) << ']';
		break;

	case PopStoreStatic:
		stream << "Pop and Store Static[" << dec << int(bp[1]) << "]: " << reinterpret_cast<OTE*>(literalFrame[bp[1]]);
		break;
		
	case PushImmediate:
		stream << "Push Immediate " << dec << int(SBYTE(bp[1]));
		break;
		
	case PushChar:
		stream << "Push Char $" << char('\0'+bp[1]);
		break;
		
	case Send:
		stream << "Send " << reinterpret_cast<OTE*>(literalFrame[bp[1] & SendXMaxLiteral]) <<
			" (literal " << dec << int(bp[1] & SendXMaxLiteral) << "), with " << 
			int(bp[1] >> SendXLiteralBits) << " args";
		break;
		
	case Supersend:
		stream << "Supersend " << reinterpret_cast<OTE*>(literalFrame[bp[1] & SendXMaxLiteral]) <<
			" (literal " << dec << int(bp[1] & SendXMaxLiteral) << "), with " << 
			int(bp[1] >> SendXLiteralBits) << " args";
		break;
		
	case NearJump:
		{
			int extension = int(SBYTE(bp[1]));
			stream << "Near Jump to " << dec << (extension + 2 + ip);
		}
		break;
		
	case NearJumpIfTrue:
		{
			int extension = int(bp[1]);
			stream << "Near Jump If True to " << dec << (extension + 2 + ip);
		}
		break;
		
	case NearJumpIfFalse:
		{
			int extension = int(bp[1]);
			stream << "Near Jump If False to " << dec << (extension + 2 + ip);
		}
		break;

	case NearJumpIfNil:
		{
			int extension = int(bp[1]);
			stream << "Near Jump If Nil to " << dec << (extension + 2 + ip);
		}
		break;

	case NearJumpIfNotNil:
		{
			int extension = int(bp[1]);
			stream << "Near Jump If Not Nil to " << dec << (extension + 2 + ip);
		}
		break;

	case SendTempWithNoArgs:
		{
			int extension = int(bp[1]);
			int literal = extension & SendXMaxLiteral;
			int temp = extension >> SendXLiteralBits;
			stream << "Send Temp [" << temp << "] " << reinterpret_cast<OTE*>(literalFrame[literal]) << 
				" with no args (literal " << dec << literal << ')';
		}
		break;

	case PushSelfAndTemp:
		{
			int extension = int(bp[1]);
			stream << "Push Self; Push Temp[" << dec << extension << ']';
		}
		break;

	case SendSelfWithNoArgs:
		{
			int literal = int(bp[1]);
			stream << "Send Self " << reinterpret_cast<OTE*>(literalFrame[literal]) << 
				" with no args (literal " << dec << literal << ')';
		}
		break;

	case PushTempPair:
		{
			int n = bp[1] >> 4;
			int m = bp[1] & 0xF;
			stream << dec << "Push Temp[" << n << "] & Temp [" << m << "]";
		}
		break;

	// Three bytes from here on ...
	case LongPushConst:
		{
			WORD index = *reinterpret_cast<WORD*>(bp+1);
			stream << " Long Push Const[" << dec << index << "]: " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongPushStatic:
		{
			WORD index = *reinterpret_cast<WORD*>(bp+1);
			stream << " Long Push Static[" << dec << index << "]: " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongStoreStatic:
		{
			WORD index = *reinterpret_cast<WORD*>(bp+1);
			stream << "Long Store Static[" << dec << index << "]: " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongPushImmediate:
		{
			int extension = static_cast<int>(*reinterpret_cast<SWORD*>(&bp[1]));
			stream << "Long Push Immediate " << dec << extension;
		}
		break;
		
	case LongSend:
		stream << "Long Send[" << dec << int(bp[2]) << "], " << dec << int(bp[1]) << " args = "
			<< reinterpret_cast<OTE*>(literalFrame[bp[2]]);
		break;
		
	case LongSupersend:
		stream << "Long Supersend[" << dec << int(bp[2]) << "], " << dec << int(bp[1]) << " args = "
			<< reinterpret_cast<OTE*>(literalFrame[bp[2]]);
		break;
		
		
	case LongJump:
		{
			int extension = static_cast<int>(*reinterpret_cast<SWORD*>(&bp[1]));
			stream << "Long Jump to " << dec << ip + 3 + extension;
		}
		break;
		
	case LongJumpIfTrue:
		{
			int extension = static_cast<int>(*reinterpret_cast<SWORD*>(&bp[1]));
			stream << "Long Jump If True to " << dec << ip + 3 + extension;
		}
		break;
		
	case LongJumpIfFalse:
		{
			int extension = static_cast<int>(*reinterpret_cast<SWORD*>(&bp[1]));
			stream << "Long Jump If False to " << dec << ip + 3 + extension;
		}
		break;

	case LongPushOuterTemp:
		stream << "Long Push Outer[" << dec << int(bp[1]) <<
			"] Temp[" << dec << int(bp[2]) << ']';
		break;

	case LongStoreOuterTemp:
		stream << "Long Store Outer[" << dec << int(bp[1]) <<
			"] Temp[" << dec << int(bp[2]) << ']';
		break;

	case IncrementTemp:
		stream << "Inc Temp[" << dec << int(bp[2]) << ']';
		break;

	case IncrementPushTemp:
		stream << "Inc & Push Temp[" << dec << int(bp[2]) << ']';
		break;

	case DecrementTemp:
		stream << "Dec Temp[" << dec << int(bp[2]) << ']';
		break;

	case DecrementPushTemp:
		stream << "Dec & Push Temp[" << dec << int(bp[2]) << ']';
		break;

	case BlockCopy:
		{
			int nArgs = bp[1];
			stream << "Block Copy, ";
			if (nArgs > 0)
				stream << nArgs << " args, ";
			int nStackTemps = bp[2];
			if (nStackTemps > 0)
				stream << nStackTemps << " stack temps, ";
			int nEnvTemps = bp[3] >> 1;
			int nCopied = bp[4] >> 1;
			if (nEnvTemps > 0)
				stream << nEnvTemps << " env temps, ";
			if (nCopied > 0)
				stream << nCopied << " copied values, ";
			if (bp[4] & 1)
				stream << "needs self, ";
			if (bp[3] & 1)
				stream << "needs outer, ";
			stream << "length: " << *reinterpret_cast<WORD*>(bp+5);
		}
		break;
		
	default:
		stream << "UNHANDLED BYTE CODE " << opcode << "!!!";
		break;
	}
	stream << endl;
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
	#if 0
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM << "* Returned to Method: " << *m_registers.m_pMethod << endl;
		CHECKREFERENCES
	}
	#endif
}

void __fastcall Interpreter::debugMethodActivated(Oop* sp)
{
	tracelock lock(TRACESTREAM);
	TRACESTREAM << endl << "** Method activated: " << m_registers.m_pActiveFrame->m_method << endl;
	if (executionTrace > 1)
	{
		decodeMethod(m_registers.m_pMethod, NULL);
		TRACESTREAM << endl << endl;
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
	for (int i=0;i<256;i++)
	{
		TRACESTREAM << dec << i << ": " << byteCodeCounters[i] << endl;
		if (bClear) byteCodeCounters[i] = 0;
	}
	TRACESTREAM << "-----------------------------" << endl << endl;

	TRACESTREAM << endl << "Bytecode pair counts" << endl << "-----------------------------" << endl;
	for (int i=0;i<256;i++)
	{
		for (int j=0;j<256;j++)
		{
			TRACESTREAM << byteCodePairs[i*256+j] << ' ';
			if (bClear) byteCodePairs[i*256+j] = 0;
		}
		TRACESTREAM << endl;
	}
	TRACESTREAM << "-----------------------------" << endl << endl;

}

extern "C" unsigned primitiveCounters[];

void DumpPrimitiveCounts(bool bClear)
{
	TRACESTREAM << endl << "Primitive invocation counts" << endl << "-----------------------------" << endl;
	for (int i=0;i<=PRIMITIVE_MAX;i++)
	{
		TRACESTREAM << dec << i << ": " << primitiveCounters[i] << endl;
		if (bClear) primitiveCounters[i] = 0;
	}

	TRACESTREAM << "-----------------------------" << endl << endl;
}
#endif	// defined(_DEBUG)
