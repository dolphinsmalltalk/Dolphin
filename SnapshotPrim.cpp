/******************************************************************************

	File: SnapshotPrim.cpp

	Description:

	Implementation of the Interpreter class' snapshot/quit primitive methods

******************************************************************************/
#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#if defined(TO_GO)
#error To Go VMs should not be able to snapshot the image
#endif

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk classes
#include "STString.h"

#pragma auto_inline(off)

Oop* __fastcall Interpreter::primitiveSnapshot(Oop* const sp)
{
	Oop arg = *(sp-3);
	char* szFileName;
	if (arg == Oop(Pointers.Nil))
		szFileName = 0;
	else if (ObjectMemory::fetchClassOf(arg) == Pointers.ClassString)
	{
		StringOTE* oteString = reinterpret_cast<StringOTE*>(arg);
		String* fileName = oteString->m_location;
		szFileName = fileName->m_characters;
	}
	else
		return primitiveFailure(0);

	bool bBackup = reinterpret_cast<OTE*>(*(sp-2)) == Pointers.True;

	SMALLINTEGER nCompressionLevel;
	Oop oopCompressionLevel = *(sp-1);
	nCompressionLevel = ObjectMemoryIsIntegerObject(oopCompressionLevel) ? ObjectMemoryIntegerValueOf(oopCompressionLevel) : 0;

	SMALLUNSIGNED nMaxObjects = 0;
	Oop oopMaxObjects = *sp;
	if (ObjectMemoryIsIntegerObject(oopMaxObjects))
	{
		nMaxObjects = ObjectMemoryIntegerValueOf(oopMaxObjects);
	}

	// N.B. It is not necessary to clear down the memory pools as the free list is rebuild on every image
	// load and the pool members, though not on the free list at present, are marked as free entries
	// in the object table

	// Store the active frame of the active process before saving so available on image reload
	// We're not actually suspending the process now, but it appears like that to the snapshotted
	// image on restarting
	m_registers.PrepareToSuspendProcess();

#ifdef OAD
	DWORD timeStart = timeGetTime();
#endif

	int saveResult = ObjectMemory::SaveImageFile(szFileName, bBackup, nCompressionLevel, nMaxObjects);

#ifdef OAD
	DWORD timeEnd = timeGetTime();
	TRACESTREAM << "Time to save image: " << (timeEnd - timeStart) << " mS" << endl;
#endif

	if (!saveResult)
	{
		// Success
		return primitiveSuccess(1);
	}
	else
	{
		// Failure
		return primitiveFailure(saveResult);
	}
}
