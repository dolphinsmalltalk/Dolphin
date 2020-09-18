"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Path'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Path guid: (Core.GUID fromString: '{1a1a5ea0-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Path comment: 'GdiplusGraphicsPath stores a sequence of lines, curves, and shapes.  The entire sequence can be drawn by calling the drawPath method of a GdiplusGraphics object.  You can partition the sequence of lines, curves, and shapes into figures, and with the help of a GdiplusGraphicsPathIterator object, selected figures can be drawn.  Selected portions of the path can also be drawn by placing markers in the sequence.

'!
!Graphics.Gdiplus.Path categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Path methodsFor!

addArc: aRectangle angles: aPoint
	"Add an arc to the receiver whose bounds are aRectangle and whose start and sweep 
	angles are specified by aPoint."

	GdiplusLibrary default
		gdipAddPathArcI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: aPoint x
		sweepAngle: aPoint y!

addClosedCurve: aPointsCollection
	GdiplusLibrary default
		gdipAddPathClosedCurveI: self asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size!

addCurve: aPointsCollection
	GdiplusLibrary default
		gdipAddPathCurveI: self asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size!

addEllipse: aRectangle
	"Add an ellipse to the receiver whose bounds are aRectangle."

	GdiplusLibrary default
		gdipAddPathEllipseI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

addLineFrom: startPoint to: endPoint
	GdiplusLibrary default
		gdipAddPathLineI: self asParameter
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y!

addLines: aPointsCollection 
	1 to: aPointsCollection size - 1
		do: [:i | self addLineFrom: (aPointsCollection at: i) to: (aPointsCollection at: i + 1)]!

addPolygon: aPointsCollection
	GdiplusLibrary default
		gdipAddPathPolygonI: self asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size!

addRectangle: aRectangle
	GdiplusLibrary default
		gdipAddPathRectangleI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePath: handle!

bounds
	"Answer a bounding Rectangle for the receiver."

	^self getBounds: nil pen: nil!

closeFigure
	GdiplusLibrary default gdipClosePathFigure: self asParameter!

fillMode
	"Answer the receiver's fillMode, a FillMode constant."

	| fillMode |
	fillMode := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathFillMode: self asParameter fillMode: fillMode.
	^fillMode sdwordAtOffset: 0!

fillMode: aFillModeConstant
	"Set the receiver's fillMode to aFillModeConstant."

	GdiplusLibrary default gdipSetPathFillMode: self asParameter fillMode: aFillModeConstant!

getBounds: aGdiplusMatrix pen: aGdiplusPen
	"Private - Answer a bounding Rectangle for the receiver.  aGdiplusMatrix specifies a temporary 
	transformation to be applied to the receiver's path before the bounding rectangle is 
	calculated.  aGdiplusPen influences the size of the bounding rectangle which will be 
	large enough to enclose the receiver even if the path is drawn with a wide pen."

	| rect |
	rect := RECTL new.
	GdiplusLibrary default
		gdipGetPathWorldBoundsI: self asParameter
		bounds: rect
		matrix: aGdiplusMatrix asParameter
		pen: aGdiplusPen asParameter.
	^rect asRectangle!

pointCount
	"Answer the number of points in the receiver."

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPointCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

startFigure
	GdiplusLibrary default gdipStartPathFigure: self asParameter! !
!Graphics.Gdiplus.Path categoriesFor: #addArc:angles:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addClosedCurve:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addCurve:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addEllipse:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addLineFrom:to:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addLines:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addPolygon:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #addRectangle:!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.Path categoriesFor: #bounds!accessing!public! !
!Graphics.Gdiplus.Path categoriesFor: #closeFigure!operations!public! !
!Graphics.Gdiplus.Path categoriesFor: #fillMode!accessing!public! !
!Graphics.Gdiplus.Path categoriesFor: #fillMode:!accessing!public! !
!Graphics.Gdiplus.Path categoriesFor: #getBounds:pen:!accessing!private! !
!Graphics.Gdiplus.Path categoriesFor: #pointCount!accessing!public! !
!Graphics.Gdiplus.Path categoriesFor: #startFigure!operations!public! !

