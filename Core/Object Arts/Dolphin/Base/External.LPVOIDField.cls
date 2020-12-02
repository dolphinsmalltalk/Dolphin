"Filed out from Dolphin Smalltalk 7"!

UINT_PTRField subclass: #LPVOIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LPVOIDField guid: (GUID fromString: '{87b4c4f0-026e-11d3-9fd7-00a0cc3e4a32}')!
LPVOIDField comment: '<LPVOIDField> is a <ScalarField> type to represent <ExternalStructure> fields that are untyped pointers to external memory.'!
!LPVOIDField categoriesForClass!External-Data-Types! !
!LPVOIDField methodsFor!

fieldClassName
	^ExternalAddress name!

readFrom: anExternalStructure
	"Private - Answer an <ExternalAddress> with the same value as the pointer field at the
	receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalAddress! !
!LPVOIDField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!LPVOIDField categoriesFor: #readFrom:!indirect accessing!private! !

