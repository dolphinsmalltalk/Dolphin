#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

Oop* PRIMCALL Interpreter::primitiveStringAsUtf32String(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	case StringEncoding::Utf8:
	case StringEncoding::Utf16:
		// TODO: Implement conversions to UTF-32 strings
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	case StringEncoding::Utf32:
		return sp;

	default:
		// Unrecognised encoding - fail the primitive.
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}
