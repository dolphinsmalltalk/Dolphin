/******************************************************************************

	File: ObjMem.h

	Description:

	Object Memory management class declarations for Dolphin Smalltalk
	(see the "Blue Book" specification)

******************************************************************************/
#pragma once

#include "Ist.h"
#include "STObject.h"
#include "STVirtualObject.h"
#include "STBehavior.h"
#include "STMemoryManager.h"
#include "ImageHeader.h"
#include "PrimitiveFailureCode.h"

using namespace ST;

#define PRIVATE_HEAP
//#undef PRIVATE_HEAP

// Dolphin Smallblock heap separate from C-runtime sbh
#include "sbheap.h"

#if defined(_DEBUG)
	#define MEMSTATS
	#define TRACKFREEOTEs
#endif

// We don't want inline expansion of recursive functions thankyou
//#pragma inline_depth(32)
//#pragma inline_recursion(off)

#ifndef MinSmallInteger
#define MinSmallInteger -0x40000000
#endif
#ifndef MaxSmallInteger
#define MaxSmallInteger 0x3FFFFFFF
#endif

constexpr size_t PoolGranularity = 8;

class ibinstream;
class obinstream;

#define pointerFromIndex(index)	(m_pOT+static_cast<ptrdiff_t>(index))

enum class ByteElementSize : size_t
{
	Bytes = 0,
	Words = 1,
	Quads = 2
};

///////////////////////////////////////////////////////////////////////////////
// Class of Object Memory Managers

class ObjectMemory
{
public:

	// Public interface for use of Interpreter
	static HRESULT Initialize();
	static HRESULT InitializeImage();
	static void InitializeMemoryManager();
	static void Terminate();

	// Object Pointer access
	static Oop fetchPointerOfObject(size_t fieldIndex, PointersOTE* ote);
	static void storePointerOfObjectWithValue(size_t fieldIndex, PointersOTE* ote, Oop valuePointer);
	static void storePointerWithValue(Oop& oopSlot, Oop oopValue);
	static OTE* storePointerWithValue(OTE*& oteSlot, OTE* oteValue);
	static Oop storePointerWithValue(Oop& oopSlot, OTE* oteValue);
	static void nilOutPointer(Oop& objectPointer);
	static void nilOutPointer(OTE*& ote);

	// Use these versions to store values which are not themselves ref. counted
	static Oop storePointerWithUnrefCntdValue(Oop&, Oop);
	static void __fastcall storePointerOfObjectWithUnrefCntdValue(size_t fieldIndex, PointersOTE* ote, Oop value);

	// Word Access
	static uintptr_t fetchWordOfObject(size_t fieldIndex, Oop objectPointer);
	static uintptr_t storeWordOfObjectWithValue(size_t fieldIndex, Oop objectPointer, uintptr_t valueWord);

	// Formerly Private reference count management
	static void  __fastcall countUp(Oop objectPointer);
	static void __fastcall countDown(Oop rootObjectPointer);
	template<typename Partitioner, typename Predicate> static ArrayOTE* selectObjects(const Partitioner&&, const Predicate& pred);
	static ArrayOTE* __stdcall instancesOf(const BehaviorOTE* classPointer);
	static ArrayOTE* __stdcall subinstancesOf(const BehaviorOTE* classPointer);
	static ArrayOTE* __stdcall referencesTo(const Oop referencedObjectPointer, bool includeWeakRefs);
	static ArrayOTE* __fastcall instanceCounts(ArrayOTE* oteClasses);
	static void deallocateByteObject(OTE*);

	// Class pointer access
	static BehaviorOTE* fetchClassOf(Oop objectPointer);

	static ByteElementSize GetBytesElementSize(BytesOTE* ote);

	// Use CRT Small block heap OR pool if size <= this threshold
	static constexpr size_t MaxSmallObjectSize = 0x3f8;
	static constexpr size_t PoolObjectSizeLimit = 144;
	static constexpr size_t MinObjectSize = /*sizeof(Object)+*/PoolGranularity;
	static constexpr size_t MaxPools = (PoolObjectSizeLimit - MinObjectSize) / PoolGranularity + 1;

	static VirtualOTE* __fastcall newVirtualObject(BehaviorOTE* classPointer, size_t initialSize, size_t maxSize);
	static PointersOTE* __fastcall newPointerObject(BehaviorOTE* classPointer);
	static PointersOTE* __fastcall newPointerObject(BehaviorOTE* classPointer, size_t instanceSize);
	static PointersOTE* __fastcall newUninitializedPointerObject(BehaviorOTE* classPointer, size_t instanceSize);
	template <bool MaybeZ, bool Initialize> static BytesOTE* newByteObject(BehaviorOTE* classPointer, size_t instanceByteSize);
	template <class T> static TOTE<T>* newUninitializedNullTermObject(size_t instanceByteSize);
	static BytesOTE* __fastcall newByteObject(BehaviorOTE* classPointer, size_t instanceByteSize, const void* pBytes);
	static OTE* CopyElements(OTE* oteObj, size_t startingAt, size_t countfrom);

	// Resizing objects (RAW - assumes no. ref counting to be done)
	template <size_t extra> static POBJECT basicResize(OTE* ote, size_t byteSize /*should include header*/);
	static POBJECT resizeVirtual(OTE* ote, size_t byteSize /*ditto*/);

