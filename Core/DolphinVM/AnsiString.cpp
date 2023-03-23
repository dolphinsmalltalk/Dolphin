#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

#include "Utf16StringBuf.h"

AnsiStringOTE* ST::AnsiString::NewFromUtf8(const char8_t* __restrict psz8, size_t cch8)
{
	size_t cch = 0;
	size_t i = 0;
	while (i < cch8) {
		cch++;
		U8_FWD_1(psz8, i, cch8);
	}
	AnsiStringOTE* oteAnswer = ObjectMemory::newUninitializedNullTermObject<AnsiString>(cch * sizeof(char));
	char* pszAnswer = oteAnswer->m_location->m_characters;
	i = 0;
	while (i < cch8) {
		char32_t c;
		U8_NEXT_OR_FFFD(psz8, i, cch8, c);
		if (c <= 0x7f) {
			*pszAnswer++ = static_cast<char>(c);
		}
		else {
			if (U_IS_BMP(c)) {
				char ansi = Interpreter::m_unicodeToBestFitAnsiCharMap[c];
				*pszAnswer++ = ansi == 0 ? Interpreter::m_ansiReplacementChar : ansi;
			}
			else {
				*pszAnswer++ = Interpreter::m_ansiReplacementChar;
			}
		}
	}
	*pszAnswer = '\0';
	return oteAnswer;
}

AnsiStringOTE* __fastcall AnsiString::NewFromUtf16(const char16_t* __restrict  pwch, size_t cwch)
{
	size_t cch = 0;
	size_t i = 0;
	while (i < cwch) {
		cch++;
		U16_FWD_1(pwch, i, cwch);
	}
	AnsiStringOTE* oteAnswer = ObjectMemory::newUninitializedNullTermObject<AnsiString>(cch * sizeof(char));
	char* pszAnswer = oteAnswer->m_location->m_characters;
	i = 0;
	while (i < cwch) {
		char32_t c;
		U16_NEXT_OR_FFFD(pwch, i, cwch, c);
		if (c <= 0x7f) {
			*pszAnswer++ = static_cast<char>(c);
		}
		else {
			if (U_IS_BMP(c)) {
				char ansi = Interpreter::m_unicodeToBestFitAnsiCharMap[c];
				*pszAnswer++ = ansi == 0 ? Interpreter::m_ansiReplacementChar : ansi;
			}
			else {
				*pszAnswer++ = Interpreter::m_ansiReplacementChar;
			}
		}
	}
	*pszAnswer = '\0';
	return oteAnswer;
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
