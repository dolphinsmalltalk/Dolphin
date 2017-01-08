/******************************************************************************

	File: ObjMem.h

	Description:

	Object Memory management class declarations for Dolphin Smalltalk
	(see the "Blue Book" specification)

******************************************************************************/
#pragma once

#include "Ist.h"
#include <stdio.h>
#include "STObject.h"
#include "STVirtualObject.h"
#include "STString.h"
#include "STBehavior.h"
#include "STMemoryManager.h"
#include "ImageHeader.h"

using namespace ST;

#define PRIVATE_HEAP
//#undef PRIVATE_HEAP

// Dolphin Smallblock heap separate from C-runtime sbh
#include "sbheap.h"

#if defined(_DEBUG)
	#define MEMSTATS
#endif

// We don't want inline expansion of recursive functions thankyou
//#pragma inline_depth(32)
//#pragma inline_recursion(off)

#define MinSmallInteger -0x40000000
#define MaxSmallInteger 0x3FFFFFFF

#define PoolGranularity 8

class ibinstream;
class obinstream;

#define pointerFromIndex(index)	(m_pOT+int(index))

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
	static Oop fetchPointerOfObject(MWORD fieldIndex, PointersOTE* ote);
	static Oop storePointerOfObjectWithValue(MWORD fieldIndex, PointersOTE* ote, Oop valuePointer);
	static Oop storePointerWithValue(Oop& oopSlot, Oop oopValue);
	static OTE* storePointerWithValue(OTE*& oteSlot, OTE* oteValue);
	static Oop storePointerWithValue(Oop& oopSlot, OTE* oteValue);
	static Oop nilOutPointer(Oop& objectPointer);
	static OTE* nilOutPointer(OTE*& ote);

	// Use these versions to store values which are not themselves ref. counted
	static Oop storePointerWithUnrefCntdValue(Oop&, Oop);
	static void __fastcall storePointerOfObjectWithUnrefCntdValue(MWORD fieldIndex, PointersOTE* ote, Oop value);

	// Word Access
	static MWORD fetchWordOfObject(MWORD fieldIndex, Oop objectPointer);
	static MWORD storeWordOfObjectWithValue(MWORD fieldIndex, Oop objectPointer, MWORD valueWord);

	// Formerly Private reference count management
	static void  __fastcall countUp(Oop objectPointer);
	static void __fastcall countDown(Oop rootObjectPointer);
	static ArrayOTE* __stdcall referencesTo(Oop referencedObjectPointer, bool includeWeakRefs);
	static ArrayOTE* __fastcall instancesOf(BehaviorOTE* classPointer);
	static ArrayOTE* __fastcall subinstancesOf(BehaviorOTE* classPointer);
	static ArrayOTE* __fastcall ObjectMemory::instanceCounts(ArrayOTE* oteClasses);
	static void deallocateByteObject(OTE*);

	// Class pointer access
	static BehaviorOTE* fetchClassOf(Oop objectPointer);

	// Use CRT Small block heap OR pool if size <= this threshold
	enum { MaxSmallObjectSize = 0x3f8 };
	enum { PoolObjectSizeLimit = 144 };
	enum { MinObjectSize = /*sizeof(Object)+*/PoolGranularity };
	enum { MaxPools = (PoolObjectSizeLimit - MinObjectSize) / PoolGranularity + 1 };

	static VirtualOTE* __fastcall newVirtualObject(BehaviorOTE* classPointer, MWORD initialSize, MWORD maxSize);
	static PointersOTE* __fastcall newPointerObject(BehaviorOTE* classPointer);
	static PointersOTE* __fastcall newPointerObject(BehaviorOTE* classPointer, MWORD instanceSize);
	static PointersOTE* __fastcall newUninitializedPointerObject(BehaviorOTE* classPointer, MWORD instanceSize);
	static BytesOTE* __fastcall newByteObject(BehaviorOTE* classPointer, MWORD instanceByteSize);
	static BytesOTE* __fastcall newUninitializedByteObject(BehaviorOTE* classPointer, MWORD instanceByteSize);
	static BytesOTE* __fastcall newByteObject(BehaviorOTE* classPointer, MWORD instanceByteSize, const void* pBytes);

	// Resizing objects (RAW - assumes no. ref counting to be done)
	static POBJECT basicResize(OTE* ote, MWORD byteSize /*should include header*/, int extra);
	static POBJECT resizeVirtual(OTE* ote, MWORD byteSize /*ditto*/);

	// More useful (and safe) entry points from Interpreter
	static VariantObject* resize(PointersOTE* objectPointer, MWORD newPointers, bool bRefCount);
	static VariantByteObject* resize(BytesOTE* objectPointer, MWORD newBytes);

	static OTE* __fastcall shallowCopy(OTE* ote);
	static BytesOTE* __fastcall shallowCopy(BytesOTE* ote);
	static PointersOTE* __fastcall shallowCopy(PointersOTE* ote);

	// Pointer Swapping
	static void __fastcall oneWayBecome(OTE* firstPointer, OTE* secondPointer);

	// GC support
	static SMALLINTEGER OopsLeft();
	static int __fastcall OopsUsed();
	static unsigned GetOTSize();
	static size_t compact(Oop* const sp);
	static void HeapCompact();
	static BYTE currentMark();

	// Used by Interpreter and Compiler to update any Oops they hold following a compact
	template <class T> static void compactOop(TOTE<T>*& ote)
	{
		// If OTE is marked as free, then it must have been moved during compaction. Otherwise we can leave alone
		if (ote->isFree())
		{
			ote = (TOTE<T>*)(ote->m_location);
			HARDASSERT(!ote->isFree());
			HARDASSERT((char*)ote >= (char*)m_pOT && (char*)ote < (char*)m_pFreePointerList);
		}
	}

	static OTE* PointerFromIndex(int index)
	{
		return pointerFromIndex(index);
	}

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
	static bool __fastcall inheritsFrom(const BehaviorOTE* behaviorPointer, const BehaviorOTE* classPointer);
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
	static BYTE* ByteAddressOfObject(Oop& objectPointer);			// pointer to header (or SmallInteger)
	static BYTE* ByteAddressOfObjectContents(Oop& objectPointer);	// pointer to body (or SmallInteger)

	// Recalc. ref. counts, perform consistency check, and clean up
	static Oop* rootObjectPointers[];

	enum GCFlags { GCNormal, GCNoWeakness };
	static void asyncGC(DWORD flags, Oop* const sp);

	static void markObject(OTE* ote);
	static void MarkObjectsAccessibleFromRoot(OTE* ote);

	static void finalize(OTE* ote);

	static void addVMRefs();

