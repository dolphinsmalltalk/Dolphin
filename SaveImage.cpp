/******************************************************************************

	File: image.cpp

	Description:

	Object Memory management image save method
	definitions for Dolphin Smalltalk

******************************************************************************/
#include "ist.h"

#if defined(VMDLL)

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <float.h>
#include <io.h>
#include <fcntl.h>
#include "binstream.h"
#include "zfbinstream.h"
#include "objmem.h"
#include "ObjMemPriv.inl"
#include "interprt.h"
#include "rc_vm.h"

// Smalltalk classes
#include "STProcess.h"		// The stacks are patched on loading to new addresses
#include "STString.h"
#include "STCharacter.h"
#include "STClassDesc.h"

#ifdef NDEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#ifdef _DEBUG
	#define PROFILE_IMAGELOADSAVE
#endif

//////////////////////////////////////////////////////////////////////////////
// Image Save Methods

int __stdcall ObjectMemory::SaveImageFile(const char* szFileName, bool bBackup, int nCompressionLevel, unsigned nMaxObjects)
{
	// Answer:
	//	NULL = success
	//	ZeroPointer = general save error

	if (!szFileName)
		return 2;

	if (nMaxObjects == 0)
	{
		nMaxObjects = m_nOTMax;
	}

	if (nMaxObjects < m_nOTSize + OTMinHeadroom)
	{
		return 4;
	}

	if (nMaxObjects > OTMaxLimit)
	{
		return 5;
	}

	int nRet = 3;

	const char* saveName;
	char bak[_MAX_PATH];
	if (bBackup)
	{
		char folder[_MAX_PATH];
		char fname[_MAX_FNAME];
		{
			char dir[_MAX_DIR];
			char drive[_MAX_DRIVE];
			_splitpath_s(szFileName, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
			_makepath(folder, drive, dir, NULL, NULL);
			_makepath(bak, drive, dir, fname, "bak");
		}
		saveName = _tempnam(folder, fname);
	}
	else
		saveName = szFileName;

	int fd;
	int err = ::_sopen_s(&fd, saveName, _O_WRONLY|_O_BINARY|_O_CREAT|_O_TRUNC|_O_SEQUENTIAL, _SH_DENYRW, _S_IWRITE|_S_IREAD);
	if (err != 0)
	{
		char buf[256];
		strerror_s(buf, errno);
		TRACE("Failed to open image file for save %d:'%s'\n", errno, buf);
		return 2;
	}

#ifdef PROFILE_IMAGELOADSAVE
	TRACESTREAM << "Saving image to '" << saveName << "' ..." << endl;
	DWORD dwStartTicks = GetTickCount();
#endif

	::_write(fd, ISTHDRTYPE, sizeof(ISTHDRTYPE));

	VS_FIXEDFILEINFO versionInfo;
	::GetVersionInfo(&versionInfo);

	ImageHeader header;
	memset(&header, 0, sizeof(header));

	header.versionMS = versionInfo.dwProductVersionMS;
	SMALLINTEGER imageVersionMinor = isIntegerObject(_Pointers.ImageVersionMinor) ? integerValueOf(_Pointers.ImageVersionMinor) : 0;
	header.versionLS = imageVersionMinor == 0 ? LOWORD(versionInfo.dwProductVersionLS) << 16 : imageVersionMinor;

	header.flags.bIsCompressed = nCompressionLevel != 0;

	header.nGlobalPointers	= NumPointers;

	// By saving down the base offset with the image, we don't need
	// to convert on save, only load
	ASSERT(sizeof(OTE*) == sizeof(DWORD));
	header.BasePointer		= m_pOT;

	// Saving down current hash counter is not 100% necessary, but ensures
	// consistent behavior each time image is loaded.
	header.nNextIdHash		= m_nNextIdHash;

	// User may have modified max table size
	header.nMaxTableSize	= nMaxObjects;

	// Set the OT size
	unsigned i = lastOTEntry();
	// Find the last used entry
	ASSERT(i > NumPermanent);
	header.nTableSize = i + 1;

	::_write(fd, &header, sizeof(ImageHeader));
	
	bool bSaved;
	{
		BYTE buf[dwAllocationGranularity];
		if (header.flags.bIsCompressed)
		{
			zfbinstream stream;
			//stream.rdbuf()->setbuf(buf, sizeof(buf));
			//stream.clrlock();
			stream.attach(fd, "wb", 0, true);
			//stream << setcompressionlevel(nCompressionLevel);
			bSaved = SaveImage(stream, &header, nRet);
		}
		else
		{
			fbinstream stream;
			// We don't need thread synchronisation
			//stream.clrlock();
			stream.attach(fd, "wb");
			stream.setbuf(buf, sizeof(buf));

			bSaved = SaveImage(stream, &header, nRet);
		}

	#ifdef PROFILE_IMAGELOADSAVE
		DWORD msToRun = GetTickCount() - dwStartTicks;
		TRACESTREAM << " done (" << (bSaved ? "Succeeded" : "Failed") << "), binstreams time " << long(msToRun) << "mS" << endl;
	#endif
	}

	if (bBackup)
	{
		if (bSaved)
		{
			remove(bak);
			rename(szFileName, bak);
			nRet = rename(saveName, szFileName);
		}
		else
		{
			remove(saveName);
		}
	}
	else
	{
		if (bSaved)
			nRet = 0;
	}

	return nRet;

}

bool __stdcall ObjectMemory::SaveImage(obinstream& imageFile, const ImageHeader* pHeader, int nRet)
{
	EmptyZct(Interpreter::m_registers.m_stackPointer);
	// Do the save.
	bool bResult = imageFile.good() != 0
		&& (nRet == 3)
		&& SaveObjectTable(imageFile, pHeader)
		// From VM 7.0.54 two bytes are allowed for null terminators to correctly accommodate wide strings; 
		// Prior to 7.0.54 null terminators were always 1 byte (which was not really sufficient for wide strings).
		&& (pHeader->HasSingleByteNullTerms() 
			? SaveObjects<sizeof(char)>(imageFile, pHeader) 
			: SaveObjects<sizeof(wchar_t)>(imageFile, pHeader))
		&& imageFile.flush().good();
	PopulateZct(Interpreter::m_registers.m_stackPointer);
	return bResult;
}

// Quick and dirty - save the whole OT wasting space used by empty
// entries
bool __stdcall ObjectMemory::SaveObjectTable(obinstream& imageFile, const ImageHeader* pHeader)
{
	return imageFile.write(m_pOT, sizeof(OTE)*pHeader->nTableSize);
}

template <MWORD ImageNullTerms> bool __stdcall ObjectMemory::SaveObjects(obinstream& imageFile, const ImageHeader* pHeader)
{
	#ifdef _DEBUG
		unsigned numObjects = 0;
		unsigned nFree = 0;
	#endif

	DWORD dwDataSize = 0;
	const OTE* pEnd = m_pOT+pHeader->nTableSize;	// Loop invariant
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			#ifdef _DEBUG
				numObjects++;
			#endif

			POBJECT obj = ote->m_location;

			if (ote->heapSpace() == OTEFlags::VirtualSpace)
			{
				VirtualObject* vObj = static_cast<VirtualObject*>(obj);
				VirtualObjectHeader* pObjHeader = vObj->getHeader();

				// We only write the max allocation size from the header. The rest of the info (fxstate) is not preserved across image saves.
				imageFile.write(pObjHeader, sizeof(MWORD));
				dwDataSize += sizeof(MWORD);
			}

			MWORD bytesToWrite = ote->getSize() + (ote->isNullTerminated() * ImageNullTerms);
			imageFile.write(obj, bytesToWrite);

			if (imageFile.good() == 0)
				return false;
			dwDataSize += bytesToWrite;
		}
		else
		{
#ifdef _DEBUG
			nFree++;
#endif
		}
	}

	#ifdef _DEBUG
		TRACESTREAM << numObjects << " objects saved totalling " << dec << dwDataSize 
				<< " bytes, " << nFree << " free OTEs"
				// Compressed stream does not support seeking and sets to bad state
				//<< ", writing checksum at offset " << imageFile.tellp() 
				<< endl;
	#endif

	// Append the amount of data written as a checksum.
	return imageFile.write(&dwDataSize, sizeof(DWORD));
}

#endif
