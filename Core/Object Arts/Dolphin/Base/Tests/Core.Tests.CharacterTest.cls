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
	self assert: $I asLowercase identicalTo: $i.
	"Boundary case - largest Ascii value"
	self assert: $\x7F asLowercase identicalTo: $\x7F.
	"U+0080 doesn't appear in 1252 (for example)"
	self assert: $\x80 asLowercase equals: $\x80.
	self assert: $\xFF asLowercase equals: $\xFF.
	self assert: $\x178 asLowercase equals: $\xFF.
	"Boundary case - BMP - largest value 16-bit char is U+FFFD, the replacement char"
	self assert: $\xFFFD asLowercase equals: $\xFFFD.
	"U+10000 Linear B Syllable B008 A"
	self assert: $\x10000 asLowercase equals: $\x10000.

	"U+20AC Euro symbol - still a unique ANSI encoded char"
	self assert: $€ asLowercase equals: $€.
	"Turkish, but 8-bit"
	self assert: $Ç asLowercase equals: $ç.
	"Turkish dotted İ"
	self assert: $İ asLowercase equals: $i.
	"Cyrillic, 16-bit"
	self assert: $Ѐ asLowercase equals: $ѐ.
	"Greek delta"
	self assert: $Δ asLowercase equals: $δ.
	"U+1E9E Latin Capital Letter Sharp S  -> (U+00DF Latin Small Letter Sharp S)."
	self assert: $ẞ asLowercase equals: $ß.
	"Thai 7 - not a letter"
	self assert: $๗ asLowercase equals: $๗.
	"U+01C5 Latin Capital Letter D with Small Letter Z with Caron -> U+01C6 Latin Small Letter Dz with Caron"
	self assert: $ǅ asLowercase equals: $ǆ.
	"U+037F Greek Capital Letter Yot -> U+03F3 Greek Letter Yot"
	self assert: $Ϳ asLowercase equals: $ϳ.
	"U+052A Cyrillic Capital Letter Dzzhe -> U+052B Cyrillic Small Letter Dzzhe"
	self assert: $Ԫ asLowercase equals: $ԫ.
	"Outside BMP"
	"Emoji"
	self assert: $🐬 asLowercase equals: $🐬.
	"Supplementary multi-lingual plane"
	"U+16E5A Medefaidrin Capital Letter Oe -> U+16E7A Medefaidrin Small Letter Oe"
	self assert: $𖹚 asLowercase equals: $𖹺.
	"U+1E921 Adlam Capital Letter Sha -> U+1E943 Adlam Small Letter Sha"
	self assert: $𞤡 asLowercase equals: $𞥃!

testAsUppercase
	"Ascii chars have unique instances in the ANSI set"

	self assert: $A asUppercase identicalTo: $A.
	self assert: $a asUppercase identicalTo: $A.
	self assert: $\0 asUppercase identicalTo: $\0.
	self assert: $i asUppercase identicalTo: $I.
	"Euro symbol - still a unique ANSI encoded char on typical code page, but might not be running with one"
	self assert: $€ asUppercase equals: $€.
	"Boundary case - largest Ascii value"
	self assert: $\x7F asUppercase identicalTo: $\x7F.
	"U+0080 doesn't appear in 1252 (for example)"
	self assert: $\x80 asUppercase equals: $\x80.
	self assert: $\xFF asUppercase equals: $\x178.
	"Boundary case - BMP - largest value 16-bit char is U+FFFD, the replacement char"
	self assert: $\xFFFD asUppercase equals: $\xFFFD.
	"U+10000 Linear B Syllable B008 A"
	self assert: $\x10000 asUppercase equals: $\x10000.
	"U+1000 Myanmar Letter Ka"
	self assert: $\x1000 asUppercase equals: $\x1000.
	"Turkish, but 8-bit"
	self assert: $ç asUppercase equals: $Ç.
	"Turkish dottless-i"
	self assert: $ı asUppercase equals: $I.
	"Cyrillic, 16-bit"
	self assert: $ѐ asUppercase equals: $Ѐ.
	"Greek delta"
	self assert: $δ asUppercase equals: $Δ.
	"U+00DF Latin Small Letter Sharp S (eszett) - there has been an official capitalized version for some time (U+1E9E Latin Capital Letter Sharp S), but not converted by ICU at this time. For a string conversion it would convert eszett to SS, but as this is a single character conversion it can't do that."
	self assert: $ß asUppercase equals: $ß.
	"Thai 7 - not a letter"
	self assert: $๗ asUppercase equals: $๗.
	"U+01C6 Latin Small Letter Dz with Caron -> U+01C4 Latin Capital Letter DZ with Caron"
	self assert: $ǆ asUppercase equals: $Ǆ.
	"U+03F3 Greek Letter Yot -> U+037F Greek Capital Letter Yot"
	self assert: $ϳ asUppercase equals: $Ϳ.
	"U+052B Cyrillic Small Letter Dzzhe -> U+052A Cyrillic Capital Letter Dzzhe "
	self assert: $ԫ asUppercase equals: $Ԫ.
	"Outside BMP"
	"Emoji"
	self assert: $🐬 asUppercase equals: $🐬.
	"Supplementary multi-lingual plane"
	"U+16E7A Medefaidrin Small Letter Oe -> U+16E5A Medefaidrin Capital Letter Oe"
	self assert: $𖹺 asUppercase equals: $𖹚.
	" U+1E943 Adlam Small Letter Sha -> U+1E921 Adlam Capital Letter Sha"
	self assert: $𞥃 asUppercase equals: $𞤡!

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
	#(#($A #[65]) #($\x7F #[16r7F]) #($£ #[16rC2 16rA3]) #($߿ #[16rDF 16rBF]) #($ࠀ #[16rE0 16rA0 16r80]) #($𐀀 #[16rF0 16r90 16r80 16r80]) #($🐬 #[16rF0 16r9F 16r90 16rAC]))
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

