"Filed out from Dolphin Smalltalk 7"!

ScalarField subclass: #SQWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SQWORDField guid: (GUID fromString: '{87b4c4ed-026e-11d3-9fd7-00a0cc3e4a32}')!
SQWORDField comment: '<SQWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit signed integers.'!
!SQWORDField categoriesForClass!External-Data-Types! !
!SQWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sqwordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 64-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes sqwordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 64-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes sqwordAtOffset: offset put: anInteger! !
!SQWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!SQWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!SQWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!SQWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!SQWORDField class categoriesFor: #byteSize!constants!private! !

