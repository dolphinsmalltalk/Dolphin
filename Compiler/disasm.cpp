#include "stdafx.h"
#include "Compiler.h"
#include <minmax.h>

#pragma warning(disable:4786)	// Browser identifier truncated to 255 characters

#pragma warning(push,3)
#pragma warning(disable:4530)
#include <iostream>
#include <iomanip>
#include <sstream>
#pragma warning(pop)
using namespace std;

#include "..\tracestream.h"
tracestream debugStream;

void Compiler::disassemble()
{
	tracelock lock(debugStream);
	debugStream << noshowbase << nouppercase << setfill(' ');
	disassemble(debugStream);
}

void Compiler::disassemble(ostream& stream)
{
	int maxDepth = 0;
	for (size_t i = 0; i < m_allScopes.size(); i++)
	{
		int depth = m_allScopes[i]->GetLogicalDepth();
		if (depth > maxDepth) maxDepth = depth;
	}

	LexicalScope* currentScope = m_allScopes[0];
	int currentDepth = 0;
	stream << endl;
	int i=0;
	const int size = GetCodeSize();
	while (i < size)
	{
		// Print one-based ip as this is how they are disassembled in the image
		stream << dec << setw(5) << (i+1) << ":";
		int len = lengthOfByteCode(m_bytecodes[i].byte);
		stream << hex << uppercase << setfill('0');
		int j;
		for (j = 0; j < min(len,3); j++)
		{
			stream << ' ' << setw(2) << static_cast<unsigned>(m_bytecodes[i + j].byte);
		}
		if (len > 3)
		{
			stream << "...";
			j++;
		}
		for (; j < 4; j++)
		{
			stream << "   ";
		}
		stream << setfill(' ') << nouppercase << dec;

		// Scope changing, and getting deeper?
		LexicalScope* newScope = m_bytecodes[i].pScope;
		stream << newScope << ' ';

		char padChar = ' ';
		// If new nested scope, want to print opening bracket
		if (currentScope != newScope)
		{
			int newDepth = newScope->GetLogicalDepth();
			if (!(newDepth < currentDepth))
			{
				padChar = '-';
			}
			currentScope = m_bytecodes[i].pScope;
			currentDepth = newDepth;
		}

		// If next is in outer scope, want to print closing bracket now
		bool lastInstr = i + len >= size;
		int nextDepth = lastInstr ? 0 : m_bytecodes[i + len].pScope->GetLogicalDepth();

		// If not on last bytecode, and scope will change, close the bracket
		if (nextDepth < currentDepth)
		{
			padChar = '-';
		}

		for (j = 0; j < currentDepth; j++)
		{
			stream << "|";
		}
		for (; j <= maxDepth; j++)
		{
			stream << padChar;
		}
		disassembleAt(stream, i);
		i += len;
	}
}

