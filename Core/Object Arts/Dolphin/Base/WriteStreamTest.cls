"Filed out from Dolphin Smalltalk 7"!

PositionableStreamTest subclass: #WriteStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WriteStreamTest guid: (GUID fromString: '{9d14176b-5486-40dc-bc22-694add104427}')!
WriteStreamTest comment: ''!
!WriteStreamTest categoriesForClass!Unclassified! !
!WriteStreamTest methodsFor!

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
!WriteStreamTest categoriesFor: #streamClass!helpers!private! !
!WriteStreamTest categoriesFor: #streamOn:!helpers!private! !
!WriteStreamTest categoriesFor: #string!constants!private! !
!WriteStreamTest categoriesFor: #stringSize!constants!private! !
!WriteStreamTest categoriesFor: #testBasicNext!public!unit tests! !
!WriteStreamTest categoriesFor: #testContents!public!unit tests! !
!WriteStreamTest categoriesFor: #testNewContents!public!unit tests! !
!WriteStreamTest categoriesFor: #testNext!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextAvailable!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextAvailableColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextColonPutColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextInto!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextPutAllArray!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextWord!public!unit tests! !
!WriteStreamTest categoriesFor: #testPeekFor!public!unit tests! !
!WriteStreamTest categoriesFor: #testSetToEnd!public!testing! !
!WriteStreamTest categoriesFor: #testUpTo!public!unit tests! !
!WriteStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testUpToEnd!public!unit tests! !
!WriteStreamTest categoriesFor: #testUpToUtf!public!unit tests! !

!WriteStreamTest class methodsFor!

allTestSelectors
	| roCategory |
	roCategory := 'gettableStream only' asMethodCategory.
	^super allTestSelectors reject: [:each | roCategory includesMethod: (self lookupMethod: each)]! !
!WriteStreamTest class categoriesFor: #allTestSelectors!Accessing!public! !

