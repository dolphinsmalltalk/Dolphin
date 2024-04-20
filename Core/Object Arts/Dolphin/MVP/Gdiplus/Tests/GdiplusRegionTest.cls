"Filed out from Dolphin Smalltalk"!

GdiplusTests subclass: #GdiplusRegionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusRegionTest guid: (GUID fromString: '{a4a89625-3ae2-46a1-b9db-e6b8f97e4007}')!

GdiplusRegionTest comment: ''!

!GdiplusRegionTest categoriesForClass!Unclassified! !

!GdiplusRegionTest methodsFor!

createCanonicalSubject
	^self subjectClass fromRectangle: self subjectBounds!

subjectBounds
	^15 @ 25 corner: 75 @ 135!

subjectClass
	^GdiplusRegion!

testBounds
	| graphics rect bitmap |
	bitmap := GdiplusBitmap extent: 60 @ 140.
	graphics := bitmap graphics.
	self newCanonicalModel.
	graphics fillRegion: model brush: GdiplusSolidBrush blue.
	graphics drawRectangle: self subjectBounds.
	false ifTrue: [bitmap clone showExample].
	rect := model bounds: graphics.
	self assert: rect equals: self subjectBounds.
	graphics free.
	bitmap free!

testIsEmpty
	| graphics |
	graphics := GdiplusGraphics fromCanvas: View desktop canvas.
	self newCanonicalModel.
	self assert: (model bounds: graphics) equals: self subjectBounds.
	self deny: model isEmpty.
	model makeEmpty.
	self assert: (model bounds: graphics) equals: (Rectangle extent: 0 @ 0).
	self assert: model isEmpty!

testUnionRectangle
	| graphics rect1 bitmap rect2 rect3 |
	bitmap := GdiplusBitmap extent: 60 @ 120.
	graphics := bitmap graphics.
	rect1 := 15 @ 25 corner: 50 @ 75.
	model := GdiplusRegion fromRectangle: rect1.
	rect2 := 20 @ 15 corner: 55 @ 65.
	model combineRectangle: rect2 mode: CombineModeUnion.
	graphics fillRegion: model brush: GdiplusSolidBrush blue.
	graphics drawRectangle: rect1.
	graphics drawRectangle: rect2 pen: GdiplusPen green.
	rect3 := model bounds: graphics.
	graphics drawRectangle: rect3
		pen: (GdiplusPen new
				dashStyle: DashStyleDash;
				yourself).
	false ifTrue: [bitmap clone showExample].
	self deny: model isEmpty.
	self assert: rect3 equals: (rect1 merge: rect2).
	self assert: (model isVisible: rect1 origin graphics: graphics).
	self assert: (model isVisible: rect1 corner - 1 graphics: graphics).
	self assert: (model isVisible: rect2 origin graphics: graphics).
	self assert: (model isVisible: rect2 corner - 1 graphics: graphics).
	model free.
	graphics free.
	bitmap free! !

!GdiplusRegionTest categoriesForMethods!
createCanonicalSubject!helpers!private! !
subjectBounds!constants!private! !
subjectClass!constants!private! !
testBounds!public! !
testIsEmpty!public!unit tests! !
testUnionRectangle!public!unit tests! !
!

