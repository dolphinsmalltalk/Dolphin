#pragma once
#include "Utf16StringBuf.h"
#include <memory.h>

///////////////////////////////////////////////////////////////////////////////
// Functors for instantiating primitive templates

struct CmpIA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		return ::CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE | LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
	}
};
struct CmpIW
{
	__forceinline int operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
	{
		return ::CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE, (PCNZWCH)psz1, cch1, (PCNZWCH)psz2, cch2) - 2;
	}
};

struct CmpA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		// lstrcmpA will stop at the first embedded null, and although our strings have a null
		// terminator, they can also contain embedded nulls, and whole string should be compared.
		// lstrcmpA is just a wrapper around CompareStringA. It passes the same values for locale and flags.
		return CompareStringA(LOCALE_USER_DEFAULT, LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
	}
};
struct CmpW
{
	__forceinline int operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
	{
		// lstrcmpW is just a wrapper around CompareStringA. It passes the same values for locale and flags.
		return CompareStringW(LOCALE_USER_DEFAULT, 0, (PCNZWCH)psz1, cch1, (PCNZWCH)psz2, cch2) - 2;
	}
};

///////////////////////////////////////////////////////////////////////////////
// Primitive templates

// Could double-dispatch this rather than handling all this in one set of primitives in the VM
// or at least define one primitive for each string class, but it would mean adding quite a lot of methods, 
// so this keeps the ST side cleaner by hiding the switch in the VM.
// This should also be faster as the intermediate conversions can usually be performed on the stack
// and so do not require any allocations.
template <typename T, class OpA, class OpW, bool Utf8_OpA> __forceinline static T AnyStringCompare(const OTE* oteReceiver, const OTE* oteArg)
{
	switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
	{
	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
		// This is the one case where we can use an Ansi comparison. It can't (generally) be used for CP_UTF8.
		return OpA()(reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize(),
			reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());

	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
	{
		Utf16StringBuf receiverW(Interpreter::m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		Utf16StringBuf argW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(receiverW, receiverW.Count, argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
	{
		Utf16StringBuf receiverW(Interpreter::m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		return OpW()(receiverW, receiverW.Count,
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize() / sizeof(Utf16String::CU));
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):
	{
		Utf16StringBuf receiverW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		Utf16StringBuf argW(Interpreter::m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(receiverW, receiverW.Count, argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
	{
		if (Utf8_OpA)
		{
			return OpA()(
				reinterpret_cast<LPCSTR>(reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters),
				oteReceiver->getSize(),
				reinterpret_cast<LPCSTR>(reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters),
				oteArg->getSize());
		}
		else
		{
			Utf16StringBuf receiverW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
			Utf16StringBuf argW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
			return OpW()(receiverW, receiverW.Count, argW, argW.Count);
		}
	}

	case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
	{
		Utf16StringBuf receiverW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize());
		return OpW()(receiverW, receiverW.Count,
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize() / sizeof(Utf16String::CU));
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
	{
		Utf16StringBuf argW(Interpreter::m_ansiCodePage, reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters,
			oteReceiver->getSize() / sizeof(Utf16String::CU), argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
	{
		Utf16StringBuf argW(CP_UTF8, (LPCCH)reinterpret_cast<const Utf8StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
		return OpW()(reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize() / sizeof(Utf16String::CU), argW, argW.Count);
	}

	case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
	{
		return OpW()(
			reinterpret_cast<const Utf16StringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize() / sizeof(Utf16String::CU),
			reinterpret_cast<const Utf16StringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize() / sizeof(Utf16String::CU));
	}
	default:
		return OpA()(reinterpret_cast<const AnsiStringOTE*>(oteReceiver)->m_location->m_characters, oteReceiver->getSize(),
			reinterpret_cast<const AnsiStringOTE*>(oteArg)->m_location->m_characters, oteArg->getSize());
	}
}

template <class OpA, class OpW> static Oop* __fastcall Interpreter::primitiveStringComparison(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				// Could double-dispatch this rather than handling all this in one
				// primitive, or at least define one primitive for each string class, but it would mean
				// adding quite a lot of methods, so this keeps the ST side cleaner by hiding the switch in the VM.
				// This should also be faster as the intermediate conversions can usually be performed on the stack
				// and so do not require any allocations.
				int cmp = AnyStringCompare<int, OpA, OpW, false>(oteReceiver, oteArg);
				*(sp - 1) = integerObjectOf(cmp);
				return sp - 1;
			}
			else
			{
				// Arg not a null terminated byte object
				return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
			}
		}
		else
		{
			// Identical
			*(sp - 1) = ZeroPointer;
			return sp - 1;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

struct EqualA
{
	__forceinline bool operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		return cch1 == cch2 && memcmp(psz1, psz2, cch1) == 0;
	}
};
struct EqualW
{
	__forceinline bool operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
	{
		return cch1 == cch2 && ::CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, FALSE) == CSTR_EQUAL;
	}
};


struct CmpOrdinalIA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		// It might be possible to use _memicmp_l here to compare without conversion, but there may be subtle differences depending on the _locale_t we pass.
		// As we want this comparison to be true to the OS ordinal comparison, it is safest just to convert and call the correct API

		Utf16StringBuf string1(Interpreter::m_ansiCodePage, psz1, cch1);
		Utf16StringBuf string2(Interpreter::m_ansiCodePage, psz2, cch2);
		return ::CompareStringOrdinal(string1, string1.Count, string2, string2.Count, TRUE) - 2;
	}
};

struct CmpOrdinalIW
{
	__forceinline int operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
	{
		return ::CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, TRUE) - 2;
	}
};

struct EqualIA
{
	__forceinline bool operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		return cch1 == cch2 && CmpOrdinalIA()(psz1, cch1, psz2, cch2) == 0;
	}
};

struct EqualIW
{
	__forceinline bool operator() (const Utf16String::CU* psz1, size_t cch1, const Utf16String::CU* psz2, size_t cch2) const
	{
		return cch1 == cch2 && ::CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, TRUE) == CSTR_EQUAL;
	}
};

template <class OpA, class OpW, bool Utf8_OpA> static Oop* __fastcall Interpreter::primitiveStringEqual(Oop* sp, primargcount_t argc)
{
	Oop oopArg = *sp;
	const OTE* oteReceiver = reinterpret_cast<const OTE*>(*(sp - 1));
	if (!ObjectMemoryIsIntegerObject(oopArg))
	{
		const OTE* oteArg = reinterpret_cast<const OTE*>(oopArg);
		if (oteArg != oteReceiver)
		{
			if (oteArg->isNullTerminated())
			{
				bool equal = AnyStringCompare<bool, OpA, OpW, Utf8_OpA>(oteReceiver, oteArg);
				*(sp - 1) = reinterpret_cast<Oop>(equal ? Pointers.True : Pointers.False);
				return sp - 1;
			}
			else
			{
				// Arg not a null terminated byte object
				return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
			}
		}
		else
		{
			// Identical, therefore equal
			*(sp - 1) = reinterpret_cast<Oop>(Pointers.True);
			return sp - 1;
		}
	}
	else
	{
		// Arg is a SmallInteger
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

static void hashCombine(char32_t& ch, uint32_t& hash);
