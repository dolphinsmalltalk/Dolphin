"Filed out from Dolphin Smalltalk"!

ArrayField subclass: #StructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

StructureArrayField guid: (GUID fromString: '{87b4c4e1-026e-11d3-9fd7-00a0cc3e4a32}')!

StructureArrayField comment: 'StructureArrayField is an <ExternalField> type that can be used to described embedded arrays of structures in <ExternalStructures>.
'!

!StructureArrayField categoriesForClass!External-Data-Types! !

!StructureArrayField methodsFor!

alignment
	"Answer the alignment requirements for the receiver.
	This is the default alignment required for a field of the receiver's type
	when embedded in an array or structure, generally speaking this is the
	same as the byte size."

	^self fieldClass alignment!

arrayClass
	"Private - Answer the class of <ExternalArray> that this field type describes."

	^StructureArray!

elementClass
	^self fieldClass!

elementSize
	"Private - Answer the byte size of the structures/values that constitute
	the elements of the embedded array the receiver represents."

	^self fieldClass elementSize!

fieldClassName
	"Private - Answer the name of the class of object to be used to represent 
	the embedded field described by the receiver."

	^self arrayClass name!

printElementSizeExpressionBodyOn: aWriteStream 
	aWriteStream
		display: self elementClass;
		space;
		display: #basicByteSize!

readFrom: anExternalStructure
	"Private - Answer a <StructureArray> of the receiver's field class which references the
	array of structures embedded in the <ExternalStructure> argument at the receiver's offset."

	^self arrayClass
		fromAddress: anExternalStructure yourAddress + offset
		length: (arrayLength getElementCountOf: self in: anExternalStructure)
		elementClass: self fieldClass!

valueParameterName
	"Private - Answer the name to use for the value parameter of a setter method generated for
	the field described by the receiver."

	^'aStructureArrayOf' , self elementClass name! !

!StructureArrayField categoriesForMethods!
alignment!constants!public! !
arrayClass!constants!private! !
elementClass!accessing!private! !
elementSize!accessing!private! !
fieldClassName!accessing!private! !
printElementSizeExpressionBodyOn:!automatic generation!private! !
readFrom:!indirect accessing!private! !
valueParameterName!automatic generation!constants!development!private! !
!

