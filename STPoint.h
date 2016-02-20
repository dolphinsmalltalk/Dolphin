/******************************************************************************

	File: STPoint.h

	Description:

	VM representation of Smalltalk Point class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STMagnitude.h"

namespace ST
{
	class Point : public ArithmeticValue
	{
	public:
		Oop	m_x;
		Oop	m_y;

		enum { XIndex = ArithmeticValue::FixedSize, YIndex, FixedSize };
	};
}
