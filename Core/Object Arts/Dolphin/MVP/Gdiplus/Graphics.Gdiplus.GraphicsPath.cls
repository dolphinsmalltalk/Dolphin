"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.GraphicsPath'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GraphicsPath guid: (Core.GUID fromString: '{1a1a5ea0-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.GraphicsPath comment: 'GdiplusGraphicsPath stores a sequence of lines, curves, and shapes.  The entire sequence can be drawn by calling the drawPath method of a GdiplusGraphics object.  You can partition the sequence of lines, curves, and shapes into figures, and with the help of a GdiplusGraphicsPathIterator object, selected figures can be drawn.  Selected portions of the path can also be drawn by placing markers in the sequence.

'!
!Graphics.Gdiplus.GraphicsPath methodsFor!

_clipGpGraphics: aGpGraphics mode: anInteger
	aGpGraphics clipRegion: (Region fromPath: self) combineMode: anInteger!

_combineGpRegion: aGdiplusRegion mode: aCombineModeConstants
	^aGdiplusRegion combinePath: self mode: aCombineModeConstants!

addArc: aRectangle angles: aPoint
	"Add an arc to the receiver whose bounds are aRectangle and whose start and sweep 
	angles are specified by aPoint."

	Gdip
		gdipAddPathArcI: self handle
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: aPoint x
		sweepAngle: aPoint y.
	initializer := nil!

addClosedCurve: aPointsCollection
	Gdip
		gdipAddPathClosedCurveI: self handle
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size.
	initializer := nil!

addCurve: aPointsCollection
	Gdip
		gdipAddPathCurveI: self handle
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size.
	initializer := nil!

addCurve: aPointsCollection tension: aNumber
	Gdip
		gdipAddPathCurve2I: self handle
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size
		tension: aNumber.
	initializer := nil!

addEllipse: aRectangle
	"Add an ellipse to the receiver whose bounds are aRectangle."

	Gdip
		gdipAddPathEllipseI: self handle
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height.
	initializer := nil!

addLineFrom: startPoint to: endPoint
	Gdip
		gdipAddPathLineI: self handle
		x1: startPoint x
		y1: startPoint y
		x2: endPoint x
		y2: endPoint y.
	initializer := nil!

addLines: aSequenceOfPoints
	Gdip
		gdipAddPathLine2I: self handle
		points: (POINTLArray marshal: aSequenceOfPoints)
		count: aSequenceOfPoints size.
	initializer := nil!

addPie: aRectangle startAngle: startNumber sweepAngle: sweepNumber
	Gdip
		gdipAddPathPieI: self handle
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: startNumber
		sweepAngle: sweepNumber.
	initializer := nil!

addPolygon: aPointsCollection
	Gdip
		gdipAddPathPolygonI: self handle
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size.
	initializer := nil!

addRectangle: aRectangle
	Gdip
		gdipAddPathRectangleI: self handle
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height.
	initializer := nil!

addString: aString font: aFont rectangle: aRectangle format: aStringFormat
	Gdip
		gdipAddPathStringI: self handle
		string: aString
		length: aString size
		family: aFont family handle
		style: aFont style
		emSize: aFont emSize
		layoutRect: (RECTL marshal: aRectangle)
		format: aStringFormat asParameter.
	initializer := nil!

bounds
	"Answer a bounding Rectangle for the receiver."

	^self bounds: nil withPen: nil!

bounds: aGdiplusMatrix withPen: aGdiplusPen
	"Answer a bounding Rectangle for the receiver as if drawn with the transformation specified by the <Matrix> 1st argument, using the <Pen> 2nd argument."

	| rect |
	rect := Rect newBuffer.
	Gdip
		gdipGetPathWorldBoundsI: self handle
		bounds: rect
		matrix: aGdiplusMatrix asParameter
		pen: aGdiplusPen asParameter.
	^rect asRectangle!

boundsWithPen: aGdiplusPen
	^self bounds: nil withPen: aGdiplusPen!

clearMarkers
	Gdip gdipClearPathMarkers: self handle.
	initializer := nil!

closeAllFigures
	"Make all sub-paths in the path into closed polygons."

	Gdip gdipClosePathFigures: self handle.
	initializer := nil!

closeFigure
	"Make the sub-path being added into a closed polygon."

	"Closing the figure will not add any extra point, but it changes the type of the last point to include the PathPointTypeCloseSubpath flag"

	Gdip gdipClosePathFigure: self handle.
	initializer := nil!

containsFillPoint: aPoint graphics: aGdiplusGraphics
	| result |
	result := UInt32Bytes new.
	Gdip
		gdipIsVisiblePathPointI: self handle
		x: aPoint x
		y: aPoint y
		graphics: aGdiplusGraphics asParameter
		result: result.
	^result asBoolean!

containsPoint: aPoint
	^self containsPoint: aPoint graphics: nil!

