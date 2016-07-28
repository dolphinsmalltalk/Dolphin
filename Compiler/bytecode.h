/*
==========
Compiler.h
==========
Smalltalk compiler
*/

#ifndef _IST_BYTECODE_H_
#define _IST_BYTECODE_H_

#include "..\bytecdes.h"
class LexicalScope;

struct BYTECODE
{
	enum BYTEFLAGS { IsOpCode=0x00, IsData=0x01, IsJump=0x02 };

	BYTE	byte;
	BYTE	flags;			// BYTEFLAGS
	WORD	jumpsTo;		// count of the number of other byte codes using this as a jump target

	union
	{
		int				target;			// Jump target location. Max jump is +/-32K, but this is checked only when the jump instruction is fixed up
		TempVarRef*		pVarRef;
	};

	LexicalScope*	pScope;

	bool isInstruction(BYTE b) const
							{ return byte == b && isOpCode(); };
	bool isData() const		{ return flags & IsData; }
	void makeData()			
	{ 
		flags |= IsData;
		pScope = NULL;
	}

	// A byte code is either instruction or data, not both
	bool isOpCode()	const	{ return !isData(); }
	void makeOpCode(BYTE b, LexicalScope* pScope)	
	{ 
		_ASSERTE(pScope != NULL);
		byte = b; 
		flags &= ~IsData;
		this->pScope = pScope;
	}

	void makeNop(LexicalScope* pScope)
	{
		makeOpCode(Nop, pScope);
	}

	bool isJumpSource() const		
	{	
		return (flags & IsJump) != 0; 
	}
	void makeNonJump()		{ flags &= ~IsJump; }
	void makeJump()			{ flags |= IsJump; }
	void makeJumpTo(int pos)
	{ 
		_ASSERTE(pos >= 0); 
		target = static_cast<WORD>(pos); 
		makeJump(); 
	}

	__forceinline bool isJumpTarget() const	
	{ 
		return jumpsTo > 0; 
	}

	void addJumpTo()		
	{ 
		_ASSERTE(isOpCode());
		jumpsTo++;
		_ASSERTE(jumpsTo < 256); 
	}

	void removeJumpTo()		
	{ 
		_ASSERTE(isOpCode() && jumpsTo > 0); 
		jumpsTo--; 
	}
	
	__forceinline int instructionLength() const 
	{ 
		_ASSERTE(isOpCode()); 
		return lengthOfByteCode(byte); 
	}

	BYTECODE(BYTE b=0, BYTE f=0, LexicalScope* s=NULL) : pVarRef(NULL), jumpsTo(0), byte(b), flags(f), pScope(s) {}

	INLINE bool isBreak() const
	{
		_ASSERTE(isOpCode());
		return byte == Break;
	}

	INLINE bool isShortPushConst() const
	{
		return byte >= ShortPushConst && byte < ShortPushConst + NumShortPushConsts;
	}

	INLINE bool isShortPushStatic() const
	{
		return byte >= ShortPushStatic && byte < ShortPushStatic + NumShortPushStatics;
	}

	INLINE bool isShortPushTemp() const
	{
		return byte >= ShortPushTemp && byte < ShortPushTemp + NumShortPushTemps;
	}

	INLINE bool isPushTemp() const
	{
		return byte == PushTemp || isShortPushTemp();
	}

	INLINE bool isShortPopStoreInstVar() const
	{
		return byte >= ShortPopStoreInstVar && byte < ShortPopStoreInstVar + NumShortPopStoreInstVars;
	}

	INLINE bool isShortPopStoreContextTemp() const
	{
		return byte >= PopStoreContextTemp && byte < PopStoreContextTemp + NumPopStoreContextTemps;
	}

	INLINE bool isShortPopStoreOuterTemp() const
	{
		return byte >= ShortPopStoreOuterTemp && byte < ShortPopStoreOuterTemp + NumPopStoreOuterTemps;
	}


