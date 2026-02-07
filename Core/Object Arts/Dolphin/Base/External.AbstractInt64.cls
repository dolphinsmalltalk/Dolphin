"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.AbstractInt64'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AbstractInt64 guid: (Core.GUID fromString: '{7459478f-3fef-47ce-b9a4-44a18034f895}')!

External.AbstractInt64 isNonInstantiable: true!

External.AbstractInt64 comment: ''!

!External.AbstractInt64 methodsFor!

asSignedInteger
	"Answer the signed 64-bit <Integer> value of the receiver."

	^bytes int64AtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 64-bit <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes uint64AtOffset: 0!

unsignedValue: anInteger
	"Set the receiver's value field to the value of the unsigned positive integer argument."

	bytes uint64AtOffset: 0 put: anInteger! !

!External.AbstractInt64 categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
unsignedValue:!accessing!public! !
!

!External.AbstractInt64 class methodsFor!

byteSize
	"Answer the size in bytes of this structure"

	^8! !

!External.AbstractInt64 class categoriesForMethods!
byteSize!accessing!public! !
!

