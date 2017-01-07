/******************************************************************************

	File: STVirtualObject.h

	Description:

	VM representation of virtual memory (i.e. dynamically expandable) object 
	base class.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"

namespace ST
{
	class VirtualObjectHeader
	{
		MWORD	m_dwMaxAlloc;

	public:
		void	setCurrentAllocation(MWORD size) { ASSERT(size == getCurrentAllocation()); size; }
		MWORD	getCurrentAllocation();
		void	addPage() { /*getObj()->m_size += dwPageSize;*/ }
		MWORD	getMaxAllocation() { return m_dwMaxAlloc; }
		void	setMaxAllocation(MWORD dwSize) { m_dwMaxAlloc = dwSize; }
	};

	inline MWORD VirtualObjectHeader::getCurrentAllocation()
	{
		MEMORY_BASIC_INFORMATION mbi;
		VERIFY(::VirtualQuery(this, &mbi, sizeof(mbi)) == sizeof(mbi));
		ASSERT(mbi.AllocationBase == this);
		ASSERT(mbi.BaseAddress == mbi.AllocationBase);
		ASSERT(mbi.AllocationProtect == PAGE_NOACCESS);
		ASSERT(mbi.Protect == PAGE_READWRITE);
		ASSERT(mbi.State == MEM_COMMIT);
		ASSERT(mbi.Type == MEM_PRIVATE);
		return mbi.RegionSize;
	}

	class VirtualObject  : public Object
	{
	public:

		VirtualObjectHeader* getHeader() { return reinterpret_cast<VirtualObjectHeader*>(this) - 1; }
	};
}

typedef TOTE<ST::VirtualObject> VirtualOTE;
