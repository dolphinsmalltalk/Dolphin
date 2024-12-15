#pragma once

class Utf8StringBuf
{
public:
	#pragma warning (suppress: 26495)	// False positive - the variables are initialized
	Utf8StringBuf() {}
	Utf8StringBuf(const Utf8StringBuf&) = delete;
	Utf8StringBuf(const Utf8StringBuf&&) = delete;

	Utf8StringBuf(const char16_t* __restrict pwch, size_t cwch);
	Utf8StringBuf(const char* __restrict psz, size_t cch);
	Utf8StringBuf(const Utf16StringOTE* ote) : Utf8StringBuf(ote->m_location->m_characters, ote->Count) {}
	Utf8StringBuf(const AnsiStringOTE* ote) : Utf8StringBuf(ote->m_location->m_characters, ote->Count) {}

	~Utf8StringBuf()
	{
		if (m_pBuf != m_ch8Buf) 
			delete m_pBuf;
	}

	operator const char8_t*() const { return m_pBuf; }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cch8; }

	static size_t LengthOfUtf16(const char16_t* __restrict pwsz, size_t cwch);
	static char8_t* ConvertUtf16_unsafe(const char16_t* __restrict pwszSrc, size_t cwchSrc, char8_t* __restrict psz8Dest, size_t cch8Dest);
	static size_t LengthOfAnsi(const char* __restrict psz, size_t cch);
	static char8_t* ConvertAnsi_unsafe(const char* __restrict pszSrc, size_t cchSrc, char8_t* __restrict pszDest, size_t cch8Dest);

private:
	char8_t* m_pBuf = m_ch8Buf;
	size_t m_cch8 = 0;
	char8_t m_ch8Buf[256-sizeof(char8_t*)-sizeof(size_t)];
};
