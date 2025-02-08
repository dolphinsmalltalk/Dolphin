"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractWriteStreamTest
	subclass: #'Core.Tests.FileWriteStreamTest'
	instanceVariableNames: 'tempFileName filestream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.FileWriteStreamTest guid: (Core.GUID fromString: '{a00fbe20-a34e-4d17-9971-5327283a2b6a}')!

Core.Tests.FileWriteStreamTest comment: ''!

!Core.Tests.FileWriteStreamTest methodsFor!

arrayedCollections
	^self strings , self byteArrays!

closeTempStream
	filestream ifNotNil: [filestream close].
	filestream := nil!

collections
	^self arrayedCollections!

expectedAnsiProtocolNames
	^#(#Object #puttableStream #writeFileStream)!

fileContents: aFileWriteStream
	aFileWriteStream filePosition > 0 ifFalse: [^aFileWriteStream collection class empty].
	^aFileWriteStream encoding == #binary
		ifTrue: [File readAllBytes: aFileWriteStream name share: #readWrite]
		ifFalse: [File readAllText: aFileWriteStream name share: #readWrite]!

filestream: aFileWriteStream
	self closeTempStream.
	filestream := aFileWriteStream!

newStream: aSymbol
	^self streamClass
		write: tempFileName
		type: aSymbol
		share: #readWrite!

newUtf8StreamBufferSize: anInteger 
	^super newUtf8StreamBufferSize: anInteger + $\xFEFF utf8Length!

setUp
	super setUp.
	tempFileName := File temporaryFilename!

sharingError
	^FileException matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_SHARING_VIOLATION]!

streamClassSupportsPointers
	^false!

streamedContents: aFileWriteStream
	^(aFileWriteStream filePosition > 0
		ifTrue: 
			[aFileWriteStream encoding == #binary
				ifTrue: [File readAllBytes: aFileWriteStream name share: #readWrite]
				ifFalse: [File readAllText: aFileWriteStream name share: #readWrite]]
		ifFalse: [aFileWriteStream collection class empty]) , aFileWriteStream bufferContents!

streamOn: aString
	self streamWith: aString.
	filestream reset.
	^filestream!

streamOnBuffer: anObject
	self closeTempStream.
	filestream := self streamClass
				on: (File
						open: tempFileName
						mode: #truncate
						check: false
						share: #read)
				buffer: anObject
				flags: FileWriteStream.OwnsFile.
	^filestream!

streamWith: aString
	self closeTempStream.
	filestream := self tempWriteStream: aString encoding.
	filestream nextPutAll: aString.
	^filestream!

tearDown
	self closeTempStream.
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

tempReadStream: aSymbol
	"Note we have to return a FileStream here, because FileWriteStreams are (obviously) not readable"

	self filestream: (FileStream read: tempFileName type: aSymbol).
	^filestream!

tempWriteStream: aSymbol
	"Private - We deliberately open the file in a shareable mode so we can alread read the data written to the file for testing purposes while the stream is still open"

	self filestream: (self newStream: aSymbol).
	^filestream!

testNextPutAllUtf8
	| string written actual offset bufferSize |
	offset := $\xFEFF utf8Length.
	bufferSize := 16.
	filestream := self newUtf8StreamBufferSize: bufferSize - offset.
	self assert: filestream collection size equals: bufferSize.
	written := ''.
	self assert: filestream file size equals: 0.
	self assert: filestream collection
		equals: ((String new: bufferSize)
				encodedAt: 1 put: $\xFEFF;
				yourself).
	self assert: filestream position equals: 0.
	self assert: filestream bufferPosition equals: offset.
	self assert: filestream absolutePosition equals: offset.
	"Write nothing"
	filestream nextPutAll: ''.
	self assert: filestream file size equals: 0.
	self assert: filestream position equals: 0.
	self assert: filestream bufferPosition equals: offset.
	self assert: filestream absolutePosition equals: offset.
	"Write one byte"
	filestream nextPutAll: '1'.
	written := '1'.
	self assert: filestream file size equals: 0.
	self assert: filestream position equals: 1.
	self assert: filestream collection
		equals: ((String new: bufferSize)
				encodedAt: 1 put: $\xFEFF;
				encodedAt: offset + 1 put: $1;
				yourself).
	self assert: filestream bufferPosition equals: offset + 1.
	self assert: filestream absolutePosition equals: offset + 1.
	"Fill the first page up to the penultimate byte"
	string := String new: bufferSize - offset - 2 withAll: $Q.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: 0.
	self assert: filestream bufferPosition equals: bufferSize - 1.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $Q)
				encodedAt: 1 put: $\xFEFF;
				encodedAt: offset + 1 put: $1;
				at: bufferSize put: $\0;
				yourself).
	self assert: filestream absolutePosition equals: bufferSize - 1.
	self assert: filestream position equals: bufferSize - 1 - offset.
	"Fill the last byte - page full, but not written yet"
	string := 'Z'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: 0.
	self assert: filestream bufferPosition equals: bufferSize.
	self assert: filestream collection equals: (String with: $\xFEFF) , written.
	self assert: filestream absolutePosition equals: bufferSize.
	self assert: filestream position equals: bufferSize - offset.
	"Write another byte to overflow into next page"
	string := 'A'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: bufferSize.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $Q)
				encodedAt: 1 put: $\xFEFF;
				at: 1 put: $A;
				at: offset + 1 put: $1;
				at: bufferSize put: $Z;
				yourself).
	self assert: filestream bufferPosition equals: 1.
	self assert: filestream absolutePosition equals: bufferSize + 1.
	self assert: filestream position equals: bufferSize + 1 - offset.
	"Fill the 2nd page up to the last byte"
	string := String new: bufferSize - 2 withAll: $Y.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: bufferSize.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $Y)
				at: 1 put: $A;
				at: bufferSize put: $Z;
				yourself).
	self assert: filestream bufferPosition equals: bufferSize - 1.
	self assert: filestream absolutePosition equals: bufferSize * 2 - 1.
	self assert: filestream position equals: written size.
	"Write a two byte char causing single byte overflow to next page"
	string := '£'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: bufferSize * 2.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $Y)
				at: 1 put: ('£' at: 2);
				at: bufferSize put: ('£' at: 1);
				yourself).
	self assert: filestream bufferPosition equals: 1.
	self assert: filestream absolutePosition equals: bufferSize * 2 + 1.
	self assert: filestream position equals: bufferSize * 2 + 1 - offset.
	"Fill the buffer up to the 2nd to last byte"
	string := String new: bufferSize - filestream bufferPosition - 2 withAll: $R.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream file size equals: bufferSize * 2.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $R)
				at: 1 put: ('£' at: 2);
				at: bufferSize - 1 put: $Y;
				at: bufferSize put: ('£' at: 1);
				yourself).
	self assert: filestream bufferPosition equals: 1 + string size.
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.
	"Write a three byte char causing 1-byte overflow to next page"
	string := '€'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream bufferPosition equals: 1.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $R)
				at: 1 put: ('€' at: 3);
				at: bufferSize - 1 put: ('€' at: 1);
				at: bufferSize put: ('€' at: 2);
				yourself).
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.
	"Fill the 4th page up to the 2nd to last byte"
	string := String new: bufferSize - $€ utf8Length withAll: $T.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream bufferPosition equals: bufferSize - 2.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $T)
				at: 1 put: ('€' at: 3);
				at: bufferSize - 1 put: ('€' at: 1);
				at: bufferSize put: ('€' at: 2);
				yourself).
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.
	"Write a four byte char causing 2-byte overflow to next page"
	string := '𐀀'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream bufferPosition equals: 2.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $T)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				at: bufferSize - 1 put: ('𐀀' at: 1);
				at: bufferSize put: ('𐀀' at: 2);
				yourself).
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.
	"Fill the 5th page up to allow enough space for a 4-byte char"
	string := String new: bufferSize - $𐀀 utf8Length - 2 withAll: $X.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream bufferPosition equals: bufferSize - 4.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $X)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				at: bufferSize - 3 put: $T;
				at: bufferSize - 2 put: $T;
				at: bufferSize - 1 put: ('𐀀' at: 1);
				at: bufferSize put: ('𐀀' at: 2);
				yourself).
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.
	"Write a four byte char to just fill the page"
	string := '🐬'.
	filestream nextPutAll: string.
	written := written , string.
	self assert: filestream bufferPosition equals: bufferSize.
	self assert: filestream collection
		equals: ((String new: bufferSize withAll: $X)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				encodedAt: bufferSize - 3 put: $🐬;
				yourself).
	self assert: filestream absolutePosition equals: written size + offset.
	self assert: filestream position equals: written size.

	"Final sanity check that we actually wrote what we expected"
	filestream close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: written!

