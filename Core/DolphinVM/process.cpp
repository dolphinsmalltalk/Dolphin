/******************************************************************************

	File: Process.cpp

	Description:

	Implementation of the Interpreter class' Process/Semaphore related methods

******************************************************************************/
#include "Ist.h"

#pragma code_seg(PROCESS_SEG)

#include "rc_vm.h"

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtProc.inl"
#include "thrdcall.h"

// Smalltalk classes
#include "STProcess.h"
#include "STArray.h"

#ifdef _DEBUG
#include "STBehavior.h"

#define NameOf(x) #x
const char* Interpreter::InterruptNames[] = {
	NULL,
	NameOf(Terminate),
	NameOf(StackOverflow),
	NameOf(Breakpoint),
	NameOf(SingleStep),
	NameOf(AccessViolation),
	NameOf(IdlePanic),
	NameOf(Generic),
	NameOf(Started),
	NameOf(Kill),
	NameOf(FpFault),
	NameOf(UserInterrupt),
	NameOf(ZeroDivide),
	NameOf(OtOverflow),
	NameOf(ConstWrite),
	NameOf(Exception),
	NameOf(FpStack),
	NameOf(NoMemory),
	NameOf(HospiceCrisis),
	NameOf(BereavedCrisis),
	NameOf(CrtFault)
};
#undef NameOf

#endif

OopQueue<SemaphoreOTE*> Interpreter::m_qAsyncSignals;
OopQueue<Oop> Interpreter::m_qInterrupts;
CRITICAL_SECTION Interpreter::m_csAsyncProtect;

