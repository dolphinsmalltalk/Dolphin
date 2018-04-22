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


Compiler::LibCallType Compiler::callTypes[DolphinX::NumCallConventions] = 
{
	(LPUTF8)"stdcall:", DolphinX::ExtCallStdCall,
	(LPUTF8)"cdecl:", DolphinX::ExtCallCDecl,
	(LPUTF8)"thiscall:", DolphinX::ExtCallThisCall,
	(LPUTF8)"fastcall:", DolphinX::ExtCallFastCall
};

///////////////////////

Compiler::Compiler() :
		m_allScopes(NULL),
		m_bytecodes(NULL),
		m_class(0),
		m_codePointer(0),
		m_compiledMethodClass(NULL),
		m_compilerObject(0),
		m_context(0),
		m_flags(Default),
		m_instVars(NULL),
		m_instVarsInitialized(false),
		m_literalFrame(NULL),
		m_literalLimit(LITERALLIMIT),
		m_notifier(0),
		m_ok(true),
		m_oopWorkspacePools(NULL),
		m_pCurrentScope(NULL),
		m_primitiveIndex(0),
		m_selector(),
		m_sendType(SendOther),
		m_textMaps(NULL)
{
	m_bytecodes.reserve(128);
}
	
Compiler::~Compiler()
{
	// Free scopes
	{
		const int count = m_allScopes.size();
		for (int i = 0; i < count ; i++)
		{
			LexicalScope* pScope = m_allScopes[i];
			delete pScope;
		}
	}

	// Free literal frame
	{
		const int count = m_literalFrame.size();
		for (int i = 0; i < count; i++)
		{
			m_piVM->RemoveReference(m_literalFrame[i]);
		}
	}
}

inline void Compiler::SetFlagsAndText(FLAGS flags, LPUTF8 text, int offset)
{
	m_flags=flags;
	SetText(text, offset);
	NextToken();
}
	
void Compiler::PrepareToCompile(FLAGS flags, LPUTF8 compiletext, int offset, POTE aClass, Oop compiler, Oop notifier, POTE workspacePools, POTE compiledMethodClass, Oop context)
{
	// Prepare to compile methods for the given class.
	// This gets the list of instance variable names for this class
	// and all its super classes so we can find the indices later.
	
	m_compiledMethodClass = compiledMethodClass;
	_ASSERTE(aClass);
	m_class = aClass;
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
		Str actualClassName = recurse ? GetNameOfClass(Oop(m_piVM->FetchClassOf(oopClass)), false) : (LPUTF8)"invalid object";
		uint8_t buf[512];
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

POTE Compiler::CompileExpression(LPUTF8 compiletext, Oop compiler, Oop notifier, Oop contextOop, FLAGS flags, unsigned& len, int exprStart)
{
	POTE classPointer = m_piVM->FetchClassOf(contextOop);
	PrepareToCompile(flags, compiletext, exprStart, classPointer, compiler, notifier, Nil(), GetVMPointers().ClassCompiledExpression, contextOop);
	POTE oteMethod;
	if (m_ok)
	{
		oteMethod = ParseEvalExpression(CloseParen);
	}
	else
		oteMethod = Nil();

	len = GetParsedLength();

	return oteMethod;
}

POTE Compiler::CompileForClassHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aClass, FLAGS flags)
{
	BOOL wasDisabled = m_piVM->DisableAsyncGC(true);
	POTE method = Nil();
	__try
	{
		if (flags & ScanOnly)
		{
			while (!AtEnd())
				NextToken();
		}
		else
		{
			PrepareToCompile(flags, compiletext, 0, aClass, compiler, notifier, Nil(), GetVMPointers().ClassCompiledMethod);
			if (m_ok)
				// Do the compile
				method=ParseMethod();
		}
	}
	__finally
	{
		m_piVM->DisableAsyncGC(wasDisabled);
	}
	return method;
}

