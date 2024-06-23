"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.UInt8Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UInt8Field guid: (Core.GUID fromString: '{87b4c4e7-026e-11d3-9fd7-00a0cc3e4a32}')!

External.UInt8Field comment: '`UInt8Field` is a `ScalarField` class to describe `External.Structure` fields that are 8-bit unsigned integers.'!

!External.UInt8Field categoriesForClass!External-Data-Types! !

!External.UInt8Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uint8AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned 8-bit field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes uint8AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 8-bit unsigned <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes uint8AtOffset: offset put: anInteger! !

!External.UInt8Field categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.UInt8Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !

!External.UInt8Field class categoriesForMethods!
byteSize!constants!private! !
!

