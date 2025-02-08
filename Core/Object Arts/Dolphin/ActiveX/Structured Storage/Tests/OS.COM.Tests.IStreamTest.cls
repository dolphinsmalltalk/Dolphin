"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.COM.Tests.IStreamTest'
	instanceVariableNames: 'temp'
	classVariableNames: ''
	imports: #(#{OS.COM.StorageConstants})
	classInstanceVariableNames: ''
	classConstants: {}!

OS.COM.Tests.IStreamTest guid: (Core.GUID fromString: '{4a9f8a1d-6363-4e51-aaa3-f52a81f52344}')!

OS.COM.Tests.IStreamTest comment: ''!

!OS.COM.Tests.IStreamTest methodsFor!

helloWorld
	^'Hello🐬World' asUtf8String!

setUp
	super setUp.
	temp := File temporaryFilename!

tearDown
	(File exists: temp) ifTrue: [File delete: temp].
	super tearDown!

testAppendToFile
	| stream |
	self writeHelloWorldFile.
	stream := IStream write: temp mode: #append.
	self assert: stream atEnd.
	stream nextPut: $s codePoint.
	stream close.
	self assert: (File readAllText: temp) equals: self helloWorld , 's'!

testAppendToNonExistantFile
	self
		should: [IStream write: temp , 'x' mode: #append]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_FILE_NOT_FOUND]!

testContentsOfFile
	| stream text |
	text := BlockClosure comment asByteArray.
	(File write: temp)
		write: text;
		close.
	stream := IStream read: temp.
	self assert: stream contents equals: text.
	self assert: stream contents equals: text.
	stream close!

testCreateExistingFile
	self
		should: [IStream write: temp mode: #create]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_FILE_EXISTS]!

testReadNonExistantFile
	self
		should: [IStream read: temp , 'x']
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_FILE_NOT_FOUND]!

testReadSharingViolation
	| stream stream2 |
	self writeHelloWorldFile.
	stream := IStream read: temp.
	self assert: (Utf8String fromByteArray: stream contents) equals: self helloWorld.
	"Can't write to it"
	self
		should: [IStream write: temp]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_SHARING_VIOLATION].
	"But should be able to have multiple read streams open"
	stream2 := IStream read: temp.
	self assert: stream2 contents equals: stream contents.
	stream close.
	stream2 close!

testStat
	| subject stat |
	self writeHelloWorldFile.
	subject := IStream read: temp.
	stat := subject stat.
	self assert: stat pwcsName equals: (File splitFilenameFrom: temp).
	self assert: stat mtime equals: (File lastWriteTime: temp).
	self assert: stat grfMode equals: STGM_READ | STGM_SHARE_DENY_WRITE.
	self assert: stat isOLEStream.
	self assert: stat grfLocksSupported equals: 0.
	self assert: stat isFinalizable.
	stat free.
	subject close!

testTruncateFile
	| stream |
	self writeHelloWorldFile.
	self assert: (File readAllText: temp) equals: self helloWorld.
	stream := IStream write: temp mode: #truncate.
	stream nextPutAll: 'Goodbye' asByteArray.
	stream close.
	self assert: (File readAllText: temp) equals: 'Goodbye'!

testUpToEndOfFile
	| stream text |
	text := BlockClosure comment asByteArray.
	(File write: temp)
		write: text;
		close.
	stream := IStream read: temp.
	self assert: (stream next: 99) equals: (text copyFrom: 1 to: 99).
	self assert: stream upToEnd equals: (text copyFrom: 100 to: text size).
	self assert: stream upToEnd isEmpty.
	stream close!

testWriteFileSharingViolation
	| stream |
	stream := IStream write: temp.
	stream nextPutAll: self helloWorld asByteArray.
	self
		should: [IStream read: temp]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_SHARING_VIOLATION].
	self
		should: [IStream write: temp]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_SHARING_VIOLATION].
	self
		should: [File readAllText: temp]
		raise: HRESULTError
		matching: [:ex | ex statusCode = ERROR_SHARING_VIOLATION].
	stream close!

testWriteReadFile
	| stream |
	(IStream write: temp)
		nextPutAll: self helloWorld asByteArray;
		close.
	stream := IStream read: temp.
	self assert: (Utf8String fromByteArray: stream contents) equals: self helloWorld.
	stream close!

writeHelloWorldFile
	"Don't want a Bom in the file. IStreams do not have a text mode."

	(File write: temp)
		write: self helloWorld;
		close! !

!OS.COM.Tests.IStreamTest categoriesForMethods!
helloWorld!constants!private! !
setUp!public!running! !
tearDown!public!running! !
testAppendToFile!public!unit tests! !
testAppendToNonExistantFile!public!unit tests! !
testContentsOfFile!public!unit tests! !
testCreateExistingFile!public!unit tests! !
testReadNonExistantFile!public!unit tests! !
testReadSharingViolation!public!unit tests! !
testStat!public!unit tests! !
testTruncateFile!public!unit tests! !
testUpToEndOfFile!public!unit tests! !
testWriteFileSharingViolation!public!unit tests! !
testWriteReadFile!public!unit tests! !
writeHelloWorldFile!helpers!private! !
!

