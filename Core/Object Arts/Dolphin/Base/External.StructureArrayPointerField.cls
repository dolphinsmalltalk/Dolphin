"Filed out from Dolphin Smalltalk 7"!

ArrayPointerField subclass: #StructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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

readFrom: anExternalStructure
	"Private - Answer a <StructureArray> of the receiver's element class that is a reference to
	the data pointed at by the corresponding pointer field of the <ExternalStructure> argument
	at the receiver's offset, and which is of the length described by the receiver."

	^self pointerClass
		fromAddress: (anExternalStructure bytes sdwordAtOffset: offset)
		length: (arrayLength getElementCountOf: self in: anExternalStructure)
		elementClass: self elementClass! !
!StructureArrayPointerField categoriesFor: #elementClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #pointerClass!accessing!private! !
!StructureArrayPointerField categoriesFor: #readFrom:!accessing!private! !

