/*
=====
Str.h
=====
A simple String class (again)
Now mapped onto the Standard Template Library string class (BSM, Sep 2002)
*/
#pragma once
#include "..\EnumHelpers.h"
#include <string>
typedef std::basic_string<char8_t, std::char_traits<char8_t>, std::allocator<char8_t>> Str;

#include "..\VMPointers.h"

inline Str MakeString(IDolphin* piVM, const POTE stringPointer)
{
	if (stringPointer == piVM->NilPointer())
		return Str();
	else
	{
		_ASSERTE(IsAString(stringPointer));
		size_t stringLen=FetchByteLengthOf(stringPointer);
		auto bytes = FetchBytesOf(stringPointer);
		return Str((const char8_t*)bytes, stringLen);
	}
}

//===============
//InsertStringFor
//===============
// Expand this string to have (insert) for every occurence of (ch)
inline void InsertStringFor(Str& str, const char8_t* insert, char8_t ch)
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