#ifdef _DEBUG
	// Recalc and consistency check
	static void checkReferences();
	static void addRefsFrom(OTE* ote);
	static void checkPools();
	static void checkStackRefs(Oop* const sp);
	static bool isValidOop(Oop);
#endif

#ifdef MEMSTATS
	static void DumpStats();
	static void CheckPoint();
#endif

	static int __stdcall SaveImageFile(const char* fileName, bool bBackup, int nCompressionLevel, unsigned nMaxObjects);
	static HRESULT __stdcall LoadImage(const char* szImageName, LPVOID imageData, UINT imageSize, bool bIsDevSys);

	static int gpFaultExceptionFilter(LPEXCEPTION_POINTERS pExInfo);

	static MemoryManager* memoryManager();

public:
	enum {
		OTMinHeadroom = 16384,
		OTDefaultSize = 65536,
		OTDefaultMax = 24 * 1024 * 1024,
		OTMaxLimit = 64 * 1024 * 1024
	};

	enum { registryIndex, FirstBuiltInIdx };

	/***************************************************************************************
	* N.B. If inserting new fixed Oops, must also update the FIRSTCHAROFFSET in ISTASM.INC
	* or will get garbage DNU very early in boot
	/***************************************************************************************/
	enum {
		nilOOPIndex = FirstBuiltInIdx,
		trueOOPIndex,
		falseOOPIndex,
		emptyStringOOPIndex,
		delimStringOOPIndex,
		emptyArrayOOPIndex,
		FirstCharacterIdx
	};
	enum {
		NumCharacters = 256,
		NumPermanent = FirstCharacterIdx + NumCharacters
	};
	enum { OTBase = NumPermanent };

	class OTEPool
	{
	public:
		OTE*	m_pFreeList;

#ifdef MEMSTATS
		DWORD	m_nFree;
		DWORD	m_nAllocated;

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

		DWORD FreeCount();

		void clear();

		OTE* allocate();
		void deallocate(OTE* ote);

		BytesOTE* newByteObject(BehaviorOTE* classPointer, unsigned bytes, OTEFlags::Spaces space);
		PointersOTE* newPointerObject(BehaviorOTE* classPointer, unsigned pointers, OTEFlags::Spaces space);

		void terminate()
		{
			// We don't actually free the content, as it is released more efficiently by
			// deleting all the heap pages and OT en-masse.
			m_pFreeList = 0;
		}
	};

	friend class OTEPool;

