"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.GdiplusGraphics'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'UnitNames'
				-> #('UnitWorld' 'UnitDisplay' 'UnitPixel' 'UnitPoint' 'UnitInch' 'UnitDocument' 'UnitMillimeter')
		}!

Graphics.Gdiplus.GdiplusGraphics guid: (Core.GUID fromString: '{76d4e292-3cd0-44ac-af53-a4209708faa5}')!

Graphics.Gdiplus.GdiplusGraphics comment: 'GdiplusGraphics class provides methods for drawing lines, curves, figures, images, and text. An instance stores attributes of the display device and attributes of the items to be drawn.

'!

!Graphics.Gdiplus.GdiplusGraphics methodsFor!

beginContainer
	"Answer an <Integer> value that identifies the container."

	| state |
	state := UInt32Bytes new.
	Gdip gdipBeginContainer2: self asParameter state: state asParameter.
	^state asInteger!

clear
	"Clear the receiver, i.e., erase everything on it."

	self clear: nil!

clear: aColor
	"Clear the receiver and (flood) fill it with the specified color."

	Gdip gdipGraphicsClear: self handle color: (aColor ifNotNil: [aColor argbCode])!

clip: aGraphicsObject
	"Set the clipping region of the receiver to a region that is the combination of itself and the area of the argument."

	self clip: aGraphicsObject combineMode: CombineModeReplace!

clip: aGraphicsObject combineMode: anInteger
	"Set the clipping region of the receiver to a region that is the combination of itself and the area of the argument."

	aGraphicsObject _clipGpGraphics: self mode: anInteger!

clipRectangle: aRectangle combineMode: aCombineModeConstant
	"Set the clipping region of the receiver to a region that is the combination of itself and 
	aRectangle, using  aCombineModeConstant to specify how the two regions are combined."

	Gdip
		gdipSetClipRectI: self handle
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		combineMode: aCombineModeConstant!

clipRegion: aGdiplusRegion combineMode: aCombineModeConstant
	"Set the clipping region of the receiver to a region that is the combination of itself and the region
	specified by aGdiplusRegion, using  aCombineModeConstant to specify how the two regions are combined."

	Gdip
		gdipSetClipRegion: self handle
		region: aGdiplusRegion asParameter
		combineMode: aCombineModeConstant!

compositingMode
	"Answer an Integer that represents how rendered colors are combined with background colors."

	| compositingMode |
	compositingMode := UInt32Bytes new.
	Gdip gdipGetCompositingMode: self handle compositingMode: compositingMode asParameter.
	^compositingMode asSignedInteger!

compositingMode: aCompositingModeConstant
	"Set the receiver's compositing mode (how rendered colors are combined with background colors.)."

	Gdip gdipSetCompositingMode: self handle compositingMode: aCompositingModeConstant!

compositingQuality
	"Answer an Integer that represents whether gamma correction is applied when colors 
	are blended with background colors"

	| compositingQuality |
	compositingQuality := UInt32Bytes new.
	Gdip gdipGetCompositingQuality: self handle compositingQuality: compositingQuality asParameter.
	^compositingQuality asSignedInteger!

compositingQuality: aCompositingQualityConstant
	"Set the receiver's compositingQuality (whether gamma correction is applied when 
	colors are blended with background colors)"

	Gdip gdipSetCompositingQuality: self handle compositingQuality: aCompositingQualityConstant!

doWithCanvas: anOperation
	| hdc |
	hdc := self getHDC.
	^[anOperation value: (Canvas withNonOwnedDC: hdc)]
		ensure: [hdc notNil ifTrue: [self releaseHDC: hdc]]!

doWithDC: anOperation
	"MSDN: 
Each call to the GetHDC method of a Graphics object should be paired with a call to the ReleaseHDC method of that same Graphics object. Do not call any methods of the Graphics object between the calls to GetHDC and ReleaseHDC. If you attempt to call a method of the Graphics object between GetHDC and ReleaseHDC, the method will fail and will return ObjectBusy. 
Any state changes you make to the device context between GetHDC and ReleaseHDC will be ignored by GDI+ and will not be reflected in rendering done by GDI+."

	| hdc |
	hdc := self getHDC.
	[anOperation value: hdc] ensure: [self releaseHDC: hdc]!

