"Filed out from Dolphin Smalltalk X6.1"!

UINT_PTR subclass: #INT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INT_PTR guid: (GUID fromString: '{7454F675-5169-482B-9A37-5FE37154D567}')!
INT_PTR comment: ''!
!INT_PTR categoriesForClass!External-Data-Structured! !
!INT_PTR methodsFor!

asUnsignedInteger
	"Answer the unsigned machined-word sized integer value of the receiver."

	^bytes uintPtrAtOffset: 0!

unsignedValue: anUnsigned 
	"Set the receiver's value field to the value of the unsigned positive
	integer, anUnsigned."

	bytes uintPtrAtOffset: 0 put: anUnsigned!

value
	"Answer the receiver's value field as a Smalltalk object."

	^bytes intPtrAtOffset: 0!

value: anObject 
	"Set the receiver's value field to the value of anObject."

	bytes intPtrAtOffset: 0 put: anObject! !
!INT_PTR categoriesFor: #asUnsignedInteger!converting!public! !
!INT_PTR categoriesFor: #unsignedValue:!accessing!public! !
!INT_PTR categoriesFor: #value!**compiled accessors**!public! !
!INT_PTR categoriesFor: #value:!**compiled accessors**!public! !

!INT_PTR class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^INT_PTRField!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	VMLibrary default registryAt: self name put: self!

uninitialize
	"Private - Uninitialize the receiver prior to its removal from the image."

	VMLibrary default registryAt: self name put: nil! !
!INT_PTR class categoriesFor: #fieldType!constants!development!private! !
!INT_PTR class categoriesFor: #initialize!development!initializing!private! !
!INT_PTR class categoriesFor: #uninitialize!class hierarchy-removing!private! !