/******************************************************************************

	Switching Contexts

	N.B. BYTEASM.ASM also contains context switching code in the routines
	for activating new methods, and for returning from contexts. These
	must be kept in sync. The reason for the duplication is performance.
	These routines are used by the process switching code (which happens
	relatively infrequently, and therefore performance is less important)
	and by the image loading/saving code.

******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// Process/Semaphore Primitives and Helpers
///////////////////////////////////////////////////////////////////////////////

inline bool ST::Process::IsReady() const
{
	return !isNil(m_myList) && !ObjectMemory::isKindOf(m_myList, Pointers.ClassSemaphore);
}

inline void ST::Process::BasicClearNext()
{
	m_nextLink = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
}

inline void ST::Process::ClearSuspendedFrame()
{
	HARDASSERT(isIntegerObject(m_suspendedFrame) || m_suspendedFrame == (Oop)Pointers.Nil);
	m_suspendedFrame = reinterpret_cast<Oop>(Pointers.Nil);
}

void InterpreterRegisters::FetchContextRegisters()
{
	HARDASSERT(!m_pActiveProcess->IsWaiting());

	// Set up the correct floating point exception mask
	m_pActiveProcess->RestoreFP();

	// We cache a pointer to the method to speed up accesses to arg count, bytes, etc
	m_pMethod = m_pActiveFrame->m_method->m_location;
	LoadIPFromFrame();
	m_basePointer = m_pActiveFrame->basePointer();
	LoadSPFromFrame();
}

void InterpreterRegisters::LoadSuspendedFrame()
{
	Oop suspFrame = m_pActiveProcess->SuspendedFrame();
	StackFrame* pNewFrame = StackFrame::FromFrameOop(suspFrame);
	HARDASSERT(pNewFrame != m_pActiveFrame);
	m_pActiveFrame = pNewFrame;
}

inline void InterpreterRegisters::PrepareToResumeProcess()
{
	// First reload the suspended frame
	LoadSuspendedFrame();
	// and load interpreter registers
	FetchContextRegisters();
}

inline void InterpreterRegisters::NewActiveProcess(ProcessOTE* newProcess)
{
	HARDASSERT(!newProcess->m_location->IsWaiting());

	// Save down suspend frame into 
	PrepareToSuspendProcess();

	// Empties Zct and counts up refs from active process stack in preparation for
	// it being suspended
	ObjectMemory::EmptyZct(m_stackPointer);

	m_oteActiveProcess = newProcess;
	m_pActiveProcess = newProcess->m_location;
	PrepareToResumeProcess();

	// Count down refs from new process' stack
	ObjectMemory::PopulateZct(m_stackPointer);
}

void __fastcall Interpreter::resizeActiveProcess()
{
#ifdef _DEBUG
	// In debug build, this might get called before the interpreter registers have been initialized
	// if a reference count error is detected when loading the image
	if (m_registers.m_pActiveProcess != NULL)
#endif
		m_registers.ResizeProcess();
}

// This method is invoked when Smalltalk is first started up, and finds the
// initial stack frame from that suspended in the previously active process
StackFrame* Interpreter::firstFrame()
{
	m_oteNewProcess = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
	ProcessOTE* otePreSnapshotProc = scheduler()->m_activeProcess;

	m_registers.m_oteActiveProcess = otePreSnapshotProc;
	m_registers.m_pActiveProcess = otePreSnapshotProc->m_location;

	Oop suspFrame = actualActiveProcess()->SuspendedFrame();
	HARDASSERT(suspFrame != Oop(Pointers.Nil));
	return StackFrame::FromFrameOop(suspFrame);
}

///////////////////////////////////////////////////////////////////////////////
// Asynchronous queuing of Semaphore signals, interrupts, and overlapped
// call completions. These are thread safe
///////////////////////////////////////////////////////////////////////////////

bool __fastcall Interpreter::disableInterrupts(bool bDisable)
{
	HARDASSERT(GetCurrentThreadId() == MainThreadId());

	// Note that the interrupts flag is only every accessed by the main interpreter thread,
	// and hence there is no need for interlocked operations here
	bool bWasDisabled = m_bInterruptsDisabled;
	if (bWasDisabled != bDisable)
	{
		m_bInterruptsDisabled = bDisable;
		if (bDisable)
		{
			// While interrupts are disabled we must not set the normal async. pending
			// flag, but must instead buffer attempts to set it so that we can process
			// the events when interrupts are re-enabled. We achieve this by using
			// indirection and two flags, one for use when interrupts are disabled, and
			// the normal flag. Only the normal flag is ever tested by the interpreter,
			// but the normal flag, or the buffer flag, may be set depending on whether
			// interrupts are on or off.

			// First switch over to the buffer
			InterlockedExchangePointer((PVOID*)(&m_pbAsyncPending), (PVOID)(&m_bAsyncPendingIOff));

			// We must clear the async. pending flag, but if currently set we save that
			if (InterlockedExchange(&m_bAsyncPending, FALSE))
				InterlockedExchange(&m_bAsyncPendingIOff, TRUE);

			// At this point the buffer should have the same value as the async. pending flag
			// (unless the latter was false, and some thread has notified of pending async
			// events since the buffer was switched in). Anyone thread NotifyAsyncPending() will 
			// set the value of the buffer, not the async pending flag
		}
		else
		{
			// If interrupts are re-enabled, then we need to be sure we pick up any
			// async events that were queue'd when the interrupts were off
			ASSERT(m_pbAsyncPending == &m_bAsyncPendingIOff);

			// First switch back to using the normal flag...
			InterlockedExchangePointer((PVOID*)&m_pbAsyncPending, (PVOID)(&m_bAsyncPending));
			// ... but if the async. events occurred while interrupts were disabled, make sure these are noticed
			if (InterlockedExchange(&m_bAsyncPendingIOff, FALSE))
				InterlockedExchange(&m_bAsyncPending, TRUE);
		}
	}
	return bWasDisabled;
}

Oop* PRIMCALL Interpreter::primitiveEnableInterrupts(Oop* const sp, primargcount_t argCount)
{
	Oop arg = *sp;
	if (arg == (Oop)Pointers.True)
	{
		bool wasDisabled = disableInterrupts(false);
		*(sp - 1) = reinterpret_cast<Oop>(wasDisabled ? Pointers.False : Pointers.True);
		return sp - 1;
	}
	else if (arg == (Oop)Pointers.False)
	{
		bool wasDisabled = disableInterrupts(true);
		*(sp - 1) = reinterpret_cast<Oop>(wasDisabled ? Pointers.False : Pointers.True);
		return sp - 1;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

///////////////////////////////////////////////////////////////////////////////
// Answer a new Semaphore, with the specified number of initial signals

SemaphoreOTE* Semaphore::New(SmallInteger sigs)
{
	SemaphoreOTE* oteSem = reinterpret_cast<SemaphoreOTE*>(ObjectMemory::newPointerObject(Pointers.ClassSemaphore));
	Semaphore* sem = oteSem->m_location;
	sem->m_excessSignals = ObjectMemoryIntegerObjectOf(sigs);
	return oteSem;
}

///////////////////////////////////////////////////////////////////////////////
// Signal a Semaphore without regard to the execution state. The Semaphore will be properly
// signalled at the earliest possible opportunity
// This version must only be used from inside the critical section
void Interpreter::asynchronousSignalNoProtect(SemaphoreOTE* aSemaphore)
{
	NotifyAsyncPending();
	m_qAsyncSignals.Push(aSemaphore);
}

///////////////////////////////////////////////////////////////////////////////
// Safely signal a Semaphore without regard to the execution state. The Semaphore will be properly
// signalled at the earliest possible opportunity
// May want to export an entry point to this for use from external DLLs?
void Interpreter::asynchronousSignal(SemaphoreOTE* aSemaphore)
{
	// If we've multiple threads (e.g. timer thread), need to serialize access to the async. signals data structure
	GrabAsyncProtect();
	asynchronousSignalNoProtect(aSemaphore);
	RelinquishAsyncProtect();
}

///////////////////////////////////////////////////////////////////////////////
// Safely post an interrupt without regard to the execution state. The interrupt will be dispatched
// to the appropriate process at the earliest opportunity
void Interpreter::queueInterrupt(ProcessOTE* interruptedProcess, VMInterrupts nInterrupt, Oop argPointer)
{
	GrabAsyncProtect();
	NotifyAsyncPending();
	m_qInterrupts.Push(static_cast<SmallInteger>(nInterrupt));
	m_qInterrupts.Push(Oop(interruptedProcess));
	m_qInterrupts.Push(argPointer);
	RelinquishAsyncProtect();
}

///////////////////////////////////////////////////////////////////////////////
// Queue an interrupt for the current active process
void Interpreter::queueInterrupt(VMInterrupts nInterrupt, Oop argPointer)
{
	queueInterrupt(actualActiveProcessPointer(), nInterrupt, argPointer);
}

Oop* Interpreter::primitiveQueueInterrupt(Oop* const sp, primargcount_t)
{
	// Queue an aysnchronous interrupt to the receiving process
	ProcessOTE* oteReceiver = reinterpret_cast<ProcessOTE*>(*(sp - 2));
	Oop arg = *(sp - 1); // ecx

	if (ObjectMemoryIsIntegerObject(arg))
	{
		VMInterrupts interrupt = static_cast<VMInterrupts>(arg);

		Process* targetProcess = oteReceiver->m_location;
		if (targetProcess->m_suspendedFrame != reinterpret_cast<Oop>(Pointers.Nil))
		{
			queueInterrupt(oteReceiver, interrupt, *sp);
			return sp - 2;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::IllegalStateChange);
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}

///////////////////////////////////////////////////////////////////////////////
// Helpers for manipulating linked lists of processes
///////////////////////////////////////////////////////////////////////////////

inline ProcessOTE* Interpreter::resumeFirst(LinkedList* list)
{
	// There are processes waiting on the semaphore - wake the first
	ProcessOTE* sleepingProcess = reinterpret_cast<ProcessOTE*>(list->removeFirst());

	// May not actually resume it if the process has been terminated
	// or not correctly initialized
	ProcessOTE* oteResumed = resume(sleepingProcess);

	// Remove the extra ref. left when process removed from list which
	// may have prevented it from being garbage collected
	sleepingProcess->countDown();

	return oteResumed;
}

ProcessOTE* Interpreter::resumeFirst(Semaphore* sem)
{
	HARDASSERT(sem->m_excessSignals == ZeroPointer);
	ProcessOTE* oteProc = resumeFirst(static_cast<LinkedList*>(sem));
	if (oteProc)
	{
		// We've successfully acquired the Sempahore, so we may
		// need to set up the Semaphore>>wait return value correctly.

		Process* proc = oteProc->m_location;
		Oop suspFrame = proc->SuspendedFrame();
		if (!ObjectMemoryIsIntegerObject(suspFrame))
		{
			TRACESTREAM<< L"WARNING: Corrupt process resumed "<< L"(non-integer suspended frame)" << std::endl;
			return NULL;
		}

		StackFrame* pTopFrame = StackFrame::FromFrameOop(suspFrame);
		if (pTopFrame->m_sp == ZeroPointer)
		{
			TRACESTREAM<< L"WARNING: Corrupt process resumed "<< L"(null stack pointer)" << std::endl;
			return NULL;
		}

		// The VM itself may suspend processes on Semaphores occasssionally, 
		// in which case we don't need to set up the Semaphore>>wait return
		// value.
		CompiledMethod* method = pTopFrame->m_method->m_location;
		// HACK: Not happy with this test, which has to catch the cases of where
		// the wait value output parameter needs to be updated. Maybe there is a better
		// way of doing this that doesn't use the output parameter.
		if (method->m_methodClass == Pointers.ClassSemaphore)
		{
			Oop* const sp = pTopFrame->stackPointer();
			// Value is returned via a value holder at stack top
			OTE* oteRetValHolder = reinterpret_cast<OTE*>(*sp);
			if (ObjectMemoryIsIntegerObject(oteRetValHolder) || oteRetValHolder->isBytes() ||
				oteRetValHolder->getWordSize() == ObjectHeaderSize)
			{
				TRACESTREAM<< L"WARNING: Corrupt process resumed "<< L"(invalid Semaphore>>wait return value holder)" << std::endl;
				return NULL;
			}

			VariantObject* retValHolder = static_cast<VariantObject*>(oteRetValHolder->m_location);
			ObjectMemory::countDown(retValHolder->m_fields[0]);
			retValHolder->m_fields[0] = ObjectMemoryIntegerObjectOf(WAIT_OBJECT_0);
		}
	}

	return oteProc;
}

// Synchronously signal a Semaphore. May initiate a context switch if wakes a higher priority process
// AND there are no interrupts pending for the current process
void Interpreter::signalSemaphore(SemaphoreOTE* aSemaphore)
{
	// Signalling a semaphore ALWAYS re-enables interrupts
	disableInterrupts(false);

	if (!ObjectMemoryIsIntegerObject(aSemaphore))
	{

		HARDASSERT(aSemaphore->m_oteClass == Pointers.ClassSemaphore);
		Semaphore* sem = aSemaphore->m_location;

		HARDASSERT(ObjectMemoryIsIntegerObject(sem->m_excessSignals));

		if (sem->isEmpty())
		{
			// There are no processes waiting on the semaphore - record the excess signal
			SmallInteger excessSignals = ObjectMemoryIntegerValueOf(sem->m_excessSignals) + 1;
#if defined(_DEBUG)
			{
				if ((excessSignals % 1000) == 0)
					DebugDump(L"signalSemaphore: Very large excess signal count %d", excessSignals);
			}
#endif


			sem->m_excessSignals = ObjectMemoryIntegerObjectOf(excessSignals);
		}
		else
		{
			resumeFirst(sem);
		}
	}
}

void Interpreter::Yield()
{
	HARDASSERT(!m_bInterruptsDisabled);

	// Sleep will place active process on a list, increasing the ref. count
	ProcessOTE* active = activeProcessPointer();
	sleep(active);
	// Schedule may remove active process from a list again, but does not reduce the ref. count
	if (schedule() == active)
		active->countDown();
	CheckProcessSwitch();
}

// Yield to the Processes of the same or higher priority than the current active process
// Answers whether a process switch occurred
Oop* PRIMCALL Interpreter::primitiveYield(Oop* const, primargcount_t)
{
	Yield();
	return m_registers.m_stackPointer;
}

// N.B. Ref. count of returned Object is one too high to prevent
// deallocation in case the scheduler list is the only reference
// This reference should be removed when appropriate
ProcessOTE* Interpreter::wakeHighestPriority()
{
	ProcessorScheduler* scheduler = (ProcessorScheduler*)Pointers.Scheduler->m_location;
	ArrayOTE* oteLists = scheduler->m_processLists;
	HARDASSERT(oteLists->m_oteClass == Pointers.ClassArray);
	size_t highestPriority = oteLists->pointersSize();
	Array* processLists = oteLists->m_location;
	size_t index = highestPriority;
	LinkedList* pProcessList;
	do
	{
		if (!index)
		{
			// We found no processes on any of the Processors ready lists.
			// This is a panic situation, since the VM invariants required that there
			// is always a process ready to run (if not then what should be do), we
			// therefore fire off an interrupt to the last active process, which will
			// interrupt its snooze and hopefully cause some action up in the image which
			// will give us some work to do. This does mean that the code for sending
			// interrupts must cater for the possibility that even the active process
			// may actually be in a wait state when an interrupt is sent to it!
			trace(L"WARNING: No processes are Ready to run\n");
			queueInterrupt(VMInterrupts::IdlePanic, Oop(m_bInterruptsDisabled ? Pointers.False : Pointers.True));
			return scheduler->m_activeProcess;
		}
		OTE* oteList = reinterpret_cast<OTE*>(processLists->m_elements[--index]);
		pProcessList = static_cast<LinkedList*>(oteList->m_location);
	} while (pProcessList->isEmpty());
	return reinterpret_cast<ProcessOTE*>(pProcessList->removeFirst());
}


// Wake the highest priority process, and initiate a process switch (which will
// actually happen when CheckProcessSwitch() is subsequently called)
// Answers the most hungry process
ProcessOTE* Interpreter::schedule()
{
	HARDASSERT(!newProcessWaiting());
	// Old newProcess value about to be deref'd

	// Return from wakeHighestPriority() has elevated ref. count, to prevent
	// process being deleted prematurely so don't need to ref. count assignment 
	// to newProcess
	ProcessOTE* mostHungry = wakeHighestPriority();

	// We compare against the ACTUAL active process
	ProcessOTE* active = actualActiveProcessPointer();
	if (mostHungry != active)
	{
		m_oteNewProcess = mostHungry;
		HARDASSERT(!isNil(m_oteNewProcess) && !m_oteNewProcess->isFree());
		HARDASSERT(ObjectMemory::fetchClassOf(Oop(m_oteNewProcess)) == Pointers.ClassProcess);
	}
	else
	{
		// Active process not changing
		// MAY need to remove extra ref. to the current active process
		// BUT not here because may not (up to caller to decide)

		// We cannot assert either of these two things, because in fact the
		// active process may have been put to sleep on a Semaphore, and yet
		// there are no other processes available to run (i.e. the idle panic 
		// situation), in which case wakeHighestPriority() will have queued
		// an interrupt, and answered the existing active process
		HARDASSERT(!actualActiveProcess()->IsWaiting());
		HARDASSERT(isNil(actualActiveProcess()->Next()));
	}
	return mostHungry;
}


// Synchronously interrupt the current active process
void __fastcall Interpreter::sendVMInterrupt(VMInterrupts nInterrupt, Oop argPointer)
{
	sendVMInterrupt(actualActiveProcessPointer(), nInterrupt, argPointer);
}

// Synchronously send interrupt to a process (in the context of the current active process, which
// is not necessarily processPointer). The correct way to send an interrupt is to use asynchronousInterrupt()
// which the VM will send as soon as possible
void Interpreter::sendVMInterrupt(ProcessOTE* interruptedProcess, VMInterrupts nInterrupt, Oop argPointer)
{
	/**************************************************************************
		There are four scenarios to consider:
		1)  Deliver an interrupt to the actual active process with no process
			switch pending.
		2)	Deliver an interrupt to the actual active process with a process
			switch pending.
		3)	Deliver an interrupt to the new process for which a switch is pending
		4)	Deliver an interrupt to any other process with no switch pending
		5)	Deliver an interrupt to any other process with a switch pending

	When a new process is pending, the sleep() routine will have been called on
	the actual active process, and it will therefore have been placed on the
	back of the ready list at it's priority. This means we may need to reactivate
	it and put the pending process back to sleep (scenario 2)
	**************************************************************************/

	// activeProcessPointer() will return either the newProcess OR the actual active process
	// depending on the value of newProcess. The reason we don't check for the ACTUAL active
	// process is that we must put the new process back to sleep. This may mean be call
	// switchTo() to perform a NOP switch to the actual active process on rare occassions
	// (i.e. when an interrupt coincides with a pending process switch). This is OK because
	// switchTo() can handle this situation.
	ProcessOTE* activeProcess = actualActiveProcessPointer();
	Oop oopListArg;
	Process* interruptedProc = interruptedProcess->m_location;
	if (activeProcess != interruptedProcess)
	{
		// We are sending an interrupt to a process which is not actually running at the moment.
		// It may be the process scheduled to run next, but to which a context switch has not 
		// actually occurred (Scenario 3), or it may be some other process (Scenario 4)

		// If the process has terminated (or is pending termination), we mustn't deliver 
		// any more interrupts to it
		if (interruptedProc->SuspendedFrame() == Oop(Pointers.Nil) ||
			interruptedProc->IsWaitingOn(reinterpret_cast<LinkedListOTE*>(scheduler()->m_pendingTerms)))
		{
			TRACESTREAM<< L"Ignored interrupt " << ObjectMemoryIntegerValueOf(nInterrupt)<< L" to terminated process " << interruptedProcess << std::endl;
			return;
		}

		if (newProcessWaiting())
		{
			HARDASSERT(!m_oteNewProcess->m_location->IsWaiting());

			// Could be Scenario 3 or 5
			if (m_oteNewProcess == interruptedProcess)
				// Scenario 3: Interrupt delivered to new pending process
				;
			else
				// Scenario 5; New process waiting, but another non-active process interrupted
				sleep(m_oteNewProcess);

			NilOutPointer(m_oteNewProcess);
		}
		else
			// Scenario 4: Interrupted process other than active, no switch pending
			sleep(activeProcess);

		LinkedListOTE* oteList = interruptedProc->SuspendingList();
		// Now we need to remove the interrupted process from any suspendingList and remember that list
		if (!isNil(oteList))
		{
			// On return from interrupt want to requeue to this list

			// ** N.B. If the Process is actually uncollected garbage, then it is possible
			// that it holds the only reference to the list (Semaphore) on which it is waiting
			// so we have to be careful to make sure the Semaphore's ref. count does not
			// drop to zero (causing it to be added to the ZCT when the process is removed from 
			// its list since removing the process from the lists nils out its m_myList variable), 
			// therefore we count up the list now, and then remove the reference again after we have
			// pushed it onto the stack. This is to avoid any danger of a ZCT reconciliation before
			// we have switched processes. This situation can arise when a Process waiting on
			// a Semaphore is finalized, since there must be no other refs to Process or
			// Semaphore.
			oteList->countUp();

			oopListArg = reinterpret_cast<Oop>(oteList);

			// If we interrupt a process in an overlapped call, we must suspend it until
			// return from interrupt.
			//interruptedProc->SuspendOverlappedCall();

			// The process is waiting on a list (i.e. its not just suspended)
			// so we'll remove it from that list, and 
			LinkedList* suspendingList = oteList->m_location;
			// The removed link has an artificially raised ref. count to prevent
			// it going away should it be needed (removeLinkFromList can return nil)
			suspendingList->remove(interruptedProcess);
			// Now we switch to the interrupted process regardless of priorities
			// There may be no switch if a new process was waiting to start when the interrupt 
			// got delivered (the new process was put back to sleep above)
			switchTo(interruptedProcess);
			interruptedProcess->countDown();
			HARDASSERT(!interruptedProcess->isFree());
		}
		else
		{
			// The process is suspended/pending, not waiting/ready on a list
			// SmallInteger Zero is used as a special cookie passed to the 
			// interrupt return primitive so that it knows that the process returning
			// from an interrupt should be suspended.
			oopListArg = ZeroPointer;
			switchTo(interruptedProcess);
		}
	}
	else
	{
		// Interrupt sent to active process (Scenario 1), perhaps with new process waiting (Scenario 2)
		if (newProcessWaiting())
		{
			// Scenario 1: New process waiting, active process interrupted
			HARDASSERT(!m_oteNewProcess->m_location->IsWaiting());

			// Must put new process back to sleep
			sleep(m_oteNewProcess);
			NilOutPointer(m_oteNewProcess);
		}

		// Save down the active frame, since a number of interrupts will access the stack
		m_registers.StoreSuspendedFrame();

		Process* interruptedProc = interruptedProcess->m_location;
		LinkedListOTE* oteList = interruptedProc->SuspendingList();

		oopListArg = reinterpret_cast<Oop>(oteList);

		if (!isNil(oteList))
		{
			// See ** above for explanation of why we count up here rather than when
			// list pushed onto the stack as argument
			oteList->countUp();

			LinkedList* suspendingList = oteList->m_location;
			// The removed link has an artificially raised ref. count to prevent
			// it going away should it be needed (removeLinkFromList can return nil)
			(suspendingList->remove(interruptedProcess))->countDown();
			HARDASSERT(!interruptedProcess->isFree());
		}
	}

	// The process to which we are delivering the interrupt must be active or we will end up delivering
	// to the wrong process (a rare bug prior to 6.03 that occurred when an interrupt was scheduled for 
	// delivery to the new process pending to run)
	HARDASSERT(actualActiveProcess() == interruptedProc);
	HARDASSERT(!actualActiveProcess()->IsWaiting());
	HARDASSERT(isNil(actualActiveProcess()->Next()));

	pushObject(Pointers.Scheduler);
	uint8_t* pProc = reinterpret_cast<uint8_t*>(actualActiveProcess());
	uint8_t* pFrame = reinterpret_cast<uint8_t*>(m_registers.m_pActiveFrame);
	HARDASSERT(pFrame > pProc);
	SmallUinteger nOffset = pFrame - pProc;
	pushSmallInteger(nOffset);

	push(oopListArg);
	ObjectMemory::countDown(oopListArg);
	push(static_cast<Oop>(nInterrupt));
	push(argPointer);			// Arg from the interrupt queue
	// Can now remove the ref. to the arg, possibly causing its addition to the Zct
	ObjectMemory::countDown(argPointer);
	disableInterrupts(true);
	sendSelectorArgumentCount(Pointers.vmiSelector, 4);
}

