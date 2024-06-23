"Filed out from Dolphin Smalltalk"!

External.UIntPtrField
	subclass: #'External.LPVOIDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.LPVOIDField guid: (Core.GUID fromString: '{87b4c4f0-026e-11d3-9fd7-00a0cc3e4a32}')!

External.LPVOIDField comment: '<LPVOIDField> is a <ScalarField> type to represent <ExternalStructure> fields that are untyped pointers to external memory.'!

!External.LPVOIDField categoriesForClass!External-Data-Types! !

!External.LPVOIDField methodsFor!

readFrom: anExternalStructure
	"Private - Answer an <External.Address> with the same value as the pointer field at the
	receiver's offset in the <External.Structure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalAddress!

valueType
	^Address! !

!External.LPVOIDField categoriesForMethods!
readFrom:!indirect accessing!private! !
valueType!automatic generation!constants!development!private! !
!

