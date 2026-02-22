#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

#include "AnsiStringBuf.h"
#include "Utf16StringBuf.h"

AnsiStringBuf::AnsiStringBuf(const char8_t* __restrict psz8, size_t cch8)
{
	m_cch = LengthOfUtf8(psz8, cch8);
	if (m_cch >= _countof(m_chBuf))
	{
		m_pBuf = new char[m_cch + 1];
	}

	*(ConvertUtf8_unsafe(psz8, cch8, m_pBuf, m_cch)) = '\0';
}

// The buffer pointed at by pszDest is assumed to be of size cchDest, and that cchDest is exactly the
// size that will be required for the Ansi encoded representation of the UTF-8 source, as calculated by
// a call to AnsiStringBufngthOfUtf8. This function does not check that it does not write off the end
// of the destination buffer, so it must be correctly sized.
char* AnsiStringBuf::ConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char* __restrict pszDest, size_t cchDest)
{
	if (cchDest == cch8Src) {
		// Only possible for the UTF-8 code unit count to be the same as the that for ANSI
		// if the ANSI code units are all ASCII, in which case a straight copy
		memcpy(pszDest, psz8Src, cch8Src);
		return pszDest + cch8Src;
	}
	else {
		size_t i = 0;
		while (i < cch8Src) {
			char32_t c;
			U8_NEXT_OR_FFFD(psz8Src, i, cch8Src, c);
			if (c <= 0x7f) {
				*pszDest++ = static_cast<char>(c);
			}
			else {
				if (U_IS_BMP(c)) {
					char ansi = Interpreter::m_unicodeToBestFitAnsiCharMap[c];
					*pszDest++ = ansi == 0 ? Interpreter::m_ansiReplacementChar : ansi;
				}
				else {
					*pszDest++ = Interpreter::m_ansiReplacementChar;
				}
			}
		}
	}
	return pszDest;
}

size_t AnsiStringBuf::LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	size_t cch = 0;
	size_t i = 0;
	while (i < cch8) {
		cch++;
		U8_FWD_1(psz8, i, cch8);
	}
	return cch;
}

AnsiStringOTE* ST::AnsiString::NewFromUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	size_t cch = AnsiStringBuf::LengthOfUtf8(psz8, cch8);
	AnsiStringOTE* oteAnswer = ObjectMemory::newUninitializedNullTermObject<AnsiString>(cch * sizeof(char));
	*(AnsiStringBuf::ConvertUtf8_unsafe(psz8, cch8, oteAnswer->m_location->m_characters, cch)) = '\0';
	return oteAnswer;
}

AnsiStringBuf::AnsiStringBuf(const char16_t* __restrict pwch, size_t cwch)
{
	m_cch = LengthOfUtf16(pwch, cwch);
	if (m_cch >= _countof(m_chBuf))
	{
		m_pBuf = new char[m_cch + 1];
	}

	*(ConvertUtf16_unsafe(pwch, cwch, m_pBuf, m_cch)) = '\0';
}

size_t AnsiStringBuf::LengthOfUtf16(const char16_t* __restrict pwsz, size_t cwch)
{
	size_t cch = 0;
	size_t i = 0;
	while (i < cwch) {
		cch++;
		U16_FWD_1(pwsz, i, cwch);
	}
	return cch;
}

AnsiStringOTE* __fastcall AnsiString::NewFromUtf16(const char16_t* __restrict  pwch, size_t cwch)
{
	size_t cch = AnsiStringBuf::LengthOfUtf16(pwch, cwch);
	AnsiStringOTE* oteAnswer = ObjectMemory::newUninitializedNullTermObject<AnsiString>(cch * sizeof(char));
	*(AnsiStringBuf::ConvertUtf16_unsafe(pwch, cwch, oteAnswer->m_location->m_characters, cch)) = '\0';
	return oteAnswer;
}

