#pragma once

class Utf16StringBuf
{
public:
	Utf16StringBuf() {}
	Utf16StringBuf(const Utf16StringBuf&) = delete;
	Utf16StringBuf(const Utf16StringBuf&&) = delete;

	//#pragma warning (suppress: 26495)	// False positive - the variables are initialized

	Utf16StringBuf(const char8_t* psz8, size_t cch8)
	{
		FromUtf8(psz8, cch8);
	}

	void FromUtf8(const char8_t* psz8, const size_t& cch8)
	{
		m_cwch = LengthOfUtf8(psz8, cch8);
		if (m_cwch >= _countof(m_wcsBuf))
		{
			m_pBuf = reinterpret_cast<char16_t*>(malloc((m_cwch + 1) * sizeof(char16_t)));
			// If malloc returns nullptr, then will fail below with benign AV
		}

		*(ConvertUtf8_unsafe(psz8, cch8, m_pBuf, m_cwch)) = L'\0';
	}

	Utf16StringBuf(const char* psz, size_t cch, UINT codePage)
	{
		FromAnsi(psz, cch, codePage);
	}

	void FromAnsi(const char* psz, const size_t& cch, UINT codePage)
	{
		if (cch >= _countof(m_wcsBuf))
		{
			m_pBuf = reinterpret_cast<char16_t*>(malloc((cch + 1) * sizeof(char16_t)));
			// If malloc returns nullptr, then will fail below with benign AV
		}

		m_cwch = static_cast<size_t>(::MultiByteToWideChar(codePage, 0, psz, cch, (LPWSTR)m_pBuf, cch));
		ASSERT(m_cwch <= cch);
		m_pBuf[m_cwch] = 0;
	}

	~Utf16StringBuf()
	{
		if (m_pBuf != m_wcsBuf) free(m_pBuf);
	}

	operator const char16_t*() const { return m_pBuf; }
	operator const wchar_t*() const { return reinterpret_cast<wchar_t*>(m_pBuf); }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cwch; }

	static size_t LengthOfUtf8(const char8_t* __restrict psz8, size_t cch8);
	static char16_t* ConvertUtf8_unsafe(const char8_t* __restrict psz8Src, size_t cch8Src, char16_t* __restrict pwszDest, size_t cwchDest);

private:
	char16_t* m_pBuf = m_wcsBuf;
	size_t m_cwch = 0;
	char16_t m_wcsBuf[256-sizeof(char16_t*)-sizeof(size_t)];
};