dpi
	"Answer the dots per inch of the display device associated with the receiver. It is assumed that the horizontal and vertical dpi are the same, which will be the case for any display device."

	| dpiY |
	dpiY := ByteArray newFixed: 4.
	Gdip gdipGetDpiY: self asParameter dpi: dpiY.
	^(dpiY floatAtOffset: 0) asInteger!

drawArc: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle
	"Draw an arc on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	Gdip
		gdipDrawArcI: self handle
		pen: aGdiplusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: startAngle
		sweepAngle: sweepAngle!

drawBezier: aPointsCollection pen: aGdiplusPen
	"Draw a Bezier curve on the receiver, specified by four points using aGdiplusPen."

	Gdip
		gdipDrawBezierI: self handle
		pen: aGdiplusPen asParameter
		x1: aPointsCollection first x
		y1: aPointsCollection first y
		x2: aPointsCollection second x
		y2: aPointsCollection second y
		x3: aPointsCollection third x
		y3: aPointsCollection third y
		x4: aPointsCollection fourth x
		y4: aPointsCollection fourth y!

drawCachedBitmap: aCachedBitmap at: aPoint
	Gdip
		gdipDrawCachedBitmap: self handle
		cachedBitmap: aCachedBitmap handle
		x: aPoint x
		y: aPoint y!

drawClosedCurve: aPointsCollection pen: aGdiplusPen tension: aReal
	"Draw a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	Gdip
		gdipDrawClosedCurve2I: self handle
		pen: aGdiplusPen asParameter
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size
		tension: aReal!

drawCurve: aPointsCollection pen: aGdiplusPen
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."

	Gdip
		gdipDrawCurveI: self handle
		pen: aGdiplusPen asParameter
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size!

drawCurve: aPointsCollection pen: aGdiplusPen tension: aReal
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	Gdip
		gdipDrawCurve2I: self handle
		pen: aGdiplusPen asParameter
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size
		tension: aReal!

drawDropShadowRectangle: rect offset: offset alpha: alpha
	| shadowRect shadow |
	shadowRect := rect topLeft // offset extent: rect extent // offset.
	shadow := Bitmap extent: shadowRect extent.
	shadow graphics fillRectangle: shadowRect
		brush: (Brush color: (Color
						a: alpha
						r: 0
						g: 0
						b: 0)).
	self
		interpolationMode: InterpolationModeHighQualityBicubic;
		drawImage: shadow
			at: offset
			extent: rect extent
			from: 0 @ 0
			extent: shadowRect extent!

drawEllipse: aRectangle pen: aPen
	"Draw an ellipse on the receiver, within aRectangle's bounds, using aPen."

	Gdip
		gdipDrawEllipseI: self handle
		pen: aPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

drawImage: aGdiplusImage
	"Draw all of aGdiplusImage on the receiver, at the receiver's origin."

	Gdip
		gdipDrawImageI: self asParameter
		image: aGdiplusImage asParameter
		x: 0
		y: 0!

drawImage: aGdiplusImage at: aPoint
	"Draw all of aGdiplusImage on the receiver, at aPoint."

	Gdip
		gdipDrawImage: self asParameter
		image: aGdiplusImage asParameter
		x: aPoint x
		y: aPoint y!

