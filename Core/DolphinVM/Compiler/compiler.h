/*
==========
Compiler.h
==========
Smalltalk compiler
*/
#pragma once

///////////////////////
#include "..\Compiler_i.h"
#include "resource.h"
#include "CompilerDLL.h"

#include "..\DolphinSmalltalk_i.h"
//typedef STObject Object;
#include "..\VMPointers.h"

#include "..\DolphinX.h"

#include "Lexer.h"
#include "LexicalScope.h"
#include <stack>
#undef min
#undef max
#include <valarray>
typedef std::valarray<POTE> POTEARRAY;
#include <unordered_map>

#ifdef _DEBUG
	#include "..\disassembler.h"
#endif

#include "..\EnumHelpers.h"
ENABLE_BITMASK_OPERATORS(CompilerFlags)

///////////////////////

#define LITERALLIMIT		UINT16_MAX+1	// maximum number of literals permitted. Limited by the byte code set, but in
											// practice this limit would not be reached because the byte code limit would
											// be reached first.
#define ARGLIMIT			UINT8_MAX		// maximum number of arguments (VM limit)
#define	ENVTEMPLIMIT		63				// (2^6)-1. Note that actual limit is 62, since value of 1 indicates that a context with 0 slots is required for a far ^-return 

#define GENERATEDTEMPSTART u8" "
#define TEMPSDELIMITER u8'|'

#include "bytecode.h"

