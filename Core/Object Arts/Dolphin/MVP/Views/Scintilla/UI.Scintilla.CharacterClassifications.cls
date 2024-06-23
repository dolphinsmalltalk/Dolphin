"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.Scintilla.CharacterClassifications'
	instanceVariableNames: 'classifications'
	classVariableNames: 'AllPossibleWordChars DefaultWhitespaces'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ClassificationNames' -> #(#whitespace #newline #word #punctuation).
			'DefaultClassifications'
				-> #[0 0 0 0 0 0 0 0 0 0 1 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 3 3 3 3 3 3 3 3 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 3 3 3 3 3 3 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 2 3 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 3 3 3 3 0 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2 2].
			'DefaultPunctuation' -> '~}|{`^]\[@?>=<;:/.-,+*)(''&%$#"!!'.
			'DefaultWordChars'
				-> 'zyxwvutsrqponmlkjihgfedcba_ZYXWVUTSRQPONMLKJIHGFEDCBA9876543210'.
			'FoldingMask' -> 16r2.
			'Newline' -> 16r1.
			'Punctuation' -> 16r3.
			'Whitespace' -> 16r0.
			'Word' -> 16r2
		}!

UI.Scintilla.CharacterClassifications guid: (Core.GUID fromString: '{6f39df2d-fc41-4975-ba69-85282d6d74e8}')!

UI.Scintilla.CharacterClassifications comment: '`UI.Scintilla.CharacterClassifications` describes the character classifications for a Scintilla control. The classifications are used to identify word boundaries, which are used for word-oriented selection and cursor movements as well as for finding whole words.

