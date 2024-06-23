"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.BrushTest
	subclass: #'Graphics.Gdiplus.Tests.HatchBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.HatchBrushTest guid: (Core.GUID fromString: '{be9147c0-8247-11d7-b609-00e0987e8081}')!

Graphics.Gdiplus.Tests.HatchBrushTest comment: ''!

!Graphics.Gdiplus.Tests.HatchBrushTest methodsFor!

brushType
	^BrushTypeHatchFill!

createCanonicalSubject
	^self subjectClass
		style: HatchStyleDiagonalCross
		forecolor: Color red
		backcolor: Color blue!

subjectClass
	^HatchBrush!

testFillingCrossDiagonal
	| bitmap |
	self newCanonicalModel.
	bitmap := Bitmap extent: 200 @ 150.
	bitmap graphics fillRectangle: (10 @ 5 extent: bitmap extent - (20 @ 10)) brush: model.
	self assert: (bitmap pixelAt: 12 @ 7) equals: (bitmap pixelAt: 11 @ 6).
	self deny: (bitmap pixelAt: 10 @ 5) equals: (bitmap pixelAt: 11 @ 5).
	bitmap free!

testHatchStyle
	self newCanonicalModel.
	self assert: model hatchStyle equals: HatchStyleDiagonalCross.
	self assert: (Object fromBinaryStoreBytes: model binaryStoreBytes) equals: model!

testLumninance
	model := self subjectClass
				style: HatchStyle25Percent
				forecolor: Color black
				backcolor: Color white.
	self assert: model luminance equals: 0.75!

testPrintString
	| expr |
	self newCanonicalModel.
	expr := model printString.
	self assert: expr
		equals: '(Gdiplus.HatchBrush style: Gdiplus.HatchStyleDiagonalCross forecolor: Color red backcolor: Color blue)'.
	self assert: (Compiler evaluate: expr) equals: model!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject backcolor equals: model backcolor.
	self assert: aGdiplusObject forecolor equals: model forecolor.
	self assert: aGdiplusObject hatchStyle equals: model hatchStyle! !

!Graphics.Gdiplus.Tests.HatchBrushTest categoriesForMethods!
brushType!constants!private! !
createCanonicalSubject!initializing!private! !
subjectClass!constants!private! !
testFillingCrossDiagonal!public!unit tests! !
testHatchStyle!public!unit tests! !
testLumninance!public!unit tests! !
testPrintString!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

