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

///////////////////////////////////////////////////////////////////////////////
// When inlining code the compiler sometimes has to generate temporaries. It prefixes
// these with a space so that the names cannot possibly clash with user defined temps
static const char eachTempName[] = GENERATEDTEMPSTART "each";
static const char valueTempName[] = GENERATEDTEMPSTART "value";

///////////////////////////////////////////////////////////////////////////////

void Compiler::PopOptimizedScope(int textStop)
{
	PopScope(textStop);
}

void Compiler::ParseZeroArgOptimizedBlock()
{
	PushOptimizedScope();
	ParseOptimizeBlock(0);
	PopOptimizedScope(ThisTokenRange().m_stop);
	NextToken();
}

bool Compiler::ParseIfTrue(const TEXTRANGE& messageRange)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol("ifTrue:"));
		return false;
	}

	int condJumpMark = GenJumpInstruction(LongJumpIfFalse);
	AddTextMap(condJumpMark, messageRange);

	ParseZeroArgOptimizedBlock();

	// Need to jump over the false block at end of true block
	int jumpOutMark = GenJumpInstruction(LongJump);
	int elseMark = m_codePointer;

	if (strcmp(ThisTokenText(), "ifFalse:") == 0)
	{
		// An else block exists
		POTE oteSelector = AddSymbolToFrame("ifTrue:ifFalse:", messageRange);

		NextToken();

		ParseZeroArgOptimizedBlock();
	}
	else
	{
		// When #ifFalse: branch is missing, value of expression if condition false is nil
		
		POTE oteSelector = AddSymbolToFrame("ifTrue:", messageRange);

		GenInstruction(ShortPushNil);
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
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol("ifFalse:"));
		return false;
	}

	int condJumpMark = GenJumpInstruction(LongJumpIfTrue);
	AddTextMap(condJumpMark, messageRange);

	ParseZeroArgOptimizedBlock();

	// Need to jump over the false block at end of true block
	int jumpOutMark = GenJumpInstruction(LongJump);
	int elseMark = m_codePointer;

	if (strcmp(ThisTokenText(), "ifTrue:") == 0)
	{
		// An else block exists

		POTE oteSelector = AddSymbolToFrame("ifFalse:ifTrue:", messageRange);

		NextToken();

		ParseZeroArgOptimizedBlock();
	}
	else
	{
		// When ifTrue: branch is missing, value of expression if condition false is nil

		POTE oteSelector = AddSymbolToFrame("ifFalse:", messageRange);

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

		GenInstruction(ShortPushNil);
	}

	SetJumpTarget(jumpOutMark, GenNop());

	// Now the jump on condition
	SetJumpTarget(condJumpMark, elseMark);

	return true;
}

bool Compiler::ParseAndCondition(const TEXTRANGE& messageRange)
{
	POTE oteSelector = AddSymbolToFrame("and:", messageRange);

	// Assume we can reorder blocks to allow us to use the smaller
	// jump on false instruction.
	//
	int popAndJumpInstruction=LongJumpIfFalse;
	
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}

	// If the receiver is false, then the whole expression is false, so 
	// jump over (shortcut) the block argument
	int branchMark = GenJumpInstruction(LongJumpIfFalse);
	AddTextMap(branchMark, messageRange);

	ParseZeroArgOptimizedBlock();
	
	int jumpOutMark = GenJumpInstruction(LongJump);
	
	SetJumpTarget(branchMark, GenInstruction(ShortPushFalse));
	SetJumpTarget(jumpOutMark, GenNop());

	return true;
}

bool Compiler::ParseOrCondition(const TEXTRANGE& messageRange)
{
	POTE oteSelector = AddSymbolToFrame("or:", messageRange);

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
	int branchMark = GenJumpInstruction(LongJumpIfFalse);
	AddTextMap(branchMark, messageRange);

	GenInstruction(ShortPushTrue);
	int jumpOutMark = GenJumpInstruction(LongJump);

	int ifFalse = m_codePointer;
	ParseZeroArgOptimizedBlock();
	
	if (m_ok)
	{
		SetJumpTarget(branchMark, ifFalse);
		SetJumpTarget(jumpOutMark, GenNop());
	}

	return true;
}