drawImage: aGdiplusImage at: aPoint attributes: imageAttributes
	"Draw the <Gdiplus.Image> 1st argument at its full extent at the origin, aPoint, with <ImageAttributes> specified by the 3rd argument."

	| extent |
	extent := aGdiplusImage extent.
	self
		drawImage: aGdiplusImage
		at: aPoint
		extent: extent
		from: Point.Zero
		extent: extent
		unit: UnitPixel
		attributes: imageAttributes!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent
	"Draw all of aGdiplusImage on the receiver, sized to fit the specified rectangle."

	Gdip
		gdipDrawImageRect: self handle
		image: aGdiplusImage asParameter
		x: dstOrigin x
		y: dstOrigin y
		width: dstExtent x
		height: dstExtent y!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent attributes: imageAttributes
	self
		drawImage: aGdiplusImage
		at: dstOrigin
		extent: dstExtent
		from: Point.Zero
		extent: aGdiplusImage extent
		unit: UnitPixel
		attributes: imageAttributes!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent
	"Draw the portion of the aGdiplusImage specified by a source rectangle to a portion of the
	receiver specified by a destination rectangle.  The source image is scaled to fit the receiver."

	self 
		drawImage: aGdiplusImage
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: UnitPixel
		attributes: nil!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aSrcUnit attributes: imageAttributes
	"Draw the portion of aGdiplusImage specified by srcOrigin and srcExtent to the receiver at the
	rectangle specified by dstOrigin and dstExtent. The image is stretched to fit the destination rectangle.
	srcUnit is the unit of measure for the source rectangle. imageAttributes specifies color adjustments."

	Gdip
		gdipDrawImageRectRectI: self handle
		image: aGdiplusImage asParameter
		dstx: dstOrigin x
		dsty: dstOrigin y
		dstwidth: dstExtent x
		dstheight: dstExtent y
		srcx: srcOrigin x
		srcy: srcOrigin y
		srcwidth: srcExtent x
		srcheight: srcExtent y
		srcUnit: aSrcUnit ?? UnitPixel
		imageAttributes: imageAttributes asParameter
		callback: nil
		callbackData: nil!

drawImage: aGdiplusImage attributes: imageAttributes
	"Draw the <Gdiplus.Image> 1st argument at its full extent at the receiver's origin with <ImageAttributes> specified by the 2nd argument."

	imageAttributes
		ifNil: 
			[Gdip
				gdipDrawImageI: self handle
				image: aGdiplusImage asParameter
				x: 0
				y: 0]
		ifNotNil: 
			[| extent |
			extent := aGdiplusImage extent.
			Gdip
				gdipDrawImageRectRectI: self handle
				image: aGdiplusImage asParameter
				dstx: 0
				dsty: 0
				dstwidth: extent x
				dstheight: extent y
				srcx: 0
				srcy: 0
				srcwidth: extent x
				srcheight: extent y
				srcUnit: UnitPixel
				imageAttributes: imageAttributes asParameter
				callback: nil
				callbackData: nil]!

drawImage: anImage points: threePoints
	"Draw anImage on the receiver stretched to fit the parallelogram specified by threePoints."

	self assert: [threePoints size = 3].
	Gdip
		gdipDrawImagePointsI: self handle
		image: anImage asParameter
		dstpoints: (POINTLArray marshal: threePoints)
		count: threePoints size!

drawImage: aGdiplusImage rectangle: aRectangle
	"Draw all of aGdiplusImage on the receiver, sized to fit aRectangle."

	self 
		drawImage: aGdiplusImage
		at: aRectangle origin
		extent: aRectangle extent!

drawLine: aRectangle pen: aPen
	"Draw a line on the receiver connecting the origin and corner of aRectange using aPen."

	self 
		drawLineFrom: aRectangle origin
		to: aRectangle corner
		pen: aPen!

drawLineFrom: fromPoint to: toPoint pen: aGdiplusPen
	"Draw a line that connects two points using aGdiplusPen."

	Gdip
		gdipDrawLine: self handle
		pen: aGdiplusPen asParameter
		x1: fromPoint x
		y1: fromPoint y
		x2: toPoint x
		y2: toPoint y!

drawPath: aPath
	self drawPath: aPath pen: Pen black!

drawPath: aPath pen: aPen
	"Draw aPath on the receiver using aPen."

	Gdip
		gdipDrawPath: self handle
		pen: aPen asParameter
		path: aPath asParameter!

drawPie: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle
	"Draw a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	Gdip
		gdipDrawPieI: self handle
		pen: aGdiplusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: startAngle
		sweepAngle: sweepAngle!

drawPolygon: aPointsCollection pen: aPen
	"Draw a polygon on the receiver using aPen."

	Gdip
		gdipDrawPolygonI: self handle
		pen: aPen asParameter
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size!

drawRectangle: aRectangle
	"Draw aRectangle on the receiver."

	| pen |
	pen := Pen new.
	self drawRectangle: aRectangle pen: pen.
	pen free!

