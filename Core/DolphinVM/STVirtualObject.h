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
		uintptr_t	m_maxAlloc;
		uintptr_t	m_reserved1;
		uintptr_t	m_reserved2;
		BOOL		m_bFxSaved;
		uint8_t		m_fxSaveArea[512];

	public:
		void		setCurrentAllocation(uintptr_t size) { ASSERT(size == getCurrentAllocation()); size; }
		uintptr_t	getCurrentAllocation();
		
		uintptr_t	getMaxAllocation() { return m_maxAlloc; }
		void	setMaxAllocation(MWORD dwSize) { m_maxAlloc = dwSize; }

		void	fxSave() 
		{ 
			m_bFxSaved = TRUE;
			_fxsave(m_fxSaveArea); 
		}

		bool fxRestore() 
		{
			if (m_bFxSaved)
			{
				_fxrstor(m_fxSaveArea);
				return true;
			}
			else
				return false;
		}
	};

	inline uintptr_t VirtualObjectHeader::getCurrentAllocation()
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
