/******************************************************************************

	File: STMethodHeader.h

	Description:

	VM representation of Smalltalk method header word.

	N.B. This structure is well known to the VM, and must not
	be modified in the image. Note also that their may also be
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

typedef enum { 
	PRIMITIVE_ACTIVATE_METHOD = 0,
	PRIMITIVE_RETURN_SELF = 1,
	PRIMITIVE_RETURN_TRUE = 2,
	PRIMITIVE_RETURN_FALSE = 3,
	PRIMITIVE_RETURN_NIL = 4,
	PRIMITIVE_RETURN_LITERAL_ZERO = 5,
	PRIMITIVE_RETURN_INSTVAR = 6,
	PRIMITIVE_SET_INSTVAR = 7,
	PRIMITIVE_RETURN_STATIC_ZERO=8,
	PRIMITIVE_MAX = 255
} STPrimitives;

typedef struct STMethodHeader
{
	uint8_t isInt 				: 1;	// MUST be 1 (to avoid treatment as object)
	uint8_t isPrivate			: 1;
	uint8_t envTempCount		: 6;	// Note that this is actually count+1
	uint8_t stackTempCount;
	uint8_t argumentCount;
	uint8_t primitiveIndex;
} STMethodHeader;
