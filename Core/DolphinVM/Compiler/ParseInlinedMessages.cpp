///////////////////////

#include "stdafx.h"

#include "Compiler.h"
#include <locale.h>

#include <crtdbg.h>
#define CHECKREFERENCES

#ifdef _DEBUG

#elif !defined(USE_VM_DLL)
#undef NDEBUG
#include <assert.h>
#undef _ASSERTE
#define _ASSERTE assert
#endif

template bool Compiler::ParseWhileLoop<true>(const ip_t, const TEXTRANGE&);
template bool Compiler::ParseWhileLoop<false>(const ip_t, const TEXTRANGE&);
template bool Compiler::ParseWhileLoopBlock<true>(const ip_t, const TEXTRANGE&, const TEXTRANGE&);
template bool Compiler::ParseWhileLoopBlock<false>(const ip_t, const TEXTRANGE&, const TEXTRANGE&);

///////////////////////////////////////////////////////////////////////////////
// When inlining code the compiler sometimes has to generate temporaries. It prefixes
// these with a space so that the names cannot possibly clash with user defined temps
static const u8string eachTempName = GENERATEDTEMPSTART u8"each";
static const u8string valueTempName = GENERATEDTEMPSTART u8"value";

///////////////////////////////////////////////////////////////////////////////

void Compiler::PopOptimizedScope(textpos_t textStop)
{
	PopScope(textStop);
}

bool Compiler::ParseZeroArgOptimizedBlock()
{
	PushOptimizedScope();
	ParseOptimizeBlock(0);
	bool isEmpty = m_pCurrentScope->IsEmptyBlock;
	PopOptimizedScope(ThisTokenRange.m_stop);
	NextToken();
	return isEmpty;
}

bool Compiler::ParseIfTrue(const TEXTRANGE& messageRange)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol(u8"ifTrue:"));
		return false;
	}

	ip_t condJumpMark = GenJumpInstruction(OpCode::LongJumpIfFalse);
	AddTextMap(condJumpMark, messageRange);

	ParseZeroArgOptimizedBlock();

	// Need to jump over the false block at end of true block
	ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);
	ip_t elseMark = m_codePointer;

	if (ThisTokenText == u8"ifFalse:"s)
	{
		// An else block exists
		POTE oteSelector = AddSymbolToFrame(u8"ifTrue:ifFalse:"s, messageRange, LiteralType::ReferenceOnly);

		NextToken();

		ParseZeroArgOptimizedBlock();
	}
	else
	{
		// When #ifFalse: branch is missing, value of expression if condition false is nil
		
		POTE oteSelector = AddSymbolToFrame(u8"ifTrue:"s, messageRange, LiteralType::ReferenceOnly);

		GenInstruction(OpCode::ShortPushNil);
	}

	SetJumpTarget(jumpOutMark, GenNop());

	// Now the jump on condition
	SetJumpTarget(condJumpMark, elseMark);

	return true;
}

bool Compiler::ParseIfFalse(const TEXTRANGE& messageRange)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol(u8"ifFalse:"s));
		return false;
	}

	ip_t condJumpMark = GenJumpInstruction(OpCode::LongJumpIfTrue);
	AddTextMap(condJumpMark, messageRange);

	ParseZeroArgOptimizedBlock();

	// Need to jump over the false block at end of true block
	ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);
	ip_t elseMark = m_codePointer;

	if (ThisTokenText == u8"ifTrue:"s)
	{
		// An else block exists

		POTE oteSelector = AddSymbolToFrame(u8"ifFalse:ifTrue:"s, messageRange, LiteralType::ReferenceOnly);

		NextToken();

		ParseZeroArgOptimizedBlock();
	}
	else
	{
		// When ifTrue: branch is missing, value of expression if condition false is nil

		POTE oteSelector = AddSymbolToFrame(u8"ifFalse:"s, messageRange, LiteralType::ReferenceOnly);

		// N.B. We used (pre 5.5) to reorder the "blocks" to take advantage of the shorter jump on false
		// instruction (i.e. we put the empty true block first), but it turns out that this
		// apparent optimization is actually a bad idea since it seems to reduce the effectiveness
		// of the peephole optimizer. Here are some stats from an image with 34319 methods:
		//
		//	Methods affected:			1276
		//	Shorter with inversion:		182
		//	Shorter without inversion:	849 (1)
		//	Size of bytecodes with:		60268
		//	Size of bytecodes without:	58564 (2)
		//
		// i.e. more methods are lengthened by the apparent optimization than without it (1), and
		// the overall size of the methods is actually increased in most cases (2).

		GenInstruction(OpCode::ShortPushNil);
	}

	SetJumpTarget(jumpOutMark, GenNop());

	// Now the jump on condition
	SetJumpTarget(condJumpMark, elseMark);

	return true;
}

