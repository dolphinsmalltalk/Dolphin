/******************************************************************************

	File: ByteCde.cpp

	Description:

	Implementation of the Interpreter class' byte code interpretation
	methods.

******************************************************************************/
#include "Ist.h"
#pragma code_seg(INTERP_SEG)

#include "ObjMem.h"
#include "Interprt.h"

#include "rc_vm.h"
#include "InterprtProc.inl"
#include "VMExcept.h"

// This module is all about the execution machinery of the VM
#include "STBehavior.h"
#include "STProcess.h"
#include "STMethod.h"
#include "STMessage.h"
#include "STArray.h"
#include "STHashedCollection.h"	// For MethodDictionary
#include "STContext.h"
#include "STBlockClosure.h"
#include "STAssoc.h"

#if defined(_DEBUG)
	#include "STClassDesc.h"
#endif

// The performance of the shortcut primitive implementations for methods that return self, literal zero, etc,
// is important to overall system performance, so it is worth retaining assembler implementations, although 
// the carefully ordered C++ versions are not too bad. They sometimes push/pop some registers when
// that is not strictly necessary, partly because the compiler doesn't realise that sp is also in ESI
#ifdef _M_IX86
__declspec(naked) Oop* PRIMCALL Interpreter::primitiveReturnSelf(Oop* const sp, primargcount_t argCount)
{
	_asm
	{
		lea		edx, [edx * 4]
		sub		ecx, edx
		cmp		[m_bStepping], 0
		mov		eax, 90000009H
		cmovz	eax, ecx
		ret
	}
}

using namespace ST;

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveReturnLiteralZero(Oop* const sp, primargcount_t argCount)
{
	_asm
	{
		mov		eax, ecx
		lea		edx, [edx * 4]
		mov		ecx, [m_registers.m_oopNewMethod]
		sub		eax, edx
		mov		ecx, [ecx]OTE.m_location
		cmp		[m_bStepping], 0
		mov		ecx, [ecx]CompiledMethod.m_aLiterals[0]
		jne		debugStep
		mov		[eax], ecx
		ret
	debugStep :
		mov		eax, 90000009H
		ret
	}
}

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveReturnStaticZero(Oop* const sp, primargcount_t argCount)
{
	_asm
	{
		mov		ecx, [m_registers.m_oopNewMethod]
		mov		eax, esi
		mov		ecx, [ecx]OTE.m_location
		lea		edx, [edx * 4]
		mov		ecx, [ecx]CompiledMethod.m_aLiterals[0]
		sub		eax, edx
		mov		ecx, [ecx]OTE.m_location
		cmp		[m_bStepping], 0
		mov		ecx, [ecx]VariableBinding.m_value
		jne		debugStep
		mov		[eax], ecx
		ret
	debugStep :
		mov		eax, 90000009H
		ret
	}
}

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveReturnInstVar(Oop* const sp, primargcount_t)
{
	_asm
	{
		// We need a to extract the inst var index from the byte codes, which should be in packed SmallInteger form
		//	1 Nop
		//	2 PushInstVarN
		//	3(inst var index)
		//	4 ReturnStackTop

		mov		ecx, [m_registers.m_oopNewMethod]
		cmp		[m_bStepping], 0
		mov		ecx, [ecx]OTE.m_location
		mov		edx, [esi]								// ecx = receiver Oop at stack top
		movzx	ecx, [ecx]CompiledMethod.m_byteCodes+2	// Get bytecodes into eax - note that it MUST be a SmallInteger
		mov		edx, [edx]OTE.m_location				// edx points at receiver object
		jnz		debugStep
		mov		eax, esi
		mov		edx, [edx]VariantObject.m_fields[ecx*OOPSIZE]
		mov		[esi], edx								// Overwrite receiver with inst.var Oop
		ret

	debugStep:
		mov		eax, 90000009H
		ret
	}
}

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveSetInstVar(Oop* const sp, primargcount_t)
{
	_asm
	{
		mov		ecx, [m_registers.m_oopNewMethod]
		cmp		[m_bStepping], 0
		mov		ecx, [ecx]OTE.m_location
		jne		debugStep
		movzx	eax, [ecx]CompiledMethod.m_byteCodes + 2
		mov		edx, [esi - OOPSIZE]
		cmp		[edx]OTE.m_size, 0
		mov		ecx, [edx]OTE.m_location
		jl		immutable
		lea		eax, [ecx]VariantObject.m_fields[eax * OOPSIZE]

		mov		edx, [esi]
		mov		ecx, [eax]

		test	dl, 1
		jnz		store
		inc		[edx]OTE.m_count
		jnz		store
		mov		[edx]OTE.m_count, 0xff // MAXCOUNT

	store:
		mov		[eax], edx
		call	ObjectMemory::countDown

		lea		eax, [esi - OOPSIZE]
		ret

	immutable:
		mov		eax, 0x800E07FCD	// _PrimitiveFailureCode::AccessViolation
		ret

	debugStep :
		mov		eax, 0x90000009		// _PrimitiveFailureCode::DebugStep
		ret
	}
}

