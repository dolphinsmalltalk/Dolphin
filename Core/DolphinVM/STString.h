/******************************************************************************

	File: STString.h

	Description:

	VM representation of Smalltalk String class.

	N.B. The representation of this class must NOT be changed.

******************************************************************************/
#pragma once

#include "STCollection.h"
#include <oleauto.h>

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
class Utf16StringOTE;
class Utf8StringOTE;
class Interpreter;

class AnsiStringOTE : public TOTE<ST::AnsiString>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size); }
	__forceinline size_t sizeForRead() const { return m_size & SizeMask; }
	__declspec(property(get = sizeForRead)) size_t Count;

	bool OrdinalEquals(const AnsiStringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf8StringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf16StringOTE* __restrict oteComperand) const;

	bool operator<=(const AnsiStringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf8StringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf16StringOTE* __restrict oteComperand) const;
};

class Utf8StringOTE : public TOTE<ST::Utf8String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size); }
	__forceinline size_t sizeForRead() const { return m_size & SizeMask; }
	__declspec(property(get = sizeForRead)) size_t Count;

	bool OrdinalEquals(const AnsiStringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf16StringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf8StringOTE* __restrict oteComperand) const;
	
	bool operator<=(const AnsiStringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf8StringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf16StringOTE* __restrict oteComperand) const;

};

class Utf16StringOTE : public TOTE<ST::Utf16String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size) / static_cast<ptrdiff_t>(sizeof(char16_t)); }
	__forceinline size_t sizeForRead() const { return (m_size & SizeMask) / sizeof(char16_t); }
	__declspec(property(get = sizeForRead)) size_t Count;

	bool OrdinalEquals(const AnsiStringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf8StringOTE* __restrict oteComperand) const;
	bool OrdinalEquals(const Utf16StringOTE* __restrict oteComperand) const;
	
	bool operator<=(const AnsiStringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf8StringOTE* __restrict oteComperand) const;
	bool operator<=(const Utf16StringOTE* __restrict oteComperand) const;
	bool operator>=(const AnsiStringOTE* __restrict oteComperand) const;
};

class Utf32StringOTE : public TOTE<ST::Utf32String>
{
public:
	__forceinline ptrdiff_t sizeForUpdate() const { return static_cast<ptrdiff_t>(m_size) / static_cast<ptrdiff_t>(sizeof(char32_t)); }
	__forceinline size_t sizeForRead() const { return (m_size & SizeMask) / sizeof(char32_t); }
	__declspec(property(get = sizeForRead)) size_t Count;
};

typedef UINT codepage_t;

namespace ST
{
	class String : public ArrayedCollection
	{
	public:
	};

	template <codepage_t ACP, size_t I, typename OTE_t, class TChar> class ByteStringT : public ArrayedCollection
	{
	public:
		typedef TChar CU;
		typedef const TChar * __restrict PCSZ;
		static const size_t PointersIndex = I;
		static const codepage_t CP = ACP;

		CU m_characters[1];		// Variable length array of data

		typedef OTE_t MyOTE;
		typedef ByteStringT<CP, PointersIndex, MyOTE, TChar> MyType;
		typedef MyOTE* POTE;

		static constexpr codepage_t CodePage()
		{
			return ACP == CP_ACP ? Interpreter::m_ansiCodePage : ACP;
		}

		static POTE __fastcall New(size_t cch)
		{
			MyOTE* stringPointer = ObjectMemory::template newUninitializedNullTermObject<MyType>(cch);
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		static POTE __fastcall New(PCSZ __restrict value, size_t cch)
		{
			MyOTE* stringPointer = ObjectMemory::template newUninitializedNullTermObject<MyType>(cch);
			MyType* __restrict string = stringPointer->m_location;
			string->m_characters[cch] = '\0';
			memcpy(string->m_characters, value, cch);
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}

		static POTE __fastcall New(PCSZ __restrict sz)
		{
			size_t cch = strlen((LPCSTR)sz);
			MyOTE* stringPointer = ObjectMemory::template newUninitializedNullTermObject<MyType>(cch);
			MyType* __restrict string = stringPointer->m_location;
			// Copy the string and null terminator
			memcpy(string->m_characters, sz, cch + sizeof(CU));
			ASSERT(stringPointer->isNullTerminated());
			return stringPointer;
		}
	};

	// Indexes into the VM's pointer array
	const size_t ClassByteString = 84;
	const size_t ClassUtf8String = 104;
	const size_t ClassUtf16String = 93;

	class AnsiString;

	class Utf8String : public ByteStringT<CP_UTF8, ClassUtf8String, Utf8StringOTE, char8_t>
	{
	public:
		static Utf8StringOTE* __fastcall NewFromAnsi(const char* __restrict psz, size_t cch);
		static Utf8StringOTE* __fastcall NewFromString(OTE* oteNonUtf8String);
		static Utf8StringOTE* __fastcall NewFromUtf16(const char16_t* __restrict pwch, size_t cwch);

		static POTE __fastcall NewFromUtf16(LPCWSTR pwsz)
		{
			return NewFromUtf16(reinterpret_cast<const char16_t*>(pwsz), wcslen(pwsz));
		}

		static POTE __fastcall NewFromBSTR(BSTR bs)
		{
			return bs == nullptr ? MyType::New(u8"", 0) : NewFromUtf16(reinterpret_cast<LPCWSTR>(bs));
		}
	};

	class AnsiString : public ByteStringT<CP_ACP, ClassByteString, AnsiStringOTE, char>
	{
	public:
		static AnsiStringOTE* __fastcall NewFromUtf8(const char8_t* __restrict pChars, size_t len);
		static AnsiStringOTE* __fastcall NewFromString(OTE* oteNonAnsiString);
		static AnsiStringOTE* __fastcall NewFromUtf16(const char16_t* __restrict pwch, size_t cwch);

		static AnsiStringOTE* __fastcall NewFromUtf16(LPCWSTR pwsz)
		{
			return NewFromUtf16(reinterpret_cast<const char16_t*>(pwsz), wcslen(pwsz));
		}
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
		typedef Utf16StringOTE MyOTE;

		CU m_characters[];

		static Utf16StringOTE* __fastcall New(LPCWSTR pwsz);
		static Utf16StringOTE* __fastcall New(const WCHAR* pwsz, size_t cwch);
#ifdef NLSConversions
		template <codepage_t CP, class T> static Utf16StringOTE* __fastcall New(const T* pChars, size_t len);
#endif
		static Utf16StringOTE* __fastcall New(const char* __restrict psz, size_t cch);
		static Utf16StringOTE* __fastcall New(const char8_t* __restrict psz8, size_t cch8);
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

struct CmpOrdinalW
{
	__forceinline int operator() (const char16_t* psz1, size_t cch1, const char16_t* psz2, size_t cch2) const
	{
		return ::CompareStringOrdinal((LPCWCH)psz1, cch1, (LPCWCH)psz2, cch2, FALSE) - 2;
	}
};
