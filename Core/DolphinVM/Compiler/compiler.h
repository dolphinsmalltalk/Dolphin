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

#ifdef _DEBUG
	#include "..\disassembler.h"
#endif

///////////////////////

#define LITERALLIMIT		65536	// maximum number of literals permitted. Limited by the byte code set, but in
									// practice this limit would not be reached because the byte code limit would
									// be reached first.
#define ARGLIMIT			255		// maximum number of arguments (VM limit)
#define	ENVTEMPLIMIT		63		// (2^6)-1. Note that actual limit is 62, since value of 1 indicates that a context with 0 slots is required for a far ^-return 

#define GENERATEDTEMPSTART " "
#define TEMPSDELIMITER '|'

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
	enum {CompileToCode, CompileToRTF, CompileToTextMap, CompileToTempsMap };

public:
	Compiler();
	virtual ~Compiler();

	void SetVMInterface(IDolphin* piVM) { m_piVM = piVM; }

	POTE CompileExpression(LPUTF8 userexpression, Oop compiler, Oop notifier, Oop contextOop, FLAGS flags, unsigned& len, int startAt);
	Oop EvaluateExpression(LPUTF8 text, POTE method, Oop contextOop, POTE pools);
	Oop EvaluateExpression(LPUTF8 source, int start, int end, POTE oteMethod, Oop contextOop, POTE pools);

	// External interface requirements
	void GetContext(POTE workspacePools);
	void GetInstVars();

	POTE NewMethod();
	POTE __stdcall NewCompiledMethod(POTE classPointer, unsigned numBytes, const STMethodHeader& hdr);
	Str GetSelector() const;
	POTE GetTextMapObject();
	POTE GetTempsMapObject();
	bool Ok() const;

	int GetLiteralCount() const;

	void Warning(int code, Oop extra=0);
	void Warning(const TEXTRANGE& range, int code, Oop extra=0);
	void WarningV(const TEXTRANGE& range, int code, ...);
	bool IsInteractive() const;

