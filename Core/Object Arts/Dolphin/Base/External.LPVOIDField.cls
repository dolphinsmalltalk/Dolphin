"Filed out from Dolphin Smalltalk 7"!

External.UINT_PTRField subclass: #'External.LPVOIDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.LPVOIDField guid: (Core.GUID fromString: '{87b4c4f0-026e-11d3-9fd7-00a0cc3e4a32}')!
External.LPVOIDField comment: '<LPVOIDField> is a <ScalarField> type to represent <ExternalStructure> fields that are untyped pointers to external memory.'!
!External.LPVOIDField categoriesForClass!External-Data-Types! !
!External.LPVOIDField methodsFor!

fieldClassName
	^External.Address name!

readFrom: anExternalStructure
	"Private - Answer an <ExternalAddress> with the same value as the pointer field at the
	receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalAddress! !
!External.LPVOIDField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!External.LPVOIDField categoriesFor: #readFrom:!indirect accessing!private! !

