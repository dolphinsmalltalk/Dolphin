#include "stdafx.h"
#include "Compiler.h"

#pragma warning(disable:4786)	// Browser identifier truncated to 255 characters

#pragma warning(push,3)
#pragma warning(disable:4530)
#include <iostream>
#include <iomanip>
#include <sstream>
#pragma warning(default:4530)
using namespace std;
#pragma warning(pop)

#include "..\tracestream.h"
tracestream debugStream;

void Compiler::disassemble()
{
	tracelock lock(debugStream);
	disassemble(debugStream);
}

void Compiler::disassemble(ostream& stream)
{
	stream << endl;
	int i=0;
	while (i < GetCodeSize())
	{
		stream << dec << setw(5) << i << ":";
		disassembleAt(stream, i);
		i += lengthOfByteCode(m_bytecodes[i].byte);
	}
}

void Compiler::disassembleAt(ostream& stream, int ip)
{
	const int opcode = m_bytecodes[ip].byte;
	const TEXTMAPLIST::iterator it = FindTextMapEntry(ip);
	if (it != m_textMaps.end())
		stream << '*';
	else 
		stream << ' ';
	//stream << hex;
	//for (int i = ip; i < ip + lengthOfByteCode(opcode); i++)
	//	stream << setw(2) << (unsigned)m_bytecodes[i].byte << ' ';
	//stream << "			" << dec;
	stream << '	';

	switch (opcode) 
	{
	case Break:
		stream << "Debug Break";
		break;

	case ShortPushInstVar+0:
	case ShortPushInstVar+1:
	case ShortPushInstVar+2:
	case ShortPushInstVar+3:
	case ShortPushInstVar+4:
	case ShortPushInstVar+5:
	case ShortPushInstVar+6:
	case ShortPushInstVar+7:
	case ShortPushInstVar+8:
	case ShortPushInstVar+9:
	case ShortPushInstVar+10:
	case ShortPushInstVar+11:
	case ShortPushInstVar+12:
	case ShortPushInstVar+13:
	case ShortPushInstVar+14:
	case ShortPushInstVar+15:
		stream << "Short Push InstVar[" << dec << int(opcode - ShortPushInstVar) << ']';
		break;
		
	case ShortPushTemp+0:
	case ShortPushTemp+1:
	case ShortPushTemp+2:
	case ShortPushTemp+3:
	case ShortPushTemp+4:
	case ShortPushTemp+5:
	case ShortPushTemp+6:
	case ShortPushTemp+7:
		stream << "Short Push Temp[" << dec << int(opcode - ShortPushTemp) << "]";
		break;
		
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
		{
			int literal = opcode - ShortPushConst;
			stream << "Short Push Const[" << literal << "]";//: " << reinterpret_cast<OTE*>(literalFrame[literal]);
		}
		break;
		
	case ShortPushStatic+0:
	case ShortPushStatic+1:
	case ShortPushStatic+2:
	case ShortPushStatic+3:
	case ShortPushStatic+4:
	case ShortPushStatic+5:
	case ShortPushStatic+6:
	case ShortPushStatic+7:
	case ShortPushStatic+8:
	case ShortPushStatic+9:
	case ShortPushStatic+10:
	case ShortPushStatic+11:
		{
			int literal = opcode - ShortPushStatic;
			stream << "Short Push Static[" << literal << "]";//: " << reinterpret_cast<OTE*>(literalFrame[literal]);
		}
		break;
		
	case ShortPushNil:
		stream << "Short Push Nil";
		break;
		
	case ShortPushTrue:
		stream << "Short Push True";
		break;
		
	case ShortPushFalse:
		stream << "Short Push False";
		break;
		
	case ShortPushSelf:
		stream << "Short Push Self";
		break;
		
	case ShortPushMinusOne:
		stream << "Short Push -1";
		break;
		
	case ShortPushZero:
		stream << "Short Push 0";
		break;
		
	case ShortPushOne:
		stream << "Short Push 1";
		break;
		
	case ShortPushTwo:
		stream << "Short Push 2";
		break;

	case ShortPushSelfAndTemp+0:
	case ShortPushSelfAndTemp+1:
	case ShortPushSelfAndTemp+2:	
	case ShortPushSelfAndTemp+3:
		stream << "Push Self and Temp[" << dec << int(opcode - ShortPushSelfAndTemp) << ']';
		break;

	case ShortStoreTemp+0:
	case ShortStoreTemp+1:
	case ShortStoreTemp+2:
	case ShortStoreTemp+3:
		stream << "Short Store Temp[" << dec << int(opcode - ShortStoreTemp) << "]";
		break;

	case ShortPopPushTemp+0:
	case ShortPopPushTemp+1:
		stream << "Pop & Push Temp[" << dec << int(opcode - ShortPopPushTemp) << "]";
		break;

	case PopPushSelf:
		stream << "Pop & Push Self";
		break;

	case PopDup:
		stream << "Pop & Dup";
		break;

	case ShortPushContextTemp+0:
	case ShortPushContextTemp+1:	
		stream << "Push Outer[0] Temp[" << dec << int(opcode - ShortPushContextTemp) << "]";
		break;

	case ShortPushOuterTemp+0:
	case ShortPushOuterTemp+1:
		stream << "Push Outer[1] Temp[" << dec << int(opcode - ShortPushOuterTemp) << "]";
		break;

	case PopStoreContextTemp+0:
	case PopStoreContextTemp+1:
		stream << "Pop Store Outer[0] Temp[" << dec << int(opcode - PopStoreContextTemp) << "]";
		break;

	case ShortPopStoreOuterTemp+0:
	case ShortPopStoreOuterTemp+1:
		stream << "Pop Store Outer[1] Temp[" << dec << int(opcode - ShortPopStoreOuterTemp) << "]";
		break;

	case ShortPopStoreInstVar+0:
	case ShortPopStoreInstVar+1:
	case ShortPopStoreInstVar+2:
	case ShortPopStoreInstVar+3:
	case ShortPopStoreInstVar+4:
	case ShortPopStoreInstVar+5:
	case ShortPopStoreInstVar+6:
	case ShortPopStoreInstVar+7:
		stream << "Short Pop Store InstVar[" << dec << int(opcode - ShortPopStoreInstVar) << "]";
		break;
		
	case  ShortPopStoreTemp+0:
	case  ShortPopStoreTemp+1:
	case  ShortPopStoreTemp+2:
	case  ShortPopStoreTemp+3:
	case  ShortPopStoreTemp+4:
	case  ShortPopStoreTemp+5:
	case  ShortPopStoreTemp+6:
	case  ShortPopStoreTemp+7:
		stream << "Short Pop Store Temp[" << dec << int(opcode - ShortPopStoreTemp) << "]";
		break;
		
	case PopStackTop:
		stream << "Pop Stack Top";
		break;
		
	case DuplicateStackTop:
		stream << "Duplicate Stack Top";
		break;
		
	case PushActiveFrame:
		stream << "Push Active Frame";
		break;
		
	case IncrementStackTop:
		stream << "Increment Stack Top";
		break;
		
	case DecrementStackTop:
		stream << "Decrement Stack Top";
		break;
		
	case ReturnNil:
		stream << "Return Nil";
		break;
		
	case ReturnTrue:
		stream << "Return True";
		break;
		
	case ReturnFalse:
		stream << "Return False";
		break;
		
	case ReturnSelf:
		stream << "Return Self";
		break;

	case PopReturnSelf:
		stream << "Pop & Return Self";
		break;

	case ReturnMessageStackTop:
		stream << "Return Message stack top";
		break;
		
	case ReturnBlockStackTop:
		stream << "Return Block stack top";
		break;

	case FarReturn:
		stream << "Far Return";
		break;

	case Nop:
		stream << "Nop";
		break;
		
	case  ShortJump+0:
	case  ShortJump+1:
	case  ShortJump+2:
	case  ShortJump+3:
	case  ShortJump+4:
	case  ShortJump+5:
	case  ShortJump+6:
	case  ShortJump+7:
		{
			BYTE offset = opcode - ShortJump;
			stream << "Short Jump to " << dec << m_bytecodes[ip].target << " (offset " << dec << int(offset) << ")";
		}
		break;
		
	case  ShortJumpIfFalse+0:
	case  ShortJumpIfFalse+1:
	case  ShortJumpIfFalse+2:
	case  ShortJumpIfFalse+3:
	case  ShortJumpIfFalse+4:
	case  ShortJumpIfFalse+5:
	case  ShortJumpIfFalse+6:
	case  ShortJumpIfFalse+7:
		{
			BYTE offset = opcode - ShortJumpIfFalse;
			stream << "Short Jump to " << dec << m_bytecodes[ip].target << " If False (offset " << dec << int(offset) << ")";
		}
		break;
		
	case SendArithmeticAdd:
	case SendArithmeticSub:
	case ShortSpecialSend+2:
	case ShortSpecialSend+3:
	case ShortSpecialSend+4:
	case ShortSpecialSend+5:
	case ShortSpecialSend+6:
	case ShortSpecialSend+7:
	case ShortSpecialSend+8:
	case ShortSpecialSend+9:
	case ShortSpecialSend+10:
	case ShortSpecialSend+11:
	case ShortSpecialSend+12:
	case ShortSpecialSend+13:
	case ShortSpecialSend+14:
	case ShortSpecialSend+15:
	case ShortSpecialSend+16:
	case ShortSpecialSend+17:
	case ShortSpecialSend+18:
	case ShortSpecialSend+19:
	case ShortSpecialSend+20:
	case ShortSpecialSend+21:
	case ShortSpecialSend+22:
	case ShortSpecialSend+23:
	case ShortSpecialSend+24:
	case ShortSpecialSend+25:
	case ShortSpecialSend+26:
	case ShortSpecialSend+27:
	case ShortSpecialSend+28:
	case ShortSpecialSend+29:
	case ShortSpecialSend+30:
	case ShortSpecialSend+31:
		{
			const POTE* pSpecialSelectors = GetVMPointers().specialSelectors;
			const POTE stringPointer = pSpecialSelectors[opcode - ShortSpecialSend];
			_ASSERTE(m_piVM->IsKindOf(Oop(stringPointer), GetVMPointers().ClassString));
			const char* psz = (const char*)FetchBytesOf(stringPointer);
			stream << "Short Special Send #" << psz;
		}
		break;
		
		
	case ShortSendWithNoArgs+0:
	case ShortSendWithNoArgs+1:
	case ShortSendWithNoArgs+2:
	case ShortSendWithNoArgs+3:
	case ShortSendWithNoArgs+4:
	case ShortSendWithNoArgs+5:
	case ShortSendWithNoArgs+6:
	case ShortSendWithNoArgs+7:
	case ShortSendWithNoArgs+8:
	case ShortSendWithNoArgs+9:
	case ShortSendWithNoArgs+10:
	case ShortSendWithNoArgs+11:
	case ShortSendWithNoArgs+12:
		{
			int literal = opcode - ShortSendWithNoArgs;
			Str selector = MakeString(this->m_piVM, (POTE)this->m_literalFrame[literal]);
			stream << "Short Send #" << selector << 
				" with no args (literal " << dec << literal << ')';
		}
		break;
		
	case ShortSendSelfWithNoArgs+0:
	case ShortSendSelfWithNoArgs+1:	
	case ShortSendSelfWithNoArgs+2:	
	case ShortSendSelfWithNoArgs+3:
	case ShortSendSelfWithNoArgs+4:
		{
			int literal = opcode - ShortSendSelfWithNoArgs;
			Str selector = MakeString(this->m_piVM, (POTE)this->m_literalFrame[literal]);
			stream << "Short Send Self #" << selector <<
				" with no args (literal " << dec << literal << ')';
		}
		break;

	case ShortSendWith1Arg+0:
	case ShortSendWith1Arg+1:
	case ShortSendWith1Arg+2:
	case ShortSendWith1Arg+3:
	case ShortSendWith1Arg+4:
	case ShortSendWith1Arg+5:
	case ShortSendWith1Arg+6:
	case ShortSendWith1Arg+7:
	case ShortSendWith1Arg+8:
	case ShortSendWith1Arg+9:
	case ShortSendWith1Arg+10:
	case ShortSendWith1Arg+11:
	case ShortSendWith1Arg+12:
	case ShortSendWith1Arg+13:
		{
			int literal = opcode - ShortSendWith1Arg;
			Str selector = MakeString(this->m_piVM, (POTE)this->m_literalFrame[literal]);
			stream << "Short Send " << selector <<
				" with 1 arg (literal " << dec << literal << ')';
		}
		break;
		
	case ShortSendWith2Args+0:
	case ShortSendWith2Args+1:
	case ShortSendWith2Args+2:
	case ShortSendWith2Args+3:
	case ShortSendWith2Args+4:
	case ShortSendWith2Args+5:
	case ShortSendWith2Args+6:
	case ShortSendWith2Args+7:
		{
			int literal = opcode - ShortSendWith2Args;
			Str selector = MakeString(this->m_piVM, (POTE)this->m_literalFrame[literal]);
			stream << "Short Send " << selector <<
				" with 2 args (literal " << dec << literal << ')';
		}
		break;
		
	case SpecialSendIsZero:
		stream << "Special Send Is Zero";
		break;

	case PushInstVar:
		stream << "Push Instance Variable[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;
		
	case PushTemp:
		stream << "Push Temp[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;
		
	case PushOuterTemp:
		stream << "Push Outer[" << dec << int(m_bytecodes[ip+1].byte >> 5) <<
			"] Temp[" << dec << int(m_bytecodes[ip+1].byte & 0x1F) << ']';
		break;

	case PushConst:
		stream << "Push Const[" << dec << int(m_bytecodes[ip+1].byte) << ']';
			//<< ": " <<reinterpret_cast<OTE*>(literalFrame[m_bytecodes[ip+1].byte]);
		break;
		
	case PushStatic:
		stream << "Push Static[" << dec << int(m_bytecodes[ip+1].byte) << ']';
			//<< ": " << reinterpret_cast<OTE*>(literalFrame[m_bytecodes[ip+1].byte]);
		break;
		
	case StoreInstVar:
		stream << "Store Instance Variable[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;
		
	case StoreTemp:
		stream << "Store Temp[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;
	
	case StoreOuterTemp:
		stream << "Store Outer[" << dec << int(m_bytecodes[ip+1].byte >> 5) <<
			"] Temp[" << dec << int(m_bytecodes[ip+1].byte & 0x1F) << ']';
		break;

	case StoreStatic:
		stream << "Store Static[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		//stream << ": " << reinterpret_cast<OTE*>(literalFrame[m_bytecodes[ip+1].byte]);
		break;
		
	case PopStoreInstVar:
		stream << "Pop And Store Instance Variable[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;
		
	case PopStoreTemp:
		stream << "Pop And Store Temp[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		break;

	case PopStoreOuterTemp:
		stream << "Pop And Store Outer[" << dec << int(m_bytecodes[ip+1].byte >> 5) <<
			"] Temp[" << dec << int(m_bytecodes[ip+1].byte & 0x1F) << ']';
		break;

	case PopStoreStatic:
		stream << "Pop and Store Static[" << dec << int(m_bytecodes[ip+1].byte) << ']';
		//stream << ": " << reinterpret_cast<OTE*>(literalFrame[m_bytecodes[ip+1].byte]);
		break;
		
	case PushImmediate:
		stream << "Push Immediate " << dec << int(SBYTE(m_bytecodes[ip+1].byte));
		break;
		
	case PushChar:
		stream << "Push Char $" << char('\0'+m_bytecodes[ip+1].byte);
		break;
		
	case Send:
		{
			Str selector = MakeString(m_piVM, (POTE)m_literalFrame[m_bytecodes[ip+1].byte & SendXMaxLiteral]);
			stream << "Send " << selector << " (literal " << dec << int(m_bytecodes[ip+1].byte & SendXMaxLiteral) 
				<< "), with " << int(m_bytecodes[ip+1].byte >> SendXLiteralBits) << " args";
		}
		break;
		
	case Supersend:
		{
			Str selector = MakeString(m_piVM, (POTE)m_literalFrame[m_bytecodes[ip+1].byte & SendXMaxLiteral]);
			stream << "Supersend " << selector <<
				" (literal " << dec << int(m_bytecodes[ip+1].byte & SendXMaxLiteral) << "), with " << 
				int(m_bytecodes[ip+1].byte >> SendXLiteralBits) << " args";
		}
		break;
		
	case NearJump:
		stream << "Near Jump to " << dec << m_bytecodes[ip].target;
		break;
		
	case NearJumpIfTrue:
		stream << "Near Jump If True to " << dec << m_bytecodes[ip].target;
		break;
		
	case NearJumpIfFalse:
		stream << "Near Jump If False to " << dec << m_bytecodes[ip].target;
		break;

	case NearJumpIfNil:
		stream << "Near Jump If Nil to " << dec << m_bytecodes[ip].target;
		break;

	case NearJumpIfNotNil:
		stream << "Near Jump If Not Nil to " << dec << m_bytecodes[ip].target;
		break;

	case SendTempWithNoArgs:
		{
			int extension = int(m_bytecodes[ip+1].byte);
			int literal = extension & SendXMaxLiteral;
			int temp = extension >> SendXLiteralBits;
			stream << "Send Temp [" << temp << ']';
			//stream << space << reinterpret_cast<OTE*>(literalFrame[literal]);
			stream << " with no args (literal " << dec << literal << ')';
		}
		break;

	case PushSelfAndTemp:
		{
			int extension = int(m_bytecodes[ip+1].byte);
			stream << "Push Self and Temp[" << dec << extension << ']';
		}
		break;

	case SendSelfWithNoArgs:
		{
			int literal = int(m_bytecodes[ip+1].byte);
			Str selector = MakeString(m_piVM, (POTE)m_literalFrame[literal]);
			stream << "Send Self " << selector << 
				" with no args (literal " << dec << literal << ')';
		}
		break;

	case PushTempPair:
		{
			int n = m_bytecodes[ip+1].byte >> 4;
			int m = m_bytecodes[ip+1].byte & 0xF;
			stream << dec << "Push Temp[" << n << "] & Temp [" << m << ']';
		}
		break;

	// Three bytes from here on ...
	case LongPushConst:
		{

			WORD index = (m_bytecodes[ip+1].byte << 8) + m_bytecodes[ip+2].byte;
			stream << " Long Push Const[" << dec << index << ']';
			//stream << ": " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongPushStatic:
		{
			WORD index = (m_bytecodes[ip+1].byte << 8) + m_bytecodes[ip+2].byte;
			stream << " Long Push Static[" << dec << index << ']';
			//stream << ": " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongStoreStatic:
		{
			WORD index = (m_bytecodes[ip+1].byte << 8) + m_bytecodes[ip+2].byte;
			stream << "Long Store Static[" << dec << index << "]";
			//stream << ": " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongPopStoreStatic:
		{
			WORD index = (m_bytecodes[ip+1].byte << 8) + m_bytecodes[ip+2].byte;
			stream << "Long Pop And Store Static[" << dec << index << "]";
			//stream << ": " << reinterpret_cast<OTE*>(literalFrame[index]);
		}
		break;
		
	case LongPushImmediate:
		{
			SWORD index = (m_bytecodes[ip+1].byte << 8) + m_bytecodes[ip+2].byte;
			int extension = static_cast<int>(index);
			stream << "Long Push Immediate " << dec << extension;
		}
		break;
		
	case LongSend:
		{
			int literal = int(m_bytecodes[ip+2].byte);
			Str selector = MakeString(m_piVM, (POTE)m_literalFrame[literal]);		
			stream << "Long Send[" << dec << int(m_bytecodes[ip+2].byte) << "], " << dec << int(m_bytecodes[ip+1].byte) << " args = "
				<< selector;
		}
		break;
		
	case LongSupersend:
		{
			int literal = int(m_bytecodes[ip+2].byte);
			Str selector = MakeString(m_piVM, (POTE)m_literalFrame[literal]);	
			stream << "Long Supersend[" << dec << int(m_bytecodes[ip+2].byte) << "], " << dec << int(m_bytecodes[ip+1].byte) << " args = "
				<< selector;
		}
		break;
		
		
	case LongJump:
		stream << "Long Jump to " << dec << m_bytecodes[ip].target;
		break;
		
	case LongJumpIfTrue:
		stream << "Long Jump If True to " << dec << m_bytecodes[ip].target;
		break;
		
	case LongJumpIfFalse:
		stream << "Long Jump If False to " << dec << m_bytecodes[ip].target;
		break;

	case LongPushOuterTemp:
		stream << "Long Push Outer[" << dec << int(m_bytecodes[ip+1].byte) <<
			"] Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case LongStoreOuterTemp:
		stream << "Long Store Outer[" << dec << int(m_bytecodes[ip+1].byte) <<
			"] Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case IncrementTemp:
		stream << "Inc Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case IncrementPushTemp:
		stream << "Inc & Push Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case DecrementTemp:
		stream << "Dec Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case DecrementPushTemp:
		stream << "Dec & Push Temp[" << dec << int(m_bytecodes[ip+2].byte) << ']';
		break;

	case BlockCopy:
		{
			int nArgs = m_bytecodes[ip+1].byte;
			stream << "Block Copy, ";
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
			int length = (m_bytecodes[ip+5].byte << 8) + m_bytecodes[ip+6].byte;
			stream << "length: " << length;
		}
		break;
		
	default:
		stream << "UNHANDLED BYTE CODE " << opcode << "!!!";
		break;
	}
	stream << endl;
	stream.flush();
}

