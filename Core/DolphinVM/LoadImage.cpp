/******************************************************************************

	File: LoadImage.cpp

	Description:

	Object Memory management image load

******************************************************************************/
#include "ist.h"

#include "binstream.h"
#include "zbinstream.h"
#include "objmem.h"
#include "interprt.h"
#include "rc_vm.h"

// Smalltalk classes
#include "STProcess.h"		// The stacks are patched on loading to new addresses
#include "STString.h"
#include "STCharacter.h"
#include "STClassDesc.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

const char ObjectMemory::ISTHDRTYPE[4] = "IST";

#define CONSTSPACESIZE 4096

extern VMPointers _Pointers;
void* ObjectMemory::m_pConstObjs = 0;

#ifdef _DEBUG
#define PROFILE_IMAGELOADSAVE
#endif

// This stuff is a once off, used only during image load
#pragma code_seg(INIT_SEG)

///////////////////////////////////////////////////////////////////////////////
// Image loading methods

// Report a read error when attempting to load image
static HRESULT ImageReadError(ibinstream& imageFile)
{
	int fileError = imageFile.fail();
	return fileError
		? ReportError(IDP_IMAGEREADERROR, fileError)
		: imageFile.eof()
		? ReportError(IDP_IMAGEFILETRUNCATED)
		: ReportError(IDP_UNKNOWNIMAGEERROR);
}

HRESULT ObjectMemory::LoadImage(const wchar_t* szImageName, LPVOID imageData, size_t imageSize, bool isDevSys)
{
#ifdef PROFILE_IMAGELOADSAVE
	TRACESTREAM<< L"Loading image '" << szImageName << std::endl;
	ULONGLONG dwStartTicks = GetTickCount64();
#endif

	HRESULT hr;

	ASSERT(imageSize > sizeof(ImageHeader));

	uint8_t* pImageBytes = static_cast<uint8_t*>(imageData);
	ImageHeader* pHeader = reinterpret_cast<ImageHeader*>(pImageBytes + sizeof(ISTHDRTYPE));
	ptrdiff_t offset = sizeof(ISTHDRTYPE) + sizeof(ImageHeader);

	if (pHeader->flags.bIsCompressed)
	{
		zibinstream stream(pImageBytes + offset, imageSize - offset);
		hr = LoadImage(stream, pHeader);
	}
	else
	{
		// It seems that using a memory mapped file is about twice as fast - of course a lot of performance
		// may well be lost by going though the simple memory stream and needlessly copying data and checking
		// for EOF.
		//fbinstream stream;
		//stream.open(szImageName, "rb");
		//int dummy;
		//stream.read(&dummy, 4);
		//ImageHeader h;
		//stream.read(&h, sizeof(h));
		//pHeader = &h;
		imbinstream stream(pImageBytes + offset, imageSize - offset);
		hr = LoadImage(stream, pHeader);
	}

#ifdef PROFILE_IMAGELOADSAVE
	int64_t msToRun = GetTickCount64() - dwStartTicks;
	TRACESTREAM<< L" done (" << (SUCCEEDED(hr) ? "Succeeded" : "Failed")<< L"), binstreams time=" << msToRun << L"mS" << std::endl;
#endif

	return hr;
}

// Convert a saved pointer to its equivalent with the current 
// object table
inline OTE* ObjectMemory::FixupPointer(OTE* pSavedPointer, OTE* pSavedBase)
{
#ifdef _DEBUG
	static BOOL breakOnCorrupt = TRUE;
	if (pSavedPointer < pSavedBase)
	{
		if (breakOnCorrupt) DebugBreak();
		return Pointers.Nil;
	}
	//ASSERT(pSavedPointer >= pSavedBase);
#endif
	return pointerFromIndex(pSavedPointer - pSavedBase);
}


