"Filed out from Dolphin Smalltalk 7"!

ReadWriteStreamTest subclass: #AbstractFileStreamTest
	instanceVariableNames: 'tempFileName subject'
	classVariableNames: 'RandomData1 RandomData2'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractFileStreamTest guid: (GUID fromString: '{fc7d3bee-d1b0-477d-a33c-33ee6cfb0339}')!
AbstractFileStreamTest isAbstract: true!
AbstractFileStreamTest comment: ''!
!AbstractFileStreamTest categoriesForClass!Unclassified! !
!AbstractFileStreamTest methodsFor!

assertBufferEmptyOrDirty: fs 
	!

assertBufferEmptyOrDirty: aFileStream size: anInteger 
	aFileStream flush!

blockWriteIntervals
	^#(#(1 0) #(1 1) #(1 2) #(1 512) #(2 1) #(2 2) #(2 3) #(2 512) #(511 768) #(1 8191) #(2 8191) #(1 8192) #(1 8193) #(1 8194) #(1 16383) #(1 16384) #(1 16385) #(2 8192) #(2 8193) #(2 8194) #(2 16383) #(2 16384) #(2 16385) #(4095 8192) #(4095 8193) #(4095 8194) #(4095 16383) #(4095 16384) #(4095 16385) #(8191 8191) #(8191 8192) #(8191 8193) #(8191 8194) #(8191 16383) #(8191 16384) #(8191 16385) #(8192 8191) #(8192 8192) #(8192 8193) #(8192 8194) #(8192 16383) #(8192 16384) #(8192 16385) #(8191 31999) #(8191 32000) #(8191 32001) #(8191 32767) #(8191 32768) #(8191 32769) #(8192 31999) #(8192 32000) #(8192 32001) #(8192 32767) #(8192 32768) #(8192 32769) #(1 31999) #(2 31999) #(1 32000) #(2 32000) #(1 32001) #(2 32001) #(1 32767) #(2 32767) #(1 32768) #(2 32768) #(1 32769) #(2 32769))!

closeTempStream: aStream 
	"Private - Clean up the temporary stream argument."

	aStream close!

initializeRandomTestData
	| r bytes |
	r := RandomCRT new.
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
	stream := self streamClass write: tempFileName text: true.
	stream nextPutAll: aString.
	^stream!

setUp
	tempFileName := File temporaryFilename!

streamWith: aString 
	"Private - Answer a <gettableStream> of the type the receiver is testing, on the <String> argument."

	^self readWriteStreamOnString: aString!

tearDown
	subject notNil ifTrue: [self tearDownTempStream].
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
	subject close!

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

	^self streamClass write: tempFileName text: true!

test1065
	| r |
	r := Random new.
	#(0 1 512 4095 4096 8191 8192 8193 16383 16384 16385) do: 
			[:i |
			| data written |
			data := ((1 to: i) collect: [:each | (r next * 256) truncated]) asByteArray.
			subject := self streamClass write: tempFileName text: false.
			subject
				next: data size
				putAll: data
				startingAt: 1.
			subject close.
			written := File readAllBytes: tempFileName.
			self
				assert: data = written
				description: 'Failed on write of ' , i printString , ' bytes'
				resumable: true]!

test64BitPosition
	subject := self tempWriteStream.
	{2 ** 33 - 1. self maxPosition} do: 
			[:position |
			subject position: position.
			self assert: subject position equals: position]!

testAppend
	| actual |
	subject := self tempWriteStream.
	subject nextPutAll: 'hello'.
	subject close.
	subject := self streamClass
				write: tempFileName
				mode: #append
				check: false
				text: true.
	subject nextPutAll: ' world'.
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: 'hello world'!

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
			subject := self streamClass on: file text: false.
			subject reset.
			"Verify it was written correctly in the first place"
			written := subject upToEnd.
			self assert: written equals: initialData.
			subject position: each first - 1.
			size := each last - each first + 1.
			subject
				next: size
				putAll: dataToWrite
				startingAt: each first.
			self assert: subject position equals: each last.
			self assertBufferEmptyOrDirty: subject size: size.
			self assert: ((each last >= initialData size and: [subject atEnd])
						or: [subject next = (initialData at: each last + 1)]).
			subject close.
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
			subject := self streamClass on: file text: false.
			subject
				next: each first - 1
				putAll: initialData
				startingAt: 1.
			self assert: subject position equals: each first - 1.
			subject
				next: each last - each first + 1
				putAll: dataToWrite
				startingAt: each first.
			self assert: subject position equals: each last.
			self assertBufferEmptyOrDirty: subject.
			each last <= initialData size
				ifTrue: 
					[subject
						next: initialData size - each last
						putAll: initialData
						startingAt: each last + 1].
			subject close.
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
			self assert: actual equals: expected]!

