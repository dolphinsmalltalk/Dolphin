#pragma once

class Utf16StringBuf
{
public:
	Utf16StringBuf() : m_pBuf(m_wcsBuf), m_cwch(0) {}
	Utf16StringBuf(const Utf16StringBuf&) = delete;
	Utf16StringBuf(const Utf16StringBuf&&) = delete;

	#pragma warning (suppress: 26495)	// False positive - the variables are initialized
	Utf16StringBuf(UINT cp, LPCCH psz, size_t cch)
	{
		FromBytes(cp, psz, cch);
	}

	~Utf16StringBuf()
	{
		if (m_pBuf != m_wcsBuf) free(m_pBuf);
	}

	operator const char16_t*() const { return (char16_t*)m_pBuf; }
	operator const wchar_t*() const { return m_pBuf; }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cwch; }

	void FromBytes(UINT cp, LPCCH psz, size_t cch)
	{
		m_pBuf = cch < _countof(m_wcsBuf) ? m_wcsBuf : reinterpret_cast<WCHAR*>(malloc((cch + 1) * sizeof(WCHAR)));

		m_cwch = static_cast<size_t>(::MultiByteToWideChar(cp, 0, psz, cch, m_pBuf, cch));
		ASSERT(m_cwch <= cch);
		m_pBuf[m_cwch] = 0;
	}

	size_t ToUtf8(char8_t* pDest = nullptr, size_t cchDest = 0) const
	{
		int cch = ::WideCharToMultiByte(CP_UTF8, 0, m_pBuf, m_cwch, reinterpret_cast<LPSTR>(pDest), cchDest, nullptr, nullptr);
		ASSERT(cch >= 0);
		return static_cast<size_t>(cch);
	}

private:
	WCHAR* m_pBuf;
	size_t	m_cwch;
	WCHAR m_wcsBuf[256-sizeof(void*)-sizeof(size_t)];
};