HRESULT ObjectMemory::LoadImage(ibinstream& imageFile, ImageHeader* pHeader)
{
	m_imageVersionMajor = pHeader->versionMS;
	m_imageVersionMinor = pHeader->versionLS;

	m_nNextIdHash = pHeader->nNextIdHash;

	// Allocate sufficient object table space for the number of objects in the image
	// and a bit extra for working space - can grow to at least the maximum size in m_nOTMax
	ASSERT(sizeof(OTE) == 16); // If not change the page size multiple
#ifdef NO_GPF_TRAP
	constexpr int otSlop = 500;
#else
	constexpr int otSlop = 3;
#endif
	HRESULT hr = allocateOT(pHeader->nMaxTableSize, pHeader->nTableSize + (dwPageSize*otSlop / sizeof(OTE)));
	if (FAILED(hr))
		return hr;

	hr = LoadObjectTable(imageFile, pHeader);
	if (FAILED(hr))
		return hr;

	size_t nDataRead = 0;
	hr = pHeader->HasSingleByteNullTerms() 
			? LoadPointersAndObjects<sizeof(char)>(imageFile, pHeader, nDataRead) 
			: LoadPointersAndObjects<sizeof(WCHAR)>(imageFile, pHeader, nDataRead);
	if (FAILED(hr))
		return hr;

#ifdef _DEBUG
	// tellg() invalidates a gzstream
	//TRACESTREAM << nDataRead<< L" data bytes read, loading checksum at offset " << imageFile.tellg() << std::endl;
#endif

	// Read the checksum...
	size_t nCheckSum;
	if (!imageFile.read(&nCheckSum, sizeof(nCheckSum)) || (nDataRead != nCheckSum))
		return ReportError(IDP_CORRUPTIMAGE, nDataRead, nCheckSum);

	PostLoadFix();

	// Perform some consistency checks to be sure this image matches the VM
	ASSERT((reinterpret_cast<const Behavior*>(_Pointers.ClassMetaclass->m_oteClass->m_location))->fixedFields() >= MetaClass::FixedSize);

	return S_OK;
}

template <size_t ImageNullTerms> HRESULT ObjectMemory::LoadPointersAndObjects(ibinstream& imageFile, const ImageHeader* pHeader, size_t& cbRead)
{
	HRESULT hr = LoadPointers<ImageNullTerms>(imageFile, pHeader, cbRead);
	if (FAILED(hr))
		return hr;
	return LoadObjects<ImageNullTerms>(imageFile, pHeader, cbRead);
}

template <size_t ImageNullTerms> HRESULT ObjectMemory::LoadPointers(ibinstream& imageFile, const ImageHeader* pHeader, size_t& cbRead)
{
	ASSERT(pHeader->nGlobalPointers == NumPointers);

	::ZeroMemory(m_pConstObjs, CONSTSPACESIZE);

	size_t cbPerm = 0;
	uint8_t* pNextConst = reinterpret_cast<uint8_t*>(m_pConstObjs);
	size_t i;
	for (i = 0; i < NumPermanent; i++)
	{
		VariantObject* pConstObj = reinterpret_cast<VariantObject*>(pNextConst);

		OTE* ote = m_pOT + i;
		size_t bytesToRead;
		size_t allocSize;
		if (ote->isNullTerminated())
		{
			size_t byteSize = ote->getSize();
			allocSize = byteSize + NULLTERMSIZE;
			bytesToRead = byteSize + ImageNullTerms;
		}
		else
		{
			allocSize = bytesToRead = ote->getSize();
		}

		if (bytesToRead > 0)
		{
			// Now load the rest of the object (size includes itself)
			if (!imageFile.read(&(pConstObj->m_fields), bytesToRead))
				return ImageReadError(imageFile);
		}
		else
		{
			if (allocSize == 0) pConstObj = NULL;
		}

		cbPerm += bytesToRead;
		pNextConst += _ROUND2(allocSize, 4);

		markObject(ote);
		Oop* oldLocation = reinterpret_cast<Oop*>(ote->m_location);
		ote->m_location = pConstObj;

		ote->beSticky();
		// Repair the object
		FixupObject(ote, oldLocation, pHeader);
	}

#ifdef _DEBUG
	TRACESTREAM << i<< L" permanent objects loaded totalling " << cbPerm<< L" bytes" << std::endl;
#endif

	memcpy(const_cast<VMPointers*>(&Pointers), &_Pointers, sizeof(Pointers));

	cbRead += cbPerm;
	return S_OK;
}

HRESULT ObjectMemory::LoadObjectTable(ibinstream& imageFile, const ImageHeader* pHeader)
{
	ASSERT(pHeader->nTableSize > NumPermanent);
	if (!imageFile.read(m_pOT, pHeader->nTableSize * sizeof(OTE)))
		return ImageReadError(imageFile);
	return S_OK;
}


