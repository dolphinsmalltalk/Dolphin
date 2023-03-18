"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GradientBlendTest
	subclass: #'Graphics.Gdiplus.Tests.GradientPresetBlendTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GradientPresetBlendTest guid: (Core.GUID fromString: '{874fa3a2-936c-4687-9425-0c53193b39c8}')!
Graphics.Gdiplus.Tests.GradientPresetBlendTest comment: ''!
!Graphics.Gdiplus.Tests.GradientPresetBlendTest methodsFor!

subjectClass
	^GradientPresetBlend!

testPrintString
	model := GradientPresetBlend colors: {Color red. Color green. Color magenta} positions: #(0 0.2 1).
	self assert: model isSelfEvaluating.
	self assert: model printString
		equals: '(Gdiplus.GradientPresetBlend colors: {Color red. Color green. Color magenta} positions: #(0.0 0.2 1.0))'.
	self assert: (Compiler evaluate: model printString) equals: model! !
!Graphics.Gdiplus.Tests.GradientPresetBlendTest categoriesForMethods!
subjectClass!constants!private! !
testPrintString!public!unit tests! !
!

