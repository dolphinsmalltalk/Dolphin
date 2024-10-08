﻿"Filed out from Dolphin Smalltalk"!

External.Tests.RECTTest
	subclass: #'Graphics.Gdiplus.Tests.RECTFTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Tests.RECTFTest guid: (Core.GUID fromString: '{d0dfe601-c177-4287-90c5-0e1511092e89}')!

Graphics.Gdiplus.Tests.RECTFTest comment: ''!

!Graphics.Gdiplus.Tests.RECTFTest methodsFor!

subjectClass
	^RectF!

testHeight
	super testHeight.
	self assert: oddDesktop bottom equals: 1023.
	oddDesktop height: 1025.5.
	self assert: oddDesktop height equals: 1025.5.
	self assert: oddDesktop bottom equals: 1027.5!

testScaleToDpiFrom
	"Test DPI scaling in-place"

	| rect |
	super testScaleToDpiFrom.
	rect := self subjectClass marshal: (1@1 extent: 186@21).
	rect scaleToDpi: 120 from: 96.
	self assert: rect equals: (1.25@1.25 corner: 233.75@27.5)
!

testWidth
	super testWidth.
	oddDesktop width: 1351.4.
	self assert: (oddDesktop width closeTo: 1351.4 precision: 0.01).
	self assert: (oddDesktop right closeTo: 1350.4 precision: 0.01)! !

!Graphics.Gdiplus.Tests.RECTFTest categoriesForMethods!
subjectClass!constants!private! !
testHeight!public!unit tests! !
testScaleToDpiFrom!public!unit tests! !
testWidth!public!unit tests! !
!

