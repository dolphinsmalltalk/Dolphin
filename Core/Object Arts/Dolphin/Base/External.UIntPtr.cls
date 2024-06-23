"Filed out from Dolphin Smalltalk"!

External.INTEGER
	subclass: #'External.UIntPtr'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_UIntPtr_Size' -> 16r4 }!

External.UIntPtr guid: (Core.GUID fromString: '{5b2efc4b-7560-43b0-930f-70dc94f37d05}')!

External.UIntPtr comment: ''!

!External.UIntPtr categoriesForClass!External-Data-Structured-Win32! !

!External.UIntPtr methodsFor!

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

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uintPtrAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_value put: anInteger! !

!External.UIntPtr categoriesForMethods!
asSignedInteger!converting!public! !
asUnsignedInteger!converting!public! !
highPart!accessing!public! !
highPart:!accessing!public! !
highPartSigned!accessing!public! !
lowPart!accessing!public! !
lowPart:!accessing!public! !
lowPartSigned!accessing!public! !
value!**compiled accessors**!public! !
value:!**compiled accessors**!public! !
!

!External.UIntPtr class methodsFor!

byteSize
	^_UIntPtr_Size!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: UIntPtrField new beOverride! !

!External.UIntPtr class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
!