bool Compiler::ParseAndCondition(const TEXTRANGE& messageRange)
{
	POTE oteSelector = AddSymbolToFrame(u8"and:"s, messageRange, LiteralType::ReferenceOnly);

	// Assume we can reorder blocks to allow us to use the smaller
	// jump on false instruction.
	//
	
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}

	// If the receiver is false, then the whole expression is false, so 
	// jump over (shortcut) the block argument
	ip_t branchMark = GenJumpInstruction(OpCode::LongJumpIfFalse);
	AddTextMap(branchMark, messageRange);

	textpos_t blockStart = ThisTokenRange.m_start;
	if (ParseZeroArgOptimizedBlock())
	{
		CompileError(TEXTRANGE(blockStart, LastTokenRange.m_stop), CErrEmptyConditionBlock, (Oop)oteSelector);
		return false;
	}
	
	ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);
	
	SetJumpTarget(branchMark, GenInstruction(OpCode::ShortPushFalse));
	SetJumpTarget(jumpOutMark, GenNop());

	return true;
}

bool Compiler::ParseOrCondition(const TEXTRANGE& messageRange)
{
	POTE oteSelector = AddSymbolToFrame(u8"or:", messageRange, LiteralType::ReferenceOnly);

	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}

	// Note "reordering" to allow us to use the smaller
	// jump on false instruction. In the case of #or: this
	// seems to be worth doing, even if it isn't for #ifFalse:. It does
	// result in a small overall size reduction. Which has a speed
	// advantage is difficult to say.
	//
	ip_t branchMark = GenJumpInstruction(OpCode::LongJumpIfFalse);
	AddTextMap(branchMark, messageRange);

	GenInstruction(OpCode::ShortPushTrue);
	ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);

	ip_t ifFalse = m_codePointer;
	textpos_t blockStart = ThisTokenRange.m_start;
	if (ParseZeroArgOptimizedBlock())
	{
		CompileError(TEXTRANGE(blockStart, LastTokenRange.m_stop), CErrEmptyConditionBlock, (Oop)oteSelector);
		return false;
	}

	if (m_ok)
	{
		SetJumpTarget(branchMark, ifFalse);
		SetJumpTarget(jumpOutMark, GenNop());
	}

	return true;
}