// Perform a pending process switch to the argument Process (the current active Processes state is saved
// and the machine registers set up for the new process)
// Note that switchTo() must be able to handle the case where the process to be switched to is the
// same as the one currently running.
void Interpreter::switchTo(ProcessOTE* oteProcess)
{
	HARDASSERT(ObjectMemory::fetchClassOf(Oop(oteProcess)) == Pointers.ClassProcess);

	ProcessOTE* oteOldActive = actualActiveProcessPointer();
	Process* newActive = oteProcess->m_location;
	if (oteProcess != oteOldActive)
	{
#ifdef _DEBUG
		{
			HARDASSERT(!newActive->IsWaiting());
			HARDASSERT(isNil(newActive->Next()));

			if (abs(executionTrace) > 0)
			{
				static int processSwitches = 0;

				Process* active = actualActiveProcess();
				TRACESTREAM << std::endl << ++processSwitches<< L": Switching from " << oteOldActive <<
					" to " << oteProcess;
				TRACESTREAM<< L"\t(from " << LPVOID(oteOldActive) << L'/' << &active
					<< L" to " << LPVOID(oteProcess) << L'/' << &newActive << L')' << std::endl << std::endl;
			}
		}
#endif

		// Important to get the real active process here
		ObjectMemory::storePointerWithValue(reinterpret_cast<POTE&>(scheduler()->m_activeProcess), reinterpret_cast<POTE>(oteProcess));
		m_registers.NewActiveProcess(oteProcess);

		// When we return to the byte code loop, we'll continue with the new contexts previously
		// suspended context
#ifdef _DEBUG
		StackFrame* frame = activeFrame();
		HARDASSERT(frame->m_sp != Oop(Pointers.Nil) && frame->m_sp != ZeroPointer);
#endif
	}
	else
	{
		TRACESTREAM<< L"Attempted switch to active process" << std::endl;
		//DebugCrashDump("Attempted switch to active process");
	}

	OverlappedCallPtr pOverlapped = newActive->GetOverlappedCall();
	if (pOverlapped)
		pOverlapped->OnActivateProcess();

	HARDASSERT(!newActive->IsWaiting());
	HARDASSERT(isNil(newActive->Next()));
}

