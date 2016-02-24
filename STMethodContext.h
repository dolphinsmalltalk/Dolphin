/******************************************************************************

	File: STMethodContext.h

	Description:

	VM representation of Smalltalk MethodContext class.

	MethodContext is used where some context must be captured for blocks.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STContext.h"