// Load objects and repair the free list

template <size_t ImageNullTerms> HRESULT ObjectMemory::LoadObjects(ibinstream& imageFile, const ImageHeader* pHeader, size_t& cbRead)
{
	// Other free OTEs will be threaded in front of the first OTE off the end
	// of the currently committed table space. We set the free list pointer
	// to that OTE rather than NULL to distinguish attemps to access off the
	// end of the current table, which then allows us to dynamically grow it
	// on demand
	OTE* pEnd = m_pOT + pHeader->nTableSize;
	m_pFreePointerList = reinterpret_cast<OTE*>(pEnd);

#ifdef _DEBUG
	auto numObjects = NumPermanent;	// Allow for VM registry, etc!
#endif

#ifdef TRACKFREEOTEs
	m_nFreeOTEs = m_nOTSize - pHeader->nTableSize;
#endif

	size_t nDataSize = 0;
	for (OTE* ote = m_pOT + NumPermanent; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			size_t byteSize = ote->getSize();

			uintptr_t* oldLocation = reinterpret_cast<uintptr_t*>(ote->m_location);

			Object* pBody;

			// Allocate space for the object, and copy into that space
			if (ote->heapSpace() == Spaces::Virtual)
			{
				size_t maxAlloc;
				if (!imageFile.read(&maxAlloc, sizeof(maxAlloc)))
					return ImageReadError(imageFile);
				cbRead += sizeof(maxAlloc);

				pBody = reinterpret_cast<Object*>(AllocateVirtualSpace(maxAlloc, byteSize));
				ote->m_location = pBody;
			}
			else
			{
				if (ote->isNullTerminated())
				{
					ASSERT(!ote->isPointers());
					pBody = AllocObj(ote, byteSize + NULLTERMSIZE);
					if (NULLTERMSIZE > ImageNullTerms)
					{
						// Ensure we have a full null-terminator
						*reinterpret_cast<NULLTERMTYPE*>(static_cast<VariantByteObject*>(pBody)->m_fields+byteSize) = 0;
					}
					byteSize += ImageNullTerms;
				}
				else
				{
					pBody = AllocObj(ote, byteSize);
				}

			}

			markObject(ote);
			if (!imageFile.read(pBody, byteSize))
				return ImageReadError(imageFile);

			cbRead += byteSize;
			FixupObject(ote, oldLocation, pHeader);

#ifdef _DEBUG
			numObjects++;
#endif
		}
		else
		{
			// Thread onto the free list
			ote->m_location = MarkFree(m_pFreePointerList);
			m_pFreePointerList = ote;
#ifdef TRACKFREEOTEs
			m_nFreeOTEs++;
#endif
		}
	}

	// Note that we don't terminate the free list with a null, because
	// it must point off into space in order to get a GPF when it
	// needs to be expanded (at which point we commit more pages)

#ifdef TRACKFREEOTEs
	assert(m_nFreeOTEs == CountFreeOTEs());
#endif

#ifdef _DEBUG
	ASSERT(numObjects + m_nFreeOTEs == m_nOTSize);
	TRACESTREAM << std::dec << numObjects<< L", " << m_nFreeOTEs<< L" free" << std::endl;
#endif

	cbRead += nDataSize;
	return S_OK;
}

ST::Object* ObjectMemory::AllocObj(OTE * ote, size_t allocSize)
{
	ST::Object* pObj = static_cast<POBJECT>(allocChunk(allocSize));
	ote->m_flags.m_space = static_cast<space_t>(Spaces::Normal);
	ote->m_location = pObj;
	return pObj;
}