drawRectangle: aRectangle pen: aPen
	"Draw a Rectangle on the receiver using aPen."

	Gdip
		gdipDrawRectangleI: self handle
		pen: aPen asParameter
		x: aRectangle left asInteger
		y: aRectangle top asInteger
		width: aRectangle width asInteger
		height: aRectangle height asInteger!

drawString: aString at: aPoint
	"Draw aString on the receiver at aPoint."

	self
		drawString: aString
		font: nil
		rect: (RectF origin: aPoint)
		format: nil
		brush: nil!

drawString: aString font: aFont at: aPoint
	"Draw aString on the receiver at aPoint using aFont and aBrush."

	self
		drawString: aString
		font: aFont
		rect: (RectF origin: aPoint)
		format: nil
		brush: nil!

drawString: aString font: aFont at: aPoint brush: aBrush
	"Draw aString on the receiver at aPoint using aFont and aBrush."

	self
		drawString: aString
		font: aFont
		rect: (RectF origin: aPoint)
		format: nil
		brush: aBrush!

drawString: aString font: aFont at: aPoint format: aStringFormat brush: aBrush
	"Draw aString on the receiver at aPoint using aFont, aStringFormat, and aBrush."

	self
		drawString: aString
		font: aFont
		rect: (RectF origin: aPoint)
		format: aStringFormat
		brush: aBrush!

drawString: aString font: aFont rect: aRectangle format: aStringFormat brush: aBrush
	"Draw aString on the receiver inside aRectangle, using font attributes (family name, size,
	and style) specified by aFont, text format information (layout and display manipulations)
	specified by aStringFormat, and aBrush to fill the string."

	| font brush text |
	font := aFont ifNil: [Font genericSansSerif].
	brush := aBrush ifNil: [Brush black].
	"Note that we must convert to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	Gdip
		gdipDrawString: self handle
		str: text
		length: text size
		font: font asParameter
		layoutRect: (RectF marshal: aRectangle)
		stringFormat: aStringFormat asParameter
		brush: brush asParameter!

drawString: aString layoutRect: aRectangle
	"Draw aString on the receiver within aRectangle."

	self 
		drawString: aString
		font: nil
		rect: aRectangle
		format: nil
		brush: nil!

endContainer: containerInteger
	"Close a graphics container specified by containerInteger."

	Gdip gdipEndContainer: self handle state: containerInteger!

erase
	"Clear the receiver to white."

	Gdip gdipGraphicsClear: self asParameter color: -1!

excludeClip: aGdiplusObject
	"Exclude the specified <Rectangle> from the receiver's clip region, this means that any attempt to draw in that rectangle will be ignored."

	self clip: aGdiplusObject combineMode: CombineModeExclude!

excludeClipRectangle: aRectangle
	"Exclude the specified <Rectangle> from the receiver's clip region, this means that any attempt to draw in that rectangle will be ignored."

	self clipRectangle: aRectangle combineMode: CombineModeExclude!

fillClosedCurve: aPointsCollection brush: aGdiplusBrush
	"Fills a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."

	Gdip
		gdipFillClosedCurveI: self handle
		brush: aGdiplusBrush asParameter
		points: (POINTLArray marshal: aPointsCollection)
		count: aPointsCollection size!

fillEllipse: aRectangle brush: aGdiplusBrush
	"Fill the interior of an ellipse that is bounded by aRectangle on the receiver using aGdiplusBrush."

	Gdip
		gdipFillEllipseI: self handle
		brush: aGdiplusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

fillPath: aPath brush: aBrush
	"Fill aPath on the receiver using a Brush."

	Gdip
		gdipFillPath: self handle
		brush: aBrush asParameter
		path: aPath asParameter!

fillPie: aRectangle brush: aGdiplusBrush startAngle: startAngle sweepAngle: sweepAngle
	"Fill a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusBrush."

	Gdip
		gdipFillPieI: self handle
		brush: aGdiplusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: startAngle
		sweepAngle: sweepAngle!

fillPolygon: collectionOfPoints brush: aBrush
	"Fill the interior of a polygon on the receiver with aBrush."

	self 
		fillPolygon: collectionOfPoints
		brush: aBrush
		fillMode: nil!

