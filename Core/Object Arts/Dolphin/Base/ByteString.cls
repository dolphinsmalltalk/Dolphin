"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #ByteString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ByteString guid: (GUID fromString: '{5b59aa2a-fc01-4424-95aa-9ffb62e6af03}')!
ByteString isNullTerminated: true!
ByteString comment: 'AnsiString is the class of <Strings>s representing the single byte encoding for the current code page (e.g. Windows 1252). "Ansi" is a bit of a misnomer, but is used because it is common parlance in the Windows API documentation for APIs that expect strings encoded with the "Ansi" code page. 

Note that code pages that require multiple bytes to represent each character are not supported properly in Dolphin.

At present AnsiString is still the default String type, but this will be changing to either Utf8String or Utf16String in future.'!
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
	copy := self basicCopy.
	UserLibrary default stringLowerA: copy.
	^copy!

asUppercase
	"Answer a <readableString> which is a copy of the receiver but with the contents converted
	to uppercase."

	"Implementation Note: The Win32 function converts in place, so we need to create a copy
	first."

	| copy |
	copy := self basicCopy.
	UserLibrary default stringUpperA: copy.
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

ByteString methodProtocol: #readableString attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #asLowercase #asString #asSymbol #asUppercase #at: #at:ifAbsent: #before: #between:and: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #do: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #keysAndValuesDo: #last #max: #min: #reverse #reverseDo: #sameAs: #subStrings: #with:do:)!
ByteString methodProtocol: #String attributes: #(#ansi #readOnly) selectors: #(#, #< #<= #> #>= #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asLowercase #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #asString #asSymbol #asUppercase #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #between:and: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #max: #min: #notEmpty #occurrencesOf: #rehash #reject: #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #sameAs: #select: #size #subStrings: #with:do:)!

!ByteString class methodsFor!

encode: aCharacter on: aPuttableStream
	^aPuttableStream nextBytePut: aCharacter ansiValue!

initialize
	empty := ''.
	VMLibrary default registryAt: #String put: self!

new: aSmallInteger
	<primitive: 71>
	^self primitiveFailed!

newFixed: aSmallInteger
	"Answer an instance of the receiver of size aSmallInteger bytes (this method is 
	only valid for byte objects). The object is allocated from the fixed memory heap
	and will not move in memory (objects allocated with primitive 71 are free to 
	move to assist garbage collection, whereas those allocated with primitive 76 
	are in a traditional fixed heap)."

	<primitive: 76>
	^self primitiveFailed! !
!ByteString class categoriesFor: #encode:on:!helpers!private! !
!ByteString class categoriesFor: #initialize!class initialization!development!public! !
!ByteString class categoriesFor: #new:!instance creation!public! !
!ByteString class categoriesFor: #newFixed:!instance creation!public! !

