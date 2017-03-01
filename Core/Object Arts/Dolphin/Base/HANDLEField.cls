"Filed out from Dolphin Smalltalk 7"!

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

printAccessorExpressionSuffixOn: aWriteStream
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	aWriteStream
		space;
		display: #asExternalHandle!

readFrom: anExternalStructure
	"Private - Answer an <ExternalHandle> with the same value as the unsigned pointer-sized
	field at the receiver's offset in the <ExternalStructure> argument."

	^(anExternalStructure bytes uintPtrAtOffset: offset) asExternalHandle! !
!HANDLEField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!HANDLEField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!HANDLEField categoriesFor: #readFrom:!indirect accessing!private! !

