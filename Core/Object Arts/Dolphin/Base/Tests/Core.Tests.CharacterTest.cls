"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.CharacterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.NlsConstants})
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
	self assert: $€ asLowercase identicalTo: $€.
	"Turkish, but 8-bit"
	self assert: $Ç asLowercase equals: $ç.
	"Turkish dotted İ, 16-bit, note not lowercased by default conversion" 
	self assert: $İ asLowercase equals: $İ.
	"Cyrillic, 16-bit"
	self assert: $\x400 asLowercase equals: $\x450.
	"Greek delta"
	self assert: $\x394 asLowercase equals: $\x3B4.
	"Thai 7 - not a letter"
	self assert: $\xE57 asLowercase equals: $\xE57.
	"Symbol outside BMP"
	self assert: Character dolphin asLowercase equals: Character dolphin!

testAsUppercase
	"Ascii chars have unique instances in the ANSI set"

	self assert: $A asUppercase identicalTo: $A.
	self assert: $a asUppercase identicalTo: $A.
	self assert: $\0 asUppercase identicalTo: $\0.
	"Euro symbol - still a unique ANSI encoded char"
	self assert: $€ asUppercase identicalTo: $€.
	"Turkish, but 8-bit"
	self assert: $ç asUppercase equals: $Ç.
	"Turkish un-dotted İ, 16-bit, note not uppercase by default conversion" 
	self assert: $ı asUppercase equals: $ı.
	"Cyrillic, 16-bit"
	self assert: $\x450 asUppercase equals: $\x400.
	"Greek delta"
	self assert: $\x3B4 asUppercase equals: $\x394.
	"Thai 7 - not a letter"
	self assert: $\xE57 asUppercase equals: $\xE57.
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

