/*
============
CompilerSupport.cpp
============
Interpreter interface functions that are used purely by the Compiler, and which can, therefore,
be thrown away eventually, or perhaps compiled into a separate DLL.
*/

#include "stdafx.h"							
#include "compiler.h"
#include <stdarg.h>
#include <wtypes.h>
#include <process.h>

#include "..\VMPointers.h"

POTE Compiler::NewCompiledMethod(POTE classPointer, size_t numBytes, const STMethodHeader& hdr)
{
	//_ASSERTE(ObjectMemory::inheritsFrom(classPointer, GetVMPointers().ClassCompiledMethod));
	// Note we subtract
	POTE methodPointer = m_piVM->NewObjectWithPointers(classPointer,
		((sizeof(STCompiledMethod)
			- sizeof(Oop)	// Deduct dummy literal frame entry (arrays cannot be zero sized in IDL)
//			-sizeof(ObjectHeader)	// Deduct size of head which NewObjectWithPointers includes implicitly
) / sizeof(Oop)) + LiteralCount);
	STCompiledMethod* method = reinterpret_cast<STCompiledMethod*>(GetObj(methodPointer));
	POTE bytes = m_piVM->NewByteArray(numBytes);
	m_piVM->StorePointerWithValue((Oop*)&method->byteCodes, Oop(bytes));

	method->header = hdr;

	return methodPointer;
}

///////////////////////////////////

//==============
//InstVarNamesOf
//==============
// Returns an Array of instance variable names of anObject. 
// Used by Compiler to get context for compilation of a method or expression
//

// N.B. Result has artificially elevated ref. count
POTE Compiler::InstVarNamesOf(POTE aBehavior) // throws SE_VMCALLBACKUNWIND
{
	if (!m_piVM->IsBehavior(Oop(aBehavior)))
		return m_piVM->NilPointer();

	_ASSERTE(GetVMPointers().allInstVarNamesSymbol != m_piVM->NilPointer());
	return (POTE)m_piVM->Perform(Oop(aBehavior), GetVMPointers().allInstVarNamesSymbol);
}

// Ditto on the ref. count front
POTE Compiler::FindDictVariable(POTE dict, const Str& name)// throws SE_VMCALLBACKUNWIND
{
	// Finds the given name as a shared global.
	// To locate the appropriate binding for the variable we'll have to run
	// some Smalltalk (dict lookupKey: aString)
	//
	_ASSERTE(!IsIntegerObject(Oop(dict)));
	Oop stringPointer = Oop(NewUtf8String(name));
	return (POTE)m_piVM->PerformWith(Oop(dict), GetVMPointers().lookupKeySymbol, stringPointer);
}

// Ditto on the ref. count front **?**
POTE Compiler::DictAtPut(POTE dict, const Str& name, Oop value)// throws SE_VMCALLBACKUNWIND
{
	POTE atPutSelector = InternSymbol((LPUTF8)"at:put:");

	// SystemDictionary will convert String to Symbol in #at:put:
	_ASSERTE(!IsIntegerObject(Oop(dict)));
	POTE symbolPointer = NewUtf8String(name);
	return (POTE)m_piVM->PerformWithWith(Oop(dict), atPutSelector, Oop(symbolPointer), value);
}

bool Compiler::CanUnderstand(POTE oteBehavior, POTE oteSelector)
{
	return ((POTE)m_piVM->PerformWith(Oop(oteBehavior), GetVMPointers().canUnderstandSymbol, Oop(oteSelector)))
		== GetVMPointers().True;
}

///////////////////////////////////////////////////////////////////////////////
// 

Oop Compiler::EvaluateExpression(LPUTF8 text, POTE oteMethod, Oop contextOop, POTE pools)
{
	STCompiledMethod& exprMethod = *(STCompiledMethod*)GetObj(oteMethod);
	auto primitive = exprMethod.header.primitiveIndex;
	Oop result;
	// As an optimization avoid calling back into Smalltalk if we the expression is of simple form, e.g. a class ref
	switch (primitive)
	{
	case PRIMITIVE_RETURN_SELF:
		result = contextOop;
		break;
	case PRIMITIVE_RETURN_TRUE:
		return reinterpret_cast<Oop>(this->GetVMPointers().True);
	case PRIMITIVE_RETURN_FALSE:
		return reinterpret_cast<Oop>(this->GetVMPointers().False);
	case PRIMITIVE_RETURN_NIL:
		return reinterpret_cast<Oop>(this->GetVMPointers().Nil);
	case PRIMITIVE_RETURN_LITERAL_ZERO:
		result = exprMethod.aLiterals[0];
		break;
	case PRIMITIVE_RETURN_STATIC_ZERO:
		result = reinterpret_cast<STVariableBinding*>(GetObj(reinterpret_cast<POTE>(exprMethod.aLiterals[0])))->value;
		break;
	default:
		return m_piVM->PerformWithWithWith(Oop(oteMethod), GetVMPointers().evaluateExpressionSelector, Oop(NewUtf8String(text)), contextOop, Oop(pools));
	}

	m_piVM->AddReference(result);

	return result;
}


///////////////////////////////////////////////////////////////////////////////
// The return value has the correct ref. count - i.e. it is not
// artificially increased

POTE Compiler::FindGlobal(const Str& name)
{
	const POTE nil = Nil();

	Oop scope = reinterpret_cast<Oop>(m_class == nil ? GetVMPointers().SmalltalkDictionary : m_class);
	POTE ote = reinterpret_cast<POTE>(m_piVM->PerformWith(scope, GetVMPointers().fullBindingForSymbol,
		reinterpret_cast<Oop>(NewUtf8String(name))));

	if (ote != nil)
	{
		OTE* oteBinding = ote;
		STVariableBinding* var = reinterpret_cast<STVariableBinding*>(GetObj(oteBinding));
		ote = (POTE)var->value;
		// Smalltalk does actually contain bindings, so the binding wont go away
		m_piVM->RemoveReference(Oop(oteBinding));
	}
	return ote;
}

///////////////////////////////////////////////////////////////////////
