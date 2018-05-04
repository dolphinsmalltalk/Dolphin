"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #AnsiString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AnsiString guid: (GUID fromString: '{5b59aa2a-fc01-4424-95aa-9ffb62e6af03}')!
AnsiString isNullTerminated: true!
AnsiString comment: 'AnsiString is the class of <Strings>s that use a single-byte encoding based on the current ANSI code page (e.g. Windows 1252). "ANSI" is a bit of a misnomer, but is used because it is common parlance in the Windows API documentation for APIs that expect strings encoded with the "ANSI" code page. 

Note that Ansi code pages that require multiple bytes to represent each character are not supported properly in Dolphin.

At present AnsiString is still the default String type, but this will be changing to either Utf8String or Utf16String in future.'!
!AnsiString categoriesForClass!Collections-Text! !
!AnsiString methodsFor!

_beginsString: aString
	^(CRTLibrary default
		strncmp: aString asAnsiString
		string2: self
		count: self size) == 0!

asAnsiString
	"Answer an ANSI encoded string representation of the receiver."

	^self!

asLowercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to lowercase."

	"Implementation Note: The Win32 function converts in place, so we must first create a copy."

	| copy |
	copy := self copy.
	UserLibrary default charLowerBuffA: copy cchLength: copy size.
	^copy!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	"Implementation Note: The Win32 function converts in place, so we need to create a copy
	first."

	| copy |
	copy := self copy.
	UserLibrary default charUpperBuffA: copy cchLength: copy size.
	^copy!

beginsWith: aString ignoreCase: aBoolean
	"Answer whether the receiver starts with the characters of the argument, aString. The
	comparison may be case sensitive or insensitive, depending on the <Boolean> argument. Note
	that unlike #beginsWith:, the comperand must be a <String>."

	^(aBoolean
		ifTrue: 
			[CRTLibrary default
				_strnicmp: self
				string2: aString
				count: aString size]
		ifFalse: 
			[CRTLibrary default
				strncmp: self
				string2: aString
				count: aString size])
			== 0!

copyToBuffer: anAddress ofSize: anInteger
	CRTLibrary default
		strncpy_s: anAddress
		bufferSize: anInteger
		strSource: self
		count: CRTConstants._TRUNCATE!

decodeNextFrom: aReadStream
	"Private - Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^aReadStream basicNextAvailable ifNotNil: [:ch | Character ansiValue: ch]!

encodeOn: aWriteStream put: aCharacter
	"Private - Encode the <Character> argument onto the <WriteStream> argument as a single byte ANSI code unit.
	 An error is raised if the <Character> has code point that is not representable in the ANSI encoding."

	^aWriteStream basicNextPut: aCharacter ansiValue!

first: anInteger
	"Answer a new string comprising the leftmost anInteger code units (ascii characters) of the receiver. "

	"Implementation Note: Rather than implement in terms of the generic #copyFrom:to: method, we
	can take advantage of the fact that this selector is specific to Strings, and implement more
	efficiently."

	^self
		replaceBytesOf: (self species new: anInteger)
		from: 1
		to: anInteger
		startingAt: 1!

includes: aCharacter
	"Answer whether the <Character> argument is one of the elements of the receiver."

	"Implementation Note: Ansi strings can only contain the base character set, all instances of which are unique."

	^self identityIncludes: aCharacter!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	<primitive: 52>
	^self nextIdentityIndexOf: anElement from: start to: stop!

reverse
	"Answer a copy of the receiver but with its elements in reverse order.
	Our Strings are null-terminated, so we can use the CRTLibrary (_strrev()
	works in place, so we must get a copy)."

	| copy |
	copy := self copy.
	CRTLibrary default _strrev: copy.
	^copy!

skipEncodingMarkerFrom: aGettableStream
	"Private - Skip over any encoding marker used for the stream encoding this collection represents on the <gettableStream> argument, which 
	is assumed to be at the start of its sequence."

	"Nothing to do for ANSI strings"

	!

strlen
	"Answer the length of the receiver (in characters) up to the first null terminator. This may
	be less than its size if it contains embedded nulls. It can never be greater than the
	receiver's size."

	^CRTLibrary default strlen: self!

trimNulls
	"Answer a copy of the receiver with trailing nulls removed.
	Take advantage of some private knowledge about the implementation of
	#fromAddress:"

	^self species fromAddress: self yourAddress! !
!AnsiString categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!AnsiString categoriesFor: #asAnsiString!converting!public! !
!AnsiString categoriesFor: #asLowercase!converting!public! !
!AnsiString categoriesFor: #asUppercase!converting!public! !
!AnsiString categoriesFor: #beginsWith:ignoreCase:!comparing!public! !
!AnsiString categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!AnsiString categoriesFor: #decodeNextFrom:!encode/decode!private! !
!AnsiString categoriesFor: #encodeOn:put:!encode/decode!private! !
!AnsiString categoriesFor: #first:!copying!public! !
!AnsiString categoriesFor: #includes:!public!searching! !
!AnsiString categoriesFor: #nextIndexOf:from:to:!public!searching! !
!AnsiString categoriesFor: #reverse!copying!public! !
!AnsiString categoriesFor: #skipEncodingMarkerFrom:!encode/decode!private! !
!AnsiString categoriesFor: #strlen!accessing!private! !
!AnsiString categoriesFor: #trimNulls!copying!public! !

!AnsiString class methodsFor!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^1!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress.
	Implementation note: We can use the external library call primitive to do the 
	job for us by performing a simple nop which returns the original pointer (_strninc()
	has the useful property that it returns NULL for NULL argument too)."

	^VMLibrary default stringFromAddress: anAddress!

fromString: aString
	"Answer an instance of the receiver containing the same characters as the argument, aString."

	^aString asAnsiString!

initialize
	empty := ''.
	VMLibrary default registryAt: #AnsiString put: self.
	self extraInstanceSpec: EncodingAnsi!

with: element1
	^(self new: 1)
		at: 1 put: element1;
		yourself!

with: element1 with: element2
	^(self new: 2)
		at: 1 put: element1;
		at: 2 put: element2;
		yourself!

with: element1 with: element2 with: element3
	^(self new: 3)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		yourself!

with: element1 with: element2 with: element3 with: element4
	^(self new: 4)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		yourself!

with: element1 with: element2 with: element3 with: element4 with: element5
	^(self new: 5)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		at: 5 put: element5;
		yourself!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements."

	| answer |
	answer := self new: newElements size.
	newElements inject: 1 into: [:i :elem | answer at: i put: elem. i + 1].
	^answer! !
!AnsiString class categoriesFor: #elementSize!constants!public! !
!AnsiString class categoriesFor: #fromAddress:!instance creation!public! !
!AnsiString class categoriesFor: #fromString:!instance creation!public! !
!AnsiString class categoriesFor: #initialize!class initialization!development!public! !
!AnsiString class categoriesFor: #with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:with:!instance creation!public! !
!AnsiString class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!AnsiString class categoriesFor: #withAll:!instance creation!public! !

