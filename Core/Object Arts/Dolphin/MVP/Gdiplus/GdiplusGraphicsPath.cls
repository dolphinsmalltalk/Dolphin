"Filed out from Dolphin Smalltalk 7"!

GdiplusBase subclass: #GdiplusGraphicsPath
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsPath guid: (GUID fromString: '{1a1a5ea0-6151-11d7-b609-00e0987e8081}')!
GdiplusGraphicsPath comment: 'GdiplusGraphicsPath stores a sequence of lines, curves, and shapes.  The entire sequence can be drawn by calling the drawPath method of a GdiplusGraphics object.  You can partition the sequence of lines, curves, and shapes into figures, and with the help of a GdiplusGraphicsPathIterator object, selected figures can be drawn.  Selected portions of the path can also be drawn by placing markers in the sequence.

'!
!GdiplusGraphicsPath categoriesForClass!Unclassified! !
!GdiplusGraphicsPath methodsFor!

addArc: aRectangle angles: aPoint 
	"Add an arc to the receiver whose bounds are aRectangle and whose start and sweep 
	angles are specified by aPoint."

	| status |
	(status := GdiplusLibrary default 
				gdipAddPathArcI: self asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				startAngle: aPoint x
				sweepAngle: aPoint y) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathArcI failed' with: status]!

addClosedCurve: aPointsCollection 
	| status |
	(status := GdiplusLibrary default 
				gdipAddPathClosedCurveI: self asParameter
				points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
						elementClass: POINTL)
				count: aPointsCollection size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathClosedCurveI failed' with: status]!

addCurve: aPointsCollection 
	| status |
	(status := GdiplusLibrary default 
				gdipAddPathCurveI: self asParameter
				points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
						elementClass: POINTL)
				count: aPointsCollection size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathCurveI failed' with: status]!

