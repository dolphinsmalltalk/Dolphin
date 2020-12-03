"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest guid: (Core.GUID fromString: '{de9caa66-14ef-49f9-8e8b-dbda54c36c53}')!
Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest methodsFor!

gdipGetImageGraphicsContext: image graphics: graphics 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := GraphicsFromImageInitializer new library: self!

testCreateHandle
	| image |
	image := Image fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model image: image.
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: image asParameter.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest categoriesFor: #gdipGetImageGraphicsContext:graphics:!accessing!public! !
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

