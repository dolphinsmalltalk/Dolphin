"Filed out from Dolphin Smalltalk"!

UINT_PTRField subclass: #HANDLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

HANDLEField guid: (GUID fromString: '{92844ae1-5120-4fc8-822f-111a92ac0485}')!

HANDLEField comment: '<HANDLEField> is a <ScalarField> type to represent <ExternalStructure> fields that are opaque pointers, or "handles".'!

!HANDLEField categoriesForClass!External-Data-Types! !

!HANDLEField methodsFor!

fieldClassName
	^ExternalHandle name!

readFrom: anExternalStructure
	"Private - Answer an <ExternalHandle> with the same value as the unsigned pointer-sized
	field at the receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalHandle! !

!HANDLEField categoriesForMethods!
fieldClassName!automatic generation!constants!development!private! !
readFrom:!indirect accessing!private! !
!

