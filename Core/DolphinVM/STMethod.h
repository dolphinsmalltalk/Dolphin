/******************************************************************************

	File: STMethod.h

	Description:

	VM representation of method related Smalltalk classes.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"
#include "STBehavior.h"
#include "DolphinSmalltalk_i.h"

#ifdef VM
#include "STString.h"
#else
typedef OTE SymbolOTE;
#endif

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

namespace ST
{
	class CompiledMethod : public Object
	{
	public:
		STMethodHeader	m_header;		// Must look like a small integer
		BehaviorOTE*	m_methodClass;
		SymbolOTE*		m_selector;
		Oop				m_source;
		Oop				m_byteCodes;	// ByteArray of byte codes
		Oop				m_aLiterals[];

		enum { HeaderIndex = ObjectFixedSize, MethodClassIndex, SelectorIndex, SourceIndex, ByteCodesIndex, FixedSize };
		enum { LiteralStart = FixedSize };
	};
}

typedef TOTE<ST::CompiledMethod> MethodOTE;

// Debug dumpers
std::wostream& operator<<(std::wostream& st, const MethodOTE*);
std::wostream& operator<<(std::wostream& st, const ST::CompiledMethod&);