void __stdcall ProcessQueuedAPCs()
{
	// N.B. Watch out SleepEx() relinquishes the timeslice even if the timeout is 0. This caused
	// the CPU hog slow-down problem in D3 and 4. However in D5 the interrupt handling &c is revised
	// so that this is only called if APCs have really queued. In D3 and D4 this was called every
	// time interrupts were re-enabled, and because of the way the InputState handle table is protected
	// by disabling/re-enabling interrupts instead of using a Mutex, the result was that Dolphin would
	// only process a single Windows message at a time if the CPU was being hogged by another process.
	SleepEx(0, TRUE);

	// This doesn't seem to relinquish the timeslice, but is considerably slower, and therefore more
	// expensive to use in the normal case.
	//WaitForSingleObjectEx((Pointers.WakeupEvent->m_location->m_handle), 0, TRUE);
}

// Fire (i.e. actually process) any pending async events
// Expects to be called with interrupts enabled
// Answers whether an interrupt was sent
BOOL __fastcall Interpreter::FireAsyncEvents()
{
	HARDASSERT(!m_bInterruptsDisabled);

	if (m_bStepping)
	{
		m_bStepping = false;
		queueInterrupt(VMInterrupts::SingleStep, Oop(m_registers.m_pActiveFrame) + 1);
	}

	LONG bAsyncPending = InterlockedExchange(&m_bAsyncPending, FALSE);

	// Indicates interrupt was fired
	BOOL bInterrupted = FALSE;

	if (bAsyncPending)
	{
		GrabAsyncProtect();

		// First let any overlapped calls complete (requires processing return value in main thread)
		if (m_nAPCsPending > 0)
			ProcessQueuedAPCs();

		// Fire any async semaphore signals
		{
			SemaphoreOTE* sem;
			while (!isNil(sem = m_qAsyncSignals.Pop()))
			{
				signalSemaphore(sem);
				// Queue leaves ref. count raised so object does not go away
				sem->countDown();
			}
		}

		// Send the first interrupt (if any) to the destination process, which may not be the
		// process that would otherwise run, and indeed that process may not be ready to run. Thus 
		// we may need to interrupt a process waiting on a Semaphore, and/or reschedule.
		Oop oopInterrupt = m_qInterrupts.Pop();
		if (oopInterrupt != Oop(Pointers.Nil))
		{
			ProcessOTE* oteProcess = reinterpret_cast<ProcessOTE*>(m_qInterrupts.Pop());
			HARDASSERT(!isNil(oteProcess));
			// Note that the arg has a ref. count from the queue after popped, removed by sendVMInterrupt
			Oop oopArg = m_qInterrupts.Pop();
#ifdef _DEBUG
			TRACESTREAM<< L"Interrupting " << oteProcess << std::endl<< L"	with "
				<< InterruptNames[ObjectMemoryIntegerValueOf(oopInterrupt)]<< L"(" << reinterpret_cast<OTE*>(oopArg)<< L")"
				<< std::endl;
#endif
			// 1) We know the process won't actually get deleted because of the ZCT
			// In any case it is very unlikely its count will actually drop to zero, because
			// that would only happen for a suspended process that is only referenced from
			// the interrupt queue.
			oteProcess->countDown();
			HARDASSERT(!oteProcess->isFree());

			bool moreInterrupts = !m_qInterrupts.isEmpty();

			RelinquishAsyncProtect();

			// Handle the first interrupt only (disable interrupts)
			sendVMInterrupt(oteProcess, static_cast<VMInterrupts>(oopInterrupt), oopArg);

			// We only process the first interrupt, so there may still be some pending
			// We leave the flag set if appropriate
			if (moreInterrupts)
			{
				InterlockedExchange(&m_bAsyncPending, TRUE);
			}

			// 2) Remove ref to process caused by queue (NOW DONE ABOVE @ 1)
			//oteProcess->countDown();

			// Interrupts take priority over synchronous and asynchronous switches
			bInterrupted = TRUE;
		}
		else
		{
			RelinquishAsyncProtect();
		}
	}

	return bInterrupted;
}

