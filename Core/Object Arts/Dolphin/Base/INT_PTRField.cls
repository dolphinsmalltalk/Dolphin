"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #INT_PTRField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
INT_PTRField guid: (GUID fromString: '{7AC35FFB-9B38-4687-BC95-130B325B2965}')!
INT_PTRField comment: ''!
!INT_PTRField categoriesForClass!External-Data-Types! !
!INT_PTRField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#intPtrAtOffset:put:!

readFrom: anExternal 
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal intPtrAtOffset: offset!

writeInto: anExternal value: anObject 
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal intPtrAtOffset: offset put: anObject! !
!INT_PTRField categoriesFor: #accessorMessage!automatic generation!private! !
!INT_PTRField categoriesFor: #readFrom:!indirect accessing!private! !
!INT_PTRField categoriesFor: #writeInto:value:!indirect accessing!private! !

!INT_PTRField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This size will vary between 32 and 64-bit machines."

	^VMConstants.IntPtrSize! !
!INT_PTRField class categoriesFor: #byteSize!constants!private! !

