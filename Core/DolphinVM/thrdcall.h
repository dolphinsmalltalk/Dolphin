/******************************************************************************

	File: thrdcall.h

	Description:

	External threaded calls.

******************************************************************************/
#pragma once

#include "Ist.h"
#include "Interprt.h"

#ifdef _DEBUG
#define TRACING 1
#else
#define TRACING 0
#endif

template<class T> class SmartPtr
{
	T* m_pObj;

private:
	void AddRef()
	{
		if (m_pObj) 
			m_pObj->AddRef();
	}

	void Release()
	{
		if (m_pObj)
			m_pObj->Release();
	}

public:

	// Constructors
	SmartPtr() : m_pObj(0) {}

	SmartPtr(T* p, bool bAddRef=true) : m_pObj(p)
	{
		if (bAddRef)
			AddRef();
	}

	// Copy constructor
	SmartPtr(const SmartPtr& other) : m_pObj(other.m_pObj)
	{
		AddRef();
	}

	// Move constructor
	SmartPtr(SmartPtr&& other) noexcept : m_pObj(other.m_pObj)
	{
		other.m_pObj = nullptr;
	}

	// Destructor
	~SmartPtr()
	{
		Release();
	}

	// Assignments
	SmartPtr& operator=(T* p)
	{
		if (p)
			p->AddRef();
		Release();
		m_pObj = p;
		return *this;
	}

	SmartPtr& operator=(const SmartPtr& cp)
	{ 
		return operator=(cp.m_pObj); 
	}

	SmartPtr& operator=(SmartPtr&& other) noexcept
	{
		if (this != &other) 
		{
			Release();
			m_pObj = other.m_pObj;
			other.m_pObj = nullptr;
		}
		return *this;
	}

	T* operator->() const
	{
		return m_pObj; 
	}

	T& operator*() const
	{
		_ASSERTE(m_pObj);
		// Will GPF if m_pObj is NULL
		return *m_pObj;
	}

	operator T*() const
	{
		return m_pObj;
	}
	
	operator bool() const
	{ 
		return m_pObj != NULL; 
	}
};

class OverlappedCall;
typedef SmartPtr<OverlappedCall> OverlappedCallPtr;

template <class T> class DoubleLink
{
	T* prev;
	T* next;

public:
	DoubleLink() : prev(NULL), next(NULL) {}

	T* Next() const { return next; }

	T* Unlink()
	{
		// next null if last link in list
		if (next)
			next->prev = prev;
		// prev pointer normally valid because there is an anchor node, but when shutting
		// down will already have been unlinked from the list
		if (prev)
			prev->next = next;
		next = prev = NULL;

		return static_cast<T*>(this);
	}

	void LinkAfter(T* prevArg)
	{
		T* pThis = static_cast<T*>(this);
		this->next = prevArg->next;
		if (this->next)
			this->next->prev = pThis;
		this->prev = prevArg;
		prevArg->next = pThis;
	}
};

template <class T> class DoublyLinkedList
{
	DoubleLink<T> anchor;
public:
	T* First() const
	{
		return anchor.Next();
	}

	bool IsEmpty() const
	{
		return First() == NULL;
	}

	T* RemoveFirst()
	{
		T* node = First();
		if (node != NULL)
			node->Unlink();
		return node;
	}

	void AddFirst(T* node)
	{
		// Slightly nasty thing is that anchor node is not actually the same type as
		// the other nodes, so we need a cast here.
		node->LinkAfter(reinterpret_cast<T*>(&anchor));
	}
};

class OverlappedCall;
typedef DoublyLinkedList<OverlappedCall> OverlappedCallList;

class ExceptionInfo : public EXCEPTION_POINTERS
{
	EXCEPTION_RECORD m_exceptionRecord;
	CONTEXT m_contextRecord;
public:
	ExceptionInfo()
	{
		ZeroMemory(&m_exceptionRecord, sizeof(m_exceptionRecord));
		ZeroMemory(&m_contextRecord, sizeof(m_contextRecord));
		ExceptionRecord = &m_exceptionRecord;
		ContextRecord = &m_contextRecord;
	}
	void Copy(const LPEXCEPTION_POINTERS& pExInfo);
};

class OverlappedCall : public DoubleLink<OverlappedCall>
{
public:
	// Allocate/free methods for maintaining pool of available blocks
	bool QueueTerminate();

	friend std::wostream& operator<<(std::wostream& stream, const OverlappedCall& oc);

	uint32_t AddRef();
	uint32_t Release();

	enum class States { Terminated, Unwinding, Starting, Ready, Pending, Calling, Returned, Completing };