__declspec(naked) Oop* PRIMCALL Interpreter::primitiveSetMutableInstVar(Oop* const sp, primargcount_t)
{
	_asm
	{
		mov		ecx, [m_registers.m_oopNewMethod]
		mov		ecx, [ecx]OTE.m_location
		movzx	eax, [ecx]CompiledMethod.m_byteCodes + 2
		mov		edx, [esi - OOPSIZE]
		mov		ecx, [edx]OTE.m_location
		lea		eax, [ecx]VariantObject.m_fields[eax * OOPSIZE]

		mov		edx, [esi]
		mov		ecx, [eax]

		test	dl, 1
		jnz		store
		inc		[edx]OTE.m_count
		jnz		store
		mov		[edx]OTE.m_count, 0xff // MAXCOUNT

	store:
		mov[eax], edx
		call	ObjectMemory::countDown

		lea		eax, [esi - OOPSIZE]
		ret
	}
}

#else

Oop* PRIMCALL Interpreter::primitiveReturnSelf(Oop* const sp, primargcount_t argCount)
{
	// This arrangement should avoid conditional jumps (can use cmov), but although it has worked
	// on some versions of the VC++ compiler, it is now generate conditional jumps again
	// Given the important of this operation to overall performance, its better to use
	// the hand coded _asm block above here
	Oop* newSp = sp - argCount;
	return !m_bStepping ? newSp : primitiveFailure(_PrimitiveFailureCode::DebugStep);
}

Oop* PRIMCALL Interpreter::primitiveReturnLiteralZero(Oop* const sp, primargcount_t argCount)
{
	Oop literalZero = m_registers.m_oopNewMethod->m_location->m_aLiterals[0];
	Oop* newSp = sp - argCount;
	if (!m_bStepping)
	{
		*newSp = literalZero;
		return newSp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::DebugStep);
	}
}

Oop* PRIMCALL Interpreter::primitiveReturnStaticZero(Oop* const sp, primargcount_t argCount)
{
	auto staticZero = reinterpret_cast<VariableBindingOTE*>(m_registers.m_oopNewMethod->m_location->m_aLiterals[0]);
	if (!m_bStepping)
	{
		Oop* newSp = sp - argCount;
		*newSp = staticZero->m_location->m_value;
		return newSp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::DebugStep);
	}
}

Oop* PRIMCALL Interpreter::primitiveReturnInstVar(Oop* const sp, primargcount_t)
{
	auto byteCodes = m_registers.m_oopNewMethod->m_location->m_packedByteCodes;
	PointersOTE* oteReceiver = reinterpret_cast<PointersOTE*>(*sp);
	auto receiver = oteReceiver->m_location;
	if (!m_bStepping)
	{

		*sp = receiver->m_fields[byteCodes.third];
		return sp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::DebugStep);
	}
}

// Around 8% slower than the assembler version, probably due to extra stack ops to save/restore registers
Oop* PRIMCALL Interpreter::primitiveSetInstVar(Oop* const sp, primargcount_t)
{
	MethodOTE* oteSetter = m_registers.m_oopNewMethod;
	if (!m_bStepping)
	{
		auto pMethod = oteSetter->m_location;
		auto oteReceiver = reinterpret_cast<PointersOTE*>(*(sp - 1));
		if (!oteReceiver->isImmutable())
		{
			auto objReceiver = oteReceiver->m_location;
			auto index = pMethod->m_packedByteCodes.third;
			ObjectMemory::storePointerWithValue(objReceiver->m_fields[index], *sp);
			return sp - 1;
		}
		else
			return primitiveFailure(_PrimitiveFailureCode::AccessViolation);
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::DebugStep);
	}
}

Oop* PRIMCALL Interpreter::primitiveSetMutableInstVar(Oop* const sp, primargcount_t)
{
	MethodOTE* oteSetter = m_registers.m_oopNewMethod;
	auto pMethod = oteSetter->m_location;
	auto oteReceiver = reinterpret_cast<PointersOTE*>(*(sp - 1));
	ObjectMemory::storePointerWithValue(oteReceiver->m_location->m_fields[pMethod->m_packedByteCodes.third], *sp);
	return sp - 1;
}

#endif

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

template <int Index> Oop* PRIMCALL Interpreter::primitiveReturnConst(Oop* const sp, primargcount_t argCount)
{
	Oop* newSp = sp - argCount;
	if (!m_bStepping)
	{
		*newSp = Pointers.pointers[Index - 1];
		return newSp;
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::StepInto);
	}
}

