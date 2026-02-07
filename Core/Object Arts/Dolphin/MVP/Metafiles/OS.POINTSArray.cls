"Filed out from Dolphin Smalltalk"!

External.POINTArray
	subclass: #'OS.POINTSArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.POINTSArray guid: (Core.GUID fromString: '{502c3d9c-099d-4f81-8ea4-7e7fa896e6f2}')!

OS.POINTSArray comment: ''!

!OS.POINTSArray methodsFor!

uncheckedAt: anInteger
	"Private - Answer a <Point> representing the pair of 16-bit integers at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| offset |
	offset := anInteger - 1 * POINTS._POINTS_Size.
	^Graphics.Point x: (bytes int16AtOffset: offset) y: (bytes int16AtOffset: offset + POINTS._OffsetOf_y)!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTS> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 16-bit signed integer range."

	| offset |
	offset := anInteger - 1 * POINTS._POINTS_Size.
	^Graphics.Point x: (bytes int16AtOffset: offset put: aPoint x)
		y: (bytes int16AtOffset: offset + POINTS._OffsetOf_y put: aPoint y)! !

!OS.POINTSArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!OS.POINTSArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^POINTS! !

!OS.POINTSArray class categoriesForMethods!
elementClass!constants!public! !
!

