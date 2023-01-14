"Filed out from Dolphin Smalltalk"!

External.ScalarField subclass: #'External.QWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.QWORDField guid: (Core.GUID fromString: '{87b4c4eb-026e-11d3-9fd7-00a0cc3e4a32}')!
External.QWORDField comment: '<QWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 64-bit unsigned integers.'!
!External.QWORDField categoriesForClass!External-Data-Types! !
!External.QWORDField methodsFor!

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
!External.QWORDField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.QWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!External.QWORDField class categoriesForMethods!
byteSize!constants!private! !
!