bool Compiler::ParseIfNotNilBlock()
{
	if (!ThisTokenIsBinary('['))
	{
		CompileError(CErrExpectLiteralBlock);
		return false;
	}

	PushOptimizedScope();

	// We now allow either zero or one arguments to the ifNotNil: block
	//ParseOptimizeBlock(1);

	textpos_t nTextStart = ThisTokenRange.m_start;

	_ASSERTE(IsInOptimizedBlock);

	// Generate the body code for an optimized block
	NextToken();
	argcount_t argc = 0;
	while (m_ok && ThisTokenIsSpecial(':'))
	{
		if (NextToken() == TokenType::NameConst)
		{
			argc++;
			u8string tempName = ThisTokenText;
			CheckTemporaryName(tempName, ThisTokenRange, true);
			if (m_ok)
			{
				TempVarRef* pValueTempRef = AddOptimizedTemp(tempName, ThisTokenRange);
				GenPopAndStoreTemp(pValueTempRef);
			}
			NextToken();
		}
		else
			CompileError(CErrExpectVariable);
	}

	switch (argc)
	{
	case 0:
		// Zero arg block, we don't need the implicit arg so just discard it
		GenPopStack();
		break;

	case 1:
		m_ok = m_ok && ThisTokenIsBinary(TEMPSDELIMITER);
		NextToken();
		break;

	default:
		CompileError(TEXTRANGE(nTextStart, ThisTokenRange.m_stop), CErrTooManyIfNotNilBlockArgs);
		break;
	}
	
	if (m_ok)
	{
		// Temporarily commented out for interim release
		ParseTemporaries();
		
		ParseBlockStatements();
		if (m_ok && ThisTokenType != TokenType::CloseSquare)
			CompileError(TEXTRANGE(nTextStart, LastTokenRange.m_stop), CErrBlockNotClosed);
	}

	PopOptimizedScope(ThisTokenRange.m_stop);
	NextToken();

	return argc != 0;
}

bool Compiler::ParseIfNilBlock(bool noPop)
{
	PushOptimizedScope();
	if (!noPop)
		// Pop off the implicit argument, which is not needed
		GenPopStack();
	ParseOptimizeBlock(0);
	PopOptimizedScope(ThisTokenRange.m_stop);
	NextToken();
	return m_ok;
}

/*
Inlined forms of #ifNil:[ifNotNil:] and #ifNotNil:[ifNil:]

1) ifNil:

		dup
		jmp ifNotNil @notNil
		pop
		[block code]
	@notNil

2) ifNil:ifNotNil:
		dup
		jmp ifNotNil @notNil
		pop
		[ifnil block]
		jmp @exit
	@notNil
		pop'n'store temp
		[if not nil block]
	@exit

3) #ifNotNil:
		dup
		jmp ifNil @nil
		pop'n'store temp
		[if not nil block]
	@nil

4) #ifNotNil:#ifNil:
		dup
		jmp ifNil @nil
		pop 'n' store temp
		[if not nil block]
		jmp @exit
	@nil
		pop
		[if nil block]
	@exit
*/

bool Compiler::ParseIfNil(const TEXTRANGE& messageRange, textpos_t exprStartPos)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol(u8"ifNil:"));
		return false;
	}

	ip_t dupMark = GenDup();

	BreakPoint();

	// We're going to add a pop and jump on condition instruction here
	// Its a forward jump, so we need to patch up the target later
	const ip_t popAndJumpMark = GenJumpInstruction(OpCode::LongJumpIfNotNil);
	const size_t mapEntry = AddTextMap(popAndJumpMark, exprStartPos, LastTokenRange.m_stop);

	ParseIfNilBlock(false);
	
	ip_t ifNotNilMark;

	if (ThisTokenText == u8"ifNotNil:"s)
	{
		POTE oteSelector = AddSymbolToFrame(u8"ifNil:ifNotNil:"s, messageRange, LiteralType::ReferenceOnly);

		// Generate the jump out instruction (forward jump, so target not yet known)
		ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);

		// Mark first instruction of the "else" branch
		ifNotNilMark = m_codePointer;

		// #ifNil:ifNotNil: form
		NextToken();

		bool hasArg = ParseIfNotNilBlock();

		// Be careful, may not actually be a literal block there
		if (m_ok)
		{
			// If the ifNotNil: block does not need an argument, we can patch out the Dup
			// and corresponding pop
			if (!hasArg)
			{
				UngenInstruction(dupMark);
				_ASSERTE(m_bytecodes[popAndJumpMark + lengthOfByteCode(OpCode::LongJumpIfFalse)].Opcode == OpCode::PopStackTop);
				UngenInstruction(popAndJumpMark + lengthOfByteCode(OpCode::LongJumpIfFalse));
				_ASSERTE(m_bytecodes[ifNotNilMark].Opcode == OpCode::PopStackTop);
				UngenInstruction(ifNotNilMark);
			}

			// Set unconditional jump at the end of the ifNil to jump over the "else" branch to a Nop
			SetJumpTarget(jumpOutMark, GenNop());
		}
	}
	else
	{
		POTE oteSelector = AddSymbolToFrame(u8"ifNil:", messageRange, LiteralType::ReferenceOnly);

		// No "else" branch, but we still need an instruction to jump to
		ifNotNilMark = GenNop();
	}

	if (m_ok)
	{
		// Conditional jump to the "else" branch (or the Nop if no else branch)
		SetJumpTarget(popAndJumpMark, ifNotNilMark);

		if (mapEntry != -1)
			m_textMaps[mapEntry].stop = LastTokenRange.m_stop;
	}

	return true;
}

