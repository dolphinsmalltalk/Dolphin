"Filed out from Dolphin Smalltalk"!

External.POINTArray
	subclass: #'External.POINTLArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.POINTLArray guid: (Core.GUID fromString: '{7870a66a-14c6-4a6c-9953-6114f3fc1662}')!

External.POINTLArray comment: ''!

!External.POINTLArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Point> representing the pair of 32-bit integers at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^(bytes int32AtOffset: offset) @ (bytes int32AtOffset: offset + 4)!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTL> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 32-bit signed integer range."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^(bytes int32AtOffset: offset put: aPoint x) @ (bytes int32AtOffset: offset + 4 put: aPoint y)! !

!External.POINTLArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.POINTLArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^POINTL! !

!External.POINTLArray class categoriesForMethods!
elementClass!constants!public! !
!

