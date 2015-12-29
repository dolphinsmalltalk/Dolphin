"Filed out from Dolphin Smalltalk X6.1"!

UINT_PTRField subclass: #LPVOIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPVOIDField guid: (GUID fromString: '{87B4C4F0-026E-11D3-9FD7-00A0CC3E4A32}')!
LPVOIDField comment: ''!
!LPVOIDField categoriesForClass!External-Data-Types! !
!LPVOIDField methodsFor!

accessorConverter
	"Private - Answer the converter message to be sent to the value read from the structure to
	convert it to an appropriate Smalltalk object."

	^#asExternalAddress!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal."

	^(super readFrom: anExternal) asExternalAddress! !
!LPVOIDField categoriesFor: #accessorConverter!automatic generation!private! !
!LPVOIDField categoriesFor: #readFrom:!indirect accessing!private! !

