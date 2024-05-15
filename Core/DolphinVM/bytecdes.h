/*
==========
bytecdes.h
==========
Dolphin Instruction Set
*/
#pragma once

#include <cstdint>
#include <crtdbg.h>
#include "EnumHelpers.h"

///////////////////////
// Instruction Set

static constexpr unsigned NumShortPushInstVars = 16;
static constexpr unsigned NumShortPushTemps = 8;
static constexpr unsigned NumPushContextTemps = 2;
static constexpr unsigned NumPushOuterTemps = 2;
static constexpr unsigned NumShortPushConsts = 16;
static constexpr unsigned NumShortPushStatics = 12;
static constexpr unsigned NumShortPushSelfAndTemps = 4;
static constexpr unsigned NumShortStoreTemps = 4;
static constexpr unsigned NumPopStoreContextTemps = 2;
static constexpr unsigned NumPopStoreOuterTemps = 2;
static constexpr unsigned NumShortPopStoreInstVars = 8;
static constexpr unsigned NumShortPopStoreTemps = 8;
static constexpr unsigned NumShortJumps = 8;
static constexpr unsigned NumShortJumpsIfFalse = 8;
static constexpr unsigned NumArithmeticSelectors = 16;
static constexpr unsigned NumCommonSelectors = 16;
static constexpr unsigned NumSpecialSelectors = NumArithmeticSelectors+NumCommonSelectors;
static constexpr unsigned NumShortSendsWithNoArgs = 13;
static constexpr unsigned NumShortSendSelfWithNoArgs = 5;
static constexpr unsigned NumShortSendsWith1Arg = 14;
static constexpr unsigned NumShortSendsWith2Args = 8;
static constexpr unsigned NumShortPopPushTemps = 2;

// N.B. These sizes are offsets from the instruction FOLLOWING the jump (the IP is assumed to
// have advanced to the next instruction by the time the offset is added to IP)
static constexpr int MaxBackwardsLongJump = INT16_MIN;
static constexpr int MaxForwardsLongJump = INT16_MAX;
static constexpr int MaxBackwardsNearJump = INT8_MIN;
static constexpr int MaxForwardsNearJump = INT8_MAX;

static constexpr unsigned FirstSingleByteInstruction = 0;
static constexpr unsigned FirstDoubleByteInstruction = 204;
static constexpr unsigned FirstTripleByteInstruction = 234;
static constexpr unsigned FirstMultiByteInstruction = 252;

enum class OpCode : uint8_t {

	Break = FirstSingleByteInstruction,
	ShortPushInstVar,
	ShortPushTemp = ShortPushInstVar + NumShortPushInstVars,
	ShortPushContextTemp = ShortPushTemp + NumShortPushTemps,
	ShortPushOuterTemp = ShortPushContextTemp + NumPushContextTemps,
	ShortPushConst = ShortPushOuterTemp + NumPushOuterTemps,
	ShortPushStatic = ShortPushConst + NumShortPushConsts,
	// Push pseudo variable
	ShortPushSelf = ShortPushStatic + NumShortPushStatics,
	ShortPushTrue,
	ShortPushFalse,
	ShortPushNil,
	// Short push immediates
	ShortPushMinusOne,
	ShortPushZero,
	ShortPushOne,
	ShortPushTwo,
	ShortPushSelfAndTemp,
	ShortStoreTemp = ShortPushSelfAndTemp + NumShortPushSelfAndTemps,
	ShortPopPushTemp = ShortStoreTemp + NumShortStoreTemps,
	PopPushSelf = ShortPopPushTemp + NumShortPopPushTemps,
	PopDup,
	PopStoreContextTemp,
	ShortPopStoreOuterTemp = PopStoreContextTemp + NumPopStoreContextTemps,
	ShortPopStoreInstVar = ShortPopStoreOuterTemp + NumPopStoreOuterTemps,
	ShortPopStoreTemp = ShortPopStoreInstVar + NumShortPopStoreInstVars,

	PopStackTop = ShortPopStoreTemp + NumShortPopStoreTemps,
	IncrementStackTop,		// push 1; send #+
	DecrementStackTop,		// push 1; send #-
	DuplicateStackTop,

	ReturnSelf,
	ReturnTrue,
	ReturnFalse,
	ReturnNil,