private:
	// Flags
	bool WantSyntaxCheckOnly() const;
	bool WantOptimize() const;
	bool WantTextMap() const;
	bool WantTempsMap() const;
	bool WantDebugMethod() const;

	POTE CompileForClassHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aClass, FLAGS flags=Default);
	POTE CompileForEvaluationHelper(LPUTF8 compiletext, Oop compiler, Oop notifier, POTE aBehavior, POTE workspacePools, FLAGS flags=Default);

	void SetFlagsAndText(FLAGS flags, LPUTF8 text, int offset);
	void PrepareToCompile(FLAGS flags, LPUTF8 text, int offset, POTE classPointer, Oop compiler, Oop notifier, POTE workspacePools, POTE compiledMethodClass, Oop context=0);
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
	int FindNameAsSpecialMessage(const Str&) const;
	bool IsPseudoVariable(const Str&) const;
	int FindNameAsInstanceVariable(const Str&) const;
	TempVarRef* AddTempRef(const Str& strName, VarRefType refType, const TEXTRANGE& refRange, int expressionEnd);

	enum StaticType { STATICCANCEL=-1, STATICNOTFOUND, STATICVARIABLE, STATICCONSTANT };
	StaticType FindNameAsStatic(const Str&, POTE&, bool autoDefine=false);

	void WarnIfRestrictedSelector(int start);

	// Code generation
	int GetCodeSize() const;
	int AddToFrameUnconditional(Oop object, const TEXTRANGE&);
	int AddToFrame(Oop object, const TEXTRANGE&);
	int AddStringToFrame(POTE string, const TEXTRANGE&);
	POTE AddSymbolToFrame(LPUTF8, const TEXTRANGE&);
	POTE AddSymbolToFrame(const char*, const TEXTRANGE&);
	void InsertByte(int pos, BYTE value, BYTE flags, LexicalScope* pScope);
	void RemoveByte(int pos);
	void RemoveBytes(int start, int stop);
	int RemoveInstruction(int pos);
	int GenByte(BYTE value, BYTE flags, LexicalScope* pScope);
	int GenData(BYTE value);
	int GenInstruction(BYTE basic, BYTE offset=0);
	int GenInstructionExtended(BYTE basic, BYTE extension);
	int GenLongInstruction(BYTE basic, WORD extension);
	void UngenInstruction(int pos);
	void UngenData(int pos, LexicalScope* pScope);
	
	int GenNop();
	int GenDup();
	int GenPopStack();
	
	void GenInteger(int val, const TEXTRANGE&);
	Oop GenNumber(LPUTF8 textvalue, const TEXTRANGE&);
	void GenNumber(Oop, const TEXTRANGE&);
	void GenConstant(int index);
	void GenLiteralConstant(Oop object, const TEXTRANGE&);
	void GenStatic(const POTE oteStatic, const TEXTRANGE&);
	
	int GenMessage(const Str& pattern, int argumentCount, int messageStart);

	int GenJumpInstruction(BYTE basic);
	int GenJump(BYTE basic, int location);
	void SetJumpTarget(int jump, int target);

	int GenTempRefInstruction(int instruction, TempVarRef* pRef);
	int GenPushCopiedValue(TempVarDecl*);

	void GenPushSelf();
	void GenPushVariable(const Str&, const TEXTRANGE&);
	int GenPushTemp(TempVarRef*);
	int GenPushInstVar(BYTE index);
	void GenPushStaticVariable(const Str&, const TEXTRANGE&);
	void GenPushStaticConstant(POTE oteBinding, const TEXTRANGE& range);
	void GenPushConstant(Oop objectPointer, const TEXTRANGE& range);
	bool GenPushImmediate(Oop objectPointer, const TEXTRANGE& range);

	void GenPopAndStoreTemp(TempVarRef*);

	int GenStore(const Str&, const TEXTRANGE&, int assignedExpressionStop);
	int GenStoreTemp(TempVarRef*);
	int GenStoreInstVar(BYTE index);
	int GenStaticStore(const Str&, const TEXTRANGE&, int assignedExpressionStop);

	int GenReturn(BYTE retOp);
	int GenFarReturn();


	// Pass 2 and optimization
	int Pass2();
	void RemoveNops();
	void Optimize();
	int CombinePairs();
	int CombinePairs1();
	int CombinePairs2();
	int OptimizePairs();
	int OptimizeJumps();
	int InlineReturns();
	int ShortenJumps();
	void FixupJumps();
	void FixupJump(int);

	// Recursive Decent Parsing
	POTE  ParseMethod();
	POTE  ParseEvalExpression(TokenType);
	void ParseMessagePattern();
	void ParseArgument();
	int ParseTemporaries();
	int ParseStatements(TokenType, bool popResults = true);
	void ParseBlockStatements();
	void ParseStatement();
	void ParseExpression();
	void ParseAssignment(const Str&, const TEXTRANGE&);
	void ParseTerm(int textPosition);
	void ParseBinaryTerm(int textPosition);
	void ParseBraceArray(int textPosition);
	void ParseContinuation(int exprMark, int textPosition);
	int ParseKeyContinuation(int exprMark, int textPosition);
	int ParseBinaryContinuation(int exprMark, int textPosition);
	int ParseUnaryContinuation(int exprMark, int textPosition);
	void MaybePatchNegativeNumber();
	void MaybePatchLiteralMessage();

	// Parsing for primitive methods
	void ParsePrimitive();

	struct LibCallType
	{
		LPUTF8 szCallType;
		DolphinX::ExtCallDeclSpecs nCallType;
	};
	static LibCallType callTypes[DolphinX::NumCallConventions];

	LibCallType* ParseCallingConvention(const Str&);
	void ParseLibCall(DolphinX::ExtCallDeclSpecs decl, int callPrim);
	void ParseVirtualCall(DolphinX::ExtCallDeclSpecs decl);

	struct TypeDescriptor
	{
		DolphinX::ExtCallArgTypes	type;
		Oop							parm;
		TEXTRANGE					range;
	};

	int ParseExtCallArgs(TypeDescriptor args[]);
	void ParseExtCallArgument(TypeDescriptor& out);
	void ParseExternalClass(const Str&, TypeDescriptor&);
	POTE FindExternalClass(const Str&, const TEXTRANGE&);
	DolphinX::ExtCallArgTypes TypeForStructPointer(POTE oteStructClass);
	DolphinX::ExternalMethodDescriptor& buildDescriptorLiteral(TypeDescriptor args[], int argcount, DolphinX::ExtCallDeclSpecs decl, LPUTF8 procName);
	void mangleDescriptorReturnType(TypeDescriptor& retType, const TEXTRANGE&);

	bool IsAtMethodScope() const;
	bool IsInBlock() const;
	bool IsInOptimizedBlock() const;

	void ParseBlock(const int textPosition);
	int  ParseBlockArguments(const int textPosition);
	bool ParseIfTrue(const TEXTRANGE&);
	bool ParseIfFalse(const TEXTRANGE&);
	bool ParseAndCondition(const TEXTRANGE&);
	bool ParseOrCondition(const TEXTRANGE&);
	bool ParseIfNilBlock(bool noPop);
	int ParseIfNotNilBlock();
	bool ParseIfNil(const TEXTRANGE&, int);
	bool ParseIfNotNil(const TEXTRANGE&, int);
	bool ParseWhileLoop(bool, const int mark);
	bool ParseWhileLoopBlock(const bool bIsWhileTrue, const int mark, const TEXTRANGE& tokenRange, const int textStart);
	bool ParseRepeatLoop(const int mark);
	bool ParseTimesRepeatLoop(const TEXTRANGE&);
	void ParseToByNumberDo(int toPointer, Oop oopStep, bool bNegativeStep);
	bool ParseToDoBlock(int, int toPointer);
	bool ParseToByDoBlock(int, int toPointer, int byPointer=0);
	void ParseZeroArgOptimizedBlock();
	int ParseOptimizeBlock(int argc);

	void InlineOptimizedBlock(int nStart, int nStop);
	bool InlineLoopBlock(const int loopmark, const TEXTRANGE&);
	int PatchBlocks();
	int PatchBlockAt(int i);
	void MakeCleanBlockAt(int i);

	POTE ParseArray();
	POTE ParseByteArray();
	Oop  ParseConstExpression();

	int	PriorInstruction() const;
	bool LastIsPushSmallInteger(int& value) const;
	Oop LastIsPushNumber() const;
	Oop IsPushLiteral(int pos) const;

	// Temporaries
	TempVarDecl* AddTemporary(const Str& name, const TEXTRANGE& range, bool isArg);
	TempVarDecl* AddArgument(const Str& name, const TEXTRANGE& range);
	TempVarRef* AddOptimizedTemp(const Str& name, const TEXTRANGE& range=TEXTRANGE());
	void RenameTemporary(int temporary, LPUTF8 newName, const TEXTRANGE& range);
	void CheckTemporaryName(const Str&, const TEXTRANGE&, bool isArg);
	void PushNewScope(int textStart, bool bOptimized=false);
	void PushOptimizedScope(int textStart=-1);
	void PopScope(int textStop);
	void PopOptimizedScope(int textStop);
	LexicalScope* GetMethodScope() const;
	void DetermineTempUsage();
	TempVarDecl* DeclareTemp(const Str& strName, const TEXTRANGE& range);
	void FixupTempRef(int i);
	int FixupTempRefs();
	int FixupTempsAndBlocks();
	void PatchOptimizedScopes();
	void PatchCleanBlockLiterals(POTE oteMethod);
	int GetArgumentCount() const;

	// text map
	int AddTextMap(int ip, const TEXTRANGE&);
	int AddTextMap(int ip, int textStart, int textStop);
	bool AdjustTextMapEntry(int ip, int newIP);
	void InsertTextMapEntry(int ip, int textStart, int textStop);
	bool RemoveTextMapEntry(int ip);
	bool VoidTextMapEntry(int ip);
