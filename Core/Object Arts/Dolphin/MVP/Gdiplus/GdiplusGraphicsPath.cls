"Filed out from Dolphin Smalltalk"!

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
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size!

addCurve: aPointsCollection
	GdiplusLibrary default
		gdipAddPathCurveI: self asParameter
		points: (POINTLArray marshal: aPointsCollection)
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
		points: (POINTLArray marshal: aPointsCollection)
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

	^self bounds: nil withPen: nil!

bounds: aGdiplusMatrix withPen: aGdiplusPen
	"Answer a bounding Rectangle for the receiver.  aGdiplusMatrix specifies a temporary 
	transformation to be applied to the receiver's path before the bounding rectangle is 
	calculated.  aGdiplusPen influences the size of the bounding rectangle which will be 
	large enough to enclose the receiver even if the path is drawn with a wide pen."

	| rect |
	rect := GpRect newBuffer.
	GdiplusLibrary default
		gdipGetPathWorldBoundsI: self asParameter
		bounds: rect
		matrix: aGdiplusMatrix asParameter
		pen: aGdiplusPen asParameter.
	^rect asRectangle!

boundsWithPen: aGdiplusPen
	^self bounds: nil withPen: aGdiplusPen!

closeFigure
	GdiplusLibrary default gdipClosePathFigure: self asParameter!

fillMode
	"Answer the receiver's fillMode, a FillMode constant."

	| fillMode |
	fillMode := SDWORD new.
	GdiplusLibrary default gdipGetPathFillMode: self asParameter fillMode: fillMode.
	^fillMode asInteger!

fillMode: aFillModeConstant
	"Set the receiver's fillMode to aFillModeConstant."

	GdiplusLibrary default gdipSetPathFillMode: self asParameter fillMode: aFillModeConstant!

pointCount
	"Answer the number of points in the receiver."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPointCount: self asParameter count: count.
	^count asInteger!

startFigure
	GdiplusLibrary default gdipStartPathFigure: self asParameter! !

!GdiplusGraphicsPath categoriesForMethods!
addArc:angles:!operations!public! !
addClosedCurve:!operations!public! !
addCurve:!operations!public! !
addEllipse:!operations!public! !
addLineFrom:to:!operations!public! !
addLines:!operations!public! !
addPolygon:!operations!public! !
addRectangle:!operations!public! !
basicFree!private!realizing/unrealizing! !
bounds!accessing!public! !
bounds:withPen:!enquiries!public! !
boundsWithPen:!enquiries!public! !
closeFigure!operations!public! !
fillMode!accessing!public! !
fillMode:!accessing!public! !
pointCount!accessing!public! !
startFigure!operations!public! !
!

!GdiplusGraphicsPath class methodsFor!

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

!GdiplusGraphicsPath class categoriesForMethods!
fillMode:!instance creation!public! !
new!instance creation!public! !
points:types:fillMode:!instance creation!public! !
!

