"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.CharacterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.CharacterTest guid: (Core.GUID fromString: '{b5b1b518-3a55-4441-9aa3-32c87f1aedba}')!
Core.Tests.CharacterTest comment: ''!
!Core.Tests.CharacterTest categoriesForClass!Tests-Magnitude-General! !
!Core.Tests.CharacterTest methodsFor!

nonCharacters
	"Private - Unicode non-characters - see https://www.unicode.org/faq/private_use.html"

	| nonchars |
	nonchars := 16rFDD0 to: 16rFDEF.
	0 to: 16r10
		do: 
			[:each |
			| start |
			start := (each << 16) + 16rFFFE.
			nonchars := nonchars , (start to: start + 1)].
	^nonchars!

testAnsiValue
	1 to: 256
		do: [:each | self assert: (Character byteCharacterSet at: each) ansiValue equals: each - 1].
	self should: [Character dolphin ansiValue] raise: Error!

testAsciiValue
	1 to: 128
		do: [:each | self assert: (Character byteCharacterSet at: each) asciiValue equals: each - 1].
	self should: [(Character ansiValue: 128) asciiValue] raise: Error.
	self should: [(Character value: 16r20AC) asciiValue] raise: Error.
	self should: [$£ asciiValue] raise: Error.
	self should: [Character dolphin asciiValue] raise: Error!

testAsLowercase
	self assert: $a asLowercase identicalTo: $a.
	self assert: $A asLowercase identicalTo: $a.
	self assert: $\0 asLowercase identicalTo: $\0.
	"Euro symbol - still a unique ANSI encoded char"
	self assert: (Character ansiValue: 128) asLowercase identicalTo: (Character ansiValue: 128).
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) asLowercase equals: (Character codePoint: 16rE7).
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0400) asLowercase equals: (Character codePoint: 16r450).
	"Greek delta"
	self assert: (Character codePoint: 16r394) asLowercase equals: (Character codePoint: 16r3B4).
	"Thai 7 - not a letter"
	self assert: (Character codePoint: 16rE57) asLowercase equals: (Character codePoint: 16rE57).
	"Symbol outside BMP"
	self assert: Character dolphin asLowercase equals: Character dolphin!

testAsUppercase
	"Ascii chars have unique instances in the ANSI set"

	self assert: $A asUppercase identicalTo: $A.
	self assert: $a asUppercase identicalTo: $A.
	self assert: $\0 asUppercase identicalTo: $\0.
	"Euro symbol - still a unique ANSI encoded char"
	self assert: (Character ansiValue: 128) asUppercase identicalTo: (Character ansiValue: 128).
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rE7) asUppercase equals: (Character codePoint: 16rC7).
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0450) asUppercase equals: (Character codePoint: 16r400).
	"Greek delta"
	self assert: (Character codePoint: 16r3B4) asUppercase equals: (Character codePoint: 16r394).
	"Thai 7 - not a letter"
	self assert: (Character codePoint: 16rE57) asUppercase equals: (Character codePoint: 16rE57).
	"Symbol outside BMP"
	self assert: Character dolphin asUppercase equals: Character dolphin!

testAsUtf16String
	#(#($A #[65 0]) #($\x7F #[16r7F 0]) #($\x20AC #[16rAC 16r20]) #($\x7FF #[16rFF 16r07]) #($\x800 #[16r00 16r08]) #($\x10000 #[16r00 16rD8 16r00 16rDC]) #($\x1F42C #[16r3D 16rD8 16r2C 16rDC]))
		do: 
			[:each |
			| actual subject expected |
			subject := each first.
			expected := each last.
			actual := subject asUtf16String asByteArray.
			self assert: actual equals: expected]!

testAsUtf8String
	#(#($A #[65]) #($\x7F #[16r7F]) #($\xA3 #[16rC2 16rA3]) #($\x7FF #[16rDF 16rBF]) #($\x800 #[16rE0 16rA0 16r80]) #($\x10000 #[16rF0 16r90 16r80 16r80]) #($\x1F42C #[16rF0 16r9F 16r90 16rAC]))
		do: 
			[:each |
			| actual subject expected |
			subject := each first.
			expected := each last.
			actual := subject asUtf8String asByteArray.
			self assert: actual equals: expected]!

