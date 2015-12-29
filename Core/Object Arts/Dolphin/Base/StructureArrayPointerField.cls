"Filed out from Dolphin Smalltalk X6.1"!

ArrayPointerField subclass: #StructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
StructureArrayPointerField guid: (GUID fromString: '{87B4C4E4-026E-11D3-9FD7-00A0CC3E4A32}')!
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

readFrom: struct
	"Private - Answer a <StructureArray> which references the array of structures
	pointed at by the field described by the receiver in the <ExternalStructure>, struct.
	N.B. The answer is a reference, and modifications to it will update the original buffer."

	^self pointerClass 
		fromAddress: (struct sdwordAtOffset: offset) 
		length: self length
		elementClass: self elementClass! !
!StructureArrayPointerField categoriesFor: #elementClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #pointerClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #printAccessorExpressionSuffixOn:!automatic generation!development!private! !
!StructureArrayPointerField categoriesFor: #readFrom:!accessing!private! !

