"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.BrushTest subclass: #'Graphics.Gdiplus.Tests.TransformableBrushTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.TransformableBrushTest guid: (Core.GUID fromString: '{31dfa4ce-3d7e-424e-acd1-cb639abcfa0e}')!
Graphics.Gdiplus.Tests.TransformableBrushTest isNonInstantiable: true!
Graphics.Gdiplus.Tests.TransformableBrushTest comment: ''!
!Graphics.Gdiplus.Tests.TransformableBrushTest methodsFor!

getTransform: aGdiplusTransformableBrush
	| transform |
	transform := Matrix new.
	self gdipGetTransform: aGdiplusTransformableBrush handle matrix: transform.
	^transform!

testMultiplyTransform
	| matrix matrix2 |
	self newCanonicalModel.
	matrix := Matrix fromArray: #(2 3 4 5 150 150).
	model multiply: matrix order: MatrixOrderAppend.
	self assert: (model transform closeTo: matrix).
	self assert: ((self getTransform: model) closeTo: matrix).
	matrix2 := Matrix fromArray: #(0.75 0.5 0.25 0.2 2 3).
	model multiply: matrix2.
	self assert: (model transform closeTo: #(3.5 4.75 1.3 1.75 166 171) precision: 1e-6).
	self assert: (self getTransform: model) equals: model transform!

testResetTransform
	self newCanonicalModel.
	self assert: model transform isIdentity.
	model transform: (Matrix fromArray: #(0.5 2 1.2 7 1 0.2)).
	self deny: model transform isIdentity.
	model resetTransform.
	self assert: model transform isIdentity!

testRotateTransform
	self newCanonicalModel.
	model rotate: 45.
	self assert: (model transform closeTo: #(0.7071067 0.7071066 -0.7071067 0.7071067 -0.0 -0.0)
				precision: 0.000001)!

testScaleTransform
	self newCanonicalModel.
	model scale: 0.2 @ 1.2.
	self assert: (model transform closeTo: #(0.2 0 0 1.2 0 0))!

testTransform
	self newCanonicalModel.
	self assert: model transform isIdentity.
	model transform: (Matrix fromArray: #(0.5 2 1.2 7 1 0.2)).
	self assert: (model transform closeTo: #(0.5 2 1.2 7 1 0.2)).
	model resetTransform.
	self assert: model transform asArray equals: #(1 0 0 1 0 0)!

testTranslateTransform
	self newCanonicalModel.
	model translate: 100 @ 50.
	self assert: (model transform asArray collect: [:each | each roundTo: 0.0001]) equals: #(1 0 0 1 100 50)!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: aGdiplusObject wrapMode equals: model wrapMode.
	self assert: aGdiplusObject transform equals: model transform! !
!Graphics.Gdiplus.Tests.TransformableBrushTest categoriesForMethods!
getTransform:!helpers!private! !
testMultiplyTransform!public!unit tests! !
testResetTransform!public!unit tests! !
testRotateTransform!public!unit tests! !
testScaleTransform!public!unit tests! !
testTransform!public!unit tests! !
testTranslateTransform!public!unit tests! !
verifyEqualToModel:!asserting!private! !
!

