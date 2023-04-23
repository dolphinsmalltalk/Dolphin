/*
==========
Compiler.h
==========
Smalltalk compiler
*/

#pragma once

#include "..\bytecdes.h"
#include "..\EnumHelpers.h"

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

	union
	{
		uint8_t		byte;
		OpCode		opcode;
	};

	Flags		flags;
	uint16_t	jumpsTo;		// count of the number of other byte codes using this as a jump target

	union
	{
		ip_t			target;			// Jump target location. Max jump is +/-32K, but this can only be checked only when the jump instruction is fixed up
		TempVarRef*		pVarRef;
	};

	LexicalScope*	pScope;

	bool operator==(const BYTECODE& comperand) const
	{

	}

	bool isInstruction(OpCode b) const
	{
		return IsOpCode && opcode == b; 
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
		this->pScope = pScope;
	}

	void makeNop(LexicalScope* pScope)
	{
		_ASSERTE(!IsJumpSource);
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
		return lengthOfByteCode(Opcode); 
	}

	BYTECODE(uint8_t b=0, Flags f=Flags::IsOpCode, LexicalScope* s=nullptr) : pVarRef(nullptr), jumpsTo(0), byte(b), flags(f), pScope(s) {}

	__declspec(property(get = get_Opcode, put = set_Opcode)) OpCode Opcode;
	INLINE OpCode get_Opcode() const
	{
		_ASSERTE(IsOpCode);
		return opcode;
	}
	INLINE void set_Opcode(OpCode opcode)
	{
		this->opcode = opcode;
		makeNonData();
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
		OpCode op = Opcode;
		return op == OpCode::PushTemp || ::isShortPushTemp(op);
	}

	__declspec(property(get = get_IsShortPopStoreInstVar)) bool IsShortPopStoreInstVar;
	INLINE bool get_IsShortPopStoreInstVar() const
	{
		return ::isShortPopStoreInstVar(Opcode);
	}

	INLINE uint8_t indexOfShortPopStoreInstVar() const
	{
		return ::indexOfShortPopStoreInstVar(Opcode);
	}

	__declspec(property(get = get_IsShortPopStoreContextTemp)) bool IsShortPopStoreContextTemp;
	INLINE bool get_IsShortPopStoreContextTemp() const
	{
		return ::isShortPopStoreContextTemp(Opcode);
	}

	__declspec(property(get = get_IsShortPopStoreOuterTemp)) bool IsShortPopStoreOuterTemp;
	INLINE bool get_IsShortPopStoreOuterTemp() const
	{
		return ::isShortPopStoreOuterTemp(Opcode);
	}

	__declspec(property(get = get_IsShortPopStore)) bool IsShortPopStore;
	INLINE bool get_IsShortPopStore() const
	{
		return ::isShortPopStore(Opcode);
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
		return ::isPseudoPush(Opcode);
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
		OpCode op = Opcode;
		return op >= OpCode::ShortSendWithNoArgs && op < OpCode::ShortSendWithNoArgs + NumShortSendsWithNoArgs;
	}

	INLINE uint8_t indexOfShortSendNoArgs() const
	{
		_ASSERTE(IsShortSendWithNoArgs);
		return static_cast<uint8_t>(Opcode - OpCode::ShortSendWithNoArgs);
	}

	__declspec(property(get = get_IsShortPushImmediate)) bool IsShortPushImmediate;
	INLINE bool get_IsShortPushImmediate() const
	{
		OpCode op = Opcode;
		return op >= OpCode::ShortPushMinusOne && op <= OpCode::ShortPushTwo;
	}

	INLINE uint8_t indexOfPushInstVar() const
	{
		return ::indexOfShortPushInstVar(Opcode);
	}

	__declspec(property(get = get_IsShortPush)) bool IsShortPush;
	INLINE bool get_IsShortPush() const
	{
		return ::isShortPush(Opcode);
	}

	__declspec(property(get = get_IsExtendedPush)) bool IsExtendedPush;
	INLINE bool get_IsExtendedPush() const
	{
		return ::isExtendedPush(Opcode);
	}

	__declspec(property(get = get_IsDoubleExtendedPush)) bool IsDoubleExtendedPush;
	INLINE bool get_IsDoubleExtendedPush() const
	{
		return ::isDoubleExtendedPush(Opcode);
	}

	__declspec(property(get = get_IsPush)) bool IsPush;
	INLINE bool get_IsPush() const
	{
		OpCode op = Opcode;
		return ::isShortPush(op) || ::isExtendedPush(op) ||	::isDoubleExtendedPush(op) || op == OpCode::ExLongPushImmediate;
	}

	__declspec(property(get = get_IsExtendedStore)) bool IsExtendedStore;
	INLINE bool get_IsExtendedStore() const
	{
		return ::isExtendedStore(Opcode);
	}

	__declspec(property(get = get_IsExtendedPopStore)) bool IsExtendedPopStore;
	INLINE bool get_IsExtendedPopStore() const
	{
		return ::isExtendedPopStore(Opcode);
	}

	__declspec(property(get = get_IsStoreTemp)) bool IsStoreTemp;
	INLINE bool get_IsStoreTemp() const
	{
		OpCode op = Opcode;
		return op == OpCode::StoreTemp || op == OpCode::StoreOuterTemp || ::isShortStoreTemp(op);
	}

	__declspec(property(get = get_IsStoreStackTemp)) bool IsStoreStackTemp;
	INLINE bool get_IsStoreStackTemp() const
	{
		OpCode op = Opcode;
		return op == OpCode::StoreTemp || ::isShortStoreTemp(op);
	}

	__declspec(property(get = get_IsShortJump)) bool IsShortJump;
	INLINE bool get_IsShortJump() const
	{
		return ::isShortJump(Opcode);
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
		return ::isUnconditionalJump(Opcode);
	}

	__declspec(property(get = get_IsShortJumpIfFalse)) bool IsShortJumpIfFalse;
	INLINE bool get_IsShortJumpIfFalse() const
	{
		return ::isShortJumpIfFalse(Opcode);
	}

	__declspec(property(get = get_IsJumpIfFalse)) bool IsJumpIfFalse;
	INLINE bool get_IsJumpIfFalse() const
	{
		return ::isJumpIfFalse(Opcode);
	}

	__declspec(property(get = get_IsJumpIfTrue)) bool IsJumpIfTrue;
	INLINE bool get_IsJumpIfTrue() const
	{
		return ::isJumpIfTrue(Opcode);
	}

	__declspec(property(get = get_IsJumpIfNil)) bool IsJumpIfNil;
	INLINE bool get_IsJumpIfNil() const
	{
		return ::isJumpIfNil(Opcode);
	}

	__declspec(property(get = get_IsJumpIfNotNil)) bool IsJumpIfNotNil;
	INLINE bool get_IsJumpIfNotNil() const
	{
		return ::isJumpIfNotNil(Opcode);
	}

	__declspec(property(get = get_IsConditionalJump)) bool IsConditionalJump;
	INLINE bool get_IsConditionalJump() const
	{
		return ::isConditionalJump(Opcode);
	}

	__declspec(property(get = get_IsJumpInstruction)) bool IsJumpInstruction;
	INLINE bool get_IsJumpInstruction() const
	{
		OpCode op = Opcode;
		return ::isUnconditionalJump(op) || 
			::isConditionalJump(op) ||
			Opcode == OpCode::BlockCopy;
	}

	__declspec(property(get = get_IsLongConditionalJump)) bool IsLongConditionalJump;
	INLINE bool get_IsLongConditionalJump() const
	{
		OpCode op = Opcode;
		return op == OpCode::LongJumpIfTrue ||
			op == OpCode::LongJumpIfFalse ||
			op == OpCode::LongJumpIfNil ||
			op == OpCode::LongJumpIfNotNil;
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

	__declspec(property(get = get_IsShortSend)) bool IsShortSend;
	INLINE bool get_IsShortSend() const
	{
		return ::isShortSend(Opcode);
	}

	__declspec(property(get = get_IsSend)) bool IsSend;
	INLINE bool get_IsSend() const
	{
		OpCode op = Opcode;
		return ::isShortSend(op)
			|| op == OpCode::Send || op == OpCode::Supersend // || op == OpCode::SpecialSend
			|| op == OpCode::SendTempWithNoArgs || op == OpCode::SendSelfWithNoArgs // || op == OpCode::PopSendSelfNoArgs
			|| op == OpCode::LongSend || op == OpCode::LongSupersend
			|| op == OpCode::ExLongSend || op == OpCode::ExLongSupersend;
	}

	__declspec(property(get = get_IsStore)) bool IsStore;
	INLINE bool get_IsStore() const
	{
		OpCode op = Opcode;
		return  ::isShortStoreTemp(op) || ::isShortPopStore(op) || ::isExtendedStore(op) || ::isExtendedPopStore(op)
				|| op == OpCode::LongStoreStatic || op == OpCode::LongStoreOuterTemp;
	}

};

ENABLE_BITMASK_OPERATORS(BYTECODE::Flags)

inline bool BYTECODE::get_IsData() const 
{ 
	return (flags & Flags::IsData) == Flags::IsData;
}

inline void BYTECODE::makeData()
{
	flags = flags | Flags::IsData;
	pScope = nullptr;
}

inline bool BYTECODE::get_IsJumpSource() const
{
	return (flags & Flags::IsJump) == Flags::IsJump;
}

inline void BYTECODE::makeNonData() { flags = flags & ~Flags::IsData; }
inline void BYTECODE::makeNonJump() { flags = flags & ~Flags::IsJump; }
inline void BYTECODE::makeJump() { flags = flags | Flags::IsJump; }

class BYTECODES : public vector<BYTECODE>
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