	INLINE bool isShortPopStore() const
	{
		return isShortPopStoreContextTemp() || isShortPopStoreOuterTemp() || isShortPopStoreInstVar() || isShortPopStoreTemp();
	}

	INLINE BYTE indexOfShortPushConst() const
	{
		_ASSERTE(isShortPushConst());
		return byte - ShortPushConst;
	}

	INLINE BYTE indexOfShortPushStatic() const
	{
		_ASSERTE(isShortPushStatic());
		return byte - ShortPushStatic;
	}


	INLINE BYTE indexOfShortPushTemp() const
	{
		_ASSERTE(isShortPushTemp());
		return byte - ShortPushTemp;
	}

	INLINE bool isPseudoReturn() const
	{
		return byte >= FirstPseudoReturn && byte <= LastPseudoReturn;
	}

	INLINE bool isPseudoPush() const
	{
		return byte >= FirstPseudoPush && byte <= LastPseudoPush;
	}

	INLINE bool isShortPushInstVar() const
	{
		return byte >= ShortPushInstVar && byte < ShortPushInstVar + NumShortPushInstVars;
	}

	INLINE bool isShortPopStoreTemp() const
	{
		return byte >= ShortPopStoreTemp && byte < ShortPopStoreTemp + NumShortPopStoreTemps;
	}

	INLINE BYTE indexOfShortPopStoreTemp() const
	{
		_ASSERTE(isShortPopStoreTemp());
		return byte - ShortPopStoreTemp;
	}

	INLINE bool isShortStoreTemp() const
	{
		return byte >= ShortStoreTemp && byte < ShortStoreTemp + NumShortStoreTemps;
	}

	INLINE BYTE indexOfShortStoreTemp() const
	{
		_ASSERTE(isShortStoreTemp());
		return byte - ShortStoreTemp;
	}

	INLINE bool isShortSendWithNoArgs() const
	{
		return byte >= ShortSendWithNoArgs && byte < ShortSendWithNoArgs + NumShortSendsWithNoArgs;
	}

	INLINE int indexOfShortSendNoArgs() const
	{
		_ASSERTE(isShortSendWithNoArgs());
		return byte - ShortSendWithNoArgs;
	}

	INLINE bool isShortPushImmediate() const
	{
		return byte >= ShortPushMinusOne && byte <= ShortPushTwo;
	}

	INLINE BYTE indexOfPushInstVar() const
	{
		_ASSERTE(isShortPushInstVar());
		return byte - ShortPushInstVar;
	}

	INLINE bool isShortPush() const
	{
		return byte >= FirstShortPush && 
			byte <= LastPush;	// Note that this includes pseudo pushes and push 0, 1, etc
	}

	inline bool isExtendedPush() const
	{
		return (byte >= PushInstVar && byte < FirstExtendedStore) ||
			byte == PushOuterTemp ||
			byte == PushImmediate ||
			byte == PushChar;
	}

	inline bool isDoubleExtendedPush() const
	{
		return byte == LongPushOuterTemp ||
			byte == LongPushConst ||
			byte == LongPushStatic ||
			byte == LongPushImmediate;
	}

	inline bool isPush() const
	{
		return isShortPush() || isExtendedPush() ||	isDoubleExtendedPush() || byte == ExLongPushImmediate;
	}

	INLINE bool isExtendedStore() const
	{
		return (byte >= FirstExtendedStore && byte <= LastExtendedStore) || (byte == StoreOuterTemp);
	}

	INLINE bool isExtendedPopStore() const
	{
		return (byte >= FirstPopStore && byte <= LastPopStore) || (byte == PopStoreOuterTemp);
	}

	INLINE bool isStoreTemp() const
	{
		return byte == StoreTemp || byte == StoreOuterTemp || isShortStoreTemp();
	}

	INLINE bool isStoreStackTemp() const
	{
		return byte == StoreTemp || isShortStoreTemp();
	}

