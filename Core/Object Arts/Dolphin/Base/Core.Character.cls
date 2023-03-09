"Filed out from Dolphin Smalltalk"!

Core.Magnitude
	subclass: #'Core.Character'
	instanceVariableNames: 'code'
	classVariableNames: 'AnsiCharacters AnsiCodePage AnsiCodePoints CharacterSet'
	imports: #(#{OS.NlsConstants private} #{OS.ICUConstants private})
	classInstanceVariableNames: ''
	classConstants: {
			'EncodingMask' -> 16r3F000000.
			'EscapeChars' -> #($0 nil nil nil nil nil nil $a $b $t $n $v $f $r).
			'Replacement' -> $\xFFFD.
			'Utf16LeadMask' -> 16rD800.
			'Utf16Mask' -> 16r2000000.
			'Utf16SurrogateMask' -> 16rFC00.
			'Utf16TrailMask' -> 16rDC00.
			'Utf32Mask' -> 16r3000000.
			'Utf8Mask' -> 16r1000000.
			'Utf8SurrogateMask' -> 16rC0
		}!
Core.Character guid: (Core.GUID fromString: '{87b4c651-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Character comment: '`Character` is the class of objects which serve as the elemental values of Smalltalk `Strings`.

Each `Character` instance generally represents a specific Unicode [code point](https://en.wikipedia.org/wiki/Code_point). Note that this does not necessarily mean that each `Character` corresponds to a single user-perceived, visually distinct, character (aka grapheme cluster). Multiple `Character`s may compose into a single grapheme cluster when displayed, some examples of different types being `👨🏻‍🍳`, `ö`, and `กำ`. The 2nd example has more than one valid representation and can have either one or two code-points.

 `Character` instances may also represent partial or surrogate character code-units that are part of a multi-code-unit code-point. Such surrogate instances may result from indexed access into `UTFEncodedStrings` such as `Utf8String` or `Utf16String`, and can be distinguished through the use of the `isSurrogate`, `isUtf8Surrogate`, `isUtf16Surrogate` family of testing messages. For example:

```
(Character dolphin asUtf8String at: 1) isUtf8Surrogate	"true"
```

A surrogate can be written into a `String` of the same encoding, e.g. a UTF-8 surrogate into a `Utf8String`, but not into a string with a different UTF encoding. Care is also needed to avoid constructing strings with partial characters by writing an incomplete, or misordered, set of surrogate code-unit characters into the string. It is also possible to work with surrogates and streams of the correct underlying encoding, for example:

```
i := 0. Character dolphin asUtf8String do: [:each | i := i + 1. Transcript nextPut: each]. Transcript nextPutAll: '' has ''; print: i; nextPutAll: '' UTF-8 code units''; cr; flush
```

However, in general it is recommended to stream over strings, rather than treating them as arrays of characters, in which case surrogates will not be encountered.

```
i := 0. Character dolphin asUtf8String readStream do: [:each | i := i + 1. Transcript nextPut: each]. Transcript nextPutAll: '' has ''; print: i; nextPutAll: '' codepoint(s)''; cr; flush
```

The instances for the first 256 code points are unique. Smalltalk characters have a literal syntax which is the ''$'' symbol followed by the normal printed representation of the character. 
At present only byte characters (that are not control characters) have a printable literal representation. Dolphin also supports the following escaped literal formats to provide a literal representation of any character:
  `$\0`		- Null
  `$\a`		- Bell
  `$\b`		- Backspace
  `$\t`		- Tab
  `$\n`		- Newline
  `$\v`		- Vertical tab
  `$\f`		- Form Feed
  `$\r`		- Carriage return
  `$\x<HHHH>` - where <HHHH> is the hex representation of the character''s code point - can be used to represent any valid code point.
'!
!Core.Character categoriesForClass!Magnitude-General! !
!Core.Character methodsFor!

_beginsString: aString
	^aString first = self!

_separateSubStringsIn: tokens
	| start answer size end codeUnits |
	size := tokens size.
	size == 0 ifTrue: [^{}].
	end := tokens
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{tokens}].
	answer := Array writeStream: 5.
	start := 1.
	codeUnits := tokens encodedSizeOf: self.
	
	[answer nextPut: (tokens copyFrom: start to: end - 1).
	start := end + codeUnits.
	end := tokens
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	start <= size ifTrue: [answer nextPut: (tokens copyFrom: start to: size)].
	^answer contents!

< aCharacter
	"Answer whether the receiver is less than the parameter aCharacter."

	^self codePoint < aCharacter asInteger
!

<==> aCharacter
	"Answer the receiver's case-sensitive <integer> collation order with respect to the <Character> argument. Note that this is a code point ordering and not a linguistic one, so for example $A is considered to occur before $a."

	^(self codePoint - aCharacter codePoint) sign!

<=> aCharacter
	"Answer the receiver's case-insensitive <integer> collation order with respect to the <Character> argument. "

	^self asUppercase <==> aCharacter asUppercase!

= anObject
	"Answer whether the receiver is equal to the argument. There is a unique Character instance for each codepoint < 256, but instances for higher code points are not unique."

	<primitive: 229>
	^self == anObject or: [anObject class == Character and: [anObject code == code]]!

> aCharacter
	"Answer whether the receiver is greater than the parameter aCharacter."

	^self codePoint > aCharacter asInteger
!

ansiValue
	"Answers the ansi character value of the receiver."

	^code <= 16rFF ifTrue: [code] ifFalse: [self error: 'Non-ansi code point']!

asAnsiString
	"Answer a new ANSI-encoded <String> whose sole element is the receiver. It is an error if
	the receiver's code point cannot be represented in ANSI encoding."

	^AnsiString with: self!

asciiValue
	"Answers the ascii character value of the receiver."

	^code < 128 ifTrue: [code] ifFalse: [self error: 'Non-ascii code point']!

asInteger
	"Answer the <integer> character encoding (i.e. the Unicode code point) that the receiver
	represents."

	^self codePoint!

asLowercase
	"Answer a <Character> which is the lowercase equivalent of the receiver. Note that this is single code point mapping, so does not properly take account of composite characters. Case-conversions for a string should always be performed directly, and never character-by-character."

	"Implementation Note: Unicode standard mappings as implemented by ICU, and as such supports letters outside the BMP (unlike the Windows API). Does not depend on host OS locale (e.g. Turkish dotted-I mapping will always take place)."

	^OS.ICU u_tolower: self!

asString
	"Answer a new <String> whose sole element is the receiver."

	^Utf8String with: self!

asSymbol
	"Answer the Symbol representation of the receiver."

	^Symbol internCharacter: self!

asUppercase
	"Answer a <Character> which is the uppercase equivalent of the receiver. Note that this is single code point mapping, so does not properly take account of context. Case-conversions for a string should always be performed directly, and never character-by-character."

	"Implementation Note: Unicode standard mappings as implemented by ICU, and as such supports letters outside the BMP (unlike the Windows API). Does not depend on host OS locale."

	^OS.ICU u_toupper: self!

asUtf16String
	"Answer a new UTF-16 encoded <String> whose sole element is the receiver."

	^Utf16String with: self!

asUtf8String
	"Answer a new <Utf8String> encoding the receiver's code point."

	^Utf8String with: self!

basicEncoding
	"Private - Answer the <integer> encoding of the character, which will be one of the String encoding constants."

	^code bitShift: -24!

basicShallowCopy
	"Answer the receiver as Characters are immutable."

	^self!

caseFolded
	"Answer a <Character> which is the case-folded equivalent of the receiver. The folding uses default Unicode mappings.
	Note that this is single code point mapping, so does not properly take account of composite characters. Case-conversions for a string should ideally be performed directly, and not character-by-character."

	"Implementation Note: ICU case folding. This is basically a Unicode standard mapping as implemented by ICU, and as such supports letters outside the BMP (unlike the Windows API). Performs default mappings independent of locale - i.e. $İ is not mapped to $i, and $I maps to $i, not $ı, but see also #asFoldcase:"

	^OS.ICU u_foldCase: self options: U_FOLD_CASE_DEFAULT!

caseFolded: aLocale
	"Answer a <Character> which is the case-folded equivalent of the receiver. The folding uses default mappings, unless the <Locale> argument is turkic.
	Note that this is single code point mapping, so does not properly take account of composite characters. Case-conversions for a string should ideally be performed directly, and not character-by-character."

	^OS.ICU u_foldCase: self options: aLocale icuCaseFoldingOptions!

code
	^code!

codePoint
	"Answer the <integer> Unicode code point that the receiver represents. If the receiver is a 
	UTF-8 or UTF-16 surrogate (partial character) this may not be a valid Unicode code point."

	"Note that Dolphin will prefer to return an ANSI encoded character from the pre-allocated
	set of 256 ANSI characters, or a UTF-32 encoded character for code points outside the ANSI
	character set. Characters encounted when streaming or enumerating over any type of string
	(including Utf8String and Utf16String) will always be either be either ANSI encoded or
	UTF-32 encoded. UTF-32 encoded characters represent a full code point. However, in the case
	of code that directly performs indexed access into a Utf8String or Utf16String, the VM may
	return UTF-8 or UTF16- surrogates (respectively). These surrogates are really only valid for
	use with further strings of their native encoding, as they do not represent a complete code
	point and cannot be translated to another encoding without their companion surrogates."

	^code <= 16rFF
		ifTrue: [AnsiCodePoints at: code +1]
		ifFalse: 
			["If this is a UTF-8 or UTF-16 surrogate, the code point will be invalid"
			code bitAnd: 16rFFFFFF]!

codePointString
	"Answer the Unicode code string for the receiver as typically shown in tables of Unicode characters, e.g. [U+0061](https://codepoints.net/U+0061) for $a"

	| codePoint |
	codePoint := self codePoint.
	^'U+' , (codePoint printStringBase: 16 nDigits: ((codePoint numberOfDigitsInBase: 16) max: 4))!

codeUnit
	"Answer the <integer> character code for the character in its native encoding. This can
	never be greater than 16r10FFFF, which is the maximum Unicode code point."

	^code bitAnd: 16r1FFFFF!

deepCopy
	"Answer the receiver, as Characters are immutable"

	^self!

digitValue
	"Answer the digit representation of the receiver. 'digit' is defined as either 0-9, or uppercase A-Z (for 10-35)."

	"Note: In versions of Dolphin prior to 3.0 this raised an error if the character was not a valid digit character, but for compatibility with other Smalltalks it now returns -1. The method is now optimized for improved performance too."

	^(#(-1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 0 1 2 3 4 5 6 7 8 9 -1 -1 -1 -1 -1 -1 -1 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1 -1)
		lookup: code) ?? -1!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream locale displayCharacter: self on: aPuttableStream!

encoding
	"Answer a <Symbol> naming the encoding of the character, which will be one of #ansi, #utf8, #utf16le or #utf32."

	^String encodingName: self basicEncoding!

greaterOrEqualToInteger: anInteger 
	^self codePoint >= anInteger!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^self codePoint!

icuType
	^OS.ICU u_charType: self!

isAlphaNumeric
	"Answer whether the receiver is a letter or a digit."

	"Implementation Note: The ANSI NCITS 319-1998 defines this as (self isLetter|self isDigit), and therefore it can include any letters, not just the ASCII letters. See #isLetter for the current limitations in Dolphin with respect to recognition of some Unicode letters outside the BMP."

	^self isLetter or: [self isDigit]!

isAscii
	"Answer whether the receiver is an ascii character"

	^code <= 16r7F!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that
	represents its value."

	"Byte characters are atomic"

	^code <= 255!

isCharacter
	"Answer whether the receiver conforms to the <Character> protocol."

	^true!

isControl
	"Answer whether the receiver is a control character. Note that this also includes newlines, tabs, etc, but not space."

	"Implementation Note: Again there are various slightly different ways to perform this query in ICU. Not 100% clear which is most consistent set yet."

	^false
		ifTrue: 
			["Doesn't include formatting marks, or even BOM"
			(OS.ICU u_charType: self) == U_CONTROL_CHAR]
		ifFalse: 
			["One of the following:
				- ISO 8-bit control character (U+0000..U+001f and U+007f..U+009f)
				- U_CONTROL_CHAR (Cc)
				- U_FORMAT_CHAR (Cf)
				- U_LINE_SEPARATOR (Zl)
				- U_PARAGRAPH_SEPARATOR (Zp)"
			OS.ICU u_iscntrl: self]!

isDigit
	"Answer whether the receiver is one of the ASCII representations of a decimal-digit character (i.e. it is one of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9). This is as defined in ANSI NCITS 319-1998. Unlike #isLetter, the implementation cannot define additional characters for which #isDigit is true, so this does not correspond to the Unicode Decimal Number general category, and will not include any decimal digits except the ASCII decimals."

	^code >= ##($0 codePoint) and: [code <= ##($9 codePoint)]!

isEnglishLetter
	"Answer whether the receiver is a letter from the English alphabet, i.e. [a-zA-Z]."

	^code >= ##($a asciiValue)
		ifTrue: [code <= ##($z asciiValue)]
		ifFalse: [code >= ##($A asciiValue) and: [code <= ##($Z asciiValue)]]!

isGraph
	"Answer whether the receiver is a printable character, other than blanks. See also #isPrintable"

	^(OS.ICU u_isgraph: self)
!

isHexDigit
	"Answer whether the receiver is a valid Smalltalk hexadecimal digit (i.e. digits and the uppercase characters A through F)."

	^code >= $A codePoint ifTrue: [code <= $F codePoint] ifFalse: [self isDigit]!

isLetter
	"Answer whether the receiver is an alphabetic character."

	"Implementation Note: The ANSI NCITS 319-1998 specifies that this at least includes the letters of the English alphabet (upper and lowercase), but that implementations may consider other Characters to be letters. In Dolphin 8 it is intended that this answer true for all Characters with Unicode codepoints in one of the letter (L) general categories. To escape the inadequacies of the underlying Windows API (which cannot handle any letters defined outside the Unicode BMP, and which seems to have some incorrect classifications even with in the BMP, e.g. it classifies the Thai Maitaikhu non-spacing mark as a letter, but does not classify ꟹ as one), we now use ICU."

	#todo.	"Decide between alternates."
	^false
		ifTrue: [OS.ICU u_hasBinaryProperty: self which: UCHAR_ALPHABETIC	"u_isUAlphabetic is directly equivalent"]
		ifFalse: [OS.ICU u_isalpha: self]!

isLinefeed
	"Answer whether the receiver is the line-feed character."

	^self == $\n!

isLiteral
	"Answer whether the receiver has a literal representation which is directly recognised by
	the Compiler."

	"In Dolphin this is always true because we have an escaped code point literal form."

	^true!

isLowercase
	"Answer whether the receiver is a lowercase letter."

	"Implementation Note: The ANSI NCITS 319-1998 specifies that this at least includes the lowercase letters of the English alphabet, but that implementations may consider other Characters to be lowercase letters. In Dolphin it is intended that this answer true for all Characters with Unicode codepoints in one of the Lowercase Letter (Ll) general category. To escape the inadequacies of the underlying Windows API (which cannot handle any letters defined outside the Unicode BMP, and which seems to have some incorrect classifications even within the BMP), we now use ICU."

	^(OS.ICU u_charType: self) == U_LOWERCASE_LETTER!

isLowerCase
	"Answer whether the receiver is a lowercase letter."

	^self isLowercase!

isPrintable
	"Answer whether the receiver is a printable character - everything except pure control characters."

	^self isControl not or: [self isWhitespace]!

isPrivateUse
	"Answer whether the receiver has a codepoint in one of the private use areas."

	^self icuType == U_PRIVATE_USE_CHAR!

isPunctuation
	"Answer whether the receiver is a punctuation character."

	"Implementation Note: It is intended that this answer true for all Characters with Unicode codepoints in one of general Punctuation (P) categories.  To escape the inadequacies of the underlying Windows API (which cannot handle any letters defined outside the Unicode BMP, and which seems to have some incorrect classifications even within the BMP), we now use ICU."

	^(OS.ICU u_ispunct: self)!

isSeparator
	"Answer whether the receiver is an ASCII separator character (i.e. whitespace)."

	^code == 32 or: [code <= 13 and: [code >= 9]]!

isSurrogate
	"Answer whether the receiver is a leading or trailing code unit of a multi-code unit code-point in it's encoding."

	^self isUtf16Surrogate or: [self isUtf8Surrogate]!

isTrailSurrogate
	"Answer whether the receiver is a trail surrogate (trailing code-unit of multi-unit code point)."

	^self isUtf8Trail or: [self isUtf16Trail]!

isUppercase
	"Answer whether the receiver is an uppercase letter."

	"Implementation Note: The ANSI NCITS 319-1998 specifies that this at least includes the uppercase letters of the English alphabet, but that implementations may consider other Characters to be uppercase letters. In Dolphin it is intended that this answer true for all Characters with Unicode codepoints in one of the Uppercase Letter (Lu) general category. To escape the inadequacies of the underlying Windows API (which cannot handle any letters defined outside the Unicode BMP, and which seems to have some incorrect classifications even within the BMP), we now use ICU."

	^(OS.ICU u_charType: self) == OS.ICUConstants.U_UPPERCASE_LETTER!

isUpperCase
	"Answer whether the receiver is an uppercase letter."

	^self isUppercase
!

isUtf16Lead
	"Answer whether the receiver is a UTF-16 lead surrogate (leading code unit of two part character)."

	^(code bitAnd: ##(EncodingMask | Utf16SurrogateMask)) == ##(Utf16Mask | Utf16LeadMask)!

isUtf16Surrogate
	"Answer whether the receiver is a UTF-16 surrogate (partial character)."

	^(code bitAnd: ##(EncodingMask | 16rF800)) == ##(Utf16Mask | Utf16LeadMask)!

isUtf16Trail
	"Answer whether the receiver is a UTF-16 trail surrogate (trailing code-unit of two-part code point)."

	^(code bitAnd: ##(EncodingMask | Utf16SurrogateMask)) == ##(Utf16Mask | Utf16TrailMask)!

isUtf8
	"Answer whether the receiver is a valid UTF-8 code unit. This is true for any ASCII character, or any UTF-8 surrogate."

	^code <= 16r7F or: [(code bitAnd: EncodingMask) == Utf8Mask]!

isUtf8Lead
	"Answer whether the receiver represents a UTF-8 leading byte."

	^(code bitAnd: ##(EncodingMask | Utf8SurrogateMask)) == ##(Utf8Mask | 16rC0)!

isUtf8Surrogate
	"Answer whether the receiver represents a UTF-8 surrogate (partial character)."

	^(code bitAnd: ##(EncodingMask | 16r80)) == ##(Utf8Mask | 16r80)!

isUtf8Trail
	"Answer whether the receiver represents a UTF-8 trailing byte."

	^(code bitAnd: ##(EncodingMask | Utf8SurrogateMask)) == ##(Utf8Mask | 16r80)!

isVowel
	"Answer whether the receiver is an English vowel (a, e, i, o, or u), upper or lowercase."

	^'aAeEiIoOuU' identityIncludes: self!

isWhitespace
	"Answer whether the receiver represents a Unicode codepoint classified in one of the Separator (Z) general categories. See also #isSeparator, which for reasons of backwards compatibility only acknowledges the ASCII whitespace characters."

	"Implementation Note: It is intended that this answer true for all Characters with Unicode codepoints in one of general Separator (Z) categories. To escape the inadequacies of the underlying Windows API (which cannot handle any letters defined outside the Unicode BMP, and which seems to have some incorrect classifications even within the BMP), we now use one of the queries (there are a few) in ICU.

	There are several ICU whitespace functions:
		- u_isUWhiteSpace=UCHAR_WHITE_SPACE: Unicode White_Space property;
			most of general categories 'Z' (separators) + most whitespace ISO controls (including no-break spaces, but excluding IS1..IS4)
		- u_isWhitespace: Java isWhitespace; Z + whitespace ISO controls but excluding no-break spaces
		- u_isJavaSpaceChar: Java isSpaceChar; just Z (including no-break spaces)
		- u_isspace: Z + whitespace ISO controls (including no-break spaces)
		- u_isblank: 'horizontal spaces' = TAB + Zs
	
	u_isUWhitespace (or the exactly equivalent binary property query as here) seems best for our purposes.
	"

	^OS.ICU u_hasBinaryProperty: self which: UCHAR_WHITE_SPACE!

join: aCollection
	"Answer a new <String> composed from the displayStrings of elements of the <collection> argument, separated by the instances of the receiver."

	| stream |
	stream := String writeStream: aCollection size * 6.
	aCollection do: [:each | each displayOn: stream] separatedBy: [stream nextPut: self].
	^stream grabContents!

printEscapedOn: aStream
	"Append the escaped literal representation of the receiver to the <puttableStream> argument."

	| codePoint |
	aStream nextPutAll: '$\'.
	(EscapeChars lookup: (codePoint := self codePoint) + 1)
		ifNil: 
			[aStream nextPut: $x.
			codePoint
				printOn: aStream
				base: 16
				showRadix: false]
		ifNotNil: [:char | aStream nextPut: char]!

printOn: aStream
	"Append the literal representation of the receiver to the <puttableStream> argument."

	(self isGraph and: [self isPrivateUse not and: [code ~~ ##(Replacement code)]])
		ifTrue: 
			[aStream
				nextPut: $$;
				nextPut: self]
		ifFalse: [self printEscapedOn: aStream]!

setCode: anInteger
	code := anInteger!

shallowCopy
	"Answer the receiver, as Characters are immutable."

	^self!

split: aReadableString
	"Answer the sub-strings of the <readableString> argument separated by the receiver."

	"Implementation Note: Although this routine is rather more complex than it need be, the performance of #subStrings(:) is important, so it pays to optimize this routine. In particular we try to avoid performing any work in the common cases where the string is either empty, or does not contain the separator at all. However, we must be careful not to over optimize and prevent correct operation for wide (Unicode) strings."

	| start end size answer codeUnits |
	size := aReadableString size.
	size == 0 ifTrue: [^#()].
	end := aReadableString
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{aReadableString}].
	answer := WriteStream on: (Array new: 5).
	start := 1.
	codeUnits := aReadableString encodedSizeOf: self.
	
	[answer nextPut: (aReadableString copyFrom: start to: end - 1).
	end := aReadableString
				nextIndexOf: self
				from: (start := end + codeUnits)
				to: size.
	end == 0]
			whileFalse.
	"Copy any remaining chars after the last separator"
	answer nextPut: (aReadableString copyFrom: start to: size).
	^answer contents!

split: aReadableString do: aMonadicValuable
	"Evaluate the <monadicValuable> 2nd argument for each of the sub-strings of the <readableString> 1st argument that are separated by the receiver."

	| start size end codeUnits |
	size := aReadableString size.
	end := aReadableString
				nextIndexOf: self
				from: 1
				to: size.
	end == 0
		ifTrue: 
			[aMonadicValuable value: aReadableString.
			^self].
	start := 1.
	codeUnits := aReadableString encodedSizeOf: self.
	
	[aMonadicValuable value: (aReadableString copyFrom: start to: end - 1).
	start := end + codeUnits.
	end := aReadableString
				nextIndexOf: self
				from: start
				to: size.
	end == 0]
			whileFalse.
	"Evaluate for any remaining chars after the last separator"
	aMonadicValuable value: (aReadableString copyFrom: start to: size)!

to: aCharacter
	"Answer a <sequencedReadableCollection> of <Character>s for each of the Unicode code points between the receiver's code point and that of the <Character> argument, aCharacter."

	^(self codePoint to: aCharacter codePoint) collect: [:each | Character basicCodePoint: each]!

unicodeName: anInteger
	^OS.ICU u_charName: self nameChoice: anInteger! !
!Core.Character categoriesForMethods!
_beginsString:!comparing!double dispatch!private! !
_separateSubStringsIn:!private!tokenizing! !
<!comparing!public! !
<==>!comparing!public! !
<=>!comparing!public! !
=!comparing!public! !
>!comparing!public! !
ansiValue!accessing!public! !
asAnsiString!converting!public! !
asciiValue!accessing!public! !
asInteger!converting!public! !
asLowercase!converting!public! !
asString!converting!public! !
asSymbol!converting!public! !
asUppercase!converting!public! !
asUtf16String!converting!public! !
asUtf8String!converting!public! !
basicEncoding!accessing!private! !
basicShallowCopy!copying!public! !
caseFolded!converting!public! !
caseFolded:!converting!public! !
code!accessing!private! !
codePoint!accessing!public! !
codePointString!printing!public! !
codeUnit!accessing!public! !
deepCopy!copying!public! !
digitValue!accessing!public! !
displayOn:!printing!public! !
encoding!accessing!public! !
greaterOrEqualToInteger:!public! !
hash!comparing!public! !
icuType!public!testing! !
isAlphaNumeric!public!testing! !
isAscii!public!testing! !
isAtomic!public!testing! !
isCharacter!public!testing! !
isControl!public!testing! !
isDigit!public!testing! !
isEnglishLetter!public!testing! !
isGraph!public!testing! !
isHexDigit!public!testing! !
isLetter!public!testing! !
isLinefeed!public!testing! !
isLiteral!public!testing! !
isLowercase!public!testing! !
isLowerCase!public!testing! !
isPrintable!public!testing! !
isPrivateUse!public!testing! !
isPunctuation!public!testing! !
isSeparator!public!testing! !
isSurrogate!public!testing! !
isTrailSurrogate!public!testing! !
isUppercase!public!testing! !
isUpperCase!public!testing! !
isUtf16Lead!public!testing! !
isUtf16Surrogate!public!testing! !
isUtf16Trail!public!testing! !
isUtf8!public!testing! !
isUtf8Lead!public!testing! !
isUtf8Surrogate!public!testing! !
isUtf8Trail!public!testing! !
isVowel!public!testing! !
isWhitespace!public!testing! !
join:!public!tokenizing! !
printEscapedOn:!printing!public! !
printOn:!printing!public! !
setCode:!accessing!initializing!private! !
shallowCopy!copying!public! !
split:!public!tokenizing! !
split:do:!public!tokenizing! !
to:!converting!public! !
unicodeName:!public! !
!

Core.Character methodProtocol: #Character attributes: #(#ansi #readOnly) selectors: #(#asLowercase #asString #asUppercase #codePoint #isAlphaNumeric #isDigit #isLetter #isLowercase #isUppercase)!

!Core.Character class methodsFor!

ansiValue: anInteger
	^(CharacterSet lookup: anInteger + 1)
		ifNil: [self error: 'Invalid ANSI code unit: ' , anInteger printString]!

asciiValue: anInteger
	^(anInteger >= 0 and: [anInteger <= 127])
		ifTrue: [CharacterSet at: anInteger + 1]
		ifFalse: [self error: 'Invalid ASCII code point: ' , anInteger printString]!

backspace
	"Answer the backspace control <Character>."

	^$\b
!

basicCodePoint: anInteger
	"Private - Answer a <Character> representing the specified <integer> Unicode code point.
	Raise an error if the argument is not a valid Unicode code point."

	^anInteger <= 16r7F
		ifTrue: [CharacterSet at: anInteger + 1]
		ifFalse: 
			[(AnsiCharacters lookup: anInteger)
				ifNil: 
					[(self newCode: (Utf32Mask bitOr: anInteger))
						isImmutable: true;
						yourself]]!

basicUtf32Value: anInteger
	^(self newCode: (Utf32Mask bitOr: anInteger))
		isImmutable: true;
		yourself!

byteCharacterSet
	"Answer the ANSI character set, i.e. the complete set of Characters that can be encoded in an <AnsiString>."

	^CharacterSet!

codePoint: anInteger
	"Answer a <Character> representing the specified <integer> Unicode code point.
	Raise an error if the argument is not a valid Unicode code point."

	^self codePoint: anInteger
		ifInvalid: 
			["This block is deliberately clean to avoid block copy overhead"
			InvalidArgumentError signal: 'Unicode character code point expected' with: 'anInteger']!

codePoint: anInteger ifInvalid: exceptionHandler
	"Answer a <Character> representing the specified <integer> Unicode code point, or the result of evaluating the <niladicValuable>, exceptionHandler, if the code point is not the code point of a valid Unicode character."

	^anInteger <= 16r7F
		ifTrue: [CharacterSet at: anInteger + 1 ifAbsent: exceptionHandler]
		ifFalse: 
			[(AnsiCharacters lookup: anInteger)
				ifNil: 
					[(self isValidCodePoint: anInteger)
						ifTrue: [self basicUtf32Value: anInteger]
						ifFalse: [exceptionHandler value]]]!

cr
	"Answer the carriage return control <Character>."

	^$\r!

digitValue: anInteger
	"Answer the <Character> that represents the specified digit. 0-9 map to $0-$9, 10-35 map to
	$A-$Z. If anInteger is not in the range 0..35, then the String #at: will fail with a bounds
	error."

	^'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: anInteger+1!

dolphin
	"Answer a <Character> representing the Dolphin symbol, i.e. Unicode code point U+1F42C."

	"Like most symbolic code points, this is outside the basic multi-lingual plane, and so requires
	multi-part UTF encodings (4x 8-bit code units in UTF-8 and 2x 16-bit code units in UTF-16),
	making it useful for testing."

	^$\x1F42C!

eof
	"Answer the EOF (Ctrl+Z) control <Character>.
	DOS interprets this character as marking the end of a file."

	^$\x1A!

esc
	"Answer the escape control <Character>."

	^$\x1B!

euro
	"Answer a <Character> representing the Euro currency symbol, €"

	^$\x20AC!

initialize
	self addClassConstant: 'CharacterSet'
		value: ((AnsiString fromByteArray: (0 to: 255) asByteArray)
				isImmutable: true;
				yourself).
	self addClassConstant: 'EscapeChars'
		value: ((Array new: 14)
				at: 0 + 1 put: $0;
				at: 7 + 1 put: $a;
				at: 8 + 1 put: $b;
				at: 9 + 1 put: $t;
				at: 10 + 1 put: $n;
				at: 11 + 1 put: $v;
				at: 12 + 1 put: $f;
				at: 13 + 1 put: $r;
				yourself).
	self addClassConstant: 'Utf8Mask' value: String.EncodingUtf8 << 24.
	self addClassConstant: 'Utf16Mask' value: String.EncodingUtf16 << 24.
	self addClassConstant: 'Utf32Mask' value: String.EncodingUtf32 << 24.
	self addClassConstant: 'EncodingMask' value: 2r111111 << 24!

isNonCharCodePoint: anInteger
	"Answer whether the <integer> argument represents a non-character Unicode code point"

	^anInteger >= 16rFDD0
		and: [anInteger <= 16rFDEF or: [(anInteger allMask: 16rFFFE) and: [anInteger <= UCHAR_MAX_VALUE]]]!

isValidCodePoint: anInteger
	"Answer whether the <integer> argument represents a valid Unicode code point AND is not a code point reserved for surrogate code units AND is not a 'non-character' (i.e. non-characters are valid code points, but 'reserved for internal use')."

	^anInteger >= 0 and: 
			[anInteger < Character.Utf16LeadMask or: 
					[anInteger > 16rDFFF and: 
							[anInteger <= OS.ICUConstants.UCHAR_MAX_VALUE and: 
									[(anInteger >= 16rFDD0 and: [anInteger <= 16rFDEF or: [(anInteger bitAnd: 16rFFFE) == 16rFFFE]]) not]]]]!

isValidUtf16CodeUnit: anInteger
	"Answer whether the <integer> argument is a valid as a code unit in the UTF-16 encoding."

	^anInteger >= 0 and: 
			[anInteger < Character.Utf16LeadMask or: 
					[(anInteger bitAnd: 16rF800) == Character.Utf16LeadMask or: 
							[anInteger < 16rFDD0
								or: [anInteger > 16rFDEF and: [anInteger <= UCHAR_MAX_VALUE and: [(anInteger allMask: 16rFFFE) not]]]]]]!

lf
	"Answer the linefeed control <Character>."

	^$\n!

new
	"Characters should not be instantiated directly; they can be created by literal references,
	by extraction from Strings, or from an <integer> code point."

	^self shouldNotImplement!

newCode: anInteger
	"Private - Answer a new instance of the receiver with the specified code. This should only be used for code points > 128."

	<primitive: 157>
	^self basicNew setCode: anInteger!

newPage
	"Answer the new page control <Character>."

	^$\f!

nl
	"Answer the new line control <Character> (synonym for lf)"

	^$\n!

null
	"Answer the NULL control character"

	^$\0!

onStartup
	| utf ansiCharacters |
	AnsiCodePage := (VM getProcAddress: 'AnsiCodePage' ifAbsent: [#[0 0 0 0]]) uint32AtOffset: 0.
	utf := self byteCharacterSet asUtf16String.
	AnsiCodePoints := ((0 to: utf size * 2 - 1 by: 2) collect: [:each | utf uint16AtOffset: each])
				isImmutable: true;
				yourself.
	#todo.	"Integers from 0 to 255 with a few gaps substituted by large values do not make for good hash distribution, so make the table larger than normal until #766 is fixed."
	ansiCharacters := IdentityDictionary new: 513.
	self byteCharacterSet do: [:each | ansiCharacters at: each codePoint put: each].
	ansiCharacters isImmutable: true.
	AnsiCharacters := ansiCharacters!

replacement
	"Answer the Unicode replacement <Character>, used to substitute for invalid code points and encodings."

	^Replacement!

space
	"Answer the space <Character>."

	^$\x20!

tab
	"Answer the tab control <Character>."

	^$\t!

utf16Value: anInteger
	"Answer a <Character> (which may be a surrogate) representing the <integer> UTF-16 code unit, anInteger.
	If the argument is not a valid UTF-16 code unit then an error is raised."

	^self utf16Value: anInteger
		ifInvalid: [InvalidArgumentError signal: 'UTF-16 code unit expected' with: 'anInteger']!

utf16Value: anInteger ifInvalid: exceptionHandler
	"Answer a <Character> (which may be a surrogate) representing the <integer> UTF-16 code unit, anInteger, or the result of evaluating the <monadicBlock>, exceptionHandler, if the code unit is not valid."

	^anInteger <= 16r7F
		ifTrue: 
			["Ascii"
			CharacterSet at: anInteger + 1 ifAbsent: exceptionHandler]
		ifFalse: 
			[(AnsiCharacters lookup: anInteger)
				ifNil: 
					[(anInteger bitAnd: 16rF800) == Character.Utf16LeadMask
						ifTrue: 
							["Surrogate"
							self newCode: (Utf16Mask bitOr: anInteger)]
						ifFalse: 
							[(anInteger <= UCHAR_MAX_VALUE
								and: [anInteger < 16rFDD0 or: [anInteger > 16rFDEF and: [(anInteger allMask: 16rFFFE) not]]])
									ifTrue: 
										["Valid non-ascii/non-ansi code point"
										self newCode: (Utf32Mask bitOr: anInteger)]
									ifFalse: [exceptionHandler value]]]]!

utf8Value: anInteger
	"Answer a <Character> representing the <integer> UTF-8 code unit, anInteger.
	Note that the resulting Character may not represent a valid Unicode code point."

	^anInteger <= 16r7F
		ifTrue: 
			["Ascii"
			CharacterSet at: anInteger + 1]
		ifFalse: 
			[anInteger <= 16rFF
				ifTrue: 
					["Some kind of surrogate"
					self newCode: (Utf8Mask bitOr: anInteger)]
				ifFalse: [self error: 'Invalid UTF-8 code unit: ' , anInteger printString]]!

value: anInteger
	"Answer a <Character> representing the specified <integer> Unicode code point.
	Raise an error if the argument is not a valid Unicode character code point."

	^self codePoint: anInteger! !
!Core.Character class categoriesForMethods!
ansiValue:!instance creation!public! !
asciiValue:!instance creation!public! !
backspace!constants!public! !
basicCodePoint:!instance creation!private! !
basicUtf32Value:!instance creation!private! !
byteCharacterSet!constants!public! !
codePoint:!instance creation!public! !
codePoint:ifInvalid:!instance creation!public! !
cr!constants!public! !
digitValue:!instance creation!public! !
dolphin!constants!public! !
eof!constants!public! !
esc!constants!public! !
euro!constants!public! !
initialize!development!initializing!public! !
isNonCharCodePoint:!enquiries!public! !
isValidCodePoint:!enquiries!public! !
isValidUtf16CodeUnit:!enquiries!public! !
lf!constants!public! !
new!instance creation!public! !
newCode:!instance creation!private! !
newPage!constants!public! !
nl!constants!public! !
null!constants!public! !
onStartup!event handling!public! !
replacement!constants!public! !
space!constants!public! !
tab!constants!public! !
utf16Value:!instance creation!public! !
utf16Value:ifInvalid:!instance creation!public! !
utf8Value:!instance creation!public! !
value:!instance creation!public! !
!

Core.Character class methodProtocol: #'Character factory' attributes: #(#ansi #readOnly) selectors: #(#codePoint: #cr #lf #space #tab)!

