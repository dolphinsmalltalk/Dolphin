"Filed out from Dolphin Smalltalk 7"!

External.StructureArrayField subclass: #'External.ConformantStructureArrayField'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
External.ConformantStructureArrayField guid: (Core.GUID fromString: '{87b4c4e2-026e-11d3-9fd7-00a0cc3e4a32}')!
External.ConformantStructureArrayField comment: 'ConformantStructureArrayField is now deprecated and should be replaced by use of StructureArrayField class>>type:lengthField:
'!
!External.ConformantStructureArrayField categoriesForClass!Deprecated! !
!External.ConformantStructureArrayField class methodsFor!

type: aClass length: aSymbol
	^StructureArrayField type: aClass arrayLength: (ConformantArrayFieldLength lengthField: aSymbol)! !
!External.ConformantStructureArrayField class categoriesFor: #type:length:!instance creation!public! !

