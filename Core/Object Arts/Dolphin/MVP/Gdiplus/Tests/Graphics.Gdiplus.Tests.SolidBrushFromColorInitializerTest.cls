"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests
	subclass: #'Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest guid: (Core.GUID fromString: '{039f3379-265a-4958-ba78-22f16a9e1300}')!
Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest methodsFor!

subjectClass
	^SolidBrushFromColorInitializer!

testCreateHandle
	| constructor |
	model color: (Color fromArgbCode: 1).
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreateSolidFill:brush:.
	self assert: constructor arguments size equals: 2.
	self assert: constructor arguments first identicalTo: 1.
	self assert: constructor arguments last isKindOf: Handle! !
!Graphics.Gdiplus.Tests.SolidBrushFromColorInitializerTest categoriesForMethods!
subjectClass!constants!private! !
testCreateHandle!public!unit tests! !
!

