"Filed out from Dolphin Smalltalk"!

Core.Tests.PositionableStreamTest
	subclass: #'Core.Tests.AbstractWriteStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.AbstractWriteStreamTest guid: (Core.GUID fromString: '{d82b7f3f-3e57-4acf-b7a8-b78617675660}')!

Core.Tests.AbstractWriteStreamTest isNonInstantiable: true!

Core.Tests.AbstractWriteStreamTest comment: ''!

!Core.Tests.AbstractWriteStreamTest methodsFor!

newUtf8StreamBufferSize: anInteger
	^self streamOnBuffer: (Utf8String new: anInteger)!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamWith: aString)
		reset;
		yourself!

streamOnBuffer: anObject
	^self streamOn: anObject!

string
	^'a 🐬 test'!

stringSize
	^self string size!

testBasicNext
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.

	"It is an error to attempt to read from a WriteStream"
	self readOperationNotImplemented: [stream basicNext]!

testNext
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	"It is an error to attempt to read from a WriteStream"
	self readOperationNotImplemented: [stream next]!

testNextAvailable
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream nextAvailable]!

testNextAvailableColon
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream nextAvailable: 5]!

testNextColon
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream next: 5]!

testNextInto
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	self readOperationNotImplemented: [stream nextInto: (Array new: 3)]!

testNextWord
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	self readOperationNotImplemented: [stream nextWord]! !

!Core.Tests.AbstractWriteStreamTest categoriesForMethods!
newUtf8StreamBufferSize:!helpers!private!unit tests! !
streamOn:!helpers!private! !
streamOnBuffer:!helpers!private! !
string!constants!private! !
stringSize!constants!private! !
testBasicNext!public!unit tests! !
testNext!public!unit tests! !
testNextAvailable!public!unit tests! !
testNextAvailableColon!public!unit tests! !
testNextColon!public!unit tests! !
testNextInto!public!unit tests! !
testNextWord!public!unit tests! !
!

