"Filed out from Dolphin Smalltalk"!

External.ScalarField subclass: #'External.UInt16Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt16Field guid: (Core.GUID fromString: '{87b4c4ef-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt16Field comment: '`UInt16Field` is a `ScalarField` class to describe `External.Structure` fields that are 16-bit unsigned integers.'!
!External.UInt16Field categoriesForClass!External-Data-Types! !
!External.UInt16Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uint16AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 16-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uint16AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 16-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes uint16AtOffset: offset put: anInteger! !
!External.UInt16Field categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.UInt16Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!External.UInt16Field class categoriesForMethods!
byteSize!constants!private! !
!

