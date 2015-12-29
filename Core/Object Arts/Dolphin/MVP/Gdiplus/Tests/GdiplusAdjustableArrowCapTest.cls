"Filed out from Dolphin Smalltalk X6"!

GdiplusTests subclass: #GdiplusAdjustableArrowCapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusAdjustableArrowCapTest guid: (GUID fromString: '{C1FCC802-8763-11D7-B609-00E0987E8081}')!
GdiplusAdjustableArrowCapTest comment: ''!
!GdiplusAdjustableArrowCapTest categoriesForClass!Unclassified! !
!GdiplusAdjustableArrowCapTest methodsFor!

setUp
	super setUp.
	model := GdiplusAdjustableArrowCap 
				height: 10
				width: 5
				isFilled: true!

testHeight
	model height: 17.
	self assert: model height = 17!

testIsFilled
	model isFilled: true.
	self assert: model isFilled.
	model isFilled: false.
	self deny: model isFilled!

testMiddleInset
	model middleInset: 2.
	self assert: model middleInset = 2!

testWidth
	model width: 17.
	self assert: model width = 17! !
!GdiplusAdjustableArrowCapTest categoriesFor: #setUp!public!setup! !
!GdiplusAdjustableArrowCapTest categoriesFor: #testHeight!public!unit tests! !
!GdiplusAdjustableArrowCapTest categoriesFor: #testIsFilled!public!unit tests! !
!GdiplusAdjustableArrowCapTest categoriesFor: #testMiddleInset!public!unit tests! !
!GdiplusAdjustableArrowCapTest categoriesFor: #testWidth!public!unit tests! !

