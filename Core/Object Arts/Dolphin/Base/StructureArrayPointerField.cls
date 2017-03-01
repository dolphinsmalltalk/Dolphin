"Filed out from Dolphin Smalltalk 7"!

ArrayPointerField subclass: #StructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayPointerField guid: (GUID fromString: '{87b4c4e4-026e-11d3-9fd7-00a0cc3e4a32}')!
StructureArrayPointerField comment: 'StructureArrayPointerField is an <ExternalField> type to represent <ExternalStructure> members which are pointers to arrays of structures.'!
!StructureArrayPointerField categoriesForClass!External-Data-Types! !
!StructureArrayPointerField methodsFor!

elementClass
	"Private - Answer the class of Smalltalk object embedded in the structure
	array pointed at by fields described by the receiver."

	^pointerClass!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^StructureArray!

printAccessorExpressionSuffixOn: aWriteStream 
	"Private - Print any extra messages/statements onto the <puttableStream> argument that are required to
	configure the object being read from the structure instance."

	"We need to set the length and element class of the structure array"

	super printAccessorExpressionSuffixOn: aWriteStream.
	aWriteStream
		space;
		display: #elementClass:;
		space;
		display: self elementClass!

readFrom: anExternalStructure
	"Private - Answer a <StructureArray> of the receiver's element class that is a reference to
	the data pointed at by the corresponding pointer field of the <ExternalStructure> argument
	at the receiver's offset, and which is of the length described by the receiver."

	^self pointerClass
		fromAddress: (anExternalStructure sdwordAtOffset: offset)
		length: (arrayLength getElementCountOf: ExternalField new in: anExternalStructure)
		elementClass: self elementClass! !
!StructureArrayPointerField categoriesFor: #elementClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #pointerClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!StructureArrayPointerField categoriesFor: #readFrom:!accessing!private! !

