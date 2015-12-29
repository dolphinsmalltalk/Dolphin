"Filed out from Dolphin Smalltalk X6.1"!

ScalarField subclass: #BOOLField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
BOOLField guid: (GUID fromString: '{87B4C4E6-026E-11D3-9FD7-00A0CC3E4A32}')!
BOOLField comment: ''!
!BOOLField categoriesForClass!External-Data-Types! !
!BOOLField methodsFor!

accessorConverter
	"Private - Answer the converter message to be sent to the value read from the structure to
	convert it to an appropriate Smalltalk object."

	^#asBoolean!

accessorMessage
	"Private - Answer the receiver's 'accessorStem'."

	^#dwordAtOffset:put:!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	super printMutatorBody: aSymbol on: aWriteStream.
	aWriteStream
		space;
		display: #asParameter!

readFrom: anExternal
	"Private - Instantiate an object of the the type the receiver represents
	at the receiver's offset in anExternal"

	^(anExternal dwordAtOffset: offset) asBoolean
!

writeInto: anExternal value: anObject
	"Private - Write anObject into anExternal at the receiver's offset, and in a form
	appropriate for the receiver's External type"

	^(anExternal dwordAtOffset: offset put: anObject) asBoolean! !
!BOOLField categoriesFor: #accessorConverter!automatic generation!private! !
!BOOLField categoriesFor: #accessorMessage!automatic generation!private! !
!BOOLField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!BOOLField categoriesFor: #readFrom:!indirect accessing!private! !
!BOOLField categoriesFor: #writeInto:value:!indirect accessing!private! !