testClassCodePoint
	| ch |
	ch := Character codePoint: 0.
	self assert: ch identicalTo: $\0.
	ch := Character codePoint: 127.
	self assert: ch identicalTo: $\x7F.
	ch := Character codePoint: 128.
	self assert: ch encoding equals: #utf32.
	"Euro symbol"
	ch := Character codePoint: 16r20AC.
	self assert: ch codePoint equals: 16r20AC.
	self assert: ch encoding equals: #ansi.
	self assert: ch identicalTo: ((AnsiString fromByteArray: #[128]) at: 1).
	ch := Character codePoint: 16r1F42C.
	self assert: ch codePoint equals: 16r1F42C.
	self assert: ch encoding equals: #utf32.
	"The replacement character"
	ch := Character codePoint: 16rFFFD.
	self assert: ch codePoint equals: 16rFFFD.
	self assert: ch encoding equals: #utf32.
	"Utf-16 surrogates, not code points"
	#(16rD800 16rDB7F 16rDB80 16rDBFF 16rDC00 16rDCFF 16rDF80 16rDFFF)
		do: [:i | self should: [Character codePoint: (i << 16) + 16rFFFE] raise: Error].
	"Valid code points but not valid characters"
	16rFDD0 to: 16rFDEF do: [:i | self should: [Character codePoint: (i << 16) + 16rFFFE] raise: Error].
	(0 to: 16) do: 
			[:i |
			self should: [Character codePoint: (i << 16) + 16rFFFE] raise: Error.
			self should: [Character codePoint: (i << 16) + 16rFFFF] raise: Error]!

testClassNewCode
	| ch ch2 originalMethod testMethod |
	ch := Character newCode: Character dolphin code.
	self assert: ch equals: $\x1F42C.
	originalMethod := Character class compiledMethodAt: #newCode:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	ch2 := testMethod value: Character withArguments: {ch code}.
	self assert: ch2 equals: ch!

testCodePoint
	| euro utf8 utf16 |
	euro := (AnsiString fromByteArray: #[128]) at: 1.
	self assert: euro codePoint equals: 16r20AC.
	self assert: Character dolphin codePoint equals: 16r1F42C.
	"Surrogates  - not real code points"
	utf8 := Utf8String with: Character dolphin.
	#[16rF0 16r9F 16r90 16rAC] keysAndValuesDo: 
			[:i :each |
			| ch |
			ch := utf8 at: i.
			self assert: ch isSurrogate.
			self assert: ch codePoint equals: each].
	utf16 := utf8 asUtf16String.
	#(16rD83D 16rDC2C) keysAndValuesDo: 
			[:i :each |
			| ch |
			ch := utf16 at: i.
			self assert: ch isSurrogate.
			self assert: ch codePoint equals: each]!

testDigitValue
	self assert: Character null digitValue equals: -1!

testEquals
	self assert: $a equals: (Character codePoint: 97).
	self deny: $a equals: $A.
	self assert: $\0 equals: (Character codePoint: 0).
	self assert: (Character codePoint: 255) equals: (Character codePoint: 255).
	self should: [Character codePoint: 16rFFFF] raise: Error.
	self deny: (Character codePoint: 16rFFFC) equals: (Character codePoint: 16rFFFD).
	self deny: (Character codePoint: 16r200E) equals: 16r200E.
	self deny: (Character utf8Value: 240) equals: (Character codePoint: 240).
	self deny: (Character utf8Value: 16r80) equals: (Character codePoint: 16r80)!

testIdentity
	self assert: $a identicalTo: (Character codePoint: 97).
	self assert: (Character codePoint: 255) identicalTo: (Character codePoint: 255).
	self deny: (Character codePoint: 256) identicalTo: (Character codePoint: 256)!

testIsAlphaNumeric
	self assert: $a isAlphaNumeric.
	self assert: $A isAlphaNumeric.
	self assert: $0 isAlphaNumeric.
	"Punctuation"
	self deny: $" isAlphaNumeric.
	"Control char"
	self deny: $\0 isAlphaNumeric.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) isAlphaNumeric.
	self assert: (Character codePoint: 16rE7) isAlphaNumeric.
	" Cyrillic ie with grave, 16-bit"
	self assert: (Character codePoint: 16r400) isAlphaNumeric.
	self assert: (Character codePoint: 16r450) isAlphaNumeric.
	"Arabic indic digit zero"
	self assert: (Character codePoint: 16r660) isAlphaNumeric.
	"Arabic percent sign"
	self deny: (Character codePoint: 16r066A) isAlphaNumeric.
	"Thai digit for 7"
	self assert: (Character codePoint: 16rE57) isAlphaNumeric!

testIsControl
	"Tests Character>>isControl"

	"C0 and C1 control codes"

	(0 to: 31) , (127 to: 15) do: [:i | self assert: (Character codePoint: i) isControl].
	"All other ASCII chars are not control codes"
	32 to: 126 do: [:i | self deny: (Character codePoint: i) isControl].
	"Left to right mark"
	self assert: (Character codePoint: 16r200E) isControl.
	"Turkish, but ANSI"
	self deny: (Character codePoint: 16rC7) isControl.
	"Cyrillic letter ie with grave"
	self deny: (Character codePoint: 16r0400) isControl.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isControl!

testIsDigit
	#($0 $1 $2 $3 $4 $5 $6 $7 $8 $9) do: [:each | self assert: each isDigit].
	self deny: $a isDigit.
	self deny: Character null isDigit.
	self deny: (Character codePoint: 16r1F37B) isDigit!

testIsHexDigit
	| dolphin |
	#($0 $1 $2 $3 $4 $5 $6 $7 $8 $9 $A $B $C $D $E $F) do: [:each | self assert: each isHexDigit].
	self deny: $a isHexDigit.
	self deny: $G isHexDigit.
	self deny: Character null isHexDigit.
	dolphin := Character dolphin.
	self deny: dolphin isHexDigit.
	"Test surrogates"
	dolphin := dolphin asUtf8String.
	1 to: 4 do: [:each | self deny: (dolphin at: each) isHexDigit].
	dolphin := dolphin asUtf16String.
	1 to: 2 do: [:each | self deny: (dolphin at: each) isHexDigit]!

testIsLowercase
	self assert: $a isLowerCase.
	self deny: $A isLowerCase.
	self deny: $0 isLowerCase.
	self deny: $\0 isLowerCase.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self deny: (Character codePoint: 16rC7) isLowercase.
	self assert: (Character codePoint: 16rE7) isLowerCase.
	"Cyrillic, 16-bit"
	self deny: (Character codePoint: 16r0400) isLowercase.
	self assert: (Character codePoint: 16r450) isLowerCase.
	"Greek delta"
	self assert: (Character codePoint: 16r3B4) isLowercase.
	self deny: (Character codePoint: 16r394) isLowercase.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isLowercase.
	"Outside BMP"
	self deny: Character dolphin isLowercase!

testIsPunctuation
	self deny: $a isPunctuation.
	self deny: $0 isPunctuation.
	self assert: $. isPunctuation.
	"Solidus"
	self assert: $/ isPunctuation.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Greek"
	self deny: (Character codePoint: 16r3B4) isPunctuation.
	self assert: (Character codePoint: 16r37E) isPunctuation.
	"Arabic indic digit zero"
	self deny: (Character codePoint: 16r660) isPunctuation.
	"Arabic percent sign"
	self assert: (Character codePoint: 16r066A) isPunctuation!

testIsUppercase
	self deny: $a isUppercase.
	self assert: $A isUppercase.
	self deny: $0 isUppercase.
	self deny: $\0 isUppercase.
	"Left-to-right mark"
	self deny: (Character codePoint: 16r200E) isLowerCase.
	"Turkish, but 8-bit"
	self assert: (Character codePoint: 16rC7) isUppercase.
	self deny: (Character codePoint: 16rE7) isUppercase.
	"Cyrillic, 16-bit"
	self assert: (Character codePoint: 16r0400) isUppercase.
	self deny: (Character codePoint: 16r450) isUppercase.
	"Greek delta"
	self deny: (Character codePoint: 16r3B4) isUppercase.
	self assert: (Character codePoint: 16r394) isUppercase.
	"Thai 7"
	self deny: (Character codePoint: 16rE57) isUpperCase.
	"Outside BMP"
	self deny: Character dolphin isUppercase!

testIsUtf16SurrogateTests
	"Exhaustively tests:
	- `Character>>isUtf16Surrogate`
	- `Character>>isUtf16Lead`
	- `Character>>isUtf16Trail`
	- `Character class>>utf16Value:`
	- `Character class>>isValidUtf16CodeUnit:`
	Also tests `Character class>>isValidCodePoint:`
	"

	| str nonchars |
	str := Character dolphin asUtf16String.
	self assert: str size equals: 2.
	self assert: (str at: 1) isUtf16Surrogate.
	self assert: (str at: 2) isUtf16Surrogate.
	0 to: 16r7F
		do: 
			[:each |
			| ch |
			self assert: (Character isValidUtf16CodeUnit: each).
			self assert: (Character isValidCodePoint: each).
			ch := Character utf16Value: each.
			self assert: ch isUtf8.
			self deny: ch isSurrogate.
			self deny: ch isUtf16Surrogate.
			self deny: ch isUtf16Lead.
			self deny: ch isUtf16Trail].
	16r80 to: 16rD700
		do: 
			[:each |
			| ch |
			self assert: (Character isValidUtf16CodeUnit: each).
			self assert: (Character isValidCodePoint: each).
			ch := Character utf16Value: each.
			self deny: ch isUtf8.
			self deny: ch isSurrogate.
			self deny: ch isUtf16Surrogate.
			self deny: ch isUtf16Lead.
			self deny: ch isUtf16Trail].
	16rD800 to: 16rDBFF
		do: 
			[:each |
			| ch |
			self assert: (Character isValidUtf16CodeUnit: each).
			ch := Character utf16Value: each.
			self deny: ch isUtf8.
			self assert: ch isSurrogate.
			self assert: ch isUtf16Surrogate.
			self assert: ch isUtf16Lead.
			self deny: ch isUtf16Trail].
	16rDC00 to: 16rDFFF
		do: 
			[:each |
			| ch |
			self assert: (Character isValidUtf16CodeUnit: each).
			self deny: (Character isValidCodePoint: each).
			ch := Character utf16Value: each.
			self deny: ch isUtf8.
			self assert: ch isSurrogate.
			self assert: ch isUtf16Surrogate.
			self deny: ch isUtf16Lead.
			self assert: ch isUtf16Trail].
	nonchars := self nonCharacters.
	((16rE000 to: 16rFFFF) difference: nonchars) do: 
			[:each |
			| ch |
			self assert: (Character isValidUtf16CodeUnit: each).
			self assert: (Character isValidCodePoint: each).
			ch := Character utf16Value: each.
			self deny: ch isUtf8.
			self deny: ch isSurrogate.
			self deny: ch isUtf16Surrogate.
			self deny: ch isUtf16Lead.
			self deny: ch isUtf16Trail].
	nonchars , {-1. OS.Win32Constants.MAX_UCSCHAR + 1} do: 
			[:each |
			self deny: (Character isValidUtf16CodeUnit: each).
			self deny: (Character isValidCodePoint: each).
			self assertIsNil: (Character utf16Value: each ifInvalid: [])]!

testIsUtf8SurrogateTests
	"Exhaustively test Charcter>>isUtf8Surrogate, Character>>isUtf8Lead, Character>>isUtf8Trail."

	Character byteCharacterSet do: 
			[:each |
			self deny: each isSurrogate.
			self deny: each isUtf8Surrogate.
			self deny: each isUtf8Lead.
			self deny: each isUtf8Trail].
	#($£ $\x20AC $\x1F42C) do: 
			[:each |
			| str |
			self deny: each isUtf8.
			self deny: each isSurrogate.
			self deny: each isUtf8Surrogate.
			self deny: each isUtf8Lead.
			self deny: each isUtf8Trail.
			str := each asUtf8String.
			self assert: (str at: 1) isUtf8Surrogate.
			self assert: (str at: 1) isUtf8Lead.
			self deny: (str at: 1) isUtf8Trail.
			2 to: str size
				do: 
					[:i |
					| ch |
					ch := str at: i.
					self assert: ch isUtf8.
					self assert: ch isSurrogate.
					self assert: ch isUtf8Surrogate.
					self deny: ch isUtf8Lead.
					self assert: ch isUtf8Trail]].
	0 to: 127
		do: 
			[:i |
			| ch |
			ch := Character utf8Value: i.
			self assert: ch isUtf8.
			self deny: ch isSurrogate.
			self deny: ch isUtf8Surrogate.
			self deny: ch isUtf8Lead.
			self deny: ch isUtf8Trail].
	128 to: 191
		do: 
			[:i |
			| ch |
			ch := Character utf8Value: i.
			self assert: ch isUtf8.
			self assert: ch isSurrogate.
			self assert: ch isUtf8Surrogate.
			self deny: ch isUtf8Lead.
			self assert: ch isUtf8Trail].
	192 to: 255
		do: 
			[:i |
			| ch |
			ch := Character utf8Value: i.
			self assert: ch isUtf8.
			self assert: ch isSurrogate.
			self assert: ch isUtf8Surrogate.
			self assert: ch isUtf8Lead.
			self deny: ch isUtf8Trail]!

testPrintString
	self assert: $a printString equals: '$a'.
	self assert: $a printString equals: '$a'.
	(1 to: 6) , (14 to: 32)
		do: [:i | self assert: (Character codePoint: i) printString equals: '$\x' , (i printStringBase: 16)].
	(33 to: 126) do: [:i | self deny: ((Character codePoint: i) printString beginsWith: '$\x')].
	self assert: (Character codePoint: 0) printString equals: '$\0'.
	self assert: (Character codePoint: 7) printString equals: '$\a'.
	self assert: (Character codePoint: 8) printString equals: '$\b'.
	self assert: (Character codePoint: 9) printString equals: '$\t'.
	self assert: (Character codePoint: 10) printString equals: '$\n'.
	self assert: (Character codePoint: 11) printString equals: '$\v'.
	self assert: (Character codePoint: 12) printString equals: '$\f'.
	self assert: (Character codePoint: 13) printString equals: '$\r'.
	self assert: (Character codePoint: 127) printString equals: '$\x7F'.
	self assert: (Character codePoint: 16r394) printString equals: '$\x394'.
	"Left-to-right mark"
	self assert: (Character codePoint: 16r200E) printString equals: '$\x200E'!

testSize
	self assert: $a size equals: 0.
	self assert: Character dolphin size equals: 0!

testSplit
	"Test single character delimiter"

	| empty |
	empty := ''.
	self assert: ($- split: empty) equals: #().
	self assert: ($- split: '-') equals: {empty. empty}.
	self assert: ($- split: 'a') equals: #('a').
	self assert: ($- split: '-a') equals: #('' 'a').
	self assert: ($- split: 'a-') equals: #('a' '').
	self assert: ($- split: '--a') equals: #('' '' 'a').
	self assert: ($- split: 'a--') equals: #('a' '' '').
	self assert: ($- split: 'ab') equals: #('ab').
	self assert: ($- split: '-ab') equals: #('' 'ab').
	self assert: ($- split: 'ab-') equals: #('ab' '').
	self assert: ($- split: 'ab---') equals: #('ab' '' '' '').
	self assert: ($- split: '--ab') equals: #('' '' 'ab').
	self assert: ($- split: 'a-b') equals: #('a' 'b').
	self assert: ($- split: 'a--b') equals: #('a' '' 'b').
	self assert: ($- split: 'ab-c-') equals: #('ab' 'c' '').
	self assert: ($- split: 'a-b--c') equals: #('a' 'b' '' 'c').

	"Note that if the string consists only of separators, then we get N+1 empty strings if there are N chars"
	1 to: 3
		do: 
			[:i |
			| subject |
			subject := String new: i withAll: $a.
			self assert: ($a split: subject) equals: (Array new: i + 1 withAll: empty)]!

testStb
	| bytes rehydrated |
	bytes := Character dolphin binaryStoreBytes.
	rehydrated := Object fromBinaryStoreBytes: bytes.
	self assert: rehydrated equals: Character dolphin! !
!Core.Tests.CharacterTest categoriesFor: #nonCharacters!constants!private! !
!Core.Tests.CharacterTest categoriesFor: #testAnsiValue!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testAsciiValue!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testAsLowercase!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testAsUppercase!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testAsUtf16String!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testAsUtf8String!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testClassCodePoint!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testClassNewCode!public! !
!Core.Tests.CharacterTest categoriesFor: #testCodePoint!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testDigitValue!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testEquals!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIdentity!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsAlphaNumeric!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsControl!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsDigit!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsHexDigit!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsLowercase!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsPunctuation!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsUppercase!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsUtf16SurrogateTests!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testIsUtf8SurrogateTests!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testPrintString!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testSize!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testSplit!public!unit tests! !
!Core.Tests.CharacterTest categoriesFor: #testStb!public!unit tests! !

