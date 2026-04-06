"Filed out from Dolphin Smalltalk"!

External.UIntPtrBytes
	variableByteSubclass: #'External.Handle'
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

isInvalid
	^(self intPtrAtOffset: 0) == OS.KernelLibrary.INVALID_HANDLE_VALUE! !

!External.Handle categoriesForMethods!
asExternalHandle!converting!public! !
handle!accessing!private! !
isInvalid!public!testing! !
!