testNextPutUtf8
	| count written actual offset bufferSize subject |
	offset := $\xFEFF utf8Length.
	bufferSize := 16.
	subject := self newUtf8StreamBufferSize: bufferSize - offset.
	self assert: (self bufferSizeOfStream: subject) equals: bufferSize.
	written := ''.
	self assert: subject file size equals: 0.
	self assert: subject collection
		equals: ((String new: bufferSize)
				encodedAt: 1 put: $\xFEFF;
				yourself).
	self assert: subject position equals: 0.
	self assert: subject bufferPositionEquals: offset.
	self assert: subject absolutePosition equals: offset.
	"Write one byte"
	subject nextPut: $1.
	written := '1'.
	self assert: subject file size equals: 0.
	self assert: subject position equals: 1.
	self assert: subject collection
		equals: ((String new: bufferSize)
				encodedAt: 1 put: $\xFEFF;
				encodedAt: offset + 1 put: $1;
				yourself).
	self assert: subject bufferPositionEquals: offset + 1.
	self assert: subject absolutePosition equals: offset + 1.
	"Fill the first page up to the penultimate byte"
	bufferSize - offset - 2 timesRepeat: [subject nextPut: $Q].
	written := written , (String new: bufferSize - offset - 2 withAll: $Q).
	self assert: subject file size equals: 0.
	self assert: subject bufferPosition equals: bufferSize - 1.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $Q)
				encodedAt: 1 put: $\xFEFF;
				encodedAt: offset + 1 put: $1;
				at: bufferSize put: $\0;
				yourself).
	self assert: subject absolutePosition equals: bufferSize - 1.
	self assert: subject position equals: bufferSize - 1 - offset.
	"Fill the last byte - page full, but not written yet"
	subject nextPut: $Z.
	written := written copyWith: $Z.
	self assert: subject file size equals: 0.
	self assert: subject bufferPositionEquals: bufferSize.
	self assert: subject collection equals: (String with: $\xFEFF) , written.
	self assert: subject absolutePosition equals: bufferSize.
	self assert: subject position equals: bufferSize - offset.
	"Write another byte to overflow into next page"
	subject nextPut: $A.
	written := written copyWith: $A.
	self assert: subject file size equals: bufferSize.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $Q)
				encodedAt: 1 put: $\xFEFF;
				at: 1 put: $A;
				at: offset + 1 put: $1;
				at: bufferSize put: $Z;
				yourself).
	self assert: subject bufferPositionEquals: 1.
	self assert: subject absolutePosition equals: bufferSize + 1.
	self assert: subject position equals: bufferSize + 1 - offset.
	"Fill the 2nd page up to the last byte"
	bufferSize - 2 timesRepeat: [subject nextPut: $Y].
	written := written , (String new: bufferSize - 2 withAll: $Y).
	self assert: subject file size equals: bufferSize.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $Y)
				at: 1 put: $A;
				at: bufferSize put: $Z;
				yourself).
	self assert: subject bufferPosition equals: bufferSize - 1.
	self assert: subject absolutePosition equals: bufferSize * 2 - 1.
	self assert: subject position equals: written size.
	"Write a two byte char causing one byte of encoding to overflow to next page"
	subject nextPut: $£.
	written := written copyWith: $£.
	self assert: subject bufferPosition equals: 1.
	self assert: subject file size equals: written size - 1 + offset.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $Y)
				at: 1 put: ('£' at: 2);
				at: bufferSize put: ('£' at: 1);
				yourself).
	self assert: subject absolutePosition equals: bufferSize * 2 + 1.
	self assert: subject position equals: bufferSize * 2 + 1 - offset.
	"Fill the buffer up to the 2nd to last byte"
	count := bufferSize - subject bufferPosition - 2.
	count timesRepeat: [subject nextPut: $R].
	written := written , (String new: count withAll: $R).
	self assert: subject file size equals: bufferSize * 2.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $R)
				at: 1 put: ('£' at: 2);
				at: bufferSize - 1 put: $Y;
				at: bufferSize put: ('£' at: 1);
				yourself).
	self assert: subject bufferPosition equals: 1 + count.
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.
	"Write a three byte char causing 1-byte overflow to next page"
	subject nextPut: $€.
	written := written copyWith: $€.
	self assert: subject bufferPosition equals: 1.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $R)
				at: 1 put: ('€' at: 3);
				at: bufferSize - 1 put: ('€' at: 1);
				at: bufferSize put: ('€' at: 2);
				yourself).
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.
	"Fill the 4th page up to the 2nd to last byte"
	count := bufferSize - $€ utf8Length.
	count timesRepeat: [subject nextPutAll: $T].
	written := written , (String new: count withAll: $T).
	self assert: subject bufferPosition equals: bufferSize - 2.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $T)
				at: 1 put: ('€' at: 3);
				at: bufferSize - 1 put: ('€' at: 1);
				at: bufferSize put: ('€' at: 2);
				yourself).
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.
	"Write a four byte char causing 2-byte overflow to next page"
	subject nextPut: $𐀀.
	written := written copyWith: $𐀀.
	self assert: subject bufferPosition equals: 2.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $T)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				at: bufferSize - 1 put: ('𐀀' at: 1);
				at: bufferSize put: ('𐀀' at: 2);
				yourself).
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.
	"Fill the 5th page up to allow enough space for a 4-byte char"
	bufferSize - 6 timesRepeat: [subject nextPut: $X].
	written := written , (String new: bufferSize - 6 withAll: $X).
	self assert: subject bufferPosition equals: bufferSize - 4.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $X)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				replaceFrom: bufferSize - 3
					to: bufferSize
					with: 'TT𐀀'
					startingAt: 1;
				yourself).
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.
	"Write a four byte char to just fill the page"
	subject nextPut: $🐬.
	written := written copyWith: $🐬.
	self assert: subject bufferPosition equals: bufferSize.
	self assert: subject collection
		equals: ((String new: bufferSize withAll: $X)
				at: 1 put: ('𐀀' at: 3);
				at: 2 put: ('𐀀' at: 4);
				encodedAt: bufferSize - 3 put: $🐬;
				yourself).
	self assert: subject absolutePosition equals: written size + offset.
	self assert: subject position equals: written size.

	"Final sanity check that we actually wrote what we expected"
	subject close.
	actual := File readAllText: tempFileName.
	self assert: actual equals: written!

