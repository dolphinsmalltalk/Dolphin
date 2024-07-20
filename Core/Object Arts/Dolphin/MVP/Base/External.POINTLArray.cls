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
	^Graphics.Point x: (bytes int32AtOffset: offset) y: (bytes int32AtOffset: offset + 4)!

uncheckedAt: anInteger put: aPoint
	"Private - Replace the <POINTL> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument.
	The co-ordinates are limited to 32-bit signed integer range."

	| offset |
	offset := anInteger - 1 bitShift: 3.
	^Graphics.Point x: (bytes int32AtOffset: offset put: aPoint x)
		y: (bytes int32AtOffset: offset + 4 put: aPoint y)! !

!External.POINTLArray categoriesForMethods!
uncheckedAt:!accessing!private! !
uncheckedAt:put:!accessing!private! !
!

!External.POINTLArray class methodsFor!

elementClass
	"Answer the class of <ExternalStructure> used to represent elements of the receiver."

	^POINTL!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements.
	An error will be raised if any of the elements of newElements
	cannot be stored in instances of the receiver."

	| answer bytes |
	answer := self new: newElements size.
	bytes := answer bytes.
	newElements inject: 0
		into: 
			[:offset :elem |
			bytes
				int32AtOffset: offset put: elem x;
				int32AtOffset: offset + 4 put: elem y.
			offset + 8].
	^answer! !

!External.POINTLArray class categoriesForMethods!
elementClass!constants!public! !
withAll:!instance creation!public! !
!

