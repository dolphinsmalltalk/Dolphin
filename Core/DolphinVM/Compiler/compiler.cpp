/*
============
Compiler.cpp
============
Smalltalk compiler.
*/

///////////////////////

#include "stdafx.h"

#include "Compiler.h"
#include "..\Compiler_i.h"

// Disable warnings about using SEH
#pragma warning ( disable : 4509 )

#include <crtdbg.h>
#define CHECKREFERENCES

#ifdef _DEBUG
static int compilationTrace = 0;

#ifdef USE_VM_DLL
void __cdecl DolphinTrace(LPCTSTR format, ...) 
{
	TCHAR buf[1024];
	va_list args;
	va_start(args, format);
	::StringCbVPrintf(buf, sizeof(buf), format, args);
	va_end(args);
	OutputDebugString(buf);
}
#endif

#elif !defined(USE_VM_DLL)
#undef NDEBUG
#include <assert.h>
#undef _ASSERTE
#define _ASSERTE assert
#endif

extern HMODULE __stdcall GetResLibHandle();

static const LPUTF8 VarSelf = (LPUTF8)"self";
static const LPUTF8 VarSuper = (LPUTF8)"super";
static const LPUTF8 VarThisContext = (LPUTF8)"thisContext";

LPUTF8 s_restrictedSelectors[] =
{
	(LPUTF8)"==",			// Cannot be overridded or redefined at all
	(LPUTF8)"and:", (LPUTF8)"or:",	// Compiler assumes receiver is a boolean, so can't be overridden/redefined
	(LPUTF8)"ifTrue:", (LPUTF8)"ifFalse:", (LPUTF8)"ifTrue:ifFalse:", (LPUTF8)"ifFalse:ifTrue:",	// "ditto"
	(LPUTF8)"ifNil:", (LPUTF8)"ifNotNil:", (LPUTF8)"ifNil:ifNotNil:", (LPUTF8)"ifNotNil:ifNil:",
	(LPUTF8)"to:do:", (LPUTF8)"to:by:do:",	// Compiler assumes that the receiver is a number, implementation is effectively fixed
	(LPUTF8)"timesRepeat:",			// ditto
	(LPUTF8)"basicAt:", (LPUTF8)"basicAt:put:", (LPUTF8)"basicSize", (LPUTF8)"basicClass", (LPUTF8)"basicNew:",	// Can't be redefined/overridden
	(LPUTF8)"yourself",

	// Although these are inlined, this is done only conditionally depending on whether the receiver
	// is a zero-arg literal block, therefore they can in fact be implemented in other objects than block
	// even if the implementation for blocks is fixed.
	//
	// "whileFalse", "whileFalse:",
	// "whileTrue", "whileTrue:",
	// "repeat",
};

#define NumRestrictedSelectors (sizeof(s_restrictedSelectors)/sizeof(LPUTF8))

///////////////////////


Compiler::LibCallType Compiler::callTypes[4] =
{
	(LPUTF8)"stdcall:", DolphinX::ExtCallDeclSpec::StdCall,
	(LPUTF8)"cdecl:", DolphinX::ExtCallDeclSpec::CDecl,
	(LPUTF8)"thiscall:", DolphinX::ExtCallDeclSpec::ThisCall,
	(LPUTF8)"fastcall:", DolphinX::ExtCallDeclSpec::FastCall
};

///////////////////////

Compiler::Compiler() :
		m_class(nullptr),
		m_codePointer(ip_t::zero),
		m_compiledMethodClass(nullptr),
		m_compilerObject(0),
		m_context(0),
		m_flags(CompilerFlags::Default),
		m_instVarsInitialized(false),
		m_isMutable(false),
		m_isCompilingExpression(false),
		m_literalLimit(LITERALLIMIT),
		m_notifier(0),
		m_ok(true),
		m_oopWorkspacePools(nullptr),
		m_pCurrentScope(nullptr),
		m_primitiveIndex(0),
		m_selector(),
		m_sendType(SendType::Other)
{
}
	
Compiler::~Compiler()
{
	// Free scopes
	{
		const size_t count = m_allScopes.size();
		for (size_t i = 0; i < count ; i++)
		{
			LexicalScope* pScope = m_allScopes[i];
			delete pScope;
		}
	}

	// Free literal frame
	{
		for(LiteralMap::const_iterator it = m_literals.cbegin(); it != m_literals.cend(); it++)
		{
			m_piVM->RemoveReference((*it).first);
		}
	}
}

inline void Compiler::SetFlagsAndText(CompilerFlags flags, LPUTF8 text, textpos_t offset)
{
	m_flags=flags;
	SetText(text, offset);
	NextToken();
}
	
void Compiler::PrepareToCompile(CompilerFlags flags, LPUTF8 compiletext, textpos_t offset, POTE aBehaviorOrNil, Oop compiler, Oop notifier, POTE workspacePools, boolean isCompilingExpression, Oop context)
{
	// Prepare to compile methods for the given class.
	// This gets the list of instance variable names for this class
	// and all its super classes so we can find the indices later.
	
	m_isCompilingExpression = isCompilingExpression;
	m_compiledMethodClass = isCompilingExpression ? GetVMPointers().ClassCompiledExpression : GetVMPointers().ClassCompiledMethod;
	_ASSERTE(aBehaviorOrNil);
	m_class = aBehaviorOrNil;
	_ASSERTE(notifier);
	m_notifier=notifier;
	_ASSERTE(compiler);
	m_compilerObject=compiler;

	m_context = context;

	SetFlagsAndText(flags, compiletext, offset);
	
	GetContext(workspacePools);
}

Str Compiler::GetNameOfClass(Oop oopClass, bool recurse)
{
	if (!(m_piVM->IsBehavior(oopClass)))
	{
		char szPrompt[256];
		::LoadString(GetResLibHandle(), IDS_P_NOTACLASS, szPrompt, sizeof(szPrompt)-1);
		Str actualClassName = recurse ? GetNameOfClass(Oop(m_piVM->FetchClassOf(oopClass)), false) : u8"invalid object";
		char8_t buf[512];
		VERIFY(wsprintf((LPSTR)buf, szPrompt, actualClassName.c_str())>=0);
		return buf;
	}
	else
	{
		POTE oteClass = (POTE)oopClass;
		if (m_piVM->IsAMetaclass(oteClass))
		{
			STMetaclass* meta = (STMetaclass*)GetObj(oteClass);
			POTE instClass = meta->instanceClass;
			Str className = GetNameOfClass(Oop(instClass),false);
			className += (LPUTF8)" class";
			return className;
		}
		else
		{
			_ASSERTE(m_piVM->IsAClass(oteClass));
			STClass* cl = (STClass*)GetObj(oteClass);
			return MakeString(m_piVM, cl->name);
		}
	}
}

POTE Compiler::CompileExpression(LPUTF8 compiletext, Oop compiler, Oop notifier, Oop contextOop, CompilerFlags flags, size_t& len, textpos_t exprStart)
{
	POTE classPointer = m_piVM->FetchClassOf(contextOop);
	PrepareToCompile(flags, compiletext, exprStart, classPointer, compiler, notifier, Nil(), true, contextOop);
	POTE oteMethod;
	if (m_ok)
	{
		oteMethod = ParseEvalExpression(TokenType::CloseParen);
	}
	else
		oteMethod = Nil();

	len = ParsedLength;

	return oteMethod;
}

POTE Compiler::CompileForClassHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aClass, CompilerFlags flags)
{
	BOOL wasDisabled = m_piVM->DisableAsyncGC(true);
	POTE method = Nil();
	__try
	{
		if (!(flags & CompilerFlags::ScanOnly))
		{
			PrepareToCompile(flags, compiletext, textpos_t::start, aClass, compiler, notifier, Nil(), false);
			if (m_ok)
				// Do the compile
				method=ParseMethod();
		}
		else
		{
			while (!AtEnd)
				NextToken();
		}
	}
	__finally
	{
		m_piVM->DisableAsyncGC(wasDisabled);
	}
	return method;
}

POTE Compiler::CompileForEvaluationHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aBehaviorOrNil, POTE aWorkspacePool, CompilerFlags flags)
{
	BOOL wasDisabled = m_piVM->DisableAsyncGC(true);
	POTE method = Nil();
	__try
	{
		PrepareToCompile(flags, compiletext, textpos_t::start, aBehaviorOrNil, compiler, notifier,  aWorkspacePool, true);
		if (m_ok)
		{
			method = ParseEvalExpression(TokenType::Eof);
			if (m_ok && ThisToken != TokenType::Eof)
				CompileError(CErrNonsenseAtMethodEnd);
		}
	}
	__finally
	{
		m_piVM->DisableAsyncGC(wasDisabled);
	}
	return method;
}


Str Compiler::GetClassName()
{
	return m_class == Nil() ? (LPUTF8)u8"nil" : GetNameOfClass(reinterpret_cast<Oop>(m_class));
}

///////////////////////////////////


inline OpCode Compiler::FindNameAsSpecialMessage(const Str& name) const
{
	// Returns true and an appropriate (index) if (name) is a
	// special message
	//
	
	const VMPointers& pointers = GetVMPointers();
	for (uint8_t i = 0; i < NumSpecialSelectors; i++)
	{
		const POTE stringPointer = pointers.specialSelectors[i];
		_ASSERTE(m_piVM->IsKindOf(Oop(stringPointer), pointers.ClassSymbol));
		LPUTF8 psz = (LPUTF8)FetchBytesOf(stringPointer);
		if (name == psz)
		{
			return OpCode::ShortSpecialSend + i;
		}
	}

	for (uint8_t i = 0; i < NumExSpecialSends; i++)
	{
		const POTE stringPointer = pointers.exSpecialSelectors[i];
		if (stringPointer != pointers.Nil)
		{
			_ASSERTE(m_piVM->IsKindOf(Oop(stringPointer), pointers.ClassSymbol));
			LPUTF8 psz = (LPUTF8)FetchBytesOf(stringPointer);
			if (name == psz)
			{
				return OpCode::ShortSpecialSendEx + i;
			}
		}
	}

	return static_cast<OpCode>(0);
}

inline size_t Compiler::FindNameAsInstanceVariable(const Str& name) const
{
	// Search for an instance variable if (name) and return true and its
	// (index) if one is found. We go through the list backwards for speed
	// rather than a necessity of scoping.
	//
	if (!m_instVarsInitialized) const_cast<Compiler*>(this)->GetInstVars();

	for (size_t i=m_instVars.size(); i>0; i--)
	{
		if (name == m_instVars[i-1])
			return i - 1;
	}
	return -1;
}

TempVarRef* Compiler::AddTempRef(const Str& strName, VarRefType refType, const TEXTRANGE& range, textpos_t expressionEnd)
{
	// Search for a temporary variable of (name) and return true and its
	// (index) if one is found. We MUST look through the list backwards to
	// get correct scoping.
	//
	LexicalScope* pScope = m_pCurrentScope;

	TempVarDecl* pDecl = pScope->FindTempDecl(strName);
	if (pDecl == nullptr)
		// Undeclared
		return nullptr;

	if (pDecl->IsReadOnly && refType > VarRefType::Read)
	{
		CompileError(TEXTRANGE(range.m_start, expressionEnd), CErrAssignmentToArgument, 
						(Oop)NewUtf8String(strName));
		return nullptr;
	}

	// Create a new usage ref and return it
	return pScope->AddTempRef(pDecl, refType, range);
}

Compiler::StaticType Compiler::FindNameAsStatic(const Str& name, POTE& oteStatic, bool autoDefine)
{
	// Finds the given name as a shared global or class variable or pool variable
	// and if it exists ensures that it is installed in the current literal frame.
	POTE nil = Nil();
	oteStatic = nil;

	Oop scope = reinterpret_cast<Oop>(m_class == nil ? GetVMPointers().SmalltalkDictionary : m_class);
	POTE oteBinding = reinterpret_cast<POTE>(m_piVM->PerformWith(scope, GetVMPointers().fullBindingForSymbol, 
												reinterpret_cast<Oop>(NewUtf8String(name))));
	STVarObject* pools = nullptr;
	// Look in Workspace pools (if any) next
	if (oteBinding == nil && m_oopWorkspacePools != nil)
	{
		pools = (STVarObject*)GetObj(m_oopWorkspacePools);
		const size_t poolsSize = FetchWordLengthOf(m_oopWorkspacePools);
		for (size_t i=0; i<poolsSize; i++)
		{
			POTE pool = reinterpret_cast<POTE>(pools->fields[i]);
			if (pool != nil)
			{
				oteBinding = FindDictVariable(pool, name);
				if (oteBinding != nil)
					break;
			}
		}
	}

	if (oteBinding == nil && autoDefine)
	{
		if (IsCharUpper(name[0]))
		{
			if (IsInteractive)
			{
				char szPrompt[256];
				::LoadString(GetResLibHandle(), IDP_AUTO_DEFINE_GLOBAL, szPrompt, sizeof(szPrompt)-1);
				char* msg = new char[strlen(szPrompt)+name.size()+32];
				::wsprintf(msg, szPrompt, name.c_str());
				char szCaption[256];
				::LoadString(GetResLibHandle(), IDR_COMPILER, szCaption, sizeof(szCaption)-1);
				int answer = ::MessageBox(nullptr, msg, szCaption, MB_YESNOCANCEL|MB_ICONQUESTION|MB_TASKMODAL);
				delete[] msg;
				
				switch(answer)
				{
				case IDYES:
					{
						DictAtPut(GetVMPointers().SmalltalkDictionary, name, Oop(Nil()));
						oteBinding = FindDictVariable(GetVMPointers().SmalltalkDictionary, name);
					}
					break;
				case IDCANCEL:
					return StaticType::Cancel;
					
				case IDNO:
				default:
					break;
				}
			}
		}
		else
		{
			if (!WantSyntaxCheckOnly && pools != nullptr)
			{
				POTE pool = reinterpret_cast<POTE>(pools->fields[0]);
				if (pool != nil)
				{
					DictAtPut(pool, name, reinterpret_cast<Oop>(nil));
					oteBinding = FindDictVariable(pool, name);
				}
			}
		}
	}
	
	if (oteBinding != nil)
	{
		StaticType sharedType = m_piVM->IsImmutable(reinterpret_cast<Oop>(oteBinding)) ? StaticType::Constant : StaticType::Variable;
		oteStatic = oteBinding;
		return sharedType;
	}
	else
		return StaticType::NotFound;
}

//////////////////////////////////////////////////////////////

// Add a new temporary at the top of the temporaries stack
TempVarDecl* Compiler::AddTemporary(const Str& name, const TEXTRANGE& range, bool isArg)
{
	TempVarDecl* pVar = nullptr;

	CheckTemporaryName(name, range, isArg);
	if (m_ok)
		pVar = DeclareTemp(name, range);

	return pVar;
}

TempVarDecl* Compiler::AddArgument(const Str& name, const TEXTRANGE& range)
{
	TempVarDecl* pNewVar = AddTemporary(name, range, true);
	if (pNewVar == nullptr)
		return nullptr;
	
	m_pCurrentScope->ArgumentAdded(pNewVar);
	return pNewVar;
}

// Rename the temporary at location "temporary" to the name "newName"
void Compiler::RenameTemporary(tempcount_t temporary, LPUTF8 newName, const TEXTRANGE& range)
{
	CheckTemporaryName(newName, range, false);
	m_pCurrentScope->RenameTemporary(temporary, newName, range);
}

void Compiler::CheckTemporaryName(const Str& name, const TEXTRANGE& range, bool isArg)
{
	if (strspn((LPCSTR)name.c_str(), (LPCSTR)GENERATEDTEMPSTART) != 0)
		return;

	if (IsPseudoVariable(name))
	{
		CompileError(range, CErrRedefiningPseudoVar);
		return;
	}

	TempVarDecl* pDecl = m_pCurrentScope->FindTempDecl(name);
	if (pDecl && pDecl->Scope == m_pCurrentScope)
	{
		if (isArg)
		{
			_ASSERTE(pDecl->IsArgument);
			CompileError(range, CErrDuplicateArgName);
		}
		else
			CompileError(range, pDecl->IsArgument ? CErrRedefiningArg : CErrDuplicateTempName);
	}

	if (IsInteractive)
	{
		if (pDecl)
			Warning(range, pDecl->IsArgument ? CWarnRedefiningArg : CWarnRedefiningTemp);
		else if (FindNameAsInstanceVariable(name) != -1)
			Warning(range, CWarnRedefiningInstVar);
		else
		{
			POTE oteStatic;
			if (FindNameAsStatic(name, oteStatic) > StaticType::NotFound)
			{
				m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
				Warning(range, CWarnRedefiningStatic);
			}
		}
	}
}

//////////////////////////////////////////////////

ip_t Compiler::GenByte(uint8_t value, BYTECODE::Flags flags, LexicalScope* pScope)
{
 	_ASSERTE(m_pCurrentScope != nullptr);
	InsertByte(m_codePointer, value, flags, pScope);
	ip_t ip = m_codePointer;
	m_codePointer++;
	return ip;
}

