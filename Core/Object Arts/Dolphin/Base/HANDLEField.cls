"Filed out from Dolphin Smalltalk X6.1"!

UINT_PTRField subclass: #HANDLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HANDLEField guid: (GUID fromString: '{92844AE1-5120-4FC8-822F-111A92AC0485}')!
HANDLEField comment: ''!
!HANDLEField categoriesForClass!External-Data-Types! !
!HANDLEField methodsFor!

accessorConverter
	"Private - Answer the converter message to be sent to the value read from the structure to
	convert it to an appropriate Smalltalk object."

	^#asExternalHandle!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal."

	^(super readFrom: anExternal) asExternalHandle! !
!HANDLEField categoriesFor: #accessorConverter!automatic generation!private! !
!HANDLEField categoriesFor: #readFrom:!indirect accessing!private! !

