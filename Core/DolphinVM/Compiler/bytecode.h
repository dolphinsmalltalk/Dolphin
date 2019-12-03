/*
==========
Compiler.h
==========
Smalltalk compiler
*/

#ifndef _IST_BYTECODE_H_
#define _IST_BYTECODE_H_

#include "..\bytecdes.h"
#include "EnumHelpers.h"

class LexicalScope;
class TempVarRef;

enum class ip_t : intptr_t 
{
	npos = -1,
	zero,
	one,
	two,
	three
};

ENABLE_INT_OPERATORS(ip_t)

struct BYTECODE
{
	enum class Flags : uint8_t { IsOpCode = 0x00, IsData = 0x01, IsJump = 0x02 };

	uint8_t		byte;
	Flags		flags;
	uint16_t	jumpsTo;		// count of the number of other byte codes using this as a jump target

	union
	{
		ip_t			target;			// Jump target location. Max jump is +/-32K, but this is checked only when the jump instruction is fixed up
		TempVarRef*		pVarRef;
	};

	LexicalScope*	pScope;

	bool isInstruction(uint8_t b) const
	{
		return byte == b && IsOpCode; 
	};
	
	__declspec(property(get = get_IsData)) bool IsData;
	bool get_IsData() const;

	void makeData();

	// A byte code is either instruction or data, not both
	__declspec(property(get = get_IsOpCode)) bool IsOpCode;
	bool get_IsOpCode()	const	{ return !IsData; }

	void makeOpCode(uint8_t b, LexicalScope* pScope)	
	{ 
		_ASSERTE(pScope != nullptr);
		byte = b; 
		makeNonData();
		this->pScope = pScope;
	}

	void makeNop(LexicalScope* pScope)
	{
		makeOpCode(Nop, pScope);
	}

	__declspec(property(get = get_IsJumpSource)) bool IsJumpSource;
	bool get_IsJumpSource() const;

	void makeNonData();
	void makeNonJump();
	void makeJump();
	void makeJumpTo(ip_t pos)
	{ 
		target = pos; 
		makeJump(); 
	}

	__declspec(property(get = get_IsJumpTarget)) bool IsJumpTarget;
	__forceinline bool get_IsJumpTarget() const	
	{ 
		return jumpsTo > 0; 
	}

	void addJumpTo()		
	{ 
		_ASSERTE(IsOpCode);
		jumpsTo++;
		_ASSERTE(jumpsTo < 256); 
	}

	void removeJumpTo()		
	{ 
		_ASSERTE(IsOpCode && jumpsTo > 0); 
		jumpsTo--; 
	}
	
	__declspec(property(get = get_InstructionLength)) size_t InstructionLength;
	__forceinline size_t get_InstructionLength() const
	{ 
		_ASSERTE(IsOpCode); 
		return lengthOfByteCode(byte); 
	}

	BYTECODE(uint8_t b=0, Flags f=Flags::IsOpCode, LexicalScope* s=nullptr) : pVarRef(nullptr), jumpsTo(0), byte(b), flags(f), pScope(s) {}

	__declspec(property(get = get_IsBreak)) bool IsBreak;
	INLINE bool get_IsBreak() const
	{
		_ASSERTE(IsOpCode);
		return byte == Break;
	}

	__declspec(property(get = get_IsShortPushConst)) bool IsShortPushConst;
	INLINE bool get_IsShortPushConst() const
	{
		return byte >= ShortPushConst && byte < ShortPushConst + NumShortPushConsts;
	}

	__declspec(property(get = get_IsShortPushStatic)) bool IsShortPushStatic;
	INLINE bool get_IsShortPushStatic() const
	{
		return byte >= ShortPushStatic && byte < ShortPushStatic + NumShortPushStatics;
	}

	__declspec(property(get = get_IsShortPushTemp)) bool IsShortPushTemp;
	INLINE bool get_IsShortPushTemp() const
	{
		return byte >= ShortPushTemp && byte < ShortPushTemp + NumShortPushTemps;
	}

	__declspec(property(get = get_IsPushTemp)) bool IsPushTemp;
	INLINE bool get_IsPushTemp() const
	{
		return byte == PushTemp || IsShortPushTemp;
	}

