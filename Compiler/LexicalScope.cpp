/*
============
Compiler.cpp
============
Smalltalk compiler.
*/

///////////////////////

#include "stdafx.h"
#include "LexicalScope.h"
#include "Compiler.h"
#include "..\DolphinSmalltalk_i.h"

///////////////////////////////////////////////////////////////////////////////
// TempVarDecl class members

void TempVarDecl::MergeRef(const TempVarRef* pRef, Compiler* pCompiler)
{
	// Important thing is distance between the actual scope of the reference, and
	// the declaring scope of the temp. This would be simple were it not for the 
	// optimized/inlined blocks, since the declaring scope would always be the
	// scope of the original declaration. By the time we get here, however,
	// the temps declared in optimized scopes will have been moved into their
	// nearest enclosing real scope. We still need to use the actual scope of
	// the ref., however, in case it is a ref. from an optimized scope.
	_ASSERTE(GetOuter() == NULL);
	_ASSERTE(pRef->GetDecl()->GetActualDecl() == this);
	// Decl's should have been promoted out of optimized scopes by now to nearest enclosing real scope
	_ASSERTE(!m_pScope->IsOptimizedBlock());

	if (pCompiler->IsInteractive() && m_refType == vrtUnknown && pRef->GetRefType() == vrtRead && !IsReadOnly())
		pCompiler->Warning(pRef->GetTextRange(), CWarnReadBeforeWritten);

	m_refType = static_cast<VarRefType>(m_refType | pRef->GetRefType());

	LexicalScope* pRefScope = pRef->GetRealScope();

	if (m_pScope == pRefScope)
	{
		// Reference to a locally declared variable

		switch(m_varType)
		{
		case tvtUnaccessed:
			// Currently unaccessed, so promote to accessed in local scope
			m_varType = tvtStack;
			break;

		case tvtCopied:
			// Already referenced from a nested scope. If this reference
			// is to write to the variable, then we must promote the temp 
			// into a shared variable so the nested scope can see the new
			// value if it is a captured block. Note that write references
			// may be made to "arguments" if they are the args to optimized
			// (inlined) blocks, such as a #to:do:. These are not treated
			// as promoting the variable to shared.
			if (pRef->GetRefType() > vrtRead && !m_bIsReadOnly)
				m_varType = tvtShared;
			break;

		case tvtShared:
			// Already the most generate type of temp, so nothing to do
		case tvtStack:
			// Already accessed in local scope
			break;

		default:
			__assume(false);
			_ASSERTE(false);
			break;
		};
	}
	else
	{
		// Reference to a temp from an outer scope

		switch(m_varType)
		{
		case tvtCopied:
			// Already referenced from a nested scope. If this reference
			// is to write to the variable, then we must promote the temp 
			// into a shared variable
		case tvtUnaccessed:
		case tvtStack:
			// Currently unaccessed, or local only.
			if (pRef->GetRefType() > vrtRead)
				m_varType = tvtShared;
			else
				m_varType = tvtCopied;
			break;

		case tvtShared:
			// Already a full shared temp
			break;

		default:
			__assume(false);
			_ASSERTE(false);
			break;
		};
	}
}

// End of TempVarDecl class members
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// TempVarRef class members

LexicalScope* TempVarRef::GetRealScope() const
{
	return m_pScope->GetRealScope();
}

void TempVarRef::MergeRefIntoDecl(Compiler* pCompiler)
{
	GetDecl()->MergeRef(this, pCompiler);
}

int TempVarRef::GetActualDistance() const
{
	LexicalScope* pScope = GetRealScope();
	return pScope->GetActualDistance(GetDecl()->GetScope());
}

// End of TempVarRef class members
///////////////////////////////////////////////////////////////////////////////

///////////////////////////////////////////////////////////////////////////////
// LexicalScope class members

LexicalScope::~LexicalScope()
{
	// Delete decls
	{
		const int count = m_tempVarDecls.size();
		for (int i = 0; i < count; i++)
		{
			TempVarDecl* pDecl = m_tempVarDecls[i];
			delete pDecl;
		}
	}

	// Delete TempVarRefs
	{
		REFLISTMAP::iterator loopEnd = m_tempVarRefs.end();
		for (REFLISTMAP::iterator it=m_tempVarRefs.begin();it != loopEnd;it++)
		{
			REFLIST& refs = (*it).second;
			const int listEnd = refs.size();
			for (int i = 0; i < listEnd; i++)
				delete refs[i];
		}
	}
}

