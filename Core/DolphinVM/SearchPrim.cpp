/******************************************************************************

	File: SearchPrim.cpp

	Description:

	Implementation of the Interpreter class' primitive methods for searching
	objects

******************************************************************************/
#include "Ist.h"
#pragma code_seg(PRIM_SEG)

#include "ObjMem.h"
#include "Interprt.h"
#include "InterprtPrim.inl"

// Smalltalk classes
#include "STBehavior.h"

#include "Utf16StringBuf.h"
#include "Utf8StringBuf.h"

// Uses object identity to locate the next occurrence of the argument in the receiver from
// the specified index to the specified index
Oop* PRIMCALL Interpreter::primitiveNextIndexOfFromTo(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter3);				// to not an integer
	const SmallInteger to = ObjectMemoryIntegerValueOf(integerPointer);

	integerPointer = *(sp - 1);
	if (!ObjectMemoryIsIntegerObject(integerPointer))
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);				// from not an integer
	SmallInteger from = ObjectMemoryIntegerValueOf(integerPointer);

	Oop valuePointer = *(sp - 2);
	OTE* receiverPointer = reinterpret_cast<OTE*>(*(sp - 3));

	#ifdef _DEBUG
		if (ObjectMemoryIsIntegerObject(receiverPointer))
			return primitiveFailure(_PrimitiveFailureCode::AssertionFailure);				// Not valid for SmallIntegers
	#endif

	Oop answer = ZeroPointer;
	if (to >= from)
	{
		if (!receiverPointer->isPointers())
		{
			// Search a byte object
			BytesOTE* oteBytes = reinterpret_cast<BytesOTE*>(receiverPointer);

			if (ObjectMemoryIsIntegerObject(valuePointer))// Arg MUST be an Integer to be a member
			{
				const SmallUinteger byteValue = ObjectMemoryIntegerValueOf(valuePointer);
				if (byteValue < 256)	// Only worth looking for 0..255
				{
					const SmallInteger length = oteBytes->bytesSize();
					// We can only be in here if to>=from, so if to>=1, then => from >= 1
					// furthermore if to <= length then => from <= length
					if (from < 1 || to > length)
						return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);

					// Search is in bounds, lets do it
			
					VariantByteObject* bytes = oteBytes->m_location;

					from--;
					while (from < to)
						if (bytes->m_fields[from++] == byteValue)
						{
							answer = ObjectMemoryIntegerObjectOf(from);
							break;
						}
				}
			}
		}
		else
		{
			// Search a pointer object - but only the indexable vars
			
			PointersOTE* oteReceiver = reinterpret_cast<PointersOTE*>(receiverPointer);
			VariantObject* receiver = oteReceiver->m_location;
			Behavior* behavior = receiverPointer->m_oteClass->m_location;
			const auto length = oteReceiver->pointersSize();
			const auto fixedFields = behavior->fixedFields();

			// Similar reasoning with to/from as for byte objects, but here we need to
			// take account of the fixed fields.
			if (from < 1 || (static_cast<size_t>(to) + fixedFields > length))
				return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// Out of bounds

			Oop* indexedFields = receiver->m_fields + fixedFields;
			from--;
			while (from < to)
				if (indexedFields[from++] == valuePointer)
				{
					answer = ObjectMemoryIntegerObjectOf(from);
					break;
				}
		}

	}
	else
		answer = ZeroPointer; 		// Range is non-inclusive, cannot be there

	*(sp - 3) = answer;
	return sp - 3;
}

// Initialize the Boyer-Moorer skip array
template <typename T> void __stdcall bmInitSkip(const T* p, const int M, int* skip)
{
	for (auto j=0;j<256;j++)
		skip[j] = M;
	for (auto j=0;j < M;j++)
		skip[p[j]] = M-j-1;
}


// Returns -1 for not found, or zero based index if found
template <typename T> int __stdcall bmSearch(const T* string, const int N, const T* p, const int M, /*const int* skip, */const int startAt)
{
	int skip[256];
	bmInitSkip(p,M,skip);

	const int n = N - startAt;
	const T* a = string + startAt;

	int i, j;
	for (i=j=M-1; j >= 0; j--,i--)
	{
		T c;
		while ((c = a[i]) != p[j])
		{
			const int t = skip[c];
			i += (M-j > t) ? M-j : t;
			if (i >= n) 
				return -1;
			j = M-1;
			_ASSERTE(i >= 0);
			_ASSERTE(j >= 0);
		}
	}
	return i+1+startAt;
}

template <typename T> int __stdcall bruteSearch(const T* a, const int N, const T* p, const int M, const int startAt)
{
	int i, j;
	for (i=startAt,j=0; j < M && i < N;i++,j++)
	{
		if (a[i] != p[j])
		{
			i -= j;
			j = -1;
		}
	}
	return j == M ? i - M : -1;
}

// N.B. startAt is now zero based
template<typename T> int __stdcall stringSearch(const T* a, const int N, const T* p, const int M, const int startAt)
{
	// In order for it to be worth initiating the skip array, we have to have enough characters to search
	return N >= 512
		? bmSearch(a, N, p, M, /*NULL, */startAt)
		: bruteSearch(a, N, p, M, startAt);
}

