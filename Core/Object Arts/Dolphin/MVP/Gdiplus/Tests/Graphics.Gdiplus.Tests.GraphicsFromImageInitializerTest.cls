"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest guid: (Core.GUID fromString: '{de9caa66-14ef-49f9-8e8b-dbda54c36c53}')!
Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest methodsFor!

subjectClass
	^GraphicsFromImageInitializer!

testCreateHandle
	| constructor image messages |
	image := Image fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model surface: image.
	messages := self createHandle.
	self assertNotNil: image basicHandle.
	constructor := messages last.
	self assert: constructor selector identicalTo: #gdipGetImageGraphicsContext:graphics:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: image basicHandle.
	self assert: constructor arguments last isKindOf: Handle.
	image free!

testIsPersistent
	"Cant persist an <IStream>"

	self deny: model isPersistent! !
!Graphics.Gdiplus.Tests.GraphicsFromImageInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
testIsPersistent!public!unit tests! !
!

