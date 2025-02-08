"Filed out from Dolphin Smalltalk"!

Core.Tests.ReadWriteStreamTest
	subclass: #'Core.Tests.AbstractFileStreamTest'
	instanceVariableNames: 'tempFileName filestream'
	classVariableNames: 'RandomData1 RandomData2'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.AbstractFileStreamTest guid: (Core.GUID fromString: '{fc7d3bee-d1b0-477d-a33c-33ee6cfb0339}')!

Core.Tests.AbstractFileStreamTest isNonInstantiable: true!

Core.Tests.AbstractFileStreamTest comment: ''!

!Core.Tests.AbstractFileStreamTest methodsFor!

arrayedCollections
	^self strings , self byteArrays!

assertBufferEmptyOrDirty: fs 
	!

assertBufferEmptyOrDirty: aFileStream size: anInteger 
	aFileStream flush!

blockWriteIntervals
	^#(#(1 0) #(1 1) #(1 2) #(1 512) #(2 1) #(2 2) #(2 3) #(2 512) #(511 768) #(1 8191) #(2 8191) #(1 8192) #(1 8193) #(1 8194) #(1 16383) #(1 16384) #(1 16385) #(2 8192) #(2 8193) #(2 8194) #(2 16383) #(2 16384) #(2 16385) #(4095 8192) #(4095 8193) #(4095 8194) #(4095 16383) #(4095 16384) #(4095 16385) #(8191 8191) #(8191 8192) #(8191 8193) #(8191 8194) #(8191 16383) #(8191 16384) #(8191 16385) #(8192 8191) #(8192 8192) #(8192 8193) #(8192 8194) #(8192 16383) #(8192 16384) #(8192 16385) #(8191 31999) #(8191 32000) #(8191 32001) #(8191 32767) #(8191 32768) #(8191 32769) #(8192 31999) #(8192 32000) #(8192 32001) #(8192 32767) #(8192 32768) #(8192 32769) #(1 31999) #(2 31999) #(1 32000) #(2 32000) #(1 32001) #(2 32001) #(1 32767) #(2 32767) #(1 32768) #(2 32768) #(1 32769) #(2 32769))!

bufferSize
	^self subclassResponsibility!

bufferSizeOfStream: aStream
	^self bufferSize!

closeTempStream
	filestream ifNil: [^self].
	filestream close.
	filestream := nil!

collections
	^self arrayedCollections!

filestream: aFileWriteStream
	self closeTempStream.
	filestream := aFileWriteStream!

initializeRandomTestData
	| r bytes |
	r := OS.RandomCRT new.
	bytes := ByteArray writeStream: 32769.
	32000 timesRepeat: [bytes nextPut: (r next * 256) truncated].
	RandomData1 := bytes contents.
	bytes reset.
	32769 timesRepeat: [bytes nextPut: (r next * 256) truncated].
	RandomData2 := bytes contents!

maxPosition
	^self subclassResponsibility!

newStream: aSymbol
	^self streamClass
		write: tempFileName
		mode: #truncate
		check: false
		type: aSymbol!

randomData1
	RandomData1 isNil ifTrue: [self initializeRandomTestData].
	^RandomData1!

randomData2
	RandomData2 isNil ifTrue: [self initializeRandomTestData].
	^RandomData2!

readWriteStreamOnString: aString
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream |
	stream := self tempWriteStream: aString encoding.
	stream nextPutAll: aString.
	^stream!

setUp
	super setUp.
	tempFileName := File temporaryFilename!

sharingError
	^self subclassResponsibility!

streamClassSupportsPointers
	^false!

