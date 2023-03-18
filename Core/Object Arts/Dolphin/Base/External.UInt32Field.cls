"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.UInt32Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt32Field guid: (Core.GUID fromString: '{87b4c4e9-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt32Field comment: '`UInt32Field` is a `ScalarField` class to describe `External.Structure` fields that are 32-bit unsigned integers.'!
!External.UInt32Field categoriesForClass!External-Data-Types! !
!External.UInt32Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uint32AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 32-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uint32AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 32-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes uint32AtOffset: offset put: anInteger! !
!External.UInt32Field categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.UInt32Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A UInt32 is always 4 bytes."

	^4! !
!External.UInt32Field class categoriesForMethods!
byteSize!constants!private! !
!

