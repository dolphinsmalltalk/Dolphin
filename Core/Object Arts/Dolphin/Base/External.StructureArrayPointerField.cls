"Filed out from Dolphin Smalltalk"!

External.ArrayPointerField
	subclass: #'External.StructureArrayPointerField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

External.StructureArrayPointerField guid: (Core.GUID fromString: '{87b4c4e4-026e-11d3-9fd7-00a0cc3e4a32}')!

External.StructureArrayPointerField comment: 'StructureArrayPointerField is an <ExternalField> type to represent <ExternalStructure> members which are pointers to arrays of structures.'!

!External.StructureArrayPointerField categoriesForClass!External-Data-Types! !

!External.StructureArrayPointerField methodsFor!

elementClass
	"Private - Answer the class of Smalltalk object embedded in the structure
	array pointed at by fields described by the receiver."

	^pointerClass!

pointerClass
	"Private - Answer the class of Smalltalk object to be used when dereferencing
	pointers of the receiver's type."

	^StructureArray!

readFrom: aStructure
	"Private - Answer a <StructureArray> of the receiver's element class that is a reference to the data pointed at by the corresponding pointer field of the <External.Structure> argument at the receiver's offset, and which is of the length described by the receiver."

	^self pointerClass
		fromAddress: (aStructure bytes int32AtOffset: offset)
		length: (arrayLength getElementCountOf: self in: aStructure)
		elementClass: self elementClass! !

!External.StructureArrayPointerField categoriesForMethods!
elementClass!accessing!private! !
pointerClass!accessing!private! !
readFrom:!accessing!private! !
!

