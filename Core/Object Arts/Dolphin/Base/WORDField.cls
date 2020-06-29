"Filed out from Dolphin Smalltalk 7"!

ScalarField subclass: #WORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
WORDField guid: (GUID fromString: '{87b4c4ef-026e-11d3-9fd7-00a0cc3e4a32}')!
WORDField comment: '<WORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 16-bit unsigned integers.'!
!WORDField categoriesForClass!External-Data-Types! !
!WORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#wordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 16-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes wordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 16-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes wordAtOffset: offset put: anInteger! !
!WORDField categoriesFor: #accessorMessage!automatic generation!private! !
!WORDField categoriesFor: #readFrom:!indirect accessing!private! !
!WORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!WORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!WORDField class categoriesFor: #byteSize!constants!private! !

