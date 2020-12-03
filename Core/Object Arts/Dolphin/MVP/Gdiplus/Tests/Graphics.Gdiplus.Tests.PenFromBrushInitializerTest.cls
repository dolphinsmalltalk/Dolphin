"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.PenFromBrushInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.PenFromBrushInitializerTest guid: (Core.GUID fromString: '{911c5add-1255-427e-b2e6-26d9d8f38caf}')!
Graphics.Gdiplus.Tests.PenFromBrushInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest methodsFor!

gdipCreatePen2: brush width: width unit: unit pen: pen 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := PenFromBrushInitializer new library: self!

testCreateHandle
	| brush |
	brush := self getSampleBrush.
	model brush: brush width: 0.5.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: brush basicHandle.
	self assert: constructorArgs second equals: 0.5.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	| brush |
	brush := self getSampleBrush.
	model brush: brush width: nil.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: brush basicHandle.
	self assert: constructorArgs second equals: 1.0.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest categoriesFor: #gdipCreatePen2:width:unit:pen:!accessing!public! !
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !
!Graphics.Gdiplus.Tests.PenFromBrushInitializerTest categoriesFor: #testCreateHandleDefaultWidth!public!unit tests! !

