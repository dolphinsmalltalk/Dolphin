/*
============
InterprtInit.cpp
============
Interpreter initialization
*/
							
#include "Ist.h"

#ifndef _DEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#include "Interprt.h"
#include "ObjMem.h"
#include "STProcess.h"
#include "STArray.h"
#include "STBlockClosure.h"

///////////////////////////////////

#pragma code_seg(INIT_SEG)

void Interpreter::initializeVMReferences()
{
	ASSERT(IS_ERROR(EXCEPTION_ACCESS_VIOLATION));

	ObjectMemory::ProtectConstSpace(PAGE_READWRITE);
	// We must obviously re-establish pointers every time
#if defined(_DEBUG)
	if (_Pointers.VMReferences == reinterpret_cast<ArrayOTE*>(Pointers.Nil))
	{
		ArrayOTE* newArray = Array::New(VMREFSINITIAL);
		_Pointers.VMReferences = reinterpret_cast<ArrayOTE*>(newArray);
		newArray->beSticky();
	}

	m_nMaxVMRefs = _Pointers.VMReferences->pointersSize();
	m_pVMRefs = _Pointers.VMReferences->m_location->m_elements;

	ASSERT(m_nMaxVMRefs >= VMREFSINITIAL);

	// Now set up the free list
	const auto loopEnd = m_nMaxVMRefs;
	for (auto i=0;i<loopEnd;i++)
		m_pVMRefs[i] = ObjectMemoryIntegerObjectOf(i+1);
	m_nFreeVMRef = 0;
#else
	ObjectMemory::storePointerWithValue((Oop&)_Pointers.VMReferences, _Pointers.Nil);
#endif

	// Defensive - if this object is changed, it'll all go horribly wrong, so attempt a repair
	if (ObjectMemory::fetchClassOf((Oop)_Pointers.MarkedBlock) != _Pointers.ClassBlockClosure)
	{
		PointersOTE* markedBlock = ObjectMemory::newFixedPointerObject<BlockClosure::FixedSize>(_Pointers.ClassBlockClosure);
		_Pointers.MarkedBlock = reinterpret_cast<BlockOTE*>(markedBlock);
		_Pointers.MarkedBlock->beImmutable();
	}

	BlockClosure* block = _Pointers.MarkedBlock->m_location;
	block->m_outer = _Pointers.Nil;
	block->m_method = reinterpret_cast<MethodOTE*>(_Pointers.Nil);
	block->m_receiver = reinterpret_cast<Oop>(_Pointers.Nil);
	*reinterpret_cast<Oop*>(&block->m_info) = ZeroPointer;
	block->m_initialIP = ZeroPointer;

	// Initialize the various VM circular queues
	if (isNil(_Pointers.SignalQueue))
	{
		_Pointers.SignalQueue = Array::New(SignalQueueSize);
	}
	ASSERT(_Pointers.SignalQueue->m_oteClass == _Pointers.ClassArray);
	m_qAsyncSignals.UseBuffer(_Pointers.SignalQueue, SignalQueueGrowth, true);

	if (isNil(_Pointers.InterruptQueue))
	{
		_Pointers.InterruptQueue = Array::New(InterruptQueueSize);
	}
	ASSERT(_Pointers.InterruptQueue->m_oteClass == _Pointers.ClassArray);
	m_qInterrupts.UseBuffer(_Pointers.InterruptQueue, InterruptQueueGrowth, false);

	ArrayOTE* finalizeQueue = _Pointers.FinalizeQueue;
	ASSERT(finalizeQueue->m_oteClass == Pointers.ClassArray);
	m_qForFinalize.UseBuffer(finalizeQueue, FinalizeQueueGrowth, true);

	ArrayOTE* bereavementQueue = _Pointers.BereavementQueue;
	ASSERT(bereavementQueue->m_oteClass == Pointers.ClassArray);
	m_qBereavements.UseBuffer(bereavementQueue, BereavementQueueGrowth, true);

	ObjectMemory::InitializeMemoryManager();

	m_pProcessor = _Pointers.Scheduler->m_location;

	if (ObjectMemory::fetchClassOf(Oop(_Pointers.EmptyString)) != _Pointers.ClassUtf8String)
	{
		_Pointers.EmptyString = Utf8String::New(u8"", 0);
		_Pointers.EmptyString->beImmutable();
	}

	ObjectMemory::ProtectConstSpace(PAGE_READONLY);

	ObjectMemory::addVMRefs();
}

void Interpreter::sendStartup(const wchar_t* szImagePath, uintptr_t arg)
{
	// Boost the priority so runs to exclusion of other processes (except timing and weak
	// collection repair)
	actualActiveProcess()->SetPriority(8);
	
	// Construct argument array
	ArrayOTE* oteArgs = Array::NewUninitialized(2);
	Array* args = oteArgs->m_location;
	Utf16StringOTE* string = Utf16String::New(szImagePath);
	args->m_elements[0] = reinterpret_cast<Oop>(string);
	string->m_count = 1;
	args->m_elements[1] = Integer::NewUIntPtr(arg);
	ObjectMemory::countUp(args->m_elements[1]);
	// We no longer need to ref. count things we push on the stack, sendVMInterrupt will count
	// down the argument after it has pushed it on the stack, possibly causing its addition to the Zct
	oteArgs->m_count = 1;
	sendVMInterrupt(VMInterrupts::Started, reinterpret_cast<Oop>(oteArgs));
}
