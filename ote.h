/******************************************************************************

	File: OTE.h

	Description:

	Definition of object table entry (OTE).

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#define COUNTBITS	(sizeof(BYTE)*8)
#define SPACEBITS	3

template <class T> class TOTE;

// Declare forward references
namespace ST
{
	class Behavior;
}
typedef TOTE<ST::Behavior> BehaviorOTE;

typedef	BYTE count_t;
typedef WORD hash_t;						// Identity hash value, assigned on object creation

struct OTEFlags
{
	// Object Creation
	enum Spaces { NormalSpace, VirtualSpace, BlockSpace, ContextSpace, DWORDSpace, HeapSpace, FloatSpace, PoolSpace, NumSpaces };

	BYTE	m_free : 1;				// Is the object in use?
	BYTE	m_pointer : 1; 			// Pointer bit?
	BYTE	m_mark : 1;				// Garbage collector mark
	BYTE	m_finalize : 1;			// Should the object be finalized
	BYTE 	m_weakOrZ : 1;			// weak references if pointers, null term if bytes
	BYTE 	m_space : SPACEBITS;	// Memory space in which the object resides (used when deallocating)
};


// Class of object table entries
// This is really opaque to everybody but the ObjectMemory (or should be)
template <class T> class TOTE
{
public:
	enum { MAXCOUNT	= ((2<<(COUNTBITS-1))-1) };
	// Often it is more efficient to use masking to avoid a 16-bit load operation
	enum { FreeMask = 1, PointerMask = 2, MarkMask = 4, FinalizeMask = 8, WeakOrZMask = 16 };
	enum { WeakMask = (PointerMask | WeakOrZMask) };
	enum { SizeMask = 0x7FFFFFFF, ImmutabilityBit = 0x80000000 };

	__forceinline MWORD getSize() const						{ return m_size & SizeMask; }
	__forceinline void setSize(MWORD size)					{ m_size = size; }

	__forceinline MWORD getWordSize() const					{ return getSize()/sizeof(MWORD); }
	__forceinline MWORD pointersSize() const				{ ASSERT(isPointers());	return getSize()/sizeof(MWORD); }
	__forceinline int pointersSizeForUpdate() const			{ ASSERT(isPointers());	return bytesSizeForUpdate()/static_cast<int>(sizeof(MWORD)); }
	__forceinline MWORD bytesSize()	const					{ ASSERT(isBytes()); return getSize(); }
	__forceinline int bytesSizeForUpdate() const			{ return m_size; } 

	// The size of a byte object can be one more than it pretends because of the hidden null terminator!
	// Answers actual byte (heap) size of the object pointed at by this OTE
	__forceinline int sizeOf() const
	{
		// If we use getSize() here, it does not get inlined
		return getSize() + isNullTerminated();
	}

	// The required size for this variable pointer object to accommodate the specified number of indexable fields
	__forceinline MWORD pointerSizeFor(MWORD pointersRequested) { ASSERT(isPointers()); return pointersRequested + m_oteClass->m_location->fixedFields(); }

	__forceinline BOOL isSticky() const						{ return m_count == MAXCOUNT; }
	__forceinline void beSticky()							{ m_count = MAXCOUNT; }

	// Answer whether the receiver has the current mark
	__forceinline void setMark(BYTE mark)					{ m_flags.m_mark = mark; }

	__forceinline MWORD getIndex()	const					{ return this - reinterpret_cast<const TOTE<T>*>(ObjectMemory::m_pOT); }

	__forceinline void countUp()							{ if (m_count < MAXCOUNT) m_count++; }

	__forceinline void countDown()
	{
		HARDASSERT(m_count > 0);
		if (m_count < MAXCOUNT)
	 		if (--m_count == 0)
				ObjectMemory::AddToZct((OTE*)this);
	}

	void countDownStackRef()
	{
		HARDASSERT(m_count > 0);
		if (m_count < MAXCOUNT)
			if (--m_count == 0)
				ObjectMemory::AddStackRefToZct((OTE*)this);
	}

	__forceinline bool decRefs()							{ return (m_count < MAXCOUNT) && (--m_count == 0); }
	__forceinline bool isImmutable() const					{ return static_cast<int>(m_size) < 0; }
	__forceinline void beImmutable()						{ m_size |= ImmutabilityBit; }
	__forceinline void beMutable()							{ m_size &= SizeMask; }
	__forceinline BOOL isFree() const						{ return m_dwFlags & FreeMask; /*m_flags.m_free;*/ }
	__forceinline void beFree()								{ m_dwFlags |= FreeMask; }
	__forceinline void setFree(bool bFree)					{ m_flags.m_free = bFree; }
	__forceinline void beAllocated()						{ m_dwFlags &= ~FreeMask; }
	__forceinline BOOL isPointers() const					{ return m_flags.m_pointer; }
	__forceinline void bePointers()							{ m_dwFlags |= PointerMask; }
	__forceinline BOOL isBytes() const						{ return !m_flags.m_pointer; }
	__forceinline void beBytes()							{ m_dwFlags &= ~PointerMask; }
	__forceinline BOOL isFinalizable()	const				{ return m_flags.m_finalize; }
	__forceinline void beFinalizable()						{ m_dwFlags |= FinalizeMask; }
	__forceinline void beUnfinalizable()					{ m_dwFlags &= ~FinalizeMask; }
	__forceinline bool isWeak() const						{ return (m_dwFlags & WeakMask) == WeakMask; }
	__forceinline bool isNullTerminated() const				{ return (m_dwFlags & WeakMask) == WeakOrZMask; }
	__forceinline void beNullTerminated()					{ ASSERT(!isImmutable()); setNullTerminated(); m_size--; }
	__forceinline void setNullTerminated()					{ m_dwFlags = (m_dwFlags & ~PointerMask) | WeakOrZMask; }

	__forceinline bool isBehavior() const					{ return isMetaclass() || m_oteClass->isMetaclass(); }
	__forceinline bool isMetaclass() const					{ return m_oteClass == Pointers.ClassMetaclass; }

	__forceinline bool isNil() const						{ return Oop(this) == Oop(Pointers.Nil); }
	__forceinline OTEFlags::Spaces heapSpace() const		{ return static_cast<OTEFlags::Spaces>(m_flags.m_space); }
	__forceinline bool flagsAllMask(BYTE mask) const		{ return (m_ubFlags & mask) == mask; }

	hash_t identityHash()
	{
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
	MWORD 	m_size;			// In practice max size is maximum positive SmallInteger, i.e. 16r3FFFFFFF, around 1Mb

	union
	{
		struct 
		{
			union
			{
				OTEFlags	m_flags;					// 8-bits of flags
				BYTE		m_ubFlags;
			};
			count_t		m_count;
			hash_t		m_idHash;					// identity hash value (16-bit)
		};
		DWORD m_dwFlags;
	};
};

