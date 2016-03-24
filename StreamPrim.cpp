/******************************************************************************

	File: StreamPrim.cpp

	Description:

	Implementation of the Interpreter class' Stream primitives

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"


// Smalltalk classes
#include "STBehavior.h"
#include "STStream.h"
#include "STArray.h"
#include "STByteArray.h"
#include "STString.h"
#include "STInteger.h"
#include "STCharacter.h"

// This primitive handles PositionableStream>>next, but only for Arrays, Strings and ByteArrays
// Unary message, so does not modify stack pointer, and is therefore called directly from the ASM 
// primitive table without indirection through an ASM thunk.
BOOL __fastcall Interpreter::primitiveNext()
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(stackTop());		// Access receiver
	
	// Only works for subclasses of PositionableStream (or look alikes)
	//ASSERT(!ObjectMemoryIsIntegerObject(streamPointer) && ObjectMemory::isKindOf(streamPointer, Pointers.ClassPositionableStream));
	
	PositionableStream* readStream = streamPointer->m_location;
	
	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (!ObjectMemoryIsIntegerObject(readStream->m_index) ||
		!ObjectMemoryIsIntegerObject(readStream->m_readLimit))
		return primitiveFailure(0);	// Receiver fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

	// Is the current index within the limits of the collection?
	// Remember that the index is 1 based (it's a Smalltalk index), and we're 0 based,
	// so we don't need to increment it until after we've got the next object
	if (index < 0 || index >= limit)
		return primitiveFailure(2);		// No, fail it

	OTE* oteBuf = readStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;
	
	if (bufClass == Pointers.ClassString)
	{
		StringOTE* oteString = reinterpret_cast<StringOTE*>(oteBuf);

		// A sanity check - ensure within bounds of object too (again in Blue Book spec)
		if (MWORD(index) >= oteString->bytesSize())
			return primitiveFailure(3);

		String* buf = oteString->m_location;
		stackTop() = reinterpret_cast<Oop>(Character::New(buf->m_characters[index]));
	}
	// We also support ByteArrays in our primitiveNext (unlike BB).
	else if (bufClass == Pointers.ClassByteArray)
	{
		ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);

		if (MWORD(index) >= oteBytes->bytesSize())
			return primitiveFailure(3);

		ByteArray* buf = oteBytes->m_location;
		stackTop() = ObjectMemoryIntegerObjectOf(buf->m_elements[index]);
	}
	else if (bufClass == Pointers.ClassArray)
	{
		ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
		if (MWORD(index) >= oteArray->pointersSize())
			return primitiveFailure(3);

		Array* buf = oteArray->m_location;
		stackTop() = buf->m_elements[index];
	}
	else
		return primitiveFailure(1);		// Collection cannot be handled by primitive, rely on Smalltalk code
	
	// When incrementing the index we must allow for it overflowing a SmallInteger, even though
	// this is extremely unlikely in practice
	readStream->m_index = Integer::NewSigned32WithRef(index+1);

	return primitiveSuccess();									// Succeed
}


// This primitive handles WriteStream>>NextPut:, but only for Arrays, Strings & ByteArrays
// Uses but does not modify stack pointer, instead returns the number of bytes to 
// pop from the Smalltalk stack.
BOOL __fastcall Interpreter::primitiveNextPut()
{
	Oop* sp = m_registers.m_stackPointer;
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*(sp-1));		// Access receiver under argument
	
	//ASSERT(!ObjectMemoryIsIntegerObject(streamPointer) && ObjectMemory::isKindOf(streamPointer, Pointers.ClassPositionableStream));

	WriteStream* writeStream = streamPointer->m_location;
	
	// Ensure valid stream - checks from Blue Book
	if (!ObjectMemoryIsIntegerObject(writeStream->m_index) ||
		!ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		return primitiveFailure(0);	// Fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

	// Within the bounds of the limit
	if (index < 0 || index >= limit)
		return primitiveFailure(2);
	
	Oop value = *(sp);
	OTE* oteBuf = writeStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;
	
	if (bufClass == Pointers.ClassString)
	{
		if (ObjectMemory::fetchClassOf(value) != Pointers.ClassCharacter)
			return primitiveFailure(4);	// Attempt to put non-character

		StringOTE* oteString = reinterpret_cast<StringOTE*>(oteBuf);
		
		if (index >= oteString->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to put non-character or off end of String

		String* buf = oteString->m_location;
		CharOTE* oteChar = reinterpret_cast<CharOTE*>(value);
		buf->m_characters[index] = static_cast<char>(oteChar->getIndex() - ObjectMemory::FirstCharacterIdx);
	}
	else if (bufClass == Pointers.ClassArray)
	{
		ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(oteBuf);
		
		// In bounds of Array?
		if (index >= oteArray->pointersSizeForUpdate())
			return primitiveFailure(3);

		Array* buf = oteArray->m_location;
		// We must ref. count value here as we're storing into a heap object slot
		ObjectMemory::storePointerWithValue(buf->m_elements[index], value);
	}
	else if (bufClass == Pointers.ClassByteArray)
	{
		if (!ObjectMemoryIsIntegerObject(value))
			return primitiveFailure(4);	// Attempt to put non-SmallInteger
		SMALLINTEGER intValue = ObjectMemoryIntegerValueOf(value);
		if (intValue < 0 || intValue > 255)
			return primitiveFailure(4);	// Can only store 0..255

		ByteArrayOTE* oteByteArray = reinterpret_cast<ByteArrayOTE*>(oteBuf);
		
		if (index >= oteByteArray->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to put non-character or off end of String

		oteByteArray->m_location->m_elements[index] = static_cast<BYTE>(intValue);
	}
	else
		return primitiveFailure(1);
	
	writeStream->m_index = Integer::NewSigned32WithRef(index + 1);		// Increment the stream index

	// As we no longer pop stack here, the receiver is still under the argument
	*(sp-1) = value;

	return sizeof(Oop);		// Pop 4 bytes
}

// Non-standard, but has very beneficial effect on performance
BOOL __fastcall Interpreter::primitiveNextPutAll()
{
	Oop* sp = m_registers.m_stackPointer;
	WriteStreamOTE* streamPointer = reinterpret_cast<WriteStreamOTE*>(*(sp-1));		// Access receiver under argument

	WriteStream* writeStream = streamPointer->m_location;
	
	// Ensure valid stream - checks from Blue Book
	if (!ObjectMemoryIsIntegerObject(writeStream->m_index) ||
		!ObjectMemoryIsIntegerObject(writeStream->m_writeLimit))
		return primitiveFailure(0);	// Fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(writeStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(writeStream->m_writeLimit);

	if (index < 0)
		return primitiveFailure(2);

	Oop value = *(sp);
	
	OTE* oteBuf = writeStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;

	MWORD newIndex;

	if (bufClass == Pointers.ClassString)
	{
		BehaviorOTE* oteClass = ObjectMemory::fetchClassOf(value);
		if (oteClass != Pointers.ClassString && oteClass != Pointers.ClassSymbol)
			return primitiveFailure(4);	// Attempt to put non-string

		StringOTE* oteString = reinterpret_cast<StringOTE*>(value);
		String* str = oteString->m_location;
		
		MWORD valueSize = oteString->bytesSize();
		newIndex = MWORD(index)+valueSize;

		if (newIndex >= static_cast<MWORD>(limit))			// Beyond write limit
			return primitiveFailure(2);

		if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to write off end of buffer

		String* buf = static_cast<String*>(oteBuf->m_location);
		memcpy(buf->m_characters+index, str->m_characters, valueSize);
	}
	else if (bufClass == Pointers.ClassByteArray)
	{
		if (ObjectMemory::fetchClassOf(value) != bufClass)
			return primitiveFailure(4);	// Attempt to put non-ByteArray

		ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(value);
		ByteArray* bytes = oteBytes->m_location;
		MWORD valueSize = oteBytes->bytesSize();
		newIndex = MWORD(index)+valueSize;

		if (newIndex >= (MWORD)limit)			// Beyond write limit
			return primitiveFailure(2);

		if (static_cast<int>(newIndex) >= oteBuf->bytesSizeForUpdate())
			return primitiveFailure(3);	// Attempt to write off end of buffer

		ByteArray* buf = static_cast<ByteArray*>(oteBuf->m_location);
		memcpy(buf->m_elements+index, bytes->m_elements, valueSize);
	}
	else if (bufClass == Pointers.ClassArray)
	{
		if (ObjectMemory::fetchClassOf(value) != Pointers.ClassArray)
			return primitiveFailure(4);	// Attempt to put non-Array

		ArrayOTE* oteArray = reinterpret_cast<ArrayOTE*>(value);
		Array* array = oteArray->m_location;
		MWORD valueSize = oteArray->pointersSize();
		newIndex = MWORD(index) + valueSize;

		if (newIndex >= (MWORD)limit)			// Beyond write limit
			return primitiveFailure(2);

		if (static_cast<int>(newIndex) >= oteBuf->pointersSizeForUpdate())
			return primitiveFailure(3);	// Attempt to write off end of buffer

		Array* buf = static_cast<Array*>(oteBuf->m_location);

		for (MWORD i = 0; i < valueSize; i++)
		{
			ObjectMemory::storePointerWithValue(buf->m_elements[index + i], array->m_elements[i]);
		}
	}
	else
		return primitiveFailure(1);
	
	writeStream->m_index = Integer::NewUnsigned32WithRef(newIndex);		// Increment the stream index

	// As we no longer pop stack here, the receiver is still under the argument
	*(sp-1) = value;

	return sizeof(Oop);		// Pop 4 bytes
}

// The primitive handles PositionableStream>>atEnd, but only for arrays/strings
// Does not use successFlag. Unary, so does not modify the stack pointer
BOOL __fastcall Interpreter::primitiveAtEnd()
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(stackTop());		// Access receiver
	//ASSERT(!ObjectMemoryIsIntegerObject(streamPointer) && ObjectMemory::isKindOf(streamPointer, Pointers.ClassPositionableStream));
	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream (see BBB p632)
	if (!ObjectMemoryIsIntegerObject(readStream->m_index) ||
		!ObjectMemoryIsIntegerObject(readStream->m_readLimit))
		return primitiveFailure(0);

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);
	BehaviorOTE* bufClass = readStream->m_array->m_oteClass;

	OTE* boolResult;
	if (bufClass == Pointers.ClassString || bufClass == Pointers.ClassByteArray)
		boolResult = index >= limit || (MWORD(index) >= readStream->m_array->bytesSize()) ?
			Pointers.True : Pointers.False;
	else if (bufClass == Pointers.ClassArray)
		boolResult = index >= limit || (MWORD(index) >= readStream->m_array->pointersSize()) ?
			Pointers.True : Pointers.False;
	else
		return primitiveFailure(1);		// Doesn't work for non-Strings/ByteArrays/Arrays, or if out of bounds
	
	stackTop() = reinterpret_cast<Oop>(boolResult);
	return primitiveSuccess();
}


// This primitive handles PositionableStream>>nextSDWORD, but only for byte-arrays
// Unary message, so does not modify stack pointer
BOOL __fastcall Interpreter::primitiveNextSDWORD()
{
	PosStreamOTE* streamPointer = reinterpret_cast<PosStreamOTE*>(stackTop());		// Access receiver
	PositionableStream* readStream = streamPointer->m_location;

	// Ensure valid stream - unusually this validity check is included in the Blue Book spec
	// and appears to be implemented in most Smalltalks, so we implement here too.
	if (!ObjectMemoryIsIntegerObject(readStream->m_index) ||
		!ObjectMemoryIsIntegerObject(readStream->m_readLimit))
		return primitiveFailure(0);	// Receiver fails invariant check

	SMALLINTEGER index = ObjectMemoryIntegerValueOf(readStream->m_index);
	SMALLINTEGER limit = ObjectMemoryIntegerValueOf(readStream->m_readLimit);

	// Is the current index within the limits of the collection?
	// Remember that the index is 1 based (it's a Smalltalk index), and we're 0 based,
	// so we don't need to increment it until after we've got the next object
	if (index < 0 || index >= limit)
		return primitiveFailure(2);		// No, fail it

	OTE* oteBuf = readStream->m_array;
	BehaviorOTE* bufClass = oteBuf->m_oteClass;
	
	if (bufClass != Pointers.ClassByteArray)
		return primitiveFailure(1);		// Collection cannot be handled by primitive, rely on Smalltalk code

	ByteArrayOTE* oteBytes = reinterpret_cast<ByteArrayOTE*>(oteBuf);

	const int newIndex = index + sizeof(SDWORD);
	if (MWORD(newIndex) > oteBytes->bytesSize())
		return primitiveFailure(3);

	const Oop oopNewIndex = ObjectMemoryIntegerObjectOf(newIndex);
	if (int(oopNewIndex) < 0)
		return primitiveFailure(4);	// index overflowed SmallInteger range

	// When incrementing the index we must allow for it overflowing a SmallInteger, even though
	// this is extremely unlikely in practice
	readStream->m_index = oopNewIndex;

	// Receiver is overwritten
	ByteArray* byteArray = oteBytes->m_location;
	replaceStackTopWithNew(Integer::NewSigned32(*reinterpret_cast<SDWORD*>(byteArray->m_elements+index)));

	return primitiveSuccess();									// Succeed
}