addEllipse: aRectangle 
	"Add an ellipse to the receiver whose bounds are aRectangle."

	| status |
	(status := GdiplusLibrary default 
				gdipAddPathEllipseI: self asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathEllipseI failed' with: status]!

addLineFrom: startPoint to: endPoint 
	| status |
	(status := GdiplusLibrary default 
				gdipAddPathLineI: self asParameter
				x1: startPoint x
				y1: startPoint y
				x2: endPoint x
				y2: endPoint y) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathLineI failed' with: status]!

addLines: aPointsCollection 
	1 to: aPointsCollection size - 1
		do: [:i | self addLineFrom: (aPointsCollection at: i) to: (aPointsCollection at: i + 1)]!

addPolygon: aPointsCollection 
	| status |
	(status := GdiplusLibrary default 
				gdipAddPathPolygonI: self asParameter
				points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
						elementClass: POINTL)
				count: aPointsCollection size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathPolygonI failed' with: status]!

addRectangle: aRectangle 
	| status |
	(status := GdiplusLibrary default 
				gdipAddPathRectangleI: self asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipAddPathRectangleI failed' with: status]!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeletePath: handle!

bounds
	"Answer a bounding Rectangle for the receiver."

	^self getBounds: nil pen: nil!

closeFigure
	| status |
	(status := GdiplusLibrary default gdipClosePathFigure: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipClosePathFigure failed' with: status]!

fillMode
	"Answer the receiver's fillMode, a FillMode constant."

	| status fillMode |
	fillMode := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathFillMode: self asParameter fillMode: fillMode) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPathFillMode failed' with: status].
	^fillMode asInteger!

fillMode: aFillModeConstant 
	"Set the receiver's fillMode to aFillModeConstant."

	| status |
	(status := GdiplusLibrary default gdipSetPathFillMode: self asParameter fillMode: aFillModeConstant) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetPathFillMode failed' with: status]!

getBounds: aGdiplusMatrix pen: aGdiplusPen 
	"Private - Answer a bounding Rectangle for the receiver.  aGdiplusMatrix specifies a temporary 
	transformation to be applied to the receiver's path before the bounding rectangle is 
	calculated.  aGdiplusPen influences the size of the bounding rectangle which will be 
	large enough to enclose the receiver even if the path is drawn with a wide pen."

	| status rect |
	rect := RECTL new.
	(status := GdiplusLibrary default 
				gdipGetPathWorldBoundsI: self asParameter
				bounds: rect
				matrix: aGdiplusMatrix asParameter
				pen: aGdiplusPen asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPathWorldBoundsI failed' with: status].
	^rect asRectangle!

pointCount
	"Answer the number of points in the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPointCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPointCount failed' with: status].
	^count asInteger!

startFigure
	| status |
	(status := GdiplusLibrary default gdipStartPathFigure: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipStartPathFigure failed' with: status]! !
!GdiplusGraphicsPath categoriesFor: #addArc:angles:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addClosedCurve:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addCurve:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addEllipse:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addLineFrom:to:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addLines:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addPolygon:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #addRectangle:!operations!public! !
!GdiplusGraphicsPath categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusGraphicsPath categoriesFor: #bounds!accessing!public! !
!GdiplusGraphicsPath categoriesFor: #closeFigure!operations!public! !
!GdiplusGraphicsPath categoriesFor: #fillMode!accessing!public! !
!GdiplusGraphicsPath categoriesFor: #fillMode:!accessing!public! !
!GdiplusGraphicsPath categoriesFor: #getBounds:pen:!accessing!private! !
!GdiplusGraphicsPath categoriesFor: #pointCount!accessing!public! !
!GdiplusGraphicsPath categoriesFor: #startFigure!operations!public! !

!GdiplusGraphicsPath class methodsFor!

exampleGdipGPCreatingFigures
	"MSDN:  Using GDI+ >  Constructing and Drawing Paths > Creating Figures from Lines, Curves, and Shapes

		self exampleGdipGPCreatingFigures showExample
	"

	| bitmap graphics path pen brush |
	bitmap := GdiplusBitmap extent: 400 @ 300.
	graphics := bitmap graphics.
	pen := GdiplusPen red.
	path := GdiplusGraphicsPath new.
	path addArc: (0 @ 0 extent: 50 @ 50) angles: 0 @ -180.
	graphics drawPath: path pen: pen.
	"Create and draw a path that has two figures. The first is an arc followed by a line. The second 
	is a line followed by a curve, followed by a line. The first is left open, and the second is closed."
	pen color: Color blue.
	path := GdiplusGraphicsPath new.
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
	path := GdiplusGraphicsPath new.
	graphics translateTransform: -100 @ 100 order: nil.
	pen color: Color red.
	brush := GdiplusSolidBrush color: Color darkGreen.
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
	path := GdiplusGraphicsPath new.
	path addArc: (0 @ 0 extent: 150 @ 120) angles: 30 @ 120.
	path addEllipse: (50 @ 50 extent: 50 @ 100).
	pen := GdiplusPen blue width: 5.
	brush := GdiplusSolidBrush red.
	bitmap := GdiplusBitmap extent: 200 @ 200.
	(bitmap graphics)
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

	^self fromInitializer: (GdiplusGraphicsPathInitializer fillMode: aFillModeConstant)!

new
	"Answer a new instance of the receiver with default fillMode.  NB: See #fillMode: for usage notes."

	^self fillMode: nil!

points: points types: types fillMode: aFillModeConstant 
	"Answer a new instance of the receiver with attributes specified by points, types, and aFillModeConstant."

	^self fromInitializer: (GdiplusGraphicsPathFromPointsInitializer 
				points: points
				types: types
				fillMode: aFillModeConstant)! !
!GdiplusGraphicsPath class categoriesFor: #exampleGdipGPCreatingFigures!examples!public!sunit! !
!GdiplusGraphicsPath class categoriesFor: #exampleGdipGPFillingFigures!examples!public!sunit! !
!GdiplusGraphicsPath class categoriesFor: #fillMode:!instance creation!public! !
!GdiplusGraphicsPath class categoriesFor: #new!instance creation!public! !
!GdiplusGraphicsPath class categoriesFor: #points:types:fillMode:!instance creation!public! !

