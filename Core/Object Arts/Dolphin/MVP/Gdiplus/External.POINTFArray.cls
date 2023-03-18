"Filed out from Dolphin Smalltalk"!

External.POINTArray
	subclass: #'External.POINTFArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.POINTFArray guid: (Core.GUID fromString: '{db21ef86-a19c-470e-93c7-fd0c4546148c}')!
External.POINTFArray comment: ''!
!External.POINTFArray methodsFor!

printElement: aPoint on: aStream
	aStream nextPut: $(.
	aPoint x printOn: aStream significantFigures: 7.
	aStream nextPut: $@.
	aPoint y printOn: aStream significantFigures: 7.
	aStream nextPut: $)!

uncheckedAt: anInteger
	"Private - Answer a <Point> representing the pair of 32-bit floats at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^(bytes floatAtOffset: offset) @ (bytes floatAtOffset: offset + 4)!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTF> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 32-bit float range and precision."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^(bytes floatAtOffset: offset put: aPoint x) @ (bytes floatAtOffset: offset + 4 put: aPoint y)! !
!External.POINTFArray categoriesForMethods!
printElement:on:!printing!private! !
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.POINTFArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^POINTF! !
!External.POINTFArray class categoriesForMethods!
elementClass!constants!public! !
!