/////////////////////////////////////////////////////////////////////////////
// CDolphinSmalltalk
class ATL_NO_VTABLE Compiler : public Lexer,
	public CComObjectRootEx<CComSingleThreadModel>,
	public CComCoClass<Compiler, &CLSID_DolphinCompiler>,
	public ICompiler
{
public:

DECLARE_REGISTRY(Compiler, "Dolphin.Compiler.7", "Dolphin.Compiler", IDR_COMPILER, THREADFLAGS_APARTMENT)

DECLARE_NOT_AGGREGATABLE(Compiler)

DECLARE_PROTECT_FINAL_CONSTRUCT()

BEGIN_COM_MAP(Compiler)
	COM_INTERFACE_ENTRY(ICompiler)
END_COM_MAP()

public:
	// Interpreting the primitiveCompile... type argument
	enum class CompileTo { CompileToCode, CompileToRTF, CompileToTextMap, CompileToTempsMap };

public:
	Compiler();
	virtual ~Compiler();

	void SetVMInterface(IDolphin* piVM) { m_piVM = piVM; }

	POTE CompileExpression(LPUTF8 userexpression, Oop compiler, Oop notifier, Oop contextOop, CompilerFlags flags, size_t& len, textpos_t startAt);
	Oop EvaluateExpression(LPUTF8 text, POTE method, Oop contextOop, POTE pools);
	Oop EvaluateExpression(LPUTF8 source, textpos_t start, textpos_t end, POTE oteMethod, Oop contextOop, POTE pools);

	// External interface requirements
	void GetContext(POTE workspacePools);
	void GetInstVars();

	POTE NewMethod();
	POTE __stdcall NewCompiledMethod(POTE classPointer, size_t numBytes, const STMethodHeader& hdr);
	
	__declspec(property(get = get_Selector)) Str Selector;
	Str get_Selector() const { return m_selector; }

	__declspec(property(get = get_MethodClass)) POTE MethodClass;
	POTE get_MethodClass() const
	{
		return m_class == Nil() ? GetVMPointers().ClassUndefinedObject : m_class;
	}

	POTE GetTextMapObject();
	POTE GetTempsMapObject();

	__declspec(property(get = get_Ok)) bool Ok;
	bool get_Ok() const { return m_ok; }

	__declspec(property(get = get_LiteralCount)) size_t LiteralCount;
	size_t get_LiteralCount() const { return m_literals.size(); }

	void Warning(int code, Oop extra=0);
	void Warning(const TEXTRANGE& range, int code, Oop extra=0);
	void WarningV(const TEXTRANGE& range, int code, ...);

	__declspec(property(get = get_IsInteractive)) bool IsInteractive;
	bool get_IsInteractive() const { return (!!(m_flags & CompilerFlags::Interactive)) && !WantSyntaxCheckOnly; }

private:
	// Flags
	__declspec(property(get= get_WantOptimize)) bool WantOptimize;
	bool get_WantOptimize() const { return !(m_flags & CompilerFlags::NoOptimize); }
	__declspec(property(get= get_WantTextMap)) bool WantTextMap;
	bool get_WantTextMap() const { return !!(m_flags & CompilerFlags::TextMap); }
	__declspec(property(get= get_WantTempsMap)) bool WantTempsMap;
	bool get_WantTempsMap() const { return !!(m_flags & CompilerFlags::TempsMap); }
	__declspec(property(get= get_WantDebugMethod)) bool WantDebugMethod;
	bool get_WantDebugMethod() const { return !!(m_flags & CompilerFlags::DebugMethod); }
	__declspec(property(get= get_WantSyntaxCheckOnly)) bool WantSyntaxCheckOnly;
	bool get_WantSyntaxCheckOnly() const { return !!(m_flags & CompilerFlags::SyntaxCheckOnly); }

	__declspec(property(get = get_CodeSize)) size_t CodeSize;
	size_t get_CodeSize() const
	{
		return m_bytecodes.size();
	}

	__declspec(property(get = get_ArgumentCount)) argcount_t ArgumentCount;
	argcount_t get_ArgumentCount() const
	{
		return GetMethodScope()->ArgumentCount;
	}

	__declspec(property(get = get_IsCompilingExpression)) boolean IsCompilingExpression;
	boolean get_IsCompilingExpression() const
	{
		return m_isCompilingExpression;
	}

	POTE CompileForClassHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aClass, CompilerFlags flags= CompilerFlags::Default);
	POTE CompileForEvaluationHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aBehavior, POTE workspacePools, CompilerFlags=CompilerFlags::Default);

	void SetFlagsAndText(CompilerFlags flags, LPUTF8 text, textpos_t offset);
	void PrepareToCompile(CompilerFlags flags, LPUTF8 text, textpos_t offset, POTE classPointer, Oop compiler, Oop notifier, POTE workspacePools, boolean isCompilingExpression, Oop context=0);
	virtual void _CompileErrorV(int code, const TEXTRANGE& range, va_list extras);
	Oop Notification(int errorCode, const TEXTRANGE& range, va_list extras);
	void InternalError(const char* szFile, int line, const TEXTRANGE&, const char* szMsg, ...);
	
	Str  GetClassName();
	Str GetNameOfClass(Oop oopClass, bool recurse=true);

	// Moved from Interpreter as compiler specific (to ease removal of compiler)
	Oop NewNumber(LPUTF8 textvalue) const;
	POTE NewAnsiString(const char*) const;
	POTE NewAnsiString(const Str&) const;
	POTE NewUtf8String(LPUTF8) const;
	POTE NewUtf8String(const Str&) const;
	POTE InternSymbol(LPUTF8) const;
	POTE InternSymbol(const Str&) const;

	// Lookup
	OpCode FindNameAsSpecialMessage(const Str&) const;
	bool IsPseudoVariable(const Str&) const;
	size_t FindNameAsInstanceVariable(const Str&) const;
	TempVarRef* AddTempRef(const Str& strName, VarRefType refType, const TEXTRANGE& refRange, textpos_t expressionEnd);

	enum class StaticType { Cancel=-1, NotFound, Variable, Constant };
	StaticType FindNameAsStatic(const Str&, POTE&, bool autoDefine=false);

	void WarnIfRestrictedSelector(textpos_t start);

	// Code generation
	enum class LiteralType { ReferenceOnly, Normal };
	size_t AddToFrameUnconditional(Oop object, const TEXTRANGE&);
	size_t AddToFrame(Oop object, const TEXTRANGE&, LiteralType type);
	size_t AddStringToFrame(POTE string, const TEXTRANGE&);
	POTE AddSymbolToFrame(LPUTF8, const TEXTRANGE&, LiteralType refOnly);
	void InsertByte(ip_t pos, uint8_t value, BYTECODE::Flags flags, LexicalScope* pScope);
	void RemoveByte(ip_t pos);
	void RemoveBytes(ip_t start, size_t count);
	size_t RemoveInstruction(ip_t pos);
	ip_t GenByte(uint8_t value, BYTECODE::Flags flags, LexicalScope* pScope);
	ip_t GenData(uint8_t value);
	ip_t GenInstruction(OpCode basic, uint8_t offset=0);
	ip_t GenInstructionExtended(OpCode basic, uint8_t extension);
	ip_t GenLongInstruction(OpCode basic, uint16_t extension);
	void UngenInstruction(ip_t pos);
	void UngenData(ip_t pos, LexicalScope* pScope);
	
	ip_t GenNop();
	ip_t GenDup();
	ip_t GenPopStack();
	
	void GenInteger(intptr_t val, const TEXTRANGE&);
	Oop GenNumber(LPUTF8 textvalue, const TEXTRANGE&);
	void GenNumber(Oop, const TEXTRANGE&);
	void GenConstant(size_t index);
	void GenLiteralConstant(Oop object, const TEXTRANGE&);
	void GenStatic(const POTE oteStatic, const TEXTRANGE&);
	
	ip_t GenMessage(const Str& pattern, argcount_t argumentCount, textpos_t messageStart);

	ip_t GenJumpInstruction(OpCode basic);
	ip_t GenJump(OpCode basic, ip_t location);
	void SetJumpTarget(ip_t jump, ip_t target);

	ip_t GenTempRefInstruction(OpCode instruction, TempVarRef* pRef);
	size_t GenPushCopiedValue(TempVarDecl*);

	void GenPushSelf();
	void GenPushVariable(const Str&, const TEXTRANGE&);
	ip_t GenPushTemp(TempVarRef*);
	ip_t GenPushInstVar(uint8_t index);
	void GenPushStaticVariable(const Str&, const TEXTRANGE&);
	void GenPushStaticConstant(POTE oteBinding, const TEXTRANGE& range);
	void GenPushConstant(Oop objectPointer, const TEXTRANGE& range);
	bool GenPushImmediate(Oop objectPointer, const TEXTRANGE& range);

	void GenPopAndStoreTemp(TempVarRef*);

	ip_t GenStore(const Str&, const TEXTRANGE&, textpos_t assignedExpressionStop);
	ip_t GenStoreTemp(TempVarRef*);
	ip_t GenStoreInstVar(uint8_t index);
	ip_t GenStaticStore(const Str&, const TEXTRANGE&, textpos_t assignedExpressionStop);

	ip_t GenReturn(OpCode retOp);
	ip_t GenFarReturn();


	// Pass 2 and optimization
	size_t Pass2();
	void RemoveNops();
	void Optimize();
	size_t CombinePairs();
	size_t CombinePairs1();
	size_t CombinePairs2();
	size_t OptimizePairs();
	size_t OptimizeJumps();
	size_t InlineReturns();
	size_t ShortenJumps();
	void FixupJumps();
	void FixupJump(ip_t);
	void insertImmediateAsFirstLiteral(Oop immediate);

	// Recursive Decent Parsing
	POTE  ParseMethod();
	POTE  ParseEvalExpression(TokenType);
	void ParseMessagePattern();
	void ParseArgument();
	tempcount_t ParseTemporaries();
	size_t ParseStatements(TokenType, bool popResults = true);
	void ParseBlockStatements();
	void ParseStatement();
	void ParseExpression();
	void ParseAssignment(const Str&, const TEXTRANGE&);
	void ParseTerm(textpos_t textPosition);
	void ParseBinaryTerm(textpos_t textPosition);
	void ParseBraceArray(textpos_t textPosition);
	void ParseContinuation(ip_t exprMark, textpos_t textPosition);
	ip_t ParseKeyContinuation(ip_t exprMark, textpos_t textPosition);
	ip_t ParseBinaryContinuation(ip_t exprMark, textpos_t textPosition);
	ip_t ParseUnaryContinuation(ip_t exprMark, textpos_t textPosition);
	void MaybePatchNegativeNumber();
	void MaybePatchLiteralMessage();

	// Parsing for primitive methods
	void ParsePrimitive();

	struct LibCallType
	{
		LPUTF8 szCallType;
		DolphinX::ExtCallDeclSpec nCallType;
	};
	static LibCallType callTypes[4];

	LibCallType* ParseCallingConvention(const Str&);
	void ParseLibCall(DolphinX::ExtCallDeclSpec decl, DolphinX::ExtCallPrimitive callPrim);
	void ParseVirtualCall(DolphinX::ExtCallDeclSpec decl);

	struct TypeDescriptor
	{
		DolphinX::ExtCallArgType	type;
		Oop							parm;
		TEXTRANGE					range;
	};

	argcount_t ParseExtCallArgs(TypeDescriptor args[]);
	void ParseExtCallArgument(TypeDescriptor& out);
	void ParseExternalClass(const Str&, TypeDescriptor&);
	POTE FindExternalClass(const Str&, const TEXTRANGE&);
	DolphinX::ExtCallArgType TypeForStructPointer(POTE oteStructClass);
	DolphinX::ExternalMethodDescriptor& buildDescriptorLiteral(TypeDescriptor args[], argcount_t argcount, DolphinX::ExtCallDeclSpec decl, LPUTF8 procName);
	void mangleDescriptorReturnType(TypeDescriptor& retType, const TEXTRANGE&);

	__declspec(property(get=get_IsAtMethodScope)) bool IsAtMethodScope;
	bool get_IsAtMethodScope() const
	{
		_ASSERTE(m_pCurrentScope != nullptr);
		return m_pCurrentScope == GetMethodScope();
	}

	__declspec(property(get = get_IsInBlock)) bool IsInBlock;
	bool get_IsInBlock() const
	{
		return m_pCurrentScope->IsInBlock;
	}

	__declspec(property(get = get_IsInOptimizedBlock)) bool IsInOptimizedBlock;
	bool get_IsInOptimizedBlock() const
	{
		return m_pCurrentScope->IsOptimizedBlock;
	}

	void ParseBlock(const textpos_t textPosition);
	argcount_t  ParseBlockArguments(const textpos_t textPosition);
	bool ParseIfTrue(const TEXTRANGE&);
	bool ParseIfFalse(const TEXTRANGE&);
	bool ParseAndCondition(const TEXTRANGE&);
	bool ParseOrCondition(const TEXTRANGE&);
	bool ParseIfNilBlock(bool noPop);
	bool ParseIfNotNilBlock();
	bool ParseIfNil(const TEXTRANGE&, textpos_t);
	bool ParseIfNotNil(const TEXTRANGE&, textpos_t);
	template<bool WhileTrue> bool ParseWhileLoop(const ip_t mark, const TEXTRANGE& receiverRange);
	template<bool> bool ParseWhileLoopBlock(const ip_t mark, const TEXTRANGE& tokenRange, const TEXTRANGE& receiverRange);
	bool ParseRepeatLoop(const ip_t mark, const TEXTRANGE& receiverRange);
	bool ParseTimesRepeatLoop(const TEXTRANGE&, const textpos_t textStart);
	void ParseToByNumberDo(ip_t toPointer, Oop oopStep, bool bNegativeStep);
	bool ParseToDoBlock(textpos_t, ip_t toPointer);
	bool ParseToByDoBlock(textpos_t, ip_t toPointer, ip_t byPointer=ip_t::zero);
	bool ParseZeroArgOptimizedBlock();
	void ParseOptimizeBlock(argcount_t argc);

	void InlineOptimizedBlock(ip_t nStart, ip_t nStop);
	enum class LoopReceiverType { NiladicBlock, NonNiladicBlock, EmptyBlock, Other };
	LoopReceiverType InlineLoopBlock(const ip_t loopmark, const TEXTRANGE&);
	size_t PatchBlocks();
	size_t PatchBlockAt(ip_t i);
	void MakeCleanBlockAt(ip_t i);

	POTE ParseArray();
	POTE ParseByteArray();
	Oop  ParseConstExpression();
	POTE ParseQualifiedReference(textpos_t textPosition);

	template <bool ignoreNops> ip_t PriorInstruction() const;
	bool LastIsPushNil() const;
	bool LastIsPushSmallInteger(intptr_t& value) const;
	Oop LastIsPushNumber() const;
	Oop IsPushLiteral(ip_t pos) const;

	// Temporaries
	TempVarDecl* AddTemporary(const Str& name, const TEXTRANGE& range, bool isArg);
	TempVarDecl* AddArgument(const Str& name, const TEXTRANGE& range);
	TempVarRef* AddOptimizedTemp(const Str& name, const TEXTRANGE& range=TEXTRANGE());
	void RenameTemporary(tempcount_t temporary, LPUTF8 newName, const TEXTRANGE& range);
	void CheckTemporaryName(const Str&, const TEXTRANGE&, bool isArg);
	void PushNewScope(textpos_t textStart, bool bOptimized=false);
	void PushOptimizedScope(textpos_t textStart=textpos_t::npos);
	void PopScope(textpos_t textStop);
	void PopOptimizedScope(textpos_t textStop);
	LexicalScope* GetMethodScope() const;
	void DetermineTempUsage();
	TempVarDecl* DeclareTemp(const Str& strName, const TEXTRANGE& range);
	void FixupTempRef(ip_t i);
	size_t FixupTempRefs();
	size_t FixupTempsAndBlocks();
	void PatchOptimizedScopes();
	void PatchCleanBlockLiterals(POTE oteMethod);

	// text map
	size_t AddTextMap(ip_t ip, const TEXTRANGE&);
	size_t AddTextMap(ip_t ip, textpos_t textStart, textpos_t textStop);
	bool AdjustTextMapEntry(ip_t ip, ip_t newIP);
	void InsertTextMapEntry(ip_t ip, textpos_t textStart, textpos_t textStop);
	bool RemoveTextMapEntry(ip_t ip);
	bool VoidTextMapEntry(ip_t ip);