	// More useful (and safe) entry points from Interpreter
	static VariantObject* resize(PointersOTE* objectPointer, size_t newPointers, bool bRefCount);
	static VariantByteObject* resize(BytesOTE* objectPointer, size_t newBytes);

	static BytesOTE* __fastcall shallowCopy(BytesOTE* ote);
	static PointersOTE* __fastcall shallowCopy(PointersOTE* ote);

	// Pointer Swapping
	static void __fastcall oneWayBecome(OTE* firstPointer, OTE* secondPointer);

	// GC support
	static SmallInteger OopsLeft();
	static size_t __fastcall OopsUsed();
	static size_t GetOTSize();
	static size_t compact(Oop* const sp);
	static void HeapCompact();

	// Used by Interpreter and Compiler to update any Oops they hold following a compact
	template <class T> static void compactOop(T*& ote)
	{
		// If OTE is marked as free, then it must have been moved during compaction. Otherwise we can leave alone
		if (ote->isFree())
		{
			ote = (T*)(ote->m_location);
			HARDASSERT(!ote->isFree());
			HARDASSERT((char*)ote >= (char*)m_pOT && (char*)ote < (char*)m_pFreePointerList);
		}
	}

	static OTE* PointerFromIndex(size_t index)
	{
		return pointerFromIndex(index);
	}

	#ifdef _DEBUG
	
	#define FREEFLAG 0x80000000

	static OTE* NextFree(const OTE* ote)
	{
		assert(ote->isFree());
		assert((reinterpret_cast<uintptr_t>(ote->m_location) & FREEFLAG) == FREEFLAG);
		OTE* next = reinterpret_cast<OTE*>(reinterpret_cast<uintptr_t>(ote->m_location) & ~FREEFLAG);
		assert(next >= m_pOT && next <= (m_pOT + m_nOTSize));
		return next;
	}

	static const POBJECT MakeNextFree(const OTE* pFree)
	{
		return reinterpret_cast<POBJECT>(reinterpret_cast<uintptr_t>(pFree) | FREEFLAG);
	}
	#else
	static OTE* NextFree(const OTE* ote)
	{
		return reinterpret_cast<OTE*>(reinterpret_cast<uintptr_t>(ote->m_location));
	}

	static const POBJECT MakeNextFree(const OTE* pFree)
	{
		return reinterpret_cast<POBJECT>(reinterpret_cast<uintptr_t>(pFree));
	}
	#endif

	// Answer whether the argument is a permanent object
	static bool isPermanent(OTE* ote);

	// Test Oop of objects class
	static bool isPointers(Oop objectPointer);	// faster than Interpreter::isPointers()
	static bool isBytes(Oop objectPointer);

	// All these routines fail for SmallIntegers (hence the OTE argument)
	static bool __fastcall isAMetaclass(const OTE* ote);
	static bool __fastcall isBehavior(Oop objectPointer);
	static bool isAContext(const OTE* ote);

	// This is a very simple routine which can work entirely in registers (hence fastcall)
	static bool __stdcall inheritsFrom(const BehaviorOTE* behaviorPointer, const BehaviorOTE* classPointer);
	static bool isKindOf(Oop objectPointer, const BehaviorOTE* classPointer);

	// Answer whether the object with Oop objectPointer is an instance or subinstance
	// of the Behavior object with Oop classPointer;
	template <typename T> static bool isKindOf(const TOTE<T>* ote, const BehaviorOTE* classPointer)
	{
		ASSERT(!isIntegerObject(ote));
		const BehaviorOTE* behaviorPointer = ote->m_oteClass;
		return inheritsFrom(behaviorPointer, classPointer);
	}


	// More C++ like interface

	// Sadly, this is not legal, since operator[] cannot be static
	// static POBJECT operator[](Oop objectPointer);
	static uint8_t* ByteAddressOfObject(Oop& objectPointer);			// pointer to header (or SmallInteger)
	static uint8_t* ByteAddressOfObjectContents(Oop& objectPointer);	// pointer to body (or SmallInteger)

	// Recalc. ref. counts, perform consistency check, and clean up
	static Oop* rootObjectPointers[];

	enum GCFlags { GCNormal, GCNoWeakness };
	static void asyncGC(uintptr_t flags, Oop* const sp);

	static void markObject(OTE* ote);
	static void MarkObjectsAccessibleFromRoot(OTE* ote);

	static void finalize(OTE* ote);

	static void addVMRefs();

#ifdef _DEBUG
	// Recalc and consistency check
	static void checkReferences(Oop* const sp);
	static void checkReferences();
	static void addRefsFrom(OTE* ote);
	static void checkPools();
	static void checkStackRefs(Oop* const sp);
	static bool isValidOop(Oop);
#endif

	// Does an object have the current GC mark?
	template <class T> static bool hasCurrentMark(TOTE<T>* const ote)
	{
			return ote->m_flags.m_mark == m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)].m_mark;
	}

#ifdef MEMSTATS
	static void DumpStats();
	static void CheckPoint();
#endif

	static _PrimitiveFailureCode __stdcall SaveImageFile(const wchar_t* fileName, bool bBackup, int nCompressionLevel, size_t nMaxObjects);
	static HRESULT __stdcall LoadImage(const wchar_t* szImageName, LPVOID imageData, size_t imageSize, bool bIsDevSys);

	static int gpFaultExceptionFilter(LPEXCEPTION_POINTERS pExInfo);

	static MemoryManager* memoryManager();

