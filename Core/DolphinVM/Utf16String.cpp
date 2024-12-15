#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

#include "Utf16StringBuf.h"

//#define SIMPLE_UTF16_2_UTF8 1

void Utf16StringBuf::FromUtf8(const char8_t* psz8, size_t cch8)
{
	m_cwch = LengthOfUtf8(psz8, cch8);
	if (m_cwch >= _countof(m_wcsBuf))
	{
		m_pBuf = new char16_t[m_cwch + 1];
		// If alloc returns nullptr, then will fail below with benign AV
	}

	char16_t* pEnd = ConvertUtf8_unsafe(psz8, cch8, m_pBuf);
	ASSERT(pEnd == m_pBuf + m_cwch);
	*pEnd = L'\0';
}

#if defined (SIMPLE_UTF16_2_UTF8)

size_t Utf16StringBuf::LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	size_t cwch = 0;
	size_t i = 0;
	while (i < cch8)
	{
		char32_t c;
		U8_NEXT_OR_FFFD(psz8, i, cch8, c);
		cwch += U16_LENGTH(c);
	}
	return cwch;
}

char16_t* Utf16StringBuf::ConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char16_t* __restrict pwszDest)
{
	size_t i = 0;
	while (i < cch8Src)
	{
		char32_t c;
		U8_NEXT_OR_FFFD(psz8Src, i, cch8Src, c);
		if (U_IS_BMP(c))
		{
			*pwszDest++ = static_cast<char16_t>(c);
		}
		else
		{
			*pwszDest++ = U16_LEAD(c);
			*pwszDest++ = U16_TRAIL(c);
		}
	}
	return pwszDest;
}
#else

// Slightly simplified version of internal ICU function
static char32_t utf8_nextCharSafeBody(const char8_t* __restrict s, size_t length, size_t& index, char32_t c) {
	// index is one after byte c.
	size_t i = index;
	if (i == length || c > 0xf4) {
		// end of string, or not a lead byte
	}
	else if (c >= 0xf0) {
		// Test for 4-byte sequences first because
		// U8_NEXT() handles shorter valid sequences inline.
		char8_t t1 = s[i], t2, t3;
		c &= 7;
		if (U8_IS_VALID_LEAD4_AND_T1(c, t1) &&
			++i != length && (t2 = s[i] - 0x80) <= 0x3f &&
			++i != length && (t3 = s[i] - 0x80) <= 0x3f) {
			index = i + 1;
			return (c << 18) | ((t1 & 0x3f) << 12) | (t2 << 6) | t3;
		}
	}
	else if (c >= 0xe0) {
		c &= 0xf;
		char8_t t1 = s[i], t2;
		if (U8_IS_VALID_LEAD3_AND_T1(c, t1) &&
			++i != length && (t2 = s[i] - 0x80) <= 0x3f) {
			index = i + 1;
			return (c << 12) | ((t1 & 0x3f) << 6) | t2;
		}
	}
	else if (c >= 0xc2) {
		char8_t t1 = s[i] - 0x80;
		if (t1 <= 0x3f) {
			index = i + 1;
			return ((c - 0xc0) << 6) | t1;
		}
	}  // else 0x80<=c<0xc2 is not a lead byte

	/* error handling */
	index = i;
	return Interpreter::UnicodeReplacementChar;
}

size_t Utf16StringBuf::LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	size_t cwch = 0;
	size_t i = 0;
	while (i < cch8)
	{
		// modified copy of U8_NEXT()
		auto ch8 = psz8[i++];
		if (U8_IS_SINGLE(ch8))
		{
			++cwch;
		}
		else
		{
			if ( /* handle U+0800..U+FFFF inline */
				(0xe0 <= ch8 && ch8 < 0xf0) &&
				(i + 1) < cch8 &&
				U8_IS_VALID_LEAD3_AND_T1(ch8, psz8[i]) &&
				(static_cast<char8_t>(psz8[i + 1] - 0x80) <= 0x3f))
			{
				++cwch;
				i += 2;
			}
			else if ( /* handle U+0080..U+07FF inline */
				(ch8 < 0xe0 && ch8 >= 0xc2) &&
				(i != cch8) &&
				(static_cast<char8_t>(psz8[i] - 0x80) <= 0x3f))
			{
				++cwch;
				++i;
			}
			else
			{
				/* function call for "complicated" and error cases */
				char32_t cp = utf8_nextCharSafeBody(psz8, cch8, i, ch8);
				cwch += U16_LENGTH(cp);
			}
		}
	}
	return cwch;
}

