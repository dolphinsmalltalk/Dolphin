#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

#include "Utf8StringBuf.h"
#include "Utf16StringBuf.h"

Utf8StringBuf::Utf8StringBuf(const char* __restrict psz, size_t cch)
{
	m_cch8 = LengthOfAnsi(psz, cch);
	if (m_cch8 >= _countof(m_ch8Buf))
	{
		m_pBuf = new char8_t[m_cch8 + 1];
		// If alloc returns nullptr, then will fail below with benign AV
	}

	*(ConvertAnsi_unsafe(psz, cch, m_pBuf, m_cch8)) = '\0';
}

Utf8StringOTE* __fastcall ST::Utf8String::NewFromAnsi(const char* __restrict psz, size_t cch)
{
	size_t cch8 = Utf8StringBuf::LengthOfAnsi(psz, cch);
	Utf8StringOTE* oteUtf8 = ObjectMemory::newUninitializedNullTermObject<MyType>(cch8);
	*(Utf8StringBuf::ConvertAnsi_unsafe(psz, cch, oteUtf8->m_location->m_characters, cch8)) = '\0';
	return oteUtf8;
}

size_t Utf8StringBuf::LengthOfAnsi(const char* __restrict psz, size_t cch)
{
	size_t cch8 = 0;
	auto pSrcLimit = psz + cch;

	while (psz < pSrcLimit) {
		unsigned char ch = *psz++;
		if (ch <= 0x7f) {
			cch8 += 1;
		}
		else {
			char16_t codePoint = Interpreter::m_ansiToUnicodeCharMap[ch];

			// We know that the ANSI code page will not contain any chars outside the BMP, nor any surrogates, so max UTF-8 length is 3
			cch8 += codePoint <= 0x7f ? 1 : codePoint <= 0x7ff ? 2 : 3;
		}
	}

	return cch8;
}

// The buffer pointed at by pUtf8Dest is assumed to be of size utf8Length, and that utf8Length is exactly the
// size that will be required for the UTF-8 encoded representation of the UTF-16 source, as calculated by
// a call to Utf8LengthOfUtf16. This function does not check that it does not write beyond utf8Length in 
// the general case. 
char8_t* Utf8StringBuf::ConvertAnsi_unsafe(const char* __restrict pszSrc, size_t cchSrc, char8_t* __restrict psz8Dest, size_t cch8Dest)
{
	if (cch8Dest == cchSrc) {
		// Only possible for the UTF-8 code unit count to be the same as the that for ANSI
		// if the ANSI code units are all ASCII, in which case a straight copy
		memcpy(psz8Dest, pszSrc, cchSrc);
		return psz8Dest + cchSrc;
	}
	else {
		auto pSrcLimit = pszSrc + cchSrc;
		while (pszSrc < pSrcLimit) {
			unsigned char ch = *pszSrc++;
			if (ch <= 0x7f) {
				*psz8Dest++ = static_cast<char8_t>(ch);
			}
			else {
				char32_t codePoint = Interpreter::m_ansiToUnicodeCharMap[ch];

				if (codePoint <= 0x7ff) {
					*psz8Dest++ = static_cast<char8_t>((codePoint >> 6) | 0xc0);
					*psz8Dest++ = static_cast<char8_t>((codePoint & 0x3f) | 0x80);
				}
				else {
					*psz8Dest++ = static_cast<char8_t>((codePoint >> 12) | 0xe0);
					*psz8Dest++ = static_cast<char8_t>(((codePoint >> 6) & 0x3f) | 0x80);
					*psz8Dest++ = static_cast<char8_t>((codePoint & 0x3f) | 0x80);
				}
			}
		}
	}
	return psz8Dest;
}

Utf8StringOTE* __fastcall Utf8String::NewFromUtf16(const char16_t* __restrict pwsz, size_t cwch)
{
	// Conversion from utf16 to utf8 is derived from ICU's u_strtoUTF8WithSub. We don't use the actual function
	// because it appears to be about 30% slower than WideCharToMultibyte for UTF-16 to UTF-8 conversion. Our
	// requirements are not so general purpose, so we can simplify it down and eliminate a lot of the overhead
	// of a general function. The end result is slightly faster than using WideCharToMultibyte

	size_t cch8Dest = Utf8StringBuf::LengthOfUtf16(pwsz, cwch);
	auto oteUtf8 = ObjectMemory::newUninitializedNullTermObject<MyType>(cch8Dest);
	*(Utf8StringBuf::ConvertUtf16_unsafe(pwsz, cwch, oteUtf8->m_location->m_characters, cch8Dest)) = '\0';
	return oteUtf8;
}

