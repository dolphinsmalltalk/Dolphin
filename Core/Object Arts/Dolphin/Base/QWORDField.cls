"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #QWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
QWORDField guid: (GUID fromString: '{87B4C4EB-026E-11D3-9FD7-00A0CC3E4A32}')!
QWORDField comment: ''!
!QWORDField categoriesForClass!External-Data-Types! !
!QWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#qwordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal qwordAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal qwordAtOffset: offset put: anObject! !
!QWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!QWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!QWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!QWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!QWORDField class categoriesFor: #byteSize!constants!private! !