containsPoint: aPoint graphics: aGdiplusGraphics
	| result |
	result := UInt32Bytes new.
	Gdip
		gdipIsVisiblePathPointI: self handle
		x: aPoint x
		y: aPoint y
		graphics: aGdiplusGraphics asParameter
		result: result.
	^result asBoolean!

fillMode
	"Answer the receiver's fillMode, a FillMode constant."

	^self initializer fillMode!

fillMode: aFillModeConstant
	"Set the receiver's fillMode to aFillModeConstant."

	self initializer fillModeOf: self set: aFillModeConstant!

fillsPoint: aPoint graphics: aGdiplusGraphics
	| result |
	result := UInt32Bytes new.
	Gdip
		gdipIsVisiblePathPointI: self handle
		x: aPoint x
		y: aPoint y
		graphics: aGdiplusGraphics asParameter
		result: result.
	^result asBoolean!

flatten: aMatrix
	self flatten: aMatrix flatness: FlatnessDefault!

flatten: aMatrix flatness: aNumber
	"Transform the path, flattening curves into a sequence of connected lines."

	Gdip
		gdipFlattenPath: self handle
		matrix: aMatrix asParameter
		flatness: aNumber.
	initializer := nil!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^GraphicsPathInitializer!

mark
	"Mark the last point (i.e. include the PathPointTypeMarker flag in its type)."

	Gdip gdipSetPathMarker: self handle.
	initializer := nil!

markLast
	"Mark the last point (i.e. include the PathPointTypeMarker flag in its type)."

	Gdip gdipSetPathMarker: self handle.
	initializer := nil!

outline: aMatrix
	self outline: aMatrix flatness: FlatnessDefault!

outline: aMatrix flatness: aNumber
	Gdip
		gdipWindingModeOutline: self handle
		matrix: aMatrix asParameter
		flatness: aNumber.
	initializer := nil!

pointCount
	"Answer the number of points in the receiver."

	^self points size!

points
	"Answer an <Array> of the <Point>s in the path."

	^self initializer pathPoints!

reset
	Gdip gdipResetPath: self handle.
	initializer := nil!

reverse
	Gdip gdipReversePath: self handle.
	initializer := nil!

rotate: aNumber
	"Rotate the points of the receiver by the <Number> angle in degrees argument."

	self transform: (Matrix identity
				rotate: aNumber;
				yourself)!

scale: aPoint
	"Scale the points in the receiver by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self transform: (Matrix identity
				scale: aPoint;
				yourself)!

shear: aPoint
	"Apply a shearing transformation to the receiver's points of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self transform: (Matrix identity
				shear: aPoint;
				yourself)!

startFigure
	Gdip gdipStartPathFigure: self handle!

touchesPoint: aPoint
	^self
		touchesPoint: aPoint
		pen: Pen new
		graphics: nil!

touchesPoint: aPoint pen: aPen
	^self
		touchesPoint: aPoint
		pen: aPen
		graphics: nil!

touchesPoint: aPoint pen: aPen graphics: aGdiplusGraphics
	| result |
	result := UInt32Bytes new.
	Gdip
		gdipIsOutlineVisiblePathPointI: self handle
		x: aPoint x
		y: aPoint y
		pen: aPen asParameter
		graphics: aGdiplusGraphics asParameter
		result: result.
	^result asBoolean!

transform: aMatrix
	"Apply a transformation to the receiver's points."

	"Note that the transformation permanently changes the points in the path:
		- The transformation cannot be reset (although it could be reversed, the accuracy of which will depend on rounding error);
		- The effect of a series of transformation is as if the MatrixOrderAppend were specified each time."

	Gdip gdipTransformPath: self handle matrix: aMatrix asParameter.
	"The points will have changed."
	initializer := nil!

translate: aPoint
	"Translate the receiver's points by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> argument."

	self transform: (Matrix identity translate: aPoint)!

types
	"Answer an <ByteArray>, the elements of which are the PathPointType's of each point in the path."

	^self initializer pathTypes!

widen: aMatrix
	"Transform the path into a series of curves that would enclose the original path when drawn with a default 1-pixel wide <Pen>, applying an optional transformation and flattening."

	self
		widen: aMatrix
		pen: Pen new
		flatness: FlatnessDefault!

widen: aMatrix pen: aPen
	"Transform the path into a series of curves that would enclose the original path when drawn with the specified <Pen>, applying an optional transformation and default flattening."

	self
		widen: aMatrix
		pen: aPen
		flatness: FlatnessDefault!

widen: aMatrix pen: aPen flatness: aNumber
	"Transform the path into a series of curves that would enclose the original path when drawn with the specified <Pen>, applying an optional transformation and flattening."

	"Note that this may not do what you expect. It does not enclose the fill path, but supposedly the path as it would be drawn by the Pen. It can have some pretty weird effects, especially with the default, centred, alignment mode of pens. It seems more predictable with inset pens, but you may need to experiment."

	Gdip
		gdipWidenPath: self handle
		pen: aPen asParameter
		matrix: aMatrix asParameter
		flatness: aNumber.
	initializer := nil! !
