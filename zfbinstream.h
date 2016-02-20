/******************************************************************************

	File: zfbinstream.h

	Description:

  Simple binary streams (to avoid pulling in a lot of CRT stream code)

******************************************************************************/
#pragma once

#include "binstream.h"
#include "zlib.h"

class zfbinstream : public ibinstream, public obinstream
{
protected:
	gzFile	m_fp;

protected:
	void _flush(int flushLevel=Z_SYNC_FLUSH)
	{
		gzflush(m_fp, flushLevel);
	}

public:
	zfbinstream() : m_fp(NULL)
	{}

	~zfbinstream()
	{
		close();
	}

	bool open(const char* szFilename, const char* szMode)
	{
		close();
		m_fp = gzopen(szFilename, szMode);
		return m_fp != NULL;
	}

	bool attach(int fd, const char* szMode, int nCompressionLevel=0, bool bAssumeOwnership=false)
	{
		int myFd = bAssumeOwnership ? fd : _dup(fd);
		close();
		m_fp = gzdopen(myFd, szMode);
		if (nCompressionLevel != 0)
			setCompressionLevel(nCompressionLevel);
		return m_fp != NULL;
	}

	bool setbuf(BYTE*, size_t)
	{
		return false;
	}

	int setCompressionLevel(int n)
	{
		 return gzsetparams(m_fp, n, -2);
	}

	obinstream& flush()
	{
		_flush();
		return *this;
	}

	binstream& close()
	{
		if (m_fp != NULL)
		{
			//_flush(Z_FULL_FLUSH);
			gzclose(m_fp);
			m_fp = NULL;
		}
		return *this;
	}

	bool good() const
	{
		return m_fp != NULL && fail() == 0;
	}

	bool eof() const
	{
		return m_fp == NULL || gzeof(m_fp) != 0;
	}

	int fail() const
	{
		int nError;
		gzerror(m_fp, &nError);
		return nError;
	}

	virtual bool read(void* pbOut, size_t cBytes)
	{
		return gzread(m_fp, pbOut, cBytes) == int(cBytes);
	}

	virtual bool write(const void* pbIn, size_t cBytes)
	{
		return gzwrite(m_fp, const_cast<void* const>(pbIn), cBytes) == int(cBytes);
	}
};