Utf8StringBuf::Utf8StringBuf(const char16_t* __restrict pwch, size_t cwch)
{
	m_cch8 = LengthOfUtf16(pwch, cwch);
	if (m_cch8 >= _countof(m_ch8Buf))
	{
		m_pBuf = new char8_t[m_cch8 + 1];
		// If alloc returns nullptr, then will fail below with benign AV
	}

	*(ConvertUtf16_unsafe(pwch, cwch, m_pBuf, m_cch8)) = '\0';
}

size_t Utf8StringBuf::LengthOfUtf16(const char16_t* __restrict pwsz, size_t cwch)
{
	size_t reqLength = 0;
	auto pSrcLimit = pwsz + cwch;

	while (pwsz < pSrcLimit) {
		auto ch = *pwsz++;
		if (ch <= 0x7f) {
			reqLength += 1;
		}
		else if (ch <= 0x7ff) {
			reqLength += 2;
		}
		else if (!U16_IS_SURROGATE(ch)) {
			reqLength += 3;
		}
		else if (U16_IS_SURROGATE_LEAD(ch) && pwsz < pSrcLimit && U16_IS_TRAIL(*pwsz)) {
			++pwsz;
			reqLength += 4;
		}
		else {
			// Will be 3
			reqLength += U8_LENGTH(Interpreter::UnicodeReplacementChar);
		}
	}

	return reqLength;
}

// The buffer pointed at by pUtf8Dest is assumed to be of size utf8Length, and that utf8Length is exactly the
// size that will be required for the UTF-8 encoded representation of the UTF-16 source, as calculated by
// a call to Utf8LengthOfUtf16. This function does not check that it does not write beyond utf8Length in 
// the general case. 
char8_t* Utf8StringBuf::ConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char8_t* __restrict psz8Dest, size_t cch8Dest)
{
	if (cch8Dest == cwchSrc) {
		// Only possible for the UTF-8 code unit count to be the same as the that for UTF-16
		// if the UTF-16 code units are all ASCII, in which case a straight copy, words to bytes, 
		// will do. In all other circumstances UTF-8 requires more code units (not necessarily bytes)
		// to represent the same string.
		while (cwchSrc--) {
			*psz8Dest++ = static_cast<char8_t>(*pwszSrc++);
		}
	}
	else {
		auto pSrcLimit = pwszSrc + cwchSrc;
		while (pwszSrc < pSrcLimit) {
			char32_t ch = *pwszSrc++;
			if (ch <= 0x7f) {
				*psz8Dest++ = (char8_t)ch;
			}
			else if (ch <= 0x7ff) {
				*psz8Dest++ = (char8_t)((ch >> 6) | 0xc0);
				*psz8Dest++ = (char8_t)((ch & 0x3f) | 0x80);
			}
			else if (ch <= 0xd7ff || ch >= 0xe000) {
				*psz8Dest++ = (char8_t)((ch >> 12) | 0xe0);
				*psz8Dest++ = (char8_t)(((ch >> 6) & 0x3f) | 0x80);
				*psz8Dest++ = (char8_t)((ch & 0x3f) | 0x80);
			}
			else /* ch is a surrogate */ {
				char32_t ch2;

				if (U16_IS_SURROGATE_LEAD(ch) && pwszSrc < pSrcLimit && U16_IS_TRAIL(ch2 = *pwszSrc)) {
					++pwszSrc;
					ch = U16_GET_SUPPLEMENTARY(ch, ch2);

					ASSERT(ch >= 0x10000);
					*psz8Dest++ = (char8_t)((ch >> 18) | 0xf0);
					*psz8Dest++ = (char8_t)(((ch >> 12) & 0x3f) | 0x80);
					*psz8Dest++ = (char8_t)(((ch >> 6) & 0x3f) | 0x80);
					*psz8Dest++ = (char8_t)((ch & 0x3f) | 0x80);
				}
				else {
					// Assume recommended unicode replacement char, 0xFFFD
					ASSERT(Interpreter::UnicodeReplacementChar == 0xFFFD);
					*psz8Dest++ = 0xef;
					*psz8Dest++ = 0xbf;
					*psz8Dest++ = 0xbd;
				}
			}
		}
	}
	return psz8Dest;
}

