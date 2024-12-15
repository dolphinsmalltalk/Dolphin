/******************************************************************************

	File: GC.cpp

	Description:

	Object Memory management class garbage collection routines

	N.B. Some functions are inlined in this module as they are auto-inlined by
	the compiler anyway, and prepending the qualifier tells the compiler that
	it does not need an out-of-line copy for calls from outside the module (there
	aren't any) thus saving a little code space for these private functions.

******************************************************************************/

#include "Ist.h"

#pragma code_seg(GC_SEG)

#include "ObjMem.h"
#include "Interprt.h"

// Smalltalk classes
#include "STBehavior.h"		// We need to check class flags such as indexability, etc,
#include "STArray.h"		// VMPointers (roots) are stored in an Array
#include "STProcess.h"

#define _CRTBLD
#include "winheap.h"
#undef _CRTBLD

// The pointers in const space
extern VMPointers _Pointers;

#ifdef _DEBUG
	#define VERBOSEGC
	static bool ignoreRefCountErrors = true;	// JGFoster edited to get past error
#endif

#ifdef VERBOSEGC
	#pragma warning (disable : 4786)
	#include <yvals.h>
	#undef _HAS_EXCEPTIONS
	#include <map>
	typedef std::map<BehaviorOTE*, int> MAPCLASSOTE2INT;
#endif

uint8_t ObjectMemory::WeaknessMask = static_cast<uint8_t>(OTEFlags::WeakOrZMask);

void ObjectMemory::ClearGCInfo()
{
}

///////////////////////////////////////////////////////////////////////////////

inline Oop ObjectMemory::corpsePointer()
{
	return _Pointers.Corpse;
}

void ObjectMemory::MarkObjectsAccessibleFromRoot(OTE* rootOTE)
{
	uint8_t curMark = 	*reinterpret_cast<uint8_t*>(&m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)]);
	if ((rootOTE->m_ubFlags ^ curMark) & OTEFlags::MarkMask)	// Already accessible from roots of world?
		markObjectsAccessibleFrom(rootOTE);
}

void ObjectMemory::markObjectsAccessibleFrom(OTE* ote)
{
	HARDASSERT(!isIntegerObject(ote));
	//HARDASSERT(!hasCurrentMark(ote));
	
	// First toggle the mark bit to the new mark
	markObject(ote);

	uint8_t curMark = 	*reinterpret_cast<uint8_t*>(&m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)]);

	// The class is always visited, but is now in the OTE which means we may not need
	// to visit the object body at all
	BehaviorOTE* oteClass = ote->m_oteClass;
	if ((oteClass->m_ubFlags ^ curMark) & OTEFlags::MarkMask)	// Already accessible from roots of world?
		markObjectsAccessibleFrom(reinterpret_cast<POTE>(oteClass));

	const size_t lastPointer = lastStrongPointerOf(ote);
	Oop* pFields = reinterpret_cast<Oop*>(ote->m_location);
	for (auto i = ObjectHeaderSize; i < lastPointer; i++)
	{
		// This will get nicely optimised by the Compiler
		Oop fieldPointer = pFields[i];
		// Perform tests to see if marking necessary to save a call
		// We don't need to visit SmallIntegers and objects we've already visited
		if (!isIntegerObject(fieldPointer))
		{
			OTE* oteField = reinterpret_cast<OTE*>(fieldPointer);

			// By Xoring current mark mask with existing one we should only get > 1 if they
			// don't actually match, and therefore we haven't visited here yet.
			if ((oteField->m_ubFlags ^ curMark) & OTEFlags::MarkMask)	// Already accessible from roots of world?
				markObjectsAccessibleFrom(oteField);
		}
	}
}

OTEFlags ObjectMemory::nextMark()
{
	OTEFlags oldMark = m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)];
	// Toggle the "visited" mark - all objects will then have previous mark
	BOOL newMark = oldMark.m_mark ? FALSE : TRUE;
	for (auto i=0u;i<OTEFlags::NumSpaces;i++)
		m_spaceOTEBits[i].m_mark = newMark;
	return oldMark;
}

void ObjectMemory::asyncGC(uintptr_t gcFlags, Oop* const sp)
{
	EmptyZct(sp);
	reclaimInaccessibleObjects(gcFlags);
	PopulateZct(sp);

	Interpreter::scheduleFinalization();
}