#ifdef _DEBUG
	void AssertValidIpForTextMapEntry(int ip, bool bFinal);
	void VerifyTextMap(bool bFinal = false);
	void VerifyJumps();
	bool IsBlock(Oop oop);
	void disassemble(std::wostream& stream);
	void disassemble();
	std::wstring DebugPrintString(Oop);

public:
	// Methods required by Disassembler
	BYTE GetBytecode(size_t ip) { return m_bytecodes[ip].byte; }
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
	enum SendType { SendOther, SendSelf, SendSuper };
	FLAGS m_flags;							// Compiler flags

	SendType m_sendType;					// true if current message is to super

	// Dynamic array of bytecodes
	BYTECODES m_bytecodes;
	int m_codePointer;						// Code insert position

	// Dynamic array of literals
	typedef std::vector<Oop> OOPVECTOR;
	OOPVECTOR m_literalFrame;					// Literal frame
	int m_literalLimit;

	// Fixed size array of instance vars (determined from class)
	typedef std::valarray<Str> STRINGARRAY;
	STRINGARRAY m_instVars;

	typedef std::vector<LexicalScope*> SCOPELIST;
	SCOPELIST m_allScopes;
	LexicalScope* m_pCurrentScope;

	POTE m_class;							// The current class to which the compilation applies
	POTE m_oopWorkspacePools;				// Shared pools for associated workspace
	Oop	 m_context;							// Compilation context for expression

	Str m_selector;							// The current message selector

	unsigned m_primitiveIndex;				// Index of primitive or zero
	Oop m_compilerObject;					// The object which was the receiver of the primCompile:... message to start compilation

	struct TEXTMAP
	{
		int ip;
		int start;
		int stop;

		TEXTMAP(int ip, int start, int stop) { this->ip = ip; this->start = start; this->stop = stop; }
		TEXTMAP() { ip = start = stop = -1; }
	};

	typedef std::vector<TEXTMAP> TEXTMAPLIST;
	TEXTMAPLIST m_textMaps;

	TEXTMAPLIST::iterator FindTextMapEntry(int ip);

	POTE m_compiledMethodClass;				// Class of compiled method to generate
	Oop m_notifier;							// Notifier object to send compilerError:... callbacks to
};