private:
	///////////////////////////////////////////////////////////////////////////
	// "Zero Count Table" (ZCT). Holds a ref to all objects that have been
	// newly allocated, or who's count has dropped to zero

	static OTE** m_pZct;
	static int m_nZctEntries;		// Current no. of Zct entries
	static int m_nZctHighWater;		// High water mark at which ZCT reconciled
	static bool m_bIsReconcilingZct;

	static HRESULT InitializeZct();
	static bool IsReconcilingZct();
	static void GrowZct();
	static void ShrinkZct();

public:
	template <typename T> static void __fastcall AddToZct(TOTE<T>* ote)
	{
		HARDASSERT(m_nZctEntries >= 0);

		m_pZct[m_nZctEntries++] = reinterpret_cast<OTE*>(ote);

#ifdef _DEBUG
		if (alwaysReconcileOnAdd || m_nZctEntries >= m_nZctHighWater)
#else
		if (m_nZctEntries >= m_nZctHighWater)
#endif
		{
			if (m_bIsReconcilingZct)
			{
				// Uh oh, the Zct overflowed when attempting to repopulate it from the active process
				// stack. We must "grow" it.
				GrowZct();
			}
			else
				ReconcileZct();
		}
	}

	static void __fastcall AddToZct(Oop);

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
		FixedSizePool(unsigned nChunkSize=MinObjectSize);

		POBJECT allocate();
		void deallocate(POBJECT pChunk);
		
		void setSize(unsigned nChunkSize);
		void terminate();

	#ifdef _DEBUG
		bool isMyChunk(void* pChunk);
		bool isValid();
	#endif

	#ifdef MEMSTATS
		int getPages() { return m_nPages; }
		int getFree();
		void**		m_pages;
		unsigned	m_nPages;
	#endif

	int getSize() { return m_nChunkSize; }

	private:
		void moreChunks();
		static void morePages();
		static BYTE* allocatePage();

	public:
		static void Initialize();
		static void Terminate();

	public:
		struct		Link	{ Link* next; };

	private:

		Link*		m_pFreeChunks;
		unsigned	m_nChunkSize;

		static	Link*		m_pFreePages;
		static	void**		m_pAllocations;
	public:
		static	unsigned	m_nAllocations;
	};

	// Object Table entry access routines
	static OTE& ot(Oop objectPointer);

	static OTE* headOfFreePointerListPut(OTE* ote);
	static OTE* toFreePointerListAdd(OTE* ote);

	static HRESULT __stdcall allocateOT(unsigned reserve, unsigned commit);

	// Answer the index of the last occuppied OT entry
	static unsigned __stdcall lastOTEntry();

	static OTE* __fastcall allocateOop(POBJECT pLocation);
	static hash_t nextIdentityHash();

	// Memory allocators - these are very thin layers of C/Win32 heap
	static void freeChunk(POBJECT pChunk);
	static void freeSmallChunk(POBJECT pObj, MWORD size);
	static POBJECT reallocChunk(POBJECT pChunk, MWORD newChunkSize);
#ifdef _DEBUG
	static MWORD chunkSize(void* pChunk);
#endif

	static POBJECT allocSmallChunk(MWORD chunkSize);
	static POBJECT allocChunk(MWORD chunkSize);
	static POBJECT allocObject(MWORD objectSize, OTE*& ote);
	static POBJECT allocLargeObject(MWORD objectSize, OTE*& ote);

	static FixedSizePool& spacePoolForSize(MWORD objectSize);

	static void decRefs(OTE* ote);
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
	static BYTE WeaknessMask;
	static MWORD lastStrongPointerOf(OTE* ote);
	static void reclaimInaccessibleObjects(DWORD flags);
	static void markObjectsAccessibleFrom(OTE* ote);
	static void ClearGCInfo();
	static OTEFlags nextMark();

	static void compactObject(OTE* ote);

	static Oop corpsePointer();

private: 
	static void scheduleFinalization();
	static void checkHospiceCrisis();


private:
	// Const obj support - very crude at present

	static void* m_pConstObjs;
	static BYTE* MakeObjConst(OTE* ote, BYTE*);
