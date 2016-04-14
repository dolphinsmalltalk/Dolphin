/*
============
Optimizer.cpp
============
Smalltalk compiler bytecode optimizer.
*/

///////////////////////

#include "stdafx.h"

#include "Compiler.h"
#include <locale.h>

#include <crtdbg.h>
#define CHECKREFERENCES

#ifdef _DEBUG
static int compilationTrace = 1;

#elif !defined(USE_VM_DLL)
#undef NDEBUG
#include <assert.h>
#undef _ASSERTE
#define _ASSERTE assert
#endif

const int BlockCopyInstructionLength = 7;

//////////////////////////////////////////////////
// Some helpers for optimisation

//////////////////////////////////////////////////

inline int Compiler::Pass2()
{
	// Optimise generated code
	int blockCount = FixupTempsAndBlocks();
	RemoveNops();
	if (WantOptimize())
		Optimize();
	FixupJumps();
	return blockCount;
}

void Compiler::RemoveNops()
{
	int i=0;
	while (i<GetCodeSize())		// Note that codeSize can change (reduce) as Nops removed
	{
		const BYTECODE& bc = m_bytecodes[i];

		VerifyTextMap();

		switch (bc.byte)
		{
		case Nop:
			_ASSERTE(!m_bytecodes[i].isData());
			// The Nop might be a jump target, in which case we must copy the inbound jump count to
			// the new byte code at the position. RemoveByte() does this (or should)
			RemoveByte(i);
			break;

		default:
			i += bc.instructionLength();
			break;
		}
	}
} 

void Compiler::Optimize()
{
	// Perform a series of (generally) peephole optimizations
	// Optimize pairs of instructions, shorten jumps, and combine pairs into macro instructions
	
	// Cycle until no further reductions in pairs of instructions or jumps
	// are possible - note that we must loop round again after CombinePairs
	// because that may introduce further macro "return" instructions that combine
	// with other instructions, and these could allow for further jump
	// optimisations. There may be other optimisations enabled by the macro
	// instructions too.
//	disassemble();
	int count;
	do
	{
		do
		{
			count = 0;
			while (OptimizePairs())
				count++;
//			disassemble();
			while (OptimizeJumps())
				count++;
//			disassemble();
		}
		while (count);

		// Note that we combine pairs into macro instructions only when other
		// optimizations are exhausted. This prevents over optimization too early on
		while (CombinePairs())
			count++;

		count += InlineReturns();
	}
	while(count);

	// Finally reduce jump instructions to their shortest form - by doing this last
	// we can simplify jump optimization
	while (ShortenJumps())
		count++;
}

// Remove an entire instruction, added by BSM to improve
// optimization when removing jumps, and to correctly
// remove multi-byte instructions, which was not always done
// before
inline int Compiler::RemoveInstruction(int ip)
{
	_ASSERTE(ip < GetCodeSize());
	// We should not be removing an instruction 
	BYTECODE& bc = m_bytecodes[ip];
	//_ASSERTE(!bytecode.isJumpTarget());

#ifdef _DEBUG
	{
		const TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
		if (it != m_textMaps.end())
		{
			_ASSERTE(bc.isOpCode());
			int prevIP = ip - 1;
			while (prevIP >= 0 && (m_bytecodes[prevIP].isData() || m_bytecodes[prevIP].byte == Nop))
				prevIP--;
			const BYTECODE* prev = prevIP < 0 ? NULL : &m_bytecodes[prevIP];
			bool isFirstInBlock = bc.pScope != NULL && bc.pScope->IsBlock() 
				&& (bc.pScope->GetInitialIP() == ip || prev->byte == BlockCopy || bc.pScope != prev->pScope);
			_ASSERTE(ip == 0 || isFirstInBlock);
		}
	}
#endif

	// We're about to remove an unreachable jump, so we want to inform
	// its jump target in case that can be optimized away too
	if (bc.isJumpSource())
	{
		_ASSERTE(bc.target < GetCodeSize());
		BYTECODE& target = m_bytecodes[bc.target];
		target.removeJumpTo();
	}
	
	int len = bc.instructionLength();
	for (int j=0;j<len;j++)
		RemoveByte(ip);
	return len;
}

// Remove a byte from the code array
// Adjusts any jumps that occur over the boundary
void Compiler::RemoveByte(int ip)
{
	_ASSERTE(ip>=0 && ip < GetCodeSize());
	const BYTECODE& bc = m_bytecodes[ip];
	WORD jumpsTo = bc.jumpsTo;

	m_bytecodes.erase(m_bytecodes.begin() + ip);
	
	if (ip < GetCodeSize())
		// New byte may become jump target
		m_bytecodes[ip].jumpsTo += jumpsTo;
	else
		_ASSERTE(!jumpsTo);
	
	// Adjust the jumps
	{
		const BYTECODES::iterator loopEnd = m_bytecodes.end();
		for (BYTECODES::iterator it=m_bytecodes.begin(); it != loopEnd; it++)
		{
			BYTECODE& bc = (*it);
			if (bc.isJumpSource())
			{
				// This is a jump. Does it cross the boundary
				if (bc.target > ip)
					bc.target--;		// Yes, adjust absolute target
			}
		}
	}
	
	// Adjust ip of any TextMaps
	{
		const TEXTMAPLIST::iterator loopEnd = m_textMaps.end();
		for (TEXTMAPLIST::iterator it = m_textMaps.begin(); it != loopEnd; it++)
		{
			TEXTMAP& textMap = (*it);
			// If the text map entry is for this IP, leave untouched so TextMap moves to next instruction
			// If the text map is for a later instruction, then its IP will need to be adjusted
			if (textMap.ip > ip && textMap.ip > 0)
				textMap.ip--;
		}
	}
}

inline int decodeOuterTempRef(BYTE byte, int& index)
{
	index = byte & OuterTempMaxIndex;
	return byte >> OuterTempIndexBits;
}

bool Compiler::AdjustTextMapEntry(int ip, int newIP)
{
	if (!WantTextMap()) return true;

	const TEXTMAPLIST::iterator loopEnd = m_textMaps.end();
	for (TEXTMAPLIST::iterator it = m_textMaps.begin(); it != loopEnd; it++)
	{
		TEXTMAP& textMap = (*it);
		if (textMap.ip == ip)
		{
			textMap.ip = newIP;
			return true;
		}
	}
	return false;
}