bool Compiler::ParseIfNotNil(const TEXTRANGE& messageRange, textpos_t exprStartPos)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectMonadicOrNiladicBlockArg, (Oop)InternSymbol(u8"ifNotNil:"));
		return false;
	}

	ip_t dupMark = GenDup();
	BreakPoint();

	// We're going to add a pop and jump on condition instruction here
	// Its a forward jump, so we need to patch up the target later
	const ip_t popAndJumpMark = GenJumpInstruction(OpCode::LongJumpIfNil);
	AddTextMap(popAndJumpMark, exprStartPos, LastTokenRange.m_stop);

	bool hasArg = ParseIfNotNilBlock();

	// If the ifNotNil: block did not have any arguments, then we do not need the Dup, and we also
	// need to patch out the corresponding pop.
	if (!hasArg)
	{
		UngenInstruction(dupMark);
		UngenInstruction(popAndJumpMark + lengthOfByteCode(OpCode::LongJumpIfTrue));
	}

	ip_t ifNilMark;

	// Has an #ifNil: branch?
	if (ThisTokenText == u8"ifNil:"s)
	{
		POTE oteSelector = AddSymbolToFrame(u8"ifNotNil:ifNil:"s, messageRange, LiteralType::ReferenceOnly);

		// Generate the jump out instruction (forward jump, so target not yet known)
		ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);

		// Mark first instruction of the "else" branch
		ifNilMark = m_codePointer;

		// ifNotNil:ifNil: form
		NextToken();

		ParseIfNilBlock(!hasArg);

		SetJumpTarget(jumpOutMark, GenNop());
	}
	else
	{
		// No "ifNil:" branch 

		POTE oteSelector = AddSymbolToFrame(u8"ifNotNil:"s, messageRange, LiteralType::ReferenceOnly);

		if (!hasArg)
		{
			// Since we've removed the Dup if the ifNotNil: block had no args, we need to ensure there is nil atop the stack
			// This should normally get optimized away later if the expression value is not used.

			// Generate the jump out instruction
			ip_t jumpOutMark = GenJumpInstruction(OpCode::LongJump);

			ifNilMark = GenInstruction(OpCode::ShortPushNil);

			SetJumpTarget(jumpOutMark, GenNop());
		}
		else
		{
			ifNilMark = GenNop();
		}
	}
	
	SetJumpTarget(popAndJumpMark, ifNilMark);
	
	return true;
}

// Inline an optimized block that was only detected after it had been generated
// (e.g. a #repeat block). This is very easy in D6 - all we need to do is 
// translate any far returns to method returns
void Compiler::InlineOptimizedBlock(ip_t nStart, ip_t nStop)
{
	ip_t i=nStart;
	while (i < nStop)
	{
		BYTECODE& bytecode=m_bytecodes[i];
		size_t len = bytecode.InstructionLength;
		
		switch(bytecode.Opcode)
		{
		case OpCode::BlockCopy:
			// We must skip any nested blocks
			_ASSERTE(bytecode.target > i+len);
			i = bytecode.target;
			_ASSERTE(m_bytecodes[i-1].IsReturn);
			break;

		case OpCode::FarReturn:
			if (!IsInBlock)
				bytecode.opcode = OpCode::ReturnMessageStackTop;
			// Drop through

		default:
			i += len;
			break;
		};
	}
}

