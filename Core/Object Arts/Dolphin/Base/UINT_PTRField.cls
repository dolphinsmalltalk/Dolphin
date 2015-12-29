"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #UINT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
UINT_PTRField guid: (GUID fromString: '{19012B00-96F4-4181-A7E1-0A85A4268D7B}')!
UINT_PTRField comment: ''!
!UINT_PTRField categoriesForClass!External-Data-Types! !
!UINT_PTRField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#uintPtrAtOffset:put:!

readFrom: anExternal 
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal uintPtrAtOffset: offset!

writeInto: anExternal value: anObject 
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal uintPtrAtOffset: offset put: anObject! !
!UINT_PTRField categoriesFor: #accessorMessage!automatic generation!private! !
!UINT_PTRField categoriesFor: #readFrom:!indirect accessing!private! !
!UINT_PTRField categoriesFor: #writeInto:value:!indirect accessing!private! !

!UINT_PTRField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This size will vary between 32 and 64-bit machines."

	^VMConstants.IntPtrSize! !
!UINT_PTRField class categoriesFor: #byteSize!constants!private! !