// Insert an extended instruction at the code pointer, returning the position at which
// the instruction was inserted.
inline ip_t Compiler::GenInstructionExtended(OpCode basic, uint8_t extension)
{
	ip_t pos=GenInstruction(basic);
	GenData(extension);
	return pos;
}

// Insert an extended instruction at the code pointer, returning the position at which
// the instruction was inserted.
ip_t Compiler::GenLongInstruction(OpCode basic, uint16_t extension)
{
	// Generate a double extended instruction.
	//
	ip_t pos=GenInstruction(basic);
	GenData(extension & UINT8_MAX);
	GenData(extension >> 8);
	return pos;
}

void Compiler::UngenInstruction(ip_t pos)
{
	BYTECODE& bc = m_bytecodes[pos];
	_ASSERTE(bc.IsOpCode);
	_ASSERTE(FindTextMapEntry(pos) == m_textMaps.end());
	
	// Marks the byte at pos as being unwanted by changing it to a Nop
	if (bc.IsJumpSource)
	{
		m_bytecodes[bc.target].removeJumpTo();
		bc.makeNonJump();
	}
	
	const size_t len = bc.InstructionLength;
	// Nop-out the instruction (N.B. doesn't remove it!)
	bc.Opcode = OpCode::Nop;
	// Also nop-out any data bytes associated with the instruction
	for (size_t i=1;i<len;i++)
		UngenData(pos+i, bc.pScope);
}

// Opens up a space at pos in the code array
// Adjusts any jumps that occur over the boundary

void Compiler::InsertByte(ip_t pos, uint8_t value, BYTECODE::Flags flags, LexicalScope* pScope)
{
	const ip_t codeSize = static_cast<ip_t>(CodeSize);

	if (pos == codeSize)
	{
		m_bytecodes.push_back(BYTECODE(value, flags, pScope));
	}
	else
	{
		_ASSERTE(pos < codeSize);
		m_bytecodes.insert(m_bytecodes.begin()+static_cast<size_t>(pos), BYTECODE(value, flags, pScope));

		// New byte may become jump target
		// Adjust the jumps providing we are not appending to the end of the code.
		// Note use of <= because we have inserted an additional bytecode
		for (ip_t i=ip_t::zero; i <= codeSize; i++)
		{
			BYTECODE& bc = m_bytecodes[i];
			if (bc.IsJumpSource)
			{
				_ASSERTE(static_cast<size_t>(bc.target) < CodeSize - 1);

				// This is a jump. Does it cross the boundary?
				if (bc.target >= pos)
				{
					bc.target++;
				}
			}
		}
	
		// Adjust ip of any TextMaps
		const size_t textMapCount = m_textMaps.size();
		for (size_t i = 0; i < textMapCount; i++)
		{
			TEXTMAP& textMap = m_textMaps[i];
			if (textMap.ip >= pos)
				textMap.ip++;
		}
	}
}


ip_t Compiler::GenPushTemp(TempVarRef* pTemp)
{
	return GenTempRefInstruction(OpCode::LongPushOuterTemp, pTemp);
}

inline ip_t Compiler::GenPushInstVar(uint8_t index)
{
	m_pCurrentScope->MarkNeedsSelf();

	// Push an instance variable
	return (index < NumShortPushInstVars) 
		? GenInstruction(OpCode::ShortPushInstVar, index)
		: GenInstructionExtended(OpCode::PushInstVar, index);
}

inline void Compiler::GenPushStaticVariable(const Str& strName, const TEXTRANGE& range)
{
	POTE oteStatic;
	switch (FindNameAsStatic(strName, oteStatic))
	{
	case StaticType::Constant:
		GenPushStaticConstant(oteStatic, range);
		break;

	case StaticType::Variable:
		GenStatic(oteStatic, range);
		break;
		
	case StaticType::Cancel:
		m_ok = false;
		return;
		
	case StaticType::NotFound:
	default:
		CompileError(range, CErrUndeclared, (Oop)NewUtf8String(strName));
		return;
	}

	// Must remove this last as in the case of a PoolConstantsDictionary the Association is not state
	// and this will be the last ref.
	m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
}

void Compiler::GenPushStaticConstant(POTE oteStatic, const TEXTRANGE& range)
{
	STVariableBinding& var = *(STVariableBinding*)GetObj(oteStatic);
	Oop literal = var.value;
	if (GenPushImmediate(literal, range))
	{
		// We still want the variable added to the literal frame so that it can be used to accurately
		// identify references to the constant, but we put it at the end of the frame so it doesn't cause
		// unnecessarily lengthen the bytecodes required to reference literals from the code
		AddToFrame(reinterpret_cast<Oop>(oteStatic), range, LiteralType::ReferenceOnly);
	}
	else
	{
		// If it doesn't have an immediate form, may as well push just the variable binding:
		// - there is little perf difference in the indirection 
		// - we need the variable for accurate reference searches, so storing just it saves the space required to 
		// store references to both variable and value
		GenStatic(oteStatic, range);
	}
}

void Compiler::GenPushSelf()
{
	m_pCurrentScope->MarkNeedsSelf();
	GenInstruction(OpCode::ShortPushSelf);
}

void Compiler::GenPushVariable(const Str& strName, const TEXTRANGE& range)
{
	if (strName == VarSelf)
	{
		GenPushSelf();
		m_sendType = SendType::Self;
	}
	else if (strName == VarSuper &&	// Cannot supersend from class with no superclass
		((STBehavior*)GetObj(MethodClass))->superclass != Nil())
	{
		// If name is "super" then we must set a flag to tell our expressions
		// that messages must be sent to superclass of self.
		//
		GenPushSelf();
		m_sendType = SendType::Super;
	}
	else if (strName == VarThisContext)
		GenInstruction(OpCode::PushActiveFrame);
	else
	{
		TempVarRef* pRef = AddTempRef(strName, VarRefType::Read, range, range.m_stop);

		if (pRef != nullptr)
			GenPushTemp(pRef);
		else 
		{
			size_t index = FindNameAsInstanceVariable(strName);
			if (index != -1)
			{
				// Only 255 inst vars recognised, so index should not be > 255
				_ASSERTE(index < 256);
				GenPushInstVar(static_cast<uint8_t>(index & 0xff));
			}
			else 
				GenPushStaticVariable(strName, range);
		}
	}
}

void Compiler::GenInteger(intptr_t val, const TEXTRANGE& range)
{
	// Generates code to push a small integer constant.
	if (val >= -1 && val <= 2)
		GenInstruction(static_cast<OpCode>((static_cast<int>(OpCode::ShortPushZero) + val) & 0xff));
	else if (val >= _I8_MIN && val <= _I8_MAX)
		GenInstructionExtended(OpCode::PushImmediate, static_cast<uint8_t>(val));
	else if (val >= _I16_MIN && val <= _I16_MAX)
		GenLongInstruction(OpCode::LongPushImmediate, static_cast<uint16_t>(val));
	else if (val >= _I32_MIN && val <= _I32_MAX && IsIntegerValue(val))
	{
		// Note that although there is sufficient space in the instruction to represent the full range of
		// 32-bit integers, in a 32-bit VM we don't bother with those outside the SmallInteger range since 
		// those would then need to be allocated each time, rather than read from a constant in the literal 
		// frame. In a 64-bit VM the full range will be used. Both cases are covered by the condition
		// above: In a 32-bit VM the value may be in the 32-bit range, but IsIntegerValue may be false.
		// In a 64-bit VM IsIntegerValue will never be false when evaluated.

		GenInstruction(OpCode::ExLongPushImmediate);
		GenData(val & UINT8_MAX);
		GenData((val >> 8) & UINT8_MAX);
		GenData((val >> 16) & UINT8_MAX);
		GenData((val >> 24) & UINT8_MAX);
	}
	else
	{
		GenLiteralConstant(m_piVM->NewSignedInteger(val), range);
	}
}

template <bool ignoreNops> ip_t Compiler::PriorInstruction() const
{
	ip_t priorIndex = m_codePointer-1;
	while (priorIndex >= ip_t::zero && (m_bytecodes[priorIndex].IsData || (m_bytecodes[priorIndex].Opcode == OpCode::Nop && ignoreNops)))
		--priorIndex;
	return priorIndex;
}

bool Compiler::LastIsPushNil() const
{
	ip_t priorIndex = PriorInstruction<true>();
	if (priorIndex == ip_t::npos)
		return false;
	return m_bytecodes[priorIndex].Opcode == OpCode::ShortPushNil;
}

// Answer whether the previous instruction is a push SmallInteger
// There are a number of possibilities
bool Compiler::LastIsPushSmallInteger(intptr_t& value) const
{
	ip_t priorIndex = PriorInstruction<false>();
	if (priorIndex == ip_t::npos)
		return false;
	
	Oop literal = IsPushLiteral(priorIndex);
	if (IsIntegerObject(literal))
	{
		value = IntegerValueOf(literal);
		return true;
	}

	return false;
}

Oop Compiler::LastIsPushNumber() const
{
	ip_t priorIndex = PriorInstruction<false>();
	if (priorIndex == ip_t::npos)
		return NULL;

	Oop literal = IsPushLiteral(priorIndex);
	if (literal == NULL)
		return NULL;

	if (IsIntegerObject(literal))
		return literal;
	else
	{
		Oop oopIsNumber = m_piVM->Perform(literal, GetVMPointers().understandsArithmeticSymbol);
		return oopIsNumber == reinterpret_cast<Oop>(GetVMPointers().True) ? literal : NULL;
	}
}

Oop Compiler::IsPushLiteral(ip_t pos) const
{
	auto opCode = m_bytecodes[pos].Opcode;

	switch(opCode)
	{
	case OpCode::ShortPushMinusOne:
	case OpCode::ShortPushZero:
	case OpCode::ShortPushOne:
	case OpCode::ShortPushTwo:
		return IntegerObjectOf(static_cast<int>(opCode) - static_cast<int>(OpCode::ShortPushZero));

	case OpCode::PushImmediate:
		return IntegerObjectOf(static_cast<int8_t>(m_bytecodes[pos+1].byte));

	case OpCode::LongPushImmediate:
		// Remember x86 is little endian
		return IntegerObjectOf(static_cast<int16_t>(m_bytecodes[pos+1].byte | (m_bytecodes[pos+2].byte << 8)));

	case OpCode::ExLongPushImmediate:
		return IntegerObjectOf(static_cast<int32_t>((m_bytecodes[pos+ExLongPushImmediateInstructionSize-1].byte) << 24
			| (m_bytecodes[pos + ExLongPushImmediateInstructionSize - 2].byte << 16)
			| (m_bytecodes[pos + ExLongPushImmediateInstructionSize - 3].byte << 8)
			| m_bytecodes[pos + ExLongPushImmediateInstructionSize - 4].byte));

	case OpCode::PushConst:
		return m_literalFrame[m_bytecodes[pos+1].byte];

	case OpCode::ShortPushConst:
	case OpCode::ShortPushConst+1:
	case OpCode::ShortPushConst+2:
	case OpCode::ShortPushConst+3:
	case OpCode::ShortPushConst+4:
	case OpCode::ShortPushConst+5:
	case OpCode::ShortPushConst+6:
	case OpCode::ShortPushConst+7:
	case OpCode::ShortPushConst+8:
	case OpCode::ShortPushConst+9:
	case OpCode::ShortPushConst+10:
	case OpCode::ShortPushConst+11:
	case OpCode::ShortPushConst+12:
	case OpCode::ShortPushConst+13:
	case OpCode::ShortPushConst+14:
	case OpCode::ShortPushConst+15:
		return m_literalFrame[m_bytecodes[pos].indexOfShortPushConst()];

	default:
		// If this assertion fires, then the above case may need updating to reflect the
		// change in the bytecode set, i.e. more or less ShortPushConst instructions
		_ASSERTE(!m_bytecodes[pos].IsShortPushConst);
		break;
	}

	return NULL;
}


// N.B. Return value has an artificially increased ref. count.
// Remember this if storing as literal or whatever
Oop Compiler::NewNumber(LPUTF8 textvalue) const// throws SE_VMCALLBACKUNWIND
{
	return m_piVM->Perform((Oop)NewAnsiString(textvalue), GetVMPointers().asNumberSymbol);
}


Oop Compiler::GenNumber(LPUTF8 textvalue, const TEXTRANGE& range)
{
	// Generates code to push a large integer constant.
	// A redundant ref. count operation occurs here 
	Oop numPointer = NewNumber(textvalue);
	GenNumber(numPointer, range);
	m_piVM->RemoveReference(numPointer);
	return numPointer;
}

void Compiler::GenNumber(Oop numPointer, const TEXTRANGE& range)
{
	if (IsIntegerObject(numPointer))
		GenInteger(IntegerValueOf(numPointer), range);
	else
		GenLiteralConstant(numPointer, range);
}

size_t Compiler::AddToFrameUnconditional(Oop object, const TEXTRANGE& errRange)
{
	// Adds (object) to the literal frame even if it is already there.
	// Returns the index to the object in the literal frame.
	//
	_ASSERTE(object);
	_ASSERTE(!IsIntegerObject(object) || IntegerValueOf(object) < INT16_MIN || IntegerValueOf(object) > INT16_MAX || errRange.Span <= 0);
	_ASSERTE(!m_literals.contains(object) || m_literals[object] == -1);
	size_t index = m_literalFrame.size();
	if (index < m_literalLimit)
	{
		m_literalFrame.push_back(object);
		CHECKREFERENCES
	}
	else
	{
		index = -1;
		CompileError(errRange, CErrTooManyLiterals, object);
	}

	return index;
}

size_t Compiler::AddToFrame(Oop object, const TEXTRANGE& errRange, LiteralType type)
{
	// Adds (object) to the literal frame if it is not already there.
	// Returns the index to the object in the literal frame.
	//
	LiteralMap::iterator it = m_literals.find(object);
	size_t index;
	if (it != m_literals.end())
	{
		index = (*it).second;
		if (type == LiteralType::Normal && index == static_cast<size_t>(-1))
		{
			// Need to insert previously reference only literal into the frame
			index = AddToFrameUnconditional(object, errRange);
			(*it).second = index;
		}
	}
	else
	{
		// New literal

		if (type == LiteralType::Normal)
		{
			index = AddToFrameUnconditional(object, errRange);
		}
		else
		{
			index = static_cast<size_t>(-1);
		}

		m_piVM->AddReference(object);
		m_literals[object] = index;
	}
	return index;
}


size_t Compiler::AddStringToFrame(POTE stringPointer, const TEXTRANGE& range)
{
	// Adds (object) to the literal frame if it is not already there.
	// Returns the index to the object in the literal frame.
	//
	m_piVM->AddReference((Oop)stringPointer);
	POTE classPointer = m_piVM->FetchClassOf(Oop(stringPointer));
	LPUTF8 szValue = (LPUTF8)FetchBytesOf(stringPointer);

	for (LiteralMap::iterator it = m_literals.begin(); it != m_literals.end(); it++)
	{
		Oop literalPointer = (*it).first;
		_ASSERTE(literalPointer);

		if ((m_piVM->FetchClassOf(literalPointer) == classPointer) &&
			strcmp((LPCSTR)FetchBytesOf(POTE(literalPointer)), (LPCSTR)szValue) == 0)
		{
			// Found an equivalent string already among the literals

			size_t index = (*it).second;
			if (index == -1)
			{
				index = AddToFrameUnconditional(literalPointer, range);
				(*it).second = index;
			}

			m_piVM->RemoveReference((Oop)stringPointer);
			return index;
		}
	}
	
	Oop oopString = reinterpret_cast<Oop>(stringPointer);
	m_piVM->MakeImmutable(oopString, TRUE);
	size_t index = AddToFrame(oopString, range, LiteralType::Normal);
	m_piVM->RemoveReference((Oop)stringPointer);
	return index;
}

void Compiler::GenLiteralConstant(Oop object, const TEXTRANGE& range)
{
	m_piVM->MakeImmutable(object, TRUE);
	GenConstant(AddToFrame(object, range, LiteralType::Normal));
}

bool Compiler::GenPushImmediate(Oop objectPointer, const TEXTRANGE& range)
{
	// If possible use an immediate form (SmallIntegers, Characters, nil, true, false)

	if (IsIntegerObject(objectPointer))
	{
		GenInteger(IntegerValueOf(objectPointer), range);
	}
	else
	{
		const VMPointers& vmPointers = GetVMPointers();
		if (objectPointer == Oop(vmPointers.False))
			GenInstruction(OpCode::ShortPushFalse);
		else if (objectPointer == Oop(vmPointers.True))
			GenInstruction(OpCode::ShortPushTrue);
		else if (objectPointer == Oop(vmPointers.Nil))
			GenInstruction(OpCode::ShortPushNil);
		else if (m_piVM->IsKindOf(objectPointer, GetVMPointers().ClassCharacter))
		{
			STVarObject* pChar = GetObj((POTE)objectPointer);
			Oop asciiValue = pChar->fields[0];
			_ASSERT(IsIntegerObject(asciiValue));
			char32_t codePoint = IntegerValueOf(asciiValue) & UINT32_MAX;
			if (codePoint > 127)
			{
				return false;
			}
			GenInstructionExtended(OpCode::PushChar, static_cast<uint8_t>(codePoint));
		}
		else
		{
			return false;
		}
	}
	return true;
}

