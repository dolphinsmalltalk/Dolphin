"Filed out from Dolphin Smalltalk 7"!

StructureArrayPointerField subclass: #ConformantStructureArrayPointerField
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ConformantStructureArrayPointerField guid: (GUID fromString: '{87b4c4e5-026e-11d3-9fd7-00a0cc3e4a32}')!
ConformantStructureArrayPointerField comment: 'ConformantStructureArrayPointerField is now deprecated, and should be replaced by use of StructureArrayPointerField class>>type:lengthField:'!
!ConformantStructureArrayPointerField categoriesForClass!External-Data-Types! !
!ConformantStructureArrayPointerField class methodsFor!

type: aClass length: aSymbol
	"Answer a new instance of the receiver which is used for describing embedded arrays of
	external type, aClass, with a varying number of elements stored in another field of the
	owning <ExternalStructure> as named by the <Symbol> argument, aSymbol."

	#deprecated.
	^StructureArrayPointerField type: aClass lengthField: aSymbol! !
!ConformantStructureArrayPointerField class categoriesFor: #type:length:!instance creation!public! !

