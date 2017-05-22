"Filed out from Dolphin Smalltalk 7"!

AbstractFileStreamTest subclass: #FileStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FileStreamTest guid: (GUID fromString: '{773617be-f790-4ae5-9ed9-f1ea47cbf664}')!
FileStreamTest comment: ''!
!FileStreamTest categoriesForClass!Unclassified! !
!FileStreamTest methodsFor!

assertBufferEmptyOrDirty: fs 
	| pos |
	pos := fs instVarNamed: 'position'.
	self 
		assert: ((fs isBufferDirty and: [pos > 0]) or: [fs isBufferDirty not and: [pos == 0]])!

assertBufferEmptyOrDirty: fs size: size 
	size == 0 
		ifTrue: [self deny: fs isBufferDirty]
		ifFalse: 
			[| pos |
			pos := fs instVarNamed: 'position'.
			self 
				assert: ((fs isBufferDirty and: [pos > 0]) or: [fs isBufferDirty not and: [pos == 0]])]!

streamClass
	^FileStream!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream name |
	stream := self streamWith: aString.
	name := stream name.
	stream close.
	^self streamClass read: name text: true!

test1065
	| r |
	r := Random new.
	#(0 1 512 4095 4096 8191 8192 8193 16383 16384 16385) do: 
			[:i |
			| data stream written |
			data := ((1 to: i) collect: [:each | (r next * 256) truncated]) asByteArray.
			stream := self streamClass write: tempFileName text: false.
			
			[stream
				next: data size
				putAll: data
				startingAt: 1] ensure: [stream close].
			stream := FileStream read: tempFileName text: false.
			written := [stream contents] ensure: [stream close].
			self
				assert: data = written
				description: 'Failed on write of ' , i printString , ' bytes'
				resumable: true]!

testFileTimes
	"Tests that file accesor exists and that #lastWriteTime works (for patch #1397)"

	| stream now file |
	now := FILETIME now.
	stream := self streamClass write: tempFileName.
	file := stream file.
	self assert: file lastWriteTime asInteger >= now asInteger!

testReset
	"#1724"

	| temp stream content |
	temp := File temporaryFilename.
	stream := FileStream write: temp.
	stream next: 3 put: $A.
	stream reset.
	content := stream upToEnd.
	self assert: content = 'AAA'.
	self assert: stream atEnd.
	stream close.
	stream := FileStream write: temp.
	stream next: 9999 put: $A.
	stream reset.
	content := stream upToEnd.
	self assert: (content size = 9999 and: [content allSatisfy: [:each | each = $A]]).
	self assert: stream atEnd.
	stream close.
	File delete: temp!

testSingleByteOverflow
	"Test that overflowing the FileStream buffer by a single byte and letting the FileStream be finalized
	doesn't lose the last byte."

	| stream weak |
	stream := self streamClass write: tempFileName.
	"Write bufSize-1 characters - buffer should be dirty but not yet flushed"
	stream next: self streamClass bufferSize - 1 put: $1.
	self assert: stream isBufferDirty.

	"Write the last byte - buffer should be dirty and full but not yet flushed"
	stream nextPut: $2.
	self assert: stream isBufferDirty.

	"Write another byte - overflowing buffer by one, but should still be dirty"
	stream nextPut: $3.
	self assert: stream isBufferDirty.
	weak := WeakArray with: stream.
	stream := nil.
	[(weak at: 1) isKindOf: DeadObject] whileFalse: [MemoryManager current collectGarbage].

	"Forcibly finalize"
	MemoryManager current administerLastRites.
	stream := self streamClass read: tempFileName text: true.
	self assert: stream size = (FileStream bufferSize + 1).
	stream next: self streamClass bufferSize - 2.
	self assert: stream next = $1.
	self assert: stream next = $2.
	self assert: stream next = $3.
	self closeTempStream: stream! !
!FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!private!unit tests! !
!FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!FileStreamTest categoriesFor: #streamClass!helpers!private! !
!FileStreamTest categoriesFor: #streamOn:!helpers!private! !
!FileStreamTest categoriesFor: #test1065!public!unit tests! !
!FileStreamTest categoriesFor: #testFileTimes!public!unit tests! !
!FileStreamTest categoriesFor: #testReset!public!unit tests! !
!FileStreamTest categoriesFor: #testSingleByteOverflow!private!unit tests! !

