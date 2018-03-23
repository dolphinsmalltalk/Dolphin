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

maxPosition
	"Seems to be a minor bug that we can't position a FileStream onto the last page of a 2^63-1 sized file, although not really an issue in practice."

	^2 ** 63 - 1 - FileStream.PageSize!

maxSize
	"The maximum size of a file on NTFS (the implementation limit, as opposed to the theoretical
	limit). Realistically this can only be achieved with a sparse file."

	^256 * (1024 ** 4) - (64 * 1024)!

streamClass
	^FileStream!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream name |
	stream := self streamWith: aString.
	name := stream name.
	stream close.
	^self streamClass read: name text: true!

tearDownTempStream
	"Private - Clean up the test subject. Don't do this by closing the FileStream, but directly
	close the File to which it is attached as this avoids the FileStream>>flush and so is more
	likely to work in case of test error"

	subject file free!

testFileTimes
	"Tests that file accesor exists and that #lastWriteTime works (for patch #1397)"

	| now file |
	now := FILETIME now.
	subject := self streamClass write: tempFileName.
	file := subject file.
	self assert: file lastWriteTime asInteger >= now asInteger!

testSingleByteOverflow
	"Test that overflowing the FileStream buffer by a single byte and letting the FileStream be finalized
	doesn't lose the last byte."

	| weak |
	subject := self tempWriteStream.
	"Write bufSize-1 characters - buffer should be dirty but not yet flushed"
	subject next: self streamClass bufferSize - 1 put: $1.
	self assert: subject isBufferDirty.

	"Write the last byte - buffer should be dirty and full but not yet flushed"
	subject nextPut: $2.
	self assert: subject isBufferDirty.

	"Write another byte - overflowing buffer by one, but should still be dirty"
	subject nextPut: $3.
	self assert: subject isBufferDirty.
	weak := WeakArray with: subject.
	subject := nil.
	[(weak at: 1) isKindOf: DeadObject] whileFalse: [MemoryManager current collectGarbage].

	"Forcibly finalize"
	MemoryManager current administerLastRites.
	subject := self streamClass read: tempFileName text: true.
	self assert: subject size equals: FileStream.PageSize + 1.
	subject next: FileStream.PageSize - 2.
	self assert: subject next equals: $1.
	self assert: subject next equals: $2.
	self assert: subject next equals: $3.
	subject close!

testVeryLargeSparseFile
	| empty max |
	subject := self tempWriteStream.
	subject file beSparse.
	subject nextPutAll: 'Beginning'.
	subject position: 2 ** 33 - 1.
	subject nextPutAll: 'Middle'.
	"Due to FileStream paging implementation, we can in theory only position up to the maximum
	size - 1 page, however I can't get close to even that on my system (Windows refuses) so just
	settle on a 4-terrabyte file, which after all is large enough to prove very large file
	support."
	max := self maxSize / 64.
	subject position: max.
	subject nextPutAll: 'End'.
	self assert: subject size equals: max + 3.
	subject reset.
	self assert: (subject next: 9) equals: 'Beginning'.
	empty := String new: FileStream.PageSize.
	self assert: (subject next: FileStream.PageSize) equals: empty.
	subject position: 2 ** 33 - 1.
	self assert: (subject next: 6) equals: 'Middle'.
	self assert: (subject next: FileStream.PageSize) equals: empty.
	subject position: max.
	self assert: (subject next: 3) equals: 'End'.
	self assert: subject atEnd!

testWritePastEnd
	"#457: Tests that the page buffer is zero'd out out when writing beyond the end of the file
	so that previous buffer content is not mirrored into the last page."

	| actual expected r |
	subject := self tempWriteStream.
	expected := WriteStream with: (String new: FileStream.PageSize * 2).
	expected reset.
	r := Random new.
	FileStream.PageSize
		timesRepeat: [subject nextPut: (expected nextPut: (Character ansiValue: (r next * 97 + 32) asInteger))].
	subject position: FileStream.PageSize - 2.
	expected position: subject position.
	subject nextPutAll: (expected nextPutAll: 'abc').
	"Go back and read the first page."
	subject reset.
	"Reposition into the 2nd page beyond the current end."
	subject position: FileStream.PageSize * 2 - 5.
	expected position: subject position.
	"Write some more stuff"
	subject nextPutAll: (expected nextPutAll: 'world').
	subject reset.
	actual := subject upToEnd.
	expected := expected contents.
	self assert: actual equals: expected! !
!FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!private!unit tests! !
!FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!FileStreamTest categoriesFor: #maxPosition!constants!public! !
!FileStreamTest categoriesFor: #maxSize!constants!public! !
!FileStreamTest categoriesFor: #streamClass!helpers!private! !
!FileStreamTest categoriesFor: #streamOn:!helpers!private! !
!FileStreamTest categoriesFor: #tearDownTempStream!helpers!private! !
!FileStreamTest categoriesFor: #testFileTimes!public!unit tests! !
!FileStreamTest categoriesFor: #testSingleByteOverflow!public!unit tests! !
!FileStreamTest categoriesFor: #testVeryLargeSparseFile!public!unit tests! !
!FileStreamTest categoriesFor: #testWritePastEnd!public!unit tests! !