void Compiler::GenPushConstant(Oop objectPointer, const TEXTRANGE& range)
{
	if (!GenPushImmediate(objectPointer, range))
	{
		// Note that we may be pushing the value of a variable here, we don't want to mark it immutable
		GenConstant(AddToFrame(objectPointer, range, LiteralType::Normal));
	}
}



// Generates code to push a literal constant
void Compiler::GenConstant(size_t index)
{
	if (m_ok)
	{
		// Generate the push
		if (index < NumShortPushConsts)		// In range of short instructions ?
			GenInstruction(OpCode::ShortPushConst, static_cast<uint8_t>(index));
		else if (index < 256)				// In range of single extended instructions ?
		{
			GenInstructionExtended(OpCode::PushConst, static_cast<uint8_t>(index));
		}
		else
		{
			// Too many literals detected when adding to frame, so index should be in range
			if (index > UINT16_MAX)
				InternalError(__FILE__, __LINE__, ThisTokenRange, "Literal index out of range %Iu", index);

			GenLongInstruction(OpCode::LongPushConst, static_cast<uint16_t>(index));
		}
	}
}		

// Generates code to push a literal variable.
void Compiler::GenStatic(const POTE oteStatic, const TEXTRANGE& range)
{
	size_t index = AddToFrame(reinterpret_cast<Oop>(oteStatic), range, LiteralType::Normal);

	if (m_ok)
	{
		// Index should be >=0 if no error detected
		_ASSERT(index != -1);

		// Generate the push
		if (index < NumShortPushStatics)	// In range of short instructions ?
		{
			GenInstruction(OpCode::ShortPushStatic, static_cast<uint8_t>(index));
		}
		else if (index <= UINT8_MAX)				// In range of single extended instructions ?
		{
			GenInstructionExtended(OpCode::PushStatic, static_cast<uint8_t>(index));
		}
		else
		{
			// Too many literals detected when adding to frame, so index should be in range
			if (index > UINT16_MAX)
				InternalError(__FILE__, __LINE__, ThisTokenRange, "Literal index out of range %Iu", index);
			GenLongInstruction(OpCode::LongPushStatic, static_cast<uint16_t>(index));
		}
	}
}		

ip_t Compiler::GenReturn(OpCode retOp)
{
	BreakPoint();
	return GenInstruction(retOp);
}

ip_t Compiler::GenMessage(const Str& pattern, argcount_t argCount, textpos_t messageStart)
{
	BreakPoint();
	// Generates code to send a message (pattern) with (argCount) arguments
	if (m_sendType != SendType::Super)
	{
		// Look for special or arithmetic messages
		OpCode bytecode = FindNameAsSpecialMessage(pattern);
		if (bytecode !=  OpCode::Break)
		{
			return GenInstruction(bytecode);
		}
	}
	
	// It wasn't that simple so we'll need a literal 
	// symbol in the frame.
	POTE oteSelector = InternSymbol(pattern);
	TEXTRANGE errRange = TEXTRANGE(messageStart, argCount == 0 ? ThisTokenRange.m_stop : LastTokenRange.m_stop);
	size_t symbolIndex=AddToFrame(reinterpret_cast<Oop>(oteSelector), errRange, LiteralType::Normal);
	if (symbolIndex == -1)
		return ip_t::npos;

	if (m_sendType == SendType::Super)
	{
		// Warn if supersends a message which is not implemented - be sure not to wrongly flag 
		// recursive self send first time the method is compiled
		POTE superclass = ((STBehavior*)GetObj(MethodClass))->superclass;
		if (IsInteractive && !CanUnderstand(superclass, oteSelector))
			WarningV(errRange, CWarnMsgUnimplemented, reinterpret_cast<Oop>(oteSelector), m_piVM->NewString("super"), superclass, 0);
	}
	else
	{
		// Warn if self-sends a message which is not implemented
		if (m_sendType == SendType::Self && IsInteractive
				&& pattern != m_selector && !CanUnderstand(MethodClass,  oteSelector))
			WarningV(errRange, CWarnMsgUnimplemented, reinterpret_cast<Oop>(oteSelector), m_piVM->NewString("self"), MethodClass, 0);

		// A short send may be possible (sends to super are always long as there is no short
		// version), but only if 0..2 args, and within literal index ranges
		
		switch (argCount)
		{
		case 0:
			if (symbolIndex < NumShortSendsWithNoArgs)
			{
				return GenInstruction(OpCode::ShortSendWithNoArgs, static_cast<uint8_t>(symbolIndex));
			}
			break;
		case 1:
			if (symbolIndex < NumShortSendsWith1Arg)
			{
				return GenInstruction(OpCode::ShortSendWith1Arg, static_cast<uint8_t>(symbolIndex));
			}
			break;
		case 2:
			if (symbolIndex < NumShortSendsWith2Args)
			{
				return GenInstruction(OpCode::ShortSendWith2Args, static_cast<uint8_t>(symbolIndex));
			}
			break;
		default:
			// drop through
			break;
		}
	}
	
	ip_t sendIP;
	// Ok, so its got to be longwinded but how long
	if (symbolIndex <= SendXMaxLiteral && argCount <= SendXMaxArgs)
	{
		// Single extended send (2 bytes) will do
		uint8_t part2 = static_cast<uint8_t>((argCount << SendXLiteralBits) | (symbolIndex & SendXMaxLiteral));
		OpCode code = m_sendType == SendType::Super ? OpCode::Supersend : OpCode::Send;
		sendIP = GenInstructionExtended(code, part2);
	}
	else if (symbolIndex <= Send2XMaxLiteral && argCount <= Send2XMaxArgs)
	{
		OpCode code = m_sendType == SendType::Super ? OpCode::LongSupersend : OpCode::LongSend;
		sendIP = GenInstructionExtended(code, static_cast<uint8_t>(argCount));
		GenData(static_cast<uint8_t>(symbolIndex));
	}
	else
	{
		// Need an extended send (3 or 4 bytes)
		if (argCount > Send3XMaxArgs)
		{
			CompileError(errRange, CErrTooManyArgs);
			argCount = Send3XMaxArgs;
		}

		// Note that this test should never fire, since the literal limit will prevent the symbolIndex
		// ever exceeding the max literals supported by a send.
		if (symbolIndex > Send3XMaxLiteral)
		{
			CompileError(errRange, CErrTooManyLiterals);
			symbolIndex = Send3XMaxLiteral;
		}

		OpCode code = m_sendType == SendType::Super ? OpCode::ExLongSupersend : OpCode::ExLongSend;
		sendIP = GenInstructionExtended(code, static_cast<uint8_t>(argCount));
		GenData(symbolIndex & UINT8_MAX);
		GenData((symbolIndex >> 8) & UINT8_MAX);
	}

	return sendIP;
}

// Basic generation of jump instruction for when target not yet known
ip_t Compiler::GenJumpInstruction(OpCode basic)
{
	// IT MUST be one of the long jump instructions
	_ASSERTE(basic == OpCode::LongJump || basic == OpCode::LongJumpIfTrue || basic == OpCode::LongJumpIfFalse || basic == OpCode::LongJumpIfNil || basic == OpCode::LongJumpIfNotNil);
	
	ip_t pos = GenInstruction(basic);
	GenData(0);						// Long jumps have two byte extension
	GenData(0);
	m_bytecodes[pos].target = ip_t::npos;
	// So that we know the target hasn't been set yet, we leave the jump flag turned off
	_ASSERTE(!m_bytecodes[pos].IsJumpSource);
	return pos;
}

// N.B. Assumes no previously established jump target
inline void Compiler::SetJumpTarget(ip_t pos, ip_t target)
{
	_ASSERT(pos != target);
	_ASSERTE(static_cast<size_t>(target) < CodeSize);
	_ASSERTE(static_cast<size_t>(pos) < CodeSize-2);
	BYTECODE& bytecode = m_bytecodes[pos];
	_ASSERTE(bytecode.IsOpCode);
	_ASSERTE(bytecode.IsJumpInstruction);

	bytecode.makeJumpTo(target);
	// Mark the target location as being jumped to
	m_bytecodes[target].addJumpTo();
}

ip_t Compiler::GenJump(OpCode basic, ip_t location)
{
	// Generate a first pass (long) jump instruction.
	// Make no attempt to shorten the instruction or to compute the real 
	// offset. We store the ABSOLUTE jump target location
	// and this will be fixed up later along with the correct jump size.
	
	// If the jump is forwards then the location will be be three bytes further
	// because we're going to insert a 3 byte long jump instruction.
	if (location > m_codePointer)
		location += 3;
	
	ip_t pos = GenJumpInstruction(basic);
	
	_ASSERTE(m_bytecodes[location].IsOpCode);		// Attempting to jump to a data item!
	
	SetJumpTarget(pos, location);
	return pos;
}

ip_t Compiler::GenStoreInstVar(uint8_t index)
{
	m_pCurrentScope->MarkNeedsSelf();
	return GenInstructionExtended(OpCode::StoreInstVar, index);
}

bool Compiler::IsPseudoVariable(const Str& name) const
{
	return name == VarSelf || name == VarSuper || name == VarThisContext;
}

ip_t Compiler::GenStore(const Str& name, const TEXTRANGE& range, textpos_t assignmentEnd)
{
	TempVarRef* pRef = AddTempRef(name, VarRefType::Write, range, assignmentEnd);
	ip_t storeIP = ip_t::npos;
	if (pRef != nullptr)
	{
		storeIP = GenStoreTemp(pRef);
	}
	else if (m_ok)
	{
		size_t index = FindNameAsInstanceVariable(name);
		if (index != -1)
		{
			// Maximum of 255 inst vars recognised
			_ASSERTE(index <= UINT8_MAX);
			storeIP = GenStoreInstVar(static_cast<uint8_t>(index));
		}
		else 
			storeIP = GenStaticStore(name, range, assignmentEnd);
	}
	return storeIP;
}

ip_t Compiler::GenStaticStore(const Str& name, const TEXTRANGE& range, textpos_t assignmentEnd)
{
	POTE oteStatic;
	ip_t storeIP = ip_t::npos;
	switch(FindNameAsStatic(name, oteStatic, true))
	{
	case StaticType::Constant:
		m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
		CompileError(TEXTRANGE(range.m_start, assignmentEnd),
						CErrAssignConstant, (Oop)NewUtf8String(name));
		break;

	case StaticType::Variable:
		{
			size_t index = AddToFrame(reinterpret_cast<Oop>(oteStatic), range, LiteralType::Normal);
			_ASSERTE(index <= UINT16_MAX);
			storeIP = index <= UINT8_MAX
							? GenInstructionExtended(OpCode::StoreStatic, static_cast<uint8_t>(index))
							: GenLongInstruction(OpCode::LongStoreStatic, static_cast<uint16_t>(index));
			m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
		}
		break;

	case StaticType::NotFound:
	default:
		if (IsPseudoVariable(name))
			CompileError(TEXTRANGE(range.m_start, assignmentEnd), 
						CErrAssignConstant, (Oop)NewAnsiString(name));
		else
			CompileError(range, CErrUndeclared);
		break;
	}


	return storeIP;
}

void Compiler::GenPopAndStoreTemp(TempVarRef* pRef)
{
	uint8_t depth = m_pCurrentScope->GetDepth();
	_ASSERTE(depth >= 0 && depth < 256);
	ip_t pos = GenInstructionExtended(OpCode::LongStoreOuterTemp, static_cast<uint8_t>(depth));
	m_bytecodes[pos].pVarRef = pRef;
	// Placeholder for index, not yet known
	GenData(0);
	GenPopStack();
}

POTE Compiler::ParseMethod()
{
	// Method is outermost scope
	_ASSERTE(m_pCurrentScope == nullptr);
	_ASSERTE(m_allScopes.empty());

	PushNewScope(textpos_t::start);

	ParseMessagePattern();
	if (ThisTokenIsBinary('<'))
	{
		ParsePrimitive();
	}
	ParseTemporaries();
	
	if (m_ok)
	{
		ParseStatements(TokenType::Eof);
	}

	if (m_ok) 
	{
		ip_t last = PriorInstruction<false>();

		// If the method doesn't already end in a return, return the receiver.
		if (last == ip_t::npos || m_bytecodes[last].Opcode != OpCode::ReturnMessageStackTop)
		{
			if (last != ip_t::npos)
				GenPopStack();
			const ip_t returnIP = GenReturn(OpCode::ReturnSelf);
			// Generate text map entry with empty interval for the implicit return
			textpos_t textPos = ThisTokenRange.m_start;
			AddTextMap(returnIP, textPos, textPos-1);
		}

		if (!AtEnd)
			CompileError(TEXTRANGE(LastTokenRange.m_stop, EndOfText), CErrNonsenseAtMethodEnd);
	}

	PopScope(EndOfText);
	_ASSERTE(m_pCurrentScope == nullptr);
	return NewMethod();
}

POTE Compiler::ParseEvalExpression(TokenType closingToken)
{
	// Parse an expression for immediate evaluation.
	// We may be called from an evaluation in a workspace window or
	// perhaps from a previous compiler evaluating a constant expression.

	PushNewScope(textpos_t::start);

	// In either case we are always compiling "doit"
	m_selector= (LPUTF8)"doIt";

	ParseTemporaries();
	
	if (m_ok)
	{
		ParseStatements(closingToken);

	}

	if (m_ok) 
	{
		if (CodeSize == 0)
			GenPushSelf();
		// Implicit return
		const ip_t returnIP = GenReturn(OpCode::ReturnMessageStackTop);
		// Generate empty text map entry for the implicit return - debugger may need to map from release to debug method
		const textpos_t textPos = ThisTokenRange.m_start;
		AddTextMap(returnIP, textPos, textPos-1);
		
		// We don't complain about junk at the end of the method as we do
		// ParseMethod() since when called from a compiler evaluating a constant
		// expression the trailing text is valid.
	}

	PopScope(EndOfText);

	return NewMethod();
}

void Compiler::WarnIfRestrictedSelector(textpos_t start)
{
	if (!IsInteractive) return;

	for (size_t i=0; i < NumRestrictedSelectors; i++)
		if (m_selector == s_restrictedSelectors[i])
		{
			Warning(TEXTRANGE(start, LastTokenRange.m_stop), CWarnRestrictedSelector);
			return;
		}
}

void Compiler::ParseMessagePattern()
{
	// Parse the message selector and arguments for this method.
	textpos_t start = ThisTokenRange.m_start;

	switch(ThisToken)
	{
	case TokenType::NilConst:
	case TokenType::TrueConst:
	case TokenType::FalseConst:
	case TokenType::NameConst:
		// Unary message pattern
		m_selector=ThisTokenText;
		NextToken();
		break;

	case TokenType::NameColon:
		// Keyword message pattern
		while (m_ok && (ThisToken== TokenType::NameColon))
		{
			m_selector+=ThisTokenText;
			NextToken();
			ParseArgument();
		}
		break;

	case TokenType::Binary:
		// Binary message pattern
		while (isAnsiBinaryChar(PeekAtChar()))
			Step();
		m_selector = ThisTokenText;
		NextToken();
		ParseArgument();
		break;

	default:
		CompileError(CErrBadSelector);
		break;
	};

	WarnIfRestrictedSelector(start);
}

void Compiler::ParseArgument()
{
	// Parse an argument name and add it to the
	// array of arguments.
	//
	if (ThisToken == TokenType::NameConst)
	{
		// Get argument name
		AddArgument(ThisTokenText, ThisTokenRange);
		NextToken();
	}
	else
		CompileError(CErrExpectVariable);
}

// Parse a block of temporaries between delimiters. Answer the number parsed.
tempcount_t Compiler::ParseTemporaries()
{
	tempcount_t nTempsAdded = 0;
	if (m_ok && ThisTokenIsBinary(TEMPSDELIMITER)) 
	{
		textpos_t start = ThisTokenRange.m_start;

		while (m_ok && NextToken() == TokenType::NameConst)
		{
			AddTemporary(ThisTokenText, ThisTokenRange, false);
			nTempsAdded++;
		}
		if (ThisTokenIsBinary(TEMPSDELIMITER))
		{
			NextToken();
		}
		else
		{
			if (m_ok)
				CompileError(TEXTRANGE(start, ThisTokenRange.m_start - 1), CErrTempListNotClosed);
		}
	}
	return nTempsAdded;
}

size_t Compiler::ParseStatements(TokenType closingToken, bool popResults)
{
	if (!m_ok || ThisToken == closingToken || AtEnd)
		return 0;

	// TEMPORARY: This nop may later be used as an insertion point for copying arguments from the
	// stack into env temps. The reason for having a Nop is to avoid any jump target confusion, 
	// since when inserting an instruction the old instruction is shuffled down and the inserted
	// instruction becomes the jump target.
	GenNop();

	size_t count = 0;
	while (m_ok)
	{
		textpos_t statementStart = ThisTokenRange.m_start;
		ParseStatement();
		bool foundPeriod = false;
		if (ThisToken == TokenType::CloseStatement)
		{
			// Statements are to be concatenated and previous
			// result ignored (except for brace arrays)
			foundPeriod = true;
			NextToken();
		}

		count++;

		if (ThisToken == closingToken)
			break;
		else if (AtEnd)
			break;

		if (m_ok && !foundPeriod)
			CompileError(TEXTRANGE(statementStart, LastTokenRange.m_stop), CErrUnterminatedStatement);

		if (popResults)
		{
			GenPopStack();
		}
	}

	return count;
}