Oop* Interpreter::primitiveStringAsUtf8String(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		auto oteAnsi = reinterpret_cast<const AnsiStringOTE*>(receiver);
		Utf8StringOTE* answer = Utf8String::NewFromAnsi(oteAnsi->m_location->m_characters, oteAnsi->Count);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}

	case StringEncoding::Utf8:
		return sp;

	case StringEncoding::Utf16:
	{
		auto oteUtf16 = reinterpret_cast<const Utf16StringOTE*>(receiver);
		Utf8StringOTE* answer = Utf8String::NewFromUtf16(oteUtf16->m_location->m_characters, oteUtf16->Count);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf32:
		// TODO: Implement conversion for UTF-32
		return primitiveFailure(_PrimitiveFailureCode::NotImplemented);

	default:
		// Unrecognised encoding - fail the primitive
		__assume(false);
		return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);
	}
}

Oop* PRIMCALL Interpreter::primitiveUtf8StringDecodeAt(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const Utf8StringOTE* oteReceiver = reinterpret_cast<const Utf8StringOTE*>(*(sp - 1));
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallUinteger i = ObjectMemoryIntegerValueOf(oopArg) - 1;
		size_t length = oteReceiver->Count;
		if (i < length)
		{
			char32_t c;
			char8_t* utf8 = oteReceiver->m_location->m_characters;
			U8_NEXT_OR_FFFD(utf8, i, length, c);
			StoreCharacterToStack(sp - 1, U_IS_UNICODE_NONCHAR(c) ? Interpreter::UnicodeReplacementChar : c);
			return sp - 1;
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Arg not a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

Oop* PRIMCALL Interpreter::primitiveUtf8StringEncodedSizeAt(Oop* const sp, primargcount_t)
{
	Oop oopArg = *sp;
	const Utf8StringOTE* oteReceiver = reinterpret_cast<const Utf8StringOTE*>(*(sp - 1));
	if (ObjectMemoryIsIntegerObject(oopArg))
	{
		SmallUinteger i = ObjectMemoryIntegerValueOf(oopArg) - 1;
		size_t length = oteReceiver->Count;
		if (i < length)
		{
			char32_t c;
			SmallUinteger j = i;
			char8_t* utf8 = oteReceiver->m_location->m_characters;
			U8_NEXT_OR_FFFD(utf8, j, length, c);
			*(sp - 1) = ObjectMemoryIntegerObjectOf(j - i);
			return sp - 1;
		}
		else
		{
			return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);
		}
	}
	else
	{
		// Arg not a SmallInteger
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
}

bool Utf8StringOTE::OrdinalEquals(const AnsiStringOTE* __restrict oteAnsi) const
{
	size_t cchAnsi = oteAnsi->Count;
	const char* pszAnsi = oteAnsi->m_location->m_characters;
	size_t cch2 = Utf8StringBuf::LengthOfAnsi(pszAnsi, cchAnsi);
	size_t cch1 = Count;
	int cmp = cch1 - cch2;
	if (cch1 != cch2) {
		// Can't be equal if different number of UTF-8 code units
		return false;
	}

	auto psz8 = malloca(char8_t, cch2);
	char8_t* pEnd = Utf8StringBuf::ConvertAnsi_unsafe(pszAnsi, cchAnsi, psz8, cch2);
	ASSERT(pEnd == psz8 + cch2);
	bool equal = memcmp(m_location->m_characters, psz8, cch2) == 0;
	_freea(psz8);

	return equal;
}

bool Utf8StringOTE::OrdinalEquals(const Utf16StringOTE* __restrict oteUtf16) const
{
	// Could also convert to UTF-8 and do a memcmp, but some tests of decoding invalid sequences assume that the comparison
	// involves decoding UTF-8 into UTF-16. 

	size_t cch = Count;
	const char8_t* psz = m_location->m_characters;
	size_t cwch1 = Utf16StringBuf::LengthOfUtf8(psz, cch);
	size_t cwch2 = oteUtf16->Count;
	if (cwch1 != cwch2) {
		// Can't be equal if different number of UTF-16 code units
		return false;
	}
	char16_t* pwsz = malloca(char16_t, cwch1);
	char16_t* pEnd = Utf16StringBuf::ConvertUtf8_unsafe(psz, cch, pwsz);
	ASSERT(pEnd == pwsz + cwch1);
	bool equal = CmpOrdinalW()(pwsz, cwch1, oteUtf16->m_location->m_characters, cwch2) == 0;
	_freea(pwsz);
	return equal;
}

