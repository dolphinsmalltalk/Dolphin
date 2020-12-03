"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest guid: (Core.GUID fromString: '{8fde00f2-25d2-4046-907f-a52febba1a57}')!
Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest methodsFor!

gdipCreateFromHDC: hdc graphics: graphics 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GraphicsFromHDCInitializer new library: self!

testCreateHandle
	| bitmap canvas |
	bitmap := Graphics.Bitmap
				gdipCopyOfIcon: Graphics.Bitmap icon
				extent: 32 @ 32
				backcolor: Color black.
	canvas := bitmap canvas.
	model canvas: canvas.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: canvas asParameter.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest categoriesFor: #gdipCreateFromHDC:graphics:!accessing!public! !
!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.GraphicsFromHDCInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

