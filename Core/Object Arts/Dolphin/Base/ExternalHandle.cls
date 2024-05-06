"Filed out from Dolphin Smalltalk"!

UIntPtrBytes variableByteSubclass: #ExternalHandle
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExternalHandle guid: (GUID fromString: '{87b4c518-026e-11d3-9fd7-00a0cc3e4a32}')!

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

!ExternalHandle categoriesForMethods!
asExternalHandle!converting!public! !
handle!accessing!private! !
stbSaveOn:!binary filing!public! !
!