template Oop* PRIMCALL Interpreter::primitiveReturnConst<2>(Oop* const, primargcount_t); // ^false
template Oop* PRIMCALL Interpreter::primitiveReturnConst<3>(Oop* const, primargcount_t); // ^true
template Oop* PRIMCALL Interpreter::primitiveReturnConst<1>(Oop* const, primargcount_t); // ^nil

// In order to keep the message lookup routines 'tight' we ensure that the infrequently executed code
// is in separate routines that will not get inlined. This can make a significant difference to the
// performance of the system (as we've discovered).
#pragma auto_inline(off)

extern "C" void __fastcall callPrimitiveValue(Oop* const sp, argcount_t numArgs);

#ifdef PROFILING
	size_t contextsCopied = 0;
	size_t blocksInstantiated = 0;
	size_t contextReturns = 0;
	size_t methodsActivated = 0;
	size_t contextsSuspended = 0;
	size_t methodsCPPActivated = 0;
	size_t contextCPPReturns = 0;
	size_t contextsCPPSuspended = 0;
	size_t byteCodeCount = 0;
#endif

#ifdef _DEBUG
	#define MAXCACHEMISSES 100000
	size_t cacheHits = 0;
	static size_t cacheMisses = 0;

#endif	

//=============
//Method Lookup
//=============

/*
inline size_t __fastcall Interpreter::cacheHash(Oop classPointer, Oop messageSelector)
{
	// Bits of History paper on method cache recommends latter, but
	// the former is quicker in IST because of the use of real pointers
	// for the Oops - this may change if the Object Table Entry size changes
	// as this hash is optimised for 8 byte entries

// 16 byte OTEs: return ((messageSelector ^ classPointer) >> 4) & (MethodCacheSize-1); 
// 12 byte OTEs: return ((messageSelector ^ classPointer) >> 2) & (MethodCacheSize-1); 
// 8 byte OTEs: return ((messageSelector ^ classPointer) >> 3) & (MethodCacheSize-1);
//	return ((messageSelector + classPointer) >> 3) & (MethodCacheSize-1);
}*/

#pragma code_seg(INTERP_SEG)

inline void Interpreter::ResetInputPollCounter()
{
	// Note that we set to 2, because the sampler interrupt must fire twice before we consider the count down
	// to have expired. This is because the sampler is just firing on a periodic interrupt, and we want at least
	// one whole sampling interval to elapse. The use of a periodic timer avoids the cost of continually resetting
	// the timer each time we process some input.
	// **** N.B. If this is changed, then the same named macro in byteasm.asm must also be changed ***
	InterlockedExchange(&m_nInputPollCounter, 2);
}

inline BOOL Interpreter::sampleInput()
{	
	// Prevent further sampling by resetting the poll counter
	ResetInputPollCounter();

	if (m_nInputPollInterval > 0)
	{
		// Look for any input in the queue, not just for new stuff
		if (((::GetQueueStatus(m_dwQueueStatusMask) >> 16) & m_dwQueueStatusMask) == 0)
		{
			// No input found, reset for next sampling
			ResetInputPollCounter();
		}
		else
		{
			// Note that we must signal the semaphore here because, even though
			// we signal the wakeup event allowing the idle task to restart, the 
			// idler is running at a lower priority so if any background task is
			// running at full tilt it will prevent the idler from signalling
			// the input semaphore itself.
			asynchronousSignal(Pointers.InputSemaphore);
			if (IsUserBreakRequested())
			{
				#ifdef _DEBUG
					WarningWithStackTrace(L"User Interrupt:");
				#endif
				queueInterrupt(VMInterrupts::UserInterrupt, Oop(Pointers.Nil));
			}
			// By setting a Win32 event we guarantee that the image will continue
			// even if about to make a call to MsgWaitForMultipleObjects(), if we
			// don't do this then there is a possible window of opportunity where
			// the UI process will find the queue empty and go to sleep, after which 
			// a message arrives, in the meantime input sampling occurs and GetQueueStatus
			// is called above clearing the "new message" flag that Windows holds.
			// Since MsgWaitForMultipleObjects() only returns when a "new" message
			// arrives, and the call to GetQueueStatus() has made sure that the queue
			// is marked as holding no new messages, this could allow the idle process
			// to send the image into an undesired sleep with the input semaphore signalled.
			// It is very unlikely, but it is possible, and Bill has found that it can
			// happen when using Sockets.
			SetWakeupEvent();
		}
	}

	return m_bAsyncPending;
}

#pragma code_seg(INTERP_SEG)

