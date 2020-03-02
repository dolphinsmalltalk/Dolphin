/******************************************************************************

	File: zbinstream.h

	Description:

  Simple binary streams (to avoid pulling in a lot of CRT stream code)

******************************************************************************/
#pragma once

#include "binstream.h"
#include "zlib\zlib.h"

enum { gz_magic1 = 0x1f, gz_magic2 = 0x8b }; /* gzip magic header */
/* gzip flag byte */
enum {ASCII_FLAG  = 0x01 /* bit 0 set: file probably ascii text */
	, HEAD_CRC    = 0x02 /* bit 1 set: header CRC present */
	, EXTRA_FIELD = 0x04 /* bit 2 set: extra field present */
	, ORIG_NAME   = 0x08 /* bit 3 set: original file name present */
	, COMMENT     = 0x10 /* bit 4 set: file comment present */
	, RESERVED    = 0xE0 /* bits 5..7: reserved */
};

class zibinstream : public ibinstream
{
protected:
	uint8_t* m_pBytes;
	size_t m_cBytes;
	z_stream m_stream;
    int m_z_err;
	long m_crc;

protected:

	int destroy()
	{
		int err = Z_OK;

		if (m_stream.state != NULL) 
			err = inflateEnd(&(m_stream));

		if (m_z_err < 0) 
			err = m_z_err;

		return err;
	}

	/* ===========================================================================
		Read a byte from a gz_stream; update next_in and avail_in. Return EOF
		for end of file.
		IN assertion: the stream s has been sucessfully opened for reading.
	*/
	int get_byte()
	{
		if (m_stream.avail_in == 0) 
			return EOF;
		m_stream.avail_in--;
		return *(m_stream.next_in)++;
	}

	/* ===========================================================================
		Reads a long in LSB order from the given gz_stream. Sets z_err in case
		of error.
	*/
	uLong getLong()
	{
		uLong x = (uLong)get_byte();
		int c;

		x += ((uLong)get_byte())<<8;
		x += ((uLong)get_byte())<<16;
		c = get_byte();
		if (c == EOF) m_z_err = Z_DATA_ERROR;
		x += ((uLong)c)<<24;
		return x;
	}

	/* ===========================================================================
      Check the gzip header of a gz_stream opened for reading. Set the stream
		mode to transparent if the gzip magic header is not present; set m_err
		to Z_DATA_ERROR if the magic header is present but the rest of the header
		is incorrect.
		IN assertion: the stream s has already been created sucessfully;
		m_stream.avail_in is zero for the first time, but may be non-zero
		for concatenated .gz files.
	*/
	void check_header()
	{
		int method; /* method byte */
		int flags;  /* flags byte */
		UINT len;
		int c;

		/* Assure two bytes in the buffer so we can peek ahead -- handle case
		where first byte of header is at the end of the buffer after the last
		gzip segment */
		len = m_stream.avail_in;
		if (len < 2) 
		{
			m_z_err = Z_DATA_ERROR;	
			return;
		}

		/* Peek ahead to check the gzip magic header */
		if (m_stream.next_in[0] != gz_magic1 ||
			m_stream.next_in[1] != gz_magic2) 
		{
			return;
		}

		m_stream.avail_in -= 2;
		m_stream.next_in += 2;

		/* Check the rest of the gzip header */
		method = get_byte();
		flags = get_byte();
		if (method != Z_DEFLATED || (flags & RESERVED) != 0) 
		{
			m_z_err = Z_DATA_ERROR;
			return;
		}

		/* Discard time, xflags and OS code: */
		for (len = 0; len < 6; len++) (void)get_byte();

		if ((flags & EXTRA_FIELD) != 0) 
		{ /* skip the extra field */
			len  =  (UINT)get_byte();
			len += ((UINT)get_byte())<<8;
			/* len is garbage if EOF but the loop below will quit anyway */
			while (len-- != 0 && get_byte() != EOF) ;
		}
		if ((flags & ORIG_NAME) != 0) 
		{ /* skip the original file name */
			while ((c = get_byte()) != 0 && c != EOF) ;
		}
		if ((flags & COMMENT) != 0) 
		{   /* skip the .gz file comment */
			while ((c = get_byte()) != 0 && c != EOF) ;
		}
		if ((flags & HEAD_CRC) != 0) 
		{  /* skip the header crc */
			for (len = 0; len < 2; len++) (void)get_byte();
		}
		m_z_err = eof() ? Z_DATA_ERROR : Z_OK;
	}

	int initialize(void* pBytes, size_t cBytes)
	{
		// Initialize the buffer pointer and size
		m_pBytes = static_cast<uint8_t*>(pBytes);
		m_cBytes = cBytes;

		// Initialize the zlib stream block
		m_stream.zalloc = (alloc_func)0;
		m_stream.zfree = (free_func)0;
		m_stream.opaque = (voidpf)0;
		m_stream.next_in = m_pBytes;
		m_stream.next_out = Z_NULL;
		m_stream.avail_in = m_cBytes;
		m_stream.avail_out = 0;

		// Initialize further state variables
		m_z_err = Z_OK;
		//m_in = 0;
		//m_out = 0;
		//m_back = EOF;
		m_crc = crc32(0L, Z_NULL, 0);
		//m_msg = NULL;

		int err = inflateInit2(&(m_stream), -MAX_WBITS);
		/* windowBits is passed < 0 to tell that there is no zlib header.
		* Note that in this case inflate *requires* an extra "dummy" byte
		* after the compressed stream in order to complete decompression and
		* return Z_STREAM_END. Here the gzip CRC32 ensures that 4 bytes are
		* present after the compressed stream.
		*/
		if (err != Z_OK)
		{
			destroy();
			return err;
		}

		check_header(); /* skip the .gz header */
		//m_start = ftell(m_file) - m_stream.avail_in;
		return m_z_err;
	}

public:
	zibinstream(void *pBytes, size_t cBytes)
	{
		initialize(pBytes, cBytes);
	}

	~zibinstream()
	{
	}

/*	int setCompressionLevel(int n)
	{
		 return gzsetparams(m_fp, n, -2);
	}
*/
	binstream& flush()
	{
		// This is an input stream, nothing to do here
		return *this;
	}

	binstream& close()
	{
		destroy();
		return *this;
	}

	bool good() const
	{
		return m_stream.state != NULL && fail() == Z_OK;
	}

	bool eof() const
	{
		return m_stream.avail_in == 0;
	}

	int fail() const
	{
		return m_z_err;
	}

	virtual bool read(void* buf, size_t len)
	{
		Bytef *start = (Bytef*)buf; /* starting point for crc computation */
		Byte  *next_out; /* == stream.next_out but not forced far (for MSDOS) */

		if (m_z_err == Z_DATA_ERROR || m_z_err == Z_ERRNO) return false;
		if (m_z_err == Z_STREAM_END) return 0;  /* EOF */

		next_out = (Byte*)buf;
		m_stream.next_out = (Bytef*)buf;
		m_stream.avail_out = len;

		while (m_stream.avail_out != 0 && !eof() && fail() == Z_OK)
		{
			m_z_err = inflate(&(m_stream), Z_NO_FLUSH);

			if (m_z_err == Z_STREAM_END) 
			{
				/* Check CRC and original size */
				m_crc = crc32(m_crc, start, (uInt)(m_stream.next_out - start));
				start = m_stream.next_out;

				if (getLong() != (uLong)m_crc) 
				{
					m_z_err = Z_DATA_ERROR;
				} 
			}
		}
		m_crc = crc32(m_crc, start, (uInt)(m_stream.next_out - start));

		return m_stream.avail_out == 0;
	}
};
