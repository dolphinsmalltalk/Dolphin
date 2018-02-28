"Filed out from Dolphin Smalltalk 7"!

String variableByteSubclass: #UtfEncodedString
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UtfEncodedString guid: (GUID fromString: '{f19f0843-d636-4c39-8815-afe452d16cb0}')!
UtfEncodedString isNullTerminated: true!
UtfEncodedString isAbstract: true!
UtfEncodedString comment: ''!
!UtfEncodedString categoriesForClass!Collections-Text! !
!UtfEncodedString methodsFor!

copyWith: newElement
	"Answer a <sequencedReadableCollection> which is a copy of 
	the receiver that has newElement concatenated to its end."

	^self, (self class with: newElement)! !
!UtfEncodedString categoriesFor: #copyWith:!copying!public! !

!UtfEncodedString class methodsFor!

encode: aCharacter on: aPuttableStream
	^self subclassResponsibility!

new: elementCount withAll: elementValue
	"Answer a new instance of the receiver with <integer>, elementCount, 
	elements, each of which is initialized to the <Object>, elementValue.
	Note that the result will be of size elementCount * codeUnitsFor(elementValue)."

	| stream |
	stream := ByteArray writeStream: elementCount * 2.
	elementCount timesRepeat: [self encode: elementValue on: stream].
	^self fromByteArray: stream contents!

with: element1
	"Answer a new instance of the receiver containing the single 
	<Object> element, element1."

	| stream |
	stream := ByteArray writeStream: 2.
	self encode: element1 on: stream.
	^self fromByteArray: stream contents!

with: element1 with: element2
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements"

	| stream |
	stream := ByteArray writeStream: 4.
	self
		encode: element1 on: stream;
		encode: element2 on: stream.
	^self fromByteArray: stream contents!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	| stream |
	stream := ByteArray writeStream: 6.
	self
		encode: element1 on: stream;
		encode: element2 on: stream;
		encode: element3 on: stream.
	^self fromByteArray: stream contents!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	| stream |
	stream := ByteArray writeStream: 8.
	self
		encode: element1 on: stream;
		encode: element2 on: stream;
		encode: element3 on: stream;
		encode: element4 on: stream.
	^self fromByteArray: stream contents!

with: element1 with: element2 with: element3 with: element4 with: element5
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements.
	N.B. This is not an ANSI standard method (up to 4 elements are supported
	by <Array factory> #with:&c messages, for more one must use #withAll:)."

	| stream |
	stream := ByteArray writeStream: 10.
	self
		encode: element1 on: stream;
		encode: element2 on: stream;
		encode: element3 on: stream;
		encode: element4 on: stream;
		encode: element5 on: stream.
	^self fromByteArray: stream contents!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements."

	| stream |
	stream := ByteArray writeStream: 10.
	newElements do: [:each | self encode: each on: stream].
	^self fromByteArray: stream contents! !
!UtfEncodedString class categoriesFor: #encode:on:!helpers!private! !
!UtfEncodedString class categoriesFor: #new:withAll:!instance creation!public! !
!UtfEncodedString class categoriesFor: #with:!instance creation!public! !
!UtfEncodedString class categoriesFor: #with:with:!instance creation!public! !
!UtfEncodedString class categoriesFor: #with:with:with:!instance creation!public! !
!UtfEncodedString class categoriesFor: #with:with:with:with:!instance creation!public! !
!UtfEncodedString class categoriesFor: #with:with:with:with:with:!instance creation!public! !
!UtfEncodedString class categoriesFor: #withAll:!instance creation!public! !