int Compiler::ParseIfNotNilBlock()
{
	if (!ThisTokenIsBinary('['))
	{
		CompileError(CErrExpectLiteralBlock);
		return 0;
	}

	PushOptimizedScope();

	// We now allow either zero or one arguments to the ifNotNil: block
	//ParseOptimizeBlock(1);

	int nTextStart = ThisTokenRange().m_start;

	_ASSERTE(IsInOptimizedBlock());

	// Generate the body code for an optimized block
	NextToken();
	int argc = 0;
	while (m_ok && ThisTokenIsSpecial(':'))
	{
		if (NextToken() == NameConst)
		{
			argc++;
			CheckTemporaryName(ThisTokenText(), ThisTokenRange(), true);
			if (m_ok)
			{
				TempVarRef* pValueTempRef = AddOptimizedTemp(ThisTokenText(), ThisTokenRange());
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
		CompileError(TEXTRANGE(nTextStart, ThisTokenRange().m_stop), CErrTooManyIfNotNilBlockArgs);
		break;
	}
	
	int nBlockTemps = 0;
	if (m_ok)
	{
		// Temporarily commented out for interim release
		ParseTemporaries();
		
		ParseBlockStatements();
		if (m_ok && ThisToken() != CloseSquare)
			CompileError(TEXTRANGE(nTextStart, LastTokenRange().m_stop), CErrBlockNotClosed);
	}

	PopOptimizedScope(ThisTokenRange().m_stop);
	NextToken();

	return argc;
}

bool Compiler::ParseIfNilBlock(bool noPop)
{
	PushOptimizedScope();
	if (!noPop)
		// Pop off the implicit argument, which is not needed
		GenPopStack();
	ParseOptimizeBlock(0);
	PopOptimizedScope(ThisTokenRange().m_stop);
	NextToken();
	return m_ok;
}

/*
Inlined forms of #ifNil:[ifNotNil:] and #ifNotNil:[ifNil:]

Note that if we use SpecialSendIsNil followed by normal conditional jump, then we still 
need to dup stack top because isNil will consume the value which we'll need. However we
generate the long form and let the optimizer convert to the conditional jump on nil if 
possible. We have to do this because the isNil/notNil jumps do not have a long form and 
our code generator must start with long jumps which are optimized down in OptimizeJumps().

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

bool Compiler::ParseIfNil(const TEXTRANGE& messageRange, int exprStartPos)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)InternSymbol("ifNil:"));
		return false;
	}

	int dupMark = GenDup();

	BreakPoint();
	const int sendIsNil = GenInstruction(SpecialSendIsNil);
	const int mapEntry = AddTextMap(sendIsNil, exprStartPos, LastTokenRange().m_stop);

	// We're going to add a pop and jump on condition instruction here
	// Its a forward jump, so we need to patch up the target later
	const int popAndJumpMark = GenJumpInstruction(LongJumpIfFalse);

	ParseIfNilBlock(false);
	
	int ifNotNilMark;

	if (strcmp(ThisTokenText(), "ifNotNil:") == 0)
	{
		POTE oteSelector = AddSymbolToFrame("ifNil:ifNotNil:", messageRange);

		// Generate the jump out instruction (forward jump, so target not yet known)
		int jumpOutMark = GenJumpInstruction(LongJump);

		// Mark first instruction of the "else" branch
		ifNotNilMark = m_codePointer;

		// #ifNil:ifNotNil: form
		NextToken();

		int argc = ParseIfNotNilBlock();

		// Be careful, may not actually be a literal block there
		if (m_ok)
		{
			// If the ifNotNil: block does not need an argument, we can patch out the Dup
			// and corresponding pop
			if (!argc)
			{
				UngenInstruction(dupMark);
				_ASSERTE(m_bytecodes[popAndJumpMark + lengthOfByteCode(LongJumpIfFalse)].byte == PopStackTop);
				UngenInstruction(popAndJumpMark + lengthOfByteCode(LongJumpIfFalse));
				_ASSERTE(m_bytecodes[ifNotNilMark].byte == PopStackTop);
				UngenInstruction(ifNotNilMark);
			}

			// Set unconditional jump at the end of the ifNil to jump over the "else" branch to a Nop
			SetJumpTarget(jumpOutMark, GenNop());
		}
	}
	else
	{
		POTE oteSelector = AddSymbolToFrame("ifNil:", messageRange);

		// No "else" branch, but we still need an instruction to jump to
		ifNotNilMark = GenNop();
	}

	if (m_ok)
	{
		// Conditional jump to the "else" branch (or the Nop if no else branch)
		SetJumpTarget(popAndJumpMark, ifNotNilMark);

		if (mapEntry >= 0)
			m_textMaps[mapEntry].stop = LastTokenRange().m_stop;
	}

	return true;
}

bool Compiler::ParseIfNotNil(const TEXTRANGE& messageRange, int exprStartPos)
{
	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectMonadicOrNiladicBlockArg, (Oop)InternSymbol("ifNotNil:"));
		return false;
	}

	int dupMark = GenDup();
	BreakPoint();
	const int sendIsNil = GenInstruction(SpecialSendIsNil);
	AddTextMap(sendIsNil, exprStartPos, LastTokenRange().m_stop);

	// We're going to add a pop and jump on condition instruction here
	// Its a forward jump, so we need to patch up the target later
	const int popAndJumpMark = GenJumpInstruction(LongJumpIfTrue);
	int argc = ParseIfNotNilBlock();

	// If the ifNotNil: block did not have any arguments, then we do not need the Dup, and we also
	// need to patch out the corresponding pop.
	if (!argc)
	{
		UngenInstruction(dupMark);
		UngenInstruction(popAndJumpMark + lengthOfByteCode(LongJumpIfTrue));
	}

	int ifNilMark;

	// Has an #ifNil: branch?
	if (strcmp(ThisTokenText(), "ifNil:") == 0)
	{
		POTE oteSelector = AddSymbolToFrame("ifNotNil:ifNil:", messageRange);

		// Generate the jump out instruction (forward jump, so target not yet known)
		int jumpOutMark = GenJumpInstruction(LongJump);

		// Mark first instruction of the "else" branch
		ifNilMark = m_codePointer;

		// ifNotNil:ifNil: form
		NextToken();

		ParseIfNilBlock(!argc);

		SetJumpTarget(jumpOutMark, GenNop());
	}
	else
	{
		// No "ifNil:" branch 

		POTE oteSelector = AddSymbolToFrame("ifNotNil:", messageRange);

		if (!argc)
		{
			// Since we've removed the Dup if the ifNotNil: block had no args, we need to ensure there is nil atop the stack
			// This should normally get optimized away later if the expression value is not used.

			// Generate the jump out instruction
			int jumpOutMark = GenJumpInstruction(LongJump);

			ifNilMark = GenInstruction(ShortPushNil);

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
void Compiler::InlineOptimizedBlock(int nStart, int nStop)
{
	int i=nStart;
	while (i < nStop)
	{
		BYTECODE& bytecode=m_bytecodes[i];
		_ASSERTE(bytecode.isOpCode());
		int len = bytecode.instructionLength();
		
		switch(bytecode.byte)
		{
		case BlockCopy:
			// We must skip any nested blocks
			_ASSERTE(bytecode.target > i+len);
			i = bytecode.target;
			_ASSERTE(m_bytecodes[i-1].isReturn());
			break;

		case FarReturn:
			if (!IsInBlock())
				bytecode.byte = ReturnMessageStackTop;
			// Drop through

		default:
			i += len;
			break;
		};
	}
}

bool Compiler::InlineLoopBlock(const int loopmark, const TEXTRANGE& tokenRange)
{
	const int nPrior = m_codePointer-2;
	BYTECODE& prior=m_bytecodes[nPrior]; // Nop following this instruction
	if (!prior.isOpCode() || prior.byte != ReturnBlockStackTop || m_bytecodes[loopmark+1].byte != BlockCopy)
	{
		// Receiver is not a literal block so do not use optimized loop block form
		return false;
	}

	// We have a block on the stack, remove its wrapper to leave
	// only the contained code, but first check that it is a niladic block
	BYTECODE& loopHead = m_bytecodes[loopmark];
	if (loopHead.pScope->GetArgumentCount() != 0)
	{
		// Receiver is not a literal block so do not use optimized loop block form
		return false;
	}

	_ASSERTE(loopHead.byte == Nop);
	InlineOptimizedBlock(loopmark+1+BlockCopyInstructionSize, nPrior);

	// Mark the scope as being optimized
	_ASSERTE(loopHead.byte == Nop);
	loopHead.pScope->BeOptimizedBlock();

	UngenInstruction(loopmark+1);		// BlockCopy (multi-byte instruction)
	_ASSERTE(nPrior == m_codePointer-2);
	_ASSERTE(prior.byte == ReturnBlockStackTop);
	VERIFY(RemoveTextMapEntry(nPrior));
	UngenInstruction(nPrior);	// Return block stack top
	// If a debug method, also Nop out the breakpoint before the return instruction
	if (WantDebugMethod())
	{
		_ASSERTE(m_bytecodes[nPrior-1].byte == Break);
		UngenInstruction(nPrior-1);
	}
	return true;
}

bool Compiler::ParseRepeatLoop(const int loopmark)
{
	// We add a literal symbol to the frame for the message send regardless of 
	// whether we are able to generate the inlined version so that searching
	// for references, etc, works as expected.
	POTE oteSelector = AddSymbolToFrame(ThisTokenText(), ThisTokenRange());

	if (!InlineLoopBlock(loopmark, ThisTokenRange()))
	{
		Warning(ThisTokenRange(), CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;
	}

	// Throw away the result of the block evaluation
	GenPopStack();
	
	// #repeat is very simple we just unconditionally jump back to the start again
	GenJump(LongJump, loopmark);

	return true;
}

POTE Compiler::AddSymbolToFrame(const char* s, const TEXTRANGE& tokenRange)
{
	POTE oteSelector = InternSymbol(s);
	AddToFrame(reinterpret_cast<Oop>(oteSelector), tokenRange);
	return oteSelector;
}


// Return whether we it was suitable to optimize this loop block
bool Compiler::ParseWhileLoopBlock(const bool bIsWhileTrue, const int loopmark, 
								   const TEXTRANGE& tokenRange, const int textStart)
{
	POTE oteSelector = AddSymbolToFrame(bIsWhileTrue ? "whileTrue:" : "whileFalse:", tokenRange);

	if (!ThisTokenIsBinary('['))
	{
		Warning(CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}

	if (!InlineLoopBlock(loopmark, tokenRange))
	{
		Warning(tokenRange, CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;
	}

	// We've generated (and inlined) the loop condition block already
	// Now we need to insert conditional jump over the loop body block which should
	// be taken if the condition is false if a while true loop, or true if a while
	// false loop (since it is the jump out)

	// To have a breakpoint on the loop condition check uncomment the breakpoint and the text map lines marked with *1*
	//BreakPoint(); // *1*
	const int popAndJumpInstruction = bIsWhileTrue ? LongJumpIfFalse : LongJumpIfTrue;
	int condJumpMark = GenJumpInstruction(popAndJumpInstruction);
	// We need a text map entry for the loop jump in case a mustBeBoolean error gets raised here
	int nLoopTextMap = AddTextMap(condJumpMark, tokenRange);// *1* textStart, LastTokenRange().m_stop);


	// Parse the loop body
	{
		PushOptimizedScope();

		// Parse the loop body ...
		ParseOptimizeBlock(0);

		PopOptimizedScope(ThisTokenRange().m_stop);

		//... and ignore its result
		GenPopStack();
		NextToken();
	}	

	// Unconditionally jump back to the loop condition
	int jumpPos = GenJump(LongJump, loopmark);

	//if (WantTextMap()) m_textMaps[nLoopTextMap].stop = LastTokenRange().m_stop;	// *1*

	// Return Nil
	int exitMark = GenInstruction(ShortPushNil);

	// We can now set the target of the forward conditional jump
	SetJumpTarget(condJumpMark, exitMark);

	return true;
}

// Returns whether we were able to optimize this loop
bool Compiler::ParseWhileLoop(bool bWhileTrue, const int loopmark)
{
	POTE oteSelector = AddSymbolToFrame(ThisTokenText(), ThisTokenRange());

	if (!InlineLoopBlock(loopmark, ThisTokenRange()))
	{
		Warning(ThisTokenRange(), CWarnExpectNiladicBlockReceiver, (Oop)oteSelector);
		return false;
	}

	// #whileTrue/#whileFalse is very simple to inline - we only need one conditional jump at the end
	// after the condition block

	int jumpPos = GenJump(bWhileTrue ? LongJumpIfTrue : LongJumpIfFalse, loopmark);
	AddTextMap(jumpPos, ThisTokenRange());

	// Result of a #whileTrue/#whileFalse should be nil
	GenInstruction(ShortPushNil);

	return true;
}

TempVarRef* Compiler::AddOptimizedTemp(const Str& tempName, const TEXTRANGE& range)
{
	_ASSERTE(m_pCurrentScope->IsOptimizedBlock());
	TempVarDecl* pDecl = AddTemporary(tempName, range, false);
	pDecl->BeReadOnly();
	return m_pCurrentScope->AddTempRef(pDecl, vrtWrite, range);
}

void Compiler::ParseToByNumberDo(int toPointer, Oop oopNumber, bool bNegativeStep)
{
	PushOptimizedScope();
	
	// Add an "each". This should be at the top of the temporary stack as it is taken over by the do: block
	TempVarRef* pEachTempRef = AddOptimizedTemp(eachTempName);
	
	// Start to generate bytecodes

	// First we must store that from value into our 'each' counter variable/argument. This involves
	// stepping back a bit ...
	_ASSERTE(toPointer < m_codePointer);
	int currentPos = m_codePointer;
	m_codePointer = toPointer;
	// Note we store so leaving the value on the stack as the result of the whole expression
	GenStoreTemp(pEachTempRef);
	m_codePointer = currentPos + m_bytecodes[toPointer].instructionLength();
	
	// Dup the to: value
	GenDup();
	// And push the from value
	GenPushTemp(pEachTempRef);

	// We must jump over the block to the test first time through
	int jumpOver = GenJumpInstruction(LongJump);

	int loopHead = m_codePointer;

	// Parse the one argument block.
	// Leave nothing on the stack, expect 1 argument
	ParseOptimizeBlock(1);

	// Pop off the result of the optimized block
	GenPopStack();
	
	GenDup();
	GenPushTemp(pEachTempRef);
	// If the step is 1/-1, this will be optimised down to Increment/Decrement
	GenNumber(oopNumber, LastTokenRange());
	int add = GenInstruction(SendArithmeticAdd);
	int store = GenStoreTemp(pEachTempRef);

	int comparePointer = m_codePointer;
	
	if (bNegativeStep)
		GenInstruction(SendArithmeticGT);
	else
		// Note that < is the best message to send, since it is normally directly implemented
		GenInstruction(SendArithmeticLT);

	GenJump(LongJumpIfFalse, loopHead);

	// Pop the to: value
	GenPopStack();

	SetJumpTarget(jumpOver, comparePointer);

	TODO("Is this in the right place? What is the last real IP of the loop");
	PopOptimizedScope(ThisTokenRange().m_stop);
	NextToken();
}

// produce optimized form of to:do: message
bool Compiler::ParseToDoBlock(int exprStart, int toPointer)
{
	POTE oteSelector = AddSymbolToFrame("to:do:", TEXTRANGE(toPointer, toPointer + 2));

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
bool Compiler::ParseToByDoBlock(int exprStart, int toPointer, int byPointer)
{
	_ASSERTE(toPointer>0 && byPointer>0);
	
	POTE oteSelector = AddSymbolToFrame("to:by:do:", TEXTRANGE(toPointer, toPointer+2));

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
			POTE stepClass = m_piVM->FetchClassOf(oopStep);
			if (stepClass == GetVMPointers().ClassFloat)
			{
				double* pfValue = reinterpret_cast<double*>(FetchBytesOf(reinterpret_cast<POTE>(oopStep)));
				bNegativeStep = *pfValue < 0;
			}
			else
			{
				// Have to call into Smalltalk to find out if it is negative
				Oop oopIsNegative = m_piVM->Perform(oopStep, GetVMPointers().negativeSymbol);
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
bool Compiler::ParseTimesRepeatLoop(const TEXTRANGE& messageRange)
{
	POTE oteSelector = AddSymbolToFrame("timesRepeat:", messageRange);

	if (!ThisTokenIsBinary('['))
	{
		Warning(messageRange, CWarnExpectNiladicBlockArg, (Oop)oteSelector);
		return false;
	}
	
	// Can apply extra optimizations if receiver is known SmallInteger
	int loopTimes=0;
	bool isIntReceiver = LastIsPushSmallInteger(loopTimes);

	int startMark = GenDup();

	int jumpOver = GenJumpInstruction(LongJump);
	int loopHead = m_codePointer;
	
	PushOptimizedScope();
	
	// Parse the loop block and ignore its result
	ParseOptimizeBlock(0);
	GenPopStack();
	PopOptimizedScope(ThisTokenRange().m_stop);
	NextToken();

	if (isIntReceiver && loopTimes <= 0)
	{
		// Blank out all our bytecodes if we have 0 or less loops
		const int loopEnd = m_codePointer;
		for (int p = startMark; p < loopEnd; p++)
			UngenInstruction(p);

		return true;
	}

	// Decrement counter
	GenInstruction(DecrementStackTop);

	// Dup counter for compare
	int testMark = GenDup();

	// Fill in forward unconditional jump before the head of the loop
	// which jumps to the conditional test
	SetJumpTarget(jumpOver, testMark);

	if (isIntReceiver)
	{
		// Using IsZero speeds up empty loop by about 5%.
		_ASSERTE(loopTimes > 0);
		GenInstruction(SpecialSendIsZero);
	}
	else
	{
		// Test for another run around the wheel - favour use of #<, therefore need to test against 1 rather than 0
		GenInteger(1, TEXTRANGE());

		// No breakpoint wanted here
		//GenMessage("<", 1);
		GenInstruction(SendArithmeticLT);
	}

	// Conditional jump back to loop head
	GenJump(LongJumpIfFalse, loopHead);

	// Pop off the loop counter, leaving the integer receiver on the stack
	GenPopStack();
	
	return true;
}

// Parse the loop block and ignore its result
int Compiler::ParseOptimizeBlock(int arguments)
{
	if (!ThisTokenIsBinary('['))
	{
		CompileError(CErrExpectLiteralBlock);
		return 0;
	}

	int nTextStart = ThisTokenRange().m_start;

	_ASSERTE(IsInOptimizedBlock());

	// Parse the arguments - note we parse them anyway, regardless of whether they are wanted, 
	// and subsequently complain if there are too many
	NextToken();
	int argument = 0;
	while (m_ok && ThisTokenIsSpecial(':') )
	{
		if (NextToken()==NameConst)
		{
			if (argument < arguments)
				RenameTemporary(argument, ThisTokenText(), ThisTokenRange());
			else
				AddTemporary(ThisTokenText(), ThisTokenRange(), true);
			argument++;
			NextToken();
		}
		else
			CompileError(CErrExpectVariable);
	}

	int argBar = -1;
	if (m_ok && argument > 0)
	{
		if (ThisTokenIsBinary(TEMPSDELIMITER))
		{
			argBar = ThisTokenRange().m_stop;
			NextToken();
		}
		else
		{
			CompileError(TEXTRANGE(nTextStart, LastTokenRange().m_stop), CErrBlockArgListNotClosed);
		}
	}

	int nBlockTemps = 0;
	if (m_ok)
	{
		// Temporarily commented out for interim release
		ParseTemporaries();
		
		ParseBlockStatements();
		if (m_ok && ThisToken() != CloseSquare)
			CompileError(TEXTRANGE(nTextStart, LastTokenRange().m_stop), CErrBlockNotClosed);
	}
	
	if (m_ok && argument != arguments)
		CompileError(TEXTRANGE(nTextStart, argBar < 0 ? ThisTokenRange().m_stop : argBar), CErrIncorrectBlockArgCount);

	return nBlockTemps;
}