void ObjectMemory::reclaimInaccessibleObjects(uintptr_t gcFlags)
{
	// Assign flags to static, as we use some deeply recursive routines
	// and we don't want to pass down to the depths. When we want to turn off
	// weakness we mask with the free bit, which obviously can't be set on any
	// live object so the test will always fail
	WeaknessMask = static_cast<uint8_t>(gcFlags & GCNoWeakness ? 0 : OTEFlags::WeakOrZMask);

	// Get the Oop to use for corpses from the interpreter (it's a global)
	Oop corpse = corpsePointer();
	HARDASSERT(!isIntegerObject(corpse));


	if (corpse == Oop(_Pointers.Nil))
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"GC: WARNING, attempted GC before Corpse registered." << std::endl;
		return;	// Refuse to garbage collect if the corpse is invalid
	}
	
	#ifdef _DEBUG
		checkReferences();
	#endif

	#ifdef VERBOSEGC
		MAPCLASSOTE2INT lossMap;
	#endif

	// Move to the "next" GC mark (really a toggle). We'll need the old mark to rescue objects
	OTEFlags oldMark = nextMark();
	
	// Starting from the roots of the world, recursively visit all objects which are still reachable
	// along a chain of strong references. We may later need to 'rescue' some unmarked objects
	// reachable from dying objects which are queued for finalization. Should these rescued objects
	// also be finalizable, then this will delay their finalization until their parent has disappeared.
	markObjectsAccessibleFrom(pointerFromIndex(0));
	Interpreter::MarkRoots();

	// Every object reachable from the roots of the world will now have the current mark bit,
	// any objects with the old mark bit can be discarded.

	// Now locate all the unmarked objects, and visit any object referenced from finalizable
	// unmarked objects. Also nil the corpses of any weak objects, and queue them for finalization
	size_t	nMaxUnmarked = 0, nUnmarked = 0;
	OTE**		pUnmarked = 0;

	const OTE* pEnd = m_pOT+m_nOTSize;							// Loop invariant
	const uint8_t curMark = 	*reinterpret_cast<uint8_t*>(&m_spaceOTEBits[static_cast<space_t>(Spaces::Normal)]);
	for (OTE* ote=m_pOT+OTBase; ote < pEnd; ote++)
	{
		uint8_t oteFlags = ote->m_ubFlags;
		if (!(oteFlags & OTEFlags::FreeMask))								// Already free'd?
		{
			// By Xoring current mark mask with existing one we should only get > 1 if they
			// don't actually match 
			if ((oteFlags ^ curMark) & OTEFlags::MarkMask)			// Accessible from roots of world?
			{
				// Inaccessible object found, if finalizable, then we need to rescue it by
				// visiting all the objects it references
				if (nUnmarked == nMaxUnmarked)
				{
					if (nMaxUnmarked == 0)
						nMaxUnmarked = 512;
					else
						nMaxUnmarked = nMaxUnmarked << 1;
					pUnmarked = static_cast<OTE**>(reallocChunk(pUnmarked, nMaxUnmarked*sizeof(OTE*)));
					if (pUnmarked == nullptr)
					{
						::RaiseException(STATUS_NO_MEMORY, EXCEPTION_NONCONTINUABLE, 0, nullptr);
					}
				}
				pUnmarked[nUnmarked++] = ote;

				// If the object is finalizable, rescue it by visiting all objects accessible from it
				if (oteFlags & OTEFlags::FinalizeMask)
				{
					markObjectsAccessibleFrom(ote);
					// We must ensure that if a finalizable object is circularly referenced, directly
					// or indirectly, that we don't prevent it ever being finalized.
					ote->setMark(oldMark.m_mark);
				}
			}
		}
	}

	// Another scan to nil out weak references. This has to be a separate scan from the finalization
	// candidate scan so that we don't end up nilling out weak references to objects that are accessible
	// from finalizable objects
	size_t queuedForBereavement=0;
	if (WeaknessMask != 0)
	{
		for (OTE* ote = m_pOT + OTBase; ote < pEnd; ote++)
		{
			const uint8_t oteFlags = ote->m_ubFlags;
			// Is it a non-free'd, weak pointer object, and does it either have the current mark or is finalizable?
			// If so it's losses are replaced with references to the corpse object, and it may be sent a loss notification
			if (((oteFlags & (OTEFlags::WeakMask | OTEFlags::FreeMask)) == OTEFlags::WeakMask)
				&& (((oteFlags ^ curMark) & (OTEFlags::MarkMask | OTEFlags::FinalizeMask)) != OTEFlags::MarkMask))
			{
				SmallInteger losses = 0;
				PointersOTE* otePointers = reinterpret_cast<PointersOTE*>(ote);
				const size_t size = otePointers->pointersSize();
				VariantObject* weakObj = otePointers->m_location;
				const Behavior* weakObjClass = ote->m_oteClass->m_location;
				const auto fixedFields = weakObjClass->fixedFields();
				for (size_t j = fixedFields; j < size; j++)
				{
					Oop fieldPointer = weakObj->m_fields[j];
					if (!ObjectMemoryIsIntegerObject(fieldPointer))
					{
						OTE* fieldOTE = reinterpret_cast<OTE*>(fieldPointer);
						const uint8_t fieldFlags = fieldOTE->m_ubFlags;
						if (fieldFlags & OTEFlags::FreeMask)
						{
#if defined(_DEBUG) && 0
							TRACESTREAM<< L"Weakling " << ote<< L" loses reference to freed object " <<
								(uintptr_t)fieldOTE<< L"/" << indexOfObject(fieldOTE) << std::endl;
#endif

							weakObj->m_fields[j] = corpse;
							losses++;
						}
						else if ((fieldFlags ^ curMark) & OTEFlags::MarkMask)
						{
							HARDASSERT(!ObjectMemory::hasCurrentMark(fieldOTE));
							// We must correctly maintain ref. count of dying object,
							// just in case it is in (or will be in) the finalization queue
#if defined(_DEBUG) && 0
							TRACESTREAM<< L"Weakling " << ote<< L" loses reference to " <<
								fieldOTE<< L"(" << (uintptr_t)fieldOTE<< L"/" << indexOfObject(fieldOTE)<< L" refs " <<
								int(ote->m_flags.m_count)<< L")" << std::endl;
#endif	
							fieldOTE->decRefs();
							weakObj->m_fields[j] = corpse;
							losses++;
						}
					}
				}

				// If any bereavements were suffered, then inform the weak object
				if (losses && weakObjClass->isMourner())
				{
					queuedForBereavement++;
					Interpreter::queueForBereavementOf(ote, integerObjectOf(losses));
#ifdef _DEBUG
					{
						tracelock lock(TRACESTREAM);
						TRACESTREAM<< L"Weakling: " << ote<< L" (" << std::hex << reinterpret_cast<uintptr_t>(ote)<< L") lost " << std::dec << losses << L" elements" << std::endl;
					}
#endif
					// We must also ensure that it and its referenced objects are marked since we're
					// rescuing it.
					markObjectsAccessibleFrom(ote);
				}
			}
		}
	}

	#ifdef _DEBUG
	{
		// Ensure the permanent objects have the current mark too
		const OTE* pEndPerm = m_pOT + NumPermanent;
		for (OTE* ote = m_pOT; ote < pEndPerm; ote++)
			markObject(ote);
	}
	#endif

	// Now sweep through the unmarked objects, and finalize/deallocate any objects which are STILL
	// unmarked
	size_t deletions=0;
	size_t queuedForFinalize=0;
	const auto loopEnd = nUnmarked;
	for (auto i=0u;i<loopEnd;i++)
	{
		OTE* ote = pUnmarked[i];
		const uint8_t oteFlags = ote->m_ubFlags;
		HARDASSERT(!(oteFlags & OTEFlags::FreeMask));
		if ((oteFlags ^ curMark) & OTEFlags::MarkMask)	// Still unmarked?
		{
			// Object still unmarked, so either deallocate it OR queue it for finalization
			HARDASSERT(!ObjectMemory::hasCurrentMark(ote));

			// We found a dying object, finalize it if necessary
			if (!(oteFlags & OTEFlags::FinalizeMask))
			{
				// It doesn't want finalizing, so we can free it
				// Countdown all refs from objects which are to be
				// deallocated - but not recursively, since marking
				// has already identified ALL objects which need to
				// be freed - thus maintaining correct reference counts
				// on objects which survive the garbage collect

				// First we remove the reference to the class
				BehaviorOTE* classPointer = ote->m_oteClass;

				#ifdef VERBOSEGC
					lossMap[classPointer]++;
				#endif

				if (classPointer->isFree())
				{
					#ifdef _DEBUG
					{
						tracelock lock(TRACESTREAM);
						TRACESTREAM<< L"GC WARNING: " << LPVOID(ote) << L'/' << i
							<< L" (size " << ote->getSize()<< L") has freed class " 
							<< LPVOID(classPointer) << L'/' << classPointer->getIndex() << std::endl; 
					}
					#endif
				}
				else
				{
					classPointer->decRefs();
				}

				// If not a pointer object, then nothing further to do
				if (ote->isPointers())
				{
					PointersOTE* otePointers = reinterpret_cast<PointersOTE*>(ote);
					const size_t lastPointer = otePointers->pointersSize();
					VariantObject* varObj = otePointers->m_location;
					for (auto f = 0u; f < lastPointer; f++)
					{
						Oop fieldPointer = varObj->m_fields[f];
						if (!isIntegerObject(fieldPointer))
						{
							OTE* fieldOTE = reinterpret_cast<OTE*>(fieldPointer);
							// Could have been previously deleted during GC
							if (!fieldOTE->isFree())
								fieldOTE->decRefs();
						}
					}
				}

				// We must ensure count really zero as some deallocation routines may not do this
				// (normally objects are only deallocated when the count hits zero)
				ote->m_count = 0;
				deallocate(ote);
				deletions++;
			}
			else
			{
#if 0//def _DEBUG
				TRACESTREAM<< L"Finalizing " << ote << std::endl;
#endif

				Interpreter::basicQueueForFinalization(ote);
				// Prevent a second finalization
				ote->beUnfinalizable();
				// We must ensure the object has the current mark so that it doesn't cock up the
				// next GC in case it survives that long
				markObject(ote);
				queuedForFinalize++;
			}
		}
	}

	freeChunk(pUnmarked);

	#ifdef VERBOSEGC
	{
		for (MAPCLASSOTE2INT::iterator it=lossMap.begin(); it != lossMap.end(); it++)
		{
			BehaviorOTE* classPointer = (*it).first;
			int val = (*it).second;
			{
				tracelock lock(TRACESTREAM);
				if (classPointer->isFree())
					TRACESTREAM<< L"GC: " << val<< L" objects of a free'd class ("
						<< LPVOID(classPointer) << L'(' << classPointer->getIndex()<< L") were deallocated" << std::endl;
				else
					TRACESTREAM<< L"GC: " << std::dec << val << L' ' << classPointer<< L"'s were deallocated" << std::endl;
			}
		}

		lossMap.clear();
	}
	#endif

	//mi_collect(false);

	#ifdef _DEBUG
		checkReferences();
	#endif

