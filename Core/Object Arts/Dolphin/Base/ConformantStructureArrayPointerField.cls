"Filed out from Dolphin Smalltalk X6.1"!

StructureArrayPointerField subclass: #ConformantStructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantStructureArrayPointerField guid: (GUID fromString: '{87B4C4E5-026E-11D3-9FD7-00A0CC3E4A32}')!
ConformantStructureArrayPointerField comment: 'VariableStructureArrayPointerField is an <ExternalField> type to represent <ExternalStructure> members which are pointers to variable length arrays of structures where another field in the structure holds the length of the array, e.g. as in the various OLE counted array structures.'!
!ConformantStructureArrayPointerField categoriesForClass!External-Data-Types! !
!ConformantStructureArrayPointerField methodsFor!

isFixedSize
	^false!

length
	"Answer the length of the array pointed at by the field described
	by the receiver. We don't know until run time what the length
	is, so claim there is one element."

	^1!

printLengthExpressionOn: aWriteStream 
	aWriteStream
		nextPutAll: 'self ';
		display: length!

readFrom: struct
	"Private - Answer a <StructureArray> which references the array of structures
	pointed at by the field described by the receiver in the <ExternalStructure>, struct.
	N.B. The answer is a reference, and modifications to it will update the original buffer."

	^self pointerClass
		fromAddress: (struct sdwordAtOffset: offset) 
		length: (struct perform: length)
		elementClass: self elementClass! !
!ConformantStructureArrayPointerField categoriesFor: #isFixedSize!private!testing! !
!ConformantStructureArrayPointerField categoriesFor: #length!accessing!public! !
!ConformantStructureArrayPointerField categoriesFor: #printLengthExpressionOn:!automatic generation!private! !
!ConformantStructureArrayPointerField categoriesFor: #readFrom:!accessing!private! !