#define isIntegerObject(objectPointer)	(Oop(objectPointer) & 1)
#define integerObjectOf(value) 			(Oop(((SMALLINTEGER)(value) << 1) | 1))
#define integerValueOf(objectPointer) 	(SMALLINTEGER(objectPointer) >> 1)
#define isIntegerValue(valueWord)		((SMALLINTEGER(valueWord) ^ (SMALLINTEGER(valueWord)<<1)) >= 0)
//#define isIntegerValue(valueWord)		(SMALLINTEGER(valueWord) >= MinSmallInteger && SMALLINTEGER(valueWord) <= MaxSmallInteger)
#define isPositiveIntegerValue(valueWord) ((MWORD)(valueWord) <= MaxSmallInteger)

// SmallInteger constants
#define MinusOnePointer (integerObjectOf(-1))
#define ZeroPointer (integerObjectOf(0))
#define OnePointer (integerObjectOf(1))
#define TwoPointer (integerObjectOf(2))
#define ThreePointer (integerObjectOf(3))

#include "STObject.h"
typedef TOTE<ST::Object> OTE;
typedef TOTE<void>* OOP;
#ifndef POTE_DEFINED
typedef OTE* POTE;
#define POTE_DEFINED
#endif

std::ostream& operator<<(std::ostream& stream, const OTE*);

template <class T> inline void NilOutPointer(TOTE<T>*& ote)
{
	ote->countDown();
	ote = reinterpret_cast<TOTE<T>*>(Pointers.Nil);
}
