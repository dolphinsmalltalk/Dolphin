#pragma once

#include "STString.h"

class Utf16StringBuf
{
public:
	#pragma warning (suppress: 26495)	// False positive - the variables are initialized
	Utf16StringBuf() {}
	Utf16StringBuf(const Utf16StringBuf&) = delete;
	Utf16StringBuf(const Utf16StringBuf&&) = delete;
	__forceinline Utf16StringBuf(const Utf8StringOTE* ote)
	{
		FromUtf8(ote->m_location->m_characters, ote->Count);
	}
	__forceinline Utf16StringBuf(const AnsiStringOTE* ote)
	{
		FromAnsi(ote->m_location->m_characters, ote->Count);

	}

	__forceinline Utf16StringBuf(const char8_t* psz8, size_t cch8)
	{
		FromUtf8(psz8, cch8);
	}


	__forceinline Utf16StringBuf(const char* psz, size_t cch)
	{
		FromAnsi(psz, cch);
	}

	__forceinline Utf16StringBuf(const char* psz, size_t cch, UINT codePage)
	{
		FromAnsi(psz, cch, codePage);
	}

	~Utf16StringBuf()
	{
		if (m_pBuf != m_wcsBuf) 
			delete m_pBuf;
	}

public:
	void FromUtf8(const char8_t* psz8, size_t cch8);
	void FromAnsi(const char* psz, size_t cch);
	void FromAnsi(const char* psz, size_t cch, UINT codePage);

	operator const char16_t*() const { return m_pBuf; }
	operator const wchar_t*() const { return reinterpret_cast<wchar_t*>(m_pBuf); }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cwch; }

	static size_t LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8);
	static char16_t* ConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char16_t* __restrict pwszDest);
	static size_t LengthOfAnsi(const char* __restrict psz8, size_t cch);
	static char16_t* ConvertAnsi_unsafe(const char* __restrict pszSrc, size_t cchSrc, char16_t* __restrict pwszDest);

private:
	char16_t* m_pBuf = m_wcsBuf;
	size_t m_cwch = 0;
	// We need to keep the default (stack) buffer size reasonably small to avoid a __chkstk call in some string primitives. 512 bytes is too much, so stick to 256
	char16_t m_wcsBuf[128-((sizeof(char16_t*)+sizeof(size_t))/sizeof(char16_t))];
};