#if defined(VERBOSEGC)
	if (deletions > 0)
	{
		tracelock lock(TRACESTREAM);
		TRACESTREAM<< L"GC: Completed, " << deletions<< L" objects reclaimed, "
				<< queuedForFinalize<< L" queued for finalization, "
				<< queuedForBereavement<< L" weak lose elements" << std::endl;
	}
#endif
}

void ObjectMemory::addVMRefs()
{
	// Deliberately max out ref. counts of VM ref'd objects so that ref. counting ops 
	// not needed
	Array* globalPointers = (Array*)&_Pointers;
	const auto loopEnd = NumPointers;
	for (auto i=0u;i<loopEnd;i++)
	{
		Oop obj = globalPointers->m_elements[i];
		if (!isIntegerObject(obj))
			reinterpret_cast<OTE*>(obj)->beSticky();
	}
}

#ifdef TRACKFREEOTEs
size_t ObjectMemory::CountFreeOTEs()
{
	OTE* p = m_pFreePointerList;
	size_t	count = 0;
	OTE* offEnd = m_pOT + m_nOTSize;
	while (p < offEnd)
	{
		count++;
		p = NextFree(p);
	}
	return count;
}
#endif

#ifdef _DEBUG

	void ObjectMemory::checkStackRefs(Oop* const sp)
	{
		size_t zeroCountNotInZct = 0;
		Process* pProcess = Interpreter::m_registers.m_pActiveProcess;
		for (Oop* pOop = pProcess->m_stack;pOop <= sp;pOop++)
		{
			Oop oop = *pOop;
			if (!isIntegerObject(oop))
			{
				OTE* ote = reinterpret_cast<OTE*>(oop);
				if (ote->m_count == 0 && !IsInZct(ote))
				{
					TRACESTREAM<< L"WARNING: Zero count Oop not in Zct: " << ote << std::endl;
					zeroCountNotInZct++;
				}
			}
		}
		HARDASSERT(zeroCountNotInZct == 0);
	}

	void ObjectMemory::checkReferences()
	{
		// If this assertion fires, then something has written off the end
		// of an object, and corrupted the heap. Possibilities to consider are:
		//	1)	Modification of a class (e.g. addition/removal of instance
		//		variables). The Behavior code in Snailtalk is still
		//		not very safe, and frequently fails to modify information
		//		about the 'shape' of classes in a running system. The solution
		//		is probably to reboot.
		//	2)	An object passed to some external API as an 'lpvoid' has the
		//		wrong size, or some error caused writing off either of its ends
		//	3)	Stack overflow (probably due to a recursive loop going too deep),
		//		though it this occurs it will likely cause a failure somewhat
		//		earlier (mostly, it seems, in either activating new methods 
		//		or returnValueTo) in BYTEASM.ASM).
		//
		#ifdef WIN32_HEAP
			if (Interpreter::executionTrace > 3)
				HARDASSERT(::HeapValidate(m_hHeap, 0, 0));
		#endif

//		HARDASSERT(_CrtCheckMemory());
		//checkPools();

		HARDASSERT(m_nFreeOTEs == CountFreeOTEs());

		Interpreter::GrabAsyncProtect();

		Oop* const sp = Interpreter::m_registers.m_stackPointer;

		// Now adjust for the current active process, depending on whether the ZCT has been reconciled or not
		if (!IsReconcilingZct())
		{
			checkStackRefs(sp);
			Interpreter::IncStackRefs(sp);
		}
	
		auto errors=0;
		uint8_t* currentRefs = new uint8_t[m_nOTSize];
		{
			const size_t loopEnd = m_nOTSize;
			for (size_t i=OTBase; i < loopEnd; i++)
			{
				// Count and free bit should both be zero, or both non-zero
				/*if (m_pOT[i].m_flags.m_free ^ (m_pOT[i].m_flags.m_count == 0))
				{
					TRACESTREAM<< L"WARNING: ";
					Oop oop = pointerFromIndex(i);
					Interpreter::printObject(oop, TRACESTREAM);
					TRACESTREAM<< L" (Oop " << oop<< L"/" << i<< L") has refs " << 
							m_pOT[i].m_flags.m_count << std::endl;
					//errors++;
				}*/
				OTE* ote = &m_pOT[i];
				currentRefs[i] = ote->m_count;
				ote->m_count = 0;
			}
		}

		// Recalc the references
		const OTE* pEnd = m_pOT+m_nOTSize;
		size_t nFree = 0;
		for (OTE* ote=m_pOT; ote < pEnd; ote++)
		{
			if (!ote->isFree())
				addRefsFrom(ote);
			else
				nFree++;
		}

		POTE poteFree = m_pFreePointerList;
		size_t cFreeList = 0;
		while (poteFree < pEnd)
		{
			++cFreeList;
			poteFree = NextFree(poteFree);
		}

		//TRACESTREAM << nFree<< L" free slots found in OT, " << cFreeList<< L" on the free list (" << nFree-cFreeList<< L")" <<endl;

		Interpreter::ReincrementVMReferences();

		auto refCountTooSmall = 0;
		const size_t loopEnd = m_nOTSize;
		for (size_t i=OTBase; i < loopEnd; i++)
		{
			OTE* ote = &m_pOT[i];
			if (currentRefs[i] < OTE::MAXCOUNT)
			{
				if (currentRefs[i] != ote->m_count)
				{
					bool tooSmall = currentRefs[i] < ote->m_count;

					tracelock lock(TRACESTREAM);

					if (tooSmall)
					{
						refCountTooSmall++;
						TRACESTREAM<< L"ERROR: ";
					}
					else
						TRACESTREAM<< L"WARNING: ";
					
					TRACESTREAM << ote<< L" (Oop " << LPVOID(ote)<< L"/" << i<< L") had refs " << std::dec << (int)currentRefs[i] 
							<< L" should be " << int(ote->m_count) << std::endl;
					errors++;

					if (tooSmall)
					{
						if (!Interpreter::m_bAsyncGCDisabled)
						{
							TRACESTREAM<< L" Referenced From:" << std::endl;
							ArrayOTE* oteRefs = ObjectMemory::referencesTo(reinterpret_cast<Oop>(ote), true);
							Array* refs = oteRefs->m_location;
							for (auto i=0u;i<oteRefs->pointersSize();i++)
								TRACESTREAM<< L"  " << reinterpret_cast<OTE*>(refs->m_elements[i]) << std::endl;
							deallocate(reinterpret_cast<OTE*>(oteRefs));
						}
					}
					
					if (Interpreter::m_bAsyncGCDisabled)
					{
						// If compiler is running then async GCs are disabled, and we should leave the ref. counts
						// that are too high unaffected
						ote->m_count = currentRefs[i];
					}
				} else if (currentRefs[i] == 0 && !ote->isFree() && !IsInZct(ote))
				{
					// Shouldn't be zero count objects around that are not in the Zct
					TRACESTREAM << ote<< L" (Oop " << LPVOID(ote)<< L"/" << i<< L") had zero refs" << std::endl;
					errors++;
				}
			}
			else
			{
				// Never modify the ref. count of a sticky object - let the GC collect these
				ote->beSticky();
			}

			if (!ote->isFree())
			{
				// Perform some basic checks that the object is valid

				// Is the class pointer valid?
				HARDASSERT(isBehavior(Oop(ote->m_oteClass)));

				// Are the remaining pointers valid Oops
				if (ote->isPointers())
				{
					VariantObject* obj = reinterpret_cast<PointersOTE*>(ote)->m_location;
					size_t size = ote->pointersSize();
					for (size_t i = 0; i < size; i++)
					{
						HARDASSERT(isValidOop(obj->m_fields[i]));
					}
				}
			}
		}

		// Now remove refs from the current active process that we added before checking refs
		if (!IsReconcilingZct())
		{
			// We have to be careful not to cause more entries to be placed in the Zct, so we need to inline this
			// operation and just count down the refs and not act when they drop to zero
			Process* pProcess = Interpreter::m_registers.m_pActiveProcess;
			for (Oop* pOop = pProcess->m_stack;pOop <= sp;pOop++)
				ObjectMemory::decRefs(*pOop);

			checkStackRefs(sp);
		}

		Interpreter::RelinquishAsyncProtect();

		HARDASSERT(Interpreter::m_bAsyncGCDisabled || !refCountTooSmall);
		delete[] currentRefs;
		if (errors)
		{
			HARDASSERT(Interpreter::m_bAsyncGCDisabled || ignoreRefCountErrors || ((errors - refCountTooSmall) == 0));
			// If we don't do this, the proc. may have wrong size for GC

			Interpreter::resizeActiveProcess();
		}
	}

	void ObjectMemory::addRefsFrom(OTE* ote)
	{
		HARDASSERT(ote >= m_pOT);
		// We must also inc. ref. count on the class here
		ote->m_oteClass->countUp();

		if (ote->isPointers())
		{
			PointersOTE* otePointers = reinterpret_cast<PointersOTE*>(ote);
			VariantObject* varObj = otePointers->m_location;
			const size_t lastPointer = otePointers->pointersSize();
			for (size_t i = 0; i < lastPointer; i++)
			{
				Oop fieldPointer = varObj->m_fields[i];
				// The reason we don't use an ASSERT here is that, ASSERT throws
				// up a message box which causes a callback into Smalltalk to process
				// the window messages, which is not permissible during the execution
				// of a GC
				if (!isIntegerObject(fieldPointer))
				{
					OTE* fieldOTE = reinterpret_cast<OTE*>(fieldPointer);
					if (fieldOTE < m_pOT 
							|| fieldOTE > m_pOT+m_nOTSize-1 
							|| fieldOTE->isFree())
					{
						HARDASSERT(FALSE);					// Fires if fieldPointer bad
						varObj->m_fields[i] = Oop(_Pointers.Nil);		// Repair the damage
					}
				}
				countUp(fieldPointer);
			}
		}
	}
#endif	// Debug
