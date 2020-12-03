"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.SQWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SQWORDField guid: (Core.GUID fromString: '{87b4c4ed-026e-11d3-9fd7-00a0cc3e4a32}')!
External.SQWORDField comment: '<SQWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit signed integers.'!
!External.SQWORDField categoriesForClass!External-Data-Types! !
!External.SQWORDField methodsFor!

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
!External.SQWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!External.SQWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!External.SQWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.SQWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!External.SQWORDField class categoriesFor: #byteSize!constants!private! !