// ParseBlockStatements() differs from ParseStatements() in the empty block
// test and different valid terminators
void Compiler::ParseBlockStatements()
{
	_ASSERTE(IsInOptimizedBlock || IsInBlock);

	if (ThisToken == TokenType::CloseSquare)
	{
		// We're compiling a block but it's empty.
		// This returns a nil
		GenInstruction(OpCode::ShortPushNil);
		m_pCurrentScope->BeEmptyBlock();
	}
	else
	{
		if (AtEnd || ThisToken == TokenType::CloseParen)
			return;

		ip_t start = m_codePointer;
		while (m_ok)
		{
			textpos_t statementStart = ThisTokenRange.m_start;
			ParseStatement();
			bool foundClosing = false;
			if (ThisToken == TokenType::CloseStatement)
			{
				// Statements are to be concatenated and previous
				// result ignored.
				NextToken();
				foundClosing = true;
			}

			if (ThisTokenIsClosing)
			{
				// Some other closing character so we break but
				// leaving result on stack
				break;	
			}

			if (m_ok && !foundClosing)
				CompileError(TEXTRANGE(statementStart, LastTokenRange.m_stop), CErrUnterminatedStatement);
			GenPopStack();
		}
		// If the block contains only one real instruction, and that is Push Nil, then the block is effectively empty
		if (m_ok && m_bytecodes[start].Opcode == OpCode::ShortPushNil && PriorInstruction<true>() == start)
		{
			m_pCurrentScope->BeEmptyBlock();
		}
	}
}

ip_t Compiler::GenFarReturn()
{
	_ASSERTE(IsInBlock);
	// It is easiest to set the far return mark later, when patching up the blocks. That
	// way it is based on whether a FarReturn instruction actually exists in the instruction
	// stream, rather than attemping to keep the flags in sync as the optimized blocks are 
	// inlined, etc.
	//m_pCurrentScope->MarkFarReturner();
	return GenReturn(OpCode::FarReturn);
}

void Compiler::ParseStatement()
{
	if (ThisTokenIsReturn) 
	{
		textpos_t textPosition = ThisTokenRange.m_start;
		NextToken();
		ParseExpression();
		if (m_ok)
		{
			const ip_t returnIP = IsInBlock ? GenFarReturn() : GenReturn(OpCode::ReturnMessageStackTop);
			AddTextMap(returnIP, textPosition, LastTokenRange.m_stop);
		}
	}
	else 
		ParseExpression(); 
}

inline void Compiler::ParseAssignment(const Str& lvalueName, const TEXTRANGE& range)
{
	// Assignment must be to temporary (not argument though), instance variable or
	// a shared variable.
	ParseExpression();
	BreakPoint();
	textpos_t expressionEnd = LastTokenRange.m_stop;
	ip_t storeIP = GenStore(lvalueName, range, expressionEnd);
	AddTextMap(storeIP, range.m_start, expressionEnd);
}

void Compiler::ParseExpression()
{
	// Stack the last expression type
	SendType lastSend = m_sendType;
	m_sendType = SendType::Other;
	
	// We may need to know the mark of the current expression
	ip_t exprMark = m_codePointer;
	TEXTRANGE tokenRange = ThisTokenRange;
	
	if (ThisToken == TokenType::NameConst)
	{	
		// Possibly assignment
		Str name = ThisTokenText;
		NextToken();
		if (ThisTokenIsAssignment) 
		{
			// This is an assignment
			NextToken();
			ParseAssignment(name, tokenRange);
		}
		else 
		{
			GenPushVariable(name, tokenRange);
			if (m_ok) 
				ParseContinuation(exprMark, tokenRange.m_start);
		}
	}
	else 
	{
		ParseTerm(tokenRange.m_start);
		if (m_ok)
			ParseContinuation(exprMark, tokenRange.m_start);
	}
	
	// Restore the last expression type
	m_sendType = lastSend;
}

void Compiler::ParseBinaryTerm(textpos_t textPosition)
{
	LPUTF8 szTok = ThisTokenText;
	if (strlen((LPCSTR)szTok) != 1)
	{
		CompileError(CErrInvalExprStart);
		return;
	}
	
	switch(*szTok)
	{
	case '(': 
		{
			// Nested expression
			textpos_t nExprStart = ThisTokenRange.m_start;
			
			NextToken();
			ParseExpression();
			if (m_ok)
			{
				if (ThisToken == TokenType::CloseParen)
					NextToken();
				else					
					CompileError(TEXTRANGE(nExprStart, LastTokenRange.m_stop), CErrParenNotClosed);
			}
		}
		break;

	case '[':
		ParseBlock(textPosition);
		break;

	case '{':
		ParseBraceArray(textPosition);
		break;

	default:
		CompileError(CErrInvalExprStart);
		break;
	};
}

void Compiler::ParseBraceArray(textpos_t textPosition)
{
	NextToken();

	size_t count = ParseStatements(TokenType::CloseBrace, false);

	if (m_ok)
	{
		GenStatic(GetVMPointers().ArrayBinding, TEXTRANGE(textPosition, textPosition));
		GenInteger(count, ThisTokenRange);
		GenMessage((LPUTF8)"newFromStack:", 1, textPosition);
	}

	if (ThisToken == TokenType::CloseBrace)
	{
		NextToken();
	}
	else
	{
		if (m_ok)
			CompileError(TEXTRANGE(textPosition, ThisTokenRange.m_stop), CErrBraceNotClosed);
	}
}

DEFINE_ENUM_FLAG_OPERATORS(BindingReferenceFlags)

POTE Compiler::ParseQualifiedReference(textpos_t textPosition)
{
	POTE bindingRef = nullptr;
	NextToken();
	TEXTRANGE range = ThisTokenRange;
	if (ThisToken == TokenType::NameConst)
	{
		Str identifier = ThisTokenText;
		NextToken();

		BindingReferenceFlags flags = BindingReferenceFlags::None;
		while (ThisToken == TokenType::NameConst)
		{
			if (!strcmp((LPCSTR)ThisTokenText, "class"))
			{
				flags |= BindingReferenceFlags::IsMeta;
				range.m_stop = ThisTokenRange.m_stop;
				NextToken();
			}
			else if (!strcmp((LPCSTR)ThisTokenText, "private"))
			{
				flags |= BindingReferenceFlags::IsPrivate;
				range.m_stop = ThisTokenRange.m_stop;
				NextToken();
			}
			else
			{
				break;
			}
		}

		if (ThisToken == TokenType::CloseBrace)
		{
			NextToken();
			Str uniqueIdentifier = (flags & BindingReferenceFlags::IsMeta) == BindingReferenceFlags::IsMeta ? identifier + u8'*' : identifier;
			auto iter = m_bindingRefs.find(uniqueIdentifier);
			if (iter == m_bindingRefs.end())
			{
				// We want the context to be nil here if compiling an unbound expression, such as in a file-in or workspace
				bindingRef = m_piVM->NewBindingRef((LPCSTR)identifier.c_str(), reinterpret_cast<Oop>(this->m_class), flags);
				m_bindingRefs[uniqueIdentifier] = bindingRef;
			}
			else
			{
				bindingRef = (*iter).second;
			}
		}
		else
		{
			TEXTRANGE badTokenRange = ThisTokenRange;
			if (NextToken() == TokenType::CloseBrace)
			{
				CompileError(badTokenRange, CErrBadQualifiedRefModifier);
				NextToken();
			}
			else
			{
				CompileError(TEXTRANGE(textPosition, range.m_stop), CErrQualifiedRefNotClosed);
			}
		}
	}
	else
	{
		CompileError(range, CErrExpectVariable);
	}
	return bindingRef;
}

void Compiler::ParseTerm(textpos_t textPosition)
{
	TokenType tokenType = ThisToken;
	
	switch(tokenType)
	{
	case TokenType::NameConst:
		GenPushVariable(ThisTokenText, ThisTokenRange);
		NextToken();
		break;

	case TokenType::SmallIntegerConst:
		GenInteger(ThisTokenInteger, ThisTokenRange);
		NextToken();
		break;

	case TokenType::LargeIntegerConst:
	case TokenType::ScaledDecimalConst:
		{
			GenNumber(ThisTokenText, ThisTokenRange);
            NextToken();
		}
		break;

	case TokenType::FloatingConst:
		GenLiteralConstant(reinterpret_cast<Oop>(m_piVM->NewFloat(ThisTokenFloat)), ThisTokenRange);
		NextToken();
		break;

	case TokenType::CharConst:
		{
			int32_t codePoint = ThisTokenInteger;
			if (__isascii(codePoint))
			{
				// We only generate the PushChar instruction for ASCII code points
				GenInstructionExtended(OpCode::PushChar, static_cast<uint8_t>(codePoint));
			}
			else
			{
				GenLiteralConstant(reinterpret_cast<Oop>(m_piVM->NewCharacter(static_cast<char32_t>(codePoint))), ThisTokenRange);
			}
			NextToken();
		}
		break;

	case TokenType::SymbolConst:
		GenConstant(AddToFrame(reinterpret_cast<Oop>(InternSymbol(ThisTokenText)), ThisTokenRange, LiteralType::Normal));
		NextToken();
		break;

	case TokenType::TrueConst:
		GenInstruction(OpCode::ShortPushTrue);
		NextToken();
		break;

	case TokenType::FalseConst:
		GenInstruction(OpCode::ShortPushFalse);
		NextToken();
		break;

	case TokenType::NilConst:
		GenInstruction(OpCode::ShortPushNil);
		NextToken();
		break;

	case TokenType::AsciiStringConst:	// We no longer create AnsiString literals, only Utf8Strings
	case TokenType::Utf8StringConst:
	{
		LPUTF8 szLiteral = ThisTokenText;
		POTE oteString = *szLiteral
			? NewUtf8String(szLiteral)
			: GetVMPointers().EmptyString;
		GenConstant(AddStringToFrame(oteString, ThisTokenRange));
		NextToken();
	}
	break;

	case TokenType::ExprConstBegin:
		{
			textpos_t start = ThisTokenRange.m_start;
			Oop literal=ParseConstExpression();
			if (m_ok)
			{
				GenPushConstant(literal, TEXTRANGE(start, LastTokenRange.m_stop));
			}
			m_piVM->RemoveReference(literal);
			NextToken();
		}
		break;

	case TokenType::ArrayBegin:
		{
			textpos_t start = ThisTokenRange.m_start;
			POTE array=ParseArray();
			if (m_ok)
				GenLiteralConstant(reinterpret_cast<Oop>(array), TEXTRANGE(start, LastTokenRange.m_stop));
		}
		break;

	case TokenType::ByteArrayBegin:
		{
			textpos_t start = ThisTokenRange.m_start;
			POTE array=ParseByteArray();
			if (m_ok)
				GenLiteralConstant(reinterpret_cast<Oop>(array), TEXTRANGE(start, LastTokenRange.m_stop));
		}
		break;

	case TokenType::QualifiedRefBegin:
		{
			textpos_t start = ThisTokenRange.m_start;
			POTE bindingRef = ParseQualifiedReference(start);
			if (m_ok)
				GenLiteralConstant(reinterpret_cast<Oop>(bindingRef), TEXTRANGE(start, LastTokenRange.m_stop));
		}
		break;
	case TokenType::Binary:
		ParseBinaryTerm(textPosition);
		break;

	default:
		CompileError(CErrInvalExprStart);
		break;
	};
}

void Compiler::ParseContinuation(ip_t exprMark, textpos_t textPosition)
{
	ip_t continuationPointer = ParseKeyContinuation(exprMark, textPosition);
	ip_t currentPos = m_codePointer;
	m_codePointer = continuationPointer;
	GenDup();
	_ASSERTE(lengthOfByteCode(OpCode::DuplicateStackTop) == 1);
	m_codePointer = currentPos + 1;
	
	while (m_ok && ThisToken == TokenType::Cascade)
	{
		TokenType tok = NextToken();
		textpos_t continueTextPosition = ThisTokenRange.m_start;
		continuationPointer= GenInstruction(OpCode::PopDup);
		switch(tok)
		{
		case TokenType::NameConst:
		case TokenType::Binary:
		case TokenType::NameColon:
			ParseKeyContinuation(exprMark, continueTextPosition);
			break;
		default:
			CompileError(CErrExpectMessage);
			break;
		}
	}
	
	// At this point there will be one extra DuplicateStackTop
	// instruction in the code stream which can be removed.
	if (m_bytecodes[continuationPointer].Opcode == OpCode::PopDup)
	{
		m_bytecodes[continuationPointer].Opcode = OpCode::PopStackTop;
	}
	else
	{
		_ASSERT(m_bytecodes[continuationPointer].Opcode == OpCode::DuplicateStackTop);
		UngenInstruction(continuationPointer);
	}
}

ip_t Compiler::ParseKeyContinuation(ip_t exprMark, textpos_t textPosition)
{
	ip_t continuationPointer = ParseBinaryContinuation(exprMark, textPosition);
	if (ThisToken!=TokenType::NameColon) 
	{
		if (m_sendType == SendType::Super)
			CompileError(CErrExpectMessage);
		return continuationPointer;
	}

	size_t argumentCount=1;
	bool specialCase=false;
	
	continuationPointer = m_codePointer;
	
	Str strPattern = ThisTokenText;
	TEXTRANGE range = ThisTokenRange;
	TEXTRANGE receiverRange = TEXTRANGE(textPosition, LastTokenRange.m_stop);
	NextToken();
	
	// There are some special cases to deal with optimized
	// blocks for conditions and loops 
	//
	if (strPattern == (LPUTF8)"whileTrue:")
	{
		specialCase = ParseWhileLoopBlock<true>(exprMark, range, receiverRange);
	}
	else if (strPattern == (LPUTF8)"whileFalse:")
	{
		specialCase = ParseWhileLoopBlock<false>(exprMark, range, receiverRange);
	}
	else if (strPattern == (LPUTF8)"ifTrue:")
	{
		if (ParseIfTrue(range))
		{
			specialCase=true;
		}
	}
	else if (strPattern == (LPUTF8)"ifFalse:")
	{
		if (ParseIfFalse(range))
		{
			specialCase=true;
		}
	}
	else if (strPattern == (LPUTF8)"and:")
	{
		if (ParseAndCondition(range))
			specialCase=true;
	}
	else if (strPattern == (LPUTF8)"or:")
	{
		if (ParseOrCondition(range))
			specialCase=true;
	}
	else if (strPattern == (LPUTF8)"ifNil:")
	{
		if (ParseIfNil(range, textPosition))
		{
			specialCase=true;
		}
	}
	else if (strPattern == (LPUTF8)"ifNotNil:")
	{
		if (ParseIfNotNil(range, textPosition))
		{
			specialCase=true;
		}
	}
	else if (strPattern == (LPUTF8)"timesRepeat:")
	{
		if (ParseTimesRepeatLoop(range, textPosition))
		{
			//AddTextMap(textPosition);
			specialCase=true;
		}
	}
	
	if (!specialCase)
	{
		// For to:[by:]do: optimization. Messy...
		ip_t toPointer = ip_t::zero;
		ip_t byPointer = ip_t::zero;
		while (m_ok) 
		{
			// Otherwise just handle normally
			SendType lastSend=m_sendType;
			m_sendType=SendType::Other;
			
			// to:[by:]do: interface
			if (strPattern == (LPUTF8)"to:")
				toPointer = m_codePointer;
			else if (strPattern == (LPUTF8)"to:by:")
				byPointer = m_codePointer;
			else if (strPattern == (LPUTF8)"to:do:")
			{
				if (ParseToDoBlock(textPosition, toPointer))
				{
					specialCase = true;// Made up our mind this time
					m_sendType = lastSend;
					break;
				}
			}
			else if (strPattern == (LPUTF8)"to:by:do:")
			{
				if (ParseToByDoBlock(textPosition, toPointer, byPointer))
				{
					specialCase = true;// Made up our mind this time
					m_sendType = lastSend;
					break;
				}
			}
			
			ip_t newExprMark = m_codePointer;
			textpos_t newTextPosition = ThisTokenRange.m_start;
			ParseTerm(newTextPosition);
			ParseBinaryContinuation(newExprMark, newTextPosition);
			m_sendType = lastSend;
			if (ThisToken == TokenType::NameColon)
			{
				strPattern += ThisTokenText;
				argumentCount++;
				NextToken();
			}
			else
				break;
		}

		if (!specialCase)
		{
			ip_t sendIP = GenMessage(strPattern, argumentCount, textPosition);
			AddTextMap(sendIP, textPosition, LastTokenRange.m_stop);
		}
	}

	return continuationPointer;
}

