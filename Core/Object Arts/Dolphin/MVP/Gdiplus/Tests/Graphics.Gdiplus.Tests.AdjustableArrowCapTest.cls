"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.AbstractCustomLineCapTest subclass: #'Graphics.Gdiplus.Tests.AdjustableArrowCapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.AdjustableArrowCapTest guid: (Core.GUID fromString: '{c1fcc802-8763-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Tests.AdjustableArrowCapTest comment: ''!
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest methodsFor!

createCanonicalSubject
	^self subjectClass
		height: 10
		width: 5
		isFilled: true!

createFullSubject
	^self createCanonicalSubject
		middleInset: 2;
		strokeJoin: LineJoinRound;
		widthScale: 3;
		yourself!

subjectClass
	^AdjustableArrowCap!

testComparing
	| model2 |
	super testComparing.
	model2 := self subjectClass new.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model2 isFilled: true.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 widthScale: 2.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model widthScale: 2.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 strokeJoin: LineJoinRound.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model strokeJoin: LineJoinRound.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model middleInset: 4.
	self deny: model2 equals: model.
	self deny: model2 hash equals: model hash.
	model2 middleInset: 4.
	self assert: model2 equals: model.
	self assert: model2 hash equals: model hash.
	model2 free.
	model2 := CustomLineCap
				fillPath: (GraphicsPath polygon: {-15 @ -15. 0 @ 0. 15 @ -15})
				baseCap: LineCapFlat
				baseInset: 0.
	self deny: model equals: model2.
	self deny: model hash equals: model2 hash!

testHeight
	model := self createCanonicalSubject.
	self assert: model height equals: 10.
	model height: 17.
	self assert: model height equals: 17.
	model free.
	self assert: model height equals: 17!

testIsFilled
	model := self createCanonicalSubject.
	self assert: model isFilled.
	model free.
	self assert: model isFilled.
	model isFilled: false.
	self deny: model isFilled.
	model isFilled: true.
	self assert: model isFilled!

testMiddleInset
	model := self createCanonicalSubject.
	self assert: model middleInset equals: 0.
	model middleInset: 2.
	self assert: model middleInset equals: 2.
	model free.
	self assert: model middleInset equals: 2!

testPrintString
	| expr |
	self newCanonicalModel.
	expr := model printString.
	self assert: expr equals: '(Gdiplus.AdjustableArrowCap height: 10 width: 5 isFilled: true)'.
	self assert: (Compiler evaluate: expr) equals: model.
	model strokeJoin: Gdiplus.LineJoinBevel.
	self assert: model printString
		equals: 'a Gdiplus.AdjustableArrowCap(height: 10 width: 5 isFilled: true; strokeJoin: Gdiplus.LineJoinBevel)'!

testStlUpgradeFromD7
	| subject |
	subject := Object
				fromLiteralStoreArray: #(#'!!STL' 4 1639174 ##(Smalltalk.GdiplusAdjustableArrowCap) nil true 2360326 ##(Smalltalk.GdiplusAdjustableArrowCapInitializer) nil 21 11 false).
	self assert: subject height equals: 10.
	self assert: subject width equals: 5.
	self deny: subject isFilled!

testWidth
	model := self createCanonicalSubject.
	self assert: model width equals: 5.
	model width: 17.
	self assert: model width equals: 17.
	model free.
	self assert: model width equals: 17!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject height equals: model height.
	self assert: aGdiplusObject isFilled equals: model isFilled.
	self assert: aGdiplusObject middleInset equals: model middleInset.
	self assert: aGdiplusObject width equals: model width! !
!Graphics.Gdiplus.Tests.AdjustableArrowCapTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
createFullSubject!helpers!private! !
subjectClass!constants!private! !
testComparing!public!unit tests! !
testHeight!public!unit tests! !
testIsFilled!public!unit tests! !
testMiddleInset!public!unit tests! !
testPrintString!public!unit tests! !
testStlUpgradeFromD7!public!unit tests! !
testWidth!public!unit tests! !
verifyEqualToModel:!helpers!private! !
!

