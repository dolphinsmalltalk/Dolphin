/******************************************************************************

	File: ObjMemInit.cpp

	Description:

	Object Memory initialization members.

******************************************************************************/

#include "Ist.h"
#pragma code_seg(INIT_SEG)

#ifdef NDEBUG
	// Not time critical, so optimize for minimal space
	#pragma optimize("s", on)
	// Compile auto inlining is too stupid
	#pragma auto_inline(off)
#endif


#include "ObjMem.h"
#include "ObjMemPriv.inl"
#include "Interprt.h"
#include "rc_vm.h"
#include "VMExcept.h"
#include "regkey.h"

// Smalltalk classes
#include "STContext.h"
#include "STBlockClosure.h"
#include "STCharacter.h"
#include "STMemoryManager.h"

///////////////////////////////////////////////////////////////////////////////

static HRESULT getSystemInfo()
{
	SYSTEM_INFO sysInfo;
	::GetSystemInfo(&sysInfo);
	// Like the C-runtime library, we assume that the page size is 4K. This allows
	// the compiler to generate more efficient code for rounding to page sizes etc.
	//dwPageSize = sysInfo.dwPageSize;
	//dwOopsPerPage = dwPageSize/sizeof(Oop);
	//dwAllocationGranularity = sysInfo.dwAllocationGranularity;
	if (sysInfo.dwPageSize != dwPageSize || dwAllocationGranularity != sysInfo.dwAllocationGranularity)
		return ReportError(IDP_BADSYSINFO, sysInfo.dwPageSize, sysInfo.dwAllocationGranularity, dwPageSize, dwAllocationGranularity);

	return S_OK;
}

void ObjectMemory::FixedSizePool::Initialize()
{
	m_pFreePages = NULL;
	m_pAllocations = NULL;
	m_nAllocations = 0;
}

HRESULT ObjectMemory::Initialize()
{
	// Assembler will need to be modified if these are not the case
	ASSERT(sizeof(Oop) == sizeof(uint32_t));
	ASSERT(sizeof(InstanceSpecification) == sizeof(Oop));
	ASSERT(sizeof(OTE) == 16);
	ASSERT(sizeof(OTEFlags) == 1);
	ASSERT(sizeof(count_t) == 1);
	ASSERT(sizeof(hash_t) == 2);
	ASSERT(sizeof(STMethodHeader) == sizeof(Oop));
	ASSERT(OTEFlags::NumSpaces <= 8);
	ASSERT(Context::FixedSize == 2);
	ASSERT(BlockClosure::FixedSize == 5);
	ASSERT(sizeof(BlockCopyExtension) == sizeof(uint32_t));
	ASSERT(MinObjectSize >= sizeof(Oop));
	ASSERT(_ROUND2(MinObjectSize,sizeof(Oop)) == MinObjectSize);
	//ASSERT(sizeof(Object) == ObjectHeaderSize*sizeof(MWORD));
	ASSERT(sizeof(VMPointers) == (192*sizeof(Oop)+ObjectByteSize));
	// Check that the const objects segment is still exactly one page
	ASSERT((sizeof(VMPointers)
			+ ((FirstCharacterIdx - FirstBuiltInIdx) * ObjectByteSize)
			+ (sizeof(uint32_t)*2)	// To round up the strings
			+ (256 * sizeof(Character))
			+ 2296	// Padding allocated in the assembler, see constobj.asm
			) == dwPageSize);

//	InitializeCriticalSection(&m_csAsyncProtect);

	getSystemInfo();

	#ifdef _DEBUG
		// Get the current state of the flag
		// and store it in a temporary variable
		int tmpFlag = _CrtSetDbgFlag( _CRTDBG_REPORT_FLAG );

		// Turn On (OR) - Keep freed memory blocks in the
		// heap’s linked list and mark them as freed
		//tmpFlag |= _CRTDBG_DELAY_FREE_MEM_DF;

		//tmpFlag |= _CRTDBG_LEAK_CHECK_DF;

		// Set the new state for the flag
		_CrtSetDbgFlag( tmpFlag );
	#endif

	HRESULT hr = InitializeZct();
	if (FAILED(hr))
		return hr;

	FixedSizePool::Initialize();

	m_nNextIdHash = 1 << 16 | 1;
	m_nOTSize = OTDefaultSize;
	m_nOTMax = OTDefaultMax;
	//m_pOT does not need to be initialized
	//m_pFreePointerList does not need to be initialized

	// N.B. By default the blank flags of NormalSpace is set up for pointer objects 
	// as these are more frequently allocated

	for (auto i=0;i<OTEFlags::NumSpaces;i++)
	{
		m_spaceOTEBits[i].m_free		= FALSE;
		m_spaceOTEBits[i].m_pointer		= TRUE;
		m_spaceOTEBits[i].m_mark		= FALSE;			// Initial mark is set from Pointers.Nil later
		m_spaceOTEBits[i].m_finalize	= FALSE;
		m_spaceOTEBits[i].m_weakOrZ		= FALSE;
		m_spaceOTEBits[i].m_space		= i;
	}

	// Certain spaces contain byte objects
	m_spaceOTEBits[static_cast<space_t>(Spaces::Dwords)].m_pointer	= FALSE;
	m_spaceOTEBits[static_cast<space_t>(Spaces::Heap)].m_pointer	= FALSE;
	m_spaceOTEBits[static_cast<space_t>(Spaces::Floats)].m_pointer	= FALSE;

	//MaxSizeOfPoolObject = PoolObjectSizeLimit;
	//NumPools =  MaxPools;

	//CRegKey rk;
	//if (OpenDolphinKey(rk, "") == ERROR_SUCCESS)
	//{
	//	rk.QueryDWORDValue("PoolThreshold", MaxSizeOfPoolObject);
	//	if (MaxSizeOfPoolObject > PoolObjectSizeLimit)
	//		MaxSizeOfPoolObject = PoolObjectSizeLimit;
	//	NumPools = MaxSizeOfPoolObject < MinObjectSize ? 0 : 
	//				(MaxSizeOfPoolObject-MinObjectSize)/PoolGranularity + 1;
	//	ASSERT(NumPools >= 0 && NumPools <= MaxPools);
	//}

 	for (auto j=0;j<NumPools;j++)
		m_pools[j].setSize(MinObjectSize << j);

	// Ensure we can write to const space in order to initialie it
	m_pConstObjs = &_Pointers;
	ProtectConstSpace(PAGE_READWRITE);

	if (!m_hHeap)
	{
		// Reinitialize the heaps each time through as gets deleted on terminate
		m_hHeap = ::HeapCreate(HEAP_NO_SERIALIZE|HEAP_GENERATE_EXCEPTIONS, HEAPINITPAGES*dwPageSize, 0);
		if (!m_hHeap)
			::RaiseException(STATUS_NO_MEMORY, EXCEPTION_NONCONTINUABLE, 0, NULL);
		_crtheap = m_hHeap;
		// Allocates a header block from the heap for the small block heap
		__sbh_heap_init(MAX_ALLOC_DATA_SIZE);
	}

	return S_OK;
}