int Compiler::OptimizePairs()
{
	// Optimize pairs of instructions.
	// Returns a count of the optimizations done.
	int count=0, i=0;
	while (i < GetCodeSize())
	{
		VerifyTextMap();
		BYTECODE& bytecode1=m_bytecodes[i];
		const int len1 = bytecode1.instructionLength();
		const int next = i+len1;
		if (next >= GetCodeSize())
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		_ASSERTE(bytecode1.isOpCode() && bytecode2.isOpCode());
		
		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.isJumpTarget())
		{
			BYTE byte1 = bytecode1.byte;
			BYTE byte2 = bytecode2.byte;

			// If the first is a push of a special and the second
			// is a return from message then we may be able to replace
			// by a return special but only if the second is not a jump
			// target.
			//
			if (bytecode1.isPseudoPush() && byte2 == ReturnMessageStackTop)
			{
				// Can avoid need to modify text map if we remove the push and adjust the return instruction
				bytecode2.byte = FirstPseudoReturn + (byte1 - FirstPseudoPush);
				RemoveInstruction(i);
				count++;
				continue;	// Go round again without advancing, to reconsider the changed instruction
			}

			// We must perform same optimisation in debug code to keep the text maps synchronised
			else if (bytecode1.isPseudoPush() && byte2 == Break && m_bytecodes[next+1].byte == ReturnMessageStackTop)
			{
				m_bytecodes[next+1].byte = FirstPseudoReturn + (byte1 - FirstPseudoPush);
				RemoveInstruction(i);
				_ASSERTE(m_bytecodes[i].byte == Break);
				count++;
				continue;
			}

			else if (byte1 == PopPushSelf && byte2 == ReturnMessageStackTop)
			{
				// Although the result of a previous optimisation, this code sequence has a slightly more 
				// efficient form, also it can be optimised down further to Pop; Return Self.
				bytecode1.byte = PopStackTop;
				bytecode2.byte = ReturnSelf;
				count++;
				continue;
			}
			
			// Quite a lot of pushes are redundant, and can be removed...
			else if (bytecode1.isPush())
			{
				// A push immediately followed by a pop that is not immediately
				// jumped to can be replaced by nothing.
				if (byte2==PopStackTop ||
					// These conditional jumps never executed as immediately following push of opposite boolean
					(byte1==ShortPushTrue && byte2 == LongJumpIfFalse) ||
					(byte1==ShortPushFalse && byte2 == LongJumpIfTrue) || 
					(byte1==ShortPushNil && byte2 == LongJumpIfNotNil) 
					)
				{
					_ASSERTE(!bytecode2.isJumpTarget());
					if (byte2 != PopStackTop)
						VoidTextMapEntry(next);
					RemoveInstruction(i);
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				
				// Push followed by pseudo return is redundant, and can be removed leaving on the return
				else if (bytecode2.isPseudoReturn())
				{
					_ASSERTE(!bytecode2.isJumpTarget());
					RemoveInstruction(i);
					count++;
					continue;	// Continue optimization on the pseudo return now move to i
				}
				
				else if (byte1 == ShortPushTrue && byte2 == LongJumpIfTrue)
				{
					// If push true followed by jump if true (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.isJumpTarget());
					VoidTextMapEntry(i+1);
					bytecode2.byte = LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				else if (byte1 == ShortPushFalse && byte2 == LongJumpIfFalse)
				{
					// If push false followed by jump if false (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.isJumpTarget());
					VoidTextMapEntry(i+1);
					bytecode2.byte = LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				else if (byte1 == ShortPushNil && byte2 == LongJumpIfNil)
				{
					// If push nil followed by jump if nil (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.isJumpTarget());
					VoidTextMapEntry(i+1);
					bytecode2.byte = LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				// Push 1 followed by special send #+/#- can be replaced by increment/decrement
				// No further optimization of the increment/decrement is possible, so we move 
				// to the next instruction in these cases
				else if (byte1 == ShortPushOne)
				{
					if (byte2 == SendArithmeticAdd)
					{
						// To avoid having to adjust the text map entry, remove the push and update the SpecialSendAdd
						bytecode2.byte = IncrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == SendArithmeticSub)
					{
						bytecode2.byte = DecrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == Break)
					{
						// Must perform same optimisation in Debug method to keep text maps in sync
						// (otherwise would have wrong stack if remapped Increment to the Send+ as would 
						// be missing push 1)
						BYTECODE& bytecode3 = m_bytecodes[next+1];
						if ( bytecode3.byte == SendArithmeticAdd)
						{
							bytecode3.byte = IncrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushOne, leave the Break before Increment
							count++;
							continue;
						}
						else if (bytecode3.byte == SendArithmeticSub)
						{
							bytecode3.byte = DecrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushOne
							count++;
							continue;	// A new instruction will now be at i to be considered, so don't advance
						}
					}
				}

				// Push -1 followed by special send #+/#- can be replaced by increment/decrement
				else if (byte1 == ShortPushMinusOne)
				{
					if (byte2 == SendArithmeticAdd)
					{
						bytecode2.byte = DecrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushMinusOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == SendArithmeticSub)
					{
						bytecode2.byte = IncrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushMinusOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == Break)
					{
						// Must perform same optimisation in Debug method to keep text maps in sync
						// (otherwise would have wrong stack if remapped Increment to the Send+ as would 
						// be missing push 1)
						BYTECODE& bytecode3 = m_bytecodes[next+1];
						if (bytecode3.byte == SendArithmeticAdd)
						{
							bytecode3.byte = DecrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushMinusOne, leave the Break before Increment
							count++;
							continue;
						}
						else if (bytecode3.byte == SendArithmeticSub)
						{
							bytecode3.byte = IncrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushMinusOne
							count++;
							continue;	// A new instruction will now be at i to be considered, so don't advance
						}
					}

				}

				else if (byte1 == ShortPushZero)
				{
					if (byte2 == SpecialSendIdentical)
					{
						_ASSERTE(!bytecode1.isJumpSource());
						bytecode2.byte = SpecialSendIsZero;
						RemoveInstruction(i);
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					// Tempting, but not really a valid optimisation since we don't know that the receiver is a Number at all
					//else if (byte2 == SendArithmeticAdd || byte2 == SendArithmeticSub)
					//{
					//	// Subtract or add zero is, of course, redundant
					//	_ASSERTE(!bytecode1.isJumpSource());
					//	RemoveInstruction(i+1);
					//	RemoveInstruction(i);
					//	count++;
					//	continue;	// A new instruction will now be at i to be considered, so don't advance
					//}
				}
			}
			
			// Check for unreachable code (remember the following byte is known not to be a jump target)
			else if (bytecode1.isReturn() || bytecode1.isLongJump())
			{
				VoidTextMapEntry(next);
				RemoveInstruction(next);
				count++; 
				
				// We don't want to advance ip here, since there may be more unreachable code
				continue;
			}
			
			else if (bytecode1.isExtendedStore())
			{
				// A store instruction followed by a pop that is not immediately
				// jumped to can be coerced (heh heh) into a pop and store.
				if (byte2==PopStackTop)
				{
					_ASSERTE(!bytecode2.isJumpTarget());
					if (byte1 == StoreOuterTemp)
					{
						// Remove the popStack
						_ASSERTE(next == i + 2);

						int index;
						int depth = decodeOuterTempRef(m_bytecodes[i+1].byte, index);

						if (depth == 0 && index < NumPopStoreContextTemps)
						{
							bytecode1.byte = PopStoreContextTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							_ASSERTE(m_bytecodes[i+1].byte == PopStackTop);
							RemoveInstruction(i+1);
						}
						else if (depth == 1 && index < NumPopStoreOuterTemps)
						{
							bytecode1.byte = ShortPopStoreOuterTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							_ASSERTE(m_bytecodes[i+1].byte == PopStackTop);
							RemoveInstruction(i+1);
						}
						else
						{
							bytecode1.byte = PopStoreOuterTemp;
							RemoveInstruction(next);
						}
						count++;
					}
					else
					{
						bytecode1.byte = FirstPopStore + (byte1 - FirstExtendedStore);
						RemoveInstruction(next);
						count++;
						
						// Now there may be a shorter form of instruction that 
						// we can use
						_ASSERTE(m_bytecodes[i+1].isData());
						
						_ASSERTE(i+1 < GetCodeSize());
						int index = m_bytecodes[i+1].byte;
						if (bytecode1.byte == PopStoreInstVar && index < NumShortPopStoreInstVars)
						{
							bytecode1.byte = ShortPopStoreInstVar + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							count++;
						}
						else if (bytecode1.byte == PopStoreTemp && index < NumShortPopStoreTemps)
						{
							bytecode1.byte = ShortPopStoreTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							count++;
						}
					}
					continue;	// Other optimizations may be possible on the new instruction
				} 
			}

			// Same as above for the next ShortStoreTemp instruction
			else if (bytecode1.isShortStoreTemp())
			{
				 if (byte2 == PopStackTop)
				 {
					_ASSERTE(NumShortStoreTemps <= NumShortPopStoreTemps);
					int index = byte1 - ShortStoreTemp;
					bytecode1.byte = ShortPopStoreTemp + index;
					RemoveInstruction(next);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				 }
			}

			else if (byte1 == SpecialSendIsNil && bytecode2.isJumpSource())
			{
				_ASSERTE(bytecode2.instructionLength() == 3);
				if (byte2 == LongJumpIfTrue)
				{
					bytecode2.byte = LongJumpIfNil;
					// Because we've effectively replaced the isNil message send
					// we need to adjust the textMap entry so that it points at the jump,
					// or it will be point at the preceeding instruction when the isNil send
					// is removed
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);					// Remove separate isNil test
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				else if (byte2 == LongJumpIfFalse)
				{
					bytecode2.byte = LongJumpIfNotNil;
					// Ditto adjustment of text map entry because of removal of isNil
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
			}
			else if (byte1 == SpecialSendNotNil && bytecode2.isJumpSource())
			{
				_ASSERTE(bytecode2.instructionLength() == 3);
				if (byte2 == LongJumpIfTrue)
				{
					bytecode2.byte = LongJumpIfNotNil;
					// Ditto adjustment of text map entry because of removal of notNil
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);					// Remove separate isNil test
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				else if (byte2 == LongJumpIfFalse)
				{
					bytecode2.byte = LongJumpIfNil;
					// Ditto adjustment of text map entry because of removal of isNil
					VERIFY(AdjustTextMapEntry(i, next));
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
			}
			else if (byte1 == DuplicateStackTop && byte2 == ReturnMessageStackTop)
			{
				// A Dup immediately before a Return ToS is redundant
				_ASSERTE(!bytecode2.isJumpTarget());
				bytecode1.byte = ReturnMessageStackTop;
				count++;
				// Leave the other return to be removed as unreachable code
				continue;	// A new instruction will now be at i to be considered, so don't advance
			}
			else if ((bytecode1.isShortPopStoreTemp() && bytecode2.isShortPushTemp())
						&& (bytecode1.indexOfShortPopStoreTemp() == bytecode2.indexOfShortPushTemp()))
			{
				// Replace a PopStore[n], Push[n], sequence with a store
				// This commonly occurs in code that assigns a temp and then 
				// uses the temp immediately, such as for a condition.
				
				int index = bytecode2.indexOfShortPushTemp();
				if (index < NumShortStoreTemps)
				{
					bytecode1.byte = ShortStoreTemp + index;
					RemoveInstruction(next);
				}
				else
				{
					bytecode1.byte = StoreTemp;
					bytecode2.byte = index;
					bytecode2.makeData();
				}
				count++;
				continue;	// A new instruction will now be at i to be considered, so don't advance
			}
			else if (bytecode1.isLongConditionalJump() && bytecode2.isLongJump()
				&&  bytecode1.target == next + 3)
			{
				// Conditional jump over unconditional jump can be replaced with 
				// inverted conditional jump to unconditional jump's target
				BYTE invertedJmp;
				switch (bytecode1.byte)
				{
				case LongJumpIfTrue:
					invertedJmp = LongJumpIfFalse;
					break;
				case LongJumpIfFalse:
					invertedJmp = LongJumpIfTrue;
					break;
				case LongJumpIfNil:
					invertedJmp = LongJumpIfNotNil;
					break;
				case LongJumpIfNotNil:
					invertedJmp = LongJumpIfNil;
					break;
				default:
					_ASSERT(FALSE);
					break;
				}
				bytecode1.byte = invertedJmp;
				m_bytecodes[bytecode1.target].removeJumpTo();		// We're no longer jumping to original target
				bytecode1.target = bytecode2.target;
				// We want the inbound-jumps count of the eventual target to remain the same so
				// we remove the jump flag from the unconditional jump instruction before removing
				// it to prevent adjustment of the target's count in RemoveInstruction()
				bytecode2.makeNonJump();
				RemoveInstruction(next);
				count++;
				continue;	// A new instruction will now be at i to be considered, so don't advance
			}
		}
		
		// A store into a temp followed by a return from method is redundant, even if
		// either is a jump target
		if (bytecode1.isStoreStackTemp() && bytecode2.isReturn())
		{
			// bytecode1 is a Store (assignment) and might have a text map entry (the Store for
			// an ifNotNil: block will not).
			// In a debug version of the method we cannot remove this store, since the user will 
			// want to debug through it. Therefore we have to leave the text map entry in order 
			// to keep the maps in sync, but void it by setting the ip to -1.
			VoidTextMapEntry(i);
			RemoveInstruction(i);
			count++;
			continue;	// A new instruction will now be at i to be considered, so don't advance
		}
		
		// Bytecode may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].isOpCode());
		const int len = m_bytecodes[i].instructionLength();
		i += len;
	}
	return count;
}

// Hmmm, there's what looks like a code generation bug here - or at least enabling global optimisation
// here generates incorrect code for CombinePairs1 and it fails to spot Push Temp;Send Zero Args pairs.
#pragma optimize("g", off)

int Compiler::CombinePairs()
{
	return CombinePairs1() + CombinePairs2();
}

// Combine pairs of instructions into the more favoured macro instructions. This should be done
// before CombinePairs2(). Returns a count of the optimizations done.
int Compiler::CombinePairs1()
{
	int count=0, i=0;
	while (i < GetCodeSize())
	{
		VerifyTextMap();
		BYTECODE& bytecode1=m_bytecodes[i];
		const int len1 = bytecode1.instructionLength();
		
		const int next = i+len1;
		if (next >= GetCodeSize())
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		_ASSERTE(bytecode1.isOpCode() && bytecode2.isOpCode());

		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.isJumpTarget())
		{
			const BYTE byte1 = bytecode1.byte;
			const BYTE byte2 = bytecode2.byte;

			// We introduce this macro instruction here rather than in CombinePairs2()
			// because we wan't it to take precedent over PopPushSelf, which would otherwise get
			// used every time there is a sequence of sends to self with the intermediate results
			// being ignored. Its possible there should be a PopSendSelf instruction
			if (byte1 == ShortPushSelf)
			{
				if (bytecode2.isShortSendWithNoArgs())
				{
					_ASSERTE(len1 == 1);
					// Need to move text map entry back, as the PushSelf becomes the send
					VERIFY(AdjustTextMapEntry(next, i));

					int n = bytecode2.indexOfShortSendNoArgs();
					if (n < NumShortSendSelfWithNoArgs)
					{
						bytecode1.byte = ShortSendSelfWithNoArgs+n;
						RemoveInstruction(next);
					}
					else
					{
						bytecode1.byte = SendSelfWithNoArgs;
						bytecode2.byte = n;
						bytecode2.makeData();
					}
					count++;
				}
			} 

			// Look for opportunities to combine push temp with subsequent zero arg send
			else if (bytecode1.isShortPushTemp())
			{
				int n = bytecode1.indexOfShortPushTemp();

				if (bytecode2.isShortSendWithNoArgs())
				{
					// Push Temp has become the Send Temp instruction
					VERIFY(AdjustTextMapEntry(next, i));

					int m = bytecode2.indexOfShortSendNoArgs();
					_ASSERTE(m <= MAXFORBITS(5));
					_ASSERTE(n <= MAXFORBITS(3));

					bytecode2.makeData();
					bytecode2.byte = n << 5 | m;

					bytecode1.byte = SendTempWithNoArgs;
				}
				else if (byte2 == Send)
				{
					_ASSERTE(m_bytecodes[next+1].isData());
					int m = m_bytecodes[next+1].byte;
					_ASSERTE(SendXLiteralBits <= 5);
					int argCount = m >> SendXLiteralBits;
					if (argCount == 0)
					{
						// Push Temp will become the Send Temp instruction
						VERIFY(AdjustTextMapEntry(next, i));

						bytecode1.byte = SendTempWithNoArgs;
						bytecode2.makeData();
						bytecode2.byte = n << 5 | m;
						RemoveByte(next+1);
					}
				}
				else if (byte2 == IncrementStackTop || byte2 == DecrementStackTop)
				{
					// Look for opportunities to replace ShortPushTempN, Inc, [Short][Pop]StoreTempN with Inc[Push]TempN
					// Note that we only need perform this optimisation in release methods, because the instruction is
					// carefully designed so that should the increment result in an actual method send, then the IP
					// can be advanced midway through the instruction and be position at the appropriate store instruction
					// for when the Send+ returns. The textmap is carefully constructed so that there is an entry for
					// the midpoint in the instruction to allow remapping of a suspended release frame to the 
					// middle of the equivalent unoptimised 3 instructions

					// byte2 cannot possibly be the last instruction
					BYTECODE& bytecode3=m_bytecodes[next+1];
					if (!bytecode3.isJumpTarget())
					{
						if (bytecode3.isShortPopStoreTemp())
						{
							int m =  bytecode3.indexOfShortPopStoreTemp();
							if (m == n)
							{
								VERIFY(AdjustTextMapEntry(next, i));
								bytecode1.byte = byte2 == IncrementStackTop ? IncrementTemp : DecrementTemp;
								VERIFY(AdjustTextMapEntry(next+1, next));
								bytecode2.byte = PopStoreTemp;
								bytecode2.makeData();
								bytecode3.byte = n;
								bytecode3.makeData();
								count++;
							}
						}
						else if (bytecode3.isShortStoreTemp())
						{
							int m =  bytecode3.indexOfShortStoreTemp();
							if (m == n)
							{
								bytecode1.byte = byte2 == IncrementStackTop ? IncrementPushTemp : DecrementPushTemp;
								// There may be no text map entries if these instructions are part of a to:[by:]do: loop
								AdjustTextMapEntry(next, i);
								bytecode2.byte = StoreTemp;
								AdjustTextMapEntry(next+1, next);
								bytecode2.makeData();
								bytecode3.byte = n;
								bytecode3.makeData();
								count++;
							}
						}
						else if (bytecode3.byte == PopStoreTemp || bytecode3.byte == StoreTemp)
						{
							int m = m_bytecodes[next+2].byte;
							if (m == n)
							{
								bytecode1.byte = bytecode3.byte == PopStoreTemp 
										? bytecode2.byte == IncrementStackTop ? IncrementTemp : DecrementTemp
										: bytecode2.byte == IncrementStackTop ? IncrementPushTemp : DecrementPushTemp;
								// The [Pop]StoreTemp instruction is now data, but is otherwise correct
								bytecode3.makeData();
								// We can remove the IncrementStackTop
								AdjustTextMapEntry(next, i);
								RemoveByte(next);
								count++;
							}
						}
					}
				}
			}
			else if (byte1 == PushTemp)
			{
				_ASSERTE(m_bytecodes[i+1].isData());
				int n = m_bytecodes[i+1].byte;

				if (byte2 == Send)
				{
					 if (n <= MAXFORBITS(3))
					 {
						_ASSERTE(m_bytecodes[next+1].isData());
						_ASSERTE(SendXLiteralBits <= 5);
						int m = m_bytecodes[next+1].byte;
						int argCount = m >> SendXLiteralBits;
						if (argCount == 0)
						{
							DebugBreak();
						}
					 }
				}
				else if (bytecode2.isShortSendWithNoArgs())
				{
					if (n <= MAXFORBITS(3))
					{
						// Push Temp will become the Send Temp instruction
						VERIFY(AdjustTextMapEntry(next, i));

						bytecode1.byte = SendTempWithNoArgs;
						m_bytecodes[i+1].byte = bytecode2.indexOfShortSendNoArgs() << 5 || n;
						RemoveByte(next);
					}
				}
				else if (bytecode2.byte == IncrementStackTop || bytecode2.byte == DecrementStackTop)
				{
					// Look for opportunities to replace PushTempN, Inc, [Pop]StoreTempN with Inc[Push]TempN
					
					// Note that we assume there will always be more short push temp instructions than
					// [Pop]Store instructions, so we do not handle the short cases here
					_ASSERTE(NumShortPushTemps >= NumShortStoreTemps);
					_ASSERTE(NumShortPushTemps >= NumShortPopStoreTemps);

					// byte2 cannot possibly be the last instruction
					BYTECODE& bytecode3=m_bytecodes[next+1];
					if (!bytecode3.isJumpTarget())
					{
						if (bytecode3.byte == PopStoreTemp || bytecode3.byte == StoreTemp)
						{
							int m = m_bytecodes[next+2].byte;
							if (m == n)
							{
								bytecode1.byte = bytecode3.byte == PopStoreTemp 
										? bytecode2.byte == IncrementStackTop ? IncrementTemp : DecrementTemp
										: bytecode2.byte == IncrementStackTop ? IncrementPushTemp : DecrementPushTemp;
								// The PopStoreTemp instruction is now data, but is otherwise correct
								bytecode3.makeData();
								// We can remove the first bytecodes argument byte and the [Inc|Dec]rementStackTop
								AdjustTextMapEntry(next, i);
								RemoveByte(next);
								RemoveByte(i+1);
								count++;
							}
						}
					}
				}
			}
		}
		
		// Bytecode may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].isOpCode());
		const int len = m_bytecodes[i].instructionLength();
		i += len;
	}
	return count;
}

// Combine pairs of instructions into the less favoured macro instructions. This should be done
// after CombinePairs1(). Returns a count of the optimizations done.
int Compiler::CombinePairs2()
{
	int count=0, i=0;
	while (i < GetCodeSize())
	{
		VerifyTextMap();
		BYTECODE& bytecode1=m_bytecodes[i];
		const int len1 = bytecode1.instructionLength();
		
		const int next = i+len1;
		if (next >= GetCodeSize())
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		_ASSERTE(bytecode1.isOpCode() && bytecode2.isOpCode());

		BYTE byte1 = bytecode1.byte;
		BYTE byte2 = bytecode2.byte;

		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.isJumpTarget())
		{
			if (byte1 == PopStackTop)
			{
				if (byte2 == ShortPushSelf)
				{
					// Pop followed by Push Self is common in a sequence of statements that send to self.

					bytecode1.byte = PopPushSelf;
					RemoveInstruction(next);
					count++;
				}

				else if (byte2 == DuplicateStackTop)
				{
					// The Pop/Dup sequence is common in cascades

					bytecode1.byte = PopDup;
					RemoveInstruction(next);
					count++;
				}

				else if (byte2 == ReturnSelf)
				{
					// Remove the Pop and adjust the return to avoid need to adjust the text map entry
					bytecode2.byte = PopReturnSelf;
					RemoveInstruction(i);
					count++;
				}

				else if (bytecode2.isShortPushTemp() && (bytecode2.indexOfShortPushTemp() < NumShortPopPushTemps))
				{
					// Pop followed by a push of a temp is common in a sequence of statements where
					// messages are sent to a temp

					bytecode1.byte = ShortPopPushTemp + (byte2 - ShortPushTemp);
					bytecode1.pVarRef = bytecode2.pVarRef;
					RemoveInstruction(next);
					count++;
				}
			}

			else if (byte1 == ShortPushSelf)
			{
				if (bytecode2.isPushTemp())
				{
					// A pair of push self and then pushing a temp is very common, being the prelude
					// to sending a one (or more) arg message to self

					// Don't lose the var ref (this is useful for debug decoding only at this stage)
					bytecode1.pVarRef = bytecode2.pVarRef;

					_ASSERTE(len1 == 1);
					if (bytecode2.byte == PushTemp)
					{
						bytecode1.byte = PushSelfAndTemp;
						// Remove the PushTemp, grabbing its index data byte
						_ASSERTE(next == i+1);
						RemoveByte(next);
					}
					else
					{
						// If short push, overwrite it with a data byte containing the temp index
						int i = bytecode2.indexOfShortPushTemp();
						if (i < NumShortPushSelfAndTemps)
						{
							bytecode1.byte = ShortPushSelfAndTemp+i;

							RemoveInstruction(next);
						}
						else
						{
							bytecode1.byte = PushSelfAndTemp;
							bytecode2.byte = i;
							bytecode2.makeData();
						}
					}
					count++;
				}
			}

			// Look for opportunities to combine pairs of push temp instructions into one
			// Pairs of temp pushes are common before sending 1 or more argument messages
			else if (bytecode1.isShortPushTemp())
			{
				int n = bytecode1.indexOfShortPushTemp();

				if (byte2 == PushTemp)
				{
					_ASSERTE(m_bytecodes[next+1].isData());
					int m = m_bytecodes[next+1].byte;
					if (m < MAXFORBITS(4))
					{
						bytecode1.byte = PushTempPair;
						RemoveByte(next);
						_ASSERTE(m_bytecodes[next].isData());
						m_bytecodes[next].byte = n << 4 | m;
						count++;
					}
				}
				else if (bytecode2.isShortPushTemp())
				{
					int m = bytecode2.indexOfShortPushTemp();
					_ASSERTE(n <= MAXFORBITS(4));
					_ASSERTE(m <= MAXFORBITS(4));
					bytecode1.byte = PushTempPair;
					bytecode2.byte = n << 4 | m;
					bytecode2.makeData();
					count++;
				}
			}

			else if (byte1 == PushTemp)
			{
				_ASSERTE(m_bytecodes[i+1].isData());
				int n = m_bytecodes[i+1].byte;

				if (bytecode2.isPushTemp())
				{
					if (n <= MAXFORBITS(4))
					{
						if (byte2 == PushTemp)
						{
							_ASSERTE(m_bytecodes[next+1].isData());
							int m = m_bytecodes[next+1].byte;
							if (m <= MAXFORBITS(4))
							{
								bytecode1.byte = PushTempPair;
								m_bytecodes[i+1].byte = n << 4 | m;
								RemoveInstruction(next);
								count++;
							}
						}
						else
						{
							_ASSERTE(bytecode2.isShortPushTemp());
							int m = bytecode2.indexOfShortPushTemp();
							_ASSERTE(n <= MAXFORBITS(4));
							_ASSERTE(m <= MAXFORBITS(4));
							bytecode1.byte = PushTempPair;
							m_bytecodes[i+1].byte = n << 4 | m;
							RemoveInstruction(next);
							count++;
						}
					}
				}
			}
		}
		
		// Bytecode may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].isOpCode());
		const int len = m_bytecodes[i].instructionLength();
		i += len;
	}
	return count;
}
#pragma optimize( "", on)
#pragma auto_inline()

void Compiler::FixupJumps()
{
	const int loopEnd = GetCodeSize();
	int i=0;
	LexicalScope* pCurrentScope = GetMethodScope();
	pCurrentScope->SetInitialIP(0);

	while (i<loopEnd)
	{
		_ASSERTE(m_bytecodes[i].isOpCode());

		//_CrtCheckMemory();
		if (m_bytecodes[i].isJumpSource())
		{
			_ASSERTE(m_bytecodes[i].isJumpInstruction());
			FixupJump(i);
			_ASSERTE(m_bytecodes[i].isJumpInstruction());
		}
		else
			_ASSERTE(!m_bytecodes[i].isJumpInstruction());
	
		// Patch up the ip range of the scopes as we encounter them
		if (m_bytecodes[i].pScope != pCurrentScope)
		{
			// Note that setting of the final IP may happen more than once
			// as the block goes in and out of scope
			pCurrentScope->SetFinalIP(i-1);
			pCurrentScope = m_bytecodes[i].pScope;
			_ASSERTE(pCurrentScope != NULL);
			// Patch up the initialIP of the scope for the temps map
			pCurrentScope->MaybeSetInitialIP(i);
		}

		_ASSERTE(m_bytecodes[i].isOpCode());
		int len = m_bytecodes[i].instructionLength();
		i += len;
		// Code size cannot shrink
		_ASSERTE(GetCodeSize() == loopEnd);
	}

	pCurrentScope->SetFinalIP(GetCodeSize()-1);
	_ASSERTE(GetMethodScope()->GetFinalIP() == GetCodeSize()-1);
}

int Compiler::OptimizeJumps()
{
	// Run through seeing if any jumps can be removed or retargeted.
	// Return a count of the number of jumps replaced.
	//
	int count=0, i=0;
	while (i<GetCodeSize())
	{
		VerifyTextMap();
		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.isOpCode());
		int len = bytecode.instructionLength();
		if (bytecode.isJumpSource())
		{
			// At this stage all jumps should be long
			_ASSERTE(bytecode.byte == BlockCopy || bytecode.instructionLength() == 3);

			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			int currentTarget = bytecode.target;
			_ASSERTE(currentTarget < GetCodeSize());
			BYTECODE& target = m_bytecodes[currentTarget];
			_ASSERTE(target.isJumpTarget());
			BYTE targetByte = target.byte;

			int distance = currentTarget-i;
			int offset = distance - len;
			if (!offset)
			{
				_ASSERTE(bytecode.byte != BlockCopy);

				// This jump is a Nop, since the jump offset is 0, and can be removed
				if (bytecode.byte == LongJump)
					RemoveInstruction(i);
				else
				{
					// However (#401) if a conditional branch we must replace it with a Pop
					// to maintain the same stack
					target.removeJumpTo();
					bytecode.makeNonJump();
					bytecode.byte = PopStackTop;
					VoidTextMapEntry(i);
					RemoveByte(i+1);
					RemoveByte(i+1);
				}
				count++;
				continue;	// Go round again at same IP
			}
			
			if (target.isJumpSource())
			{
				if (target.byte == LongJump)
				{
					// Catch rare case of jump to self (e.g. [true] whileTrue can reduce to this).
					if (currentTarget != i)
					{
						// Any jump to an unconditional jump can be redirected to its
						// eventual target.
						int eventualtarget=target.target;
						_ASSERTE(eventualtarget < GetCodeSize());
						target.removeJumpTo();		// We're no longer jumping to original target
						SetJumpTarget(i, eventualtarget);
						count++;
						continue;	// Reconsider this jump as may be in a chain
					}
				}
				else if (bytecode.byte == LongJump && target.byte != BlockCopy)
				{
					// Unconditional jump to a conditional jump can be replaced
					// with a conditional jump (of the same type) to the same target
					// and an unconditional jump to the location after the original cond jump target
					_ASSERTE(target.isLongConditionalJump());
					_ASSERTE(len == 3);
					bytecode.byte = target.byte;
					int eventualtarget = target.target;
					_ASSERTE(eventualtarget < GetCodeSize());
					target.removeJumpTo();		// We're no longer jumping to original target
					SetJumpTarget(i, eventualtarget);
					m_codePointer = i + len;
					m_pCurrentScope = bytecode.pScope;
					GenJump(LongJump, currentTarget+3);
					m_pCurrentScope = NULL;
					count++;
					continue;	// Reconsider this jump as may be in a chain
				}
			}
			else if (target.isPush())
			{
				// If jumping to push followed by pop, can skip to the next instruction
				// This is quite a common result of conditional expressions
				
				// Can't be last byte (wouldn't make sense, as need a return)
				int next = currentTarget + target.instructionLength();
				_ASSERTE(next < GetCodeSize());
				BYTECODE& nextAfterTarget=m_bytecodes[next];
				if (nextAfterTarget.byte == PopStackTop)
				{
					_ASSERTE(nextAfterTarget.instructionLength() == 1);
					// Yup its a jump to a no-op, so retarget to following byte
					target.removeJumpTo();
					_ASSERTE(next+1 < GetCodeSize());	// Again, must be at least a ret to follow
					SetJumpTarget(i, next+1);
					count++;
					continue;	// Reconsider this jump as may be in a chain
				}
			}
		}

		i += len;
	}
	return count;
}

int Compiler::InlineReturns()
{
	// Jumps to return instructions can be replaced by the return instruction
	// Note that this is done last in optimisation as quite often such jumps
	// can be removed altogether due to elimination of unreachable/redundant code.
	//
	int count=0, i=0;
	while (i<GetCodeSize())
	{
		//_CrtCheckMemory();
		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.isOpCode());
		int len = bytecode.instructionLength();
		if (bytecode.isJumpSource())
		{
			// At this stage all jumps should be long
			_ASSERTE(bytecode.byte == BlockCopy || bytecode.instructionLength() == 3);

			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			int currentTarget = bytecode.target;
			_ASSERTE(currentTarget < GetCodeSize());
			BYTECODE& target = m_bytecodes[currentTarget];
			_ASSERTE(target.isJumpTarget());
			BYTE targetByte = target.byte;

			// Unconditional Jumps to return instructions can be replaced with the return instruction
			if (bytecode.byte == LongJump)
			{
				if (target.isReturn())
				{
					// All return instructions must be 1 byte long
					_ASSERTE(target.instructionLength() == 1);
					len = 1;
					bytecode.byte = targetByte;
					target.removeJumpTo();
					bytecode.makeNonJump();
					if (WantTextMap())
					{
						// N.B. We need to copy the text map entry for the target
						TEXTMAP tm = *FindTextMapEntry(currentTarget);
						InsertTextMapEntry(i, tm.start, tm.stop);
					}
					RemoveByte(i+1);
					RemoveByte(i+1);
					count++;
				}
				// We need to perform the same optimisation in debug methods to ensure the text maps match
				else if (targetByte == Break && m_bytecodes[currentTarget+1].isReturn())
				{
					// All return instructions must be 1 byte long
					_ASSERTE(target.instructionLength() == 1);
					
					const BYTECODE& returnOp = m_bytecodes[currentTarget+1];

					// We have to be careful to avoid performing an optimisation that would not be performed in
					// the release version of a method - if this is a jump over an empty block, the jump will
					// not be present in a release method because all empty blocks are folded to a single instance
					// and therefore there is no code inline in the method to jump over. We have to special case
					// this to avoid creating inconsistent text maps. You would think the code sequence '[[]]'
					// would never appear in a method, but EventsCollection>>triggerEvent: contains it!
					if (!(returnOp.byte == ReturnBlockStackTop && m_bytecodes[i+len].pScope->GetActualScope()->IsEmptyBlock()))
					{
						len = 2;
						bytecode.byte = Break;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].byte, bytecode.pScope);
						if (WantTextMap())
						{
							// N.B. We need to copy the text map entry for the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+1);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+1, (*it).start, (*it).stop);
						}
						RemoveByte(i+2);
						count++;
					}
				}
				else if (targetByte == PopStackTop)
				{
					if (m_bytecodes[currentTarget+1].isReturn())//.byte == ReturnSelf)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.instructionLength() == 1);
						len = 2;

						bytecode.byte = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].byte, bytecode.pScope);
						if (WantTextMap())
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+1);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+1, (*it).start, (*it).stop);
						}
						RemoveByte(i+2);
						count++;
					}
					else if (m_bytecodes[currentTarget+1].byte == Break 
							&& m_bytecodes[currentTarget+2].isReturn()) //.byte == ReturnSelf)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.instructionLength() == 1);
						len = 3;

						bytecode.byte = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(Break, bytecode.pScope);
						m_bytecodes[i+2].makeOpCode(m_bytecodes[currentTarget+2].byte, bytecode.pScope);
						if (WantTextMap())
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+2);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+2, (*it).start, (*it).stop);
						}
						count++;
					}
				}
				else if (target.isPseudoPush())	
				{
					// Inline jump to Push [Self|True|False|Nil]; Return sequence

					if (m_bytecodes[currentTarget+1].isReturnStackTop())
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.instructionLength() == 1);
						len = 2;

						bytecode.byte = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].byte, bytecode.pScope);
						if (WantTextMap())
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+1);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+1, (*it).start, (*it).stop);
						}
						RemoveByte(i+2);
						count++;
					}
					else if (m_bytecodes[currentTarget+1].byte == Break && m_bytecodes[currentTarget+2].isReturnStackTop())
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.instructionLength() == 1);
						len = 3;

						bytecode.byte = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(Break, bytecode.pScope);
						m_bytecodes[i+2].makeOpCode(m_bytecodes[currentTarget+2].byte, bytecode.pScope);
						if (WantTextMap())
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+2);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+2, (*it).start, (*it).stop);
						}
						count++;
					}
				}
			}
		}
		// A pair of the same return instructions can be reduced to one, EVEN IF one or the
		// other is a jump target. Note that we do this after inlining any returns to ensure that
		// we inline the 'correct' return (the correct one is the one associated with the right text
		// map entry)
		else if (bytecode.isReturn() && i + len < GetCodeSize() && bytecode.byte == m_bytecodes[i+len].byte)
		{
			VERIFY(VoidTextMapEntry(i));
			RemoveInstruction(i);
			count++;
			continue;	// There might be another subsequent return instruction that can be folded, so don't advance
		}

		i += len;
	}
	return count;
}

