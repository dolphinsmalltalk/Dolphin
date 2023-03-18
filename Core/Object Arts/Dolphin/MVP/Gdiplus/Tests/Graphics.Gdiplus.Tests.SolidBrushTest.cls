"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.BrushTest
	subclass: #'Graphics.Gdiplus.Tests.SolidBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.SolidBrushTest guid: (Core.GUID fromString: '{1443093f-5a7a-47f8-8686-2e8414d7ad51}')!
Graphics.Gdiplus.Tests.SolidBrushTest comment: ''!
!Graphics.Gdiplus.Tests.SolidBrushTest methodsFor!

brushType
	^BrushTypeSolidColor!

subjectClass
	^SolidBrush!

testClone
	| clone |
	model := Brush blue.
	clone := model clone.
	self deny: clone identicalTo: model.
	"We don't want the initializer to be shared"
	self deny: clone initializer identicalTo: model initializer.
	self assert: clone equals: model.
	self deny: clone handle equals: model handle.
	clone free!

testColor
	| rect bitmap graphics |
	rect := 0 @ 0 extent: 50 @ 50.
	bitmap := Bitmap extent: rect extent.
	graphics := bitmap graphics.
	model := Brush blue.
	self assert: model isKindOf: SolidBrush.
	self assert: model color equals: Color blue.
	graphics fillRectangle: rect brush: model.
	self assert: (bitmap pixelAt: rect origin) equals: Color blue.
	model color: Color purple.
	self assert: model color equals: Color purple.
	rect := rect insetBy: 5.
	graphics fillRectangle: rect brush: model.
	self assert: (bitmap pixelAt: rect origin) equals: Color purple.
	model color: Color green.
	self assert: model color equals: Color green.
	"Now check that will persist using current colour, not the original one"
	rect := rect insetBy: 5.
	graphics fillRectangle: rect brush: (Object fromBinaryStoreBytes: model binaryStoreBytes).
	self assert: (bitmap pixelAt: rect origin) equals: Color green!

testIsNone
	super testIsNone.
	model color: Color none.
	self assert: model isNone!

testLumninance
	self newCanonicalModel.
	model color: Color blue.
	self assert: model luminance equals: Color blue luminance!

testPrintString
	| expr array |
	model := Brush blue.
	self assert: model printString equals: '(Gdiplus.Brush color: Color blue)'.
	"Self-evaluating, so an Array of SolidBrushes should print as a brace array"
	array := {model. Brush green}.
	expr := array printString.
	self assert: expr equals: '{(Gdiplus.Brush color: Color blue). (Gdiplus.Brush color: Color green)}'.
	self assert: (Compiler evaluate: expr) equals: array!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject color equals: model color! !
!Graphics.Gdiplus.Tests.SolidBrushTest categoriesForMethods!
brushType!constants!private! !
subjectClass!constants!private! !
testClone!public!unit tests! !
testColor!public!unit tests! !
testIsNone!public!unit tests! !
testLumninance!public!unit tests! !
testPrintString!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

