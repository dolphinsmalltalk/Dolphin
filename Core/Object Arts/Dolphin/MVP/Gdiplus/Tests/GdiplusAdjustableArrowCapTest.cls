"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusAdjustableArrowCapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusAdjustableArrowCapTest guid: (GUID fromString: '{c1fcc802-8763-11d7-b609-00e0987e8081}')!

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

!GdiplusAdjustableArrowCapTest categoriesForMethods!
setUp!public!setup! !
testHeight!public!unit tests! !
testIsFilled!public!unit tests! !
testMiddleInset!public!unit tests! !
testWidth!public!unit tests! !
!

