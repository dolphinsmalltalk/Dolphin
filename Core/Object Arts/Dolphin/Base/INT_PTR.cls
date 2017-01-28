"Filed out from Dolphin Smalltalk 7"!

UINT_PTR subclass: #INT_PTR
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INT_PTR guid: (GUID fromString: '{7454F675-5169-482B-9A37-5FE37154D567}')!
INT_PTR comment: ''!
!INT_PTR categoriesForClass!External-Data-Structured! !
!INT_PTR methodsFor!

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
!INT_PTR categoriesFor: #unsignedValue:!accessing!public! !
!INT_PTR categoriesFor: #value!**compiled accessors**!public! !
!INT_PTR categoriesFor: #value:!**compiled accessors**!public! !

!INT_PTR class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^INT_PTRField! !
!INT_PTR class categoriesFor: #fieldType!constants!development!private! !

