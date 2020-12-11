"Filed out from Dolphin Smalltalk 7"!

Core.Tests.AbstractFileStreamTest subclass: #'Core.Tests.FileStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.FileStreamTest guid: (Core.GUID fromString: '{773617be-f790-4ae5-9ed9-f1ea47cbf664}')!
Core.Tests.FileStreamTest comment: ''!
!Core.Tests.FileStreamTest categoriesForClass!Unclassified! !
!Core.Tests.FileStreamTest methodsFor!

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

bufferSize
	^FileStream.PageSize!

maxPosition
	"Private - Seems to be a minor bug that we can't position a FileStream onto the last page of a 2^63-1 sized file, although not really an issue in practice."

	^2 ** 63 - 1 - FileStream.PageSize!

maxSize
	"Private - The maximum size of a file on NTFS (the implementation limit, as opposed to the theoretical
	limit). Realistically this can only be achieved with a sparse file."

	^256 * (1024 ** 4) - (64 * 1024)!

streamClass
	^FileStream!

streamClassSupportsUtf16
	"Streaming strings to/from FileStreams in UTF-16 encoding is not currently implemented."

	^false!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream name |
	stream := self streamWith: aString.
	name := stream name.
	stream close.
	^self streamClass read: name type: aString encoding!

streamOnFile: pathString type: aSymbol
	^FileStream read: pathString type: aSymbol!

tearDownTempStream
	"Private - Clean up the test subject. Don't do this by closing the FileStream, but directly
	close the File to which it is attached as this avoids the FileStream>>flush and so is more
	likely to work in case of test error"

	filestream file free!

testFileTimes
	"Tests that file accesor exists and that #lastWriteTime works (for patch #1397)"

	| now file |
	now := OS.FILETIME now.
	filestream := self streamClass write: tempFileName.
	file := filestream file.
	self assert: file lastWriteTime asInteger >= now asInteger!

testNextAvailableColonWithPaging
	"#640"

	| bytes random writeStream |
	bytes := ByteArray new: self streamClass bufferSize + 1.
	random := Random new.
	1 to: bytes size do: [:index | bytes at: index put: (random next * 255) truncated].
	filestream := self streamOn: bytes.
	writeStream := ByteArray writeStream: bytes size.
	self
		shouldnt: [[filestream atEnd] whileFalse: [writeStream nextPutAll: (filestream nextAvailable: 64)]]
		raise: self streamClass endOfStreamSignal.
	self assert: writeStream contents equals: bytes!

testOwnsFile
	| subject file |
	subject := FileStream read: self class fileOutName.
	self assert: subject ownsFile.
	file := subject file.
	self assert: file handle isKindOf: External.Handle.
	subject close.
	self assertIsNil: file handle.
	file open.
	self assert: file handle isKindOf: External.Handle.
	subject := FileStream on: file.
	self deny: subject ownsFile.
	subject close.
	self assert: file handle isKindOf: External.Handle.
	file close!

testSingleByteOverflow
	"Test that overflowing the FileStream buffer by a single byte and letting the FileStream be finalized
	doesn't lose the last byte."

	| weak |
	filestream := self tempWriteStream.
	"Write bufSize-1 characters - buffer should be dirty but not yet flushed"
	filestream next: self streamClass bufferSize - 1 put: $1.
	self assert: filestream isBufferDirty.

	"Write the last byte - buffer should be dirty and full but not yet flushed"
	filestream nextPut: $2.
	self assert: filestream isBufferDirty.

	"Write another byte - overflowing buffer by one, but should still be dirty"
	filestream nextPut: $3.
	self assert: filestream isBufferDirty.
	weak := WeakArray with: filestream.
	filestream := nil.
	[(weak at: 1) isKindOf: DeadObject] whileFalse: [MemoryManager current collectGarbage].

	"Forcibly finalize"
	MemoryManager current administerLastRites.
	filestream := self streamClass read: tempFileName text: true.
	self assert: filestream size equals: FileStream.PageSize + 1.
	filestream next: FileStream.PageSize - 2.
	self assert: filestream next equals: $1.
	self assert: filestream next equals: $2.
	self assert: filestream next equals: $3.
	filestream close!

testVeryLargeSparseFile
	| empty max |
	filestream := self tempWriteStream.
	filestream file beSparse.
	filestream nextPutAll: 'Beginning'.
	filestream position: 2 ** 33 - 1.
	filestream nextPutAll: 'Middle'.
	"Due to FileStream paging implementation, we can in theory only position up to the maximum
	size - 1 page, however I can't get close to even that on my system (Windows refuses) so just
	settle on a 4-terrabyte file, which after all is large enough to prove very large file
	support."
	max := self maxSize / 64.
	filestream position: max.
	filestream nextPutAll: 'End'.
	self assert: filestream size equals: max + 3.
	filestream reset.
	self assert: (filestream next: 9) equals: 'Beginning'.
	empty := String new: FileStream.PageSize.
	self assert: (filestream next: FileStream.PageSize) equals: empty.
	filestream position: 2 ** 33 - 1.
	self assert: (filestream next: 6) equals: 'Middle'.
	self assert: (filestream next: FileStream.PageSize) equals: empty.
	filestream position: max.
	self assert: (filestream next: 3) equals: 'End'.
	self assert: filestream atEnd!

testWritePastEnd
	"#457: Tests that the page buffer is zero'd out out when writing beyond the end of the file
	so that previous buffer content is not mirrored into the last page."

	| actual expected r |
	filestream := self tempWriteStream: #ansi.
	expected := WriteStream with: (AnsiString new: FileStream.PageSize * 2).
	expected reset.
	r := Random new.
	FileStream.PageSize timesRepeat: 
			[filestream nextPut: (expected nextPut: (Character ansiValue: (r next * 97 + 32) asInteger))].
	filestream position: FileStream.PageSize - 2.
	expected position: filestream position.
	filestream nextPutAll: (expected nextPutAll: 'abc').
	"Go back and read the first page."
	filestream reset.
	"Reposition into the 2nd page beyond the current end."
	filestream position: FileStream.PageSize * 2 - 5.
	expected position: filestream position.
	"Write some more stuff"
	filestream nextPutAll: (expected nextPutAll: 'world').
	filestream reset.
	actual := filestream upToEnd.
	expected := expected contents.
	self assert: actual equals: expected! !
!Core.Tests.FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!private!unit tests! !
!Core.Tests.FileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #bufferSize!constants!private! !
!Core.Tests.FileStreamTest categoriesFor: #maxPosition!constants!private! !
!Core.Tests.FileStreamTest categoriesFor: #maxSize!constants!private! !
!Core.Tests.FileStreamTest categoriesFor: #streamClass!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #streamClassSupportsUtf16!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #streamOn:!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #streamOnFile:type:!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #tearDownTempStream!helpers!private! !
!Core.Tests.FileStreamTest categoriesFor: #testFileTimes!public!unit tests! !
!Core.Tests.FileStreamTest categoriesFor: #testNextAvailableColonWithPaging!public!unit tests! !
!Core.Tests.FileStreamTest categoriesFor: #testOwnsFile!public! !
!Core.Tests.FileStreamTest categoriesFor: #testSingleByteOverflow!public!unit tests! !
!Core.Tests.FileStreamTest categoriesFor: #testVeryLargeSparseFile!public!unit tests! !
!Core.Tests.FileStreamTest categoriesFor: #testWritePastEnd!public!unit tests! !

