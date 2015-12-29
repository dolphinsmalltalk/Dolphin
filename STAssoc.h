/******************************************************************************

	File: STAssoc.h

	Description:

	VM representation of Smalltalk Point class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STAssoc_H_
#define _IST_STAssoc_H_

#include "STObject.h"

class VariableBinding // : public Object
{
public:
	Oop m_key;
	Oop m_value;

	enum { KeyIndex=ObjectFixedSize, ValueIndex, FixedSize };
};

typedef TOTE<VariableBinding> VariableBindingOTE;

#endif	//EOF