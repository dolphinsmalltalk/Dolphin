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
!AnsiString categoriesFor: #_beginsString:!comparing!double dispatch!private! !
!AnsiString categoriesFor: #asAnsiString!converting!public! !
!AnsiString categoriesFor: #asLowercase!converting!public! !
!AnsiString categoriesFor: #asUppercase!converting!public! !
!AnsiString categoriesFor: #beginsWith:ignoreCase:!comparing!public! !
!AnsiString categoriesFor: #copyToBuffer:ofSize:!copying!private! !
!AnsiString categoriesFor: #first:!copying!public! !

!AnsiString class methodsFor!

decode: anInteger
	"Answer a <Character> that corresponds to the ANSI code unit, anInteger."

	^Character ansiValue: anInteger!

decodeNextFrom: aReadStream
	"Read the next <Character> in the receiver's encoding from the <ReadStream> argument ."

	^Character ansiValue: aReadStream basicNext!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^1!

encodeOn: aWriteStream put: aCharacter
	"Encode the <Character> argument onto the <WriteStream> argument as a single byte ANSI code unit.
	 An error is raised if the <Character> has code point that is not representable in the ANSI encoding."

	^aWriteStream basicNextPut: aCharacter ansiValue!

initialize
	empty := ''.
	VMLibrary default registryAt: #String put: self.
	self extraInstanceSpec: EncodingAnsi!

skipEncodingMarkerFrom: aGettableStream
	"Skip over any encoding marker used for the stream encoding this collection represents on the <gettableStream> argument, which 
	is assumed to be at the start of its sequence."

	"Nothing to do for ANSI strings"

	! !
!AnsiString class categoriesFor: #decode:!encode/decode!public! !
!AnsiString class categoriesFor: #decodeNextFrom:!encode/decode!public! !
!AnsiString class categoriesFor: #elementSize!constants!public! !
!AnsiString class categoriesFor: #encodeOn:put:!encode/decode!public! !
!AnsiString class categoriesFor: #initialize!class initialization!development!public! !
!AnsiString class categoriesFor: #skipEncodingMarkerFrom:!encode/decode!public! !

