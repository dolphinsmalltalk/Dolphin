"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #ByteString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteString guid: (GUID fromString: '{5b59aa2a-fc01-4424-95aa-9ffb62e6af03}')!
ByteString isNullTerminated: true!
ByteString comment: 'ByteString is the class of <Strings>s that use a single-byte encoding based on the current ANSI code page (e.g. Windows 1252). "ANSI" is a bit of a misnomer, but is used because it is common parlance in the Windows API documentation for APIs that expect strings encoded with the "ANSI" code page. 

Note that Ansi code pages that require multiple bytes to represent each character are not supported properly in Dolphin.

At present ByteString is still the default String type, but this will be changing to either Utf8String or Utf16String in future.'!
!ByteString categoriesForClass!Collections-Text! !
!ByteString methodsFor!

_beginsString: aString
	#todo. "Doesn't work for mixed encodings, only both ANSI or both UTF-8"
	^(CRTLibrary default 
		strncmp: aString
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
	copy := self mutableCopy.
	UserLibrary default charLowerBuffA: copy cchLength: copy size.
	^copy!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	"Implementation Note: The Win32 function converts in place, so we need to create a copy
	first."

	| copy |
	copy := self mutableCopy.
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

first: anInteger
	"Answer a new string comprising the leftmost anInteger characters of the receiver. "

	"Implementation Note: Rather than implement in terms of the generic #copyFrom:to: method, we
	can take advantage of the fact that this selector is specific to Strings, and implement more
	efficiently."

	^self
		replaceBytesOf: (self species new: anInteger)
		from: 1
		to: anInteger
		startingAt: 1! !
!ByteString categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!ByteString categoriesFor: #asAnsiString!converting!public! !
!ByteString categoriesFor: #asLowercase!converting!public! !
!ByteString categoriesFor: #asUppercase!converting!public! !
!ByteString categoriesFor: #beginsWith:ignoreCase:!comparing!public! !
!ByteString categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!ByteString categoriesFor: #first:!copying!public! !

!ByteString class methodsFor!

decode: anInteger
	"Answer a <Character> that corresponds to the ANSI code unit, anInteger."

	^Character ansiValue: anInteger!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^1!

encode: aCharacter on: aWriteStream
	"Encode the <Character> argument onto the <WriteStream> argument as a single byte ANSI code unit.
	 An error is raised if the <Character> has code point that is not representable in the ANSI encoding." 

	^aWriteStream basicNextPut: aCharacter ansiValue!

initialize
	empty := ''.
	VMLibrary default registryAt: #String put: self.
	self extraInstanceSpec: EncodingAnsi! !
!ByteString class categoriesFor: #decode:!encode/decode!public! !
!ByteString class categoriesFor: #elementSize!constants!public! !
!ByteString class categoriesFor: #encode:on:!encode/decode!public! !
!ByteString class categoriesFor: #initialize!class initialization!development!public! !

