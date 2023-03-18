"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.Int8Field'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.Int8Field guid: (Core.GUID fromString: '{d9145096-c1d5-4c8d-b640-605d284b0c42}')!
External.Int8Field comment: '`Int8Field` is a `ScalarField` class to describe `External.Structure` fields that are 8-bit signed integers.'!
!External.Int8Field categoriesForClass!External-Data-Types! !
!External.Int8Field methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#int8AtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the signed 8-bit signed field at the
	receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes int8AtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the 8-bit signed <integer>, anInteger, into the <ExternalStructure>,
	anExternalStructure, at the receiver's offset."

	^anExternalStructure bytes int8AtOffset: offset put: anInteger! !
!External.Int8Field categoriesForMethods!
accessorMessage!initializing!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.Int8Field class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!External.Int8Field class categoriesForMethods!
byteSize!constants!private! !
!

