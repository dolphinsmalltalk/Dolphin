/******************************************************************************

	File: STStream.h

	Description:

	VM representation of Smalltalk Stream classes. VM requires knowledge of
	these in order to implement the stream primitives.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STSTREAM_H_
#define _IST_STSTREAM_H_

#include "STObject.h"

class Stream // : public Object
{
public:

	enum { FixedSize = 0 };
};

class PositionableStream : public Stream
{
public:
	OTE* m_array;
	Oop m_index;
	Oop m_readLimit;

	enum { StreamArrayIndex= Stream::FixedSize, StreamIndexIndex , StreamReadLimitIndex, FixedSize };
};

typedef TOTE<PositionableStream> PosStreamOTE;

class WriteStream : public PositionableStream
{
public:
	Oop m_writeLimit;

	enum { StreamWriteLimitIndex=PositionableStream::FixedSize, FixedSize };
};

typedef TOTE<WriteStream> WriteStreamOTE;

#ifdef _AFX
	class ReadWriteStream : public WriteStream
	{
	public:
	};

	class FileStream : public ReadWriteStream
	{
	public:
		Oop m_file;
		Oop m_flags;				// In the old FileStream this is the name instance var.
		Oop m_pageBase;				// not present in old FileStream.
		Oop m_logicalFileSize;		// not present in old FileStream.

		enum { FileIndex=ReadWriteStream::FixedSize, FlagsIndex, PageBaseIndex, LogicalFileSizeIndex, FixedSize };
	};
#endif

#endif	// EOF