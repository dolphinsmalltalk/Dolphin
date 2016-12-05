/******************************************************************************

	File: Interprt.Inl

	Description:

	Public inlines for the interpreter bodules

******************************************************************************/
#pragma once

#ifndef CHECKREFERENCES
	#error You'll need to include interprt.h
#endif

#include "STString.h"
#include "STExternal.h"
#include "STFloat.h"
#include "STInteger.h"

inline void Interpreter::GrabAsyncProtect()
{
	::EnterCriticalSection(&m_csAsyncProtect);
}

inline void Interpreter::RelinquishAsyncProtect()
{
	::LeaveCriticalSection(&m_csAsyncProtect);
}

//=============
//Stack Inlines 
//=============

#define stackValue(offset) (*(Interpreter::m_registers.m_stackPointer - (offset)))
#define pop(number) (Interpreter::m_registers.m_stackPointer -=(number))
#define popStack()	(*Interpreter::m_registers.m_stackPointer--)
#define stackTop()	(*Interpreter::m_registers.m_stackPointer)

inline void Interpreter::push(LPCSTR pStr)
{
	if (pStr)
		pushNewObject(String::New(pStr));
	else
		pushNil();
}

inline void Interpreter::pushHandle(HANDLE h)
{
	if (h)
		pushNewObject(ExternalHandle::New(h));
	else
		pushNil();
}

inline void Interpreter::push(double d)
{
	pushNewObject(Float::New(d));
}

inline void Interpreter::pushNil()
{
	push(Oop(Pointers.Nil));
}

inline void Interpreter::pushSmallInteger(SMALLINTEGER n)
{
	push(ObjectMemoryIntegerObjectOf(n));
}

inline void Interpreter::pushUnsigned32(DWORD dwValue)
{
	pushNewObject(Integer::NewUnsigned32(dwValue));
}

inline void Interpreter::pushUIntPtr(UINT_PTR uptrValue)
{
	pushNewObject(Integer::NewUIntPtr(uptrValue));
}

inline void Interpreter::pushSigned32(SDWORD lValue)
{
	pushNewObject(Integer::NewSigned32(lValue));
}

inline void Interpreter::pushIntPtr(INT_PTR ptrValue)
{
	pushNewObject(Integer::NewIntPtr(ptrValue));
}

inline void Interpreter::pushBool(BOOL bValue)
{
	push(Oop(bValue == 0 ? Pointers.False : Pointers.True));
}

inline void Interpreter::pushNewObject(Oop oop)
{
	if (ObjectMemoryIsIntegerObject(oop))
		push(oop);
	else
		pushNewObject(reinterpret_cast<OTE*>(oop));
}

inline void Interpreter::push(Oop object)
{
	// Unfortunately the Compiler generate code with an AGI penalty for this by
	// performing the +1 before writing through the new SP, and I can't persuade
	// it to use an instruction with an offset
	Oop* sp = m_registers.m_stackPointer;
	sp[1] = object;
	m_registers.m_stackPointer = sp+1;
	
	// This does cause it to use an offset, but the ++ causes it to read the global variable twice
	//(m_registers.m_stackPointer++)[1] = object;
}

inline Oop Interpreter::replaceStackTopWith(OTE* object)
{
	return *m_registers.m_stackPointer = Oop(object);
}

inline Oop Interpreter::replaceStackTopWith(Oop oop)
{
	return *m_registers.m_stackPointer = oop;
}

inline Oop Interpreter::replaceStackTopWithNew(Oop oop)
{
	if (ObjectMemoryIsIntegerObject(oop))
		*m_registers.m_stackPointer = oop;
	else
		replaceStackTopWithNew(reinterpret_cast<OTE*>(oop));
	return oop;
}

inline Oop Interpreter::replaceStackTopWithNew(double fValue)
{
	return 	replaceStackTopWithNew(Float::New(fValue));
}

inline Oop Interpreter::popAndCountUp()
{
	Oop top = *m_registers.m_stackPointer--;
	ObjectMemory::countUp(top);
	return top;
}

///////////////////////////////////////////////////////////////////////////////
// Object field access

#ifndef _M_IX86
	// Intel version in assembler (see primitiv.cpp)
	inline int __fastcall smalltalkMod(int numerator, int denominator)
	{
		SMALLINTEGER quotient = numerator/denominator;
		quotient = quotient - (quotient < 0 && quotient*denominator!=numerator);
		return numerator - (quotient * denominator);
	}
#else
	// See primasm.asm
	extern int __fastcall smalltalkMod(int numerator, int denominator);
#endif

inline bool Interpreter::IsShuttingDown()
{
	return m_bShutDown;
}

