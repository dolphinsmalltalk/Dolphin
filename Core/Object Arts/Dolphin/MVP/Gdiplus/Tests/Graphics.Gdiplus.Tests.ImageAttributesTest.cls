"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.ImageAttributesTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.ImageAttributesTest guid: (Core.GUID fromString: '{f39d5f9d-2a7b-4275-839e-e3f956904dd5}')!

Graphics.Gdiplus.Tests.ImageAttributesTest comment: ''!

!Graphics.Gdiplus.Tests.ImageAttributesTest methodsFor!

subjectClass
	^ImageAttributes!

testIsPersistent
	self newCanonicalModel.
	self deny: model isPersistent! !

!Graphics.Gdiplus.Tests.ImageAttributesTest categoriesForMethods!
subjectClass!constants!private! !
testIsPersistent!public!unit tests! !
!

