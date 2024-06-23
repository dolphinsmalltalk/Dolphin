"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.BrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.BrushTest guid: (Core.GUID fromString: '{a44bef50-db22-468d-bcf1-815158731a8b}')!

Graphics.Gdiplus.Tests.BrushTest isNonInstantiable: true!

Graphics.Gdiplus.Tests.BrushTest comment: ''!

!Graphics.Gdiplus.Tests.BrushTest methodsFor!

brushType
	^self subclassResponsibility!

testIsNone
	self newCanonicalModel.
	self deny: model isNone!

testLumninance
	self newCanonicalModel.
	self assert: model luminance equals: 0.5!

testType
	self newCanonicalModel.
	self assert: model type equals: self brushType! !

!Graphics.Gdiplus.Tests.BrushTest categoriesForMethods!
brushType!constants!private! !
testIsNone!public!unit tests! !
testLumninance!public!unit tests! !
testType!public!unit tests! !
!

