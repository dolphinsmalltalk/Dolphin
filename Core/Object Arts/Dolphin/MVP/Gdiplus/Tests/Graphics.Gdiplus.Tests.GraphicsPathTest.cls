"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.GraphicsPathTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.GraphicsPathTest guid: (Core.GUID fromString: '{fcef1a10-834c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Tests.GraphicsPathTest comment: ''!
!Graphics.Gdiplus.Tests.GraphicsPathTest methodsFor!

createFullSubject
	^GraphicsPath new
		addRectangle: (5 @ 10 extent: 100 @ 200);
		addEllipse: (10 @ 20 extent: 50 @ 75);
		fillMode: FillModeWinding;
		yourself!

setSample3Points
	"An equilateral triangle"

	model := self subjectClass points: {100 @ 0. 200 @ 150. 0 @ 150}
				types: {PathPointTypeStart. PathPointTypeLine. PathPointTypeLine | PathPointTypeCloseSubpath}!

setSampleEllipse
	model := self subjectClass ellipse: (Point zero extent: 200 @ 100)!

setSampleNew
	model := self subjectClass new!

subjectClass
	^GraphicsPath!

testAddArc
	| points types reconstituted |
	model := GraphicsPath new.
	self assert: model points equals: #().
	model addArc: (0 @ 0 extent: 50 @ 50) angles: 0 @ -180.
	points := model points.
	types := model types.
	self assert: points size > 4.
	self assert: types size equals: points size.
	self assert: model types
		equals: ((ByteArray new: types size withAll: PathPointTypeBezier)
				at: 1 put: PathPointTypeStart;
				yourself).
	model free.
	self assert: model pointCount equals: points size.
	self assert: model isPersistent.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted points equals: points.
	self assert: reconstituted equals: model.
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: reconstituted bounds extent + (10 @ 20).
			bitmap graphics
				translate: 10 @ 10;
				drawPath: model pen: (Pen color: Color blue width: 3).
			bitmap showExample]!

testAddCurve
	| types1 |
	model := GraphicsPath new.
	model startFigure.
	model addCurve: {50 @ 50. 60 @ 20. 70 @ 100. 80 @ 50}.
	model closeFigure.
	types1 := model types.
	self assert: types1
		equals: ((ByteArray new: types1 size withAll: PathPointTypeBezier3)
				at: 1 put: PathPointTypeStart;
				at: types1 size put: PathPointTypeCloseSubpath | PathPointTypeBezier3;
				yourself).
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: 100 @ 120.
			bitmap graphics
				fillPath: model brush: Brush green;
				drawPath: model.
			bitmap showExample]!

testAddEllipse
	| rect rect2 points points2 types types2 reconstituted |
	model := GraphicsPath new.
	self assert: model points equals: #().
	rect := 15 @ 25 extent: 50 @ 100.
	model := model addEllipse: rect.
	points := model points.
	types := model types.
	self assert: points size > 4.
	self assert: types size equals: points size.
	self assert: model types second equals: PathPointTypeBezier.
	rect2 := rect moveBy: 25.
	model := model addEllipse: rect2.
	points2 := model points.
	types2 := model types.
	model free.
	self assert: model pointCount equals: points2 size.
	self assert: model points equals: points2.
	self assert: model types equals: types2.
	self assert: model isPersistent.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted points equals: points2.
	self assert: reconstituted equals: model.
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: reconstituted bounds extent + rect origin.
			bitmap graphics drawPath: reconstituted.
			bitmap showExample]!

testAddLines
	| points |
	model := GraphicsPath new.
	points := {75 @ 0.
				100 @ 50.
				150 @ 50.
				112 @ 75.
				150 @ 150.
				75 @ 100.
				0 @ 150.
				37 @ 75.
				0 @ 50.
				50 @ 50}.
	model addLines: points.
	self assert: model points equals: points.
	self assert: model types
		equals: ((ByteArray new: points size withAll: PathPointTypeLine)
				at: 1 put: PathPointTypeStart;
				yourself)!

testAddPie
	| rect |
	model := GraphicsPath new.
	rect := 25 @ 25 extent: 100 @ 100.
	model
		addPie: rect
		startAngle: 20
		sweepAngle: 45.
	self assert: model types equals: (ByteArray with: PathPointTypeStart with: PathPointTypeLine with: PathPointTypeBezier with: PathPointTypeBezier with: PathPointTypeBezier|PathPointTypeCloseSubpath).
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: 200 @ 200.
			bitmap graphics
				fillPath: model brush: Brush blue;
				drawPath: model.
			bitmap showExample]!