char* AnsiStringBuf::ConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char* __restrict pszDest, size_t cchDest)
{
	size_t i = 0;
	while (i < cwchSrc) {
		char32_t c;
		U16_NEXT_OR_FFFD(pwszSrc, i, cwchSrc, c);
		if (c <= 0x7f) {
			*pszDest++ = static_cast<char>(c);
		}
		else {
			if (U_IS_BMP(c)) {
				char ansi = Interpreter::m_unicodeToBestFitAnsiCharMap[c];
				*pszDest++ = ansi == 0 ? Interpreter::m_ansiReplacementChar : ansi;
			}
			else {
				*pszDest++ = Interpreter::m_ansiReplacementChar;
			}
		}
	}
	return pszDest;
}

Oop* PRIMCALL Interpreter::primitiveStringAsByteString(Oop* const sp, primargcount_t)
{
	const OTE* receiver = reinterpret_cast<const OTE*>(*sp);
	BehaviorOTE* oteClass = receiver->m_oteClass;
	switch (oteClass->m_location->m_instanceSpec.m_encoding)
	{
	case StringEncoding::Ansi:
	{
		return sp;
	}
	case StringEncoding::Utf8:
	{
		auto oteUtf8 = reinterpret_cast<const Utf8StringOTE*>(receiver);
		AnsiStringOTE* answer = AnsiString::NewFromUtf8(oteUtf8	->m_location->m_characters, oteUtf8->Count);
		*sp = reinterpret_cast<Oop>(answer);
		ObjectMemory::AddToZct((OTE*)answer);
		return sp;
	}
	case StringEncoding::Utf16:
	{
		auto oteUtf16 = reinterpret_cast<const Utf16StringOTE*>(receiver);
		AnsiStringOTE* answer = AnsiString::NewFromUtf16(oteUtf16->m_location->m_characters, oteUtf16->Count);
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

// Strict versions of the UTF-8 and UTF-16 to Ansi conversions that do not do best fit mappings, and which fail if there is no mapping, returning null

char* AnsiStringBuf::StrictConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char* __restrict pszDest, size_t cchDest)
{
	size_t i = 0;
	while (i < cwchSrc) {
		char32_t c;
		U16_NEXT_OR_FFFD(pwszSrc, i, cwchSrc, c);
		if (c <= 0x7f) {
			*pszDest++ = static_cast<char>(c);
		}
		else {
			if (U_IS_BMP(c)) {
				char ansi = Interpreter::m_unicodeToAnsiCharMap[c];
				if (!ansi) return nullptr;
				*pszDest++ = ansi;
			}
			else {
				return nullptr;
			}
		}
	}
	return pszDest;
}

char* AnsiStringBuf::StrictConvertUtf16(const char16_t* __restrict pwch, size_t cwch)
{
	m_cch = AnsiStringBuf::LengthOfUtf16(pwch, cwch);
	if (m_cch >= _countof(m_chBuf))
	{
		m_pBuf = new char[m_cch + 1];
	}

	return StrictConvertUtf16_unsafe(pwch, cwch, m_pBuf, m_cch);
}

char* AnsiStringBuf::StrictConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char* __restrict pszDest, size_t cchDest)
{
	if (cchDest == cch8Src) {
		// Only possible for the UTF-8 code unit count to be the same as the that for ANSI
		// if the ANSI code units are all ASCII, in which case a straight copy
		memcpy(pszDest, psz8Src, cch8Src);
		return pszDest + cch8Src;
	}
	else {
		size_t i = 0;
		while (i < cch8Src) {
			char32_t c;
			U8_NEXT_OR_FFFD(psz8Src, i, cch8Src, c);
			if (c <= 0x7f) {
				*pszDest++ = static_cast<char>(c);
			}
			else {
				if (U_IS_BMP(c)) {
					char ansi = Interpreter::m_unicodeToAnsiCharMap[c];
					if (!ansi) return nullptr;
					*pszDest++ = ansi;
				}
				else {
					return nullptr;
				}
			}
		}
	}
	return pszDest;
}

char* AnsiStringBuf::StrictConvertUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	m_cch = AnsiStringBuf::LengthOfUtf8(psz8, cch8);
	if (m_cch >= _countof(m_chBuf))
	{
		m_pBuf = new char[m_cch + 1];
	}

	return StrictConvertUtf8_unsafe(psz8, cch8, m_pBuf, m_cch);
}

