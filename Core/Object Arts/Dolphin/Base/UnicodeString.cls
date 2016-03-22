"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #UnicodeString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UnicodeString guid: (GUID fromString: '{87B4C51E-026E-11D3-9FD7-00A0CC3E4A32}')!
UnicodeString isNullTerminated: true!
UnicodeString comment: 'UnicodeString is a minimal class to support wide character (16-bit) Unicode strings. Natively Dolphin uses byte-character strings at present.

UnicodeStrings can be constructed from <String>s when needed by sending the #asUnicodeString message, and converted back again by sending the #asString message.'!
!UnicodeString categoriesForClass!Collections-Text! !
!UnicodeString methodsFor!

asLowercase
	| copy |
	copy := self basicCopy.
	UserLibrary default stringLowerW: copy.
	^copy!

asString
	"Answer a byte string representation of the receiver."

	| buf size bytes |
	size := self size.
	buf := String new: size+size.
	size == 0 ifTrue: [^buf].	"Avoid 'The Parameter is Incorrect' error"
	bytes := KernelLibrary default
		wideCharToMultiByte: 0
		dwFlags: 0
		lpWideCharStr: self
		cchWideChar: size
		lpMultiByteStr: buf
		cchMultiByte: buf size
		lpDefaultChar: nil
		lpUsedDefaultChar: nil.
	bytes == 0 ifTrue: [^KernelLibrary default systemError].
	buf resize: bytes.
	^buf!

asUnicodeString
	"Answer a wide character String representation of the receiver."

	^self!

asUppercase
	| copy |
	copy := self basicCopy.
	UserLibrary default stringUpperW: copy.
	^copy!

at: anInteger
	"Answer the character at index, anInteger, in the receiver."

	| index |
	index := anInteger+anInteger.
	^Character value: (self basicAt: index) * 256 + (self basicAt: index-1)!

at: anInteger put: aCharacter
	"Replace the character at index, anInteger, in the receiver with aCharacter."

	^super at: anInteger+anInteger-1 put: aCharacter!

beginsWith: aCollection
	"Answer whether the receiver begins with the sequence
	of objects in the <Collection> argument."

	^self basicBeginsWith: aCollection!

byteSize
	"Private - Answer the size in bytes of this object, including the null terminator."

	^self basicSize + 2!

displayOn: aStream
	"Append the receiver in end-user form to aStream.
	We must convert to mbcs for display."

	aStream nextPutAll: self asString!

findString: aString startingAt: anInteger 
	"Answer the index of the <String> argument within the receiver, starting at the <integer>
	argument. If the receiver does not contain aString, answer 0."

	| size subSize firstElement |
	subSize := aString size.
	subSize == 0 ifTrue: [^0].
	firstElement := aString at: 1.
	size := self size.
	subSize == 1 
		ifTrue: 
			[^self 
				nextIndexOf: firstElement
				from: anInteger
				to: size].
	anInteger to: size - subSize + 1
		do: 
			[:i | 
			(self at: i) = firstElement 
				ifTrue: 
					[| j |
					j := 2.
					[(self at: i + j - 1) = (aString at: j)] whileTrue: 
							[j = subSize ifTrue: [^i].
							j := j + 1]]].
	^0!

first: anInteger
	"Answer a copy of the receiver comprising the leftmost anInteger elements."

	^self copyFrom: 1 to: anInteger!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the inherited implementation because the byte-character search
	primitives won't work."

	^anElement class == Character 
		ifTrue: [self nextIndexOf: anElement from: start to: stop]
		ifFalse: [0 "Can only contain characters"]!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0."

	self from: start to: stop keysAndValuesDo: [:i :elem | elem = anElement ifTrue: [^i]].
	^0!

replaceFrom: startInteger to: stopInteger with: aReadableString startingAt: startAtInteger 
	"Replace the characters of the receiver at index positions startInteger through stopInteger
	inclusive with consecutive characters of the <readableString>, aReadableString, beginning at
	index position startAtInteger. Answer the receiver."

	| offset |
	offset := startAtInteger - startInteger.
	"Perform overlapping moves backwards, otherwise forwards"
	(self == aReadableString and: [startAtInteger < startInteger]) 
		ifTrue: 
			[stopInteger to: startInteger
				by: -1
				do: [:i | self at: i put: (aReadableString at: offset + i)]]
		ifFalse: [startInteger to: stopInteger do: [:i | self at: i put: (aReadableString at: offset + i)]]!

