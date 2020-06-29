"Filed out from Dolphin Smalltalk 7"!

ScalarField subclass: #SDWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SDWORDField guid: (GUID fromString: '{87b4c4ec-026e-11d3-9fd7-00a0cc3e4a32}')!
SDWORDField comment: '<SDWORDField> is a <ScalarField> class to represent <ExternalStructure> fields that are 32-bit signed integers.'!
!SDWORDField categoriesForClass!External-Data-Types! !
!SDWORDField methodsFor!

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
!SDWORDField categoriesFor: #accessorMessage!initializing!private! !
!SDWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!SDWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!SDWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	An SDWORD is always 4 bytes."

	^4! !
!SDWORDField class categoriesFor: #byteSize!constants!private! !