void ObjectMemory::FixupObject(OTE* ote, uintptr_t* oldLocation, const ImageHeader* pHeader)
{
	// Convert the class now separately
	BehaviorOTE* classPointer = reinterpret_cast<BehaviorOTE*>(FixupPointer(reinterpret_cast<OTE*>(ote->m_oteClass), static_cast<OTE*>(pHeader->BasePointer)));
#ifdef _DEBUG
	{
		PointersOTE* oteObj = reinterpret_cast<PointersOTE*>(ote);
		if (ote->isPointers() && (oteObj->getSize() % 2 == 1 ||
			classPointer == _Pointers.ClassByteArray ||
			classPointer == _Pointers.ClassAnsiString ||
			classPointer == _Pointers.ClassUtf8String ||
			classPointer == _Pointers.ClassSymbol))
		{
			TRACESTREAM<< L"Bad OTE for byte array " << LPVOID(&ote)<< L" marked as pointer" << std::endl;
			ote->beBytes();
		}
	}
#endif

	ote->m_oteClass = classPointer;

	if (ote->isPointers())
	{
		PointersOTE* otePointers = reinterpret_cast<PointersOTE*>(ote);
		VariantObject* obj = otePointers->m_location;

		const SmallUinteger numFields = ote->pointersSize();
		ASSERT(SmallInteger(numFields) >= 0);
		// Fixup all the Oops
		for (SmallUinteger i = 0; i < numFields; i++)
		{
			Oop instPointer = obj->m_fields[i];
			if (!isIntegerObject(instPointer))
				obj->m_fields[i] = Oop(FixupPointer(reinterpret_cast<OTE*>(instPointer), static_cast<OTE*>(pHeader->BasePointer)));
		}

		if (classPointer == _Pointers.ClassProcess)
		{
			Process* process = static_cast<Process*>(ote->m_location);
			// We use the callbackDepth slot to store the delta in location
			// which we later use to adjust all the stack references.
			// The previous value is lost, but this is not important
			// as it must be reestablished as zero anyway
			process->BasicSetCallbackDepth(Oop(process) - Oop(oldLocation) + 1);
		}
		// else
		// MethodContext objects contain a pointer to their frame in the
		// stack, but we must fix that up later when walking down the stack.
	}
	else
	{
		if (classPointer == _Pointers.ClassExternalHandle)
		{
			// In Dolphin 4.0, all ExternalHandles are automatically nulled
			// on image load.

			ExternalHandle* handle = static_cast<ExternalHandle*>(ote->m_location);
			handle->m_handle = NULL;
		}
		// Look for the special image stamp object
		else if (classPointer == _Pointers.ClassContext)
		{
			ASSERT(ote->heapSpace() == Spaces::Normal);

			// Can't deallocate now - must leave for collection later - maybe could go in the Zct though.
			VERIFY(ote->decRefs());
			deallocate(reinterpret_cast<OTE*>(ote));
		}
	}
}

void Process::PostLoadFix(ProcessOTE* oteThis)
{
	// Any overlapped call running when the image was saved is no longer valid, so
	// we must clear down the "pointer" and remove the back reference
	if (m_thread != reinterpret_cast<Oop>(Pointers.Nil))
	{
		m_thread = reinterpret_cast<Oop>(Pointers.Nil);
		oteThis->countDown();
	}

	// Patch any badly created or corrupted processes
	if (!ObjectMemoryIsIntegerObject(m_fpControl))
	{
		m_fpControl = ObjectMemoryIntegerObjectOf(_DN_SAVE | _RC_NEAR | _PC_64 | _EM_INEXACT | _EM_UNDERFLOW | _EM_OVERFLOW | _EM_DENORMAL);
	}

	Oop* pFramePointer = &m_suspendedFrame;
	Oop framePointer = *pFramePointer;
	const void* stackBase = m_stack;
	const void* stackEnd = reinterpret_cast<uint8_t*>(this) + oteThis->getSize() - 1;

	// Wind down the stack adjusting references to self as we go
	// Start with the suspended context
	const SmallInteger delta = m_callbackDepth - 1;
	while (isIntegerObject(framePointer) && framePointer != ZeroPointer)
	{
		framePointer += delta;
		if (framePointer < Oop(stackBase) || framePointer > Oop(stackEnd))
		{
			trace(L"Warning: Process at %#x has corrupt frame pointer at %#x which will be nilled\n", this, pFramePointer);
			*pFramePointer = Oop(Pointers.Nil);
			break;
		}
		else
			*pFramePointer += delta;

		StackFrame* pFrame = StackFrame::FromFrameOop(*pFramePointer);
		if (isIntegerObject(pFrame->m_bp))
		{
			pFrame->m_bp += delta;
		}

		ASSERT(reinterpret_cast<void*>(pFrame->m_bp) > stackBase && reinterpret_cast<void*>(pFrame->m_bp) < stackEnd);

		// If a stack only frame, then adjust the BP
		if (!isIntegerObject(pFrame->m_environment))
		{
			// The frame has an object context, we need to adjust
			// its back pointer to the frame if it is a MethodContext
			// The context objects contain no other addresses any more
			OTE* oteContext = reinterpret_cast<OTE*>(pFrame->m_environment);
			if (ObjectMemory::isAContext(oteContext))
			{
				Context* ctx = static_cast<Context*>(oteContext->m_location);
				if (isIntegerObject(ctx->m_frame) && ctx->m_frame != ZeroPointer)
				{
					ctx->m_frame += delta;
					ASSERT(reinterpret_cast<void*>(ctx->m_frame) > stackBase && reinterpret_cast<void*>(ctx->m_frame) < stackEnd);
				}
			}
		}

		// Adjust the contexts SP
		if (isIntegerObject(pFrame->m_sp))
		{
			pFrame->m_sp += delta;
			ASSERT(reinterpret_cast<void*>(pFrame->m_sp) >= stackBase && reinterpret_cast<void*>(pFrame->m_sp) <= stackEnd);
		}

		pFramePointer = &pFrame->m_caller;
		framePointer = *pFramePointer;
	}

	framePointer = SuspendedFrame();
	if (isIntegerObject(framePointer) && framePointer != ZeroPointer)
	{
		// The size of the process should exactly correspond with that required to
		// hold up to the SP of the suspended frame
		StackFrame* pFrame = StackFrame::FromFrameOop(framePointer);
		ptrdiff_t size = (pFrame->m_sp - 1) - reinterpret_cast<uintptr_t>(this) + sizeof(Oop);
		if (size > 0 && static_cast<size_t>(size) < oteThis->getSize())
		{
			TRACE(L"WARNING: Resizing process %p from %u to %u\n", oteThis, oteThis->getSize(), size);
			oteThis->setSize(size);
		}
	}
	// else its dead or not started yet

	// Later we'll use this slot to count the callback depth
	m_callbackDepth = ZeroPointer;
}

