/******************************************************************************

	File: STCollection.h

	Description:

	VM representation of Smalltalk LinkedList class, and its links (LinkedList
	uses intrusive linking).

	N.B. The classes here defined are well known to the VM, and must not
	be modified in the image. Note also that these classes may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STCollection.h"

namespace ST
{
	class LinkedList : public SequenceableCollection
	{
	public:
		OTE* m_firstLink;
		OTE* m_lastLink;

		static constexpr size_t FirstLinkIndex = SequenceableCollection::FixedSize;
		static constexpr size_t LastLinkIndex = FirstLinkIndex + 1;
		static constexpr size_t FixedSize = LastLinkIndex + 1;
	};

		bool isEmpty();
		void addLast(OTE* aLink);
		OTE* removeFirst();
		OTE* remove(OTE* aLink);
	};

class Link : public Object
{
public:
	OTE* m_nextLink;

	static constexpr size_t NextLinkIndex = Object::FixedSize;
	static constexpr size_t FixedSize = NextLinkIndex + 1;
};
	};
}