public:
	static constexpr size_t OTMinHeadroom = 16384;
	static constexpr size_t OTDefaultSize = 65536;
	static constexpr size_t OTDefaultMax = 24 * 1024 * 1024;
	static constexpr size_t OTMaxLimit = 64 * 1024 * 1024;

	static constexpr size_t registryIndex = 0;
	static constexpr size_t FirstBuiltInIdx = registryIndex + 1;

	/***************************************************************************************
	* N.B. If inserting new fixed Oops, must also update the FIRSTCHAROFFSET in ISTASM.INC
	* or will get garbage DNU very early in boot
	/***************************************************************************************/
	static constexpr size_t nilOOPIndex = FirstBuiltInIdx;
	static constexpr size_t trueOOPIndex = nilOOPIndex + 1;
	static constexpr size_t falseOOPIndex = trueOOPIndex + 1;
	static constexpr size_t emptyStringOOPIndex = falseOOPIndex + 1;
	static constexpr size_t delimStringOOPIndex = emptyStringOOPIndex + 1;
	static constexpr size_t emptyArrayOOPIndex = delimStringOOPIndex + 1;
	static constexpr size_t FirstCharacterIdx = emptyArrayOOPIndex + 1;
	static constexpr size_t NumCharacters = 256;
	static constexpr size_t NumPermanent = FirstCharacterIdx + NumCharacters;
	static constexpr size_t OTBase = NumPermanent;

	static constexpr size_t MinimumVirtualMemoryAvailable = 256 * 1024 * 1024;

	class OTEPool
	{
	public:
		OTE*	m_pFreeList;

#ifdef MEMSTATS
		size_t	m_nFree;
		size_t	m_nAllocated;

		void	DumpStats();
		void	registerNew(OTE* newOTE, BehaviorOTE* classPointer);
#endif

		OTEPool() : m_pFreeList(0)
		{
#ifdef MEMSTATS
			m_nFree = 0;
			m_nAllocated = 0;
#endif
		}

		size_t FreeCount();

		void clear();

		OTE* allocate();
		void deallocate(OTE* ote);

		BytesOTE* newByteObject(BehaviorOTE* classPointer, size_t bytes, Spaces space);
		PointersOTE* newPointerObject(BehaviorOTE* classPointer, size_t pointers, Spaces space);

		void terminate()
		{
			// We don't actually free the content, as it is released more efficiently by
			// deleting all the heap pages and OT en-masse.
			m_pFreeList = 0;
		}
	};

	friend class OTEPool;
	friend class BootLoader;

private:
	///////////////////////////////////////////////////////////////////////////
	// "Zero Count Table" (ZCT). Holds a ref to all objects that have been
	// newly allocated, or who's count has dropped to zero

	static OTE** m_pZct;
	static ptrdiff_t m_nZctEntries;		// Current no. of Zct entries
	static ptrdiff_t m_nZctHighWater;	// High water mark at which ZCT reconciled
	static bool m_bIsReconcilingZct;

	static HRESULT InitializeZct();
	static bool IsReconcilingZct();
	static void GrowZct();
	static void ShrinkZct();

public:
#ifdef _DEBUG
	static bool alwaysReconcileOnAdd;
#endif

	static void __fastcall AddToZct(TOTE<Object>* ote);
	static void __fastcall AddOopToZct(Oop);
	static void __fastcall AddStackRefToZct(TOTE<Object>* ote);

	// Used by Interpreter when switching processes
	static void EmptyZct(Oop* const sp);
	static void PopulateZct(Oop* const sp);
	static Oop* __fastcall ReconcileZct();
#ifdef _DEBUG
	static bool IsInZct(OTE*);
	static void DumpZct();
#endif

private:
	///////////////////////////////////////////////////////////////////////////
	// Memory Pools

	__declspec(align(8)) class FixedSizePool
	{
	public:
		FixedSizePool(size_t nChunkSize=MinObjectSize);

		POBJECT allocate();
		void deallocate(POBJECT pChunk);
		
		void setSize(size_t nChunkSize);
		void terminate();

	#ifdef _DEBUG
		bool isMyChunk(void* pChunk);
		bool isValid();
	#endif

	#ifdef MEMSTATS
		size_t getPages() { return m_nPages; }
		size_t getFree();
		void**		m_pages;
		size_t	m_nPages;
	#endif

	size_t getSize() { return m_nChunkSize; }

	private:
		void moreChunks();
		static void morePages();
		static uint8_t* allocatePage();

	public:
		static void Initialize();
		static void Terminate();

	public:
		struct		Link	{ Link* next; };

	private:

		Link*		m_pFreeChunks;
		size_t		m_nChunkSize;

		static	Link*		m_pFreePages;
		static	void**		m_pAllocations;
	public:
		static	size_t		m_nAllocations;
	};

	static HRESULT __stdcall allocateOT(size_t reserve, size_t commit);

	// Answer the index of the last occuppied OT entry
	static size_t __stdcall lastOTEntry();

	static OTE* __fastcall allocateOop(POBJECT pLocation);
public:
	static hash_t nextIdentityHash();
