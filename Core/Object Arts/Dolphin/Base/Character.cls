"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Character
	instanceVariableNames: 'codePoint'
	classVariableNames: 'CharacterSet EscapeChars'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Character guid: (GUID fromString: '{87b4c651-026e-11d3-9fd7-00a0cc3e4a32}')!
Character addClassConstant: 'EscapeChars' value: #($0 nil nil nil nil nil nil $a $b $t $n $v $f $r)!
Character comment: 'Character is the class of objects which serve as the elemental values of Smalltalk Strings. Each Character instance represents a specific Unicode code point. The instances for the first 256 code points are unique. Smalltalk characters have a literal syntax which is the $ symbol followed by the normal printed representation of the character. Dolphin also supports the following escaped literal formats to provide a literal representation of any character:
	$\0	- Null
	$\a	- Bell
	$\b	- Backspace
	$\t	- Tab
	$\n	- Newline
	$\v	- Vertical tab
	$\f	- Form Feed
	$\r	- Carriage return
	$\x<HHHH> - where <HHHH> is the hex representation of the character''s code point - can be used to represent any character.

At present only byte characters (that are not control characters) have a printable representation, at least within the IDE.
'!
!Character categoriesForClass!Magnitude-General! !
!Character methodsFor!

_beginsString: aString 
	^aString first == self!

