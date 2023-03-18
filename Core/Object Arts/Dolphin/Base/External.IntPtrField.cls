"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.IntPtrField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.IntPtrField guid: (Core.GUID fromString: '{7ac35ffb-9b38-4687-bc95-130b325b2965}')!
External.IntPtrField comment: '`IntPtrField` is a `ScalarField` class to describe `External.Structure` fields that are signed integers of the same size as a pointer on the host platform. Currently these are always 32-bit as Dolphin is a 32-bit process.'!
!External.IntPtrField categoriesForClass!External-Data-Types! !
!External.IntPtrField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#intPtrAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned pointer-sized field at the receiver's offset in the <External.Structure> argument."

	^anExternalStructure bytes intPtrAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the pointer-sized signed <integer> value, anInteger, into the <External.Structure> first argument at the receiver's offset ."

	^anExternalStructure bytes intPtrAtOffset: offset put: anInteger! !
!External.IntPtrField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.IntPtrField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes. This size will vary between 32 and 64-bit platforms."

	^VMConstants.IntPtrSize! !
!External.IntPtrField class categoriesForMethods!
byteSize!constants!private! !
!