testCodePointString
	#($\x0 'U+0000' $a 'U+0061' $£ 'U+00A3' $€ 'U+20AC' $\x1F42C 'U+1F42C' $ÿ 'U+00FF' $\x100 'U+0100' $\xFFF 'U+0FFF' $\x1000 'U+1000' $\xFFFD 'U+FFFD' $\x10000 'U+10000' $\x10FFFD 'U+10FFFD')
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

testFoldcase
	"Unicode case folding is similar to lower-casing."

	self assert: $a caseFolded identicalTo: $a.
	self assert: $A caseFolded identicalTo: $a.
	self assert: $\0 caseFolded identicalTo: $\0.
	"Euro symbol - still a unique ANSI encoded char"
	self assert: $€ caseFolded identicalTo: $€.
	self assert: $\x80 caseFolded equals: $\x80.
	"Turkish, but 8-bit"
	self assert: $Ç caseFolded equals: $ç.
	"Turkish dotted İ"
	self assert: $İ caseFolded equals: $İ.
	"Cyrillic, 16-bit"
	self assert: $Ѐ caseFolded equals: $ѐ.
	"Greek delta"
	self assert: $Δ caseFolded equals: $δ.
	"U+1E9E Latin Capital Letter Sharp S  -> (U+00DF Latin Small Letter Sharp S)."
	self assert: $ẞ caseFolded equals: $ß.
	self assert: $ß caseFolded equals: $ß.
	"Thai 7 - not a letter"
	self assert: $๗ caseFolded equals: $๗.
	"U+01C5 Latin Capital Letter D with Small Letter Z with Caron -> U+01C6 Latin Small Letter Dz with Caron"
	self assert: $ǅ caseFolded equals: $ǆ.
	"U+037F Greek Capital Letter Yot -> U+03F3 Greek Letter Yot"
	self assert: $Ϳ caseFolded equals: $ϳ.
	"U+052A Cyrillic Capital Letter Dzzhe -> U+052B Cyrillic Small Letter Dzzhe"
	self assert: $Ԫ caseFolded equals: $ԫ.
	"Outside BMP"
	"Emoji"
	self assert: $🐬 caseFolded equals: $🐬.
	"Supplementary multi-lingual plane"
	"U+16E5A Medefaidrin Capital Letter Oe -> U+16E7A Medefaidrin Small Letter Oe"
	self assert: $𖹚 caseFolded equals: $𖹺.
	"U+1E921 Adlam Capital Letter Sha -> U+1E943 Adlam Small Letter Sha"
	self assert: $𞤡 caseFolded equals: $𞥃!

