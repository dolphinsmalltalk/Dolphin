"Filed out from Dolphin Smalltalk X6.1"!

UIntPtrBytes variableByteSubclass: #ExternalHandle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ExternalHandle guid: (GUID fromString: '{87B4C518-026E-11D3-9FD7-00A0CC3E4A32}')!
ExternalHandle comment: ''!
!ExternalHandle categoriesForClass!External-Data-Unstructured! !
!ExternalHandle methodsFor!

asExternalHandle
	"Answer the receiver as an ExternalHandle."

	^self!

handle
	"Private - Please use #asPositiveInteger (or #asInteger) instead"

	^self value!

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler.
	Output nil in place of the receiver as the future validity of an external handle is uncertain."

	anSTBOutFiler saveObject: self as: nil! !
!ExternalHandle categoriesFor: #asExternalHandle!converting!public! !
!ExternalHandle categoriesFor: #handle!accessing!private! !
!ExternalHandle categoriesFor: #stbSaveOn:!binary filing!public! !

!ExternalHandle class methodsFor!

fieldType
	"Private - Answer the <ExternalField> type to be used to represent the receiver's field type in 
	other structures."

	^HANDLEField! !
!ExternalHandle class categoriesFor: #fieldType!constants!development!private! !

