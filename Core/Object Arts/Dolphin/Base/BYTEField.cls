"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #BYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BYTEField guid: (GUID fromString: '{87B4C4E7-026E-11D3-9FD7-00A0CC3E4A32}')!
BYTEField comment: ''!
!BYTEField categoriesForClass!External-Data-Types! !
!BYTEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#byteAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal byteAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write the value of anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal byteAtOffset: offset put: anObject! !
!BYTEField categoriesFor: #accessorMessage!initializing!private! !
!BYTEField categoriesFor: #readFrom:!indirect accessing!private! !
!BYTEField categoriesFor: #writeInto:value:!indirect accessing!private! !

!BYTEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!BYTEField class categoriesFor: #byteSize!constants!private! !