	States beUnwinding();
	States beUnwound();
	// This is only a point in time indication - not thread safe
	bool IsInCall() const { return m_state >= States::Pending; }

private:
	///////////////////////////////////////////////////////////////////////////
	// Private member functions

	OverlappedCall(ProcessOTE*);
	~OverlappedCall();

	Process* GetProcess() 
	{ 
		HARDASSERT((POTE)m_oteProcess != Pointers.Nil);
		return m_oteProcess->m_location; 
	}

	// Start corresponding OS thread
	bool BeginThread();

	void Init();
	void Term();
	void Free();

	void TerminateThread();

	DWORD WaitForRequest();
	int ProcessRequests();
	void PerformCall();
	void ReturnFromFailedCall();
	int CallExceptionFilter(LPEXCEPTION_POINTERS pExInfo);
	void CopyExceptionInfo(const LPEXCEPTION_POINTERS& pExInfo);
	OverlappedCall::States ExchangeState(States exchange);
	OverlappedCall::States ExchangeState(States exchange, States comperand);

	int Main();
	int TryMain();

	// Called from assembler
	void /*thiscall*/ OnCallReturned();
	bool CanComplete();
	void NotifyInterpreterOfCallReturn();

	// Queue a notification to the interpreter thread that an overlapped thread
	// has received a termination signal
	bool NotifyInterpreterOfTermination();
	void WaitForInterpreter();

	void RemoveFromPendingTerminations();

	bool QueueForInterpreter(PAPCFUNC pfnAPC);
	bool QueueForMe(PAPCFUNC pfnAPC);

public:
	///////////////////////////////////////////////////////////////////////////
	// Static member functions

	static void Initialize();
	static void Uninitialize();

	static OverlappedCallPtr GetActiveProcessOverlappedCall();
	_PrimitiveFailureCode Initiate(CompiledMethod* pMethod, argcount_t nArgCount);

	static Semaphore* pendingTerms();

	static void MarkRoots();
	static void OnCompact();

	void OnActivateProcess();

	void SendExceptionInterrupt(Interpreter::VMInterrupts oopInterrupt);

	void CallFailed();

	static int __cdecl IEEEFPHandler(_FPIEEE_RECORD* pIEEEFPException);

#ifdef _DEBUG
	static void ReincrementProcessReferences();
#endif

private:
	// Low-level management routines
	static OverlappedCallPtr New(ProcessOTE*);
	static OverlappedCallPtr RemoveFirstFromList(OverlappedCallList&);

	// Thread entry point function
	static unsigned __stdcall ThreadMain(void* pThis);
	static int MainExceptionFilter(DWORD exceptionCode);

	// APC functions (APCs are used to queue messages between threads)
	static void __stdcall TerminatedAPC(ULONG_PTR param);
	static OverlappedCallPtr BeginAPC(ULONG_PTR param);
	static OverlappedCallPtr BeginMainThreadAPC(ULONG_PTR param);

	static void CompactCallsOnList(OverlappedCallList& list);
	void compact();

	///////////////////////////////////////////////////////////////////////////
	// Static data members
private:

	static OverlappedCallList s_activeList;
	
	static bool s_bShutdown;

	///////////////////////////////////////////////////////////////////////////
	// Data members
public:
	#if TRACING == 1
		tracestream thinDump;
	#endif

	// Context of the process for which we are running
	InterpreterRegisters	m_interpContext;
	ProcessOTE*				m_oteProcess;	// paired Smalltalk Process
	SHAREDLONG				m_nRefs;

	HANDLE					m_hThread;		// thread handle (returned by _beginthread(ex))
	DWORD					m_dwThreadId;	// thread's ID
	HANDLE					m_hEvtGo;		// Set when ready to initiate a call (auto-reset)
	HANDLE					m_hEvtCompleted;// Set when call has completed (auto-reset)

	// Method causing this overlapped call to start executing
	CompiledMethod*			m_pMethod;
	argcount_t				m_nArgCount;
private:
	volatile States			m_state;
	_PrimitiveFailureCode	m_primitiveFailureCode;
	ExceptionInfo*			m_pExInfo;
	_FPIEEE_RECORD*			m_pFpIeeeRecord;

	// We have to use thread local storage to be able to pass in a 'this' pointer to our IEEE FP fault handler because _fpieee_flt doesn't accept a closure parameter and will only call a static function
	thread_local static OverlappedCall* m_pThis;
};


std::wostream& operator<<(std::wostream& stream, const OverlappedCall& oc);

inline uint32_t OverlappedCall::AddRef()
{
	return InterlockedIncrement(&m_nRefs);
}

inline uint32_t OverlappedCall::Release()
{
	uint32_t nRefs = InterlockedDecrement(&m_nRefs);
	if (nRefs == 0)
		delete this;
	return nRefs;
}