Compiler::LoopReceiverType Compiler::InlineLoopBlock(const ip_t loopmark, const TEXTRANGE& tokenRange)
{
	const ip_t nPrior = m_codePointer-2;
	const BYTECODE& prior=m_bytecodes[nPrior]; // Nop following this instruction
	if (!prior.IsOpCode || prior.Opcode != OpCode::ReturnBlockStackTop || m_bytecodes[loopmark+1].Opcode != OpCode::BlockCopy)
	{
		// Receiver is not a literal block so do not use optimized loop block form
		return LoopReceiverType::Other;
	}

	// We have a block on the stack, remove its wrapper to leave
	// only the contained code, but first check that it is a niladic block
	BYTECODE& loopHead = m_bytecodes[loopmark];
	if (loopHead.pScope->ArgumentCount != 0)
	{
		// Receiver is not a niladic block so do not use optimized loop block form
		return LoopReceiverType::NonNiladicBlock;
	}

	if (loopHead.pScope->IsEmptyBlock)
	{
		return LoopReceiverType::EmptyBlock;
	}

	_ASSERTE(loopHead.Opcode == OpCode::Nop);
	ip_t firstInBlock = loopmark + 1 + BlockCopyInstructionSize;
	InlineOptimizedBlock(firstInBlock, nPrior);

	// Mark the scope as being optimized
	_ASSERTE(loopHead.Opcode == OpCode::Nop);
	loopHead.pScope->BeOptimizedBlock();

	UngenInstruction(loopmark+1);		// BlockCopy (multi-byte instruction)
	_ASSERTE(nPrior == m_codePointer-2);
	_ASSERTE(prior.Opcode == OpCode::ReturnBlockStackTop);
	VERIFY(RemoveTextMapEntry(nPrior));
	UngenInstruction(nPrior);	// Return block stack top
	// If a debug method, also Nop out the breakpoint before the return instruction
	if (WantDebugMethod)
	{
		_ASSERTE(m_bytecodes[nPrior-1].Opcode == OpCode::Break);
		UngenInstruction(nPrior-1);
	}

	return LoopReceiverType::NiladicBlock;
}

