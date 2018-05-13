#include "Ist.h"

#ifndef _DEBUG
#pragma optimize("s", on)
#pragma auto_inline(off)
#endif

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

template <class P> __forceinline static Oop* primitiveIntegerCompare(Oop* const sp, const P &pred)
{
	// Normally it is better to jump on the failure case as the static prediction is that forward
	// jumps are not taken, but these primitives are normally only invoked when the special bytecode 
	// has triggered the fallback method, which suggests the arg will not be a SmallInteger, so 
	// the 99% case is that the primitive should fail
	Oop arg = *sp;
	if (!ObjectMemoryIsIntegerObject(arg))
		return nullptr;

	Oop receiver = *(sp - 1);
	// We can perform the comparisons without shifting away the SmallInteger bit since it always 1
	*(sp - 1) = reinterpret_cast<Oop>(pred(receiver, arg) ? Pointers.True : Pointers.False);
	return sp - 1;
}

Oop* __fastcall Interpreter::primitiveLessThan(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x < y; } };
	
	return primitiveIntegerCompare(sp, op());
}

Oop* __fastcall Interpreter::primitiveGreaterThan(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x > y; } };

	return primitiveIntegerCompare(sp, op());
}

Oop* __fastcall Interpreter::primitiveLessOrEqual(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x <= y; } };

	return primitiveIntegerCompare(sp, op());
}

Oop* __fastcall Interpreter::primitiveGreaterOrEqual(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x >= y; } };

	return primitiveIntegerCompare(sp, op());
}

Oop* __fastcall Interpreter::primitiveEqual(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x == y; } };

	return primitiveIntegerCompare(sp, op());
}

Oop* __fastcall Interpreter::primitiveNotEqual(Oop* const sp, unsigned)
{
	struct op { bool operator()(SMALLINTEGER x, SMALLINTEGER y) const { return x != y; } };

	return primitiveIntegerCompare(sp, op());
}

