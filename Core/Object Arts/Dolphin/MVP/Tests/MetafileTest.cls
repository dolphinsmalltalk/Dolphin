"Filed out from Dolphin Smalltalk"!

ImageTest subclass: #MetafileTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MetafileTest guid: (GUID fromString: '{c461569e-459f-474b-aa7c-4566176e246f}')!

MetafileTest comment: ''!

!MetafileTest categoriesForClass!Unclassified! !

!MetafileTest methodsFor!

canonicalInstance
	^Metafile fromOwnedHandle: (GDILibrary default getEnhMetaFile: self imageFile)!

expectedImageExtent
	^89 @ 89!

imageFile
	^'resources\tests\example2.emf'!

subjectClass
	^Metafile! !

!MetafileTest categoriesForMethods!
canonicalInstance!helpers!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
!