#ifdef _DEBUG
	void AssertValidIpForTextMapEntry(ip_t ip, bool bFinal);
	void VerifyTextMap(bool bFinal = false);
	void VerifyJumps();
	bool IsBlock(Oop oop);
	void disassemble(std::wostream& stream);
	void disassemble();
	std::wstring DebugPrintString(Oop);

public:
	// Methods required by Disassembler
	uint8_t GetBytecode(ip_t ip) const { return m_bytecodes[ip].byte; }
	Str GetSpecialSelector(size_t index);
	std::wstring GetLiteralAsString(size_t index) { return DebugPrintString(m_literalFrame[index]); }
	Str GetInstVar(size_t index) { return m_instVars[index]; }

private:
#else
#define AssertValidIpForTextMapEntry __noop
#define VerifyTextMap __noop
#define VerifyJumps __noop
#define disassemble __noop
#endif

	void BreakPoint();

	const VMPointers& GetVMPointers() const
	{
		return *(VMPointers*)m_piVM->GetVMPointers();
	}

	POTE Nil() const
	{
		return m_piVM->NilPointer();
	}

	void MakeQuickMethod(STMethodHeader& hdr, STPrimitives extraIndex);

public:
	POTE InstVarNamesOf(POTE aBehavior)/* throws SE_VMCALLBACKUNWIND */;
	POTE FindDictVariable(POTE dict, const Str&)/* throws SE_VMCALLBACKUNWIND */;
	//POTE FindClass(const Str&)/* throws SE_VMCALLBACKUNWIND */;
	POTE FindGlobal(const Str&)/* throws SE_VMCALLBACKUNWIND */;
	POTE DictAtPut(POTE dict, const Str&, Oop value)/* throws SE_VMCALLBACKUNWIND */;
	bool CanUnderstand(POTE oteBehavior, POTE oteSelector);
	Str GetString(POTE oopString);

	// Special names for compiler and decoder
	static const char* s_specialObjectName[];

