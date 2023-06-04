/*
==========
LexicalScope.h
==========
*/
#pragma once

#include "Str.h"
#include <vector>
#include <map>
#include "bytecode.h"
#include "textrange.h"

#define TEMPORARYLIMIT 		255		// maximum number of temporaries permitted (ditto)
#define MAXBLOCKNESTING		255		// maximum depth to which blocks (actually contexts) can be nested


enum class TempVarType { 
	Unaccessed=0,	// Temp variable which is not accessed at all
	Stack,			// Temp variable accessed only from local scope (or optimized blocks)
	Copied,			// Temp variable which is closed over, but only read after closure
	Shared,			// Temp variable which is written after being closed over
	Copy,			// Temp variable decl created to represent a copied temp in the closure
	};		

enum class VarRefType 
{
	Unknown = 0, 
	Read=1, 
	Write=2, 
	ReadWrite=3 
};
ENABLE_BITMASK_OPERATORS(VarRefType)

class LexicalScope;
class TempVarRef;
class Compiler;

class TempVarDecl
{
	u8string		m_strName;
	TEXTRANGE		m_range;
	LexicalScope*	m_pScope;
	TempVarType		m_varType;
	VarRefType		m_refType;
	TempVarDecl*	m_pOuter;
	size_t			m_nIndex;
	bool			m_bInvisible;	// Not visible in this scope (used for real declarations of temps in optimized blocks)
	bool			m_bIsArgument;
	bool			m_bIsReadOnly;

public:
	TempVarDecl(const u8string& strName, const TEXTRANGE& range) : 
			m_strName(strName), m_pScope(nullptr), m_range(range),
			m_varType(TempVarType::Unaccessed), m_refType(VarRefType::Unknown), m_pOuter(nullptr),
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

	__declspec(property(get = get_VarType, put = put_VarType)) TempVarType VarType;
	TempVarType get_VarType() const
	{
		return m_varType;
	}
	void put_VarType(TempVarType varType)
	{
		m_varType = varType;
	}

	__declspec(property(get = get_RefType)) VarRefType RefType;
	VarRefType get_RefType() const
	{
		return m_refType;
	}

	__declspec(property(get = get_Index, put=put_Index)) size_t Index;
	size_t get_Index() const
	{
		return m_varType == TempVarType::Copy || Outer == nullptr
					? m_nIndex
					: Outer->Index;
	}
	void put_Index(size_t index)
	{
		_ASSERTE(m_varType == TempVarType::Copy || Outer == nullptr);
		m_nIndex = index;
	}

	__declspec(property(get = get_Name, put = put_Name)) const u8string& Name;
	const u8string& get_Name() const
	{
		return m_strName;
	}
	void put_Name(const u8string& strName)
	{
		m_strName = strName;
	}

	__declspec(property(get = get_Scope, put = put_Scope)) LexicalScope* Scope;
	LexicalScope* get_Scope() const
	{
		return m_pScope;
	}
	void put_Scope(LexicalScope* pScope)
	{
		m_pScope = pScope;
	}

	__declspec(property(get = get_ActualScope)) LexicalScope* ActualScope;
	LexicalScope* get_ActualScope() const
	{
		return ActualDecl->Scope;
	}

	__declspec(property(get = get_Outer, put = put_Outer)) TempVarDecl* Outer;
	TempVarDecl* get_Outer() const
	{
		return m_pOuter;
	}
	void put_Outer(TempVarDecl* pOuter)
	{
		m_pOuter = pOuter;
	}

	__declspec(property(get = get_TextRange, put = put_TextRange)) const TEXTRANGE& TextRange;
	const TEXTRANGE& get_TextRange() const
	{
		return m_range;
	}
	void put_TextRange(const TEXTRANGE& range)
	{
		m_range = range;
	}