testOwnsFile
	| subject file |
	subject := self streamClass write: tempFileName.
	self assert: subject ownsFile.
	file := subject file.
	self assert: file handle isKindOf: External.Handle.
	subject close.
	self assertIsNil: file handle.
	file open.
	self assert: file handle isKindOf: External.Handle.
	subject := self streamClass on: file.
	self deny: subject ownsFile.
	subject close.
	self assert: file handle isKindOf: External.Handle.
	file close!

testPositionPastEnd
	| pos1 pos2 expected actual pos3 |
	filestream := self tempWriteStream: #ansi.
	pos1 := (filestream class bufferSize * 1.25) truncated.
	filestream position: pos1.
	filestream print: pos1.
	pos2 := filestream class bufferSize * 2 - 1.
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
	content := filestream contents.
	self assert: content equals: 'AAA'.
	filestream close.
	filestream := self tempWriteStream.
	filestream next: 9999 put: $A.
	filestream reset.
	content := filestream contents.
	self assert: (content size = 9999 and: [content allSatisfy: [:each | each = $A]]).
	filestream close!

testSharing
	| sharingError text |
	self filestream: (self streamClass write: tempFileName).
	text := 'Hello 🐬 world'.
	filestream
		nextPutAll: text;
		flush.
	sharingError := self sharingError.
	self should: [self tempWriteStream: #binary] raise: sharingError.
	"By default FileStream read streams are opened with #read sharing, so won't open a stream being written"
	self should: [self tempReadStream: #binary] raise: sharingError.
	"If we open in #text mode the File must be  opened to sniff it, so we'll always get a Win32Error"
	self
		should: [self tempReadStream: #text]
		raise: OS.Win32Error
		matching: [:ex | ex statusCode = OS.Win32Errors.ERROR_SHARING_VIOLATION]!

testWriteManyCharacters
	| many fileSize filename subject |
	many := Object comment.
	subject := self tempWriteStream.
	self deny: subject isReadable.
	subject nextPutAll: many.
	self assert: subject position equals: many size.
	subject flush.
	self assert: subject position equals: many size.
	subject nextPutAll: many.
	self assert: subject position equals: many size * 2.
	filename := subject name.
	subject close.
	self assert: (File readAllText: filename) equals: many , many.
	subject := (self streamClass write: filename mode: #append).
	self filestream: subject.
	fileSize := many size * 2 + $\xFEFF utf8Length.
	self assert: subject position equals: fileSize.
	subject nextPutAll: self streamClass comment.
	fileSize := fileSize + self streamClass comment size.
	subject close.
	self assert: (File fileSize: filename) equals: fileSize.
	self assert: (File readAllText: filename) equals: many , many , self streamClass comment!

testWriteNoBom
	| many file |
	many := Object comment.
	
	[file := File write: tempFileName.
	self filestream: (self streamClass
				on: file
				type: #text
				flags: FileWriteStream.NoBom).
	filestream nextPutAll: many.
	self assert: filestream position equals: many size.
	filestream flush.
	self assert: filestream position equals: many size.
	filestream nextPutAll: many.
	self assert: filestream position equals: many size * 2.
	self closeTempStream.
	"Deliberately attached filestream without giving it ownership, so it should not have closed the file"
	self assert: file handle notNil]
			ensure: [file close].
	self assert: (File readAllText: tempFileName) equals: many , many!

writeableCollections
	^self strings , self byteArrays! !

!Core.Tests.FileWriteStreamTest categoriesForMethods!
arrayedCollections!private! !
closeTempStream!private! !
collections!constants!private! !
expectedAnsiProtocolNames!constants!private! !
fileContents:!private! !
filestream:!private! !
newStream:!helpers!private! !
newUtf8StreamBufferSize:!public! !
setUp!public!running! !
sharingError!constants!private! !
streamClassSupportsPointers!private!testing! !
streamedContents:!private! !
streamOn:!private! !
streamOnBuffer:!private! !
streamWith:!private! !
tearDown!public!running! !
tempReadStream:!helpers!private! !
tempWriteStream:!helpers!private! !
testNextPutAllUtf8!public!unit tests! !
testNextPutUtf8!public!unit tests! !
testOwnsFile!public!unit tests! !
testPositionPastEnd!public!unit tests! !
testReset!public!unit tests! !
testSharing!public!unit tests! !
testWriteManyCharacters!public!unit tests! !
testWriteNoBom!public!unit tests! !
writeableCollections!constants!private! !
!

!Core.Tests.FileWriteStreamTest class methodsFor!

streamClass
	^FileWriteStream! !

!Core.Tests.FileWriteStreamTest class categoriesForMethods!
streamClass!constants!private! !
!

