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

expectedAnsiProtocolNames
	^#(#Object #FileStream #gettableStream #puttableStream #readFileStream #ReadWriteStream #sequencedStream #writeFileStream #WriteStream)!

maxPosition
	"Private - Seems to be a minor bug that we can't position a FileStream onto the last page of a 2^63-1 sized file, although not really an issue in practice."

	^2 ** 63 - 1 - FileStream.PageSize!

maxSize
	"Private - The maximum size of a file on NTFS (the implementation limit, as opposed to the theoretical
	limit). Realistically this can only be achieved with a sparse file."

	^256 * (1024 ** 4) - (64 * 1024)!

sharingError
	^FileException matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_SHARING_VIOLATION]!

streamClassSupportsUtf16
	"Streaming strings to/from FileStreams in UTF-16 encoding is not currently implemented."

	^false!

streamedContents: aFileStream
	| contents |
	contents := aFileStream isText
				ifTrue: [File readAllText: aFileStream name share: #readWrite]
				ifFalse: [File readAllBytes: aFileStream name share: #readWrite].
	aFileStream isBufferDirty
		ifTrue: 
			[| unwritten start |
			unwritten := aFileStream bufferContents.
			aFileStream absolutePosition > aFileStream file size
				ifTrue: [contents := contents , aFileStream bufferContents]
				ifFalse: 
					[start := aFileStream bufferStartPosition.
					contents
						replaceFrom: start
						to: start + unwritten size - 1
						with: unwritten]].
	^contents!

streamOn: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream |
	stream := self streamWith: aString.
	stream close.
	^self tempReadStream: aString encoding!

streamOnFile: pathString type: aSymbol
	self filestream: (FileStream read: pathString type: aSymbol).
	^filestream!

tearDownTempStream
	"Private - Clean up the test subject. Don't do this by closing the FileStream, but directly close the File to which it is attached as this avoids the FileStream>>flush and so is more likely to work in case of test error"

	filestream ifNil: [^self].
	filestream file free.
	filestream := nil!

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
	self assert: filestream atEnd! !

!Core.Tests.FileStreamTest categoriesForMethods!
assertBufferEmptyOrDirty:!private!unit tests! !
assertBufferEmptyOrDirty:size:!helpers!private! !
bufferSize!constants!private! !
expectedAnsiProtocolNames!constants!private! !
maxPosition!constants!private! !
maxSize!constants!private! !
sharingError!constants!private! !
streamClassSupportsUtf16!helpers!private! !
streamedContents:!private! !
streamOn:!helpers!private! !
streamOnFile:type:!helpers!private! !
tearDownTempStream!helpers!private! !
testAtEndWithUtf8Bom!public!unit tests! !
testNextAvailableColonWithPaging!public!unit tests! !
testUtf8StraddlingPageBoundary!public!unit tests! !
testVeryLargeSparseFile!public!unit tests! !
!

!Core.Tests.FileStreamTest class methodsFor!

streamClass
	^FileStream! !

!Core.Tests.FileStreamTest class categoriesForMethods!
streamClass!helpers!private! !
!

