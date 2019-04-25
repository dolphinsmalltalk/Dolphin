"Filed out from Dolphin Smalltalk 7"!

AbstractFileStreamTest subclass: #StdioFileStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioFileStreamTest guid: (GUID fromString: '{d3e882fd-385f-45ec-b975-c31f9e777b4b}')!
StdioFileStreamTest comment: ''!
!StdioFileStreamTest categoriesForClass!Unclassified! !
!StdioFileStreamTest methodsFor!

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
!StdioFileStreamTest categoriesFor: #bufferSize!constants!private! !
!StdioFileStreamTest categoriesFor: #maxPosition!constants!private! !
!StdioFileStreamTest categoriesFor: #streamClass!helpers!private! !
!StdioFileStreamTest categoriesFor: #streamOnFile:type:!helpers!private! !
!StdioFileStreamTest categoriesFor: #strings!constants!private! !
!StdioFileStreamTest categoriesFor: #subjectCollection:!public! !
!StdioFileStreamTest categoriesFor: #testCharacterTranslation!public!unit tests! !
!StdioFileStreamTest categoriesFor: #testNextLineCrOnly!public!unit tests! !
!StdioFileStreamTest categoriesFor: #testNextLineUpToEof!public!unit tests! !

!StdioFileStreamTest class methodsFor!

allTestSelectors
	| roCategory |
	roCategory := 'strict utf8' asMethodCategory.
	^super allTestSelectors reject: [:each | roCategory includesMethod: (self lookupMethod: each)]! !
!StdioFileStreamTest class categoriesFor: #allTestSelectors!Accessing!public! !