// ICompiler
public:
	STDMETHOD_(POTE, CompileForClass)(IUnknown* piVM, Oop compiler, const char* compiletext, POTE aClass, FLAGS flags, Oop notifier);
	STDMETHOD_(POTE, CompileForEval)(IUnknown* piVM, Oop compiler, const char* compiletext, POTE aClass, POTE workspacePools, FLAGS flags, Oop notifier);

private:
	// Parse state
	bool m_ok;								// Parse still ok? 
	bool m_instVarsInitialized;
	bool m_isMutable;
	bool m_isCompilingExpression;

	enum class SendType { Other, Self, Super };
	CompilerFlags m_flags;							// Compiler flags

	SendType m_sendType;					// true if current message is to super

	// Dynamic array of bytecodes
	BYTECODES m_bytecodes;
	ip_t m_codePointer;						// Code insert position

	__declspec(property(get = GetLastIp)) ip_t LastIp;
	ip_t GetLastIp() const
	{
		return static_cast<ip_t>(CodeSize - 1);
	}

	// Dynamic array of literals
	typedef std::vector<Oop> OOPVECTOR;
	OOPVECTOR m_literalFrame;			// Literal frame
	typedef std::unordered_map<Oop, size_t> LiteralMap;
	LiteralMap m_literals;				// All literals
	size_t m_literalLimit;

	// Fixed size array of instance vars (determined from class)
	typedef std::valarray<Str> STRINGARRAY;
	STRINGARRAY m_instVars;

	typedef std::vector<LexicalScope*> SCOPELIST;
	SCOPELIST m_allScopes;
	LexicalScope* m_pCurrentScope;

	POTE m_class;							// The current class to which the compilation applies, i.e. the method class
	POTE m_oopWorkspacePools;				// Shared pools for associated workspace
	Oop	 m_context;							// Compilation context for expression

	Str m_selector;							// The current message selector

	uintptr_t m_primitiveIndex;				// Index of primitive or zero
	Oop m_compilerObject;					// The object which was the receiver of the primCompile:... message to start compilation

	struct TEXTMAP
	{
		ip_t ip;
		textpos_t start;
		textpos_t stop;

		TEXTMAP(const ip_t ip, const textpos_t start, const textpos_t stop) { this->ip = ip; this->start = start; this->stop = stop; }
		TEXTMAP() : ip((ip_t)-1), start((textpos_t)-1), stop((textpos_t)-1) { }
	};

	typedef std::vector<TEXTMAP> TEXTMAPLIST;
	TEXTMAPLIST m_textMaps;

	TEXTMAPLIST::iterator FindTextMapEntry(ip_t ip);

	POTE m_compiledMethodClass;				// Class of compiled method to generate
	Oop m_notifier;							// Notifier object to send compilerError:... callbacks to

	typedef std::map<Str, POTE> NAMEDOBJECTS;
	NAMEDOBJECTS m_bindingRefs;
};

