"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.DWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.DWORDField guid: (Core.GUID fromString: '{87b4c4e9-026e-11d3-9fd7-00a0cc3e4a32}')!
External.DWORDField comment: '<DWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 32-bit unsigned integers.'!
!External.DWORDField categoriesForClass!External-Data-Types! !
!External.DWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#dwordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 32-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes dwordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 32-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes dwordAtOffset: offset put: anInteger! !
!External.DWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!External.DWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!External.DWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.DWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A DWORD is always 4 bytes."

	^4! !
!External.DWORDField class categoriesFor: #byteSize!constants!private! !