private:
	// Memory allocators - these are very thin layers of C/Win32 heap
	static void freeChunk(POBJECT pChunk);
	static void freeSmallChunk(POBJECT pObj, size_t size);
	static POBJECT reallocChunk(POBJECT pChunk, size_t newChunkSize);
#ifdef _DEBUG
	static size_t chunkSize(void* pChunk);
#endif

	static POBJECT allocSmallChunk(size_t chunkSize);
	static POBJECT allocChunk(size_t chunkSize);
	static POBJECT allocObject(size_t objectSize, OTE*& ote);
	static POBJECT allocLargeObject(size_t objectSize, OTE*& ote);

	static FixedSizePool& spacePoolForSize(size_t objectSize);

	static void decRefs(Oop);

#ifdef _DEBUG
	static void cantBeIntegerObject(Oop objectPointer);
#else
	#define cantBeIntegerObject(Oop) (void(0))
#endif

	// Private reference count management
	static OTE* __fastcall recursiveFree(OTE* rootOTE);
	static void recursiveCountDown(OTE* rootOTE);

	// NOT the normal way to clean up an object (normally done by counting down)
	static void deallocate(OTE* ote);

	static void releasePointer(OTE* ote);

	// Garbage collection/Ref count checking
	static uint8_t WeaknessMask;
	static size_t lastStrongPointerOf(const OTE* ote);
	static void reclaimInaccessibleObjects(uintptr_t flags);
	static void markObjectsAccessibleFrom(OTE* ote);
	static void ClearGCInfo();
	static OTEFlags nextMark();

	static void compactObject(OTE* ote);

	static Oop corpsePointer();

private:
	// Const obj support - very crude at present

	static void* m_pConstObjs;
public:
	static DWORD __stdcall ProtectConstSpace(DWORD dwNewProtect);
	static bool IsConstObj(void* ptr);

private:
	///////////////////////////////////////////////////////////////////////////
	// Image Load/Save

	static const char ISTHDRTYPE[4];

	static bool __stdcall SaveObjectTable(obinstream& imageFile, const ImageHeader*);
	template <size_t ImageNullTerms> static bool __stdcall SaveObjects(obinstream& imageFile, const ImageHeader*);
	static bool __stdcall SaveImage(obinstream& imageFile, const ImageHeader*, int nRet);

	static HRESULT __stdcall LoadImage(ibinstream& imageFile, ImageHeader*);

	static OTE* __fastcall FixupPointer(OTE* pSavedPointer, OTE* pSavedBase);
	static HRESULT __stdcall LoadObjectTable(ibinstream& imageFile, const ImageHeader*);
	template <size_t ImageNullTerms> static HRESULT LoadPointersAndObjects(ibinstream& imageFile, const ImageHeader* pHeader, size_t& cbRead);
	template <size_t ImageNullTerms> static HRESULT __stdcall LoadPointers(ibinstream& imageFile, const ImageHeader*, size_t&);
	template <size_t ImageNullTerms> static HRESULT __stdcall LoadObjects(ibinstream& imageFile, const ImageHeader*, size_t&);

	static ST::Object* AllocObj(OTE * ote, size_t allocSize);

	static void __stdcall FixupObject(OTE* ote, uintptr_t* oldLocation, const ImageHeader*);
	static void __stdcall PostLoadFix();

public:			// Public Data

	static constexpr size_t dwOopsPerPage = dwPageSize/sizeof(Oop);

	static uint32_t m_imageVersionMajor;	// MS part of image version number
	static uint32_t m_imageVersionMinor;	// LS part of image version number

private:		// Private Data


	static HANDLE m_hHeap;
	static constexpr size_t HEAPINITPAGES = 2;

	static uint32_t m_nNextIdHash;					// Next identity hash value to use

	// These are to be used for collecting statistics in future
	static size_t	m_nObjectsAllocated;
	static size_t	m_nObjectsFreed;
	static size_t	m_nBytesAllocated;
	static size_t	m_nBytesFreed;
#ifdef TRACKFREEOTEs
	static size_t	m_nFreeOTEs;
	static size_t	CountFreeOTEs();
#endif

	static OTEFlags m_spaceOTEBits[OTEFlags::NumSpaces];

	static size_t m_nOTMax;
	static size_t m_nOTSize;						// The size (in Oops, not bytes) of the object table
public:
	static OTE*		m_pOT;							// The Object Table itself
private:
	static OTE*		m_pFreePointerList;				// Head of list of free Object Table Entries

private:
	static FixedSizePool	m_pools[MaxPools];
};

// Lower level object creation
// Note that we deliberately do not make this a member fn, so that we are sure it is not
// touching any of the static member vars
Oop* __stdcall AllocateVirtualSpace(size_t maxBytes, size_t initialBytes);


// Globally accessible pointers, but please don't write to them!
#define NumPointers (sizeof(_Pointers)/sizeof(Oop) - ObjectHeaderSize)

/******************************************************************************

	INLINE METHODS

******************************************************************************/

///////////////////////////////////////////////////////////////////////////////
// Integer Access

#define ObjectMemoryIntegerValueOf		integerValueOf
#define	ObjectMemoryIntegerObjectOf 	integerObjectOf
#define ObjectMemoryIsIntegerObject		isIntegerObject
#define ObjectMemoryIsIntegerValue		isIntegerValue
#define ObjectMemoryIsPositiveIntegerValue		isPositiveIntegerValue

