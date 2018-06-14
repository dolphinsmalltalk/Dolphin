/*
==========
LexicalScope.h
==========
*/
#pragma once

#include "Str.h"
#include <vector>
#include <map>

#define TEMPORARYLIMIT 		255		// maximum number of temporaries permitted (ditto)
#define MAXBLOCKNESTING		255		// maximum depth to which blocks (actually contexts) can be nested


enum TempVarType { 
	tvtUnaccessed=0,	// Temp variable which is not accessed at all
	tvtStack,			// Temp variable accessed only from local scope (or optimized blocks)
	tvtCopied,			// Temp variable which is closed over, but only read after closure
	tvtShared,			// Temp variable which is written after being closed over
	tvtCopy,			// Temp variable decl created to represent a copied temp in the closure
	};		

enum VarRefType { vrtUnknown = 0, vrtRead=1, vrtWrite=2, vrtReadWrite=3};
class LexicalScope;
class TempVarRef;
class Compiler;

class TempVarDecl
{
	Str				m_strName;
	TEXTRANGE		m_range;
	LexicalScope*	m_pScope;
	TempVarType		m_varType;
	VarRefType		m_refType;
	TempVarDecl*	m_pOuter;
	int				m_nIndex;
	bool			m_bInvisible;	// Not visible in this scope (used for real declarations of temps in optimized blocks)
	bool			m_bIsArgument;
	bool			m_bIsReadOnly;

public:
	TempVarDecl(const Str& strName, const TEXTRANGE& range) : 
			m_strName(strName), m_pScope(NULL), m_range(range),
			m_varType(tvtUnaccessed), m_refType(vrtUnknown), m_pOuter(NULL),
			m_nIndex(-1),
			m_bInvisible(false), m_bIsArgument(false), m_bIsReadOnly(false)
	{
	}


	TempVarDecl(const TempVarDecl& s) :
			m_strName(s.m_strName), m_pScope(s.m_pScope),
			m_varType(s.m_varType), m_refType(s.m_refType),
			m_pOuter(const_cast<TempVarDecl*>(&s)), m_nIndex(-1),
			m_bInvisible(false), m_bIsArgument(false), m_bIsReadOnly(true)
	{
	}


	/////////////////////////
	// Accessing

	TempVarType GetVarType() const
	{
		return m_varType;
	}

	void SetVarType(TempVarType varType)
	{
		m_varType = varType;
	}

	VarRefType GetRefType() const
	{
		return m_refType;
	}

	int GetIndex() const
	{
		return m_varType == tvtCopy || GetOuter() == NULL
					? m_nIndex
					: GetOuter()->GetIndex();
	}

	void SetIndex(int index)
	{
		_ASSERTE(m_varType == tvtCopy || GetOuter() == NULL);
		m_nIndex = index;
	}

	const Str& GetName() const
	{
		return m_strName;
	}

	void SetName(const Str& strName)
	{
		m_strName = strName;
	}

	LexicalScope* GetScope() const
	{
		return m_pScope;
	}

	void SetScope(LexicalScope* pScope)
	{
		m_pScope = pScope;
	}

	LexicalScope* GetActualScope() const
	{
		return GetActualDecl()->GetScope();
	}

	TempVarDecl* GetOuter() const
	{
		return m_pOuter;
	}

	void SetOuter(TempVarDecl* pOuter)
	{
		m_pOuter = pOuter;
	}

	const TEXTRANGE& GetTextRange() const
	{
		return m_range;
	}

	void SetTextRange(const TEXTRANGE& range)
	{
		m_range = range;
	}

	TempVarDecl* GetActualDecl() const
	{
		TempVarDecl* pDecl = const_cast<TempVarDecl*>(this);
		while (pDecl->m_pOuter != NULL)
			pDecl = pDecl->m_pOuter;

		return pDecl;
	}

	void SetIsArgument(bool bIsArgument)
	{
		m_bIsArgument = bIsArgument;
		if (bIsArgument)
			BeReadOnly();
	}

	void BeReadOnly()
	{
		m_bIsReadOnly = true;
	}

	void MarkInvisible()
	{
		m_bInvisible = true;
	}

