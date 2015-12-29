/******************************************************************************

	File: InterpRegisters.h

	Description:

	Specification of the Smalltalk Interpreter Registers

******************************************************************************/

#ifndef _IST_INTERPREGISTERS_H_
#define _IST_INTERPREGISTERS_H_


// Forward references
class Process;
class CompiledMethod;
struct StackFrame;

#include "STString.h"
#include "STMethod.h"

class Process;
typedef TOTE<Process> ProcessOTE;

// N.B. Must be kept in sync with istasm.inc
struct InterpreterRegisters
{
	Process*		m_pActiveProcess;
	CompiledMethod* m_pMethod;
	BYTE*			m_instructionPointer;
	StackFrame*		m_pActiveFrame;
	Oop*			m_stackPointer;
	Oop*			m_basePointer;

	// These are the only Oops the VM refererences without ref. counting them (for performance)
	MethodOTE*		m_oopNewMethod;
	ProcessOTE*		m_oteActiveProcess;

public:
	Process* activeProcess()		{ return m_pActiveProcess; }
	Oop activeFrameOop()			{ return Oop(m_pActiveFrame)+1; }
	StackFrame& activeFrame()		{ return *m_pActiveFrame; }

	void StoreIPInFrame();			// Save down IP to active frame
	void LoadIPFromFrame();			// Load IP from active frame

	void StoreSPInFrame();			// Save down SP to active  frame
	void LoadSPFromFrame();			// Load SP from active frame

	void NewActiveProcess(ProcessOTE* newProcess);

	void FetchContextRegisters();	// Load current IP/SP from active frame
	void StoreContextRegisters();	// Save down current IP/SP to active frame
	void StoreSuspendedFrame();		// Save active frame back to process as top frame
	void LoadSuspendedFrame();		// Restore process suspended frame as active frame
	void PrepareToSuspendProcess();	// Resize proc, update suspended frame, and store context to that frame
	void PrepareToResumeProcess();	// Resize proc, update suspended frame, and store context to that frame
	void ResizeProcess();

	void IncStackRefs();
	void DecStackRefs();
};

typedef __declspec(align(16)) struct InterpreterRegisters InterpreterRegisters16;
#endif	//EOF