#ifdef _DEBUG
inline bool ObjectMemory::isValidOop(Oop objectPointer)
{
	return isIntegerObject(objectPointer) || (objectPointer & (sizeof(OTE)-1)) == 0 &&
		objectPointer >= reinterpret_cast<Oop>(m_pOT) && objectPointer < reinterpret_cast<Oop>(m_pOT + m_nOTSize);
}
#endif

// Make it a macro to speed up debug version a bit
// All of these macros refer to their args only once, so shouldn't be any
// multiple reference problems if there are function calls, etc, in the
// calls
#define ot(objectPointer) (*reinterpret_cast<OTE*>(objectPointer))

#define roundUpTo(n, to) ((((n)+(to)-1)/(to)) * (to))

// Macro to calculate the byte size of an object with N pointers
#define SizeOfPointers(N) ((static_cast<size_t>(N)+ObjectHeaderSize)*sizeof(Oop))

inline void ObjectMemory::decRefs(Oop oop)
{
	if (!isIntegerObject(oop))
		reinterpret_cast<OTE*>(oop)->decRefs();
}

inline size_t ObjectMemory::GetOTSize()
{
	return m_nOTSize;
}

///////////////////////////////////////////////////////////////////////////////
//	Inlines for Public interface used by Interpreter

inline MemoryManager* ObjectMemory::memoryManager()
{
	ASSERT(!Pointers.MemoryManager->m_oteClass->isMetaclass());
	return Pointers.MemoryManager->m_location;
}

inline bool ObjectMemory::isPermanent(OTE* ote)
{
	ASSERT(!isIntegerObject(ote));
	return ote < pointerFromIndex(NumPermanent);
}

inline bool ObjectMemory::isPointers(Oop objectPointer)
{
	return !isIntegerObject(objectPointer) && reinterpret_cast<OTE*>(objectPointer)->isPointers();
}

inline bool ObjectMemory::isBytes(Oop objectPointer)
{
	return !isIntegerObject(objectPointer) && reinterpret_cast<OTE*>(objectPointer)->isBytes();
}

#ifdef _DEBUG
inline void ObjectMemory::cantBeIntegerObject(Oop objectPointer)
{
	ASSERT(!isIntegerObject(objectPointer));
}
#endif

///////////////////////////////////////////////////////////////////////////////
// Reference Counting

// MSVC seems to dislike expanding these as inlines, so add some useful macros

__forceinline void ObjectMemory::countUp(Oop objectPointer)
{
	if (!isIntegerObject(objectPointer))
	{
		OTE* ote = reinterpret_cast<OTE*>(objectPointer);
		ote->countUp();
	}
}

inline void ObjectMemory::countDown(Oop rootObjectPointer)
{
	if (!isIntegerObject(rootObjectPointer))
	{
		OTE* rootOTE = reinterpret_cast<OTE*>(rootObjectPointer);
		rootOTE->countDown();
	}
}

#ifdef _DEBUG
	extern bool alwaysReconcileOnAdd;
#endif

__forceinline void __fastcall ObjectMemory::AddOopToZct(Oop oop)
{
	if (!ObjectMemoryIsIntegerObject(oop))
	{
		AddToZct(reinterpret_cast<OTE*>(oop));
	}
}

inline void __fastcall ObjectMemory::AddToZct(TOTE<Object>* ote)
{
	HARDASSERT(m_nZctEntries >= 0);

	// If we don't use a temp here, compiler generates code that needlessly reads the field from memory multiple times
	auto zctEntries = m_nZctEntries;
	m_pZct[zctEntries++] = reinterpret_cast<OTE*>(ote);
	m_nZctEntries = zctEntries;

#ifdef _DEBUG
	if (!alwaysReconcileOnAdd && m_nZctEntries < m_nZctHighWater)
#else
	if (zctEntries < m_nZctHighWater)
#endif
	{
		return;
	}

	ReconcileZct();
}

inline void __fastcall ObjectMemory::AddStackRefToZct(TOTE<Object>* ote)
{
	HARDASSERT(m_nZctEntries >= 0);

	// If we don't use a temp here, compiler generates code that needlessly reads the field from memory multiple times
	auto zctEntries = m_nZctEntries;
	m_pZct[zctEntries++] = reinterpret_cast<OTE*>(ote);
	m_nZctEntries = zctEntries;

	if (zctEntries < m_nZctHighWater)
	{
		return;
	}

	// The Zct overflowed when attempting to repopulate it from the active process stack. We must "grow" it.
	GrowZct();
}


inline bool ObjectMemory::IsReconcilingZct()
{
	return m_bIsReconcilingZct;
}

///////////////////////////////////////////////////////////////////////////////
// Machine Word Access

inline Oop ObjectMemory::fetchPointerOfObject(size_t fieldIndex, PointersOTE* ote)
{
	ASSERT(fieldIndex < ote->pointersSize());
	return ote->m_location->m_fields[fieldIndex];
}

// SmallIntegers and some special objects are not ref. counted, so this saves a little time
inline void __fastcall ObjectMemory::storePointerOfObjectWithUnrefCntdValue(size_t fieldIndex, PointersOTE* ote, Oop nonRefCountedPointer)
{
	ASSERT(fieldIndex < ote->pointersSize());
	VariantObject* obj = ote->m_location;
	countDown(obj->m_fields[fieldIndex]);
	obj->m_fields[fieldIndex] = nonRefCountedPointer;
}

