/******************************************************************************

	File: STProcess.h

	Description:

	VM representation of execution related Smalltalk classes.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STPROCESS_H_
#define _IST_STPROCESS_H_
#include <stddef.h>
#include <float.h>

#include "STVirtualObject.h"
#include "STStackFrame.h"

class OverlappedCall;
class ProcessList;
typedef TOTE<ProcessList> ProcessListOTE;

// Really a subclass of Link, but VM doesn't care about that
class Process //: public Object
{
private:
	// Really a member of Link superclass
	ProcessOTE*		m_nextLink;
	Oop				m_suspendedFrame;
	Oop				m_priority;
	ProcessListOTE*	m_myList;
	Oop				m_callbackDepth;
	Oop				m_primitiveFailureCode;
	Oop				m_primitiveFailureData;
	Oop				m_fpeMask;
	SemaphoreOTE*	m_waitOverlap;
	Oop				m_thread;

private:
	// Process contains these extra fields after this point, but we do not access them
	OTE* m_exceptionEnvironment;
	Oop m__alreadyPrinted;
	Oop m_reserved1;
	OTE* m_debugger;
	Oop m_name;
	Oop m_reserved2;
public:
	Oop m_stack[];

	#ifdef _DEBUG
		bool IsValid();
	#endif

public:
	void sizeToSP(ProcessOTE*, Oop* sp) const;

	SMALLUNSIGNED stackSize(ProcessOTE* oteMe)
	{
		return (oteMe->getSize() - offsetof(Process, m_stack[0]))/sizeof(MWORD);
	}

	SMALLUNSIGNED indexOfSP(Oop* sp)
	{
		return SMALLUNSIGNED(sp - m_stack) + 1;
	}

	SMALLUNSIGNED indexOfFramePointer(Oop framePointer)
	{
		return indexOfSP(reinterpret_cast<Oop*>(framePointer-1));
	}

	StackFrame* suspendedFrame()			{ return (StackFrame*)(m_suspendedFrame-1); }
	void SetSuspendedFrame(InterpreterRegisters& registers);		// Store down current frame in prep. for suspend (also resize to SP)
	//void saveContext(InterpreterRegisters registers);

	VirtualObjectHeader* getHeader() const	
	{
		return reinterpret_cast<VirtualObjectHeader*>(const_cast<Process*>(this))-1; 
	}

	///////////////////////////////////////////////////////////////////////////
	// Helpers for overlapped calls

	OverlappedCall* GetOverlappedCall();

	// Suspend any active overlapped call thread associated with the receiver, if any
	bool SuspendOverlappedCall();
	// Resume any active overlapped call thread associated with the receiver, if any
	bool ResumeOverlappedCall();

	Oop Name() const { return m_name; }
	bool IsWaiting() const { return !m_myList->isNil(); }
	bool IsWaitingOn(const ProcessListOTE* oteList) const { return m_myList == oteList; }
	bool IsReady() const { return !m_myList->isNil() && !ObjectMemory::isKindOf(m_myList, Pointers.ClassSemaphore); }
	ProcessListOTE* SuspendingList() const { return m_myList; }
	ProcessOTE* Next() const { return m_nextLink; }
	void SetSuspendingList(ProcessListOTE* oteList)
	{
		HARDASSERT(m_myList->isNil());
		oteList->countUp();
		m_myList = oteList;
	}
	void ClearList()
	{
		NilOutPointer(m_myList);
	}
	void BasicClearNext()
	{
		m_nextLink = reinterpret_cast<ProcessOTE*>(Pointers.Nil);
	}
	void BasicSetNext(ProcessOTE* oteNext) { m_nextLink = oteNext; }
	void SetNext(ProcessOTE* oteNext)
	{
		StorePointerWithValue(m_nextLink, oteNext);
	}
	Oop SuspendedFrame() const { return m_suspendedFrame; }
	void SetSuspendedFrame(Oop intPointer)
	{
		HARDASSERT(ObjectMemoryIsIntegerObject(intPointer));
		m_suspendedFrame = intPointer;
	}
	void ClearSuspendedFrame() 
	{
		HARDASSERT(ObjectMemoryIsIntegerObject(m_suspendedFrame) || m_suspendedFrame == (Oop)Pointers.Nil);
		m_suspendedFrame = reinterpret_cast<Oop>(Pointers.Nil);
	}

	DWORD FpeMask() const
	{
		return ObjectMemoryIntegerValueOf(m_fpeMask);
	}
	SMALLUNSIGNED Priority() const
	{
		HARDASSERT(ObjectMemoryIsIntegerObject(m_priority));
		return ObjectMemoryIntegerValueOf(m_priority);
	}
	void SetPriority(SMALLUNSIGNED priority)
	{
		m_priority = ObjectMemoryIntegerObjectOf(priority);
	}
	SMALLINTEGER PrimitiveFailureCode()
	{
		return ObjectMemoryIsIntegerObject(m_primitiveFailureCode) ? ObjectMemoryIntegerValueOf(m_primitiveFailureCode) : 0; 
	}
	Oop PrimitiveFailureData() const { return m_primitiveFailureData; }
	void SetPrimitiveFailureCode(SMALLINTEGER code)
	{
		m_primitiveFailureCode = ObjectMemoryIntegerObjectOf(code);
	}
	void SetPrimitiveFailureData(Oop failureData)
	{
		ObjectMemory::countDown(m_primitiveFailureData);
		ObjectMemory::countUp(failureData);
		m_primitiveFailureData = failureData;
	}
	void SetPrimitiveFailureData(OTE* failureData)
	{
		ObjectMemory::countDown(m_primitiveFailureData);
		failureData->countUp();
		m_primitiveFailureData = reinterpret_cast<Oop>(failureData);
	}
	void SetPrimitiveFailureData(SMALLINTEGER failureData)
	{
		ObjectMemory::countDown(m_primitiveFailureData);
		m_primitiveFailureData = ObjectMemoryIntegerObjectOf(failureData);
	}
	SMALLUNSIGNED CallbackDepth() const { return ObjectMemoryIntegerValueOf(m_callbackDepth); }
	void IncrementCallbackDepth()
	{
		HARDASSERT(ObjectMemoryIsIntegerObject(m_callbackDepth));
		m_callbackDepth += 2;	// increase callback depth
	}
	void DecrementCallbackDepth()
	{
		HARDASSERT(ObjectMemoryIsIntegerObject(m_callbackDepth) && m_callbackDepth > ZeroPointer);
		m_callbackDepth -= 2;
		if (m_callbackDepth <= 0)
			m_callbackDepth = ZeroPointer;
	}
	void BasicSetCallbackDepth(Oop depth) { m_callbackDepth = depth; }

	void SetThread(void* handle)
	{
		ObjectMemory::storePointerWithUnrefCntdValue(m_thread, Oop(handle)+1);
	}
	void* Thread() const { return m_thread == reinterpret_cast<Oop>(Pointers.Nil) ? 0 : (void*)(m_thread-1); }
	void ClearThread() { m_thread = reinterpret_cast<Oop>(Pointers.Nil); }
	void NewOverlapSemaphore();
	SemaphoreOTE* OverlapSemaphore() const { return m_waitOverlap; }

	// Used by ObjectMemory when loading the image - patches up the rehydrated process
	void PostLoadFix(ProcessOTE* oteThis);
};

typedef TOTE<Process> ProcessOTE;
ostream& operator<<(ostream& st, const ProcessOTE*);

class ProcessList : public SequenceableCollection
{
public:
	ProcessOTE* m_firstLink;
	ProcessOTE* m_lastLink;
	enum { FirstLinkIndex=SequenceableCollection::FixedSize, LastLinkIndex, FixedSize };

	bool isEmpty();
	void addLast(ProcessOTE* aLink);
	ProcessOTE* removeFirst();
	ProcessOTE* remove(ProcessOTE* aLink);
};

class Semaphore;
typedef TOTE<Semaphore> SemaphoreOTE;

class Semaphore : public ProcessList
{
public:
	Oop m_excessSignals;
	enum { ExcessSignalsIndex = ProcessList::FixedSize };

	DWORD Wait(SemaphoreOTE* oteThis, ProcessOTE* oteProcess, int nTimeout);

	static SemaphoreOTE* New(int sigs=0);
};

#ifdef _DEBUG
	ostream& operator<<(ostream& st, const Semaphore& sem);
#endif

// ProcessorScheduler has a single instance "Processor" (a global variable)
class ProcessorScheduler //: public Object
{
public:
	ArrayOTE* m_processLists;		// N.B. An array of lists
	ProcessOTE* m_activeProcess;
	SemaphoreOTE* m_pendingReturns;
	OTE* m_comStubs;
	Oop  m_unused;
	SemaphoreOTE* m_pendingTerms;
	
	enum { ProcessListsIndex=ObjectFixedSize, ActiveProcessIndex, PendingReturns, 
			ComStubsIndex, Reserved1, PendingTermsIndex, FixedSize };

	#ifdef _DEBUG
		bool IsValid();
	#endif
};

typedef TOTE<ProcessorScheduler> SchedulerOTE;

#ifdef _DEBUG
	ostream& operator<<(ostream& st, const ProcessorScheduler& proc);
#endif

///////////////////////////////////////////////////////////////////////////////
// Recalculcate the size of the process from the supplied stack pointer, and save it down
// into the process. Usually done before switching processes, but may also want to do this
// when accessing the active frame using the 'thisContext' pseudo variable.
inline void Process::sizeToSP(ProcessOTE* oteMe, Oop* sp) const
{
	MWORD words = sp - reinterpret_cast<const Oop*>(this) + 1;
	oteMe->setSize(words*sizeof(MWORD));
}

inline void InterpreterRegisters::ResizeProcess()
{
	HARDASSERT(m_pActiveProcess != NULL);
	MWORD words = m_stackPointer - reinterpret_cast<const Oop*>(activeProcess()) + 1;
	m_oteActiveProcess->setSize(words*sizeof(MWORD));
}

///////////////////////////////////////////////////////////////////////////////

#ifdef _DEBUG
	inline bool ProcessorScheduler::IsValid()
	{
		return true;
	}

	inline bool Process::IsValid()
	{
		return true;
	}
#endif

#endif