public:
	static DWORD __stdcall ProtectConstSpace(DWORD dwNewProtect);
	static bool IsConstObj(void* ptr);

private:
	///////////////////////////////////////////////////////////////////////////
	// Image Load/Save

	static const char ISTHDRTYPE[4];

	static bool __stdcall SavePointers(obinstream& imageFile, const ImageHeader*);
	static bool __stdcall SaveObjectTable(obinstream& imageFile, const ImageHeader*);
	static bool __stdcall SaveObjects(obinstream& imageFile, const ImageHeader*);
	static bool __stdcall SaveImage(obinstream& imageFile, const ImageHeader*, int);

	static void ShowExpiryDialog();

	static HRESULT __stdcall LoadImage(ibinstream& imageFile, ImageHeader*);

	static OTE* __fastcall FixupPointer(OTE* pSavedPointer, OTE* pSavedBase);
	static HRESULT __stdcall LoadPointers(ibinstream& imageFile, const ImageHeader*, size_t&);
	static HRESULT __stdcall LoadObjectTable(ibinstream& imageFile, const ImageHeader*);
	static HRESULT __stdcall LoadObjects(ibinstream& imageFile, const ImageHeader*, size_t&);
	static HRESULT __stdcall LoadObject(OTE* ote, ibinstream& imageFile, const ImageHeader*, size_t&);
	static void __stdcall FixupObject(OTE* ote, MWORD* oldLocation, const ImageHeader*);
	static void __stdcall PostLoadFix();

public:			// Public Data

	enum { dwOopsPerPage = dwPageSize/sizeof(Oop) };

	static DWORD m_imageVersionMajor;	// MS part of image version number
	static DWORD m_imageVersionMinor;	// LS part of image version number

private:		// Private Data


	static HANDLE m_hHeap;
	enum { HEAPINITPAGES = 2 };

	static DWORD	m_nNextIdHash;					// Next identity hash value to use

	// These are to be used for collecting statistics in future
	static unsigned	m_nObjectsAllocated;
	static unsigned m_nObjectsFreed;
	static unsigned m_nBytesAllocated;
	static unsigned m_nBytesFreed;
#ifdef _DEBUG
	static int		m_nFreeOTEs;
	static int		CountFreeOTEs();
#endif

	static struct OTEFlags m_spaceOTEBits[OTEFlags::NumSpaces];

	static unsigned m_nOTMax;
	static unsigned m_nOTSize;						// The size (in Oops, not bytes) of the object table
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
MWORD* __stdcall AllocateVirtualSpace(MWORD maxBytes, MWORD initialBytes);


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
#define SizeOfPointers(N) (((N)+ObjectHeaderSize)*sizeof(MWORD))

inline void ObjectMemory::decRefs(OTE* ote)
{
	ASSERT(!isIntegerObject(ote));
	ote->decRefs();
}

inline void ObjectMemory::decRefs(Oop oop)
{
	if (!isIntegerObject(oop))
		reinterpret_cast<OTE*>(oop)->decRefs();
}

inline unsigned ObjectMemory::GetOTSize()
{
	return m_nOTSize;
}

///////////////////////////////////////////////////////////////////////////////
//	Inlines for Public interface used by Interpreter

