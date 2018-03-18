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
	class ByteString;
	class Symbol;
	class Utf32String;
	class Utf16String;
	class Utf8String;
};
typedef TOTE<ST::String> StringOTE;
typedef TOTE<ST::ByteString> ByteStringOTE;
typedef TOTE<ST::Utf8String> Utf8StringOTE;
typedef TOTE<ST::Utf16String> Utf16StringOTE;
typedef TOTE<ST::Utf32String> Utf32StringOTE;
typedef TOTE<ST::Symbol> SymbolOTE;

namespace ST
{
	enum class StringEncoding
	{
		Ansi,
		Utf8,
		Utf16,
		Utf32
	};

	class String : public ArrayedCollection
	{
	public:
		template <typename T> static StringEncoding GetEncoding(T* ote)
		{
			ASSERT(ote->isNullTerminated());
			auto strClass = reinterpret_cast<const StringClass*>(ote->m_oteClass->m_location);
			return strClass->Encoding;
		}
	};

	template <UINT CP, size_t PointersIndex, class OTE, class TChar> class ByteStringT : public ArrayedCollection
	{
	public:
		typedef TChar CU;
		typedef const TChar * __restrict PCSZ;
		static const UINT CodePage = CP;

		CU m_characters[1];		// Variable length array of data

		typedef ByteStringT<CP, PointersIndex, OTE, TChar> MyType;
		typedef OTE* POTE;

		static POTE __fastcall New(size_t cch)
		{
			return reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), cch));
		}

		static POTE __fastcall New(LPCCH value, size_t cch)
		{
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), cch));
			MyType* __restrict string = stringPointer->m_location;
			string->m_characters[cch] = '\0';
			memcpy(string->m_characters, value, cch);
			return stringPointer;
		}

		static POTE __fastcall New(LPCSTR sz)
		{
			size_t cch = strlen(sz);
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), cch));
			MyType* __restrict string = stringPointer->m_location;
			// Copy the string and null terminator
			memcpy(string->m_characters, sz, cch + sizeof(char));
			return stringPointer;
		}

		// Allocate a new String from a Unicode string
		static POTE __fastcall New(LPCWSTR wsz)
		{
			int cch = ::WideCharToMultiByte(CP, 0, wsz, -1, nullptr, 0, nullptr, nullptr);
			// Length includes null terminator since input is null terminated
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), (cch - 1)*sizeof(CU)));
			CU* psz = stringPointer->m_location->m_characters;
			int cch2 = ::WideCharToMultiByte(CP, 0, wsz, -1, reinterpret_cast<LPSTR>(psz), cch, nullptr, nullptr);
			UNREFERENCED_PARAMETER(cch2);
			ASSERT(cch2 == cch);
			return stringPointer;
		}

		static POTE __fastcall New(LPCWCH pwch, size_t cwch)
		{
			int cch = ::WideCharToMultiByte(CP, 0, pwch, cwch, nullptr, 0, nullptr, nullptr);
			// Length does not include null terminator
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject(reinterpret_cast<BehaviorOTE*>(Pointers.pointers[PointersIndex - 1]), cch*sizeof(CU)));
			CU* psz = stringPointer->m_location->m_characters;
			psz[cch] = '\0';
			int cch2 = ::WideCharToMultiByte(CP, 0, pwch, cwch, reinterpret_cast<LPSTR>(psz), cch, nullptr, nullptr);
			UNREFERENCED_PARAMETER(cch2);
			ASSERT(cch2 == cch);
			return stringPointer;
		}

		static POTE NewLiteral(LPCSTR szValue)
		{
			size_t cch = strlen(szValue);
			if (cch > 0)
			{
				MyOTE* oteLiteral = NewWithLen(szValue, cch);
				oteLiteral->beImmutable();
				return oteLiteral;
			}
			else
				return Pointers.EmptyString;
		}
	};


	class ByteString : public ByteStringT<CP_ACP, 84, ByteStringOTE, char> 
	{
	public:
		static POTE __fastcall NewFromUtf8(const uint8_t* pChars, size_t len);
	};

	class Utf8String : public ByteStringT<CP_UTF8, 104, Utf8StringOTE, uint8_t>
	{
	public:
		static POTE __fastcall NewFromAnsi(const char* pChars, size_t len);

		static POTE __fastcall NewFromBSTR(BSTR bs)
		{
			return bs == nullptr ? New("", 0) : New(reinterpret_cast<LPCWSTR>(bs));
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
		typedef WCHAR CU;

		CU m_characters[];

		static Utf16StringOTE* __fastcall New(LPCWSTR wsz);
		static Utf16StringOTE* __fastcall New(const WCHAR* pChars, size_t len);
		template <UINT CP, class T> static Utf16StringOTE* __fastcall New(const T* pChars, size_t len);
		static Utf16StringOTE* __fastcall New(OTE* oteByteString);
		static Utf16StringOTE* __fastcall New(size_t cwch);
		static Utf16StringOTE * ST::Utf16String::NewFromBSTR(BSTR bs)
		{
			return New(bs, ::SysStringLen(bs));
		}
	};

	class Utf32String : public ArrayedCollection	// Actually a string subclass
	{
	public:
		typedef uint32_t CU;

		CU m_characters[];
	};
}


wostream& operator<<(wostream& st, const ByteStringOTE*);
wostream& operator<<(wostream& st, const SymbolOTE*);

