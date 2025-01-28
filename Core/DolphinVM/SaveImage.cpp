/******************************************************************************

	File: image.cpp

	Description:

	Object Memory management image save method
	definitions for Dolphin Smalltalk

******************************************************************************/
#include "ist.h"

#if defined(CANSAVEIMAGE)

#include <fcntl.h>

#include "binstream.h"
#include "zfbinstream.h"
#include "objmem.h"
#include "interprt.h"
#include "rc_vm.h"

// Smalltalk classes
#include "STProcess.h"		// The stacks are patched on loading to new addresses
#include "STString.h"
#include "STCharacter.h"
#include "STClassDesc.h"

#include "Utf16StringBuf.h"

#ifdef NDEBUG
	#pragma optimize("s", on)
	#pragma auto_inline(off)
#endif

#ifdef _DEBUG
	#define PROFILE_IMAGELOADSAVE
#endif

//////////////////////////////////////////////////////////////////////////////
// Image Save Methods

_PrimitiveFailureCode __stdcall ObjectMemory::SaveImageFile(const wchar_t* szFileName, bool bBackup, int nCompressionLevel, size_t nMaxObjects)
{
	// Answer:
	//	NULL = success
	//	ZeroPointer = general save error

	if (!szFileName)
		return _PrimitiveFailureCode::InvalidParameter1;

	if (nMaxObjects == 0)
	{
		nMaxObjects = m_nOTMax;
	}

	if (nMaxObjects < m_nOTSize + OTMinHeadroom)
	{
		return _PrimitiveFailureCode::InvalidParameter4;
	}

	if (nMaxObjects > OTMaxLimit)
	{
		return _PrimitiveFailureCode::NoMemory;
	}

	int nRet = 3;

	const wchar_t* saveName;
	wchar_t bak[_MAX_PATH];
	if (bBackup)
	{
		wchar_t folder[_MAX_PATH];
		wchar_t fname[_MAX_FNAME];
		{
			wchar_t dir[_MAX_DIR];
			wchar_t drive[_MAX_DRIVE];
			_wsplitpath_s(szFileName, drive, _MAX_DRIVE, dir, _MAX_DIR, fname, _MAX_FNAME, NULL, 0);
			_wmakepath(folder, drive, dir, NULL, NULL);
			_wmakepath(bak, drive, dir, fname, L"bak");
		}
		saveName = _wtempnam(folder, fname);
	}
	else
		saveName = szFileName;

	int fd;
	int err = ::_wsopen_s(&fd, (const wchar_t*)saveName, _O_WRONLY|_O_BINARY|_O_CREAT|_O_TRUNC|_O_SEQUENTIAL, _SH_DENYRW, _S_IWRITE|_S_IREAD);
	if (err != 0)
	{
		wchar_t buf[256];
		_wcserror_s(buf, errno);
		TRACE(L"Failed to open image file for save %d:'%s'\n", errno, buf);
		return _PrimitiveFailureCode::Failed;
	}

#ifdef PROFILE_IMAGELOADSAVE
	TRACESTREAM<< L"Saving image to '" << saveName<< L"' ..." << std::endl;
	ULONGLONG dwStartTicks = GetTickCount64();
#endif

	::_write(fd, ISTHDRTYPE, sizeof(ISTHDRTYPE));

	VS_FIXEDFILEINFO versionInfo;
	::GetVersionInfo(&versionInfo);

	ImageHeader header;
	ZeroMemory(&header, sizeof(header));

	header.versionMS = versionInfo.dwProductVersionMS;
	SmallInteger imageVersionMinor = isIntegerObject(_Pointers.ImageVersionMinor) ? integerValueOf(_Pointers.ImageVersionMinor) : 0;
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
	size_t i = lastOTEntry();
	// Find the last used entry
	ASSERT(i > NumPermanent);
	header.nTableSize = i + 1;

	::_write(fd, &header, sizeof(ImageHeader));
	
	bool bSaved;
	{
		uint8_t buf[dwAllocationGranularity];
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
		int64_t msToRun = GetTickCount64() - dwStartTicks;
		TRACESTREAM << L" done (" << (bSaved ? "Succeeded" : "Failed")<< L"), binstreams time " << long(msToRun)<< L"mS" << std::endl;
	#endif
	}

	if (bBackup)
	{
		if (bSaved)
		{
			_wremove(bak);
			_wrename(szFileName, bak);
			nRet = _wrename(saveName, szFileName);
		}
		else
		{
			_wremove(saveName);
		}
	}
	else
	{
		if (bSaved)
			nRet = 0;
	}

	return nRet == 0 ? _PrimitiveFailureCode::NoError : _PrimitiveFailureCode::Unsuccessful;

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
			: SaveObjects<sizeof(WCHAR)>(imageFile, pHeader))
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

template <size_t ImageNullTerms> bool __stdcall ObjectMemory::SaveObjects(obinstream& imageFile, const ImageHeader* pHeader)
{
	#ifdef _DEBUG
		size_t numObjects = 0;
		size_t nFree = 0;
	#endif

	size_t dataSize = 0;
	const OTE* pEnd = m_pOT+pHeader->nTableSize;	// Loop invariant
	for (OTE* ote=m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			#ifdef _DEBUG
				numObjects++;
			#endif

			POBJECT obj = ote->m_location;

			if (ote->heapSpace() == Spaces::Virtual)
			{
				VirtualObject* vObj = static_cast<VirtualObject*>(obj);
				VirtualObjectHeader* pObjHeader = vObj->getHeader();

				// We only write the max allocation size from the header. The rest of the info (fxstate) is not preserved across image saves.
				imageFile.write(pObjHeader, sizeof(VirtualObjectHeader::m_maxAlloc));
				dataSize += sizeof(sizeof(VirtualObjectHeader::m_maxAlloc));
			}

			size_t bytesToWrite = ote->getSize() + (ote->isNullTerminated() * ImageNullTerms);
			imageFile.write(obj, bytesToWrite);

			if (imageFile.good() == 0)
				return false;
			dataSize += bytesToWrite;
		}
		else
		{
#ifdef _DEBUG
			nFree++;
#endif
		}
	}

	#ifdef _DEBUG
		TRACESTREAM << numObjects<< L" objects saved totalling " << std::dec << dataSize 
				<< L" bytes, " << nFree<< L" free OTEs"
				// Compressed stream does not support seeking and sets to bad state
				//<< L", writing checksum at offset " << imageFile.tellp() 
				<< std::endl;
	#endif

	// Append the amount of data written as a checksum.
	return imageFile.write(&dataSize, sizeof(dataSize));
}

#endif