inline void ObjectMemory::storePointerOfObjectWithValue(size_t fieldIndex, PointersOTE* ote, Oop valuePointer)
{
	ASSERT(fieldIndex < ote->pointersSize());
	countUp(valuePointer);
	VariantObject* obj = ote->m_location;
	Oop oldValue = obj->m_fields[fieldIndex];
	obj->m_fields[fieldIndex] = valuePointer;
	countDown(oldValue);
}

// Useful for overwriting structure members
inline void ObjectMemory::storePointerWithValue(Oop& oopSlot, Oop oopValue)
{
	countUp(oopValue);	// Increase the reference count on stored object
	Oop oldValue = oopSlot;
	oopSlot = oopValue;
	countDown(oldValue);
}

// Useful for overwriting structure members
inline Oop ObjectMemory::storePointerWithUnrefCntdValue(Oop& oopSlot, Oop oopValue)
{
	Oop oldValue = oopSlot;
	oopSlot = oopValue;
	countDown(oldValue);
	return oopValue;
}

// Useful for overwriting structure members
inline OTE* ObjectMemory::storePointerWithValue(OTE*& oteSlot, OTE* oteValue)
{
	oteValue->countUp();			// Increase the reference count on stored object
	OTE* oteOldValue = oteSlot;
	oteSlot = oteValue;
	oteOldValue->countDown();
	return oteValue;
}

// Useful for overwriting structure members
inline Oop ObjectMemory::storePointerWithValue(Oop& oopSlot, OTE* oteValue)
{
	// Sadly compiler refuses to inline the count up code, and macro seems to generate
	// bad code(!) so inline by hand
	oteValue->countUp();			// Increase the reference count on stored object
	Oop oldValue = oopSlot;
	oopSlot = reinterpret_cast<Oop>(oteValue);
	countDown(oldValue);
	return oopSlot;
}

inline void ObjectMemory::nilOutPointer(Oop& objectPointer)
{
	countDown(objectPointer);
	objectPointer = reinterpret_cast<Oop>(Pointers.Nil);
}

inline void ObjectMemory::nilOutPointer(OTE*& ote)
{
	ote->countDown();
	ote = reinterpret_cast<OTE*>(Pointers.Nil);
}

///////////////////////////////////////////////////////////////////////////////
// Machine Word Access

inline uintptr_t ObjectMemory::fetchWordOfObject(size_t wordIndex, Oop objectPointer)
{
	PointersOTE* ote = reinterpret_cast<PointersOTE*>(objectPointer);
	VariantObject* obj = ote->m_location;
	return obj->m_fields[wordIndex];
}

inline uintptr_t ObjectMemory::storeWordOfObjectWithValue(size_t wordIndex, Oop objectPointer, uintptr_t valueWord)
{
	PointersOTE* ote = reinterpret_cast<PointersOTE*>(objectPointer);
	VariantObject* obj = ote->m_location;
	return obj->m_fields[wordIndex] = valueWord;
}

///////////////////////////////////////////////////////////////////////////////
// Class Pointer Access

inline BehaviorOTE* ObjectMemory::fetchClassOf(Oop objectPointer)
{
	return !isIntegerObject(objectPointer)
			? reinterpret_cast<OTE*>(objectPointer)->m_oteClass
			: Pointers.ClassSmallInteger;
}

///////////////////////////////////////////////////////////////////////////////

inline bool ObjectMemory::isAContext(const OTE* ote)
{
	const BehaviorOTE* classPointer = ote->m_oteClass;
	return classPointer == Pointers.ClassContext;
}


///////////////////////////////////////////////////////////////////////////////
// Extension methods added during C++ class conversion

inline uint8_t* ObjectMemory::ByteAddressOfObject(Oop& objectPointer)
{
	if (!isIntegerObject(objectPointer))
	{
		OTE* ote = reinterpret_cast<OTE*>(objectPointer);
		return reinterpret_cast<uint8_t*>(ote->m_location);
	}
	else
	{
		return reinterpret_cast<uint8_t*>(&objectPointer);
	}
}

// Answers the address of the first byte of the contents of an object
// For SmallIntegers, which are sometimes used to encode 3 bytes, this is the
// address of the first after the low byte (which holds the SmallInteger flag and
// is therefore unusable). For non-SmallIntegers, it is the address of the first
// byte after the header.
inline uint8_t* ObjectMemory::ByteAddressOfObjectContents(Oop& objectPointer)
{
	if (!isIntegerObject(objectPointer))
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(objectPointer);
		return oteBytes->m_location->m_fields;
	}
	else
	{
		return reinterpret_cast<uint8_t*>(&objectPointer);
	}
}


///////////////////////////////////////////////////////////////////////////////
// Class membership tests

// Answer whether the object with Oop objectPointer is an instance or subinstance
// of the Behavior object with Oop classPointer;
inline bool ObjectMemory::isKindOf(Oop objectPointer, const BehaviorOTE* classPointer)
{
	BehaviorOTE* behaviorPointer = fetchClassOf(objectPointer);
	return inheritsFrom(behaviorPointer, classPointer);
}

///////////////////////////////////////////////////////////////////////////////
// GC Support

inline void ObjectMemory::markObject(OTE* ote)
{
	ote->m_flags.m_mark = m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)].m_mark;
}

