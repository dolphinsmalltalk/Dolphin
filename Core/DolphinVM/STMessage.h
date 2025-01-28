/******************************************************************************

	File: STMessage.h

	Description:

	VM representation of Smalltalk Message class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/
#pragma once

#include "STObject.h"

// Declare forward references
namespace ST { class Message; }
typedef TOTE<ST::Message> MessageOTE;

namespace ST
{
	class Message // : public Object
	{
	public:
		SymbolOTE* m_selector;
		ArrayOTE* m_args;

		static constexpr size_t MessageSelectorIndex = Object::FixedSize;
		static constexpr size_t MessageArgumentsIndex = MessageSelectorIndex + 1;
		static constexpr size_t FixedSize = MessageArgumentsIndex + 1;

		static MessageOTE* New()
		{
			return reinterpret_cast<MessageOTE*>(ObjectMemory::newFixedPointerObject<FixedSize>(Pointers.ClassMessage));
		}

		static MessageOTE* NewUninitialized()
		{
			return reinterpret_cast<MessageOTE*>(ObjectMemory::newUninitializedPointerObject(Pointers.ClassMessage, FixedSize));
		}
	};
}

std::wostream& operator<<(std::wostream& st, const MessageOTE* oteMsg);
