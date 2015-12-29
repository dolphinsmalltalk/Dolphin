"Filed out from Dolphin Smalltalk X6.1"!

ExternalField subclass: #ScalarField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField guid: (GUID fromString: '{87B4C4DD-026E-11D3-9FD7-00A0CC3E4A32}')!
ScalarField comment: ''!
!ScalarField categoriesForClass!External-Data-Types! !
!ScalarField methodsFor!

accessorConverter
	"Private - Answer the converter message to be sent to the value read from the structure to
	convert it to an appropriate Smalltalk object."

	^nil!

accessorMessage
	"Private - Answer the stem of the accessor message used to access the value of the field
	described by the receiver in a structure."

	^self subclassResponsibility!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This is fixed for ScalarFields."

	^self class byteSize!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	aWriteStream
		nextPutAll: '(bytes ';
		display: self accessorMessage keywords first;
		space.
	self printOffsetExpression: aSymbol on: aWriteStream.
	aWriteStream nextPut: $).
	self accessorConverter 
		ifNotNil: 
			[:message | 
			aWriteStream
				space;
				display: message]!

printMutatorBody: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an isntance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	| keywords |
	keywords := self accessorMessage keywords.
	aWriteStream
		nextPutAll: 'bytes';
		space;
		display: keywords first;
		space.
	self printOffsetExpression: aSymbol on: aWriteStream.
	aWriteStream
		space;
		display: keywords second;
		nextPutAll: ' anObject'! !
!ScalarField categoriesFor: #accessorConverter!automatic generation!private! !
!ScalarField categoriesFor: #accessorMessage!automatic generation!private! !
!ScalarField categoriesFor: #byteSize!constants!private! !
!ScalarField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!ScalarField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !

!ScalarField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A large number of fields are the same size as an integer."

	^VMConstants.IntSize! !
!ScalarField class categoriesFor: #byteSize!constants!private! !

