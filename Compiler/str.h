/*
=====
Str.h
=====
A simple String class (again)
Now mapped onto the Standard Template Library string class (BSM, Sep 2002)
*/
#pragma once

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
		MWORD stringLen=FetchByteLengthOf(stringPointer);
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
	unsigned i=0;
	int insertlen = strlen((const char*)insert);
	while (i < str.size() && (i = str.find(ch, i)) != Str::npos)
	{
		str.replace(i, 1, insert, insertlen);
		i += insertlen;
	}
}

struct TEXTRANGE
{
	int m_start;
	int m_stop;

	TEXTRANGE(int start=0, int stop=-1) : m_start(start), m_stop(stop)
	{}

	int span() const { return m_stop - m_start + 1; }
};

inline std::wostream& operator<<(std::wostream& stream, const std::string& str)
{
	USES_CONVERSION;
	return stream << static_cast<LPCWSTR>(A2W(str.c_str()));
}
