/*
==========
Compiler.h
==========
Smalltalk compiler
*/

#pragma once

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

	bool isInstruction(OpCode b) const
	{
		return IsOpCode && Opcode == b; 
	};
	
	__declspec(property(get = get_IsData)) bool IsData;
	bool get_IsData() const;

	void makeData();

	// A byte code is either instruction or data, not both
	__declspec(property(get = get_IsOpCode)) bool IsOpCode;
	bool get_IsOpCode()	const	{ return !IsData; }

	void makeOpCode(OpCode b, LexicalScope* pScope)	
	{ 
		_ASSERTE(pScope != nullptr);
		Opcode = b;
		makeNonData();
		this->pScope = pScope;
	}

	void makeNop(LexicalScope* pScope)
	{
		makeOpCode(OpCode::Nop, pScope);
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
		return lengthOfByteCode(static_cast<OpCode>(byte)); 
	}

	BYTECODE(uint8_t b=0, Flags f=Flags::IsOpCode, LexicalScope* s=nullptr) : pVarRef(nullptr), jumpsTo(0), byte(b), flags(f), pScope(s) {}

	__declspec(property(get = get_Opcode, put = set_Opcode)) OpCode Opcode;
	INLINE OpCode get_Opcode() const
	{
		_ASSERTE(IsOpCode);
		return static_cast<OpCode>(byte);
	}
	INLINE void set_Opcode(OpCode opcode)
	{
		byte = static_cast<uint8_t>(opcode);
	}

	__declspec(property(get = get_IsBreak)) bool IsBreak;
	INLINE bool get_IsBreak() const
	{
		return Opcode == OpCode::Break;
	}

	__declspec(property(get = get_IsShortPushConst)) bool IsShortPushConst;
	INLINE bool get_IsShortPushConst() const
	{
		return ::isShortPushConst(Opcode);
	}

	__declspec(property(get = get_IsShortPushStatic)) bool IsShortPushStatic;
	INLINE bool get_IsShortPushStatic() const
	{
		return ::isShortPushStatic(Opcode);
	}

	__declspec(property(get = get_IsShortPushTemp)) bool IsShortPushTemp;
	INLINE bool get_IsShortPushTemp() const
	{
		return ::isShortPushTemp(Opcode);
	}

	__declspec(property(get = get_IsPushTemp)) bool IsPushTemp;
	INLINE bool get_IsPushTemp() const
	{
		return Opcode == OpCode::PushTemp || IsShortPushTemp;
	}

	__declspec(property(get = get_IsShortPopStoreInstVar)) bool IsShortPopStoreInstVar;
	INLINE bool get_IsShortPopStoreInstVar() const
	{
		return Opcode >= OpCode::ShortPopStoreInstVar && Opcode < OpCode::ShortPopStoreInstVar + NumShortPopStoreInstVars;
	}

	__declspec(property(get = get_IsShortPopStoreContextTemp)) bool IsShortPopStoreContextTemp;
	INLINE bool get_IsShortPopStoreContextTemp() const
	{
		return Opcode >= OpCode::PopStoreContextTemp && Opcode < OpCode::PopStoreContextTemp + NumPopStoreContextTemps;
	}

	__declspec(property(get = get_IsShortPopStoreOuterTemp)) bool IsShortPopStoreOuterTemp;
	INLINE bool get_IsShortPopStoreOuterTemp() const
	{
		return Opcode >= OpCode::ShortPopStoreOuterTemp && Opcode < OpCode::ShortPopStoreOuterTemp + NumPopStoreOuterTemps;
	}


	__declspec(property(get = get_IsShortPopStore)) bool IsShortPopStore;
	INLINE bool get_IsShortPopStore() const
	{
		return IsShortPopStoreContextTemp || IsShortPopStoreOuterTemp || IsShortPopStoreInstVar || IsShortPopStoreTemp;
	}

	INLINE uint8_t indexOfShortPushConst() const
	{
		return ::indexOfShortPushConst(Opcode);
	}

	INLINE uint8_t indexOfShortPushStatic() const
	{
		return ::indexOfShortPushStatic(Opcode);
	}


	INLINE uint8_t indexOfShortPushTemp() const
	{
		return ::indexOfShortPushTemp(Opcode);
	}

	__declspec(property(get = get_IsPseudoReturn)) bool IsPseudoReturn;
	INLINE bool get_IsPseudoReturn() const
	{
		return ::isPseudoReturn(Opcode);
	}

	__declspec(property(get = get_IsPseudoPush)) bool IsPseudoPush;
	INLINE bool get_IsPseudoPush() const
	{
		return byte >= FirstPseudoPush && byte <= LastPseudoPush;
	}

	__declspec(property(get = get_IsShortPushInstVar)) bool IsShortPushInstVar;
	INLINE bool get_IsShortPushInstVar() const
	{
		return ::isShortPushInstVar(Opcode);
	}

	__declspec(property(get = get_IsShortPopStoreTemp)) bool IsShortPopStoreTemp;
	INLINE bool get_IsShortPopStoreTemp() const
	{
		return ::isShortPopStoreTemp(Opcode);
	}

	INLINE uint8_t indexOfShortPopStoreTemp() const
	{
		return ::indexOfShortPopStoreTemp(Opcode);
	}

	__declspec(property(get = get_IsShortStoreTemp)) bool IsShortStoreTemp;
	INLINE bool get_IsShortStoreTemp() const
	{
		return ::isShortStoreTemp(Opcode);
	}

	INLINE uint8_t indexOfShortStoreTemp() const
	{
		return ::indexOfShortStoreTemp(Opcode);
	}

	__declspec(property(get = get_IsShortSendWithNoArgs)) bool IsShortSendWithNoArgs;
	INLINE bool get_IsShortSendWithNoArgs() const
	{
		return Opcode >= OpCode::ShortSendWithNoArgs && Opcode < OpCode::ShortSendWithNoArgs + NumShortSendsWithNoArgs;
	}

	INLINE uint8_t indexOfShortSendNoArgs() const
	{
		_ASSERTE(IsShortSendWithNoArgs);
		return static_cast<uint8_t>(Opcode - OpCode::ShortSendWithNoArgs);
	}

	__declspec(property(get = get_IsShortPushImmediate)) bool IsShortPushImmediate;
	INLINE bool get_IsShortPushImmediate() const
	{
		return Opcode >= OpCode::ShortPushMinusOne && Opcode <= OpCode::ShortPushTwo;
	}

	INLINE uint8_t indexOfPushInstVar() const
	{
		return ::indexOfShortPushInstVar(Opcode);
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
		return (Opcode >= OpCode::PushInstVar && byte < FirstExtendedStore) ||
			Opcode == OpCode::PushOuterTemp ||
			Opcode == OpCode::PushImmediate ||
			Opcode == OpCode::PushChar;
	}

	__declspec(property(get = get_IsDoubleExtendedPush)) bool IsDoubleExtendedPush;
	INLINE bool get_IsDoubleExtendedPush() const
	{
		return Opcode == OpCode::LongPushOuterTemp ||
			Opcode == OpCode::LongPushConst ||
			Opcode == OpCode::LongPushStatic ||
			Opcode == OpCode::LongPushImmediate;
	}

	__declspec(property(get = get_IsPush)) bool IsPush;
	INLINE bool get_IsPush() const
	{
		return IsShortPush || IsExtendedPush ||	IsDoubleExtendedPush || Opcode == OpCode::ExLongPushImmediate;
	}

	__declspec(property(get = get_IsExtendedStore)) bool IsExtendedStore;
	INLINE bool get_IsExtendedStore() const
	{
		return (byte >= FirstExtendedStore && byte <= LastExtendedStore) || (Opcode == OpCode::StoreOuterTemp);
	}

	__declspec(property(get = get_IsExtendedPopStore)) bool IsExtendedPopStore;
	INLINE bool get_IsExtendedPopStore() const
	{
		return (byte >= FirstPopStore && byte <= LastPopStore) || (Opcode == OpCode::PopStoreOuterTemp);
	}

	__declspec(property(get = get_IsStoreTemp)) bool IsStoreTemp;
	INLINE bool get_IsStoreTemp() const
	{
		return Opcode == OpCode::StoreTemp || Opcode == OpCode::StoreOuterTemp || IsShortStoreTemp;
	}

	__declspec(property(get = get_IsStoreStackTemp)) bool IsStoreStackTemp;
	INLINE bool get_IsStoreStackTemp() const
	{
		return Opcode == OpCode::StoreTemp || IsShortStoreTemp;
	}

	__declspec(property(get = get_IsShortJump)) bool IsShortJump;
	INLINE bool get_IsShortJump() const
	{
		return Opcode >= OpCode::ShortJump && byte <= LastShortJump;
	}

	__declspec(property(get = get_IsLongJump)) bool IsLongJump;
	INLINE bool get_IsLongJump() const
	{
		return Opcode == OpCode::LongJump;
	}

	__declspec(property(get = get_IsNearJump)) bool IsNearJump;
	INLINE bool get_IsNearJump() const
	{
		return Opcode == OpCode::NearJump;
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
		return Opcode >= OpCode::ShortJumpIfFalse && Opcode < OpCode::ShortJumpIfFalse + NumShortJumpsIfFalse;
	}

	__declspec(property(get = get_IsJumpIfFalse)) bool IsJumpIfFalse;
	INLINE bool get_IsJumpIfFalse() const
	{
		return IsShortJumpIfFalse ||
			Opcode == OpCode::NearJumpIfFalse ||
			Opcode == OpCode::LongJumpIfFalse;
	}

	__declspec(property(get = get_IsJumpIfTrue)) bool IsJumpIfTrue;
	INLINE bool get_IsJumpIfTrue() const
	{
		return Opcode == OpCode::NearJumpIfTrue || Opcode == OpCode::LongJumpIfTrue;
	}

	__declspec(property(get = get_IsJumpIfNil)) bool IsJumpIfNil;
	INLINE bool get_IsJumpIfNil() const
	{
		return Opcode == OpCode::NearJumpIfNil || Opcode == OpCode::LongJumpIfNil;
	}

	__declspec(property(get = get_IsJumpIfNotNil)) bool IsJumpIfNotNil;
	INLINE bool get_IsJumpIfNotNil() const
	{
		return Opcode == OpCode::NearJumpIfNotNil || Opcode == OpCode::LongJumpIfNotNil;
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
		return IsUnconditionalJump || 
			IsJumpIfFalse ||
			IsJumpIfTrue ||
			IsJumpIfNil ||
			IsJumpIfNotNil ||
			Opcode == OpCode::BlockCopy;
	}

	__declspec(property(get = get_IsLongConditionalJump)) bool IsLongConditionalJump;
	INLINE bool get_IsLongConditionalJump() const
	{
		return Opcode == OpCode::LongJumpIfTrue ||
			Opcode == OpCode::LongJumpIfFalse ||
			Opcode == OpCode::LongJumpIfNil ||
			Opcode == OpCode::LongJumpIfNotNil;
	}

	__declspec(property(get = get_IsReturn)) bool IsReturn;
	INLINE bool get_IsReturn() const
	{
		return ::isReturn(Opcode);
	}

	__declspec(property(get = get_IsReturnStackTop)) bool IsReturnStackTop;
	INLINE bool get_IsReturnStackTop() const
	{
		return Opcode == OpCode::ReturnMessageStackTop || Opcode == OpCode::ReturnBlockStackTop;
	}

	__declspec(property(get = get_IsMethodReturn)) bool IsMethodReturn;
	INLINE bool get_IsMethodReturn() const
	{
		return Opcode != OpCode::ReturnBlockStackTop && IsReturn;
	}

	__declspec(property(get = get_IsShortSend)) bool IsShortSend;
	INLINE bool get_IsShortSend() const
	{
		return ::isShortSend(Opcode);
	}

	__declspec(property(get = get_IsSend)) bool IsSend;
	INLINE bool get_IsSend() const
	{
		return IsShortSend 
			|| Opcode == OpCode::Send || Opcode == OpCode::Supersend || Opcode == OpCode::SpecialSend
			|| Opcode == OpCode::SendTempWithNoArgs || Opcode == OpCode::SendSelfWithNoArgs || Opcode == OpCode::PopSendSelfNoArgs
			|| Opcode == OpCode::LongSend || Opcode == OpCode::LongSupersend
			|| Opcode == OpCode::ExLongSend || Opcode == OpCode::ExLongSupersend;
	}

	__declspec(property(get = get_IsStore)) bool IsStore;
	INLINE bool get_IsStore() const
	{
		return IsShortStoreTemp || IsShortPopStore || IsExtendedStore || IsExtendedPopStore
				|| Opcode == OpCode::LongStoreStatic || Opcode == OpCode::LongStoreOuterTemp;
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

INLINE bool isPushInstVarX(OpCode b1, uint8_t /*b2*/)
{
	return b1 == OpCode::PushInstVar;
}

