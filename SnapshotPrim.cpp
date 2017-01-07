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

Oop* __fastcall Interpreter::primitiveSnapshot(CompiledMethod&, unsigned argCount)
{
	Oop arg = stackValue(argCount - 1);
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

	bool bBackup;
	if (argCount >= 2)
		bBackup = reinterpret_cast<OTE*>(stackValue(argCount - 2)) == Pointers.True;
	else
		bBackup = false;

	SMALLINTEGER nCompressionLevel;
	if (argCount >= 3)
	{
		Oop oopCompressionLevel = stackValue(argCount - 3);
		nCompressionLevel = ObjectMemoryIsIntegerObject(oopCompressionLevel) ? ObjectMemoryIntegerValueOf(oopCompressionLevel) : 0;
	}
	else
		nCompressionLevel = 0;

	SMALLUNSIGNED nMaxObjects = 0;
	if (argCount >= 4)
	{
		Oop oopMaxObjects = stackValue(argCount - 4);
		if (ObjectMemoryIsIntegerObject(oopMaxObjects))
		{
			nMaxObjects = ObjectMemoryIntegerValueOf(oopMaxObjects);
		}
	}

	// N.B. It is not necessary to clear down the memory pools as the free list is rebuild on every image
	// load and the pool members, though not on the free list at present, are marked as free entries
	// in the object table

	// ZCT is reconciled, so objects may be deleted
	flushAtCaches();

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
