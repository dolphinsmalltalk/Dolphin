"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.InitializerTests subclass: #'Graphics.Gdiplus.Tests.PenInitializerTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.PenInitializerTest guid: (Core.GUID fromString: '{af606711-5d59-44e2-b217-d6db5d89ffc4}')!
Graphics.Gdiplus.Tests.PenInitializerTest comment: ''!
!Graphics.Gdiplus.Tests.PenInitializerTest methodsFor!

createCanonicalSubject
	^self subjectClass ink: Color red width: nil!

subjectClass
	^PenInitializer!

testCreateHandleFromBrushDefaultWidth
	| brush constructor messages |
	brush := HatchBrush
				style: HatchStyleLargeConfetti
				forecolor: Color yellow
				backcolor: Color blue.
	model ink: brush width: nil.
	messages := self createHandle.
	"Here we are just checking that the brush gets realised"
	self assert: messages size equals: 2.
	self assert: messages first selector identicalTo: #gdipCreateHatchBrush:forecol:backcol:brush:.
	constructor := messages last.
	self assert: constructor selector identicalTo: #gdipCreatePen2:width:unit:pen:.
	self assert: constructor arguments size equals: 4.
	self assert: brush basicHandle notNil.
	self assert: constructor arguments first identicalTo: brush basicHandle.
	self assert: constructor arguments second isKindOf: Float.
	self assert: constructor arguments second equals: 1.0.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleFromColor
	| constructor |
	model ink: (Color fromArgbCode: 1) width: 1 / 2.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreatePen1:width:unit:pen:.
	self assert: constructor arguments size equals: 4.
	self assert: constructor arguments first identicalTo: 1.
	self assert: constructor arguments second isKindOf: Float.
	self assert: constructor arguments second equals: 0.5.
	self assert: constructor arguments third equals: UnitWorld.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleFromColorDefaultWidth
	| constructor |
	model ink: (Color fromArgbCode: 1) width: nil.
	constructor := self createHandle single.
	self assert: constructor selector identicalTo: #gdipCreatePen1:width:unit:pen:.
	self assert: constructor arguments size equals: 4.
	self assert: constructor arguments first identicalTo: 1.
	self assert: constructor arguments second isKindOf: Float.
	self assert: constructor arguments second equals: 1.0.
	self assert: constructor arguments third equals: UnitWorld.
	self assert: constructor arguments last isKindOf: Handle!

testCreateHandleFromSolidBrush
	| constructor brush messages |
	brush := Brush color: (Color red alpha: 100).
	model ink: brush width: 0.5.
	messages := self createHandle.
	"Here we are just checking that the brush gets realised"
	self assert: messages size equals: 2.
	self assert: messages first selector identicalTo: #gdipCreateSolidFill:brush:.
	constructor := messages last.
	self assert: constructor selector identicalTo: #gdipCreatePen2:width:unit:pen:.
	self assert: constructor arguments size equals: 4.
	self assert: constructor arguments first identicalTo: brush basicHandle.
	self assert: constructor arguments second isKindOf: Float.
	self assert: constructor arguments second equals: 0.5.
	self assert: constructor arguments last isKindOf: Handle! !
!Graphics.Gdiplus.Tests.PenInitializerTest categoriesForMethods!
createCanonicalSubject!private!running! !
subjectClass!constants!private! !
testCreateHandleFromBrushDefaultWidth!public!unit tests! !
testCreateHandleFromColor!public!unit tests! !
testCreateHandleFromColorDefaultWidth!public!unit tests! !
testCreateHandleFromSolidBrush!public!unit tests! !
!

