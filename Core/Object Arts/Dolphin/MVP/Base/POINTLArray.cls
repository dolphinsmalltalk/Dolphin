"Filed out from Dolphin Smalltalk"!

POINTArray subclass: #POINTLArray
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

POINTLArray guid: (GUID fromString: '{cb677120-c3a4-4943-8691-fa52d1d3c579}')!

POINTLArray comment: ''!

!POINTLArray categoriesForClass!External-Data-Structured! !

!POINTLArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Point> representing the pair of 32-bit integers at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^Point x: (bytes sdwordAtOffset: offset) y: (bytes sdwordAtOffset: offset + 4)!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTL> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 32-bit signed integer range."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^Point x: (bytes sdwordAtOffset: offset put: aPoint x)
		y: (bytes sdwordAtOffset: offset + 4 put: aPoint y)! !

!POINTLArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!POINTLArray class methodsFor!

elementClass
	^POINTL! !

!POINTLArray class categoriesForMethods!
elementClass!constants!public! !
!

