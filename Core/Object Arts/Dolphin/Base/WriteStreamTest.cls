"Filed out from Dolphin Smalltalk 7"!

PositionableStreamTest subclass: #WriteStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WriteStreamTest guid: (GUID fromString: '{9D14176B-5486-40DC-BC22-694ADD104427}')!
WriteStreamTest comment: ''!
!WriteStreamTest categoriesForClass!Unclassified! !
!WriteStreamTest methodsFor!

readOperationNotImplemented: aBlock 
	"It is an error to attempt to read from a WriteStream"

	self 
		should: aBlock
		raise: Error
		matching: [:ex | ex description beginsWith: self streamClass name , ' should not implement']!

streamClass
	^WriteStream!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^(self streamWith: aString)
		reset;
		yourself!

testContents
	| stream |
	stream := self streamWith: ''.
	self assert: stream contents isEmpty.
	self closeTempStream: stream.
	stream := self streamWith: 'hello'.
	self assert: stream contents = 'hello'.
	self closeTempStream: stream!

testNewContents
	| stream contents |
	stream := self streamWith: String new.
	self assert: stream contents isEmpty.
	stream nextPut: $h.
	self assert: stream contents = 'h'.
	self closeTempStream: stream.
	stream := self streamWith: 'hel'.
	stream nextPutAll: 'lo'.
	contents := stream contents.
	self assert: contents = 'hello'.
	self closeTempStream: stream!

testNextLine
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	self readOperationNotImplemented: [stream nextLine]!

testNextWord
	| stream |
	stream := self streamWith: 'abc'.
	stream reset.
	"It is an error to attempt to read from a WriteStream"
	self should: [stream nextWord] raise: Error!

testSetToEnd
	| string stream |
	string := 'hello'.
	stream := WriteStream with: String new.
	stream nextPutAll: string.
	self assert: stream position = string size.
	stream setToEnd.
	self assert: stream position = string size.
	self assert: stream contents = string!

testSkipToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	self readOperationNotImplemented: [stream skipToAll: 'a']!

testUpToAllColon
	| chars stream |
	chars := 'aababcabcdabcde'.
	stream := self streamOn: chars.

	self readOperationNotImplemented: [stream upToAll: 'a']
!

testUpToEnd
	| stream |
	stream := self streamOn: 'abc'.
	self readOperationNotImplemented: [stream upToEnd]! !
!WriteStreamTest categoriesFor: #readOperationNotImplemented:!private!unit tests! !
!WriteStreamTest categoriesFor: #streamClass!helpers!private! !
!WriteStreamTest categoriesFor: #streamOn:!helpers!private! !
!WriteStreamTest categoriesFor: #testContents!public!unit tests! !
!WriteStreamTest categoriesFor: #testNewContents!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextLine!public!unit tests! !
!WriteStreamTest categoriesFor: #testNextWord!public!unit tests! !
!WriteStreamTest categoriesFor: #testSetToEnd!public!testing! !
!WriteStreamTest categoriesFor: #testSkipToAllColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testUpToAllColon!public!unit tests! !
!WriteStreamTest categoriesFor: #testUpToEnd!public!unit tests! !

