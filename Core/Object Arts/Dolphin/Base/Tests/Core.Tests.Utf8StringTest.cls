"Filed out from Dolphin Smalltalk"!

Core.Tests.UtfEncodedStringTest
	subclass: #'Core.Tests.Utf8StringTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.Utf8StringTest guid: (Core.GUID fromString: '{cc364a8d-e3ae-493e-8856-3f10c847c10d}')!
Core.Tests.Utf8StringTest comment: ''!
!Core.Tests.Utf8StringTest methodsFor!

assertAsUtf16String: aUtf8String equals: aUtf16String
	self assert: aUtf8String asUtf16String equals: aUtf16String.
	"We expect the conversion to be equivalent to ICU's u_strFromUTF8WithSub, on which it is based"
	self assert: aUtf8String asUtf16String asByteArray
		equals: (OS.ICU u_strFromUTF8WithSub: aUtf8String) asByteArray!

assertInvalidSequence: aUtf8String length: anInteger
	| expectedUtf16 actualUtf16 |
	expectedUtf16 := Utf16String new: anInteger withAll: Character.Replacement.
	actualUtf16 := aUtf8String asUtf16String.
	self assert: actualUtf16 equals: expectedUtf16.
	self assert: (aUtf8String copyWith: $A) asUtf16String equals: (expectedUtf16 copyWith: $A).
	"We expect the conversion to be equivalent to ICU's u_strFromUTF8WithSub, on which it is based"
	self assert: actualUtf16 asByteArray equals: (OS.ICU u_strFromUTF8WithSub: aUtf8String) asByteArray.
	"Also test streams consistently"
	self assert: aUtf8String asArray equals: (Array new: anInteger withAll: Character.Replacement)!

assimilateString: aString
	^aString asUtf8String!

collectionClass
	^Utf8String!

decodeIncompleteContinuations
	^#(#[16rC0] #[16rE0] #[16rE0 16r80] #[16rF0 16r80 16r80])!

decodeInvalidCharacters
	"Includes UTF-16 surrogates"

	^#(#[16rED 16rA0 16r80] 3 #[16rED 16rA3 16rBF] 3 #[16rED 16rBF 16rBF] 3 #[16rF4 16r90 16r80 16r80] 4 #[16rF5 16r80 16r80 16r80] 4)!

decodeInvalidContinuations
	^#(#(#[16rC0 16r00] 1 $\0) #(#[16rC2 16r41] 1 $A) #(#[16rC2 16rC0 16r00] 2 $\0) #(#[16rDF 16r00] 1 $\0) #(#[16rE0 16r80 16r41] 2 $A) #(#[16rE0 16rC0 16r41] 2 $A) #(#[16rE0 16rA0 16rC0 16r41] 2 $A) #(#[16rF0 16r80 16r80 16r41] 3 $A))!

decodeTestCases
	^#(#[16r0] $\0 #[16r7F] $\x7F #[16rC2 16r80] $\x80 #[16rC2 16r8F] $\x8F #[16rC2 16rBF] $\xBF #[16rDF 16r8F] $\x7CF #[16rDF 16rBE] $\x7FE #[16rDF 16rBF] $\x7FF #[16rE0 16rA0 16r80] $\x800 #[16rE1 16r80 16r80] $\x1000 #[16rEE 16r80 16r80] $\xE000 #[16rEF 16rBF 16rBD] $\xFFFD #[16rF0 16r90 16r80 16r80] $\x10000 #[16rF0 16r9F 16r90 16rAC] $🐬 #[16rF0 16r9F 16rBF 16rBD] $\x1FFFD #[16rF1 16r80 16r80 16r80] $\x40000 #[16rF4 16r8F 16rBF 16rBD] $\x10FFFD)!

makeStringFromCodeUnits: aByteArray
	^Utf8String fromByteArray: aByteArray!

testAssociations
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject associations
		equals: {1 -> $a. 2 -> $£. 4 -> $\x6587. 7 -> $\x1F42C. 11 -> $1. 12 -> $\x1F37A}!

