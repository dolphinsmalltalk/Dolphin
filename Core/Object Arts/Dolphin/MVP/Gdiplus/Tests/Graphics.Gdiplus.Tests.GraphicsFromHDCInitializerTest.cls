"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest guid: (Core.GUID fromString: '{8fde00f2-25d2-4046-907f-a52febba1a57}')!

Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest comment: ''!

!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest methodsFor!

subjectClass
	^GraphicsFromHDCInitializer!

testCreateHandle
	| constructor bitmap canvas |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Graphics.Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	canvas := bitmap canvas.
	model surface: canvas.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateFromHDC:graphics:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: canvas asParameter.
	self assert: constructor arguments last isKindOf: Handle.
	bitmap free!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !

!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!