// Answer whether the specified distance is in the range of a short jump instruction, assuming that the
// current instruction has 'extensionBytes' bytes of extensions. The purpose of extensionBytes is to
// allow us to take account of the size of the current extension for forward jumps, as otherwise we may
// miss an opportunity to optimize jumps which are currently near, but could be short if it were not for
// the extension byte of the Near Jump
inline static bool isInShortJumpRange(int distance, unsigned extensionBytes)
{
	int offset = distance - 2;	// Allow for the instruction itself
	return offset >= 0 && (offset - extensionBytes) < NumShortJumps;
}

// Answer whether the supplied distance is within the possible jump range from the jump
// instruction. assuming that the current instruction has 'extensionBytes' bytes of extensions.
//
inline static bool isInNearJumpRange(int distance, unsigned extensionBytes)
{
#if defined(_DEBUG) && !defined(USE_VM_DLL)
	if (distance == 0)
		TRACESTREAM << "WARNING: Near Jump to itself detected" << std::endl;
#endif
	_ASSERTE(extensionBytes >= 1);
	
	// If the jump instruction is at 1, then the IP after interpreting it will be 3
	// so the offsets will be distance - 2
	int offset = distance - 2;
	
	return offset < 0 ?
		// We must take account of the size of the Near Jump instruction (2) when deciding whether a 
		// Near jump is possible since the offset always starts from the next instruction (i.e. 
		// offset 0 is the next instruction). The offset accounts for the opcode, but not the extension
		offset >= MaxBackwardsNearJump 	// Allow for jump over extension too
		:	
	// If the jump is currently long, then we may be able to reduce it by removing the extra
	// extension byte, so account for that too
	(offset-(extensionBytes-1)) <= MaxForwardsNearJump;
}