testAddPolygon
	| triangle triangle2 reconstituted types |
	model := GraphicsPath new.
	self assert: model points equals: #().
	triangle := {50 @ 0. 100 @ 100. 0 @ 100}.
	model := model addPolygon: triangle.
	self assert: model points equals: triangle.
	types := {PathPointTypeStart. PathPointTypeLine. PathPointTypeLine | PathPointTypeCloseSubpath}
				asByteArray.
	self assert: model types equals: types.
	triangle2 := triangle collect: [:each | each + 25].
	model := model addPolygon: triangle2.
	self assert: model points equals: triangle , triangle2.
	self assert: model types equals: types , types.
	self assert: model isPersistent.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted points equals: triangle , triangle2.
	self assert: reconstituted equals: model.
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: reconstituted bounds extent + 10.
			bitmap graphics drawPath: reconstituted.
			bitmap showExample]!

testAddRectangle
	| rect |
	self setSampleNew.
	rect := -10 @ -5 corner: 20 @ 10.
	model addRectangle: rect.
	self assert: model points equals: rect vertices.
	self assert: model types
		equals: {PathPointTypeStart.
				PathPointTypeLine.
				PathPointTypeLine.
				PathPointTypeLine | PathPointTypeCloseSubpath} asByteArray.
	self assertClonedValid free!

testAddRectangle2
	| rect1 rect2 vertices reconstituted |
	rect1 := -5 @ -10 extent: 10 @ 20.
	model := GraphicsPath new.
	model addRectangle: rect1.
	self assert: model points equals: rect1 vertices.
	self assert: model types
		equals: {PathPointTypeStart.
				PathPointTypeLine.
				PathPointTypeLine.
				PathPointTypeLine | PathPointTypeCloseSubpath} asByteArray.
	self assert: model isPersistent.
	rect2 := 5 @ 10 extent: 15 @ 25.
	model addRectangle: rect2.
	vertices := rect1 vertices , rect2 vertices.
	self assert: model points equals: vertices.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted points equals: vertices.
	self assert: reconstituted equals: model.
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: reconstituted bounds extent + 25.
			bitmap graphics
				translate: 25 @ 25;
				drawPath: model.
			bitmap showExample]!

testBounds
	self setSample3Points.
	self assert: (Point zero extent: model bounds extent - 1) equals: (Point zero extent: 200 @ 150)!

testBounds2
	| rect |
	rect := 15 @ 25 extent: 50 @ 100.
	model := GraphicsPath new addEllipse: rect.
	self assert: model bounds equals: (rect expandBy: (0 @ 0 corner: 1 @ 1)).
	false
		ifTrue: 
			[| bitmap graphics region |
			bitmap := Bitmap extent: 100 @ 200.
			graphics := bitmap graphics.
			region := Region fromPath: model.
			graphics fillRegion: region brush: (Brush color: Color paleGreen).
			graphics drawRectangle: rect.
			bitmap showExample]!

testCloseFigure
	| points1 points2 types1 types2 reconstituted |
	model := GraphicsPath new.
	model startFigure.
	self assert: model points equals: #().
	model addLineFrom: 50 @ 20 to: 5 @ 90.
	model addCurve: {40 @ 60. 50 @ 70. 30 @ 90}.
	model addLineFrom: 50 @ 150 to: 150 @ 180.
	points1 := model points.
	types1 := model types.
	self assert: types1 last equals: PathPointTypeLine.
	model closeFigure.
	points2 := model points.
	types2 := model types.
	"No change in points, but the type of the final point should change"
	self assert: points1 equals: points2.
	self assert: types2 last equals: PathPointTypeLine | PathPointTypeCloseSubpath.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted points equals: points2.
	self assert: reconstituted equals: model.
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: reconstituted bounds extent + 25.
			bitmap graphics drawPath: model.
			bitmap showExample]!

testConstructor3Points
	self setSample3Points.
	model asParameter.
	self assertPersistedValid free.
	self assert: model points equals: {100 @ 0. 200 @ 150. 0 @ 150}.
	self assert: model types
		equals: {PathPointTypeStart. PathPointTypeLine. PathPointTypeLine | PathPointTypeCloseSubpath}
				asByteArray.
	self assertClonedValid free!

testContainsPoint
	| rect |
	rect := 15 @ 25 extent: 50 @ 100.
	model := GraphicsPath fromRectangle: rect.
	self assert: (rect containsPoint: rect origin).
	self assert: (model containsPoint: rect origin).
	"See Rectangle>>containsPoint:"
	self deny: (rect containsPoint: rect corner).
	self deny: (model containsPoint: rect corner).
	model := GraphicsPath new.
	model := model addEllipse: rect.
	self assert: (model containsPoint: rect center).
	self deny: (model containsPoint: rect origin)!

