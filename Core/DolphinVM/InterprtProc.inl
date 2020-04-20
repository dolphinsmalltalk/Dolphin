/******************************************************************************

	File: InterprtProc.Inl

	Description:

	Inlines for the process related interpreter bodules (e.g. saving/restoring
	process context, that sort of thing).

	All these are private.

******************************************************************************/

// Smalltalk classes
#include "STProcess.h"
#include "STMethod.h"
#include "STExternal.h"

inline StackFrame* Interpreter::activeFrame()
{
	return m_registers.m_pActiveFrame;
}

inline ProcessOTE* Interpreter::activeProcessPointer()
{
	return newProcessWaiting() ? m_oteNewProcess : scheduler()->m_activeProcess;
}

// Returns the active/new process
inline Process* Interpreter::activeProcess()
{
	Process* activeProc = activeProcessPointer()->m_location;
	_ASSERTE(activeProc->IsValid());
	return activeProc;
}

// Always returns the active process, even if a new process is waiting
inline Process* Interpreter::actualActiveProcess()
{
	return m_registers.m_pActiveProcess;
}

// Always returns the active process, even if a new process is waiting
inline ProcessOTE* Interpreter::actualActiveProcessPointer()
{
	return m_registers.m_oteActiveProcess;
}

inline SchedulerOTE* Interpreter::schedulerPointer()
{
	return Pointers.Scheduler;
}

inline ProcessorScheduler* Interpreter::scheduler()
{
	return m_pProcessor;
}

inline BOOL Interpreter::newProcessWaiting()
{
	return !isNil(m_oteNewProcess);
}

///////////////////////////////////////////////////////////////////////////////
inline void InterpreterRegisters::StoreSuspendedFrame()
{
	ResizeProcess();
	m_pActiveProcess->SetSuspendedFrame(activeFrameOop());
}

inline void InterpreterRegisters::StoreIPInFrame()
{
	// Are we storing down IP into correct frame, if not registers are corrupt
	ASSERT(m_pMethod == m_pActiveFrame->m_method->m_location);

	// Convert address to an offset
	ptrdiff_t offsetFromBeginningOfByteCodesObject = m_instructionPointer - ObjectMemory::ByteAddressOfObject(m_pMethod->m_byteCodes);
	m_pActiveFrame->setInstructionPointer(offsetFromBeginningOfByteCodesObject);
}

inline void InterpreterRegisters::LoadIPFromFrame()
{
	SmallInteger offsetFromBeginningOfByteCodesObject = ObjectMemoryIntegerValueOf(m_pActiveFrame->m_ip);
	//ASSERT(offsetFromBeginningOfByteCodesObject >= 0 && offsetFromBeginningOfByteCodesObject < 1024);
	m_instructionPointer = ObjectMemory::ByteAddressOfObject(m_pMethod->m_byteCodes) + offsetFromBeginningOfByteCodesObject;
}


inline void InterpreterRegisters::StoreSPInFrame()
{
	// Mask SP odd and store as SmallInteger
	m_pActiveFrame->setStackPointer(m_stackPointer);
}

inline void InterpreterRegisters::LoadSPFromFrame()
{
	// stackPointer is pointer to the top item on the stack (stack pointer increases
	// as items are pushed on the stack).The stackPointer is incremented BEFORE 
	// a new item is pushed, and is a pointer directly into the current
	// active process. It is stored down into contexts by setting the SmallInteger
	// (odd) bit, as it will always be even (divisible by 4 actually)
	m_stackPointer = m_pActiveFrame->stackPointer();
}

inline void InterpreterRegisters::StoreContextRegisters()
{
	m_pActiveProcess->SaveFP();
	StoreIPInFrame();
	StoreSPInFrame();
}

inline void InterpreterRegisters::PrepareToSuspendProcess()
{
	StoreSuspendedFrame();
	StoreContextRegisters();
}

inline BOOL Interpreter::SetWakeupEvent()
{
	return ::SetEvent(Pointers.WakeupEvent->m_location->m_handle);
}
