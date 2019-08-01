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

#define primitiveSuccess(argCount) (Interpreter::m_registers.m_stackPointer - argCount)

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

inline void Interpreter::push(LPCSTR pStr)
{
	if (pStr)
		pushNewObject((OTE*)AnsiString::New(pStr));
	else
		pushNil();
}

inline void Interpreter::pushHandle(HANDLE h)
{
	if (h)
		pushNewObject((OTE*)ExternalHandle::New(h));
	else
		pushNil();
}

inline void Interpreter::push(double d)
{
	pushNewObject((OTE*)Float::New(d));
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
	Oop* const sp = m_registers.m_stackPointer;
	sp[1] = object;
	m_registers.m_stackPointer = sp+1;
}

inline Oop Interpreter::popAndCountUp()
{
	Oop top = *m_registers.m_stackPointer--;
	ObjectMemory::countUp(top);
	return top;
}

// Functor to write a 32-bit signed integer to a stack location - used in primitives
struct StoreSigned32
{
	__forceinline void operator()(Oop* const sp, int32_t value)
	{
		if (ObjectMemoryIsIntegerValue(value))
		{
			*sp = ObjectMemoryIntegerObjectOf(value);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewSigned32(value);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

// Functor to write a 32-bit positive integer to a stack location - used in primitives
struct StoreUnsigned32
{
	__forceinline void operator()(Oop* const sp, uint32_t dwValue)
	{
		if (ObjectMemoryIsPositiveIntegerValue(dwValue))
		{
			*sp = ObjectMemoryIntegerObjectOf(dwValue);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewUnsigned(dwValue);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

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
	sendSelectorToClass(ObjectMemory::fetchClassOf(*(m_registers.m_stackPointer - argCount)), argCount);
}

inline void Interpreter::sendSelectorToClass(BehaviorOTE* classPointer, unsigned argCount)
{
	MethodCacheEntry* pEntry = findNewMethodInClass(classPointer, argCount);
	executeNewMethod(pEntry->method, argCount);
}

inline void	Interpreter::NotifyAsyncPending()
{
	InterlockedExchange(m_pbAsyncPending, TRUE);
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
	ASSERT(ote->isWeak());
	ASSERT(ObjectMemoryIsIntegerObject(argPointer));

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

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

template <int Index> Oop* __fastcall Interpreter::primitiveReturnConst(Oop* const sp, unsigned argCount)
{
	Oop* newSp = sp - argCount;
	if (!m_bStepping)
	{
		*newSp = Pointers.pointers[Index - 1];
		return newSp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::DebugStep);
	}
}
