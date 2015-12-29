"Filed out from Dolphin Smalltalk X6.1"!

ExternalField subclass: #PointerField
	instanceVariableNames: 'pointerClass'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PointerField guid: (GUID fromString: '{87B4C4DC-026E-11D3-9FD7-00A0CC3E4A32}')!
PointerField comment: 'PointerField is an <ExternalField> type to represent pointer members of <ExternalStructure>s.'!
!PointerField categoriesForClass!External-Data-Types! !
!PointerField methodsFor!

byteSize
	"Private - Answer the byte size of the ExternalField the receiver represents
	Answer the size of a 32-bit pointer"

	^VMConstants.IntPtrSize!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^pointerClass!

pointerClass: aClass
	"Private - Set the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type. Answer the receiver."

	pointerClass := aClass!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	aWriteStream
		display: self pointerClass;
		space;
		display: #fromAddress:;
		nextPutAll: ' (bytes ';
		display: #intPtrAtOffset:;
		space.
	self printOffsetExpression: aSymbol on: aWriteStream.
	aWriteStream nextPut: $)!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	| keywords |
	keywords := #uintPtrAtOffset:put: keywords.
	aWriteStream
		nextPutAll: 'bytes ';
		display: keywords first;
		space.
	self printOffsetExpression: aSymbol on: aWriteStream.
	aWriteStream
		space;
		display: keywords second;
		nextPutAll: ' anObject ';
		display: #yourAddress!

readFrom: anExternal 
	"Private - Answer an object of the type pointed at by the receiver in 
	anExternal. WARNING: May be a copy or a reference depending on 
	the behavior of pointerClass (which can be any Behavior which
	has the instance creation method #fromAddress:)"

	^self pointerClass fromAddress: (anExternal intPtrAtOffset: offset)!

writeInto: anExternal value: anObject 
	"Private - Write the address of the externally addressable Smalltalk object, anObject,
	into anExternal at the receiver's offset.
	N.B. Precautions must be taken (such as saving the Object as an
	instance variable of the ExternalStructure which encapsulates anExternal)
	to prevent anObject being garbage collected, which will invalidate its
	address. anObject cannot be saved by the receiver, because it is shared
	among all instances of a subclass of ExternalStructure (it is part of
	the class instance variable 'template')."

	^anExternal uintPtrAtOffset: offset put: anObject yourAddress! !
!PointerField categoriesFor: #byteSize!accessing!private! !
!PointerField categoriesFor: #pointerClass!accessing!private! !
!PointerField categoriesFor: #pointerClass:!accessing!private! !
!PointerField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!PointerField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!PointerField categoriesFor: #readFrom:!indirect accessing!private! !
!PointerField categoriesFor: #writeInto:value:!indirect accessing!private! !

!PointerField class methodsFor!

type: aClass
	"Answer a new instance of the receiver which is used for dereferencing
	pointers to objects of type aClass"

	^super new pointerClass: aClass! !
!PointerField class categoriesFor: #type:!instance creation!public! !

