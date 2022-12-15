"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest subclass: #'Graphics.Gdiplus.Tests.RegionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.RegionTest guid: (Core.GUID fromString: '{3e99725f-064c-4d2a-afd6-3d4cf777e9f3}')!
Graphics.Gdiplus.Tests.RegionTest comment: ''!
!Graphics.Gdiplus.Tests.RegionTest methodsFor!

createCanonicalSubject
	^Region fromRectangle: self subjectBounds!

subjectBounds
	^15 @ 25 corner: 75 @ 135!

subjectClass
	^Region!

testBounds
	| graphics rect bitmap |
	bitmap := Bitmap extent: 60 @ 140.
	graphics := bitmap graphics.
	self newCanonicalModel.
	graphics fillRegion: model brush: Brush blue.
	graphics drawRectangle: self subjectBounds.
	false ifTrue: [bitmap clone showExample].
	rect := model bounds: graphics.
	self assert: rect equals: self subjectBounds.
	graphics free.
	bitmap free!

testComparing
	| model2 |
	self newCanonicalModel.
	self verifyEqualToModel: model.
	model2 := model.
	self newCanonicalModel.
	self verifyEqualToModel: model2.
	model2 free.
	model2 := Region empty union: self subjectBounds.
	self verifyEqualToModel: model2.
	model2 free.
	model2 := Region infinite intersection: self subjectBounds.
	self verifyEqualToModel: model2.
	model2 free.
	model2 := Region fromPath: (GraphicsPath fromRectangle: self subjectBounds).
	self assert: (model2 isEqualRegion: model).
	self deny: model2 equals: model.
	self deny: model2 equals: model hash.
	model2 free.
	model makeEmpty.
	self verifyEqualToModel: Region empty.
	model makeInfinite.
	self verifyEqualToModel: Region infinite!

