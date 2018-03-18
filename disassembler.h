#pragma once

#pragma warning(push,3)
#pragma warning(disable:4530)
#include <iostream>
#include <iomanip>
#include <sstream>
#pragma warning(pop)

#include "bytecdes.h"

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif

std::wostream& operator<<(std::wostream& stream, const std::string& str);

template <class T> class BytecodeDisassembler
{
	T& context;
public:

	BytecodeDisassembler(T& i) : context(i)
	{}

	//void Disassemble(T context, std::wostream& stream);
	size_t DisassembleAt(size_t ip, std::wostream& stream)
	{
		EmitIp(ip, stream);
		size_t len = EmitRawBytes(ip, stream);
		EmitDecodedInstructionAt(ip, stream);
		return len;
	}

private:
	size_t GetCodeSize() { 
		return context.GetCodeSize(); 
	}
	BYTE GetBytecode(size_t ip) {
		return context.GetBytecode(ip);
	}

public:
	void EmitIp(size_t ip, std::wostream& stream)
	{
		// Print one-based ip as this is how they are disassembled in the image
		stream << dec << setw(5) << (ip + 1) << L":";
	}

	size_t EmitRawBytes(size_t ip, std::wostream& stream)
	{
		int len = lengthOfByteCode(GetBytecode(ip));
		stream << hex << uppercase << setfill(L'0');
		int j;
		for (j = 0; j < min(len, 3); j++)
		{
			stream << L' ' << setw(2) << static_cast<unsigned>(GetBytecode(ip + j));
		}
		if (len > 3)
		{
			stream << L"...";
			j++;
		}
		for (; j < 4; j++)
		{
			stream << L"   ";
		}
		stream << setfill(L' ') << nouppercase << dec;
		return len;
	}

	void BytecodeDisassembler::EmitDecodedInstructionAt(size_t ip, std::wostream& stream)
	{
		const BYTE opcode = GetBytecode(ip);

		switch (opcode)
		{
		case Break:
			stream << L"*Break";
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
			PrintInstVarInstruction(ip, stream, "Push", opcode - ShortPushInstVar);
			break;

		case ShortPushTemp + 0:
		case ShortPushTemp + 1:
		case ShortPushTemp + 2:
		case ShortPushTemp + 3:
		case ShortPushTemp + 4:
		case ShortPushTemp + 5:
		case ShortPushTemp + 6:
		case ShortPushTemp + 7:
			PrintTempInstruction(ip, stream, "Push", opcode - ShortPushTemp);
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
			PrintStaticInstruction(ip, stream, "Push Const", opcode - ShortPushConst);
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
			PrintStaticInstruction(ip, stream, "Push Static", opcode - ShortPushStatic);
			break;

		case ShortPushNil:
			stream << L"Push nil";
			break;

		case ShortPushTrue:
			stream << L"Push true";
			break;

		case ShortPushFalse:
			stream << L"Push false";
			break;

		case ShortPushSelf:
			stream << L"Push self";
			break;

		case ShortPushMinusOne:
			PrintPushImmediate(ip, stream, -1, 0);
			break;

		case ShortPushZero:
			PrintPushImmediate(ip, stream, 0, 0);
			break;

		case ShortPushOne:
			PrintPushImmediate(ip, stream, 1, 0);
			break;

		case ShortPushTwo:
			PrintPushImmediate(ip, stream, 2, 0);
			break;

		case ShortPushSelfAndTemp + 0:
		case ShortPushSelfAndTemp + 1:
		case ShortPushSelfAndTemp + 2:
		case ShortPushSelfAndTemp + 3:
			PrintTempInstruction(ip, stream, "Push self; Push", opcode - ShortPushSelfAndTemp);

			break;

		case ShortStoreTemp + 0:
		case ShortStoreTemp + 1:
		case ShortStoreTemp + 2:
		case ShortStoreTemp + 3:
			PrintTempInstruction(ip, stream, "Store", opcode - ShortStoreTemp);

			break;

		case ShortPopPushTemp + 0:
		case ShortPopPushTemp + 1:
			PrintTempInstruction(ip, stream, "Pop; Push", opcode - ShortPopPushTemp);

			break;

		case PopPushSelf:
			stream << L"Pop; Push self";
			break;

		case PopDup:
			stream << L"Pop; Dup";
			break;

		case ShortPushContextTemp + 0:
		case ShortPushContextTemp + 1:
			PrintTempInstruction(ip, stream, "Push Outer[0]", opcode - ShortPushContextTemp);
			break;

		case ShortPushOuterTemp + 0:
		case ShortPushOuterTemp + 1:
			PrintTempInstruction(ip, stream, "Push Outer[1]", opcode - ShortPushOuterTemp);
			break;

		case PopStoreContextTemp + 0:
		case PopStoreContextTemp + 1:
			PrintTempInstruction(ip, stream, "Pop Outer[0]", opcode - PopStoreContextTemp);
			break;

		case ShortPopStoreOuterTemp + 0:
		case ShortPopStoreOuterTemp + 1:
			PrintTempInstruction(ip, stream, "Pop Outer[1]", opcode - ShortPopStoreOuterTemp);
			break;

		case ShortPopStoreInstVar + 0:
		case ShortPopStoreInstVar + 1:
		case ShortPopStoreInstVar + 2:
		case ShortPopStoreInstVar + 3:
		case ShortPopStoreInstVar + 4:
		case ShortPopStoreInstVar + 5:
		case ShortPopStoreInstVar + 6:
		case ShortPopStoreInstVar + 7:
			PrintInstVarInstruction(ip, stream, "Pop", opcode - ShortPopStoreInstVar);
			break;

		case  ShortPopStoreTemp + 0:
		case  ShortPopStoreTemp + 1:
		case  ShortPopStoreTemp + 2:
		case  ShortPopStoreTemp + 3:
		case  ShortPopStoreTemp + 4:
		case  ShortPopStoreTemp + 5:
		case  ShortPopStoreTemp + 6:
		case  ShortPopStoreTemp + 7:
			PrintTempInstruction(ip, stream, "Pop", opcode - ShortPopStoreTemp);
			break;

		case PopStackTop:
			stream << L"Pop";
			break;

		case DuplicateStackTop:
			stream << L"Dup";
			break;

		case PushActiveFrame:
			stream << L"Push Active Frame";
			break;

		case IncrementStackTop:
			stream << L"Increment";
			break;

		case DecrementStackTop:
			stream << L"Decrement";
			break;

		case ReturnNil:
			stream << L"Return nil";
			break;

		case ReturnTrue:
			stream << L"Return true";
			break;

		case ReturnFalse:
			stream << L"Return false";
			break;

		case ReturnSelf:
			stream << L"Return self";
			break;

		case PopReturnSelf:
			stream << L"Pop; Return self";
			break;

		case ReturnMessageStackTop:
			stream << L"Return";
			break;

		case ReturnBlockStackTop:
			stream << L"Return From Block";
			break;

		case FarReturn:
			stream << L"Far Return";
			break;

		case Nop:
			stream << L"Nop";
			break;

		case  ShortJump + 0:
		case  ShortJump + 1:
		case  ShortJump + 2:
		case  ShortJump + 3:
		case  ShortJump + 4:
		case  ShortJump + 5:
		case  ShortJump + 6:
		case  ShortJump + 7:
		{
			BYTE offset = opcode - ShortJump;
			PrintJumpInstruction(ip, stream, Jump, offset, offset + ip + 1 + 1);
		}
		break;

		case  ShortJumpIfFalse + 0:
		case  ShortJumpIfFalse + 1:
		case  ShortJumpIfFalse + 2:
		case  ShortJumpIfFalse + 3:
		case  ShortJumpIfFalse + 4:
		case  ShortJumpIfFalse + 5:
		case  ShortJumpIfFalse + 6:
		case  ShortJumpIfFalse + 7:
		{
			BYTE offset = opcode - ShortJumpIfFalse;
			PrintJumpInstruction(ip, stream, JumpIfFalse, offset, offset + ip + 1 + 1);
		}
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
			stream << L"Special Send #" << context.GetSpecialSelector(opcode - ShortSpecialSend);
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
			PrintSendInstruction(ip, stream, opcode - ShortSendWithNoArgs, 0);
			break;

		case ShortSendSelfWithNoArgs + 0:
		case ShortSendSelfWithNoArgs + 1:
		case ShortSendSelfWithNoArgs + 2:
		case ShortSendSelfWithNoArgs + 3:
		case ShortSendSelfWithNoArgs + 4:
			stream << L"Push self; ";
			PrintSendInstruction(ip, stream, opcode - ShortSendSelfWithNoArgs, 0);
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
			PrintSendInstruction(ip, stream, opcode - ShortSendWith1Arg, 1);
			break;

		case ShortSendWith2Args + 0:
		case ShortSendWith2Args + 1:
		case ShortSendWith2Args + 2:
		case ShortSendWith2Args + 3:
		case ShortSendWith2Args + 4:
		case ShortSendWith2Args + 5:
		case ShortSendWith2Args + 6:
		case ShortSendWith2Args + 7:
			PrintSendInstruction(ip, stream, opcode - ShortSendWith2Args, 2);
			break;

		case IsZero:
			stream << L"IsZero";
			break;

		case PushInstVar:
			PrintInstVarInstruction(ip, stream, "Push", GetBytecode(ip + 1));
			break;

		case PushTemp:
			PrintTempInstruction(ip, stream, "Push", GetBytecode(ip + 1));
			break;

		case PushOuterTemp:
		{
			BYTE operand = GetBytecode(ip + 1);
			stream << L"Push Outer[" << dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", (operand & 0x1F));
		}
		break;

		case PushConst:
			PrintStaticInstruction(ip, stream, "Push Const", GetBytecode(ip + 1));
			break;

		case PushStatic:
			PrintStaticInstruction(ip, stream, "Push Static", GetBytecode(ip + 1));
			break;

		case StoreInstVar:
			PrintInstVarInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case StoreTemp:
			PrintTempInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case StoreOuterTemp:
		{
			BYTE operand = GetBytecode(ip + 1);
			stream << L"Store Outer[" << dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", (operand & 0x1F));
		}
		break;

		case StoreStatic:
			PrintStaticInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case PopStoreInstVar:
			PrintInstVarInstruction(ip, stream, "Pop", GetBytecode(ip + 1));
			break;

		case PopStoreTemp:
			PrintTempInstruction(ip, stream, "Pop", GetBytecode(ip + 1));
			break;

		case PopStoreOuterTemp:
		{
			BYTE operand = GetBytecode(ip + 1);
			stream << L"Pop Outer[" << dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", operand & 0x1F);
		}
		break;

		case PopStoreStatic:
			PrintStaticInstruction(ip, stream, "Pop Static", GetBytecode(ip + 1));
			break;

		case PushImmediate:
			PrintPushImmediate(ip, stream, static_cast<SBYTE>(GetBytecode(ip + 1)), 1);
			break;

		case PushChar:
			stream << L"Push Char $" << static_cast<char>('\0' + GetBytecode(ip + 1));
			break;

		case Send:
		{
			BYTE operand = GetBytecode(ip + 1);
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, operand >> SendXLiteralBits);
		}
		break;

		case Supersend:
		{
			BYTE operand = GetBytecode(ip + 1);
			stream << L"Super ";
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, operand >> SendXLiteralBits);
		}
		break;

		case NearJump:
		case NearJumpIfTrue:
		case NearJumpIfFalse:
		case NearJumpIfNil:
		case NearJumpIfNotNil:
		{
			SBYTE offset = static_cast<SBYTE>(GetBytecode(ip + 1));
			PrintJumpInstruction(ip, stream, (JumpType)(opcode - NearJump), offset, ip + offset + 2);
		}
		break;

		case SendTempWithNoArgs:
		{
			BYTE operand = GetBytecode(ip + 1);
			PrintTempInstruction(ip, stream, "Push", operand >> SendXLiteralBits);
			stream << L"; ";
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, 0);
		}
		break;

		case PushSelfAndTemp:
			PrintTempInstruction(ip, stream, "Push self; Push", GetBytecode(ip + 1));
			break;

		case SendSelfWithNoArgs:
			PrintSendInstruction(ip, stream, GetBytecode(ip + 1), 0);
			break;

		case PushTempPair:
		{
			BYTE operand = GetBytecode(ip + 1);
			PrintTempInstruction(ip, stream, "Push", operand >> 4);
			PrintTempInstruction(ip + 1, stream, "; Push", operand & 0xF);
		}
		break;

		// Three bytes from here on ...
		case LongPushConst:
			PrintStaticInstruction(ip, stream, "Push Const", (GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1));
			break;

		case LongPushStatic:
			PrintStaticInstruction(ip, stream, "Push Static", (GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1));
			break;

		case LongStoreStatic:
			PrintStaticInstruction(ip, stream, "Store Static", (GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1));
			break;

		case LongPushImmediate:
			PrintPushImmediate(ip, stream, (SWORD)((GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1)), 2);
			break;

		case LongSend:
			PrintSendInstruction(ip, stream, GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case LongSupersend:
			stream << L"Super ";
			PrintSendInstruction(ip, stream, GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;


		case LongJump:
		case LongJumpIfTrue:
		case LongJumpIfFalse:
		case LongJumpIfNil:
		case LongJumpIfNotNil:
		{
			SWORD offset = (SWORD)((GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1));
			PrintJumpInstruction(ip, stream, (JumpType)(opcode - LongJump), offset, ip + 3 + offset);
		}
		break;

		case LongPushOuterTemp:
			stream << L"Push Outer[" << dec << static_cast<int>(GetBytecode(ip + 1));
			PrintTempInstruction(ip, stream, "]", GetBytecode(ip + 2));
			break;

		case LongStoreOuterTemp:
			stream << L"Store Outer[" << dec << static_cast<int>(GetBytecode(ip + 1));
			PrintTempInstruction(ip, stream, "]", GetBytecode(ip + 2));
			break;

		case IncrementTemp:
			// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Increment", GetBytecode(ip + 2));
			break;

		case IncrementPushTemp:
			// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Increment & Push", GetBytecode(ip + 2));
			break;

		case DecrementTemp:
			// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Decrement", GetBytecode(ip + 2));
			break;

		case DecrementPushTemp:
			// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Decrement & Push", GetBytecode(ip + 2));
			break;

		case BlockCopy:
		{
			int nArgs = GetBytecode(ip + 1);
			stream << L"Block Copy, " << dec;
			if (nArgs > 0)
				stream << nArgs << L" args, ";
			int nStackTemps = GetBytecode(ip + 2);
			if (nStackTemps > 0)
				stream << nStackTemps << L" stack temps, ";
			int nEnvTemps = GetBytecode(ip + 3) >> 1;
			int nCopied = GetBytecode(ip + 4) >> 1;
			if (nEnvTemps > 0)
				stream << nEnvTemps << L" env temps, ";
			if (nCopied > 0)
				stream << nCopied << L" copied values, ";
			if (GetBytecode(ip + 4) & 1)
				stream << L"needs self, ";
			if (GetBytecode(ip + 3) & 1)
				stream << L"needs outer, ";
			int length = (GetBytecode(ip + 6) << 8) + GetBytecode(ip + 5);
			stream << L"length: " << length;
		}
		break;

		case ExLongSend:
			PrintSendInstruction(ip, stream, (GetBytecode(ip + 3) << 8) + GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case ExLongSupersend:
			stream << L"Super ";
			PrintSendInstruction(ip, stream, (GetBytecode(ip + 3) << 8) + GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case ExLongPushImmediate:
			PrintPushImmediate(ip, stream, (GetBytecode(ip + 4) << 24) + (GetBytecode(ip + 3) << 16) + (GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1), 4);
			break;


		default:
			stream << L"UNHANDLED BYTE CODE " << opcode << L"!!!";
			break;
		}
		stream << endl;
		stream.flush();
	}

	void BytecodeDisassembler::PrintJumpInstruction(size_t ip, std::wostream& stream, JumpType jumpType, SWORD offset, size_t target)
	{
		const char* JumpNames[] = { "Jump", "Jump If True", "Jump If False", "Jump If Nil", "Jump If Not Nil" };
		stream << JumpNames[jumpType] << L' ';
		if (offset > 0)
		{
			stream << L'+';
		}
		stream << dec << static_cast<int>(offset) << L" to " << (target + 1);
	}

	void BytecodeDisassembler::PrintStaticInstruction(size_t ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" [" << dec << index << L"]: " << context.GetLiteralAsString(index);
	}

	void BytecodeDisassembler::PrintInstVarInstruction(size_t ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" InstVar[" << dec << index << L"]: " << context.GetInstVar(index);
	}

	void BytecodeDisassembler::PrintSendInstruction(size_t ip, std::wostream& stream, int index, int argumentCount)
	{
		wstring selector = context.GetLiteralAsString(index);
		stream << L"Send[" << dec << index << L"]: #" << selector << L" with " << argumentCount << (argumentCount == 1 ? L" arg" : L" args");
	}

	void BytecodeDisassembler::PrintTempInstruction(size_t ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" Temp[" << dec << index << L"]";
	}

	void BytecodeDisassembler::PrintPushImmediate(size_t ip, std::wostream& stream, int value, int byteSize)
	{
		stream << L"Push " << dec << value;
		if (byteSize > 0)
		{
			stream << L" (" << hex << L"0x" << setfill(L'0') << setw(byteSize * 2) << value << L')' << setfill(L' ');
		}
	}
};
