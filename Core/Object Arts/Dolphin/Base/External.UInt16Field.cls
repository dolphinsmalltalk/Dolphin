"Filed out from Dolphin Smalltalk"!

External.ScalarField subclass: #'External.WORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.WORDField guid: (Core.GUID fromString: '{87b4c4ef-026e-11d3-9fd7-00a0cc3e4a32}')!
External.WORDField comment: '<WORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 16-bit unsigned integers.'!
!External.WORDField categoriesForClass!External-Data-Types! !
!External.WORDField methodsFor!

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
!External.WORDField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.WORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!External.WORDField class categoriesForMethods!
byteSize!constants!private! !
!

