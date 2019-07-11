/******************************************************************************

	File: STBlockClosure.h

	Description:

	VM representation of Smalltalk block objects

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "VMPointers.h"
#include "STMethod.h"

namespace ST
{
	class BlockClosure;
};
typedef TOTE<ST::BlockClosure> BlockOTE;

namespace ST
{
	#include "STBlockInfo.h"

	class BlockClosure : public Object
	{
	public:
		// Outer environment, or SmallInteger frame pointer if a method env.
		POTE		m_outer;
		MethodOTE* m_method;
		Oop			m_initialIP;
		BlockInfo	m_info;
		Oop			m_receiver;
		Oop			m_copiedValues[];

	public:
		// The pool must contain fixed size objects, so choose a suitable maximum number of
		// copied values permissible; very uncommonly exceed 2 (see Util class>>blockStats)
		static constexpr size_t MaxCopiedValues = 4;

		static constexpr size_t OuterIndex = Object::FixedSize;
		static constexpr size_t MethodIndex = OuterIndex + 1;
		static constexpr size_t InitialIPIndex = MethodIndex + 1;
		static constexpr size_t InfoIndex = InitialIPIndex + 1;
		static constexpr size_t ReceiverIndex = InfoIndex + 1;
		static constexpr size_t FixedSize = ReceiverIndex + 1;
		static constexpr size_t TempFrameStart = FixedSize;

		SmallUinteger initialIP() const
		{
			return integerValueOf(m_initialIP);
		}

		size_t copiedValuesCount(BlockOTE* myOTE) const
		{
			return myOTE->pointersSize() - FixedSize;
		}

		stacktempcount_t stackTempsCount() const
		{
			return m_info.stackTempsCount;
		}

		envtempcount_t envTempsCount() const
		{
			return m_info.envTempsCount;
		}

		methodargcount_t argumentCount() const
		{
			return m_info.argumentCount;
		}

		bool isClean(BlockOTE* ote) const
		{
			return m_receiver == Oop(Pointers.Nil) && m_outer == Pointers.Nil
				&& copiedValuesCount(ote) == 0 && envTempsCount() == 0;
		}
	};
}

std::wostream& operator<<(std::wostream& st, const BlockOTE*);
