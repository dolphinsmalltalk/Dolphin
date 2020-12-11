"Filed out from Dolphin Smalltalk 7"!

Core.Tests.ReadWriteStreamTest subclass: #'Core.Tests.AbstractFileStreamTest'
	instanceVariableNames: 'tempFileName filestream'
	classVariableNames: 'RandomData1 RandomData2'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.AbstractFileStreamTest guid: (Core.GUID fromString: '{fc7d3bee-d1b0-477d-a33c-33ee6cfb0339}')!
Core.Tests.AbstractFileStreamTest isNonInstantiable: true!
Core.Tests.AbstractFileStreamTest comment: ''!
!Core.Tests.AbstractFileStreamTest categoriesForClass!Unclassified! !
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

closeTempStream: aStream 
	"Private - Clean up the temporary stream argument."

	aStream close!

collections
	^self arrayedCollections!

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

randomData1
	RandomData1 isNil ifTrue: [self initializeRandomTestData].
	^RandomData1!

randomData2
	RandomData2 isNil ifTrue: [self initializeRandomTestData].
	^RandomData2!

readWriteStreamOnString: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	| stream |
	stream := self streamClass write: tempFileName type: aString encoding.
	stream nextPutAll: aString.
	^stream!

setUp
	tempFileName := File temporaryFilename!

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
	filestream notNil ifTrue: [self tearDownTempStream].
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
	tempFileName := nil!

tearDownTempStream
	filestream close!

tempReadStream
	^self streamClass read: tempFileName!

tempReadWriteStream
	| answer |
	answer := self streamClass 
				write: tempFileName
				mode: #append
				check: false
				text: false.
	answer reset.
	^answer!

tempWriteStream
	"Private - Answer a writeable FileStream on a temporary file."

	^self tempWriteStream: #text!

tempWriteStream: aSymbol
	^self streamClass
		write: tempFileName
		mode: #truncate
		check: false
		type: aSymbol!

test1065
	| r |
	r := Random new.
	#(0 1 512 4095 4096 8191 8192 8193 16383 16384 16385) do: 
			[:i |
			| data written |
			data := ((1 to: i) collect: [:each | (r next * 256) truncated]) asByteArray.
			filestream := self streamClass write: tempFileName text: false.
			filestream
				next: data size
				putAll: data
				startingAt: 1.
			filestream close.
			written := File readAllBytes: tempFileName.
			self
				assert: data = written
				description: 'Failed on write of ' , i printString , ' bytes'
				resumable: true]!

test64BitPosition
	filestream := self tempWriteStream: #binary.
	{2 ** 33 - 1. self maxPosition} do: 
			[:position |
			filestream position: position.
			self assert: filestream position equals: position]!

testAppend
	| actual padding |
	filestream := self tempWriteStream: #utf8.
	padding := String new: self bufferSize - Utf8String.Bom size - 1 withAll: $\x20.
	filestream
		nextPutAll: padding;
		nextPut: Character dolphin.
	filestream close.
	filestream := self streamClass
				write: tempFileName
				mode: #append
				check: false
				type: #utf8.
	filestream nextPutAll: ' says hello'.
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: (actual beginsWith: padding).
	self assert: (actual copyFrom: padding size + 1)
		equals: Character dolphin asUtf8String , ' says hello'!

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

testPositionAfterWrite
	| actual |
	filestream := self tempWriteStream: #ansi.
	filestream position: 100.
	filestream nextPut: $a.
	"Reposition to a later point, but don't write anything."
	filestream position: 200.
	"Only the content up to the last actual write position should be flushed to the file."
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: 101.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: 101) equals: $a.
	self assert: (actual occurrencesOf: $\0) equals: 100!

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

testRandomWriteOnePage
	| pos actual |
	filestream := self tempWriteStream: #ansi.
	pos := FileStream.PageSize - 2.
	filestream position: pos.
	self assert: filestream position equals: pos.
	self assert: filestream size equals: 0.
	self assert: filestream atEnd.
	filestream nextPut: $a.
	"Reposition behind the point we extended the file to and write something earlier in the page."
	filestream position: pos - 100.
	filestream nextPutAll: 'b'.
	"We expect the content to be flushed up to the first char we wrote (which is the last positionally)"
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: FileStream.PageSize - 1.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: pos + 1) equals: $a.
	self assert: (actual at: pos - 100 + 1) equals: $b.
	self assert: (actual occurrencesOf: $\0) equals: FileStream.PageSize - 1 - 2!

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

testRewindAfterWrite
	| actual |
	filestream := self tempWriteStream.
	filestream nextPutAll: 'Hello'.
	filestream position: 1.
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: 'Hello'!

testTruncate
	| actual |
	filestream := self tempWriteStream.
	filestream nextPutAll: 'hello'.
	filestream close.
	filestream := self streamClass
				write: tempFileName
				mode: #truncate
				check: false
				text: true.
	filestream nextPutAll: ' world'.
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: ' world'!

writeableCollections
	^self strings , self byteArrays! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #arrayedCollections!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #blockWriteIntervals!constants!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #bufferSize!constants!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #closeTempStream:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #collections!private!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #initializeRandomTestData!initializing!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #maxPosition!constants!public! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #randomData1!constants!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #randomData2!constants!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #readWriteStreamOnString:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #setUp!public!running! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #streamClassSupportsPointers!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #streamOnBytes:type:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #streamWith:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #strings!constants!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tearDown!public!running! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tearDownTempStream!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tempReadStream!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tempReadWriteStream!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tempWriteStream!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #tempWriteStream:!helpers!private! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #test1065!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #test64BitPosition!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testAppend!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt2!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testPositionAfterWrite!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testPositionPastEnd!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testRandomWriteOnePage!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testReset!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testRewindAfterWrite!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #testTruncate!public!unit tests! !
!Core.Tests.AbstractFileStreamTest categoriesFor: #writeableCollections!constants!private! !

