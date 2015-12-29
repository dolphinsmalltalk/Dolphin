"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #SQWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SQWORDField guid: (GUID fromString: '{87B4C4ED-026E-11D3-9FD7-00A0CC3E4A32}')!
SQWORDField comment: ''!
!SQWORDField categoriesForClass!External-Data-Types! !
!SQWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sqwordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal sqwordAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal sqwordAtOffset: offset put: anObject! !
!SQWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!SQWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!SQWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!SQWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A QWORD is always 8 bytes."

	^8! !
!SQWORDField class categoriesFor: #byteSize!constants!private! !

