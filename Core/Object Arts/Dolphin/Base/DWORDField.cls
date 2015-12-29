"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #DWORDField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DWORDField guid: (GUID fromString: '{87B4C4E9-026E-11D3-9FD7-00A0CC3E4A32}')!
DWORDField comment: ''!
!DWORDField categoriesForClass!External-Data-Types! !
!DWORDField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#dwordAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal dwordAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal dwordAtOffset: offset put: anObject! !
!DWORDField categoriesFor: #accessorMessage!automatic generation!private! !
!DWORDField categoriesFor: #readFrom:!indirect accessing!private! !
!DWORDField categoriesFor: #writeInto:value:!indirect accessing!private! !

!DWORDField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A DWORD is always 4 bytes."

	^4! !
!DWORDField class categoriesFor: #byteSize!constants!private! !