// Is distance within the range of jumps possible from the current long jump instruction (accounting for
// the size of the instruction). 
inline static bool isInLongJumpRange(int distance)
{
	int offset = distance - 3;
	return offset >= MaxBackwardsLongJump && offset <= MaxForwardsLongJump;
}

int Compiler::ShortenJumps()
{
	// Run through seeing if any shorter jumps can be used. Return a count
	// of the number of jumps shortened.
	//
	int count=0, i=0;
	while (i<GetCodeSize())
	{
		//_CrtCheckMemory();
		// Fix up jumps
		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.isOpCode());
		if (bytecode.isJumpSource())
		{
			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			_ASSERTE(bytecode.target < GetCodeSize());
			BYTECODE& target = m_bytecodes[bytecode.target];
			_ASSERTE(target.isJumpTarget());
			BYTE targetByte = target.byte;
			int distance = bytecode.target - i;
			switch (bytecode.byte)
			{
				
				//////////////////////////////////////////////////////////////////////////////////
				// Single byte Short jumps. Obviously these cannot be shorted further
			case ShortJump:
				_ASSERTE(!target.isReturn());
			case ShortJumpIfFalse:
				break;
				
				//////////////////////////////////////////////////////////////////////////////////
				// Double byte Near jumps. Might be possible to shorten to single byte Short jumps
				
			case NearJump:
				// Unconditional Jumps to return instructions can be replaced with the return instruction
				_ASSERTE(!target.isReturn());
				if (isInShortJumpRange(distance, 1))		// Account for extension
				{
					// Can shorten to short jump
					bytecode.byte=ShortJump;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case NearJumpIfTrue:
				if (isInShortJumpRange(distance, 1))
				{
					// Currently there is no short jump if true, compiler will optimize away
				}
				break;
				
			case NearJumpIfFalse:
				if (isInShortJumpRange(distance, 1))
				{
					// Can shorten to short jump
					bytecode.byte=ShortJumpIfFalse;
					RemoveByte(i+1);
					count++;
				}
				break;
				
				
				//////////////////////////////////////////////////////////////////////////////////
				// Triple byte long jumps. Might be possible to shorten to short or near jumps
				
			case LongJump:
				// Unconditional Jumps to return instructions should have been replaced with the 
				// return instruction
				_ASSERTE(!target.isReturn());
				if (isInNearJumpRange(distance, 2))
				{
					// Can shorten to near jump
					bytecode.byte=NearJump;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case LongJumpIfTrue:
				if (isInNearJumpRange(distance, 2))
				{
					// Can shorten to near jump
					bytecode.byte=NearJumpIfTrue;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case LongJumpIfFalse:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.byte=NearJumpIfFalse;
					RemoveByte(i+1);
					count++;
				}
				break;
				
				// Blocks contain a jump too, but they cannot be shortened at the moment
				// Could implement a 3 byte block copy instruction to allow for this.
			case BlockCopy:
				break;
				
			case NearJumpIfNil:
			case NearJumpIfNotNil:
				// No short versions
				break;

			case LongJumpIfNil:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.byte = NearJumpIfNil;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case LongJumpIfNotNil:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.byte=NearJumpIfNotNil;
					RemoveByte(i+1);
					count++;
				}
				break;

			default:
				// A bogus jump instruction?
				_ASSERTE(0);
			}
		}
		int len = m_bytecodes[i].instructionLength();
		i += len;
	}
	return count;
}