	// Operations
	void MergeRef(const TempVarRef*, Compiler* pCompiler);

	// Testing
	bool IsArgument() const
	{
		return m_bIsArgument;
	}

	bool IsStack() const
	{
		switch (m_varType)
		{
		case tvtCopy:
//			break;
		case tvtStack:
		case tvtCopied:
			return true;
		case tvtUnaccessed:
			return m_bIsReadOnly;
		case tvtShared:
		default:
			break;
		}
		return false;
	}

	bool IsReferenced() const
	{
		return m_varType != tvtUnaccessed || m_bIsReadOnly;
	}

	bool IsVisible() const
	{
		return !m_bInvisible;
	}

	bool IsReadOnly() const
	{
		return m_bIsReadOnly;
	}
};

class TempVarRef
{
	LexicalScope*	m_pScope;
	TempVarDecl*	m_pDecl;
	VarRefType		m_refType;
	TEXTRANGE		m_range;

public:
	TempVarRef(LexicalScope* pScope, TempVarDecl* pDecl, VarRefType refType, const TEXTRANGE& range) 
		: m_pScope(pScope), m_pDecl(pDecl), m_refType(refType), m_range(range)
	{
	}

	//////////////////////////////////////////////
	// Accessing

	int GetEstimatedDistance() const;
	int GetActualDistance() const;

	VarRefType GetRefType() const
	{
		return m_refType;
	}

	void SetRefType(VarRefType refType)
	{
		_ASSERTE(refType >= m_refType);
		m_refType = refType;
	}

	TempVarDecl* GetDecl() const
	{
		return m_pDecl;
	}

	void SetDecl(TempVarDecl* pDecl)
	{
		m_pDecl = pDecl;
	}

	TempVarType GetVarType() const
	{
		return m_pDecl->GetVarType();
	}

	LexicalScope* GetScope() const
	{
		return m_pScope;
	}

	LexicalScope* GetRealScope() const;

	const Str& GetName() const
	{
		return GetDecl()->GetName();
	}

	const TEXTRANGE& GetTextRange() const
	{
		return m_range;
	}

	//////////////////////////////////////////////
	// Testing

	bool IsShared() const
	{
		return GetVarType() == tvtShared;
	}

	bool IsStack() const
	{
		return GetDecl()->IsStack();
	}

	/////////////////////////////////////////////
	// Operations

	void MergeRefIntoDecl(Compiler* pCompiler);
};

typedef std::vector<TempVarDecl*> DECLLIST;
typedef std::map<Str, TempVarDecl*> DECLMAP;
typedef std::vector<TempVarRef*> REFLIST;
typedef std::map<Str, REFLIST> REFLISTMAP;
typedef std::vector<Oop> OOPVECTOR;

class LexicalScope
{
	LexicalScope*	m_pOuter;

	DECLLIST		m_tempVarDecls;
	REFLISTMAP		m_tempVarRefs;
	DECLLIST		m_copiedTemps;

	TEXTRANGE		m_textRange;		// Range of text this scope represents

	int				m_nArgs;
	int				m_nStackSize;
	int				m_nSharedTemps;
	int				m_initialIP;
	int				m_finalIP;

	POTE			m_oteBlockLiteral;

	// Flags
	bool			m_bIsEmptyBlock;		// An empty block
	bool			m_bIsOptimizedBlock;// Set if scope is for an optimized (inlined) block, i.e. has no run-time representation
	bool			m_bHasFarReturn;	// Set if scope, or an enclosed scope, contains a FarReturn instruction
	bool			m_bRefersToSelf;	// Set if scope refers directly or indirectly to receiver
	bool			m_bRefsOuterTemps;	// Set if scope refers to shared temps from outer contexts

private:
	LexicalScope();
	LexicalScope(const LexicalScope&);

public:
	LexicalScope(LexicalScope* pOuter, int nStart, bool bOptimized) : m_pOuter(pOuter), 
				m_nArgs(0), m_nStackSize(0), m_nSharedTemps(0),
				m_initialIP(-1), m_finalIP(-2),
				m_bIsEmptyBlock(false), m_bIsOptimizedBlock(bOptimized), m_bHasFarReturn(false),
				m_bRefersToSelf(false),	m_bRefsOuterTemps(false),
				m_textRange(nStart, -1), m_oteBlockLiteral(NULL)
	{
	}

