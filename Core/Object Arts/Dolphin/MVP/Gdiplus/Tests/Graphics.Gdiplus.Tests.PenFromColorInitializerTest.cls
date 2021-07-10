"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.PenFromColorInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.PenFromColorInitializerTest guid: (Core.GUID fromString: '{af606711-5d59-44e2-b217-d6db5d89ffc4}')!
Graphics.Gdiplus.Tests.PenFromColorInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.PenFromColorInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.PenFromColorInitializerTest methodsFor!

gdipCreatePen1: color width: width unit: unit pen: pen 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := PenFromColorInitializer new library: self!

testCreateHandle
	model color: (Color fromArgbCode: 1) width: 0.5.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: 1.
	self assert: constructorArgs second equals: 0.5.
	self assert: constructorArgs third equals: UnitWorld.
	self assertLastArgIsHandle!

testCreateHandleDefaultWidth
	model color: (Color fromArgbCode: 1) width: nil.
	model createHandle.
	self assert: constructorArgs size equals: 4.
	self assert: constructorArgs first identicalTo: 1.
	self assert: constructorArgs second equals: 1.0.
	self assert: constructorArgs third equals: UnitWorld.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.PenFromColorInitializerTest categoriesForMethods!
gdipCreatePen1:width:unit:pen:!accessing!public! !
setUp!public!setup! !
testCreateHandle!public!unit tests! !
testCreateHandleDefaultWidth!public!unit tests! !
!