fillPolygon: collectionOfPoints brush: aBrush fillMode: aFillModeConstant
	"Fill the interior of a polygon on the receiver with aBrush.  aFillMode specifies how to fill a closed area
	that is within another closed area and that is created when the curve or path passes over itself."

	Gdip
		gdipFillPolygonI: self handle
		brush: aBrush asParameter
		points: (POINTLArray marshal: collectionOfPoints)
		count: collectionOfPoints size
		fillMode: aFillModeConstant!

fillRectangle: aRectangle brush: aGdiplusBrush
	"Fill aRectangle on the receiver using a aGdiplusBrush."

	Gdip
		gdipFillRectangle: self handle
		brush: aGdiplusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

fillRectangle: aRectangle color: aColor
	| fillBrush |
	fillBrush := SolidBrush color: aColor.
	self fillRectangle: aRectangle brush: fillBrush.
	fillBrush free!

fillRegion: aRegion brush: aBrush
	"Fill aRegion on the receiver using aBrush."

	Gdip
		gdipFillRegion: self handle
		brush: aBrush asParameter
		region: aRegion asParameter!

fillRegion: aRegion color: aColor
	| fillBrush |
	fillBrush := Brush color: aColor.
	self fillRegion: aRegion brush: fillBrush.
	fillBrush free!

getHDC
	"
	HDC GetHDC()
	    {
	        HDC     hdc = NULL;
	
	        SetStatus(DllExports::GdipGetDC(nativeGraphics, &hdc));
	
	        return hdc;
	    }"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetDC: self handle hdc: gpHandle.
	^gpHandle!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^GraphicsInitializer!

interpolationMode
	"Answer an Integer that represents the receiver's interpolation mode (the algorithm 
	that is used when images are scaled or rotated)."

	| interpolationMode |
	interpolationMode := UInt32Bytes new.
	Gdip gdipGetInterpolationMode: self handle interpolationMode: interpolationMode asParameter.
	^interpolationMode asSignedInteger!

interpolationMode: anInterpolationModeConstant
	"Set the receiver's interpolation mode (the algorithm that is used when images are scaled or rotated)."

	Gdip gdipSetInterpolationMode: self handle interpolationMode: anInterpolationModeConstant!

intersectClip: aGraphicsObject
	"Create a new clipping region for the receiver from the intersection of the current clipping region and the area of the argument."

	self clip: aGraphicsObject combineMode: CombineModeIntersect!

intersectClipRectangle: aRectangle
	"Create a new clipping region for the receiver from the intersection of the current clipping region and aRectangle."

	self clipRectangle: aRectangle combineMode: CombineModeIntersect!

measureCharacterRanges: aString font: aFont rect: aRectangle format: aStringFormat
	| count regions handles utf16 |
	count := aStringFormat characterRanges size.
	regions := Array new: count.
	handles := HandleArray new: count.
	1 to: count
		do: 
			[:i |
			| region |
			region := Region new.
			regions at: i put: region.
			handles at: i put: region asParameter].
	utf16 := aString asUtf16String.
	Gdip
		gdipMeasureCharacterRanges: self handle
		str: utf16
		length: utf16 size
		font: aFont asParameter
		layoutRect: (RectF marshal: aRectangle)
		stringFormat: aStringFormat asParameter
		regionCount: count
		regions: handles.
	^regions!

measureString: aString font: aFont
	"Answer a Point that is the extent of aString as specified by aFont."

	^(self
		measureString: aString
		font: aFont
		rect: RectF new
		format: nil) extent!

measureString: aString font: aFont rect: aRectangle format: aStringFormat
	"Answer a Rectangle that is the bounds of aString inside aRectangle as specified by aFont and aStringFormat."

	| boundRect text |
	boundRect := RectF new.
	"Note that we must conver to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	Gdip
		gdipMeasureString: self handle
		str: text
		length: text size
		font: aFont asParameter
		layoutRect: (RectF marshal: aRectangle)
		stringFormat: aStringFormat asParameter
		boundingBox: boundRect
		codepointsFitted: nil
		linesFilled: nil.
	^boundRect!