_separateSubStringsIn: tokens
	"Private - Answer the sub-strings of the <readableString> argument
	 separated by the receiver.
	Implementation Note: Although this routine is rather more complex than
	it need be, the performance of #subStrings(:) is important, so it pays
	to optimize this routine. In particular we try to avoid performing any
	work in the common cases where the string is either empty, or does not
	contain the separator at all. However, we must be careful not to over 
	optimize and prevent correct operation for wide (Unicode) strings."

	| start answer size end |
	size := tokens size.
	size == 0 ifTrue: [^Array new].
	end := tokens
				nextIndexOf: self
				from: 1
				to: size.
	end == 0 ifTrue: [^{tokens}].
	answer := Array writeStream: 5.
	start := 1.
	
	[answer nextPut: (tokens copyFrom: start to: end - 1).
	start := end + 1.
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

	^self asInteger < aCharacter asInteger
!

= comperand
	"Answer whether the receiver is the sames as the parameter, comperand.
	There is a unique Character instance for each possible byte-character value,
	but the instances are not unique for codepoints > 255."

	^self == comperand or: [comperand class == Character and: [comperand codePoint == self codePoint]]!

> aCharacter
	"Answer whether the receiver is greater than the parameter aCharacter."

	^self asInteger > aCharacter asInteger
!

appendToStream: puttableStream
	"Private - Append the receiver's elements to the argument, puttableStream.
	Answer the receiver.
	Implementation note: Double dispatched from streams."

	puttableStream nextPut: self!

asAnsiString
	"Answer a new <String> whose sole element is the receiver. Assumes that the receiver represents an ANSI code point."

	^String with: self!

asInteger
	"Answer the <integer> character encoding (i.e. the Unicode code point) that the receiver
	represents."

	^codePoint!

asLowercase
	"Answer a <Character> which is the lowercase equivalent of the receiver.
	If the receiver is already lowercase, then answer the receiver unchanged.
	Implementation Note: Apart from the ANSI asLowercase character mappings
	(basically all the uppercase letters are mapped to lowercase letters), this
	implementation will map other characters, depending on the configured
	locale of the host OS."

	^self class codePoint: (UserLibrary default charLower: self)!

asString
	"Answer a new <String> whose sole element is the receiver. Assumes that the receiver represents an ANSI code point."

	^String with: self
!

asSymbol
	"Answer the Symbol representation of the receiver."

	^Symbol internCharacter: self!

asUppercase
	"Answer a <Character> which is the uppercase equivalent of the receiver.
	If the receiver is already uppercase, then answer the receiver unchanged.
	Implementation Note: Apart from the ANSI asUppercase character mappings
	(basically all the lowercase letters are mapped to uppercase letters), this
	implementation will map other characters, depending on the configured
	locale of the host OS."

	^self class codePoint: (UserLibrary default charUpper: self)!

asUtf16String
	"Answer a new <String> whose sole element is the receiver. Assumes that the receiver represents an ANSI code point."

	^Utf16String with: self!

asUtf8String
	"Answer a new <Utf8String> encoding the receiver's code point."

	#todo. "Implement this properly to respect the UTF8 encoding - this is a hack until I look it up."
	^Utf8String with: self
!

basicShallowCopy
	"Answer the receiver as Characters are immutable."

	^self!

codePoint
	"Answer the <integer> character encoding (i.e. the Unicode code point) that the receiver
	represents."

	^codePoint!

deepCopy
	"Answer the receiver, as Characters are immutable"

	^self!

digitValue
	"Answer the digit representation of the receiver.
	'digit' is defined as either 0-9, or uppercase A-Z (for 10-35).
	Note: In versions of Dolphin prior to 3.0 this raised an error if the character
	was not a valid digit character, but for compatibility with VW it now returns
	-1. The method is now optimized for improved performance too."

	^codePoint > 127
		ifTrue: [-1]
		ifFalse: 
			[(#[0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 1 2 3 4 5 6 7 8 9 10 0 0 0 0 0 0 0 11 12 13 14 15 16 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 36 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]
				at: codePoint + 1) - 1]!

displayOn: aStream
	"Append the end-user display representation of the receiver to aStream."

	aStream nextPut: self!

hash
	"Answer the <SmallInteger> hash value for the receiver."

	^codePoint!

isAlphaNumeric
	"Answer whether the receiver is a letter or a digit."

	^UserLibrary default isCharAlphaNumeric: self!

isAtomic
	"Answer whether or not the receiver is the single unique instance of its class that
	represents its value."

	"Byte characters are atomic"

	^codePoint <= 255!

isControl
	"Answer whether the receiver is a control character."

	^CRTLibrary default iswcntrl: self!

isDigit
	"Answer whether the receiver is a representation of a decimal-digit character
	(i.e. it is one of $0 $1 $2 $3 $4 $5 $6 $7 $8 $9)."

	^self codePoint >= ##($0 codePoint) and: [self codePoint <= ##($9 codePoint)]!

isEnglishLetter
	"Answer whether the receiver is a letter from the English alphabet."

	^(self between: $a and: $z) or: [self between: $A and: $Z]!

isHexDigit
	"Answer whether the receiver is a valid Smalltalk hexadecimal digit (i.e. digits and the
	uppercase characters A through F)."

	^self isDigit or: [self codePoint >= ##($A codePoint) and: [self codePoint <= ##($F codePoint)]]!

isLetter
	"Answer whether the receiver is an alphabetic character."

	^UserLibrary default isCharAlpha: self
!

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

	^UserLibrary default isCharLower: self!

isLowerCase
	"Answer whether the receiver is a lowercase letter."

	^self isLowercase!

isPrintable
	"Answer whether the receiver is a printable character."

	^CRTLibrary default iswprint: self!

isPunctuation
	"Answer whether the receiver is a punctuation character."

	^CRTLibrary default iswpunct: self!

isSeparator
	"Answer whether the receiver is a separator character (i.e. whitespace)."

	^codePoint == 32 or: [codePoint >= 9 and: [codePoint <= 13]]!

isUppercase
	"Answer whether the receiver is an uppercase letter."

	^UserLibrary default isCharUpper: self!

isUpperCase
	"Answer whether the receiver is an uppercase letter."

	^self isUppercase
!

isVowel
	"Answer whether the receiver is an English vowel (a, e, i, o, or u).
	This test is case insensitive."

	^'aAeEiIoOuU' identityIncludes: self!

isWhitespace
	"Answer whether the receiver is a white space character.
	This is a synonym for #isSeparator as currently defined."

	^self isSeparator!

printOn: aStream
	"Append the literal representation of the receiver to the <puttableStream> argument."

	aStream nextPut: $$.
	(codePoint > 32 and: [codePoint <= 255 and: [codePoint ~= 127]])
		ifTrue: [aStream nextPut: self]
		ifFalse: 
			[aStream nextPut: $\.
			(EscapeChars lookup: codePoint + 1)
				ifNotNil: [:char | aStream nextPut: char]
				ifNil: 
					[aStream nextPut: $x.
					codePoint
						printOn: aStream
						base: 16
						showRadix: false]]!

shallowCopy
	"Answer the receiver, as Characters are immutable."

	^self!

species
	"Answer the 'species' of the receiver.
	Implementation Note: The primitive superclass implementation
	will fail for immediate classes, so we must override here."

	^Character! !
!Character categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!Character categoriesFor: #_separateSubStringsIn:!double dispatch!private! !
!Character categoriesFor: #<!comparing!public! !
!Character categoriesFor: #=!comparing!public! !
!Character categoriesFor: #>!comparing!public! !
!Character categoriesFor: #appendToStream:!double dispatch!private! !
!Character categoriesFor: #asAnsiString!converting!public! !
!Character categoriesFor: #asInteger!converting!public! !
!Character categoriesFor: #asLowercase!converting!public! !
!Character categoriesFor: #asString!converting!public! !
!Character categoriesFor: #asSymbol!converting!public! !
!Character categoriesFor: #asUppercase!converting!public! !
!Character categoriesFor: #asUtf16String!converting!public! !
!Character categoriesFor: #asUtf8String!converting!public! !
!Character categoriesFor: #basicShallowCopy!copying!public! !
!Character categoriesFor: #codePoint!accessing!public! !
!Character categoriesFor: #deepCopy!copying!public! !
!Character categoriesFor: #digitValue!accessing!public! !
!Character categoriesFor: #displayOn:!printing!public! !
!Character categoriesFor: #hash!comparing!public! !
!Character categoriesFor: #isAlphaNumeric!public!testing! !
!Character categoriesFor: #isAtomic!public!testing! !
!Character categoriesFor: #isControl!public!testing! !
!Character categoriesFor: #isDigit!public!testing! !
!Character categoriesFor: #isEnglishLetter!public!testing! !
!Character categoriesFor: #isHexDigit!public!testing! !
!Character categoriesFor: #isLetter!public!testing! !
!Character categoriesFor: #isLinefeed!public!testing! !
!Character categoriesFor: #isLiteral!public!testing! !
!Character categoriesFor: #isLowercase!public!testing! !
!Character categoriesFor: #isLowerCase!public!testing! !
!Character categoriesFor: #isPrintable!public!testing! !
!Character categoriesFor: #isPunctuation!public!testing! !
!Character categoriesFor: #isSeparator!public!testing! !
!Character categoriesFor: #isUppercase!public!testing! !
!Character categoriesFor: #isUpperCase!public!testing! !
!Character categoriesFor: #isVowel!public!testing! !
!Character categoriesFor: #isWhitespace!public!testing! !
!Character categoriesFor: #printOn:!printing!public! !
!Character categoriesFor: #shallowCopy!copying!public! !
!Character categoriesFor: #species!accessing!public! !

Character methodProtocol: #Character attributes: #(#ansi #readOnly) selectors: #(#asLowercase #asString #asUppercase #codePoint #isAlphaNumeric #isDigit #isLetter #isLowercase #isUppercase)!

!Character class methodsFor!

backspace
	"Answer the backspace control <Character>."

	^$\b
!

basicNew
	"Characters should not be instantiated directly; they can be created by literal references,
	by operations on other Characters or Strings, or with the Character>>value: message."

	^self shouldNotImplement!

byteCharacterSet
	"Answer the first 256 characters."

	^CharacterSet!

codePoint: integer
	"Answer an instance of the receiver with the <integer> encoding, integer."

	^self value: integer!

cr
	"Answer the carriage return control <Character>."

	^$\r!

digitValue: anInteger
	"Answer the <Character> that represents the specified digit. 0-9 map to $0-$9, 10-35 map to
	$A-$Z. If anInteger is not in the range 0..35, then the String #at: will fail with a bounds
	error."

	^'0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ' at: anInteger+1!

eof
	"Answer the EOF (Ctrl+Z) control <Character>.
	DOS interprets this character as marking the end of a file."

	^$\x1A!

esc
	"Answer the escape control <Character>."

	^$\x1B!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

initialize
	self addClassConstant: 'CharacterSet' value: CharacterSet.
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
				yourself)!

