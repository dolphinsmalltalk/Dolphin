/******************************************************************************

	File: STPoint.h

	Description:

	VM representation of Smalltalk Point class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STPOINT_H_
#define _IST_STPOINT_H_

#include "STMagnitude.h"

class Point : public ArithmeticValue
{
public:
	Oop	m_x;
	Oop	m_y;

	enum { XIndex=ArithmeticValue::FixedSize, YIndex, FixedSize };
};

#endif	//EOF