pageScale
	"Answer the scaling factor currently set for the page transformation of the receiver."

	| scale |
	scale := ByteArray newFixed: 4.
	Gdip gdipGetPageScale: self handle scale: scale.
	^scale floatAtOffset: 0!

pageScale: aRealNumber
	"Set the scaling factor for the page transformation of the receiver to aRealNumber.
	The page transformation converts page coordinates to device coordinates."

	Gdip gdipSetPageScale: self handle scale: aRealNumber!

pageUnit
	"Answer the unit of measure currently set for the receiver."

	| unit |
	unit := UInt32Bytes new.
	Gdip gdipGetPageUnit: self handle unit: unit.
	^unit asSignedInteger!

pageUnit: aUnitConstant
	"Set the receiver's unit of measure."

	Gdip gdipSetPageUnit: self handle unit: aUnitConstant!

pageUnitName
	"Answer the receiver's page unit as a string."

	^UnitNames at: self pageUnit + 1!

pixelOffsetMode
	| pixelOffsetMode |
	pixelOffsetMode := UInt32Bytes new.
	Gdip gdipGetPixelOffsetMode: self handle pixelOffsetMode: pixelOffsetMode.
	^pixelOffsetMode asSignedInteger!

pixelOffsetMode: aPixelOffsetModeConstant
	"Set the type of pixel offsetting that is applied to lines and curves."

	Gdip gdipSetPixelOffsetMode: self handle pixelOffsetMode: aPixelOffsetModeConstant!

releaseHDC: anExternalHandle
	" 
	VOID ReleaseHDC(IN HDC hdc)
	    {
	        SetStatus(DllExports::GdipReleaseDC(nativeGraphics, hdc));
	    }"

	Gdip gdipReleaseDC: self handle hdc: anExternalHandle!

resetClip
	"Set the clipping region of the receiver to an infinite region."

	Gdip gdipResetClip: self handle!

resetTransform
	"Reset the receiver's world transform to the identity matrix (i.e. no transformation)."

	Gdip gdipResetWorldTransform: self handle!

resolution
	"Answer the resolution, in dots per inch, of the display device associated with the receiver."

	| buf dpiX |
	buf := ByteArray newFixed: 4.
	Gdip gdipGetDpiX: self handle dpi: buf.
	dpiX := buf floatAtOffset: 0.
	Gdip gdipGetDpiY: handle dpi: buf.
	^dpiX asInteger @ (buf floatAtOffset: 0) asInteger!

rotate: aNumber
	"Prepend a rotation of the receiver's world transform by the <Number> angle in degrees argument."

	self rotate: aNumber order: MatrixOrderPrepend!

rotate: aNumber at: aPoint
	"Rotate the reciever's world transform by the angle in degrees specified by the <Number> first argument, around the origin specified by the <Point> second argument."

	self
		translate: aPoint;
		rotate: aNumber!

rotate: aNumber order: aMatrixOrderConstant
	"Rotate the receiver's world transform by the <Number> angle in degrees 1st argument, with the order of transformation specified by MatrixOrder <integer> 2nd argument."

	Gdip
		gdipRotateWorldTransform: self handle
		angle: aNumber asFloat
		order: aMatrixOrderConstant!

rotateTransform: aRealAngle
	#deprecated.
	self rotate: aRealAngle!

rotateTransform: aNumber order: aMatrixOrderConstant
	#deprecated.
	self rotate: aNumber order: aMatrixOrderConstant!

scale: aPoint
	"Prepend a scaling transformation to the receiver's world transform of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self scale: aPoint order: MatrixOrderPrepend!

scale: aPoint order: aMatrixOrderConstant
	"Scale the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	Gdip
		gdipScaleWorldTransform: self handle
		sx: aPoint x asFloat
		sy: aPoint y asFloat
		order: aMatrixOrderConstant!

scaleTransform: aPoint
	#deprecated.
	self scale: aPoint!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	#deprecated.
	self scale: aRealPoint order: aMatrixOrderConstant!

shear: aPoint
	"Prepend a shearing transformation to the receiver of the horizontal and vertical factors that are the x and y co-ordinates of the <Point> argument."

	self shear: aPoint order: MatrixOrderPrepend!