	ReturnMessageStackTop,
	ReturnBlockStackTop,
	FarReturn,
	PopReturnSelf,

	Nop,

	ShortJump,
	ShortJumpIfFalse = ShortJump + NumShortJumps,

	ShortSpecialSend = ShortJumpIfFalse + NumShortJumpsIfFalse,
	SendArithmeticAdd = ShortSpecialSend,
	SendArithmeticSub,
	SendArithmeticLT,
	SendArithmeticGT,
	SendArithmeticLE,
	SendArithmeticGE,
	SendArithmeticEQ,
	SendArithmeticNE,
	SendArithmeticMul,
	SendArithmeticDivide,
	SendArithmeticMod,
	SendArithmeticBitShift,
	SendArithmeticDiv,
	SendArithmeticBitAnd,
	SendArithmeticBitOr,

	SpecialSendIdentical,
	SpecialSendValue0,
	SpecialSendValue1,
	SpecialSendClass,
	SpecialSendSize,
	SpecialSendNew,
	SpecialSendNew1,
	SpecialSendAt,
	SpecialSendAtPut,
	SpecialSendValue2,
	SpecialSendBasicNew,
	SpecialSendBasicClass,
	SpecialSendBasicSize,
	SpecialSendBasicAt,
	SpecialSendBasicAtPut,
	SpecialSendIsNil,
	SpecialSendNotNil,
	
	ShortSendWithNoArgs = ShortSpecialSend + NumSpecialSelectors,
	ShortSendSelfWithNoArgs = ShortSendWithNoArgs + NumShortSendsWithNoArgs,
	ShortSendWith1Arg =  ShortSendSelfWithNoArgs + NumShortSendSelfWithNoArgs,
	ShortSendWith2Args =  ShortSendWith1Arg + NumShortSendsWith1Arg,

	IsZero = ShortSendWith2Args + NumShortSendsWith2Args,
	PushActiveFrame,

	ShortSpecialSendEx,
	SpecialSendNotIdentical = ShortSpecialSendEx,
	SpecialSendNot,

	// Some unused space before double byte instructions...
	UnusedShortSend202,
	UnusedShortSend203,
	
	PushInstVar = FirstDoubleByteInstruction, 
	PushTemp,
	PushConst,
	PushStatic,
	
	StoreInstVar,
	StoreTemp,
	StoreStatic,
	
	PopStoreInstVar,
	PopStoreTemp,
	PopStoreStatic,

	PushImmediate,
	PushChar,
	Send,
	Supersend,
	SpecialSend,				// Not implemented yet
	NearJump,
	NearJumpIfTrue,
	NearJumpIfFalse,
	NearJumpIfNil,
	NearJumpIfNotNil,
	ReservedJump224,
	ReservedJump225,
	SendTempWithNoArgs,
	PushSelfAndTemp,
	PushOuterTemp,
	StoreOuterTemp,
	PopStoreOuterTemp,
	SendSelfWithNoArgs,
	PopSendSelfNoArgs,
	PushTempPair,

	LongPushConst = FirstTripleByteInstruction,
	LongPushStatic,
	LongStoreStatic,
	_unusedTripleByte237,
	LongPushImmediate,
	LongSend,
	LongSupersend,
	LongJump,
	LongJumpIfTrue,
	LongJumpIfFalse,
	LongJumpIfNil,
	LongJumpIfNotNil,
	LongPushOuterTemp,
	LongStoreOuterTemp,
	IncrementTemp,
	IncrementPushTemp,
	DecrementTemp,
	DecrementPushTemp,

	BlockCopy = FirstMultiByteInstruction,
	ExLongSend,
	ExLongSupersend,
	ExLongPushImmediate
};

ENABLE_INT_OPERATORS(OpCode)

