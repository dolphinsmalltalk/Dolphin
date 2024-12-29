/*
=====
Str.h
=====
A simple String class (again)
Now mapped onto the Standard Template Library string class (BSM, Sep 2002)
*/
#pragma once
#include "..\EnumHelpers.h"

#include "..\VMPointers.h"

inline u8string MakeString(IDolphin* piVM, const POTE stringPointer)
{
	if (stringPointer == piVM->NilPointer())
		return u8string();
	else
	{
		_ASSERTE(IsAString(stringPointer));
		size_t stringLen=FetchByteLengthOf(stringPointer);
		auto bytes = FetchBytesOf(stringPointer);
		return u8string((const char8_t*)bytes, stringLen);
	}
}

inline wostream& operator<<(wostream& stream, const u8string& str)
{
	size_t cch = str.size();
	std::unique_ptr<WCHAR[]> buf(new WCHAR[cch]);
	::MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, reinterpret_cast<LPCCH>(str.data()), cch, buf.get(), cch);
	return stream << buf;
}
