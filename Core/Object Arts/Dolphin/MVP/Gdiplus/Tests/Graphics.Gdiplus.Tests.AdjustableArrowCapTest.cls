"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.AdjustableArrowCapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.AdjustableArrowCapTest guid: (Core.GUID fromString: '{c1fcc802-8763-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Tests.AdjustableArrowCapTest comment: ''!
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest methodsFor!

setUp
	super setUp.
	model := AdjustableArrowCap
				height: 10
				width: 5
				isFilled: true!

testHeight
	model height: 17.
	self assert: model height equals: 17!

testIsFilled
	model isFilled: true.
	self assert: model isFilled.
	model isFilled: false.
	self deny: model isFilled!

testMiddleInset
	model middleInset: 2.
	self assert: model middleInset equals: 2!

testWidth
	model width: 17.
	self assert: model width equals: 17! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesFor: #testHeight!public!unit tests! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesFor: #testIsFilled!public!unit tests! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesFor: #testMiddleInset!public!unit tests! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesFor: #testWidth!public!unit tests! !

