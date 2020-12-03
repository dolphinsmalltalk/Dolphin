"Filed out from Dolphin Smalltalk 7"!

External.StructureArrayPointerField subclass: #'External.ConformantStructureArrayPointerField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ConformantStructureArrayPointerField guid: (Core.GUID fromString: '{87b4c4e5-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ConformantStructureArrayPointerField comment: 'ConformantStructureArrayPointerField is now deprecated, and should be replaced by use of StructureArrayPointerField class>>type:lengthField:'!
!External.ConformantStructureArrayPointerField categoriesForClass!Deprecated! !
!External.ConformantStructureArrayPointerField class methodsFor!

type: aClass length: aSymbol
	^StructureArrayPointerField type: aClass
		arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!External.ConformantStructureArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

