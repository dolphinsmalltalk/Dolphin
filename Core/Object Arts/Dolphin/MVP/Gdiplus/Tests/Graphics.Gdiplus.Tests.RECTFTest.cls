"Filed out from Dolphin Smalltalk"!

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

testWidth
	super testWidth.
	oddDesktop width: 1351.4.
	self assert: (oddDesktop width closeTo: 1351.4 precision: 0.01).
	self assert: (oddDesktop right closeTo: 1350.4 precision: 0.01)! !

!Graphics.Gdiplus.Tests.RECTFTest categoriesForMethods!
subjectClass!constants!private! !
testHeight!public!unit tests! !
testWidth!public!unit tests! !
!