bool Compiler::ParseRepeatLoop(const ip_t loopmark, const TEXTRANGE& receiverRange)
{
	// We add a literal symbol to the frame for the message send regardless of 
	// whether we are able to generate the inlined version so that searching
	// for references, etc, works as expected.
	POTE oteSelector = AddSymbolToFrame(ThisTokenText, ThisTokenRange, LiteralType::ReferenceOnly);

	switch (InlineLoopBlock(loopmark, ThisTokenRange))
	{
	case LoopReceiverType::NonNiladicBlock:
	case LoopReceiverType::Other:
		Warning(receiverRange, CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;
	}

	// Throw away the result of the block evaluation
	GenPopStack();
	
	// #repeat is very simple we just unconditionally jump back to the start again
	GenJump(OpCode::LongJump, loopmark);

	return true;
}


POTE Compiler::AddSymbolToFrame(const u8string& s, const TEXTRANGE& tokenRange, LiteralType type)
{
	POTE oteSelector = InternSymbol(s);
	AddToFrame(reinterpret_cast<Oop>(oteSelector), tokenRange, type);
	return oteSelector;
}

// Return whether we it was suitable to optimize this loop block
template <bool WhileTrue> bool Compiler::ParseWhileLoopBlock(const ip_t loopmark, 
								   const TEXTRANGE& tokenRange, const TEXTRANGE& receiverRange)
{
	POTE oteSelector = AddSymbolToFrame(WhileTrue ? u8"whileTrue:" : u8"whileFalse:", tokenRange, LiteralType::ReferenceOnly);

	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}

	switch (InlineLoopBlock(loopmark, tokenRange))
	{
	case LoopReceiverType::NonNiladicBlock:
	case LoopReceiverType::Other:
		Warning(receiverRange, CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;

	case LoopReceiverType::EmptyBlock:
		CompileError(receiverRange, CErrEmptyConditionBlock, (Oop)oteSelector);
		return false;
	}

	// We've generated (and inlined) the loop condition block already
	// Now we need to insert conditional jump over the loop body block which should
	// be taken if the condition is false if a while true loop, or true if a while
	// false loop (since it is the jump out)

	// To have a breakpoint on the loop condition check uncomment the breakpoint and the text map lines marked with *1*
	//BreakPoint(); // *1*
	const OpCode popAndJumpInstruction = WhileTrue ? OpCode::LongJumpIfFalse : OpCode::LongJumpIfTrue;
	ip_t condJumpMark = GenJumpInstruction(popAndJumpInstruction);
	// We need a text map entry for the loop jump in case a mustBeBoolean error gets raised here
	size_t nLoopTextMap = AddTextMap(condJumpMark, tokenRange);// *1* textStart, LastTokenRange.m_stop);


	// Parse the loop body
	{
		PushOptimizedScope();

		// Parse the loop body ...
		ParseOptimizeBlock(0);

		PopOptimizedScope(ThisTokenRange.m_stop);

		//... and ignore its result
		GenPopStack();
		NextToken();
	}	

	// Unconditionally jump back to the loop condition
	ip_t jumpPos = GenJump(OpCode::LongJump, loopmark);

	//if (WantTextMap()) m_textMaps[nLoopTextMap].stop = LastTokenRange.m_stop;	// *1*

	// Return Nil
	ip_t exitMark = GenInstruction(OpCode::ShortPushNil);

	// We can now set the target of the forward conditional jump
	SetJumpTarget(condJumpMark, exitMark);

	return true;
}

// Returns whether we were able to optimize this loop
template <bool WhileTrue> bool Compiler::ParseWhileLoop(const ip_t loopmark, const TEXTRANGE& receiverRange)
{
	POTE oteSelector = AddSymbolToFrame(ThisTokenText, ThisTokenRange, LiteralType::ReferenceOnly);

	switch (InlineLoopBlock(loopmark, ThisTokenRange))
	{
	case LoopReceiverType::NonNiladicBlock:
	case LoopReceiverType::Other:
		Warning(receiverRange, CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;

	case LoopReceiverType::EmptyBlock:
		CompileError(receiverRange, CErrEmptyConditionBlock, (Oop)oteSelector);
		return false;
	}

	// #whileTrue/#whileFalse is very simple to inline - we only need one conditional jump at the end
	// after the condition block

	ip_t jumpPos = GenJump(WhileTrue ? OpCode::LongJumpIfTrue : OpCode::LongJumpIfFalse, loopmark);
	AddTextMap(jumpPos, ThisTokenRange);

	// Result of a #whileTrue/#whileFalse should be nil
	GenInstruction(OpCode::ShortPushNil);

	return true;
}

TempVarRef* Compiler::AddOptimizedTemp(const u8string& tempName, const TEXTRANGE& range)
{
	_ASSERTE(m_pCurrentScope->IsOptimizedBlock);
	TempVarDecl* pDecl = AddTemporary(tempName, range, false);
	pDecl->BeReadOnly();
	return m_pCurrentScope->AddTempRef(pDecl, VarRefType::Write, range);
}

void Compiler::ParseToByNumberDo(ip_t toPointer, Oop oopNumber, bool bNegativeStep)
{
	PushOptimizedScope();
	
	// Add an "each". This should be at the top of the temporary stack as it is taken over by the do: block
	TempVarRef* pEachTempRef = AddOptimizedTemp(eachTempName);
	
	// Start to generate bytecodes

	// First we must store that from value into our 'each' counter variable/argument. This involves
	// stepping back a bit ...
	_ASSERTE(toPointer < m_codePointer);
	ip_t currentPos = m_codePointer;
	m_codePointer = toPointer;
	// Note we store so leaving the value on the stack as the result of the whole expression
	GenStoreTemp(pEachTempRef);
	m_codePointer = currentPos + m_bytecodes[toPointer].InstructionLength;
	
	// Dup the to: value
	GenDup();
	// And push the from value
	GenPushTemp(pEachTempRef);

	// We must jump over the block to the test first time through
	ip_t jumpOver = GenJumpInstruction(OpCode::LongJump);

	ip_t loopHead = m_codePointer;

	// Parse the one argument block.
	// Leave nothing on the stack, expect 1 argument
	ParseOptimizeBlock(1);

	// Pop off the result of the optimized block
	GenPopStack();
	
	GenDup();
	GenPushTemp(pEachTempRef);
	// If the step is 1/-1, this will be optimised down to Increment/Decrement
	GenNumber(oopNumber, LastTokenRange);
	ip_t add = GenInstruction(OpCode::SendArithmeticAdd);
	ip_t store = GenStoreTemp(pEachTempRef);

	ip_t comparePointer = m_codePointer;
	
	if (bNegativeStep)
		GenInstruction(OpCode::SendArithmeticGT);
	else
		// Note that < is the best message to send, since it is normally directly implemented
		GenInstruction(OpCode::SendArithmeticLT);

	GenJump(OpCode::LongJumpIfFalse, loopHead);

	// Pop the to: value
	GenPopStack();

	SetJumpTarget(jumpOver, comparePointer);

	TODO("Is this in the right place? What is the last real IP of the loop");
	PopOptimizedScope(ThisTokenRange.m_stop);
	NextToken();
}

// produce optimized form of to:do: message
bool Compiler::ParseToDoBlock(textpos_t exprStart, ip_t toPointer)
{
	POTE oteSelector = AddSymbolToFrame(u8"to:do:", TEXTRANGE(exprStart, exprStart + 2), LiteralType::ReferenceOnly);

	// Only optimize if a block is next
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectMonadicBlockArg, (Oop)oteSelector);
		return false;
	}
	
	ParseToByNumberDo(toPointer, IntegerObjectOf(1), false);
	return true;
}

