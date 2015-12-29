/******************************************************************************

	File: STMemoryManager.h

	Description:

	VM representation of Smalltalk MemoryManager class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STMemoryManager_H_
#define _IST_STMemoryManager_H_

#include "STObject.h"

class MemoryManager //: public Object
{
public:
	OTE* m_finalizer;			// Finalization process
	OTE* m_lastRequests;		// Semaphore to signal objects requiring finalization are waiting
	OTE* m_hospice;				// Finalization queue (home for dying objects)
	Oop	 m_hospiceHighWater;	// High water level for hospice
	OTE* m_reservedForCorpse;	// Corpse object used to replace losses in weaklings
	OTE* m_undertaker;			// Undertaker process sends #elementsExpired: messages to bereaved
	OTE* m_bereavements;		// Semaphore to signal bereaved queue not empty
	OTE* m_bereaved;			// Queue of bereaved weaklings
	OTE* m_bereavedHighWater;	// High water level for bereavement queue
	Oop	 m_gcInterval;			// Interval (mS) before next idle GC
	OTE* m_lastGCTime;			// Millisecond clock at last GC (32-bit DWORD)
	Oop	 m_lastGCDuration;		// mS to perform last GC
	Oop	 m_objectHeaderSize;	// Size in bytes of object header (as SmallInteger)
};

typedef TOTE<MemoryManager> MemManOTE;

#endif	// EOF