// Not that the Dolphin instruction set diverges form the Blue Book quite significantly for Jump instructions.
// We have an orthogonal set of simpler instructions which can be either Short (+2..+9), Near (-127..+128), 
// or Long (-32767..32768).
// N.B. When fetching an instruction the VM increments IP automatically, which explains the offset from the normal
// twos complement ranges for bytes and words for the longer instructions (the data part of the instruction is
// not read by fetching). In the case of the short instructions the VM adds an additional 1 to the jump offset
// to extend the range of jumps that can be handled by a short jump (since jump 0 is effectively jump to the 
// next instruction, which is not much use) - i.e. the zero based offset in the instruction is converted to 1 based.
void Compiler::FixupJump(int pos)
{
	// Fixes up the jump at pos
	const int targetIP = m_bytecodes[pos].target;
	_ASSERTE(targetIP < GetCodeSize());
	_ASSERTE(m_bytecodes[targetIP].isJumpTarget());	// Otherwise optimization could have gone wrong
	int distance=targetIP - pos;
	
	switch (m_bytecodes[pos].byte)
	{
	case ShortJump:
	case ShortJumpIfFalse:
		{
			// Short jumps
			_ASSERTE(isInShortJumpRange(distance,0));
			int offset = distance - 2;				// IP advanced over instruction, and VM adds 1 too to
			// extend the useful range of short jumps (no point jumping
			// to the next instruction)
			_ASSERTE(pos+distance < GetCodeSize());
			m_bytecodes[pos].byte += offset;
		}
		break;
		
	case NearJump:
	case NearJumpIfFalse:
		_ASSERTE(!WantOptimize() || !isInShortJumpRange(distance, 1));	// Why not optimized?
	case NearJumpIfTrue:
	case NearJumpIfNil:
	case NearJumpIfNotNil:
		{
			// Unconditional jump
			_ASSERTE(isInNearJumpRange(distance, 1));
			int offset = distance - 2;				// IP inc'd for instruction and extension byte
			
			_ASSERTE(!WantOptimize() || offset != 0);	// Why not optimized out?
			_ASSERTE(offset >= -128 && offset <= 127);
			
			_ASSERTE(pos+distance < GetCodeSize());
			m_bytecodes[pos+1].byte = offset;
		}
		break;
		
	case LongJump:
	case LongJumpIfTrue:
	case LongJumpIfFalse:
	case LongJumpIfNil:
	case LongJumpIfNotNil:
		{
#if defined(_DEBUG)
	#define MASK_BYTE(op) ((op) & 0xFF)
#else
	#define MASK_BYTE(op) (op)
#endif
			// Unconditional jump
			_ASSERTE(!WantOptimize() || !isInNearJumpRange(distance,2));	// Why not optimized?
			int offset = distance - 3;				// IP inc'd for instruction, and extension bytes
			if (offset < MaxBackwardsLongJump || offset > MaxForwardsLongJump)
			{
				CompileError(CErrMethodTooLarge);
			}
			_ASSERTE(pos+distance < GetCodeSize());
			m_bytecodes[pos+1].byte = BYTE(MASK_BYTE(offset));
			m_bytecodes[pos + 2].byte = BYTE(MASK_BYTE(offset >> 8));
		}
		break;
		
	case BlockCopy:
		{
			// BlockCopy contains an implicit jump
			int offset = distance - BlockCopyInstructionLength;				// IP inc'd for instruction, and extension bytes
			if (offset < MaxBackwardsLongJump || offset > MaxForwardsLongJump)
			{
				CompileError(CErrMethodTooLarge);
			}
			_ASSERTE(pos+distance < GetCodeSize());
			m_bytecodes[pos + 5].byte = BYTE(MASK_BYTE(offset));
			m_bytecodes[pos + 6].byte = BYTE(MASK_BYTE(offset >> 8));
		}
		break;
		
	default:
		// Illegal jump basic
		_ASSERTE(0);
	}
}