	__declspec(property(get = get_ActualDecl)) TempVarDecl* ActualDecl;
	TempVarDecl* get_ActualDecl() const
	{
		TempVarDecl* pDecl = const_cast<TempVarDecl*>(this);
		while (pDecl->m_pOuter != nullptr)
			pDecl = pDecl->m_pOuter;

		return pDecl;
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
	__declspec(property(get = get_IsArgument, put = put_IsArgument)) bool IsArgument;
	bool get_IsArgument() const
	{
		return m_bIsArgument;
	}
	void put_IsArgument(bool bIsArgument)
	{
		m_bIsArgument = bIsArgument;
		if (bIsArgument)
			BeReadOnly();
	}

	__declspec(property(get = get_IsStack)) bool IsStack;
	bool get_IsStack() const
	{
		switch (m_varType)
		{
		case TempVarType::Copy:
//			break;
		case TempVarType::Stack:
		case TempVarType::Copied:
			return true;
		case TempVarType::Unaccessed:
			return m_bIsReadOnly;
		case TempVarType::Shared:
		default:
			break;
		}
		return false;
	}

	__declspec(property(get = get_IsReferenced)) bool IsReferenced;
	bool get_IsReferenced() const
	{
		return m_varType != TempVarType::Unaccessed || m_bIsReadOnly;
	}

	__declspec(property(get = get_IsVisible)) bool IsVisible;
	bool get_IsVisible() const
	{
		return !m_bInvisible;
	}

	__declspec(property(get = get_IsReadOnly)) bool IsReadOnly;
	bool get_IsReadOnly() const
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

	unsigned GetEstimatedDistance() const;
	unsigned GetActualDistance() const;

	__declspec(property(get = get_RefType, put = put_RefType)) VarRefType RefType;
	VarRefType get_RefType() const
	{
		return m_refType;
	}
	void put_RefType(VarRefType refType)
	{
		_ASSERTE(refType >= m_refType);
		m_refType = refType;
	}

	__declspec(property(get = get_Decl, put = put_Decl)) TempVarDecl* Decl;
	TempVarDecl* get_Decl() const
	{
		return m_pDecl;
	}
	void put_Decl(TempVarDecl* pDecl)
	{
		m_pDecl = pDecl;
	}

	__declspec(property(get = get_VarType)) TempVarType VarType;
	TempVarType get_VarType() const
	{
		return m_pDecl->VarType;
	}

	__declspec(property(get = get_Scope)) LexicalScope* Scope;
	LexicalScope* get_Scope() const
	{
		return m_pScope;
	}

	__declspec(property(get = get_RealScope)) LexicalScope* RealScope;
	LexicalScope* get_RealScope() const;

	__declspec(property(get = get_Name)) const u8string& Name;
	const u8string& get_Name() const
	{
		return Decl->Name;
	}

	__declspec(property(get = get_TextRange)) const TEXTRANGE& TextRange;
	const TEXTRANGE& get_TextRange() const
	{
		return m_range;
	}

	//////////////////////////////////////////////
	// Testing

	__declspec(property(get = get_IsShared)) bool IsShared;
	bool get_IsShared() const
	{
		return VarType == TempVarType::Shared;
	}

	__declspec(property(get = get_IsStack)) bool IsStack;
	bool get_IsStack() const
	{
		return Decl->IsStack;
	}

	/////////////////////////////////////////////
	// Operations

	void MergeRefIntoDecl(Compiler* pCompiler);
};

typedef vector<TempVarDecl*> DECLLIST;
typedef map<u8string, TempVarDecl*> DECLMAP;
typedef vector<TempVarRef*> REFLIST;
typedef map<u8string, REFLIST> REFLISTMAP;
typedef vector<Oop> OOPVECTOR;

typedef size_t tempcount_t;
typedef size_t argcount_t;

class LexicalScope
{
	LexicalScope*	m_pOuter;

	DECLLIST		m_tempVarDecls;
	REFLISTMAP		m_tempVarRefs;
	DECLLIST		m_copiedTemps;

	TEXTRANGE		m_textRange;		// Range of text this scope represents

	argcount_t		m_nArgs;
	tempcount_t		m_nStackSize;
	tempcount_t		m_nSharedTemps;
	ip_t			m_initialIP;
	ip_t			m_finalIP;

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
	LexicalScope(LexicalScope* pOuter, textpos_t nStart, bool bOptimized) : m_pOuter(pOuter), 
				m_nArgs(0), m_nStackSize(0), m_nSharedTemps(0),
				m_initialIP(ip_t::npos), m_finalIP(ip_t::npos),
				m_bIsEmptyBlock(false), m_bIsOptimizedBlock(bOptimized), m_bHasFarReturn(false),
				m_bRefersToSelf(false),	m_bRefsOuterTemps(false),
				m_textRange(nStart, textpos_t::npos), m_oteBlockLiteral(nullptr)
	{
	}

	~LexicalScope();

	__declspec(property(get = get_CopiedValuesCount)) tempcount_t CopiedValuesCount;
	tempcount_t get_CopiedValuesCount() const
	{
		return static_cast<tempcount_t>(m_copiedTemps.size());
	}