void Compiler::MaybePatchNegativeNumber()
{
	if (ThisTokenIsNumber && ThisTokenText[0] == '-')
	{
		StepBack(strlen((LPCSTR)ThisTokenText)-1);
		ThisToken = TokenType::Binary;
		_ASSERTE(ThisTokenIsBinary('-'));
	}
}

ip_t Compiler::ParseBinaryContinuation(ip_t exprMark, textpos_t textPosition)
{
	ip_t continuationPointer = ParseUnaryContinuation(exprMark, textPosition);
	MaybePatchNegativeNumber();
	while (m_ok && (ThisToken== TokenType::Binary))
	{
		continuationPointer = m_codePointer;
		char8_t ch;
		while (isAnsiBinaryChar((ch = PeekAtChar())))
		{
			if (ch == '-' && isdigit(PeekAtChar(1)))
				break;
			else
				Step();
		}
		Str pattern = ThisTokenText;
		
		NextToken();
		
		SendType lastSend = m_sendType;
		m_sendType = SendType::Other;
		ip_t newExprMark = m_codePointer;
		textpos_t newTextPosition = ThisTokenRange.m_start;
		ParseTerm(newTextPosition);
		ParseUnaryContinuation(newExprMark, newTextPosition);
		if (m_sendType == SendType::Super)
			CompileError(CErrExpectMessage);
		m_sendType = lastSend;
		MaybePatchNegativeNumber();

		TODO("See if m_sendsToSuper can be reset inside GenMessage");
		ip_t sendIP = GenMessage(pattern, 1, textPosition);
		AddTextMap(sendIP, textPosition, LastTokenRange.m_stop);
		m_sendType = SendType::Other;
	}
	return continuationPointer;
}

void Compiler::MaybePatchLiteralMessage()
{
	switch (ThisToken)
	{
	case TokenType::NilConst:
	case TokenType::FalseConst:
	case TokenType::TrueConst:
		ThisToken = TokenType::NameConst;
		break;
	default:
		break;
	}
}

ip_t Compiler::ParseUnaryContinuation(ip_t exprMark, textpos_t textPosition)
{
	ip_t continuationPointer = m_codePointer;
	MaybePatchLiteralMessage();
	while (m_ok && (ThisToken==TokenType::NameConst)) 
	{
		bool isSpecialCase=false;
		continuationPointer = m_codePointer;

		Str strToken = ThisTokenText;
		// Check for some optimizations
		if (strToken == (LPUTF8)"whileTrue")
		{
			if (ParseWhileLoop<true>(exprMark, TEXTRANGE(textPosition, LastTokenRange.m_stop)))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"whileFalse")
		{
			if (ParseWhileLoop<false>(exprMark, TEXTRANGE(textPosition, LastTokenRange.m_stop)))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"repeat")
		{
			if (ParseRepeatLoop(exprMark, TEXTRANGE(textPosition, LastTokenRange.m_stop)))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"yourself" && !(m_flags & CompilerFlags::SendYourself))
		{
			AddSymbolToFrame(ThisTokenText, ThisTokenRange, LiteralType::ReferenceOnly);
			// We don't send yourself, since it is a Nop
			isSpecialCase=true;
		}
		
		if (!isSpecialCase)
		{
			ip_t sendIP = GenMessage(ThisTokenText, 0, textPosition);
			AddTextMap(sendIP, textPosition, ThisTokenRange.m_stop);
		}
		
		m_sendType = SendType::Other;
		NextToken();
		MaybePatchLiteralMessage();
	}
	return continuationPointer;
}

void Compiler::ParsePrimitive()
{
	TokenType next = NextToken();
	Str strToken = ThisTokenText;

	// Declare the implicit _failureCode temporary - this will always be the first temp of the method after the arguments
	TempVarDecl* pErrorCodeDecl = AddTemporary((LPUTF8)"_failureCode", ThisTokenRange, false);
	TempVarRef* pErrorTempRef = m_pCurrentScope->AddTempRef(pErrorCodeDecl, VarRefType::Write, ThisTokenRange);
	// Implicitly written to by the primitive itself, but is then read-only and cannot be assigned
	pErrorCodeDecl->BeReadOnly();

	if (next == TokenType::NameColon)
	{
		if (strToken == (LPUTF8)"primitive:")
		{
			if (NextToken() != TokenType::SmallIntegerConst)
				CompileError(CErrExpectPrimIdx);
			else
			{
				m_primitiveIndex = static_cast<uintptr_t>(ThisTokenInteger);
				if (m_primitiveIndex > PRIMITIVE_MAX && !(m_flags & CompilerFlags::Boot))
					CompileError(ThisTokenRange, CErrBadPrimIdx);
				
				next = NextToken();
				if (next == TokenType::NameColon && Str(ThisTokenText) == (LPUTF8)"error:")
				{
					if (NextToken() == TokenType::NameConst)
					{
						// Rename the _failureCode temporary
						Str errorCodeName = ThisTokenText;
						CheckTemporaryName(errorCodeName, ThisTokenRange, false);
						pErrorCodeDecl->Name = errorCodeName;
						pErrorCodeDecl->TextRange = ThisTokenRange;
						NextToken();
					}
					else
						CompileError(ThisTokenRange, CErrExpectVariable);
				}

				if (ThisTokenIsBinary('>'))
				{
					NextToken();
				}
				else
					CompileError(CErrExpectCloseTag);
			}
			return;
		}
		else
		{
			LibCallType* callType = ParseCallingConvention(strToken);
			if (callType)
			{
				ParseLibCall(callType->nCallType, DolphinX::ExtCallPrimitive::LibCall);
				return;
			}
		}
	}
	else
	{
		if (next == TokenType::NameConst)
		{
			if (strToken == (LPUTF8)"virtual")
			{
				if (NextToken() == TokenType::NameColon)
				{
					LibCallType* callType = ParseCallingConvention(ThisTokenText);
					if (callType)
					{
						ParseVirtualCall(callType->nCallType);
						return;
					}
				}
			}
			else if (strToken == (LPUTF8)"overlap")
			{
				if (NextToken() == TokenType::NameColon)
				{
					LibCallType* callType = ParseCallingConvention(ThisTokenText);
					if (callType)
					{
						ParseLibCall(callType->nCallType, DolphinX::ExtCallPrimitive::AsyncLibCall);
						return;
					}
				}
			}
			else if (strToken == (LPUTF8)"mutable")
			{
				NextToken();
				if (ThisTokenIsBinary('>'))
				{
					NextToken();
					this->m_isMutable = true;
				}
				else
				{
					CompileError(CErrExpectCloseTag);
				}
				return;
			}
		}
	}
	
	CompileError(CErrBadPrimCallType);
}


Compiler::LibCallType* Compiler::ParseCallingConvention(const Str& strToken)
{
	for (size_t i=0; i < static_cast<size_t>(DolphinX::ExtCallDeclSpec::NumCallConventions); i++)
		if (strToken == callTypes[i].szCallType)
		{
			m_literalLimit = 256;		// Literal limit is reduced because only byte available in descriptor
			return &callTypes[i];
		}
		
		return 0;
}



argcount_t Compiler::ParseExtCallArgs(TypeDescriptor args[])
{
	argcount_t argcount=0;
	NextToken();
	textpos_t nArgsStart = ThisTokenRange.m_start;
	
	while (m_ok && !ThisTokenIsBinary('>') && !AtEnd)
	{
		TEXTRANGE typeRange = ThisTokenRange;
		ParseExtCallArgument(args[argcount]);
		if (m_ok)
		{
			if (args[argcount].type != DolphinX::ExtCallArgType::Void)
				argcount++;
			else
				CompileError(typeRange, CErrArgTypeCannotBeVoid);
		}
	}
	
	if (m_ok)
	{
		if (argcount < ArgumentCount)
			CompileError(TEXTRANGE(nArgsStart, LastTokenRange.m_stop), CErrInsufficientArgTypes);
		else
			if (argcount > ArgumentCount)
				CompileError(TEXTRANGE(nArgsStart, LastTokenRange.m_stop), CErrTooManyArgTypes);
	}
	
	if (m_ok)
	{
		if (ThisTokenIsBinary('>'))
			NextToken();
		else
			CompileError(CErrExpectCloseTag);
	}

	return argcount;
}

void Compiler::ParseVirtualCall(DolphinX::ExtCallDeclSpec decl)
{
	// Parse a C++ virtual function call
	_ASSERTE(LiteralCount == 0);
	_ASSERTE(m_literalLimit <= 256);
	
	NextToken();
	
	TypeDescriptor args[ARGLIMIT];
	TEXTRANGE retTypeRange = ThisTokenRange;
	ParseExtCallArgument(args[0]);
	if (!m_ok)
		return;

	// Temporary bodge until VM call prim can handle variant return type correctly
	if (args[0].type == DolphinX::ExtCallArgType::Variant)
	{
		args[0].type = DolphinX::ExtCallArgType::Struct;

		// Because VARIANT is not in the base image, cannot be used as a return type
		// until ActiveX Automation Package has been loaded
		POTE structClass = GetVMPointers().ClassVARIANT;
		if (structClass == Nil())
		{
			CompileError(retTypeRange, CErrUndeclared);
			return;
		}

		args[0].parm = Oop(structClass);
	}
	
	m_primitiveIndex = static_cast<uintptr_t>(DolphinX::ExtCallPrimitive::VirtualCall);
	m_compiledMethodClass=GetVMPointers().ClassExternalMethod;
	
	argcount_t argcount;
	intptr_t vfnIndex;
	
	if (ThisToken != TokenType::SmallIntegerConst)
		CompileError(CErrExpectVfn);
	else
	{
		// Virtual function number
		vfnIndex = ThisTokenInteger;
		if (vfnIndex < 1 || vfnIndex > 1024)
			CompileError(CErrBadVfn);
		
		// Implicit arg for this pointer (the receiver)
		args[1].type = DolphinX::ExtCallArgType::LPVoid;
		args[1].parm = 0;
		
		// Now create an array of argument types
		argcount = ParseExtCallArgs(args+2) + 1;
	
		if (m_ok)
		{
			DolphinX::ExternalMethodDescriptor& argsEtc = buildDescriptorLiteral(args, argcount, decl, (LPUTF8)"");
			argsEtc.m_proc = PROC((vfnIndex-1)*sizeof(PROC));
		}
	}
}

// There is some considerable trickyness here, because 4 and 8-byte structs are returned
// differently!
void Compiler::mangleDescriptorReturnType(TypeDescriptor& retType, const TEXTRANGE& range)
{
	if (retType.parm)
	{
		if (retType.type == DolphinX::ExtCallArgType::Struct)
		{
			// We can save the interpreter work by compiling down this info now, thereby allowing
			// for improved run-time performance
			size_t byteSize = ((STBehavior*)GetObj(POTE(retType.parm)))->instSpec.extraSpec;
			
			if (byteSize != 0)
			{
				if (byteSize <= sizeof(int32_t))
					retType.type = DolphinX::ExtCallArgType::Struct32;
				else if (byteSize <= sizeof(int64_t))
					retType.type = DolphinX::ExtCallArgType::Struct64;
			}
		}
	}
	
	if (m_ok && retType.parm)
	{
		retType.parm = AddToFrame(retType.parm, range, LiteralType::Normal);
		_ASSERTE(retType.parm==1);
	}
}

DolphinX::ExternalMethodDescriptor& Compiler::buildDescriptorLiteral(TypeDescriptor types[], argcount_t argcount, DolphinX::ExtCallDeclSpec decl, LPUTF8 szProcName)
{
	_ASSERTE(szProcName);
	argcount_t argsLen=argcount;
	{
		for (size_t i=1;i<=argcount;i++)
		{
			if (types[i].parm)
				argsLen++;
		}
	}
	
	size_t procNameSize = strlen((LPCSTR)szProcName)+1;
	size_t size = sizeof(DolphinX::ExternalMethodDescriptor) + argsLen + procNameSize;
	size_t index=AddToFrame(Oop(m_piVM->NewByteArray(size)), LastTokenRange, LiteralType::Normal);
	
	// This must be the first literal in the frame!
	_ASSERTE(index==0);
	
	POTE argArray=(POTE)m_literalFrame[index];
	auto pb = FetchBytesOf(argArray);
	DolphinX::ExternalMethodDescriptor& argsEtc = *(DolphinX::ExternalMethodDescriptor*)pb;
	
	argsEtc.m_descriptor.m_callConv = static_cast<uint8_t>(decl);
	mangleDescriptorReturnType(types[0], types[0].range);
	argsEtc.m_descriptor.m_return = static_cast<uint8_t>(types[0].type);
	argsEtc.m_descriptor.m_returnParm = static_cast<uint8_t>(types[0].parm);
	
	
	// At the moment we build the descriptor in argument order, but the literal
	// indices preceed the types because the call primitive reads the literal
	// in reverse order (because the arguments must be pushed onto the stack in
	// the reverse order that they are on the Smalltalk stack - i.e. pop from
	// Smalltalk, push onto machine stack)
	argsLen=0;
	for (size_t i=1; m_ok && i<=argcount; i++)
	{
		// Any types with a literal argument are added to frame (only ExtCallArgSTRUCT at present)
		if (types[i].parm)
		{
			size_t frameIndex = AddToFrame(types[i].parm, types[i].range, LiteralType::Normal);
			_ASSERTE(frameIndex <= UINT8_MAX);
			argsEtc.m_descriptor.m_args[argsLen++] = static_cast<uint8_t>(frameIndex);
		}
		argsEtc.m_descriptor.m_args[argsLen++] = static_cast<uint8_t>(types[i].type);
	}
	_ASSERTE(argsLen < 256 && argsLen >= argcount);
	argsEtc.m_descriptor.m_argsLen = static_cast<uint8_t>(argsLen);
	
	// Shove the procName (store ordinal as string too) on the end
	strcpy_s((char*)argsEtc.m_descriptor.m_args+argsLen, procNameSize, (LPCSTR)szProcName);
	return argsEtc;
}

void Compiler::ParseLibCall(DolphinX::ExtCallDeclSpec decl, DolphinX::ExtCallPrimitive callPrim)
{
	if (decl > DolphinX::ExtCallDeclSpec::CDecl)
	{
		CompileError(CErrUnsupportedCallConv);
		return;
	}
	
	_ASSERTE(decl == DolphinX::ExtCallDeclSpec::StdCall || decl == DolphinX::ExtCallDeclSpec::CDecl);
	
	// Parse an external library call
	_ASSERTE(LiteralCount==0);
	NextToken();
	
	TypeDescriptor args[ARGLIMIT];
	TEXTRANGE retTypeRange = ThisTokenRange;
	ParseExtCallArgument(args[0]);
	if (!m_ok)
		return;

	// Temporary bodge until VM call prim can handle variant return type correctly
	if (args[0].type == DolphinX::ExtCallArgType::Variant)
	{
		args[0].type = DolphinX::ExtCallArgType::Struct;

		// Because VARIANT is not in the base image, cannot be used as a return type
		// until ActiveX Automation Package has been loaded
		POTE structClass = GetVMPointers().ClassVARIANT;
		if (structClass == Nil())
		{
			CompileError(retTypeRange, CErrUndeclared);
			return;
		}

		args[0].parm = Oop(structClass);
	}
	
	// Function name or ordinal
	m_primitiveIndex = static_cast<uintptr_t>(callPrim);
	m_compiledMethodClass=GetVMPointers().ClassExternalMethod;
	
	argcount_t argcount;
	
	TokenType tok = ThisToken;
	// Function names must be ASCII, or an ordinal
	if (tok != TokenType::AsciiStringConst && tok != TokenType::NameConst && tok != TokenType::SmallIntegerConst)
		CompileError(CErrExpectFnName);
	else
	{
		Str procName = ThisTokenText;
		// Now create an array of argument types
		
		// Now create an array of argument types
		argcount = ParseExtCallArgs(args+1);
		
		if (m_ok)
		{
			// We have to add the arg array whether we have args or
			// not in order to provide space for the proc address cache
			// and to store the procName (which it placed after the args
			// because it is of variable length). We also allow 1 extra
			// byte to Null terminate the proc address - since new byte
			// objects are automatically initialized to zeros, we do not
			// need to actually set this null termiator.
			//
			
			buildDescriptorLiteral(args, argcount, decl, procName.c_str());
		}
	}
}

POTE Compiler::FindExternalClass(const Str& strClass, const TEXTRANGE& range)
{
	// Maybe it will be a class name
	POTE structClass = FindGlobal(strClass);
	if (structClass == Nil())
	{
		CompileError(range, CErrUndeclared);
		return nullptr;
	}

	if (!m_piVM->IsAClass(structClass))
	{
		CompileError(range, CErrInvalidStructArg);
		return nullptr;
	}

	STBehavior& behavior = *(STBehavior*)GetObj(structClass);
	if (behavior.instSpec.pointers && behavior.instSpec.fixedFields < 1)
	{
		CompileError(range, CErrInvalidStructArg);
		return nullptr;
	}

	return structClass;
}