char16_t* Utf16StringBuf::ConvertUtf8_unsafe(const char8_t* __restrict psz8, size_t cch8Src, char16_t* __restrict pwszDest)
{
	char16_t* pwch = pwszDest;

	// Even if the UTF-16 code unit count is the same as the UTF-8, we can't perform a straight 
	// copy as we may need to convert invalid code units to the replacement char

	size_t i = 0;
	while (i < cch8Src) {
		// modified copy of U8_NEXT()
		auto ch8 = psz8[i++];
		if (U8_IS_SINGLE(ch8)) {
			*pwch++ = static_cast<char16_t>(ch8);
		}
		else {
			uint8_t __t1, __t2;
			if ( /* handle U+0800..U+FFFF inline */
				(0xe0 <= ch8 && ch8 < 0xf0) &&
				(i + 1) < cch8Src &&
				U8_IS_VALID_LEAD3_AND_T1(ch8, psz8[i]) &&
				(__t2 = psz8[(i)+1] - 0x80) <= 0x3f) {
				*pwch++ = ((ch8 & 0xf) << 12) | ((psz8[i] & 0x3f) << 6) | __t2;
				i += 2;
			}
			else if ( /* handle U+0080..U+07FF inline */
				(ch8 < 0xe0 && ch8 >= 0xc2) &&
				(i != cch8Src) &&
				(__t1 = psz8[i] - 0x80) <= 0x3f) {
				*pwch++ = ((ch8 & 0x1f) << 6) | __t1;
				++i;
			}
			else {
				/* function call for "complicated" and error cases */
				char32_t cp = utf8_nextCharSafeBody(psz8, cch8Src, i, ch8);
				if (cp <= 0xFFFF) {
					*pwch++ = static_cast<char16_t>(cp);
				}
				else {
					*pwch++ = U16_LEAD(cp);
					*pwch++ = U16_TRAIL(cp);
				}
			}
		}
	}
	return pwch;
}


#endif

void Utf16StringBuf::FromAnsi(const char* psz, size_t cch)
{
	m_cwch = LengthOfAnsi(psz, cch);
	if (m_cwch >= _countof(m_wcsBuf))
	{
		m_pBuf = new char16_t[m_cwch + 1];
		// If alloc returns nullptr, then will fail below with benign AV
	}

	char16_t* pEnd = ConvertAnsi_unsafe(psz, cch, m_pBuf);
	ASSERT(pEnd == m_pBuf + m_cwch);
	*pEnd = L'\0';
}

void Utf16StringBuf::FromAnsi(const char* psz, size_t cch, UINT codePage)
{
	if (cch >= _countof(m_wcsBuf))
	{
		m_pBuf = new char16_t[cch + 1];
		// If alloc returns nullptr, then will fail below with benign AV
	}

	m_cwch = static_cast<size_t>(::MultiByteToWideChar(codePage, 0, psz, cch, (LPWSTR)m_pBuf, cch));
	ASSERT(m_cwch <= cch);
	m_pBuf[m_cwch] = 0;
}


Utf16StringOTE* Utf16String::New(LPCWSTR value)
{
	return New(value, wcslen(value));
}

Utf16StringOTE* __fastcall Utf16String::New(const WCHAR* value, size_t cwch)
{
	Utf16StringOTE* stringPointer = New(cwch);
	Utf16String* string = stringPointer->m_location;
	string->m_characters[cwch] = L'\0';
	memcpy(string->m_characters, value, cwch * sizeof(WCHAR));
	return stringPointer;
}

Utf16StringOTE* ST::Utf16String::New(size_t cwch)
{
	return ObjectMemory::newUninitializedNullTermObject<Utf16String>(cwch * sizeof(CU));
}

#ifdef NLSConversions
template <UINT CP, class T> Utf16StringOTE* ST::Utf16String::New(const T* __restrict psz, size_t cch)
{
	// A UTF16 encoded string can never require more code units than a byte encoding (though it will usually require more bytes)
	const UINT cp = CP == CP_ACP ? Interpreter::m_ansiCodePage : CP;
	int cwch = ::MultiByteToWideChar(cp, 0, reinterpret_cast<LPCCH>(psz), cch, nullptr, 0);
	Utf16StringOTE* stringPointer = New(cwch);
	auto pwsz = stringPointer->m_location->m_characters;
	int cwch2 = ::MultiByteToWideChar(cp, 0, reinterpret_cast<LPCCH>(psz), cch, (LPWSTR)pwsz, cwch);
	pwsz[cwch] = L'\0';
	return stringPointer;
}
#endif

