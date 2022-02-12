#include "Interprt.h"
#pragma once

///////////////////////////////////////////////////////////////////////////////
// Functors for instantiating primitive templates

struct StoreSmallInteger
{
	__forceinline constexpr void operator()(Oop* const sp, SmallInteger value)
	{
		*sp = ObjectMemoryIntegerObjectOf(value);
	}
};

struct StoreUIntPtr
{
	__forceinline void operator()(Oop* const sp, uintptr_t ptr)
	{
		if (ObjectMemoryIsPositiveIntegerValue(ptr))
		{
			*sp = ObjectMemoryIntegerObjectOf(ptr);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewUnsigned(ptr);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

struct StoreIntPtr
{
	__forceinline void operator()(Oop* const sp, intptr_t ptr)
	{
		if (ObjectMemoryIsIntegerValue(ptr))
		{
			*sp = ObjectMemoryIntegerObjectOf(ptr);
		}
		else
		{
			LargeIntegerOTE* oteLi = LargeInteger::liNewSigned32(ptr);
			*sp = reinterpret_cast<Oop>(oteLi);
			ObjectMemory::AddToZct((OTE*)oteLi);
		}
	}
};

struct StoreUnsigned64
{
	__forceinline void operator()(Oop* const sp, uint64_t dwValue)
	{
		Oop result = LargeInteger::NewUnsigned64(dwValue);
		*sp = result;
		ObjectMemory::AddOopToZct(result);
	}
};

struct StoreSigned64
{
	__forceinline void operator()(Oop* const sp, uint64_t dwValue)
	{
		Oop result = LargeInteger::NewSigned64(dwValue);
		*sp = result;
		ObjectMemory::AddOopToZct(result);
	}
};