void Compiler::ParseExternalClass(const Str& strClass, TypeDescriptor& descriptor)
{
	POTE structClass = FindExternalClass(strClass, descriptor.range);
	if (m_ok)
	{
		STBehavior& behavior = *(STBehavior*)GetObj(structClass);
		if (ThisTokenIsBinary('*'))
		{
			descriptor.range.m_stop = ThisTokenRange.m_stop;
			NextToken();
			if (ThisTokenIsBinary('*'))
			{
				descriptor.range.m_stop = ThisTokenRange.m_stop;
				NextToken();
				if (behavior.instSpec.indirect)
					// One level of indirection implied, cannot have 3
					CompileError(descriptor.range, CErrNotIndirectable, (Oop)NewUtf8String(strClass));
				else
				{
					// Double indirections always use LPPVOID type
					descriptor.type = DolphinX::ExtCallArgType::LPPVoid;
					descriptor.parm = 0;
				}
			}
			else
			{
				if (behavior.instSpec.indirect)
				{
					// One level of indirection already implied, totalling two
					descriptor.type = DolphinX::ExtCallArgType::LPPVoid;
					descriptor.parm = 0;
				}
				else
				{
					descriptor.type = TypeForStructPointer(structClass);
					descriptor.parm = Oop(structClass);
				}
			}
		}
		else
		{
			// For efficiency/space saving, convert special recognised structure types
			_ASSERTE(structClass != GetVMPointers().ClassExternalAddress);
			_ASSERTE(structClass != GetVMPointers().ClassExternalHandle);
			
			// No explicit indirection, but there may be implicit
			if (behavior.instSpec.indirect)
				descriptor.type = DolphinX::ExtCallArgType::LPStruct;
			else
				descriptor.type = DolphinX::ExtCallArgType::Struct;
			descriptor.parm = Oop(structClass);
		}
	}
}

DolphinX::ExtCallArgType Compiler::TypeForStructPointer(POTE oteStructClass)
{
	const VMPointers& pointers = GetVMPointers();
	POTE oteUnkClass = pointers.ClassIUnknown;
	return (oteUnkClass != pointers.Nil && m_piVM->InheritsFrom(oteStructClass, oteUnkClass))
		? DolphinX::ExtCallArgType::ComPtr
		: DolphinX::ExtCallArgType::LPStruct;
}

// Answers true if an argument type was parsed, else false. Advances over argument if parsed.
void Compiler::ParseExtCallArgument(TypeDescriptor& answer)
{
	switch(ThisToken)
	{
	case TokenType::NameConst:
		{
			// Table of arg types
			// N.B. THIS SHOULD MATCH THE DolphinX::ExtCallArgTypes ENUM...
			struct ArgTypeDefn 
			{
				LPUTF8						m_szName;
				DolphinX::ExtCallArgType	m_type;
				LPUTF8						m_szIndirectClass;
			};
			
			static ArgTypeDefn argTypes[] =	{
				{ (LPUTF8)"sdword", DolphinX::ExtCallArgType::Int32, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"dword", DolphinX::ExtCallArgType::UInt32, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"intptr", DolphinX::ExtCallArgType::IntPtr, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"uintptr", DolphinX::ExtCallArgType::UIntPtr, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"lpvoid", DolphinX::ExtCallArgType::LPVoid, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"handle", DolphinX::ExtCallArgType::Handle, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"lppvoid", DolphinX::ExtCallArgType::LPPVoid, nullptr },
				{ (LPUTF8)"lpstr", DolphinX::ExtCallArgType::LPStr, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"bool", DolphinX::ExtCallArgType::Bool, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"void", DolphinX::ExtCallArgType::Void, (LPUTF8)DolphinX::ExtCallArgType::LPVoid},
				{ (LPUTF8)"double", DolphinX::ExtCallArgType::Double, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"float", DolphinX::ExtCallArgType::Float, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"hresult", DolphinX::ExtCallArgType::HResult, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"ntstatus", DolphinX::ExtCallArgType::NTStatus, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"errno", DolphinX::ExtCallArgType::Errno, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"char", DolphinX::ExtCallArgType::Char, (LPUTF8)DolphinX::ExtCallArgType::LPStr},
				{ (LPUTF8)"byte", DolphinX::ExtCallArgType::UInt8, (LPUTF8)DolphinX::ExtCallArgType::LPVoid},
				{ (LPUTF8)"sbyte", DolphinX::ExtCallArgType::Int8, (LPUTF8)DolphinX::ExtCallArgType::LPVoid},
				{ (LPUTF8)"word", DolphinX::ExtCallArgType::UInt16, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"sword", DolphinX::ExtCallArgType::Int16, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"oop", DolphinX::ExtCallArgType::Oop, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"lpwstr", DolphinX::ExtCallArgType::LPWStr, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"bstr", DolphinX::ExtCallArgType::Bstr, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid },
				{ (LPUTF8)"qword", DolphinX::ExtCallArgType::UInt64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"sqword", DolphinX::ExtCallArgType::Int64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"ote", DolphinX::ExtCallArgType::Ote, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"variant", DolphinX::ExtCallArgType::Variant, (LPUTF8)"VARIANT" },
				{ (LPUTF8)"varbool", DolphinX::ExtCallArgType::VarBool, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"guid", DolphinX::ExtCallArgType::Guid, (LPUTF8)"External.REFGUID" },
				{ (LPUTF8)"date", DolphinX::ExtCallArgType::Date, (LPUTF8)"DATE" },
				//(LPUTF8) Convert a few class types to the special types to save space and time
				{ (LPUTF8)"ExternalAddress", DolphinX::ExtCallArgType::LPVoid, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"ExternalHandle", DolphinX::ExtCallArgType::Handle, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"BSTR", DolphinX::ExtCallArgType::Bstr, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"VARIANT", DolphinX::ExtCallArgType::Variant, (LPUTF8)"VARIANT" },
				{ (LPUTF8)"SDWORD", DolphinX::ExtCallArgType::Int32, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"DWORD", DolphinX::ExtCallArgType::UInt32, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"LPVOID", DolphinX::ExtCallArgType::LPVoid, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"DOUBLE", DolphinX::ExtCallArgType::Double, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"FLOAT", DolphinX::ExtCallArgType::Float, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"HRESULT", DolphinX::ExtCallArgType::HResult, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"NTSTATUS", DolphinX::ExtCallArgType::NTStatus, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"BYTE", DolphinX::ExtCallArgType::UInt8, (LPUTF8)DolphinX::ExtCallArgType::LPVoid},
				{ (LPUTF8)"SBYTE", DolphinX::ExtCallArgType::Int8, (LPUTF8)DolphinX::ExtCallArgType::LPVoid},
				{ (LPUTF8)"WORD", DolphinX::ExtCallArgType::UInt16, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"SWORD", DolphinX::ExtCallArgType::Int16, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"LPWSTR", DolphinX::ExtCallArgType::LPWStr, (LPUTF8)DolphinX::ExtCallArgType::LPPVoid},
				{ (LPUTF8)"QWORD", DolphinX::ExtCallArgType::UInt64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"ULARGE_INTEGER", DolphinX::ExtCallArgType::UInt64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"SQWORD", DolphinX::ExtCallArgType::Int64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"LARGE_INTEGER", DolphinX::ExtCallArgType::Int64, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
				{ (LPUTF8)"GUID", DolphinX::ExtCallArgType::Guid, (LPUTF8)"External.REFGUID" },
				{ (LPUTF8)"IID", DolphinX::ExtCallArgType::Guid, (LPUTF8)"External.REFGUID" },
				{ (LPUTF8)"CLSID", DolphinX::ExtCallArgType::Guid, (LPUTF8)"External.REFGUID" },
				{ (LPUTF8)"VARIANT_BOOL", DolphinX::ExtCallArgType::VarBool, (LPUTF8)DolphinX::ExtCallArgType::LPVoid },
			};

			answer.range = ThisTokenRange;
			Str strToken = ThisTokenText;
			NextToken();

			// Scan the table
			for (size_t i=0; i < sizeof(argTypes)/sizeof(ArgTypeDefn);i++)
			{
				if (strToken == argTypes[i].m_szName)
				{
					answer.type = argTypes[i].m_type;
					answer.parm = 0;

					if (ThisToken == TokenType::Binary && !ThisTokenIsBinary('>'))
					{
						// At least a single indirection to a standard type
						char8_t ch;
						while ((ch = PeekAtChar()) != '>' && isAnsiBinaryChar(ch))
							Step();

						Str strModifier = ThisTokenText;
						unsigned indirections = strModifier == (LPUTF8)"**" ? 2 : strModifier == (LPUTF8)"*" ? 1 : 0;
						if (indirections == 0)
						{
							CompileError(TEXTRANGE(ThisTokenRange.m_start, CharPosition), CErrBadExtTypeQualifier);
						}
						answer.range.m_stop = ThisTokenRange.m_stop;
						NextToken();
						LPUTF8 szClass = argTypes[i].m_szIndirectClass;
						// Indirection to a built-in type?
						if (szClass <= LPUTF8(DolphinX::ExtCallArgType::Struct))
						{
							if (!szClass || (indirections > 1 && szClass == LPUTF8(DolphinX::ExtCallArgType::LPPVoid)))
								// Cannot indirect this type
								CompileError(TEXTRANGE(answer.range.m_start, LastTokenRange.m_stop), CErrNotIndirectable, (Oop)NewUtf8String(strToken));

							if (indirections > 1)
								answer.type = DolphinX::ExtCallArgType::LPPVoid;
							else
								answer.type = DolphinX::ExtCallArgType(reinterpret_cast<uintptr_t>(szClass) & UINT8_MAX);
							answer.parm = 0;
						}
						else
						{
							// Try looking up the specified (special) class
							POTE structClass = FindExternalClass(szClass, answer.range);
							if (m_ok)
							{
								// Indirection to a recognised struct class
								if (indirections > 1)
								{
									answer.type = DolphinX::ExtCallArgType::LPPVoid;
									answer.parm = 0;
								}
								else
								{
									// Single indirection, perhaps already accounted for
									// through use of indirection class in table.
									answer.type = TypeForStructPointer(structClass);
									answer.parm = Oop(structClass);
								}
							}
						}
					}

					// Located one of the special types in the table, return it
					return;
				}
			}

			// Couldn't find the name in the table, so try looking it up as an external struct
			ParseExternalClass(strToken, answer);
		}
		return;
		
	default:
		CompileError(CErrExpectExtType);
		break;
	}
	
	if (m_ok)
		NextToken();
}

void Compiler::ParseBlock(textpos_t textPosition)
{
	PushNewScope(textPosition);

	NextToken();

	// This Nop is needed in case the block is a jump target, as this then
	// allows us to insert the push instructions for any copied values
	GenNop();
	
	// Parse the block arguments
	argcount_t nArgs = ParseBlockArguments(textPosition);
	
	textpos_t stop = textpos_t::npos;
	if (m_ok)
	{
		// Block copy instruction has an implicit jump
		ip_t blockCopyMark = GenInstruction(OpCode::BlockCopy);
		m_bytecodes[blockCopyMark].pScope = m_pCurrentScope;
		// Block copy has 6 extension bytes, most filled in later
		GenData(static_cast<uint8_t>(nArgs));
		GenData(0);
		GenData(0);
		GenData(0);
		GenData(0);	
		GenData(0);
		
		ParseTemporaries();
		
		// Generate the block's body
		ParseBlockStatements();
		ip_t endOfBlockPos = GenReturn(OpCode::ReturnBlockStackTop);
		m_bytecodes[endOfBlockPos].pScope = m_pCurrentScope;
		// Generate text map entry for the Return
		AddTextMap(endOfBlockPos, textPosition, ThisTokenRange.m_stop);
		
		// Fill in the target of the block copy's implicit jump (which will be the following Nop)
		const ip_t endOfBlockNopPos = GenNop();
		m_bytecodes[endOfBlockNopPos].addJumpTo();
		m_bytecodes[blockCopyMark].makeJumpTo(endOfBlockNopPos);

		if (ThisToken == TokenType::CloseSquare)
		{
			stop = ThisTokenRange.m_stop;
			NextToken();
		}
		else
		{
			stop = LastTokenRange.m_stop;
			if (m_ok)
				CompileError(TEXTRANGE(textPosition, stop), CErrBlockNotClosed);
		}
	}

	PopScope(stop != textpos_t::npos ? LastTokenRange.m_stop : stop);
}

argcount_t Compiler::ParseBlockArguments(const textpos_t blockStart)
{
	argcount_t argcount=0;
	while (m_ok && ThisTokenIsSpecial(':'))
	{
		if (NextToken()== TokenType::NameConst)
		{
			// Get temporary name
			AddArgument(ThisTokenText, ThisTokenRange);
			argcount++;
		}
		else
			CompileError(CErrExpectVariable);
		NextToken();
	}
	if (argcount)
	{
		if (ThisTokenIsBinary(TEMPSDELIMITER))
			NextToken();
		else
			CompileError(TEXTRANGE(blockStart, LastTokenRange.m_stop), CErrBlockArgListNotClosed);
	}
	return argcount;
}

POTE Compiler::ParseArray()
{
	// Temporarily add the literal elements of this array to a local buffer.
	// When done we'll gather them all into a new array and just add this
	// to the frame itself.
	//
	OOPVECTOR elems;
	elems.reserve(16);

	textpos_t arrayStart = ThisTokenRange.m_start;

	NextToken();
	while (m_ok && !ThisTokenIsClosing)
	{
		switch(ThisToken) 
		{
		case TokenType::SmallIntegerConst:
			{
				Oop oopElement = m_piVM->NewSignedInteger(ThisTokenInteger);
				elems.push_back(oopElement);
				m_piVM->AddReference(oopElement);
				m_piVM->MakeImmutable(oopElement, TRUE);
				NextToken();
			}
			break;

		case TokenType::LargeIntegerConst:
		case TokenType::ScaledDecimalConst:
			{
				// Result of NewNumber already has ref. count
				Oop oopElem = NewNumber(ThisTokenText);
				m_piVM->MakeImmutable(oopElem, TRUE);
				elems.push_back(oopElem);
				NextToken();
			}
			break;

		case TokenType::FloatingConst:
			{
				Oop oopFloat = reinterpret_cast<Oop>(m_piVM->NewFloat(ThisTokenFloat));
				elems.push_back(oopFloat);
				m_piVM->AddReference(oopFloat);
				m_piVM->MakeImmutable(oopFloat, TRUE);
				NextToken();
			}
			break;
			
		case TokenType::NilConst:
				elems.push_back(reinterpret_cast<Oop>(Nil()));
				NextToken();
				break;

		case TokenType::TrueConst:
				elems.push_back(reinterpret_cast<Oop>(GetVMPointers().True));
				NextToken();
				break;

		case TokenType::FalseConst:
				elems.push_back(reinterpret_cast<Oop>(GetVMPointers().False));
				NextToken();
				break;

		case TokenType::NameConst:
			{
				POTE oteElement = InternSymbol(ThisTokenText);
				Oop oopElement = reinterpret_cast<Oop>(oteElement);
				elems.push_back(oopElement);
				m_piVM->AddReference(oopElement);
				NextToken();
			}
			break;
			
		case TokenType::SymbolConst:
		case TokenType::NameColon:
			{
				Str name = ThisTokenText;
				while (isIdentifierFirst(PeekAtChar()))
				{
					NextToken();
					name += ThisTokenText;
				}
				Oop oopSymbol = reinterpret_cast<Oop>(InternSymbol(name));
				elems.push_back(oopSymbol);
				m_piVM->AddReference(oopSymbol);
				NextToken();
			}
			break;
			
		case TokenType::ArrayBegin:
		case TokenType::Binary:
			{
				if (ThisToken== TokenType::ArrayBegin || ThisTokenIsBinary('('))
				{
					POTE array = ParseArray();
					if (m_ok)
					{
						_ASSERTE(array);
						Oop oopArray = reinterpret_cast<Oop>(array);
						elems.push_back(oopArray);
						m_piVM->AddReference(oopArray);
						m_piVM->MakeImmutable(oopArray, TRUE);
					}
					break;
				}
				
				if (ThisTokenIsBinary('-')) 
				{
					Oop oopElement;
					char8_t ch = PeekAtChar();
					// Look for negation, but first see if in fact
					// we have a binary selector
					if (isAnsiBinaryChar(ch))
					{
						do
						{
							Step();
						}
						while (isAnsiBinaryChar(PeekAtChar()));
						oopElement = reinterpret_cast<Oop>(InternSymbol(ThisTokenText));
						NextToken();
					}
					else if (isdigit(ch))
					{
						NextToken();
						TokenType tokenType = ThisToken;
						if (tokenType == TokenType::SmallIntegerConst)
						{
							oopElement = m_piVM->NewSignedInteger(-ThisTokenInteger);
							NextToken();
						}
						else if (tokenType == TokenType::LargeIntegerConst || tokenType == TokenType::ScaledDecimalConst)
						{
							Str valuetext = (LPUTF8)"-";
							valuetext += ThisTokenText;
							oopElement = NewNumber(valuetext.c_str());
							// Return value has an elevated ref. count which we assume here
							elems.push_back(oopElement);
							NextToken();
							break;
						}
						else if (tokenType == TokenType::FloatingConst)
						{
							oopElement = reinterpret_cast<Oop>(m_piVM->NewFloat(-ThisTokenFloat));
							NextToken();
						}
					}
					else
					{
						oopElement = reinterpret_cast<Oop>(InternSymbol(ThisTokenText));
						NextToken();
					}
					
					elems.push_back(oopElement);
					m_piVM->AddReference(oopElement);
					break;
				}
				
				while (isAnsiBinaryChar(PeekAtChar()))
					Step();
				Oop oopSymbol = reinterpret_cast<Oop>(InternSymbol(ThisTokenText));
				elems.push_back(oopSymbol);
				m_piVM->AddReference(oopSymbol);
				NextToken();
				break;
			}
			
		case TokenType::CharConst:
			{
				Oop oopChar = reinterpret_cast<Oop>(m_piVM->NewCharacter(static_cast<DWORD>(ThisTokenInteger)));
				m_piVM->AddReference(oopChar);
				elems.push_back(oopChar);
				NextToken();
			}
			break;
			
		case TokenType::AsciiStringConst:
		case TokenType::Utf8StringConst:
			{
				LPUTF8 szLiteral = ThisTokenText;
				POTE oteString = *szLiteral
					? NewUtf8String(szLiteral)
					: GetVMPointers().EmptyString;
				Oop oopString = reinterpret_cast<Oop>(oteString);
				elems.push_back(oopString);
				m_piVM->AddReference(oopString);
				m_piVM->MakeImmutable(oopString, TRUE);
				NextToken();
			}
			break;

		case TokenType::ExprConstBegin:
			{
				Oop oopConst = ParseConstExpression();
				elems.push_back(oopConst);
				// Return from ParseConstExpression() already has elevated ref. count
				// Don't think its right to make an arbitrary object immutable here - only literals should be immutable
				//m_piVM->MakeImmutable(oopConst, TRUE);
				NextToken();
			}
			break;
			
		case TokenType::ByteArrayBegin:
			{
				Oop oopBytes = reinterpret_cast<Oop>(ParseByteArray());
				if (m_ok)
				{
					elems.push_back(oopBytes);
					m_piVM->AddReference(oopBytes);
					m_piVM->MakeImmutable(oopBytes, TRUE);
				}
			}
			break;

		case TokenType::QualifiedRefBegin:
			{
				textpos_t start = ThisTokenRange.m_start;
				Oop oopBindingRef = reinterpret_cast<Oop>(ParseQualifiedReference(start));
				if (m_ok)
				{
					elems.push_back(oopBindingRef);
					m_piVM->AddReference(oopBindingRef);
					m_piVM->MakeImmutable(oopBindingRef, TRUE);
				}
			}
			break;

		default:
			CompileError(CErrBadTokenInArray);
			NextToken();
			break;
		}
	}
	
	if (m_ok)
	{
		if (ThisToken == TokenType::CloseParen)
		{
			POTE arrayPointer;

			if (elems.empty())
			{
				arrayPointer = GetVMPointers().EmptyArray;
			}
			else
			{
				// Gather new literals into a new array
				const size_t elemcount = elems.size();
				arrayPointer = m_piVM->NewArray(elemcount);
				STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
				for (size_t i=0; i < elemcount; i++)
				{
					Oop object = elems[i];
					// We've already inc'd ref count of the elements
					#ifdef _DEBUG
						m_piVM->StorePointerWithValue(&array.fields[i], object);
						m_piVM->RemoveReference(object);
					#else
						array.fields[i] = object;
					#endif
				}
			}
			NextToken();
			return arrayPointer;
		}
		else
			CompileError(TEXTRANGE(arrayStart, LastTokenRange.m_stop), CErrArrayNotClosed);
	}
	
	// It failed, so destroy all the new bits and pieces
	for (OOPVECTOR::iterator it = elems.begin(); it != elems.end(); it++)
		m_piVM->RemoveReference(*it);

	return 0;
}

POTE Compiler::ParseByteArray()
{
	// Temporarily add the literal elements of this array to a local buffer.
	// When done we'll gather them all into a new array and just add this
	// to the frame itself.
	// A byte array may be any length.
	//
	std::vector<uint8_t> elems;
	textpos_t start = ThisTokenRange.m_start;

	NextToken();
	while (m_ok && !ThisTokenIsClosing)
	{
		switch(ThisToken) 
		{
		case TokenType::SmallIntegerConst:
			{
				intptr_t intVal = ThisTokenInteger;
				if (intVal < 0 || intVal > UINT8_MAX)
				{
					CompileError(CErrBadValueInByteArray);
					NextToken();
					break;
				}
				elems.push_back(static_cast<uint8_t>(intVal));
				NextToken();
			}
			break;
			
		case TokenType::LargeIntegerConst:
			{
				Oop li = NewNumber(ThisTokenText);
				if (IsIntegerObject(li))
				{
					intptr_t nVal = IntegerValueOf(li);
					if (nVal < 0 || nVal > UINT8_MAX)
						CompileError(CErrBadValueInByteArray);
					else
						elems.push_back(static_cast<uint8_t>(ThisTokenInteger));
					NextToken();
					break;
				}
				else
					m_piVM->RemoveReference(li);
				
				CompileError(CErrBadValueInByteArray);
				NextToken();
			}
			break;
			
		default:
			CompileError(CErrBadValueInByteArray);
			NextToken();
			break;
		}
	}
	
	POTE arrayPointer=0;
	if (m_ok)
	{
		if (ThisToken == TokenType::CloseSquare)
		{
			arrayPointer = m_piVM->NewByteArray(elems.size());
			uint8_t* pb = FetchBytesOf(arrayPointer);
			memcpy(pb, elems.data(), elems.size());
			NextToken();
		}
		else
			CompileError(TEXTRANGE(start, LastTokenRange.m_stop), CErrByteArrayNotClosed);
	}
	return arrayPointer;
}


// N.B. Return value has artificially inc'd ref. count
Oop Compiler::ParseConstExpression()
{
	// We have to create a new compiler to compile and evaluate the
	// subsequent expression in the context of the current class's class.
	CComObject<Compiler>* pCompiler;
	HRESULT hr = CComObject<Compiler>::CreateInstance(&pCompiler);
	if (FAILED(hr))
	{
		_ASSERTE(FALSE);
		return reinterpret_cast<Oop>(Nil());
	}
	pCompiler->AddRef();
	pCompiler->SetVMInterface(m_piVM);

	Oop result;
	size_t len;
	__try
	{
		_ASSERTE(m_compilerObject && m_notifier);
		CompilerFlags flags = m_flags & ~CompilerFlags::DebugMethod;

		POTE methodClass = MethodClass;
		POTE oteSelf = m_piVM->IsAMetaclass(methodClass) ? reinterpret_cast<STMetaclass*>(GetObj(methodClass))->instanceClass: methodClass;
		Oop contextOop = Oop(oteSelf);
		TEXTRANGE tokRange = ThisTokenRange;
		POTE oteMethod = pCompiler->CompileExpression(Text, m_compilerObject, m_notifier, contextOop, flags, len, tokRange.m_stop+1);
		if (pCompiler->m_ok && pCompiler->ThisToken != TokenType::CloseParen)
		{
			CompileError(TEXTRANGE(tokRange.m_start, tokRange.m_stop+len), CErrStaticExprNotClosed);
		}

		if (pCompiler->m_ok && oteMethod != Nil())
		{
			STCompiledMethod& exprMethod = *(STCompiledMethod*)GetObj(oteMethod);

			// Add all the literals in the expression to the end of the literal frame of this method as this
			// allows normal references search to work in IDE
			const size_t loopEnd = pCompiler->LiteralCount;
			for (size_t i=0; i < loopEnd;i++)
			{
				Oop oopLiteral = exprMethod.aLiterals[i];
				_ASSERTE(oopLiteral);
				if (!IsIntegerObject(oopLiteral) &&
						(m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassSymbol) ||
							m_piVM->IsAClass((POTE)oopLiteral) ||
							m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassVariableBinding) ||
							m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassArray)))

				{
					AddToFrame(oopLiteral, LastTokenRange, LiteralType::ReferenceOnly);
				}
			}

			m_piVM->AddReference((Oop)oteMethod);
			result = this->EvaluateExpression(Text, tokRange.m_stop+1, tokRange.m_stop + len - 1, oteMethod, contextOop, Nil());
			m_piVM->RemoveReference((Oop)oteMethod);
		}
		else
			result= Oop(Nil());
	}
	__finally
	{
		m_ok = pCompiler->Ok;
		pCompiler->Release();
	}
	
	// Update source pointer
	AdvanceCharPtr(len);
	return result;
}