OBJECT_ENTRY_AUTO(__uuidof(DolphinCompiler), Compiler)

///////////////////////

// Inlines

// Insert a data byte at the code pointer, returning the position at which
// the date byte was inserted.
inline ip_t Compiler::GenData(uint8_t value)
{
	return GenByte(value, BYTECODE::Flags::IsData, nullptr);
}

inline void Compiler::UngenData(ip_t pos, LexicalScope* pScope)
{
	#ifdef _DEBUG
	{
		BYTECODE& bc = m_bytecodes[pos];
		_ASSERTE(bc.IsData);
		_ASSERTE(!bc.IsJumpSource);
	}
	#endif
	m_bytecodes[pos].makeNop(pScope);
}

// Insert an instruction at the code pointer, returning the position at which
// the instruction was inserted.
inline ip_t Compiler::GenInstruction(OpCode basic, uint8_t offset)
{
	_ASSERTE(offset == 0 || static_cast<unsigned>(basic+offset) < FirstDoubleByteInstruction);
	_ASSERTE(m_pCurrentScope != nullptr);
	return GenByte(static_cast<uint8_t>(basic + offset), BYTECODE::Flags::IsOpCode, m_pCurrentScope);
}

inline ip_t Compiler::GenNop()
{
	return GenInstruction(OpCode::Nop);
}

