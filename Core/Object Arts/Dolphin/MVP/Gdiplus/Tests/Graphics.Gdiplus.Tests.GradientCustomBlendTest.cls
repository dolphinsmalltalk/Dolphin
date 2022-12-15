"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GradientBlendTest subclass: #'Graphics.Gdiplus.Tests.GradientCustomBlendTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GradientCustomBlendTest guid: (Core.GUID fromString: '{f0f03f56-fb75-4f90-b82c-bea936df2612}')!
Graphics.Gdiplus.Tests.GradientCustomBlendTest comment: ''!
!Graphics.Gdiplus.Tests.GradientCustomBlendTest methodsFor!

subjectClass
	^GradientCustomBlend!

testPrintString
	model := Gdiplus.GradientCustomBlend factors: {0. 1 / 2. 1} positions: {0. 1 / 5. 1}.
	self assert: model isSelfEvaluating.
	self assert: model printString
		equals: '(Gdiplus.GradientCustomBlend factors: #(0.0 0.5 1.0) positions: #(0.0 0.2 1.0))'.
	self assert: (Compiler evaluate: model printString) equals: model! !
!Graphics.Gdiplus.Tests.GradientCustomBlendTest categoriesForMethods!
subjectClass!constants!private! !
testPrintString!public!unit tests! !
!

