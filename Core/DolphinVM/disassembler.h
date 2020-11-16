#pragma once

#include "bytecdes.h"
#include <iomanip>

enum class JumpType { Jump, JumpIfTrue, JumpIfFalse, JumpIfNil, JumpIfNotNil };

#ifndef min
#define min(a,b)            (((a) < (b)) ? (a) : (b))
#endif

std::wostream& __stdcall operator<<(std::wostream& stream, const std::string& str);

template <class T, class I> class BytecodeDisassembler
{
	T& context;
public:

	BytecodeDisassembler(T& i) : context(i)
	{}

	//void Disassemble(T context, std::wostream& stream);
	size_t DisassembleAt(I ip, std::wostream& stream)
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
	uint8_t GetBytecode(I ip) {
		return context.GetBytecode(ip);
	}
	OpCode GetOpCode(I ip) {
		return static_cast<OpCode>(GetBytecode(ip));
	}

public:
	void EmitIp(I ip, std::wostream& stream)
	{
		// Print one-based ip as this is how they are disassembled in the image
		stream << std::dec << std::setw(5) << static_cast<uintptr_t>(ip + 1) << L":";
	}

	size_t EmitRawBytes(I ip, std::wostream& stream)
	{
		size_t len = lengthOfByteCode(GetOpCode(ip));
		stream << std::hex << std::uppercase << std::setfill(L'0');
		size_t j;
		for (j = 0; j < min(len, 3); j++)
		{
			stream << L' ' << std::setw(2) << static_cast<uint32_t>(GetBytecode(ip + j));
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
		stream << std::setfill(L' ') << std::nouppercase << std::dec;
		return len;
	}

	void EmitDecodedInstructionAt(I ip, std::wostream& stream)
	{
		const OpCode opcode = GetOpCode(ip);

		switch (opcode)
		{
		case OpCode::Break:
			stream << L"*Break";
			break;

		case OpCode::ShortPushInstVar + 0:
		case OpCode::ShortPushInstVar + 1:
		case OpCode::ShortPushInstVar + 2:
		case OpCode::ShortPushInstVar + 3:
		case OpCode::ShortPushInstVar + 4:
		case OpCode::ShortPushInstVar + 5:
		case OpCode::ShortPushInstVar + 6:
		case OpCode::ShortPushInstVar + 7:
		case OpCode::ShortPushInstVar + 8:
		case OpCode::ShortPushInstVar + 9:
		case OpCode::ShortPushInstVar + 10:
		case OpCode::ShortPushInstVar + 11:
		case OpCode::ShortPushInstVar + 12:
		case OpCode::ShortPushInstVar + 13:
		case OpCode::ShortPushInstVar + 14:
		case OpCode::ShortPushInstVar + 15:
			PrintInstVarInstruction(ip, stream, "Push", indexOfShortPushInstVar(opcode));
			break;

		case OpCode::ShortPushTemp+0:
		case OpCode::ShortPushTemp+1:
		case OpCode::ShortPushTemp+2:
		case OpCode::ShortPushTemp+3:
		case OpCode::ShortPushTemp+4:
		case OpCode::ShortPushTemp+5:
		case OpCode::ShortPushTemp+6:
		case OpCode::ShortPushTemp+7:
			PrintTempInstruction(ip, stream, "Push", indexOfShortPushTemp(opcode));
			break;

		case OpCode::ShortPushConst+0:
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
			PrintStaticInstruction(ip, stream, "Push Const", indexOfShortPushConst(opcode));
			break;

		case OpCode::ShortPushStatic+0:
		case OpCode::ShortPushStatic+1:
		case OpCode::ShortPushStatic+2:
		case OpCode::ShortPushStatic+3:
		case OpCode::ShortPushStatic+4:
		case OpCode::ShortPushStatic+5:
		case OpCode::ShortPushStatic+6:
		case OpCode::ShortPushStatic+7:
		case OpCode::ShortPushStatic+8:
		case OpCode::ShortPushStatic+9:
		case OpCode::ShortPushStatic+10:
		case OpCode::ShortPushStatic+11:
			PrintStaticInstruction(ip, stream, "Push Static", indexOfShortPushStatic(opcode));
			break;

		case OpCode::ShortPushNil:
			stream << L"Push nil";
			break;

		case OpCode::ShortPushTrue:
			stream << L"Push true";
			break;

		case OpCode::ShortPushFalse:
			stream << L"Push false";
			break;

		case OpCode::ShortPushSelf:
			stream << L"Push self";
			break;

		case OpCode::ShortPushMinusOne:
			PrintPushImmediate(ip, stream, -1, 0);
			break;

		case OpCode::ShortPushZero:
			PrintPushImmediate(ip, stream, 0, 0);
			break;

		case OpCode::ShortPushOne:
			PrintPushImmediate(ip, stream, 1, 0);
			break;

		case OpCode::ShortPushTwo:
			PrintPushImmediate(ip, stream, 2, 0);
			break;

		case OpCode::ShortPushSelfAndTemp+0:
		case OpCode::ShortPushSelfAndTemp+1:
		case OpCode::ShortPushSelfAndTemp+2:
		case OpCode::ShortPushSelfAndTemp+3:
			PrintTempInstruction(ip, stream, "Push self; Push", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPushSelfAndTemp));

			break;

		case OpCode::ShortStoreTemp+0:
		case OpCode::ShortStoreTemp+1:
		case OpCode::ShortStoreTemp+2:
		case OpCode::ShortStoreTemp+3:
			PrintTempInstruction(ip, stream, "Store", indexOfShortStoreTemp(opcode));

			break;

		case OpCode::ShortPopPushTemp+0:
		case OpCode::ShortPopPushTemp+1:
			PrintTempInstruction(ip, stream, "Pop; Push", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPopPushTemp));

			break;

		case OpCode::PopPushSelf:
			stream << L"Pop; Push self";
			break;

		case OpCode::PopDup:
			stream << L"Pop; Dup";
			break;

		case OpCode::ShortPushContextTemp+0:
		case OpCode::ShortPushContextTemp+1:
			PrintTempInstruction(ip, stream, "Push Outer[0]", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPushContextTemp));
			break;

		case OpCode::ShortPushOuterTemp+0:
		case OpCode::ShortPushOuterTemp+1:
			PrintTempInstruction(ip, stream, "Push Outer[1]", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPushOuterTemp));
			break;

		case OpCode::PopStoreContextTemp+0:
		case OpCode::PopStoreContextTemp+1:
			PrintTempInstruction(ip, stream, "Pop Outer[0]", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::PopStoreContextTemp));
			break;

		case OpCode::ShortPopStoreOuterTemp+0:
		case OpCode::ShortPopStoreOuterTemp+1:
			PrintTempInstruction(ip, stream, "Pop Outer[1]", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPopStoreOuterTemp));
			break;

		case OpCode::ShortPopStoreInstVar+0:
		case OpCode::ShortPopStoreInstVar+1:
		case OpCode::ShortPopStoreInstVar+2:
		case OpCode::ShortPopStoreInstVar+3:
		case OpCode::ShortPopStoreInstVar+4:
		case OpCode::ShortPopStoreInstVar+5:
		case OpCode::ShortPopStoreInstVar+6:
		case OpCode::ShortPopStoreInstVar+7:
			PrintInstVarInstruction(ip, stream, "Pop", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPopStoreInstVar));
			break;

		case OpCode::ShortPopStoreTemp+0:
		case OpCode::ShortPopStoreTemp+1:
		case OpCode::ShortPopStoreTemp+2:
		case OpCode::ShortPopStoreTemp+3:
		case OpCode::ShortPopStoreTemp+4:
		case OpCode::ShortPopStoreTemp+5:
		case OpCode::ShortPopStoreTemp+6:
		case OpCode::ShortPopStoreTemp+7:
			PrintTempInstruction(ip, stream, "Pop", static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortPopStoreTemp));
			break;

		case OpCode::PopStackTop:
			stream << L"Pop";
			break;

		case OpCode::DuplicateStackTop:
			stream << L"Dup";
			break;

		case OpCode::PushActiveFrame:
			stream << L"Push Active Frame";
			break;

		case OpCode::IncrementStackTop:
			stream << L"Increment";
			break;

		case OpCode::DecrementStackTop:
			stream << L"Decrement";
			break;

		case OpCode::ReturnNil:
			stream << L"Return nil";
			break;

		case OpCode::ReturnTrue:
			stream << L"Return true";
			break;

		case OpCode::ReturnFalse:
			stream << L"Return false";
			break;

		case OpCode::ReturnSelf:
			stream << L"Return self";
			break;

		case OpCode::PopReturnSelf:
			stream << L"Pop; Return self";
			break;

		case OpCode::ReturnMessageStackTop:
			stream << L"Return";
			break;

		case OpCode::ReturnBlockStackTop:
			stream << L"Return From Block";
			break;

		case OpCode::FarReturn:
			stream << L"Far Return";
			break;

		case OpCode::Nop:
			stream << L"Nop";
			break;

		case OpCode::ShortJump+0:
		case OpCode::ShortJump+1:
		case OpCode::ShortJump+2:
		case OpCode::ShortJump+3:
		case OpCode::ShortJump+4:
		case OpCode::ShortJump+5:
		case OpCode::ShortJump+6:
		case OpCode::ShortJump+7:
		{
			int8_t offset = offsetOfShortJump(opcode);
			PrintJumpInstruction(ip, stream, JumpType::Jump, offset, offset + static_cast<intptr_t>(ip) + 1 + 1);
		}
		break;

		case OpCode::ShortJumpIfFalse+0:
		case OpCode::ShortJumpIfFalse+1:
		case OpCode::ShortJumpIfFalse+2:
		case OpCode::ShortJumpIfFalse+3:
		case OpCode::ShortJumpIfFalse+4:
		case OpCode::ShortJumpIfFalse+5:
		case OpCode::ShortJumpIfFalse+6:
		case OpCode::ShortJumpIfFalse+7:
		{
			int8_t offset = offsetOfShortJumpIfFalse(opcode);
			PrintJumpInstruction(ip, stream, JumpType::JumpIfFalse, offset, offset + static_cast<intptr_t>(ip) + 1 + 1);
		}
		break;

		case OpCode::ShortSpecialSend+0 :
		case OpCode::ShortSpecialSend+1 :
		case OpCode::ShortSpecialSend+2:
		case OpCode::ShortSpecialSend+3:
		case OpCode::ShortSpecialSend+4:
		case OpCode::ShortSpecialSend+5:
		case OpCode::ShortSpecialSend+6:
		case OpCode::ShortSpecialSend+7:
		case OpCode::ShortSpecialSend+8:
		case OpCode::ShortSpecialSend+9:
		case OpCode::ShortSpecialSend+10:
		case OpCode::ShortSpecialSend+11:
		case OpCode::ShortSpecialSend+12:
		case OpCode::ShortSpecialSend+13:
		case OpCode::ShortSpecialSend+14:
		case OpCode::ShortSpecialSend+15:
		case OpCode::ShortSpecialSend+16:
		case OpCode::ShortSpecialSend+17:
		case OpCode::ShortSpecialSend+18:
		case OpCode::ShortSpecialSend+19:
		case OpCode::ShortSpecialSend+20:
		case OpCode::ShortSpecialSend+21:
		case OpCode::ShortSpecialSend+22:
		case OpCode::ShortSpecialSend+23:
		case OpCode::ShortSpecialSend+24:
		case OpCode::ShortSpecialSend+25:
		case OpCode::ShortSpecialSend+26:
		case OpCode::ShortSpecialSend+27:
		case OpCode::ShortSpecialSend+28:
		case OpCode::ShortSpecialSend+30:
		case OpCode::ShortSpecialSend+31:
		{
			stream << L"Special Send #" << context.GetSpecialSelector(static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortSpecialSend));
		}
		break;


		case OpCode::ShortSendWithNoArgs+0:
		case OpCode::ShortSendWithNoArgs+1:
		case OpCode::ShortSendWithNoArgs+2:
		case OpCode::ShortSendWithNoArgs+3:
		case OpCode::ShortSendWithNoArgs+4:
		case OpCode::ShortSendWithNoArgs+5:
		case OpCode::ShortSendWithNoArgs+6:
		case OpCode::ShortSendWithNoArgs+7:
		case OpCode::ShortSendWithNoArgs+8:
		case OpCode::ShortSendWithNoArgs+9:
		case OpCode::ShortSendWithNoArgs+10:
		case OpCode::ShortSendWithNoArgs+11:
		case OpCode::ShortSendWithNoArgs+12:
			PrintSendInstruction(ip, stream, static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortSendWithNoArgs), 0);
			break;

		case OpCode::ShortSendSelfWithNoArgs+0:
		case OpCode::ShortSendSelfWithNoArgs+1:
		case OpCode::ShortSendSelfWithNoArgs+2:
		case OpCode::ShortSendSelfWithNoArgs+3:
		case OpCode::ShortSendSelfWithNoArgs+4:
			stream << L"Push self; ";
			PrintSendInstruction(ip, stream, static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortSendSelfWithNoArgs), 0);
			break;

		case OpCode::ShortSendWith1Arg+0:
		case OpCode::ShortSendWith1Arg+1:
		case OpCode::ShortSendWith1Arg+2:
		case OpCode::ShortSendWith1Arg+3:
		case OpCode::ShortSendWith1Arg+4:
		case OpCode::ShortSendWith1Arg+5:
		case OpCode::ShortSendWith1Arg+6:
		case OpCode::ShortSendWith1Arg+7:
		case OpCode::ShortSendWith1Arg+8:
		case OpCode::ShortSendWith1Arg+9:
		case OpCode::ShortSendWith1Arg+10:
		case OpCode::ShortSendWith1Arg+11:
		case OpCode::ShortSendWith1Arg+12:
		case OpCode::ShortSendWith1Arg+13:
			PrintSendInstruction(ip, stream, static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortSendWith1Arg), 1);
			break;

		case OpCode::ShortSendWith2Args+0:
		case OpCode::ShortSendWith2Args+1:
		case OpCode::ShortSendWith2Args+2:
		case OpCode::ShortSendWith2Args+3:
		case OpCode::ShortSendWith2Args+4:
		case OpCode::ShortSendWith2Args+5:
		case OpCode::ShortSendWith2Args+6:
		case OpCode::ShortSendWith2Args+7:
			PrintSendInstruction(ip, stream, static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::ShortSendWith2Args), 2);
			break;

		case OpCode::IsZero:
			stream << L"IsZero";
			break;

		case OpCode::SpecialSendNotIdentical:
			stream << L"Special Send #~~";
			break;

		case OpCode::SpecialSendNot:
			stream << L"Special Send #not";
			break;

		case OpCode::PushInstVar:
			PrintInstVarInstruction(ip, stream, "Push", GetBytecode(ip + 1));
			break;

		case OpCode::PushTemp:
			PrintTempInstruction(ip, stream, "Push", GetBytecode(ip + 1));
			break;

		case OpCode::PushOuterTemp:
		{
			uint8_t operand = GetBytecode(ip + 1);
			stream << L"Push Outer[" << std::dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", (operand & 0x1F));
		}
		break;

		case OpCode::PushConst:
			PrintStaticInstruction(ip, stream, "Push Const", GetBytecode(ip + 1));
			break;

		case OpCode::PushStatic:
			PrintStaticInstruction(ip, stream, "Push Static", GetBytecode(ip + 1));
			break;

		case OpCode::StoreInstVar:
			PrintInstVarInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case OpCode::StoreTemp:
			PrintTempInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case OpCode::StoreOuterTemp:
		{
			uint8_t operand = GetBytecode(ip + 1);
			stream << L"Store Outer[" << std::dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", (operand & 0x1F));
		}
		break;

		case OpCode::StoreStatic:
			PrintStaticInstruction(ip, stream, "Store", GetBytecode(ip + 1));
			break;

		case OpCode::PopStoreInstVar:
			PrintInstVarInstruction(ip, stream, "Pop", GetBytecode(ip + 1));
			break;

		case OpCode::PopStoreTemp:
			PrintTempInstruction(ip, stream, "Pop", GetBytecode(ip + 1));
			break;

		case OpCode::PopStoreOuterTemp:
		{
			uint8_t operand = GetBytecode(ip + 1);
			stream << L"Pop Outer[" << std::dec << static_cast<int>(operand >> 5);
			PrintTempInstruction(ip, stream, "]", operand & 0x1F);
		}
		break;

		case OpCode::PopStoreStatic:
			PrintStaticInstruction(ip, stream, "Pop Static", GetBytecode(ip + 1));
			break;

		case OpCode::PushImmediate:
			PrintPushImmediate(ip, stream, static_cast<int8_t>(GetBytecode(ip + 1)), 1);
			break;

		case OpCode::PushChar:
			stream << L"Push Char $" << static_cast<char>('\0' + GetBytecode(ip + 1));
			break;

		case OpCode::Send:
		{
			uint8_t operand = GetBytecode(ip + 1);
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, operand >> SendXLiteralBits);
		}
		break;

		case OpCode::Supersend:
		{
			uint8_t operand = GetBytecode(ip + 1);
			stream << L"Super ";
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, operand >> SendXLiteralBits);
		}
		break;

		case OpCode::NearJump:
		case OpCode::NearJumpIfTrue:
		case OpCode::NearJumpIfFalse:
		case OpCode::NearJumpIfNil:
		case OpCode::NearJumpIfNotNil:
		{
			int8_t offset = static_cast<int8_t>(GetBytecode(ip + 1));
			PrintJumpInstruction(ip, stream, (JumpType)(static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::NearJump)), offset, static_cast<intptr_t>(ip) + offset + 2);
		}
		break;

		case OpCode::SendTempWithNoArgs:
		{
			uint8_t operand = GetBytecode(ip + 1);
			PrintTempInstruction(ip, stream, "Push", operand >> SendXLiteralBits);
			stream << L"; ";
			PrintSendInstruction(ip, stream, operand & SendXMaxLiteral, 0);
		}
		break;

		case OpCode::PushSelfAndTemp:
			PrintTempInstruction(ip, stream, "Push self; Push", GetBytecode(ip + 1));
			break;

		case OpCode::SendSelfWithNoArgs:
			PrintSendInstruction(ip, stream, GetBytecode(ip + 1), 0);
			break;

		case OpCode::PushTempPair:
		{
			uint8_t operand = GetBytecode(ip + 1);
			PrintTempInstruction(ip, stream, "Push", operand >> 4);
			PrintTempInstruction(ip + 1, stream, "; Push", operand & 0xF);
		}
		break;

		// Three bytes from here on ...
		case OpCode::LongPushConst:
			PrintStaticInstruction(ip, stream, "Push Const", (static_cast<size_t>(GetBytecode(ip + 2)) << 8) + GetBytecode(ip + 1));
			break;

		case OpCode::LongPushStatic:
			PrintStaticInstruction(ip, stream, "Push Static", (static_cast<size_t>(GetBytecode(ip + 2)) << 8) + GetBytecode(ip + 1));
			break;

		case OpCode::LongStoreStatic:
			PrintStaticInstruction(ip, stream, "Store Static", (static_cast<size_t>(GetBytecode(ip + 2)) << 8) + GetBytecode(ip + 1));
			break;

		case OpCode::LongPushImmediate:
			PrintPushImmediate(ip, stream, static_cast<int16_t>((GetBytecode(ip + 2) << 8) + GetBytecode(ip + 1)), 2);
			break;

		case OpCode::LongSend:
			PrintSendInstruction(ip, stream, GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case OpCode::LongSupersend:
			stream << L"Super ";
			PrintSendInstruction(ip, stream, GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;


		case OpCode::LongJump:
		case OpCode::LongJumpIfTrue:
		case OpCode::LongJumpIfFalse:
		case OpCode::LongJumpIfNil:
		case OpCode::LongJumpIfNotNil:
		{
			int16_t offset = static_cast<int16_t>((GetBytecode(ip + 2) << 8ui32) + GetBytecode(ip + 1));
			PrintJumpInstruction(ip, stream, static_cast<JumpType>(static_cast<uint8_t>(opcode) - static_cast<uint8_t>(OpCode::LongJump)), offset, static_cast<intptr_t>(ip) + 3 + offset);
		}
		break;

		case OpCode::LongPushOuterTemp:
			stream << L"Push Outer[" << std::dec << static_cast<int>(GetBytecode(ip + 1));
			PrintTempInstruction(ip, stream, "]", GetBytecode(ip + 2));
			break;

		case OpCode::LongStoreOuterTemp:
			stream << L"Store Outer[" << std::dec << static_cast<int>(GetBytecode(ip + 1));
			PrintTempInstruction(ip, stream, "]", GetBytecode(ip + 2));
			break;

		case OpCode::IncrementTemp:
			// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Increment", GetBytecode(ip + 2));
			break;

		case OpCode::IncrementPushTemp:
			// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Increment & Push", GetBytecode(ip + 2));
			break;

		case OpCode::DecrementTemp:
			// Note this instruction uses a trick in that it embeds a PopStoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Decrement", GetBytecode(ip + 2));
			break;

		case OpCode::DecrementPushTemp:
			// Note this instruction uses a trick in that it embeds a StoreTemp<N>, hence why it is 3 bytes long
			PrintTempInstruction(ip, stream, "Decrement & Push", GetBytecode(ip + 2));
			break;

		case OpCode::BlockCopy:
		{
			int nArgs = GetBytecode(ip + 1);
			stream << L"Block Copy, " << std::dec;
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
			int length = (GetBytecode(ip + 6) << 8ui32) + GetBytecode(ip + 5);
			stream << L"length: " << length;
		}
		break;

		case OpCode::ExLongSend:
			PrintSendInstruction(ip, stream, (GetBytecode(ip + 3) << 8ui32) + GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case OpCode::ExLongSupersend:
			stream << L"Super ";
			PrintSendInstruction(ip, stream, (GetBytecode(ip + 3) << 8ui32) + GetBytecode(ip + 2), GetBytecode(ip + 1));
			break;

		case OpCode::ExLongPushImmediate:
			PrintPushImmediate(ip, stream, (GetBytecode(ip + 4) << 24ui32) + (GetBytecode(ip + 3) << 16ui32) + (GetBytecode(ip + 2) << 8ui32) + GetBytecode(ip + 1), 4);
			break;


		default:
			stream << L"UNHANDLED BYTECODE " << static_cast<unsigned>(opcode) << L"!!!";
			break;
		}
		stream << std::endl;
		stream.flush();
	}

	void PrintJumpInstruction(I ip, std::wostream& stream, JumpType jumpType, int16_t offset, size_t target)
	{
		const char* JumpNames[] = { "Jump", "Jump If True", "Jump If False", "Jump If Nil", "Jump If Not Nil" };
		stream << JumpNames[static_cast<std::underlying_type<JumpType>::type>(jumpType)] << L' ';
		if (offset > 0)
		{
			stream << L'+';
		}
		stream << std::dec << static_cast<int>(offset) << L" to " << (target + 1);
	}

	void PrintStaticInstruction(I ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" [" << std::dec << index << L"]: " << context.GetLiteralAsString(index);
	}

	void PrintInstVarInstruction(I ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" InstVar[" << std::dec << index << L"]: " << context.GetInstVar(index);
	}

	void PrintSendInstruction(I ip, std::wostream& stream, int index, int argumentCount)
	{
		std::wstring selector = context.GetLiteralAsString(index);
		stream << L"Send[" << std::dec << index << L"]: #" << selector << L" with " << argumentCount << (argumentCount == 1 ? L" arg" : L" args");
	}

	void PrintTempInstruction(I ip, std::wostream& stream, const char* type, size_t index)
	{
		stream << type << L" Temp[" << std::dec << index << L"]";
	}

	void PrintPushImmediate(I ip, std::wostream& stream, int value, int byteSize)
	{
		stream << L"Push " << std::dec << value;
		if (byteSize > 0)
		{
			stream << L" (" << std::hex << L"0x" << std::setfill(L'0') << std::setw(static_cast<std::streamsize>(byteSize) * 2) << value << L')' << std::setfill(L' ');
		}
	}
};