!Graphics.Gdiplus.Path class methodsFor!

exampleGdipGPCreatingFigures
	"MSDN:  Using GDI+ >  Constructing and Drawing Paths > Creating Figures from Lines, Curves, and Shapes

		self exampleGdipGPCreatingFigures showExample
	"

	| bitmap graphics path pen brush |
	bitmap := Bitmap extent: 400 @ 300.
	graphics := bitmap graphics.
	pen := Pen red.
	path := Path new.
	path addArc: (0 @ 0 extent: 50 @ 50) angles: 0 @ -180.
	graphics drawPath: path pen: pen.
	"Create and draw a path that has two figures. The first is an arc followed by a line. The second 
	is a line followed by a curve, followed by a line. The first is left open, and the second is closed."
	pen color: Color blue.
	path := Path new.
	graphics translateTransform: 100 @ 0 order: nil.
	path addArc: (175 @ 50 extent: 50 @ 50) angles: 0 @ 180.
	path addLineFrom: 100 @ 0 to: 250 @ 20.
	path startFigure.
	path addLineFrom: 50 @ 20 to: 5 @ 90.
	path addCurve: {40 @ 60. 50 @ 70. 30 @ 90}.
	path addLineFrom: 50 @ 150 to: 150 @ 180.
	path closeFigure.
	graphics drawPath: path pen: pen.
	"Create, draw and fill a path that has two lines, a rectangle, and an ellipse."
	path := Path new.
	graphics translateTransform: -100 @ 100 order: nil.
	pen color: Color red.
	brush := SolidBrush color: Color darkGreen.
	path addLineFrom: 10 @ 10 to: 100 @ 40.
	path addLineFrom: 100 @ 60 to: 30 @ 60.
	path addRectangle: (50 @ 35 extent: 20 @ 40).
	path addEllipse: (10 @ 75 extent: 40 @ 30).
	graphics drawPath: path pen: pen.
	graphics fillPath: path brush: brush.
	^bitmap!

exampleGdipGPFillingFigures
	"MSDN:   GDI+ >  Using GDI+ >  Constructing and Drawing Paths > Filling Open Figures

		self exampleGdipGPFillingFigures showExample
	"

	| path pen brush bitmap |
	path := Path new.
	path addArc: (0 @ 0 extent: 150 @ 120) angles: 30 @ 120.
	path addEllipse: (50 @ 50 extent: 50 @ 100).
	pen := Pen blue width: 5.
	brush := SolidBrush red.
	bitmap := Bitmap extent: 200 @ 200.
	bitmap graphics
		fillPath: path brush: brush;
		drawPath: path pen: pen.
	^bitmap!

fillMode: aFillModeConstant
	"Answer a new instance of the receiver with specified FillMode constants.
	NB:  An instance created with this method is expected to have objects added to it (e.g., #addEllipse:).
	An instance with no added figures (or pointCount < 2) will raise an error in many cases when 
	messages are sent to it.  Related to this is that an instance created with this method is not persistent
	since the initializer does not hold any information on the added figures but will recreate an instance
	with no points."

	^self fromInitializer: (PathInitializer fillMode: aFillModeConstant)!

new
	"Answer a new instance of the receiver with default fillMode.  NB: See #fillMode: for usage notes."

	^self fillMode: nil!

points: points types: types fillMode: aFillModeConstant
	"Answer a new instance of the receiver with attributes specified by points, types, and aFillModeConstant."

	^self fromInitializer: (PathFromPointsInitializer
				points: points
				types: types
				fillMode: aFillModeConstant)! !
!Graphics.Gdiplus.Path class categoriesFor: #exampleGdipGPCreatingFigures!examples!public!sunit! !
!Graphics.Gdiplus.Path class categoriesFor: #exampleGdipGPFillingFigures!examples!public!sunit! !
!Graphics.Gdiplus.Path class categoriesFor: #fillMode:!instance creation!public! !
!Graphics.Gdiplus.Path class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.Path class categoriesFor: #points:types:fillMode:!instance creation!public! !