inline void Compiler::MakeQuickMethod(STMethodHeader& hdr, STPrimitives primitiveIndex)
{
	hdr.isInt = TRUE;	// To be valid SmallInteger this is necessary
	hdr.primitiveIndex = primitiveIndex;
}

POTE Compiler::NewMethod()
{
	// Must do this before generate the bytecodes as the textmaps may be offset if packed
	VerifyTextMap(true);

	if (!m_ok || WantSyntaxCheckOnly())
		return m_piVM->NilPointer();

	int blockCount = Pass2();
	
	_ASSERTE(sizeof(STMethodHeader) == sizeof(MWORD));
	_ASSERTE(GetLiteralCount()<=LITERALLIMIT);
	
	// As we keep the class of the method in the method, we no longer need to store the super
	// class as an extra literal
	
	STMethodHeader hdr;
	*(MWORD*)&hdr = 0;
	
	// Set the needsContext flag if any literal blocks (non-optimized) are used
	// within this method.
	hdr.isInt = TRUE;
	
	// Work out method header flag value
	// There are some special cases for primitive returns of self
	// and instance variables which we deal with here
	//

	LexicalScope* pMethodScope = m_allScopes[0];
	// Need this in case we choose to gen some code
	m_pCurrentScope = pMethodScope;
	_ASSERTE(pMethodScope->GetCopiedTemps().size() == 0);
	int numEnvTemps = pMethodScope->GetSharedTempsCount();
	bool bHasFarReturn = pMethodScope->HasFarReturn();
	bool bNeedsContext = bHasFarReturn || numEnvTemps > 0;

	BYTE byte1=m_bytecodes[0].byte;
	BYTE byte2=Nop;
	BYTE byte3=Nop;
	int len = GetCodeSize();
	if (len > 1)
	{
		byte2 = m_bytecodes[1].byte;
		if (len > 2)
			byte3=m_bytecodes[2].byte;
	}

	if (m_primitiveIndex!=0)
	{
		// Primitive
		// This is not a valid assertion, since primitive methods
		// can have any form of Smalltalk backup code
		//_ASSERTE(!hdr.m_needsContextFlag);
		MakeQuickMethod(hdr, STPrimitives(m_primitiveIndex));
		//classRequired=true;
	}
	else if (m_bytecodes[0].isPseudoReturn())
	{
		//_ASSERTE(!bNeedsContext); Not a valid assertion, since could have a block after the return at the top
		// Primitive return of self, true, false, nil
		MakeQuickMethod(hdr, STPrimitives(PRIMITIVE_RETURN_SELF + (byte1 - FirstPseudoReturn)));
		
		// We go ahead and generate the bytes anyway, as they'll fit in a SmallInteger and
		// may be of interest for debugging/browsing
		_ASSERTE(GetCodeSize() < sizeof(MWORD));
	}
	else if (byte1 == ShortPushConst && byte2 == ReturnMessageStackTop)
	{
		// Primitive return of literal zero
		_ASSERTE(!bNeedsContext);
		_ASSERTE(GetLiteralCount()>0);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);

		// Note that in this case the literal may be a clean block, in which case the code size
		// may well be greater than will fit in a SmallInteger
		// _ASSERTE(GetCodeSize() < sizeof(MWORD));
	}
	else if (m_bytecodes[0].isShortPushConst() && byte2 == ReturnMessageStackTop && GetCodeSize() == 2)
	{
		// Primitive return of literal zero from a ##() expression that generated literal frame entries
		_ASSERTE(!bNeedsContext);
		_ASSERTE(GetLiteralCount()>1);
		int index = m_bytecodes[0].indexOfShortPushConst();
		Oop tmp = m_literalFrame[0];
		m_literalFrame[0] = m_literalFrame[index];
		m_literalFrame[index] = tmp;
		m_bytecodes[0].byte = ShortPushConst;
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
	}
	else if (byte1 == ShortPushStatic && byte2 == ReturnMessageStackTop)
	{
		// Primitive return of literal zero
		_ASSERTE(!bNeedsContext);
		_ASSERTE(GetLiteralCount()>0);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_STATIC_ZERO);

		// Note that in this case the literal may be a clean block, in which case the code size
		// may well be greater than will fit in a SmallInteger
		// _ASSERTE(GetCodeSize() < sizeof(MWORD));
	}
	else if (m_bytecodes[0].isShortPushStatic() && byte2 == ReturnMessageStackTop && GetCodeSize() == 2)
	{
		// Primitive return of literal zero from a ##() expression that generated literal frame entries
		_ASSERTE(!bNeedsContext);
		_ASSERTE(GetLiteralCount()>1);
		int index = m_bytecodes[0].indexOfShortPushStatic();
		Oop tmp = m_literalFrame[0];
		m_literalFrame[0] = m_literalFrame[index];
		m_literalFrame[index] = tmp;
		m_bytecodes[0].byte = ShortPushStatic;
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_STATIC_ZERO);
	}
	else if (m_bytecodes[0].isShortPushInstVar() && byte2 == ReturnMessageStackTop && GetArgumentCount() == 0)
	{
		// instance variable accessor method (<=15)
		_ASSERTE(!bNeedsContext);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_INSTVAR);
		
		// Convert to long form to simplify the interpreter's code to exec. this quick method.
		byte2 = m_bytecodes[0].indexOfPushInstVar();
		m_bytecodes[0].byte = byte1 = PushInstVar;
		m_codePointer = 1;
		GenData(byte2);
		m_codePointer++;
		byte3 = ReturnMessageStackTop;

		// We must go ahead and generate the bytes anyway as they are needed by the interpreter to 
		// determine which inst. var to push (they'll fit in a SmallInteger anyway)
		_ASSERTE(GetCodeSize() == 3);
	}
	else if (isPushInstVarX(byte1, byte2) && byte3 == ReturnMessageStackTop && GetArgumentCount() == 0)
	{
		// instance variable accessor method (>15)
		_ASSERTE(!bNeedsContext);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_INSTVAR);
		
		// We must go ahead and generate the bytes anyway as they are needed by the interpreter to 
		// determine which inst. var to push (they'll fit in a SmallInteger anyway)
		_ASSERTE(GetCodeSize() == 3);
	}
	else if (byte2 == ReturnMessageStackTop && m_bytecodes[0].isShortPushImmediate())
	{
		_ASSERTE(GetCodeSize() == 2 || !WantOptimize());
		_ASSERTE(m_bytecodes[1].isOpCode());
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);

		_ASSERTE(m_primitiveIndex == 0);
		Oop literalInt = IntegerObjectOf(byte1-ShortPushMinusOne-1);
		if (GetLiteralCount() > 0)
		{
			m_literalFrame.push_back(m_literalFrame[0]);
			m_literalFrame[0] = literalInt;
		}
		else
			AddToFrameUnconditional(literalInt, TEXTRANGE());
	}
	else if (byte1 == PushImmediate && byte3 == ReturnMessageStackTop)
	{
		_ASSERTE(GetCodeSize() == 3 || !WantOptimize());
		_ASSERTE(m_bytecodes[2].isOpCode());
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		SBYTE immediateByte = SBYTE(byte2);
		if (GetLiteralCount() > 0)
		{
			m_literalFrame.push_back(m_literalFrame[0]);
			m_literalFrame[0] = IntegerObjectOf(immediateByte);
		}
		else
			AddToFrameUnconditional(IntegerObjectOf(immediateByte), TEXTRANGE());
	}
	else if (byte1 == LongPushImmediate && m_bytecodes[3].byte == ReturnMessageStackTop)
	{
		_ASSERTE(GetCodeSize() >= 4);
		_ASSERTE(m_bytecodes[3].isOpCode());
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		SWORD immediateWord = SWORD(byte3 << 8) + byte2;
		if (GetLiteralCount() > 0)
		{
			m_literalFrame.push_back(m_literalFrame[0]);
			m_literalFrame[0] = IntegerObjectOf(immediateWord);
		}
		else
			AddToFrameUnconditional(IntegerObjectOf(immediateWord), TEXTRANGE());
	}
	else if (byte1 == PushChar && byte3 == ReturnMessageStackTop)
	{
		_ASSERTE(GetCodeSize() == 3 || !WantOptimize());
		_ASSERTE(m_bytecodes[2].isOpCode());
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		Oop oopChar = reinterpret_cast<Oop>(m_piVM->NewCharacter(byte2));
		if (GetLiteralCount() > 0)
		{
			m_literalFrame.push_back(m_literalFrame[0]);
			m_literalFrame[0] = oopChar;
		}
		else
			AddToFrameUnconditional(oopChar, TEXTRANGE());
	}
	else if ((byte1 == ShortPushTemp && GetArgumentCount() == 1 && GetCodeSize() <= sizeof(MWORD))
		&& ((byte2 == PopStoreInstVar && m_bytecodes[3].byte == ReturnSelf)
			||(m_bytecodes[1].isShortPopStoreInstVar() && byte3 == ReturnSelf)))
	{
		// instance variable set method
		_ASSERTE(!bNeedsContext);
		_ASSERTE((byte1 & 1) != 0);		// First must be odd, as VM assumes will be a packed method

		MakeQuickMethod(hdr, PRIMITIVE_SET_INSTVAR);
		
		// We go ahead and generate the bytes anyway, as they're needed by the primitive
	}
	else
	{
		// Standard code
		_ASSERTE(m_primitiveIndex == PRIMITIVE_ACTIVATE_METHOD);
	}
	
	if (bNeedsContext)
	{
		// There is a sublety in the envTempCount, which is that it is the number of required slots in the context+1
		// A value >= 0 indicates the need for a context. A value of 1, that no env temp slots are required, but
		// the context is needed to support a far return. Therefore we add 1 to flag that a context is needed
		// to avoid having to spend a whole bit on a flag, but this means the maximum number of env temps is 
		// actually (2^6)-2==62
		_ASSERTE(numEnvTemps < ENVTEMPLIMIT);
		hdr.envTempCount = numEnvTemps + 1;
	}

	_ASSERTE(pMethodScope->GetStackSize() <= TEMPORARYLIMIT);
	_ASSERTE(GetArgumentCount() <= ARGLIMIT);
	hdr.stackTempCount = pMethodScope->GetStackTempCount();
	hdr.argumentCount = GetArgumentCount();
	
	// Allocate CompiledMethod and install the header
	POTE method = NewCompiledMethod(m_compiledMethodClass, GetCodeSize(), hdr);
	STCompiledMethod& cmpldMethod = *(STCompiledMethod*)GetObj(method);
	
	// Install bytecodes
	if (!WantDebugMethod() //&& blockCount == 0
		&& (GetCodeSize() < sizeof(MWORD) 
			|| (GetCodeSize() == sizeof(MWORD) && ((byte1 & 1) != 0))))
	{
		Oop bytes = IntegerObjectOf(0);
		BYTE* pByteCodes = (BYTE*)&bytes;
		// IX86 is a little endian machine, so first must be odd for SmallInteger flag
		if ((byte1 & 1) == 0)
		{
			*pByteCodes++ = Nop;
			// Must adjust the text map to account for the leading Nop
			// Adjust ip of any TextMaps
			{
				const int loopEnd = m_textMaps.size();
				for (int i = 0; i < loopEnd; i++)
					m_textMaps[i].ip++;
			}
		}
		const int loopEnd = GetCodeSize();
		for (int i=0; i<loopEnd && i < sizeof(MWORD); i++)
			pByteCodes[i] = m_bytecodes[i].byte;
		m_piVM->StorePointerWithValue(&cmpldMethod.byteCodes, bytes);
	}
	else
	{
		BYTE* pByteCodes = FetchBytesOf(POTE(cmpldMethod.byteCodes));
		const int loopEnd = GetCodeSize();
		for (int i=0; i<loopEnd; i++)
			pByteCodes[i] = m_bytecodes[i].byte;
		m_piVM->MakeImmutable(cmpldMethod.byteCodes, TRUE);
	}
	
	PatchCleanBlockLiterals(method);

	// Install literals
	const int loopEnd = GetLiteralCount();
	for (int i=0; i<loopEnd; i++)
	{
		Oop oopLiteral = m_literalFrame[i];
		_ASSERTE(oopLiteral != NULL);
		m_piVM->StorePointerWithValue(&cmpldMethod.aLiterals[i], oopLiteral);
	}
	
	m_piVM->StorePointerWithValue((Oop*)&cmpldMethod.selector, Oop(m_piVM->NewString(GetSelector().c_str())));
	m_piVM->StorePointerWithValue((Oop*)&cmpldMethod.methodClass, Oop(m_class));