static constexpr unsigned FirstShortPush = static_cast<unsigned>(OpCode::ShortPushInstVar);
static constexpr unsigned LastShortPush = static_cast<unsigned>(OpCode::ShortPushStatic) + NumShortPushStatics - 1;
static constexpr unsigned FirstPseudoPush = static_cast<unsigned>(OpCode::ShortPushSelf);
static constexpr unsigned LastPseudoPush = static_cast<unsigned>(OpCode::ShortPushNil);
static constexpr unsigned LastPush = static_cast<unsigned>(OpCode::ShortPushSelfAndTemp) + NumShortPushSelfAndTemps - 1;
static constexpr unsigned LastShortJump = static_cast<unsigned>(OpCode::ShortJump) + NumShortJumps - 1;
static constexpr unsigned LastShortSend = static_cast<unsigned>(OpCode::ShortSendWith2Args) + NumShortSendsWith2Args - 1;
static constexpr unsigned NumExSpecialSends = 4;
static constexpr unsigned FirstExtendedStore = static_cast<unsigned>(OpCode::StoreInstVar);
static constexpr unsigned LastExtendedStore = static_cast<unsigned>(OpCode::StoreStatic);
static constexpr unsigned FirstPopStore = static_cast<unsigned>(OpCode::PopStoreInstVar);
static constexpr unsigned LastPopStore = static_cast<unsigned>(OpCode::PopStoreStatic);

// Offsets for Push and ReturnFromMessage
// These are deliberately reordered from Blue Book to provide most opportunity for packing
// 4 byte code methods into a SmallInteger (which can be done if the first byte is odd).
// Since push receiver is very often the first byte of a short method, the BBB byte code of 112
// is reassigned to 115 (push nil if very infrequently used at the start of a method)
//enum PseudoVars { Nil, True, False, Receiver, NumPseudoVars };
//enum SpecialPushes { MinusOne=NumPseudoVars, Zero, One, Two, NumSpecialPushes };

#define MAXFORBITS(n) ((1 << (n)) - 1)

// Consts for Single extended send instructions
static constexpr unsigned SendXArgCountBits 	= 3;
static constexpr unsigned SendXMaxArgs	 		= MAXFORBITS(SendXArgCountBits);
static constexpr unsigned SendXLiteralBits 		= 8 - SendXArgCountBits;
static constexpr unsigned SendXMaxLiteral 		= MAXFORBITS(SendXLiteralBits);

// Consts for double extended send instructions
static constexpr unsigned Send2XArgCountBits	= 8;
static constexpr unsigned Send2XMaxArgs			= MAXFORBITS(Send2XArgCountBits);
static constexpr unsigned Send2XLiteralBits 	= 8;
static constexpr unsigned Send2XMaxLiteral		= MAXFORBITS(Send2XLiteralBits);

static constexpr unsigned Send3XArgCountBits	= 8;
static constexpr unsigned Send3XMaxArgs			= MAXFORBITS(Send3XArgCountBits);
static constexpr unsigned Send3XLiteralBits 	= 16;
static constexpr unsigned Send3XMaxLiteral		= MAXFORBITS(Send3XLiteralBits);

static constexpr unsigned OuterTempIndexBits	= 5;
static constexpr unsigned OuterTempMaxIndex		= MAXFORBITS(OuterTempIndexBits);
static constexpr unsigned OuterTempDepthBits	= 3;
static constexpr unsigned OuterTempMaxDepth		= MAXFORBITS(OuterTempDepthBits);

#pragma warning(disable:4201)
struct BlockCopyExtension
{
	uint8_t	argCount;
	uint8_t	stackTempsCount;
	uint8_t	needsOuter:1;
	uint8_t	envTempsCount:7;
	uint8_t	needsSelf:1;
	uint8_t	copiedValuesCount:7;
};

static constexpr unsigned ExLongPushImmediateInstructionSize = 5;
static constexpr unsigned BlockCopyInstructionSize = 7;

inline unsigned lengthOfByteCode(OpCode opCode)
{
	return static_cast<unsigned>(opCode) < FirstDoubleByteInstruction ? 1 : 
				static_cast<unsigned>(opCode) < FirstTripleByteInstruction ? 2 : 
					static_cast<unsigned>(opCode) <  FirstMultiByteInstruction ? 3 : 
						opCode == OpCode::BlockCopy ? BlockCopyInstructionSize : 
							opCode == OpCode::ExLongPushImmediate ? ExLongPushImmediateInstructionSize : 4;

}

inline bool isShortPushInstVar(OpCode code)
{
	return code >= OpCode::ShortPushInstVar && code < OpCode::ShortPushInstVar + NumShortPushInstVars;
}

