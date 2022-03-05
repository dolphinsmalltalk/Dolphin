"Filed out from Dolphin Smalltalk"!

StdioUnicodeFileStream subclass: #StdioUtf16FileStream
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StdioUtf16FileStream guid: (GUID fromString: '{59d77acf-50ff-4508-a672-0eaf7422f32a}')!
StdioUtf16FileStream comment: ''!
!StdioUtf16FileStream categoriesForClass!Collections-Streams! !
!StdioUtf16FileStream methodsFor!

contentsSpecies
	"Private - Answer the class of Object to be used when answering collections of elements
	from the receiver."

	^Utf16String!

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
!StdioUtf16FileStream categoriesForMethods!
contentsSpecies!constants!private! !
position!accessing!public! !
position:!positioning!public! !
size!accessing!public! !
!

