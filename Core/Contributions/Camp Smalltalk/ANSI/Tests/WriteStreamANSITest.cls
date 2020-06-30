"Filed out from Dolphin Smalltalk 7"!

SequencedStreamTest subclass: #WriteStreamANSITest
	instanceVariableNames: 'writeStream buffer'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WriteStreamANSITest guid: (GUID fromString: '{ad10f0de-1dd8-4427-b092-0efcb083e330}')!
WriteStreamANSITest comment: ''!
!WriteStreamANSITest categoriesForClass!Unclassified! !
!WriteStreamANSITest methodsFor!

canonicalObject
	^writeStream!

protocol
	^#'WriteStream'!

setUp
	super setUp.
	buffer := 'this is a string' copy.
	writeStream := WriteStream with: buffer!

testXcr
	"5.9.4.1 <puttableStream>#cr"

	| byteStream position |
	position := self canonicalObject position.
	self assertSend: #cr.
	"A sequence of character objects that constitute the implementation-defined end-of-line sequence is added to the receiver in the same manner as if the message #nextPutAll: was sent to the receiver with an argument string whose elements are the sequence of characters."
	self assert: self canonicalObject position equals: position + self endOfLineSequence size.
	self assert: self canonicalObject contents equals: ('this is a string', self endOfLineSequence).
	"It is erroneous if any element of the end-of-line sequence is an object that does not conform to the receiver's sequence value type"
	byteStream := WriteStream on: ByteArray new.
	self value: [byteStream cr] shouldRaise: Error
!

testXnextPutAllX
	| position string |
	position := self canonicalObject position.
	string := 'abc1%ABC'.

	self value: [self canonicalObject nextPutAll: '']
		should: [:r | true "UNSPECIFIED" ]
		conformTo: self protocol selector: #'nextPutAll:'.
	"Has the effect of enumerating the aCollection with the message #do: and adding each element to the receiver with #nextPut:. That is, aCollection do: [:each | receiver nextPut: each]"
	self assert: self canonicalObject position equals: position.
	self assert: self canonicalObject contents equals: 'this is a string'.
	self canonicalObject nextPutAll: string.
	self assert: self canonicalObject position equals: position + string size.
	self assert: self canonicalObject contents equals: 'this is a string', string.

	"It is erroneous if any element of aCollection is an object that does not conform to the receiver's sequence value type."
	self value: [self canonicalObject nextPutAll: #($a 9 $X)]
		shouldRaise: Error.!

testXnextPutX
	| position contents |
	position := self canonicalObject position.
	contents := self canonicalObject contents.
	
	self value: [self canonicalObject nextPut: $a]
		should: [:r | true "UNSPECIFIED" ]
		conformTo: self protocol selector: #'nextPut:'.

	"Appends anObject to the receiver's past sequence values."
	self assert: self canonicalObject position equals: position + 1.
	self assert: self canonicalObject contents equals: (contents copyWith: $a).

	"If the receiver's future sequence values is not empty, removes its first object."
	self canonicalObject position: 0.
	self canonicalObject nextPut: $@.
	self canonicalObject position: position.
	self assert: self canonicalObject contents equals: '@', (contents copyFrom: 2 to: contents size).

	"It is erroneous if anObject is an object that does not conform to the receiver's sequence value type."
	self value: [self canonicalObject nextPut: 9]
		shouldRaise: Error.!

testXspace
	"5.9.4.5 <puttableStream>#space"

	| byteStream position |
	position := self canonicalObject position.
	self assertSend: #space.
	"The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #space is sent to the standard global Character."
	self assert: self canonicalObject position equals: position + 1.
	self assert: self canonicalObject contents equals: ('this is a string' copyWith: Character space).
	"It is erroneous if the tab character is an object that does not conform to the receiver's sequence value type"
	byteStream := WriteStream on: ByteArray new.
	self value: [byteStream space] shouldRaise: Error!

testXtab
	"5.9.4.6 <puttableStream>#tab "

	| byteStream position |
	position := self canonicalObject position.
	self assertSend: #tab.
	"The effect is the same as sending the message #nextPut: to the receiver with an argument that is the object that is the value returned when the message #tab is sent to the standard global Character."
	self assert: self canonicalObject position equals: position + 1.
	self assert: self canonicalObject contents equals: ('this is a string' copyWith: Character tab).
	"It is erroneous if the tab character is an object that does not conform to the receiver's sequence value type"
	byteStream := WriteStream on: ByteArray new.
	self value: [byteStream tab] shouldRaise: Error
	! !
!WriteStreamANSITest categoriesFor: #canonicalObject!public! !
!WriteStreamANSITest categoriesFor: #protocol!public! !
!WriteStreamANSITest categoriesFor: #setUp!public! !
!WriteStreamANSITest categoriesFor: #testXcr!public! !
!WriteStreamANSITest categoriesFor: #testXnextPutAllX!public! !
!WriteStreamANSITest categoriesFor: #testXnextPutX!public! !
!WriteStreamANSITest categoriesFor: #testXspace!public! !
!WriteStreamANSITest categoriesFor: #testXtab!public! !

!WriteStreamANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: PuttableStreamHelper.
	aBlock value: CollectionStreamHelper.
	aBlock value: WriteStreamHelper.! !
!WriteStreamANSITest class categoriesFor: #helperClassesDo:!public! !

