"Filed out from Dolphin Smalltalk 7"!

External.UIntPtrBytes variableByteSubclass: #'External.Handle'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Handle guid: (Core.GUID fromString: '{87b4c518-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Handle comment: ''!
!External.Handle categoriesForClass!External-Data-Unstructured! !
!External.Handle methodsFor!

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
!External.Handle categoriesFor: #asExternalHandle!converting!public! !
!External.Handle categoriesFor: #handle!accessing!private! !
!External.Handle categoriesFor: #stbSaveOn:!binary filing!public! !