	inline bool isShortJump() const
	{
		_ASSERTE(isOpCode());
		return byte >= ShortJump && byte <= LastShortJump;
	}

	inline bool isLongJump() const
	{
		_ASSERTE(isOpCode());
		return byte == LongJump;
	}

	inline bool isNearJump() const
	{
		_ASSERTE(isOpCode());
		return byte == NearJump;
	}

	inline bool isUnconditionalJump() const
	{
		// Faster to test for long jump first, as this is mainly used by the optimizer
		// which always works on long jumps
		return isLongJump() || isNearJump() || isShortJump();
	}

	inline bool isShortJumpIfFalse() const
	{
		_ASSERTE(isOpCode());
		return byte >= ShortJumpIfFalse && byte < ShortJumpIfFalse+NumShortJumpsIfFalse;
	}

	inline bool isJumpIfFalse() const
	{
		return isShortJumpIfFalse() ||
			byte == NearJumpIfFalse ||
			byte == LongJumpIfFalse;
	}

	inline bool isJumpIfTrue() const
	{
		_ASSERTE(isOpCode());
		return byte == NearJumpIfTrue || byte == LongJumpIfTrue;
	}

	inline bool isJumpIfNil() const
	{
		_ASSERTE(isOpCode());
		return byte == NearJumpIfNil || byte == LongJumpIfNil;
	}

	inline bool isJumpIfNotNil() const
	{
		_ASSERTE(isOpCode());
		return byte == NearJumpIfNotNil || byte == LongJumpIfNotNil;
	}

	inline bool isConditionalJump() const
	{
		return 
			isJumpIfFalse() ||
			isJumpIfTrue() ||
			isJumpIfNil() ||
			isJumpIfNotNil();	
	}

	inline bool isJumpInstruction() const
	{
		_ASSERTE(isOpCode());
		return isUnconditionalJump() || 
			isJumpIfFalse() ||
			isJumpIfTrue() ||
			isJumpIfNil() ||
			isJumpIfNotNil() ||
			byte == BlockCopy;
	}

	inline bool isLongConditionalJump() const
	{
		_ASSERTE(isOpCode());
		return byte == LongJumpIfTrue || 
			byte == LongJumpIfFalse ||
			byte == LongJumpIfNil ||
			byte == LongJumpIfNotNil;
	}

	inline bool isReturn() const
	{
		_ASSERTE(isOpCode());
		return byte >= FirstReturn && byte <= LastReturn;
	}

	inline bool isReturnStackTop() const
	{
		_ASSERTE(isOpCode());
		return byte == ReturnMessageStackTop || byte == ReturnBlockStackTop;
	}

	inline bool isMethodReturn() const
	{
		_ASSERTE(isOpCode());
		return byte != ReturnBlockStackTop && isReturn();
	}

	inline bool isShortSend() const
	{
		return byte >= FirstShortSend && byte <= LastShortSend;
	}

	inline bool isSend() const
	{
		_ASSERTE(isOpCode());
		return isShortSend() 
			|| byte == Send || byte == Supersend || byte == SpecialSend
			|| byte == SendTempWithNoArgs || byte == SendSelfWithNoArgs || byte == PopSendSelfNoArgs
			|| byte == LongSend || byte == LongSupersend
			|| byte == ExLongSend || byte == ExLongSupersend;
	}

	inline bool isStore() const
	{
		return isShortStoreTemp() || isShortPopStore() || isExtendedStore() || isExtendedPopStore()
				|| byte == LongStoreStatic || byte == LongStoreOuterTemp;
	}
};

typedef std::vector<BYTECODE> BYTECODES;

INLINE static int indexOfPushX(BYTE /*b1*/, BYTE b2)
{
	return b2;
}

INLINE static bool isPushInstVarX(BYTE b1, BYTE /*b2*/)
{
	return b1 == PushInstVar;
}

#endif