// Produce optimized form of to:by:do: message
bool Compiler::ParseToByDoBlock(textpos_t exprStart, ip_t toPointer, ip_t byPointer)
{
	_ASSERTE(toPointer>ip_t::zero && byPointer>ip_t::zero);
	
	POTE oteSelector = AddSymbolToFrame(u8"to:by:do:", TEXTRANGE(exprStart, exprStart +2), LiteralType::ReferenceOnly);

	// Only optimize if a block is next
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectMonadicBlockArg, (Oop)oteSelector);
		return false;
	}

	Oop oopStep = LastIsPushNumber();
	if (oopStep != NULL)
	{
		GenPopStack();	// Pop off the "by" argument

		bool bNegativeStep;
		if (IsIntegerObject(oopStep))
			bNegativeStep = IntegerValueOf(oopStep) < 0;
		else
		{
			POTE stepClass = FetchClassOf((POTE)oopStep);
			if (stepClass == GetVMPointers().ClassFloat)
			{
				double* pfValue = reinterpret_cast<double*>(FetchBytesOf(reinterpret_cast<POTE>(oopStep)));
				bNegativeStep = *pfValue < 0;
			}
			else
			{
				// Have to call into Smalltalk to find out if it is negative
				Oop oopIsNegative = m_piVM->Perform(oopStep, GetVMPointers().negativeSelector);
				bNegativeStep = oopIsNegative == reinterpret_cast<Oop>(GetVMPointers().True);
			}
		}

		ParseToByNumberDo(toPointer, oopStep, bNegativeStep);
		return true;
	}
	
	return false;
}