bool Interpreter::IsUserBreakRequested()
{
	// Note that we want to call GetAsyncKeyState for each key to clear the state
	// so we don't want to early out just because one of the required keys has not
	// been pressed.

	SmallInteger hotkey = integerValueOf(Pointers.InterruptHotKey);
	int vk = hotkey & 0x1FF;
	bool interrupt = (::GetAsyncKeyState(vk) & 0x8001) != 0;
	int modifiers = (hotkey >> 9);
	if (modifiers & FSHIFT)
	{
		interrupt &= (::GetAsyncKeyState(VK_SHIFT) & 0x8001) != 0;
	}
	if (modifiers & FCONTROL)
	{
		interrupt &= (::GetAsyncKeyState(VK_CONTROL) & 0x8001) != 0;
	}
	if (modifiers & FALT)
	{
		interrupt &= (::GetAsyncKeyState(VK_MENU) & 0x8001) != 0;
	}
	return interrupt;
}

BOOL __stdcall Interpreter::BytecodePoll()
{
	if (m_nInputPollCounter <= 0 && !m_bStepping)
		sampleInput();

	return CheckProcessSwitch();
}

BOOL __stdcall Interpreter::MsgSendPoll()
{
	if (m_nInputPollCounter <= 0)
	{
		if (m_bStepping)
		{
			if (++m_nInputPollCounter >= 0)
				disableInterrupts(false);
		}
		// MUST NOT do a PeekMessage here, as this causes synchronisation problems
		// if currently processing a message
		else
			sampleInput();
	}

	return CheckProcessSwitch();
}

Interpreter::MethodCacheEntry* __stdcall Interpreter::findNewMethodInClassNoCache(BehaviorOTE* classPointer, const argcount_t argCount)
{
	HARDASSERT(argCount < 256);

	SymbolOTE* targetSelector = m_oopMessageSelector;					// Loop invariant

	// class/selector pair not in cache
	#ifdef _DEBUG
		if (++cacheMisses > MAXCACHEMISSES)
			DumpCacheStats();
	#endif

	// Lookup the method in the dictionaries of the class & superclass chain
	// Here we manually inline the lookup method for performance reasons as compiler
	// will not inline everything we need from separate routines.
	const Behavior* behavior = classPointer->m_location;
	const SmallUinteger targetSelectorHash = targetSelector->m_idHash;
	do
	{
		const MethodDictOTE* methodDictionary = behavior->m_methodDictionary;
		const MethodDictionary* dict = methodDictionary->m_location;
		if (dict != nullptr)
		{
			// mask is the number of keys in the dictionary (which is pointer size - header - 2) minus 1
			// as the size is a power of 2, thus we can avoid a modulus operation which is relatively slow
			// requiring a division instruction
			SmallUinteger lastKeyIndex = methodDictionary->pointersSize() - (ObjectHeaderSize + MethodDictionary::FixedSize + 1);
			SmallUinteger index = targetSelectorHash & lastKeyIndex;

			bool wrapped = false;
			const SymbolOTE* nextSelector;
			while ((nextSelector = dict->m_selectors[index]) != reinterpret_cast<SymbolOTE*>(Pointers.Nil))
			{
				if (nextSelector == targetSelector)
				{
					// MethodDictionary is IdentityDictionary, which store values as an Array
					const ArrayOTE* methodArray = dict->m_methods;
					HARDASSERT(methodArray->m_oteClass == Pointers.ClassArray);
					MethodOTE* methodPointer = reinterpret_cast<MethodOTE*>(methodArray->m_location->m_elements[index]);
					HARDASSERT(ObjectMemory::isKindOf(methodPointer, Pointers.ClassCompiledMethod));

					// Write back into the cache
					MethodCacheEntry* pEntry = GetCacheEntry(classPointer, targetSelector);
					pEntry->selector = targetSelector;
					pEntry->classPointer = classPointer;
					pEntry->method = methodPointer;
					pEntry->primAddress = (intptr_t)primitivesTable[methodPointer->m_location->m_header.primitiveIndex];

#ifdef _DEBUG
					{
						if (abs(executionTrace) > 1)
						{
							tracelock lock(TRACESTREAM);
							TRACESTREAM<< L"Found method " << classPointer<< L">>" << targetSelector<< L" (" << methodPointer<< L")" << std::endl;
						}
					}
#endif
					return pEntry;
				}
				else
				{
					if (++index > lastKeyIndex)
					{
						// Our IdentityDictionaries should not wrap around more than once, as they
						// are guaranteed to contain empty slots, however there are a couple of corner
						// cases where the dictonaries can be temporarily full after adding a new 
						// element that takes the last slot (e.g. adding 2nd element to dict of capacity 2)
						if (wrapped) break;
						wrapped = true;
						index = 0;
					}
				}
			}
		}
		behavior = behavior->m_superclass->m_location;
	} while (behavior != nullptr);

	// The message was not understood, send a #doesNotUnderstand: to the receiver.
	return messageNotUnderstood(classPointer, argCount);
}