	__declspec(property(get = get_IsShortPopStoreInstVar)) bool IsShortPopStoreInstVar;
	INLINE bool get_IsShortPopStoreInstVar() const
	{
		return byte >= ShortPopStoreInstVar && byte < ShortPopStoreInstVar + NumShortPopStoreInstVars;
	}

	__declspec(property(get = get_IsShortPopStoreContextTemp)) bool IsShortPopStoreContextTemp;
	INLINE bool get_IsShortPopStoreContextTemp() const
	{
		return byte >= PopStoreContextTemp && byte < PopStoreContextTemp + NumPopStoreContextTemps;
	}

	__declspec(property(get = get_IsShortPopStoreOuterTemp)) bool IsShortPopStoreOuterTemp;
	INLINE bool get_IsShortPopStoreOuterTemp() const
	{
		return byte >= ShortPopStoreOuterTemp && byte < ShortPopStoreOuterTemp + NumPopStoreOuterTemps;
	}


	__declspec(property(get = get_IsShortPopStore)) bool IsShortPopStore;
	INLINE bool get_IsShortPopStore() const
	{
		return IsShortPopStoreContextTemp || IsShortPopStoreOuterTemp || IsShortPopStoreInstVar || IsShortPopStoreTemp;
	}

	INLINE uint8_t indexOfShortPushConst() const
	{
		_ASSERTE(IsShortPushConst);
		return byte - ShortPushConst;
	}

	INLINE uint8_t indexOfShortPushStatic() const
	{
		_ASSERTE(IsShortPushStatic);
		return byte - ShortPushStatic;
	}


	INLINE uint8_t indexOfShortPushTemp() const
	{
		_ASSERTE(IsShortPushTemp);
		return byte - ShortPushTemp;
	}

	__declspec(property(get = get_IsPseudoReturn)) bool IsPseudoReturn;
	INLINE bool get_IsPseudoReturn() const
	{
		return byte >= FirstPseudoReturn && byte <= LastPseudoReturn;
	}

	__declspec(property(get = get_IsPseudoPush)) bool IsPseudoPush;
	INLINE bool get_IsPseudoPush() const
	{
		return byte >= FirstPseudoPush && byte <= LastPseudoPush;
	}

	__declspec(property(get = get_IsShortPushInstVar)) bool IsShortPushInstVar;
	INLINE bool get_IsShortPushInstVar() const
	{
		return byte >= ShortPushInstVar && byte < ShortPushInstVar + NumShortPushInstVars;
	}

	__declspec(property(get = get_IsShortPopStoreTemp)) bool IsShortPopStoreTemp;
	INLINE bool get_IsShortPopStoreTemp() const
	{
		return byte >= ShortPopStoreTemp && byte < ShortPopStoreTemp + NumShortPopStoreTemps;
	}

	INLINE uint8_t indexOfShortPopStoreTemp() const
	{
		_ASSERTE(IsShortPopStoreTemp);
		return byte - ShortPopStoreTemp;
	}

	__declspec(property(get = get_IsShortStoreTemp)) bool IsShortStoreTemp;
	INLINE bool get_IsShortStoreTemp() const
	{
		return byte >= ShortStoreTemp && byte < ShortStoreTemp + NumShortStoreTemps;
	}

	INLINE uint8_t indexOfShortStoreTemp() const
	{
		_ASSERTE(IsShortStoreTemp);
		return byte - ShortStoreTemp;
	}

	__declspec(property(get = get_IsShortSendWithNoArgs)) bool IsShortSendWithNoArgs;
	INLINE bool get_IsShortSendWithNoArgs() const
	{
		return byte >= ShortSendWithNoArgs && byte < ShortSendWithNoArgs + NumShortSendsWithNoArgs;
	}

	INLINE uint8_t indexOfShortSendNoArgs() const
	{
		_ASSERTE(IsShortSendWithNoArgs);
		return byte - ShortSendWithNoArgs;
	}

	__declspec(property(get = get_IsShortPushImmediate)) bool IsShortPushImmediate;
	INLINE bool get_IsShortPushImmediate() const
	{
		return byte >= ShortPushMinusOne && byte <= ShortPushTwo;
	}

	INLINE uint8_t indexOfPushInstVar() const
	{
		_ASSERTE(IsShortPushInstVar);
		return byte - ShortPushInstVar;
	}

	__declspec(property(get = get_IsShortPush)) bool IsShortPush;
	INLINE bool get_IsShortPush() const
	{
		return byte >= FirstShortPush && 
			byte <= LastPush;	// Note that this includes pseudo pushes and push 0, 1, etc
	}