TempVarDecl* LexicalScope::FindTempDecl(const Str& strName)
{
	LexicalScope* pScope = this;
	do
	{
		// Note that we must search the declarations in reverse, as there may be same named
		// argument, or an optimized scope may define an overriding temp name that is added
		// to this during final patching up of temps/blocks, and we must always pick up that 
		// one when copying temps from this scope.
		DECLLIST::reverse_iterator loopEnd = pScope->m_tempVarDecls.rend();
		for (DECLLIST::reverse_iterator it=pScope->m_tempVarDecls.rbegin();it != loopEnd;it++)
		{
			TempVarDecl* pDecl = (*it);
			if (pDecl->GetName() == strName)
				return pDecl;
		}
		pScope = pScope->GetOuter();
	}
	while (pScope != NULL);

	return NULL;
}

void LexicalScope::PropagateFarReturn()
{
	if (HasFarReturn())
	{
		LexicalScope* pOuter = GetOuter();
		// Outer scope cannot be null in the case of a block
		_ASSERTE(pOuter != NULL);
		do
		{
			pOuter->m_bHasFarReturn = true;
			pOuter = pOuter->GetOuter();
		} while (pOuter != NULL);
	}
}

void LexicalScope::PropagateNeedsSelf()
{
	if (NeedsSelf())
	{
		LexicalScope* pOuter = GetOuter();
		// Outer scope cannot be null in the case of a block
		while (pOuter != NULL)
		{
			pOuter->m_bRefersToSelf = true;
			pOuter = pOuter->GetOuter();
		}
	}
}

void LexicalScope::PropagateOuterRequirements()
{
	PropagateFarReturn();
	PropagateNeedsSelf();
}


TempVarDecl* LexicalScope::CopyTemp(TempVarDecl* pTemp, Compiler* pCompiler)
{
	_ASSERTE(pTemp->GetVarType() == tvtCopied);
	_ASSERTE(pTemp->GetActualDecl() == pTemp);

	LexicalScope* pScope = pTemp->GetScope();
	if (pScope == this)
		// This is the declaring scope already
		return pTemp;

	LexicalScope* outer = GetRealOuter();
	_ASSERTE(outer != NULL);

	// Temps should never be copied into optimized blocks, as they have no
	// runtime representation, but we do need to update the reference
	TempVarDecl* pNewVar;
	if (IsOptimizedBlock())
	{
		pNewVar = outer->CopyTemp(pTemp, pCompiler);
	}
	else
	{
		// First we must see if it has already been copied into this scope, 
		// perhaps when processing a preceeding nested scope
		const int declCount = m_tempVarDecls.size();
		for (int i = 0; i < declCount; i++)
		{
			TempVarDecl* pDecl = m_tempVarDecls[i];
			if (pDecl->GetActualDecl() == pTemp)
				return pDecl;
		}

		pNewVar = new TempVarDecl(*pTemp);
		_ASSERTE(pNewVar->GetVarType() == tvtCopied);
		// Hmmm, do we want to do this. Means can only find true decl by searching
		// up, though that may not matter.
		pNewVar->SetScope(this);

		// We must recursively copy into any enclosing scopes
		pNewVar->SetOuter(outer->CopyTemp(pTemp, pCompiler));

		pNewVar->SetVarType(tvtCopy);
		pNewVar->SetIndex(m_copiedTemps.size());
		m_copiedTemps.push_back(pNewVar);

		m_tempVarDecls.push_back(pNewVar);
		if (m_tempVarDecls.size() > TEMPORARYLIMIT)
			pCompiler->CompileError(pTemp->GetTextRange(), CErrTooManyTemps);
	}

	// We must update any ref in this scope to use the new local declaration
	REFLIST& refs = m_tempVarRefs[pTemp->GetName()];
	const int refcount = refs.size();
	for (int i = 0; i < refcount; i++)
	{ 
		TempVarRef* pRef = refs[i];
		if (pRef->GetDecl() == pTemp)
			pRef->SetDecl(pNewVar);
		// else already copied
	}

	return pNewVar;
}

