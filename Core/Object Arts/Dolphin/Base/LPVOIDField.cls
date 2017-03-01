"Filed out from Dolphin Smalltalk 7"!

UINT_PTRField subclass: #LPVOIDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LPVOIDField guid: (GUID fromString: '{87b4c4f0-026e-11d3-9fd7-00a0cc3e4a32}')!
LPVOIDField comment: '<LPVOIDField> is a <ScalarField> type to represent <ExternalStructure> fields that are untyped pointers to external memory.'!
!LPVOIDField categoriesForClass!External-Data-Types! !
!LPVOIDField methodsFor!

fieldClassName
	^ExternalAddress name!

printAccessorExpressionSuffixOn: aWriteStream
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	aWriteStream
		space;
		display: #asExternalAddress!

readFrom: anExternalStructure
	"Private - Answer an <ExternalAddress> with the same value as the pointer field at the
	receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalAddress! !
!LPVOIDField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!LPVOIDField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!LPVOIDField categoriesFor: #readFrom:!indirect accessing!private! !

