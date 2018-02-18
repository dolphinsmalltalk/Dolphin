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
	class Utf16String;
	class Utf8String;
};
typedef TOTE<ST::String> StringOTE;
typedef TOTE<ST::Utf8String> Utf8StringOTE;
typedef TOTE<ST::Utf16String> Utf16StringOTE;
typedef TOTE<ST::Symbol> SymbolOTE;

namespace ST
{
	template <UINT CP, size_t PointersIndex, class OTE> class ByteString : public ArrayedCollection
	{
	public:
		char m_characters[1];		// Variable length array of data

		typedef ByteString<CP, PointersIndex, OTE> MyType;
		typedef OTE* POTE;

		static POTE __fastcall New(const char * __restrict value, size_t len)
		{
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), len));
			MyType* __restrict string = stringPointer->m_location;
			string->m_characters[len] = '\0';
			memcpy(string->m_characters, value, len);
			return stringPointer;
		}

		static POTE __fastcall New(LPCSTR sz)
		{
			unsigned len = strlen(sz);
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), len));
			MyType* __restrict string = stringPointer->m_location;
			memcpy(string->m_characters, sz, len + 1);
			return stringPointer;
		}

		// Allocate a new String from a Unicode string
		static POTE __fastcall New(LPCWSTR wsz)
		{
			int len = ::WideCharToMultiByte(CP, 0, wsz, -1, nullptr, 0, nullptr, nullptr);
			// Length includes null terminator since input is null terminated
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), len - 1));
			MyType* __restrict string = stringPointer->m_location;
			int nCopied = ::WideCharToMultiByte(CP, 0, wsz, -1, string->m_characters, len, nullptr, nullptr);
			UNREFERENCED_PARAMETER(nCopied);
			ASSERT(nCopied == len);
			return stringPointer;
		}

		static POTE __fastcall New(const WCHAR* pChars, size_t wideLen)
		{
			int len = ::WideCharToMultiByte(CP, 0, pChars, wideLen, nullptr, 0, nullptr, nullptr);
			// Length does not include null terminator
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), len));
			MyType* __restrict string = stringPointer->m_location;
			string->m_characters[len] = '\0';
			int nCopied = ::WideCharToMultiByte(CP, 0, pChars, wideLen, string->m_characters, len, nullptr, nullptr);
			UNREFERENCED_PARAMETER(nCopied);
			ASSERT(nCopied == len);
			return stringPointer;
		}

		static POTE NewLiteral(const char* szValue)
		{
			unsigned len = strlen(value);
			if (len > 0)
			{
				MyOTE* oteLiteral = NewWithLen(value, len);
				oteLiteral->beImmutable();
				return oteLiteral;
			}
			else
				return Pointers.EmptyString;
		}
	};


	class String : public ByteString<CP_ACP, 84, StringOTE> 
	{
	public:
		static POTE __fastcall NewFromUtf8(const char* pChars, size_t len);
	};

	class Utf8String : public ByteString<CP_UTF8, 104, Utf8StringOTE>
	{
	public:
		static POTE __fastcall NewFromAnsi(const char* pChars, size_t len);

		static POTE __fastcall NewFromBSTR(BSTR bs)
		{
			return bs == nullptr ? New("", 0) : New((LPCWSTR)bs);
		}
	};

	class Symbol : public ArrayedCollection	// Actually a String subclass
	{
	public:
		char m_characters[];
	};

	class Utf16String : public ArrayedCollection	// Actually a string subclass
	{
	public:
		WCHAR m_characters[];

		static Utf16StringOTE* __fastcall New(LPCWSTR wsz);
		static Utf16StringOTE* __fastcall New(const WCHAR* pChars, size_t len);
		//static Utf16StringOTE* __fastcall New(LPCSTR sz, UINT cp);
		template <UINT CP> static Utf16StringOTE* __fastcall New(const char* pChars, size_t len);
		static Utf16StringOTE* __fastcall New(StringOTE* oteByteString);

		static Utf16StringOTE * ST::Utf16String::NewFromBSTR(BSTR bs)
		{
			return New(bs, ::SysStringLen(bs));
		}
	};
}


ostream& operator<<(ostream& st, const StringOTE*);
ostream& operator<<(ostream& st, const SymbolOTE*);

