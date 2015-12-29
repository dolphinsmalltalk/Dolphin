"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #DOUBLEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DOUBLEField guid: (GUID fromString: '{87B4C4E8-026E-11D3-9FD7-00A0CC3E4A32}')!
DOUBLEField comment: ''!
!DOUBLEField categoriesForClass!External-Data-Types! !
!DOUBLEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#doubleAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal doubleAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal doubleAtOffset: offset put: anObject! !
!DOUBLEField categoriesFor: #accessorMessage!initializing!private! !
!DOUBLEField categoriesFor: #readFrom:!indirect accessing!private! !
!DOUBLEField categoriesFor: #writeInto:value:!indirect accessing!private! !

!DOUBLEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.DoubleSize! !
!DOUBLEField class categoriesFor: #byteSize!constants!private! !

