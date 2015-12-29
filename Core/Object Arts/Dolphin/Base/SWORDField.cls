"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #SWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SWORDField guid: (GUID fromString: '{87B4C4EE-026E-11D3-9FD7-00A0CC3E4A32}')!
SWORDField comment: ''!
!SWORDField categoriesForClass!External-Data-Types! !
!SWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#swordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal wordAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal swordAtOffset: offset put: anObject! !
!SWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!SWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!SWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!SWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!SWORDField class categoriesFor: #byteSize!constants!private! !

