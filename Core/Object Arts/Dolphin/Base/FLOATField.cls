"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #FLOATField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FLOATField guid: (GUID fromString: '{87B4C4EA-026E-11D3-9FD7-00A0CC3E4A32}')!
FLOATField comment: ''!
!FLOATField categoriesForClass!External-Data-Types! !
!FLOATField methodsFor!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#floatAtOffset:put:!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^anExternal floatAtOffset: offset
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^anExternal floatAtOffset: offset put: anObject! !
!FLOATField categoriesFor: #accessorMessage!initializing!private! !
!FLOATField categoriesFor: #readFrom:!indirect accessing!private! !
!FLOATField categoriesFor: #writeInto:value:!indirect accessing!private! !

!FLOATField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes."

	^VMConstants.FloatSize! !
!FLOATField class categoriesFor: #byteSize!constants!private! !

