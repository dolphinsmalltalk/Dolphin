#pragma once

class AnsiStringBuf
{
public:
	#pragma warning (suppress: 26495)	// False positive - the variables are initialized
	AnsiStringBuf() {}
	AnsiStringBuf(const AnsiStringBuf&) = delete;
	AnsiStringBuf(const AnsiStringBuf&&) = delete;

	AnsiStringBuf(const char16_t* __restrict pwch, size_t cwch);
	AnsiStringBuf(const char8_t* __restrict psz, size_t cch);
	AnsiStringBuf(const Utf16StringOTE* ote) : AnsiStringBuf(ote->m_location->m_characters, ote->Count) {}
	AnsiStringBuf(const Utf8StringOTE* ote) : AnsiStringBuf(ote->m_location->m_characters, ote->Count) {}

	~AnsiStringBuf()
	{
		if (m_pBuf != m_chBuf) 
			delete m_pBuf;
	}

	operator const char*() const { return m_pBuf; }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cch; }

	static size_t LengthOfUtf16(const char16_t* __restrict pwsz, size_t cwch);
	static char* ConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char* __restrict pszDest, size_t cchDest);
	static char* StrictConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char* __restrict pszDest, size_t cchDest);
	char* StrictConvertUtf16(const char16_t* __restrict pwszSrc, size_t cwchSrc);
	static size_t LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8);
	static char* ConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char* __restrict pszDest, size_t cchDest);
	static char* StrictConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char* __restrict pszDest, size_t cchDest);
	char* StrictConvertUtf8(const char8_t* __restrict psz8Src, size_t cch8Src);

private:
	char* m_pBuf = m_chBuf;
	size_t m_cch = 0;
	char m_chBuf[256-sizeof(char*)-sizeof(size_t)];
};
