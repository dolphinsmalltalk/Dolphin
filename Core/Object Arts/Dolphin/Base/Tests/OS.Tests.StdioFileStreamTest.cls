"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractFileStreamTest subclass: #'OS.Tests.StdioFileStreamTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.StdioFileStreamTest guid: (Core.GUID fromString: '{d3e882fd-385f-45ec-b975-c31f9e777b4b}')!
OS.Tests.StdioFileStreamTest comment: ''!
!OS.Tests.StdioFileStreamTest methodsFor!

bufferSize
	^128!

maxPosition
	^2 ** 63 - 1!

streamClass
	^StdioFileStream!

streamOnFile: pathString type: aSymbol
	^StdioFileStream read: pathString type: aSymbol!

strings
	| pred |
	pred := [:ch | ch == $\0 or: [ch == $\x1A]].
	^(super strings reject: [:each | each first class elementSize ~~ 1]) collect: 
			[:each |
			"The CRT stdio  streams has issues with nulls in text (bugs in positioning) and will treat Ctrl+Z as EOF (expected behaviour)"
			{each first reject: pred. each last reject: pred}]!

subjectCollection: aSequencableCollection
	^(aSequencableCollection isKindOf: Utf8String)
		ifTrue: 
			["StdioUnicodeFileStream behaves as if streaming over wide chars, regardless of whether encoding is UTF-8 or UTF-16LE"
			Utf16String fromString: aSequencableCollection]
		ifFalse: [aSequencableCollection]!

testCharacterTranslation
	"This is mainly to remind us of some of the stdio librarys quirks when in text translation mode, etc"

	{AnsiString. Utf8String. Utf16String} do: 
			[:eachClass |
			| byteCharSet subject actual expected |
			"Eof"
			filestream := self streamOn: eachClass empty.
			filestream nextPut: Character eof.
			self assert: filestream size equals: 1.
			self assert: filestream contents equals: ''.
			self closeTempStream: filestream.
			self assert: (File readAllText: tempFileName) equals: (eachClass with: Character eof).
			#($\n $\r) do: 
					[:each |
					subject := self streamOn: eachClass empty.
					subject nextPut: each.
					actual := subject contents.
					self assert: subject atEnd.
					self closeTempStream: subject.
					expected := String with: each.
					self assert: actual equals: expected].

			"All the characters except EOF should round trip unchanged"
			byteCharSet := Character byteCharacterSet reject: [:c | c == Character eof].
			subject := self streamOn: eachClass empty.
			byteCharSet do: [:each | subject nextPut: each].
			subject reset.
			byteCharSet do: 
					[:each |
					actual := subject next.
					self assert: actual equals: each].
			self closeTempStream: subject]!

testFileNotFound
	self
		should: [StdioFileStream read: 'Hopefully not there']
		raise: CRTError
		matching: [:ex | ex errno = OS.CRTConstants.ENOENT]!

testFromHandleOnDevice
	"Test that a StdioFileStream instantiated by StdioFileStream class>>fromHandle: is non-blocking on a tty."

	| stdout |
	stdout := SessionManager current stdout.
	self assert: stdout isNonBlocking!

testFromHandleOnFile
	"Test that a StdioFileStream instantiated by StdioFileStream class>>fromHandle: on a file is blocking."

	| handle written read |
	filestream := self tempWriteStream.
	self deny: filestream isNonBlocking.
	written := 'Hello world'.
	filestream nextPutAll: written.
	filestream close.
	handle := Handle new.
	Ucrt
		_wfopen_s: handle
		filename: tempFileName
		mode: 'rt, ccs=UTF-8'.
	filestream := StdioFileStream fromHandle: handle.
	self assert: filestream isFinalizable.
	self deny: filestream isNonBlocking.
	self deny: filestream isDevice.
	read := filestream upToEnd.
	self assert: read equals: written!

testFromHandleOnPipe
	"Test that a StdioFileStream instantiated by StdioFileStream class>>fromHandle: on a pipe is non-blocking."

	| pipeIn pipeOut streams |
	pipeIn := Handle new.
	pipeOut := Handle new.
	Kernel32
		createPipe: pipeIn
		hWritePipe: pipeOut
		lpPipeAttributes: (SECURITY_ATTRIBUTES new
				bInheritHandle: 1;
				yourself)
		nSize: 0.
	streams := {pipeIn -> 'rt'. pipeOut -> 'wt'} collect: 
					[:each |
					| fd hFile |
					"Note that ownership of the OS handle is transferred to the CRT file here"
					fd := Ucrt _open_osfhandle: each key flags: 0.
					hFile := Ucrt _fdopen: fd mode: each value.
					StdioFileStream fromHandle: hFile].
	streams do: 
			[:each |
			self assert: each isFinalizable.
			self assert: each isNonBlocking.
			self deny: each isDevice.
			each close]!

testNextLineCrOnly
	"Test PositionableStream>>nextLine for text streams with <CR> between lines"

	#('a' 'ab' 'a£c') do: 
			[:each |
			| chars |
			chars := each , (String with: Character cr) , each.
			filestream := self streamOn: chars.
			"CRT I/O stream in translated text mode does not recognise single CR as a line ending"
			self assert: filestream nextLine equals: chars.
			self assert: filestream atEnd.
			filestream close]!

testNextLineUpToEof
	#(0 1 2 127 128 129 255 256 257) do: 
			[:each |
			| f expected actual |
			f := self tempWriteStream.
			1 to: each do: [:i | f nextPut: (Character value: i % 95 + 31)].
			expected := f contents.
			f close.
			self assert: expected size equals: each.
			filestream := self tempReadStream.
			actual := filestream nextLine.
			self assert: actual equals: expected.
			filestream close]! !
!OS.Tests.StdioFileStreamTest categoriesForMethods!
bufferSize!constants!private! !
maxPosition!constants!private! !
streamClass!helpers!private! !
streamOnFile:type:!helpers!private! !
strings!constants!private! !
subjectCollection:!helpers!public! !
testCharacterTranslation!public!unit tests! !
testFileNotFound!public!unit tests! !
testFromHandleOnDevice!public!unit tests! !
testFromHandleOnFile!public!unit tests! !
testFromHandleOnPipe!public!unit tests! !
testNextLineCrOnly!public!unit tests! !
testNextLineUpToEof!public!unit tests! !
!

!OS.Tests.StdioFileStreamTest class methodsFor!

allTestSelectors
	| roCategory |
	roCategory := 'strict utf8' asMethodCategory.
	^super allTestSelectors reject: [:each | roCategory includesMethod: (self lookupMethod: each)]! !
!OS.Tests.StdioFileStreamTest class categoriesForMethods!
allTestSelectors!Accessing!public! !
!