#pragma code_seg(INTERP_SEG)

// Translate args on stack to a message containing an array of arguments
void __fastcall Interpreter::createActualMessage(const argcount_t argCount)
{
	MessageOTE* messagePointer = Message::NewUninitialized();
	Message* message = messagePointer->m_location;
	message->m_selector = m_oopMessageSelector;
	message->m_selector->countUp();
	message->m_args = Array::NewUninitialized(argCount);
	message->m_args->m_count = 1;
	Array* args = message->m_args->m_location;
	
	Oop* const sp = m_registers.m_stackPointer - argCount + 1;

	// Transfer the arguments off the stack to the array
	const auto loopEnd = argCount;
	for (auto i=0u;i<loopEnd;i++)
	{
		Oop oopArg = sp[i];
		ObjectMemory::countUp(oopArg);
		args->m_elements[i] = oopArg;
	}

	*sp = (Oop)messagePointer;
	m_registers.m_stackPointer = sp;
	ObjectMemory::AddToZct((OTE*)messagePointer);
}

ContextOTE* __fastcall Context::New(size_t tempCount, Oop oopOuter)
{
	ContextOTE* newContext;

	#ifdef _DEBUG
	{
		if (ObjectMemoryIsIntegerObject(oopOuter))
		{
		}
		else
		{
			const OTE* oteOuter = reinterpret_cast<const OTE*>(oopOuter);
			if (oteOuter->m_oteClass == Pointers.ClassContext)
			{
				const Context* context = static_cast<Context*>(oteOuter->m_location);
				if (context->isBlockContext())
				{
					HARDASSERT(context->m_block->m_oteClass == Pointers.ClassBlockClosure);
				}
				else
				{
					HARDASSERT(isNil(context->m_block));
				}
			}
			else
				HARDASSERT(isNil(oteOuter));
		}
	}
	#endif

	Context* pContext;

	if (tempCount <= MaxEnvironmentTemps)
	{
		// Can allocate from pool of contexts

		newContext = reinterpret_cast<ContextOTE*>(Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Contexts)].newPointerObject(Pointers.ClassContext));
		pContext = newContext->m_location;

		const Oop nil = Oop(Pointers.Nil);		// Loop invariant
		pContext->m_block = reinterpret_cast<BlockOTE*>(nil);

		// Nil out the old frame up to the required number of temps
		const auto loopEnd = tempCount;
		for (auto i=0u;i<loopEnd;i++)
			pContext->m_tempFrame[i] = nil;

		newContext->setSize(SizeOfPointers(FixedSize+tempCount));
	}
	else
	{
		// Too large for context pool, so allocate as if a normal object
		newContext = reinterpret_cast<ContextOTE*>(ObjectMemory::newPointerObject(Pointers.ClassContext, FixedSize + tempCount));
		pContext = newContext->m_location;
	}

	pContext->m_frame = oopOuter;
	ObjectMemory::countUp(oopOuter);

	return newContext;
}

#pragma code_seg(INTERPMISC_SEG)

// Departure from Smalltalk-80 here in that we send the cannotReturn: selector to the Processor
// rather than the current active context, because our current active contexts are stack frames
// not objects
void Interpreter::invalidReturn(Oop resultPointer)
{
	pushObject(Pointers.Scheduler);	// Receiver of cannotReturn
	push(resultPointer);
	sendSelectorArgumentCount(Pointers.CannotReturnSelector, 1);
}

#pragma code_seg(INTERP_SEG)

void __fastcall Interpreter::returnValueToCaller(Oop resultPointer, Oop framePointer)
{
	StackFrame* pFrameFrom = m_registers.m_pActiveFrame;
	StackFrame* pFrameTo = StackFrame::FromFrameOop(framePointer);

	m_registers.m_pActiveFrame = pFrameTo;

	if (!isIntegerObject(pFrameFrom->m_environment))
	{
		Context* context = reinterpret_cast<ContextOTE*>(pFrameFrom->m_environment)->m_location;
		if (isIntegerObject(context->m_frame))
			context->m_frame = ZeroPointer;
	}

	Oop* targetSp = reinterpret_cast<Oop*>(pFrameTo->m_sp-1);

	*(targetSp+1) = resultPointer;
	m_registers.m_stackPointer = targetSp+1;

	MethodOTE* oteMethod = pFrameTo->m_method;
	CompiledMethod* method = oteMethod->m_location;
	m_registers.m_pMethod = method;
	m_registers.m_instructionPointer = integerValueOf(pFrameTo->m_ip) 
											+ ObjectMemory::ByteAddressOfObject(method->m_byteCodes);

	m_registers.m_basePointer = reinterpret_cast<Oop*>(pFrameTo->m_bp-1);
}