// Produce optimized form of timesRepeat: [...].
// Returns true if optimization performed.
// Note that we perform the conditional jump as a backwards jump at the end for optimal performance
bool Compiler::ParseTimesRepeatLoop(const TEXTRANGE& messageRange, const textpos_t textPosition)
{
	POTE oteSelector = AddSymbolToFrame(u8"timesRepeat:", messageRange, LiteralType::ReferenceOnly);

	if (!ThisTokenIsBinary('['))
	{
		Warning(messageRange, CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}
	
	// Can apply extra optimizations if receiver is known SmallInteger
	intptr_t loopTimes=0;
	bool isIntReceiver = LastIsPushSmallInteger(loopTimes);

	ip_t startMark = GenDup();

	ip_t jumpOver = GenJumpInstruction(OpCode::LongJump);
	ip_t loopHead = m_codePointer;
	
	PushOptimizedScope();
	
	// Parse the loop block and ignore its result
	ParseOptimizeBlock(0);
	GenPopStack();
	PopOptimizedScope(ThisTokenRange.m_stop);
	NextToken();

	if (isIntReceiver && loopTimes <= 0)
	{
		// Blank out all our bytecodes if we have 0 or less loops
		const ip_t loopEnd = m_codePointer;
		for (ip_t p = startMark; p < loopEnd; p++)
			UngenInstruction(p);

		return true;
	}

	// Decrement counter
	GenInstruction(OpCode::DecrementStackTop);

	// Dup counter for compare
	ip_t testMark = GenDup();

	// Fill in forward unconditional jump before the head of the loop
	// which jumps to the conditional test
	SetJumpTarget(jumpOver, testMark);

	if (isIntReceiver)
	{
		// Using IsZero speeds up empty loop by about 5%.
		_ASSERTE(loopTimes > 0);
		GenInstruction(OpCode::IsZero);
	}
	else
	{
		// Test for another run around the wheel - favour use of #<, therefore need to test against 1 rather than 0
		GenInteger(1, TEXTRANGE());

		// No breakpoint wanted here
		//GenMessage("<", 1);
		GenInstruction(OpCode::SendArithmeticLT);
	}

	// Conditional jump back to loop head
	GenJump(OpCode::LongJumpIfFalse, loopHead);

	// Pop off the loop counter, leaving the integer receiver on the stack
	GenPopStack();
	
	return true;
}

// Parse the loop block and ignore its result
void Compiler::ParseOptimizeBlock(argcount_t arguments)
{
	if (!ThisTokenIsBinary('['))
	{
		CompileError(CErrExpectLiteralBlock);
		return;
	}

	textpos_t nTextStart = ThisTokenRange.m_start;

	_ASSERTE(IsInOptimizedBlock);

	// Parse the arguments - note we parse them anyway, regardless of whether they are wanted, 
	// and subsequently complain if there are too many
	NextToken();
	argcount_t argument = 0;
	while (m_ok && ThisTokenIsSpecial(':') )
	{
		if (NextToken() == TokenType::NameConst)
		{
			u8string argName = ThisTokenText;
			if (argument < arguments)
				RenameTemporary(argument, argName, ThisTokenRange);
			else
				AddTemporary(argName, ThisTokenRange, true);
			argument++;
			NextToken();
		}
		else
			CompileError(CErrExpectVariable);
	}

	textpos_t argBar = textpos_t::npos;
	if (m_ok && argument > 0)
	{
		if (ThisTokenIsBinary(TEMPSDELIMITER))
		{
			argBar = ThisTokenRange.m_stop;
			NextToken();
		}
		else
		{
			CompileError(TEXTRANGE(nTextStart, LastTokenRange.m_stop), CErrBlockArgListNotClosed);
		}
	}

	if (m_ok)
	{
		// Temporarily commented out for interim release
		ParseTemporaries();
		
		ParseBlockStatements();
		if (m_ok && ThisTokenType != TokenType::CloseSquare)
			CompileError(TEXTRANGE(nTextStart, LastTokenRange.m_stop), CErrBlockNotClosed);
	}
	
	if (m_ok && argument != arguments)
		CompileError(TEXTRANGE(nTextStart, argBar < textpos_t::start ? ThisTokenRange.m_stop : argBar), CErrIncorrectBlockArgCount);
}

