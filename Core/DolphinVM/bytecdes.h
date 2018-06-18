/*
==========
bytecdes.h
==========
Dolphin Instruction Set
*/
#pragma once

///////////////////////
// Instruction Set

enum { NumShortPushInstVars = 16 };
enum { NumShortPushTemps = 8 };
enum { NumPushContextTemps = 2 };
enum { NumPushOuterTemps = 2 };
enum { NumShortPushConsts = 16 };
enum { NumShortPushStatics = 12 };
enum { NumShortPushSelfAndTemps = 4 };
enum { NumShortStoreTemps = 4 };
enum { NumPopStoreContextTemps = 2};
enum { NumPopStoreOuterTemps = 2};
enum { NumShortPopStoreInstVars = 8 };
enum { NumShortPopStoreTemps = 8 };
enum { NumShortJumps = 8 };
enum { NumShortJumpsIfFalse = 8 };
enum { NumArithmeticSelectors = 16 };
enum { NumCommonSelectors = 16 };
enum { NumSpecialSelectors = NumArithmeticSelectors+NumCommonSelectors };
enum { NumShortSendsWithNoArgs = 13 };
enum { NumShortSendSelfWithNoArgs = 5 };
enum { NumShortSendsWith1Arg = 14 };
enum { NumShortSendsWith2Args = 8 };

// N.B. These sizes are offsets from the instruction FOLLOWING the jump (the IP is assumed to
// have advanced to the next instruction by the time the offset is added to IP)
enum { MaxBackwardsLongJump = -32768, MaxForwardsLongJump = 32767 };
enum { MaxBackwardsNearJump = -128, MaxForwardsNearJump = 127 };

enum { 
	FirstSingleByteInstruction = 0, 
	FirstDoubleByteInstruction = 204, 
	FirstTripleByteInstruction = 234,
	FirstMultiByteInstruction = 252 };

enum {	Break = FirstSingleByteInstruction,
		FirstShortPush };

enum {	ShortPushInstVar = FirstShortPush };
enum {	ShortPushTemp = ShortPushInstVar + NumShortPushInstVars };
enum {	ShortPushContextTemp = ShortPushTemp + NumShortPushTemps };
enum {	ShortPushOuterTemp = ShortPushContextTemp + NumPushContextTemps };
enum {	ShortPushConst = ShortPushOuterTemp + NumPushOuterTemps };
enum {	ShortPushStatic = ShortPushConst + NumShortPushConsts };
enum {
	LastShortPush = ShortPushStatic + NumShortPushStatics - 1,
	FirstPseudoPush
	};

enum { ShortPushSelf = FirstPseudoPush, ShortPushTrue, ShortPushFalse, ShortPushNil };		// Push pseudo variable

enum { 
	LastPseudoPush = ShortPushNil,
	ShortPushMinusOne, ShortPushZero, ShortPushOne, ShortPushTwo,			// Short push immediates
	ShortPushSelfAndTemp };

enum {
	LastPush =  ShortPushSelfAndTemp + NumShortPushSelfAndTemps - 1,
	ShortStoreTemp };

enum { ShortPopPushTemp = ShortStoreTemp + NumShortStoreTemps };
enum { NumShortPopPushTemps = 2 };

enum {PopPushSelf = ShortPopPushTemp + NumShortPopPushTemps,
	PopDup,
	PopStoreContextTemp 
};

enum { ShortPopStoreOuterTemp = PopStoreContextTemp + NumPopStoreContextTemps };
enum { ShortPopStoreInstVar = ShortPopStoreOuterTemp + NumPopStoreOuterTemps };
enum { ShortPopStoreTemp = ShortPopStoreInstVar + NumShortPopStoreInstVars };

enum { 
	PopStackTop = ShortPopStoreTemp + NumShortPopStoreTemps,
	IncrementStackTop,			// push 1; send #+
	DecrementStackTop,			// push 1; send #-
	DuplicateStackTop,
	FirstReturn };
	
enum { FirstPseudoReturn = FirstReturn };
enum {
	ReturnSelf = FirstPseudoReturn, ReturnTrue, ReturnFalse, ReturnNil };
enum {
	LastPseudoReturn = ReturnNil,
	ReturnMessageStackTop, 
	ReturnBlockStackTop,
	FarReturn,
	PopReturnSelf,
	};
enum {
	LastReturn = PopReturnSelf,
	Nop,
	ShortJump };
enum { 
	LastShortJump = ShortJump + NumShortJumps - 1, 
	ShortJumpIfFalse };
enum { FirstShortSend = ShortJumpIfFalse + NumShortJumpsIfFalse };
enum { ShortSpecialSend = FirstShortSend };
enum { 
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
	SendArithmeticBitOr };