inline MemoryManager* ObjectMemory::memoryManager()
{
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

inline void ObjectMemory::countUp(Oop objectPointer)
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

inline void __fastcall ObjectMemory::AddToZct(Oop oop)
{
	if (!ObjectMemoryIsIntegerObject(oop))
	{
		AddToZct(reinterpret_cast<OTE*>(oop));
	}
}

inline bool ObjectMemory::IsReconcilingZct()
{
	return m_bIsReconcilingZct;
}

///////////////////////////////////////////////////////////////////////////////
// Machine Word Access

inline Oop ObjectMemory::fetchPointerOfObject(MWORD fieldIndex, PointersOTE* ote)
{
	ASSERT(fieldIndex < ote->pointersSize());
	return ote->m_location->m_fields[fieldIndex];
}

// SmallIntegers and some special objects are not ref. counted, so this saves a little time
inline void __fastcall ObjectMemory::storePointerOfObjectWithUnrefCntdValue(MWORD fieldIndex, PointersOTE* ote, Oop nonRefCountedPointer)
{
	ASSERT(fieldIndex < ote->pointersSize());
	VariantObject* obj = ote->m_location;
	countDown(obj->m_fields[fieldIndex]);
	obj->m_fields[fieldIndex] = nonRefCountedPointer;
}

inline Oop ObjectMemory::storePointerOfObjectWithValue(MWORD fieldIndex, PointersOTE* ote, Oop valuePointer)
{
	ASSERT(fieldIndex < ote->pointersSize());
	countUp(valuePointer);
	VariantObject* obj = ote->m_location;
	countDown(obj->m_fields[fieldIndex]);
	return obj->m_fields[fieldIndex] = valuePointer;
}

// Useful for overwriting structure members
inline Oop ObjectMemory::storePointerWithValue(Oop& oopSlot, Oop oopValue)
{
	// Sadly compiler refuses to inline the count up code, and macro seems to generate
	// bad code(!) so inline by hand
	countUp(oopValue);	// Increase the reference count on stored object
	countDown(oopSlot);
	return oopSlot = oopValue;
}

// Useful for overwriting structure members
inline Oop ObjectMemory::storePointerWithUnrefCntdValue(Oop& oopSlot, Oop oopValue)
{
	// Sadly compiler refuses to inline the count up code, and macro seems to generate
	// bad code(!) so inline by hand
	countDown(oopSlot);
	return oopSlot = oopValue;
}

// Useful for overwriting structure members
inline OTE* ObjectMemory::storePointerWithValue(OTE*& oteSlot, OTE* oteValue)
{
	// Sadly compiler refuses to inline the count up code, and macro seems to generate
	// bad code(!) so inline by hand
	oteValue->countUp();			// Increase the reference count on stored object
	oteSlot->countDown();
	return (oteSlot = oteValue);
}

// Useful for overwriting structure members
inline Oop ObjectMemory::storePointerWithValue(Oop& oopSlot, OTE* oteValue)
{
	// Sadly compiler refuses to inline the count up code, and macro seems to generate
	// bad code(!) so inline by hand
	oteValue->countUp();			// Increase the reference count on stored object
	countDown(oopSlot);
	return oopSlot = Oop(oteValue);
}

inline Oop ObjectMemory::nilOutPointer(Oop& objectPointer)
{
	countDown(objectPointer);
	return objectPointer = Oop(Pointers.Nil);
}

inline OTE* ObjectMemory::nilOutPointer(OTE*& ote)
{
	ote->countDown();
	return ote = Pointers.Nil;
}

///////////////////////////////////////////////////////////////////////////////
// Machine Word Access

inline MWORD ObjectMemory::fetchWordOfObject(MWORD wordIndex, Oop objectPointer)
{
	PointersOTE* ote = reinterpret_cast<PointersOTE*>(objectPointer);
	VariantObject* obj = ote->m_location;
	return obj->m_fields[wordIndex];
}

inline MWORD ObjectMemory::storeWordOfObjectWithValue(MWORD wordIndex, Oop objectPointer, MWORD valueWord)
{
	PointersOTE* ote = reinterpret_cast<PointersOTE*>(objectPointer);
	VariantObject* obj = ote->m_location;
	return obj->m_fields[wordIndex] = valueWord;
}

///////////////////////////////////////////////////////////////////////////////
// Class Pointer Access

inline BehaviorOTE* ObjectMemory::fetchClassOf(Oop objectPointer)
{
	return isIntegerObject(objectPointer) 
			? Pointers.ClassSmallInteger 
			: reinterpret_cast<OTE*>(objectPointer)->m_oteClass;
}

///////////////////////////////////////////////////////////////////////////////
// Does an object have the current GC mark?

__forceinline BYTE ObjectMemory::currentMark()
{
	return m_spaceOTEBits[OTEFlags::NormalSpace].m_mark;
}

inline bool ObjectMemory::isAContext(const OTE* ote)
{
	const BehaviorOTE* classPointer = ote->m_oteClass;
	return classPointer == Pointers.ClassContext;
}


///////////////////////////////////////////////////////////////////////////////
// Extension methods added during C++ class conversion

inline BYTE* ObjectMemory::ByteAddressOfObject(Oop& objectPointer)
{
	if (isIntegerObject(objectPointer))
	{
		return reinterpret_cast<BYTE*>(&objectPointer);
	}
	else
	{
		OTE* ote = reinterpret_cast<OTE*>(objectPointer);
		return reinterpret_cast<BYTE*>(ote->m_location);
	}
}

// Answers the address of the first byte of the contents of an object
// For SmallIntegers, which are sometimes used to encode 3 bytes, this is the
// address of the first after the low byte (which holds the SmallInteger flag and
// is therefore unusable). For non-SmallIntegers, it is the address of the first
// byte after the header.
inline BYTE* ObjectMemory::ByteAddressOfObjectContents(Oop& objectPointer)
{
	if (isIntegerObject(objectPointer))
	{
		return reinterpret_cast<BYTE*>(&objectPointer);
	}
	else
	{
		BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(objectPointer);
		return oteBytes->m_location->m_fields;
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
	// TODO: Check code generated here is optimal
	ote->mark();
	//ote->m_flags.m_mark = m_spaceOTEBits[OTEFlags::NormalSpace].m_mark;
}

// lastPointerOf includes the object header, sizeBitsOf()/mwordSizeOf() does NOT
inline MWORD ObjectMemory::lastStrongPointerOf(OTE* ote)
{
	BYTE flags = ote->getFlagsByte();
	return (flags & OTE::PointerMask)
		? (flags & WeaknessMask) == OTE::WeakMask 
				? ObjectHeaderSize + ote->m_oteClass->m_location->fixedFields() 
				: ote->getWordSize()
		: 0;
}


///////////////////////////////////////////////////////////////////////////////
// Memory pool routines

inline ObjectMemory::FixedSizePool& ObjectMemory::spacePoolForSize(MWORD objectSize)
{
	int nPool = (_ROUND2(objectSize, PoolGranularity) - MinObjectSize) / PoolGranularity;
	ASSERT(nPool < MaxPools);
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

inline DWORD ObjectMemory::OTEPool::FreeCount()
{
	#ifdef MEMSTATS
		return m_nFree;
	#else
		DWORD nFree = 0;
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
		ote->mark();
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
inline BytesOTE* ObjectMemory::OTEPool::newByteObject(BehaviorOTE* classPointer, unsigned bytes, OTEFlags::Spaces space)
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
		ote = ObjectMemory::newUninitializedByteObject(classPointer, bytes);
		#ifdef MEMSTATS
			registerNew(reinterpret_cast<OTE*>(ote), classPointer);
		#endif

		// It MUST be the case that all pooled objects can reside in pool space
		ASSERT(ote->heapSpace() == OTEFlags::PoolSpace);
	}

	ote->m_flags = m_spaceOTEBits[space];
	ASSERT(!ote->isFree());
	ASSERT(!ote->isPointers());
	ASSERT(ote->heapSpace() == space);
	ASSERT(ote->hasCurrentMark());
	ASSERT(ote->m_count == 0);
	ASSERT(!ote->isImmutable());

	return ote;
}

// Although this looks like a long routine to inline, in fact it is very few machine instructions
inline PointersOTE* ObjectMemory::OTEPool::newPointerObject(BehaviorOTE* classPointer, unsigned pointers, OTEFlags::Spaces space)
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
		ASSERT(ote->heapSpace() == OTEFlags::PoolSpace);
	}

	ote->m_flags = m_spaceOTEBits[space];
	ASSERT(!ote->isFree());
	ASSERT(ote->isPointers());
	ASSERT(ote->heapSpace() == space);
	ASSERT(ote->hasCurrentMark());
	ASSERT(ote->m_count == 0);

	return ote;
}

inline BytesOTE* __fastcall ObjectMemory::newByteObject(BehaviorOTE* classPointer, MWORD cBytes, const void* pBytes)
{
	BytesOTE* oteBytes = newUninitializedByteObject(classPointer, cBytes);
	memcpy(oteBytes->m_location->m_fields, pBytes, cBytes);
	return oteBytes;
}

#define NumPools MaxPools
#define MaxSizeOfPoolObject PoolObjectSizeLimit

inline bool ObjectMemory::IsConstObj(void* ptr)
{
	return ptr >= m_pConstObjs && ptr < static_cast<BYTE*>(m_pConstObjs)+dwPageSize;
}

///////////////////////////////////////////////////////////////////////////////
// ST::Array allocators

inline ArrayOTE* ST::Array::New(unsigned size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newPointerObject(Pointers.ClassArray, size));
}

inline ArrayOTE* ST::Array::NewUninitialized(unsigned size)
{
	return reinterpret_cast<ArrayOTE*>(ObjectMemory::newUninitializedPointerObject(Pointers.ClassArray, size));
}