#if defined(_DEBUG)
	{
		char buf[512];
		wsprintf(buf, "Compiling %s>>%s for %s, %s\n", GetClassName().c_str(), m_selector.c_str(), 
			WantDebugMethod() ? "debug" : "release", m_ok ? "succeeded" : "failed");
		OutputDebugString(buf);
		
		if (m_ok && compilationTrace > 0)
		{
			disassemble();
		}
		
	}
#endif
	
	// Note the method is not made immutable by the compiler, so it can be updated in the image
	// to contain the source pointer, etc
	//m_piVM->MakeImmutable(reinterpret_cast<Oop>(method), TRUE);
	return method;
}

//////////////////////////////////////////////////

void Compiler::PatchCleanBlockLiterals(POTE oteMethod)
{
	const SCOPELIST::iterator loopEnd = m_allScopes.end();
	for (SCOPELIST::iterator it = m_allScopes.begin()+1; it != m_allScopes.end(); it++)
	{
		LexicalScope* pScope = (*it);
		if (pScope->IsCleanBlock())
			pScope->PatchBlockLiteral(m_piVM, oteMethod);
	}
}

int Compiler::FixupTempsAndBlocks()
{
	VerifyTextMap(false);

	// We must copy down any temps declared in optimized scopes to the actual scope
	// in which they will be allocated at run time. We must also merge in any temp 
	// references from those scopes so that these will be seen when we copy to
	// copy temps for copying blocks.
	PatchOptimizedScopes();

	VerifyTextMap(true);

	DetermineTempUsage();

	// Enumerate all lexical scopes in reverse, determining the index of each of the
	// temps declared in that scope (or copied into that scope).
	const SCOPELIST::reverse_iterator sloopEnd = m_allScopes.rend();
	for (SCOPELIST::reverse_iterator sit = m_allScopes.rbegin();sit != sloopEnd; sit++)
	{
		LexicalScope* pScope = (*sit);
		pScope->CopyTemps(this);

		if (!pScope->IsOptimizedBlock())
			pScope->AllocTempIndices(this);
	}

	// Maybe should combine these into one scan of the bytecodes? Can't do that because the 
	// block's outer flag can only be set once we've found all shared temps refs. Although
	// that could be done by scanning the scopes after determining temp usage. Note that 
	// calculating whether a block references shared temps (and therefore needs an outer
	// pointer) dynamically on demand would be tricky because the refs in the optimized
	// blocks have not been moved down into the actual block (although I suppose they could
	// be, in the same way that the declarations are moved down).
	FixupTempRefs();

	VerifyTextMap(true);

	return PatchBlocks();
}

// Currently any temps declared in an optimized block, will be declared in that scope. We need
// to copy these declarations into the nearest enclosing full scope (in which they will be marked
// as invisible so they do not appear in the temp map) so that they can be allocated in the right
// place. We must also merge in the temp references so that these are taken into account when
// copying temps (if any). An example of where this would be needed is:
//		| a | a := 1. [2 > 1 ifTrue: [a]] value
// In this case the closed over temp 'a' can be copied, because it is not written after the creation
// of the closure. However it is only referenced from an optimized block inside the block into which
// it needs to be copied, so we must be careful to make sure that the reference is taken into account
// when copying temps.
void Compiler::PatchOptimizedScopes()
{
	_ASSERTE(m_allScopes.size() >= 1);
	const SCOPELIST::iterator loopEnd = m_allScopes.end();
	for (SCOPELIST::iterator it = m_allScopes.begin()+1;it != loopEnd; it++)
	{
		LexicalScope* pScope = (*it);
		pScope->PatchOptimized(this);
	}
}

void Compiler::DetermineTempUsage()
{
	BYTECODES::const_iterator loopEnd = m_bytecodes.end();
	BYTECODES::const_iterator it = m_bytecodes.begin();
	while (it != loopEnd)
	{
		const BYTECODE& bytecode1 = (*it);
		int len1 = bytecode1.instructionLength();

		_ASSERTE(!bytecode1.isPushTemp());

		switch(bytecode1.byte)
		{
		case LongPushOuterTemp:
		case LongStoreOuterTemp:
			bytecode1.pVarRef->MergeRefIntoDecl(this);
			break;

#ifdef _DEBUG
		case PushOuterTemp:
		case StoreOuterTemp:
		case PopStoreOuterTemp:
		case PushTemp:
		case PopStoreTemp:
		case StoreTemp:
			_ASSERT(false);
			break;
#endif

		default:
			break;
		};

		it += len1;
	}
}

int Compiler::FixupTempRefs()
{
	int count=0;
	BYTECODES::iterator loopEnd = m_bytecodes.end();
	BYTECODES::iterator it = m_bytecodes.begin();
	while (it != loopEnd)
	{
		const BYTECODE& bytecode1 = (*it);
		const int len1 = bytecode1.instructionLength();

		switch(bytecode1.byte)
		{
		case LongPushOuterTemp:
		case LongStoreOuterTemp:
			FixupTempRef(it);
			count++;
			break;

		case FarReturn:
			bytecode1.pScope->MarkFarReturner();
			break;

		default:
			break;
		};

		it += len1;
	}

	return count;
}

