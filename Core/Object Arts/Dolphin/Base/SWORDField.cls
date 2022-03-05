"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #SWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SWORDField guid: (GUID fromString: '{87b4c4ee-026e-11d3-9fd7-00a0cc3e4a32}')!
SWORDField comment: '<SWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 16-bit signed integers.'!
!SWORDField categoriesForClass!External-Data-Types! !
!SWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#swordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 16-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes wordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 16-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes swordAtOffset: offset put: anInteger! !
!SWORDField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!SWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!SWORDField class categoriesForMethods!
byteSize!constants!private! !
!

