"Filed out from Dolphin Smalltalk 7"!

ReadWriteStreamTest subclass: #AbstractFileStreamTest
	instanceVariableNames: 'tempFileName'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractFileStreamTest guid: (GUID fromString: '{FC7D3BEE-D1B0-477D-A33C-33EE6CFB0339}')!
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
	^self tempReadWriteStream!

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

testAppend
	| stream temp stream2 stream3 |
	stream := self tempWriteStream.
	temp := stream name.
	[stream nextPutAll: 'hello'] ensure: [stream close].
	stream2 := FileStream 
				write: temp
				mode: #append
				check: false
				text: true.
	[stream2 nextPutAll: ' world'] ensure: [stream2 close].
	stream3 := FileStream read: temp.
	self assert: stream3 contents = 'hello world'.
	self closeTempStream: stream3!

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
			fs := self streamClass read: tempFileName text: false.
			[written := fs contents] ensure: [fs close].
			self assert: written = initialData.
			fs := self tempReadWriteStream.
			
			[| size |
			fs position: each first - 1.
			size := each last - each first + 1.
			fs 
				next: size
				putAll: dataToWrite
				startingAt: each first.
			self assert: fs position = each last.
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
			fs := self streamClass read: tempFileName text: false.
			[contents := fs contents] ensure: [fs close].
			self assert: contents = expected]!

testNextPutAllStartingAt2
	| r initialData dataToWrite |
	r := Random new.
	initialData := ((1 to: 32000) collect: [:each | (r next * 256) truncated]) asByteArray.
	dataToWrite := ((1 to: 32769) collect: [:each | (r next * 256) truncated]) asByteArray.
	self blockWriteIntervals do: 
			[:each | 
			"truncate the file"

			| fs expected contents |
			(File 
				open: tempFileName
				mode: #truncate
				check: false) close.
			fs := self tempReadWriteStream.
			
			[fs 
				next: each first - 1
				putAll: initialData
				startingAt: 1.
			self assert: fs position = (each first - 1).
			fs 
				next: each last - each first + 1
				putAll: dataToWrite
				startingAt: each first.
			self assert: fs position = each last.
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
			fs := self streamClass read: tempFileName text: false.
			[contents := fs contents] ensure: [fs close].
			self assert: contents = expected]!

testRewindAfterWrite
	| stream name |
	stream := self streamWith: String new.
	stream nextPutAll: 'Hello'.
	stream position: 1.
	name := stream name.
	stream close.
	stream := self streamClass read: name.
	self assert: stream contents = 'Hello'.
	self closeTempStream: stream!

testTruncate
	| stream temp |
	stream := self tempWriteStream.
	temp := stream name.
	[stream nextPutAll: 'hello'] ensure: [stream close].
	stream := FileStream 
				write: temp
				mode: #truncate
				check: false
				text: true.
	[stream nextPutAll: ' world'] ensure: [stream close].
	stream := FileStream read: temp.
	self assert: stream contents = ' world'.
	self closeTempStream: stream! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #assertBufferEmptyOrDirty:size:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #blockWriteIntervals!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #closeTempStream:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #readWriteStreamOnString:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #setUp!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #streamWith:!helpers!private! !
!AbstractFileStreamTest categoriesFor: #tearDown!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempReadStream!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempReadWriteStream!private!unit tests! !
!AbstractFileStreamTest categoriesFor: #tempWriteStream!helpers!private! !
!AbstractFileStreamTest categoriesFor: #testAppend!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testNextPutAllStartingAt2!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testRewindAfterWrite!public!unit tests! !
!AbstractFileStreamTest categoriesFor: #testTruncate!public!unit tests! !

!AbstractFileStreamTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!AbstractFileStreamTest class categoriesFor: #isAbstract!public!Testing! !

