"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.AbstractIntPtr'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.AbstractIntPtr guid: (Core.GUID fromString: '{2712b7bb-e7c0-4022-a494-51e4f857cca1}')!

External.AbstractIntPtr isNonInstantiable: true!

External.AbstractIntPtr comment: ''!

!External.AbstractIntPtr methodsFor!

asSignedInteger
	"Answer the signed pointer-sized <Integer> value of the receiver."

	^bytes intPtrAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned pointer-sized <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes uintPtrAtOffset: 0!

highPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes uint32AtOffset: 4] ifFalse: [bytes uint16AtOffset: 2]!

highPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [bytes uint32AtOffset: 4 put: anObject]
		ifFalse: [bytes uint16AtOffset: 2 put: anObject]!

highPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes int32AtOffset: 4] ifFalse: [bytes int16AtOffset: 2]!

lowPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes uint32AtOffset: 0] ifFalse: [bytes uint16AtOffset: 0]!

lowPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [bytes uint32AtOffset: 0 put: anObject]
		ifFalse: [bytes uint16AtOffset: 0 put: anObject]!

lowPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes int32AtOffset: 0] ifFalse: [bytes int16AtOffset: 0]!

unsignedValue: anUnsigned 
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uintPtrAtOffset: 0 put: anUnsigned! !

!External.AbstractIntPtr categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
highPart!accessing!public! !
highPart:!accessing!public! !
highPartSigned!accessing!public! !
lowPart!accessing!public! !
lowPart:!accessing!public! !
lowPartSigned!accessing!public! !
unsignedValue:!accessing!public! !
!

!External.AbstractIntPtr class methodsFor!

byteSize
	"Answer the size in bytes of this structure"

	^VMConstants.IntPtrSize! !

!External.AbstractIntPtr class categoriesForMethods!
byteSize!accessing!public! !
!