void Compiler::disassembleAt(ostream& stream, int ip)
{
	const BYTECODE& bytecode = m_bytecodes[ip];
	const TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
		stream << '`';
	else 
		stream << ' ';

	const int opcode = bytecode.byte;
	switch (opcode)
	{
	case Break:
		stream << "*Break";
		break;

	case ShortPushInstVar + 0:
	case ShortPushInstVar + 1:
	case ShortPushInstVar + 2:
	case ShortPushInstVar + 3:
	case ShortPushInstVar + 4:
	case ShortPushInstVar + 5:
	case ShortPushInstVar + 6:
	case ShortPushInstVar + 7:
	case ShortPushInstVar + 8:
	case ShortPushInstVar + 9:
	case ShortPushInstVar + 10:
	case ShortPushInstVar + 11:
	case ShortPushInstVar + 12:
	case ShortPushInstVar + 13:
	case ShortPushInstVar + 14:
	case ShortPushInstVar + 15:
		PrintInstVarInstruction(stream, "Push", opcode - ShortPushInstVar);
	break;

	case ShortPushTemp + 0:
	case ShortPushTemp + 1:
	case ShortPushTemp + 2:
	case ShortPushTemp + 3:
	case ShortPushTemp + 4:
	case ShortPushTemp + 5:
	case ShortPushTemp + 6:
	case ShortPushTemp + 7:
		PrintTempInstruction(stream, "Push", opcode - ShortPushTemp, bytecode);
		break;

	case ShortPushConst + 0:
	case ShortPushConst + 1:
	case ShortPushConst + 2:
	case ShortPushConst + 3:
	case ShortPushConst + 4:
	case ShortPushConst + 5:
	case ShortPushConst + 6:
	case ShortPushConst + 7:
	case ShortPushConst + 8:
	case ShortPushConst + 9:
	case ShortPushConst + 10:
	case ShortPushConst + 11:
	case ShortPushConst + 12:
	case ShortPushConst + 13:
	case ShortPushConst + 14:
	case ShortPushConst + 15:
		PrintStaticInstruction(stream, "Push Const", opcode - ShortPushConst);
		break;

	case ShortPushStatic + 0:
	case ShortPushStatic + 1:
	case ShortPushStatic + 2:
	case ShortPushStatic + 3:
	case ShortPushStatic + 4:
	case ShortPushStatic + 5:
	case ShortPushStatic + 6:
	case ShortPushStatic + 7:
	case ShortPushStatic + 8:
	case ShortPushStatic + 9:
	case ShortPushStatic + 10:
	case ShortPushStatic + 11:
		PrintStaticInstruction(stream, "Push Static", opcode - ShortPushStatic);
		break;

	case ShortPushNil:
		stream << "Push nil";
		break;

	case ShortPushTrue:
		stream << "Push true";
		break;

	case ShortPushFalse:
		stream << "Push false";
		break;

	case ShortPushSelf:
		stream << "Push self";
		break;

	case ShortPushMinusOne:
		PrintPushImmediate(stream, -1, 0);
		break;

	case ShortPushZero:
		PrintPushImmediate(stream, 0, 0);
		break;

	case ShortPushOne:
		PrintPushImmediate(stream, 1, 0);
		break;

	case ShortPushTwo:
		PrintPushImmediate(stream, 2, 0);
		break;

	case ShortPushSelfAndTemp + 0:
	case ShortPushSelfAndTemp + 1:
	case ShortPushSelfAndTemp + 2:
	case ShortPushSelfAndTemp + 3:
		PrintTempInstruction(stream, "Push self; Push", opcode - ShortPushSelfAndTemp, bytecode);

		break;

	case ShortStoreTemp + 0:
	case ShortStoreTemp + 1:
	case ShortStoreTemp + 2:
	case ShortStoreTemp + 3:
		PrintTempInstruction(stream, "Store", opcode - ShortStoreTemp, bytecode);

		break;

	case ShortPopPushTemp + 0:
	case ShortPopPushTemp + 1:
		PrintTempInstruction(stream, "Pop; Push", opcode - ShortPopPushTemp, bytecode);

		break;

	case PopPushSelf:
		stream << "Pop; Push self";
		break;

	case PopDup:
		stream << "Pop; Dup";
		break;

	case ShortPushContextTemp + 0:
	case ShortPushContextTemp + 1:
		PrintTempInstruction(stream, "Push Outer[0]", opcode - ShortPushContextTemp, bytecode);
		break;

	case ShortPushOuterTemp + 0:
	case ShortPushOuterTemp + 1:
		PrintTempInstruction(stream, "Push Outer[1]", opcode - ShortPushOuterTemp, bytecode);
		break;

	case PopStoreContextTemp + 0:
	case PopStoreContextTemp + 1:
		PrintTempInstruction(stream, "Pop Outer[0]", opcode - PopStoreContextTemp, bytecode);
		break;

	case ShortPopStoreOuterTemp + 0:
	case ShortPopStoreOuterTemp + 1:
		PrintTempInstruction(stream, "Pop Outer[1]", opcode - ShortPopStoreOuterTemp, bytecode);
		break;

	case ShortPopStoreInstVar + 0:
	case ShortPopStoreInstVar + 1:
	case ShortPopStoreInstVar + 2:
	case ShortPopStoreInstVar + 3:
	case ShortPopStoreInstVar + 4:
	case ShortPopStoreInstVar + 5:
	case ShortPopStoreInstVar + 6:
	case ShortPopStoreInstVar + 7:
		PrintInstVarInstruction(stream, "Pop", opcode - ShortPopStoreInstVar);
		break;

	case  ShortPopStoreTemp + 0:
	case  ShortPopStoreTemp + 1:
	case  ShortPopStoreTemp + 2:
	case  ShortPopStoreTemp + 3:
	case  ShortPopStoreTemp + 4:
	case  ShortPopStoreTemp + 5:
	case  ShortPopStoreTemp + 6:
	case  ShortPopStoreTemp + 7:
		PrintTempInstruction(stream, "Pop", opcode - ShortPopStoreTemp, bytecode);
		break;

	case PopStackTop:
		stream << "Pop";
		break;

	case DuplicateStackTop:
		stream << "Dup";
		break;

	case PushActiveFrame:
		stream << "Push Active Frame";
		break;

	case IncrementStackTop:
		stream << "Increment";
		break;

	case DecrementStackTop:
		stream << "Decrement";
		break;

	case ReturnNil:
		stream << "Return nil";
		break;

	case ReturnTrue:
		stream << "Return true";
		break;

	case ReturnFalse:
		stream << "Return false";
		break;

	case ReturnSelf:
		stream << "Return self";
		break;

	case PopReturnSelf:
		stream << "Pop; Return self";
		break;

	case ReturnMessageStackTop:
		stream << "Return";
		break;

	case ReturnBlockStackTop:
		stream << "Return From Block";
		break;

	case FarReturn:
		stream << "Far Return";
		break;

	case Nop:
		stream << "Nop";
		break;

	case  ShortJump + 0:
	case  ShortJump + 1:
	case  ShortJump + 2:
	case  ShortJump + 3:
	case  ShortJump + 4:
	case  ShortJump + 5:
	case  ShortJump + 6:
	case  ShortJump + 7:
		PrintJumpInstruction(stream, Jump, opcode - ShortJump, bytecode.target);
		break;

	case  ShortJumpIfFalse + 0:
	case  ShortJumpIfFalse + 1:
	case  ShortJumpIfFalse + 2:
	case  ShortJumpIfFalse + 3:
	case  ShortJumpIfFalse + 4:
	case  ShortJumpIfFalse + 5:
	case  ShortJumpIfFalse + 6:
	case  ShortJumpIfFalse + 7:
		PrintJumpInstruction(stream, JumpIfFalse, opcode - ShortJumpIfFalse, bytecode.target);
		break;

	case SendArithmeticAdd:
	case SendArithmeticSub:
	case ShortSpecialSend + 2:
	case ShortSpecialSend + 3:
	case ShortSpecialSend + 4:
	case ShortSpecialSend + 5:
	case ShortSpecialSend + 6:
	case ShortSpecialSend + 7:
	case ShortSpecialSend + 8:
	case ShortSpecialSend + 9:
	case ShortSpecialSend + 10:
	case ShortSpecialSend + 11:
	case ShortSpecialSend + 12:
	case ShortSpecialSend + 13:
	case ShortSpecialSend + 14:
	case ShortSpecialSend + 15:
	case ShortSpecialSend + 16:
	case ShortSpecialSend + 17:
	case ShortSpecialSend + 18:
	case ShortSpecialSend + 19:
	case ShortSpecialSend + 20:
	case ShortSpecialSend + 21:
	case ShortSpecialSend + 22:
	case ShortSpecialSend + 23:
	case ShortSpecialSend + 24:
	case ShortSpecialSend + 25:
	case ShortSpecialSend + 26:
	case ShortSpecialSend + 27:
	case ShortSpecialSend + 28:
	case ShortSpecialSend + 29:
	case ShortSpecialSend + 30:
	case ShortSpecialSend + 31:
	{
		const POTE* pSpecialSelectors = GetVMPointers().specialSelectors;
		const POTE stringPointer = pSpecialSelectors[opcode - ShortSpecialSend];
		Str selector = MakeString(m_piVM, stringPointer);
		stream << "Special Send #" << selector;
	}
	break;


	case ShortSendWithNoArgs + 0:
	case ShortSendWithNoArgs + 1:
	case ShortSendWithNoArgs + 2:
	case ShortSendWithNoArgs + 3:
	case ShortSendWithNoArgs + 4:
	case ShortSendWithNoArgs + 5:
	case ShortSendWithNoArgs + 6:
	case ShortSendWithNoArgs + 7:
	case ShortSendWithNoArgs + 8:
	case ShortSendWithNoArgs + 9:
	case ShortSendWithNoArgs + 10:
	case ShortSendWithNoArgs + 11:
	case ShortSendWithNoArgs + 12:
		PrintSendInstruction(stream, opcode - ShortSendWithNoArgs, 0);
		break;

	case ShortSendSelfWithNoArgs + 0:
	case ShortSendSelfWithNoArgs + 1:
	case ShortSendSelfWithNoArgs + 2:
	case ShortSendSelfWithNoArgs + 3:
	case ShortSendSelfWithNoArgs + 4:
		stream << "Push self; ";
		PrintSendInstruction(stream, opcode - ShortSendSelfWithNoArgs, 0);
		break;

	case ShortSendWith1Arg + 0:
	case ShortSendWith1Arg + 1:
	case ShortSendWith1Arg + 2:
	case ShortSendWith1Arg + 3:
	case ShortSendWith1Arg + 4:
	case ShortSendWith1Arg + 5:
	case ShortSendWith1Arg + 6:
	case ShortSendWith1Arg + 7:
	case ShortSendWith1Arg + 8:
	case ShortSendWith1Arg + 9:
	case ShortSendWith1Arg + 10:
	case ShortSendWith1Arg + 11:
	case ShortSendWith1Arg + 12:
	case ShortSendWith1Arg + 13:
		PrintSendInstruction(stream, opcode - ShortSendWith1Arg, 1);
		break;

	case ShortSendWith2Args + 0:
	case ShortSendWith2Args + 1:
	case ShortSendWith2Args + 2:
	case ShortSendWith2Args + 3:
	case ShortSendWith2Args + 4:
	case ShortSendWith2Args + 5:
	case ShortSendWith2Args + 6:
	case ShortSendWith2Args + 7:
		PrintSendInstruction(stream, opcode - ShortSendWith2Args, 2);
		break;

	case SpecialSendIsZero:
		stream << "Special Send Is Zero";
		break;

	case PushInstVar:
		PrintInstVarInstruction(stream, "Push", m_bytecodes[ip + 1].byte);
		break;

	case PushTemp:
		PrintTempInstruction(stream, "Push", m_bytecodes[ip + 1].byte, bytecode);
		break;

	case PushOuterTemp:
		stream << "Push Outer[" << dec << static_cast<int>(m_bytecodes[ip + 1].byte >> 5);
		PrintTempInstruction(stream, "]", (m_bytecodes[ip + 1].byte & 0x1F), bytecode);
		break;

	case PushConst:
		PrintStaticInstruction(stream, "Push Const", m_bytecodes[ip + 1].byte);
		break;

	case PushStatic:
		PrintStaticInstruction(stream, "Push Static", m_bytecodes[ip + 1].byte);
		break;

	case StoreInstVar:
		PrintInstVarInstruction(stream, "Store", m_bytecodes[ip + 1].byte);
		break;

	case StoreTemp:
		PrintTempInstruction(stream, "Store", m_bytecodes[ip + 1].byte, bytecode);
		break;

	case StoreOuterTemp:
		stream << "Store Outer[" << dec << static_cast<int>(m_bytecodes[ip + 1].byte >> 5);
		PrintTempInstruction(stream, "]", (m_bytecodes[ip + 1].byte & 0x1F), bytecode);
		break;

	case StoreStatic:
		PrintStaticInstruction(stream, "Store", m_bytecodes[ip + 1].byte);
		break;

	case PopStoreInstVar:
		PrintInstVarInstruction(stream, "Pop", m_bytecodes[ip + 1].byte);
		break;

	case PopStoreTemp:
		PrintTempInstruction(stream, "Pop", m_bytecodes[ip + 1].byte, bytecode);
		break;

	case PopStoreOuterTemp:
		stream << "Pop Outer[" << dec << static_cast<int>(m_bytecodes[ip + 1].byte >> 5);
		PrintTempInstruction(stream, "]", (m_bytecodes[ip + 1].byte & 0x1F), bytecode);
		break;

	case PopStoreStatic:
		PrintStaticInstruction(stream, "Pop Static", m_bytecodes[ip + 1].byte);
		break;

	case PushImmediate:
		PrintPushImmediate(stream, static_cast<SBYTE>(m_bytecodes[ip + 1].byte), 1);
		break;

	case PushChar:
		stream << "Push Char $" << static_cast<char>('\0' + m_bytecodes[ip + 1].byte);
		break;

	case Send:
		PrintSendInstruction(stream, m_bytecodes[ip + 1].byte & SendXMaxLiteral, m_bytecodes[ip + 1].byte >> SendXLiteralBits);
		break;

	case Supersend:
		stream << "Super ";
		PrintSendInstruction(stream, m_bytecodes[ip + 1].byte & SendXMaxLiteral, m_bytecodes[ip + 1].byte >> SendXLiteralBits);
		break;

	case NearJump:
	case NearJumpIfTrue:
	case NearJumpIfFalse:
	case NearJumpIfNil:
	case NearJumpIfNotNil:
		PrintJumpInstruction(stream, (JumpType)(opcode-NearJump), static_cast<SBYTE>(m_bytecodes[ip + 1].byte), bytecode.target);
		break;

	case SendTempWithNoArgs:
		PrintTempInstruction(stream, "Push", m_bytecodes[ip + 1].byte >> SendXLiteralBits, bytecode);
		stream << "; ";
		PrintSendInstruction(stream, m_bytecodes[ip + 1].byte & SendXMaxLiteral, 0);
		break;

	case PushSelfAndTemp:
		PrintTempInstruction(stream, "Push self; Push", m_bytecodes[ip + 1].byte, bytecode);
		break;

	case SendSelfWithNoArgs:
		PrintSendInstruction(stream, m_bytecodes[ip + 1].byte, 0);
		break;

	case PushTempPair:
		PrintTempInstruction(stream, "Push", m_bytecodes[ip + 1].byte >> 4, bytecode);
		PrintTempInstruction(stream, "; Push", m_bytecodes[ip + 1].byte & 0xF, m_bytecodes[ip + 1]);
		break;

	// Three bytes from here on ...
	case LongPushConst:
		PrintStaticInstruction(stream, "Push Const", (m_bytecodes[ip + 2].byte << 8) + m_bytecodes[ip + 1].byte);
		break;

	case LongPushStatic:
		PrintStaticInstruction(stream, "Push Static", (m_bytecodes[ip + 2].byte << 8) + m_bytecodes[ip + 1].byte);
		break;

	case LongStoreStatic:
		PrintStaticInstruction(stream, "Store Static", (m_bytecodes[ip + 2].byte << 8) + m_bytecodes[ip + 1].byte);
		break;

	case LongPushImmediate:
		PrintPushImmediate(stream, (m_bytecodes[ip + 2].byte << 8) + m_bytecodes[ip + 1].byte, 2);
		break;

	case LongSend:
		PrintSendInstruction(stream, m_bytecodes[ip + 2].byte, m_bytecodes[ip + 1].byte);
		break;

	case LongSupersend:
		stream << "Super ";
		PrintSendInstruction(stream, m_bytecodes[ip + 2].byte, m_bytecodes[ip + 1].byte);
		break;


	case LongJump:
	case LongJumpIfTrue:
	case LongJumpIfFalse:
	case LongJumpIfNil:
	case LongJumpIfNotNil:
		PrintJumpInstruction(stream, (JumpType)(opcode - LongJump), m_bytecodes[ip + 1].byte, bytecode.target);
		break;

	case LongPushOuterTemp:
		stream << "Push Outer[" << dec << static_cast<int>(m_bytecodes[ip + 1].byte);
		PrintTempInstruction(stream, "]", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case LongStoreOuterTemp:
		stream << "Store Outer[" << dec << static_cast<int>(m_bytecodes[ip + 1].byte);
		PrintTempInstruction(stream, "]", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case IncrementTemp:
		// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
		PrintTempInstruction(stream, "Increment", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case IncrementPushTemp:
		// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
		PrintTempInstruction(stream, "Increment & Push", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case DecrementTemp:
		// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
		PrintTempInstruction(stream, "Decrement", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case DecrementPushTemp:
		// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
		PrintTempInstruction(stream, "Decrement & Push", m_bytecodes[ip + 2].byte, bytecode);
		break;

	case BlockCopy:
		{
			int nArgs = m_bytecodes[ip+1].byte;
			stream << "Block Copy, " << dec;
			if (nArgs > 0)
				stream << nArgs << " args, ";
			int nStackTemps = m_bytecodes[ip+2].byte;
			if (nStackTemps > 0)
				stream << nStackTemps << " stack temps, ";
			int nEnvTemps = m_bytecodes[ip+3].byte >> 1;
			int nCopied = m_bytecodes[ip+4].byte >> 1;
			if (nEnvTemps > 0)
				stream << nEnvTemps << " env temps, ";
			if (nCopied > 0)
				stream << nCopied << " copied values, ";
			if (m_bytecodes[ip+4].byte & 1)
				stream << "needs self, ";
			if (m_bytecodes[ip+3].byte & 1)
				stream << "needs outer, ";
			int length = (m_bytecodes[ip+6].byte << 8) + m_bytecodes[ip+5].byte;
			stream << "length: " << length;
		}
		break;

	case ExLongSend:
		PrintSendInstruction(stream, (m_bytecodes[ip + 3].byte << 8) + m_bytecodes[ip + 2].byte, m_bytecodes[ip + 1].byte);
		break;

	case ExLongSupersend:
		stream << "Super ";
		PrintSendInstruction(stream, (m_bytecodes[ip + 3].byte << 8) + m_bytecodes[ip + 2].byte, m_bytecodes[ip + 1].byte);
		break;

	case ExLongPushImmediate:
		PrintPushImmediate(stream, (m_bytecodes[ip + 4].byte << 24) + (m_bytecodes[ip + 3].byte << 16) + (m_bytecodes[ip + 2].byte << 8) + m_bytecodes[ip + 1].byte, 4);
		break;


	default:
		stream << "UNHANDLED BYTE CODE " << opcode << "!!!";
		break;
	}
	stream << endl;
	stream.flush();
}

Str Compiler::DebugPrintString(Oop oop)
{
	USES_CONVERSION;

	CComBSTR bstr;
	bstr.Attach(m_piVM->DebugPrintString(oop));
	return W2A(bstr);
}

void Compiler::PrintJumpInstruction(ostream& stream, JumpType jumpType, SWORD offset, int target)
{
	const char* JumpNames[] = { "Jump", "Jump If True", "Jump If False", "Jump If Nil", "Jump If Not Nil" };
	stream << JumpNames[jumpType] << ' ';
	if (offset > 0)
	{
		stream << '+';
	}
	stream << dec << static_cast<int>(offset) << " to " << (target + 1);
}

void Compiler::PrintStaticInstruction(ostream& stream, const char* type, int index)
{
	stream << type << " [" << dec << index << "]: " << DebugPrintString(m_literalFrame[index]);
}

void Compiler::PrintInstVarInstruction(ostream& stream, const char* type, int index)
{
	stream << type << " InstVar[" << dec << index << "]: " << m_instVars[index];
}

void Compiler::PrintSendInstruction(ostream& stream, int index, int argumentCount)
{
	Str selector = MakeString(this->m_piVM, (POTE)this->m_literalFrame[index]);
	stream << "Send[" << dec << index << "]: #" << selector << " with " << argumentCount << (argumentCount == 1 ? " arg" : " args");
}

void Compiler::PrintTempInstruction(std::ostream& stream, const char* type, int index, const BYTECODE& bytecode)
{
	TempVarRef* varRef = bytecode.pVarRef;
	stream << type << " Temp[" << dec << index << "]: " << (varRef ? varRef->GetName() : "<NULL ==> Compiler Bug>");
}

void Compiler::PrintPushImmediate(std::ostream& stream, int value, int byteSize)
{
	stream << "Push " << dec << value;
	if (byteSize > 0)
	{
		stream << " (" << hex << "0x" << setfill('0') << setw(byteSize * 2) << value << ')' << setfill(' ');
	}
}