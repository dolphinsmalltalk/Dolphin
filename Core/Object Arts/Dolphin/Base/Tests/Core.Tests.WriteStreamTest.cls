"Filed out from Dolphin Smalltalk 7"!

Core.Tests.PositionableStreamTest subclass: #'Core.Tests.WriteStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.WriteStreamTest guid: (Core.GUID fromString: '{9d14176b-5486-40dc-bc22-694add104427}')!
Core.Tests.WriteStreamTest comment: ''!
!Core.Tests.WriteStreamTest categoriesForClass!Unclassified! !
!Core.Tests.WriteStreamTest methodsFor!

streamClass
	^WriteStream!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamWith: aString)
		reset;
		yourself!

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

testContents
	| stream |
	stream := self streamWith: ''.
	self assert: stream contents isEmpty.
	self closeTempStream: stream.
	stream := self streamWith: 'hello'.
	self assert: stream contents equals: 'hello'.
	self closeTempStream: stream!

testNewContents
	| stream contents |
	stream := self streamWith: String new.
	self assert: stream contents isEmpty.
	stream nextPut: $h.
	self assert: stream contents equals: 'h'.
	self closeTempStream: stream.
	stream := self streamWith: 'hel'.
	stream nextPutAll: 'lo'.
	contents := stream contents.
	self assert: contents equals: 'hello'.
	self closeTempStream: stream!

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

testNextColonPutColon
	| stream |
	stream := self newStream.
	stream next: 0 put: $a.
	self assert: stream contents equals: ''.
	stream next: 1 put: $a.
	self assert: stream contents equals: 'a'.
	stream next: 2 put: $b.
	self assert: stream contents equals: 'abb'!

testNextInto
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	self readOperationNotImplemented: [stream nextInto: (Array new: 3)]!

testNextPutAllArray
	| subject array |
	subject := Array writeStream.
	array := #(10 20 30 40 50).
	subject nextPutAll: array.
	self assert: subject contents equals: array!

testNextWord
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	"It is an error to attempt to read from a WriteStream"
	self should: [stream nextWord] raise: Error!

testPeekFor
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	self readOperationNotImplemented: [stream peekFor: $a]!

testSetToEnd
	| string stream |
	string := 'hello'.
	stream := WriteStream with: String new.
	stream nextPutAll: string.
	self assert: stream position equals: string size.
	stream setToEnd.
	self assert: stream position equals: string size.
	self assert: stream contents equals: string!

testUpTo
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream upTo: $a]!

testUpToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	self readOperationNotImplemented: [stream upToAll: 'a']
!

testUpToEnd
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream upToEnd]!

testUpToUtf
	| stream |
	stream := self streamOn: '1£/🐬'.
	self readOperationNotImplemented: [stream upTo: Character dolphin]! !
!Core.Tests.WriteStreamTest categoriesFor: #streamClass!helpers!private! !
!Core.Tests.WriteStreamTest categoriesFor: #streamOn:!helpers!private! !
!Core.Tests.WriteStreamTest categoriesFor: #string!constants!private! !
!Core.Tests.WriteStreamTest categoriesFor: #stringSize!constants!private! !
!Core.Tests.WriteStreamTest categoriesFor: #testBasicNext!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testContents!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNewContents!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNext!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextAvailable!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextAvailableColon!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextColon!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextColonPutColon!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextInto!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextPutAllArray!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testNextWord!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testPeekFor!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testSetToEnd!public!testing! !
!Core.Tests.WriteStreamTest categoriesFor: #testUpTo!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testUpToEnd!public!unit tests! !
!Core.Tests.WriteStreamTest categoriesFor: #testUpToUtf!public!unit tests! !

!Core.Tests.WriteStreamTest class methodsFor!

allTestSelectors
	| roCategory |
	roCategory := 'gettableStream only' asMethodCategory.
	^super allTestSelectors reject: [:each | roCategory includesMethod: (self lookupMethod: each)]! !
!Core.Tests.WriteStreamTest class categoriesFor: #allTestSelectors!Accessing!public! !