testAsUtf16StringMarkusKuhnBoundaryCases
	"Note that these include 5 and 6-byte cases that are valid Utf-8 encodings but not valid Unicode. ICU follows the more recent Unicode best practice guidance to treat these as completely invalid sequences, which means that rather than translating a 5-byte sequence to one replacement character, it is translated to 5 replacement characters. I can't say I agree with this, but it is consistent with other decoders, e.g. in Edge or Chrome, and ultimately doesn't matter much in practice because valid UTF-8 encoded Unicoded text will never contain 5/6 byte UTF-8 encodings. In Markus Kuhn's test file his primary expectation was that a single replacement character would be used for most invalid sequences and so the file is constructed to make it visually apparent when this is not the case. However he does note that 'as an alternative to the notion of malformed sequence used here, it is also a perfectly acceptable (and in some situations even preferable) solution to represent each individual byte of a malformed sequence with a replacement character.' The alternative handling of malformed sequences is what ICU does and so what we see here. This may not be consistent with Dolphin 7 (which used NLS APIs), but should be consistent with what you would see in a chromium browser."

	"1. Some correct UTF-8 text: Greek word 'kosme'"

	self assertAsUtf16String: 'κόσμε' equals: 'κόσμε'.

	"2.  Boundary condition test cases"

	"2.1  First possible sequence of a certain length"

	"2.1.1  1 byte  (U-00000000): "
	self assertAsUtf16String: (Utf8String with: $\0) equals: (Utf16String fromByteArray: #[0 0]).
	"2.1.2  2 bytes (U-00000080):"
	self assertAsUtf16String: (Utf8String with: $\x80) equals: (Utf16String fromByteArray: #[128 0]).
	"2.1.3  3 bytes (U-00000800):"
	self assertAsUtf16String: (Utf8String with: $ࠀ) equals: (Utf16String fromByteArray: #[0 8]).

	"2.1.4  4 bytes (U-00010000): "
	self assertAsUtf16String: (Utf8String with: $𐀀)
		equals: (Utf16String fromByteArray: #[16r00 16rD8 16r00 16rDC]).

	"2.1.5  5 bytes (U-00200000): "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF8 16r88 16r80 16r80 16r80]) length: 5.

	"2.1.6  6 bytes (U-04000000):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFC 16r84 16r80 16r80 16r80 16r80])
		length: 6.

	"2.2  Last possible sequence of a certain length"

	"2.2.1  1 byte  (U-0000007F): "
	self assertAsUtf16String: (Utf8String with: $\x7F) equals: (Utf16String fromByteArray: #[127 0]).

	"2.2.2  2 bytes (U-000007FF): "
	self assertAsUtf16String: (Utf8String with: $߿) equals: (Utf16String fromByteArray: #[255 7]).

	"2.2.3  3 bytes (U-0000FFFF):"
	"16rFFFF is non-char, but is a valid code point so we don't translate it to the replacement character"
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rEF 16rBF 16rBF])
		equals: (Utf16String fromByteArray: #[255 255]).

	"2.2.4  4 bytes (U-001FFFFF): "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF7 16rBF 16rBF 16rBF]) length: 4.

	"2.2.5  5 bytes (U-03FFFFFF): "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFB 16rBF 16rBF 16rBF 16rBF]) length: 5.

	"2.2.6  6 bytes (U-7FFFFFFF): "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFD 16rBF 16rBF 16rBF 16rBF 16rBF])
		length: 6.

	"2.3  Other boundary conditions"

	"2.3.1  U-0000D7FF"
	self assertAsUtf16String: (Utf8String with: $\xD7FF) equals: (Utf16String with: $\xD7FF).

	"2.3.2  U-0000E000"
	self assertAsUtf16String: (Utf8String with: $\xE000) equals: (Utf16String with: $\xE000).

	"2.3.3  U-0000FFFD"
	self assertAsUtf16String: (Utf8String with: $\xFFFD) equals: (Utf16String with: $\xFFFD).

	"2.3.4  U-0010FFFF"
	"16r10FFFF is non-char, but is a valid code point so we don't translate it to the replacement character"
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rF4 16r8F 16rBF 16rBF])
		equals: (Utf16String fromByteArray: #[16rFF 16rDB 16rFF 16rDF]).

	"2.3.5  U-00110000 = f4 90 80 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF4 16r90 16r80 16r80]) length: 4!

testAsUtf16StringMarkusKuhnIllegalCodePositions
	"5 Illegal code positions

	The following UTF-8 sequences should be rejected like malformed sequences, because they never represent valid ISO 10646 characters and a UTF-8 decoder that accepts them might introduce security problems comparable to overlong UTF-8 sequences. "

	"5.1 Single UTF-16 surrogates"

	"5.1.1 U+D800 = ed a0 80"

	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rA0 16r80]) length: 3.
	"5.1.2  U+DB7F = ed ad bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAD 16rBF]) length: 3.
	"5.1.3  U+DB80 = ed ae 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAE 16r80]) length: 3.
	"5.1.4  U+DBFF = ed af bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAF 16rBF]) length: 3.
	"5.1.5  U+DC00 = ed b0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rB0 16r80]) length: 3.
	"5.1.6  U+DF80 = ed be 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rBE 16r80]) length: 3.
	"5.1.7  U+DFFF = ed bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rBF 16rBF]) length: 3.

	"5.2 Paired UTF-16 surrogates"

	"5.2.1  U+D800 U+DC00 = ed a0 80 ed b0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rA0 16r80 16rED 16rB0 16r80])
		length: 6.
	"5.2.2  U+D800 U+DFFF = ed a0 80 ed bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rA0 16r80 16rED 16rBF 16rBF])
		length: 6.
	"5.2.3  U+DB7F U+DC00 = ed ad bf ed b0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAF 16rBF 16rED 16rB0 16r80])
		length: 6.
	"5.2.4  U+DB7F U+DFFF = ed ad bf ed bf bf "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAD 16rBF 16rED 16rBF 16rBF])
		length: 6.
	"5.2.5  U+DB80 U+DC00 = ed ae 80 ed b0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAE 16r80 16rED 16rB0 16r80])
		length: 6.
	"5.2.6  U+DB80 U+DFFF = ed ae 80 ed bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAE 16r80 16rED 16rBF 16rBF])
		length: 6.
	"5.2.7  U+DBFF U+DC00 = ed af bf ed b0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAF 16rBF 16rED 16rB0 16r80])
		length: 6.
	"5.2.8  U+DBFF U+DFFF = ed af bf ed bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rED 16rAF 16rBF 16rED 16rBF 16rBF])
		length: 6!

testAsUtf16StringMarkusKuhnImpossibleBytes
	"Note that these include 5 and 6-byte cases that are valid Utf-8 encodings, but not valid Unicode characters, so treated as unrecognised sequences by ICU"

	"3.5  Impossible bytes"

	"The following two bytes cannot appear in a correct UTF-8 string"

	"3.5.1  fe"
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rFE]) equals: (Utf16String with: $\xFFFD).
	"3.5.2  ff"
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rFF]) equals: (Utf16String with: $\xFFFD).
	"3.5.3  fe fe ff ff"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFE 16rFE 16rFF 16rFF]) length: 4!