// aContext will be the sender of our home context. The current active context must be a block
void Interpreter::nonLocalReturnValueTo(Oop resultPointer, Oop framePointer)
{
/*	cmp		edx, [ACTIVEFRAME]
	jge		@F
	cmp		edx, [ACTIVEPROCESS]
	jle		@F
*/
	// This is no longer a valid assertion, because the VM callback exits may perform long
	// returns from non-block contexts (even stack frames)
	//ASSERT(isBlockContext(activeContext));

	StackFrame* pFrame = StackFrame::FromFrameOop(framePointer);
	StackFrame* pActiveFrame = m_registers.m_pActiveFrame;
	Process* pProcess = actualActiveProcess();
	if (pFrame > pActiveFrame 
			|| pFrame < reinterpret_cast<StackFrame*>(&pProcess->m_stack[0]))
	{
		invalidReturn(resultPointer);
		return;
	}

	// We do no ref. counting of result now, as this is taken
	// care of by the caller in the most efficient way for the
	// value being returned. Basically we assume its ref. count
	// is correct as it stands

	// Unwind contexts down to nearest unwind block

	// Start from the caller of the current stack frame, ax we'll be calling
	// the local return routine which will deal with the stack frame itself
	// Note that we also leave all stack nilling to that routine
	Oop caller = pActiveFrame->m_caller;
	do
	{
		ASSERT(caller != Oop(Pointers.Nil) && ObjectMemoryIsIntegerObject(caller));
		StackFrame* pCallingFrame = StackFrame::FromFrameOop(caller);

		if (!pCallingFrame->isBlockFrame())
		{
			Oop* bp = pCallingFrame->basePointer();			// Deduct 1 to remove SmallInteger flag
			Oop oopReceiver = *(bp-1);
			// Is it a marked frame?
			if (oopReceiver == Oop(Pointers.MarkedBlock))
			{
				Oop* sp = pCallingFrame->stackPointer();
				oopReceiver = *(sp+1);
				HARDASSERT(ObjectMemory::fetchClassOf(oopReceiver)== Pointers.ClassBlockClosure);
				// Restore the protected block as the receiver of the #ifCurtailed: message
				*(bp-1) = oopReceiver;

				// Grab the unwind block and return it to the ifCurtailed: frame as the result
				Oop unwindBlock = *(sp+2);
				HARDASSERT(ObjectMemory::fetchClassOf(unwindBlock)== Pointers.ClassBlockClosure);

				returnValueToCaller(unwindBlock, caller);

				// Now push the real result and the frame index onto the stack as the arguments to the
				// unwind block which is already there (from above). No ref. counting needed
				sp = m_registers.m_stackPointer;

				*(sp+1) = resultPointer;
				
				// Push the destination return context
				SmallUinteger frameIndex = pProcess->indexOfSP(reinterpret_cast<Oop*>(pFrame));
				*(sp+2) = ObjectMemoryIntegerObjectOf(frameIndex); // pushNoRefCnt(framePointer);

				// Invoke the two arg unwind block
				callPrimitiveValue(sp+2, 2);
				return;
			}

			if (!ObjectMemoryIsIntegerObject(pCallingFrame->m_environment))
			{
				const ContextOTE* oteEnv = reinterpret_cast<ContextOTE*>(pCallingFrame->m_environment);

				// Note that we should not be here if the environment is a block closure
				ASSERT(oteEnv->m_oteClass == Pointers.ClassContext);

				// It's a full MethodContext, mark it as having returned
				Context* ctx = oteEnv->m_location;
				ASSERT(ObjectMemoryIsIntegerObject(ctx->m_outer));

				ctx->m_frame = ZeroPointer;
			}
		}

		// Unwind the current frame down to the next

		caller = pCallingFrame->m_caller;
	} while (framePointer != caller);
	
	returnValueToCaller(resultPointer, framePointer);
}

#pragma code_seg(INTERP_SEG)