	__declspec(property(get = get_StackTempCount)) tempcount_t StackTempCount;
	tempcount_t get_StackTempCount() const
	{
		return m_nStackSize - ArgumentCount - CopiedValuesCount;
	}

	__declspec(property(get = get_TempCount)) tempcount_t TempCount;
	tempcount_t get_TempCount() const
	{
		return static_cast<tempcount_t>(m_tempVarDecls.size());
	}

	__declspec(property(get = get_ArgumentCount)) argcount_t ArgumentCount;
	argcount_t get_ArgumentCount() const
	{
		return m_nArgs;
	}

	__declspec(property(get = get_SharedTempsCount)) tempcount_t SharedTempsCount;
	tempcount_t get_SharedTempsCount() const
	{
		_ASSERTE(!IsOptimizedBlock || m_nSharedTemps == 0);
		return m_nSharedTemps;
	}

	__declspec(property(get = get_Outer, put = put_Outer)) LexicalScope* Outer;
	LexicalScope* get_Outer() const
	{
		return m_pOuter;
	}

	__declspec(property(get = get_RealOuter)) LexicalScope* RealOuter;
	LexicalScope* get_RealOuter() const
	{
		return Outer->RealScope;
	}

	// Answer the nearest real (non-optimized) scope. If the scope
	// is itself unoptimized, then this will be the receiver. The
	// actual scope is the scope in which any variables declared in the
	// receiver will actually be allocated.
	__declspec(property(get = get_RealScope)) LexicalScope* RealScope;
	LexicalScope* get_RealScope() const
	{
		LexicalScope* pScope = const_cast<LexicalScope*>(this);
		while (pScope != nullptr && pScope->IsOptimizedBlock)
		{
			pScope = pScope->Outer;
		}

		return pScope;
	}

private:
	void put_Outer(LexicalScope* pOuter)
	{
		m_pOuter = pOuter;
	}

public:
	DECLLIST& GetCopiedTemps()
	{
		return m_copiedTemps;
	}

	__declspec(property(get = get_StackSize)) tempcount_t StackSize;
	tempcount_t get_StackSize() const
	{
		return m_nStackSize;
	}

	void BeOptimizedBlock();
	void BeEmptyBlock() { m_bIsEmptyBlock = true; }

	void ArgumentAdded(TempVarDecl* pArg)
	{
		pArg->IsArgument = true;
		pArg->Index = m_nArgs++;
	}

	unsigned GetDepth() const
	{
		unsigned depth = 0;
		const LexicalScope* current = this;
		const LexicalScope* outer;
		while ((outer = current->Outer) != nullptr)
		{
			if (!current->IsOptimizedBlock)
				depth++;
			current = outer;
		}
		return depth;
	}

	unsigned GetLogicalDepth() const
	{
		unsigned depth = 0;
		const LexicalScope* current = this;
		const LexicalScope* outer;
		while ((outer = current->Outer) != nullptr)
		{
			depth++;
			current = outer;
		}
		return depth;
	}

	unsigned GetActualDistance(LexicalScope* pDeclScope) const
	{
		const LexicalScope* pScope = RealScope;
		unsigned distance = 0;
		while (pScope != pDeclScope)
		{
			_ASSERTE(pScope != nullptr);
			pScope = pScope->Outer;
			if (pScope->SharedTempsCount != 0)
			{
				_ASSERTE(!pScope->IsOptimizedBlock);
				distance++;
				_ASSERTE(distance <= MAXBLOCKNESTING);
			}
		}

		return distance;
	}

	__declspec(property(get = get_TextRange)) const TEXTRANGE& TextRange;
	const TEXTRANGE& get_TextRange() const
	{
		return m_textRange;
	}

	void SetTextStop(textpos_t stop)
	{
		m_textRange.m_stop = stop;
	}

	void MarkNeedsSelf()
	{
		m_bRefersToSelf = true;
	}

	void MarkFarReturner()
	{
		if (HasFarReturn) return;

		m_bHasFarReturn = true;
		LexicalScope* outer = Outer;
		if (outer != nullptr)
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
			pScope = pScope->Outer;
			_ASSERTE(pScope != nullptr);
		}
	}

	void MaybeSetInitialIP(ip_t ip)
	{
		if (InitialIP == ip_t::npos)
		{
			InitialIP = ip;
			// If an optimized block, such as a repeat loop, may need to chain out 
			// to the outer scope so that cases such as the following are handled
			// correctly: [[.,..] repeat] value
			if (IsOptimizedBlock)
			{
				Outer->MaybeSetInitialIP(ip);
			}
		}
	}