testAsUtf16StringMarkusKuhnIncompleteContinuations
	"Note that these include 5 and 6-byte cases that are valid Utf-8 encodings, but not valid Unicode characters, so treated as unrecognised sequences by ICU"

	"3.3  Sequences with last continuation byte missing"

	"All bytes of an incomplete sequence should be signalled as a single malformed sequence, i.e., you should see only a single replacement character in each of the next 10 tests. (Characters as in section 2)"

	"3.3.1  2-byte sequence with last byte missing (U+0000): "

	self assertInvalidSequence: (Utf8String fromByteArray: #[16rC0]) length: 1.
	"3.3.2  3-byte sequence with last byte missing (U+0000):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rE0 16r80]) length: 2.
	"3.3.3  4-byte sequence with last byte missing (U+0000):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF0 16r80 16r80]) length: 3.
	"3.3.4  5-byte sequence with last byte missing (U+0000):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF8 16r80 16r80 16r80]) length: 4.
	"3.3.5  6-byte sequence with last byte missing (U+0000):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFC 16r80 16r80 16r80 16r80]) length: 5.
	"3.3.6  2-byte sequence with last byte missing (U-000007FF):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rDF]) length: 1.
	"3.3.7  3-byte sequence with last byte missing (U-0000FFFF): [Note: Start of a valid sequence, so only one replacement char]"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rEF 16rBF]) length: 1.
	"3.3.8  4-byte sequence with last byte missing (U-001FFFFF): [Note: Not the start of a valid sequence (U+001FFFFF is out of range), so multiple replacement chars"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF7 16rBF 16rBF]) length: 3.
	"3.3.9  5-byte sequence with last byte missing (U-03FFFFFF):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFB 16rBF 16rBF 16rBF]) length: 4.
	"3.3.10 6-byte sequence with last byte missing (U-7FFFFFFF):"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFD 16rBF 16rBF 16rBF 16rBF]) length: 5.

	"3.4  Concatenation of incomplete sequences"

	"All the 10 sequences of 3.3 concatenated, you should see 10 malformed sequences being signalled:"
	self assertInvalidSequence: (Utf8String
				fromByteArray: #[16rC0 16rE0 16r80 16rF0 16r80 16r80 16rF8 16r80 16r80 16r80 16rFC 16r80 16r80 16r80 16r80 16rDF 16rEF 16rBF 16rF7 16rBF 16rBF 16rFB 16rBF 16rBF 16rBF 16rFD 16rBF 16rBF 16rBF 16rBF])
		length: 29!

testAsUtf16StringMarkusKuhnLonelyStarts
	"Note that these include 5 and 6-byte cases that are valid Utf-8 encodings, but not valid Unicode characters, so treated as unrecognised sequences by ICU"

	"3.2  Lonely start characters"

	"3.2.1  All 32 first bytes of 2-byte sequences (0xc0-0xdf), each followed by a space character:"

	self assertAsUtf16String: (Utf8String
				fromByteArray: (ByteArray streamContents: 
							[:strm |
							16rC0 to: 16rDF
								do: 
									[:ch |
									strm
										nextPut: ch;
										nextPut: 32]]))
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							32 timesRepeat: 
									[strm
										nextPut: $\xFFFD;
										nextPut: $\x20]])).
	"3.2.2  All 16 first bytes of 3-byte sequences (0xe0-0xef), each followed by a space character:"
	self assertAsUtf16String: (Utf8String
				fromByteArray: (ByteArray streamContents: 
							[:strm |
							16rE0 to: 16rEF
								do: 
									[:ch |
									strm
										nextPut: ch;
										nextPut: 32]]))
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							16 timesRepeat: 
									[strm
										nextPut: $\xFFFD;
										nextPut: $\x20]])).
	"3.2.3  All 8 first bytes of 4-byte sequences (0xf0-0xf7), each followed by a space character: "
	self assertAsUtf16String: (Utf8String
				fromByteArray: (ByteArray streamContents: 
							[:strm |
							16rF0 to: 16rF7
								do: 
									[:ch |
									strm
										nextPut: ch;
										nextPut: 32]]))
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							8 timesRepeat: 
									[strm
										nextPut: $\xFFFD;
										nextPut: $\x20]])).
	"3.2.4  All 4 first bytes of 5-byte sequences (0xf8-0xfb), each followed by a space character: "
	self assertAsUtf16String: (Utf8String
				fromByteArray: (ByteArray streamContents: 
							[:strm |
							16rF8 to: 16rFB
								do: 
									[:ch |
									strm
										nextPut: ch;
										nextPut: 32]]))
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							4 timesRepeat: 
									[strm
										nextPut: $\xFFFD;
										nextPut: $\x20]])).
	"3.2.5  All 2 first bytes of 6-byte sequences (0xfc-0xfd),  each followed by a space character: "
	self assertAsUtf16String: (Utf8String
				fromByteArray: (ByteArray streamContents: 
							[:strm |
							16rFC to: 16rFD
								do: 
									[:ch |
									strm
										nextPut: ch;
										nextPut: 32]]))
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							2 timesRepeat: 
									[strm
										nextPut: $\xFFFD;
										nextPut: $\x20]]))!