lf
	"Answer the linefeed control <Character>."

	^$\n!

new
	"Characters should not be instantiated directly; they can be created by literal references,
	by extraction from Strings, or from an <integer> code point."

	^self shouldNotImplement!

newCodePoint: anInteger
	"Private - Answer a new instance of the receiver with the specified code point. This should
	only be used for code points > 255."

	<primitive: 157>
	^self primitiveFailed!

newPage
	"Answer the new page control <Character>."

	^$\f!

nl
	"Answer the new line control <Character> (synonym for lf)"

	^$\n!

null
	"Answer the NULL control character"

	^$\0!

space
	"Answer the space <Character>."

	^$\x20!

tab
	"Answer the tab control <Character>."

	^$\t!

value: anInteger
	"Answer a <Character> representing the specified <integer> Unicode code point."

	^anInteger <= 255
		ifTrue: [CharacterSet at: anInteger + 1]
		ifFalse: 
			[^anInteger < 16r110000
				ifTrue: [(self newCodePoint: anInteger) isImmutable: true]
				ifFalse: [self error: 'Invalid code point ' , anInteger hex]]! !
!Character class categoriesFor: #backspace!constants!public! !
!Character class categoriesFor: #basicNew!instance creation!public! !
!Character class categoriesFor: #byteCharacterSet!constants!public! !
!Character class categoriesFor: #codePoint:!instance creation!public! !
!Character class categoriesFor: #cr!constants!public! !
!Character class categoriesFor: #digitValue:!instance creation!public! !
!Character class categoriesFor: #eof!constants!public! !
!Character class categoriesFor: #esc!constants!public! !
!Character class categoriesFor: #icon!constants!public! !
!Character class categoriesFor: #initialize!development!initializing!public! !
!Character class categoriesFor: #lf!constants!public! !
!Character class categoriesFor: #new!instance creation!public! !
!Character class categoriesFor: #newCodePoint:!instance creation!private! !
!Character class categoriesFor: #newPage!constants!public! !
!Character class categoriesFor: #nl!constants!public! !
!Character class categoriesFor: #null!constants!public! !
!Character class categoriesFor: #space!constants!public! !
!Character class categoriesFor: #tab!constants!public! !
!Character class categoriesFor: #value:!instance creation!public! !

Character class methodProtocol: #'Character factory' attributes: #(#ansi #readOnly) selectors: #(#codePoint: #cr #lf #space #tab)!

