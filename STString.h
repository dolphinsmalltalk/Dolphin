/******************************************************************************

	File: STString.h

	Description:

	VM representation of Smalltalk String class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/
#pragma once

#include "VMPointers.h"
#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

// Declare forward references
namespace ST 
{ 
	class String;
	class Symbol;
	class WideString;
}
typedef TOTE<ST::String> StringOTE;
typedef TOTE<ST::WideString> WideStringOTE;
typedef TOTE<ST::Symbol> SymbolOTE;

namespace ST
{
	class String : public ArrayedCollection
	{
	public:
		char m_characters[];		// Variable length array of data

		static StringOTE* __fastcall NewWithLen(const char* value, unsigned len);
		static StringOTE* __stdcall New(LPCSTR sz);
		static StringOTE* __fastcall New(LPCWSTR wsz);
		static StringOTE* __fastcall NewFromBSTR(BSTR bs);
		static StringOTE* NewLiteral(const char* szValue);
	};

	inline StringOTE* String::New(LPCSTR value)
	{
		unsigned len = strlen(value);
		return NewWithLen(value, len);
	}

	// Allocate a new String from a Unicode string
	inline StringOTE* __fastcall String::NewFromBSTR(BSTR bs)
	{
		return bs == NULL ? NewWithLen("", 0) : New(bs);
	}

	inline StringOTE* String::NewLiteral(const char* value)
	{
		unsigned len = strlen(value);
		if (len > 0)
		{
			StringOTE* oteLiteral = NewWithLen(value, len);
			oteLiteral->beImmutable();
			return oteLiteral;
		}
		else
			return Pointers.EmptyString;
	}


	class Symbol : public ArrayedCollection	// Actually a String subclass
	{
	public:
		char m_characters[];
	};

	class WideString : public ArrayedCollection	// Actuall a string subclass
	{
	public:
		wchar_t m_characters[];

		static WideStringOTE* __fastcall New(LPCWSTR wsz);
		static WideStringOTE* __fastcall NewWithLen(const wchar_t* wsz, unsigned len);
	};

	inline WideStringOTE* WideString::New(LPCWSTR value)
	{
		unsigned len = wcslen(value);
		return NewWithLen(value, len);
	}
}

ostream& operator<<(ostream& st, const StringOTE*);
ostream& operator<<(ostream& st, const SymbolOTE*);

