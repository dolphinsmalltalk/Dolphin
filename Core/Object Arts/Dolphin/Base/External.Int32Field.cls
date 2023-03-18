"Filed out from Dolphin Smalltalk"!

External.ScalarField subclass: #'External.Int32Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Int32Field guid: (Core.GUID fromString: '{87b4c4ec-026e-11d3-9fd7-00a0cc3e4a32}')!
External.Int32Field comment: '`Int32Field` is a `ScalarField` class to describe `External.Structure` fields that are 32-bit signed integers.'!
!External.Int32Field categoriesForClass!External-Data-Types! !
!External.Int32Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#int32AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 32-bit signed field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes int32AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 32-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes int32AtOffset: offset put: anInteger! !
!External.Int32Field categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.Int32Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	An Int32 is always 4 bytes."

	^4! !
!External.Int32Field class categoriesForMethods!
byteSize!constants!private! !
!

