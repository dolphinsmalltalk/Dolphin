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
#include <winerror.h>
#include <wtypes.h>
#include <CommCtrl.h>

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

#if defined(_DEBUG)
	#include "STClassDesc.h"
#endif

// In order to keep the message lookup routines 'tight' we ensure that the infrequently executed code
// is in separate routines that will not get inlined. This can make a significant difference to the
// performance of the system (as we've discovered).
#pragma auto_inline(off)

extern "C" void __fastcall callPrimitiveValue(unsigned, unsigned numArgs);

#ifdef PROFILING
	unsigned contextsCopied = 0;
	unsigned blocksInstantiated = 0;
	unsigned contextReturns = 0;
	unsigned methodsActivated = 0;
	unsigned contextsSuspended = 0;
	unsigned methodsCPPActivated = 0;
	unsigned contextCPPReturns = 0;
	unsigned contextsCPPSuspended = 0;
	unsigned byteCodeCount = 0;
	//unsigned contextDepth = 0;
#endif

#ifdef _DEBUG
	#define MAXCACHEMISSES 100000
	DWORD cacheHits = 0;
	static DWORD cacheMisses = 0;

#endif	

//=============
//Method Lookup
//=============

/*
inline unsigned __fastcall Interpreter::cacheHash(Oop classPointer, Oop messageSelector)
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

	if ((SDWORD)m_nInputPollInterval > 0)
	{
		// Look for any input in the queue, not just for new stuff
		if (((::GetQueueStatus(m_dwQueueStatusMask) >> 16) & m_dwQueueStatusMask) != 0)
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
					WarningWithStackTrace("User Interrupt:");
				#endif
				queueInterrupt(VMI_USERINTERRUPT, Oop(Pointers.Nil));
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
		else
		{
			// No input found, reset for next sampling
			ResetInputPollCounter();
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

	int hotkey = integerValueOf(Pointers.InterruptHotKey);
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


// N.B. cacheHash must match that used in byteasm.asm
// Use following for 8-byte OTEs
//#define cacheHash(classPointer, messageSelector) (((Oop(messageSelector) ^ Oop(classPointer)) >> 3) & (MethodCacheSize-1))
// Use following for 12-byte OTEs
//#define cacheHash(classPointer, messageSelector) (((Oop(messageSelector) ^ Oop(classPointer)) >> 2) & (MethodCacheSize-1))
// Use following for 16-byte OTEs
#define cacheHash(classPointer, messageSelector) (((Oop(messageSelector) ^ Oop(classPointer)) >> 4) & (MethodCacheSize-1))

#pragma code_seg(INTERP_SEG)

MethodOTE* __fastcall Interpreter::findNewMethodInClass(BehaviorOTE* classPointer, const unsigned argCount)
{
	ASSERT(ObjectMemory::isBehavior(Oop(classPointer)));

	SymbolOTE* oteSelector = m_oopMessageSelector;

	// This hashForCache 'function' relies on the OTEntry size being 12 bytes, meaning
	// that the bottom 2 bits of the Oops (which are pointers to the OTEntries)
	// are always the same.
	unsigned hashForCache = cacheHash(classPointer, oteSelector);

	if (methodCache[hashForCache].classPointer == classPointer)
	{
		MethodOTE* oteMethod = methodCache[hashForCache].method;

		if (oteMethod->m_location->m_selector == oteSelector)
		{
			#ifdef _DEBUG
			cacheHits++;
			{
				if (executionTrace)
				{
					tracelock lock(TRACESTREAM);
					TRACESTREAM << "Found method " << classPointer << ">>" << oteSelector << 
							" (" << oteMethod << ") in cache\n";
				}
			}
			#endif

			return oteMethod;
		}
	}

	return findNewMethodInClassNoCache(classPointer, argCount);
}

#pragma code_seg(INTERP_SEG)

extern "C" intptr_t primitivesTable[PRIMITIVE_MAX];

inline intptr_t LookupMethodPrimitive(MethodOTE* oteMethod)
{
	CompiledMethod* pMethod = oteMethod->m_location;
	return primitivesTable[pMethod->m_header.primitiveIndex];
}

MethodOTE* __stdcall Interpreter::findNewMethodInClassNoCache(BehaviorOTE* classPointer, const unsigned argCount)
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
	const BehaviorOTE* currentClass = classPointer;
	const SMALLUNSIGNED targetSelectorHash = targetSelector->m_idHash;
	const Oop nil = Oop(Pointers.Nil);
	do
	{
		Behavior* behavior = currentClass->m_location;
		const MethodDictOTE* methodDictionary = behavior->m_methodDictionary;
		if ((Oop)methodDictionary != nil)
		{
			// mask is the number of keys in the dictionary (which is pointer size - header - 2) minus 1
			// as the size is a power of 2, thus we can avoid a modulus operation which is relatively slow
			// requiring a division instruction
			SMALLUNSIGNED lastKeyIndex = methodDictionary->pointersSize() - (ObjectHeaderSize + MethodDictionary::FixedSize + 1);
			SMALLUNSIGNED index = targetSelectorHash & lastKeyIndex;
			MethodDictionary* dict = methodDictionary->m_location;

			bool wrapped = false;
			const SymbolOTE* nextSelector;
			while (Oop(nextSelector = dict->m_selectors[index]) != nil)
			{
				if (nextSelector == targetSelector)
				{
					// MethodDictionary is IdentityDictionary, which store values as an Array
					const ArrayOTE* methodArray = dict->m_methods;
					HARDASSERT(methodArray->m_oteClass == Pointers.ClassArray);
					MethodOTE* methodPointer = reinterpret_cast<MethodOTE*>(methodArray->m_location->m_elements[index]);
					HARDASSERT(ObjectMemory::isKindOf(methodPointer, Pointers.ClassCompiledMethod));

					unsigned hashForCache = cacheHash(classPointer, targetSelector);
					// Write back into the cache, no longer store selector in the cache
					methodCache[hashForCache].selector = targetSelector;
					methodCache[hashForCache].classPointer = classPointer;
					methodCache[hashForCache].method = methodPointer;
					methodCache[hashForCache].primAddress = LookupMethodPrimitive(methodPointer);

#ifdef _DEBUG
					{
						if (abs(executionTrace) > 1)
						{
							tracelock lock(TRACESTREAM);
							TRACESTREAM << "Found method " << classPointer << ">>" << targetSelector << " (" << methodPointer << ")" << endl;
						}
					}
#endif
					return methodPointer;
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
		currentClass = behavior->m_superclass;
	} while (Oop(currentClass) != nil);

	// The message was not understood, send a #doesNotUnderstand: to the receiver.
	return messageNotUnderstood(classPointer, argCount);
}

#pragma code_seg(INTERP_SEG)

// Translate args on stack to a message containing an array of arguments
void __fastcall Interpreter::createActualMessage(const unsigned argCount)
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
	const unsigned loopEnd = argCount;
	for (unsigned i=0;i<loopEnd;i++)
	{
		Oop oopArg = sp[i];
		ObjectMemory::countUp(oopArg);
		args->m_elements[i] = oopArg;
	}

	*sp = (Oop)messagePointer;
	m_registers.m_stackPointer = sp;
	ObjectMemory::AddToZct((OTE*)messagePointer);
}

#pragma code_seg(INTERP_SEG)

MethodOTE* __fastcall Interpreter::messageNotUnderstood(BehaviorOTE* classPointer, const unsigned argCount)
{
	#if defined(_DEBUG)
	{
		ostringstream dc;
		dc << classPointer << " does not understand " << m_oopMessageSelector << endl << ends;
		string msg = dc.str();
		tracelock lock(TRACESTREAM);
		TRACESTREAM << msg;
		if (classPointer->isMetaclass() || 
				strcmp(static_cast<Class*>(classPointer->m_location)->getName(), "DeafObject"))
			WarningWithStackTrace(msg.c_str());
	}
	#endif

	// Check for recursive not understood error
	if (m_oopMessageSelector == Pointers.DoesNotUnderstandSelector)
		RaiseFatalError(IDP_RECURSIVEDNU, 2, reinterpret_cast<DWORD>(classPointer), reinterpret_cast<DWORD>(m_oopMessageSelector->m_location));

	createActualMessage(argCount);
	m_oopMessageSelector = Pointers.DoesNotUnderstandSelector;
	// Recursively invoke to find #doesNotUnderstand: in class
	return findNewMethodInClass(classPointer, 1);
}

#pragma code_seg(INTERP_SEG)

ContextOTE* __fastcall Context::New(unsigned tempCount, Oop oopOuter)
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
					HARDASSERT(context->m_block->isNil());
				}
			}
			else
				HARDASSERT(oteOuter->isNil());
		}
	}
	#endif

	Context* pContext;

	if (tempCount <= MaxEnvironmentTemps)
	{
		// Can allocate from pool of contexts

		newContext = reinterpret_cast<ContextOTE*>(Interpreter::m_otePools[Interpreter::CONTEXTPOOL].newPointerObject(Pointers.ClassContext, 
										FixedSize + MaxEnvironmentTemps, OTEFlags::ContextSpace));
		pContext = newContext->m_location;

		const Oop nil = Oop(Pointers.Nil);		// Loop invariant
		pContext->m_block = reinterpret_cast<BlockOTE*>(Pointers.Nil);

		// Nil out the old frame up to the required number of temps
		const unsigned loopEnd = tempCount;
		for (unsigned i=0;i<loopEnd;i++)
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

BlockOTE* __fastcall BlockClosure::New(unsigned copiedValuesCount)
{
	BlockOTE* newBlock;
	
	if (copiedValuesCount <= MaxCopiedValues)
	{
		// Can allocate from pool of contexts

		newBlock = reinterpret_cast<BlockOTE*>(Interpreter::m_otePools[Interpreter::BLOCKPOOL].newPointerObject(Pointers.ClassBlockClosure, 
										FixedSize + MaxCopiedValues, OTEFlags::BlockSpace));
		BlockClosure* pClosure = newBlock->m_location;

		const Oop nil = Oop(Pointers.Nil);		// Loop invariant
		#ifdef _DEBUG
			pClosure->m_receiver = nil;
		#endif
		TODO("Don't need to nil out the copied values slots, as these will be overwritten on BlockCopy");

		// Nil out the old frame up to the required number of temps
		const unsigned loopEnd = copiedValuesCount;
		for (unsigned i=0;i<loopEnd;i++)
			pClosure->m_copiedValues[i] = nil;

		newBlock->setSize(SizeOfPointers(BlockClosure::FixedSize+copiedValuesCount));
	}
	else
	{
		// Too large for context pool, so allocate as if a normal object
		newBlock = reinterpret_cast<BlockOTE*>(ObjectMemory::newPointerObject(Pointers.ClassBlockClosure, BlockClosure::FixedSize + copiedValuesCount));
	}

	return newBlock;
}

#pragma code_seg(INTERPMISC_SEG)

// Departure from Smalltalk-80 here in that we send the cannotReturn: selector to the Processor
// rather than the current active context, because our current active contexts are stack frames
// not objects
void Interpreter::invalidReturn(Oop resultPointer)
{
	pushObject((OTE*)Pointers.Scheduler);	// Receiver of cannotReturn
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
				// Zero out the stack slot so no net effect on the ref. count of the protected block
				*(sp+1) = ZeroPointer;

				// Grab the unwind block and return it to the ifCurtailed: frame as the result
				Oop unwindBlock = *(sp+2);
				HARDASSERT(ObjectMemory::fetchClassOf(unwindBlock)== Pointers.ClassBlockClosure);
				*(sp+2) = ZeroPointer;

				returnValueToCaller(unwindBlock, caller);

				// Now push the real result and the frame index onto the stack as the arguments to the
				// unwind block which is already there (from above). No ref. counting needed
				sp = m_registers.m_stackPointer;

				*(sp+1) = resultPointer;
				
				// Push the destination return context
				SMALLUNSIGNED frameIndex = pProcess->indexOfSP(reinterpret_cast<Oop*>(pFrame));
				*(sp+2) = ObjectMemoryIntegerObjectOf(frameIndex); // pushNoRefCnt(framePointer);
				m_registers.m_stackPointer = sp+2;

				// Invoke the two arg unwind block
				callPrimitiveValue(0, 2);
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
BlockOTE* __fastcall Interpreter::blockCopy(DWORD ext)
{
	BlockCopyExtension extension = *reinterpret_cast<BlockCopyExtension*>(&ext);

	// Note that every field of the context must be assigned, because the block
	// may come from the context cache
	BlockOTE* oteBlock = BlockClosure::New(extension.copiedValuesCount);

	HARDASSERT(ObjectMemory::hasCurrentMark(oteBlock));
	HARDASSERT(oteBlock->m_oteClass == Pointers.ClassBlockClosure);
	BlockClosure* pBlock = oteBlock->m_location;

	// Set up the initial IP
	m_registers.StoreIPInFrame();
	StackFrame* frame = activeFrame();
	Oop oopIP = frame->m_ip - ((SizeOfPointers(0)-1)<<1);
	pBlock->m_initialIP = oopIP;
	pBlock->m_info.isInteger = 1;
	pBlock->m_info.argumentCount = extension.argCount;
	pBlock->m_info.stackTempsCount = extension.stackTempsCount;
	pBlock->m_info.envTempsCount = extension.envTempsCount;

	HARDASSERT(ObjectMemoryIsIntegerObject(*reinterpret_cast<Oop*>(&pBlock->m_info)));

	if (extension.needsOuter)
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
	else
		pBlock->m_outer = Pointers.Nil;
	
	const unsigned nValuesToCopy = extension.copiedValuesCount;
	if (nValuesToCopy > 0)
	{
		Oop* sp = m_registers.m_stackPointer;
		unsigned i=0;
		do
		{
			Oop copiedValue = *(sp--);
			// We must count up the value, since we are storing it into a heap object, and the stack refs
			// are not counted while the process is active
			ObjectMemory::countUp(copiedValue);
			pBlock->m_copiedValues[i] = copiedValue;
			i++;
		} while (i<nValuesToCopy);
		m_registers.m_stackPointer = sp;
	}

	if (extension.needsSelf)
	{
		pBlock->m_receiver = frame->receiver();
		ObjectMemory::countUp(pBlock->m_receiver);
	}
	else
		pBlock->m_receiver = Oop(Pointers.Nil);

	pBlock->m_method = frame->m_method;
	pBlock->m_method->countUp();

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

	unsigned hashForCache = cacheHash(classPointer, targetSelector);

	if (methodCache[hashForCache].classPointer == classPointer)
	{
		MethodOTE* oteMethod = methodCache[hashForCache].method;
		if (oteMethod->m_location->m_selector == targetSelector)
			return oteMethod;
	}

	// Lookup the method in the dictionaries of the class & superclass chain
	// Here we manually inline the lookup method for performance reasons as compiler
	// will not inline both lookupMethodInClass and lookupMethodInDictionary
	const BehaviorOTE* currentClass=classPointer;
	const SMALLUNSIGNED targetSelectorHash = targetSelector->m_idHash;
	const Oop nil = Oop(Pointers.Nil);
	do
	{
		const Behavior* current = currentClass->m_location;
		const MethodDictOTE* methodDictionary = current->m_methodDictionary;
		if ((Oop)methodDictionary != nil)
		{
			SMALLUNSIGNED lastKeyIndex = methodDictionary->pointersSize() - (ObjectHeaderSize + MethodDictionary::FixedSize + 1);
			ASSERT((((lastKeyIndex + 1) >> 1) << 1) == (lastKeyIndex + 1));
			SMALLUNSIGNED index = targetSelectorHash & lastKeyIndex;

			const MethodDictionary* dict = methodDictionary->m_location;

			const SymbolOTE* nextSelector;
			while (Oop(nextSelector = dict->m_selectors[index]) != nil)
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
		currentClass = current->m_superclass;
	} while ((Oop)currentClass != nil);

	// We didn't find a method with matching selector
	return reinterpret_cast<MethodOTE*>(nil);
}

#pragma code_seg(DEBUG_SEG)

#ifdef _DEBUG
	void Interpreter::DumpMethodCacheStats()
	{
		// If not then VM hash lookup logic won't work
		ASSERT(MethodDictionary::FixedSize == 2);

		int used = 0;
		for (int i=0;i<MethodCacheSize;i++)
		{
			if (methodCache[i].method != NULL) used++;
		}


		if (cacheHits != 0 || cacheMisses != 0)
		{
			char buf[256];
			_snprintf(buf, sizeof(buf)-1, "%u method cache hits, %u misses %.2lf hit ratio, in use %d, empty %d\n",
							cacheHits, cacheMisses, 
							(double)cacheHits / 
								(cacheHits + cacheMisses?cacheHits+cacheMisses:1),
							used, MethodCacheSize - used);
			OutputDebugString(buf);
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
