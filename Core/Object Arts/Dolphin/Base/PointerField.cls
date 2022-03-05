"Filed out from Dolphin Smalltalk"!

ExternalField subclass: #PointerField
	instanceVariableNames: 'pointerClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerField guid: (GUID fromString: '{87b4c4dc-026e-11d3-9fd7-00a0cc3e4a32}')!
PointerField comment: 'PointerField is an <ExternalField> type to represent fields of <ExternalStructure>s that are pointers to external data.'!
!PointerField categoriesForClass!External-Data-Types! !
!PointerField methodsFor!

byteSize
	"Private - Answer the byte size of the ExternalField the receiver represents
	Answer the size of a 32-bit pointer"

	^VMConstants.IntPtrSize!

fieldClassName
	^self pointerClass name!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^pointerClass!

pointerClass: aClass
	"Private - Set the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type. Answer the receiver."

	pointerClass := aClass!

readFrom: anExternalStructure
	"Private - Answer a pointer object of the type pointed at by the receiver in the
	<ExternalStructure> argument. WARNING: May be a copy or a reference depending on the
	behavior of pointerClass (which can be any Behavior which has the instance creation method
	#fromAddress:)"

	^self pointerClass fromAddress: (anExternalStructure bytes intPtrAtOffset: offset)!

writeInto: anExternalStructure value: anObject
	"Private - Write the address of the externally addressable Smalltalk object, anObject,
	into anExternal at the receiver's offset.
	N.B. Precautions must be taken (such as saving the Object as an
	instance variable of the ExternalStructure which encapsulates anExternal)
	to prevent anObject being garbage collected, which will invalidate its
	address. anObject cannot be saved by the receiver, because it is shared
	among all instances of a subclass of ExternalStructure (it is part of
	the class instance variable 'template')."

	^anExternalStructure bytes uintPtrAtOffset: offset put: anObject yourAddress! !
!PointerField categoriesForMethods!
byteSize!accessing!private! !
fieldClassName!automatic generation!constants!development!private! !
pointerClass!accessing!private! !
pointerClass:!accessing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!PointerField class methodsFor!

type: aClass
	"Answer a new instance of the receiver which is used for dereferencing
	pointers to objects of type aClass"

	^super new pointerClass: aClass! !
!PointerField class categoriesForMethods!
type:!instance creation!public! !
!

