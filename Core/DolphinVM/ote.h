/******************************************************************************

	File: OTE.h

	Description:

	Definition of object table entry (OTE).

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include <type_traits>
#include <cstdint>

#define COUNTBITS	(sizeof(uint8_t)*8)
#define SPACEBITS	3
#define NULLTERMTYPE WCHAR
//#define NULLTERMTYPE char
#define NULLTERMSIZE sizeof(NULLTERMTYPE)

template <class T> class TOTE;
class ObjectMemory;

// Declare forward references
namespace ST
{
	class Behavior;
	class Object;
}
typedef TOTE<ST::Behavior> BehaviorOTE;

typedef	uint8_t count_t;
typedef uint16_t hash_t;						// Identity hash value, assigned on object creation

enum class Spaces { Normal, Virtual, Blocks, Contexts, Dwords, Heap, Floats };
typedef typename std::underlying_type<Spaces>::type space_t;

union OTEFlags
{
	// Object Creation
	static constexpr space_t NumSpaces = static_cast<space_t>(Spaces::Floats) + 1;

	struct
	{
		uint8_t	m_free : 1;				// Is the object in use?
		uint8_t	m_pointer : 1; 			// Pointer bit?
		uint8_t	m_mark : 1;				// Garbage collector mark
		uint8_t	m_finalize : 1;			// Should the object be finalized
		uint8_t m_weakOrZ : 1;			// weak references if pointers, null term if bytes
		uint8_t m_space : SPACEBITS;	// Memory space in which the object resides (used when deallocating)
	};
	uint8_t m_value;

	// Often it is more efficient to use masking to avoid a 16-bit load operation
	 
	static constexpr uint8_t FreeMask = 1;
	static constexpr uint8_t PointerMask = 1 << 1;
	static constexpr uint8_t MarkMask = 1 << 2;
	static constexpr uint8_t FinalizeMask = 1 << 3;
	static constexpr uint8_t WeakOrZMask = 1 << 4;
	static constexpr uint8_t SpaceMask = 0x7 << 5;

	static constexpr uint8_t WeakMask = (PointerMask | WeakOrZMask);
};


// Class of object table entries
// This is really opaque to everybody but the ObjectMemory (or should be)
template <class T> class TOTE
{
public:
	static constexpr count_t MAXCOUNT = ((2 << (COUNTBITS - 1)) - 1);
	static constexpr size_t SizeMask = 0x7FFFFFFF;
	static constexpr size_t ImmutabilityBit = 0x80000000;

	__forceinline size_t getSize() const					{ return m_size & SizeMask; }
	__forceinline void setSize(size_t size)					{ m_size = size; }

	__forceinline size_t getWordSize() const				{ return getSize()/sizeof(Oop); }
	__forceinline size_t pointersSize() const				{ ASSERT(isPointers());	return getSize()/sizeof(Oop); }
	__forceinline ptrdiff_t pointersSizeForUpdate() const	{ ASSERT(isPointers());	return static_cast<ptrdiff_t>(m_size)/static_cast<ptrdiff_t>(sizeof(Oop)); }
	__forceinline size_t bytesSize()	const				{ ASSERT(isBytes()); return getSize(); }
	__forceinline ptrdiff_t bytesSizeForUpdate() const		{ ASSERT(isBytes()); return m_size; }

	// The size of a byte object can be one more than it pretends because of the hidden null terminator!
	// Answers actual byte (heap) size of the object pointed at by this OTE
	__forceinline size_t sizeOf() const
	{
		// If we use getSize() here, it does not get inlined
		return getSize() + (isNullTerminated() * NULLTERMSIZE);
	}

	// The required size for this variable pointer object to accommodate the specified number of indexable fields
	__forceinline size_t pointerSizeFor(size_t pointersRequested) { ASSERT(isPointers()); return pointersRequested + m_oteClass->m_location->fixedFields(); }

	__forceinline BOOL isSticky() const						{ return m_count == MAXCOUNT; }
	__forceinline void beSticky()							{ m_count = MAXCOUNT; }

	// Answer whether the receiver has the current mark
	__forceinline void setMark(uint8_t mark)					{ m_flags.m_mark = mark; }

	__forceinline size_t getIndex()	const					{ return this - reinterpret_cast<const TOTE<T>*>(ObjectMemory::m_pOT); }

	__forceinline void countUp() 
	{ 
#ifdef _DEBUG
		if (m_count < MAXCOUNT) m_count++;
#else
		// Deliberately truncate to zero to detect sticky
		count_t up = m_count + 1;
		if (up != 0) m_count = up; 
#endif
	}

	__forceinline void countDown()
	{
		HARDASSERT(m_count > 0);
		if (m_count != MAXCOUNT)
	 		if (--m_count == 0)
				ObjectMemory::AddToZct(reinterpret_cast<TOTE<ST::Object>*>(this));
	}

	void countDownStackRef()
	{
		HARDASSERT(m_count > 0);
		if (m_count != MAXCOUNT)
			if (--m_count == 0)
				ObjectMemory::AddStackRefToZct(reinterpret_cast<TOTE<ST::Object>*>(this));
	}

	__forceinline bool decRefs()							{ return (m_count != MAXCOUNT) && (--m_count == 0); }
	__forceinline bool isImmutable() const					{ return static_cast<ptrdiff_t>(m_size) < 0; }
	__forceinline void beImmutable()						{ m_size |= ImmutabilityBit; }
	__forceinline void beMutable()							{ m_size &= SizeMask; }
	__forceinline BOOL isFree() const						{ return m_flagsWord & OTEFlags::FreeMask; /*m_flags.m_free;*/ }
	__forceinline void beFree()								{ m_flagsWord |= OTEFlags::FreeMask; }
	__forceinline void setFree(bool bFree)					{ m_flags.m_free = bFree; }
	__forceinline void beAllocated()						{ m_flagsWord &= ~OTEFlags::FreeMask; }
	__forceinline BOOL isPointers() const					{ return m_flags.m_pointer; }
	__forceinline void bePointers()							{ m_flagsWord |= OTEFlags::PointerMask; }
	__forceinline BOOL isBytes() const						{ return !m_flags.m_pointer; }
	__forceinline void beBytes()							{ m_flagsWord &= ~OTEFlags::PointerMask; }
	__forceinline BOOL isFinalizable()	const				{ return m_flags.m_finalize; }
	__forceinline void beFinalizable()						{ m_flagsWord |= OTEFlags::FinalizeMask; }
	__forceinline void beUnfinalizable()					{ m_flagsWord &= ~OTEFlags::FinalizeMask; }
	__forceinline bool isWeak() const						{ return (m_flagsWord & OTEFlags::WeakMask) == OTEFlags::WeakMask; }
	__forceinline bool isNullTerminated() const				{ return (m_flagsWord & OTEFlags::WeakMask) == OTEFlags::WeakOrZMask; }
	__forceinline void beNullTerminated()					{ ASSERT(!isImmutable()); setNullTerminated(); m_size -= NULLTERMSIZE; }
	__forceinline void setNullTerminated()					{ m_flagsWord = (m_flagsWord & ~OTEFlags::PointerMask) | OTEFlags::WeakOrZMask; }
	__forceinline Spaces heapSpace() const					{ return static_cast<Spaces>(m_flags.m_space); }
	__forceinline bool flagsAllMask(uint8_t mask) const		{ return (m_ubFlags & mask) == mask; }

	__forceinline hash_t identityHash()
	{
		// This needs to be a loop in case nextIdentityHash ever returns zero
		while (m_idHash == 0)
		{
			m_idHash = ObjectMemory::nextIdentityHash();
		}
		return m_idHash;
	}