// Answers whether a new process became ready
// If interrupts are disabled, then no asynchronous interrupts or semaphores are processed
// BUT a process switch due to a synchronous operation can still occur. This allows suspending
// and resuming of processes with interrupts disabled. Signalling or waiting on a semaphore
// automatically re-enables interrupts.
BOOL Interpreter::CheckProcessSwitch()
{
	//CHECKREFSNOFIX

	ASSERT(GetCurrentThreadId() == MainThreadId());

	if (!m_bInterruptsDisabled)
		if (FireAsyncEvents())
			return TRUE;

	if (newProcessWaiting())
	{
#ifdef _DEBUG
		if (m_bInterruptsDisabled)
			TRACESTREAM<< L"WARNING: Switching processes with interrupts disabled" << std::endl;
#endif

		// Shouldn't happen that attempt to switch to same process
		// but if we do it doesn't matter
		switchTo(m_oteNewProcess);

		// Nil out newProcess register removing extra ref.
		NilOutPointer(m_oteNewProcess);

		CHECKREFERENCESIF(abs(executionTrace) > 0)

		return TRUE;
	}

	//CHECKREFERENCES

	return FALSE;
}

#ifdef _DEBUG
// Return the priority of the highest priority waiting process
int Interpreter::highestWaitingPriority()
{
	ProcessorScheduler* scheduler = schedulerPointer()->m_location;

	HARDASSERT(scheduler->m_processLists->m_oteClass == Pointers.ClassArray);
	ArrayOTE* oteLists = scheduler->m_processLists;
	Array* processLists = oteLists->m_location;

	size_t highestPriority = oteLists->pointersSize();
	size_t index = highestPriority;
	LinkedList* pProcessList;
	do
	{
		LinkedListOTE* oteProcessList = reinterpret_cast<LinkedListOTE*>(processLists->m_elements[--index]);
		pProcessList = oteProcessList->m_location;
	} while (pProcessList->isEmpty() && index);
	return index + 1;
}
#endif

void Interpreter::sleep(ProcessOTE* aProcess)
{
	if (isNil(aProcess))
		return;

	Process* process = aProcess->m_location;
	HARDASSERT(!process->IsWaiting());
	ProcessorScheduler* processor = scheduler();

	HARDASSERT(processor->m_processLists->m_oteClass == Pointers.ClassArray);
	Array* processLists = processor->m_processLists->m_location;

	LinkedListOTE* oteList = reinterpret_cast<LinkedListOTE*>(processLists->m_elements[process->Priority() - 1]);
	QueueProcessOn(aProcess, oteList);
}


void Interpreter::QueueProcessOn(ProcessOTE* oteProcess, LinkedListOTE* oteList)
{
	Process* process = oteProcess->m_location;

	// If this process is already waiting on a list, then things are about to go wrong
	HARDASSERT(!process->IsWaiting());
	HARDASSERT(isNil(process->Next()));

	LinkedList* processList = oteList->m_location;
	processList->addLast(oteProcess);
	// Process has back pointer to list (and therefore inc's its ref. count)
	process->SetSuspendingList(oteList);
}

// Resuspend the active process on the specified list and reschedule
// Called by iret primitive if interrupt took process off a suspending list
//
// One scenario to consider is where the idle process handles an interrupt. Since this is 
// normally ready to run, when the interrupt returns it will get replaced on ready list. 
// However if it is the only available process, then it will be immediately taken back off 
// that list to continue execution.
LinkedListOTE* __fastcall Interpreter::ResuspendActiveOn(LinkedListOTE* oteList)
{
	ProcessOTE* oteActive = actualActiveProcessPointer();
	LinkedListOTE* list = ResuspendProcessOn(oteActive, oteList);
	CHECKREFERENCES
	return list;
}

LinkedListOTE* Interpreter::ResuspendProcessOn(ProcessOTE* oteProcess, LinkedListOTE* oteList)
{
	HARDASSERT(!isNil(oteList));

	// This must either be a request to push the active process onto a list, or it must already be waiting on a list. 
	// If not, the Reschedule call will schedule another process to run, and the active process will effectively be suspended.
	HARDASSERT(oteProcess == activeProcessPointer() || activeProcess()->IsWaiting());

	// Nasty, but...
	if (oteList->m_oteClass == Pointers.ClassSemaphore)
	{
		// We need to see if the Semaphore now has any excess signals
		// to avoid incorrectly suspending the process
		Semaphore* sem = static_cast<Semaphore*>(oteList->m_location);
		HARDASSERT(ObjectMemoryIsIntegerObject(sem->m_excessSignals));
		auto excessSignals = ObjectMemoryIntegerValueOf(sem->m_excessSignals);

		if (excessSignals > 0)
		{
			sem->m_excessSignals -= 2;
			// Process is ready to run, queue it for scheduling
			sleep(oteProcess);
		}
		else
		{
			// Add the process to the end of the Semaphore's wait queue
			QueueProcessOn(oteProcess, oteList);
		}
	}
	else
	{
		// Put the process back on the list for scheduling
		QueueProcessOn(oteProcess, oteList);
	}

	// schedule and perform process switch
	BOOL bSuccess = Reschedule();
	if (!bSuccess)
	{
		HARDASSERT(!newProcessWaiting());
		// Remove the extra ref left by schedule()
		actualActiveProcessPointer()->countDown();
	}

	CHECKREFERENCES

	return oteList;
}

BOOL __stdcall Interpreter::Reschedule()
{
	// Normally one would call sleep(active)/SuspendActiveOn() before calling this 
	// to ensure current process remains alive. If you don't then current process
	// will drop out of the scheduler.
	HARDASSERT(activeProcess()->IsWaiting());

	schedule();
	return CheckProcessSwitch();
}

#pragma auto_inline(off)

// Resume aProcess in place of the current activeProcess, but only if it has a higher priority
// than the current active process. Return aProcess unless it is invalid, in which case return NULL
ProcessOTE* Interpreter::resume(ProcessOTE* aProcess)
{
	HARDASSERT(aProcess != activeProcessPointer());

	// We do not check that the state of the object is valid, so don't mess
	// up the Process objects in the inspector
	HARDASSERT(ObjectMemory::fetchClassOf(Oop(aProcess)) == Pointers.ClassProcess);
	Process* proc = aProcess->m_location;

	// For the sake of robustness(!) refuse to resume a process which
	// has been terminated, or is not properly initialized
	if (proc->SuspendedFrame() == Oop(Pointers.Nil))
		return NULL;

	SmallInteger newPriority = proc->Priority();
	SmallInteger activePriority = 0;
	// It is important that this answer the newProcess if there is one, as it can be called
	// repeatedly during the same primitive, and so must find the newProcess with the highest
	// priority, so we use the activeProcessPointer() which returns either the activeProcess
	// or the new activeProcess.
	ProcessOTE* activePointer = activeProcessPointer();
	if (!isNil(activePointer))
	{
		HARDASSERT(ObjectMemory::fetchClassOf(Oop(activePointer)) == Pointers.ClassProcess);
		Process* activeProc = activePointer->m_location;
		activePriority = activeProc->Priority();
	}

	if (newPriority > activePriority)
	{
		sleep(activePointer);

		// If we are reviving the process which is currently active 'cos we thought
		// we were going to switch away from it but have changed our minds, then we don't 
		// need to do the actual process switch 'cos we're already running the correct process
		if (aProcess == actualActiveProcessPointer())
		{
			HARDASSERT(m_oteNewProcess == activePointer);
			NilOutPointer(m_oteNewProcess);
		}
		else
			ObjectMemory::storePointerWithValue((OTE*&)m_oteNewProcess, (OTE*)aProcess);

		HARDASSERT(!proc->IsWaiting());
	}
	else
	{
		//HARDASSERT(aProcess != actualActiveProcessPointer());

		// Put aProcess back to sleep as it is the same or lower priority
		// and/or process switches are disabled
		sleep(aProcess);
	}

#ifdef _DEBUG
	int newActivePriority = activeProcess()->Priority();
	int highestPriorityWaiting = highestWaitingPriority();
 	//HARDASSERT(newActivePriority >= highestPriorityWaiting);
#endif

	return aProcess;	// We resumed something, even if it was the previously active process
}

#ifdef NDEBUG
#pragma auto_inline(on)
#endif

///////////////////////////////////////////////////////////////////////////////
// LinkedList accessing routines