Scintilla has separate API calls for set the word, punctuation and whitespace characters. This is rather awkward and creates ambiguity since the character groups should be mutually exclusive but may not be when specified individually. The APIs also have some inconsistency in the setting of defaults. Setting the word characters through the [SCI_SETWORDCHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_SETWORDCHARS) API also resets the punctuation and whitespace to "defaults", but not the same ones as the initialization defaults from [SCI_SETCHARSDEFAULT](https://www.scintilla.org/ScintillaDoc.html#SCI_SETCHARSDEFAULT). The latter initialization sets all byte characters > 127 to be classified as word characters, but after `SCI_SETWORDCHARS` all characters > 127 are instead classified as punctuation. A more sensible abstraction that avoids inconsistencies and the inherent ambiguity of storing the classifications in multiple settings is to represent the character classifications with a single setting so that overlap is impossible, which is the purpose of this class.

Note that in addition to the word, punctuation and whitespace classification groups, the carriage return and newline characters have a special fixed classification. They are not treated as whitespace for the purposes of the character classification APIs. Also the null character cannot be changed from whitespace. The character is included in the set of whitespace characters returned by SCI_GETWHITESPACECHARS, but is treated as a null-terminator by any of the SCI_SETXXXCHARS APIs, so is effectively fixed at its default setting. This is inherent in the API design of expecting a C-style (null-terminated) string, rather than a character array and size. This is a design flaw in Scintilla, but probably not one that matters very much in practice.

A design flaw of greater consequence is that the classifications are only really available for ASCII characters (0..127). Internally the implementation stores classifications for all byte characters, but the effect of setting classifications for characters in the range (128..255) is not documented, other than the general statement associated with [SCI_GETWORDCHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_GETWORDCHARS): ''For multi-byte encodings, this API will not return meaningful values for 0x80 and above.'' We always use the control in CP_UTF8 mode, and of course UTF-8 is a multi-byte encoding. It isn''t documented nor immediately obvious what behaviour is expected for code points greater 127. From examination of the Scintilla code, the default setting for (128..255) is to treat as punctuation, and empirically it appears to be the case that characters such as © (U+00A9) are treated as word delimiters by default. Of course in UTF-8 any 128.255 code point is actually two code units with the lead surrogate being either 194 or 195. It isn''t clear whether allowing the 128.255 classifications to be changed would work individually, or whether the effect would be that all would be classified per the settings for 194/195. This could be determined by examining the code or empirically, but as undocumented behaviour we would not want to rely on the results remaining stable anyway, especially as the behaviour is not even stable currently given the inconsistency of behaviour between `SCI_SETCHARSDEFAULT` and `SCI_SETWORDCHARS` noted above. At present `CharacterClassifications` does not allow the classification for 128..255 to be changed, but rather ensures that they always remain classified as punctuation, at least eliminating the inconsistency.

We store the classifications as a `ByteArray` of `SmallInteger` values from an enumeration equivalent to the underlying enumeration in the Scintilla code. Should the Scintilla API ever be rationalised down to a single setting, then a reasonable choice would that it expected to be passed a ByteArray of these values, in which case we would not need to change the representation here. That said if the API were ever changed, then the most likely motivation for that would be expand the classification mechanism to support any Unicode code point, in which case some other approach would be necessary.'!

!UI.Scintilla.CharacterClassifications methodsFor!

= anObject
	^self == anObject
		or: [anObject species == self species and: [classifications = anObject classifications]]!

applyToView: aScintillaView
	| punctuation whitespaces |
	self isDefault
		ifTrue: 
			[aScintillaView sciSetCharsDefault.
			^self].
	punctuation := AnsiString writeStream: 31.
	whitespaces := AnsiString writeStream: 32.
	256 to: 1
		by: -1
		do: 
			[:i |
			| charClass |
			charClass := classifications at: i.
			charClass == Whitespace
				ifTrue: [whitespaces basicNextPut: i - 1]
				ifFalse: [charClass == Punctuation ifTrue: [punctuation basicNextPut: i - 1]]].
	aScintillaView
		sciSetWordChars: AllPossibleWordChars;
		sciSetPunctuationChars: punctuation grabContents;
		sciSetWhitespaceChars: whitespaces grabContents!

associations
	^self keys collect: [:ch | ch -> (self at: ch)]!

at: aCharacter
	^ClassificationNames lookup: ((classifications lookup: aCharacter codeUnit + 1) ?? ##(Word - 1)) + 1!

at: aCharacter ifAbsent: aNiladicValuable
	^aCharacter isAscii ifTrue: [self at: aCharacter] ifFalse: [aNiladicValuable value]!

at: aCharacter put: aSymbol
	| charClass |
	charClass := ClassificationNames identityIndexOf: aSymbol.
	charClass == 0 ifTrue: [self error: 'Invalid character classification ' , aSymbol printString].
	classifications at: aCharacter codeUnit + 1 put: charClass - 1.
	^aSymbol!

charsWithClassification: anInteger
	| chars |
	chars := String writeStream: 63.
	"See [SCI_GETWORDCHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_GETWORDCHARS) for why we limit this to ascii"
	128 to: 1
		by: -1
		do: 
			[:i |
			| charClass |
			charClass := classifications at: i.
			charClass == anInteger ifTrue: [chars basicNextPut: i - 1]].
	^chars grabContents!

classifications
	^classifications!

classifications: aByteArray
	classifications := aByteArray.
	^self!

hash
	^classifications hash!

isDefault
	^classifications = DefaultClassifications!

keys
	^##($\0 to: $\x7F)!

punctuation
	"Answer a <String> containing the set of characters considered to be non-whitespace word delimiters. The characters are in reverse code-point order to mimic the behaviour of [SCI_GETPUNCTUATIONCHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_GETPUNCTUATIONCHARS)"

	^self charsWithClassification: Punctuation!

punctuation: aStringOrNil
	"Set the set of characters considered to be non-whitespace word separators. This setting controls word-oriented cursor movements and selections.  If the argument is nil, then the word characters are restored to the [default Scintilla setting](https://www.scintilla.org/ScintillaDoc.html#SCI_SETCHARSDEFAULT)."

	| new old |
	new := aStringOrNil ?? DefaultPunctuation.
	old := self punctuation.
	(new difference: old) do: [:each | classifications at: each codeUnit + 1 put: Punctuation].
	"Any former punctuation is returned its default classification, or Word if is Punctuation by default."
	(old difference: new) do: 
			[:each |
			classifications at: each codeUnit + 1
				put: ((DefaultWhitespaces includes: each) ifTrue: [Whitespace] ifFalse: [Word])].
	self setFixedClassifications!

setFixedClassifications
	"Private - Set the character classifications that cannot be changed."

	"Null must always be Whitespace, cr/lf always Newline"

	classifications
		at: ##($\0 codePoint + 1) put: Whitespace;
		at: ##($\r codePoint + 1) put: Newline;
		at: ##($\n codePoint + 1) put: Newline!

size
	^128!

whitespaces
	"Answer a <String> containing the set of characters considered to be whitespace. The characters are in reverse code-point order to mimic the behaviour of [SCI_SETWHITESPACECHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_SETWHITESPACECHARS)"

	^self charsWithClassification: Whitespace!

whitespaces: aStringOrNil
	"Set the set of characters considered to be whitespace. If the argument is nil, then the word characters are restored to the [default Scintilla setting](https://www.scintilla.org/ScintillaDoc.html#SCI_SETCHARSDEFAULT)."

	| new old |
	new := aStringOrNil ?? DefaultWhitespaces.
	old := self whitespaces.
	(new difference: old) do: [:each | classifications at: each codeUnit + 1 put: Whitespace].
	"Any former whitespace is returned its default classification, or Punctuation if it is Whitespace by default."
	(old difference: new) do: 
			[:each |
			classifications at: each codeUnit + 1
				put: ((DefaultWordChars includes: each) ifTrue: [Word] ifFalse: [Punctuation])].
	self setFixedClassifications!

whitespaces: spacesString punctuation: punctuationString
	classifications := ByteArray new: 256 withAll: Word.
	spacesString do: [:each | classifications at: each codeUnit + 1 put: Whitespace].
	punctuationString do: [:each | classifications at: each codeUnit + 1 put: Punctuation].
	"LF & CR should always be newline classification - setting these to something else has unpredictable effects. Scintilla has an internal classification value for CR/LF that is not accessible through the API, but it doesn't guard against these characters being set to whitespace or punctuation. Also the classification of null can't be changed from whitespace because although Scintilla will return it as one of the classifiable characters, it treats it as a string terminator when trying to set character classes, so any attempt to set it will be ignored (a small Scintilla bug of no real consequence)."
	classifications
		at: ##($\0 codeUnit + 1) put: Whitespace;
		at: ##($\n codeUnit + 1) put: Newline;
		at: ##($\r codeUnit + 1) put: Newline.
	^self!

wordChars
	"Answer a <String> containing the set of characters considered to be those valid as characters in a single word. All other characters are considered to be delimiters (whitespace or punctuation). This setting controls word-oriented cursor movements and selections. The characters are in reverse code-point order to mimic the behaviour of [SCI_GETWORDCHARS](https://www.scintilla.org/ScintillaDoc.html#SCI_GETWORDCHARS)"

	^self charsWithClassification: Word!

wordChars: aStringOrNil
	"Set the set of characters considered to be those valid as characters in a single word. All other characters are considered to be delimiters of some sort. This setting controls word-oriented cursor movements and selections. If the argument is nil, then the word characters are restored to the [default Scintilla setting](https://www.scintilla.org/ScintillaDoc.html#SCI_SETCHARSDEFAULT)."

	| new old |
	new := aStringOrNil ?? DefaultWordChars.
	old := self wordChars.
	(new difference: old) do: [:each | classifications at: each codeUnit + 1 put: Word].
	"Any former word character is returned its default classification, or Punctuation if it is Word by default."
	(old difference: new) do: 
			[:each |
			classifications at: each codeUnit + 1
				put: ((DefaultWhitespaces includes: each) ifTrue: [Whitespace] ifFalse: [Punctuation])].
	self setFixedClassifications! !

!UI.Scintilla.CharacterClassifications categoriesForMethods!
=!comparing!public! !
applyToView:!operations!private! !
associations!accessing!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
charsWithClassification:!helpers!private! !
classifications!accessing!private! !
classifications:!initializing!private! !
hash!comparing!public! !
isDefault!public!testing! !
keys!accessing!public! !
punctuation!accessing!public! !
punctuation:!accessing!public! !
setFixedClassifications!accessing!private! !
size!accessing!public! !
whitespaces!accessing!public! !
whitespaces:!accessing!public! !
whitespaces:punctuation:!initializing!private! !
wordChars!accessing!public! !
wordChars:!accessing!public! !
!

!UI.Scintilla.CharacterClassifications class methodsFor!

icon
	^ScintillaView icon!

initialize
	self addClassConstant: 'DefaultWhitespaces'
		value: (AnsiString
				withAll: #($\x7F $\x20 $\x1F $\x1E $\x1D $\x1C $\x1B $\x1A $\x19 $\x18 $\x17 $\x16 $\x15 $\x14 $\x13 $\x12 $\x11 $\x10 $\xF $\xE $\f $\v $\t $\b $\a $\x6 $\x5 $\x4 $\x3 $\x2 $\x1 $\0)).
	self addClassConstant: 'AllPossibleWordChars'
		value: ((Character byteCharacterSet reverse difference: String lineDelimiter) copyWithout: $\0)!

new
	^self basicNew classifications: DefaultClassifications shallowCopy!

whitespaces: spacesString punctuation: punctuationString
	^self basicNew whitespaces: spacesString punctuation: punctuationString! !

!UI.Scintilla.CharacterClassifications class categoriesForMethods!
icon!constants!development!public! !
initialize!class initialization!public! !
new!instance creation!public! !
whitespaces:punctuation:!instance creation!public! !
!