	~LexicalScope();

	int GetCopiedValuesCount() const
	{
		return m_copiedTemps.size();
	}

	int GetStackTempCount() const
	{
		return m_nStackSize - GetArgumentCount() - GetCopiedValuesCount();
	}

	int GetTempCount() const
	{
		return m_tempVarDecls.size();
	}

	int GetArgumentCount() const
	{
		return m_nArgs;
	}

	int GetSharedTempsCount() const
	{
		_ASSERTE(!IsOptimizedBlock() || m_nSharedTemps == 0);
		return m_nSharedTemps;
	}

	LexicalScope* GetOuter() const
	{
		return m_pOuter;
	}

	LexicalScope* GetRealOuter() const
	{
		return GetOuter()->GetRealScope();
	}

	// Answer the nearest real (non-optimized) scope. If the scope
	// is itself unoptimized, then this will be the receiver. The
	// actual scope is the scope in which any variables declared in the
	// receiver will actually be allocated.
	LexicalScope* GetRealScope() const
	{
		LexicalScope* pScope = const_cast<LexicalScope*>(this);
		while (pScope != NULL && pScope->IsOptimizedBlock())
		{
			pScope = pScope->GetOuter();
		}

		return pScope;
	}

private:
	void SetOuter(LexicalScope* pOuter)
	{
		m_pOuter = pOuter;
	}

public:
	DECLLIST& GetCopiedTemps()
	{
		return m_copiedTemps;
	}

	int GetStackSize() const
	{
		return m_nStackSize;
	}

	void BeOptimizedBlock();
	void BeEmptyBlock() { m_bIsEmptyBlock = true; }

	void ArgumentAdded(TempVarDecl* pArg)
	{
		pArg->SetIsArgument(true);
		pArg->SetIndex(m_nArgs++);
	}

	int GetDepth() const
	{
		int depth = 0;
		const LexicalScope* current = this;
		const LexicalScope* outer;
		while ((outer = current->GetOuter()) != NULL)
		{
			if (!current->IsOptimizedBlock())
				depth++;
			current = outer;
		}
		return depth;
	}

	int GetLogicalDepth() const
	{
		int depth = 0;
		const LexicalScope* current = this;
		const LexicalScope* outer;
		while ((outer = current->GetOuter()) != NULL)
		{
			depth++;
			current = outer;
		}
		return depth;
	}

	int GetActualDistance(LexicalScope* pDeclScope) const
	{
		const LexicalScope* pScope = GetRealScope();
		int distance = 0;
		while (pScope != pDeclScope)
		{
			_ASSERTE(pScope != NULL);
			pScope = pScope->GetOuter();
			if (pScope->GetSharedTempsCount() != 0)
			{
				_ASSERTE(!pScope->IsOptimizedBlock());
				distance++;
				_ASSERTE(distance <= MAXBLOCKNESTING);
			}
		}

		return distance;
	}

	const TEXTRANGE& GetTextRange() const
	{
		return m_textRange;
	}

	void SetTextStop(int stop)
	{
		m_textRange.m_stop = stop;
	}

	void MarkNeedsSelf()
	{
		m_bRefersToSelf = true;
	}

	void MarkFarReturner()
	{
		if (m_bHasFarReturn) return;

		m_bHasFarReturn = true;
		LexicalScope* outer = GetOuter();
		if (outer != NULL)
		{
			outer->MarkFarReturner();
		}
	}

	void SetReferencesOuterTempsIn(LexicalScope* pDeclScope)
	{
		// This flag is only applicable to block scopes, and must be propagated
		// up to the outermost block as each block in the chain will need a 
		LexicalScope* pScope = this;
		while (pScope != pDeclScope)
		{
			pScope->m_bRefsOuterTemps = true;
			pScope = pScope->GetOuter();
			_ASSERTE(pScope != NULL);
		}
	}

	void SetInitialIP(int ip)
	{
		m_initialIP = ip;
	}