	__declspec(property(get = get_IsExtendedPush)) bool IsExtendedPush;
	INLINE bool get_IsExtendedPush() const
	{
		return (byte >= PushInstVar && byte < FirstExtendedStore) ||
			byte == PushOuterTemp ||
			byte == PushImmediate ||
			byte == PushChar;
	}

	__declspec(property(get = get_IsDoubleExtendedPush)) bool IsDoubleExtendedPush;
	INLINE bool get_IsDoubleExtendedPush() const
	{
		return byte == LongPushOuterTemp ||
			byte == LongPushConst ||
			byte == LongPushStatic ||
			byte == LongPushImmediate;
	}

	__declspec(property(get = get_IsPush)) bool IsPush;
	INLINE bool get_IsPush() const
	{
		return IsShortPush || IsExtendedPush ||	IsDoubleExtendedPush || byte == ExLongPushImmediate;
	}

	__declspec(property(get = get_IsExtendedStore)) bool IsExtendedStore;
	INLINE bool get_IsExtendedStore() const
	{
		return (byte >= FirstExtendedStore && byte <= LastExtendedStore) || (byte == StoreOuterTemp);
	}

	__declspec(property(get = get_IsExtendedPopStore)) bool IsExtendedPopStore;
	INLINE bool get_IsExtendedPopStore() const
	{
		return (byte >= FirstPopStore && byte <= LastPopStore) || (byte == PopStoreOuterTemp);
	}

	__declspec(property(get = get_IsStoreTemp)) bool IsStoreTemp;
	INLINE bool get_IsStoreTemp() const
	{
		return byte == StoreTemp || byte == StoreOuterTemp || IsShortStoreTemp;
	}

	__declspec(property(get = get_IsStoreStackTemp)) bool IsStoreStackTemp;
	INLINE bool get_IsStoreStackTemp() const
	{
		return byte == StoreTemp || IsShortStoreTemp;
	}

	__declspec(property(get = get_IsShortJump)) bool IsShortJump;
	INLINE bool get_IsShortJump() const
	{
		_ASSERTE(IsOpCode);
		return byte >= ShortJump && byte <= LastShortJump;
	}

	__declspec(property(get = get_IsLongJump)) bool IsLongJump;
	INLINE bool get_IsLongJump() const
	{
		_ASSERTE(IsOpCode);
		return byte == LongJump;
	}

	__declspec(property(get = get_IsNearJump)) bool IsNearJump;
	INLINE bool get_IsNearJump() const
	{
		_ASSERTE(IsOpCode);
		return byte == NearJump;
	}

	__declspec(property(get = get_IsUnconditionalJump)) bool IsUnconditionalJump;
	INLINE bool get_IsUnconditionalJump() const
	{
		// Faster to test for long jump first, as this is mainly used by the optimizer
		// which always works on long jumps
		return IsLongJump || IsNearJump || IsShortJump;
	}

	__declspec(property(get = get_IsShortJumpIfFalse)) bool IsShortJumpIfFalse;
	INLINE bool get_IsShortJumpIfFalse() const
	{
		_ASSERTE(IsOpCode);
		return byte >= ShortJumpIfFalse && byte < ShortJumpIfFalse+NumShortJumpsIfFalse;
	}

	__declspec(property(get = get_IsJumpIfFalse)) bool IsJumpIfFalse;
	INLINE bool get_IsJumpIfFalse() const
	{
		return IsShortJumpIfFalse ||
			byte == NearJumpIfFalse ||
			byte == LongJumpIfFalse;
	}

	__declspec(property(get = get_IsJumpIfTrue)) bool IsJumpIfTrue;
	INLINE bool get_IsJumpIfTrue() const
	{
		_ASSERTE(IsOpCode);
		return byte == NearJumpIfTrue || byte == LongJumpIfTrue;
	}

	__declspec(property(get = get_IsJumpIfNil)) bool IsJumpIfNil;
	INLINE bool get_IsJumpIfNil() const
	{
		_ASSERTE(IsOpCode);
		return byte == NearJumpIfNil || byte == LongJumpIfNil;
	}

	__declspec(property(get = get_IsJumpIfNotNil)) bool IsJumpIfNotNil;
	INLINE bool get_IsJumpIfNotNil() const
	{
		_ASSERTE(IsOpCode);
		return byte == NearJumpIfNotNil || byte == LongJumpIfNotNil;
	}