// There are some fixups that we can only apply after all the objects are loaded, because
// they involve reference from one object to other objects which may not be available
// during the normal load process. These fixes are applied here
void ObjectMemory::PostLoadFix()
{
	// Special case handling for Contexts because we store
	// the sp's as integers in the image file, but at
	// run-time they are expected to be direct pointers
	const OTE* pEnd = m_pOT + m_nOTSize;	// Loop invariant
	for (OTE* ote = m_pOT; ote < pEnd; ote++)
	{
		if (!ote->isFree())
		{
			if (ote->isBytes())
			{
#ifdef _DEBUG
				{
					// Its a byte object, and may be null terminated
					const Behavior* behavior = ote->m_oteClass->m_location;
					const BytesOTE* oteBytes = reinterpret_cast<const BytesOTE*>(ote);
					const VariantByteObject* object = oteBytes->m_location;
					ASSERT(behavior->m_instanceSpec.m_nullTerminated == ote->isNullTerminated());
				}
#endif
			}
			else if (ote->m_oteClass == _Pointers.ClassProcess)
			{
				ASSERT(ote->heapSpace() == Spaces::Virtual);
				ProcessOTE* oteProcess = reinterpret_cast<ProcessOTE*>(ote);
				Process* process = oteProcess->m_location;
				process->PostLoadFix(oteProcess);
			}
		}
	}

	ProtectConstSpace(PAGE_READONLY);

#if defined(_DEBUG) && 0
	{
		// Dump out the pointers
		TRACESTREAM << NumPointers<< L" VM Pointers..." << std::endl;
		for (auto i = 0; i < NumPointers; i++)
		{
			VariantObject* obj = static_cast<VariantObject*>(m_pConstObjs);
			POTE pote = POTE(obj->m_fields[i]);
			TRACESTREAM << i<< L": " << pote << std::endl;
		}
	}
#endif
}

DWORD ObjectMemory::ProtectConstSpace(DWORD dwNewProtect)
{
	if (dwNewProtect == PAGE_READONLY)
	{
		// Pointers have been modified, copy to cache
		memcpy(const_cast<VMPointers*>(&Pointers), &_Pointers, sizeof(Pointers));
	}

#ifdef NO_CONST_SPACE
	return PAGE_READWRITE;
#else
	DWORD dwOld;
	::VirtualProtect(m_pConstObjs, CONSTSPACESIZE, dwNewProtect, &dwOld);
	return dwOld;
#endif
}