testClassify
	"Hex uppercase letters"

	($A to: $F)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA | C1_UPPER | C1_XDIGIT)].
	"Remaining uppercase letters"
	($G to: $Z)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA | C1_UPPER)].
	"Hex lowercase letters"
	($a to: $f)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA | C1_LOWER | C1_XDIGIT)].
	"Remaining Lowercase letters, lowercase greek letters, some others"
	($g to: $z) , 'αβγδεζηθικλμνξοπρςστυφχψω' , 'ąⱡîɋṹẵ'
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA | C1_LOWER)].
	"Some Arabic letters"
	'ٮٯٱٲٳٴٵٶٷٸٹٺٻټٽپٿڀځڂڃڄڅچڇڈډڊڋڌڍڎڏڐڑڒړڔڕږڗژڙښڛڜڝڞڟڠڡڢڣڤڥڦڧڨکڪګڬڭڮگڰڱڲڳڴڵڶڷڸڹںڻڼڽھڿۀہۂۃۄۅۆۇۈۉۊۋیۍێۏېۑےۓە'
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA)].
	"Arabic Letter Superscript Alef"
	self assert: ($\x670 classify: 1) equals: C1_DEFINED.

	"Digits"
	($0 to: $9)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_DIGIT | C1_XDIGIT)].
	"Arabic-indic digits"
	($\x660 to: $\x669)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_DIGIT)].

	"Simple Control chars"
	($\0 to: $\b) , ($\xE to: $\x1F)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_CNTRL)].

	"Space - blank, spacing, not control"
	self assert: ($\x20 classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_BLANK | C1_SPACE).

	"Tab - control, blank, spacing"
	#($\t)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_CNTRL | C1_BLANK | C1_SPACE)].

	"Other spaces"
	#($\n $\v $\f $\r)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_CNTRL | C1_SPACE)].

	"Punctuation, ASCII and a few others, e.g. Greek question mark, French speech marks, section mark, runic single, triple danda, arabic percent sign"
	#($!! $" $# $$ $% $& $' $( $) $* $+ $, $- $. $/ $: $; $< $= $> $? $@ $\x37E $« $§ $\x16EB $\xAA5F $\x66A)
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_PUNCT)].

	"Unicode Left-to-right mark - a control character"
	self assert: ($\x200E classify: 1) equals: ##(C1_DEFINED | C1_CNTRL).

	"Lowercase greek letters, some lowercase cyrillic"
	'αβγδεζηθικλμνξοπρςστυφχψω' , 'кракозябры'
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA | C1_LOWER)].

	"Kanji"
	'文字化け'
		do: [:each | self assert: (each classify: CT_CTYPE1) equals: ##(C1_DEFINED | C1_ALPHA)].

	"Emoji"
	self assert: (Character dolphin classify: 1) equals: C1_DEFINED.

	"Unassigned"
	self assert: ($\x8D0 classify: 1) equals: 0!

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

testCodePointString
	#($a 'U+0061' $£ 'U+00A3' $€ 'U+20AC' $\x1F42C 'U+1F42C' $ÿ 'U+00FF' $\x100 'U+0100' $\xFFF 'U+0FFF' $\x1000 'U+1000' $\xFFFD 'U+FFFD' $\x10000 'U+10000' $\x10FFFD 'U+10FFFD')
		pairsDo: [:char :expected | self assert: char codePointString equals: expected]!

testComparing
	self assert: (Character codePoint: 97) <=> $a equals: 0.
	self assert: (Character codePoint: 97) <==> $a equals: 0.
	
	self deny: $a equals: $A.
	self assert: (Character codePoint: 0) equals: $\0.
	self assert: (Character codePoint: 255) equals: $ÿ.
	self deny: $\xFFFC equals: $\xFFFD.
	self deny: $\x200E equals: 16r200E.
	self deny: (Character utf8Value: 240) equals: $ð.
	self deny: (Character utf8Value: 16r80) equals: $\x80!

testDigitValue
	self assert: Character null digitValue equals: -1.
	self assert: $: digitValue equals: -1.
	self assert: $@ digitValue equals: -1.
	($0 to: $9)
		keysAndValuesDo: [:eachKey :eachValue | self assert: eachValue digitValue equals: eachKey - 1].
	($A to: $Z)
		keysAndValuesDo: [:eachKey :eachValue | self assert: eachValue digitValue equals: eachKey + 9].
	"All other characters have no digit value"
	(Character byteCharacterSet difference: ($0 to: $9) , ($A to: $Z))
		do: [:each | self assert: each digitValue equals: -1].
	self assert: Character dolphin digitValue equals: -1!

testEquals
	self assert: (Character codePoint: 97) equals: $a.
	self deny: $a equals: $A.
	self assert: (Character codePoint: 0) equals: $\0.
	self assert: (Character codePoint: 255) equals: $ÿ.
	self deny: $\xFFFC equals: $\xFFFD.
	self deny: $\x200E equals: 16r200E.
	self deny: (Character utf8Value: 240) equals: $ð.
	self deny: (Character utf8Value: 16r80) equals: $\x80!

testIdentity
	self assert: (Character codePoint: 97) identicalTo: $a.
	self assert: (Character codePoint: 255) identicalTo: $ÿ.
	self deny: (Character codePoint: 256) identicalTo: $\x100!

testIsAlphaNumeric
	self assert: $a isAlphaNumeric.
	self assert: $A isAlphaNumeric.
	self assert: $0 isAlphaNumeric.
	"Punctuation"
	self deny: $" isAlphaNumeric.
	"Control char"
	self deny: $\0 isAlphaNumeric.
	"Left-to-right mark"
	self deny: $\x200E isLowerCase.
	"Turkish, but 8-bit"
	self assert: $Ç isAlphaNumeric.
	self assert: $ç isAlphaNumeric.
	" Cyrillic ie with grave, 16-bit"
	self assert: $\x400 isAlphaNumeric.
	self assert: $\x450 isAlphaNumeric.
	"Arabic indic digit zero"
	self assert: $\x660 isAlphaNumeric.
	"Arabic percent sign"
	self deny: $\x66A isAlphaNumeric.
	"Thai digit for 7"
	self assert: $\xE57 isAlphaNumeric!

testIsControl
	"Tests Character>>isControl"

	"C0 and C1 control codes"

	(0 to: 31) , (127 to: 15) do: [:i | self assert: (Character codePoint: i) isControl].
	"All other ASCII chars are not control codes"
	32 to: 126 do: [:i | self deny: (Character codePoint: i) isControl].
	"Left to right mark"
	self assert: $\x200E isControl.
	"Turkish, but ANSI"
	self deny: $Ç isControl.
	"Cyrillic letter ie with grave"
	self deny: $\x400 isControl.
	"Thai 7"
	self deny: $\xE57 isControl!

testIsDigit
	#($0 $1 $2 $3 $4 $5 $6 $7 $8 $9) do: [:each | self assert: each isDigit].
	self deny: $a isDigit.
	self deny: Character null isDigit.
	self deny: $\x1F37B isDigit!

testIsEnglishLetter
	"Ascii"

	self assert: ((0 to: 255) select: [:each | (Character codePoint: each) isEnglishLetter])
		equals: ($A asciiValue to: $Z asciiValue) , ($a asciiValue to: $z asciiValue).
	#($ñ $\x3B2 $\x1F42C $\x6D3 $\x2A77F) do: [:each | self deny: each isEnglishLetter]!

testIsGraph
	"Graph characters are non-blank printable characters."

	"Control characters"

	self deny: $\0 isGraph.
	self deny: $\b isGraph.
	self deny: $\a isGraph.
	"Blank control characters"
	self deny: $\f isGraph.
	self deny: $\t isGraph.
	self deny: $\v isGraph.
	self deny: $\n isGraph.
	"Space"
	self deny: $\x20 isGraph.
	"Punctuation"
	self assert: $. isGraph.
	"Alpha"
	self assert: $a isGraph.
	self assert: $Z isGraph.
	"Digits"
	self assert: $0 isGraph.
	self assert: $9 isGraph.
	"Left-to-right mark - a control character"
	self deny: $\x200E isGraph.
	"Greek"
	self assert: $\x3B4 isGraph.
	self assert: $\x37E isGraph.
	"Arabic indic digit zero"
	self assert: $\x660 isGraph.
	"Arabic percent sign"
	self assert: $\x66A isGraph.
	"Emoji"
	self assert: Character dolphin isGraph!

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
	self deny: Character eof isLowercase.
	"Left-to-right mark"
	self deny: $\x200E isLowerCase.
	"Turkish, but 8-bit"
	self deny: $Ç isLowercase.
	self assert: $ç isLowerCase.
	"Cyrillic, 16-bit"
	self deny: $\x400 isLowercase.
	self assert: $\x450 isLowerCase.
	"Greek delta"
	self assert: $\x3B4 isLowercase.
	self deny: $\x394 isLowercase.
	"Thai 7"
	self deny: $\xE57 isLowercase.
	"Outside BMP"
	self deny: Character dolphin isLowercase.
	self deny: '𪝿' first isLowercase.
	self deny: '𐒽' first isLowercase!

testIsPrintable
	"Control characters"

	self deny: $\0 isPrintable.
	self deny: $\b isPrintable.
	self deny: $\a isPrintable.
	self deny: Character eof isPrintable.
	"Blanks that are also considered control characters, but are printable"
	#($\f $\t $\v $\n) do: [:each | self assert: each isPrintable].
	"Space"
	self assert: $\x20 isPrintable.
	"Punctuation"
	self assert: $. isPrintable.
	"Alpha"
	($A to: $Z) , ($a to: $z) do: [:each | self assert: each isPrintable].
	"Digits"
	($0 to: $9) do: [:each | self deny: each isPunctuation].
	"Left-to-right mark - a control character"
	self deny: $\x200E isPrintable.
	"Greek"
	self assert: $\x3B4 isPrintable.
	self assert: $\x37E isPrintable.
	"Arabic indic digit zero"
	self assert: $\x660 isPrintable.
	"Arabic percent sign"
	self assert: $\x66A isPrintable.
	"Emoji"
	self assert: Character dolphin isPrintable!

testIsPunctuation
	"Letters"

	($A to: $Z) , ($a to: $z) do: [:each | self deny: each isPunctuation].
	"Control chars"
	self deny: $\b isPunctuation.
	self deny: $\a isPunctuation.
	self deny: $\0 isPunctuation.
	self deny: Character eof isPunctuation.
	"Blanks"
	#($\f $\t $\v $\n) do: [:each | self deny: each isPunctuation].
	"Spaces"
	self deny: $\x20 isPunctuation.
	"Digits"
	($0 to: $9) do: [:each | self deny: each isPunctuation].
	"Punctuation"
	self assert: $. isPunctuation.
	self assert: $/ isPunctuation.
	"Left-to-right mark"
	self deny: $\x200E isPunctuation.
	"Greek"
	self deny: $\x3B4 isPunctuation.
	self assert: $\x37E isPunctuation.
	"Arabic indic digit zero"
	self deny: $\x660 isPunctuation.
	"Arabic percent sign"
	self assert: $\x66A isPunctuation.
	"Emoji"
	self deny: Character dolphin isPunctuation!

testIsUppercase
	($A to: $Z) do: [:each | self assert: each isUppercase].
	self deny: $a isUppercase.
	self deny: $0 isUppercase.
	self deny: $\0 isUppercase.
	self deny: $\x20 isUppercase.
	self deny: $\n isUppercase.
	self deny: $!! isUppercase.
	"Left-to-right mark"
	self deny: $\x200E isLowerCase.
	"Turkish, but 8-bit"
	self assert: $Ç isUppercase.
	self deny: $ç isUppercase.
	"Cyrillic, 16-bit"
	self assert: $\x400 isUppercase.
	self deny: $\x450 isUppercase.
	"Greek delta"
	self assert: $\x394 isUppercase.
	self deny: $\x3B4 isUppercase.
	"Thai 7"
	self deny: $\xE57 isUpperCase.
	"Outside BMP"
	self deny: Character dolphin isUppercase.
	self deny: '𠃀' first isUppercase.
	self deny: '𐓦' first isUppercase!

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

testIsWhitespace
	"Graph characters are non-blank printable characters."

	#($\x20 $\n $\r $\t $\f $\v $\x2028 $\x2029) do: [:each | self assert: each isWhitespace].
	#($\0 $\b $a $A $0 $\x200E $\x16 $\x3B4 $\x660 $@ $\x1F42C)
		do: [:each | self deny: each isWhitespace]!

testJoin
	self assert: ($, join: #()) equals: ''.
	self assert: ($, join: 'b') equals: 'b'.
	self assert: ($, join: #('b')) equals: 'b'.
	self assert: ($, join: 'ab') equals: 'a,b'.
	self assert: ($, join: #('a' 'b')) equals: 'a,b'.
	self assert: ($, join: {Object. Association}) equals: 'Core.Object,Core.Association'!

testPrintString
	self assert: $a printString equals: '$a'.
	self assert: $a printString equals: '$a'.
	(1 to: 6) , (14 to: 32)
		do: [:i | self assert: (Character codePoint: i) printString equals: '$\x' , (i printStringBase: 16)].
	(33 to: 126) do: [:i | self deny: ((Character codePoint: i) printString beginsWith: '$\x')].
	self assert: $\0 printString equals: '$\0'.
	self assert: $\a printString equals: '$\a'.
	self assert: $\b printString equals: '$\b'.
	self assert: $\t printString equals: '$\t'.
	self assert: $\n printString equals: '$\n'.
	self assert: $\v printString equals: '$\v'.
	self assert: $\f printString equals: '$\f'.
	self assert: $\r printString equals: '$\r'.
	self assert: $\x7F printString equals: '$\x7F'.
	self assert: $\x394 printString equals: '$\x394'.
	"Left-to-right mark"
	self assert: $\x200E printString equals: '$\x200E'!

testSize
	self assert: $a size equals: 0.
	self assert: Character dolphin size equals: 0!

testSpaceships
	"Note that <==> is a case-sensitive ordinal (codepoint) ordering"

	self assert: (Character codePoint: 97) <=> $a equals: 0.
	self assert: (Character codePoint: 97) <==> $a equals: 0.
	self assert: $a <=> $A equals: 0.
	"Code point ordering, so $A < $a"
	self assert: $a <==> $A equals: 1.
	self assert: $A <==> $a equals: -1.
	self assert: $a <=> $B equals: -1.
	self assert: $a <==> $b equals: -1.
	self assert: $a <==> $B equals: 1.
	self assert: $A <=> $b equals: -1.
	self assert: $A <==> $b equals: -1.
	"'Non-ascii: ě cf Ě"
	self assert: $\x11B <=> $\x11A equals: 0.
	self assert: $\x11A <=> $\x11B equals: 0.
	self assert: $\x11B <==> $\x11A equals: 1.
	self assert: $\x11A <==> $\x11B equals: -1.
	"'Non-ascii: ě/Ě cf Ď"
	self assert: $\x11B <=> $\x10E equals: 1.
	self assert: $\x10E <=> $\x11B equals: -1.
	self assert: $\x11A <=> $\x10E equals: 1.
	self assert: $\x11B <==> $\x10E equals: 1.
	self assert: $\x10E <==> $\x11B equals: -1!

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
!Core.Tests.CharacterTest categoriesForMethods!
nonCharacters!constants!private! !
testAnsiValue!public!unit tests! !
testAsciiValue!public!unit tests! !
testAsLowercase!public!unit tests! !
testAsUppercase!public!unit tests! !
testAsUtf16String!public!unit tests! !
testAsUtf8String!public!unit tests! !
testClassCodePoint!public!unit tests! !
testClassify!public!unit tests! !
testClassNewCode!public! !
testCodePoint!public!unit tests! !
testCodePointString!public!unit tests! !
testComparing!public!unit tests! !
testDigitValue!public!unit tests! !
testEquals!public!unit tests! !
testIdentity!public!unit tests! !
testIsAlphaNumeric!public!unit tests! !
testIsControl!public!unit tests! !
testIsDigit!public!unit tests! !
testIsEnglishLetter!public!unit tests! !
testIsGraph!public!unit tests! !
testIsHexDigit!public!unit tests! !
testIsLowercase!public!unit tests! !
testIsPrintable!public!unit tests! !
testIsPunctuation!public!unit tests! !
testIsUppercase!public!unit tests! !
testIsUtf16SurrogateTests!public!unit tests! !
testIsUtf8SurrogateTests!public!unit tests! !
testIsWhitespace!public!unit tests! !
testJoin!public!unit tests! !
testPrintString!public!unit tests! !
testSize!public!unit tests! !
testSpaceships!public!unit tests! !
testSplit!public!unit tests! !
testStb!public!unit tests! !
!