Utf16StringOTE* ST::Utf16String::New(const char8_t* __restrict psz8Src, size_t cch8Src)
{
#ifdef NLSConversions
	return New<CP_UTF8, char8_t>(psz8Src, cch8Src);
#else
	// A UTF16 encoded string can never require more code units than a byte encoding (though it will usually require more bytes)
	size_t cwchDest = Utf16StringBuf::LengthOfUtf8(psz8Src, cch8Src);
	Utf16StringOTE* stringPointer = New(cwchDest);
	auto pwszDest = stringPointer->m_location->m_characters;
	char16_t* pEnd = Utf16StringBuf::ConvertUtf8_unsafe(psz8Src, cch8Src, pwszDest);
	ASSERT((pEnd - pwszDest) == cwchDest);
	*pEnd = L'\0';
	return stringPointer;
#endif
}

Utf16StringOTE* ST::Utf16String::New(const char* __restrict pszSrc, size_t cchSrc)
{
#ifdef NLSConversions
	return New<CP_ACP, char>(pszSrc, cchSrc);
#else
	// A UTF16 encoded string can never require more code units than a byte encoding (though it will usually require more bytes)
	size_t cwchDest = Utf16StringBuf::LengthOfAnsi(pszSrc, cchSrc);
	Utf16StringOTE* stringPointer = New(cwchDest);
	auto pwszDest = stringPointer->m_location->m_characters;
	char16_t* pEnd = Utf16StringBuf::ConvertAnsi_unsafe(pszSrc, cchSrc, pwszDest);
	ASSERT((pEnd - pwszDest) == cwchDest);
	*pEnd = L'\0';
	return stringPointer;
#endif
}

size_t Utf16StringBuf::LengthOfAnsi(const char* __restrict psz, size_t cch)
{
	// We know that the ANSI code page will not contain any chars outside the BMP, nor any surrogates, so the code unit count must be the same.
	return cch;
}

// The buffer pointed at by pUtf8Dest is assumed to be of size utf8Length, and that utf8Length is exactly the
// size that will be required for the UTF-8 encoded representation of the UTF-16 source, as calculated by
// a call to Utf8LengthOfUtf16. This function does not check that it does not write beyond utf8Length in 
// the general case. 
char16_t* Utf16StringBuf::ConvertAnsi_unsafe(const char* __restrict pszSrc, size_t cchSrc, char16_t* __restrict pwszDest)
{
	auto pSrcLimit = pszSrc + cchSrc;
	while (pszSrc < pSrcLimit) {
		unsigned char ch = *pszSrc++;
		*pwszDest++ = (ch <= 0x7f) ? ch : Interpreter::m_ansiToUnicodeCharMap[ch];
	}
	return pwszDest;
}

Oop* PRIMCALL Interpreter::primitiveStringAsUtf16String(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	if (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding >= StringEncoding::Utf16)
		return sp;

	switch (receiver->m_oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{	
		auto oteAnsi = reinterpret_cast<const AnsiStringOTE*>(receiver);
		Utf16StringOTE* answer = Utf16String::New(oteAnsi->m_location->m_characters, oteAnsi->Count);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf8:
	{
		auto oteUtf8 = reinterpret_cast<const Utf8StringOTE*>(receiver);
		Utf16StringOTE* answer = Utf16String::New(oteUtf8->m_location->m_characters, oteUtf8->Count);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf16:
	{
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	default:
		// Unrecognised encoding
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}

bool Utf16StringOTE::OrdinalEquals(const AnsiStringOTE* __restrict oteAnsi) const
{
	size_t cchAnsi = oteAnsi->Count;
	const char* pszAnsi = oteAnsi->m_location->m_characters;
	size_t cwch = Utf16StringBuf::LengthOfAnsi(pszAnsi, cchAnsi);
	size_t cch1 = Count;
	if (cch1 != cwch) return false;

	auto pwsz = malloca(char16_t, cwch);
	Utf16StringBuf::ConvertAnsi_unsafe(pszAnsi, cchAnsi, pwsz);
	bool equal = CmpOrdinalW()(m_location->m_characters, cch1, pwsz, cwch) == 0;
	_freea(pwsz);
	return equal;
}

bool Utf16StringOTE::OrdinalEquals(const Utf8StringOTE* __restrict oteComperand) const
{
	// Could also convert to UTF-8 and do a memcmp, but some tests of decoding invalid sequences assume that the comparison
	// involves decoding UTF-8 into UTF-16. 

	const char8_t* psz = oteComperand->m_location->m_characters;
	size_t cch = oteComperand->Count;
	size_t cwch2 = Utf16StringBuf::LengthOfUtf8(psz, cch);
	size_t cwch1 = Count;
	if (cwch1 != cwch2) {
		return false;
	}
	char16_t* pwsz = malloca(char16_t, cwch1);
	char16_t* pEnd = Utf16StringBuf::ConvertUtf8_unsafe(psz, cch, pwsz);
	ASSERT(pEnd == pwsz + cwch1);
	bool equal = CmpOrdinalW()(m_location->m_characters, cwch1, pwsz, cwch2) == 0;
	_freea(pwsz);
	return equal;
}