testComplementPath
	| graphics rect1 bitmap path complement rect2 inside outside |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	rect1 := model bounds: graphics.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	complement := model complement: path.
	graphics fillRegion: complement brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawPath: path pen: Pen green.
	rect2 := complement bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: complement identicalTo: model.
	self deny: complement isEmpty.
	inside := rect1 topRight + (1 @ 0).
	self assert: (complement containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topRight + (-1 @ 1).
	self deny: (complement containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color white.
	complement free.
	graphics free.
	bitmap free!

testComplementRectangle
	"This creates a region that subtracts the overlapping area with the 2nd rectangle."

	| graphics rect1 bitmap rect2 complement rect3 inside outside |
	bitmap := Bitmap extent: 60 @ 120.
	graphics := bitmap graphics.
	graphics clear: Color white.
	rect1 := 15 @ 25 corner: 50 @ 75.
	model := Region fromRectangle: rect1.
	self assert: (model bounds: graphics) equals: rect1.
	rect2 := 10 @ 45 corner: 55 @ 80.
	complement := model complement: rect2.
	self deny: complement identicalTo: model.
	graphics fillRegion: complement brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawRectangle: rect2 pen: Pen red.
	rect3 := complement bounds: graphics.
	graphics drawRectangle: rect3 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: complement identicalTo: model.
	self deny: complement isEmpty.
	self assert: rect3 equals: rect2.
	inside := rect1 bottomRight + 1.
	self assert: (complement containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 bottomRight - 1.
	self deny: (complement containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color white.
	complement free.
	graphics free.
	bitmap free!

testComplementRegion
	| graphics rect1 bitmap region2 complement rect2 inside outside |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	rect1 := model bounds: graphics.
	region2 := Region fromPath: (GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}).
	graphics fillRegion: region2 brush: Brush green.
	complement := model complement: region2.
	graphics fillRegion: complement brush: Brush blue.
	graphics drawRectangle: rect1.
	rect2 := complement bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: complement identicalTo: model.
	self deny: complement isEmpty.
	inside := rect1 topRight + (1 @ 0).
	self assert: (complement containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topRight + (-1 @ 1).
	self deny: (complement containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color green.
	complement free.
	graphics free.
	bitmap free!

testExcludePath
	| graphics rect1 bitmap path excluded rect2 inside outside |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	excluded := model exclude: path.
	graphics fillRegion: excluded brush: Brush blue.
	rect1 := model bounds: graphics.
	graphics drawRectangle: rect1 pen: Pen red.
	graphics drawPath: path pen: Pen green.
	rect2 := excluded bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: excluded identicalTo: model.
	self deny: excluded isEmpty.
	inside := rect1 topLeft + (2 @ 10).
	self assert: (excluded containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topRight + (-1 @ 1).
	self deny: (excluded containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color white.
	self assert: rect2 equals: self subjectBounds.
	excluded free.
	graphics free.
	bitmap free!

testExcludeRectangle
	| graphics area bitmap rect2 occluded bgColor |
	bitmap := Bitmap extent: 80 @ 140.
	graphics := bitmap graphics.
	bgColor := Color white.
	graphics clear: bgColor.
	self newCanonicalModel.
	rect2 := 20 @ 15 corner: 55 @ 65.
	occluded := model exclude: rect2.
	graphics fillRegion: occluded brush: Brush blue.
	graphics drawRectangle: self subjectBounds pen: Pen red.
	graphics drawRectangle: rect2 pen: Pen green.
	area := occluded bounds: graphics.
	graphics drawRectangle: area pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: occluded identicalTo: model.
	self deny: occluded isEmpty.
	self assert: area equals: self subjectBounds.
	self assert: (occluded containsPoint: self subjectBounds origin + 2 graphics: graphics).
	self assert: (bitmap pixelAt: self subjectBounds origin + 2) equals: Color blue.
	self deny: (occluded containsPoint: rect2 center graphics: graphics).
	self assert: (bitmap pixelAt: rect2 center) equals: bgColor.
	occluded free.
	graphics free.
	bitmap free!

testExcludeRegion
	| graphics rect1 bitmap excluded rect2 inside outside region2 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	region2 := Region fromPath: (GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}).
	graphics fillRegion: region2 brush: Brush green.
	excluded := model exclude: region2.
	graphics fillRegion: excluded brush: Brush blue.
	rect1 := model bounds: graphics.
	graphics drawRectangle: rect1 pen: Pen red.
	rect2 := excluded bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: excluded identicalTo: model.
	self deny: excluded isEmpty.
	inside := rect1 topLeft + (2 @ 10).
	self assert: (excluded containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topRight + (-1 @ 1).
	self deny: (excluded containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color green.
	self assert: rect2 equals: self subjectBounds.
	excluded free.
	graphics free.
	bitmap free!

testIntersectPath
	| graphics rect1 bitmap path intersection rect2 inside outside |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	intersection := model intersection: path.
	graphics fillRegion: intersection brush: Brush blue.
	rect1 := model bounds: graphics.
	graphics drawRectangle: rect1.
	graphics drawPath: path pen: Pen green.
	rect2 := intersection bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: intersection identicalTo: model.
	self deny: intersection isEmpty.
	inside := rect1 topRight + (-1 @ 1).
	self assert: (intersection containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topLeft + (2 @ 10).
	self deny: (intersection containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color white.
	self assert: rect2 equals: (20 @ 25 corner: 75 @ 110).
	intersection free.
	graphics free.
	bitmap free!

testIntersectRectangle
	"This creates a region that represents only the overlapping area of the two rectangles."

	| graphics area bitmap rect2 intersection |
	bitmap := Bitmap extent: 80 @ 140.
	graphics := bitmap graphics.
	self newCanonicalModel.
	rect2 := 20 @ 15 corner: 55 @ 65.
	intersection := model intersection: rect2.
	graphics fillRegion: intersection brush: Brush blue.
	graphics drawRectangle: self subjectBounds pen: Pen red.
	graphics drawRectangle: rect2 pen: Pen green.
	area := intersection bounds: graphics.
	graphics drawRectangle: area pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: intersection identicalTo: model.
	self deny: intersection isEmpty.
	self assert: area equals: (area intersect: rect2).
	intersection free.
	graphics free.
	bitmap free!

testIntersectRectangleNoOverlap
	"This creates an empty region"

	| graphics rect1 bitmap rect2 intersection |
	bitmap := Bitmap extent: 100 @ 140.
	graphics := bitmap graphics.
	self newCanonicalModel.
	rect2 := self subjectBounds origin: self subjectBounds topRight + (1 @ -5) extent: 20 @ 30.
	intersection := model intersection: rect2.
	graphics fillRegion: intersection brush: Brush blue.
	graphics drawRectangle: self subjectBounds.
	graphics drawRectangle: rect2 pen: (Pen color: Color green).
	rect1 := intersection bounds: graphics.
	self deny: intersection identicalTo: model.
	self assert: intersection isEmpty.
	false ifTrue: [bitmap clone showExample].
	self assert: rect1 equals: (0 @ 0 extent: 0 @ 0).
	intersection free.
	graphics free.
	bitmap free!

testIntersectRegion
	| graphics rect1 bitmap path intersection rect2 inside outside region2 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	self newCanonicalModel.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	region2 := Region fromPath: path.
	graphics fillRegion: region2 brush: Brush green.
	intersection := model intersection: region2.
	graphics fillRegion: intersection brush: Brush blue.
	rect1 := model bounds: graphics.
	graphics drawRectangle: rect1.
	graphics drawPath: path pen: Pen green.
	rect2 := intersection bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: intersection identicalTo: model.
	self deny: intersection isEmpty.
	inside := rect1 topRight + (-1 @ 1).
	self assert: (intersection containsPoint: inside graphics: graphics).
	self assert: (bitmap pixelAt: inside) equals: Color blue.
	outside := rect1 topLeft + (2 @ 10).
	self deny: (intersection containsPoint: outside graphics: graphics).
	self assert: (bitmap pixelAt: outside) equals: Color white.
	self assert: rect2 equals: (20 @ 25 corner: 75 @ 110).
	intersection free.
	graphics free.
	bitmap free!

testIsEmpty
	| graphics |
	graphics := GdiplusGraphics desktop.
	self newCanonicalModel.
	self assert: (model bounds: graphics) equals: self subjectBounds.
	self deny: model isEmpty.
	model makeEmpty.
	self assert: (model bounds: graphics) equals: (Rectangle extent: 0 @ 0).
	self assert: model isEmpty!

testIsInfinite
	| graphics |
	graphics := GdiplusGraphics desktop.
	self newCanonicalModel.
	self assert: (model bounds: graphics) equals: self subjectBounds.
	self deny: model isInfinite.
	model makeInfinite.
	self assert: model isInfinite.
	self assert: (model bounds: graphics)
		equals: (-16r400000 @ -16r400000 extent: 16r800000 @ 16r800000).
!

testUnionPath
	| graphics rect1 bitmap path union rect2 pt1 pt2 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	rect1 := 5 @ 25 corner: 75 @ 175.
	model := Region fromRectangle: rect1.
	self assert: (model bounds: graphics) equals: rect1.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	union := model union: path.
	self deny: union identicalTo: model.
	graphics fillRegion: union brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawPath: path pen: Pen green.
	rect2 := union bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: union identicalTo: model.
	self deny: union isEmpty.
	self assert: rect2 equals: (5 @ 10 corner: 150 @ 175).
	pt1 := rect1 topRight + (-1 @ 1).
	self assert: (union containsPoint: pt1 graphics: graphics).
	self assert: (bitmap pixelAt: pt1) equals: Color blue.
	pt2 := rect1 topLeft + (2 @ 10).
	self assert: (union containsPoint: pt2 graphics: graphics).
	self assert: (bitmap pixelAt: pt2) equals: Color blue.
	union free.
	graphics free.
	bitmap free!

testUnionRectangle
	| graphics rect1 bitmap rect2 union rect3 |
	bitmap := Bitmap extent: 60 @ 120.
	graphics := bitmap graphics.
	rect1 := 15 @ 25 corner: 50 @ 75.
	model := Region fromRectangle: rect1.
	rect2 := 20 @ 15 corner: 55 @ 65.
	union := model union: rect2.
	self deny: union identicalTo: model.
	graphics fillRegion: union brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawRectangle: rect2 pen: Pen green.
	rect3 := union bounds: graphics.
	graphics drawRectangle: rect3 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: union identicalTo: model.
	self deny: union isEmpty.
	self assert: rect3 equals: (rect1 merge: rect2).
	self assert: (union containsPoint: rect1 origin graphics: graphics).
	self assert: (union containsPoint: rect1 corner - 1 graphics: graphics).
	self assert: (union containsPoint: rect2 origin graphics: graphics).
	self assert: (union containsPoint: rect2 corner - 1 graphics: graphics).
	union free.
	graphics free.
	bitmap free!

testUnionRectangleNoOverlap
	"This creates a disjoint region with two non-overlapping areas"

	| graphics rect1 bitmap rect2 union rect3 |
	bitmap := Bitmap extent: 80 @ 120.
	graphics := bitmap graphics.
	rect1 := 15 @ 25 corner: 50 @ 75.
	model := Region fromRectangle: rect1.
	rect2 := 55 @ 15 corner: 75 @ 65.
	union := model union: rect2.
	self deny: union identicalTo: model.
	graphics fillRegion: union brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawRectangle: rect2 pen: Pen green.
	rect3 := union bounds: graphics.
	graphics drawRectangle: rect3 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: union identicalTo: model.
	self deny: union isEmpty.
	self assert: rect3 equals: (rect1 merge: rect2).
	self assert: (union containsPoint: rect1 origin graphics: graphics).
	self assert: (union containsPoint: rect1 corner - 1 graphics: graphics).
	self assert: (union containsPoint: rect2 origin graphics: graphics).
	self assert: (union containsPoint: rect2 corner - 1 graphics: graphics).
	union free.
	graphics free.
	bitmap free!

testUnionRegion
	| graphics rect1 bitmap union rect2 region2 pt1 pt2 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	rect1 := 5 @ 25 corner: 75 @ 175.
	model := Region fromRectangle: rect1.
	self assert: (model bounds: graphics) equals: rect1.
	region2 := Region fromPath: (GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}).
	graphics fillRegion: region2 brush: Brush green.
	union := model union: region2.
	self deny: union identicalTo: model.
	graphics fillRegion: union brush: Brush blue.
	graphics drawRectangle: rect1.
	rect2 := union bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: union identicalTo: model.
	self deny: union isEmpty.
	self assert: rect2 equals: (5 @ 10 corner: 150 @ 175).
	pt1 := rect1 topRight + (-1 @ 1).
	self assert: (union containsPoint: pt1 graphics: graphics).
	self assert: (bitmap pixelAt: pt1) equals: Color blue.
	pt2 := rect1 topLeft + (2 @ 10).
	self assert: (union containsPoint: pt2 graphics: graphics).
	self assert: (bitmap pixelAt: pt2) equals: Color blue.
	union free.
	graphics free.
	bitmap free!

testXorPath
	| graphics rect1 bitmap path xor rect2 pt1 pt2 pt3 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	graphics clear: Color white.
	rect1 := 5 @ 25 corner: 75 @ 175.
	model := Region fromRectangle: rect1.
	self assert: (model bounds: graphics) equals: rect1.
	path := GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	xor := model xor: path.
	self deny: xor identicalTo: model.
	graphics fillRegion: xor brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawPath: path pen: Pen green.
	rect2 := xor bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: xor identicalTo: model.
	self deny: xor isEmpty.
	self assert: rect2 equals: (5 @ 10 corner: 150 @ 175).
	pt1 := rect1 topRight + (-1 @ 1).
	self deny: (xor containsPoint: pt1 graphics: graphics).
	self assert: (bitmap pixelAt: pt1) equals: Color white.
	pt2 := rect1 topLeft + (2 @ 10).
	self assert: (xor containsPoint: pt2 graphics: graphics).
	self assert: (bitmap pixelAt: pt2) equals: Color blue.
	pt3 := path points first + 2.
	self assert: (xor containsPoint: pt3 graphics: graphics).
	self assert: (bitmap pixelAt: pt3) equals: Color blue.
	xor free.
	graphics free.
	bitmap free!

testXorRectangle
	| graphics rect1 bitmap rect2 xor rect3 |
	bitmap := Bitmap extent: 60 @ 120.
	graphics := bitmap graphics.
	rect1 := 15 @ 25 corner: 50 @ 75.
	model := Region fromRectangle: rect1.
	rect2 := 20 @ 15 corner: 55 @ 65.
	xor := model xor: rect2.
	self deny: xor identicalTo: model.
	graphics fillRegion: xor brush: Brush blue.
	graphics drawRectangle: rect1.
	graphics drawRectangle: rect2 pen: Pen green.
	rect3 := xor bounds: graphics.
	graphics drawRectangle: rect3 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: xor identicalTo: model.
	self deny: xor isEmpty.
	self assert: rect3 equals: (rect1 merge: rect2).
	self assert: (xor containsPoint: rect1 origin graphics: graphics).
	self assert: (xor containsPoint: rect1 corner - 1 graphics: graphics).
	self assert: (xor containsPoint: rect2 origin graphics: graphics).
	self assert: (xor containsPoint: rect2 corner - 1 graphics: graphics).
	self deny: (xor containsPoint: rect1 center graphics: graphics).
	xor free.
	graphics free.
	bitmap free!

testXorRegion
	| graphics rect1 bitmap xor rect2 region2 pt1 pt2 pt3 |
	bitmap := Bitmap extent: 200 @ 200.
	graphics := bitmap graphics.
	rect1 := 5 @ 25 corner: 75 @ 175.
	model := Region fromRectangle: rect1.
	self assert: (model bounds: graphics) equals: rect1.
	region2 := Region fromPath: (GraphicsPath polygon: {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}).
	graphics fillRegion: region2 brush: Brush green.
	xor := model xor: region2.
	self deny: xor identicalTo: model.
	graphics fillRegion: xor brush: Brush blue.
	graphics drawRectangle: rect1.
	rect2 := xor bounds: graphics.
	graphics drawRectangle: rect2 pen: Pen dashed.
	false ifTrue: [bitmap clone showExample].
	self deny: xor identicalTo: model.
	self deny: xor isEmpty.
	self assert: rect2 equals: (5 @ 10 corner: 150 @ 175).
	pt1 := rect1 topRight + (-1 @ 1).
	self deny: (xor containsPoint: pt1 graphics: graphics).
	self assert: (bitmap pixelAt: pt1) equals: Color green.
	pt2 := rect1 topLeft + (2 @ 10).
	self assert: (xor containsPoint: pt2 graphics: graphics).
	self assert: (bitmap pixelAt: pt2) equals: Color blue.
	pt3 := 12 @ 12.
	self assert: (xor containsPoint: pt3 graphics: graphics).
	self assert: (bitmap pixelAt: pt3) equals: Color blue.
	xor free.
	graphics free.
	bitmap free!

verifyEqualToModel: aGdiplusObject
	super verifyEqualToModel: aGdiplusObject.
	self assert: (aGdiplusObject isEqualRegion: model)! !
!Graphics.Gdiplus.Tests.RegionTest categoriesForMethods!
createCanonicalSubject!private!running! !
subjectBounds!constants!private! !
subjectClass!constants!private! !
testBounds!public!unit tests! !
testComparing!public!unit tests! !
testComplementPath!public!unit tests! !
testComplementRectangle!public!unit tests! !
testComplementRegion!public!unit tests! !
testExcludePath!public!unit tests! !
testExcludeRectangle!public!unit tests! !
testExcludeRegion!public!unit tests! !
testIntersectPath!public!unit tests! !
testIntersectRectangle!public!unit tests! !
testIntersectRectangleNoOverlap!public!unit tests! !
testIntersectRegion!public!unit tests! !
testIsEmpty!public!unit tests! !
testIsInfinite!public!unit tests! !
testUnionPath!public!unit tests! !
testUnionRectangle!public!unit tests! !
testUnionRectangleNoOverlap!public!unit tests! !
testUnionRegion!public!unit tests! !
testXorPath!public!unit tests! !
testXorRectangle!public!unit tests! !
testXorRegion!public!unit tests! !
verifyEqualToModel:!asserting!private! !
!

