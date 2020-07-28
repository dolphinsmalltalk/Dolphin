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

		static constexpr size_t FixedSize = Object::FixedSize;
	};

	class PositionableStream : public Stream
	{
	public:
		OTE* m_array;
		Oop m_index;
		Oop m_readLimit;
		Oop m_locale;

		static constexpr size_t StreamArrayIndex = Stream::FixedSize;
		static constexpr size_t StreamIndexIndex = StreamArrayIndex + 1;
		static constexpr size_t StreamReadLimitIndex = StreamIndexIndex + 1;
		static constexpr size_t StreamLocaleIndex = StreamReadLimitIndex + 1;
		static constexpr size_t FixedSize = StreamLocaleIndex + 1;
	};

	typedef TOTE<PositionableStream> PosStreamOTE;

	class WriteStream : public PositionableStream
	{
	public:
		Oop m_writeLimit;

		static constexpr size_t StreamWriteLimitIndex = PositionableStream::FixedSize;
		static constexpr size_t FixedSize = StreamWriteLimitIndex + 1;
	};
}

typedef TOTE<WriteStream> WriteStreamOTE;
