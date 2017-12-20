#ifndef _DOLPHINIF_H_
#define _DOLPHINIF_H_

#include <windows.h>
#include <string.h>

#ifdef _DEBUG
class ostream;
#endif

namespace DolphinIF {

enum { MinSmallInteger = -0x40000000, MaxSmallInteger = 0x3FFFFFFF };

typedef signed char		SBYTE;
typedef short			SWORD;
typedef long			SDWORD;

typedef DWORD	MWORD;

typedef MWORD Oop;
typedef void* POTE;

#include "STObject.h"

// I'm not happy about this being in here - it should be cut down to something
// simpler and less comprehensive. Hence outside the namespace.
#include "VMPointers.h"

#ifndef _DOLPHINIMPORT
	#define _DOLPHINIMPORT __declspec(dllimport)
#endif

#define _DOLPHINAPI(x) _DOLPHINIMPORT x __stdcall

_DOLPHINAPI(VMPointers&) GetVMPointers();

// For externally reference counting an object - prevents it being GC'd,
// the object may still move, however, so don't hold down pointers into it.
_DOLPHINAPI(void) AddReference(Oop objectPointer);
_DOLPHINAPI(void) RemoveReference(Oop objectPointer);

_DOLPHINAPI(POTE) FetchClassOf(Oop objectPointer);
_DOLPHINAPI(bool) InheritsFrom(const POTE behaviorPointer, const POTE classPointer);

_DOLPHINAPI(bool) IsBehavior(Oop objectPointer);
_DOLPHINAPI(bool) IsAMetaclass(const POTE);
_DOLPHINAPI(bool) IsAClass(const POTE);

_DOLPHINAPI(Oop) Perform(Oop receiver, POTE selector);
_DOLPHINAPI(Oop) PerformWith(Oop receiver, POTE selector, Oop arg);
_DOLPHINAPI(Oop) PerformWithWith(Oop receiver, POTE selector, Oop arg1, Oop arg2);
_DOLPHINAPI(Oop) PerformWithWithWith(Oop receiver, POTE selector, Oop arg1, Oop arg2, Oop arg3);
_DOLPHINAPI(Oop) PerformWithArguments(Oop receiver, POTE selector, Oop argArray);

_DOLPHINAPI(POTE) NewObject(POTE classPointer);
_DOLPHINAPI(POTE) NewObjectWithPointers(POTE classPointer, unsigned size);
_DOLPHINAPI(POTE) NewByteArray(unsigned len);
_DOLPHINAPI(POTE) NewStringWithLen(const char* value, unsigned len);
_DOLPHINAPI(Oop) NewSignedInteger(SDWORD value);
//_DOLPHINAPI(Oop) NewSignedInteger(SQWORD value);
_DOLPHINAPI(Oop) NewUnsignedInteger(DWORD value);
//_DOLPHINAPI(Oop) NewUnsignedInteger(QWORD value);

_DOLPHINAPI(POTE) NewCharacter(DWORD codePoint);
_DOLPHINAPI(POTE) NewArray(unsigned size);

_DOLPHINAPI(POTE) NewFloat(double fValue);
_DOLPHINAPI(POTE) InternSymbol(const char* name);

_DOLPHINAPI(void) StorePointerWithValue(Oop& oopSlot, Oop oopValue);

_DOLPHINAPI(BOOL) DisableInterrupts(BOOL bDisable);
_DOLPHINAPI(int) CallbackExceptionFilter(LPEXCEPTION_POINTERS info);

#ifdef _DEBUG
	_DOLPHINAPI(void) DecodeMethod(POTE methodPointer, void* pstream);
#endif

_DOLPHINAPI(BOOL) DisableAsyncGC(BOOL bDisable);

// Please do not rely on any of the internal representation exposed by these inline
// functions, as it may change in future.
inline Object* GetObject(POTE ote)
{
	return *(Object**)ote;
}

inline BOOL IsIntegerObject(Oop objectPointer)
{
	return objectPointer & 1;
}

inline SDWORD IntegerValueOf(Oop objectPointer)
{
	// Use cast to ensure shift is signed arithmetic
	return (SDWORD(objectPointer) >> 1);
}

inline Oop IntegerObjectOf(SDWORD value) 			
{
	return (Oop(((value) << 1) | 1));
}

inline bool IsIntegerValue(SDWORD valueWord)
{
	return (valueWord >= MinSmallInteger && valueWord <= MaxSmallInteger);
}

inline BYTE* FetchBytesOf(POTE ote)
{
	VariantByteObject* pObj = static_cast<VariantByteObject*>(GetObject(ote));
	return pObj->m_fields;
}

inline MWORD FetchByteLengthOf(POTE ote)
{
	return GetObject(ote)->ByteSize();
}

inline MWORD FetchWordLengthOf(POTE ote)
{
	return GetObject(ote)->PointerSize();
}

inline POTE NewString(const char* value)
{
	unsigned len = strlen(value);
	return NewStringWithLen(value, len);
}

// Answer whether the object with Oop objectPointer is an instance or subinstance
// of the Behavior object with Oop classPointer;
inline bool IsKindOf(Oop objectPointer, const POTE classPointer)
{
	POTE behaviorPointer = FetchClassOf(objectPointer);
	return InheritsFrom(behaviorPointer, classPointer);
}

};

#endif