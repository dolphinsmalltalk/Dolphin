/******************************************************************************

	File: STString.h

	Description:

	VM representation of Smalltalk String class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/
#pragma once

#include "STCollection.h"

// Turn off warning about zero length arrays
#pragma warning ( disable : 4200)

// Declare forward references
namespace ST 
{ 
	class String;
	class AnsiString;
	class Symbol;
	class Utf32String;
	class Utf16String;
	class Utf8String;
};
typedef TOTE<ST::String> StringOTE;
typedef TOTE<ST::Symbol> SymbolOTE;

class AnsiStringOTE : public TOTE<ST::AnsiString>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size); }
	__forceinline size_t sizeForRead() const { return m_size & SizeMask; }
};

class Utf8StringOTE : public TOTE<ST::Utf8String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size); }
	__forceinline size_t sizeForRead() const { return m_size & SizeMask; }
};

class Utf16StringOTE : public TOTE<ST::Utf16String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size) / static_cast<ptrdiff_t>(sizeof(char16_t)); }
	__forceinline size_t sizeForRead() const { return (m_size & SizeMask) / sizeof(char16_t); }
};

class Utf32StringOTE : public TOTE<ST::Utf32String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size) / static_cast<ptrdiff_t>(sizeof(char32_t)); }
	__forceinline size_t sizeForRead() const { return (m_size & SizeMask) / sizeof(char32_t); }
};

typedef UINT codepage_t;

namespace ST
{
	class String : public ArrayedCollection
	{
	public:
	};

	template <codepage_t ACP, size_t I, class OTE, class TChar> class ByteStringT : public ArrayedCollection
	{
	public:
		typedef TChar CU;
		typedef const TChar * __restrict PCSZ;
		static const size_t PointersIndex = I;
		static const codepage_t CP = ACP;

		CU m_characters[1];		// Variable length array of data

		typedef ByteStringT<CP, PointersIndex, OTE, TChar> MyType;
		typedef OTE* POTE;

		static constexpr codepage_t CodePage()
		{
			return ACP == CP_ACP ? Interpreter::m_ansiCodePage : ACP;
		}

		static POTE __fastcall New(size_t cch)
		{
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject<MyType>(cch));
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		static POTE __fastcall New(PCSZ value, size_t cch)
		{
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject<MyType>(cch));
			MyType* __restrict string = stringPointer->m_location;
			string->m_characters[cch] = '\0';
			memcpy(string->m_characters, value, cch);
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		static POTE __fastcall New(PCSZ sz)
		{
			size_t cch = strlen((LPCSTR)sz);
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject<MyType>(cch));
			MyType* __restrict string = stringPointer->m_location;
			// Copy the string and null terminator
			memcpy(string->m_characters, sz, cch + sizeof(CU));
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		// Allocate a new String from a Unicode string
		static POTE __fastcall New(LPCWSTR wsz)
		{
			int cch = ::WideCharToMultiByte(CodePage(), 0, wsz, -1, nullptr, 0, nullptr, nullptr);
			// Length includes null terminator since input is null terminated
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject<MyType>((cch - 1)*sizeof(CU)));
			CU* psz = stringPointer->m_location->m_characters;
			int cch2 = ::WideCharToMultiByte(CodePage(), 0, wsz, -1, reinterpret_cast<LPSTR>(psz), cch, nullptr, nullptr);
			UNREFERENCED_PARAMETER(cch2);
			ASSERT(cch2 == cch);
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		static POTE __fastcall New(const char16_t* pwch, size_t cwch)
		{
			int cch = ::WideCharToMultiByte(CodePage(), 0, (LPCWCH)pwch, cwch, nullptr, 0, nullptr, nullptr);
			// Length does not include null terminator
			OTE* stringPointer = reinterpret_cast<OTE*>(ObjectMemory::newUninitializedNullTermObject<MyType>(cch*sizeof(CU)));
			CU* psz = stringPointer->m_location->m_characters;
			psz[cch] = '\0';
			int cch2 = ::WideCharToMultiByte(CodePage(), 0, (LPCWCH)pwch, cwch, reinterpret_cast<LPSTR>(psz), cch, nullptr, nullptr);
			UNREFERENCED_PARAMETER(cch2);
			ASSERT(cch2 == cch);
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}
	};

	// Indexes into the VM's pointer array
	const size_t ClassByteString = 84;
	const size_t ClassUtf8String = 104;
	const size_t ClassUtf16String = 93;

	class Utf8String : public ByteStringT<CP_UTF8, ClassUtf8String, Utf8StringOTE, char8_t>
	{
	public:
		static POTE __fastcall NewFromAnsi(const char* pChars, size_t len);

		static POTE __fastcall NewFromBSTR(BSTR bs)
		{
			return bs == nullptr ? New(u8"", 0) : New(reinterpret_cast<LPCWSTR>(bs));
		}
	};

	class AnsiString : public ByteStringT<CP_ACP, ClassByteString, AnsiStringOTE, char>
	{
	public:
		static POTE __fastcall NewFromUtf8(const Utf8String::CU* pChars, size_t len);
	};

	class Symbol : public ArrayedCollection	// Really a subclass of Utf8String
	{
	public:
		Utf8String::CU m_characters[];
	};

	class Utf16String : public ArrayedCollection	// Actually a string subclass
	{
	public:
		typedef char16_t CU;
		static const size_t PointersIndex = ClassUtf16String;

		CU m_characters[];

		static Utf16StringOTE* __fastcall New(LPCWSTR wsz);
		static Utf16StringOTE* __fastcall New(const WCHAR* pChars, size_t len);
		template <codepage_t CP, class T> static Utf16StringOTE* __fastcall New(const T* pChars, size_t len);
		static Utf16StringOTE* __fastcall New(OTE* oteByteString);
		static Utf16StringOTE* __fastcall New(size_t cwch);
		static Utf16StringOTE * NewFromBSTR(BSTR bs)
		{
			return New(bs, ::SysStringLen(bs));
		}
	};

	class Utf32String : public ArrayedCollection	// Actually a string subclass
	{
	public:
		typedef char32_t CU;

		CU m_characters[];
	};
}

std::wostream& operator<<(std::wostream& st, const AnsiStringOTE*);
std::wostream& operator<<(std::wostream& st, const SymbolOTE*);
#define ENCODINGPAIR(e1, e2) (static_cast<int>(e1) <<2 | static_cast<int>(e2))