Oop Compiler::EvaluateExpression(LPUTF8 source, textpos_t start, textpos_t end, POTE oteMethod, Oop contextOop, POTE pools)
{
	Str exprSource(source, static_cast<size_t>(start), static_cast<size_t>(end - start + 1));
	return EvaluateExpression(exprSource.c_str(), oteMethod, contextOop, pools);
}



void Compiler::GetInstVars()
{
	_ASSERTE(!m_instVarsInitialized);

	if (m_class != Nil())
	{
		POTE arrayPointer=InstVarNamesOf(m_class);	// May throw SE_VMCALLBACKUNWIND
		if (m_piVM->FetchClassOf(Oop(arrayPointer)) != GetVMPointers().ClassArray) 
		{
#if defined(_DEBUG) && !defined(USE_VM_DLL)
			TRACESTREAM<< L"Compiler: " << m_class<< L">>" << GetVMPointers().allInstVarNamesSymbol<< L" returned " <<
				arrayPointer<< L"\n";
#endif
			// #allInstVarNames incorrect result
			CompileError(CompileTextRange(), CErrBadContext);
			m_piVM->RemoveReference(Oop(arrayPointer));
			return;
		}
		
		// We now have an arrayPointer with a list of Strings (or Symbols) that are the
		// instance variable names.
		//
		STVarObject& array=*(STVarObject*)GetObj(arrayPointer);
		const size_t len=FetchWordLengthOf(arrayPointer);
		// Too many inst vars?
		if (len > UINT8_MAX)
			CompileError(CompileTextRange(), CErrBadContext);
		// We know how many inst vars there are in advance of compilation, and this
		// array does not, therefore, need to be dynamic
		m_instVars.resize(len);
		for (size_t i=0; i<len; i++)
		{
			// Copy the names from the Array into our m_instVars array.
			POTE ote = (POTE)array.fields[i];
			auto pb = FetchBytesOf(ote);
			m_instVars[i] = reinterpret_cast<LPUTF8>(pb);
		}
		
		// We don't need the array of inst var names any more
		m_piVM->RemoveReference(Oop(arrayPointer));
	}
	m_instVarsInitialized = true;
}

///////////////////////////////////

void Compiler::GetContext(POTE workspacePools)
{ 
	// Instance variables are now acquired lazily to avoid cost when compiling simple methods

	// Validate the workspace pools
	bool poolsOK = true;
	if (IsIntegerObject(Oop(workspacePools)))
		poolsOK = false;
	else
	{
		m_oopWorkspacePools = workspacePools;
		if (workspacePools != Nil())
		{
			if (m_piVM->FetchClassOf(Oop(m_oopWorkspacePools)) != GetVMPointers().ClassArray)
				poolsOK = false;
			else
			{
				STVarObject& pools = *(STVarObject*)GetObj(m_oopWorkspacePools);
				const size_t len=FetchWordLengthOf(m_oopWorkspacePools);
				if (len == 0)
					m_oopWorkspacePools = Nil();
				else
					for (size_t i=0;i<len;i++)
					{
						Oop oopPool = pools.fields[i];
						if (IsIntegerObject(oopPool))
						{
							poolsOK = false;
							break;
						}
						else
						{
							// At the moment there is no further verification we can do here
						}
					}
			}
		}
	}			
	
	if (!poolsOK)
		CompileError(CErrBadPools);	// The workspace pools were invalid in some way
}
///////////////////////////////////
#ifdef _DEBUG

bool Compiler::IsBlock(Oop oop)
{
	return m_piVM->IsKindOf(Oop(oop), GetVMPointers().ClassBlockClosure) != 0;
}

void Compiler::AssertValidIpForTextMapEntry(ip_t ip, bool bFinal)
{
	if (ip == ip_t::npos) return;
	_ASSERTE(ip <= LastIp);
	const BYTECODE& bc = m_bytecodes[ip];
	if (bc.IsData)
	{
		_ASSERTE(ip > ip_t::zero);
		const BYTECODE& prev = m_bytecodes[ip-1];
		_ASSERTE(prev.IsOpCode);
		_ASSERTE((static_cast<OpCode>(bc.byte) == OpCode::PopStoreTemp && (prev.Opcode == OpCode::IncrementTemp || prev.Opcode == OpCode::DecrementTemp))
			|| (static_cast<OpCode>(bc.byte) == OpCode::StoreTemp && (prev.Opcode == OpCode::IncrementPushTemp || prev.Opcode == OpCode::DecrementPushTemp)));
	}
	else
	{
		_ASSERTE(bc.Opcode == OpCode::Nop || bc.pScope != nullptr);

		// Must be a message send, store (assignment), return, push of the empty block,
		// or the first instruction in a block
		ip_t prevIP = ip - 1;
		while (prevIP >= ip_t::zero && (m_bytecodes[prevIP].IsData || m_bytecodes[prevIP].Opcode == OpCode::Nop))
			--prevIP;
		const BYTECODE* prev = prevIP < ip_t::zero ? nullptr : &m_bytecodes[prevIP];
		bool isFirstInBlock = prev != nullptr && (prev->Opcode == OpCode::BlockCopy
								|| (bc.pScope == nullptr 
										? bc.Opcode == OpCode::Nop && prev != nullptr && prev->IsUnconditionalJump
										: bc.pScope->RealScope->IsBlock 
											&& (bc.pScope->RealScope->InitialIP == ip
											|| bc.pScope != prev->pScope 
											|| bc.pScope->RealScope != prev->pScope->RealScope)));
		if (bFinal && WantDebugMethod)
		{
			// If not at the start of a method or block, then a text map entry should only occur after a Break
			// or (when stripping unreachable code) if the byte immediately follows an unconditional return/jump
			_ASSERTE(ip == ip_t::zero 
				|| isFirstInBlock 
				|| bc.IsConditionalJump
				|| (bc.IsShortPushConst && IsBlock(m_literalFrame[bc.indexOfShortPushConst()]))
				|| (bc.Opcode == OpCode::PushConst && IsBlock(m_literalFrame[m_bytecodes[ip + 1].byte]))
				|| (prev->IsBreak || (!bc.IsJumpTarget && (prev->IsReturn || prev->IsLongJump))));
		}

		_ASSERTE(bc.IsSend
			|| bc.IsConditionalJump
			|| bc.IsStore
			|| bc.IsReturn
			|| (bc.IsShortPushConst && IsBlock(m_literalFrame[bc.indexOfShortPushConst()]))
			|| (bc.Opcode == OpCode::PushConst && IsBlock(m_literalFrame[m_bytecodes[ip + 1].byte]))
			|| (isFirstInBlock)
			|| (bc.IsConditionalJump)
			|| (bc.Opcode == OpCode::IncrementTemp || bc.Opcode == OpCode::DecrementTemp)
			|| (bc.Opcode == OpCode::IncrementStackTop || bc.Opcode == OpCode::DecrementStackTop)
			|| (bc.Opcode == OpCode::IncrementPushTemp|| bc.Opcode == OpCode::DecrementPushTemp)
			|| (bc.Opcode == OpCode::IsZero)
			);
	}
}

void Compiler::VerifyTextMap(bool bFinal)
{
	//_CrtCheckMemory();
	const size_t size = m_textMaps.size();
	for (size_t i=0; i<size; i++)
	{
		const TEXTMAP& textMap = m_textMaps[i];
		ip_t ip = textMap.ip;
		AssertValidIpForTextMapEntry(ip, bFinal);
	}
}

void Compiler::VerifyJumps()
{
	const ip_t end = LastIp;
	for (ip_t i = ip_t::zero; i<=end; i++)
	{
		const BYTECODE& bc = m_bytecodes[i];
		if (bc.IsJumpSource)
		{
			_ASSERTE(bc.IsJumpInstruction);
			_ASSERTE(bc.target <= end);
			const BYTECODE& target = m_bytecodes[bc.target];
			_ASSERTE(!target.IsData);
			_ASSERTE(target.jumpsTo > 0);
		}
	}
}
#endif

POTE Compiler::GetTextMapObject()
{
	const size_t size = m_textMaps.size();
	POTE arrayPointer=m_piVM->NewArray(size*3);
	STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
	size_t arrayIndex = 0;
	for (size_t i=0; i<size; i++)
	{
		const TEXTMAP& textMap = m_textMaps[i];
		ip_t ip = textMap.ip;
		array.fields[arrayIndex++] = IntegerObjectOf(static_cast<intptr_t>(ip) + 1);
		array.fields[arrayIndex++] = IntegerObjectOf(static_cast<intptr_t>(textMap.start) + 1);
		array.fields[arrayIndex++] = IntegerObjectOf(static_cast<intptr_t>(textMap.stop) + 1);
	}
	return arrayPointer;
}

