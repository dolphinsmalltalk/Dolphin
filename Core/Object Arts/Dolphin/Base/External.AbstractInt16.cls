"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.AbstractInt16'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AbstractInt16 guid: (Core.GUID fromString: '{98272a92-8711-4ef9-af5b-547021931157}')!

External.AbstractInt16 isNonInstantiable: true!

External.AbstractInt16 comment: ''!

!External.AbstractInt16 methodsFor!

asSignedInteger
	"Answer the signed 16-bit <Integer> value of the receiver."

	^bytes int16AtOffset: _OffsetOf_value!

asUnsignedInteger
	"Answer the unsigned 16-bit <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes uint16AtOffset: _OffsetOf_value!

byteSize
	"Answer the size in bytes of this structure"

	^2!

unsignedValue: anInteger
	"Set the receiver's value field to the value of the unsigned positive integer argument."

	bytes uint16AtOffset: 0 put: anInteger! !

!External.AbstractInt16 categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
byteSize!accessing!public! !
unsignedValue:!accessing!public! !
!

!External.AbstractInt16 class methodsFor!

byteSize
	"Answer the size in bytes of this structure"

	^2! !

!External.AbstractInt16 class categoriesForMethods!
byteSize!accessing!public! !
!

