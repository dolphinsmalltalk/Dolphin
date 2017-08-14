"Filed out from Dolphin Smalltalk 7"!

ReadWriteStreamTest subclass: #AbstractFileStreamTest
	instanceVariableNames: 'tempFileName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractFileStreamTest guid: (GUID fromString: '{fc7d3bee-d1b0-477d-a33c-33ee6cfb0339}')!
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

maxPosition
	^self subclassResponsibility!

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
	tempFileName isNil ifTrue: [^self].
	[File delete: tempFileName] on: Error do: [:ex | ex toTrace].
	tempFileName := nil!

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
			| data stream written |
			data := ((1 to: i) collect: [:each | (r next * 256) truncated]) asByteArray.
			stream := self streamClass write: tempFileName text: false.
			
			[stream
				next: data size
				putAll: data
				startingAt: 1] ensure: [stream close].
			written := File readAllBytes: tempFileName.
			self
				assert: data = written
				description: 'Failed on write of ' , i printString , ' bytes'
				resumable: true]!

test64BitPosition
	| stream |
	stream := self tempWriteStream.
	{2 ** 33 - 1. self maxPosition} do: 
			[:position |
			stream position: position.
			self assert: stream position equals: position]!

testAppend
	| stream stream2 actual |
	stream := self tempWriteStream.
	[stream nextPutAll: 'hello'] ensure: [stream close].
	stream2 := self streamClass
				write: tempFileName
				mode: #append
				check: false
				text: true.
	[stream2 nextPutAll: ' world'] ensure: [stream2 close].
	actual := File readAllText: tempFileName.
	self assert: actual equals: 'hello world'!

testNextPutAllStartingAt
	| r initialData dataToWrite |
	r := Random new.
	initialData := ((1 to: 32000) collect: [:each | (r next * 256) truncated]) asByteArray.
	dataToWrite := ((1 to: 32769) collect: [:each | (r next * 256) truncated]) asByteArray.
	self blockWriteIntervals do: 
			[:each |
			| f fs expected written contents |
			f := File
						open: tempFileName
						mode: #truncate
						check: false.
			[f write: initialData] ensure: [f close].
			"Verify it was written correctly in the first place"
			written := File readAllBytes: tempFileName.
			self assert: written equals: initialData.
			fs := self tempReadWriteStream.
			
			[| size |
			fs position: each first - 1.
			size := each last - each first + 1.
			fs
				next: size
				putAll: dataToWrite
				startingAt: each first.
			self assert: fs position equals: each last.
			self assertBufferEmptyOrDirty: fs size: size.
			self assert: ((each last >= initialData size and: [fs atEnd])
						or: [fs next = (initialData at: each last + 1)])]
					ensure: [fs close].
			"Expected data will be composed of a (possibly empty) block of the original data, a (possibly empty) block of the
			new data, and a (possibly empty) block of the original data"
			expected := (initialData copyFrom: 1 to: each first - 1)
						, (dataToWrite copyFrom: each first to: each last).
			each last <= initialData size
				ifTrue: [expected := expected , (initialData copyFrom: each last + 1)].
			contents := File readAllBytes: tempFileName.
			self assert: contents equals: expected]!

testNextPutAllStartingAt2
	| r initialData dataToWrite |
	r := Random new.
	initialData := ((1 to: 32000) collect: [:each | (r next * 256) truncated]) asByteArray.
	dataToWrite := ((1 to: 32769) collect: [:each | (r next * 256) truncated]) asByteArray.
	self blockWriteIntervals do: 
			[:each |
			| fs expected contents |
			"truncate the file"
			(File
				open: tempFileName
				mode: #truncate
				check: false) close.
			fs := self tempReadWriteStream.
			
			[fs
				next: each first - 1
				putAll: initialData
				startingAt: 1.
			self assert: fs position equals: each first - 1.
			fs
				next: each last - each first + 1
				putAll: dataToWrite
				startingAt: each first.
			self assert: fs position equals: each last.
			self assertBufferEmptyOrDirty: fs.
			each last <= initialData size
				ifTrue: 
					[fs
						next: initialData size - each last
						putAll: initialData
						startingAt: each last + 1]]
					ensure: [fs close].
			"Expected data will be composed of a (possibly empty) block of the original data, a (possibly empty) block of the
			new data, and a (possibly empty) block of the original data"
			expected := (initialData copyFrom: 1 to: each first - 1)
						, (dataToWrite copyFrom: each first to: each last).
			each last <= initialData size
				ifTrue: [expected := expected , (initialData copyFrom: each last + 1)].
			contents := File readAllBytes: tempFileName.
			self assert: contents equals: expected]!

