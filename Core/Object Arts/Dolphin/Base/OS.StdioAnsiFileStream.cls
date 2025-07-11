﻿"Filed out from Dolphin Smalltalk"!

OS.StdioTextFileStream
	subclass: #'OS.StdioAnsiFileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioAnsiFileStream guid: (Core.GUID fromString: '{37ed07fd-6fc6-41d9-aa82-7147a1af19fd}')!

OS.StdioAnsiFileStream comment: '`OS.StdioAnsiFileStream` is the concrete class of `StdioFileStream` for streaming over ANSI string data.'!

!OS.StdioAnsiFileStream categoriesForClass!Collections-Streams! !

!OS.StdioAnsiFileStream methodsFor!

contentsSpecies
	^AnsiString!

getString: anAnsiString
	^crtlib
		fgets: anAnsiString
		n: anAnsiString size + 1
		stream: stream!

modeModifiers
	^'t'!

next
	"Answer a <Character> being the next of the receiver's future sequence values interpreted as
	an ANSI code point. Raise an error if at EOF."

	^Character ansiValue: self basicNext!

nextPutAll: aCollection
	"Store the elements in the argument, aCollection, as the next elements accessible by the receiver. 
	Answer aCollection"

	self prepareToWrite.
	crtlib fputs: aCollection asAnsiString stream: stream.
	^aCollection!

peek
	"Answer the next element in the collection, but do not change the position reference. 
	Answer nil if the receiver is at its end."

	^self basicNextAvailable
		ifNotNil: 
			[:ch |
			crtlib ungetc: ch stream: stream.
			Character ansiValue: ch]!

peekFor: anObject
	"Determine the response to the message peek. If it is the same as the
	argument, anObject, then increment the position reference and answer true.
	Otherwise answer false and do not change the position reference"

	| ch |
	^(ch := self basicNextAvailable) notNil
		and: [ch == anObject ansiValue or: 
					[crtlib ungetc: ch stream: stream.
					false]]! !

!OS.StdioAnsiFileStream categoriesForMethods!
contentsSpecies!accessing!private! !
getString:!private!reading! !
modeModifiers!constants!private! !
next!public!reading! !
nextPutAll:!public!writing! !
peek!public!reading! !
peekFor:!public!reading! !
!

!OS.StdioAnsiFileStream class methodsFor!

translationMode
	^CRTConstants._O_TEXT! !

!OS.StdioAnsiFileStream class categoriesForMethods!
translationMode!constants!private! !
!