void Compiler::FixupTempRef(BYTECODES::iterator it)
{
	BYTECODE& byte1 = (*it);
	BYTECODE& byte2 = *(it+1);
	BYTECODE& byte3 = *(it+2);
	_ASSERTE(byte1.isOpCode());
	_ASSERTE(byte2.isData());
	_ASSERTE(byte3.isData());

	TempVarRef* pVarRef = byte1.pVarRef;
	_ASSERTE(pVarRef != NULL);
	int index = pVarRef->GetDecl()->GetIndex();
	_ASSERTE(index >= 0 && index < 255);

	bool bIsPush = byte1.byte == LongPushOuterTemp;

	TempVarType varType = pVarRef->GetVarType();
	switch(varType)
	{
	case tvtCopy:
	case tvtStack:
	case tvtCopied:
		if (bIsPush)
		{
			if (index < NumShortPushTemps)
			{
				byte1.byte = ShortPushTemp + index;
				byte2.makeOpCode(Nop, byte1.pScope);
			}
			else
			{
				byte1.byte = PushTemp;
				byte2.byte = index;
			}
		}
		else
		{
			if (index < NumShortStoreTemps)
			{
				byte1.byte = ShortStoreTemp + index;
				byte2.makeOpCode(Nop, byte1.pScope);
			}
			else
			{
				byte1.byte = StoreTemp;
				byte2.byte = index;
			}
		}
		byte3.makeOpCode(Nop, byte1.pScope);
		break;

	case tvtShared:
		{
			int outer = pVarRef->GetActualDistance();
			_ASSERTE(outer >= 0 && outer < 256);
			TempVarDecl* pDecl = pVarRef->GetDecl();
			_ASSERTE(pDecl == pVarRef->GetActualDecl());
			if (outer > 0)
				pVarRef->GetScope()->SetReferencesOuterTempsIn(pDecl->GetScope());

			_ASSERTE(index < pDecl->GetScope()->GetSharedTempsCount());

			if (outer < 2 && index < NumPushContextTemps && bIsPush)
			{
				byte1.byte = (outer == 0 ? ShortPushContextTemp : ShortPushOuterTemp) + index;
				byte2.makeNop();
				byte3.makeNop();
			}
			else if (outer <= OuterTempMaxDepth && index <= OuterTempMaxIndex)
			{
				byte1.byte = bIsPush ? PushOuterTemp : StoreOuterTemp;
				byte2.byte = (outer << OuterTempIndexBits) | index;
				byte3.makeNop();
			}
			else
			{
				byte2.byte = outer;
				byte3.byte = index;
			}
		}
		break;

	case tvtUnaccessed:
	default:
		{
			TempVarDecl* pDecl = pVarRef->GetDecl();
			InternalError(__FILE__, __LINE__, pVarRef->GetTextRange(), 
				"Invalid temp variable state %d for '%s'", 
				pVarRef->GetVarType(), pVarRef->GetName().c_str());
		}
		break;
	};
}

int Compiler::PatchBlocks()
{
	int i=0;
	int blockCount = 0;
	while (i < GetCodeSize())
	{
		VerifyTextMap(true);

		BYTECODE& bytecode1=m_bytecodes[i];
		int len1 = bytecode1.instructionLength();

		switch(bytecode1.byte)
		{
		case BlockCopy:
			len1 += PatchBlockAt(i);
			blockCount++;
			break;

		default:
			break;
		};

		i += len1;
	}

	return blockCount;
}

// Push any copied values in reverse order for the block at the specified position in the bytecodes
// Answers the number of extra bytes generated to push copied values. These are generated
// before the block.
int Compiler::PatchBlockAt(int i)
{
	BYTECODE& byte1 = m_bytecodes[i];
	_ASSERTE(byte1.byte == BlockCopy);
	LexicalScope* pScope = byte1.pScope;
	_ASSERTE(pScope != NULL);
	_ASSERTE(!pScope->GetOuter()->IsOptimizedBlock());
	// Self and far return flags should have been propagated by now
	_ASSERTE(!pScope->NeedsSelf() || pScope->GetOuter()->NeedsSelf());
	_ASSERTE(!pScope->HasFarReturn() || pScope->GetOuter()->HasFarReturn());

	if (pScope->IsCleanBlock())
	{
		MakeCleanBlockAt(i);
		return 0;
	}

	// From now on we don't want this instruction to appear to be part of this block's scope
	byte1.pScope = pScope->GetOuter();

	//	BlockCopy
	//	+1	nArgs
	//	+2	nStack
	//	+3	(nEnv << 1) | (0|1)		bottom bit set if outer ref. required
	//	+4	nCopiedTemps
	//	+5	jumpOffset1
	//		jumpOffset2
	_ASSERTE(m_bytecodes[i+1].byte == pScope->GetArgumentCount());
	m_bytecodes[i+2].byte = pScope->GetStackTempCount();

	// Note that the env size includes the env temps and copied temps
	int nEnvSize = pScope->GetSharedTempsCount();
	_ASSERTE(nEnvSize < 128);
	int needsOuter = pScope->NeedsOuter();
	m_bytecodes[i+3].byte = (nEnvSize << 1) | needsOuter;

	int nCopied = pScope->GetCopiedValuesCount();
	_ASSERTE(nCopied < 128);
	m_bytecodes[i+4].byte = (nCopied << 1) | (pScope->NeedsSelf() ?1:0);

	// This text map is needed by the Debugger to remap the initial IP of block frames.
	int blockStart = pScope->GetTextRange().m_start;
	InsertTextMapEntry(i + BlockCopyInstructionLength, blockStart, blockStart-1);

	if (nCopied == 0)
		return 0;

	////////////////////////////////////////////////////////////////////////////////////////
	// Generate push temp instructions for all values to be copied from enclosing scope
	//
	_ASSERTE(m_codePointer == GetCodeSize());
	_ASSERTE(!byte1.isJumpTarget());
	m_codePointer = i;

	LexicalScope* pOuter = pScope->GetOuter();
	_ASSERT(pOuter != NULL);
	m_pCurrentScope = pOuter;

	int extraBytes = 0;
	DECLLIST& copiedTemps = pScope->GetCopiedTemps();
	const DECLLIST::reverse_iterator loopEnd = copiedTemps.rend();
	for (DECLLIST::reverse_iterator it = copiedTemps.rbegin(); it != loopEnd; it++)
	{
		TempVarDecl* pCopy = (*it);
		TempVarDecl* pCopyFrom = pCopy->GetOuter();
		if (pCopyFrom == NULL || pCopyFrom->GetScope() != pOuter)
			InternalError(__FILE__, __LINE__, pCopy->GetTextRange(), "Copied temp '%s' not found in outer scope", pCopy->GetName().c_str());

		// Its a copied value, so must be local to this environment
		extraBytes += GenPushCopiedValue(pCopyFrom);
	}

	m_pCurrentScope = NULL;

	m_codePointer = GetCodeSize();

	return extraBytes;
}

void Compiler::MakeCleanBlockAt(int i)
{
	BYTECODE& byte1 = m_bytecodes[i];
	_ASSERTE(byte1.byte = BlockCopy);
	_ASSERTE(byte1.instructionLength() == BlockCopyInstructionLength);
	int initIP = i + BlockCopyInstructionLength;
	BYTECODE& firstInBlock = m_bytecodes[initIP];
	BYTECODE& secondInBlock = m_bytecodes[initIP + firstInBlock.instructionLength()];

	LexicalScope* pScope = byte1.pScope;
	_ASSERTE(pScope->IsBlock());

	LexicalScope* pOuter = pScope->GetOuter(); 
	byte1.pScope = pOuter;

	// If a Clean block, then we can patch out the block copy replacing it
	// with a push of a literal block we store in the frame, and a jump
	// over the blocks bytecodes.

	POTE blockPointer = GetVMPointers().EmptyBlock;
	bool useEmptyBlock = pScope->IsEmptyBlock() && blockPointer != Nil() && !WantDebugMethod();

	if (useEmptyBlock)
	{
		_ASSERTE(!firstInBlock.isJumpTarget());
		_ASSERTE(!secondInBlock.isJumpTarget());
		_ASSERTE(!WantDebugMethod());
	}
	else
	{
		blockPointer = m_piVM->NewObjectWithPointers(GetVMPointers().ClassBlockClosure, 
		((sizeof(STBlockClosure)
			-sizeof(Oop)	// Deduct dummy literal frame entry (arrays cannot be zero sized in IDL)
//			-sizeof(ObjectHeader)	// Deduct size of head which NewObjectWithPointers includes implicitly
		)/sizeof(Oop)));

		pScope->SetCleanBlockLiteral(blockPointer);
	}

	int index = AddToFrame(reinterpret_cast<Oop>(blockPointer), pScope->GetTextRange());
	if (index < NumShortPushConsts)		// In range of short instructions ?
	{
		byte1.byte = ShortPushConst + index;
		UngenData(i+1);
		UngenData(i+2);
	}
	else if (index < 256)				// In range of single extended instructions ?
	{
		byte1.byte = PushConst;
		m_bytecodes[i+1].byte = index;
		UngenData(i+2);
	}
	else
	{
		byte1.byte = LongPushConst;
		m_bytecodes[i+1].byte = index & 0xFF;
		m_bytecodes[i+2].byte = index >> 8;
	}

	// The block copy is no longer a jump, being replaced by byte 4 (or not at all if empty)
	byte1.makeNonJump();

	initIP = i;
	if (useEmptyBlock)
	{
		int j=i+3;
		for(;j<i+BlockCopyInstructionLength;j++)
			UngenData(j);
		while(m_bytecodes[j].byte != ReturnBlockStackTop)
		{
			_ASSERTE(m_bytecodes[j].isOpCode());
			UngenInstruction(j);
			j++;
		}
		// We must retain the text map entry in order that debug and release text maps match
		// We'll have to map it onto the push const instruction
		VERIFY(AdjustTextMapEntry(j, i));
		UngenInstruction(j);
	}
	else
	{
		UngenData(i+3);

		m_bytecodes[i+4].makeOpCode(LongJump, pOuter);
		m_bytecodes[i+4].makeJumpTo(byte1.target);

		// +5 and +6 remain the jump offset

		initIP += BlockCopyInstructionLength;
		_ASSERTE(m_bytecodes[initIP].isOpCode());
		// We must mark the blocks first bytecode as a jump target to prevent
		// it being treated as unreachable code
		m_bytecodes[initIP].addJumpTo();
	}

	if (!pScope->IsEmptyBlock())
	{
		// This text map is needed by the Debugger to remap the initial IP of block frames.
		int blockStart = pScope->GetTextRange().m_start;
		InsertTextMapEntry(initIP, blockStart, blockStart-1);
	}
}

