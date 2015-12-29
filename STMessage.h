/******************************************************************************

	File: STMessage.h

	Description:

	VM representation of Smalltalk Message class.

	N.B. The class here defined is well known to the VM, and must not
	be modified in the image. Note also that this class may also have
	a representation in the assembler modules (so see istasm.inc)

******************************************************************************/

#ifndef _IST_STMessage_H_
#define _IST_STMessage_H_

#include "STObject.h"

class Message;
typedef TOTE<Message> MessageOTE;

class Message // : public Object
{
public:
	SymbolOTE*	m_selector;
	ArrayOTE*	m_args;

	enum { MessageSelectorIndex=ObjectFixedSize, MessageArgumentsIndex, FixedSize };

	static MessageOTE* New()
	{
		return reinterpret_cast<MessageOTE*>(ObjectMemory::newPointerObject(Pointers.ClassMessage, FixedSize));
	}

	static MessageOTE* NewUninitialized()
	{
		return reinterpret_cast<MessageOTE*>(ObjectMemory::newUninitializedPointerObject(Pointers.ClassMessage, FixedSize));
	}
};

ostream& operator<<(ostream& st, const MessageOTE* oteMsg);

#endif	//EOF
