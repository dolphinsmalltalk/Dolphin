/******************************************************************************

	File: binstream.h

	Description:

  Simple binary streams (to avoid pulling in a lot of CRT stream code)

******************************************************************************/
#pragma once

class ibinstream;
class obinstream;

class binstream
{
public:
	virtual bool good() const=0;
	virtual int fail() const=0;
	virtual bool eof() const=0;

	virtual binstream& close()=0;
};

class ibinstream : public virtual binstream
{
public:
	virtual bool read(void*,size_t)=0;
};

class obinstream : public virtual binstream
{
public:
	virtual obinstream& flush()=0;
	virtual bool write(const void*,size_t)=0;
};

class imbinstream : public ibinstream
{
protected:
	BYTE*	m_pBytes;
	size_t	m_nPosition;
	size_t	m_cBytes;

public:
	imbinstream(void* pBytes=NULL, size_t cBytes=0) : m_nPosition(0)
	{
		initialize(pBytes, cBytes);
	}

	void initialize(void* pBytes, size_t cBytes)
	{
		m_pBytes = static_cast<BYTE*>(pBytes);
		m_cBytes = cBytes;
	}

	binstream& flush()
	{
		return *this;
	}

	binstream& close()
	{
		return *this;
	}

	bool good() const
	{
		return fail() == 0;
	}

	int fail() const
	{
		return 0;
	}

	bool eof() const
	{
		return m_nPosition >= m_cBytes;
	}

	virtual bool read(void* pbOut, size_t cRequested)
	{
		size_t available = m_cBytes - m_nPosition;
		size_t cRead = (cRequested > available) ? available: cRequested;
        memcpy(pbOut, m_pBytes+m_nPosition, cRead);
		m_nPosition += cRead;
		return cRead == cRequested;
	}
};

class fbinstream : public obinstream, public ibinstream
{
protected:
	FILE*	m_fp;
	bool	m_bOwner;

public:
	bool open(const char* szFilename, const char* szMode)
	{
		close();
		m_bOwner = true;
		m_fp = NULL;
		return fopen_s(&m_fp, szFilename, szMode) == 0;
	}

	bool attach(int fd, const char* szMode)
	{
		close();
		m_bOwner = true;
		m_fp = _fdopen(fd, szMode);
		return m_fp != NULL;
	}

	fbinstream() : m_fp(NULL), m_bOwner(false)
	{}

	~fbinstream()
	{
		close();
	}

	bool setbuf(void* pbBuf, size_t cBytes)
	{
		return setvbuf(m_fp, reinterpret_cast<char*>(pbBuf), _IOFBF, cBytes) != 0;
	}

	obinstream& flush()
	{
		::fflush(m_fp);
		return *this;
	}

	binstream& close()
	{
		if (m_fp != NULL)
		{
			flush();
			if (m_bOwner)
			{
				fclose(m_fp);
			}
			m_fp = NULL;
		}
		return *this;
	}

	bool good() const
	{
		return m_fp != NULL && ferror(m_fp) == 0 && feof(m_fp) == 0;
	}

	int fail() const
	{
		return ferror(m_fp);
	}

	bool eof() const
	{
		return m_fp == NULL || feof(m_fp) != 0;
	}

	virtual bool read(void* pbOut, size_t cBytes)
	{
		return ::fread(pbOut, 1, cBytes, m_fp) == cBytes;
	}

	virtual bool write(const void* pbIn, size_t cBytes)
	{
		return ::fwrite(pbIn, 1, cBytes, m_fp) == cBytes;
	}
};
