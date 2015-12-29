"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #SBYTEField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SBYTEField guid: (GUID fromString: '{D9145096-C1D5-4C8D-B640-605D284B0C42}')!
SBYTEField comment: ''!
!SBYTEField categoriesForClass!External-Data-Types! !
!SBYTEField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#sbyteAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal sbyteAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write the value of anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal sbyteAtOffset: offset put: anObject! !
!SBYTEField categoriesFor: #accessorMessage!initializing!private! !
!SBYTEField categoriesFor: #readFrom:!indirect accessing!private! !
!SBYTEField categoriesFor: #writeInto:value:!indirect accessing!private! !

!SBYTEField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^1! !
!SBYTEField class categoriesFor: #byteSize!constants!private! !

