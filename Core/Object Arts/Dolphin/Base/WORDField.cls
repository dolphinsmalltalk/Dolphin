"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #WORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
WORDField guid: (GUID fromString: '{87B4C4EF-026E-11D3-9FD7-00A0CC3E4A32}')!
WORDField comment: ''!
!WORDField categoriesForClass!External-Data-Types! !
!WORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#wordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal wordAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal wordAtOffset: offset put: anObject! !
!WORDField categoriesFor: #accessorMessage!automatic generation!private! !
!WORDField categoriesFor: #readFrom:!indirect accessing!private! !
!WORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!WORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A WORD is always 16-bits/2 bytes."

	^2! !
!WORDField class categoriesFor: #byteSize!constants!private! !

