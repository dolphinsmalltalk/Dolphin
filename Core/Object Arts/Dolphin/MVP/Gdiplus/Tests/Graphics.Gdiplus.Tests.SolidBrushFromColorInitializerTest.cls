"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest guid: (Core.GUID fromString: '{039f3379-265a-4958-ba78-22f16a9e1300}')!
Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest methodsFor!

gdipCreateSolidFill: color brush: brush 
	constructorArgs := Processor activeProcess topFrame arguments.
	^Ok!

setUp
	super setUp.
	model := SolidBrushFromColorInitializer new library: self!

testCreateHandle
	model color: (Color fromArgbCode: 1).
	model createHandle.
	self assert: constructorArgs size equals: 2.
	self assert: constructorArgs first identicalTo: 1.
	self assertLastArgIsHandle! !
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest categoriesFor: #gdipCreateSolidFill:brush:!accessing!public! !
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest categoriesFor: #testCreateHandle!public!unit tests! !