// N.B. On return ref. count of return object will be one too high - this
// is to prevent it being prematurely deleted if the only object
// referencing it was aLinkedList - so callers must be careful to reduce
// the reference count at the appropriate time (or leave the object to 
// be garbage collected - when we implement that)
inline ProcessOTE* LinkedList::removeFirst()
{
	HARDASSERT(!isEmpty());
	ProcessOTE* removedLink = m_firstLink;
	Process* link = removedLink->m_location;
	if (removedLink == m_lastLink)
	{
		// Removed last link in list - set the pointers of the linked list to nil 
		// to signify empty
		// We don't reduce ref. count for first link in case we are only reference
		m_firstLink = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
		m_lastLink->countDown();
		m_lastLink = reinterpret_cast<ProcessOTE*>(Pointers.Nil);

		// If removing last link, then shouldn't need to nil the next link pointer
		HARDASSERT(isNil(link->Next()));
	}
	else
	{
		// Overall ref. count of next link remains the same
		m_firstLink = link->Next();
		link->BasicClearNext();
	}

	link->ClearList();
	return removedLink;
}

inline void Process::SetNext(ProcessOTE* oteNext)
{
	ObjectMemory::storePointerWithValue((OTE*&)m_nextLink, (OTE*)oteNext);
}

// Add link to end of list
inline void LinkedList::addLast(ProcessOTE* aLink)
{
	if (isEmpty())
	{
		// Incs the ref. count on aLink (current value is nil)
		ObjectMemory::storePointerWithValue((OTE*&)m_firstLink, (OTE*)aLink);
	}
	else
	{
		Process* lastLink = m_lastLink->m_location;
		HARDASSERT(isNil(lastLink->Next()));
		lastLink->SetNext(aLink);
		// We add to the end of the list, so the current end of the list loses
		// a reference from the list
	}
	ObjectMemory::storePointerWithValue((OTE*&)m_lastLink, (OTE*)aLink);
}

// Ref. count of removed (and returned) link will be one too high
ProcessOTE* LinkedList::remove(ProcessOTE* aLink)
{
	ProcessOTE* currLink = m_firstLink;
	ProcessOTE* nil = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
	ProcessOTE* prevLink = nil;

	while (currLink != aLink)
	{
		if (currLink == nil)
			return nil;		// Not found, jump out
		prevLink = currLink;
		Process* link = currLink->m_location;
		currLink = link->Next();
	}


	ProcessOTE* nextLink = currLink->m_location->Next();
	// Previous link/firstLink must point at removed links nextLink.
	// Don't lose ref here in case cause Link to be destroyed
	// Ref. count of nextLink remains the same
	if (aLink == m_firstLink)
		// Removed first item in list
		m_firstLink = nextLink;
	else
		prevLink->m_location->BasicSetNext(nextLink);

	// Nil out the nextLink pointer of the removed link (ref. count remains same overall)
	currLink->m_location->BasicClearNext();

	// May have removed last link in list
	if (aLink == m_lastLink)
	{
		// We DO remove the ref. from lists lastLink pointer
		ObjectMemory::storePointerWithValue((OTE*&)m_lastLink, (OTE*)prevLink);
	}

	Process* proc = aLink->m_location;

	// Remove the back pointer
	proc->ClearList();

	HARDASSERT(isNil(proc->Next()));
	return aLink;
}

inline bool LinkedList::isEmpty()
{
	return isNil(m_firstLink);
}

///////////////////////////////////////////////////////////////////////////////
// Process related primitives (Semaphore etc)
#include "InterprtPrim.inl"

Oop* PRIMCALL Interpreter::primitiveSignal(Oop* const sp, primargcount_t)
{
	SemaphoreOTE* receiver = reinterpret_cast<SemaphoreOTE*>(*sp);
	HARDASSERT(ObjectMemory::fetchClassOf((Oop)receiver) == Pointers.ClassSemaphore);

	// Sending #signal always re-enables interrupts (inside signalSemaphore)
	signalSemaphore(receiver);
	CheckProcessSwitch();
	return primitiveSuccess(0);
}


Oop* PRIMCALL Interpreter::primitiveSetSignals(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Must be a SmallInteger
	}

	// Causes interrupts to be re-enabled to prevent carry over
	// of disabled state to another process
	disableInterrupts(false);

	Oop semaphorePointer = *(sp-1);
	m_registers.m_stackPointer = sp - 1;

	HARDASSERT(ObjectMemory::fetchClassOf(semaphorePointer) == Pointers.ClassSemaphore);
	SemaphoreOTE* oteSem = reinterpret_cast<SemaphoreOTE*>(semaphorePointer);
	Semaphore* sem = oteSem->m_location;

	SmallInteger signals = ObjectMemoryIntegerValueOf(integerPointer);
	HARDASSERT(ObjectMemoryIsIntegerObject(sem->m_excessSignals));

	if (!sem->isEmpty())
	{
		HARDASSERT(sem->m_excessSignals == ZeroPointer);
		do
		{
			resumeFirst(sem);
			if (signals == 0) break;
			signals--;
		} while (!sem->isEmpty());
		CheckProcessSwitch();
	}

	sem->m_excessSignals = ObjectMemoryIntegerObjectOf(signals);

	return primitiveSuccess(0);
}

Oop* PRIMCALL Interpreter::primitiveWait(Oop* const sp, primargcount_t)
{
	//CHECKREFERENCES

	Oop oopTimeout = *(sp - 1);
	if (!ObjectMemoryIsIntegerObject(oopTimeout))
	{
		OTE* oteArg = reinterpret_cast<OTE*>(oopTimeout);
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Must be a SmallInteger
	}

	SmallInteger timeout = ObjectMemoryIntegerValueOf(oopTimeout);
	if (timeout != INFINITE && timeout != 0)
		return primitiveFailure(_PrimitiveFailureCode::NotSupported);

	OTE* oteRetValHolder = reinterpret_cast<OTE*>(*sp);
	if (ObjectMemoryIsIntegerObject(oteRetValHolder) || oteRetValHolder->isBytes() ||
		oteRetValHolder->getWordSize() == ObjectHeaderSize)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);	// Must be a suitable value holder

	SemaphoreOTE* thisReceiver = reinterpret_cast<SemaphoreOTE*>(*(sp - 2));
	Semaphore* sem = thisReceiver->m_location;

	// Any arguments are integers or no change to ref. count
	pop(2);

	// Sending #wait implicity re-enables interrupts
	// This is to prevent interrupts remaining disabled forever, which might happen
	// if the active process remains waiting forever.
	disableInterrupts(false);

	HARDASSERT(!actualActiveProcess()->IsWaiting());
	HARDASSERT(isNil(actualActiveProcess()->Next()));
	HARDASSERT(!newProcessWaiting());

	// BUG FIX: We must suspend frame properly in case semaphore signalled asynchronously
	// and handled at start of CheckProcessSwitch() because the semaphore signalling code
	// needs to access the suspended stack pointer in order to update value holder in v3.
	m_registers.PrepareToSuspendProcess();

	int nAnswer = sem->Wait(thisReceiver, actualActiveProcessPointer(), timeout);

	Oop oopAnswer = ObjectMemoryIntegerObjectOf(nAnswer);

	// Assign result into temporary in the active context
	VariantObject* retValHolder = static_cast<VariantObject*>(oteRetValHolder->m_location);
	ObjectMemory::countDown(retValHolder->m_fields[0]);
	retValHolder->m_fields[0] = oopAnswer;

	oopAnswer = reinterpret_cast<Oop>(oteRetValHolder);

	*m_registers.m_stackPointer = oopAnswer;

	CheckProcessSwitch();
#ifdef _DEBUG
	if (abs(executionTrace) > 0)
	{
		CHECKREFERENCES
	}
#endif
	return primitiveSuccess(0);
}