testAsUtf16StringMarkusKuhnNonCharacters
	"5.3 Noncharacter code positions"

	"The following 'noncharacters' are 'reserved for internal use. by applications, and according to older versions of the Unicode Standard 'should never be interchanged'. Unicode Corrigendum #9 dropped the latter restriction. Nevertheless, their presence in incoming UTF-8 data can remain a potential security risk, depending on what use is made of these codes subsequently. Examples of such internal use:

	- Some file APIs with 16-bit characters may use the integer value -1 = U+FFFF to signal an end-of-file (EOF) or error condition.
	- In some UTF-16 receivers, code point U+FFFE might trigger a byte-swap operation (to convert between UTF-16LE and UTF-16BE).

	With such internal use of noncharacters, it may be desirable and safer to block those code points in UTF-8 decoders, as they should never occur legitimately in incoming UTF-8 data, and could trigger unsafe behaviour in subsequent processing."

	"[Dolphin Note: Avoiding codepoints that might be confused with -1 in a signed integer representation is not particularly relevant in Smalltalk because we have reiified Characters and can't confuse these with integer values. We also expect to operate exclusively with UTF-16LE. We don't translate non-character codepoints to the replacement character when converting from UTF-8 to UTF-16 because the encodings are correct and so the conversion is valid. However attempting to access or stream over the whole characters will return replacement characters.]"

	"Particularly problematic noncharacters in 16-bit applications:"

	"5.3.1  U+FFFE = ef bf be"
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rEF 16rBF 16rBE])
		equals: (Utf16String with: $\xFFFE).
	"5.3.2  U+FFFF = ef bf bf "
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rEF 16rBF 16rBF])
		equals: (Utf16String with: $\xFFFF).

	"Other noncharacters: [we don't replace these]"

	"5.3.3  U+FDD0 .. U+FDEF"
	self assertAsUtf16String: (Utf8String
				fromByteArray: #[16rEF 16rB7 16r90 16rEF 16rB7 16r91 16rEF 16rB7 16r92 16rEF 16rB7 16r93 16rEF 16rB7 16r94 16rEF 16rB7 16r95 16rEF 16rB7 16r96 16rEF 16rB7 16r97 16rEF 16rB7 16r98 16rEF 16rB7 16r99 16rEF 16rB7 16r9A 16rEF 16rB7 16r9B 16rEF 16rB7 16r9C 16rEF 16rB7 16r9D 16rEF 16rB7 16r9E 16rEF 16rB7 16r9F 16rEF 16rB7 16rA0 16rEF 16rB7 16rA1 16rEF 16rB7 16rA2 16rEF 16rB7 16rA3 16rEF 16rB7 16rA4 16rEF 16rB7 16rA5 16rEF 16rB7 16rA6 16rEF 16rB7 16rA7 16rEF 16rB7 16rA8 16rEF 16rB7 16rA9 16rEF 16rB7 16rAA 16rEF 16rB7 16rAB 16rEF 16rB7 16rAC 16rEF 16rB7 16rAD 16rEF 16rB7 16rAE 16rEF 16rB7 16rAF])
		equals: (Utf16String withAll: ($\xFDD0 to: $\xFDEF)).

	"5.3.4  U+nFFFE U+nFFFF (for n = 1..10)"
	self assertAsUtf16String: (Utf8String
				fromByteArray: #[16rF0 16r9F 16rBF 16rBE 16rF0 16r9F 16rBF 16rBF 16rF0 16rAF 16rBF 16rBE 16rF0 16rAF 16rBF 16rBF 16rF0 16rBF 16rBF 16rBE 16rF0 16rBF 16rBF 16rBF 16rF1 16r8F 16rBF 16rBE 16rF1 16r8F 16rBF 16rBF 16rF1 16r9F 16rBF 16rBE 16rF1 16r9F 16rBF 16rBF 16rF1 16rAF 16rBF 16rBE 16rF1 16rAF 16rBF 16rBF 16rF1 16rBF 16rBF 16rBE 16rF1 16rBF 16rBF 16rBF 16rF2 16r8F 16rBF 16rBE 16rF2 16r8F 16rBF 16rBF 16rF2 16r9F 16rBF 16rBE 16rF2 16r9F 16rBF 16rBF 16rF2 16rAF 16rBF 16rBE 16rF2 16rAF 16rBF 16rBF 16rF2 16rBF 16rBF 16rBE 16rF2 16rBF 16rBF 16rBF 16rF3 16r8F 16rBF 16rBE 16rF3 16r8F 16rBF 16rBF 16rF3 16r9F 16rBF 16rBE 16rF3 16r9F 16rBF 16rBF 16rF3 16rAF 16rBF 16rBE 16rF3 16rAF 16rBF 16rBF 16rF3 16rBF 16rBF 16rBE 16rF3 16rBF 16rBF 16rBF 16rF4 16r8F 16rBF 16rBE 16rF4 16r8F 16rBF 16rBF])
		equals: (Utf16String
				withAll: (Array streamContents: 
							[:strm |
							1 to: 16
								do: 
									[:each |
									strm
										nextPut: (Character basicCodePoint: (each << 16) + 16rFFFE);
										nextPut: (Character basicCodePoint: (each << 16) + 16rFFFF)]]))!

testAsUtf16StringMarkusKuhnOverlongSequences
	"4  Overlong sequences 
	The following sequences are not malformed according to the letter of the Unicode 2.0 standard. However, they are longer then necessary and a correct UTF-8 encoder is not allowed to produce them. A safe UTF-8 decoder  should reject them just like malformed sequences for two reasons: 
		(1) It helps to debug applications if overlong sequences are not treated as valid representations of characters, because this helps to spot problems more quickly. 
		(2) Overlong sequences provide alternative representations of characters, that could maliciously be used to bypass filters that check only for ASCII characters. For instance, a 2-byte encoded line feed (LF) would not be caught by a line counter that counts only 0x0a bytes, but it would still be processed as a line feed by an unsafe UTF-8 decoder later in the pipeline. 
	From a security point of view, ASCII compatibility of UTF-8 sequences means also, that ASCII characters are *only* allowed to be represented by ASCII bytes in the range 0x00-0x7f. To ensure this  aspect of ASCII compatibility, use only safe UTF-8 decoders that reject overlong UTF-8 sequences for which a shorter encoding exists."

	"4.1  Examples of an overlong ASCII character 

	With a safe UTF-8 decoder, all of the following five overlong representations of the ASCII character slash ('/') should be rejected like a malformed UTF-8 sequence, for instance by substituting it with a replacement character. If you see a slash below, you do not have a safe UTF-8 decoder!!"

	"4.1.1 U+002F = c0 af "

	self assertInvalidSequence: (Utf8String fromByteArray: #[16rC0 16rAF]) length: 2.
	"4.1.2 U+002F = e0 80 af"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rE0 16r80 16rAF]) length: 3.
	"4.1.3 U+002F = f0 80 80 af"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF0 16r80 16r80 16rAF]) length: 4.
	"4.1.4 U+002F = f8 80 80 80 af"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF8 16r80 16r80 16r80 16rAF]) length: 5.
	"4.1.5 U+002F = fc 80 80 80 80 af"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFC 16r80 16r80 16r80 16r80 16rAF])
		length: 6.

	"4.2  Maximum overlong sequences"

	"Below you see the highest Unicode value that is still resulting in an overlong sequence if represented with the given number of bytes. This is a boundary test for safe UTF-8 decoders. All five characters should be rejected like malformed UTF-8 sequences."

	"4.2.1  U-0000007F = c1 bf "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rC1 16rBF]) length: 2.
	"4.2.2  U-000007FF = e0 9f bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rE0 16r9F 16rBF]) length: 3.
	"4.2.3  U-0000FFFF = f0 8f bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF0 16r8F 16rBF 16rBF]) length: 4.
	"4.2.4  U-001FFFFF = f8 87 bf bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF8 16r87 16rBF 16rBF 16rBF]) length: 5.
	"4.2.5  U-03FFFFFF = fc 83 bf bf bf bf"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFC 16r83 16rBF 16rBF 16rBF 16rBF])
		length: 6.

	"4.3  Overlong representation of the NUL character"

	"The following five sequences should also be rejected like malformed UTF-8 sequences and should not be treated like the ASCII NUL character."

	"4.3.1  U+0000 = c0 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rC0 16r80]) length: 2.
	"4.3.2  U+0000 = e0 80 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rE0 16r80 16r80]) length: 3.
	"4.3.3  U+0000 = f0 80 80 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF0 16r80 16r80 16r80]) length: 4.
	"4.3.4  U+0000 = f8 80 80 80 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rF8 16r80 16r80 16r80 16r80]) length: 5.
	"4.3.5  U+0000 = fc 80 80 80 80 80"
	self assertInvalidSequence: (Utf8String fromByteArray: #[16rFC 16r80 16r80 16r80 16r80 16r80])
		length: 6!

testAsUtf16StringMarkusKuhnUnexpectedContinuations
	"Note that these include 5 and 6-byte cases that are valid Utf-8 encodings, but not valid Unicode characters, so treated as unrecognised sequences by ICU"

	"3.1  Unexpected continuation bytes"

	"Each unexpected continuation byte should be separately signalled as a malformed sequence of its own."

	"3.1.1  First continuation byte 0x80: "

	self assertAsUtf16String: (Utf8String fromByteArray: #[16r80]) equals: (Utf16String with: $\xFFFD).
	"3.1.2  Last continuation byte 0xbf: "
	self assertAsUtf16String: (Utf8String fromByteArray: #[16rBF]) equals: (Utf16String with: $\xFFFD).
	"3.1.3  2 continuation bytes: "
	self assertAsUtf16String: (Utf8String fromByteArray: #[16r80 16rBF])
		equals: (Utf16String with: $\xFFFD with: $\xFFFD).
	"3.1.4  3 continuation bytes: "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16r80 16rBF 16r80]) length: 3.
	"3.1.5  4 continuation bytes: "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16r80 16rBF 16r80 16rBF]) length: 4.
	"3.1.6  5 continuation bytes: "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16r80 16rBF 16r80 16rBF 16r80]) length: 5.
	"3.1.7  6 continuation bytes: "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16r80 16rBF 16r80 16rBF 16r80 16rBF])
		length: 6.
	"3.1.8  7 continuation bytes: "
	self assertInvalidSequence: (Utf8String fromByteArray: #[16r80 16rBF 16r80 16rBF 16r80 16rBF 16r80])
		length: 7.
	"3.1.9  Sequence of all 64 possible continuation bytes (0x80-0xbf):"
	self assertInvalidSequence: (Utf8String fromByteArray: (16r80 to: 16rBF) asByteArray) length: 64!

testAsUtf16StringMarkusKuhnUtf8Complete
	"Tests decoding of the entire Markus Kuhn test file. Also broken down into test cases covering individual sub-sections by converting the isolated test sequences."

	| testFilePath bytes utf16 utf8 |
	testFilePath := FileLocator imageRelative
				localFileSpecFor: 'Core\Object Arts\Dolphin\Tests\UTF8-test.txt'.
	bytes := File readAllBytes: testFilePath.
	utf8 := Utf8String fromByteArray: bytes.
	utf16 := Utf16String fromBytes: bytes codePage: OS.NlsConstants.CP_UTF8.
	self assertAsUtf16String: utf8 equals: utf16!

testConcatenateInvalidUtf16
	"Result is UTF-8, so prefix not converted and assumed to be well-formed UTF-8. Suffix converted from UTF-16, so any invalid chars are replaced"

	| actual |
	actual := (Utf8String fromByteArray: #[194])
				, (Utf16String fromByteArray: #[98 0 163 0 172 32 0 220 61 216]).
	self assert: actual isKindOf: Utf8String.
	self assert: actual
		equals: (Utf8String fromByteArray: #[194 98 194 163 226 130 172 239 191 189 239 191 189])!

testConcatenateInvalidUtf8
	"Invalid prefix and suffix preserved as is since assumed to be well-formed UTF-8"

	| actual |
	actual := (Utf8String fromByteArray: #[194])
				, (Utf8String fromByteArray: #[98 194 226 130 172 144 128 128 240 159 172]).
	self assert: actual isKindOf: Utf8String.
	self assert: actual
		equals: (Utf8String fromByteArray: #[194 98 194 226 130 172 144 128 128 240 159 172])!

testCopyWith
	| subject actual |
	subject := self assimilateString: 'a£文1🍺'.
	self assert: subject length equals: 5.
	actual := subject copyWith: Character dolphin.
	self assert: actual equals: 'a£文1🍺🐬'.
	self assert: actual length equals: 6!

testCopyWithAtIndex
	| subject actual |
	subject := self assimilateString: 'a£文1🍺'.
	actual := subject copyWith: Character dolphin atIndex: 4.
	self assert: actual equals: 'a£🐬文1🍺'.
	self assert: actual length equals: subject length + 1.
	self should: [subject copyWith: Character dolphin atIndex: 5] raise: Error!

testDecodeNextFrom5and6Byte
	| subject bytes |
	subject := self collectionClass empty.
	"5 and 6 byte encodings - not actually valid Unicode characters, but valid UTF-8 encodings"
	bytes := (#[16rF8 16r88 16r80 16r80 16r80] , Character dolphin asString asByteArray
				, #[16rFB 16rBF 16rBF 16rBF 16rBF] , $£ asUtf8String asByteArray
				, #[16rFC 16r84 16r80 16r80 16r80] , $€ asUtf8String asByteArray
				, #[16rFD 16rBF 16rBF 16rBF 16rBF 16rBF] , $你 asUtf8String asByteArray)
				readStream.
	"Revised handling of 5&6 byte sequences is to treat them as wholly invalid sequences and convert each byte to the replacement char. This is per the Unicode standard best practice guidance, and as implemented in ICU."
	5 timesRepeat: [self assert: (subject decodeNextFrom: bytes) equals: Character replacement].
	self assert: (subject decodeNextFrom: bytes) equals: Character dolphin.
	5 timesRepeat: [self assert: (subject decodeNextFrom: bytes) equals: Character replacement].
	self assert: (subject decodeNextFrom: bytes) equals: $£.
	5 timesRepeat: [self assert: (subject decodeNextFrom: bytes) equals: Character replacement].
	self assert: (subject decodeNextFrom: bytes) equals: $€.
	6 timesRepeat: [self assert: (subject decodeNextFrom: bytes) equals: Character replacement].
	self assert: (subject decodeNextFrom: bytes) equals: $你.
	self assert: bytes atEnd!

testDecodeNextFromOverlong
	"Overlong character encodings"

	| subject stream bytes i byteStream |
	bytes := #[16rC0 16r80 95 16rC0 16rAF 95 16rC0 16rBF 95 16rC1 16r80 95 16rC1 16rBF 95 16rE0 16r80 16r80 95 16rE0 16r80 16rBF 95 16rE0 16r9F 16rBF 95 16rE0 16r80 16rAF 95 16rE0 16r81 16r80 95 16rE0 16r8F 16r80 95 16rE0 16r8F 16rBF 95 16rE0 16r90 16r80 95 16rE0 16r90 16rBF 95 16rE0 16r9F 16r80 95 16rE0 16r9F 16rBF 95 16rE0 16r80 16r80 16r80 95 16rF0 16r80 16r80 16r80 95 16rF0 16r80 16r80 16rAF 95 16rF0 16r8F 16rBF 16rBF 95 16rF0 16r8F 16rBF 16rBF 16r80 95 16rF8 16r80 16r80 16r80 16r80 95 16rF8 16r80 16r80 16r80 16rAF 95 16rF8 16r87 16rBF 16rBF 16rBF 95 16rFC 16r80 16r80 16r80 16r80 16r80 95 16rFC 16r80 16r80 16r80 16r80 16rAF 95 16rFC 16r83 16rBF 16rBF 16rBF 16rBF 95].
	subject := self collectionClass fromByteArray: bytes.
	self assert: subject length equals: bytes size.
	byteStream := bytes readStream.
	stream := subject readStream.
	i := 1.
	[i > bytes size] whileFalse: 
			[| end |
			end := bytes
						nextIndexOf: 16r5F
						from: i
						to: bytes size.
			i to: end - 1
				do: 
					[:j |
					| n |
					n := subject encodedSizeAt: j.
					self assert: (subject decodeNextFrom: byteStream) equals: Character replacement.
					self assert: byteStream position equals: j + n - 1.
					self assert: (subject decodeAt: j) equals: Character replacement].
			self assert: byteStream position equals: end - 1.
			self assert: (subject decodeNextFrom: byteStream) equals: $_.
			self assert: byteStream position equals: end.
			self assert: (subject encodedSizeAt: end) equals: 1.
			self assert: (subject decodeAt: end) equals: $_.
			end - i timesRepeat: [self assert: stream next equals: Character replacement].
			self assert: stream next equals: $_.
			self assert: stream position equals: end.
			i := end + 1].
	self assert: byteStream atEnd.
	self assert: stream atEnd!

testEncodedSizeOf
	| subject |
	subject := self collectionClass empty.
	#($\0 1 $\x7F 1 $\x80 2 $\x7FF 2 $\x800 3 $\xFFFF 3 $\x10000 4 $\x10FFFF 4)
		pairsDo: [:ch :bytes | self assert: (subject encodedSizeOf: ch) equals: bytes].
	self
		should: [subject encodedSizeOf: (Character newCode: Character.Utf32Mask | 16r110000)]
		raise: Error
		matching: [:ex | ex messageText = 'Invalid code point U+110000']!

testFromByteArray
	"Examples are from RFC3629"

	| theKoreanLanguage theJapaneseLanguage stumpOfTreeWithBom |
	theKoreanLanguage := Utf8String
				fromByteArray: #[16rED 16r95 16r9C 16rEA 16rB5 16rAD 16rEC 16r96 16rB4].
	self assert: theKoreanLanguage length equals: 3.
	self assert: (theKoreanLanguage asArray collect: [:each | each codePoint])
		equals: #(16rD55C 16rAD6D 16rC5B4).
	self assert: theKoreanLanguage equals: '한국어'.
	theJapaneseLanguage := Utf8String
				fromByteArray: #[16rE6 16r97 16rA5 16rE6 16r9C 16rAC 16rE8 16rAA 16r9E].
	self assert: theJapaneseLanguage length equals: 3.
	self assert: (theJapaneseLanguage asArray collect: [:each | each codePoint])
		equals: #(16r65E5 16r672C 16r8A9E).
	self assert: theJapaneseLanguage equals: '日本語'.
	stumpOfTreeWithBom := Utf8String fromByteArray: #[16rEF 16rBB 16rBF 16rF0 16rA3 16r8E 16rB4].
	self assert: stumpOfTreeWithBom length equals: 2.
	self assert: (stumpOfTreeWithBom asArray collect: [:each | each codePoint])
		equals: #(16rFEFF 16r233B4)!

testKeys
	| subject |
	subject := self assimilateString: 'a£文🐬1🍺'.
	self assert: subject length equals: 6.
	self assert: subject keys equals: #(1 2 4 7 11 12)!

testLastCodeUnit
	| subject last |
	super testLastCodeUnit.
	subject := self assimilateString: '🐬a£文🍺'.
	self assert: (subject basicAt: subject size) equals: 16rBA.
	last := subject lastCodeUnit.
	self assert: last isUtf8Trail.
	self assert: last equals: (Character utf8Value: 16rBA)!

testUnicodeBestPracticeDecodingExamplesIllFormedSurrogates
	| utf8 stream |
	"Table 3-9. U+FFFD for Ill-Formed Sequences for Surrogates"
	utf8 := Utf8String fromByteArray: #[16rED 16rA0 16r80 16rED 16rBF 16rBF 16rED 16rAF 16r41].
	self assert: utf8 length equals: 9.
	stream := utf8 readStream.
	8 timesRepeat: [self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD].
	self assert: (utf8 decodeNextFrom: stream) equals: $A.
	self assert: stream atEnd.
	stream reset.
	8 timesRepeat: [self assert: stream next equals: $\xFFFD].
	self assert: stream next equals: $A.
	self assert: stream atEnd.
	self assert: utf8 associations
		equals: (((1 to: 8) collect: [:i | i -> Character replacement]) copyWith: 9 -> $A).
	"Conversion to UTF-16 should follow the same decoding algorithm"
	self assert: utf8 asUtf16String asByteArray
		equals: #[16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16r41 16r0]!

testUnicodeBestPracticeDecodingExamplesOtherIllFormed
	| utf8 stream |
	"Table 3-10. U+FFFD for Other Ill-Formed Sequences"
	utf8 := Utf8String fromByteArray: #[16rF4 16r91 16r92 16r93 16rFF 16r41 16r80 16rBF 16r42].
	self assert: utf8 length equals: 9.
	stream := utf8 readStream.
	5 timesRepeat: [self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD].
	self assert: (utf8 decodeNextFrom: stream) equals: $A.
	2 timesRepeat: [self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD].
	self assert: (utf8 decodeNextFrom: stream) equals: $B.
	self assert: stream atEnd.
	stream reset.
	5 timesRepeat: [self assert: stream next equals: $\xFFFD].
	self assert: stream next equals: $A.
	2 timesRepeat: [self assert: stream next equals: $\xFFFD].
	self assert: stream next equals: $B.
	self assert: stream atEnd.
	self assert: utf8 associations
		equals: {
				1 -> $\xFFFD.
				2 -> $\xFFFD.
				3 -> $\xFFFD.
				4 -> $\xFFFD.
				5 -> $\xFFFD.
				6 -> $A.
				7 -> $\xFFFD.
				8 -> $\xFFFD.
				9 -> $B
			}.

	"Conversion to UTF-16 should follow the same decoding algorithm"
	self assert: utf8 asUtf16String asByteArray
		equals: #[16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16r41 16r0 16rFD 16rFF 16rFD 16rFF 16r42 16r0]!

testUnicodeBestPracticeDecodingExamplesOverlong
	| utf8 stream |
	"Table 3-8: Non-Shortest Form Sequences"
	utf8 := Utf8String fromByteArray: #[16rC0 16rAF 16rE0 16r80 16rBF 16rF0 16r81 16r82 16r41].
	self assert: utf8 length equals: 9.
	stream := utf8 readStream.
	8 timesRepeat: [self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD].
	self assert: (utf8 decodeNextFrom: stream) equals: $A.
	self assert: stream atEnd.
	stream reset.
	8 timesRepeat: [self assert: stream next equals: $\xFFFD].
	self assert: stream next equals: $A.
	self assert: stream atEnd.
	"Conversion to UTF-16 should follow the same decoding algorithm"
	self assert: utf8 asUtf16String asByteArray
		equals: #[16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16r41 16r0].

	"Other (non-stream) decoding"
	self assert: utf8 associations
		equals: (((1 to: 8) collect: [:i | i -> Character replacement]) copyWith: 9 -> $A).
	#(#[16rC0 16rAF] #[16rE0 16r80 16rBF] #[16rF0 16r81 16r82 16rBF]) do: 
			[:each |
			utf8 := Utf8String fromByteArray: each.
			self assert: utf8 length equals: utf8 size.
			self assert: utf8 first equals: Character replacement.
			self
				should: [utf8 single]
				raise: Error
				matching: [:ex | ex messageText = 'String is not of a single Character'].
			1 to: each size
				do: 
					[:i |
					self assert: (utf8 encodedSizeAt: i) equals: 1.
					self assert: (utf8 codePointAt: i) equals: Character replacement].
			self assert: utf8 keys equals: (1 to: each size)]!

testUnicodeBestPracticeDecodingExamplesTruncated
	| utf8 stream |
	"Table 3-11. U+FFFD for Truncated Sequences"
	utf8 := Utf8String fromByteArray: #[16rE1 16r80 16rE2 16rF0 16r91 16r92 16rF1 16rBF 16r41].
	self assert: utf8 length equals: 5.
	stream := utf8 readStream.
	self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
	self assert: stream basicNext equals: 16rE2.
	stream pop.
	self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
	self assert: stream basicNext equals: 16rF0.
	stream pop.
	self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
	self assert: stream basicNext equals: 16rF1.
	stream pop.
	self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
	self assert: (utf8 decodeNextFrom: stream) equals: $A.
	self assert: stream atEnd.
	stream reset.
	4 timesRepeat: [self assert: stream next equals: $\xFFFD].
	self assert: stream next equals: $A.
	self assert: stream atEnd.
	"Conversion to UTF-16 should follow the same decoding algorithm"
	self assert: utf8 asUtf16String asByteArray
		equals: #[16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16rFD 16rFF 16r41 16r0].
	"Enumerations should use the same decoding as streams and also enumerate multiple replacement characters for invalid sequences"
	self assert: utf8 associations
		equals: { 1 -> $\xFFFD. 3 -> $\xFFFD. 4 -> $\xFFFD. 7 -> $\xFFFD. 9 -> $A }.
	self assert: utf8 keys equals: #(1 3 4 7 9).
	self assert: (utf8 codePointAt: 1) equals: Character replacement.
	self assert: (utf8 codePointAt: 2) equals: Character replacement.
	self assert: (utf8 codePointAt: 3) equals: Character replacement.
	self assert: (utf8 codePointAt: 4) equals: Character replacement.
	self assert: (utf8 codePointAt: 5) equals: $A.

	"Check them some truncation variations individually"
	#(#[16rE0 16rA0] #[16rE1 16r80] #[16rE1 16rBF] #[16rEC 16r80] #[16rEC 16rBF] #[16rED 16r80] #[16rED 16r9F] #[16rEE 16r80] #[16rEE 16rBF] #[16rEF 16r80] #[16rEF 16rBF] #[16rE0] #[16rE1] #[16rEC] #[16rED] #[16rEE] #[16rEF] #[16rF0] #[16rF1] #[16rF2] #[16rF3] #[16rF4] #[16rF0 16r90] #[16rF0 16rBF] #[16rF0 16r90 16r80] #[16rF0 16rBF 16rBF] #[16rF1 16r80] #[16rF1 16rBF] #[16rF1 16r80 16r80] #[16rF1 16rBF 16rBF] #[16rF3 16r80] #[16rF3 16rBF] #[16rF3 16r80 16r80] #[16rF3 16rBF 16rBF] #[16rF4 16r80] #[16rF4 16r8F] #[16rF4 16r80 16r80] #[16rF4 16r8F 16rBF])
		do: 
			[:each |
			utf8 := Utf8String fromByteArray: each.
			self assert: utf8 length equals: 1.
			stream := utf8 readStream.
			self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
			self assert: stream atEnd.
			stream reset.
			self assert: stream next equals: $\xFFFD.
			self assert: stream atEnd.
			"Non-stream"
			self assert: (utf8 decodeAt: 1) equals: $\xFFFD.
			self assert: (utf8 encodedSizeAt: 1) equals: each size.
			self assert: utf8 single equals: $\xFFFD.

			"Truncated mid-stream"
			utf8 := Utf8String fromByteArray: (each copyWith: 16r41).
			self assert: utf8 length equals: 2.
			stream := utf8 readStream.
			self assert: (utf8 decodeNextFrom: stream) equals: $\xFFFD.
			self assert: (utf8 decodeNextFrom: stream) equals: $A.
			self assert: stream atEnd.
			stream reset.
			self assert: stream next equals: $\xFFFD.
			self assert: stream next equals: $A.
			self assert: stream atEnd.
			self assert: utf8 associations equals: { 1 -> $\xFFFD. each size + 1 -> $A }.

			"Conversion to UTF-16 should follow the same decoding algorithm"
			self assert: utf8 asUtf16String asByteArray equals: #[16rFD 16rFF 16r41 16r0]]!

testUnicodeBestPracticeDecodingExamplesWellFormed
	| utf8 stream |
	"Table 3-7. Well formed - note these include some non-characters that are replaced with a single replacement char"
	#(#[0] $\0 #[16r7F] $\x7F #[16rC2 16r80] $\x80 #[16rDF 16rBF] $\x7FF #[16rE0 16rA0 16r80] $\x800 #[16rE0 16rBF 16rBF] $\xFFF #[16rE1 16r80 16r80] $\x1000 #[16rEC 16rBF 16rBF] $\xCFFF #[16rED 16r80 16r80] $\xD000 #[16rED 16r9F 16rBF] $\xD7FF #[16rEE 16r80 16r80] $\xE000 #[16rEF 16rBF 16rBF] $\xFFFD #[16rF0 16r90 16r80 16r80] $\x10000 #[16rF0 16rBF 16rBF 16rBF] $\xFFFD #[16rF1 16r80 16r80 16r80] $\x40000 #[16rF3 16rBF 16rBF 16rBF] $\xFFFD #[16rF4 16r80 16r80 16r80] $\x100000 #[16rF4 16r8F 16rBF 16rBF] $\xFFFD)
		pairsDo: 
			[:each :char |
			utf8 := Utf8String fromByteArray: each.
			self assert: utf8 length equals: 1.
			stream := utf8 readStream.
			self assert: (utf8 decodeNextFrom: stream) equals: char.
			self assert: stream atEnd.
			stream reset.
			self assert: stream next equals: char.
			self assert: stream atEnd.
			"Non-stream"
			self assert: (utf8 decodeAt: 1) equals: char.
			self assert: (utf8 encodedSizeAt: 1) equals: utf8 size.
			self assert: utf8 single equals: char.
			"Conversion to UTF-16 should follow the same decoding algorithm, although non-chars will be converted as these are valid encodings. These will be replaced with U+FFFDs when streamed out of the Utf16String though."
			self assert: utf8 asUtf16String single equals: char]! !
!Core.Tests.Utf8StringTest categoriesForMethods!
assertAsUtf16String:equals:!helpers!private! !
assertInvalidSequence:length:!helpers!private! !
assimilateString:!helpers!private! !
collectionClass!helpers!private! !
decodeIncompleteContinuations!constants!private! !
decodeInvalidCharacters!constants!private! !
decodeInvalidContinuations!constants!private! !
decodeTestCases!constants!private! !
makeStringFromCodeUnits:!helpers!private! !
testAssociations!public!unit tests! !
testAsUtf16StringMarkusKuhnBoundaryCases!public!unit tests! !
testAsUtf16StringMarkusKuhnIllegalCodePositions!public!unit tests! !
testAsUtf16StringMarkusKuhnImpossibleBytes!public!unit tests! !
testAsUtf16StringMarkusKuhnIncompleteContinuations!public!unit tests! !
testAsUtf16StringMarkusKuhnLonelyStarts!public!unit tests! !
testAsUtf16StringMarkusKuhnNonCharacters!public!unit tests! !
testAsUtf16StringMarkusKuhnOverlongSequences!public!unit tests! !
testAsUtf16StringMarkusKuhnUnexpectedContinuations!public!unit tests! !
testAsUtf16StringMarkusKuhnUtf8Complete!public!unit tests! !
testConcatenateInvalidUtf16!public!unit tests! !
testConcatenateInvalidUtf8!public!unit tests! !
testCopyWith!public!unit tests! !
testCopyWithAtIndex!public!unit tests! !
testDecodeNextFrom5and6Byte!public!unit tests! !
testDecodeNextFromOverlong!public!unit tests! !
testEncodedSizeOf!public!unit tests! !
testFromByteArray!public!unit tests! !
testKeys!public!unit tests! !
testLastCodeUnit!public!unit tests! !
testUnicodeBestPracticeDecodingExamplesIllFormedSurrogates!public! !
testUnicodeBestPracticeDecodingExamplesOtherIllFormed!public! !
testUnicodeBestPracticeDecodingExamplesOverlong!public! !
testUnicodeBestPracticeDecodingExamplesTruncated!public! !
testUnicodeBestPracticeDecodingExamplesWellFormed!public! !
!

