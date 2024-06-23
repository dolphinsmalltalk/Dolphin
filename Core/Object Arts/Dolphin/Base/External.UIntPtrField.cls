"Filed out from Dolphin Smalltalk"!

External.ScalarField
	subclass: #'External.UIntPtrField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.UIntPtrField guid: (Core.GUID fromString: '{19012b00-96f4-4181-a7e1-0a85a4268d7b}')!

External.UIntPtrField comment: '`UIntPtrField` is a `ScalarField` class to describe `External.Structure` fields that are unsigned integers the same size as a pointer on the host platform. Currently these are always 32-bit as Dolphin is a 32-bit process.'!

!External.UIntPtrField categoriesForClass!External-Data-Types! !

!External.UIntPtrField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uintPtrAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned pointer-sized field at the receiver's offset in the <External.Structure> argument."

	^anExternalStructure bytes uintPtrAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the pointer-sized unsigned <integer> value, anInteger, into the <External.Structure> first argument, at the receiver's offset ."

	^anExternalStructure bytes uintPtrAtOffset: offset put: anInteger! !

!External.UIntPtrField categoriesForMethods!
accessorMessage!automatic generation!private! !
readFrom:!indirect accessing!private! !
writeInto:value:!indirect accessing!private! !
!

!External.UIntPtrField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes. This size will vary between 32 and 64-bit platforms."

	^VMConstants.IntPtrSize! !

!External.UIntPtrField class categoriesForMethods!
byteSize!constants!private! !
!