void ObjectMemory::InitializeMemoryManager()
{
	MemoryManager* memMan = memoryManager();

	// This is useful for image to know for launching processes (setting up the launch blocks
	// initial IP) and by not hardcoding it in the image we can avoid the problems I always
	// seem to get into when I change it.
	memMan->m_objectHeaderSize = integerObjectOf(SizeOfPointers(0));
	memMan->m_maxObjects = integerObjectOf(ObjectMemory::m_nOTMax);
}

extern HMODULE GetModuleContaining(LPCVOID pFunc);

// Answer the module handle of the implicitly linked CRT library so that the Smalltalk
// code can use the correct one (it is stored in the VM shared object registry).
static HMODULE GetCRTHandle()
{
	return GetModuleContaining(atoi);
}

HRESULT ObjectMemory::InitializeImage()
{
	DWORD dwOldProtect = ProtectConstSpace(PAGE_READWRITE);
	_Pointers.KernelHandle = ExternalHandle::New(::GetModuleHandleW(L"KERNEL32"));
	_Pointers.KernelHandle->beSticky();
	_Pointers.VMHandle = ExternalHandle::New(GetModuleContaining(InitializeImage));
	_Pointers.VMHandle->beSticky();
	_Pointers.DolphinHandle = ExternalHandle::New(GetApplicationInstance());
	_Pointers.DolphinHandle->beSticky();
	_Pointers.CRTHandle = ExternalHandle::New(GetCRTHandle());
	_Pointers.CRTHandle->beSticky();
	_Pointers.ImageVersionMajor = integerObjectOf(m_imageVersionMajor);
	_Pointers.ImageVersionMinor = integerObjectOf(m_imageVersionMinor);
	_Pointers.MsgWndHandle = ExternalHandle::New(Interpreter::m_hWndVM);
	_Pointers.MsgWndHandle->beSticky();
	ProtectConstSpace(dwOldProtect);

	return S_OK;
}

