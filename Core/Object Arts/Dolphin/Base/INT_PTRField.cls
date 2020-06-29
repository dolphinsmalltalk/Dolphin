"Filed out from Dolphin Smalltalk 7"!

ScalarField subclass: #INT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
INT_PTRField guid: (GUID fromString: '{7ac35ffb-9b38-4687-bc95-130b325b2965}')!
INT_PTRField comment: '<INT_PTRField> is a <ScalarField> class to represent <ExternalStructure> fields that are signed integers the same size as a pointer on the host machine architecture. Currently these are always 32-bit as Dolphin is a 32-bit process.'!
!INT_PTRField categoriesForClass!External-Data-Types! !
!INT_PTRField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#intPtrAtOffset:put:!

readFrom: anExternalStructure
	"Private - Answer an <integer> with the same value as the unsigned pointer-sized field at
	the receiver's offset in the <ExternalStructure> argument."

	^anExternalStructure bytes intPtrAtOffset: offset!

writeInto: anExternalStructure value: anInteger
	"Private - Write the pointer-sized signed <integer> value, anInteger, into the
	<ExternalStructure, anExternalStructure, at the receiver's offset ."

	^anExternalStructure bytes intPtrAtOffset: offset put: anInteger! !
!INT_PTRField categoriesFor: #accessorMessage!automatic generation!private! !
!INT_PTRField categoriesFor: #readFrom:!indirect accessing!private! !
!INT_PTRField categoriesFor: #writeInto:value:!indirect accessing!private! !

!INT_PTRField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This size will vary between 32 and 64-bit machines."

	^VMConstants.IntPtrSize! !
!INT_PTRField class categoriesFor: #byteSize!constants!private! !

