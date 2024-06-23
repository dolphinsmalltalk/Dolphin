"Filed out from Dolphin Smalltalk"!

StructureArrayPointerField subclass: #ConformantStructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ConformantStructureArrayPointerField guid: (GUID fromString: '{87b4c4e5-026e-11d3-9fd7-00a0cc3e4a32}')!

ConformantStructureArrayPointerField comment: 'ConformantStructureArrayPointerField is now deprecated, and should be replaced by use of StructureArrayPointerField class>>type:lengthField:'!

!ConformantStructureArrayPointerField categoriesForClass!Deprecated! !

!ConformantStructureArrayPointerField class methodsFor!

type: aClass length: aSymbol
	^StructureArrayPointerField type: aClass
		arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !

!ConformantStructureArrayPointerField class categoriesForMethods!
type:length:!instance creation!public! !
!