// Create new declarations for any temps that need to be copied
// into this scope, recursing up through outer scopes ensuring
// that the variable is copied into all of those too
void LexicalScope::CopyTemps(Compiler* pCompiler)
{
	// Note that some temps may already have been copied into this scope if they were copied
	// into nested scopes. However these will have a declaration that marks them as a copy,
	// and so will not be copied again.

	const REFLISTMAP::const_iterator loopEnd = m_tempVarRefs.end();
	for (REFLISTMAP::const_iterator it = m_tempVarRefs.begin(); it != loopEnd; it++)
	{
		const REFLIST& refs = (*it).second;
		if (refs.size() < 1)
			continue;

		TempVarDecl* pDecl = refs[0]->GetDecl();
		_ASSERTE(!pDecl->GetScope()->IsOptimizedBlock());
		if (pDecl->GetVarType() == tvtCopied)
		{
			LexicalScope* pDeclScope = pDecl->GetScope();
			if (pDeclScope == this)
			{
				// Reached its declaring scope
				_ASSERTE(pDecl->GetOuter() == NULL);
			}
			else
				CopyTemp(pDecl, pCompiler);
		}
	}
}

void LexicalScope::CopyDownOptimizedDecls(Compiler* pCompiler)
{
	LexicalScope* pActualScope = GetRealScope();
	_ASSERTE(pActualScope != this);
	_ASSERTE(m_bIsOptimizedBlock);

	const int count = m_tempVarDecls.size();
	for (int i = 0; i < count; i++)
	{
		TempVarDecl* pDecl = m_tempVarDecls[i];
		_ASSERTE(pDecl->GetScope() == this);
		_ASSERTE(pDecl->GetOuter() == NULL);
		
		TempVarDecl* pNewVar = new TempVarDecl(*pDecl);
		m_tempVarDecls[i] = pNewVar;

		_ASSERTE(pDecl->GetOuter() == NULL);
		_ASSERTE(pNewVar->GetOuter() == pDecl);
		pDecl->MarkInvisible();
		pActualScope->AddTempDecl(pDecl, pCompiler);
	}
}

// We have to move the variable declarations in optimized scopes out to the nearest
// unoptimized scope. This is necessary because the variables must be allocated in that
// scope since the optimized scope has no runtime representation. In order to be able 
// to maintain the temp map correctly, however, we replace the moved decl with a copy 
// that includes all the information needed for the temp map. However this decl will not 
// be referenced by any of the references in the scope, which will still be pointing at 
// the old (moved) decl.
void LexicalScope::PatchOptimized(Compiler* pCompiler)
{
	// This is an appropriate time to propagate out the far return flag, since 
	// any optimized blocks will have been inlined.
	PropagateOuterRequirements();

	if (IsOptimizedBlock())
	{
		CopyDownOptimizedDecls(pCompiler);
	}
}

// Allocate slots for all temps declared in this scope. Temps are one of three types
//	1) Stack
//	2) Copied
//	3) Shared
// The last two types are both allocated in the context associated with the scope. 
// The copied values must appear first, and so the indices for these have already
// been allocated when the temps were copied down. Note that we are able to ignore
// any unaccessed temps, and so these carry no runtime overhead. 
void LexicalScope::AllocTempIndices(Compiler* pCompiler)
{
	_ASSERTE(m_nStackSize == 0);
	_ASSERTE(m_nSharedTemps == 0);
	// All temps in optimized blocks must be allocated in the nearest enclosing unoptimized scope
	_ASSERTE(!IsOptimizedBlock());

	const int nCopiedValues = GetCopiedValuesCount();
	// We must allow sufficient space for the copied values before the other temps
	m_nStackSize = m_nArgs + nCopiedValues;
	const int count = m_tempVarDecls.size();
	for (int i = 0; i < count; i++)
	{
		TempVarDecl* pDecl = m_tempVarDecls[i];
		if (pDecl->IsArgument())
		{
			_ASSERTE(pDecl->GetIndex() >= 0 && pDecl->GetIndex() < m_nArgs);
		}
		else
		{
			switch(pDecl->GetVarType())
			{
			case tvtUnaccessed:
				if (pDecl->IsReadOnly())
					pDecl->SetIndex(m_nStackSize++);
				else
				{
					// Unaccessed temp, issue a warning, but don't allocate any space
					if (pCompiler->IsInteractive())
						pCompiler->Warning(pDecl->GetTextRange(), CWarnUnreferencedTemp);
					continue;
				}
				break;

			case tvtStack:
			case tvtCopied:
				pDecl->SetIndex(m_nStackSize++);
				break;

			case tvtCopy:
				_ASSERTE(pDecl->GetIndex() >= 0 && pDecl->GetIndex() < nCopiedValues);
				_ASSERTE(pDecl->GetOuter() != NULL);
				pDecl->SetIndex(pDecl->GetIndex() + m_nArgs);
				break;

			case tvtShared:
				pDecl->SetIndex(m_nSharedTemps++);
				break;

			default:
				__assume(false);
				_ASSERTE(false);
				break;
			}

			VarRefType refType = pDecl->GetRefType();
			switch(refType)
			{
			case vrtRead:	// Read, not written
				if (pCompiler->IsInteractive() && !pDecl->IsReadOnly())
				{
					// Would be better to report this on the first such read, but we'd need to search for it.
					// The in-image parser does this anyway, so not worth the effort
					pCompiler->Warning(pDecl->GetTextRange(), CWarnReadNotWritten);
				}
				break;

			case vrtWrite:	// Written, not read
				if (pCompiler->IsInteractive())
				{
					// As above, better reported on the first write, but not worth it for the same reasons.
					pCompiler->Warning(pDecl->GetTextRange(), CWarnWrittenNotRead);
				}
				break;

			case vrtUnknown:		// Unreferenced
			case vrtReadWrite:	// Normal
			default:
				break;
			}
		}
	}
}

