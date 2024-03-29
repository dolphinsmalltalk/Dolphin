#pragma once
#include "Utf16StringBuf.h"
#include "Utf8StringBuf.h"
#include <memory.h>

static void hashCombine(char32_t& ch, uint32_t& hash);

///////////////////////////////////////////////////////////////////////////////
// Functors for instantiating primitive templates

struct CmpA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		// lstrcmpA will stop at the first embedded null, and although our strings have a null
		// terminator, they can also contain embedded nulls, and whole string should be compared.
		// lstrcmpA is just a wrapper around CompareStringA. It passes the same values for locale and flags.
		return ::CompareStringA(LOCALE_USER_DEFAULT, LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
	}
};
struct CmpW
{
	__forceinline int operator() (const char16_t* psz1, size_t cch1, const char16_t* psz2, size_t cch2) const
	{
		// lstrcmpW is just a wrapper around CompareStringA. It passes the same values for locale and flags.
		return ::CompareStringW(LOCALE_USER_DEFAULT, 0, (PCNZWCH)psz1, cch1, (PCNZWCH)psz2, cch2) - 2;
	}
};

struct CmpOrdinalIA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		// It might be possible to use _memicmp_l here to compare without conversion, but there may be subtle differences depending on the _locale_t we pass.
		// As we want this comparison to be true to the OS ordinal comparison, it is safest just to convert and call the correct API

		Utf16StringBuf string1(psz1, cch1);
		Utf16StringBuf string2(psz2, cch2);
		return ::CompareStringOrdinal(string1, string1.Count, string2, string2.Count, TRUE) - 2;
	}
};

struct CmpOrdinalIW
{
	__forceinline int operator() (const char16_t* psz1, size_t cch1, const char16_t* psz2, size_t cch2) const
	{
		return ::CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, TRUE) - 2;
	}
};

struct CmpIA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		return ::CompareStringA(LOCALE_USER_DEFAULT, NORM_IGNORECASE | LOCALE_USE_CP_ACP, psz1, cch1, psz2, cch2) - 2;
	}
};
struct CmpIW
{
	__forceinline int operator() (const char16_t* psz1, size_t cch1, const char16_t* psz2, size_t cch2) const
	{
		return ::CompareStringW(LOCALE_USER_DEFAULT, NORM_IGNORECASE | NORM_LINGUISTIC_CASING, (PCNZWCH)psz1, cch1, (PCNZWCH)psz2, cch2) - 2;
	}
};

struct CmpOrdinalA
{
	__forceinline int operator() (LPCSTR psz1, size_t cch1, LPCSTR psz2, size_t cch2) const
	{
		int cmp = memcmp(psz1, psz2, min(cch1, cch2));
		return cmp == 0 && cch1 != cch2
			? cch1 < cch2 ? -1 : 1
			: cmp;
	}
};

