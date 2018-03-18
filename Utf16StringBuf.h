#pragma once

template <UINT CP, class T> class Utf16StringBuf
{
public:
	Utf16StringBuf() = delete;
	Utf16StringBuf(const Utf16StringBuf&) = delete;
	Utf16StringBuf(const Utf16StringBuf&&) = delete;

	Utf16StringBuf(const T* psz, size_t cch)
	{
		if (cch < _countof(m_wcsBuf))
		{
			m_pBuf = m_wcsBuf;
		}
		else
		{
			m_pBuf = reinterpret_cast<Utf16String::CU*>(malloc((cch + 1) * sizeof(Utf16String::CU)));
		}

		m_cwch = static_cast<size_t>(::MultiByteToWideChar(CP, 0, reinterpret_cast<LPCCH>(psz), cch, m_pBuf, cch));
		ASSERT(m_cwch <= cch);
		m_pBuf[m_cwch] = 0;
	}

	~Utf16StringBuf()
	{
		if (m_pBuf != m_wcsBuf) free(m_pBuf);
	}

	operator Utf16String::CU*() const { return m_pBuf; }
	__declspec(property(get = getCount)) size_t Count;
	size_t getCount() const { return m_cwch; }

	size_t ToAnsi(ByteString::CU * pDest = nullptr, size_t cchDest = 0) const
	{
		int cch = ::WideCharToMultiByte(CP_ACP, 0, m_pBuf, m_cwch, pDest, cchDest, nullptr, nullptr);
		ASSERT(cch >= 0);
		return static_cast<size_t>(cch);
	}

	size_t ToUtf8(Utf8String::CU* pDest = nullptr, size_t cchDest = 0) const
	{
		int cch = ::WideCharToMultiByte(CP_UTF8, 0, m_pBuf, m_cwch, reinterpret_cast<LPSTR>(pDest), cchDest, nullptr, nullptr);
		ASSERT(cch >= 0);
		return static_cast<size_t>(cch);
	}

private:
	Utf16String::CU * m_pBuf;
	size_t	m_cwch;
	Utf16String::CU   m_wcsBuf[252];
};

inline std::wostream& operator<<(std::wostream& stream, const std::string& str)
{
	Utf16StringBuf<CP_ACP, char> utf16(str.c_str(), str.size());
	return stream << utf16;
}