	void MaybeSetInitialIP(int ip)
	{
		if (GetInitialIP() < 0)
		{
			SetInitialIP(ip);
			// If an optimized block, such as a repeat loop, may need to chain out 
			// to the outer scope so that cases such as the following are handled
			// correctly: [[.,..] repeat] value
			if (IsOptimizedBlock())
			{
				GetOuter()->MaybeSetInitialIP(ip);
			}
		}
	}

	int GetInitialIP() const
	{
		return m_initialIP;
	}

	int GetFinalIP() const
	{
		return m_finalIP;
	}

	void SetFinalIP(int ip)
	{
		if (m_finalIP < ip)
		{
			m_finalIP = ip;
			if (GetOuter())
			{
				GetOuter()->SetFinalIP(ip);
			}
		}
	}

	void IncrementIPs()
	{
		if (m_initialIP >= 0)
		{
			_ASSERTE(m_finalIP >= 0);
			m_initialIP++;
			m_finalIP++;

			// If associated with a clean block, we need to update it's initialIP too
			// Note that the initialIP of the block is 1-based, whereas the m_initialIP
			// of this object is zero-based.
			//STBlockClosure* pBlock = GetBlock();
			//if (pBlock != NULL)
			//{
			//	_ASSERTE(IntegerValueOf(pBlock->m_initialIP) == m_initialIP);
			//	pBlock->m_initialIP = IntegerObjectOf(m_initialIP + 1);
			//}
		}
	}

	void SetCleanBlockLiteral(POTE block)
	{
		m_oteBlockLiteral = block;
	}

	STBlockClosure* GetBlock()
	{
		return m_oteBlockLiteral ? reinterpret_cast<STBlockClosure*>(GetObj(m_oteBlockLiteral)) : NULL;
	}
	///////////////////////////////////////////////////////////////////////////
	// Testing

	bool HasFarReturn() const
	{
		return m_bHasFarReturn;
	}

	bool NeedsSelf() const
	{
		return m_bRefersToSelf;
	}

	bool NeedsOuter() const
	{
		return HasFarReturn() || m_bRefsOuterTemps;
	}

	bool IsOptimizedBlock() const
	{
		return m_bIsOptimizedBlock;
	}

	bool IsEmptyBlock() const
	{
		return m_bIsEmptyBlock && GetArgumentCount() == 0;
	}

	bool IsInBlock() const
	{
		return GetOuter() != NULL 
				&& (!IsOptimizedBlock() || GetOuter()->IsInBlock());
	}

	bool IsBlock() const
	{
		return GetOuter() != NULL && !IsOptimizedBlock();
	}


	// Clean blocks can be allocated statically as they don't close over any
	// of their creation time environment and don't contain a ^-return
	bool IsCleanBlock() const
	{
		return IsBlock() 
				&& !NeedsSelf() 
				&& !NeedsOuter() 
				&& GetSharedTempsCount() == 0
				&& GetCopiedValuesCount() == 0;
	}

	/////////////////////////////////////////////////////////////////
	// Searching

	TempVarDecl* FindTempDecl(const Str&);

	////////////////////////////////////////////////////////////////
	// Operations

	void RenameTemporary(int, const Str&, const TEXTRANGE&);
	TempVarDecl* CopyTemp(TempVarDecl* pTemp, Compiler*);
	TempVarRef* AddTempRef(TempVarDecl*, VarRefType, const TEXTRANGE&);
	void CopyTemps(Compiler*);
	void AllocTempIndices(Compiler*);
	void PropagateOuterRequirements();
	void AddTempDecl(TempVarDecl* pDecl, Compiler*);
	void PatchOptimized(Compiler*);
	void PatchBlockLiteral(IDolphin*, POTE oteMethod);

	POTE BuildTempMapEntry(IDolphin*) const;

private:
	void PropagateNeedsSelf();
	void PropagateFarReturn();
	void AddVisibleDeclsTo(DECLMAP&) const;
	void AddSharedDeclsTo(DECLMAP& allSharedDecls) const;
	void CopyDownOptimizedDecls(Compiler*);
};

inline int TempVarRef::GetEstimatedDistance() const
{
	// Note that this will be an overestimate until the optimized scopes have been
	// unlinked.
	return GetRealScope()->GetDepth() - GetDecl()->GetScope()->GetDepth();
}