testPositionAfterWrite
	| actual |
	subject := self tempWriteStream.
	subject position: 100.
	subject nextPut: $a.
	"Reposition to a later point, but don't write anything."
	subject position: 200.
	"Only the content up to the last actual write position should be flushed to the file."
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: 101.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: 101) equals: $a.
	self assert: (actual occurrencesOf: $\0) equals: 100!

testPositionPastEnd
	| pos1 pos2 expected actual pos3 |
	subject := self tempWriteStream.
	pos1 := (FileStream.PageSize * 1.25) truncated.
	subject position: pos1.
	subject print: pos1.
	pos2 := FileStream.PageSize * 2 - 1.
	subject position: pos2.
	subject print: pos2.
	actual := subject contents.
	expected := String writeStream.
	expected
		next: pos1 put: $\0;
		print: pos1.
	expected
		next: pos2 - expected size put: $\0;
		print: pos2.
	expected := expected contents.
	self assert: actual equals: expected.
	subject close.
	subject := self tempReadStream.
	subject position: pos1.
	self assert: subject position equals: pos1.
	actual := subject upTo: $\0.
	self assert: actual equals: pos1 printString.
	subject position: pos2.
	self assert: subject position equals: pos2.
	actual := subject upToEnd.
	self assert: actual equals: pos2 printString.
	pos3 := pos1 * 2.
	subject position: pos3.
	self assert: subject position equals: pos3.
	self assert: subject atEnd.
	self assert: (subject upTo: $\0) equals: ''.
	"Move back, but not into the actual stream content, so should still be at end."
	subject position: pos3 - 100.
	self assert: subject atEnd.
	"Read-only stream should never expand, even if we position past the end."
	actual := subject contents.
	self assert: actual equals: expected.
	self assert: subject size equals: expected size!

testRandomWriteOnePage
	| pos actual |
	subject := self tempWriteStream.
	pos := FileStream.PageSize - 2.
	subject position: pos.
	self assert: subject position equals: pos.
	self assert: subject size equals: 0.
	self assert: subject atEnd.
	subject nextPut: $a.
	"Reposition behind the point we extended the file to and write something earlier in the page."
	subject position: pos - 100.
	subject nextPutAll: 'b'.
	"We expect the content to be flushed up to the first char we wrote (which is the last positionally)"
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: FileStream.PageSize - 1.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: pos + 1) equals: $a.
	self assert: (actual at: pos - 100 + 1) equals: $b.
	self assert: (actual occurrencesOf: $\0) equals: FileStream.PageSize - 1 - 2!

testReset
	"#1724"

	| content |
	subject := self tempWriteStream.
	subject next: 3 put: $A.
	subject reset.
	content := subject upToEnd.
	self assert: content equals: 'AAA'.
	self assert: subject atEnd.
	subject close.
	subject := self tempWriteStream.
	subject next: 9999 put: $A.
	subject reset.
	content := subject upToEnd.
	self assert: (content size = 9999 and: [content allSatisfy: [:each | each = $A]]).
	self assert: subject atEnd.
	subject close!

testRewindAfterWrite
	| actual |
	subject := self tempWriteStream.
	subject nextPutAll: 'Hello'.
	subject position: 1.
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: 'Hello'!

testTruncate
	| actual |
	subject := self tempWriteStream.
	subject nextPutAll: 'hello'.
	subject close.
	subject := self streamClass
				write: tempFileName
				mode: #truncate
				check: false
				text: true.
	subject nextPutAll: ' world'.
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: ' world'! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #blockWriteIntervals!constants!private! !
!AbstractFileStreamTest categoriesFor: #closeTempStream:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #initializeRandomTestData!initializing!private! !
!AbstractFileStreamTest categoriesFor: #maxPosition!constants!public! !
!AbstractFileStreamTest categoriesFor: #randomData1!constants!private! !
!AbstractFileStreamTest categoriesFor: #randomData2!constants!private! !
!AbstractFileStreamTest categoriesFor: #readWriteStreamOnString:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #setUp!public!running! !
!AbstractFileStreamTest categoriesFor: #streamWith:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tearDown!public!running! !
!AbstractFileStreamTest categoriesFor: #tearDownTempStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tempReadStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tempReadWriteStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tempWriteStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #test1065!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #test64BitPosition!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testAppend!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt2!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testPositionAfterWrite!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testPositionPastEnd!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testRandomWriteOnePage!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testReset!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testRewindAfterWrite!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testTruncate!public!unit tests! !