TempVarRef* LexicalScope::AddTempRef(TempVarDecl* pDecl, VarRefType refType, const TEXTRANGE& range)
{
	TempVarRef* pNewVarRef = new TempVarRef(this, pDecl, refType, range);
	m_tempVarRefs[pDecl->GetName()].push_back(pNewVarRef);
	return pNewVarRef;
}

void LexicalScope::AddSharedDeclsTo(DECLMAP& allSharedDecls) const
{
	LexicalScope* outer = GetOuter();
	if (outer != NULL)
	{
		outer->AddSharedDeclsTo(allSharedDecls);
	}

	const DECLLIST::const_iterator end = this->m_tempVarDecls.end();
	for (DECLLIST::const_iterator it = this->m_tempVarDecls.begin(); it != end; it++)
	{
		TempVarDecl* pDecl = *it;
		if (pDecl->GetVarType() == tvtShared)
		{
			allSharedDecls[pDecl->GetName()] = pDecl;
		}
	}
}

// Recursively add all temp declarations that are visible in this scope 
// to the map. Note that outer scope is visited before this scope's
// own variables are added, so that temps declared in this scope that
// have the same name as outer temps will correctly "hide" those outer
// temps.
void LexicalScope::AddVisibleDeclsTo(DECLMAP& allVisibleDecls) const
{
	LexicalScope* outer = GetOuter();

	bool isOptimized = IsOptimizedBlock();
	// Optimized blocks are effectively inlined within their enclosing scope so all temps visible in that scope are implicitly visible in the optimized 
	// block. It is convenient in the debugger to see all the declared values in the outer scopes in this case. 
	if (isOptimized)
	{
		_ASSERTE(outer != NULL);
		outer->AddVisibleDeclsTo(allVisibleDecls);
	}	

	// 	Unoptimized blocks can be stored for later evaluation, so we should only include temps they can actually see - these will be either 
	// copied values (which, in effect, become declared locally within the block itself), or arguments (again considered locally declared), or 
	// shared variables from outer scopes in the case of full blocks.

	if (m_bRefsOuterTemps)
	{
		_ASSERTE(outer != NULL);
		outer->AddSharedDeclsTo(allVisibleDecls);
	}
	
	// Now add any locally declared, or copied, temps
	const int count = m_tempVarDecls.size();
	for (int i = 0; i < count; i++)
	{
		TempVarDecl* pDecl = m_tempVarDecls[i];
		TempVarDecl* pRealDecl = isOptimized ? pDecl->GetOuter() : pDecl;
		if (pDecl->IsVisible() && pRealDecl->IsReferenced())
		{
			allVisibleDecls[pDecl->GetName()] = pRealDecl;
		}
	}
}
 