// Create a new Block from the current active frame with the specified number of arguments
BlockOTE* __stdcall Interpreter::blockCopy(BlockCopyExtension extension)
{
	// Note that every field of the context must be assigned, because the block
	// may come from the context cache
	BlockOTE* oteBlock;

	const unsigned nValuesToCopy = extension.copiedValuesCount;

	if (nValuesToCopy <= BlockClosure::MaxCopiedValues)
	{
		oteBlock = reinterpret_cast<BlockOTE*>(Interpreter::m_otePools[static_cast<size_t>(Interpreter::Pools::Blocks)].newPointerObject(Pointers.ClassBlockClosure));
		oteBlock->setSize(SizeOfPointers(BlockClosure::FixedSize + nValuesToCopy));
	}
	else
	{
		// Too large for context pool, so allocate as if a normal object
		oteBlock = reinterpret_cast<BlockOTE*>(ObjectMemory::newPointerObject(Pointers.ClassBlockClosure, BlockClosure::FixedSize + nValuesToCopy));
	}

	BlockClosure* pBlock = oteBlock->m_location;

	pBlock->m_info.isInteger = 1;
	pBlock->m_info.argumentCount = extension.argCount;
	pBlock->m_info.stackTempsCount = extension.stackTempsCount;
	pBlock->m_info.envTempsCount = extension.envTempsCount;

	if (nValuesToCopy > 0)
	{
		Oop* sp = m_registers.m_stackPointer;
		unsigned i = 0;
		do
		{
			Oop copiedValue = *(sp--);
			// We must count up the value, since we are storing it into a heap object, and the stack refs
			// are not counted while the process is active
			ObjectMemory::countUp(copiedValue);
			pBlock->m_copiedValues[i] = copiedValue;
			i++;
		} while (i < nValuesToCopy);
		m_registers.m_stackPointer = sp;
	}

	StackFrame* frame = activeFrame();

	if (extension.needsSelf)
	{
		Oop receiver = frame->receiver();
		pBlock->m_receiver = receiver;
		ObjectMemory::countUp(receiver);
	}
	else
	{
		pBlock->m_receiver = Oop(Pointers.Nil);
	}

	pBlock->m_method = frame->m_method;
	pBlock->m_method->countUp();

	if (!extension.needsOuter)
	{
		pBlock->m_outer = Pointers.Nil;
	}
	else
	{
		OTE* outerPointer = reinterpret_cast<OTE*>(frame->m_environment);
		// If this assertion fires its a clean block, which we don't expect at present
		HARDASSERT(!ObjectMemoryIsIntegerObject(outerPointer));

		// An optimisation is that if a nested block that requires an outer pointer 
		// is nested within a block that does not itself require a context (i.e. it has
		// no shared temps of its own), then that will not cause a needless Context
		// to be allocated for the outer block. In order to be able to locate the outer
		// pointer (which the outer block must, however, have set), the block itself
		// is stored in the environment slot of the calling stack frame. The compiler knows
		// about this, and when creating "Push Outer" instructions, it counts only those
		// scopes which require contexts when calculating the depths.
		if (outerPointer->m_oteClass == Pointers.ClassBlockClosure)
		{
			BlockClosure* outerBlock = static_cast<BlockClosure*>(outerPointer->m_location);
			outerPointer = outerBlock->m_outer;
		}

		pBlock->m_outer = outerPointer;
		HARDASSERT(!outerPointer->isFree());
		HARDASSERT(outerPointer->m_oteClass == Pointers.ClassContext);
		// We've added a heap object to home context so we must count it
		outerPointer->countUp();
	}
	
	// Set up the initial IP
	unsigned initialIP =
		(m_registers.m_instructionPointer
			- reinterpret_cast<BytesOTE*>(m_registers.m_pMethod->m_byteCodes)->m_location->m_fields
			+ 1);
	pBlock->m_initialIP = ObjectMemoryIntegerObjectOf(initialIP);

	return oteBlock;
}

#pragma code_seg(PRIM_SEG)
///////////////////////////////////////////////////////////////////////////////
// We only use these routines for the canUnderstand primitive since the method
// lookup is expanded by hand inline for optimum performance
//

MethodOTE* __fastcall Interpreter::lookupMethod(BehaviorOTE* classPointer, SymbolOTE* targetSelector)
{
	ASSERT(ObjectMemory::isBehavior(Oop(classPointer)));

	size_t hashForCache = cacheHash(classPointer, targetSelector);

	if (methodCache[hashForCache].classPointer == classPointer)
	{
		MethodOTE* oteMethod = methodCache[hashForCache].method;
		if (oteMethod->m_location->m_selector == targetSelector)
			return oteMethod;
	}

	// Lookup the method in the dictionaries of the class & superclass chain
	// Here we manually inline the lookup method for performance reasons as compiler
	// will not inline both lookupMethodInClass and lookupMethodInDictionary
	const SmallUinteger targetSelectorHash = targetSelector->m_idHash;
	const Behavior* current = classPointer->m_location;
	do
	{
		const MethodDictOTE* methodDictionary = current->m_methodDictionary;
		const MethodDictionary* dict = methodDictionary->m_location;
		if (dict != nullptr)
		{
			SmallUinteger lastKeyIndex = methodDictionary->pointersSize() - (ObjectHeaderSize + MethodDictionary::FixedSize + 1);
			ASSERT((((lastKeyIndex + 1) >> 1) << 1) == (lastKeyIndex + 1));
			SmallUinteger index = targetSelectorHash & lastKeyIndex;

			const SymbolOTE* nextSelector;
			while ((nextSelector = dict->m_selectors[index]) != reinterpret_cast<SymbolOTE*>(Pointers.Nil))
			{
				if (nextSelector == targetSelector)
				{
					// MethodDictionary is IdentityDictionary, which store values as an Array
					const ArrayOTE* methodArray = dict->m_methods;
					HARDASSERT(methodArray->m_oteClass == Pointers.ClassArray);
					MethodOTE* methodPointer = reinterpret_cast<MethodOTE*>(methodArray->m_location->m_elements[index]);
					HARDASSERT(ObjectMemory::isKindOf(methodPointer, Pointers.ClassCompiledMethod));
					return methodPointer;
				}
				else
				{
					// Inc and test is quicker than mod.
					if (++index > lastKeyIndex)
					{
						// Our IdentityDictionaries cannot wrap around more than once, as they
						// are guaranteed to contain empty slots.
						index = 0;
					}
				}
			}
		}
		current = current->m_superclass->m_location;
	} while (current != nullptr);

	// We didn't find a method with matching selector
	return reinterpret_cast<MethodOTE*>(Pointers.Nil);
}