// lastPointerOf includes the object header, sizeBitsOf()/mwordSizeOf() does NOT
inline size_t ObjectMemory::lastStrongPointerOf(const OTE* ote)
{
	uint8_t flags = ote->m_ubFlags;
	return (flags & OTEFlags::PointerMask)
		? (flags & WeaknessMask) == OTEFlags::WeakMask 
				? ObjectHeaderSize + ote->m_oteClass->m_location->m_instanceSpec.m_fixedFields 
				: ote->getWordSize()
		: 0;
}


///////////////////////////////////////////////////////////////////////////////
// Memory pool routines

inline ObjectMemory::FixedSizePool& ObjectMemory::spacePoolForSize(size_t objectSize)
{
	auto nPool = (_ROUND2(objectSize, PoolGranularity) - MinObjectSize) / PoolGranularity;
	ASSERT(nPool < MaxPools);
	__assume(nPool < MaxPools);
	ASSERT(nPool * PoolGranularity + (DWORD)MinObjectSize >= objectSize);
	return m_pools[nPool];
}

inline POBJECT ObjectMemory::FixedSizePool::allocate()
{
	if (!m_pFreeChunks)
	{
		moreChunks();
		ASSERT(m_pFreeChunks);
		_ASSERTE(isValid());
	}
	Link* pChunk = m_pFreeChunks;
	m_pFreeChunks = pChunk->next;
	
	#if defined(_DEBUG) //	&& defined(		// JGFoster
		if (_crtDbgFlag & _CRTDBG_CHECK_ALWAYS_DF)
			HARDASSERT(isValid());
		memset(&pChunk->next, 0xCD, sizeof(pChunk->next));
	#endif

	return reinterpret_cast<POBJECT>(pChunk);
}

inline void ObjectMemory::FixedSizePool::deallocate(POBJECT p)
{
	#ifdef _DEBUG
		HARDASSERT(isMyChunk(p));
		if (_crtDbgFlag & _CRTDBG_CHECK_ALWAYS_DF)
		{
			HARDASSERT(isValid());
		}
		memset(p, 0xCD, m_nChunkSize);
	#endif

	Link* pChunk = reinterpret_cast<Link*>(p);
	pChunk->next = m_pFreeChunks;
	m_pFreeChunks = pChunk;
}

inline void ObjectMemory::FixedSizePool::terminate()
{
	#ifdef _DEBUG
		free(m_pages);
		m_pages = 0;
		m_nPages = 0;
	#endif
	m_pFreeChunks = 0;
}

inline size_t ObjectMemory::OTEPool::FreeCount()
{
	#ifdef MEMSTATS
		return m_nFree;
	#else
		size_t nFree = 0;
		OTE* ote = m_pFreeList;
		while (ote)
		{
			nFree++;
			VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
			ote = reinterpret_cast<OTE*>(obj->m_fields[0]);
		}
		return nFree;
	#endif
}

// Answer an OTE from the pool, or NULL if the pool is empty
inline OTE* ObjectMemory::OTEPool::allocate()
{
	OTE* ote = m_pFreeList;
	if (ote)
	{
		#ifdef MEMSTATS
			m_nFree--;
		#endif

		// Should now be considered by GC, so remove free mark
		ote->beAllocated();
		markObject(ote);
		VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
		m_pFreeList = reinterpret_cast<OTE*>(obj->m_fields[0]);

		// New objects are not added to the ZCT until they are pushed on the stack
	}
	else
		_ASSERTE(m_nFree == 0);

	return ote;
}

inline void ObjectMemory::deallocateByteObject(OTE* ote)
{
	ASSERT(ote->isBytes());
	deallocate(ote);
}

inline void ObjectMemory::OTEPool::deallocate(OTE* ote)
{
//	ASSERT(!ObjectMemoryisIntegerObject(Oop(ote)));
//	ASSERT(ote->m_oteClass->getCount() == MAXCOUNT);

	VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
	obj->m_fields[0] = reinterpret_cast<Oop>(m_pFreeList);
	m_pFreeList = ote;

	// Free blocks are marked as free so ignored by GC, but not put on free list
	ote->beFree();

	#ifdef MEMSTATS
/*		if (m_nAllocated == 0)
		{
			Class* cl = ote->m_oteClass->m_location;
			String* st = cl->m_name->m_location;
			TRACE("OTEPool(%p): WARNING deallocated old %s (%p)\n", this, st->m_characters, ote);
		}
		else
			m_nAllocated--;
*/		m_nFree++;
	#endif
}

// Although this looks like a long routine to inline, in fact it is very few machine instructions
inline BytesOTE* ObjectMemory::OTEPool::newByteObject(BehaviorOTE* classPointer, size_t bytes, Spaces space)
{
	BytesOTE* ote = reinterpret_cast<BytesOTE*>(m_pFreeList);
	if (ote)
	{
		#ifdef MEMSTATS
			m_nFree--;
		#endif
		// Remove any immutability flag that might have been left by the last user of the OTE
		ote->beMutable();

		VariantObject* obj = reinterpret_cast<VariantObject*>(ote->m_location);
		m_pFreeList = reinterpret_cast<OTE*>(obj->m_fields[0]);

		// N.B. Must be added to Zct if pushed on stack, otherwise no hope of recovery until next mark-sweep
	}
	else
	{
		// We don't need to ref. count the class, so use the basic instantiation method for byte objects
		ote = ObjectMemory::newByteObject<false, false>(classPointer, bytes);
		#ifdef MEMSTATS
			registerNew(reinterpret_cast<OTE*>(ote), classPointer);
		#endif

		// It MUST be the case that all pooled objects can reside in pool space
		ASSERT(ote->heapSpace() == Spaces::Pools);
	}

	ote->m_flags = m_spaceOTEBits[static_cast<space_t>(space)];
	ASSERT(!ote->isFree());
	ASSERT(!ote->isPointers());
	ASSERT(ote->heapSpace() == space);
	ASSERT(ObjectMemory::hasCurrentMark(ote));
	ASSERT(ote->m_count == 0);
	ASSERT(!ote->isImmutable());

	return ote;
}