inline void Compiler::BreakPoint()
{
	if (WantDebugMethod)
		GenInstruction(OpCode::Break);
}


size_t Compiler::AddTextMap(ip_t ip, const TEXTRANGE& range)
{
	return AddTextMap(ip, range.m_start, range.m_stop);
}

// Add a new TEXTMAP encoding the current char position and code position
// These need to be added in IP order.
size_t Compiler::AddTextMap(ip_t ip, const textpos_t textStart, const textpos_t textStop)
{
	if (!m_ok) return -1;
	_ASSERTE(ip <= LastIp);
	// textStart can be equal to text length in order to specify an empty interval at the end of the method
	_ASSERTE((intptr_t)textStart >= 0 && static_cast<size_t>(textStart) <= TextLength);
	_ASSERTE(static_cast<size_t>(textStop) < TextLength || textStop == textpos_t::npos);
	if (!WantTextMap) return -1;
	_ASSERTE(m_bytecodes[ip].Opcode != OpCode::Nop);
	m_textMaps.push_back(TEXTMAP(ip, textStart, textStop));
	VerifyTextMap();
	return m_textMaps.size() - 1;
}

void Compiler::InsertTextMapEntry(ip_t ip, textpos_t textStart, textpos_t textStop)
{
	if (!WantTextMap) return;

	const TEXTMAPLIST::const_iterator end = m_textMaps.end();
	TEXTMAPLIST::iterator it = m_textMaps.begin();
	for (; it != end; it++)
	{
		const TEXTMAP& tm = *it;
		if (tm.ip > ip)
			break;
	}
	m_textMaps.insert(it, TEXTMAP(ip, textStart, textStop));
}

Compiler::TEXTMAPLIST::iterator Compiler::FindTextMapEntry(ip_t ip)
{
	const TEXTMAPLIST::const_iterator end = m_textMaps.end();
	for (TEXTMAPLIST::iterator it = m_textMaps.begin(); it != end; it++)
	{
		const TEXTMAP& tm = *it;
		if (tm.ip == ip)
			return it;
	}

	return m_textMaps.end();
}

bool Compiler::RemoveTextMapEntry(ip_t ip)
{
	if (!WantTextMap) return true;

	TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
	{
		const TEXTMAP& tm = (*it);
		const BYTECODE& bc = m_bytecodes[ip];
		ptrdiff_t i = it - m_textMaps.begin();

		m_textMaps.erase(it);
		return true;
	}
	else
		return false;
}

bool Compiler::VoidTextMapEntry(ip_t ip)
{
	if (!WantTextMap) return true;

	TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
	{
		TEXTMAP& tm = (*it);
		tm.ip = ip_t::npos;
		return true;
	}
	else
		return false;
}
///////////////////////////////////

POTE Compiler::GetTempsMapObject()
{
	const size_t nScopes = m_allScopes.size();
	POTE arrayPointer=m_piVM->NewArray(nScopes);
	STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
	size_t arrayIndex = 0;
	for (size_t i=0; i<nScopes; i++)
	{
		LexicalScope* pScope = m_allScopes[i];
		m_piVM->StorePointerWithValue(array.fields+i, reinterpret_cast<Oop>(pScope->BuildTempMapEntry(m_piVM)));
	}
	return arrayPointer;
}

///////////////////////////////////

//==========================================
//Compiler entry points (exported functions)
//==========================================

// Because of a Visual C++ bug, imported exception filters cannot be called directly, as
// a GPF occurs if the filter species that the handler should be run.
static int DolphinExceptionFilter(IDolphin* piVM, LPEXCEPTION_POINTERS info)
{
	return piVM->CallbackExceptionFilter(info);
}

// Compile a string of source as a method in the context of a particular Behavior
STDMETHODIMP_(POTE) Compiler::CompileForClass(IUnknown* piVM, Oop compilerOop, const char* szSource, POTE aClass, FLAGS flags, Oop notifier)
{
	m_piVM = (IDolphin*)piVM;

	// Check argument types are correct
	if (!m_piVM->IsBehavior(Oop(aClass)) || szSource == nullptr)
		return Nil();

	POTE resultPointer = Nil();
	int crtFlag;
	__try
	{
		crtFlag = _CrtSetDbgFlag( _CRTDBG_REPORT_FLAG );
		_CrtSetDbgFlag( crtFlag /*| _CRTDBG_CHECK_ALWAYS_DF */);
		
		__try
		{
			POTE methodPointer = CompileForClassHelper((LPUTF8)szSource, compilerOop, notifier, aClass, static_cast<CompilerFlags>(flags));

			resultPointer = m_piVM->NewArray(3);
			STVarObject& result = *(STVarObject*)GetObj(resultPointer);
			
			m_piVM->StorePointerWithValue(&(result.fields[0]), Oop(methodPointer));
			
			if (m_ok) 
			{
				if (WantTextMap)
					m_piVM->StorePointerWithValue(&(result.fields[1]), Oop(GetTextMapObject()));

				if (WantTempsMap)
					m_piVM->StorePointerWithValue(&(result.fields[2]), Oop(GetTempsMapObject()));
			}
		}
		__except(DolphinExceptionFilter(m_piVM, GetExceptionInformation()))
		{
			// Unwind may occur if user catches CompilerNotification and doesn't resume it (for example)
			//
#ifndef USE_VM_DLL
			TRACESTREAM<< L"WARNING: Unwinding Compiler::CompileForClass("
				<< compilerOop << L',' << szSource << L',' << aClass << L','
				<< std::hex << flags << L',' << notifier << L')' << std::endl;
#endif
		}
	}
	__finally
	{
		_CrtSetDbgFlag(crtFlag);
	}
	
	return resultPointer;
}

// Compile an expression (i.e. source outside a method)
STDMETHODIMP_(POTE) Compiler::CompileForEval(IUnknown* piVM, Oop compilerOop, const char* szSource, POTE aBehaviorOrNil, POTE aWorkspacePool, FLAGS flags, Oop notifier)
{
	m_piVM = (IDolphin*)piVM; 

	POTE nil = Nil();
	// Check argument types are correct
	if (!(aBehaviorOrNil == nil || m_piVM->IsBehavior(reinterpret_cast<Oop>(aBehaviorOrNil))) || szSource == nullptr)
		return nil;
	
	POTE resultPointer = nil;

#if 0
	CHECKREFERENCES
#endif

	wchar_t* prevLocale = nullptr;
	__try
	{
#ifdef USE_VM_DLL
		prevLocale = _wsetlocale(LC_ALL, L"C");
		if (prevLocale[0] == L'C' && prevLocale[1] == 0)
		{
			prevLocale = nullptr;
		}
		else
		{
			prevLocale = _wcsdup(prevLocale);
		}
#endif
		
		__try
		{
			POTE methodPointer = CompileForEvaluationHelper((LPUTF8)szSource, compilerOop, notifier, aBehaviorOrNil, aWorkspacePool, static_cast<CompilerFlags>(flags));
			
			resultPointer = m_piVM->NewArray(3);
			STVarObject& result = *(STVarObject*)GetObj(resultPointer);
			
			m_piVM->StorePointerWithValue(&(result.fields[0]), Oop(methodPointer));
			
			if (WantTextMap)
				m_piVM->StorePointerWithValue(&(result.fields[1]), Oop(GetTextMapObject()));
			
			if (WantTempsMap)
				m_piVM->StorePointerWithValue(&(result.fields[2]), Oop(GetTempsMapObject()));
		}
		__except(DolphinExceptionFilter(m_piVM, GetExceptionInformation()))
		{
			// Unwind may occur if user catches CompilerNotification and doesn't resume it (for example)
			//
#ifndef USE_VM_DLL
			TRACESTREAM<< L"WARNING: Unwinding Compiler::CompileForEval("
				<< compilerOop << L',' << szSource << L',' << aClassOrNil << L','
				<< aWorkspacePool << std::hex << flags << L',' << notifier << L')' << std::endl;
#endif
		}
	}
	__finally
	{
#ifdef USE_VM_DLL
		if (prevLocale != nullptr)
		{
			_wsetlocale(LC_ALL, prevLocale);
			free(prevLocale);
		}
#endif
	}
	
#if 0
	CHECKREFERENCES
#endif

	return resultPointer;
}


//=======================
// Compiler notification
//=======================

// May very well throw SE_VMCALLBACKUNWIND if the Notification is trapped and handled
// We let this propagate up to the outer handler in the main compiler entry points, so
// that the entire compilation is unwound (which will match the behaviour on the Smalltalk
// side).
Oop Compiler::Notification(int errorCode, const TEXTRANGE& range, va_list extras)
{
	POTE argsPointer = m_piVM->NewArray(10);
	STVarObject& args = *(STVarObject*)GetObj(argsPointer);
	args.fields[0] = IntegerObjectOf(errorCode);
	args.fields[1] = IntegerObjectOf(LineNo);

	args.fields[2] = IntegerObjectOf(static_cast<intptr_t>(range.m_start));
	args.fields[3] = IntegerObjectOf(static_cast<intptr_t>(range.m_stop));
	textpos_t offset = TextOffset;
	args.fields[4] = IntegerObjectOf(static_cast<intptr_t>(offset));

	POTE sourceString = NewUtf8String(Text);
	m_piVM->StorePointerWithValue(&args.fields[5], Oop(sourceString));

	LPUTF8 selector = m_selector.c_str();
	if (selector)
	{
		POTE sel = NewUtf8String(selector);
		m_piVM->StorePointerWithValue(&args.fields[6], Oop(sel));
	}
	else
		args.fields[6] = Oop(Nil());
	
	m_piVM->StorePointerWithValue(&args.fields[7], Oop(m_class));
	Oop notifier = m_notifier == Oop(Nil()) ? m_compilerObject : m_notifier;
	m_piVM->StorePointerWithValue(&args.fields[8], notifier);

	size_t extrasCount = 0;
	va_list copy = extras;
	while (va_arg(copy, Oop) != 0)
		extrasCount++;
	
	POTE oopExtras = m_piVM->NewArray(extrasCount);
	m_piVM->StorePointerWithValue(&args.fields[9], Oop(oopExtras));
	STVarObject& arrayExtras = *(STVarObject*)GetObj(oopExtras);
	for (size_t i=0;i<extrasCount;i++)
	{
		Oop oopExtra = va_arg(extras, Oop);
		_ASSERTE(oopExtra != 0);
		m_piVM->StorePointerWithValue(&arrayExtras.fields[i], oopExtra);
	}

	Oop result = m_piVM->PerformWith(m_compilerObject, GetVMPointers().compilerNotificationCallback, Oop(argsPointer));
	m_piVM->RemoveReference(result);
	return result;
}

#include <stdio.h>
void Compiler::_CompileErrorV(int code, const TEXTRANGE& range, va_list extras)
{
	m_ok=false;
	if (!WantSyntaxCheckOnly)	
	{
		if (!(m_flags & CompilerFlags::Boot))
		{
			_ASSERTE(m_compilerObject && m_notifier);
			Notification(code, range, extras);
		}
		else
		{
			Str erroneousText = GetTextRange(range);
			if (IsCompilingExpression)
			{
				fprintf(stdout, "ERROR %d in %s>>%s line %d,(%Id..%Id): %s\n\r", code, reinterpret_cast<const char*>(GetClassName().c_str()), reinterpret_cast<const char*>(m_selector.c_str()), LineNo, range.m_start, range.m_stop,
					reinterpret_cast<const char*>(erroneousText.c_str()));
			}
			else
			{
				fprintf(stdout, "ERROR %d in %s>>%s line %d,(%Id..%Id): %s\n\r", code, reinterpret_cast<const char*>(GetClassName().c_str()), reinterpret_cast<const char*>(m_selector.c_str()), LineNo, range.m_start, range.m_stop,
					reinterpret_cast<const char*>(erroneousText.c_str()));
			}
			fprintf(stdout, (LPCSTR)Text);
		}
	}
}

void Compiler::Warning(int code, Oop extra)
{
	WarningV(ThisTokenRange, code, extra, 0);
}

void Compiler::Warning(const TEXTRANGE& range, int code, Oop extra)
{
	WarningV(range, code, extra, 0);
}

void Compiler::WarningV(const TEXTRANGE& range, int code, ...)
{
	if (!WantSyntaxCheckOnly)	
	{
		if (!(m_flags & CompilerFlags::Boot))
		{
			_ASSERTE(m_compilerObject);
			va_list extras;
			va_start(extras, code);
			Notification(code, range, extras);
			va_end(extras);
		}
		else
		{
			char buf[1024];
			VERIFY(wsprintf(buf, "WARNING %s>>%s line %d: %d\n", GetClassName().c_str(), m_selector.c_str(), LineNo, code) >= 0);
			OutputDebugString(buf);
			//((CIstApp*)AfxGetApp())->OutputErrorStringToCurrentDoc(buf);
			OutputDebugString((LPCSTR)Text);
			OutputDebugString("\n\r");
		}
	}
}

void Compiler::InternalError(const char* szFile, int Line, const TEXTRANGE& range, const char* szFormat, ...)
{
	va_list args;
	va_start(args, szFormat);

	int nBuf;
	char szBuffer[1024];
	nBuf = _vsnprintf_s(szBuffer, sizeof(szBuffer), szFormat, args);
	_ASSERTE(nBuf < sizeof(szBuffer)); //Output truncated as it was > sizeof(szBuffer)
	va_end(args);

	OutputDebugString(szBuffer);
	OutputDebugString("\n\r");
	
	CompileError(range, CErrInternal);
}

/******************************************************************************
*
* NEW D6 Closure related temp scoping
*
******************************************************************************/

TempVarDecl* Compiler::DeclareTemp(const Str& strName, const TEXTRANGE& range)
{
	TempVarDecl* pNewVar = new TempVarDecl(strName, range);
	m_pCurrentScope->AddTempDecl(pNewVar, this);
	return pNewVar;
}

void Compiler::PopScope(textpos_t textStop)
{
	_ASSERTE(m_pCurrentScope != nullptr);
	m_pCurrentScope->SetTextStop(textStop);
	m_pCurrentScope = m_pCurrentScope->Outer;
}

void Compiler::PushNewScope(textpos_t textStart, bool bOptimized)
{
	textpos_t start = textStart < textpos_t::start ? ThisTokenRange.m_start : textStart;
	LexicalScope* pNewScope = new LexicalScope(m_pCurrentScope, start, bOptimized);
	m_allScopes.push_back(pNewScope);
	m_pCurrentScope = pNewScope;
	if (m_pCurrentScope->GetDepth() > MAXBLOCKNESTING)
	{
		// Note that the error range is just the first char of the scope (block), which is
		// not terribly satisfactory, but at this stage we don't know where the block ends
		// and encountering this error in practice is extremely unlikely (who writes
		// methods with 255 nested blocks?)
		CompileError(TEXTRANGE(start, start), CErrBlockNestingTooDeep);
	}
}

void Compiler::PushOptimizedScope(textpos_t textStart)
{
	PushNewScope(textStart, true);
}

ip_t Compiler::GenTempRefInstruction(OpCode instruction, TempVarRef* pRef)
{
	unsigned scopeDepth = pRef->GetEstimatedDistance();
	_ASSERTE(scopeDepth <= UINT8_MAX);
	ip_t pos = GenInstructionExtended(instruction, static_cast<uint8_t>(scopeDepth));
	// Placeholder for index (not yet known)
	GenData(0);
	m_bytecodes[pos].pVarRef = pRef;

	return pos;
}

size_t Compiler::GenPushCopiedValue(TempVarDecl* pDecl)
{
	size_t index = pDecl->Index;
	_ASSERTE(index != -1);
	size_t bytesGenerated = 0;

	switch(pDecl->VarType)
	{
	case TempVarType::Unaccessed:
		InternalError(__FILE__, __LINE__, pDecl->TextRange, 
						"Unaccessed copied value '%s'", pDecl->Name.c_str());
		break;

	case TempVarType::Copy:	// Copies are pushed back on the stack on block activation
	case TempVarType::Stack:	// A stack variable accessed only from its local scope
	case TempVarType::Copied:	// This is the type of a stack variable that has been copied
	{
		ip_t insertedAt;
		if (index < NumShortPushTemps)
		{
			insertedAt = GenInstruction(OpCode::ShortPushTemp, static_cast<uint8_t>(index));
			bytesGenerated = 1;
		}
		else
		{
			insertedAt = GenInstructionExtended(OpCode::PushTemp, static_cast<uint8_t>(index));
			bytesGenerated = 2;
		}

#ifdef _DEBUG
		// This fake temp ref is only needed for diagnostic purposes (the refs having been processed already)
		TempVarRef* pVarRef = pDecl->Scope->AddTempRef(pDecl, VarRefType::Read, pDecl->TextRange);
		m_bytecodes[insertedAt].pVarRef = pVarRef;
#endif
		break;
	}

	case TempVarType::Shared:
		InternalError( __FILE__, __LINE__, pDecl->TextRange, 
						"Can't copy shared temp '%s'", pDecl->Name.c_str());
		break;

	default:
		__assume(false);
		break;
	}

	return bytesGenerated;
}

