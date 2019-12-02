/*
=====
Str.h
=====
A simple String class (again)
Now mapped onto the Standard Template Library string class (BSM, Sep 2002)
*/
#pragma once
#include "EnumHelpers.h"
#include <string>
typedef std::basic_string<uint8_t, std::char_traits<uint8_t>, std::allocator<uint8_t>> Str;

#include "..\VMPointers.h"

inline Str MakeString(IDolphin* piVM, const POTE stringPointer)
{
	if (stringPointer == piVM->NilPointer())
		return Str();
	else
	{
		_ASSERTE(IsAString(stringPointer));
		size_t stringLen=FetchByteLengthOf(stringPointer);
		BYTE* bytes = FetchBytesOf(stringPointer);
		return Str((const uint8_t*)bytes, stringLen);
	}
}

//===============
//InsertStringFor
//===============
// Expand this string to have (insert) for every occurence of (ch)
inline void InsertStringFor(Str& str, const uint8_t* insert, uint8_t ch)
{
	size_t i=0;
	size_t insertlen = strlen((const char*)insert);
	while (i < str.size() && (i = str.find(ch, i)) != Str::npos)
	{
		str.replace(i, 1, insert, insertlen);
		i += insertlen;
	}
}

inline std::wostream& operator<<(std::wostream& stream, const Str& str)
{
	USES_CONVERSION;
	return stream << static_cast<LPCWSTR>(A2W(reinterpret_cast<const char*>(str.c_str())));
}
