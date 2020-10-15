"Filed out from Dolphin Smalltalk 7"!

External.ArrayField subclass: #'External.StructureArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.StructureArrayField guid: (Core.GUID fromString: '{87b4c4e1-026e-11d3-9fd7-00a0cc3e4a32}')!
External.StructureArrayField comment: 'StructureArrayField is an <ExternalField> type that can be used to described embedded arrays of structures in <ExternalStructures>.
'!
!External.StructureArrayField categoriesForClass!External-Data-Types! !
!External.StructureArrayField methodsFor!

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

printElementSizeExpressionBodyOn: aWriteStream 
	aWriteStream
		display: self elementClass;
		space;
		display: #basicByteSize!

readFrom: aStructure
	"Private - Answer a <StructureArray> of the receiver's field class which references the array of structures embedded in the <External.Structure> argument at the receiver's offset."

	^self arrayClass
		fromAddress: aStructure yourAddress + offset
		length: (arrayLength getElementCountOf: self in: aStructure)
		elementClass: self fieldClass!

valueParameterName
	"Private - Answer the name to use for the value parameter of a setter method generated for
	the field described by the receiver."

	^'aStructureArrayOf' , self elementClass name!

valueType
	^self arrayClass! !
!External.StructureArrayField categoriesFor: #alignment!constants!public! !
!External.StructureArrayField categoriesFor: #arrayClass!constants!private! !
!External.StructureArrayField categoriesFor: #elementClass!accessing!private! !
!External.StructureArrayField categoriesFor: #elementSize!accessing!private! !
!External.StructureArrayField categoriesFor: #printElementSizeExpressionBodyOn:!automatic generation!private! !
!External.StructureArrayField categoriesFor: #readFrom:!indirect accessing!private! !
!External.StructureArrayField categoriesFor: #valueParameterName!automatic generation!constants!development!private! !
!External.StructureArrayField categoriesFor: #valueType!accessing!private! !