testEllipse
	| points types |
	self setSampleEllipse.
	points := model points.
	types := model types.
	self assert: types first equals: PathPointTypeStart.
	2 to: types size - 1 do: [:i | self assert: (types at: i) equals: PathPointTypeBezier].
	self assert: types last equals: PathPointTypeBezier | PathPointTypeCloseSubpath.
	self assert: points first equals: 200 @ 50.
	self assert: points fourth equals: 100 @ 100.
	self assert: points last equals: 200 @ 50.
	self assertClonedValid free!

testFillMode
	self setSampleNew.
	self assert: model fillMode equals: 0.
	{FillModeAlternate. FillModeWinding} do: 
			[:e |
			model fillMode: e.
			self assert: model fillMode equals: e].
	self assertClonedValid free!

testFillMode2
	model := GraphicsPath new.
	self assertIsNil: model basicHandle.
	self assert: model fillMode equals: FillModeAlternate.
	model fillMode: FillModeWinding.
	self assertNotNil: model basicHandle.
	self assert: model fillMode equals: FillModeWinding.
	model free.
	self assert: model points isEmpty.
	self assert: model fillMode equals: FillModeWinding!

testFlatten
	| rect points points2 types types2 count2 count |
	model := GraphicsPath new.
	self assert: model points equals: #().
	rect := 15 @ 25 extent: 50 @ 100.
	model := model addEllipse: rect.
	points := model points.
	types := model types.
	count := types size.
	model flatten: (Matrix new
				translate: 5 @ 15;
				yourself).
	"Default flattening the ellipse into straight lines will require many more points"
	points2 := model points.
	types2 := model types.
	count2 := types2 size.
	self assert: count2 > (2 * count).
	self assert: types2
		equals: ((ByteArray new: count2 withAll: PathPointTypeLine)
				at: 1 put: PathPointTypeStart;
				at: points2 size put: PathPointTypeCloseSubpath | PathPointTypeLine;
				yourself).
	self assert: points2 first equals: points first + (5 @ 15)!

testFromRectangle
	self verifyFromRectangle: (-10 @ -5 corner: 20 @ 10)!

testFromRectangle2
	self verifyFromRectangle: (5 @ 10 extent: 100 @ 200)!

testMarkers
	model := GraphicsPath new.
	model addLines: {75 @ 0. 100 @ 50}.
	model markLast.
	model addLines: {150 @ 50}.
	self assert: model types
		equals: (ByteArray
				with: PathPointTypeStart
				with: PathPointTypeLine | PathPointTypePathMarker
				with: PathPointTypeLine).
	model clearMarkers.
	self assert: model types
		equals: (ByteArray
				with: PathPointTypeStart
				with: PathPointTypeLine
				with: PathPointTypeLine)!

testMarkLast
	model := GraphicsPath new.
	model addLines: {75 @ 0. 100 @ 50}.
	model markLast.
	model addLines: {150 @ 50}.
	self assert: model types
		equals: (ByteArray
				with: PathPointTypeStart
				with: PathPointTypeLine | PathPointTypePathMarker
				with: PathPointTypeLine).
	model clearMarkers.
	self assert: model types
		equals: (ByteArray
				with: PathPointTypeStart
				with: PathPointTypeLine
				with: PathPointTypeLine)!

testOutline
	| types |
	model := GraphicsPath new.
	model
		addRectangle: (-5 @ -10 extent: 15 @ 25);
		addRectangle: (5 @ 10 extent: 15 @ 25).
	types := {PathPointTypeStart.
				PathPointTypeLine.
				PathPointTypeLine.
				PathPointTypeLine | PathPointTypeCloseSubpath} asByteArray.
	"Two separate closed shapes"
	types := types , types.
	self assert: model points
		equals: {-5 @ -10. 10 @ -10. 10 @ 15. -5 @ 15. 5 @ 10. 20 @ 10. 20 @ 35. 5 @ 35}.
	self assert: model types equals: types.
	"Transform to winding outline - we still have the same number of points, because closing lines don't need an endpoint since it is the start point."
	model outline: nil.
	self assert: model points
		equals: {-5 @ -10. 10 @ -10. 10 @ 10. 20 @ 10. 20 @ 35. 5 @ 35. 5 @ 15. -5 @ 15}.
	self assert: model types
		equals: ((ByteArray new: types size withAll: PathPointTypeLine)
				at: 1 put: PathPointTypeStart;
				at: types size put: PathPointTypeLine | PathPointTypeCloseSubpath;
				yourself).
	false
		ifTrue: 
			[| bitmap |
			bitmap := Bitmap extent: model bounds extent + 25.
			bitmap graphics
				translate: 25 @ 25;
				drawPath: model.
			bitmap showExample]!

