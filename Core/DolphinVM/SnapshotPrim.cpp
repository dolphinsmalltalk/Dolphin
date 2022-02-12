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

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"
#include "InterprtProc.inl"

// Smalltalk classes
#include "STString.h"

#include "Utf16StringBuf.h"

#pragma auto_inline(off)

#if defined(CANSAVEIMAGE)

Oop* PRIMCALL Interpreter::primitiveSnapshot(Oop* const sp, primargcount_t)
{
	Oop arg = *(sp-3);
	if (ObjectMemoryIsIntegerObject(arg))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);

	OTE* oteArg = reinterpret_cast<OTE*>(arg);
	const wchar_t* szFileName;
	if (oteArg == Pointers.Nil)
	{
		szFileName = nullptr;
	}
	else if (!oteArg->isNullTerminated())
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}

	Utf16StringBuf buf;
	StringEncoding encoding = oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding;
	switch (encoding)
	{
	case StringEncoding::Ansi:
		buf.FromBytes(Interpreter::m_ansiCodePage, reinterpret_cast<AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		szFileName = buf;
		break;
	case StringEncoding::Utf8:
		buf.FromBytes(CP_UTF8, (LPCCH)reinterpret_cast<Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		szFileName = buf;
		break;
	case StringEncoding::Utf16:
		szFileName = (const wchar_t*)reinterpret_cast<Utf16StringOTE*>(oteArg)->m_location->m_characters;
		break;
	case StringEncoding::Utf32:
		return primitiveFailure(_PrimitiveFailureCode::NotSupported);

	default:
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}

	bool bBackup = reinterpret_cast<OTE*>(*(sp-2)) == Pointers.True;

	SmallInteger nCompressionLevel;
	Oop oopCompressionLevel = *(sp-1);
	nCompressionLevel = ObjectMemoryIsIntegerObject(oopCompressionLevel) ? ObjectMemoryIntegerValueOf(oopCompressionLevel) : 0;

	SmallUinteger nMaxObjects = 0;
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

	_PrimitiveFailureCode saveResult = ObjectMemory::SaveImageFile(szFileName, bBackup, nCompressionLevel, nMaxObjects);

#ifdef OAD
	DWORD timeEnd = timeGetTime();
	TRACESTREAM<< L"Time to save image: " << (timeEnd - timeStart)<< L" mS" << std::endl;
#endif

	return saveResult == _PrimitiveFailureCode::NoError ? primitiveSuccess(4) : primitiveFailure(saveResult);
}

#elif defined(TO_GO)

Oop* PRIMCALL Interpreter::primitiveSnapshot(Oop* const, primargcount_t)
{
	return primitiveFailure(_PrimitiveFailureCode::NotSupported);
}

#endif
