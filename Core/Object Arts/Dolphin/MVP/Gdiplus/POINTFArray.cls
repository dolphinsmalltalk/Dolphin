"Filed out from Dolphin Smalltalk"!

POINTArray subclass: #POINTFArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTFArray guid: (GUID fromString: '{db21ef86-a19c-470e-93c7-fd0c4546148c}')!

POINTFArray comment: ''!

!POINTFArray categoriesForClass!External-Data-Structured! !

!POINTFArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Point> representing the pair of 32-bit floats at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^Point x: (bytes floatAtOffset: offset) y: (bytes floatAtOffset: offset + 4)
!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTF> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 32-bit float range and precision."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^Point x: (bytes floatAtOffset: offset put: aPoint x)
		y: (bytes floatAtOffset: offset + 4 put: aPoint y)
! !

!POINTFArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!POINTFArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^POINTF! !

!POINTFArray class categoriesForMethods!
elementClass!constants!public! !
!

