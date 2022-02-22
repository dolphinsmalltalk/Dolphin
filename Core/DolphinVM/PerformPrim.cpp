/******************************************************************************

	File: PerformPrim.cpp

	Description:

	Implementation of the Interpreter class' perform/value primitive methods


******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk classes
#include "STBehavior.h"
#include "STArray.h"
#include "STMethod.h"
#include "STBlockClosure.h"

// Value with args takes an array of arguments
Oop* PRIMCALL Interpreter::primitiveValueWithArgs(Oop* const bp, primargcount_t)
{
	ArrayOTE* argumentArray = reinterpret_cast<ArrayOTE*>(*(bp));
	BlockOTE* oteBlock = reinterpret_cast<BlockOTE*>(*(bp-1));
	ASSERT(ObjectMemory::fetchClassOf(reinterpret_cast<Oop>(oteBlock)) == Pointers.ClassBlockClosure);
	BlockClosure* block = oteBlock->m_location;
	const auto blockArgumentCount = block->m_info.argumentCount;

	BehaviorOTE* arrayClass = ObjectMemory::fetchClassOf(reinterpret_cast<Oop>(argumentArray));
	if (arrayClass != Pointers.ClassArray)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	const size_t arrayArgumentCount = argumentArray->pointersSize();
	if (arrayArgumentCount != blockArgumentCount)
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);

	pop(2);								// N.B. ref count of Block will be assumed by storing into frame
	// Store old context details from interpreter registers
	m_registers.StoreContextRegisters();

	// Overwrite receiver block with receiver at time of closure.
	Oop closureReceiver = block->m_receiver;
	*(bp-1) = closureReceiver;
	// No need to count up the receiver since we've written it into a stack slot

	Array* args = argumentArray->m_location;

	// Code this carefully so compiler generates optimal code (it makes a poor job on its own)
	Oop* sp = bp;

	// Push the args from the array
	{
		for (size_t i=0;i<arrayArgumentCount;i++)
		{
			Oop pushee = args->m_elements[i];
			*sp++ = pushee;
			// No need to count up since pushing on the stack
		}
	}

	const auto copiedValues = block->copiedValuesCount(oteBlock);
	{
		for (auto i=0u;i<copiedValues;i++)
		{
			Oop oopCopied = block->m_copiedValues[i];
			*sp++ = oopCopied;
			// No need to count up since pushing on the stack
		}
	}

	// Nil out any extra stack temp slots we need
	const auto extraTemps = block->stackTempsCount();
	{
		const Oop nilPointer = Oop(Pointers.Nil);
		for (auto i=0;i<extraTemps;i++)
			*sp++ = nilPointer;
	}

	// Stack frame follows args...
	StackFrame* pFrame = reinterpret_cast<StackFrame*>(sp);

	pFrame->m_bp = reinterpret_cast<Oop>(bp)+1;
	m_registers.m_basePointer = reinterpret_cast<Oop*>(bp);

	// stack ref. removed so don't need to count down

	pFrame->m_caller = m_registers.activeFrameOop();
	// Having set caller can update the active frame Oop
	m_registers.m_pActiveFrame = pFrame;

	// Note that ref. count remains the same due dto overwritten receiver slot
	const auto envTemps = block->envTempsCount();
	if (envTemps > 0)
	{
		ContextOTE* oteContext = Context::New(envTemps, reinterpret_cast<Oop>(block->m_outer));
		pFrame->m_environment = reinterpret_cast<Oop>(oteContext);
		Context* context = oteContext->m_location;
		context->m_block = oteBlock;
		// Block has been written into a heap object slot, so must count up
		oteBlock->countUp();
	}
	else
		pFrame->m_environment = reinterpret_cast<Oop>(oteBlock);

	// We don't need to store down the IP and SP into the frame until it is suspended
	pFrame->m_ip = ZeroPointer;
	pFrame->m_sp = ZeroPointer;
	MethodOTE* oteMethod = block->m_method;
	pFrame->m_method = oteMethod;
	// Don't need to inc ref count for stack frame ref to method
	CompiledMethod* method = oteMethod->m_location;
	m_registers.m_pMethod = method;

	m_registers.m_instructionPointer = ObjectMemory::ByteAddressOfObjectContents(method->m_byteCodes) +
											block->initialIP() - 1;

	// New stack pointer points at last field of stack frame
	m_registers.m_stackPointer = reinterpret_cast<Oop*>(reinterpret_cast<uint8_t*>(pFrame)+sizeof(StackFrame)) - 1;
	ASSERT(m_registers.m_stackPointer == &pFrame->m_bp);

	return primitiveSuccess(0);
}

Oop* PRIMCALL Interpreter::primitivePerform(Oop* const sp, primargcount_t argCount)
{
	SymbolOTE* performSelector = m_oopMessageSelector;	// Save in case we need to restore

	SymbolOTE* selectorToPerform = reinterpret_cast<SymbolOTE*>(*(sp - (argCount-1)));
	if (ObjectMemoryIsIntegerObject(selectorToPerform))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	m_oopMessageSelector = selectorToPerform;
	Oop newReceiver = *(sp - argCount);

	// lookupMethodInClass returns the Oop of the new CompiledMethod
	// if the selector is found, or Pointers.DoesNotUnderstand if the class 
	// does not understand the selector. We succeed if either the argument
	// count of the returned method matches that passed to this primitive,
	// or if the selector is not understood, because by this time the
	// detection of the 'does not understand' will have triggered
	// the create of a Message object (see createActualMessage) into
	// which all the arguments will have been moved, and which then replaces
	// those arguments on the Smalltalk context stack. i.e. the primitive 
	// will succeed if the message is not understood, but will result in 
	// the execution of doesNotUnderstand: rather than the selector we've 
	// been asked to perform. This works because
	// after a doesNotUnderstand detection, the stack has a Message at stack
	// top, the selector is still there, and argCount is now 1. Consequently
	// the Message gets shuffled over the selector, and doesNotUnderstand is
	// sent

	auto oteClass = ObjectMemory::fetchClassOf(newReceiver);
	MethodCacheEntry* pEntry = findNewMethodInClass(oteClass, (argCount - 1));
	MethodOTE* methodPointer = pEntry->method;
	CompiledMethod* method = methodPointer->m_location;
	const auto methodArgCount = method->m_header.argumentCount;
	if (methodArgCount == (argCount-1) || m_oopMessageSelector == Pointers.DoesNotUnderstandSelector)
	{
		// Shuffle arguments down over the selector (use argumentCount of
		// method found which may not equal argCount)
		// #pragma message("primitivePerform: Instead of shuffling args down 1, why not just deduct 1 from calling frames suspended SP after exec?")
		Oop* const tos = m_registers.m_stackPointer;
		Oop* sp = tos - methodArgCount;

		// We don't need to count down the overwritten oop anymore, since we don't ref. count stack ops

		// Not worth overhead of calling memmove here since argumentCount
		// normally small
		for (;sp < tos;sp++)
			*sp = *(sp+1);
		m_registers.m_stackPointer = sp - 1;
		executeNewMethod(methodPointer, methodArgCount);
		return primitiveSuccess(0);
	}
	else
	{
		// The argument count did not match, so drop out into the Smalltalk
		// having restored the selector
		ASSERT(m_oopMessageSelector!=Pointers.DoesNotUnderstandSelector);
		m_oopMessageSelector = performSelector;
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);
	}
}

Oop* PRIMCALL Interpreter::primitivePerformWithArgs(Oop* const sp, primargcount_t)
{
	ArrayOTE* argumentArray = reinterpret_cast<ArrayOTE*>(*(sp));
	BehaviorOTE* arrayClass = ObjectMemory::fetchClassOf(Oop(argumentArray));
	if (arrayClass != Pointers.ClassArray)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);
	
	// N.B. We're using a large stack, so don't bother checking for overflow
	//		(standard stack overflow mechanism should catch it)
									   
	// We must not get the length outside, in case small integer arg
	const auto argCount = argumentArray->pointersSize();
	
	// Save old message selector in case of prim failure (need to reinstate)
	SymbolOTE* performSelector = m_oopMessageSelector;

	// To ensure the argumentArray doesn't go away when we push its contents
	// onto the stack, in case we need it for recovery from an argument
	// count mismatch we leave its ref. count elevated

	SymbolOTE* selectorToPerform = reinterpret_cast<SymbolOTE*>(*(sp-1));
	if (ObjectMemoryIsIntegerObject(selectorToPerform))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	m_oopMessageSelector = selectorToPerform;	// Get selector from stack
	// Don't need to count down the stack ref.
	ASSERT(!selectorToPerform->isFree());

	Oop newReceiver = *(sp-2);			// receiver is under selector and arg array

	// Push the args from the array onto the stack. We must do this before
	// looking up the method, because if the receiver does not understand
	// the method then the lookup routines copy the arguments off the stack
	// into a Message object
	Array* args = argumentArray->m_location;
	for (auto i=0u; i<argCount; i++)
	{
		Oop pushee = args->m_elements[i];
		// Note no need to inc the ref. count when pushing on the stack
		sp[i-1] = pushee;
	}
	// Args written over top of selector and argument array (hence -2)
	m_registers.m_stackPointer = sp+argCount-2;

	// There is a subtle complication here when the receiver does not
	// understand the message, by which lookupMethodInClass() converts
	// the message we're trying to perform to a #doesNotUnderstand: with
	// all arguments moved to a Message. We still want to execute this
	// does not understand, so we also execute the method if the argument
	// counts do not match, but it was not understood. Note that it is
	// possible for a doesNotUnderstand: to be executed thru the first
	// test if the argumentArray contained only one argument. We allow
	// this to happen to avoid testing for not understood in the normal
	// case - just be aware of this anomaly.
	MethodCacheEntry* pEntry = findNewMethodInClass(ObjectMemory::fetchClassOf(newReceiver), argCount);
	MethodOTE* methodPointer = pEntry->method;
	CompiledMethod& method = *methodPointer->m_location;
	const auto methodArgCount = method.m_header.argumentCount;
	if (methodArgCount == argCount ||
			m_oopMessageSelector == Pointers.DoesNotUnderstandSelector)
	{
		// WE no longer need the argument array, but don't count it down since we only have a stack ref.
		executeNewMethod(methodPointer, methodArgCount);
		return primitiveSuccess(0);
	}
	else
	{
		// Receiver must have understood the message, but we had wrong 
		// number of arguments, so reinstate the stack and fail the primitive
		pop(argCount);
		pushObject((OTE*)m_oopMessageSelector);
		// Argument array already has artificially increased ref. count
		push(Oop(argumentArray));
		m_oopMessageSelector = performSelector;
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);
	}
}


Oop* PRIMCALL Interpreter::primitivePerformMethod(Oop* const sp, primargcount_t)
{
	ArrayOTE* oteArg = reinterpret_cast<ArrayOTE*>(*(sp));
	if (ObjectMemory::fetchClassOf(Oop(oteArg)) != Pointers.ClassArray)
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);		// Arguments not an Array
	Array* arguments = oteArg->m_location;
	Oop receiverPointer = *(sp - 1);
	MethodOTE* oteMethod = reinterpret_cast<MethodOTE*>(*(sp - 2));
	Oop* bp = sp - 2;

	CompiledMethod* method = oteMethod->m_location;
	if (!ObjectMemory::isKindOf(receiverPointer, method->m_methodClass))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);		// Wrong class of receiver

	const size_t argCount = oteArg->pointersSize();
	const auto methodArgCount = method->m_header.argumentCount;
	if (methodArgCount != argCount)
		return primitiveFailure(_PrimitiveFailureCode::WrongNumberOfArgs);		// Wrong number of arguments

	// Push receiver and arguments on stack (over the top of array and receiver)
	bp[0] = receiverPointer;					// Write receiver over the top of the method
	for (auto i = 0; i < methodArgCount; i++)
	{
		Oop pushee = arguments->m_elements[i];
		// Don't count up because we are adding a stack ref.
		bp[i+1] = pushee;
	}
	m_registers.m_stackPointer = bp+ methodArgCount;

	// Don't count down any args
	executeNewMethod(oteMethod, methodArgCount);
	return primitiveSuccess(0);
}
