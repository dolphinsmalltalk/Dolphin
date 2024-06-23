"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest
	subclass: #'Graphics.Tests.MetafileTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.MetafileTest guid: (Core.GUID fromString: '{698db9d3-9835-41ab-9c8f-11ed9e78700a}')!

Graphics.Tests.MetafileTest comment: ''!

!Graphics.Tests.MetafileTest methodsFor!

canonicalInstance
	^Metafile fromOwnedHandle: (Gdi32 getEnhMetaFile: self imageFile)!

expectedImageExtent
	^89 @ 89!

imageFile
	^'resources\tests\example2.emf'!

subjectClass
	^Metafile! !

!Graphics.Tests.MetafileTest categoriesForMethods!
canonicalInstance!constants!private! !
expectedImageExtent!constants!private! !
imageFile!public! !
subjectClass!constants!private! !
!

