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
#include <utility>

#include <crtdbg.h>
#define CHECKREFERENCES

#ifdef _DEBUG
static int compilationTrace = 0;

#elif !defined(USE_VM_DLL)
#undef NDEBUG
#include <assert.h>
#undef _ASSERTE
#define _ASSERTE assert
#endif

const size_t BlockCopyInstructionLength = 7;

//////////////////////////////////////////////////
// Some helpers for optimisation

//////////////////////////////////////////////////

inline size_t Compiler::Pass2()
{
	// Optimise generated code
	size_t blockCount = FixupTempsAndBlocks();
	RemoveNops();
	if (WantOptimize)
		Optimize();
	FixupJumps();
	return blockCount;
}

void Compiler::RemoveNops()
{
	ip_t i=ip_t::zero;
	while (i<=LastIp)		// Note that codeSize can change (reduce) as Nops removed
	{
		const BYTECODE& bc = m_bytecodes[i];
		_ASSERTE(bc.IsOpCode);
		_ASSERTE(!bc.IsJumpSource || (bc.target >= ip_t::zero && bc.target <= LastIp));

		switch (bc.Opcode)
		{
		case OpCode::Nop:
			// The Nop might be a jump target, in which case we must copy the inbound jump count to
			// the new byte code at the position. RemoveByte() does this (or should)
			RemoveBytes(i, 1);
			VerifyTextMap();
			break;

		default:
			i += bc.InstructionLength;
			break;
		}
	}
} 

