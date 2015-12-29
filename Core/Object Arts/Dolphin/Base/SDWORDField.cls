"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #SDWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SDWORDField guid: (GUID fromString: '{87B4C4EC-026E-11D3-9FD7-00A0CC3E4A32}')!
SDWORDField comment: ''!
!SDWORDField categoriesForClass!External-Data-Types! !
!SDWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sdwordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal sdwordAtOffset: offset!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal sdwordAtOffset: offset put: anObject! !
!SDWORDField categoriesFor: #accessorMessage!initializing!private! !
!SDWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!SDWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

