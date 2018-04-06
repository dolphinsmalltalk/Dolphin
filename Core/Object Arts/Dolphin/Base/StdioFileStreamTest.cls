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

collections
	^(super collections reject: [:each | each class elementSize ~~ 1]) collect: 
			[:each |
			"The CRT stdio  streams has issues with nulls in text (bugs in positioning) and will treat Ctrl+Z as EOF (expected behaviour)"
			each reject: [:ch | ch == $\0 or: [ch == $\x1A]]]!

maxPosition
	^2 ** 63 - 1!

streamClass
	^StdioFileStream!

testNextLineCrOnly
	"Test PositionableStream>>nextLine for text streams with <CR> between lines"

	#('a' 'ab' 'abc') do: 
			[:each |
			| chars |
			chars := each , (String with: Character cr) , each.
			subject := self streamOn: chars.
			subject reset.
			"CRT I/O stream in translated text mode does not recognise single CR as a line ending"
			self assert: subject nextLine equals: chars.
			self assert: subject atEnd.
			subject close]!

testNextLineUpToEof
	#(0 1 2 127 128 129 255 256 257) do: 
			[:each |
			| f expected actual |
			f := self tempWriteStream.
			1 to: each do: [:i | f nextPut: (Character value: i % 95 + 31)].
			expected := f contents.
			f close.
			self assert: expected size equals: each.
			subject := self tempReadStream.
			actual := subject nextLine.
			self assert: actual equals: expected.
			subject close]! !
!StdioFileStreamTest categoriesFor: #bufferSize!constants!private! !
!StdioFileStreamTest categoriesFor: #collections!constants!private! !
!StdioFileStreamTest categoriesFor: #maxPosition!constants!private! !
!StdioFileStreamTest categoriesFor: #streamClass!helpers!private! !
!StdioFileStreamTest categoriesFor: #testNextLineCrOnly!public!unit tests! !
!StdioFileStreamTest categoriesFor: #testNextLineUpToEof!public!unit tests! !