streamOnBytes: aByteArray type: aSymbol
	filestream notNil ifTrue: [filestream close].
	(File
		open: tempFileName
		mode: #truncate
		check: false
		share: #readWrite)
		write: aByteArray;
		close.
	^filestream := self streamClass read: tempFileName type: aSymbol!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self readWriteStreamOnString: aString!

strings
	"Can't handle UTF-16 encoding yet"

	^super strings reject: [:each | each first isKindOf: Utf16String]!

tearDown
	self tearDownTempStream.
	(tempFileName isNil or: [(File exists: tempFileName) not]) ifTrue: [^self].
	[File delete: tempFileName] on: Error
		do: 
			[:ex |
			SessionManager current traceStream
				print: self;
				nextPutAll: ' Unable to delete test file ';
				print: tempFileName;
				nextPutAll: ': '.
			ex toTrace].
	tempFileName := nil.
	super tearDown!

tearDownTempStream
	"Private - Clean up the test subject. Don't do this by closing the FileStream, but directly close the File to which it is attached as this avoids the FileStream>>flush and so is more likely to work in case of test error"

	self closeTempStream!

tempReadStream: aSymbol
	self closeTempStream.
	^filestream := self streamClass read: tempFileName type: aSymbol!

tempReadWriteStream
	^self tempReadWriteStream: #binary!

tempReadWriteStream: aSymbol
	self closeTempStream.
	filestream := self streamClass
				write: tempFileName
				mode: #append
				check: false
				type: aSymbol.
	filestream reset.
	^filestream!

tempWriteStream: aSymbol
	self closeTempStream.
	^filestream := self newStream: aSymbol!

test64BitPosition
	filestream := self tempWriteStream: #binary.
	{2 ** 33 - 1. self maxPosition} do: 
			[:position |
			filestream position: position.
			self assert: filestream position equals: position]!

testIsReadable
	self assert: self tempReadStream isReadable.
	"Writeable FileStreams must also be readable"
	self assert: self tempWriteStream isReadable!

testIsWriteable
	self deny: self tempReadStream isWriteable.
	self assert: self tempWriteStream isWriteable!

testNextPutAllStartingAt
	| initialData dataToWrite file |
	initialData := self randomData1.
	dataToWrite := self randomData2.
	file := File
				open: tempFileName
				mode: #truncate
				check: false.
	
	[self blockWriteIntervals do: 
			[:each |
			| expected written actual size |
			file
				size: 0;
				write: initialData.
			filestream := self streamClass on: file text: false.
			self assert: filestream isReadable.
			self assert: filestream isWriteable.
			self assert: filestream isBinary.
			filestream reset.
			"Verify it was written correctly in the first place"
			written := filestream upToEnd.
			self assert: written equals: initialData.
			filestream position: each first - 1.
			size := each last - each first + 1.
			filestream
				next: size
				putAll: dataToWrite
				startingAt: each first.
			self assert: filestream position equals: each last.
			self assertBufferEmptyOrDirty: filestream size: size.
			self assert: ((each last >= initialData size and: [filestream atEnd])
						or: [filestream next = (initialData at: each last + 1)]).
			filestream close.
			"Expected data will be composed of a (possibly empty) block of the original data, a (possibly empty) block of the
			new data, and a (possibly empty) block of the original data"
			expected := (initialData copyFrom: 1 to: each first - 1)
						, (dataToWrite copyFrom: each first to: each last).
			each last <= initialData size
				ifTrue: [expected := expected , (initialData copyFrom: each last + 1)].
			actual := ByteArray newFixed: file size.
			file
				reset;
				read: actual.
			self assert: actual equals: expected]]
			ensure: 
				[file
					size: 0;
					close]!

testNextPutAllStartingAt2
	| initialData dataToWrite file |
	initialData := self randomData1.
	dataToWrite := self randomData2.
	file := File
				open: tempFileName
				mode: #truncate
				check: false.
	self blockWriteIntervals do: 
			[:each |
			| expected actual |
			"truncate the file"
			file size: 0.
			filestream := self streamClass on: file text: false.
			self assert: filestream isWriteable.
			self assert: filestream isReadable.
			self assert: filestream isBinary.
			filestream
				next: each first - 1
				putAll: initialData
				startingAt: 1.
			self assert: filestream position equals: each first - 1.
			filestream
				next: each last - each first + 1
				putAll: dataToWrite
				startingAt: each first.
			self assert: filestream position equals: each last.
			self assertBufferEmptyOrDirty: filestream.
			each last <= initialData size
				ifTrue: 
					[filestream
						next: initialData size - each last
						putAll: initialData
						startingAt: each last + 1].
			filestream close.
			"Expected data will be composed of a (possibly empty) block of the original data, a (possibly empty) block of the
			new data, and a (possibly empty) block of the original data"
			expected := (initialData copyFrom: 1 to: each first - 1)
						, (dataToWrite copyFrom: each first to: each last).
			each last <= initialData size
				ifTrue: [expected := expected , (initialData copyFrom: each last + 1)].
			actual := ByteArray newFixed: file size.
			file
				reset;
				read: actual.
			self assert: actual equals: expected].
	file close!

testPositionPastEnd
	| pos1 pos2 expected actual pos3 |
	filestream := self tempWriteStream: #ansi.
	pos1 := (FileStream.PageSize * 1.25) truncated.
	filestream position: pos1.
	filestream print: pos1.
	pos2 := FileStream.PageSize * 2 - 1.
	filestream position: pos2.
	filestream print: pos2.
	actual := filestream contents.
	expected := String writeStream.
	expected
		next: pos1 put: $\0;
		print: pos1.
	expected
		next: pos2 - expected size put: $\0;
		print: pos2.
	expected := expected contents.
	self assert: actual equals: expected.
	filestream close.
	filestream := self tempReadStream.
	filestream position: pos1.
	self assert: filestream position equals: pos1.
	actual := filestream upTo: $\0.
	self assert: actual equals: pos1 printString.
	filestream position: pos2.
	self assert: filestream position equals: pos2.
	actual := filestream upToEnd.
	self assert: actual equals: pos2 printString.
	pos3 := pos1 * 2.
	filestream position: pos3.
	self assert: filestream position equals: pos3.
	self assert: filestream atEnd.
	self assert: (filestream upTo: $\0) equals: ''.
	"Move back, but not into the actual stream content, so should still be at end."
	filestream position: pos3 - 100.
	self assert: filestream atEnd.
	"Read-only stream should never expand, even if we position past the end."
	actual := filestream contents.
	self assert: actual equals: expected.
	self assert: filestream size equals: expected size!

testReset
	"#1724"

	| content |
	filestream := self tempWriteStream.
	filestream next: 3 put: $A.
	filestream reset.
	content := filestream upToEnd.
	self assert: content equals: 'AAA'.
	self assert: filestream atEnd.
	filestream close.
	filestream := self tempWriteStream.
	filestream next: 9999 put: $A.
	filestream reset.
	content := filestream upToEnd.
	self assert: (content size = 9999 and: [content allSatisfy: [:each | each = $A]]).
	self assert: filestream atEnd.
	filestream close!

testSharing
	| read sharingError |
	filestream := self tempWriteStream.
	filestream
		nextPutAll: 'Hello 🐬 world';
		flush.
	sharingError := self sharingError.
	self should: [self streamClass write: tempFileName type: #binary] raise: sharingError.
	"By default read streams are opened with #read sharing, so won't open a stream being written"
	self should: [self streamClass read: tempFileName type: #binary] raise: sharingError.
	"If we open in #text mode the File must be  opened to sniff it, so we'll always get a Win32Error"
	self
		should: [self streamClass read: tempFileName type: #text]
		raise: OS.Win32Error
		matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_SHARING_VIOLATION].
	"But we should be able to open with read/write sharing - the mode specifies that we are allowed to share with others that have opened the file for reading or writing"
	read := self streamClass
				read: tempFileName
				type: #utf8
				share: #readWrite.
	self assert: read upToEnd equals: 'Hello 🐬 world'.
	"Now try opening a stream for write that is open for reading with read/write, should be fine."
	filestream close.
	filestream := self tempWriteStream.
	filestream
		nextPutAll: 'Hello 💩 world';
		flush.
	self assert: read contents equals: 'Hello 💩 world'.
	"Now try opening a stream for write that is open for reading with read, should not be permitted."
	filestream close.
	read close.
	read := self tempReadStream.
	self should: [self streamClass write: tempFileName type: #binary] raise: sharingError.
	self should: [self streamClass write: tempFileName type: #text] raise: sharingError!

writeableCollections
	^self strings , self byteArrays! !

!Core.Tests.AbstractFileStreamTest categoriesForMethods!
arrayedCollections!constants!private! !
assertBufferEmptyOrDirty:!helpers!private! !
assertBufferEmptyOrDirty:size:!helpers!private! !
blockWriteIntervals!constants!private! !
bufferSize!constants!private! !
bufferSizeOfStream:!helpers!private!unit tests! !
closeTempStream!helpers!private! !
collections!private!unit tests! !
filestream:!accessing!private! !
initializeRandomTestData!initializing!private! !
maxPosition!constants!private! !
newStream:!helpers!private! !
randomData1!constants!private! !
randomData2!constants!private! !
readWriteStreamOnString:!helpers!private! !
setUp!public!running! !
sharingError!constants!private! !
streamClassSupportsPointers!helpers!private! !
streamOnBytes:type:!helpers!private! !
streamWith:!helpers!private! !
strings!constants!private! !
tearDown!public!running! !
tearDownTempStream!helpers!private! !
tempReadStream:!helpers!private! !
tempReadWriteStream!helpers!private! !
tempReadWriteStream:!helpers!private! !
tempWriteStream:!helpers!private! !
test64BitPosition!public!unit tests! !
testIsReadable!public!unit tests! !
testIsWriteable!public!unit tests! !
testNextPutAllStartingAt!public!unit tests! !
testNextPutAllStartingAt2!public!unit tests! !
testPositionPastEnd!public!unit tests! !
testReset!public!unit tests! !
testSharing!public!unit tests! !
writeableCollections!constants!private! !
!

