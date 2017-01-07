/******************************************************************************

	File: STContext.h

	Description:

	VM representation of Smalltalk Context class used for MethodContexts
	and BlockClosures.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "ote.h"
#include "STObject.h"
#include "STBlockClosure.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

// Declare forward references
namespace ST { class Context;  }
typedef TOTE<ST::Context> ContextOTE;

namespace ST
{
	class Context : public Object
	{
	public:
		// Outer environment, or SmallInteger frame pointer if a method env.
		union
		{
			Oop			m_frame;
			OTE*		m_outer;
		};
		BlockOTE*		m_block;
		Oop				m_tempFrame[];			// Environment temps only - args always in Process stack

		BOOL isBlockContext() const;


	public:
		// The environment pool must contain fixed size objects, so choose a suitable maximum number of
		// temps permissible; very uncommonly exceed even 1 environment (shared) temporaries
		// In fact quite often there are none since the Context is required just to support a ^-return
		enum { MaxEnvironmentTemps = 1 };

		enum { OuterIndex = ObjectFixedSize, BlockIndex, FixedSize };
		enum { TempFrameStart = FixedSize };

		static ContextOTE* __fastcall New(unsigned tempCount, Oop oopOuter);
	};

	///////////////////////////////////////////////////////////////////////////////
	inline BOOL Context::isBlockContext() const
	{
		return !isIntegerObject(m_frame);
	}
}