OBJECT_ENTRY_AUTO(__uuidof(DolphinCompiler), Compiler)

///////////////////////

// Inlines
inline bool Compiler::WantSyntaxCheckOnly() const { return (m_flags & SyntaxCheckOnly)!=0; }
inline bool Compiler::IsInteractive() const { return ((m_flags & Interactive)!=0) && !WantSyntaxCheckOnly(); }
inline bool Compiler::WantOptimize() const { return (m_flags & NoOptimize)==0; }
inline bool Compiler::WantTextMap() const { return (m_flags & TextMap)!=0; }
inline bool Compiler::WantDebugMethod() const { return (m_flags & DebugMethod)!=0; }
inline bool Compiler::WantTempsMap() const { return (m_flags & TempsMap)!=0; }
inline Str Compiler::GetSelector() const { return m_selector; }
inline bool Compiler::Ok() const { return m_ok; }
inline int Compiler::GetLiteralCount() const { return m_literalFrame.size(); }

inline int Compiler::GetCodeSize() const 
{ 
	return m_bytecodes.size();
}

inline int Compiler::GetArgumentCount() const
{
	return GetMethodScope()->GetArgumentCount();
}

///////////////////////////////////////////////////////////////////////////////

// Insert a data byte at the code pointer, returning the position at which
// the date byte was inserted.
inline int Compiler::GenData(BYTE value)
{
	return GenByte(value, BYTECODE::IsData, NULL);
}

inline void Compiler::UngenData(int pos, LexicalScope* pScope)
{
	_ASSERTE(pos < GetCodeSize());
	#ifdef _DEBUG
	{
		BYTECODE& bc = m_bytecodes[pos];
		_ASSERTE(bc.isData());
		_ASSERTE(!bc.isJumpSource());
	}
	#endif
	m_bytecodes[pos].makeNop(pScope);
}

// Insert an instruction at the code pointer, returning the position at which
// the instruction was inserted.
inline int Compiler::GenInstruction(BYTE basic, BYTE offset)
{
	_ASSERTE(offset == 0 || ((int)basic+offset) < FirstDoubleByteInstruction);
	_ASSERTE(m_pCurrentScope != NULL);
	return GenByte(basic + offset, BYTECODE::IsOpCode, m_pCurrentScope);
}

inline int Compiler::GenNop()
{
	return GenInstruction(Nop);
}

inline int Compiler::GenDup()
{
	return GenInstruction(DuplicateStackTop);
}

inline int Compiler::GenPopStack()
{
	return GenInstruction(PopStackTop);
}

inline int Compiler::GenStoreTemp(TempVarRef* pTemp)
{
	return GenTempRefInstruction(LongStoreOuterTemp, pTemp);
}

///////////////////////////////////////////////////////////////////////////////

inline bool Compiler::IsInBlock() const
{
	return m_pCurrentScope->IsInBlock();
}

inline bool Compiler::IsAtMethodScope() const
{
	_ASSERTE(m_pCurrentScope != NULL);
	return m_pCurrentScope == GetMethodScope();
}

inline bool Compiler::IsInOptimizedBlock() const
{
	return m_pCurrentScope->IsOptimizedBlock();
}

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

inline void Compiler::RemoveByte(int ip)
{
	_ASSERTE(m_bytecodes[ip].isData());	// Should be using RemoveInstruction for op code bytes
	RemoveBytes(ip, 1);
}

inline Str Compiler::GetString(POTE ote) 
{ 
	return MakeString(m_piVM, ote); 
}

inline POTE Compiler::AddSymbolToFrame(const char* s, const TEXTRANGE& tokenRange)
{
	return AddSymbolToFrame((LPUTF8)s, tokenRange);
}
