"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractFileStreamTest
	subclass: #'Core.Tests.FileStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.FileStreamTest guid: (Core.GUID fromString: '{773617be-f790-4ae5-9ed9-f1ea47cbf664}')!

Core.Tests.FileStreamTest comment: ''!

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

sharingError
	^FileException matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_SHARING_VIOLATION]!

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

testAtEndWithUtf8Bom
	(0 to: 1) , (FileStream.PageSize - $\xFEFF utf8Length - 3 to: FileStream.PageSize + 1)
		, (FileStream.PageSize * 2 - $\xFEFF utf8Length - 3 to: FileStream.PageSize * 2 + 1) do: 
				[:each |
				| subject |
				subject := self tempWriteStream: #utf8.
				subject
					position: each;
					nextPut: $£.
				self assert: subject position equals: each + 2.
				self assert: subject atEnd.
				subject position: each.
				self assert: subject position equals: each.
				self deny: subject atEnd.
				self assert: subject basicNext equals: 194.
				self assert: subject position equals: each + 1.
				self deny: subject atEnd.
				self assert: subject basicNext equals: 163.
				self assert: subject position equals: each + 2.
				self assert: subject atEnd.
				subject position: each.
				self deny: subject atEnd.
				self assert: subject next equals: $£.
				self assert: subject atEnd.
				subject close.
				subject := self tempReadStream.
				subject position: each.
				self assert: subject position equals: each.
				self deny: subject atEnd.
				self assert: subject basicNext equals: 194.
				self assert: subject position equals: each + 1.
				self deny: subject atEnd.
				self assert: subject basicNext equals: 163.
				self assert: subject position equals: each + 2.
				self assert: subject atEnd.
				subject position: each.
				self deny: subject atEnd.
				self assert: subject next equals: $£.
				self assert: subject atEnd.
				subject close]!

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

testNextPutAll
	| string written actual offset |
	filestream := self tempWriteStream: #utf8.
	written := ''.
	offset := Utf8String.Bom size.
	"Fill the first page up to the penultimate byte"
	string := String new: FileStream.PageSize - offset - 1 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize - 1.
	self assert: filestream absolutePosition equals: FileStream.PageSize - 1.
	self assert: filestream isBufferDirty.
	filestream flush.
	"Fill the last byte - page full, but not written yet"
	string := 'Z'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize.
	self assert: filestream absolutePosition equals: FileStream.PageSize.
	self assert: filestream isBufferDirty.
	"Write another byte to overflow into next page"
	string := 'A'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: 1.
	self assert: filestream absolutePosition equals: FileStream.PageSize + 1.
	self assert: filestream isBufferDirty.
	"Fill the 2nd page up to the last byte"
	string := String new: FileStream.PageSize - 2 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize - 1.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 2 - 1.
	self assert: filestream isBufferDirty.
	filestream flush.
	"Write a two byte char causing overflow to next page"
	string := '£'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: 1.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 2 + 1.
	self assert: filestream isBufferDirty.
	"Fill the 3nd page up to the 2nd to last byte"
	string := String new: FileStream.PageSize - 3 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize - 2.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 3 - 2.
	self assert: filestream isBufferDirty.
	filestream flush.
	"Write a three byte char causing 1-byte overflow to next page"
	string := '€'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: 1.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 3 + 1.
	self assert: filestream isBufferDirty.
	"Fill the 4th page up to the 2nd to last byte"
	string := String new: FileStream.PageSize - 3 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize - 2.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 4 - 2.
	self assert: filestream isBufferDirty.
	filestream flush.
	"Write a four byte char causing 2-byte overflow to next page"
	string := '𐀀'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: 2.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 4 + 2.
	self assert: filestream isBufferDirty.
	"Fill the 5th page up to allow enough space for a 4-byte char"
	string := String new: FileStream.PageSize - 6 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize - 4.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 5 - 4.
	self assert: filestream isBufferDirty.
	filestream flush.
	"Write a four byte char to just fill the page"
	string := '🐬'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream pagePosition equals: FileStream.PageSize.
	self assert: filestream absolutePosition equals: FileStream.PageSize * 5.
	self assert: filestream isBufferDirty.

	"Final sanity check that we actually wrote what we expected"
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: written!

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

testUtf8StraddlingPageBoundary
	"Test writing and then reading a multi-byte UTF-8 character that is straddling a page boundary"

	| offset string subject allText |
	subject := self tempWriteStream: #utf8.
	self assert: subject atEnd.
	offset := $\xFEFF utf8Length.
	"Fill the first page up to the penultimate byte"
	string := String new: FileStream.PageSize - offset - 1 withAll: $X.
	subject nextPutAll: string.
	self assert: subject atEnd.
	subject nextPut: Character dolphin.
	self assert: subject atEnd.
	subject close.
	allText := string copyWith: Character dolphin.
	self assert: (File readAllText: tempFileName) equals: allText.
	subject := self tempReadStream.
	self deny: subject atEnd.
	self assert: subject encoding equals: #utf8.
	self assert: subject upToEnd equals: allText.
	subject reset.
	self assert: (subject next: string size) equals: string.
	subject reset.
	string size timesRepeat: 
			[self assert: subject next equals: $X.
			self deny: subject atEnd].
	"The emoji straddles the page boundary"
	self assert: subject next equals: Character dolphin.
	self assert: subject atEnd.
	subject reset.
	subject position: string size.
	self deny: subject atEnd.
	self assert: subject nextAvailable equals: Character dolphin.
	subject position: string size.
	Character dolphin asUtf8String asByteArray do: 
			[:each |
			self deny: subject atEnd.
			self assert: subject basicNext equals: each].
	self assert: subject atEnd!

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

!Core.Tests.FileStreamTest categoriesForMethods!
assertBufferEmptyOrDirty:!private!unit tests! !
assertBufferEmptyOrDirty:size:!helpers!private! !
bufferSize!constants!private! !
maxPosition!constants!private! !
maxSize!constants!private! !
sharingError!constants!private! !
streamClass!helpers!private! !
streamClassSupportsUtf16!helpers!private! !
streamOn:!helpers!private! !
streamOnFile:type:!helpers!private! !
tearDownTempStream!helpers!private! !
testAtEndWithUtf8Bom!public!unit tests! !
testNextAvailableColonWithPaging!public!unit tests! !
testNextPutAll!public!unit tests! !
testOwnsFile!public! !
testSingleByteOverflow!public!unit tests! !
testUtf8StraddlingPageBoundary!public!unit tests! !
testVeryLargeSparseFile!public!unit tests! !
testWritePastEnd!public!unit tests! !
!

