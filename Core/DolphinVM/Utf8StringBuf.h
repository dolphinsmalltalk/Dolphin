#pragma once

class Utf8StringBuf
{
public:
	#pragma warning (suppress: 26495)	// False positive - the variables are initialized
	Utf8StringBuf() {}
	Utf8StringBuf(const Utf8StringBuf&) = delete;
	Utf8StringBuf(const Utf8StringBuf&&) = delete;

	Utf8StringBuf(const char16_t* pwch, size_t cwch)
	{
		FromUtf16(pwch, cwch);
	}

	void FromUtf16(const char16_t* pwch, const size_t& cwch)
	{
		m_cch8 = LengthOfUtf16(pwch, cwch);
		if (m_cch8 >= _countof(m_ch8Buf))
		{
			m_pBuf = reinterpret_cast<char8_t*>(malloc((m_cch8 + 1) * sizeof(char8_t)));
			// If malloc returns nullptr, then will fail below with benign AV
		}

		*(ConvertUtf16_unsafe(pwch, cwch, m_pBuf, m_cch8)) = '\0';
	}

	Utf8StringBuf(const char* psz, size_t cch, UINT codePage)
	{
		FromAnsi(psz, cch, codePage);
	}

	void FromAnsi(const char* psz, const size_t& cch, UINT codePage)
	{
		m_cch8 = LengthOfAnsi(psz, cch);
		if (m_cch8 >= _countof(m_ch8Buf))
		{
			m_pBuf = reinterpret_cast<char8_t*>(malloc((m_cch8 + 1) * sizeof(char8_t)));
			// If malloc returns nullptr, then will fail below with benign AV
		}

		*(ConvertAnsi_unsafe(psz, cch, m_pBuf, m_cch8)) = '\0';
	}

	~Utf8StringBuf()
	{
		if (m_pBuf != m_ch8Buf) free(m_pBuf);
	}

	operator const char8_t*() const { return m_pBuf; }
	//operator const char*() const { return reinterpret_cast<char*>(m_pBuf); }
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