// Yield to avoid starving other processes at the same priority only, 
// e.g. if in a very tight loop of short Delays.
BOOL Interpreter::FastYield()
{
	ProcessorScheduler* processor = scheduler();
	Process* activeProc = actualActiveProcess();

	SmallInteger activePriority = activeProc->Priority();

	HARDASSERT(processor->m_processLists->m_oteClass == Pointers.ClassArray);
	ArrayOTE* oteLists = processor->m_processLists;
	Array* processLists = oteLists->m_location;

	HARDASSERT(activePriority >= 1 && activePriority <= static_cast<SmallInteger>(oteLists->pointersSize()));

	LinkedListOTE* oteList = reinterpret_cast<LinkedListOTE*>(processLists->m_elements[activePriority - 1]);
	LinkedList* processList = oteList->m_location;
	if (!processList->isEmpty())
	{
		// There is another process ready to run at the same priority - so give
		// it a chance, even though we're not waiting on the Semaphore
		ProcessOTE* oteActive = processor->m_activeProcess;
		HARDASSERT(activeProcessPointer() == oteActive);
		sleep(oteActive);
		m_oteNewProcess = processList->removeFirst();
		//CHECKREFERENCES
		// Process switch will occur below
#ifdef _DEBUG
		TRACESTREAM<< L"Interpreter: Yield from " << oteActive << std::endl<< L"  to "
			<< m_oteNewProcess << std::endl;
		TRACESTREAM.flush();
#endif
		return TRUE;	// Yielded
	}
	return FALSE;
}

DWORD Semaphore::Wait(SemaphoreOTE* oteThis, ProcessOTE* oteProcess, int timeout)
{
	if (!ObjectMemoryIsIntegerObject(m_excessSignals))
	{
		// Semaphore has bad format - force to 0
		m_excessSignals = ZeroPointer;
	}

	SmallInteger excessSignals = ObjectMemoryIntegerValueOf(m_excessSignals);

	DWORD dwAnswer;
	if (excessSignals > 0)
	{
		m_excessSignals -= 2;
		// Use this as a pre-emption point, even if Semaphore does not block
		// the process
		Interpreter::FastYield();
		dwAnswer = WAIT_OBJECT_0;
	}
	else
	{
		if (timeout == INFINITE)
		{
			Interpreter::QueueProcessOn(oteProcess, reinterpret_cast<LinkedListOTE*>(oteThis));
			if (Interpreter::schedule() == oteProcess)
				TRACESTREAM<< L"WARNING: Interrupted wait of " << oteProcess<< L" on " << oteThis << std::endl;
			// Semaphore not available yet, so if interrupted in the meantime the
			// return value holder will contain the "interrupted" value
			dwAnswer = WAIT_IO_COMPLETION;
		}
		else
		{
			HARDASSERT(timeout == 0);
			dwAnswer = WAIT_TIMEOUT;
		}
	}
	return dwAnswer;
}

// Uses, but does not modify, instructionPointer and stackPointer
// Does not modify pHome or pMethod
Oop* PRIMCALL Interpreter::primitiveResume(Oop* const sp, primargcount_t argumentCount)
{
#ifdef _DEBUG
	//	if (abs(executionTrace) > 0)
	CHECKREFERENCES
#endif
	if (argumentCount > 1)
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);	// Too many arguments

	ProcessOTE* receiverProcess = reinterpret_cast<ProcessOTE*>(*(sp - argumentCount));
	Process* proc = receiverProcess->m_location;
	// We can only resume processes which are not waiting on a queue
	// already (i.e. Schedulable processes in a Ready state, and Processes
	// waiting on a Semaphore, should not be resumed, only suspended
	// processes.
	if (proc->IsWaiting())
		return primitiveFailure(_PrimitiveFailureCode::IllegalStateChange);

	LinkedListOTE* oteList;
	if (argumentCount == 0 || isNil(oteList = reinterpret_cast<LinkedListOTE*>(*sp)))
	{
		if (!resume(receiverProcess))
			return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
	else
	{
		HARDASSERT(ObjectMemory::isKindOf((POTE)oteList, Pointers.ClassSemaphore->m_location->m_superclass));
		sleep(activeProcessPointer());
		ResuspendProcessOn(receiverProcess, oteList);
	}

	CheckProcessSwitch();
#ifdef _DEBUG
	//	if (abs(executionTrace) > 0)
	CHECKREFERENCES
#endif

	return primitiveSuccess(0);
}

// Uses, but does not modify, instructionPointer and stackPointer
// Does not modify pHome or pMethod
Oop* PRIMCALL Interpreter::primitiveSingleStep(Oop* const sp, primargcount_t argumentCount)
{
	SmallInteger steps;
	switch (argumentCount)
	{
	case 0:
		steps = 1;	// Default is 2 because of the interrupt return method?
		break;

	case 1:
	{
		Oop oopSteps = *sp;
		if (!ObjectMemoryIsIntegerObject(oopSteps))
		{
			return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Must be a SmallInteger
		}
		steps = ObjectMemoryIntegerValueOf(oopSteps);
	}
	break;
	default:
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);	// Too many arguments
	}

	ProcessOTE* receiverProcess = reinterpret_cast<ProcessOTE*>(*(sp - argumentCount));
	Process* proc = receiverProcess->m_location;

	// Detect terminated, or pending termination, processes
	if (proc->SuspendedFrame() == Oop(Pointers.Nil))
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);

	// We must kill the sampling timer to prevent it upsetting results
	CancelSampleTimer();
	m_nInputPollCounter = -steps;

	LinkedListOTE* oteList = proc->SuspendingList();

	// We have to be able to single step processes which are either suspended
	// or waiting on on a queue (i.e. Schedulable processes in a Ready state)
	// Processes waiting on a Semaphore, cannot be single stepped.
	if (!isNil(oteList))
	{
		if (oteList->m_oteClass == Pointers.ClassSemaphore)
			return primitiveFailure(_PrimitiveFailureCode::IllegalStateChange);

		// The process is waiting on a list (i.e. its not just suspended)
		// so we'll remove it from that list, and 
		LinkedList* suspendingList = oteList->m_location;
		// The removed link has an artificially raised ref. count to prevent
		// it going away should it be needed (removeLinkFromList can return nil)
		(suspendingList->remove(receiverProcess))->countDown();
	}

	pop(argumentCount + 1);

	ProcessOTE* activeProcess = activeProcessPointer();
	if (activeProcess != receiverProcess)
	{
		sleep(activeProcess);
		NilOutPointer(m_oteNewProcess);
		// Forcibly switch to the stepped process regardless of priorities
		switchTo(receiverProcess);
	}

	// Disable process switching, enable break
	disableInterrupts(true);
	m_bAsyncPending = true;
	m_bStepping = true;

	return primitiveSuccess(0);
}

_PrimitiveFailureCode Interpreter::SuspendProcess(ProcessOTE* processPointer)
{
	ProcessOTE* active = activeProcessPointer();
	if (processPointer == active)
	{
		// If the active process suspends itself, we must re-enable interrupts as we don't
		// know who will run next, and whether interrupts will ever then get re-enabled.
		disableInterrupts(false);

#ifdef _DEBUG
		{
			Process* process = processPointer->m_location;

			// It is important to remove this self reference
			//replaceStackTopObjectNoRefCnt(Oop(Pointers.Nil));
			// Mark the Process as suspended (it will not be on any lists)
			HARDASSERT(!process->IsWaiting());
		}
#endif

		TODO("Use SuspendActive here - need to rewrite slightly")
		if (schedule() == processPointer)
			return _PrimitiveFailureCode::Retry;

		CheckProcessSwitch();
#ifdef _DEBUG
		if (abs(executionTrace) > 0)
			CHECKREFERENCES
#endif
			// A process switch MUST occur
			HARDASSERT(processPointer != activeProcessPointer());
	}
	else
	{
		Process* process = processPointer->m_location;
		// The receiver is not (now) the activeProcess, remove from Processor or Semaphore list
		if (process->IsWaiting())
		{
			if (process->IsWaitingOn(reinterpret_cast<LinkedListOTE*>(scheduler()->m_pendingTerms)))
				return _PrimitiveFailureCode::ThreadIsTerminating;	// Process is pending termination

			// N.B. In a runtime system we do not check the type of process.m_myList, 
			// but just assume it is a kind of LinkedList, if it isn't (which could
			// only occur if the user has fiddled with it in an inspector) then it's
			// just too bad, and a crash will almost certainly result!
			LinkedList* suspendingList = process->SuspendingList()->m_location;

			// The removed link has an artificially raised ref. count to prevent
			// it going away should it be needed
			(suspendingList->remove(processPointer))->countDown();
		}
		else
			return _PrimitiveFailureCode::AlreadyComplete;	// Process already suspended
	}

	return _PrimitiveFailureCode::NoError;
}