shear: aPoint order: aMatrixOrderConstant
	"Shear the receiver's world transform by the horizontal and vertical factors that are the x and y co-ordinates of the <Point> 1st argument, in the order specified by the <integer> MatrixOrder 2nd argument."

	self transform: (self transform shear: aPoint order: aMatrixOrderConstant)!

smoothingMode
	| smoothingMode |
	smoothingMode := UInt32Bytes new.
	Gdip gdipGetSmoothingMode: self handle smoothingMode: smoothingMode.
	^smoothingMode asSignedInteger!

smoothingMode: aSmoothingModeConstant
	"Set the type of smoothing (antialiasing) that is applied to lines and curves."

	Gdip gdipSetSmoothingMode: self handle smoothingMode: aSmoothingModeConstant!

textRenderingHint: aTextRenderingHintConstant
	"Set the text rendering mode of the receiver."

	Gdip gdipSetTextRenderingHint: self handle mode: aTextRenderingHintConstant!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| gpHandle |
	gpHandle := Matrix new.
	Gdip gdipGetWorldTransform: self handle matrix: gpHandle asParameter.
	^gpHandle!

transform: aGdiplusMatrix
	"Set the receiver's world transform to the <Matrix> argument."

	Gdip gdipSetWorldTransform: self handle matrix: aGdiplusMatrix asParameter!

transformPoints: aPointsCollection destSpace: destSpace srcSpace: srcSpace
	"Convert aPointsCollection from one coordinate space to another. The conversion 
	is based on the current world and page transformations of the receiver."

	| points |
	points := POINTLArray marshal: aPointsCollection.
	Gdip
		gdipTransformPointsI: self handle
		destSpace: destSpace
		srcSpace: srcSpace
		points: points
		count: aPointsCollection size.
	^points!

translate: aPoint
	"Translate (shift) the receiver's world transform by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> argument."

	self translate: aPoint order: MatrixOrderPrepend!

translate: aPoint order: aMatrixOrderConstant
	"Translate the receiver's world transform by the horizontal and vertical offsets that are the x and y co-ordinates of the <Point> 1st argument, with the order of transformation specified by <integer> MatrixOrderConstant 2nd argument."

	Gdip
		gdipTranslateWorldTransform: self handle
		dx: aPoint x
		dy: aPoint y
		order: aMatrixOrderConstant!

translateTransform: aPoint
	#deprecated.
	self translate: aPoint!

translateTransform: aPoint order: aMatrixOrderConstant
	#deprecated.
	self translate: aPoint order: aMatrixOrderConstant! !

