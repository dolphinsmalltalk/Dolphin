"Filed out from Dolphin Smalltalk 7"!

ExternalField subclass: #ScalarField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ScalarField guid: (GUID fromString: '{87b4c4dd-026e-11d3-9fd7-00a0cc3e4a32}')!
ScalarField comment: '<ScalarField> is the abstract class of <ExternalField>s to describe <ExternalStructure> fields of simple scalar types, e.g. ints, boolean, etc.'!
!ScalarField categoriesForClass!External-Data-Types! !
!ScalarField methodsFor!

accessorMessage
	"Private - Answer the stem of the accessor message used to access the value of the field
	described by the receiver in a structure."

	^self subclassResponsibility!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	This is fixed for ScalarFields."

	^self class byteSize!

fieldClassName
	^Integer name!

printAccessorExpression: aSymbol on: aWriteStream 
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will read the value of this field from an instance of the structure. The field in question
	is after the fields in the <sequencedReadableCollection> that is the 2nd argument."

	aWriteStream
		nextPutAll: '(bytes ';
		display: self accessorMessage keywords first;
		space.
	self printOffsetExpression: aSymbol on: aWriteStream.
	aWriteStream nextPut: $)!

printMutatorBody: aSymbol on: aWriteStream
	"Private - Print a suitable statement or statement onto the specified <puttableStream> which
	will write the value of this field into an instance of the structure. The field in question
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
		space.
	self printMutatorValueOn: aWriteStream parameter: self valueParameterName!

printMutatorValueOn: aWriteStream parameter: aString
	"Private - Print a suitable expression onto the specified <puttableStream> which will
	evaluate to the the value to be stored into this field in an instance of the structure when
	compiled into a mutator method where the value parameter is named by the <String> argument."

	aWriteStream nextPutAll: aString! !
!ScalarField categoriesFor: #accessorMessage!automatic generation!private! !
!ScalarField categoriesFor: #byteSize!constants!private! !
!ScalarField categoriesFor: #fieldClassName!automatic generation!constants!development!private! !
!ScalarField categoriesFor: #printAccessorExpression:on:!automatic generation!development!private! !
!ScalarField categoriesFor: #printMutatorBody:on:!automatic generation!development!private! !
!ScalarField categoriesFor: #printMutatorValueOn:parameter:!automatic generation!development!private! !

!ScalarField class methodsFor!

byteSize
	"Private - Answer the size of the field type the receiver represents in bytes.
	A large number of fields are the same size as an integer."

	^VMConstants.IntSize! !
!ScalarField class categoriesFor: #byteSize!constants!private! !