testFoldCaseICU
	"Transcription of ICU case folding test."

	| simple tr de |
	simple := #(#(16r61 16r61 16r61) #(16r49 16r69 16r131) #(16r130 16r130 16r69) #(16r131 16r131 16r131) #(16rDF 16rDF 16rDF) #(16rFB03 16rFB03 16rFB03) #(16r1040E 16r10436 16r10436) #(16r5FFFF 16r5FFFF 16r5FFFF)).
	tr := Locale named: 'tr-TR'.
	de := Locale named: 'de-DE'.
	simple do: 
			[:each |
			| subject |
			subject := Character utf16Value: each first
						ifInvalid: 
							["Test data contains invalid character, but Dolphin deliberately makes it difficult to create strings with invalid characters (or indeed just to instantiate invalid characters)."
							Character newCode: (each first bitOr: Character.Utf32Mask)].
			self assert: subject caseFolded codePoint equals: each second.
			self assert: (subject caseFolded: de) codePoint equals: each second.
			self assert: (subject caseFolded: tr) codePoint equals: each third]!

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
	self assert: $Ѐ isAlphaNumeric.
	self assert: $ѐ isAlphaNumeric.
	"Arabic indic digit zero - not considered alphanumeric because this is ANSI standard definition, and only ASCII digits are included"
	self deny: $٠ isAlphaNumeric.
	"Ditto Thai digit for 7"
	self deny: $๗ isAlphaNumeric.
	"Arabic percent sign"
	self deny: $٪ isAlphaNumeric!

testIsControl
	"Tests Character>>isControl"

	"C0 and C1 control codes"

	($\0 to: $\b) , ($\xE to: $\x1F) do: [:each | self assert: each isControl].
	self assert: $\x7F isControl.
	"Space is specifically not a control character"
	self deny: $\x20 isControl.
	"All other ASCII chars are not control codes"
	16r21 to: 16r7E do: [:i | self deny: (Character codePoint: i) isControl].
	"Left to right mark"
	self assert: $\x200E isControl.
	"Turkish, but ANSI"
	self deny: $Ç isControl.
	"Cyrillic letter ie with grave"
	self deny: $Ѐ isControl.
	"Thai 7"
	self deny: $๗ isControl.
	"Khmer Vowel Inherent Aq - a non-spacing mark, not a control"
	self deny: $឴ isControl.
	"BOM"
	self assert: $\xFEFF isControl!

testIsDigit
	#($0 $1 $2 $3 $4 $5 $6 $7 $8 $9) do: [:each | self assert: each isDigit].


	"Arabic indic digits - are decimal digits, but not by the ANSI isDigit definition"
	($٠ to: $٩) do: [:each | self deny: each isDigit].
	self deny: $a isDigit.
	self deny: $\0 isDigit.
	self deny: $🍻 isDigit.

	"Mathematical bold digit 1, U+1D7CF is a digit, but not according to #isDigit"
	self deny: $𝟏 isDigit!

testIsEnglishLetter
	"Ascii only"

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
	"U+200B: Zero width space"
	self deny: $\x200B isGraph.
	"Greek"
	self assert: $δ isGraph.
	self assert: $; isGraph.	"Greek question mark"
	"Arabic indic digit zero"
	self assert: $٠ isGraph.
	"Arabic percent sign"
	self assert: $٪ isGraph.
	"Emoji"
	self assert: $🐬 isGraph.
	"U+17B4: Khmer Vowel Inherent Aq"
	self assert: $឴ isGraph.
	"U+E0020 Tag Space. An emoji modifier, not a standalone graph"
	self deny: $\xE0020 isGraph.
	"BOM"
	self deny: $\xFEFF isGraph!

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

testIsLetter
	self assert: ((0 to: 255) select: [:each | (Character codePoint: each) isEnglishLetter])
		equals: ($A asciiValue to: $Z asciiValue) , ($a asciiValue to: $z asciiValue).
	#($_ $\x20 $\t $\r $0) do: [:each | self deny: each isLetter].
	#($ñ $β $ۓ $𪝿 $ꟹ) do: [:each | self assert: each isLetter].
	"Some Arabic letters"
	'ٮٯٱٲٳٴٵٶٷٸٹٺٻټٽپٿڀځڂڃڄڅچڇڈډڊڋڌڍڎڏڐڑڒړڔڕږڗژڙښڛڜڝڞڟڠڡڢڣڤڥڦڧڨکڪګڬڭڮگڰڱڲڳڴڵڶڷڸڹںڻڼڽھڿۀہۂۃۄۅۆۇۈۉۊۋیۍێۏېۑےۓە'
		codePointsDo: [:each | self assert: each isLetter].
	"Kanji"
	'文字化け' do: [:each | self assert: each isLetter].

	"Arabic Letter Superscript Alef"
	self deny: $ٰ isLetter.

	"Emoji"
	self deny: $🐬 isLetter.
	"Combining Greek Ypogegrammeni (diacritical mark)"
	self deny: $ͅ isLetter.
	"Hebrew Point Hataf Segol (non-spacing mark)"
	self deny: $ֱ isLetter.
	"U+0E47 Thai Maitaikhu (non-spacing mark)"
	self deny: $็ isLetter!

