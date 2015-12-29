"Filed out from Dolphin Smalltalk X6.1"!

ExternalInteger subclass: #UINT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTR guid: (GUID fromString: '{5B2EFC4B-7560-43B0-930F-70DC94F37D05}')!
UINT_PTR comment: ''!
!UINT_PTR categoriesForClass!External-Data-Structured! !
!UINT_PTR methodsFor!

asSignedInteger
	"Answer the signed 32-bit Integer value of the receiver."

	^bytes intPtrAtOffset: 0!

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
	"Answer the receiver's value field as a Smalltalk object."

	^bytes uintPtrAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes uintPtrAtOffset: 0 put: anObject! !
!UINT_PTR categoriesFor: #asSignedInteger!converting!public! !
!UINT_PTR categoriesFor: #highPart!accessing!public! !
!UINT_PTR categoriesFor: #highPart:!accessing!public! !
!UINT_PTR categoriesFor: #highPartSigned!accessing!public! !
!UINT_PTR categoriesFor: #lowPart!accessing!public! !
!UINT_PTR categoriesFor: #lowPart:!accessing!public! !
!UINT_PTR categoriesFor: #lowPartSigned!accessing!public! !
!UINT_PTR categoriesFor: #value!**compiled accessors**!public! !
!UINT_PTR categoriesFor: #value:!**compiled accessors**!public! !

!UINT_PTR class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^UINT_PTRField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!UINT_PTR class categoriesFor: #fieldType!constants!development!private! !
!UINT_PTR class categoriesFor: #initialize!development!initializing!private! !
!UINT_PTR class categoriesFor: #uninitialize!class hierarchy-removing!private! !