	__declspec(property(get = get_InitialIP, put=put_InitialIP)) ip_t InitialIP;
	ip_t get_InitialIP() const
	{
		return m_initialIP;
	}
	void put_InitialIP(ip_t ip)
	{
		_ASSERTE(ip >= ip_t::zero);
		m_initialIP = ip;
	}

	__declspec(property(get = get_FinalIP, put=put_FinalIP)) ip_t FinalIP;
	ip_t get_FinalIP() const
	{
		return m_finalIP;
	}

	void put_FinalIP(ip_t ip)
	{
		if (m_finalIP < ip)
		{
			m_finalIP = ip;
			// Clean blocks are moved out of line of the parent scope
			if (Outer != nullptr && !IsCleanBlock)
			{
				Outer->FinalIP = ip;
			}
		}
	}

	void AdjustFinalIP(int delta)
	{
		m_finalIP += delta;
	}

	__declspec(property(get = get_CodeLength)) intptr_t CodeLength;
	intptr_t get_CodeLength() const
	{
		return m_initialIP == ip_t::npos ? 0 : static_cast<intptr_t>(m_finalIP - m_initialIP + 1);
	}

	void IncrementIPs()
	{
		if (m_initialIP != ip_t::npos)
		{
			_ASSERTE(m_finalIP != ip_t::npos);
			++m_initialIP;
			++m_finalIP;

			// We don't need to update the initial IP of any clean blocks as this is not
			// set until after all bytecode generation is complete
			_ASSERTE(Block == nullptr || !IsIntegerObject(Block->m_initialIP));
		}
	}

	void SetCleanBlockLiteral(POTE block)
	{
		m_oteBlockLiteral = block;
	}

	__declspec(property(get = get_Block)) STBlockClosure* Block;
	STBlockClosure* get_Block()
	{
		return m_oteBlockLiteral ? reinterpret_cast<STBlockClosure*>(GetObj(m_oteBlockLiteral)) : nullptr;
	}

	///////////////////////////////////////////////////////////////////////////
	// Testing

	__declspec(property(get = get_HasFarReturn)) bool HasFarReturn;
	bool get_HasFarReturn() const
	{
		return m_bHasFarReturn;
	}

	__declspec(property(get = get_NeedsSelf)) bool NeedsSelf;
	bool get_NeedsSelf() const
	{
		return m_bRefersToSelf;
	}

	__declspec(property(get = get_NeedsOuter)) bool NeedsOuter;
	bool get_NeedsOuter() const
	{
		return HasFarReturn || m_bRefsOuterTemps;
	}

	__declspec(property(get = get_IsOptimizedBlock)) bool IsOptimizedBlock;
	bool get_IsOptimizedBlock() const
	{
		return m_bIsOptimizedBlock;
	}

	__declspec(property(get = get_IsEmptyBlock)) bool IsEmptyBlock;
	bool get_IsEmptyBlock() const
	{
		return m_bIsEmptyBlock && ArgumentCount == 0;
	}

	__declspec(property(get = get_IsInBlock)) bool IsInBlock;
	bool get_IsInBlock() const
	{
		return Outer != nullptr && (!IsOptimizedBlock || Outer->IsInBlock);
	}

	__declspec(property(get = get_IsBlock)) bool IsBlock;
	bool get_IsBlock() const
	{
		return Outer != nullptr && !IsOptimizedBlock;
	}


	// Clean blocks can be allocated statically as they don't close over any
	// of their creation time environment and don't contain a ^-return
	__declspec(property(get = get_IsCleanBlock)) bool IsCleanBlock;
	bool get_IsCleanBlock() const
	{
		return IsBlock 
				&& !NeedsSelf
				&& !NeedsOuter
				&& SharedTempsCount == 0
				&& CopiedValuesCount == 0;
	}

	/////////////////////////////////////////////////////////////////
	// Searching

	TempVarDecl* FindTempDecl(const u8string&);

	////////////////////////////////////////////////////////////////
	// Operations

	void RenameTemporary(tempcount_t, const u8string&, const TEXTRANGE&);
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

inline unsigned TempVarRef::GetEstimatedDistance() const
{
	// Note that this will be an overestimate until the optimized scopes have been
	// unlinked.
	return RealScope->GetDepth() - Decl->Scope->GetDepth();
}