void Compiler::Optimize()
{
	VerifyJumps();

	// Perform a series of (generally) peephole optimizations
	// Optimize pairs of instructions, shorten jumps, and combine pairs into macro instructions
	
	// Cycle until no further reductions in pairs of instructions or jumps
	// are possible - note that we must loop round again after CombinePairs
	// because that may introduce further macro "return" instructions that combine
	// with other instructions, and these could allow for further jump
	// optimisations. There may be other optimisations enabled by the macro
	// instructions too.

	size_t count;
	do
	{
		do
		{
			// 
			while (OptimizePairs()) {}

			// We only need to go around the outer loop again if some jumps are optimized
			count = 0;
			while (OptimizeJumps())
				count++;
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
inline size_t Compiler::RemoveInstruction(ip_t ip)
{
	_ASSERTE(ip <= LastIp);
	BYTECODE& bc = m_bytecodes[ip];
	// We should be removing an instruction 
	_ASSERTE(bc.IsOpCode);

#ifdef _DEBUG
	{
		const TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
		if (it != m_textMaps.end())
		{
			ip_t prevIP = ip - 1;
			while (prevIP >= ip_t::zero && (m_bytecodes[prevIP].IsData || m_bytecodes[prevIP].Opcode == OpCode::Nop))
				--prevIP;
			const BYTECODE* prev = prevIP < ip_t::zero ? nullptr : &m_bytecodes[prevIP];
			bool isFirstInBlock = bc.pScope != nullptr && bc.pScope->IsBlock 
				&& (bc.pScope->InitialIP == ip || (prev != nullptr && (prev->Opcode == OpCode::BlockCopy || bc.pScope != prev->pScope)));
			_ASSERTE(ip == ip_t::zero || isFirstInBlock);
		}
	}
#endif

	// We're about to remove an unreachable jump, so we want to inform
	// its jump target in case that can be optimized away too
	if (bc.IsJumpSource)
	{
		_ASSERTE(bc.target <= LastIp);
		BYTECODE& target = m_bytecodes[bc.target];
		target.removeJumpTo();
	}
	
	size_t len = bc.InstructionLength;
	RemoveBytes(ip, len);

	return len;
}


// Remove a sequence of bytes from the code array
// Adjusts any jumps that occur over the boundary
// This is very slow if the bytecode array is large
void Compiler::RemoveBytes(ip_t ip, size_t count)
{
	_ASSERTE(ip >= ip_t::zero && count > 0);
	ip_t last = LastIp;
	const ip_t next = ip + count;
	_ASSERTE(next <= last+1);
	const BYTECODE& bc = m_bytecodes[ip];
	auto jumpsTo = bc.jumpsTo;

	const BYTECODES::iterator begin = m_bytecodes.begin();
	m_bytecodes.erase(begin + static_cast<size_t>(ip), begin + static_cast<size_t>(next));
	
	last -= count;
	if (ip <= last)
	{
		_ASSERTE(jumpsTo == 0 || m_bytecodes[ip].IsOpCode);
		// Following byte may become jump target
		m_bytecodes[ip].jumpsTo += jumpsTo;
	}
	else
	{
		// Removed last instruction, which should not have happened if it was a jump target
		_ASSERTE(!jumpsTo);
	}


	// Adjust any jumps to targets past the removal point as the target will have shuffled up
	{
		for (ip_t i = ip_t::zero; i < last;)
		{
			BYTECODE& bc = m_bytecodes[i];
			_ASSERTE(bc.IsOpCode);
			if (bc.IsJumpSource)
			{
				_ASSERTE(bc.target <= last + count);
				// This is a jump. Does it cross the boundary
				if (bc.target >= next)
					bc.target -= count;		// Yes, adjust absolute target
				_ASSERTE(bc.target >= ip_t::zero);
			}

			i += lengthOfByteCode(bc.Opcode);
		}
	}
	
	// Adjust ip of any TextMaps
	{
		const size_t textMapCount = m_textMaps.size();
		for (size_t i = 0; i < textMapCount; i++)
		{
			TEXTMAP& textMap = m_textMaps[i];
			// If the text map entry is in the range of removed bytes, adjust it to point at the next instruction
			// If the text map is for a later instruction, then adjust its ip to keep pointing at the same (moved up) instruction
			ip_t mapIp = textMap.ip;
			if (mapIp > ip)
			{
				textMap.ip = mapIp < next ? ip : mapIp - count;
				_ASSERTE(textMap.ip <= last);
				AssertValidIpForTextMapEntry(textMap.ip, false);
			}
		}
	}
}

inline int decodeOuterTempRef(uint8_t byte, int& index)
{
	index = byte & OuterTempMaxIndex;
	return byte >> OuterTempIndexBits;
}

bool Compiler::AdjustTextMapEntry(ip_t ip, ip_t newIP)
{
	if (!WantTextMap) return true;

	const size_t count = m_textMaps.size();
	for (size_t i = 0; i < count; i++)
	{
		TEXTMAP& textMap = m_textMaps[i];
		if (textMap.ip == ip)
		{
			textMap.ip = newIP;
			return true;
		}
	}
	return false;
}

size_t Compiler::OptimizePairs()
{
	// Optimize pairs of instructions.
	// Returns a count of the optimizations done.
	size_t count = 0;
	size_t lastCount = 0;
	ip_t i = ip_t::zero;
	while (i <= LastIp)
	{
#ifdef _DEBUG
		if (count > lastCount)
		{
			lastCount = count;
			VerifyTextMap();
			VerifyJumps();
		}
#endif

		BYTECODE& bytecode1=m_bytecodes[i];
		const size_t len1 = bytecode1.InstructionLength;
		const ip_t next = i+len1;
		if (next > LastIp)
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		_ASSERTE(bytecode1.IsOpCode && bytecode2.IsOpCode);
		
		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.IsJumpTarget)
		{
			auto byte1 = bytecode1.Opcode;
			auto byte2 = bytecode2.Opcode;

			// If the first is a push of a special and the second
			// is a return from message then we may be able to replace
			// by a return special but only if the second is not a jump
			// target.
			//
			if (bytecode1.IsPseudoPush && byte2 == OpCode::ReturnMessageStackTop)
			{
				// Can avoid need to modify text map if we remove the push and adjust the return instruction
				bytecode2.opcode = OpCode::ReturnSelf + (byte1 - OpCode::ShortPushSelf);
				RemoveInstruction(i);
				count++;
				continue;	// Go round again without advancing, to reconsider the changed instruction
			}

			// We must perform same optimisation in debug code to keep the text maps synchronised
			else if (bytecode1.IsPseudoPush && byte2 == OpCode::Break && m_bytecodes[next+1].Opcode == OpCode::ReturnMessageStackTop)
			{
				m_bytecodes[next+1].opcode = OpCode::ReturnSelf + (byte1 - OpCode::ShortPushSelf);
				RemoveInstruction(i);
				_ASSERTE(m_bytecodes[i].Opcode == OpCode::Break);
				count++;
				continue;
			}

			else if (byte1 == OpCode::PopPushSelf && byte2 == OpCode::ReturnMessageStackTop)
			{
				// Although the result of a previous optimisation, this code sequence has a slightly more 
				// efficient form, also it can be optimised down further to Pop; Return Self.
				bytecode1.opcode = OpCode::PopStackTop;
				bytecode2.opcode = OpCode::ReturnSelf;
				count++;
				continue;
			}
			
			// Quite a lot of pushes are redundant, and can be removed...
			else if (bytecode1.IsPush)
			{
				// A push immediately followed by a pop that is not immediately
				// jumped to can be replaced by nothing.
				if (byte2== OpCode::PopStackTop ||
					// These conditional jumps never executed as immediately following push of opposite boolean
					(byte1==OpCode::ShortPushTrue && byte2 == OpCode::LongJumpIfFalse) ||
					(byte1==OpCode::ShortPushFalse && byte2 == OpCode::LongJumpIfTrue) ||
					(byte1==OpCode::ShortPushNil && byte2 == OpCode::LongJumpIfNotNil)
					)
				{
					_ASSERTE(!bytecode2.IsJumpTarget);
					if (byte2 != OpCode::PopStackTop)
						VoidTextMapEntry(next);
					RemoveInstruction(i);
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				
				// Push followed by pseudo return is redundant, and can be removed leaving on the return
				else if (bytecode2.IsPseudoReturn)
				{
					_ASSERTE(!bytecode2.IsJumpTarget);
					RemoveInstruction(i);
					count++;
					continue;	// Continue optimization on the pseudo return now move to i
				}
				
				else if (byte2 == OpCode::LongJumpIfNotNil)
				{
					// If jump on non-nil following a Push to the same Push followed by return TOS, can replace with ReturnIfNotNil
					// e.g. Code of the form
					//	var isNil ifTrue: [var := ...].
					//	^var
					ip_t jumpTo = bytecode2.target;
					BYTECODE& target = m_bytecodes[jumpTo];
					if (AreBytecodesSame(i, jumpTo) && m_bytecodes[jumpTo + target.InstructionLength].IsReturnStackTop)
					{
						target.removeJumpTo();
						_ASSERTE(bytecode2.InstructionLength == 3);
						bytecode2.opcode = OpCode::ReturnIfNotNil;
						bytecode2.makeNonJump();
						RemoveBytes(next + 1, 2);		// Delete the jump extension bytes
						count++;
					}
				}
				// Same as previous optimisation in a debug method to keep text maps the same
				else if (byte2 == OpCode::Break && m_bytecodes[next+1].Opcode == OpCode::LongJumpIfNotNil)
				{
					BYTECODE& jump = m_bytecodes[next + 1];
					ip_t jumpTo = jump.target;
					BYTECODE& target = m_bytecodes[jumpTo];
					if (AreBytecodesSame(i, jumpTo) && m_bytecodes[jumpTo + target.InstructionLength+1].IsReturnStackTop)
					{
						target.removeJumpTo();
						_ASSERTE(jump.InstructionLength == 3);
						jump.opcode = OpCode::ReturnIfNotNil;
						jump.makeNonJump();
						RemoveBytes(next + 2, 2);		// Delete the jump extension bytes
						count++;
					}
				}

				else if (byte1 == OpCode::ShortPushTrue && byte2 == OpCode::LongJumpIfTrue)
				{
					// If push true followed by jump if true (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.IsJumpTarget);
					VoidTextMapEntry(i+1);
					bytecode2.opcode = OpCode::LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				else if (byte1 == OpCode::ShortPushFalse && byte2 == OpCode::LongJumpIfFalse)
				{
					// If push false followed by jump if false (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.IsJumpTarget);
					VoidTextMapEntry(i+1);
					bytecode2.opcode = OpCode::LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				else if (byte1 == OpCode::ShortPushNil && byte2 == OpCode::LongJumpIfNil)
				{
					// If push nil followed by jump if nil (which is not a jump target)
					// then equivalent to an unconditional jump
					_ASSERTE(!bytecode2.IsJumpTarget);
					VoidTextMapEntry(i+1);
					bytecode2.opcode = OpCode::LongJump;
					RemoveInstruction(i);	// Remove the push ...
					count++;
					continue;	// Continue optimization with unconditional jump now at i
				}
				// Push 1 followed by special send #+/#- can be replaced by increment/decrement
				// No further optimization of the increment/decrement is possible, so we move 
				// to the next instruction in these cases
				else if (byte1 == OpCode::ShortPushOne)
				{
					if (byte2 == OpCode::SendArithmeticAdd)
					{
						// To avoid having to adjust the text map entry, remove the push and update the SpecialSendAdd
						bytecode2.opcode = OpCode::IncrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == OpCode::SendArithmeticSub)
					{
						bytecode2.opcode = OpCode::DecrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == OpCode::Break)
					{
						// Must perform same optimisation in Debug method to keep text maps in sync
						// (otherwise would have wrong stack if remapped Increment to the Send+ as would 
						// be missing push 1)
						BYTECODE& bytecode3 = m_bytecodes[next+1];
						if ( bytecode3.Opcode == OpCode::SendArithmeticAdd)
						{
							bytecode3.opcode = OpCode::IncrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushOne, leave the Break before Increment
							count++;
							continue;
						}
						else if (bytecode3.Opcode == OpCode::SendArithmeticSub)
						{
							bytecode3.opcode = OpCode::DecrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushOne
							count++;
							continue;	// A new instruction will now be at i to be considered, so don't advance
						}
					}
				}

				// Push -1 followed by special send #+/#- can be replaced by increment/decrement
				else if (byte1 == OpCode::ShortPushMinusOne)
				{
					if (byte2 == OpCode::SendArithmeticAdd)
					{
						bytecode2.opcode = OpCode::DecrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushMinusOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == OpCode::SendArithmeticSub)
					{
						bytecode2.opcode = OpCode::IncrementStackTop;
						RemoveInstruction(i);	// Remove the ShortPushMinusOne
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					else if (byte2 == OpCode::Break)
					{
						// Must perform same optimisation in Debug method to keep text maps in sync
						// (otherwise would have wrong stack if remapped Increment to the Send+ as would 
						// be missing push 1)
						BYTECODE& bytecode3 = m_bytecodes[next+1];
						if (bytecode3.Opcode == OpCode::SendArithmeticAdd)
						{
							bytecode3.opcode = OpCode::DecrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushMinusOne, leave the Break before Increment
							count++;
							continue;
						}
						else if (bytecode3.Opcode == OpCode::SendArithmeticSub)
						{
							bytecode3.opcode = OpCode::IncrementStackTop;
							RemoveInstruction(i);	// Remove the ShortPushMinusOne
							count++;
							continue;	// A new instruction will now be at i to be considered, so don't advance
						}
					}

				}

				else if (byte1 == OpCode::ShortPushZero)
				{
					if (byte2 == OpCode::SpecialSendIdentical)
					{
						_ASSERTE(!bytecode1.IsJumpSource);
						bytecode2.opcode = OpCode::IsZero;
						RemoveInstruction(i);
						count++;
						continue;	// A new instruction will now be at i to be considered, so don't advance
					}
					// Tempting, but not really a valid optimisation since we don't know that the receiver is a Number at all
					//else if (byte2 == OpCode::SendArithmeticAdd || byte2 == OpCode::SendArithmeticSub)
					//{
					//	// Subtract or add zero is, of course, redundant
					//	_ASSERTE(!bytecode1.IsJumpSource);
					//	RemoveInstruction(i+1);
					//	RemoveInstruction(i);
					//	count++;
					//	continue;	// A new instruction will now be at i to be considered, so don't advance
					//}
				}
			}
			
			// Check for unreachable code (remember the following byte is known not to be a jump target)
			else if (bytecode1.IsReturn || bytecode1.IsLongJump)
			{
				VerifyJumps();
				VoidTextMapEntry(next);
				RemoveInstruction(next);
				count++; 
				
				// We don't want to advance ip here, since there may be more unreachable code
				continue;
			}
			
			else if (bytecode1.IsExtendedStore)
			{
				// A store instruction followed by a pop that is not immediately
				// jumped to can be coerced (heh heh) into a pop and store.
				if (byte2 == OpCode::PopStackTop)
				{
					_ASSERTE(!bytecode2.IsJumpTarget);
					if (byte1 == OpCode::StoreOuterTemp)
					{
						// Remove the popStack
						_ASSERTE(next == i + 2);

						int index;
						int depth = decodeOuterTempRef(m_bytecodes[i+1].byte, index);

						if (depth == 0 && index < NumPopStoreContextTemps)
						{
							bytecode1.opcode = OpCode::PopStoreContextTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							_ASSERTE(m_bytecodes[i+1].Opcode == OpCode::PopStackTop);
							RemoveInstruction(i+1);
						}
						else if (depth == 1 && index < NumPopStoreOuterTemps)
						{
							bytecode1.opcode = OpCode::ShortPopStoreOuterTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							_ASSERTE(m_bytecodes[i+1].Opcode == OpCode::PopStackTop);
							RemoveInstruction(i+1);
						}
						else
						{
							bytecode1.opcode = OpCode::PopStoreOuterTemp;
							RemoveInstruction(next);
						}
						count++;
					}
					else
					{
						bytecode1.opcode = byte1 - FirstExtendedStore + FirstPopStore;
						RemoveInstruction(next);
						count++;
						
						// Now there may be a shorter form of instruction that 
						// we can use
						_ASSERTE(m_bytecodes[i+1].IsData);
						
						_ASSERTE(i+1 <= LastIp);
						unsigned index = m_bytecodes[i+1].byte;
						if (bytecode1.Opcode == OpCode::PopStoreInstVar && index < NumShortPopStoreInstVars)
						{
							bytecode1.opcode = OpCode::ShortPopStoreInstVar + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							count++;
						}
						else if (bytecode1.Opcode == OpCode::PopStoreTemp && index < NumShortPopStoreTemps)
						{
							bytecode1.opcode = OpCode::ShortPopStoreTemp + index;
							RemoveByte(i+1);		// Delete the index belonging to the extended instruction
							count++;
						}
					}
					continue;	// Other optimizations may be possible on the new instruction
				} 
			}

			// Same as above for the next ShortStoreTemp instruction
			else if (bytecode1.IsShortStoreTemp)
			{
				 if (byte2 == OpCode::PopStackTop)
				 {
					_ASSERTE(NumShortStoreTemps <= NumShortPopStoreTemps);
					auto index = indexOfShortStoreTemp(byte1);
					bytecode1.opcode = OpCode::ShortPopStoreTemp + index;
					RemoveInstruction(next);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				 }
			}

			else if (byte1 == OpCode::SpecialSendIsNil && bytecode2.IsJumpSource)
			{
				_ASSERTE(bytecode2.InstructionLength == 3);
				if (byte2 == OpCode::LongJumpIfTrue)
				{
					bytecode2.opcode = OpCode::LongJumpIfNil;
					// Because we've effectively replaced the isNil message send
					// we need to adjust the textMap entry so that it points at the jump,
					// or it will be point at the preceeding instruction when the isNil send
					// is removed
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);					// Remove separate isNil test
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				else if (byte2 == OpCode::LongJumpIfFalse)
				{
					bytecode2.opcode = OpCode::LongJumpIfNotNil;
					// Ditto adjustment of text map entry because of removal of isNil
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
			}
			else if (byte1 == OpCode::SpecialSendNotNil && bytecode2.IsJumpSource)
			{
				_ASSERTE(bytecode2.InstructionLength == 3);
				if (byte2 == OpCode::LongJumpIfTrue)
				{
					bytecode2.opcode = OpCode::LongJumpIfNotNil;
					// Ditto adjustment of text map entry because of removal of notNil
					VERIFY(AdjustTextMapEntry(i, i+1));
					RemoveInstruction(i);					// Remove separate isNil test
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
				else if (byte2 == OpCode::LongJumpIfFalse)
				{
					bytecode2.opcode = OpCode::LongJumpIfNil;
					// Ditto adjustment of text map entry because of removal of isNil
					VERIFY(AdjustTextMapEntry(i, next));
					RemoveInstruction(i);
					count++;
					continue;	// A new instruction will now be at i to be considered, so don't advance
				}
			}
			else if (byte1 == OpCode::DuplicateStackTop)
			{
				if (byte2 == OpCode::ReturnMessageStackTop)
				{
					// A Dup immediately before a Return ToS is redundant
					_ASSERTE(!bytecode2.IsJumpTarget);
					bytecode1.opcode = OpCode::ReturnMessageStackTop;
					count++;
					// Leave the other return to be removed as unreachable code
					continue;	// A new instruction will now be at i to be considered, so don't advance
				} 
				else if (byte2 == OpCode::LongJumpIfNotNil)
				{
					// Dup, LongJumpIfNotNil
					BYTECODE& target = m_bytecodes[bytecode2.target];
					if (target.IsReturnStackTop)
					{
						target.removeJumpTo();
						bytecode2.makeNonJump();
						bytecode2.opcode = OpCode::ReturnIfNotNil;
						RemoveBytes(next + 1, 2);
						count++;
					}
					else if (target.Opcode == OpCode::PopStackTop && target.jumpsTo == 1)
					{
						ip_t nilBranch = next + bytecode2.InstructionLength;
						BYTECODE& bytecode3 = m_bytecodes[nilBranch];
						if (bytecode3.Opcode == OpCode::PopStackTop)
						{
							// Remove Dup and Pop from first branch, and retarget jump over to next after the pop
							target.removeJumpTo();
							m_bytecodes[++bytecode2.target].addJumpTo();

							_ASSERTE(!m_bytecodes[nilBranch].IsJumpTarget);
							// Remove Pop from nil branch
							RemoveInstruction(nilBranch);
							// Remove Dup
							RemoveInstruction(i);

							continue;	// A new instruction will now be at i to be considered, so don't advance
						}
					}
				}
				else if (byte2 == OpCode::LongJumpIfNil && m_bytecodes[next + 3].IsReturnStackTop && !m_bytecodes[next+3].IsJumpTarget)
				{
					// e.g. code of the form: `@expr ifNotNil: [:x | ^x]
					_ASSERTE(m_bytecodes[next].target == next + 4);
					m_bytecodes[next + 3].opcode = OpCode::ReturnIfNotNil;
					// Remove the jump (will update jumpsTo of the target)
					VoidTextMapEntry(next);
					RemoveInstruction(next);
					count++;
					continue;
				}
				else if (byte2 == OpCode::ReturnIfNotNil)
				{
					BYTECODE& bytecode3 = m_bytecodes[next+1];
					if (bytecode3.Opcode == OpCode::PopStackTop && !bytecode3.IsJumpTarget)
					{
						// We can remove the Dup and the Pop
						RemoveInstruction(next + 1);
						RemoveInstruction(i);
						count++;
						continue;
					}
				}
				else if (byte2 == OpCode::PopStackTop)
				{
					// Redundant Dup/Pop pair
					RemoveInstruction(next);
					RemoveInstruction(i);
					count++;
					continue;
				}
			}
			else if ((bytecode1.IsShortPopStoreTemp && bytecode2.IsShortPushTemp)
						&& (bytecode1.indexOfShortPopStoreTemp() == bytecode2.indexOfShortPushTemp()))
			{
				// Replace a PopStore[n], Push[n], sequence with a store
				// This commonly occurs in code that assigns a temp and then 
				// uses the temp immediately, such as for a condition.
				
				auto index = bytecode2.indexOfShortPushTemp();
				if (index < NumShortStoreTemps)
				{
					bytecode1.opcode = OpCode::ShortStoreTemp + index;
					RemoveInstruction(next);
				}
				else
				{
					bytecode1.opcode = OpCode::StoreTemp;
					bytecode2.byte = index;
					bytecode2.makeData();
				}
				count++;
				continue;	// A new instruction will now be at i to be considered, so don't advance
			}
			else if (bytecode1.IsLongConditionalJump && bytecode2.IsLongJump
				&&  bytecode1.target == next + 3)
			{
				// Conditional jump over unconditional jump can be replaced with 
				// inverted conditional jump to unconditional jump's target
				OpCode invertedJmp;
				switch (bytecode1.Opcode)
				{
				case OpCode::LongJumpIfTrue:
					invertedJmp = OpCode::LongJumpIfFalse;
					break;
				case OpCode::LongJumpIfFalse:
					invertedJmp = OpCode::LongJumpIfTrue;
					break;
				case OpCode::LongJumpIfNil:
					invertedJmp = OpCode::LongJumpIfNotNil;
					break;
				case OpCode::LongJumpIfNotNil:
					invertedJmp = OpCode::LongJumpIfNil;
					break;
				default:
					__assume(false);
					break;
				}
				bytecode1.opcode = invertedJmp;
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

			else if (bytecode1.IsShortPopStoreInstVar && bytecode2.Opcode == OpCode::ShortPushInstVar + bytecode1.indexOfShortPopStoreInstVar())
			{
				bytecode2.makeData();
				bytecode2.byte = bytecode1.indexOfShortPopStoreInstVar();
				bytecode1.opcode = OpCode::StoreInstVar;
				count++;
				continue;
			}

			// There are more ShortPushInstVar instructions that ShortPopStoreInstVar, so we may be the long/short combination
			else if (byte1 == OpCode::PopStoreInstVar 
				&& ((m_bytecodes[i+1].byte < NumShortPushInstVars && byte2 == OpCode::ShortPushInstVar + m_bytecodes[i + 1].byte)
					|| (byte2 == OpCode::PushInstVar && m_bytecodes[i + 1].byte == m_bytecodes[next + 1].byte)))
			{
				bytecode1.opcode = OpCode::StoreInstVar;
				RemoveInstruction(next);
				count++;
				continue;
			}
		}

		// A store into a temp followed by a return from method is redundant, even if
		// either is a jump target
		if (bytecode1.IsStoreStackTemp && bytecode2.IsReturn)
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
		
		// m_bytecodes may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].IsOpCode);
		const size_t len = m_bytecodes[i].InstructionLength;
		i += len;
	}
	return count;
}

bool Compiler::AreBytecodesSame(ip_t i, ip_t j) const
{
	const BYTECODE& a = m_bytecodes[i];
	const BYTECODE& b = m_bytecodes[j];
	if (a.Opcode != b.Opcode) return false;
	size_t count = a.InstructionLength;
	if (b.InstructionLength != count) return false;
	for (auto x = 1u; x < count; x++)
	{
		if (m_bytecodes[i + x].byte != m_bytecodes[j + x].byte) return false;
	}
	return true;
}

// Hmmm, there's what looks like a code generation bug here - or at least enabling global optimisation
// here generates incorrect code for CombinePairs1 and it fails to spot Push Temp;Send Zero Args pairs.
#pragma optimize("g", off)

size_t Compiler::CombinePairs()
{
	return CombinePairs1() + CombinePairs2();
}

// Combine pairs of instructions into the more favoured macro instructions. This should be done
// before CombinePairs2(). Returns a count of the optimizations done.
size_t Compiler::CombinePairs1()
{
	size_t count = 0;
	size_t lastCount = 0;
	ip_t i=ip_t::zero;
	while (i <= LastIp)
	{
#ifdef _DEBUG
		if (count > lastCount)
		{
			lastCount = count;
			VerifyTextMap();
		}
#endif

		BYTECODE& bytecode1=m_bytecodes[i];
		const size_t len1 = bytecode1.InstructionLength;
		
		const ip_t next = i+len1;
		if (next > LastIp)
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		_ASSERTE(bytecode1.IsOpCode && bytecode2.IsOpCode);

		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.IsJumpTarget)
		{
			auto byte1 = bytecode1.Opcode;
			auto byte2 = bytecode2.Opcode;

			// We introduce this macro instruction here rather than in CombinePairs2()
			// because we wan't it to take precedent over PopPushSelf, which would otherwise get
			// used every time there is a sequence of sends to self with the intermediate results
			// being ignored. Its possible there should be a PopSendSelf instruction
			if (byte1 == OpCode::ShortPushSelf)
			{
				if (byte2 == OpCode::Send)
				{
					_ASSERTE(m_bytecodes[next+1].IsData);
					auto m = m_bytecodes[next+1].byte;
					_ASSERTE(SendXLiteralBits == 5);
					auto argCount = m >> SendXLiteralBits;
					if (argCount == 0)
					{
						// Push Self will become the Send Self instruction
						VERIFY(AdjustTextMapEntry(next, i));

						bytecode1.opcode = OpCode::SendSelfWithNoArgs;
						bytecode2.makeData();
						bytecode2.byte = m;
						RemoveByte(next+1);
					}
				}
				else if (bytecode2.IsShortSendWithNoArgs)
				{
					_ASSERTE(len1 == 1);
					VERIFY(AdjustTextMapEntry(next, i));

					auto n = bytecode2.indexOfShortSendNoArgs();
					if (n < NumShortSendSelfWithNoArgs)
					{
						bytecode1.opcode = OpCode::ShortSendSelfWithNoArgs + n;
						RemoveInstruction(next);
					}
					else
					{
						bytecode1.opcode = OpCode::SendSelfWithNoArgs;
						bytecode2.byte = n;
						bytecode2.makeData();
					}
					count++;
				}
			} 

			// Look for opportunities to combine push temp with subsequent zero arg send
			else if (bytecode1.IsShortPushTemp)
			{
				auto n = bytecode1.indexOfShortPushTemp();

				if (bytecode2.IsShortSendWithNoArgs)
				{
					// Push Temp has become the Send Temp instruction
					VERIFY(AdjustTextMapEntry(next, i));

					auto m = bytecode2.indexOfShortSendNoArgs();
					_ASSERTE(m <= MAXFORBITS(5));
					_ASSERTE(n <= MAXFORBITS(3));

					bytecode2.makeData();
					bytecode2.byte = n << 5 | m;

					bytecode1.opcode = OpCode::SendTempWithNoArgs;
				}
				else if (byte2 == OpCode::Send)
				{
					_ASSERTE(m_bytecodes[next+1].IsData);
					auto m = m_bytecodes[next+1].byte;
					_ASSERTE(SendXLiteralBits <= 5);
					auto argCount = m >> SendXLiteralBits;
					if (argCount == 0)
					{
						// Push Temp will become the Send Temp instruction
						VERIFY(AdjustTextMapEntry(next, i));

						bytecode1.opcode = OpCode::SendTempWithNoArgs;
						bytecode2.makeData();
						bytecode2.byte = n << 5 | m;
						RemoveByte(next+1);
					}
				}
				else if (byte2 == OpCode::IncrementStackTop || byte2 == OpCode::DecrementStackTop)
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
					if (!bytecode3.IsJumpTarget)
					{
						if (bytecode3.IsShortPopStoreTemp)
						{
							auto m = bytecode3.indexOfShortPopStoreTemp();
							if (m == n)
							{
								VERIFY(AdjustTextMapEntry(next, i));
								bytecode1.opcode = byte2 == OpCode::IncrementStackTop ? OpCode::IncrementTemp : OpCode::DecrementTemp;
								VERIFY(AdjustTextMapEntry(next+1, next));
								bytecode2.opcode = OpCode::PopStoreTemp;
								bytecode2.makeData();
								bytecode3.byte = n;
								bytecode3.makeData();
								count++;
							}
						}
						else if (bytecode3.IsShortStoreTemp)
						{
							auto m = bytecode3.indexOfShortStoreTemp();
							if (m == n)
							{
								bytecode1.opcode = byte2 == OpCode::IncrementStackTop ? OpCode::IncrementPushTemp : OpCode::DecrementPushTemp;
								// There may be no text map entries if these instructions are part of a to:[by:]do: loop
								AdjustTextMapEntry(next, i);
								bytecode2.opcode = OpCode::StoreTemp;
								AdjustTextMapEntry(next+1, next);
								bytecode2.makeData();
								bytecode3.byte = n;
								bytecode3.makeData();
								count++;
							}
						}
						else if (bytecode3.Opcode == OpCode::PopStoreTemp || bytecode3.Opcode == OpCode::StoreTemp)
						{
							auto m = m_bytecodes[next+2].byte;
							if (m == n)
							{
								bytecode1.opcode = bytecode3.Opcode == OpCode::PopStoreTemp
										? bytecode2.Opcode == OpCode::IncrementStackTop ? OpCode::IncrementTemp : OpCode::DecrementTemp
										: bytecode2.Opcode == OpCode::IncrementStackTop ? OpCode::IncrementPushTemp : OpCode::DecrementPushTemp;
								// The [Pop]StoreTemp instruction is now data, but is otherwise correct
								bytecode3.makeData();
								// We can remove the IncrementStackTop
								AdjustTextMapEntry(next, i);
								RemoveInstruction(next);
								count++;
							}
						}
					}
				}
			}
			else if (byte1 == OpCode::PushTemp)
			{
				_ASSERTE(m_bytecodes[i+1].IsData);
				auto n = m_bytecodes[i+1].byte;

				if (byte2 == OpCode::Send)
				{
					 if (n <= MAXFORBITS(3))
					 {
						_ASSERTE(m_bytecodes[next+1].IsData);
						_ASSERTE(SendXLiteralBits <= 5);
						auto m = m_bytecodes[next+1].byte;
						auto argCount = m >> SendXLiteralBits;
						if (argCount == 0)
						{
							DebugBreak();
						}
					 }
				}
				else if (bytecode2.IsShortSendWithNoArgs)
				{
					if (n <= MAXFORBITS(3))
					{
						// Push Temp will become the Send Temp instruction
						VERIFY(AdjustTextMapEntry(next, i));

						bytecode1.opcode = OpCode::SendTempWithNoArgs;
						m_bytecodes[i+1].byte = bytecode2.indexOfShortSendNoArgs() << 5 || n;
						RemoveByte(next);
					}
				}
				else if (bytecode2.Opcode == OpCode::IncrementStackTop || bytecode2.Opcode == OpCode::DecrementStackTop)
				{
					// Look for opportunities to replace PushTempN, Inc, [Pop]StoreTempN with Inc[Push]TempN
					
					// Note that we assume there will always be more short push temp instructions than
					// [Pop]Store instructions, so we do not handle the short cases here
					_ASSERTE(NumShortPushTemps >= NumShortStoreTemps);
					_ASSERTE(NumShortPushTemps >= NumShortPopStoreTemps);

					// byte2 cannot possibly be the last instruction
					BYTECODE& bytecode3=m_bytecodes[next+1];
					if (!bytecode3.IsJumpTarget)
					{
						if (bytecode3.Opcode == OpCode::PopStoreTemp || bytecode3.Opcode == OpCode::StoreTemp)
						{
							auto m = m_bytecodes[next+2].byte;
							if (m == n)
							{
								// The [Inc|Dec][Push]Temp instructions are unusual in having a first data byte that is
								// the [Pop]StoreTemp instruction to execute in the case of SmallInteger overflow on 
								// inc or dec. On overflow a 'Send +' is executed, but the instructionPointer is left
								// pointing at the first data byte before the send, which is then executed as the 
								// correct temp store operation when the + method returns.
								bytecode1.opcode = bytecode3.Opcode == OpCode::PopStoreTemp
										? bytecode2.Opcode == OpCode::IncrementStackTop ? OpCode::IncrementTemp : OpCode::DecrementTemp
										: bytecode2.Opcode == OpCode::IncrementStackTop ? OpCode::IncrementPushTemp : OpCode::DecrementPushTemp;
								// The [Pop]StoreTemp instruction is now data, but is otherwise correct
								bytecode3.makeData();
								// We can remove the first bytecodes argument byte and the [Inc|Dec]rementStackTop
								AdjustTextMapEntry(next, i);
								RemoveBytes(i+1, 2);
								count++;
							}
						}
					}
				}
			}
		}
		
		// m_bytecodes may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].IsOpCode);
		i += m_bytecodes[i].InstructionLength;
	}
	return count;
}

// Combine pairs of instructions into the less favoured macro instructions. This should be done
// after CombinePairs1(). Returns a count of the optimizations done.
size_t Compiler::CombinePairs2()
{
	size_t count = 0;
	size_t lastCount = 0;
	ip_t i = ip_t::zero;
	while (i <= LastIp)
	{
#ifdef _DEBUG
		if (count > lastCount)
		{
			lastCount = count;
			VerifyTextMap();
		}
#endif
		BYTECODE& bytecode1=m_bytecodes[i];
		const size_t len1 = bytecode1.InstructionLength;
		
		const ip_t next = i+len1;
		if (next > LastIp)
			break;					// bytecode1 is last instruction
		BYTECODE& bytecode2=m_bytecodes[next];
		
		auto byte1 = bytecode1.Opcode;
		auto byte2 = bytecode2.Opcode;

		// We can't perform any of these optimizations if the second byte code is a jump target
		if (!bytecode2.IsJumpTarget)
		{
			if (byte1 == OpCode::PopStackTop)
			{
				if (byte2 == OpCode::ShortPushSelf)
				{
					// Pop followed by Push Self is common in a sequence of statements that send to self.

					bytecode1.opcode = OpCode::PopPushSelf;
					RemoveInstruction(next);
					count++;
				}

				else if (byte2 == OpCode::DuplicateStackTop)
				{
					// The Pop/Dup sequence is common in cascades

					bytecode1.opcode = OpCode::PopDup;
					RemoveInstruction(next);
					count++;
				}

				else if (byte2 == OpCode::ReturnSelf)
				{
					// Remove the Pop and adjust the return to avoid need to adjust the text map entry
					bytecode2.opcode = OpCode::PopReturnSelf;
					RemoveInstruction(i);
					count++;
				}

				else if (bytecode2.IsShortPushTemp && (bytecode2.indexOfShortPushTemp() < NumShortPopPushTemps))
				{
					// Pop followed by a push of a temp is common in a sequence of statements where
					// messages are sent to a temp

					bytecode1.opcode = OpCode::ShortPopPushTemp + indexOfShortPushTemp(byte2);
					bytecode1.pVarRef = bytecode2.pVarRef;
					RemoveInstruction(next);
					count++;
				}
			}

			else if (byte1 == OpCode::ShortPushSelf)
			{
				if (bytecode2.IsPushTemp)
				{
					// A pair of push self and then pushing a temp is very common, being the prelude
					// to sending a one (or more) arg message to self

					// Don't lose the var ref (this is useful for debug decoding only at this stage)
					bytecode1.pVarRef = bytecode2.pVarRef;

					_ASSERTE(len1 == 1);
					if (bytecode2.Opcode == OpCode::PushTemp)
					{
						bytecode1.opcode = OpCode::PushSelfAndTemp;
						// Remove the PushTemp, grabbing its index data byte
						_ASSERTE(next == i+1);
						RemoveBytes(next, 1);
					}
					else
					{
						// If short push, overwrite it with a data byte containing the temp index
						auto i = bytecode2.indexOfShortPushTemp();
						if (i < NumShortPushSelfAndTemps)
						{
							bytecode1.opcode = OpCode::ShortPushSelfAndTemp + i;
							RemoveInstruction(next);
						}
						else
						{
							bytecode1.opcode = OpCode::PushSelfAndTemp;
							bytecode2.byte = i;
							bytecode2.makeData();
						}
					}
					count++;
				}
			}

			// Look for opportunities to combine pairs of push temp instructions into one
			// Pairs of temp pushes are common before sending 1 or more argument messages
			else if (bytecode1.IsShortPushTemp)
			{
				auto n = bytecode1.indexOfShortPushTemp();

				if (byte2 == OpCode::PushTemp)
				{
					_ASSERTE(m_bytecodes[next+1].IsData);
					auto m = m_bytecodes[next+1].byte;
					if (m < MAXFORBITS(4))
					{
						bytecode1.opcode = OpCode::PushTempPair;
						RemoveBytes(next, 1);
						_ASSERTE(m_bytecodes[next].IsData);
						m_bytecodes[next].byte = n << 4 | m;
						count++;
					}
				}
				else if (bytecode2.IsShortPushTemp)
				{
					auto m = bytecode2.indexOfShortPushTemp();
					_ASSERTE(n <= MAXFORBITS(4));
					_ASSERTE(m <= MAXFORBITS(4));
					bytecode1.opcode = OpCode::PushTempPair;
					bytecode2.byte = n << 4 | m;
					bytecode2.makeData();
					count++;
				}
			}

			else if (byte1 == OpCode::PushTemp)
			{
				_ASSERTE(m_bytecodes[i+1].IsData);
				auto n = m_bytecodes[i+1].byte;

				if (bytecode2.IsPushTemp)
				{
					if (n <= MAXFORBITS(4))
					{
						if (byte2 == OpCode::PushTemp)
						{
							_ASSERTE(m_bytecodes[next+1].IsData);
							auto m = m_bytecodes[next+1].byte;
							if (m <= MAXFORBITS(4))
							{
								bytecode1.opcode = OpCode::PushTempPair;
								m_bytecodes[i+1].byte = n << 4 | m;
								RemoveInstruction(next);
								count++;
							}
						}
						else
						{
							_ASSERTE(bytecode2.IsShortPushTemp);
							auto m = bytecode2.indexOfShortPushTemp();
							_ASSERTE(n <= MAXFORBITS(4));
							_ASSERTE(m <= MAXFORBITS(4));
							bytecode1.opcode = OpCode::PushTempPair;
							m_bytecodes[i+1].byte = n << 4 | m;
							RemoveInstruction(next);
							count++;
						}
					}
				}
			}
		}
		
		// m_bytecodes may have been replaced, so move to next based on the one there now
		_ASSERTE(m_bytecodes[i].IsOpCode);
		const size_t len = m_bytecodes[i].InstructionLength;
		i += len;
	}
	return count;
}
#pragma optimize( "", on)
#pragma auto_inline()

void Compiler::FixupJumps()
{
	const ip_t last = LastIp;
	ip_t i = ip_t::zero;
	LexicalScope* pCurrentScope = GetMethodScope();
	pCurrentScope->InitialIP = ip_t::zero;

	while (i<=last)
	{
		_ASSERTE(m_bytecodes[i].IsOpCode);

		//_CrtCheckMemory();
		if (m_bytecodes[i].IsJumpSource)
		{
			_ASSERTE(m_bytecodes[i].IsJumpInstruction);

			FixupJump(i);
			_ASSERTE(m_bytecodes[i].IsJumpInstruction);
		}
		else
			_ASSERTE(!m_bytecodes[i].IsJumpInstruction);
	
		// Patch up the ip range of the scopes as we encounter them
		if (m_bytecodes[i].pScope != pCurrentScope)
		{
			// Note that setting of the final IP may happen more than once
			// as the block goes in and out of scope
			pCurrentScope->FinalIP = i-1;
			pCurrentScope = m_bytecodes[i].pScope;
			_ASSERTE(pCurrentScope != nullptr);
			// Patch up the initialIP of the scope for the temps map
			pCurrentScope->MaybeSetInitialIP(i);
		}

		_ASSERTE(m_bytecodes[i].IsOpCode);
		size_t len = m_bytecodes[i].InstructionLength;
		i += len;
		// Code size cannot shrink
		_ASSERTE(LastIp == last);
	}

	pCurrentScope->FinalIP = LastIp;
	_ASSERTE(GetMethodScope()->FinalIP == LastIp);
}

size_t Compiler::OptimizeJumps()
{
	// Run through seeing if any jumps can be removed or retargeted.
	// Return a count of the number of jumps replaced.
	//
	size_t count = 0;
	size_t lastCount = 0;
	ip_t i = ip_t::zero;
	while (i<=LastIp)
	{
#ifdef _DEBUG
		if (count > lastCount)
		{
			lastCount = count;
			VerifyJumps();
			VerifyTextMap();
		}
#endif

		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.IsOpCode);
		size_t len = bytecode.InstructionLength;
		if (bytecode.IsJumpSource)
		{
			// At this stage all jumps should be long
			_ASSERTE(bytecode.Opcode == OpCode::BlockCopy || bytecode.InstructionLength == 3);

			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			ip_t currentTarget = bytecode.target;
			_ASSERTE(currentTarget <= LastIp);
			BYTECODE& target = m_bytecodes[currentTarget];
			_ASSERTE(target.IsJumpTarget);
			auto targetByte = target.byte;

			intptr_t distance = static_cast<intptr_t>(currentTarget) - static_cast<intptr_t>(i);
			intptr_t offset = distance - len;
			if (offset == 0)
			{
				_ASSERTE(bytecode.Opcode != OpCode::BlockCopy);

				// This jump is a Nop, since the jump offset is 0, and can be removed
				if (bytecode.Opcode == OpCode::LongJump)
					RemoveInstruction(i);
				else
				{
					// However (#401) if a conditional branch we must replace it with a Pop
					// to maintain the same stack
					target.removeJumpTo();
					bytecode.makeNonJump();
					bytecode.opcode = OpCode::PopStackTop;
					VoidTextMapEntry(i);
					RemoveBytes(i+1, 2);
				}
				count++;
				continue;	// Go round again at same IP
			}
			
			if (target.IsJumpSource)
			{
				if (target.Opcode == OpCode::LongJump)
				{
					// Catch rare case of jump to self (e.g. [true] whileTrue can reduce to this).
					if (currentTarget != i)
					{
						// Any jump to an unconditional jump can be redirected to its
						// eventual target.
						ip_t eventualtarget=target.target;
						_ASSERTE(eventualtarget <= LastIp);
						target.removeJumpTo();		// We're no longer jumping to original target
						SetJumpTarget(i, eventualtarget);
						count++;
						continue;	// Reconsider this jump as may be in a chain
					}
				}
				else if (bytecode.Opcode == OpCode::LongJump && target.Opcode != OpCode::BlockCopy)
				{
					// Unconditional jump to a conditional jump can be replaced
					// with a conditional jump (of the same type) to the same target
					// and an unconditional jump to the location after the original cond jump target
					_ASSERTE(target.IsLongConditionalJump);
					_ASSERTE(len == 3);
					bytecode.byte = target.byte;
					ip_t eventualtarget = target.target;
					_ASSERTE(eventualtarget <= LastIp);
					target.removeJumpTo();		// We're no longer jumping to original target
					SetJumpTarget(i, eventualtarget);
					m_codePointer = i + len;
					m_pCurrentScope = bytecode.pScope;
					GenJump(OpCode::LongJump, currentTarget+3);
					m_pCurrentScope = nullptr;
					count++;
					continue;	// Reconsider this jump as may be in a chain
				}
			}
			else if (target.IsPush)
			{
				// If jumping to push followed by pop, can skip to the next instruction
				// This is quite a common result of conditional expressions
				
				// Can't be last byte (wouldn't make sense, as need a return)
				ip_t next = currentTarget + target.InstructionLength;
				_ASSERTE(next <= LastIp);
				BYTECODE& nextAfterTarget=m_bytecodes[next];
				if (nextAfterTarget.Opcode == OpCode::PopStackTop)
				{
					_ASSERTE(nextAfterTarget.InstructionLength == 1);
					// Yup its a jump to a no-op, so retarget to following byte
					target.removeJumpTo();
					_ASSERTE(next+1 <= LastIp);	// Again, must be at least a ret to follow
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

size_t Compiler::InlineReturns()
{
	// Jumps to return instructions can be replaced by the return instruction
	// Note that this is done last in optimisation as quite often such jumps
	// can be removed altogether due to elimination of unreachable/redundant code.
	//
	size_t count = 0;
	ip_t i = ip_t::zero;
	while (i<=LastIp)
	{
		//_CrtCheckMemory();
		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.IsOpCode);
		size_t len = bytecode.InstructionLength;
		if (bytecode.IsJumpSource)
		{
			// At this stage all jumps should be long
			_ASSERTE(bytecode.Opcode == OpCode::BlockCopy || bytecode.InstructionLength == 3);

			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			ip_t currentTarget = bytecode.target;
			_ASSERTE(currentTarget <= LastIp);
			BYTECODE& target = m_bytecodes[currentTarget];
			_ASSERTE(target.IsJumpTarget);
			auto targetByte = target.Opcode;

			// Unconditional Jumps to return instructions can be replaced with the return instruction
			if (bytecode.Opcode == OpCode::LongJump)
			{
				if (target.IsReturn)
				{
					// All return instructions must be 1 byte long
					_ASSERTE(target.InstructionLength == 1);
					len = 1;
					bytecode.opcode = targetByte;
					target.removeJumpTo();
					bytecode.makeNonJump();
					if (WantTextMap)
					{
						// N.B. We need to copy the text map entry for the target
						TEXTMAP tm = *FindTextMapEntry(currentTarget);
						InsertTextMapEntry(i, tm.start, tm.stop);
					}
					// Remove the data bytes reserved for the jump offset
					RemoveBytes(i+1, 2);
					count++;
				}
				// We need to perform the same optimisation in debug methods to ensure the text maps match
				else if (targetByte == OpCode::Break && m_bytecodes[currentTarget+1].IsReturn)
				{
					// All return instructions must be 1 byte long
					_ASSERTE(target.InstructionLength == 1);
					
					const BYTECODE& returnOp = m_bytecodes[currentTarget+1];

					// We have to be careful to avoid performing an optimisation that would not be performed in
					// the release version of a method - if this is a jump over an empty block, the jump will
					// not be present in a release method because all empty blocks are folded to a single instance
					// and therefore there is no code inline in the method to jump over. We have to special case
					// this to avoid creating inconsistent text maps. You would think the code sequence '[[]]'
					// would never appear in a method, but EventsCollection>>triggerEvent: contains it!
					if (!(returnOp.Opcode == OpCode::ReturnBlockStackTop && m_bytecodes[i+len].pScope->RealScope->IsEmptyBlock))
					{
						len = 2;
						bytecode.opcode = OpCode::Break;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].Opcode, bytecode.pScope);
						if (WantTextMap)
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
				else if (targetByte == OpCode::PopStackTop)
				{
					if (m_bytecodes[currentTarget+1].IsReturn)//.byte == ReturnSelf)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.InstructionLength == 1);
						len = 2;

						bytecode.opcode = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].Opcode, bytecode.pScope);
						if (WantTextMap)
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+1);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+1, (*it).start, (*it).stop);
						}
						RemoveByte(i+2);
						count++;
					}
					else if (m_bytecodes[currentTarget+1].Opcode == OpCode::Break
							&& m_bytecodes[currentTarget+2].IsReturn) //.byte == ReturnSelf)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.InstructionLength == 1);
						len = 3;

						bytecode.opcode = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(OpCode::Break, bytecode.pScope);
						m_bytecodes[i+2].makeOpCode(m_bytecodes[currentTarget+2].Opcode, bytecode.pScope);
						if (WantTextMap)
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+2);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+2, (*it).start, (*it).stop);
						}
						count++;
					}
				}
				else if (target.IsPseudoPush)	
				{
					// Inline jump to Push [Self|True|False|Nil]; Return sequence

					if (m_bytecodes[currentTarget+1].IsReturnStackTop)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.InstructionLength == 1);
						len = 2;

						bytecode.opcode = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(m_bytecodes[currentTarget+1].Opcode, bytecode.pScope);
						if (WantTextMap)
						{
							// N.B. We need to copy the text map entry for the return after the target
							TEXTMAPLIST::const_iterator it = FindTextMapEntry(currentTarget+1);
							_ASSERTE(it != m_textMaps.end());
							InsertTextMapEntry(i+1, (*it).start, (*it).stop);
						}
						RemoveByte(i+2);
						count++;
					}
					else if (m_bytecodes[currentTarget+1].Opcode == OpCode::Break && m_bytecodes[currentTarget+2].IsReturnStackTop)
					{
						// All return instructions must be 1 byte long
						_ASSERTE(target.InstructionLength == 1);
						len = 3;

						bytecode.opcode = targetByte;
						target.removeJumpTo();
						bytecode.makeNonJump();
						m_bytecodes[i+1].makeOpCode(OpCode::Break, bytecode.pScope);
						m_bytecodes[i+2].makeOpCode(m_bytecodes[currentTarget+2].Opcode, bytecode.pScope);
						if (WantTextMap)
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
		// map entry). T
		else if (bytecode.IsReturn && i + len <= LastIp && bytecode.byte == m_bytecodes[i+len].byte)
		{
			VERIFY(VoidTextMapEntry(i));
			auto duplicateReturn = bytecode.byte;
			LexicalScope* pScope = bytecode.pScope;
			RemoveInstruction(i);
			_ASSERTE(m_bytecodes[i].byte == duplicateReturn);
			m_bytecodes[i].pScope = pScope;
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
inline static bool isInShortJumpRange(intptr_t distance, size_t extensionBytes)
{
	intptr_t offset = distance - 2;	// Allow for the instruction itself
	return offset >= 0 && (offset - extensionBytes) < NumShortJumps;
}

// Answer whether the supplied distance is within the possible jump range from the jump
// instruction. assuming that the current instruction has 'extensionBytes' bytes of extensions.
//
inline static bool isInNearJumpRange(intptr_t distance, unsigned extensionBytes)
{
#if defined(_DEBUG) && !defined(USE_VM_DLL)
	if (distance == 0)
		TRACESTREAM<< L"WARNING: Near Jump to itself detected" << endl;
#endif
	_ASSERTE(extensionBytes >= 1);
	
	// If the jump instruction is at 1, then the IP after interpreting it will be 3
	// so the offsets will be distance - 2
	intptr_t offset = distance - 2;
	
	return offset < 0?
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
inline static bool isInLongJumpRange(intptr_t distance)
{
	intptr_t offset = distance - 3;
	return offset >= MaxBackwardsLongJump && offset <= MaxForwardsLongJump;
}

size_t Compiler::ShortenJumps()
{
	// Run through seeing if any shorter jumps can be used. Return a count
	// of the number of jumps shortened.
	//
	size_t count = 0;
	ip_t i = ip_t::zero;
	while (i<=LastIp)
	{
		//_CrtCheckMemory();
		// Fix up jumps
		BYTECODE& bytecode = m_bytecodes[i];
		_ASSERTE(bytecode.IsOpCode);
		if (bytecode.IsJumpSource)
		{
			// Compute relative distance from this instructions
			// (N.B. Bear in mind that jumps start after the instruction itself, but the distance
			// we calculate here is from the jump itself)
			_ASSERTE(bytecode.target >= ip_t::zero && bytecode.target <= LastIp);
			BYTECODE& target = m_bytecodes[bytecode.target];
			_ASSERTE(target.IsJumpTarget);
			auto targetByte = target.Opcode;
			intptr_t distance = static_cast<intptr_t>(bytecode.target) - static_cast<intptr_t>(i);
			switch (bytecode.Opcode)
			{
				
				//////////////////////////////////////////////////////////////////////////////////
				// Single byte Short jumps. Obviously these cannot be shorted further
			case OpCode::ShortJump:
				_ASSERTE(!target.IsReturn);
			case OpCode::ShortJumpIfFalse:
				break;
				
				//////////////////////////////////////////////////////////////////////////////////
				// Double byte Near jumps. Might be possible to shorten to single byte Short jumps
				
			case OpCode::NearJump:
				// Unconditional Jumps to return instructions can be replaced with the return instruction
				_ASSERTE(!target.IsReturn);
				if (isInShortJumpRange(distance, 1))		// Account for extension
				{
					// Can shorten to short jump
					bytecode.opcode = OpCode::ShortJump;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case OpCode::NearJumpIfTrue:
				if (isInShortJumpRange(distance, 1))
				{
					// Currently there is no short jump if true, compiler will optimize away
				}
				break;
				
			case OpCode::NearJumpIfFalse:
				if (isInShortJumpRange(distance, 1))
				{
					// Can shorten to short jump
					bytecode.opcode = OpCode::ShortJumpIfFalse;
					RemoveByte(i+1);
					count++;
				}
				break;
				
				
				//////////////////////////////////////////////////////////////////////////////////
				// Triple byte long jumps. Might be possible to shorten to short or near jumps
				
			case OpCode::LongJump:
				// Unconditional Jumps to return instructions should have been replaced with the 
				// return instruction
				_ASSERTE(!target.IsReturn);
				if (isInNearJumpRange(distance, 2))
				{
					// Can shorten to near jump
					bytecode.opcode = OpCode::NearJump;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case OpCode::LongJumpIfTrue:
				if (isInNearJumpRange(distance, 2))
				{
					// Can shorten to near jump
					bytecode.opcode = OpCode::NearJumpIfTrue;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case OpCode::LongJumpIfFalse:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.opcode = OpCode::NearJumpIfFalse;
					RemoveByte(i+1);
					count++;
				}
				break;
				
				// Blocks contain a jump too, but they cannot be shortened at the moment
				// Could implement a 3 byte block copy instruction to allow for this.
			case OpCode::BlockCopy:
				break;
				
			case OpCode::NearJumpIfNil:
			case OpCode::NearJumpIfNotNil:
				// No short versions
				break;

			case OpCode::LongJumpIfNil:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.opcode = OpCode::NearJumpIfNil;
					RemoveByte(i+1);
					count++;
				}
				break;
				
			case OpCode::LongJumpIfNotNil:
				if (isInNearJumpRange(distance, 2))
				{
					bytecode.opcode = OpCode::NearJumpIfNotNil;
					RemoveByte(i+1);
					count++;
				}
				break;

			default:
				// A bogus jump instruction?
				_ASSERTE(0);
			}
		}
		size_t len = m_bytecodes[i].InstructionLength;
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
void Compiler::FixupJump(ip_t pos)
{
	// Fixes up the jump at pos
	const ip_t targetIP = m_bytecodes[pos].target;
	_ASSERTE(targetIP <= LastIp);
	_ASSERTE(m_bytecodes[targetIP].IsJumpTarget);	// Otherwise optimization could have gone wrong
	intptr_t distance=static_cast<intptr_t>(targetIP) - static_cast<intptr_t>(pos);
	
	switch (m_bytecodes[pos].Opcode)
	{
	case OpCode::ShortJump:
	case OpCode::ShortJumpIfFalse:
		{
			// Short jumps
			_ASSERTE(isInShortJumpRange(distance,0));
			intptr_t offset = distance - 2;				// IP advanced over instruction, and VM adds 1 too to
			// extend the useful range of short jumps (no point jumping
			// to the next instruction)
			_ASSERTE(pos+distance <= LastIp);
			m_bytecodes[pos].byte += static_cast<uint8_t>(offset);
		}
		break;
		
	case OpCode::NearJump:
	case OpCode::NearJumpIfFalse:
		_ASSERTE(!WantOptimize || !isInShortJumpRange(distance, 1));	// Why not optimized?
	case OpCode::NearJumpIfTrue:
	case OpCode::NearJumpIfNil:
	case OpCode::NearJumpIfNotNil:
		{
			// Unconditional jump
			_ASSERTE(isInNearJumpRange(distance, 1));
			intptr_t offset = distance - 2;	// IP inc'd for instruction and extension byte
			
			_ASSERTE(!WantOptimize || offset != 0);	// Why not optimized out?
			_ASSERTE(offset >= -128 && offset <= 127);
			
			_ASSERTE(pos+distance <= LastIp);
			m_bytecodes[pos+1].byte = static_cast<uint8_t>(offset);
		}
		break;
		
	case OpCode::LongJump:
	case OpCode::LongJumpIfTrue:
	case OpCode::LongJumpIfFalse:
	case OpCode::LongJumpIfNil:
	case OpCode::LongJumpIfNotNil:
		{
#if defined(_DEBUG)
	#define MASK_BYTE(op) ((op) & 0xFF)
#else
	#define MASK_BYTE(op) (op)
#endif
			// Unconditional jump
			_ASSERTE(!WantOptimize || !isInNearJumpRange(distance,2));	// Why not optimized?
			intptr_t offset = distance - 3;				// IP inc'd for instruction, and extension bytes
			if (offset < MaxBackwardsLongJump || offset > MaxForwardsLongJump)
			{
				CompileError(CErrMethodTooLarge);
			}
			_ASSERTE(pos+distance <= LastIp);
			m_bytecodes[pos+1].byte = static_cast<uint8_t>(MASK_BYTE(offset));
			m_bytecodes[pos + 2].byte = static_cast<uint8_t>(MASK_BYTE(offset >> 8));
		}
		break;
		
	case OpCode::BlockCopy:
		{
			// BlockCopy contains an implicit jump
			intptr_t offset = distance - BlockCopyInstructionLength;				// IP inc'd for instruction, and extension bytes
			if (offset < MaxBackwardsLongJump || offset > MaxForwardsLongJump)
			{
				CompileError(CErrMethodTooLarge);
			}
			_ASSERTE(pos+distance <= LastIp);
			m_bytecodes[pos + 5].byte =static_cast<uint8_t>(MASK_BYTE(offset));
			m_bytecodes[pos + 6].byte =static_cast<uint8_t>(MASK_BYTE(offset >> 8));
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

void Compiler::insertImmediateAsFirstLiteral(Oop newLiteralForImmediate)
{
	// Should only be called to insert an object that is encodable in bytecodes (and therefore cannot
	// already be in the literal frame) as part of creating a quick method definition to return a constant
	_ASSERTE(IsIntegerObject(newLiteralForImmediate) || FetchClassOf((POTE)newLiteralForImmediate) == GetVMPointers().ClassCharacter);
	_ASSERTE(!m_literals.contains(newLiteralForImmediate));

	size_t i = m_literalFrame.size();
	if (i > 0)
	{
		Oop firstLiteral = m_literalFrame[0];
		m_literals[firstLiteral] = i;
		m_literalFrame.push_back(firstLiteral);
		m_literalFrame[0] = newLiteralForImmediate;
		m_literals[newLiteralForImmediate] = 0;
	}
	else
		AddToFrame(newLiteralForImmediate, TEXTRANGE(), LiteralType::Normal);
}

POTE Compiler::NewMethod()
{
	// Must do this before generate the bytecodes as the textmaps may be offset if packed
	VerifyTextMap(true);

	if (!m_ok || WantSyntaxCheckOnly)
		return Nil();

	size_t blockCount = Pass2();
	
	_ASSERTE(sizeof(STMethodHeader) == sizeof(uintptr_t));
	_ASSERTE(m_literalFrame.size() <= LITERALLIMIT);
	
	// As we keep the class of the method in the method, we no longer need to store the super
	// class as an extra literal
	
	STMethodHeader hdr;
	*(uintptr_t*)&hdr = 0;
	
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
	tempcount_t numEnvTemps = pMethodScope->SharedTempsCount;
	bool bHasFarReturn = pMethodScope->HasFarReturn;
	bool bNeedsContext = bHasFarReturn || numEnvTemps > 0;

	auto byte0=m_bytecodes[ip_t::zero].Opcode;
	auto byte1= static_cast<uint8_t>(OpCode::Nop);
	auto byte2= static_cast<uint8_t>(OpCode::Nop);
	size_t len = CodeSize;
	if (len > 1)
	{
		byte1 = m_bytecodes[ip_t::one].byte;
		if (len > 2)
			byte2=m_bytecodes[ip_t::two].byte;
	}

	if (m_primitiveIndex!=0)
	{
		// Primitive
		// This is not a valid assertion, since primitive methods
		// can have any form of Smalltalk backup code
		//_ASSERTE(!hdr.m_needsContextFlag);
		MakeQuickMethod(hdr, static_cast<STPrimitives>(m_primitiveIndex));
		//classRequired=true;
	}
	else if (m_bytecodes[ip_t::zero].IsPseudoReturn && CodeSize < sizeof(uintptr_t))
	{
		//_ASSERTE(!bNeedsContext); Not a valid assertion, since could have a block after the return at the top
		// Primitive return of self, true, false, nil
		MakeQuickMethod(hdr, static_cast<STPrimitives>(PRIMITIVE_RETURN_SELF + indexOfPseudoReturn(byte0)));
		
		// We go ahead and generate the bytes anyway, as they'll fit in a SmallInteger and
		// may be of interest for debugging/browsing
	}
	else if (byte0 == OpCode::ShortPushConst && static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop)
	{
		// Primitive return of literal zero
		_ASSERTE(!bNeedsContext);
		_ASSERTE(m_literalFrame.size() > 0);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);

		// Note that in this case the literal may be a clean block, in which case the code size
		// may well be greater than will fit in a SmallInteger
		// _ASSERTE(CodeSize < sizeof(uintptr_t));
	}
	else if (m_bytecodes[ip_t::zero].IsShortPushConst && static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop && CodeSize == 2)
	{
		// Primitive return of literal zero from a ##() expression that generated literal frame entries
		_ASSERTE(!bNeedsContext);
		_ASSERTE(m_literalFrame.size() > 1);
		auto index = m_bytecodes[ip_t::zero].indexOfShortPushConst();

		swap(m_literalFrame[0], m_literalFrame[index]);

		m_bytecodes[ip_t::zero].opcode = OpCode::ShortPushConst;
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
	}
	else if (byte0 == OpCode::ShortPushStatic && static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop)
	{
		// Primitive return of literal zero
		_ASSERTE(!bNeedsContext);
		_ASSERTE(m_literalFrame.size() > 0);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_STATIC_ZERO);

		// Note that in this case the literal may be a clean block, in which case the code size
		// may well be greater than will fit in a SmallInteger
		// _ASSERTE(CodeSize < sizeof(uintptr_t));
	}
	else if (m_bytecodes[ip_t::zero].IsShortPushStatic && static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop && CodeSize == 2)
	{
		// Primitive return of literal zero from a ##() expression that generated literal frame entries
		_ASSERTE(!bNeedsContext);
		_ASSERTE(m_literalFrame.size() > 1);
		auto index = m_bytecodes[ip_t::zero].indexOfShortPushStatic();

		swap(m_literalFrame[0], m_literalFrame[index]);

		m_bytecodes[ip_t::zero].opcode = OpCode::ShortPushStatic;
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_STATIC_ZERO);
	}
	else if (m_bytecodes[ip_t::zero].IsShortPushInstVar && ArgumentCount == 0)
	{
		if (static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop)
		{
			// instance variable accessor method (<=15)
			_ASSERTE(!bNeedsContext);
			MakeQuickMethod(hdr, PRIMITIVE_RETURN_INSTVAR);

			// Convert to long form to simplify the interpreter's code to exec. this quick method.
			byte1 = m_bytecodes[ip_t::zero].indexOfPushInstVar();
			m_bytecodes[ip_t::zero].opcode = OpCode::PushInstVar;
			m_codePointer = ip_t::one;
			GenData(byte1);
			m_codePointer++;
			byte2 = static_cast<uint8_t>(OpCode::ReturnMessageStackTop);

			// We must adjust the debug info to account for the longer (two byte) first instruction
			//_ASSERTE(m_allScopes.size() == 1); Some inlined scopes may have been optimised away
			_ASSERTE(pMethodScope->FinalIP == ip_t::one);
			pMethodScope->FinalIP = ip_t::two;

			// We must go ahead and generate the bytes anyway as they are needed by the interpreter to 
			// determine which inst. var to push (they'll fit in a SmallInteger anyway)
			_ASSERTE(CodeSize == 3);
		}
	}
	else if (isPushInstVarX(byte0, byte1) && ArgumentCount == 0)
	{
		if (static_cast<OpCode>(byte2) == OpCode::ReturnMessageStackTop)
		{
			// instance variable accessor method (>15)
			_ASSERTE(!bNeedsContext);
			MakeQuickMethod(hdr, PRIMITIVE_RETURN_INSTVAR);

			// We must go ahead and generate the bytes anyway as they are needed by the interpreter to 
			// determine which inst. var to push (they'll fit in a SmallInteger anyway)
			_ASSERTE(CodeSize == 3);
		} 
	}
	else if (static_cast<OpCode>(byte1) == OpCode::ReturnMessageStackTop && m_bytecodes[ip_t::zero].IsShortPushImmediate)
	{
		_ASSERTE(CodeSize == 2 || !WantOptimize);
		_ASSERTE(m_bytecodes[ip_t::one].IsOpCode);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);

		_ASSERTE(m_primitiveIndex == 0);
		intptr_t immediateValue = static_cast<intptr_t>(byte0 - OpCode::ShortPushMinusOne) - 1;
		insertImmediateAsFirstLiteral(IntegerObjectOf(immediateValue));
	}
	else if (byte0 == OpCode::PushImmediate && static_cast<OpCode>(byte2) == OpCode::ReturnMessageStackTop)
	{
		_ASSERTE(CodeSize == 3 || !WantOptimize);
		_ASSERTE(m_bytecodes[ip_t::two].IsOpCode);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		int8_t immediateByte = static_cast<int8_t>(byte1);
		insertImmediateAsFirstLiteral(IntegerObjectOf(immediateByte));
	}
	else if (byte0 == OpCode::LongPushImmediate && m_bytecodes[ip_t::three].Opcode == OpCode::ReturnMessageStackTop)
	{
		_ASSERTE(CodeSize >= 4);
		_ASSERTE(m_bytecodes[ip_t::three].IsOpCode);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		int16_t immediateWord = static_cast<int16_t>(byte2 << 8) + byte1;
		insertImmediateAsFirstLiteral(IntegerObjectOf(immediateWord));
		// We can save space by replacing the LongPushImmediate instruction with 2-byte argument with a single byte push const 0
		m_bytecodes[ip_t::zero].opcode = OpCode::ShortPushConst;
		RemoveBytes(ip_t::one, 2);
		// Since we have modified the instructions after FixupJumps, we must patch up the method scope (there should only be one) 
		// to reflect the new shorter method
		pMethodScope->AdjustFinalIP(-2);
	}
	else if (byte0 == OpCode::ExLongPushImmediate && m_bytecodes[static_cast<ip_t>(ExLongPushImmediateInstructionSize)].Opcode == OpCode::ReturnMessageStackTop)
	{
		_ASSERTE(CodeSize >= 4);
		const ip_t longPush = static_cast<ip_t>(ExLongPushImmediateInstructionSize);
		_ASSERTE(m_bytecodes[longPush].IsOpCode);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		int32_t immediateValue = static_cast<int32_t>((m_bytecodes[longPush - 1].byte << 24) 
									| (m_bytecodes[longPush - 2].byte << 16) 
									| (m_bytecodes[longPush - 3].byte << 8) 
									| m_bytecodes[longPush - 4].byte);
		insertImmediateAsFirstLiteral(IntegerObjectOf(immediateValue));
		// We can save space by replacing the ExLongPushImmediate instruction with 4-byte argument with a single byte push const 0
		m_bytecodes[ip_t::zero].opcode = OpCode::ShortPushConst;
		constexpr size_t bytesToRemove = ExLongPushImmediateInstructionSize - 1;
		RemoveBytes(ip_t::one, bytesToRemove);
		pMethodScope->AdjustFinalIP(-static_cast<int>(bytesToRemove));
	}
	else if (byte0 == OpCode::PushChar && static_cast<OpCode>(byte2) == OpCode::ReturnMessageStackTop)
	{
		_ASSERTE(CodeSize == 3 || !WantOptimize);
		_ASSERTE(m_bytecodes[ip_t::two].IsOpCode);
		MakeQuickMethod(hdr, PRIMITIVE_RETURN_LITERAL_ZERO);
		_ASSERTE(m_primitiveIndex == 0);
		Oop oopChar = reinterpret_cast<Oop>(m_piVM->NewCharacter(byte1));
		insertImmediateAsFirstLiteral(oopChar);
	}
	else if ((byte0 == OpCode::ShortPushTemp && ArgumentCount == 1 && CodeSize <= sizeof(uintptr_t))
		&& ((static_cast<OpCode>(byte1) == OpCode::PopStoreInstVar && m_bytecodes[ip_t::three].Opcode == OpCode::ReturnSelf)
			||(m_bytecodes[ip_t::one].IsShortPopStoreInstVar && static_cast<OpCode>(byte2) == OpCode::ReturnSelf)))
	{
		// instance variable set method
		_ASSERTE(!bNeedsContext);
		_ASSERTE((static_cast<uint8_t>(byte0) & 1) != 0);		// First must be odd, as VM assumes will be a packed method

		// Convert back to the long form as the primitive method definition can be simpler/faster if it doesn't have to decode
		if (static_cast<OpCode>(byte1) != OpCode::PopStoreInstVar)
		{
			byte2 = byte1 - static_cast<uint8_t>(OpCode::ShortPopStoreInstVar);
			InsertByte(ip_t::two, byte2, BYTECODE::Flags::IsData, m_bytecodes[ip_t::one].pScope);
			m_bytecodes[ip_t::one].opcode = OpCode::PopStoreInstVar;
			pMethodScope->FinalIP = ip_t::three;
			m_codePointer++;
			byte1 = static_cast<uint8_t>(OpCode::PopStoreInstVar);
		}

		MakeQuickMethod(hdr, m_isMutable ? PRIMITIVE_SET_MUTABLE_INSTVAR : PRIMITIVE_SET_INSTVAR);
		
		// We go ahead and generate the bytes anyway, as they're needed by the primitive
	}
	else
	{
		// Standard code
		_ASSERTE(m_primitiveIndex == PRIMITIVE_ACTIVATE_METHOD);
	}
	
	if (m_isMutable && hdr.primitiveIndex != PRIMITIVE_SET_MUTABLE_INSTVAR)
	{
		Warning(TEXTRANGE(textpos_t::start, static_cast<textpos_t>(TextLength - 1)), CWarnMutableIgnored);
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

	_ASSERTE(pMethodScope->StackSize <= TEMPORARYLIMIT);
	_ASSERTE(ArgumentCount <= ARGLIMIT);
	hdr.stackTempCount = static_cast<uint8_t>(pMethodScope->StackTempCount);
	hdr.argumentCount = static_cast<uint8_t>(ArgumentCount);
	
	// Allocate CompiledMethod and install the header
	POTE method = NewCompiledMethod(m_compiledMethodClass, CodeSize, hdr);

	// Allocate bytecode array for the CompiledMethod and install its header
	STCompiledMethod& cmpldMethod = *(STCompiledMethod*)GetObj(method);

	// May have been changed above
	byte0 = m_bytecodes[ip_t::zero].Opcode;

	// Install bytecodes
	if (!WantDebugMethod //&& blockCount == 0
		&& (CodeSize < sizeof(uintptr_t) 
			|| (CodeSize == sizeof(uintptr_t) && ((static_cast<uint8_t>(byte0) & 1) != 0))))
	{
		Oop bytes = IntegerObjectOf(0);
		auto pByteCodes = (uint8_t*)&bytes;
		// IX86 is a little endian machine, so first must be odd for SmallInteger flag
		if ((static_cast<uint8_t>(byte0) & 1) == 0)
		{
			*pByteCodes++ = static_cast<uint8_t>(OpCode::Nop);
			// Method scope expands for leading Nop 
			IncrementIPs();

			// Adjust ip of any TextMaps
			{
				const size_t loopEnd = m_textMaps.size();
				for (size_t i = 0; i < loopEnd; i++)
					m_textMaps[i].ip++;
			}
		}
		const size_t loopEnd = CodeSize;
		for (size_t i=0; i<loopEnd && i < sizeof(uintptr_t); i++)
			pByteCodes[i] = m_bytecodes[static_cast<ip_t>(i)].byte;
		m_piVM->StorePointerWithValue(&cmpldMethod.byteCodes, bytes);
	}
	else
	{
		auto pByteCodes = FetchBytesOf(POTE(cmpldMethod.byteCodes));
		const ip_t loopEnd = LastIp;
		for (ip_t i=ip_t::zero; i<=loopEnd; i++)
			pByteCodes[static_cast<size_t>(i)] = m_bytecodes[i].byte;
		m_piVM->MakeImmutable(cmpldMethod.byteCodes, TRUE);
	}

	// We have to delay setting up the initialIP of the clean blocks until the bytecodes have been allocated.
	PatchCleanBlockLiterals(method);

	// Install literals 
	// First those referenced from bytecodes
	const size_t loopEnd = m_literalFrame.size();
	const size_t literalCount = LiteralCount + (m_annotations.size() > 0);
	size_t i = 0;
	for (; i<loopEnd; i++)
	{
		_ASSERTE(i < literalCount);
		Oop oopLiteral = m_literalFrame[i];
		_ASSERTE(oopLiteral != NULL);
		m_piVM->StorePointerWithValue(&cmpldMethod.aLiterals[i], oopLiteral);
	}
	// Then the literals for references not present in the bytecode
	for (LiteralMap::const_iterator it = m_literals.cbegin(); it != m_literals.cend(); it++)
	{
		if ((*it).second == -1)
		{
			_ASSERTE(i < literalCount);
			Oop oopLiteral = (*it).first;
			_ASSERTE(oopLiteral != NULL);
			m_piVM->StorePointerWithValue(&cmpldMethod.aLiterals[i], oopLiteral);
			i++;
		}
	}
	
	if (!m_annotations.empty())
	{
		POTE oteMethodAnnotations = MakeMethodAnnotations();
		m_piVM->StorePointerWithValue(&cmpldMethod.aLiterals[i], (Oop)oteMethodAnnotations);
	}

	m_piVM->StorePointerWithValue((Oop*)&cmpldMethod.selector, reinterpret_cast<Oop>(NewUtf8String(Selector)));
	m_piVM->StorePointerWithValue((Oop*)&cmpldMethod.methodClass, reinterpret_cast<Oop>(MethodClass));

	// Now that we have created the method, we can patch up any relative BindingReference objects defined in 
	// methods with a namespace annotation.
	PatchBindingReferenceLiterals(method);

#if defined(_DEBUG)
	{
		char buf[512];
		wsprintf(buf, "Compiling %s>>%s for %s, %s\n", GetClassName().c_str(), m_selector.c_str(), 
			WantDebugMethod ? "debug" : "release", m_ok ? "succeeded" : "failed");
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

void Compiler::IncrementIPs()
{
	LexicalScope* pMethodScope = m_allScopes[0];
	pMethodScope->AdjustFinalIP(1);
	// Should only be here for 3 byte methods, so nested scopes are unlikely, but possible
	const size_t count = m_allScopes.size();
	for (size_t i = 1; i < count; i++)
	{
		LexicalScope* pScope = m_allScopes[i];
		pScope->IncrementIPs();
	}
}

bool Compiler::IsReturnIfNotNil(ip_t ip) const
{
	const BYTECODE& bc = m_bytecodes[ip];
	return bc.IsJumpIfNotNil && m_bytecodes[bc.target].Opcode == OpCode::ReturnMessageStackTop;
}

//////////////////////////////////////////////////

POTE Compiler::MakeMethodAnnotations()
{
	if (m_annotations.size() == 1)
	{
		MethodAnnotation annotation = m_annotations[0];
		if (annotation.first == GetVMPointers().namespaceAnnotationSelector
			&& annotation.second.size() == 1
			&& annotation.second[0] == (Oop)GetVMPointers().SmalltalkDictionary)
		{
			return GetVMPointers().SmalltalkNamespaceAnnotation;
		}
	}

	POTE oteMethodAnnotations = m_piVM->NewObjectWithPointers(GetVMPointers().ClassMethodAnnotations, m_annotations.size() * 2);

	STVarObject& methodAnnotations = *(STVarObject*)GetObj(oteMethodAnnotations);
	size_t j = 0;
	for (AnnotationVector::const_iterator it = m_annotations.cbegin(); it != m_annotations.cend(); it++)
	{
		m_piVM->StorePointerWithValue(methodAnnotations.fields + j, (Oop)(*it).first);
		const OOPVECTOR& args = (*it).second;
		size_t argc = args.size();
		POTE oteArray;
		if (argc == 0)
		{
			oteArray = GetVMPointers().EmptyArray;
		}
		else
		{
			oteArray = m_piVM->NewArray(argc);
			STVarObject& argsArray = *(STVarObject*)GetObj(oteArray);
			for (size_t k = 0; k < argc; k++)
			{
				m_piVM->StorePointerWithValue(argsArray.fields + k, args[k]);
			}
			m_piVM->MakeImmutable((Oop)oteArray, TRUE);
		}
		m_piVM->StorePointerWithValue(methodAnnotations.fields + j + 1, (Oop)oteArray);
		j += 2;
	}

	m_piVM->MakeImmutable((Oop)oteMethodAnnotations, TRUE);

	return oteMethodAnnotations;
}

void Compiler::PatchCleanBlockLiterals(POTE oteMethod)
{
	const size_t count = m_allScopes.size();
	for (size_t i = 1; i < count; i++)
	{
		LexicalScope* pScope = m_allScopes[i];
		if (pScope->IsCleanBlock)
		{
			pScope->PatchBlockLiteral(m_piVM, oteMethod);
		}
	}
}

void Compiler::PatchBindingReferenceLiterals(POTE oteMethod)
{
	// If the method does not have a namespace annotation, then the method class is an equivalent context for any
	// relative binding references, so we don't need to do anything. Otherwise we need to patch the relative literal 
	// binding references to have the right context.
	if (m_namespaceAnnotationIndex != -1)
	{
		POTE setContextSelector = GetVMPointers().setScopeSelector;
		for (auto it = m_bindingRefs.cbegin(); it != m_bindingRefs.cend(); it++)
		{
			// If relative, update the context to be the method so that the binding search will include the method namespace
			if ((*it).first.ends_with(RelativeBindingRefIdSuffix))
			{
				POTE bindingRef = (*it).second;
				m_piVM->PerformWith((Oop)bindingRef, setContextSelector, (Oop)oteMethod);
			}
		}
	}
}

size_t Compiler::FixupTempsAndBlocks()
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

		if (!pScope->IsOptimizedBlock)
		{
			pScope->AllocTempIndices(this);
		}
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
	const size_t count = m_allScopes.size();
	_ASSERTE(count >= 1);
	for (size_t i = 1; i < count; i++)
	{
		LexicalScope* pScope = m_allScopes[i];
		pScope->PatchOptimized(this);
	}
}

void Compiler::DetermineTempUsage()
{
	const ip_t last = LastIp;
	for (ip_t i = ip_t::zero; i <= last;)
	{
		const BYTECODE& bytecode1 = m_bytecodes[i];
		size_t len1 = bytecode1.InstructionLength;

		_ASSERTE(!bytecode1.IsPushTemp);

		switch(bytecode1.Opcode)
		{
		case OpCode::LongPushOuterTemp:
		case OpCode::LongStoreOuterTemp:
			bytecode1.pVarRef->MergeRefIntoDecl(this);
			break;

#ifdef _DEBUG
		case OpCode::PushOuterTemp:
		case OpCode::StoreOuterTemp:
		case OpCode::PopStoreOuterTemp:
		case OpCode::PushTemp:
		case OpCode::PopStoreTemp:
		case OpCode::StoreTemp:
			_ASSERT(false);
			break;
#endif

		default:
			break;
		};

		i += len1;
	}
}

size_t Compiler::FixupTempRefs()
{
	size_t fixed=0;
	const ip_t last = LastIp;
	for (ip_t i = ip_t::zero; i <= last;)
	{
		const BYTECODE& bytecode1 = m_bytecodes[i];
		const size_t len1 = bytecode1.InstructionLength;

		switch(bytecode1.Opcode)
		{
		case OpCode::LongPushOuterTemp:
		case OpCode::LongStoreOuterTemp:
			FixupTempRef(i);
			fixed++;
			break;

		case OpCode::FarReturn:
			bytecode1.pScope->MarkFarReturner();
			break;

		default:
			break;
		};

		i += len1;
	}

	return fixed;
}

void Compiler::FixupTempRef(ip_t i)
{
	BYTECODE& byte1 = m_bytecodes[i];
	BYTECODE& byte2 = m_bytecodes[i+1];
	BYTECODE& byte3 = m_bytecodes[i+2];
	_ASSERTE(byte1.IsOpCode);
	_ASSERTE(byte2.IsData);
	_ASSERTE(byte3.IsData);

	TempVarRef* pVarRef = byte1.pVarRef;
	_ASSERTE(pVarRef != nullptr);
	TempVarDecl* pDecl = pVarRef->Decl;
	size_t index = pDecl->Index;
	_ASSERTE(index != -1 && index < UINT8_MAX);
	// Temp refs should by now be pointing at real decls in unoptimized scopes
	_ASSERTE(!pDecl->Scope->IsOptimizedBlock);

	bool bIsPush = byte1.Opcode == OpCode::LongPushOuterTemp;

	TempVarType varType = pDecl->VarType;
	switch(varType)
	{
	case TempVarType::Copy:
	case TempVarType::Stack:
	case TempVarType::Copied:
		if (bIsPush)
		{
			if (index < NumShortPushTemps)
			{
				byte1.opcode = OpCode::ShortPushTemp + index;
				byte2.makeNop(byte1.pScope);
			}
			else
			{
				byte1.opcode = OpCode::PushTemp;
				byte2.byte = static_cast<uint8_t>(index);
			}
		}
		else
		{
			if (index < NumShortStoreTemps)
			{
				byte1.opcode = OpCode::ShortStoreTemp + index;
				byte2.makeNop(byte1.pScope);
			}
			else
			{
				byte1.opcode = OpCode::StoreTemp;
				byte2.byte = static_cast<uint8_t>(index);
			}
		}
		byte3.makeNop(byte1.pScope);
		break;

	case TempVarType::Shared:
		{
			unsigned outer = pVarRef->GetActualDistance();
			_ASSERTE(outer <= UINT8_MAX);
			TempVarDecl* pDecl = pVarRef->Decl;
			_ASSERTE(pDecl == pVarRef->Decl->ActualDecl);
			if (outer > 0)
				pVarRef->Scope->SetReferencesOuterTempsIn(pDecl->Scope);

			_ASSERTE(index < pDecl->Scope->SharedTempsCount);

			if (outer < 2 && index < NumPushContextTemps && bIsPush)
			{
				byte1.opcode = (outer == 0 ? OpCode::ShortPushContextTemp : OpCode::ShortPushOuterTemp) + index;
				byte2.makeNop(byte1.pScope);
				byte3.makeNop(byte1.pScope);
			}
			else if (outer <= OuterTempMaxDepth && index <= OuterTempMaxIndex)
			{
				byte1.opcode = bIsPush ? OpCode::PushOuterTemp : OpCode::StoreOuterTemp;
				byte2.byte = (outer << OuterTempIndexBits) | static_cast<uint8_t>(index);
				byte3.makeNop(byte1.pScope);
			}
			else
			{
				byte2.byte = outer;
				byte3.byte = static_cast<uint8_t>(index);
			}
		}
		break;

	case TempVarType::Unaccessed:
	default:
		{
			TempVarDecl* pDecl = pVarRef->Decl;
			InternalError(__FILE__, __LINE__, pVarRef->TextRange, 
				"Invalid temp variable state %d for '%s'", 
				pVarRef->VarType, pVarRef->Name.c_str());
		}
		break;
	};
}

size_t Compiler::PatchBlocks()
{
	ip_t i=ip_t::zero;
	size_t blockCount = 0;
	while (i <= LastIp)
	{
		const BYTECODE& bytecode1 = m_bytecodes[i];
		size_t len1 = bytecode1.InstructionLength;

		switch(bytecode1.Opcode)
		{
		case OpCode::BlockCopy:
			len1 += PatchBlockAt(i);
			blockCount++;
			VerifyTextMap(true);
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
size_t Compiler::PatchBlockAt(ip_t i)
{
	BYTECODE& byte1 = m_bytecodes[i];
	_ASSERTE(byte1.Opcode == OpCode::BlockCopy);
	LexicalScope* pScope = byte1.pScope;
	_ASSERTE(pScope != nullptr);
	// Self and far return flags should have been propagated by now
	_ASSERTE(!pScope->NeedsSelf || pScope->Outer->NeedsSelf);
	_ASSERTE(!pScope->HasFarReturn || pScope->Outer->HasFarReturn);

	if (pScope->IsCleanBlock)
	{
		MakeCleanBlockAt(i);
		return 0;
	}

	// From now on we don't want this instruction to appear to be part of this block's scope
	LexicalScope* pOuter = pScope->Outer;
	_ASSERTE(pOuter != nullptr);
	byte1.pScope = pOuter;

	//	BlockCopy
	//	+1	nArgs
	//	+2	nStack
	//	+3	(nEnv << 1) | (0|1)		bottom bit set if outer ref. required
	//	+4	nCopiedTemps
	//	+5	jumpOffset1
	//		jumpOffset2
	_ASSERTE(m_bytecodes[i+1].byte == pScope->ArgumentCount);
	m_bytecodes[i+2].byte = static_cast<uint8_t>(pScope->StackTempCount);

	// Note that the env size includes the env temps and copied temps
	tempcount_t nEnvSize = pScope->SharedTempsCount;
	_ASSERTE(nEnvSize <= INT8_MAX);
	bool needsOuter = pScope->NeedsOuter;
	m_bytecodes[i+3].byte = static_cast<uint8_t>((nEnvSize << 1) | (needsOuter ? 1 : 0));

	tempcount_t nCopied = pScope->CopiedValuesCount;
	_ASSERTE(nCopied <= INT8_MAX);
	m_bytecodes[i+4].byte = static_cast<uint8_t>((nCopied << 1) | (pScope->NeedsSelf ?1:0));

	// This text map is needed by the Debugger to remap the initial IP of block frames.
	textpos_t blockStart = pScope->TextRange.m_start;
	InsertTextMapEntry(i + BlockCopyInstructionLength, blockStart, blockStart-1);

	if (nCopied == 0)
		return 0;

	////////////////////////////////////////////////////////////////////////////////////////
	// Generate push temp instructions for all values to be copied from enclosing scope
	//
	_ASSERTE(m_codePointer == LastIp+1);
	_ASSERTE(!byte1.IsJumpTarget);
	m_codePointer = i;

	m_pCurrentScope = pOuter->RealScope;

	size_t extraBytes = 0;
	DECLLIST& copiedTemps = pScope->GetCopiedTemps();
	const DECLLIST::reverse_iterator loopEnd = copiedTemps.rend();
	for (DECLLIST::reverse_iterator it = copiedTemps.rbegin(); it != loopEnd; it++)
	{
		TempVarDecl* pCopy = (*it);
		TempVarDecl* pCopyFrom = pCopy->Outer;
		_ASSERTE(pCopyFrom != nullptr && !pCopyFrom->Scope->IsOptimizedBlock);
		if (pCopyFrom == nullptr || pCopyFrom->Scope != m_pCurrentScope)
			InternalError(__FILE__, __LINE__, pCopy->TextRange, "Copied temp '%s' not found in outer scope", pCopy->Name.c_str());

		// Its a copied value, so must be local to this environment
		extraBytes += GenPushCopiedValue(pCopyFrom);
	}

	m_pCurrentScope = nullptr;

	// TODO: Is this right? Looks to be off by one
	m_codePointer = LastIp + 1;

	return extraBytes;
}

void Compiler::MakeCleanBlockAt(ip_t i)
{
	BYTECODE& byte1 = m_bytecodes[i];
	_ASSERTE(byte1.Opcode == OpCode::BlockCopy);
	_ASSERTE(byte1.InstructionLength == BlockCopyInstructionLength);
	ip_t initIP = i + BlockCopyInstructionLength;
	BYTECODE& firstInBlock = m_bytecodes[initIP];
	BYTECODE& secondInBlock = m_bytecodes[initIP + firstInBlock.InstructionLength];

	LexicalScope* pScope = byte1.pScope;
	_ASSERTE(pScope->IsBlock);

	LexicalScope* pOuter = pScope->Outer; 
	_ASSERTE(pOuter != nullptr);
	byte1.pScope = pOuter;

	// If a Clean block, then we can patch out the block copy replacing it
	// with a push of a literal block we store in the frame, and a jump
	// over the blocks bytecodes.

	const VMPointers& vmPointers = GetVMPointers();
	POTE blockPointer = WantDebugMethod ? vmPointers.EmptyDebugBlock : vmPointers.EmptyBlock;
	bool isEmptyBlock = pScope->IsEmptyBlock;
	bool useEmptyBlock = isEmptyBlock && blockPointer != Nil() 
		// We don't want to generate empty block form for the empty block itself
		&& this->TextLength != 2;

	if (useEmptyBlock)
	{
		_ASSERTE(!firstInBlock.IsJumpTarget);
		_ASSERTE(!secondInBlock.IsJumpTarget);
	}
	else
	{
		blockPointer = m_piVM->NewObjectWithPointers(vmPointers.ClassBlockClosure, 
		((sizeof(STBlockClosure)
			-sizeof(Oop)	// Deduct dummy literal frame entry (arrays cannot be zero sized in IDL)
//			-sizeof(ObjectHeader)	// Deduct size of head which NewObjectWithPointers includes implicitly
		)/sizeof(Oop)));

		pScope->SetCleanBlockLiteral(blockPointer);
	}

	size_t index = AddToFrame(reinterpret_cast<Oop>(blockPointer), pScope->TextRange, LiteralType::Normal);
	if (index < NumShortPushConsts)		// In range of short instructions ?
	{
		byte1.opcode = OpCode::ShortPushConst + index;
		UngenData(i+1, byte1.pScope);
		UngenData(i+2, byte1.pScope);
	}
	else if (index <= UINT8_MAX)				// In range of single extended instructions ?
	{
		byte1.opcode = OpCode::PushConst;
		m_bytecodes[i+1].byte = static_cast<uint8_t>(index);
		UngenData(i+2, byte1.pScope);
	}
	else
	{
		byte1.opcode = OpCode::LongPushConst;
		m_bytecodes[i+1].byte = index & UINT8_MAX;
		m_bytecodes[i+2].byte = (index >> 8) & UINT8_MAX;
	}

	// The block copy is no longer a jump, being replaced by byte 4 (or not at all if empty)
	byte1.makeNonJump();

	initIP = i;
	if (useEmptyBlock)
	{
		ip_t j=i+3;
		for(;j<i+BlockCopyInstructionLength;j++)
			UngenData(j, pOuter);
		while(m_bytecodes[j].Opcode != OpCode::ReturnBlockStackTop)
		{
			_ASSERTE(m_bytecodes[j].IsOpCode);
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
		UngenData(i+3, pOuter);

		auto nextAfter = byte1.target;

		m_bytecodes[i+4].makeOpCode(OpCode::LongJump, pOuter);
		m_bytecodes[i+4].makeJumpTo(nextAfter);

		// +5 and +6 remain the jump offset

		initIP += BlockCopyInstructionLength;
		_ASSERTE(m_bytecodes[initIP].IsOpCode);

		auto newInitIp = m_codePointer;
		int offset = (int)newInitIp - (int)initIP;

		// Now we are going to move all the bytecodes to the end of the method so that they are out of line
		for (auto i = initIP; i < nextAfter; i++)
		{
			BYTECODE bc = m_bytecodes[i];
			if (bc.IsOpCode)
			{
				if (bc.IsJumpSource)
				{
					bc.target += offset;
					m_bytecodes[i].makeNonJump();
				}
				auto it = FindTextMapEntry(i);
				if (it != m_textMaps.end())
				{
					TEXTMAP tm = *it;
					m_textMaps.erase(it);
					tm.ip = m_codePointer;
					m_textMaps.push_back(tm);
				}
			}
			m_bytecodes.push_back(bc);
			m_codePointer++;
			m_bytecodes[i].makeNop(pOuter);
		}

		// We must mark the blocks first bytecode as a jump target to prevent
		// it being treated as unreachable code
		m_bytecodes[newInitIp].addJumpTo();

		// This text map is needed by the Debugger to remap the initial IP of block frames.
		textpos_t blockStart = pScope->TextRange.m_start;
		InsertTextMapEntry(newInitIp, blockStart, blockStart-1);
	}
}