POTE Compiler::CompileForEvaluationHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aBehavior, POTE aWorkspacePool, FLAGS flags)
{
	BOOL wasDisabled = m_piVM->DisableAsyncGC(true);
	POTE method = Nil();
	__try
	{
		PrepareToCompile(flags, compiletext, 0, aBehavior, compiler, notifier,  aWorkspacePool, GetVMPointers().ClassCompiledExpression);
		if (m_ok)
		{
			method = ParseEvalExpression(Eof);
			if (m_ok && ThisToken() != Eof)		
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
	return GetNameOfClass(Oop(m_class));
}

///////////////////////////////////


inline int Compiler::FindNameAsSpecialMessage(const Str& name) const
{
	// Returns true and an appropriate (index) if (name) is a
	// special message
	//
	
	const VMPointers& pointers = GetVMPointers();
	for (int i = 0; i < NumSpecialSelectors; i++)
	{
		const POTE stringPointer = pointers.specialSelectors[i];
		_ASSERTE(m_piVM->IsKindOf(Oop(stringPointer), pointers.ClassSymbol));
		LPUTF8 psz = (LPUTF8)FetchBytesOf(stringPointer);
		if (name == psz)
		{
			return i + ShortSpecialSend;
		}
	}

	for (int i = 0; i < NumExSpecialSends; i++)
	{
		const POTE stringPointer = pointers.exSpecialSelectors[i];
		if (stringPointer != pointers.Nil)
		{
			_ASSERTE(m_piVM->IsKindOf(Oop(stringPointer), pointers.ClassSymbol));
			LPUTF8 psz = (LPUTF8)FetchBytesOf(stringPointer);
			if (name == psz)
			{
				return i + FirstExSpecialSend;
			}
		}
	}

	return -1;
}

inline int Compiler::FindNameAsInstanceVariable(const Str& name) const
{
	// Search for an instance variable if (name) and return true and its
	// (index) if one is found. We go through the list backwards for speed
	// rather than a necessity of scoping.
	//
	if (!m_instVarsInitialized) const_cast<Compiler*>(this)->GetInstVars();

	int i;
	for (i=m_instVars.size()-1; i>=0; i--)
	{
		if (name == m_instVars[i])
			break;
	}
	return i;
}

TempVarRef* Compiler::AddTempRef(const Str& strName, VarRefType refType, const TEXTRANGE& range, int expressionEnd)
{
	// Search for a temporary variable of (name) and return true and its
	// (index) if one is found. We MUST look through the list backwards to
	// get correct scoping.
	//
	LexicalScope* pScope = m_pCurrentScope;

	TempVarDecl* pDecl = pScope->FindTempDecl(strName);
	if (pDecl == NULL)
		// Undeclared
		return NULL;

	if (pDecl->IsReadOnly() && refType > vrtRead)
	{
		CompileError(TEXTRANGE(range.m_start, expressionEnd), CErrAssignmentToArgument, 
						(Oop)NewUtf8String(strName));
		return NULL;
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

	Oop scope = reinterpret_cast<Oop>(m_class == nil ? GetVMPointers().ClassUndefinedObject : m_class);
	POTE oteBinding = reinterpret_cast<POTE>(m_piVM->PerformWith(scope, GetVMPointers().fullBindingForSymbol, 
												reinterpret_cast<Oop>(NewUtf8String(name))));
	STVarObject* pools = NULL;
	// Look in Workspace pools (if any) next
	if (oteBinding == nil && m_oopWorkspacePools != nil)
	{
		pools = (STVarObject*)GetObj(m_oopWorkspacePools);
		const MWORD poolsSize = FetchWordLengthOf(m_oopWorkspacePools);
		for (MWORD i=0; i<poolsSize; i++)
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
			if (IsInteractive())
			{
				char szPrompt[256];
				::LoadString(GetResLibHandle(), IDP_AUTO_DEFINE_GLOBAL, szPrompt, sizeof(szPrompt)-1);
				char* msg = new char[strlen(szPrompt)+name.size()+32];
				::wsprintf(msg, szPrompt, name.c_str());
				char szCaption[256];
				::LoadString(GetResLibHandle(), IDR_COMPILER, szCaption, sizeof(szCaption)-1);
				int answer = ::MessageBox(NULL, msg, szCaption, MB_YESNOCANCEL|MB_ICONQUESTION|MB_TASKMODAL);
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
					return STATICCANCEL;
					
				case IDNO:
				default:
					break;
				}
			}
		}
		else
		{
			if (!WantSyntaxCheckOnly() && pools != NULL)
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
		StaticType sharedType = m_piVM->IsImmutable(reinterpret_cast<Oop>(oteBinding)) ? STATICCONSTANT : STATICVARIABLE;
		oteStatic = oteBinding;
		return sharedType;
	}
	else
		return STATICNOTFOUND;
}

//////////////////////////////////////////////////////////////

// Add a new temporary at the top of the temporaries stack
TempVarDecl* Compiler::AddTemporary(const Str& name, const TEXTRANGE& range, bool isArg)
{
	TempVarDecl* pVar = NULL;

	CheckTemporaryName(name, range, isArg);
	if (m_ok)
		pVar = DeclareTemp(name, range);

	return pVar;
}

TempVarDecl* Compiler::AddArgument(const Str& name, const TEXTRANGE& range)
{
	TempVarDecl* pNewVar = AddTemporary(name, range, true);
	if (pNewVar == NULL)
		return NULL;
	
	m_pCurrentScope->ArgumentAdded(pNewVar);
	return pNewVar;
}

// Rename the temporary at location "temporary" to the name "newName"
void Compiler::RenameTemporary(int temporary, LPUTF8 newName, const TEXTRANGE& range)
{
	CheckTemporaryName(newName, range, false);
	m_pCurrentScope->RenameTemporary(temporary, newName, range);
}

void Compiler::CheckTemporaryName(const Str& name, const TEXTRANGE& range, bool isArg)
{
	if (strspn((LPCSTR)name.c_str(), GENERATEDTEMPSTART) != 0)
		return;

	if (IsPseudoVariable(name))
	{
		CompileError(range, CErrRedefiningPseudoVar);
		return;
	}

	TempVarDecl* pDecl = m_pCurrentScope->FindTempDecl(name);
	if (pDecl && pDecl->GetScope() == m_pCurrentScope)
	{
		if (isArg)
		{
			_ASSERTE(pDecl->IsArgument());
			CompileError(range, CErrDuplicateArgName);
		}
		else
			CompileError(range, pDecl->IsArgument() ? CErrRedefiningArg : CErrDuplicateTempName);
	}

	if (IsInteractive())
	{
		if (pDecl)
			Warning(range, pDecl->IsArgument() ? CWarnRedefiningArg : CWarnRedefiningTemp);
		else if (FindNameAsInstanceVariable(name) >= 0)
			Warning(range, CWarnRedefiningInstVar);
		else
		{
			POTE oteStatic;
			if (FindNameAsStatic(name, oteStatic) > STATICNOTFOUND)
			{
				m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
				Warning(range, CWarnRedefiningStatic);
			}
		}
	}
}

//////////////////////////////////////////////////

int Compiler::GenByte(BYTE value, BYTE flags, LexicalScope* pScope)
{
 	_ASSERTE(m_pCurrentScope != NULL);
	InsertByte(m_codePointer, value, flags, pScope);
	int ip = m_codePointer;
	m_codePointer++;
	return ip;
}

// Insert an extended instruction at the code pointer, returning the position at which
// the instruction was inserted.
inline int Compiler::GenInstructionExtended(BYTE basic, BYTE extension)
{
	int pos=GenInstruction(basic);
	GenData(extension);
	return pos;
}

// Insert an extended instruction at the code pointer, returning the position at which
// the instruction was inserted.
int Compiler::GenLongInstruction(BYTE basic, WORD extension)
{
	// Generate a double extended instruction.
	//
	int pos=GenInstruction(basic);
	GenData(extension & 0xFF);
	GenData(extension >> 8);
	return pos;
}

void Compiler::UngenInstruction(int pos)
{
	_ASSERTE(pos < GetCodeSize());
	BYTECODE& bc = m_bytecodes[pos];
	_ASSERTE(bc.isOpCode());
	_ASSERTE(FindTextMapEntry(pos) == m_textMaps.end());
	
	// Marks the byte at pos as being unwanted by changing it to a Nop
	if (bc.isJumpSource())
	{
		_ASSERTE(bc.target < GetCodeSize());
		_ASSERTE(static_cast<SWORD>(bc.target) >= 0);
		m_bytecodes[bc.target].removeJumpTo();
		bc.makeNonJump();
	}
	
	const int len = bc.instructionLength();
	// Nop-out the instruction (N.B. doesn't remove it!)
	bc.byte = Nop;
	// Also nop-out any data bytes associated with the instruction
	for (int i=1;i<len;i++)
		UngenData(pos+i, bc.pScope);
}

// Opens up a space at pos in the code array
// Adjusts any jumps that occur over the boundary

void Compiler::InsertByte(int pos, BYTE value, BYTE flags, LexicalScope* pScope)
{
	const int codeSize = GetCodeSize();

	if (pos == codeSize)
	{
		m_bytecodes.push_back(BYTECODE(value, flags, pScope));
	}
	else
	{
		_ASSERTE(pos >= 0 && pos < codeSize);
		m_bytecodes.insert(m_bytecodes.begin()+pos, BYTECODE(value, flags, pScope));

		// New byte may become jump target
		// Adjust the jumps providing we are not appending to the end of the code.
		// Note use of <= because we have inserted an additional bytecode
		for (int i=0; i <= codeSize; i++)
		{
			BYTECODE& bc = m_bytecodes[i];
			if (bc.isJumpSource())
			{
				_ASSERTE(bc.target < GetCodeSize() - 1);

				// This is a jump. Does it cross the boundary?
				if (bc.target >= pos)
				{
					bc.target++;
				}
			}
		}
	
		// Adjust ip of any TextMaps
		const int textMapCount = m_textMaps.size();
		for (int i = 0; i < textMapCount; i++)
		{
			TEXTMAP& textMap = m_textMaps[i];
			if (textMap.ip >= pos)
				textMap.ip++;
		}
	}
}


int Compiler::GenPushTemp(TempVarRef* pTemp)
{
	return GenTempRefInstruction(LongPushOuterTemp, pTemp);
}

inline int Compiler::GenPushInstVar(BYTE index)
{
	m_pCurrentScope->MarkNeedsSelf();

	// Push an instance variable
	return (index < NumShortPushInstVars) 
		? GenInstruction(ShortPushInstVar, index)
		: GenInstructionExtended(PushInstVar, index);
}

inline void Compiler::GenPushStaticVariable(const Str& strName, const TEXTRANGE& range)
{
	POTE oteStatic;
	switch (FindNameAsStatic(strName, oteStatic))
	{
	case STATICCONSTANT:
		GenPushStaticConstant(oteStatic, range);
		break;

	case STATICVARIABLE:
		GenStatic(oteStatic, range);
		break;
		
	case STATICCANCEL:
		m_ok = false;
		return;
		
	case STATICNOTFOUND:
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
	if (!GenPushImmediate(literal, range))
	{
		// If it doesn't have an immediate form, may as well push the variable binding as this is better for ref searches in the IDE
		// and means we don't need to recompile if the value changes.
		GenStatic(oteStatic, range);
	}
}

void Compiler::GenPushSelf()
{
	m_pCurrentScope->MarkNeedsSelf();
	GenInstruction(ShortPushSelf);
}

void Compiler::GenPushVariable(const Str& strName, const TEXTRANGE& range)
{
	if (strName == VarSelf)
	{
		GenPushSelf();
		m_sendType = SendSelf;
	}
	else if (strName == VarSuper &&	// Cannot supersend from class with no superclass
		((STBehavior*)GetObj(m_class))->superclass != Nil())
	{
		// If name is "super" then we must set a flag to tell our expressions
		// that messages must be sent to superclass of self.
		//
		GenPushSelf();
		m_sendType = SendSuper;
	}
	else if (strName == VarThisContext)
		GenInstruction(PushActiveFrame);
	else
	{
		TempVarRef* pRef = AddTempRef(strName, vrtRead, range, range.m_stop);

		if (pRef != NULL)
			GenPushTemp(pRef);
		else 
		{
			int index = FindNameAsInstanceVariable(strName);
			if (index >= 0)
			{
				// Only 255 inst vars recognised, so index should not be > 255
				_ASSERTE(index < 256);
				GenPushInstVar(static_cast<BYTE>(index));
			}
			else 
				GenPushStaticVariable(strName, range);
		}
	}
}

void Compiler::GenInteger(int val, const TEXTRANGE& range)
{
	// Generates code to push a small integer constant.
	if (val >= -1 && val <= 2)
		GenInstruction(ShortPushZero + val);
	else if (val >= -128 && val <= 127)
		GenInstructionExtended(PushImmediate, static_cast<BYTE>(val));
	else if (val >= -32768 && val <= 32767)
		GenLongInstruction(LongPushImmediate, static_cast<WORD>(val));
	else if (IsIntegerValue(val))
	{
		// Note that although there is sufficient space in the instruction to represent the full range of
		// 32-bit integers, we don't bother with those outside the SmallInteger range since those would
		// then need to be allocated each time, rather than read from a constant in the literal frame.

		GenInstruction(ExLongPushImmediate);
		GenData(val & 0xFF);
		GenData((val >> 8) & 0xFF);
		GenData((val >> 16) & 0xFF);
		GenData((val >> 24) & 0xFF);
	}
	else
		GenLiteralConstant(m_piVM->NewSignedInteger(val), range);
}

int Compiler::PriorInstruction() const
{
	int priorIndex = m_codePointer-1;
	while (priorIndex >= 0 && m_bytecodes[priorIndex].isData())
		priorIndex--;
	return priorIndex;
}

// Answer whether the previous instruction is a push SmallInteger
// There are a number of possibilities
bool Compiler::LastIsPushSmallInteger(int& value) const
{
	int priorIndex = PriorInstruction();
	if (priorIndex < 0)
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
	int priorIndex = PriorInstruction();
	if (priorIndex < 0)
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

Oop Compiler::IsPushLiteral(int pos) const
{
	BYTE opCode = m_bytecodes[pos].byte;

	switch(opCode)
	{
	case ShortPushMinusOne:
	case ShortPushZero:
	case ShortPushOne:
	case ShortPushTwo:
		return IntegerObjectOf(opCode - ShortPushZero);

	case PushImmediate:
		return IntegerObjectOf(SBYTE(m_bytecodes[pos+1].byte));

	case LongPushImmediate:
		// Remember x86 is little endian
		return IntegerObjectOf(SWORD(m_bytecodes[pos+1].byte | (m_bytecodes[pos+2].byte << 8)));

	case ExLongPushImmediate:
		return IntegerObjectOf(static_cast<SDWORD>((m_bytecodes[pos+ExLongPushImmediateInstructionSize-1].byte) << 24
			| (m_bytecodes[pos + ExLongPushImmediateInstructionSize - 2].byte << 16)
			| (m_bytecodes[pos + ExLongPushImmediateInstructionSize - 3].byte << 8)
			| m_bytecodes[pos + ExLongPushImmediateInstructionSize - 4].byte));

	case PushConst:
		return m_literalFrame[m_bytecodes[pos+1].byte];

	case ShortPushConst+0:
	case ShortPushConst+1:
	case ShortPushConst+2:
	case ShortPushConst+3:
	case ShortPushConst+4:
	case ShortPushConst+5:
	case ShortPushConst+6:
	case ShortPushConst+7:
	case ShortPushConst+8:
	case ShortPushConst+9:
	case ShortPushConst+10:
	case ShortPushConst+11:
	case ShortPushConst+12:
	case ShortPushConst+13:
	case ShortPushConst+14:
	case ShortPushConst+15:
		_ASSERTE(m_bytecodes[pos].isShortPushConst());
		return m_literalFrame[opCode - ShortPushConst];

	default:
		// If this assertion fires, then the above case may need updating to reflect the
		// change in the bytecode set, i.e. more or less ShortPushConst instructions
		_ASSERTE(!m_bytecodes[pos].isShortPushConst());
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

int Compiler::AddToFrameUnconditional(Oop object, const TEXTRANGE& errRange)
{
	// Adds (object) to the literal frame even if it is already there.
	// Returns the index to the object in the literal frame.
	//
	_ASSERTE(object);
	_ASSERTE(!IsIntegerObject(object) || IntegerValueOf(object) < -32768 || IntegerValueOf(object) > 32767 || errRange.span() <= 0);
	int index=-1;
	int count = GetLiteralCount();
	if (count < m_literalLimit)
	{
		index = count;
		m_literalFrame.push_back(object);
		m_piVM->AddReference(object);
		CHECKREFERENCES
	}
	else
		CompileError(errRange, CErrTooManyLiterals, object);

	return index;
}

int Compiler::AddToFrame(Oop object, const TEXTRANGE& errRange)
{
	// Adds (object) to the literal frame if it is not already there.
	// Returns the index to the object in the literal frame.
	//
	for (int i=GetLiteralCount()-1;i>=0;i--)
	{
		Oop literalPointer = m_literalFrame[i];
		_ASSERTE(literalPointer);

		if (literalPointer == object)
		{
			CHECKREFERENCES
			return i;
		}
	}
	
	return AddToFrameUnconditional(object, errRange);
}

int Compiler::AddStringToFrame(POTE stringPointer, const TEXTRANGE& range)
{
	// Adds (object) to the literal frame if it is not already there.
	// Returns the index to the object in the literal frame.
	//
	POTE classPointer = m_piVM->FetchClassOf(Oop(stringPointer));
	LPUTF8 szValue = (LPUTF8)FetchBytesOf(stringPointer);

	for (int i=GetLiteralCount()-1;i>=0;i--)
	{
		Oop literalPointer = m_literalFrame[i];
		_ASSERTE(literalPointer);

		if ((m_piVM->FetchClassOf(literalPointer) == classPointer) &&
			strcmp((LPCSTR)FetchBytesOf(POTE(literalPointer)), (LPCSTR)szValue) == 0)
		{
			return i;
		}
	}
	
	Oop oopString = reinterpret_cast<Oop>(stringPointer);
	m_piVM->MakeImmutable(oopString, TRUE);
	return AddToFrameUnconditional(oopString, range);
}

void Compiler::GenLiteralConstant(Oop object, const TEXTRANGE& range)
{
	m_piVM->MakeImmutable(object, TRUE);
	GenConstant(AddToFrame(object, range));
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
			GenInstruction(ShortPushFalse);
		else if (objectPointer == Oop(vmPointers.True))
			GenInstruction(ShortPushTrue);
		else if (objectPointer == Oop(vmPointers.Nil))
			GenInstruction(ShortPushNil);
		else if (m_piVM->IsKindOf(objectPointer, GetVMPointers().ClassCharacter))
		{
			STVarObject* pChar = GetObj((POTE)objectPointer);
			Oop asciiValue = pChar->fields[0];
			_ASSERT(IsIntegerObject(asciiValue));
			MWORD codePoint = IntegerValueOf(asciiValue);
			if (codePoint > 127)
			{
				return false;
			}
			GenInstructionExtended(PushChar, static_cast<BYTE>(codePoint));
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
		GenConstant(AddToFrame(objectPointer, range));
	}
}



// Generates code to push a literal constant
void Compiler::GenConstant(int index)
{
	if (m_ok)
	{
		// Index should be >=0 if no error detected
		_ASSERTE(index >= 0);

		// Generate the push
		if (index < NumShortPushConsts)		// In range of short instructions ?
			GenInstruction(ShortPushConst, index);
		else if (index < 256)				// In range of single extended instructions ?
		{
			GenInstructionExtended(PushConst, static_cast<BYTE>(index));
		}
		else
		{
			// Too many literals detected when adding to frame, so index should be in range
			_ASSERTE(index < 65536);
			GenLongInstruction(LongPushConst, static_cast<WORD>(index));
		}
	}
}		

// Generates code to push a literal variable.
void Compiler::GenStatic(const POTE oteStatic, const TEXTRANGE& range)
{
	int index = AddToFrame(reinterpret_cast<Oop>(oteStatic), range);

	if (m_ok)
	{
		// Index should be >=0 if no error detected
		_ASSERT(index >= 0);

		// Generate the push
		if (index < NumShortPushStatics)	// In range of short instructions ?
			GenInstruction(ShortPushStatic, index);
		else if (index < 256)				// In range of single extended instructions ?
		{
			GenInstructionExtended(PushStatic, static_cast<BYTE>(index));
		}
		else
		{
			// Too many literals detected when adding to frame, so index should be in range
			_ASSERTE(index < 65536);
			GenLongInstruction(LongPushStatic, static_cast<WORD>(index));
		}
	}
}		

int Compiler::GenReturn(BYTE retOp)
{
	BreakPoint();
	return GenInstruction(retOp);
}

int Compiler::GenMessage(const Str& pattern, int argCount, int messageStart)
{
	BreakPoint();
	// Generates code to send a message (pattern) with (argCount) arguments
	if (m_sendType != SendSuper)
	{
		// Look for special or arithmetic messages
		int bytecode = FindNameAsSpecialMessage(pattern);
		if (bytecode > 0)
		{
			return GenInstruction(bytecode);
		}
	}
	
	// It wasn't that simple so we'll need a literal 
	// symbol in the frame.
	POTE oteSelector = InternSymbol(pattern);
	TEXTRANGE errRange = TEXTRANGE(messageStart, argCount == 0 ? ThisTokenRange().m_stop : LastTokenRange().m_stop);
	int symbolIndex=AddToFrame(reinterpret_cast<Oop>(oteSelector), errRange);
	if (symbolIndex < 0)
		return 0;

	if (m_sendType == SendSuper)
	{
		// Warn if supersends a message which is not implemented - be sure not to wrongly flag 
		// recursive self send first time the method is compiled
		POTE superclass = ((STBehavior*)GetObj(m_class))->superclass;
		if (IsInteractive() && !CanUnderstand(superclass, oteSelector))
			WarningV(errRange, CWarnMsgUnimplemented, reinterpret_cast<Oop>(oteSelector), m_piVM->NewString("super"), superclass, 0);
	}
	else
	{
		// Warn if self-sends a message which is not implemented
		if (m_sendType == SendSelf && IsInteractive() 
				&& pattern != m_selector && !CanUnderstand(m_class,  oteSelector))
			WarningV(errRange, CWarnMsgUnimplemented, reinterpret_cast<Oop>(oteSelector), m_piVM->NewString("self"), m_class, 0);

		// A short send may be possible (sends to super are always long as there is no short
		// version), but only if 0..2 args, and within literal index ranges
		
		switch (argCount)
		{
		case 0:
			if (symbolIndex < NumShortSendsWithNoArgs)
			{
				return GenInstruction(ShortSendWithNoArgs, static_cast<BYTE>(symbolIndex));
			}
			break;
		case 1:
			if (symbolIndex < NumShortSendsWith1Arg)
			{
				return GenInstruction(ShortSendWith1Arg, static_cast<BYTE>(symbolIndex));
			}
			break;
		case 2:
			if (symbolIndex < NumShortSendsWith2Args)
			{
				return GenInstruction(ShortSendWith2Args, static_cast<BYTE>(symbolIndex));
			}
			break;
		default:
			// drop through
			break;
		}
	}
	
	int sendIP;
	// Ok, so its got to be longwinded but how long
	if (symbolIndex <= SendXMaxLiteral && argCount <= SendXMaxArgs)
	{
		// Single extended send (2 bytes) will do
		BYTE part2 = static_cast<BYTE>((argCount << SendXLiteralBits) | (symbolIndex & SendXMaxLiteral));
		BYTE code = m_sendType == SendSuper ? Supersend : Send;
		sendIP = GenInstructionExtended(code, part2);
	}
	else if (symbolIndex <= Send2XMaxLiteral && argCount <= Send2XMaxArgs)
	{
		BYTE code = m_sendType == SendSuper ? LongSupersend : LongSend;
		sendIP = GenInstructionExtended(code, static_cast<BYTE>(argCount));
		GenData(static_cast<BYTE>(symbolIndex));
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

		BYTE code = m_sendType == SendSuper ? ExLongSupersend : ExLongSend;
		sendIP = GenInstructionExtended(code, static_cast<BYTE>(argCount));
		GenData(symbolIndex & 0xFF);
		GenData(symbolIndex >> 8);
	}

	return sendIP;
}

// Basic generation of jump instruction for when target not yet known
int Compiler::GenJumpInstruction(BYTE basic)
{
	// IT MUST be one of the long jump instructions
	_ASSERTE(basic == LongJump || basic == LongJumpIfTrue || basic == LongJumpIfFalse);
	
	int pos = GenInstruction(basic);
	GenData(0);						// Long jumps have two byte extension
	GenData(0);
	m_bytecodes[pos].target = static_cast<WORD>(-1);
	// So that we know the target hasn't been set yet, we leave the jump flag turned off
	_ASSERTE(!m_bytecodes[pos].isJumpSource());
	return pos;
}

// N.B. Assumes no previously established jump target
inline void Compiler::SetJumpTarget(int pos, int target)
{
	_ASSERT(pos != target);
	_ASSERTE(target >= 0 && target < GetCodeSize());
	_ASSERTE(pos >= 0 && pos < GetCodeSize()-2);
	BYTECODE& bytecode = m_bytecodes[pos];
	_ASSERTE(bytecode.isOpCode());
	_ASSERTE(bytecode.isJumpInstruction());

	bytecode.makeJumpTo(target);
	// Mark the target location as being jumped to
	m_bytecodes[target].addJumpTo();
}

int Compiler::GenJump(BYTE basic, int location)
{
	// Generate a first pass (long) jump instruction.
	// Make no attempt to shorten the instruction or to compute the real 
	// offset. We store the ABSOLUTE jump target location
	// and this will be fixed up later along with the correct jump size.
	
	// If the jump is forwards then the location will be be three bytes further
	// because we're going to insert a 3 byte long jump instruction.
	if (location > m_codePointer)
		location += 3;
	
	int pos = GenJumpInstruction(basic);
	
	_ASSERTE(location < GetCodeSize());					// Jumping off the end of the code
	_ASSERTE(m_bytecodes[location].isOpCode());		// Attempting to jump to a data item!
	
	SetJumpTarget(pos, location);
	return pos;
}

int Compiler::GenStoreInstVar(BYTE index)
{
	m_pCurrentScope->MarkNeedsSelf();
	return GenInstructionExtended(StoreInstVar, index);
}

bool Compiler::IsPseudoVariable(const Str& name) const
{
	return name == VarSelf || name == VarSuper || name == VarThisContext;
}

int Compiler::GenStore(const Str& name, const TEXTRANGE& range, int assignmentEnd)
{
	TempVarRef* pRef = AddTempRef(name, vrtWrite, range, assignmentEnd);
	int storeIP = -1;
	if (pRef != NULL)
	{
		storeIP = GenStoreTemp(pRef);
	}
	else if (m_ok)
	{
		int index = FindNameAsInstanceVariable(name);
		if (index >= 0)
		{
			// Maximum of 255 inst vars recognised
			_ASSERTE(index < 256);
			storeIP = GenStoreInstVar(static_cast<BYTE>(index));
		}
		else 
			storeIP = GenStaticStore(name, range, assignmentEnd);
	}
	return storeIP;
}

int Compiler::GenStaticStore(const Str& name, const TEXTRANGE& range, int assignmentEnd)
{
	POTE oteStatic;
	int storeIP = 0;
	switch(FindNameAsStatic(name, oteStatic, true))
	{
	case STATICCONSTANT:
		m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
		CompileError(TEXTRANGE(range.m_start, assignmentEnd),
						CErrAssignConstant, (Oop)NewUtf8String(name));
		break;

	case STATICVARIABLE:
		{
			int index = AddToFrame(reinterpret_cast<Oop>(oteStatic), range);
			_ASSERTE(index >= 0 && index < 65536);
			storeIP = index < 255 
							? GenInstructionExtended(StoreStatic, static_cast<BYTE>(index)) 
							: GenLongInstruction(LongStoreStatic, static_cast<WORD>(index));
			m_piVM->RemoveReference(reinterpret_cast<Oop>(oteStatic));
		}
		break;

	case STATICNOTFOUND:
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
	int depth = m_pCurrentScope->GetDepth();
	_ASSERTE(depth >= 0 && depth < 256);
	int pos = GenInstructionExtended(LongStoreOuterTemp, static_cast<BYTE>(depth));
	m_bytecodes[pos].pVarRef = pRef;
	// Placeholder for index, not yet known
	GenData(0);
	GenPopStack();
}

POTE Compiler::ParseMethod()
{
	// Method is outermost scope
	_ASSERTE(m_pCurrentScope == NULL);
	_ASSERTE(m_allScopes.empty());

	PushNewScope(0);

	ParseMessagePattern();
	ParseTemporaries();
	
	if (m_ok)
	{
		if (ThisTokenIsBinary('<'))
		{
			ParsePrimitive();
		}
		ParseStatements(Eof);
	}

	if (m_ok) 
	{
		int last = PriorInstruction();

		// If the method doesn't already end in a return, return the receiver.
		if (last < 0 || m_bytecodes[last].byte != ReturnMessageStackTop)
		{
			if (last >= 0)
				GenPopStack();
			const int returnIP = GenReturn(ReturnSelf);
			// Generate text map entry with empty interval for the implicit return
			int textPos = ThisTokenRange().m_start;
			AddTextMap(returnIP, textPos, textPos-1);
		}

		if (!AtEnd())
			CompileError(TEXTRANGE(LastTokenRange().m_stop, GetTextLength()), CErrNonsenseAtMethodEnd);
	}

	PopScope(GetTextLength()-1);
	_ASSERTE(m_pCurrentScope == NULL);
	return NewMethod();
}

POTE Compiler::ParseEvalExpression(TokenType closingToken)
{
	// Parse an expression for immediate evaluation.
	// We may be called from an evaluation in a workspace window or
	// perhaps from a previous compiler evaluating a constant expression.

	PushNewScope(0);

	// In either case we are always compiling "doit"
	m_selector= (LPUTF8)"doIt";

	ParseTemporaries();
	
	if (m_ok)
	{
		ParseStatements(closingToken);

	}

	if (m_ok) 
	{
		if (GetCodeSize() == 0)
			GenPushSelf();
		// Implicit return
		const int returnIP = GenReturn(ReturnMessageStackTop);
		// Generate empty text map entry for the implicit return - debugger may need to map from release to debug method
		const int textPos = ThisTokenRange().m_start;
		AddTextMap(returnIP, textPos, textPos-1);
		
		// We don't complain about junk at the end of the method as we do
		// ParseMethod() since when called from a compiler evaluating a constant
		// expression the trailing text is valid.
	}

	PopScope(GetTextLength()-1);

	return NewMethod();
}

void Compiler::WarnIfRestrictedSelector(int start)
{
	if (!IsInteractive()) return;

	for (int i=0; i < NumRestrictedSelectors; i++)
		if (m_selector == s_restrictedSelectors[i])
		{
			Warning(TEXTRANGE(start, LastTokenRange().m_stop), CWarnRestrictedSelector);
			return;
		}
}

void Compiler::ParseMessagePattern()
{
	// Parse the message selector and arguments for this method.
	int start = ThisTokenRange().m_start;

	switch(ThisToken())
	{
	case NilConst:
	case TrueConst:
	case FalseConst:
	case NameConst:
		// Unary message pattern
		m_selector=ThisTokenText();
		NextToken();
		break;

	case NameColon:
		// Keyword message pattern
		while (m_ok && (ThisToken()==NameColon)) 
		{
			m_selector+=ThisTokenText();
			NextToken();
			ParseArgument();
		}
		break;

	case Binary:
		// Binary message pattern
		while (isAnsiBinaryChar(PeekAtChar()))
			Step();
		m_selector = ThisTokenText();
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
	if (ThisToken()==NameConst) 
	{
		// Get argument name
		AddArgument(ThisTokenText(), ThisTokenRange());
		NextToken();
	}
	else
		CompileError(CErrExpectVariable);
}

// Parse a block of temporaries between delimiters. Answer the number parsed.
int Compiler::ParseTemporaries()
{
	int nTempsAdded = 0;
	if (m_ok && ThisTokenIsBinary(TEMPSDELIMITER)) 
	{
		int start = ThisTokenRange().m_start;

		while (m_ok && NextToken()==NameConst)
		{
			AddTemporary(ThisTokenText(), ThisTokenRange(), false);
			nTempsAdded++;
		}
		if (ThisTokenIsBinary(TEMPSDELIMITER))
			NextToken();
		else
			if (m_ok)
				CompileError(TEXTRANGE(start, ThisTokenRange().m_start-1), CErrTempListNotClosed);
	}
	return nTempsAdded;
}

int Compiler::ParseStatements(TokenType closingToken, bool popResults)
{
	if (!m_ok || ThisToken() == closingToken || AtEnd())
		return 0;

	// TEMPORARY: This nop may later be used as an insertion point for copying arguments from the
	// stack into env temps. The reason for having a Nop is to avoid any jump target confusion, 
	// since when inserting an instruction the old instruction is shuffled down and the inserted
	// instruction becomes the jump target.
	GenNop();

	int count = 0;
	while (m_ok)
	{
		int statementStart = ThisTokenRange().m_start;
		ParseStatement();
		bool foundPeriod = false;
		if (ThisToken() == CloseStatement)
		{
			// Statements are to be concatenated and previous
			// result ignored (except for brace arrays)
			foundPeriod = true;
			NextToken();
		}

		count = count + 1;

		if (ThisToken() == closingToken)
			break;
		else if (AtEnd())
			break;

		if (m_ok && !foundPeriod)
			CompileError(TEXTRANGE(statementStart, LastTokenRange().m_stop), CErrUnterminatedStatement);

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
	_ASSERTE(IsInOptimizedBlock() || IsInBlock());

	if (ThisToken() == CloseSquare)
	{
		// We're compiling a block but it's empty.
		// This returns a nil
		GenInstruction(ShortPushNil);
		m_pCurrentScope->BeEmptyBlock();
	}
	else
	{
		if (AtEnd() || ThisToken() == CloseParen)
			return;

		while (m_ok)
		{
			int statementStart = ThisTokenRange().m_start;
			ParseStatement();
			bool foundClosing = false;
			if (ThisToken() == CloseStatement)
			{
				// Statements are to be concatenated and previous
				// result ignored.
				NextToken();
				foundClosing = true;
			}

			if (ThisTokenIsClosing())
			{
				// Some other closing character so we break but
				// leaving result on stack
				break;	
			}

			if (m_ok && !foundClosing)
				CompileError(TEXTRANGE(statementStart, LastTokenRange().m_stop), CErrUnterminatedStatement);
			GenPopStack();
		}
	}
}

int Compiler::GenFarReturn()
{
	_ASSERTE(IsInBlock());
	// It is easiest to set the far return mark later, when patching up the blocks. That
	// way it is based on whether a FarReturn instruction actually exists in the instruction
	// stream, rather than attemping to keep the flags in sync as the optimized blocks are 
	// inlined, etc.
	//m_pCurrentScope->MarkFarReturner();
	return GenReturn(FarReturn);
}

void Compiler::ParseStatement()
{
	if (ThisTokenIsReturn()) 
	{
		int textPosition = ThisTokenRange().m_start;
		NextToken();
		ParseExpression();
		if (m_ok)
		{
			const int returnIP = IsInBlock() ? GenFarReturn() : GenReturn(ReturnMessageStackTop);
			AddTextMap(returnIP, textPosition, LastTokenRange().m_stop);
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
	int expressionEnd = LastTokenRange().m_stop;
	int storeIP = GenStore(lvalueName, range, expressionEnd);
	AddTextMap(storeIP, range.m_start, expressionEnd);
}

void Compiler::ParseExpression()
{
	// Stack the last expression type
	SendType lastSend = m_sendType;
	m_sendType = SendOther;
	
	// We may need to know the mark of the current expression
	int exprMark = m_codePointer;
	TEXTRANGE tokenRange = ThisTokenRange();
	
	if (ThisToken() == NameConst) 
	{	
		// Possibly assignment
		Str name = ThisTokenText();
		NextToken();
		if (ThisTokenIsAssignment()) 
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

void Compiler::ParseBinaryTerm(int textPosition)
{
	LPUTF8 szTok = ThisTokenText();
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
			int nExprStart = ThisTokenRange().m_start;
			
			NextToken();
			ParseExpression();
			if (m_ok)
			{
				if (ThisToken() == CloseParen)
					NextToken();
				else					
					CompileError(TEXTRANGE(nExprStart, LastTokenRange().m_stop), CErrParenNotClosed);
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

void Compiler::ParseBraceArray(int textPosition)
{
	NextToken();

	int count = ParseStatements(CloseBrace, false);

	if (m_ok)
	{
		GenPushStaticVariable((LPUTF8)"Smalltalk.Array", TEXTRANGE(textPosition, textPosition));
		GenInteger(count, ThisTokenRange());
		GenMessage((LPUTF8)"newFromStack:", 1, textPosition);
	}

	if (ThisToken() == CloseBrace)
	{
		NextToken();
	}
	else
	{
		if (m_ok)
			CompileError(TEXTRANGE(textPosition, ThisTokenRange().m_stop), CErrBraceNotClosed);
	}
}

void Compiler::ParseTerm(int textPosition)
{
	TokenType tokenType = ThisToken();
	
	switch(tokenType)
	{
	case NameConst:
		GenPushVariable(ThisTokenText(), ThisTokenRange());
		NextToken();
		break;

	case SmallIntegerConst:
		GenInteger(ThisTokenInteger(), ThisTokenRange());
		NextToken();
		break;

	case LargeIntegerConst:
	case ScaledDecimalConst:
		{
			GenNumber(ThisTokenText(), ThisTokenRange());
            NextToken();
		}
		break;

	case FloatingConst:
		GenLiteralConstant(reinterpret_cast<Oop>(m_piVM->NewFloat(ThisTokenFloat())), ThisTokenRange());
		NextToken();
		break;

	case CharConst:
		{
			long codePoint = ThisTokenInteger();
			if (__isascii(codePoint))
			{
				// We only generate the PushChar instruction for ASCII code points
				GenInstructionExtended(PushChar, static_cast<BYTE>(codePoint));
			}
			else
			{
				GenLiteralConstant(reinterpret_cast<Oop>(m_piVM->NewCharacter(static_cast<DWORD>(codePoint))), ThisTokenRange());
			}
			NextToken();
		}
		break;

	case SymbolConst:
		GenConstant(AddToFrame(reinterpret_cast<Oop>(InternSymbol(ThisTokenText())), ThisTokenRange()));
		NextToken();
		break;

	case TrueConst:
		GenInstruction(ShortPushTrue);
		NextToken();
		break;

	case FalseConst:
		GenInstruction(ShortPushFalse);
		NextToken();
		break;

	case NilConst:
		GenInstruction(ShortPushNil);
		NextToken();
		break;

	case AnsiStringConst:
		{
			LPUTF8 szLiteral = ThisTokenText();
			POTE oteString = *szLiteral
				? NewAnsiString(szLiteral)
				: GetVMPointers().EmptyString;
            GenConstant(AddStringToFrame(oteString, ThisTokenRange()));
			NextToken();
		}
		break;

	case Utf8StringConst:
	{
		LPUTF8 szLiteral = ThisTokenText();
		POTE oteString = *szLiteral
			? NewUtf8String(szLiteral)
			: GetVMPointers().EmptyString;
		GenConstant(AddStringToFrame(oteString, ThisTokenRange()));
		NextToken();
	}
	break;

	case ExprConstBegin:
		{
			int start = ThisTokenRange().m_start;
			Oop literal=ParseConstExpression();
			if (m_ok)
			{
				GenPushConstant(literal, TEXTRANGE(start, LastTokenRange().m_stop));
			}
			m_piVM->RemoveReference(literal);
			NextToken();
		}
		break;

	case ArrayBegin:
		{
			int start = ThisTokenRange().m_start;
			POTE array=ParseArray();
			if (m_ok)
				GenLiteralConstant(reinterpret_cast<Oop>(array), TEXTRANGE(start, LastTokenRange().m_stop));
		}
		break;

	case ByteArrayBegin:
		{
			int start = ThisTokenRange().m_start;
			POTE array=ParseByteArray();
			if (m_ok)
				GenLiteralConstant(reinterpret_cast<Oop>(array), TEXTRANGE(start, LastTokenRange().m_stop));
		}
		break;

	case Binary:
		ParseBinaryTerm(textPosition);
		break;

	default:
		CompileError(CErrInvalExprStart);
		break;
	};
}

void Compiler::ParseContinuation(int exprMark, int textPosition)
{
	int continuationPointer = ParseKeyContinuation(exprMark, textPosition);
	int currentPos = m_codePointer;
	m_codePointer = continuationPointer;
	GenDup();
	_ASSERTE(lengthOfByteCode(DuplicateStackTop) == 1);
	m_codePointer = currentPos + 1;
	
	while (m_ok && ThisToken() == Cascade)
	{
		TokenType tok = NextToken();
		int continueTextPosition = ThisTokenRange().m_start;
		continuationPointer= GenInstruction(PopDup);
		switch(tok)
		{
		case NameConst:
		case Binary:
		case NameColon:
			ParseKeyContinuation(exprMark, continueTextPosition);
			break;
		default:
			CompileError(CErrExpectMessage);
			break;
		}
	}
	
	// At this point there will be one extra DuplicateStackTop
	// instruction in the code stream which can be removed.
	if (m_bytecodes[continuationPointer].byte == PopDup)
	{
		m_bytecodes[continuationPointer].byte = PopStackTop;
	}
	else
	{
		_ASSERT(m_bytecodes[continuationPointer].byte == DuplicateStackTop);
		UngenInstruction(continuationPointer);
	}
}

int Compiler::ParseKeyContinuation(int exprMark, int textPosition)
{
	int continuationPointer = ParseBinaryContinuation(exprMark, textPosition);
	if (ThisToken()!=NameColon) 
	{
		if (m_sendType == SendSuper)
			CompileError(CErrExpectMessage);
		return continuationPointer;
	}

	int argumentCount=1;
	bool specialCase=false;
	
	continuationPointer = m_codePointer;
	
	Str strPattern = ThisTokenText();
	TEXTRANGE range = ThisTokenRange();
	NextToken();
	
	// There are some special cases to deal with optimized
	// blocks for conditions and loops 
	//
	if (strPattern == (LPUTF8)"whileTrue:")
	{
		specialCase = ParseWhileLoopBlock(true, exprMark, range, textPosition);
	}
	else if (strPattern == (LPUTF8)"whileFalse:")
	{
		specialCase = ParseWhileLoopBlock(false, exprMark, range, textPosition);
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
		if (ParseTimesRepeatLoop(range))
		{
			//AddTextMap(textPosition);
			specialCase=true;
		}
	}
	
	if (!specialCase)
	{
		// For to:[by:]do: optimization. Messy...
		int toPointer = 0;
		int byPointer = 0;
		while (m_ok) 
		{
			// Otherwise just handle normally
			SendType lastSend=m_sendType;
			m_sendType=SendOther;
			
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
			
			int newExprMark = m_codePointer;
			int newTextPosition = ThisTokenRange().m_start;
			ParseTerm(newTextPosition);
			ParseBinaryContinuation(newExprMark, newTextPosition);
			m_sendType = lastSend;
			if (ThisToken() == NameColon)
			{
				strPattern += ThisTokenText();
				argumentCount++;
				NextToken();
			}
			else
				break;
		}

		if (!specialCase)
		{
			int sendIP = GenMessage(strPattern, argumentCount, textPosition);
			AddTextMap(sendIP, textPosition, LastTokenRange().m_stop);
		}
	}

	return continuationPointer;
}

void Compiler::MaybePatchNegativeNumber()
{
	if (ThisTokenIsNumber() && ThisTokenText()[0] == '-')
	{
		StepBack(strlen((LPCSTR)ThisTokenText())-1);
		SetTokenType(Binary);
		_ASSERTE(ThisTokenIsBinary('-'));
	}
}

int Compiler::ParseBinaryContinuation(int exprMark, int textPosition)
{
	int continuationPointer = ParseUnaryContinuation(exprMark, textPosition);
	MaybePatchNegativeNumber();
	while (m_ok && (ThisToken()==Binary)) 
	{
		continuationPointer = m_codePointer;
		uint8_t ch;
		while (isAnsiBinaryChar((ch = PeekAtChar())))
		{
			if (ch == '-' && isdigit(PeekAtChar(1)))
				break;
			else
				Step();
		}
		Str pattern = ThisTokenText();
		
		NextToken();
		
		SendType lastSend = m_sendType;
		m_sendType = SendOther;
		int newExprMark = m_codePointer;
		int newTextPosition = ThisTokenRange().m_start;
		ParseTerm(newTextPosition);
		ParseUnaryContinuation(newExprMark, newTextPosition);
		if (m_sendType == SendSuper)
			CompileError(CErrExpectMessage);
		m_sendType = lastSend;
		MaybePatchNegativeNumber();

		TODO("See if m_sendsToSuper can be reset inside GenMessage");
		int sendIP = GenMessage(pattern, 1, textPosition);
		AddTextMap(sendIP, textPosition, LastTokenRange().m_stop);
		m_sendType = SendOther;
	}
	return continuationPointer;
}

void Compiler::MaybePatchLiteralMessage()
{
	switch (ThisToken())
	{
	case NilConst:
	case FalseConst:
	case TrueConst:
		SetTokenType(NameConst);
		break;
	default:
		break;
	}
}

int Compiler::ParseUnaryContinuation(int exprMark, int textPosition)
{
	int continuationPointer = m_codePointer;
	MaybePatchLiteralMessage();
	while (m_ok && (ThisToken()==NameConst)) 
	{
		bool isSpecialCase=false;
		continuationPointer = m_codePointer;

		Str strToken = ThisTokenText();
		// Check for some optimizations
		if (strToken == (LPUTF8)"whileTrue")
		{
			if (ParseWhileLoop(true, exprMark))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"whileFalse")
		{
			if (ParseWhileLoop(false, exprMark))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"repeat")
		{
			if (ParseRepeatLoop(exprMark))
				isSpecialCase=true;
		}
		else if (strToken == (LPUTF8)"yourself" && !(m_flags & SendYourself))
		{
			AddSymbolToFrame(ThisTokenText(), ThisTokenRange());
			// We don't send yourself, since it is a Nop
			isSpecialCase=true;
		}
		
		if (!isSpecialCase)
		{
			int sendIP = GenMessage(ThisTokenText(), 0, textPosition);
			AddTextMap(sendIP, textPosition, ThisTokenRange().m_stop);
		}
		
		m_sendType = SendOther;
		NextToken();
		MaybePatchLiteralMessage();
	}
	return continuationPointer;
}

void Compiler::ParsePrimitive()
{
	TokenType next = NextToken();
	Str strToken = ThisTokenText();
	if (next == NameColon)
	{
		if (strToken == (LPUTF8)"primitive:")
		{
			if (NextToken() != SmallIntegerConst)
				CompileError(CErrExpectPrimIdx);
			else
			{
				m_primitiveIndex=ThisTokenInteger();
				if (m_primitiveIndex > PRIMITIVE_MAX && !(m_flags & Boot))
					CompileError(ThisTokenRange(), CErrBadPrimIdx);

				NextToken();
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
				ParseLibCall(callType->nCallType, DolphinX::LibCallPrim);
				return;
			}
		}
	}
	else
	{
		if (next == NameConst)
		{
			if (strToken == (LPUTF8)"virtual")
			{
				if (NextToken() == NameColon)
				{
					LibCallType* callType = ParseCallingConvention(ThisTokenText());
					if (callType)
					{
						ParseVirtualCall(callType->nCallType);
						return;
					}
				}
			}
			else if (strToken == (LPUTF8)"overlap")
			{
				if (NextToken() == NameColon)
				{
					LibCallType* callType = ParseCallingConvention(ThisTokenText());
					if (callType)
					{
						ParseLibCall(callType->nCallType, DolphinX::AsyncLibCallPrim);
						return;
					}
				}
			}
		}
	}
	
	CompileError(CErrBadPrimCallType);
}


Compiler::LibCallType* Compiler::ParseCallingConvention(const Str& strToken)
{
	for (int i=0; i<DolphinX::NumCallConventions; i++)
		if (strToken == callTypes[i].szCallType)
		{
			m_literalLimit = 256;		// Literal limit is reduced because only byte available in descriptor
			return &callTypes[i];
		}
		
		return 0;
}



int Compiler::ParseExtCallArgs(TypeDescriptor args[])
{
	int argcount=0;
	NextToken();
	int nArgsStart = ThisTokenRange().m_start;
	
	while (m_ok && !ThisTokenIsBinary('>') && !AtEnd())
	{
		TEXTRANGE typeRange = ThisTokenRange();
		ParseExtCallArgument(args[argcount]);
		if (m_ok)
		{
			if (args[argcount].type != DolphinX::ExtCallArgVOID)
				argcount++;
			else
				CompileError(typeRange, CErrArgTypeCannotBeVoid);
		}
	}
	
	if (m_ok)
	{
		if (argcount < GetArgumentCount())
			CompileError(TEXTRANGE(nArgsStart, LastTokenRange().m_stop), CErrInsufficientArgTypes);
		else
			if (argcount > GetArgumentCount())
				CompileError(TEXTRANGE(nArgsStart, LastTokenRange().m_stop), CErrTooManyArgTypes);
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

void Compiler::ParseVirtualCall(DolphinX::ExtCallDeclSpecs decl)
{
	// Parse a C++ virtual function call
	_ASSERTE(GetLiteralCount() == 0);
	_ASSERTE(m_literalLimit <= 256);
	
	NextToken();
	
	TypeDescriptor args[ARGLIMIT];
	TEXTRANGE retTypeRange = ThisTokenRange();
	ParseExtCallArgument(args[0]);
	if (!m_ok)
		return;

	// Temporary bodge until VM call prim can handle variant return type correctly
	if (args[0].type == DolphinX::ExtCallArgVARIANT)
	{
		args[0].type = DolphinX::ExtCallArgSTRUCT;

		// Because VARIANT is not in the base image, cannot be used as a return type
		// until ActiveX Automation Package has been loaded
		POTE structClass = GetVMPointers().ClassVARIANT;
		if (structClass == Nil())
		{
			CompileError(retTypeRange, CErrUndefinedClass);
			return;
		}

		args[0].parm = Oop(structClass);
	}
	
	m_primitiveIndex=DolphinX::VirtualCallPrim;
	m_compiledMethodClass=GetVMPointers().ClassExternalMethod;
	
	int argcount;
	long vfnIndex;
	
	if (ThisToken() != SmallIntegerConst)
		CompileError(CErrExpectVfn);
	else
	{
		// Virtual function number
		vfnIndex = ThisTokenInteger();
		if (vfnIndex < 1 || vfnIndex > 1024)
			CompileError(CErrBadVfn);
		
		// Implicit arg for this pointer (the receiver)
		args[1].type = DolphinX::ExtCallArgLPVOID;
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
		if (retType.type == DolphinX::ExtCallArgSTRUCT)
		{
			// We can save the interpreter work by compiling down this info now, thereby allowing
			// for improved run-time performance
			unsigned byteSize = ((STBehavior*)GetObj(POTE(retType.parm)))->instSpec.extraSpec;
			
			if (byteSize != 0)
			{
				if (byteSize <= 4)
					retType.type = DolphinX::ExtCallArgSTRUCT4;
				else if (byteSize <= 8)
					retType.type = DolphinX::ExtCallArgSTRUCT8;
			}
		}
	}
	
	if (m_ok && retType.parm)
	{
		retType.parm = AddToFrameUnconditional(retType.parm, range);
		_ASSERTE(retType.parm==1);
	}
}

DolphinX::ExternalMethodDescriptor& Compiler::buildDescriptorLiteral(TypeDescriptor types[], int argcount, DolphinX::ExtCallDeclSpecs decl, LPUTF8 szProcName)
{
	_ASSERTE(szProcName);
	_ASSERTE(argcount >= 0 && argcount < 256);
	int argsLen=argcount;
	{
		for (int i=1;i<=argcount;i++)
		{
			if (types[i].parm)
				argsLen++;
		}
	}
	
	unsigned procNameSize = strlen((LPCSTR)szProcName)+1;
	unsigned size = sizeof(DolphinX::ExternalMethodDescriptor) + argsLen + procNameSize;
	int index=AddToFrameUnconditional(Oop(m_piVM->NewByteArray(size)), LastTokenRange());
	
	// This must be the first literal in the frame!
	_ASSERTE(index==0);
	
	POTE argArray=(POTE)m_literalFrame[index];
	BYTE* pb = FetchBytesOf(argArray);
	DolphinX::ExternalMethodDescriptor& argsEtc = *(DolphinX::ExternalMethodDescriptor*)pb;
	//memset(&argsEtc, 0xFF, size);
	
	argsEtc.m_descriptor.m_callConv = decl;
	mangleDescriptorReturnType(types[0], types[0].range);
	argsEtc.m_descriptor.m_return = types[0].type;
	argsEtc.m_descriptor.m_returnParm = types[0].parm;
	
	
	// At the moment we build the descriptor in argument order, but the literal
	// indices preceed the types because the call primitive reads the literal
	// in reverse order (because the arguments must be pushed onto the stack in
	// the reverse order that they are on the Smalltalk stack - i.e. pop from
	// Smalltalk, push onto machine stack)
	argsLen=0;
	for (int i=1; m_ok && i<=argcount; i++)
	{
		// Any types with a literal argument are added to frame (only ExtCallArgSTRUCT at present)
		if (types[i].parm)
		{
			int frameIndex = AddToFrame(types[i].parm, types[i].range);
			_ASSERTE(frameIndex < 256);
			argsEtc.m_descriptor.m_args[argsLen++] = frameIndex;
		}
		argsEtc.m_descriptor.m_args[argsLen++] = types[i].type;
	}
	_ASSERTE(argsLen < 256 && argsLen >= argcount);
	argsEtc.m_descriptor.m_argsLen = argsLen;
	
	// Shove the procName (store ordinal as string too) on the end
	strcpy_s((char*)argsEtc.m_descriptor.m_args+argsLen, procNameSize, (LPCSTR)szProcName);
	return argsEtc;
}

void Compiler::ParseLibCall(DolphinX::ExtCallDeclSpecs decl, int callPrim)
{
	if (decl > DolphinX::ExtCallCDecl)
	{
		CompileError(CErrUnsupportedCallConv);
		return;
	}
	
	_ASSERTE(decl == DolphinX::ExtCallStdCall || decl == DolphinX::ExtCallCDecl);
	
	// Parse an external library call
	_ASSERTE(GetLiteralCount()==0);
	NextToken();
	
	TypeDescriptor args[ARGLIMIT];
	TEXTRANGE retTypeRange = ThisTokenRange();
	ParseExtCallArgument(args[0]);
	if (!m_ok)
		return;

	// Temporary bodge until VM call prim can handle variant return type correctly
	if (args[0].type == DolphinX::ExtCallArgVARIANT)
	{
		args[0].type = DolphinX::ExtCallArgSTRUCT;

		// Because VARIANT is not in the base image, cannot be used as a return type
		// until ActiveX Automation Package has been loaded
		POTE structClass = GetVMPointers().ClassVARIANT;
		if (structClass == Nil())
		{
			CompileError(retTypeRange, CErrUndefinedClass);
			return;
		}

		args[0].parm = Oop(structClass);
	}
	
	// Function name or ordinal
	m_primitiveIndex=callPrim;
	m_compiledMethodClass=GetVMPointers().ClassExternalMethod;
	
	int argcount;
	
	TokenType tok = ThisToken();
	// Function names must be ASCII, or an ordinal
	if (tok != AnsiStringConst && tok != NameConst && tok != SmallIntegerConst)
		CompileError(CErrExpectFnName);
	else
	{
		Str procName = ThisTokenText();
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
		CompileError(range, CErrUndefinedClass);
		return NULL;
	}

	if (!m_piVM->IsAClass(structClass))
	{
		CompileError(range, CErrInvalidStructArg);
		return NULL;
	}

	STBehavior& behavior = *(STBehavior*)GetObj(structClass);
	if (behavior.instSpec.pointers && behavior.instSpec.fixedFields < 1)
	{
		CompileError(range, CErrInvalidStructArg);
		return NULL;
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
			descriptor.range.m_stop = ThisTokenRange().m_stop;
			NextToken();
			if (ThisTokenIsBinary('*'))
			{
				descriptor.range.m_stop = ThisTokenRange().m_stop;
				NextToken();
				if (behavior.instSpec.indirect)
					// One level of indirection implied, cannot have 3
					CompileError(descriptor.range, CErrNotIndirectable, (Oop)NewUtf8String(strClass));
				else
				{
					// Double indirections always use LPPVOID type
					descriptor.type = DolphinX::ExtCallArgLPPVOID;
					descriptor.parm = 0;
				}
			}
			else
			{
				if (behavior.instSpec.indirect)
				{
					// One level of indirection already implied, totalling two
					descriptor.type = DolphinX::ExtCallArgLPPVOID;
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
				descriptor.type = DolphinX::ExtCallArgLP;
			else
				descriptor.type = DolphinX::ExtCallArgSTRUCT;
			descriptor.parm = Oop(structClass);
		}
	}
}

DolphinX::ExtCallArgTypes Compiler::TypeForStructPointer(POTE oteStructClass)
{
	const VMPointers& pointers = GetVMPointers();
	POTE oteUnkClass = pointers.ClassIUnknown;
	return (oteUnkClass != pointers.Nil && m_piVM->InheritsFrom(oteStructClass, oteUnkClass))
		? DolphinX::ExtCallArgCOMPTR
		: DolphinX::ExtCallArgLP;
}

// Answers true if an argument type was parsed, else false. Advances over argument if parsed.
void Compiler::ParseExtCallArgument(TypeDescriptor& answer)
{
	switch(ThisToken())
	{
	case NameConst:
		{
			// Table of arg types
			// N.B. THIS SHOULD MATCH THE DolphinX::ExtCallArgTypes ENUM...
			struct ArgTypeDefn 
			{
				LPUTF8						m_szName;
				DolphinX::ExtCallArgTypes	m_type;
				LPUTF8						m_szIndirectClass;
			};
			
			static ArgTypeDefn argTypes[] =	{
				{ (LPUTF8)"sdword", DolphinX::ExtCallArgSDWORD, (LPUTF8)"SDWORD" },
				{ (LPUTF8)"dword", DolphinX::ExtCallArgDWORD, (LPUTF8)"DWORD" },
				{ (LPUTF8)"intptr", DolphinX::ExtCallArgINTPTR, (LPUTF8)"INT_PTR" },
				{ (LPUTF8)"uintptr", DolphinX::ExtCallArgUINTPTR, (LPUTF8)"UINT_PTR" },
				{ (LPUTF8)"lpvoid", DolphinX::ExtCallArgLPVOID, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"handle", DolphinX::ExtCallArgHANDLE, (LPUTF8)"DWORD" },
				{ (LPUTF8)"lppvoid", DolphinX::ExtCallArgLPPVOID, NULL },
				{ (LPUTF8)"lpstr", DolphinX::ExtCallArgLPSTR, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"bool", DolphinX::ExtCallArgBOOL, (LPUTF8)"DWORD" },
				{ (LPUTF8)"void", DolphinX::ExtCallArgVOID, (LPUTF8)DolphinX::ExtCallArgLPVOID},
				{ (LPUTF8)"double", DolphinX::ExtCallArgDOUBLE, (LPUTF8)"DOUBLE" },
				{ (LPUTF8)"float", DolphinX::ExtCallArgFLOAT, (LPUTF8)"FLOAT" },
				{ (LPUTF8)"hresult", DolphinX::ExtCallArgHRESULT, (LPUTF8)"HRESULT" },
				{ (LPUTF8)"char", DolphinX::ExtCallArgCHAR, (LPUTF8)DolphinX::ExtCallArgLPSTR},
				{ (LPUTF8)"byte", DolphinX::ExtCallArgBYTE, (LPUTF8)DolphinX::ExtCallArgLPVOID},
				{ (LPUTF8)"sbyte", DolphinX::ExtCallArgSBYTE, (LPUTF8)DolphinX::ExtCallArgLPVOID},
				{ (LPUTF8)"word", DolphinX::ExtCallArgWORD, (LPUTF8)"WORD" },
				{ (LPUTF8)"sword", DolphinX::ExtCallArgSWORD, (LPUTF8)"SWORD" },
				{ (LPUTF8)"oop", DolphinX::ExtCallArgOOP, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"lpwstr", DolphinX::ExtCallArgLPWSTR, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"bstr", DolphinX::ExtCallArgBSTR, (LPUTF8)DolphinX::ExtCallArgLPPVOID },
				{ (LPUTF8)"qword", DolphinX::ExtCallArgQWORD, (LPUTF8)"ULARGE_INTEGER" },
				{ (LPUTF8)"sqword", DolphinX::ExtCallArgSQWORD, (LPUTF8)"LARGE_INTEGER" },
				{ (LPUTF8)"ote", DolphinX::ExtCallArgOTE, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"variant", DolphinX::ExtCallArgVARIANT, (LPUTF8)"VARIANT" },
				{ (LPUTF8)"varbool", DolphinX::ExtCallArgVARBOOL, (LPUTF8)"VARIANT_BOOL" },
				{ (LPUTF8)"guid", DolphinX::ExtCallArgGUID, (LPUTF8)"REFGUID" },
				{ (LPUTF8)"date", DolphinX::ExtCallArgDATE, (LPUTF8)"DATE" },
				//(LPUTF8) Convert a few class types to the special types to save space and time
				{ (LPUTF8)"ExternalAddress", DolphinX::ExtCallArgLPVOID, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"ExternalHandle", DolphinX::ExtCallArgHANDLE, (LPUTF8)"DWORD" },
				{ (LPUTF8)"BSTR", DolphinX::ExtCallArgBSTR, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"VARIANT", DolphinX::ExtCallArgVARIANT, (LPUTF8)"VARIANT" },
				{ (LPUTF8)"SDWORD", DolphinX::ExtCallArgSDWORD, (LPUTF8)"SDWORD" },
				{ (LPUTF8)"DWORD", DolphinX::ExtCallArgDWORD, (LPUTF8)"DWORD" },
				{ (LPUTF8)"LPVOID", DolphinX::ExtCallArgLPVOID, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"DOUBLE", DolphinX::ExtCallArgDOUBLE, (LPUTF8)"DOUBLE" },
				{ (LPUTF8)"FLOAT", DolphinX::ExtCallArgFLOAT, (LPUTF8)"FLOAT" },
				{ (LPUTF8)"HRESULT", DolphinX::ExtCallArgHRESULT, (LPUTF8)"HRESULT" },
				{ (LPUTF8)"BYTE", DolphinX::ExtCallArgBYTE, (LPUTF8)DolphinX::ExtCallArgLPVOID},
				{ (LPUTF8)"SBYTE", DolphinX::ExtCallArgSBYTE, (LPUTF8)DolphinX::ExtCallArgLPVOID},
				{ (LPUTF8)"WORD", DolphinX::ExtCallArgWORD, (LPUTF8)"WORD" },
				{ (LPUTF8)"SWORD", DolphinX::ExtCallArgSWORD, (LPUTF8)"SWORD" },
				{ (LPUTF8)"LPWSTR", DolphinX::ExtCallArgLPWSTR, (LPUTF8)DolphinX::ExtCallArgLPPVOID},
				{ (LPUTF8)"QWORD", DolphinX::ExtCallArgQWORD, (LPUTF8)"ULARGE_INTEGER" },
				{ (LPUTF8)"ULARGE_INTEGER", DolphinX::ExtCallArgQWORD, (LPUTF8)"ULARGE_INTEGER" },
				{ (LPUTF8)"SQWORD", DolphinX::ExtCallArgSQWORD, (LPUTF8)"LARGE_INTEGER" },
				{ (LPUTF8)"LARGE_INTEGER", DolphinX::ExtCallArgSQWORD, (LPUTF8)"LARGE_INTEGER" },
				{ (LPUTF8)"GUID", DolphinX::ExtCallArgGUID, (LPUTF8)"REFGUID" },
				{ (LPUTF8)"IID", DolphinX::ExtCallArgGUID, (LPUTF8)"REFGUID" },
				{ (LPUTF8)"CLSID", DolphinX::ExtCallArgGUID, (LPUTF8)"REFGUID" },
				{ (LPUTF8)"VARIANT_BOOL", DolphinX::ExtCallArgVARBOOL, (LPUTF8)"VARIANT_BOOL" }
			};

			answer.range = ThisTokenRange();
			Str strToken = ThisTokenText();
			NextToken();

			// Scan the table
			for (int i=0; i < sizeof(argTypes)/sizeof(ArgTypeDefn);i++)
			{
				if (strToken == argTypes[i].m_szName)
				{
					answer.type = argTypes[i].m_type;
					answer.parm = 0;

					if (ThisToken() == Binary && !ThisTokenIsBinary('>'))
					{
						// At least a single indirection to a standard type
						uint8_t ch;
						while ((ch = PeekAtChar()) != '>' && isAnsiBinaryChar(ch))
							Step();

						Str strModifier = ThisTokenText();
						int indirections = strModifier == (LPUTF8)"**" ? 2 : strModifier == (LPUTF8)"*" ? 1 : 0;
						if (indirections == 0)
						{
							CompileError(TEXTRANGE(ThisTokenRange().m_start, CharPosition()), CErrBadExtTypeQualifier);
						}
						answer.range.m_stop = ThisTokenRange().m_stop;
						NextToken();
						LPUTF8 szClass = argTypes[i].m_szIndirectClass;
						// Indirection to a built-in type?
						if (szClass <= LPUTF8(DolphinX::ExtCallArgSTRUCT))
						{
							if (!szClass || (indirections > 1 && szClass == LPUTF8(DolphinX::ExtCallArgLPPVOID)))
								// Cannot indirect this type
								CompileError(TEXTRANGE(answer.range.m_start, LastTokenRange().m_stop), CErrNotIndirectable, (Oop)NewUtf8String(strToken));

							if (indirections > 1)
								answer.type = DolphinX::ExtCallArgLPPVOID;
							else
								answer.type = DolphinX::ExtCallArgTypes(int(szClass));
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
									answer.type = DolphinX::ExtCallArgLPPVOID;
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

void Compiler::ParseBlock(int textPosition)
{
	PushNewScope(textPosition);

	NextToken();

	// This Nop is needed in case the block is a jump target, as this then
	// allows us to insert the push instructions for any copied values
	GenNop();
	
	// Parse the block arguments
	int nArgs = ParseBlockArguments(textPosition);
	
	int stop = -1;
	if (m_ok)
	{
		// Block copy instruction has an implicit jump
		int blockCopyMark = GenInstruction(BlockCopy);
		m_bytecodes[blockCopyMark].pScope = m_pCurrentScope;
		// Block copy has 6 extension bytes, most filled in later
		GenData(nArgs);
		GenData(0);
		GenData(0);
		GenData(0);
		GenData(0);	
		GenData(0);
		
		ParseTemporaries();
		
		// Generate the block's body
		ParseBlockStatements();
		int endOfBlockPos = GenReturn(ReturnBlockStackTop);
		m_bytecodes[endOfBlockPos].pScope = m_pCurrentScope;
		// Generate text map entry for the Return
		AddTextMap(endOfBlockPos, textPosition, ThisTokenRange().m_stop);
		
		// Fill in the target of the block copy's implicit jump (which will be the following Nop)
		const int endOfBlockNopPos = GenNop();
		m_bytecodes[endOfBlockNopPos].addJumpTo();
		m_bytecodes[blockCopyMark].makeJumpTo(endOfBlockNopPos);

		if (ThisToken() == CloseSquare)
		{
			stop = ThisTokenRange().m_stop;
			NextToken();
		}
		else
		{
			stop = LastTokenRange().m_stop;
			if (m_ok)
				CompileError(TEXTRANGE(textPosition, stop), CErrBlockNotClosed);
		}
	}

	PopScope(stop < 0 ? LastTokenRange().m_stop : stop);
}

int Compiler::ParseBlockArguments(const int blockStart)
{
	int argcount=0;
	while (m_ok && ThisTokenIsSpecial(':'))
	{
		if (NextToken()==NameConst)
		{
			// Get temporary name
			AddArgument(ThisTokenText(), ThisTokenRange());
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
			CompileError(TEXTRANGE(blockStart, LastTokenRange().m_stop), CErrBlockArgListNotClosed);
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

	int arrayStart = ThisTokenRange().m_start;

	NextToken();
	while (m_ok && !ThisTokenIsClosing())
	{
		switch(ThisToken()) 
		{
		case SmallIntegerConst:
			{
				Oop oopElement = m_piVM->NewSignedInteger(ThisTokenInteger());
				elems.push_back(oopElement);
				m_piVM->AddReference(oopElement);
				m_piVM->MakeImmutable(oopElement, TRUE);
				NextToken();
			}
			break;

		case LargeIntegerConst:
		case ScaledDecimalConst:
			{
				// Result of NewNumber already has ref. count
				Oop oopElem = NewNumber(ThisTokenText());
				m_piVM->MakeImmutable(oopElem, TRUE);
				elems.push_back(oopElem);
				NextToken();
			}
			break;

		case FloatingConst:
			{
				Oop oopFloat = reinterpret_cast<Oop>(m_piVM->NewFloat(ThisTokenFloat()));
				elems.push_back(oopFloat);
				m_piVM->AddReference(oopFloat);
				m_piVM->MakeImmutable(oopFloat, TRUE);
				NextToken();
			}
			break;
			
		case NilConst:
				elems.push_back(reinterpret_cast<Oop>(Nil()));
				NextToken();
				break;

		case TrueConst:
				elems.push_back(reinterpret_cast<Oop>(GetVMPointers().True));
				NextToken();
				break;

		case FalseConst:
				elems.push_back(reinterpret_cast<Oop>(GetVMPointers().False));
				NextToken();
				break;

		case NameConst:
			{
				POTE oteElement = InternSymbol(ThisTokenText());
				Oop oopElement = reinterpret_cast<Oop>(oteElement);
				elems.push_back(oopElement);
				m_piVM->AddReference(oopElement);
				NextToken();
			}
			break;
			
		case SymbolConst:
		case NameColon:
			{
				Str name = ThisTokenText();
				while (isIdentifierFirst(PeekAtChar()))
				{
					NextToken();
					name += ThisTokenText();
				}
				Oop oopSymbol = reinterpret_cast<Oop>(InternSymbol(name));
				elems.push_back(oopSymbol);
				m_piVM->AddReference(oopSymbol);
				NextToken();
			}
			break;
			
		case ArrayBegin:
		case Binary:
			{
				if (ThisToken()==ArrayBegin || ThisTokenIsBinary('(')) 
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
					uint8_t ch = PeekAtChar();
					// Look for negation, but first see if in fact
					// we have a binary selector
					if (isAnsiBinaryChar(ch))
					{
						do
						{
							Step();
						}
						while (isAnsiBinaryChar(PeekAtChar()));
						oopElement = reinterpret_cast<Oop>(InternSymbol(ThisTokenText()));
						NextToken();
					}
					else if (isdigit(ch))
					{
						NextToken();
						TokenType tokenType = ThisToken();
						if (tokenType == SmallIntegerConst)
						{
							oopElement = m_piVM->NewSignedInteger(-ThisTokenInteger());
							NextToken();
						}
						else if (tokenType == LargeIntegerConst || tokenType == ScaledDecimalConst) 
						{
							Str valuetext = (LPUTF8)"-";
							valuetext += ThisTokenText();
							oopElement = NewNumber(valuetext.c_str());
							// Return value has an elevated ref. count which we assume here
							elems.push_back(oopElement);
							NextToken();
							break;
						}
						else if (tokenType == FloatingConst) 
						{
							oopElement = reinterpret_cast<Oop>(m_piVM->NewFloat(-ThisTokenFloat()));
							NextToken();
						}
					}
					else
					{
						oopElement = reinterpret_cast<Oop>(InternSymbol(ThisTokenText()));
						NextToken();
					}
					
					elems.push_back(oopElement);
					m_piVM->AddReference(oopElement);
					break;
				}
				
				while (isAnsiBinaryChar(PeekAtChar()))
					Step();
				Oop oopSymbol = reinterpret_cast<Oop>(InternSymbol(ThisTokenText()));
				elems.push_back(oopSymbol);
				m_piVM->AddReference(oopSymbol);
				NextToken();
				break;
			}
			
		case CharConst:
			{
				Oop oopChar = reinterpret_cast<Oop>(m_piVM->NewCharacter(static_cast<DWORD>(ThisTokenInteger())));
				m_piVM->AddReference(oopChar);
				elems.push_back(oopChar);
				NextToken();
			}
			break;
			
		case AnsiStringConst:
			{
				LPUTF8 szLiteral = ThisTokenText();
				POTE oteString = *szLiteral
					? NewAnsiString(szLiteral)
					: GetVMPointers().EmptyString;
				Oop oopString = reinterpret_cast<Oop>(oteString);
				elems.push_back(oopString);
				m_piVM->AddReference(oopString);
				m_piVM->MakeImmutable(oopString, TRUE);
				NextToken();
			}
			break;

		case Utf8StringConst:
			{
				LPUTF8 szLiteral = ThisTokenText();
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

		case ExprConstBegin:
			{
				Oop oopConst = ParseConstExpression();
				elems.push_back(oopConst);
				// Return from ParseConstExpression() already has elevated ref. count
				// Don't think its right to make an arbitrary object immutable here - only literals should be immutable
				//m_piVM->MakeImmutable(oopConst, TRUE);
				NextToken();
			}
			break;
			
		case ByteArrayBegin:
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

		default:
			CompileError(CErrBadTokenInArray);
			NextToken();
			break;
		}
	}
	
	if (m_ok)
	{
		if (ThisToken() == CloseParen)
		{
			POTE arrayPointer;

			if (elems.empty())
			{
				arrayPointer = GetVMPointers().EmptyArray;
			}
			else
			{
				// Gather new literals into a new array
				const int elemcount = elems.size();
				arrayPointer = m_piVM->NewArray(elemcount);
				STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
				for (int i=0; i < elemcount; i++)
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
			CompileError(TEXTRANGE(arrayStart, LastTokenRange().m_stop), CErrArrayNotClosed);
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
	int maxelemcount=128; // A convenient start size though we can expand beyond this if necessary
	BYTE* elems=static_cast<BYTE*>(malloc(maxelemcount*sizeof(BYTE)));
	int elemcount=0;

	int start = ThisTokenRange().m_start;

	NextToken();
	while (m_ok && !ThisTokenIsClosing())
	{
		if (elemcount>=maxelemcount)
		{
			_ASSERTE(maxelemcount > 0);
			maxelemcount *= 2;
			elems = (BYTE*)realloc(elems, maxelemcount*sizeof(BYTE));
		}
		
		switch(ThisToken()) 
		{
		case SmallIntegerConst:
			{
				long intVal = ThisTokenInteger();
				if (intVal < 0 || intVal > 255)
				{
					CompileError(CErrBadValueInByteArray);
					NextToken();
					break;
				}
				elems[elemcount++] = static_cast<BYTE>(intVal);
				NextToken();
			}
			break;
			
		case LargeIntegerConst:
			{
				Oop li = NewNumber(ThisTokenText());
				if (IsIntegerObject(li))
				{
					int nVal = IntegerValueOf(li);
					if (nVal < 0 || nVal > 255)
						CompileError(CErrBadValueInByteArray);
					else
						elems[elemcount++] = static_cast<BYTE>(ThisTokenInteger());
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
		if (ThisToken() == CloseSquare)
		{
			arrayPointer=m_piVM->NewByteArray(elemcount);
			BYTE* pb = FetchBytesOf(arrayPointer);
			memcpy(pb, elems, elemcount);
			NextToken();
		}
		else
			CompileError(TEXTRANGE(start, LastTokenRange().m_stop), CErrByteArrayNotClosed);
	}
	free(elems);
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
	unsigned len;
	__try
	{
		_ASSERTE(m_compilerObject && m_notifier);
		DWORD flags = m_flags & ~DebugMethod;

		POTE oteSelf = m_piVM->IsAMetaclass(m_class) ? reinterpret_cast<STMetaclass*>(GetObj(m_class))->instanceClass: m_class;
		Oop contextOop = Oop(oteSelf);
		TEXTRANGE tokRange = ThisTokenRange();
		POTE oteMethod = pCompiler->CompileExpression(GetText(), m_compilerObject, m_notifier, contextOop, FLAGS(flags), len, tokRange.m_stop+1);
		if (pCompiler->m_ok && pCompiler->ThisToken() != CloseParen)
		{
			CompileError(TEXTRANGE(tokRange.m_start, tokRange.m_stop+len), CErrStaticExprNotClosed);
		}

		if (pCompiler->m_ok && oteMethod != Nil())
		{
			STCompiledMethod& exprMethod = *(STCompiledMethod*)GetObj(oteMethod);

			// Add all the literals in the expression to the literal frame of this method as this
			// allows normal references search to work in IDE
			const int loopEnd = pCompiler->GetLiteralCount();
			for (int i=0; i < loopEnd;i++)
			{
				Oop oopLiteral = exprMethod.aLiterals[i];
				_ASSERTE(oopLiteral);
				if (!IsIntegerObject(oopLiteral) &&
						(m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassSymbol) ||
							m_piVM->IsAClass((POTE)oopLiteral) ||
							m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassVariableBinding) ||
							m_piVM->IsKindOf(oopLiteral, GetVMPointers().ClassArray)))

				{
					AddToFrame(oopLiteral, LastTokenRange());
				}
			}

			// Note that when we evaluate the expression the expression method will be automatically
			// destroyed as currently its reference count is zero. The method is passed into the 
			// image for evaluation, and is pushed onto the stack increasing its count to 1. On 
			// return when it is popped off the stack its count will drop to zero and it will be
			// reclaimed.
			
			result = this->EvaluateExpression(GetText(), tokRange.m_stop+1, tokRange.m_stop + len - 1, oteMethod, contextOop, Nil());
		}
		else
			result= Oop(Nil());
	}
	__finally
	{
		m_ok = pCompiler->Ok();
		pCompiler->Release();
	}
	
	// Update source pointer
	AdvanceCharPtr(len);
	return result;
}

Oop Compiler::EvaluateExpression(LPUTF8 source, int start, int end, POTE oteMethod, Oop contextOop, POTE pools)
{
	Str exprSource(source, start, end - start + 1);
	return EvaluateExpression(exprSource.c_str(), oteMethod, contextOop, pools);
}



void Compiler::GetInstVars()
{
	_ASSERTE(!m_instVarsInitialized);

	if (m_class != GetVMPointers().ClassUndefinedObject)
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
		const int len=FetchWordLengthOf(arrayPointer);
		// Too many inst vars?
		if (len > 255)
			CompileError(CompileTextRange(), CErrBadContext);
		// We know how many inst vars there are in advance of compilation, and this
		// array does not, therefore, need to be dynamic
		m_instVars.resize(len);
		for (int i=0; i<len; i++)
		{
			// Copy the names from the Array into our m_instVars array.
			POTE ote = (POTE)array.fields[i];
			BYTE *pb = FetchBytesOf(ote);
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
				const MWORD len=FetchWordLengthOf(m_oopWorkspacePools);
				if (len == 0)
					m_oopWorkspacePools = Nil();
				else
					for (MWORD i=0;i<len;i++)
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

void Compiler::AssertValidIpForTextMapEntry(int ip, bool bFinal)
{
	if (ip == -1) return;
	_ASSERTE(ip >= 0 && ip < GetCodeSize());
	const BYTECODE& bc = m_bytecodes[ip];
	if (bc.isData())
	{
		_ASSERTE(ip > 0);
		const BYTECODE& prev = m_bytecodes[ip-1];
		_ASSERTE(prev.isOpCode());
		_ASSERTE((bc.byte == PopStoreTemp && (prev.byte == IncrementTemp || prev.byte == DecrementTemp))
			|| (bc.byte == StoreTemp && (prev.byte == IncrementPushTemp || prev.byte == DecrementPushTemp)));
	}
	else
	{
		_ASSERTE(bc.byte == Nop || bc.pScope != NULL);

		// Must be a message send, store (assignment), return, push of the empty block,
		// or the first instruction in a block
		int prevIP = ip - 1;
		while (prevIP >= 0 && (m_bytecodes[prevIP].isData() || m_bytecodes[prevIP].byte == Nop))
			prevIP--;
		const BYTECODE* prev = prevIP < 0 ? NULL : &m_bytecodes[prevIP];
		bool isFirstInBlock = prev != NULL && (prev->byte == BlockCopy 
								|| (bc.pScope == NULL 
										? bc.byte == Nop && prev != NULL && prev->isUnconditionalJump()
										: bc.pScope->GetRealScope()->IsBlock() 
											&& (bc.pScope->GetRealScope()->GetInitialIP() == ip
											|| bc.pScope != prev->pScope 
											|| bc.pScope->GetRealScope() != prev->pScope->GetRealScope())));
		if (bFinal && WantDebugMethod())
		{
			// If not at the start of a method or block, then a text map entry should only occur after a Break
			// or (when stripping unreachable code) if the byte immediately follows an unconditional return/jump
			_ASSERTE(ip == 0 
				|| isFirstInBlock 
				|| bc.isConditionalJump()
				|| (bc.isShortPushConst() && IsBlock(m_literalFrame[bc.indexOfShortPushConst()]))
				|| (bc.byte == PushConst && IsBlock(m_literalFrame[m_bytecodes[ip + 1].byte]))
				|| (prev->isBreak() || (!bc.isJumpTarget() && (prev->isReturn() || prev->isLongJump()))));
		}

		_ASSERTE(bc.isSend()
			|| bc.isConditionalJump()
			|| bc.isStore()
			|| bc.isReturn()
			|| (bc.isShortPushConst() && IsBlock(m_literalFrame[bc.indexOfShortPushConst()]))
			|| (bc.byte == PushConst && IsBlock(m_literalFrame[m_bytecodes[ip+1].byte]))
			|| (isFirstInBlock)
			|| (bc.isConditionalJump())
			|| (bc.byte == IncrementTemp || bc.byte == DecrementTemp)
			|| (bc.byte == IncrementStackTop || bc.byte == DecrementStackTop)
			|| (bc.byte == IncrementPushTemp|| bc.byte == DecrementPushTemp)
			|| (bc.byte == IsZero)
			);
	}
}

void Compiler::VerifyTextMap(bool bFinal)
{
	//_CrtCheckMemory();
	const int size = m_textMaps.size();
	for (int i=0; i<size; i++)
	{
		const TEXTMAP& textMap = m_textMaps[i];
		int ip = textMap.ip;
		AssertValidIpForTextMapEntry(ip, bFinal);
	}
}

void Compiler::VerifyJumps()
{
	const int size = GetCodeSize();
	for (int i = 0; i<size; i++)
	{
		const BYTECODE& bc = m_bytecodes[i];
		if (bc.isJumpSource())
		{
			_ASSERTE(bc.isJumpInstruction());
			_ASSERTE(bc.target >= 0 && bc.target < size);
			const BYTECODE& target = m_bytecodes[bc.target];
			_ASSERTE(!target.isData());
			_ASSERTE(target.jumpsTo > 0);
		}
	}
}
#endif

POTE Compiler::GetTextMapObject()
{
	const int size = m_textMaps.size();
	POTE arrayPointer=m_piVM->NewArray(size*3);
	STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
	int arrayIndex = 0;
	for (int i=0; i<size; i++)
	{
		const TEXTMAP& textMap = m_textMaps[i];
		int ip = textMap.ip;
		array.fields[arrayIndex++] = IntegerObjectOf(ip + 1);
		array.fields[arrayIndex++] = IntegerObjectOf(textMap.start + 1);
		array.fields[arrayIndex++] = IntegerObjectOf(textMap.stop + 1);
	}
	return arrayPointer;
}

inline void Compiler::BreakPoint()
{
	if (WantDebugMethod())
		GenInstruction(Break);
}


int Compiler::AddTextMap(int ip, const TEXTRANGE& range)
{
	return AddTextMap(ip, range.m_start, range.m_stop);
}

// Add a new TEXTMAP encoding the current char position and code position
// These need to be added in IP order.
int Compiler::AddTextMap(int ip, int textStart, int textStop)
{
	if (!m_ok) return -1;
	_ASSERTE(ip < GetCodeSize());
	// textStart can be equal to text length in order to specify an empty interval at the end of the method
	_ASSERTE(textStart >= 0 && textStart <= GetTextLength());
	_ASSERTE(textStop >= -1 && textStop < GetTextLength());
	if (!WantTextMap()) return -1;
	_ASSERTE(m_bytecodes[ip].isOpCode());
	_ASSERTE(m_bytecodes[ip].byte != Nop);
	m_textMaps.push_back(TEXTMAP(ip, textStart, textStop));
	VerifyTextMap();
	return m_textMaps.size() - 1;
}

void Compiler::InsertTextMapEntry(int ip, int textStart, int textStop)
{
	if (!WantTextMap()) return;

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

Compiler::TEXTMAPLIST::iterator Compiler::FindTextMapEntry(int ip)
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

bool Compiler::RemoveTextMapEntry(int ip)
{
	if (!WantTextMap()) return true;

	TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
	{
		const TEXTMAP& tm = (*it);
		const BYTECODE& bc = m_bytecodes[ip];
		int i = it - m_textMaps.begin();

		m_textMaps.erase(it);
		return true;
	}
	else
		return false;
}

bool Compiler::VoidTextMapEntry(int ip)
{
	if (!WantTextMap()) return true;

	TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
	{
		TEXTMAP& tm = (*it);
		tm.ip = -1;
		return true;
	}
	else
		return false;
}
///////////////////////////////////

POTE Compiler::GetTempsMapObject()
{
	int nScopes = m_allScopes.size();
	POTE arrayPointer=m_piVM->NewArray(nScopes);
	STVarObject& array = *(STVarObject*)GetObj(arrayPointer);
	int arrayIndex = 0;
	const int loopEnd = nScopes;
	for (int i=0; i<loopEnd; i++)
	{
		LexicalScope* pScope = m_allScopes[i];
		m_piVM->StorePointerWithValue(array.fields+i, Oop(pScope->BuildTempMapEntry(m_piVM)));
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
	if (!m_piVM->IsBehavior(Oop(aClass)) || szSource == NULL)
		return Nil();

	POTE resultPointer = Nil();
	int crtFlag;
	__try
	{
		crtFlag = _CrtSetDbgFlag( _CRTDBG_REPORT_FLAG );
		_CrtSetDbgFlag( crtFlag /*| _CRTDBG_CHECK_ALWAYS_DF */);
		
		__try
		{
			POTE methodPointer = CompileForClassHelper((LPUTF8)szSource, compilerOop, notifier, aClass, flags);

			resultPointer = m_piVM->NewArray(3);
			STVarObject& result = *(STVarObject*)GetObj(resultPointer);
			
			m_piVM->StorePointerWithValue(&(result.fields[0]), Oop(methodPointer));
			
			if (WantTextMap())
				m_piVM->StorePointerWithValue(&(result.fields[1]), Oop(GetTextMapObject()));
			
			if (WantTempsMap())
				m_piVM->StorePointerWithValue(&(result.fields[2]), Oop(GetTempsMapObject()));
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
STDMETHODIMP_(POTE) Compiler::CompileForEval(IUnknown* piVM, Oop compilerOop, const char* szSource, POTE aClass, POTE aWorkspacePool, FLAGS flags, Oop notifier)
{
	m_piVM = (IDolphin*)piVM; 

	// Check argument types are correct
	if (!m_piVM->IsBehavior(Oop(aClass)) || szSource == NULL)
		return Nil();
	
	POTE resultPointer = Nil();
	
	CHECKREFERENCES
		
	wchar_t* prevLocale = NULL;
	__try
	{
#ifdef USE_VM_DLL
		prevLocale = _wsetlocale(LC_ALL, L"C");
		if (prevLocale[0] == L'C' && prevLocale[1] == 0)
		{
			prevLocale = NULL;
		}
		else
		{
			prevLocale = _wcsdup(prevLocale);
		}
#endif
		
		__try
		{
			POTE methodPointer = CompileForEvaluationHelper((LPUTF8)szSource, compilerOop, notifier, aClass, aWorkspacePool, flags);
			
			resultPointer = m_piVM->NewArray(3);
			STVarObject& result = *(STVarObject*)GetObj(resultPointer);
			
			m_piVM->StorePointerWithValue(&(result.fields[0]), Oop(methodPointer));
			
			if (WantTextMap())
				m_piVM->StorePointerWithValue(&(result.fields[1]), Oop(GetTextMapObject()));
			
			if (WantTempsMap())
				m_piVM->StorePointerWithValue(&(result.fields[2]), Oop(GetTempsMapObject()));
		}
		__except(DolphinExceptionFilter(m_piVM, GetExceptionInformation()))
		{
			// Unwind may occur if user catches CompilerNotification and doesn't resume it (for example)
			//
#ifndef USE_VM_DLL
			TRACESTREAM<< L"WARNING: Unwinding Compiler::CompileForEval("
				<< compilerOop << L',' << szSource << L',' << aClass << L','
				<< aWorkspacePool << std::hex << flags << L',' << notifier << L')' << std::endl;
#endif
		}
	}
	__finally
	{
#ifdef USE_VM_DLL
		if (prevLocale != NULL)
		{
			_wsetlocale(LC_ALL, prevLocale);
			free(prevLocale);
		}
#endif
	}
	
	CHECKREFERENCES

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
	args.fields[1] = IntegerObjectOf(GetLineNo());

	args.fields[2] = IntegerObjectOf(range.m_start);
	args.fields[3] = IntegerObjectOf(range.m_stop);
	int offset = GetTextOffset();
	args.fields[4] = IntegerObjectOf(offset);

	POTE sourceString = NewUtf8String(GetText());
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

	int extrasCount = 0;
	va_list copy = extras;
	while (va_arg(copy, Oop) != 0)
		extrasCount++;
	
	POTE oopExtras = m_piVM->NewArray(extrasCount);
	m_piVM->StorePointerWithValue(&args.fields[9], Oop(oopExtras));
	STVarObject& arrayExtras = *(STVarObject*)GetObj(oopExtras);
	for (int i=0;i<extrasCount;i++)
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
	if (!WantSyntaxCheckOnly())	
	{
		if (m_flags & Boot)
		{	
			char buf[1024];
			wsprintf(buf, "ERROR %s>>%s line %d: %d\n\r", GetClassName().c_str(), m_selector.c_str(), GetLineNo(), code);
			OutputDebugString(buf);
		}
		else
		{
			_ASSERTE(m_compilerObject && m_notifier);

			Notification(code, range, extras);
		}
	}
}

void Compiler::Warning(int code, Oop extra)
{
	WarningV(ThisTokenRange(), code, extra, 0);
}

void Compiler::Warning(const TEXTRANGE& range, int code, Oop extra)
{
	WarningV(range, code, extra, 0);
}

void Compiler::WarningV(const TEXTRANGE& range, int code, ...)
{
	if (!WantSyntaxCheckOnly())	
	{
		if (m_flags & Boot)
		{
			char buf[1024];
			VERIFY(wsprintf(buf, "WARNING %s>>%s line %d: %d\n", GetClassName().c_str(), m_selector.c_str(), GetLineNo(), code)>=0);
			OutputDebugString(buf);
			//((CIstApp*)AfxGetApp())->OutputErrorStringToCurrentDoc(buf);
			OutputDebugString((LPCSTR)GetText());
			OutputDebugString("\n\r");
		}
		else
		{
			_ASSERTE(m_compilerObject);
			va_list extras;
			va_start(extras, code);
			Notification(code, range, extras);
			va_end(extras);
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

void Compiler::PopScope(int textStop)
{
	_ASSERTE(m_pCurrentScope != NULL);
	m_pCurrentScope->SetTextStop(textStop);
	m_pCurrentScope = m_pCurrentScope->GetOuter();
}

void Compiler::PushNewScope(int textStart, bool bOptimized)
{
	int start = textStart < 0 ? ThisTokenRange().m_start : textStart;
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

void Compiler::PushOptimizedScope(int textStart)
{
	PushNewScope(textStart, true);
}

inline BYTE MakeOuterTempRef(int blockDepth, int index)
{
	_ASSERTE(index < OuterTempMaxIndex);
	_ASSERTE(blockDepth <= OuterTempMaxDepth);
	return static_cast<BYTE>((blockDepth << 5) | index);
}

int Compiler::GenTempRefInstruction(int instruction, TempVarRef* pRef)
{
	int scopeDepth = pRef->GetEstimatedDistance();
	_ASSERTE(scopeDepth >= 0 && scopeDepth < 256);
	int pos = GenInstructionExtended(instruction, static_cast<BYTE>(scopeDepth));
	// Placeholder for index (not yet known)
	GenData(0);
	m_bytecodes[pos].pVarRef = pRef;

	return pos;
}

int Compiler::GenPushCopiedValue(TempVarDecl* pDecl)
{
	int index = pDecl->GetIndex();
	_ASSERTE(index >= 0);
	int bytesGenerated = 0;

	switch(pDecl->GetVarType())
	{
	case tvtUnaccessed:
		InternalError(__FILE__, __LINE__, pDecl->GetTextRange(), 
						"Unaccessed copied value '%s'", pDecl->GetName().c_str());
		break;

	case tvtCopy:	// Copies are pushed back on the stack on block activation
	case tvtStack:	// A stack variable accessed only from its local scope
	case tvtCopied:	// This is the type of a stack variable that has been copied
	{
		int insertedAt;
		if (index < NumShortPushTemps)
		{
			insertedAt = GenInstruction(ShortPushTemp, static_cast<BYTE>(index));
			bytesGenerated = 1;
		}
		else
		{
			insertedAt = GenInstructionExtended(PushTemp, static_cast<BYTE>(index));
			bytesGenerated = 2;
		}

#ifdef _DEBUG
		// This fake temp ref is only needed for diagnostic purposes (the refs having been processed already)
		TempVarRef* pVarRef = pDecl->GetScope()->AddTempRef(pDecl, vrtRead, pDecl->GetTextRange());
		m_bytecodes[insertedAt].pVarRef = pVarRef;
#endif
		break;
	}

	case tvtShared:
		InternalError( __FILE__, __LINE__, pDecl->GetTextRange(), 
						"Can't copy shared temp '%s'", pDecl->GetName().c_str());
		break;

	default:
		__assume(false);
		break;
	}

	return bytesGenerated;
}