inline ip_t Compiler::GenDup()
{
	return GenInstruction(OpCode::DuplicateStackTop);
}

inline ip_t Compiler::GenPopStack()
{
	return GenInstruction(OpCode::PopStackTop);
}

inline ip_t Compiler::GenStoreTemp(TempVarRef* pTemp)
{
	return GenTempRefInstruction(OpCode::LongStoreOuterTemp, pTemp);
}

///////////////////////////////////////////////////////////////////////////////

inline LexicalScope* Compiler::GetMethodScope() const
{
	_ASSERTE(!m_allScopes.empty());
	return m_allScopes[0];
}

///////////////////////

inline POTE Compiler::NewAnsiString(const char* sz) const
{
	return m_piVM->NewString((LPCSTR)sz);
}

inline POTE Compiler::NewAnsiString(const Str& str) const
{
	return NewAnsiString((LPCSTR)str.c_str());
}

inline POTE Compiler::NewUtf8String(LPUTF8 sz) const
{
	return m_piVM->NewUtf8String((LPCSTR)sz);
}

inline POTE Compiler::NewUtf8String(const Str& str) const
{
	return NewUtf8String(str.c_str());
}

inline POTE Compiler::InternSymbol(LPUTF8 sz) const
{
	return m_piVM->InternSymbol((LPCSTR)sz);
}

inline POTE Compiler::InternSymbol(const Str& str) const
{
	return InternSymbol(str.c_str());
}

inline void Compiler::RemoveByte(ip_t ip)
{
	_ASSERTE(m_bytecodes[ip].IsData);	// Should be using RemoveInstruction for op code bytes
	RemoveBytes(ip, 1);
}

inline Str Compiler::GetString(POTE ote) 
{ 
	return MakeString(m_piVM, ote); 
}
