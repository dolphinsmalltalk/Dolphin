/******************************************************************************

	File: VMRef.cpp

	Description:

	Interpreter methods to maintain VM reference table

******************************************************************************/

#include "Ist.h"
#include "Interprt.h"

// Smalltalk classes
#include "STArray.h"
#include "thrdcall.h"

///////////////////////////////////////////////////////////////////////////////
//
// Routines to provide generic support for references to objects from the VM
//
// The algorithm uses a linked list of free slots for adding a reference, but
// with a serial search on dereferencing. This would be better replaced with
// a hash table implementation using the identity hash of the object
TODO("Replace with hash table implementation")

#ifdef _DEBUG		// JGFoster

Oop* Interpreter::m_pVMRefs = 0;
SmallInteger Interpreter::m_nMaxVMRefs = 0;
SmallInteger Interpreter::m_nFreeVMRef = -1;

// Add a reference to an object in use by the VM by storing it in an array reserved
// for the purpose, which is itself reference from the special VMPointers root object
void Interpreter::AddVMReference(Oop object)
{
	if (!ObjectMemoryIsIntegerObject(object))
		AddVMReference((OTE*)object);
}

// Add a reference to an object in use by the VM by storing it in an array reserved
// for the purpose, which is itself reference from the special VMPointers root object
void Interpreter::AddVMReference(OTE* pOTE)
{
	// Don't store ref's to objects which don't need ref. counting
	if (!ObjectMemory::isPermanent(pOTE))
	{
		if (m_nFreeVMRef >= m_nMaxVMRefs)
		{
			// Need to grow the array
			m_nFreeVMRef = m_nMaxVMRefs;
			m_nMaxVMRefs += VMREFSGROWTH;
			m_pVMRefs = ((Array*)ObjectMemory::resize((PointersOTE*)Pointers.VMReferences, m_nMaxVMRefs, false))->m_elements;
			for (SmallInteger i=m_nFreeVMRef;i<m_nMaxVMRefs;i++)
				m_pVMRefs[i] = ObjectMemoryIntegerObjectOf(i+1);
		}
		const SmallInteger empty = m_nFreeVMRef;
		const Oop oopNextEmpty = m_pVMRefs[empty];
		HARDASSERT(ObjectMemoryIsIntegerObject(oopNextEmpty));
		m_nFreeVMRef = ObjectMemoryIntegerValueOf(oopNextEmpty);
		m_pVMRefs[empty] = Oop(pOTE);
		pOTE->countUp();
	}
	//CHECKREFERENCES
}

// Remove ref. to previously registered object.
// N.B. Assumes that 
void Interpreter::RemoveVMReference(Oop object)
{
	if (!ObjectMemoryIsIntegerObject(object))
		RemoveVMReference((OTE*)object);
}

// Remove ref. to previously registered object.
// N.B. Assumes that 
void Interpreter::RemoveVMReference(OTE* pOTE)
{
	if (!ObjectMemory::isPermanent(pOTE))
	{
		for (auto i=0;i<m_nMaxVMRefs;i++)
		{
			if (m_pVMRefs[i] == Oop(pOTE))
			{
				ASSERT(!ObjectMemoryIsIntegerObject(m_pVMRefs[i]));
				
				// Link onto the front of the free list
				m_pVMRefs[i] = ObjectMemoryIntegerObjectOf(m_nFreeVMRef);
				m_nFreeVMRef = i;

				break;
			}
		}
		pOTE->countDown();
	}
	//CHECKREFERENCES
}

///////////////////////////////////////////////////////////////////////////////
//

//	#ifdef _DEBUG		// JGFoster
	//========================
	//ReincrementVMReferences
	//========================
	// ObjectMemory::checkReferences(), in DEBUG version, clears then re-increments the reference counts of all 
	// accessible objects. This function is called to re-increment the reference count of the objects to which
	// the VM holds a strong reference
	//
	void Interpreter::ReincrementVMReferences()
	{
		// VM holds onto an array into which it stores objects which it is
		// currently referencing from outside the Smalltalk world, this array
		// is one of the root objects used for garbage collection, but its own
		// count must be artificially maintained during a check references
		// this is achieved through the overflow of the counts of all objects
		// in the global pointers structure (see below)

		m_oteNewProcess->countUp();					// new process or nil
		
		OverlappedCall::ReincrementProcessReferences();

		ObjectMemory::addVMRefs();
	}
#endif
