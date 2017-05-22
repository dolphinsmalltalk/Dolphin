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

streamClass
	^StdioFileStream!

testNextLineCrOnly
	"Test PositionableStream>>nextLine for text streams with <CR> between lines"

	#('a' 'ab' 'abc') do: 
			[:each |
			| chars stream |
			chars := each , (String with: Character cr) , each.
			stream := self streamOn: chars.
			stream reset.
			"CRT I/O stream in translated text mode does not recognise single CR as a line ending"
			self assert: chars equals: stream nextLine.
			self assert: stream atEnd.
			self closeTempStream: stream]! !
!StdioFileStreamTest categoriesFor: #streamClass!helpers!private! !
!StdioFileStreamTest categoriesFor: #testNextLineCrOnly!public!unit tests! !