Oop* PRIMCALL Interpreter::primitiveStringSearch(Oop* const sp, primargcount_t)
{
	Oop integerPointer = *sp;
	if (ObjectMemoryIsIntegerObject(integerPointer))
	{
		const SmallInteger startingAt = ObjectMemoryIntegerValueOf(integerPointer);

		Oop oopSubString = *(sp - 1);
		OTE* oteReceiver = reinterpret_cast<OTE*>(*(sp - 2));

		if (!ObjectMemoryIsIntegerObject(oopSubString))
		{
			const OTE* oteArg = reinterpret_cast<const OTE*>(oopSubString);
			if (oteArg->isNullTerminated())
			{
				if (startingAt > 0)
				{
					switch (ENCODINGPAIR(oteReceiver->m_oteClass->m_location->m_instanceSpec.m_encoding, oteArg->m_oteClass->m_location->m_instanceSpec.m_encoding))
					{
					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Ansi):
					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf8):
					{
						auto oteString = reinterpret_cast<Utf8StringOTE*>(oteReceiver);
						auto oteSubString = reinterpret_cast<Utf8StringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							const size_t N = oteString->Count;
							if ((startingAt + M) - 1 <= N)
							{
								SmallInteger index = stringSearch(oteString->m_location->m_characters, N, oteSubString->m_location->m_characters, M, startingAt - 1) + 1;
								*(sp - 2) = ObjectMemoryIntegerObjectOf(index);
								return sp - 2;
							}
						}
						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf8):
					{
						return primitiveFailure(_PrimitiveFailureCode::DataTypeMismatch);
					}

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Ansi):	// Ansi sequence can match same Ansi sequence in UTF-8
					{
						auto oteString = reinterpret_cast<Utf8StringOTE*>(oteReceiver);
						auto oteSubString = reinterpret_cast<AnsiStringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							Utf8StringBuf buf(oteSubString->m_location->m_characters, M);
							const size_t N = oteString->Count;
							if ((startingAt + buf.Count) - 1 <= N)
							{
								SmallInteger index = stringSearch(oteString->m_location->m_characters, N, (const char8_t*)buf, buf.Count, startingAt - 1) + 1;
								*(sp - 2) = ObjectMemoryIntegerObjectOf(index);
								return sp - 2;
							}
						}
						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Ansi):
					{
						auto oteString = reinterpret_cast<Utf16StringOTE*>(oteReceiver);
						auto oteSubString = reinterpret_cast<Utf8StringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							Utf16StringBuf buf(oteSubString->m_location->m_characters, M);
							const size_t N = oteString->Count;
							if ((startingAt + buf.Count) - 1 <= N)
							{
								auto wsz = oteString->m_location->m_characters;
								UChar* found = u_strFindFirst(wsz + startingAt, N - startingAt + 1, buf, buf.Count);
								if (found != nullptr)
								{
									SmallInteger nOffset = (found - wsz) + startingAt;
									*(sp - 2) = ObjectMemoryIntegerObjectOf(nOffset);
									return sp - 2;
								}
							}
						}

						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf16):
					{
						return primitiveFailure(_PrimitiveFailureCode::DataTypeMismatch);
					}

					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf16):
					{
						auto oteString = reinterpret_cast<Utf8StringOTE*>(oteReceiver);
						auto oteSubString = reinterpret_cast<Utf16StringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							Utf8StringBuf buf(oteSubString->m_location->m_characters, M);
							const size_t N = oteString->Count;
							if ((startingAt + buf.Count) - 1 <= N)
							{
								SmallInteger index = stringSearch(oteString->m_location->m_characters, N, (const char8_t*)buf, buf.Count, startingAt - 1) + 1;
								*(sp - 2) = ObjectMemoryIntegerObjectOf(index);
								return sp - 2;
							}
						}
						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf8):
					{
						Utf16StringOTE* oteString = reinterpret_cast<Utf16StringOTE*>(oteReceiver);
						Utf8StringOTE* oteSubString = reinterpret_cast<Utf8StringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							Utf16StringBuf buf(oteSubString->m_location->m_characters, M);
							const size_t N = oteString->Count;
							if ((startingAt + buf.Count) - 1 <= N)
							{
								auto wsz = oteString->m_location->m_characters;
								UChar* found = u_strFindFirst(wsz + startingAt - 1, N - startingAt + 1, buf, buf.Count);
								if (found != nullptr)
								{
									SmallInteger nOffset = (found - wsz) + 1;
									*(sp - 2) = ObjectMemoryIntegerObjectOf(nOffset);
									return sp - 2;
								}
							}
						}

						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf16):
					{
						auto oteString = reinterpret_cast<Utf16StringOTE*>(oteReceiver);
						auto oteSubString = reinterpret_cast<Utf16StringOTE*>(oopSubString);

						const size_t M = oteSubString->Count;
						if (M != 0)
						{
							const size_t N = oteString->Count;
							if ((startingAt + M) - 1 <= N)
							{
								auto wsz = oteString->m_location->m_characters;
								UChar* found = u_strFindFirst(wsz + startingAt - 1, N - startingAt + 1, oteSubString->m_location->m_characters, M);
								if (found != nullptr)
								{
									SmallInteger nOffset = (found - wsz) + 1;
									*(sp - 2) = ObjectMemoryIntegerObjectOf(nOffset);
									return sp - 2;
								}
							}
						}

						*(sp - 2) = ZeroPointer;
						return sp - 2;
					}

					// Utf32 isn't supported currently
					case ENCODINGPAIR(StringEncoding::Ansi, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf8, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf16, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf32):
					case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Ansi):
					case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf8):
					case ENCODINGPAIR(StringEncoding::Utf32, StringEncoding::Utf16):
						return Interpreter::primitiveFailure(_PrimitiveFailureCode::NotImplemented);
					default:
						__assume(false);
					}
				}
				else
				{
					return primitiveFailure(_PrimitiveFailureCode::OutOfBounds);	// out of bounds - startingAt <= 0
				}
			}
		}

		// target not a String
		return Interpreter::primitiveFailure(_PrimitiveFailureCode::InvalidParameter1);
	}
	else
	{
		return primitiveFailure(_PrimitiveFailureCode::InvalidParameter2);				// startingAt not an integer
	}
}
