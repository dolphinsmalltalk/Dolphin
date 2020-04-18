/******************************************************************************

	File: STAssoc.h

	Description:

	VM representation of Smalltalk Point class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"

namespace ST
{
	class VariableBinding // : public Object
	{
	public:
		StringOTE* m_key;
		Oop m_value;

		static constexpr size_t KeyIndex = Object::FixedSize;
		static constexpr size_t ValueIndex = KeyIndex + 1;
		static constexpr size_t FixedSize = ValueIndex + 1;
	};
}

typedef TOTE<ST::VariableBinding> VariableBindingOTE;
