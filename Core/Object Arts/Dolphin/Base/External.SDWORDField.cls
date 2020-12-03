"Filed out from Dolphin Smalltalk 7"!

External.ScalarField subclass: #'External.SDWORDField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.SDWORDField guid: (Core.GUID fromString: '{87b4c4ec-026e-11d3-9fd7-00a0cc3e4a32}')!
External.SDWORDField comment: '<SDWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 32-bit signed integers.'!
!External.SDWORDField categoriesForClass!External-Data-Types! !
!External.SDWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sdwordAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 32-bit signed field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes sdwordAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 32-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes sdwordAtOffset: offset put: anInteger! !
!External.SDWORDField categoriesFor: #accessorMessage!initializing!private! !
!External.SDWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!External.SDWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!External.SDWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	An SDWORD is always 4 bytes."

	^4! !
!External.SDWORDField class categoriesFor: #byteSize!constants!private! !