!Graphics.Gdiplus.GraphicsPath categoriesForMethods!
_clipGpGraphics:mode:!double dispatch!private! !
_combineGpRegion:mode:!double dispatch!private! !
addArc:angles:!adding!public! !
addClosedCurve:!adding!public! !
addCurve:!adding!public! !
addCurve:tension:!adding!public! !
addEllipse:!adding!public! !
addLineFrom:to:!adding!public! !
addLines:!adding!public! !
addPie:startAngle:sweepAngle:!adding!public! !
addPolygon:!adding!public! !
addRectangle:!adding!public! !
addString:font:rectangle:format:!adding!public! !
bounds!enquiries!public! !
bounds:withPen:!enquiries!public! !
boundsWithPen:!enquiries!public! !
clearMarkers!marking!public! !
closeAllFigures!adding!public! !
closeFigure!adding!public! !
containsFillPoint:graphics:!enquiries!public! !
containsPoint:!enquiries!public! !
containsPoint:graphics:!enquiries!public! !
fillMode!accessing!public! !
fillMode:!accessing!public! !
fillsPoint:graphics:!enquiries!public! !
flatten:!public!transformations! !
flatten:flatness:!public!transformations! !
initializerClass!constants!private! !
mark!marking!public! !
markLast!marking!public! !
outline:!public!transformations! !
outline:flatness:!public!transformations! !
pointCount!accessing!public! !
points!accessing!public! !
reset!public!transformations! !
reverse!public!transformations! !
rotate:!public!transformations! !
scale:!public!transformations! !
shear:!public!transformations! !
startFigure!adding!public! !
touchesPoint:!enquiries!public! !
touchesPoint:pen:!enquiries!public! !
touchesPoint:pen:graphics:!enquiries!public! !
transform:!public!transformations! !
translate:!public!transformations! !
types!accessing!public! !
widen:!public!transformations! !
widen:pen:!public!transformations! !
widen:pen:flatness:!public!transformations! !
!

!Graphics.Gdiplus.GraphicsPath class methodsFor!

ellipse: aRectangle
	^self new
		addEllipse: aRectangle;
		yourself!

fillMode: aFillModeConstant
	"Answer a new instance of the receiver with specified FillMode constants.
	NB:  An instance created with this method is expected to have objects added to it (e.g., #addEllipse:).
	An instance with no added figures (or pointCount < 2) will raise an error in many cases when 
	messages are sent to it.  Related to this is that an instance created with this method is not persistent
	since the initializer does not hold any information on the added figures but will recreate an instance
	with no points."

	^self fromInitializer: (GraphicsPathInitializer
				points: #()
				types: #[]
				fillMode: aFillModeConstant)!

fromRectangle: aRectangle
	^self points: aRectangle vertices
		types: ##({PathPointTypeStart.
				PathPointTypeLine.
				PathPointTypeLine.
				PathPointTypeLine | PathPointTypeCloseSubpath} asByteArray)!

lines: aCollectionOfPoints
	| count |
	count := aCollectionOfPoints size.
	count < 1 ifTrue: [^self new].
	^self points: aCollectionOfPoints
		types: ((ByteArray new: count withAll: 1)
				at: 1 put: 0;
				yourself)!

new
	"Answer a new instance of the receiver with default fillMode.  NB: See #fillMode: for usage notes."

	^self fillMode: FillModeAlternate!

points: anArrayOfPoints types: anArrayOfPathPointTypeIntegers
	"Answer a new instance of the receiver with attributes specified by points, types, and aFillModeConstant."

	^self
		points: anArrayOfPoints
		types: anArrayOfPathPointTypeIntegers
		fillMode: FillModeAlternate!

points: aSequenceOfPoints types: aSequenceOfPathPointTypeConstants fillMode: aFillModeConstant
	"Answer a new instance of the receiver with attributes specified by points, types, and aFillModeConstant."

	^self fromInitializer: (GraphicsPathInitializer
				points: aSequenceOfPoints
				types: aSequenceOfPathPointTypeConstants
				fillMode: aFillModeConstant)!

polygon: anArrayOfPoints
	"Answer a new instance of the receiver representing the polygon described by the closed path of straight lines between the <Point>s in the argument."

	| count |
	count := anArrayOfPoints size.
	count < 3 ifTrue: [self error: 'A polygon must have a least 3 vertices'].
	^self points: anArrayOfPoints
		types: ((ByteArray new: count withAll: PathPointTypeLine)
				at: 1 put: PathPointTypeStart;
				at: count put: ##(PathPointTypeLine | PathPointTypeCloseSubpath);
				yourself)! !
!Graphics.Gdiplus.GraphicsPath class categoriesForMethods!
ellipse:!instance creation!public! !
fillMode:!instance creation!public! !
fromRectangle:!instance creation!public! !
lines:!instance creation!public! !
new!instance creation!public! !
points:types:!instance creation!public! !
points:types:fillMode:!instance creation!public! !
polygon:!instance creation!public! !
!

