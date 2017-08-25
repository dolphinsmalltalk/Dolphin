/******************************************************************************

	File: STProcess.h

	Description:

	VM representation of execution related Smalltalk classes.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once
#include <stddef.h>
#include <float.h>

#include "STVirtualObject.h"
#include "STStackFrame.h"

// Declare forward references
struct InterpreterRegisters;
class OverlappedCall;
namespace ST
{
	class Process;
	class LinkedList;
	class Semaphore;
	class ProcessorScheduler;
}
typedef TOTE<ST::Process> ProcessOTE;
typedef TOTE<ST::LinkedList> LinkedListOTE;
typedef TOTE<ST::Semaphore> SemaphoreOTE;
typedef TOTE<ST::ProcessorScheduler> SchedulerOTE;

namespace ST
{
	// Really a subclass of Link, but VM doesn't care about that
	class Process : public Object
	{
	private:
		// Really a member of Link superclass
		ProcessOTE*		m_nextLink;
		Oop				m_suspendedFrame;
		Oop				m_priority;
		LinkedListOTE*	m_myList;
		Oop				m_callbackDepth;
		Oop				m_primitiveFailureCode;
		Oop				m_primitiveFailureData;
		Oop				m_fpControl;
		SemaphoreOTE*	m_waitOverlap;
		Oop				m_thread;

	private:
		// Process contains these additional fields after this point, but we do not access them from the VM
		OTE* m_exceptionEnvironment;
		Oop m__alreadyPrinted;
		Oop m_reserved1;
		OTE* m_debugger;
		OTE* m_name;			// Note this can be an Oop, but normally isn't
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
			return (oteMe->getSize() - offsetof(Process, m_stack[0])) / sizeof(MWORD);
		}

		SMALLUNSIGNED indexOfSP(Oop* sp)
		{
			return SMALLUNSIGNED(sp - m_stack) + 1;
		}

		SMALLUNSIGNED indexOfFramePointer(Oop framePointer)
		{
			return indexOfSP(reinterpret_cast<Oop*>(framePointer - 1));
		}

		StackFrame* suspendedFrame() { return (StackFrame*)(m_suspendedFrame - 1); }
		//void SetSuspendedFrame(InterpreterRegisters& registers);		// Store down current frame in prep. for suspend (also resize to SP)

		VirtualObjectHeader* getHeader() const
		{
			return reinterpret_cast<VirtualObjectHeader*>(const_cast<Process*>(this)) - 1;
		}

		///////////////////////////////////////////////////////////////////////////
		// Helpers for overlapped calls

		OverlappedCall* GetOverlappedCall();

		// Suspend any active overlapped call thread associated with the receiver, if any
		bool SuspendOverlappedCall();
		// Resume any active overlapped call thread associated with the receiver, if any
		bool ResumeOverlappedCall();

		Oop Name() const { return reinterpret_cast<Oop>(m_name); }
		bool IsWaiting() const { return !m_myList->isNil(); }
		bool IsWaitingOn(const LinkedListOTE* oteList) const { return m_myList == oteList; }
		bool IsReady() const;
		LinkedListOTE* SuspendingList() const { return m_myList; }
		ProcessOTE* Next() const { return m_nextLink; }
		void SetSuspendingList(LinkedListOTE* oteList)
		{
			HARDASSERT(m_myList->isNil());
			oteList->countUp();
			m_myList = oteList;
		}
		void ClearList()
		{
			NilOutPointer(m_myList);
		}
		void BasicClearNext();
		void BasicSetNext(ProcessOTE* oteNext) { m_nextLink = oteNext; }
		void SetNext(ProcessOTE* oteNext);
		Oop SuspendedFrame() const { return m_suspendedFrame; }
		void SetSuspendedFrame(Oop intPointer)
		{
			HARDASSERT(isIntegerObject(intPointer));
			m_suspendedFrame = intPointer;
		}
		void ClearSuspendedFrame();

		DWORD FpControl() const
		{
			ASSERT(isIntegerObject(m_fpControl));
			return integerValueOf(m_fpControl);
		}

		void ResetFP() const
		{
			_clearfp();
			// Note that we use _control87 to allow for control over the denormal exception mask. Denormal exceptions are masked by default 
			// on x86, and _controlfp_s does not allow this to be changed. We also want to mask denormal exceptions by default, but also
			// want to allow this to be changed for experimentation and testing.
			_control87(FpControl(), _MCW_DN | _MCW_EM | _MCW_IC | _MCW_PC | _MCW_RC);
		}

		void RestoreFP() const
		{
			VirtualObjectHeader* header = getHeader();
			if (!header->fxRestore())
			{
				ResetFP();
			}
		}

		void SaveFP()
		{
			getHeader()->fxSave();
		}

		SMALLUNSIGNED Priority() const
		{
			HARDASSERT(isIntegerObject(m_priority));
			return integerValueOf(m_priority);
		}
		void SetPriority(SMALLUNSIGNED priority)
		{
			m_priority = integerObjectOf(priority);
		}
		SMALLINTEGER PrimitiveFailureCode()
		{
			return isIntegerObject(m_primitiveFailureCode) ? integerValueOf(m_primitiveFailureCode) : 0;
		}
		Oop PrimitiveFailureData() const { return m_primitiveFailureData; }
		void SetPrimitiveFailureCode(SMALLINTEGER code);
		void SetPrimitiveFailureData(Oop failureData);
		void SetPrimitiveFailureData(OTE* failureData);
		void SetPrimitiveFailureData(SMALLINTEGER failureData);
		SMALLUNSIGNED CallbackDepth() const { return integerValueOf(m_callbackDepth); }
		void IncrementCallbackDepth()
		{
			HARDASSERT(isIntegerObject(m_callbackDepth));
			m_callbackDepth += 2;	// increase callback depth
		}
		void DecrementCallbackDepth()
		{
			HARDASSERT(isIntegerObject(m_callbackDepth) && m_callbackDepth > ZeroPointer);
			m_callbackDepth -= 2;
			if (m_callbackDepth <= 0)
				m_callbackDepth = ZeroPointer;
		}
		void BasicSetCallbackDepth(Oop depth) { m_callbackDepth = depth; }

		void SetThread(void* handle);
		void* Thread() const { return m_thread == reinterpret_cast<Oop>(Pointers.Nil) ? 0 : (void*)(m_thread - 1); }
		void ClearThread() { m_thread = reinterpret_cast<Oop>(Pointers.Nil); }
		void NewOverlapSemaphore();
		SemaphoreOTE* OverlapSemaphore() const { return m_waitOverlap; }

		// Used by ObjectMemory when loading the image - patches up the rehydrated process
		void PostLoadFix(ProcessOTE* oteThis);
	};

	class LinkedList : public SequenceableCollection
	{
	public:
		ProcessOTE* m_firstLink;
		ProcessOTE* m_lastLink;
		enum { FirstLinkIndex = SequenceableCollection::FixedSize, LastLinkIndex, FixedSize };

		bool isEmpty();
		void addLast(ProcessOTE* aLink);
		ProcessOTE* removeFirst();
		ProcessOTE* remove(ProcessOTE* aLink);
	};

	class Semaphore : public LinkedList
	{
	public:
		Oop m_excessSignals;
		enum { ExcessSignalsIndex = LinkedList::FixedSize };

		DWORD Wait(SemaphoreOTE* oteThis, ProcessOTE* oteProcess, int nTimeout);

		static SemaphoreOTE* New(int sigs = 0);
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

		enum {
			ProcessListsIndex = ObjectFixedSize, ActiveProcessIndex, PendingReturns,
			ComStubsIndex, Reserved1, PendingTermsIndex, FixedSize
		};

#ifdef _DEBUG
		bool IsValid();
#endif
	};

	///////////////////////////////////////////////////////////////////////////////
	// Recalculcate the size of the process from the supplied stack pointer, and save it down
	// into the process. Usually done before switching processes, but may also want to do this
	// when accessing the active frame using the 'thisContext' pseudo variable.
	inline void Process::sizeToSP(ProcessOTE* oteMe, Oop* sp) const
	{
		MWORD words = sp - reinterpret_cast<const Oop*>(this) + 1;
		oteMe->setSize(words*sizeof(MWORD));
	}

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
}

ostream& operator<<(ostream& st, const ProcessOTE*);

#ifdef _DEBUG
	ostream& operator<<(ostream& st, const ST::ProcessorScheduler& proc);
#endif