!Graphics.Gdiplus.GdiplusGraphics categoriesForMethods!
beginContainer!operations!public! !
clear!operations!public! !
clear:!operations!public! !
clip:!clipping!public! !
clip:combineMode:!clipping!public! !
clipRectangle:combineMode:!clipping!public! !
clipRegion:combineMode:!clipping!public! !
compositingMode!accessing-modes!public! !
compositingMode:!accessing-modes!public! !
compositingQuality!accessing-modes!public! !
compositingQuality:!accessing-modes!public! !
doWithCanvas:!gdi interop!public! !
doWithDC:!gdi interop!public! !
dpi!accessing!drawArc:pen:startAngle:sweepAngle:!drawing-lines!public! !
drawArc:pen:startAngle:sweepAngle:!public! !
drawBezier:pen:!drawing-lines!public! !
drawCachedBitmap:at:!drawing-bitmaps!public! !
drawClosedCurve:pen:tension:!drawing-lines!public! !
drawCurve:pen:!drawing-lines!public! !
drawCurve:pen:tension:!drawing-lines!public! !
drawDropShadowRectangle:offset:alpha:!operations!public! !
drawEllipse:pen:!drawing-lines!public! !
drawImage:!drawing-bitmaps!public! !
drawImage:at:!drawing-bitmaps!public! !
drawImage:at:attributes:!drawing-bitmaps!public! !
drawImage:at:extent:!drawing-bitmaps!public! !
drawImage:at:extent:attributes:!drawing-bitmaps!public! !
drawImage:at:extent:from:extent:!drawing-bitmaps!public! !
drawImage:at:extent:from:extent:unit:attributes:!drawing-bitmaps!public! !
drawImage:attributes:!drawing-bitmaps!public! !
drawImage:points:!drawing-bitmaps!public! !
drawImage:rectangle:!drawing-bitmaps!public! !
drawLine:pen:!drawing-lines!public! !
drawLineFrom:to:pen:!drawing-lines!public! !
drawPath:!drawing-lines!public! !
drawPath:pen:!drawing-lines!public! !
drawPie:pen:startAngle:sweepAngle:!drawing-lines!public! !
drawPolygon:pen:!drawing-lines!public! !
drawRectangle:!drawing-lines!public! !
drawRectangle:pen:!drawing-lines!public! !
drawString:at:!drawing-strings!public! !
drawString:font:at:!drawing-strings!public! !
drawString:font:at:brush:!drawing-strings!public! !
drawString:font:at:format:brush:!drawing-strings!public! !
drawString:font:rect:format:brush:!drawing-strings!public! !
drawString:layoutRect:!drawing-strings!public! !
endContainer:!operations!public! !
erase!operations!public! !
excludeClip:!clipping!public! !
excludeClipRectangle:!clipping!public! !
fillClosedCurve:brush:!drawing-lines!public! !
fillEllipse:brush:!filling!public! !
fillPath:brush:!filling!public! !
fillPie:brush:startAngle:sweepAngle:!filling!public! !
fillPolygon:brush:!filling!public! !
fillPolygon:brush:fillMode:!filling!public! !
fillRectangle:brush:!filling!public! !
fillRectangle:color:!filling!public! !
fillRegion:brush:!filling!public! !
fillRegion:color:!filling!public! !
getHDC!gdi interop!private! !
initializerClass!constants!private! !
interpolationMode!accessing-modes!public! !
interpolationMode:!accessing-modes!public! !
intersectClip:!clipping!public! !
intersectClipRectangle:!clipping!public! !
measureCharacterRanges:font:rect:format:!drawing-strings!public! !
measureString:font:!drawing-strings!public! !
measureString:font:rect:format:!drawing-strings!public! !
pageScale!accessing!public! !
pageScale:!accessing!public! !
pageUnit!accessing!public! !
pageUnit:!accessing!public! !
pageUnitName!accessing!public! !
pixelOffsetMode!accessing-modes!public! !
pixelOffsetMode:!accessing-modes!public! !
releaseHDC:!gdi interop!private! !
resetClip!operations!public! !
resetTransform!public!transformations! !
resolution!accessing!public! !
rotate:!public!transformations! !
rotate:at:!public!transformations! !
rotate:order:!public!transformations! !
rotateTransform:!public!transformations! !
rotateTransform:order:!public!transformations! !
scale:!public!transformations! !
scale:order:!public!transformations! !
scaleTransform:!public!transformations! !
scaleTransform:order:!public!transformations! !
shear:!public!transformations! !
shear:order:!public!transformations! !
smoothingMode!accessing-modes!public! !
smoothingMode:!accessing-modes!public! !
textRenderingHint:!accessing-modes!public! !
transform!public!transformations! !
transform:!public!transformations! !
transformPoints:destSpace:srcSpace:!public!transformations! !
translate:!public!transformations! !
translate:order:!public!transformations! !
translateTransform:!public!transformations! !
translateTransform:order:!public!transformations! !
!

!Graphics.Gdiplus.GdiplusGraphics class methodsFor!

desktop
	^self fromInitializer: (GraphicsFromHWNDInitializer on: nil)!

fromCanvas: aCanvas
	^self fromInitializer: (GraphicsFromHDCInitializer on: aCanvas)!

fromImage: aGdiplusImage
	^self fromInitializer: (GraphicsFromImageInitializer on: aGdiplusImage)!

fromView: aView
	^self fromInitializer: (GraphicsFromHWNDInitializer on: aView)! !

!Graphics.Gdiplus.GdiplusGraphics class categoriesForMethods!
desktop!instance creation!public! !
fromCanvas:!instance creation!public! !
fromImage:!instance creation!public! !
fromView:!instance creation!public! !
!

