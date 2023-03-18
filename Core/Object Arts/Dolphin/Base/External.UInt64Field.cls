"Filed out from Dolphin Smalltalk"!

External.ScalarField subclass: #'External.UInt64Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.UInt64Field guid: (Core.GUID fromString: '{87b4c4eb-026e-11d3-9fd7-00a0cc3e4a32}')!
External.UInt64Field comment: '`UInt64Field` is a `ScalarField` class to describe `External.Structure` fields that are 64-bit unsigned integers.'!
!External.UInt64Field categoriesForClass!External-Data-Types! !
!External.UInt64Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uint64AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 64-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uint64AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 64-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes uint64AtOffset: offset put: anInteger! !
!External.UInt64Field categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.UInt64Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!External.UInt64Field class categoriesForMethods!
byteSize!constants!private! !
!

