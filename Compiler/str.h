/*
=====
Str.h
=====
A simple String class (again)
Now mapped onto the Standard Template Library string class (BSM, Sep 2002)
*/

#ifndef _IST_STR_H_
#define _IST_STR_H_

#include <string>
typedef std::string Str;

#include "..\VMPointers.h"

inline Str MakeString(IDolphin* piVM, const POTE stringPointer)
{
	if (stringPointer == piVM->NilPointer())
		return Str();
	else
	{
		_ASSERTE(piVM->IsKindOf(Oop(stringPointer), ((VMPointers*)piVM->GetVMPointers())->ClassString));
		MWORD stringLen=FetchByteLengthOf(stringPointer);
		BYTE* bytes = FetchBytesOf(stringPointer);
		return Str((const char*)bytes, stringLen);
	}
}

//===============
//InsertStringFor
//===============
// Expand this string to have (insert) for every occurence of (ch)
inline void InsertStringFor(Str& str, const char* insert, char ch)
{
	unsigned i=0;
	int insertlen = strlen(insert);
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

#endif