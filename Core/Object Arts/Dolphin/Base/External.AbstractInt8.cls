"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.AbstractInt8'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AbstractInt8 guid: (Core.GUID fromString: '{e0e23d9b-3cc2-48fd-a6fa-f9eb9bf29f82}')!

External.AbstractInt8 isNonInstantiable: true!

External.AbstractInt8 comment: ''!

!External.AbstractInt8 methodsFor!

asSignedInteger
	"Answer the signed 8-bit <Integer> value of the receiver."

	^bytes int8AtOffset: 0!

asUnsignedInteger
	"Answer the unsigned 8-bit <Integer> value of the receiver."

	^bytes uint8AtOffset: 0!

unsignedValue: anInteger
	"Set the receiver's value field to the value of the unsigned positive integer argument."

	bytes uint8AtOffset: 0 put: anInteger! !

!External.AbstractInt8 categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
unsignedValue:!accessing!public! !
!

!External.AbstractInt8 class methodsFor!

byteSize
	"Answer the size in bytes of this structure"

	^1! !

!External.AbstractInt8 class categoriesForMethods!
byteSize!accessing!public! !
!