enum { FirstSpecialSend = SendArithmeticBitOr + 1 };
enum {
	SpecialSendIdentical = FirstSpecialSend,
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
	SpecialSendNotNil
	 };
enum { ShortSendWithNoArgs = ShortSpecialSend + NumSpecialSelectors };
enum { ShortSendSelfWithNoArgs = ShortSendWithNoArgs + NumShortSendsWithNoArgs };
enum { ShortSendWith1Arg =  ShortSendSelfWithNoArgs + NumShortSendSelfWithNoArgs };
enum { ShortSendWith2Args =  ShortSendWith1Arg + NumShortSendsWith1Arg };

enum { LastShortSend = ShortSendWith2Args + NumShortSendsWith2Args - 1};
enum {
	IsZero = LastShortSend+1,
	PushActiveFrame,
	SpecialSendNotIdentical,
	SpecialSendNot,
	UnusedShortSend202,
	UnusedShortSend203
};
enum { FirstExSpecialSend = SpecialSendNotIdentical, LastExSpecialSend = UnusedShortSend203 };
enum { NumExSpecialSends = LastExSpecialSend - FirstExSpecialSend + 1 };


// Some unused space before double byte instructions...

enum {
	PushInstVar = FirstDoubleByteInstruction, 
	PushTemp,
	PushConst,
	PushStatic,
	FirstExtendedStore
	};

enum {
	StoreInstVar = FirstExtendedStore,
	StoreTemp,
	StoreStatic,
	};

enum {
	LastExtendedStore = StoreStatic,
	FirstPopStore 
	};

enum {
	PopStoreInstVar = FirstPopStore,
	PopStoreTemp,
	PopStoreStatic
	};

enum {
	LastPopStore = PopStoreStatic,
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
	PushTempPair};

enum {
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
	};


enum { 
	BlockCopy = FirstMultiByteInstruction,
	ExLongSend,
	ExLongSupersend,
	ExLongPushImmediate
};


// Offsets for Push and ReturnFromMessage
// These are deliberately reordered from Blue Book to provide most opportunity for packing
// 4 byte code methods into a SmallInteger (which can be done if the first byte is odd).
// Since push receiver is very often the first byte of a short method, the BBB byte code of 112
// is reassigned to 115 (push nil if very infrequently used at the start of a method)
//enum PseudoVars { Nil, True, False, Receiver, NumPseudoVars };
//enum SpecialPushes { MinusOne=NumPseudoVars, Zero, One, Two, NumSpecialPushes };

#define MAXFORBITS(n) ((1 << (n)) - 1)

// Consts for Single extended send instructions
enum { SendXArgCountBits 	= 3 };
enum { SendXMaxArgs	 		= MAXFORBITS(SendXArgCountBits) };
enum { SendXLiteralBits 	= 8 - SendXArgCountBits };
enum { SendXMaxLiteral 		= MAXFORBITS(SendXLiteralBits) };

// Consts for double extended send instructions
enum { Send2XArgCountBits	= 8 };
enum { Send2XMaxArgs		= MAXFORBITS(Send2XArgCountBits) };
enum { Send2XLiteralBits 	= 8 };
enum { Send2XMaxLiteral		= MAXFORBITS(Send2XLiteralBits) };

enum { Send3XArgCountBits	= 8 };
enum { Send3XMaxArgs		= MAXFORBITS(Send3XArgCountBits) };
enum { Send3XLiteralBits 	= 16 };
enum { Send3XMaxLiteral		= MAXFORBITS(Send3XLiteralBits) };

enum { OuterTempIndexBits	= 5 };
enum { OuterTempMaxIndex	= MAXFORBITS(OuterTempIndexBits) };
enum { OuterTempDepthBits	= 3 };
enum { OuterTempMaxDepth	= MAXFORBITS(OuterTempDepthBits) };

#pragma warning(disable:4201)
struct BlockCopyExtension
{
	BYTE	argCount;
	BYTE	stackTempsCount;
	BYTE	needsOuter:1;
	BYTE	envTempsCount:7;
	BYTE	needsSelf:1;
	BYTE	copiedValuesCount:7;
};

enum { ExLongPushImmediateInstructionSize = 5, BlockCopyInstructionSize = 7 };

inline int lengthOfByteCode(BYTE opCode)
{
	return opCode < FirstDoubleByteInstruction ? 1 : 
				opCode < FirstTripleByteInstruction ? 2 : 
					opCode <  FirstMultiByteInstruction ? 3 : 
						opCode == BlockCopy ? BlockCopyInstructionSize : 
							opCode == ExLongPushImmediate ? ExLongPushImmediateInstructionSize : 4;

}
