"Filed out from Dolphin Smalltalk 7"!

AbstractFileStreamTest subclass: #StdioFileStreamTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioFileStreamTest guid: (GUID fromString: '{D3E882FD-385F-45EC-B975-C31F9E777B4B}')!
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