public:
	T*				m_location;					// Pointer to array of elements which is the object
	BehaviorOTE*	m_oteClass;					// Class Oop
	// Size is now in the OTE too, if zero then m_location should be NULL
	size_t		 	m_size;						// In practice max size is maximum positive SmallInteger, i.e. 16r3FFFFFFF, around 1Mb

	union
	{
		struct 
		{
			union
			{
				OTEFlags	m_flags;					// 8-bits of flags
				uint8_t		m_ubFlags;
			};
			count_t		m_count;
			hash_t		m_idHash;					// identity hash value (16-bit)
		};
		uintptr_t m_flagsWord;
	};
};

#define isIntegerObject(objectPointer)	(Oop(objectPointer) & 1)
#define integerObjectOf(value) 			(Oop(((SmallInteger)(value) << 1) | 1))
#define integerValueOf(objectPointer) 	(SmallInteger(objectPointer) >> 1)
#define isIntegerValue(valueWord)		((SmallInteger(valueWord) ^ (SmallInteger(valueWord)<<1)) >= 0)
//#define isIntegerValue(valueWord)		(SmallInteger(valueWord) >= MinSmallInteger && SmallInteger(valueWord) <= MaxSmallInteger)
#define isPositiveIntegerValue(valueWord) ((SmallUinteger)(valueWord) <= MaxSmallInteger)

// SmallInteger constants
#define MinusOnePointer -1 /*(integerObjectOf(-1))*/
#define ZeroPointer 1 /*(integerObjectOf(0))*/
#define OnePointer 3 /*(integerObjectOf(1))*/
#define TwoPointer 5 /*(integerObjectOf(2))*/
#define ThreePointer 7 /*(integerObjectOf(3))*/

#include "STObject.h"
typedef TOTE<ST::Object> OTE;
typedef TOTE<void>* OOP;
#ifndef POTE_DEFINED
typedef OTE* POTE;
#define POTE_DEFINED
#endif

std::wostream& operator<<(std::wostream& stream, const OTE*);

