"Filed out from Dolphin Smalltalk"!

ScalarField subclass: #QWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

QWORDField guid: (GUID fromString: '{87b4c4eb-026e-11d3-9fd7-00a0cc3e4a32}')!

QWORDField comment: '<QWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit unsigned integers.'!

!QWORDField categoriesForClass!External-Data-Types! !

!QWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#qwordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 64-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes qwordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 64-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes qwordAtOffset: offset put: anInteger! !

!QWORDField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!QWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !

!QWORDField class categoriesForMethods!
byteSize!constants!private! !
!