	__declspec(property(get = get_IsConditionalJump)) bool IsConditionalJump;
	INLINE bool get_IsConditionalJump() const
	{
		return 
			IsJumpIfFalse ||
			IsJumpIfTrue ||
			IsJumpIfNil ||
			IsJumpIfNotNil;	
	}

	__declspec(property(get = get_IsJumpInstruction)) bool IsJumpInstruction;
	INLINE bool get_IsJumpInstruction() const
	{
		_ASSERTE(IsOpCode);
		return IsUnconditionalJump || 
			IsJumpIfFalse ||
			IsJumpIfTrue ||
			IsJumpIfNil ||
			IsJumpIfNotNil ||
			byte == BlockCopy;
	}

	__declspec(property(get = get_IsLongConditionalJump)) bool IsLongConditionalJump;
	INLINE bool get_IsLongConditionalJump() const
	{
		_ASSERTE(IsOpCode);
		return byte == LongJumpIfTrue || 
			byte == LongJumpIfFalse ||
			byte == LongJumpIfNil ||
			byte == LongJumpIfNotNil;
	}

	__declspec(property(get = get_IsReturn)) bool IsReturn;
	INLINE bool get_IsReturn() const
	{
		_ASSERTE(IsOpCode);
		return byte >= FirstReturn && byte <= LastReturn;
	}

	__declspec(property(get = get_IsReturnStackTop)) bool IsReturnStackTop;
	INLINE bool get_IsReturnStackTop() const
	{
		_ASSERTE(IsOpCode);
		return byte == ReturnMessageStackTop || byte == ReturnBlockStackTop;
	}

	__declspec(property(get = get_IsMethodReturn)) bool IsMethodReturn;
	INLINE bool get_IsMethodReturn() const
	{
		_ASSERTE(IsOpCode);
		return byte != ReturnBlockStackTop && IsReturn;
	}

	__declspec(property(get = get_IsShortSend)) bool IsShortSend;
	INLINE bool get_IsShortSend() const
	{
		return (byte >= FirstShortSend && byte <= LastShortSend) || (byte >= FirstExSpecialSend && byte <= LastExSpecialSend);
	}

	__declspec(property(get = get_IsSend)) bool IsSend;
	INLINE bool get_IsSend() const
	{
		_ASSERTE(IsOpCode);
		return IsShortSend 
			|| byte == Send || byte == Supersend || byte == SpecialSend
			|| byte == SendTempWithNoArgs || byte == SendSelfWithNoArgs || byte == PopSendSelfNoArgs
			|| byte == LongSend || byte == LongSupersend
			|| byte == ExLongSend || byte == ExLongSupersend;
	}

	__declspec(property(get = get_IsStore)) bool IsStore;
	INLINE bool get_IsStore() const
	{
		return IsShortStoreTemp || IsShortPopStore || IsExtendedStore || IsExtendedPopStore
				|| byte == LongStoreStatic || byte == LongStoreOuterTemp;
	}
};

ENABLE_BITMASK_OPERATORS(BYTECODE::Flags)

inline bool BYTECODE::get_IsData() const 
{ 
	return !!(flags & Flags::IsData); 
}

inline void BYTECODE::makeData()
{
	flags = flags | Flags::IsData;
	pScope = nullptr;
}

inline bool BYTECODE::get_IsJumpSource() const
{
	return !!(flags & Flags::IsJump);
}

inline void BYTECODE::makeNonData() { flags = flags & ~Flags::IsData; }
inline void BYTECODE::makeNonJump() { flags = flags & ~Flags::IsJump; }
inline void BYTECODE::makeJump() { flags = flags | Flags::IsJump; }

class BYTECODES : public std::vector<BYTECODE>
{
public:
	BYTECODE& operator[](const ip_t ip)
	{
		size_t pos = static_cast<size_t>(ip);
		_ASSERTE(pos < size());
		return at(pos);
	}

	const BYTECODE& operator[](const ip_t ip) const
	{
		size_t pos = static_cast<size_t>(ip);
		_ASSERTE(pos < size());
		return at(pos);
	}
};

INLINE static bool isPushInstVarX(uint8_t b1, uint8_t /*b2*/)
{
	return b1 == PushInstVar;
}

#endif

