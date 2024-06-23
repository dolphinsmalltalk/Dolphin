"Filed out from Dolphin Smalltalk"!

OS.StdioUnicodeFileStream
	subclass: #'OS.StdioUtf16FileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.StdioUtf16FileStream guid: (Core.GUID fromString: '{59d77acf-50ff-4508-a672-0eaf7422f32a}')!

OS.StdioUtf16FileStream comment: '`OS.StdioUtf16FileStream` is the concrete class of `StdioFileStream` for streaming over UTF-16 encoded data.'!

!OS.StdioUtf16FileStream categoriesForClass!Collections-Streams! !

!OS.StdioUtf16FileStream methodsFor!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Utf16String!

modeModifiers
	^'t, ccs=UTF-16LE'!

position
	"Answer the absolute (zero-based) position of the file pointer."

	^(super position - offset) bitShift: -1!

position: anInteger
	"Set the receiver's current position reference for accessing the collection to the the
	argument, anInteger. If the argument is not within the bounds of the receiver's collection,
	or if the associated stdio stream is not positionable, report an error."

	super position: (anInteger bitShift: 1) + offset!

size
	"Answer the size of the file in wide characters, excluding the BOM."

	^super size - offset bitShift: -1! !

!OS.StdioUtf16FileStream categoriesForMethods!
contentsSpecies!constants!private! !
modeModifiers!constants!private! !
position!accessing!public! !
position:!positioning!public! !
size!accessing!public! !
!

!OS.StdioUtf16FileStream class methodsFor!

translationMode
	^CRTConstants._O_U16TEXT! !

!OS.StdioUtf16FileStream class categoriesForMethods!
translationMode!constants!private! !
!

