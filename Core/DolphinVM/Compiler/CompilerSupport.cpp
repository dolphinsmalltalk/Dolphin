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

///////////////////////////////////

POTE __stdcall Compiler::NewCompiledMethod(POTE classPointer, size_t numBytes, const STMethodHeader & hdr, size_t literalCount)
{
	POTE methodPointer = m_piVM->NewObjectWithPointers(classPointer,
		((sizeof(STCompiledMethod)
			 -sizeof(Oop)	// Deduct dummy literal frame entry (arrays cannot be zero sized in IDL)
			//			-sizeof(ObjectHeader)	// Deduct size of head which NewObjectWithPointers includes implicitly
			) / sizeof(Oop)) + literalCount);
	STCompiledMethod * method = reinterpret_cast<STCompiledMethod*>(GetObj(methodPointer));
	POTE bytes = m_piVM->NewByteArray(numBytes);
	m_piVM->StorePointerWithValue((Oop*)&method->byteCodes, Oop(bytes));

	method->header = hdr;

	return methodPointer;
}

// Returns an Array of instance variable names of anObject. 
// Used by Compiler to get context for compilation of a method or expression
// N.B. Result has artificially elevated ref. count
POTE Compiler::GetInstVarNames() // throws SE_VMCALLBACKUNWIND
{
	if (!m_piVM->IsBehavior(Oop(m_class)))
		return Nil();

	_ASSERTE(GetVMPointers().allInstVarNamesSelector != Nil());
	return (POTE)m_piVM->Perform(Oop(m_class), GetVMPointers().allInstVarNamesSelector);
}

// Returns the namespace of the class into which the method is being compiled
POTE Compiler::GetClassEnvironment(POTE oteClass)
{
	if (!m_piVM->IsBehavior(Oop(oteClass)))
		return Nil();

	if (m_piVM->IsAMetaclass(m_class))
	{
		STMetaclass* meta = (STMetaclass*)GetObj(oteClass);
		oteClass = meta->instanceClass;
	}

	_ASSERTE(m_piVM->IsAClass(oteClass));
	STClass* cl = (STClass*)GetObj(oteClass);
	return cl->environment;
}

// Ditto on the ref. count front
POTE Compiler::FindDictVariable(POTE dict, const u8string& name)// throws SE_VMCALLBACKUNWIND
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
POTE Compiler::DictAtPut(POTE dict, const u8string& name, Oop value)// throws SE_VMCALLBACKUNWIND
{
	POTE atPutSelector = InternSymbol(u8"at:put:"s);

	// SystemDictionary will convert String to Symbol in #at:put:
	_ASSERTE(!IsIntegerObject(Oop(dict)));
	POTE symbolPointer = NewUtf8String(name);
	return (POTE)m_piVM->PerformWithWith(Oop(dict), atPutSelector, Oop(symbolPointer), value);
}

bool Compiler::CanUnderstand(POTE oteBehavior, POTE oteSelector)
{
	return ((POTE)m_piVM->PerformWith(Oop(oteBehavior), GetVMPointers().canUnderstandSelector, Oop(oteSelector)))
		== GetVMPointers().True;
}

///////////////////////////////////////////////////////////////////////////////
// 

Oop Compiler::EvaluateExpression(const u8string& text, POTE oteMethod, Oop contextOop, POTE pools)
{
	STCompiledMethod& exprMethod = *(STCompiledMethod*)GetObj(oteMethod);
	auto primitive = exprMethod.header.primitiveIndex;
	Oop result;
	// As an optimization avoid calling back into Smalltalk if the expression is of simple form, e.g. a class ref
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

POTE Compiler::FindGlobal(const u8string& name)
{
	const POTE nil = Nil();

	Oop scope = reinterpret_cast<Oop>(m_class == nil ? GetVMPointers().SmalltalkDictionary : m_class);
	POTE ote = reinterpret_cast<POTE>(m_piVM->PerformWithWith(scope, GetVMPointers().fullBindingForSelector, reinterpret_cast<Oop>(NewUtf8String(name)), (Oop)m_environment));

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