//	Primitive to duplicate the VM's method lookup. Useful for fast #respondsTo:/
//	#canUnderstand:.Uses, but does not update, the method cache.
Oop* PRIMCALL Interpreter::primitiveLookupMethod(Oop* const sp, primargcount_t)
{
	Oop arg = *sp;
	BehaviorOTE* receiver = reinterpret_cast<BehaviorOTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(arg))
	{
		*(sp - 1) = reinterpret_cast<Oop>(lookupMethod(receiver, reinterpret_cast<SymbolOTE*>(arg)));
		return sp - 1;
	}
	else
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
}


#pragma code_seg(DEBUG_SEG)

#ifdef _DEBUG
	void Interpreter::DumpMethodCacheStats()
	{
		// If not then VM hash lookup logic won't work
		ASSERT(MethodDictionary::FixedSize == 2);

		size_t used = 0;
		for (size_t i=0;i<MethodCacheSize;i++)
		{
			if (methodCache[i].method != NULL) used++;
		}


		if (cacheHits != 0 || cacheMisses != 0)
		{
			wchar_t buf[256];
			_snwprintf_s(buf, sizeof(buf)-1, L"%u method cache hits, %u misses %.2lf hit ratio, in use %d, empty %d\n",
							cacheHits, cacheMisses, 
							(double)cacheHits / 
								(cacheHits + cacheMisses?cacheHits+cacheMisses:1),
							used, MethodCacheSize - used);
			OutputDebugStringW(buf);
		}

		cacheHits = cacheMisses = 0;
	}

	void Interpreter::DumpCacheStats()
	{
		DumpMethodCacheStats();
	}
#endif

#ifdef PROFILING

	#include "boot/timeval.h"
	struct timeval startTime;

	void Interpreter::StartProfiling()
	{
		gettimeofday(&startTime, 0);
		byteCodeCount = 0;
		contextsCopied = blocksInstantiated = contextReturns = methodsActivated = 
			contextsSuspended = 0;
	}

	void Interpreter::StopProfiling()
	{
		struct timeval endTime;
		// Stop the clock!
		gettimeofday(&endTime,0);
		struct timeval deltaTime;
		deltaTime.tv_sec = endTime.tv_sec - startTime.tv_sec;
		deltaTime.tv_usec = endTime.tv_usec - startTime.tv_usec;
		if (deltaTime.tv_usec < 0) 
		{
			deltaTime.tv_sec--;
			deltaTime.tv_usec += TV_TICKSPERSEC;
		}
		double fElapsed = double(deltaTime.tv_sec) + double(deltaTime.tv_usec)/TV_TICKSPERSEC;
		if (fElapsed > 0.1)
		{
			char buf[256];
			_snprintf(buf, sizeof(buf)-1, 
//				"Executed %u bytecodes in %.2lf seconds (%.2lf/sec) (%d free contexts)\n",
				"Executed %u bytecodes in %.2lf seconds (%.2lf/sec)\n",
			  		byteCodeCount, fElapsed, (double)byteCodeCount/(fElapsed?fElapsed:0.001));
			OutputDebugString(buf);
			_snprintf(buf, sizeof(buf)-1, 
				"%u/%u methods activated, %u blocks, %u copied\n",
					methodsActivated, methodsCPPActivated, blocksInstantiated, contextsCopied);
			OutputDebugString(buf);
			_snprintf(buf, sizeof(buf)-1, 
				"%u/%u returns. %u/%u suspended\n", contextReturns, contextCPPReturns, contextsSuspended, contextsCPPSuspended);
			OutputDebugString(buf);
		}
	}

#endif