testPolygon
	| triangleVertices reconstituted |
	triangleVertices := {10 @ 10. 150 @ 10. 100 @ 75. 100 @ 150}.
	model := GraphicsPath polygon: triangleVertices.
	self assert: model points equals: triangleVertices.
	self assert: model isPersistent.
	reconstituted := Object fromBinaryStoreBytes: model binaryStoreBytes.
	self assert: reconstituted equals: model!

testReset
	| rect |
	rect := 15 @ 25 extent: 50 @ 100.
	model := GraphicsPath fromRectangle: rect.
	model fillMode: FillModeWinding.
	self assert: model bounds equals: (rect expandBy: (0 @ 0 corner: 1 @ 1)).
	self assert: model fillMode equals: FillModeWinding.
	model reset.
	self assert: model bounds equals: (0 @ 0 corner: 1 @ 1).
	self assert: model fillMode equals: FillModeAlternate!

testRotate
	self setSample3Points.
	model rotate: 90.
	self assert: model points equals: {0 @ 100. -150 @ 200. -150 @ 0}.
	self assert: model types equals: #[0 1 129].
	self assertClonedValid free!

testScale
	| bitmap graphics |
	bitmap := Bitmap extent: 600 @ 600.
	self setSample3Points.
	graphics := bitmap graphics.
	graphics drawPath: model.
	model scale: 3 @ 2.
	graphics drawPath: model pen: Pen red.
	false ifTrue: [bitmap showExample].
	self assert: model points equals: {300 @ 0. 600 @ 300. 0 @ 300}.
	self assert: model types equals: #[0 1 129].
	self assertClonedValid free!

testShear
	| points points2 types |
	self setSampleEllipse.
	points := model points.
	types := model types.
	model shear: 3 @ 0.
	points2 := model points.
	self assert: points2 size equals: points size.
	self assert: model types equals: types.
	self deny: points2 equals: points.
	self assertClonedValid free!

testTranslate
	| bitmap graphics points |
	bitmap := Bitmap extent: 600 @ 600.
	self setSample3Points.
	points := model points.
	graphics := bitmap graphics.
	graphics drawPath: model.
	model translate: 70 @ 35.
	graphics drawPath: model pen: Pen red.
	false ifTrue: [bitmap showExample].
	self assert: model points equals: (points collect: [:each | each + (70 @ 35)]).
	self assert: model types equals: #[0 1 129].
	self assertClonedValid free!

verifyEqualToModel: aGraphicsPath
	super verifyEqualToModel: aGraphicsPath.
	self assert: aGraphicsPath points equals: model points.
	self assert: aGraphicsPath points equals: model points.
	self assert: aGraphicsPath fillMode equals: model fillMode!

verifyFromRectangle: aRectangle
	| model2 |
	model := GraphicsPath fromRectangle: aRectangle.
	self assert: model points equals: aRectangle vertices.
	self assert: model types
		equals: {PathPointTypeStart.
				PathPointTypeLine.
				PathPointTypeLine.
				PathPointTypeLine | PathPointTypeCloseSubpath} asByteArray.
	model2 := GraphicsPath new addRectangle: aRectangle.
	self assert: model equals: model2.
	model2 free.
	self assertClonedValid free! !
!Graphics.Gdiplus.Tests.GraphicsPathTest categoriesForMethods!
createFullSubject!private!running! !
setSample3Points!initializing!private! !
setSampleEllipse!initializing!private! !
setSampleNew!initializing!private! !
subjectClass!constants!private! !
testAddArc!public!unit tests! !
testAddCurve!public!unit tests! !
testAddEllipse!public!unit tests! !
testAddLines!public!unit tests! !
testAddPie!public!unit tests! !
testAddPolygon!public!unit tests! !
testAddRectangle!public!unit tests! !
testAddRectangle2!public!unit tests! !
testBounds!public!unit tests! !
testBounds2!public!unit tests! !
testCloseFigure!public!unit tests! !
testConstructor3Points!public!unit tests! !
testContainsPoint!public!unit tests! !
testEllipse!public!unit tests! !
testFillMode!public!unit tests! !
testFillMode2!public!unit tests! !
testFlatten!public!unit tests! !
testFromRectangle!public!unit tests! !
testFromRectangle2!public!unit tests! !
testMarkers!public!unit tests! !
testMarkLast!public!unit tests! !
testOutline!public!unit tests! !
testPolygon!public!unit tests! !
testReset!public!unit tests! !
testRotate!public!unit tests! !
testScale!public!unit tests! !
testShear!public!unit tests! !
testTranslate!public!unit tests! !
verifyEqualToModel:!asserting!private! !
verifyFromRectangle:!asserting!private! !
!

