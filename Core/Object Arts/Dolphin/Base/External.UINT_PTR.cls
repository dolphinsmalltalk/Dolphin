"Filed out from Dolphin Smalltalk 7"!

External.INTEGER subclass: #'External.UINT_PTR'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UINT_PTR guid: (Core.GUID fromString: '{5b2efc4b-7560-43b0-930f-70dc94f37d05}')!
External.UINT_PTR comment: ''!
!External.UINT_PTR categoriesForClass!External-Data-Structured-Win32! !
!External.UINT_PTR methodsFor!

asSignedInteger
	"Answer the signed pointer-sized <Integer> value of the receiver."

	^bytes intPtrAtOffset: 0!

asUnsignedInteger
	"Answer the unsigned pointer-sized <Integer> value of the receiver.
	This can be useful where unsigned values are stored in signed values."

	^bytes uintPtrAtOffset: 0!

highPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes dwordAtOffset: 4] ifFalse: [bytes wordAtOffset: 2]!

highPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [bytes dwordAtOffset: 4 put: anObject]
		ifFalse: [bytes wordAtOffset: 2 put: anObject]!

highPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes sdwordAtOffset: 4] ifFalse: [bytes swordAtOffset: 2]!

lowPart
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes dwordAtOffset: 0] ifFalse: [bytes wordAtOffset: 0]!

lowPart: anObject 
	"Note: The compiler will optimise out the conditional because it is constant."

	VMConstants.IsWin64 
		ifTrue: [bytes dwordAtOffset: 0 put: anObject]
		ifFalse: [bytes wordAtOffset: 0 put: anObject]!

lowPartSigned
	"Note: The compiler will optimise out the conditional because it is constant."

	^VMConstants.IsWin64 ifTrue: [bytes sdwordAtOffset: 0] ifFalse: [bytes swordAtOffset: 0]!

value
	"Answer the <Integer> value of the receiver's 'value' field."

	^bytes uintPtrAtOffset: _OffsetOf_value!

value: anInteger
	"Set the receiver's 'value' field to the value of the argument, anInteger"

	bytes uintPtrAtOffset: _OffsetOf_value put: anInteger! !
!External.UINT_PTR categoriesFor: #asSignedInteger!converting!public! !
!External.UINT_PTR categoriesFor: #asUnsignedInteger!converting!public! !
!External.UINT_PTR categoriesFor: #highPart!accessing!public! !
!External.UINT_PTR categoriesFor: #highPart:!accessing!public! !
!External.UINT_PTR categoriesFor: #highPartSigned!accessing!public! !
!External.UINT_PTR categoriesFor: #lowPart!accessing!public! !
!External.UINT_PTR categoriesFor: #lowPart:!accessing!public! !
!External.UINT_PTR categoriesFor: #lowPartSigned!accessing!public! !
!External.UINT_PTR categoriesFor: #value!**compiled accessors**!public! !
!External.UINT_PTR categoriesFor: #value:!**compiled accessors**!public! !

!External.UINT_PTR class methodsFor!

defineFields
	"Define the fields of the ExternalInteger 'structure'. ExternalInteger subclasses
	have a single value."

	self defineField: #value type: UINT_PTRField new beOverride! !
!External.UINT_PTR class categoriesFor: #defineFields!public!template definition! !