#pragma auto_inline(off)

// Suspend the caller if it is the receiver if it is the active process
// if it is not the active process, then the primitive fails
Oop* PRIMCALL Interpreter::primitiveSuspend(Oop* const sp, primargcount_t)
{
	ProcessOTE* processPointer = reinterpret_cast<ProcessOTE*>(*sp);

	_PrimitiveFailureCode nRet = SuspendProcess(processPointer);
	if (nRet != _PrimitiveFailureCode::NoError)
		return primitiveFailure(nRet);

	return primitiveSuccess(0);			// OK, suspended
}

#ifdef NDEBUG
#pragma auto_inline(on)
#endif

// Terminate the caller - really just a suspend which also nils the suspended context
// This is necessary because otherwise if the active process attempts to terminate itself,
// then it won't get as far as nilling out the suspended context. The alternative is to
// use another process to do the nilling, but that seems more error prone and consumes
// more resources than this very simple primitive.
Oop* PRIMCALL Interpreter::primitiveTerminateProcess(Oop* const sp, primargcount_t)
{
	ProcessOTE* processPointer = reinterpret_cast<ProcessOTE*>(*sp);

	_PrimitiveFailureCode nRet = SuspendProcess(processPointer);
	if (nRet != _PrimitiveFailureCode::NoError)
		return primitiveFailure(nRet);

	HARDASSERT(!processPointer->isFree());

	if (!TerminateOverlapped(processPointer))
	{
		if (!processPointer->isFree())
		{
			// Terminated processes are recognisable because they have no suspended context,
			// and no suspending list
			Process* process = processPointer->m_location;
			// Terminated processes can be spotted by their nilled out context. They cannot be restarted (easily)
			process->ClearSuspendedFrame();
		}
	}

#ifdef _DEBUG
	//	if (abs(executionTrace) > 0)
	//		CHECKREFERENCES
#endif
	return primitiveSuccess(0);
}

// Change the priority of the receiver to the argument.
// Fail if the argument is not a SmallInteger in the range 1..max priority
// Answers the processes old priority
Oop* PRIMCALL Interpreter::primitiveProcessPriority(Oop* const sp, primargcount_t)
{
	//	CHECKREFERENCES
	Oop argPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(argPointer))
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Must be a SmallInteger
	}

	SmallUinteger newPriority = ObjectMemoryIntegerValueOf(argPointer);
	ProcessorScheduler* sched = scheduler();
	ArrayOTE* listsArrayPointer = sched->m_processLists;
	if (newPriority > listsArrayPointer->pointersSize())
		return primitiveFailure(_PrimitiveFailureCode::IntegerOutOfRange);	// Priority out of range

	// Changing a processes priority implicitly enables interrupts
	// This is because the interrupt disabled state should not be 
	// carried over to other processes, as they may not be expecting
	// to be run with interrupts disabled, and may never re-enable them.
	disableInterrupts(false);

	ProcessOTE* receiverPointer = reinterpret_cast<ProcessOTE*>(*(sp-1));

	Process* process = receiverPointer->m_location;
	SmallUinteger oldPriority = process->Priority();
	process->SetPriority(newPriority);

	// Answer the previous priority (we do this now in case a Process switch occurs
	// as then we'd end up putting the result on the wrong stack!)
	*(sp-1) = ObjectMemoryIntegerObjectOf(oldPriority);

	// Pop SmallInteger argument before context switch
	m_registers.m_stackPointer = sp - 1;

	if (receiverPointer == activeProcessPointer())
	{
		// Active process is changing its priority

		if (newPriority < oldPriority)
		{
			// Priority reduced, may need to run another process
			Yield();
		}
		// else priority same or increased, leave it running
	}
	else
	{
		// Changing priority of a process which is currently inactive depends
		// on its state. If its Suspended, Terminated, or Waiting, then we've
		// nothing further to do. If, however, its Ready then we need to place
		// it in the correct list, and reschedule
		if (process->IsReady())
		{
			LinkedList* suspendingList = process->SuspendingList()->m_location;
			// The removed link has an artificially raised ref. count to prevent
			// it going away should it be needed (removeLinkFromList can return nil)
			(suspendingList->remove(receiverPointer))->countDown();
			HARDASSERT(!receiverPointer->isFree());
			// Reschedule by attempting to resume the process whose priority has changed
			resume(receiverPointer);
			CheckProcessSwitch();
		}
	}

	return primitiveSuccess(0);
}

// Register a new Object with the VM. This primitive is now used to register
// more than just the input semaphore, and is independent of receiver.
Oop* PRIMCALL Interpreter::primitiveInputSemaphore(Oop* const sp, primargcount_t)
{
	Oop oopIndex = *(sp-1);
	if (!ObjectMemoryIsIntegerObject(oopIndex))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	SmallUinteger which = ObjectMemoryIntegerValueOf(oopIndex);
	if (which <= 0 || which > NumPointers)
		return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// out of bounds

	// top of stack is value to be put
	Oop oopValue = *sp;

	if (!isIntegerObject(oopValue))
	{
		reinterpret_cast<OTE*>(oopValue)->beSticky();
	}

	ObjectMemory::ProtectConstSpace(PAGE_READWRITE);
	Array* registry = reinterpret_cast<Array*>(&_Pointers);
	ObjectMemory::storePointerWithValue(registry->m_elements[which - 1], oopValue);
	ObjectMemory::ProtectConstSpace(PAGE_READONLY);

	return sp-2;
}


// Not quite the orignal meaning of this primitive, but we'll use it all the same
// Answers the old sample interval.
// If the new interval is 0, simply resets the counter.
// If the new interval is < 0, turns off the input polling
Oop* PRIMCALL Interpreter::primitiveSampleInterval(Oop* const sp, primargcount_t)
{
	Oop argPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(argPointer))
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);	// Must be an SmallInteger
	}

	Oop oldInterval = ObjectMemoryIntegerObjectOf(m_nInputPollInterval);
	SmallInteger newInterval = ObjectMemoryIntegerValueOf(argPointer);

	if (newInterval < 0)
		CancelSampleTimer();
	else
		SetSampleTimer(newInterval);

	ResetInputPollCounter();

	// And ensure pressed bit of async key state is reset
	IsUserBreakRequested();

	*(sp-1) = oldInterval;
	return sp - 1;
}

///////////////////////////////////////////////////////////////////////////////
// Process methods for managing overlapped calls

inline OverlappedCall* Process::GetOverlappedCall()
{
	return ObjectMemoryIsIntegerObject(m_thread) && m_thread != ZeroPointer
		? reinterpret_cast<OverlappedCall*>(m_thread - 1)
		: nullptr;
}

bool Interpreter::TerminateOverlapped(ProcessOTE* oteProc)
{
	// Must be active or suspended by the time we get here
	Process* proc = oteProc->m_location;

	OverlappedCallPtr pOverlapped = proc->GetOverlappedCall();
	if (pOverlapped)
	{
		// Need to ensure process remains around at least until the thread terminates
		// Note that we don't actually 'suspend' the process, but put it on a Semaphore
		// like terminations pending list
		LinkedListOTE* otePending = reinterpret_cast<LinkedListOTE*>(scheduler()->m_pendingTerms);

		if (!proc->IsWaitingOn(otePending))
		{
			QueueProcessOn(oteProc, otePending);

#ifdef _DEBUG
			TRACESTREAM << std::hex << GetCurrentThreadId()<< L": Queueing terminate to " << *pOverlapped<< L" in process " << reinterpret_cast<OTE*>(proc->Name()) << std::endl;
#endif
			// Queue an APC to raise a terminate exception in the overlapped call thread.
			// The overlapped thread will queue an APC back to this thread from its termination
			// handler to let us know when it has really terminated, at which point we can take 
			// the process off the pendingTerms list, and allow the corresponding Smalltalk
			// process to die.
			pOverlapped->QueueTerminate();

			if (activeProcessPointer() == oteProc)
				Reschedule();

			// The process must wait for the associated overlapped call thread to terminate
			return true;
		}
		else
		{
			// We don't need to do anything as a previous attempt has been made to 
			// terminate this process and we are still waiting for the overlapped
			// call thread to respond
			HARDASSERT(FALSE);	// Actually I don't think we can get here
		}

	}

	// The process can be terminated immediately
	return false;
}