inline DWORD Interpreter::MainThreadId()
{
	return m_dwThreadId;
}

inline HANDLE Interpreter::MainThreadHandle()
{
	return m_hThread;
}

inline InterpreterRegisters& Interpreter::GetRegisters() 
{
	return m_registers; 
}


inline BOOL Interpreter::isAFloat(Oop objectPointer)
{
	return ObjectMemory::fetchClassOf(objectPointer) == Pointers.ClassFloat;
}

#ifdef PROFILING
	#define STARTPROFILING() Interpreter::StartProfiling()
	#define STOPPROFILING()	 Interpreter::StopProfiling()
#else
	#define STARTPROFILING()
	#define STOPPROFILING()
#endif

inline void Interpreter::sendSelectorArgumentCount(SymbolOTE* selector, unsigned argCount)
{
	m_oopMessageSelector = selector;
	sendSelectorToClass(ObjectMemory::fetchClassOf(stackValue(argCount)), argCount);
}

inline void Interpreter::sendSelectorToClass(BehaviorOTE* classPointer, unsigned argCount)
{
	MethodOTE* methodPointer = findNewMethodInClass(classPointer, argCount);
	executeNewMethod(methodPointer, argCount);
}

inline void	Interpreter::NotifyAsyncPending()
{
	::InterlockedExchange((LPLONG)m_pbAsyncPending, TRUE);
}

#define ACEAt(cache,offset) (reinterpret_cast<AtCacheEntry*>(reinterpret_cast<BYTE*>(&cache[0])+atCacheOffset))

inline void Interpreter::purgeObjectFromCaches(OTE* ote)
{
	unsigned atCacheOffset = Oop(ote) & Interpreter::AtCacheMask;
	AtCacheEntry* ace = ACEAt(AtCache, atCacheOffset);
	if (ace->oteArray == ote)
		ace->oteArray = NULL;
	ace = ACEAt(AtPutCache, atCacheOffset);
	if (ace->oteArray == ote)
		ace->oteArray = NULL;
}

inline void Interpreter::IncStackRefs()
{
	m_registers.IncStackRefs();
}

inline void Interpreter::DecStackRefs()
{
	m_registers.DecStackRefs();
}

inline void InterpreterRegisters::IncStackRefs()
{
	Process* pProcess = activeProcess();
	Oop* sp = m_stackPointer;
	for (Oop* pOop = pProcess->m_stack;pOop <= sp;pOop++)
		ObjectMemory::countUp(*pOop);
}

inline void InterpreterRegisters::DecStackRefs()
{
	Process* pProcess = activeProcess();
	Oop* sp = m_stackPointer;
	for (Oop* pOop = pProcess->m_stack;pOop <= sp;pOop++)
		ObjectMemory::countDown(*pOop);
}

///////////////////////////////////////////////////////////////////////////////
// Finalization/Bereavement 

// The argument has had a temporary reprieve; we place it on the finalization queue to permit it to
// fulfill its last requests. At the moment the queue is FILO.

inline void Interpreter::basicQueueForFinalization(OTE* ote)
{
	ASSERT(!isIntegerObject(ote));
	ASSERT(!ObjectMemory::isPermanent(ote));
	// Must keep the OopsPerEntry constant in sync. with num objects pushed here
	m_qForFinalize.Push(ote);
}

inline void Interpreter::queueForFinalization(OTE* ote, int highWater)
{
	basicQueueForFinalization(ote);
	asynchronousSignal(Pointers.FinalizeSemaphore);

	unsigned count = m_qForFinalize.Count();
	// Only raise interrupt when high water mark is hit!
	if (count == static_cast<unsigned>(highWater))
		queueInterrupt(VMI_HOSPICECRISIS, ObjectMemoryIntegerObjectOf(count));
}

inline void Interpreter::queueForBereavementOf(OTE* ote, Oop argPointer)
{
	// Must keep the OopsPerEntry constant in sync. with num objects pushed here
	m_qBereavements.Push(reinterpret_cast<Oop>(ote));
	m_qBereavements.Push(argPointer);
}

///////////////////////////////////////////////////////////////////////////////
// FFI support

inline AddressOTE* ST::ExternalAddress::New(void* ptr)
{
	return reinterpret_cast<AddressOTE*>(Interpreter::NewDWORD(DWORD(ptr), Pointers.ClassExternalAddress));
}

inline HandleOTE* ST::ExternalHandle::New(HANDLE hValue)
{
	return reinterpret_cast<HandleOTE*>(Interpreter::NewDWORD(DWORD(hValue), Pointers.ClassExternalHandle));
}