resize: anInteger
	^super resize: anInteger * 2!

shallowCopy
	"Implemented here to ensure that copied UnicodeStrings are correctly terminated with a double null"

	^UnicodeString fromAddress: self yourAddress length: self size!

size
	"Answer the number of characters in the receiver."

	^self basicSize bitShift: -1!

strcspn: aString start: anInteger 
	^CRTLibrary default wcscspn: self yourAddress + ((anInteger - 1) * 2)
		strCharSet: aString asUnicodeString! !
!UnicodeString categoriesFor: #asLowercase!converting!public! !
!UnicodeString categoriesFor: #asString!converting!public! !
!UnicodeString categoriesFor: #asUnicodeString!converting!public! !
!UnicodeString categoriesFor: #asUppercase!converting!public! !
!UnicodeString categoriesFor: #at:!accessing!public! !
!UnicodeString categoriesFor: #at:put:!accessing!public! !
!UnicodeString categoriesFor: #beginsWith:!comparing!public! !
!UnicodeString categoriesFor: #byteSize!accessing!private! !
!UnicodeString categoriesFor: #displayOn:!printing!public! !
!UnicodeString categoriesFor: #findString:startingAt:!public!searching! !
!UnicodeString categoriesFor: #first:!copying!public! !
!UnicodeString categoriesFor: #nextIdentityIndexOf:from:to:!public!searching! !
!UnicodeString categoriesFor: #nextIndexOf:from:to:!public!searching! !
!UnicodeString categoriesFor: #replaceFrom:to:with:startingAt:!public!replacing! !
!UnicodeString categoriesFor: #resize:!mutating!public! !
!UnicodeString categoriesFor: #shallowCopy!public! !
!UnicodeString categoriesFor: #size!accessing!public! !
!UnicodeString categoriesFor: #strcspn:start:!private!searching! !

!UnicodeString class methodsFor!

elementSize
	"Answer the size of the elements of the receiver in bytes."

	^2!

fromAddress: anAddress
	"Answer a new String instantiated from the null terminated string at anAddress."

	| len |
	len := KernelLibrary default lstrlenW: anAddress.
	^self fromAddress: anAddress length: len!

fromAddress: anAddress length: anInteger
	"Answer a new UnicodeString, of length anInteger, copied from the first anInteger
	characters pointed at by anAddress."

	| answer |
	answer := self new: anInteger.
	anAddress asExternalAddress replaceBytesOf: answer from: 1 to: anInteger*2 startingAt: 1.
	^answer!

fromString: aString
	"Answer a new instance of the receiver containing the same characters as the <String>
	argument.
	Implementation Note: CP_ACP is the only code page supported by Win95."

	| answer |
	answer := self new: aString size.
	(KernelLibrary default 
		multiByteToWideChar: CP_ACP
		dwFlags: 0
		lpMultiByteStr: aString
		cchMultiByte: -1
		lpWideCharStr: answer
		cchWideChar: answer basicSize) == 0 
		ifTrue: [^KernelLibrary default systemError].
	^answer!

new: anInteger
	"Answer an instance of the receiver to accomodate exactly
	anInteger characters (plus a null-term)."

	^super new: anInteger*2!

newFixed: aSmallInteger 
	"Answer an instance of the receiver of size aSmallInteger bytes (this method is 
	only valid for byte objects). The object is allocated from the fixed memory heap
	and will not move in memory (objects allocated with primitive 71 are free to 
	move to assist garbage collection, whereas those allocated with primitive 76 
	are in a traditional fixed heap)."

	^super newFixed: aSmallInteger * 2! !
!UnicodeString class categoriesFor: #elementSize!constants!public! !
!UnicodeString class categoriesFor: #fromAddress:!instance creation!public! !
!UnicodeString class categoriesFor: #fromAddress:length:!instance creation!public! !
!UnicodeString class categoriesFor: #fromString:!instance creation!public! !
!UnicodeString class categoriesFor: #new:!instance creation!public! !
!UnicodeString class categoriesFor: #newFixed:!instance creation!public! !

