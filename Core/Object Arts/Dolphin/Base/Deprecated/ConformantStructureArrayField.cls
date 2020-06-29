"Filed out from Dolphin Smalltalk 7"!

StructureArrayField subclass: #ConformantStructureArrayField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
ConformantStructureArrayField guid: (GUID fromString: '{87b4c4e2-026e-11d3-9fd7-00a0cc3e4a32}')!
ConformantStructureArrayField comment: 'ConformantStructureArrayField is now deprecated and should be replaced by use of StructureArrayField class>>type:lengthField:
'!
!ConformantStructureArrayField categoriesForClass!Deprecated! !
!ConformantStructureArrayField class methodsFor!

type: aClass length: aSymbol
	^StructureArrayField type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!ConformantStructureArrayField class categoriesFor: #type:length:!instance creation!public! !

