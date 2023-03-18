"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.ImageTests
	subclass: #'Graphics.Gdiplus.Tests.ImageTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageTest guid: (Core.GUID fromString: '{913d638b-b96f-42e7-9dd5-da50e692d4b9}')!
Graphics.Gdiplus.Tests.ImageTest comment: ''!
!Graphics.Gdiplus.Tests.ImageTest methodsFor!

subjectClass
	^Image!

testLoadingBmp
	model := self subjectClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model handle.
	self assertPersistedValid free.
	self assertClonedValid free! !
!Graphics.Gdiplus.Tests.ImageTest categoriesForMethods!
subjectClass!constants!private! !
testLoadingBmp!public!unit tests! !
!