testPositionAfterWrite
	| stream actual |
	stream := self tempWriteStream.
	stream position: 100.
	stream nextPut: $a.
	"Reposition to a later point, but don't write anything."
	stream position: 200.
	"Only the content up to the last actual write position should be flushed to the file."
	stream close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: 101.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: 101) equals: $a.
	self assert: (actual occurrencesOf: $\0) equals: 100!

testPositionPastEnd
	| subject pos1 pos2 expected actual pos3 |
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
	| stream pos actual |
	stream := self tempWriteStream.
	pos := FileStream.PageSize - 2.
	stream position: pos.
	self assert: stream position equals: pos.
	self assert: stream size equals: 0.
	self assert: stream atEnd.
	stream nextPut: $a.
	"Reposition behind the point we extended the file to and write something earlier in the page."
	stream position: pos - 100.
	stream nextPutAll: 'b'.
	"We expect the content to be flushed up to the first char we wrote (which is the last positionally)"
	stream close.
	actual := File readAllText: tempFileName.
	self assert: actual size equals: FileStream.PageSize - 1.
	"Note that the stream position is (rather unusually for Smalltalk) zero based"
	self assert: (actual at: pos + 1) equals: $a.
	self assert: (actual at: pos - 100 + 1) equals: $b.
	self assert: (actual occurrencesOf: $\0) equals: FileStream.PageSize - 1 - 2!

testReset
	"#1724"

	| stream content |
	stream := self tempWriteStream.
	stream next: 3 put: $A.
	stream reset.
	content := stream upToEnd.
	self assert: content = 'AAA'.
	self assert: stream atEnd.
	stream close.
	stream := self tempWriteStream.
	stream next: 9999 put: $A.
	stream reset.
	content := stream upToEnd.
	self assert: (content size = 9999 and: [content allSatisfy: [:each | each = $A]]).
	self assert: stream atEnd.
	stream close!

testRewindAfterWrite
	| stream actual |
	stream := self tempWriteStream.
	stream nextPutAll: 'Hello'.
	stream position: 1.
	stream close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: 'Hello'!

testTruncate
	| stream actual |
	stream := self tempWriteStream.
	[stream nextPutAll: 'hello'] ensure: [stream close].
	stream := self streamClass
				write: tempFileName
				mode: #truncate
				check: false
				text: true.
	[stream nextPutAll: ' world'] ensure: [stream close].
	actual := File readAllText: tempFileName.
	self assert: actual equals: ' world'! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #blockWriteIntervals!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #closeTempStream:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #maxPosition!public! !
!AbstractFileStreamTest categoriesFor: #readWriteStreamOnString:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #setUp!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #streamWith:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tearDown!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempReadStream!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempReadWriteStream!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempWriteStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #test1065!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #test64BitPosition!public! !
!AbstractFileStreamTest categoriesFor: #testAppend!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt2!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testPositionAfterWrite!public! !
!AbstractFileStreamTest categoriesFor: #testPositionPastEnd!public! !
!AbstractFileStreamTest categoriesFor: #testRandomWriteOnePage!public! !
!AbstractFileStreamTest categoriesFor: #testReset!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testRewindAfterWrite!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testTruncate!public!unit tests! !

!AbstractFileStreamTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!AbstractFileStreamTest class categoriesFor: #isAbstract!public!Testing! !