inline uint8_t indexOfShortPushInstVar(OpCode code)
{
	_ASSERTE(isShortPushInstVar(code));
	return static_cast<uint8_t>(code - OpCode::ShortPushInstVar);
}

inline bool isShortPushTemp(OpCode code)
{
	return code >= OpCode::ShortPushTemp && code < OpCode::ShortPushTemp + NumShortPushTemps;
}

inline uint8_t indexOfShortPushTemp(OpCode code)
{
	_ASSERTE(isShortPushTemp(code));
	return static_cast<uint8_t>(code - OpCode::ShortPushTemp);
}

inline bool isShortPushConst(OpCode code)
{
	return code >= OpCode::ShortPushConst && code < OpCode::ShortPushConst + NumShortPushConsts;
}

inline uint8_t indexOfShortPushConst(OpCode code)
{
	_ASSERTE(isShortPushConst(code));
	return static_cast<uint8_t>(code - OpCode::ShortPushConst);
}

inline bool isShortPushStatic(OpCode code)
{
	return code >= OpCode::ShortPushStatic && code < OpCode::ShortPushStatic + NumShortPushStatics;
}

inline uint8_t indexOfShortPushStatic(OpCode code)
{
	_ASSERTE(isShortPushStatic(code));
	return static_cast<uint8_t>(code - OpCode::ShortPushStatic);
}

inline bool isShortPopStoreTemp(OpCode code)
{
	return code >= OpCode::ShortPopStoreTemp && code < OpCode::ShortPopStoreTemp + NumShortPopStoreTemps;
}

inline uint8_t indexOfShortPopStoreTemp(OpCode code)
{
	_ASSERTE(isShortPopStoreTemp(code));
	return static_cast<uint8_t>(code - OpCode::ShortPopStoreTemp);
}

inline bool isShortStoreTemp(OpCode code)
{
	return code >= OpCode::ShortStoreTemp && code < OpCode::ShortStoreTemp + NumShortStoreTemps;
}

inline uint8_t indexOfShortStoreTemp(OpCode code)
{
	_ASSERTE(isShortStoreTemp(code));
	return static_cast<uint8_t>(code - OpCode::ShortStoreTemp);
}

inline bool isShortSendWithNoArgs(OpCode code)
{
	return code >= OpCode::ShortSendWithNoArgs && code < OpCode::ShortSendWithNoArgs + NumShortSendsWithNoArgs;
}

inline uint8_t indexOfShortSendNoArgs(OpCode code)
{
	_ASSERTE(isShortSendWithNoArgs(code));
	return static_cast<uint8_t>(code - OpCode::ShortSendWithNoArgs);
}

inline bool isShortJump(OpCode code)
{
	return code >= OpCode::ShortJump && code < OpCode::ShortJump + NumShortJumps;
}

inline int8_t offsetOfShortJump(OpCode code)
{
	_ASSERTE(isShortJump(code));
	return static_cast<uint8_t>(code - OpCode::ShortJump);
}

inline bool isShortJumpIfFalse(OpCode code)
{
	return code >= OpCode::ShortJumpIfFalse && code < OpCode::ShortJumpIfFalse + NumShortJumpsIfFalse;
}

inline int8_t offsetOfShortJumpIfFalse(OpCode code)
{
	_ASSERTE(isShortJumpIfFalse(code));
	return static_cast<uint8_t>(code - OpCode::ShortJumpIfFalse);
}

inline bool isPseudoReturn(OpCode code)
{
	return code >= OpCode::ReturnSelf && code <= OpCode::ReturnNil;
}

inline uint8_t indexOfPseudoReturn(OpCode code)
{
	_ASSERTE(isPseudoReturn(code));
	return static_cast<uint8_t>(code - OpCode::ReturnSelf);
}

inline bool isReturn(OpCode code)
{
	return code >= OpCode::ReturnSelf && code <= OpCode::PopReturnSelf;
}

inline bool isShortSend(OpCode code)
{
	return (code >= OpCode::ShortSpecialSend && static_cast<uint8_t>(code) <= LastShortSend) 
		|| (code >= OpCode::ShortSpecialSendEx && code < OpCode::ShortSpecialSendEx + NumExSpecialSends);
}