// Although this looks like a long routine to inline, in fact it is very few machine instructions
inline PointersOTE* ObjectMemory::OTEPool::newPointerObject(BehaviorOTE* classPointer, size_t pointers, Spaces space)
{
	PointersOTE* ote = reinterpret_cast<PointersOTE*>(m_pFreeList);
	if (ote)
	{
		#ifdef MEMSTATS
			m_nFree--;
		#endif

		VariantObject* obj = static_cast<VariantObject*>(ote->m_location);
		m_pFreeList = reinterpret_cast<OTE*>(obj->m_fields[0]);

		// New objects are not added to the ZCT until they are pushed on the stack

		// Note that it is assumed that the class is sticky and does not require ref. counting
		ote->m_oteClass = classPointer;
	}
	else
	{
		// We don't need to ref. count the class, so use the basic instantiation method for pointer objects
		ote = ObjectMemory::newPointerObject(classPointer, pointers);
		#ifdef MEMSTATS
			registerNew(reinterpret_cast<OTE*>(ote), classPointer);
		#endif

		// It MUST be the case that all pooled objects can reside in pool space
		ASSERT(ote->heapSpace() == Spaces::Pools);
	}

	ote->m_flags = m_spaceOTEBits[static_cast<space_t>(space)];
	ASSERT(!ote->isFree());
	ASSERT(ote->isPointers());
	ASSERT(ote->heapSpace() == space);
	ASSERT(ObjectMemory::hasCurrentMark(ote));
	ASSERT(ote->m_count == 0);

	return ote;
}

template <class T> TOTE<T>* __fastcall ObjectMemory::newUninitializedNullTermObject(size_t byteSize)
{
	OTE* ote;
	allocObject(byteSize + NULLTERMSIZE + SizeOfPointers(0), ote);
	ote->m_oteClass = reinterpret_cast<BehaviorOTE*>(Pointers.pointers[T::PointersIndex - 1]);
	ASSERT((OTE*)(ote->m_oteClass) != Pointers.Nil);
	ote->beNullTerminated();
	return reinterpret_cast<TOTE<T>*>(ote);
}

inline BytesOTE* __fastcall ObjectMemory::newByteObject(BehaviorOTE* classPointer, size_t cBytes, const void* pBytes)
{
	ASSERT((OTE*)classPointer != Pointers.Nil);
	ASSERT(!classPointer->m_location->m_instanceSpec.m_nullTerminated);
	BytesOTE* oteBytes = newByteObject<false, false>(classPointer, cBytes);
	memcpy(oteBytes->m_location->m_fields, pBytes, cBytes);
	return oteBytes;
}

#define NumPools MaxPools
#define MaxSizeOfPoolObject PoolObjectSizeLimit

inline bool ObjectMemory::IsConstObj(void* ptr)
{
	return ptr >= m_pConstObjs && ptr < static_cast<uint8_t*>(m_pConstObjs)+dwPageSize;
}

inline hash_t ObjectMemory::nextIdentityHash()
{
	uint32_t seed = m_nNextIdHash;
	hash_t y = LOWORD(seed);
	hash_t x = HIWORD(seed);
	// The 16-bit masks make no difference to the code generated in a release build (they are redundant),
	// but prevent a debug report of loss of bits when casting to a smaller sized int in a debug build
	hash_t t = x ^ static_cast<hash_t>((x << 5) & 0xffff);
	m_nNextIdHash = y << 16 | ((y ^ (y >> 1)) ^ (t ^ (t >> 3)));
	return static_cast<uint16_t>(m_nNextIdHash & 0xffff);
}

///////////////////////////////////////////////////////////////////////////////
// ST::Array allocators

inline ArrayOTE* ST::Array::New(size_t size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newPointerObject(Pointers.ClassArray, size));
}

inline ArrayOTE* ST::Array::NewUninitialized(size_t size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newUninitializedPointerObject(Pointers.ClassArray, size));
}

///////////////////////////////////////////////////////////////////////////////

#include "STClassDesc.h"

__forceinline ByteElementSize ObjectMemory::GetBytesElementSize(BytesOTE * ote)
{
	ASSERT(ote->isBytes());

	int shift = 0;
	// Null-terminated classes (strings) have an encoding size
	// TODO: Should be using revised InstanceSpec here, not string encoding
	if (ote->m_flags.m_weakOrZ)
	{
		shift = (int)reinterpret_cast<const StringClass*>(ote->m_oteClass->m_location)->Encoding << 1;
	}
	return static_cast<ByteElementSize>((0x90 >> shift) & 0x3);
}