testIsLowercase
	($a to: $z) do: [:each | self assert: each isLowercase].
	"Greek"
	'αβγδεζηθικλμνξοπρςστυφχψω'
		codePointsDo: [:each | self assert: each isLowercase].
	'ΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΣΤΥΦΧΨΩ'
		codePointsDo: [:each | self deny: each isLowercase].
	"Cyrillic"
	'кракозябры' codePointsDo: [:each | self assert: each isLowercase].
	"Other"
	'ąⱡîɋṹẵ' codePointsDo: [:each | self assert: each isLowercase].
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
	self deny: $Ѐ isLowercase.
	self assert: $ѐ isLowerCase.
	"Greek delta"
	self assert: $δ isLowercase.
	self deny: $Δ isLowercase.
	"U+00DF Latin Small Letter Sharp S (eszett)"
	self assert: $ß isLowercase.
	"Thai 7"
	self deny: $๗ isLowercase.
	"Cyrillic Small Letter Rounded Ve"
	self assert: $ᲀ isLowercase.
	"U+00AA: Feminine Ordinal Indicator (other letter, not in lowercase category)"
	self deny: $ª isLowercase.
	"Outside BMP"
	self deny: $🐬 isLowercase.
	self deny: $𪝿 isLowercase.
	self deny: $𐒽 isLowercase.
	"U+10428: Deseret Small Letter Long I"
	self assert: $𐐨 isLowercase!

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
	self assert: $δ isPrintable.
	self assert: $; isPrintable.
	"Arabic indic digit zero"
	self assert: $٠ isPrintable.
	"Arabic percent sign"
	self assert: $٪ isPrintable.
	"Emoji"
	self assert: Character dolphin isPrintable.
	"BOM - not printable"
	self deny: $\xFEFF isPrintable!

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
	"Punctuation, ASCII and a few others, e.g. Greek question mark, French speech marks, section mark, runic single, triple danda, arabic percent sign"
	#($!! $" $# $% $& $' $( $) $* $, $- $. $/ $: $; $? $@ $« $§ $᛫ $꩟ $٪)
		do: [:each | self assert: each isPunctuation].
	"Currencies are not punctuation"
	self deny: $$ isPunctuation.
	"Nor are mathematical symbols"
	self deny: $+ isPunctuation.
	"Nor relational operators"
	self deny: $< isPunctuation.
	"Left-to-right mark"
	self deny: $\x200E isPunctuation.
	"Greek"
	self deny: $δ isPunctuation.
	self assert: $; isPunctuation.
	"Arabic indic digit zero"
	self deny: $٠ isPunctuation.
	"U+0830 Samaritan Nequdaa (Other Punctuation)"
	self assert: $࠰ isPunctuation.
	"Emoji"
	self deny: $🐬 isPunctuation!

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
	self assert: $Ѐ isUppercase.
	self deny: $ѐ isUppercase.
	"Greek delta"
	self assert: $Δ isUppercase.
	self deny: $δ isUppercase.
	"U+1E9E Latin Capital Letter Sharp S."
	self assert: $ẞ isUpperCase.
	"Thai 7"
	self deny: $๗ isUpperCase.
	"Outside BMP"
	self deny: $🐬 isUppercase.
	self deny: $𠃀 isUppercase.
	self deny: $𐓦 isUppercase.
	self assert: $𐒽 isUppercase.
	"U+1D49C: Mathematical Script Capital A"
	self assert: $𝒜 isUppercase!

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

	#($\x20 $\n $\r $\t $\f $\v) do: [:each | self assert: each isWhitespace].
	"NEL - Next line"
	self assert: $\x85 isWhitespace.
	"Non-break space"
	self assert: $\xA0 isWhitespace.
	"U+1680 Ogham Space Mark"
	self assert: $\x1680 isWhitespace.
	"U+2003 Em Space (printer's separator, aka mutton)"
	self assert: $\x2003 isWhitespace.
	"U+2028 Line Separator"
	self assert: $\x2028 isWhitespace.
	"U+2028 Paragraph Separator"
	self assert: $\x2029 isWhitespace.
	"U+202F Narrow No-Break Space"
	self assert: $\x202F isWhitespace.
	"U+205F Medium Mathematical Space"
	self assert: $\x205F isWhitespace.
	"U+3000 Ideographic Space"
	self assert: $\x3000 isWhitespace.
	"Some non-spaces"
	#($\0 $\b $a $A $0 $\x1C $\x200E $\x16 $δ $٠ $@ $🐬 $\x180E)
		do: [:each | self deny: each isWhitespace]!

