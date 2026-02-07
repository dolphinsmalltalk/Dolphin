"Filed out from Dolphin Smalltalk"!

External.ExternalArray
	subclass: #'External.POINTArray'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.POINTArray guid: (Core.GUID fromString: '{c1350f8a-5e5c-4a80-960d-5798265d8c23}')!

External.POINTArray isNonInstantiable: true!

External.POINTArray comment: '`POINTArray` is an abstract `ExternalArray`, subclasses of which represent contiguous single-dimensioned arrays of cartesian point structures.'!

!External.POINTArray methodsFor!

basicUncheckedAt: anInteger
	"Private - Answer a <POINT> representing the pair of co-ordinates at the specified one-based index in the receiver.
	No bounds checks are performed on the subscript."

	| elemt |
	elemt := self elementClass.
	^elemt fromAddress: (bytes yourAddress + (anInteger - 1)) * elemt byteSize owner: self!

basicUncheckedAt: anInteger put: aPOINT
	"Private - Replace the <POINT> value at the specified index in the receiver with the x and y co-ordindates of the <Point> argument. Note that the point needs to be of the same concrete <POINT> subclass as the receiver's elementClass."

	| size |
	size := self elementSize.
	aPOINT
		replaceBytesOf: bytes
		from: (anInteger - 1) * size + 1
		to: anInteger * size
		startingAt: 1.
	^aPOINT! !

!External.POINTArray categoriesForMethods!
basicUncheckedAt:!accessing!private! !
basicUncheckedAt:put:!accessing!private! !
!

