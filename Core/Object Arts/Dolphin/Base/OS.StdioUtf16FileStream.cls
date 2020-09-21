"Filed out from Dolphin Smalltalk 7"!

External.StdioUnicodeFileStream subclass: #'External.StdioUtf16FileStream'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.StdioUtf16FileStream guid: (Core.GUID fromString: '{59d77acf-50ff-4508-a672-0eaf7422f32a}')!
External.StdioUtf16FileStream comment: ''!
!External.StdioUtf16FileStream categoriesForClass!Collections-Streams! !
!External.StdioUtf16FileStream methodsFor!

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
!External.StdioUtf16FileStream categoriesFor: #contentsSpecies!constants!private! !
!External.StdioUtf16FileStream categoriesFor: #position!accessing!public! !
!External.StdioUtf16FileStream categoriesFor: #position:!positioning!public! !
!External.StdioUtf16FileStream categoriesFor: #size!accessing!public! !