testJoin
	self assert: ($, join: #()) equals: ''.
	self assert: ($, join: 'b') equals: 'b'.
	self assert: ($, join: #('b')) equals: 'b'.
	self assert: ($, join: 'ab') equals: 'a,b'.
	self assert: ($, join: #('a' 'b')) equals: 'a,b'.
	self assert: ($, join: {Object. Association}) equals: 'Core.Object,Core.Association'!

testLiterals
	"Exhaustively test that all Unicode codepoints have a valid literal representation."

	<knownSlowTest>
	| chars expr actual |
	chars := ((0 to: 16r1FFFF) select: [:each | Character isValidCodePoint: each])
				collect: [:each | Character codePoint: each].
	expr := Utf8String writeStream.
	expr nextPut: ${.
	chars do: 
			[:each |
			actual := Compiler evaluate: each printString.
			self assert: actual equals: each]!

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
	self assert: $\x394 printString equals: '$Δ'.
	"Left-to-right mark"
	self assert: $\x200E printString equals: '$\x200E'!

testSize
	self assert: $a size equals: 0.
	self assert: Character dolphin size equals: 0!

testSpaceships
	"Note that <==> is a case-sensitive ordinal (codepoint) ordering"

	self assert: (Character codePoint: 97) <=> $a equals: 0.
	self assert: (Character codePoint: 97) <==> $a equals: 0.
	self assert: $i <=> $I equals: 0.
	self assert: $I <=> $i equals: 0.

	"Code point ordering, so $A < $a"
	self assert: $a <==> $A equals: 1.
	self assert: $A <==> $a equals: -1.
	self assert: $a <=> $B equals: -1.
	self assert: $a <==> $b equals: -1.
	self assert: $a <==> $B equals: 1.
	self assert: $A <=> $b equals: -1.
	self assert: $A <==> $b equals: -1.
	"'Non-ascii: ě cf Ě"
	self assert: $ě <=> $Ě equals: 0.
	self assert: $Ě <=> $ě equals: 0.
	self assert: $ě <==> $Ě equals: 1.
	self assert: $Ě <==> $ě equals: -1.
	"'Non-ascii: ě/Ě cf Ď"
	self assert: $ě <=> $Ď equals: 1.
	self assert: $Ď <=> $ě equals: -1.
	self assert: $Ě <=> $Ď equals: 1.
	self assert: $ě <==> $Ď equals: 1.
	self assert: $Ď <==> $ě equals: -1!

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
testClassNewCode!public! !
testCodePoint!public!unit tests! !
testCodePointString!public!unit tests! !
testComparing!public!unit tests! !
testDigitValue!public!unit tests! !
testEquals!public!unit tests! !
testFoldcase!public!unit tests! !
testFoldCaseICU!public!unit tests! !
testIdentity!public!unit tests! !
testIsAlphaNumeric!public!unit tests! !
testIsControl!public!unit tests! !
testIsDigit!public!unit tests! !
testIsEnglishLetter!public!unit tests! !
testIsGraph!public!unit tests! !
testIsHexDigit!public!unit tests! !
testIsLetter!public!unit tests! !
testIsLowercase!public!unit tests! !
testIsPrintable!public!unit tests! !
testIsPunctuation!public!unit tests! !
testIsUppercase!public!unit tests! !
testIsUtf16SurrogateTests!public!unit tests! !
testIsUtf8SurrogateTests!public!unit tests! !
testIsWhitespace!public!unit tests! !
testJoin!public!unit tests! !
testLiterals!public!unit tests! !
testPrintString!public!unit tests! !
testSize!public!unit tests! !
testSpaceships!public!unit tests! !
testSplit!public!unit tests! !
testStb!public!unit tests! !
!

