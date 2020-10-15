"Filed out from Dolphin Smalltalk 7"!

External.UINT_PTRField subclass: #'External.HANDLEField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.HANDLEField guid: (Core.GUID fromString: '{92844ae1-5120-4fc8-822f-111a92ac0485}')!
External.HANDLEField comment: '<HANDLEField> is a <ScalarField> type to represent <ExternalStructure> fields that are opaque pointers, or "handles".'!
!External.HANDLEField categoriesForClass!External-Data-Types! !
!External.HANDLEField methodsFor!

readFrom: anExternalStructure
	"Private - Answer an <ExternalHandle> with the same value as the unsigned pointer-sized
	field at the receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalHandle!

valueType
	^Handle! !
!External.HANDLEField categoriesFor: #readFrom:!indirect accessing!private! !
!External.HANDLEField categoriesFor: #valueType!automatic generation!constants!development!private! !

