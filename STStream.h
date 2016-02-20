/******************************************************************************

	File: STStream.h

	Description:

	VM representation of Smalltalk Stream classes. VM requires knowledge of
	these in order to implement the stream primitives.

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"

namespace ST
{
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

		enum { StreamArrayIndex = Stream::FixedSize, StreamIndexIndex, StreamReadLimitIndex, FixedSize };
	};

	typedef TOTE<PositionableStream> PosStreamOTE;

	class WriteStream : public PositionableStream
	{
	public:
		Oop m_writeLimit;

		enum { StreamWriteLimitIndex = PositionableStream::FixedSize, FixedSize };
	};
}
typedef TOTE<WriteStream> WriteStreamOTE;