// The format of a Temp map entry is:
//
//	#(initialIP finalIP #(#("temp1", <temp1Depth>, <temp1Index>) #("temp2"....) ...))
//
// i.e. The outer array is a tuple that describes the scope, the 3rd element of which is
// an array of tuples describing the temps. The temp tuples include the temporary name,
// the depth at which it can be found (0 = stack, 1 = local context, 2 = first outer context, etc)
// and the index of the temp within that stack frame or context.
// 
POTE LexicalScope::BuildTempMapEntry(IDolphin* piVM) const
{
	POTE scopeTuplePointer = piVM->NewArray(3);
	STVarObject& scopeTuple = *(STVarObject*)GetObj(scopeTuplePointer);
	scopeTuple.fields[0] = IntegerObjectOf(m_initialIP+1);
	scopeTuple.fields[1] = IntegerObjectOf(m_finalIP+1);

	DECLMAP allVisibleDecls;
	AddVisibleDeclsTo(allVisibleDecls);

	int numTemps = allVisibleDecls.size();
	POTE tempsPointer = piVM->NewArray(numTemps);
	piVM->StorePointerWithValue(scopeTuple.fields+2, Oop(tempsPointer));

	STVarObject& temps = *(STVarObject*)GetObj(tempsPointer);

	DECLMAP::const_iterator it = allVisibleDecls.begin();
	for (int i = 0;i < numTemps; i++, it++)
	{
		_ASSERTE(it != allVisibleDecls.end());

		TempVarDecl* pDecl = (*it).second;
		_ASSERTE(pDecl->IsArgument() || pDecl->GetVarType() != tvtUnaccessed);

		POTE tempPointer = piVM->NewArray(3);
		piVM->StorePointerWithValue(temps.fields+i, Oop(tempPointer));

		STVarObject& temp = *(STVarObject*)GetObj(tempPointer);
		piVM->StorePointerWithValue(temp.fields+0, Oop(piVM->NewUtf8String(reinterpret_cast<LPCSTR>(pDecl->GetName().c_str()))));

		int nDepth = pDecl->IsStack() 
			? 0
			: GetActualDistance(pDecl->GetScope()) + 1;

		piVM->StorePointerWithValue(temp.fields+1, IntegerObjectOf(nDepth));
		piVM->StorePointerWithValue(temp.fields+2, IntegerObjectOf(pDecl->GetIndex()+1));
	}

	return scopeTuplePointer;
}

extern void __cdecl DolphinTrace(LPCTSTR format, ...);

void LexicalScope::AddTempDecl(TempVarDecl* pDecl, Compiler* pCompiler)
{
	pDecl->SetScope(this);
	m_tempVarDecls.push_back(pDecl);

	if (m_tempVarDecls.size() > TEMPORARYLIMIT)
		pCompiler->CompileError(pDecl->GetTextRange(), CErrTooManyTemps);
}

void LexicalScope::RenameTemporary(int temporary, const Str& newName, const TEXTRANGE& range)
{
	_ASSERTE(temporary >= 0 && (unsigned)temporary < m_tempVarDecls.size());
#ifdef _DEBUG
//	TRACE("Renaming temp '%s' (%d..%d) to '%s'\n", m_tempVarDecls[temporary]->GetName().c_str(), range.m_start, range.m_stop, newName.c_str());
#endif
	TempVarDecl* pDecl = m_tempVarDecls[temporary];
	_ASSERTE(pDecl != NULL);
	pDecl->SetName(newName);
	pDecl->SetTextRange(range);

}

void LexicalScope::PatchBlockLiteral(IDolphin* piVM, POTE oteMethod)
{
	_ASSERTE(IsCleanBlock());

	if (m_oteBlockLiteral == NULL)
	{
		// Empty block
		_ASSERTE(IsEmptyBlock());
		return;
	}

	_ASSERTE((m_finalIP - m_initialIP) > 0);	// A minimal block must push a value and return requiring at least two bytes

	STBlockClosure& block = *(STBlockClosure*)GetObj(m_oteBlockLiteral);

	//block.m_outer = nil;
	piVM->StorePointerWithValue(reinterpret_cast<Oop*>(&block.m_method), reinterpret_cast<Oop>(oteMethod));

	block.m_initialIP = IntegerObjectOf(GetInitialIP()+1);

	*reinterpret_cast<Oop*>(&block.m_infoFlags) = 1;
	_ASSERTE(block.m_infoFlags.isInteger);
	block.m_infoFlags.argumentCount = GetArgumentCount();
	block.m_infoFlags.stackTempsCount = GetStackTempCount();
	_ASSERTE(GetCopiedValuesCount() == 0);
	_ASSERTE(GetSharedTempsCount() == 0);
	_ASSERTE(block.m_infoFlags.envTempsCount == 0);
	
	piVM->MakeImmutable(reinterpret_cast<Oop>(m_oteBlockLiteral), TRUE);
}

void LexicalScope::BeOptimizedBlock()
{
	m_bIsOptimizedBlock = true;
	m_bHasFarReturn = false;

	// Any apparent arguments are not really arguments from the point of view of the enclosing scope
	const int count = m_tempVarDecls.size();
	for (int i = 0; i < count; i++)
	{
		TempVarDecl* pDecl = m_tempVarDecls[i];
		pDecl->SetIsArgument(false);
	}
	m_nArgs = 0;
}

// End of LexicalScope class members
///////////////////////////////////////////////////////////////////////////////
