"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.Int16Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Int16Field guid: (Core.GUID fromString: '{87b4c4ee-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Int16Field comment: '`Int16Field` is a `ScalarField` class to describe `External.Structure` fields that are 16-bit signed integers.'!
!External.Int16Field categoriesForClass!External-Data-Types! !
!External.Int16Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#int16AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 16-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uint16AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 16-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes int16AtOffset: offset put: anInteger! !
!External.Int16Field categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.Int16Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!External.Int16Field class categoriesForMethods!
byteSize!constants!private! !
!

