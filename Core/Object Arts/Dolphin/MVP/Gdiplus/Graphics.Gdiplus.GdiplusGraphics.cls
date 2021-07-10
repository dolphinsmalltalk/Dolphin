"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.GdiplusGraphics'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GdiplusGraphics guid: (Core.GUID fromString: '{76d4e292-3cd0-44ac-af53-a4209708faa5}')!
Graphics.Gdiplus.GdiplusGraphics comment: 'GdiplusGraphics class provides methods for drawing lines, curves, figures, images, and text. An instance stores attributes of the display device and attributes of the items to be drawn.

'!
!Graphics.Gdiplus.GdiplusGraphics categoriesForClass!Unclassified! !
!Graphics.Gdiplus.GdiplusGraphics methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	Gdip gdipDeleteGraphics: handle!

beginContainer
	"Answer an <Integer> value that identifies the container."

	| state |
	state := ByteArray newFixed: 4.
	Gdip gdipBeginContainer2: self asParameter state: state asParameter.
	^state dwordAtOffset: 0!

clear
	"Clear the receiver, i.e., erase everything on it."

	self clear: nil!

clear: aColor
	"Clear the receiver and (flood) fill it with the specified color."

	Gdip gdipGraphicsClear: self asParameter color: aColor argbCode!

clipRectangle: aRectangle combineMode: aCombineModeConstant
	"Set the clipping region of the receiver to a region that is the combination of itself and 
	aRectangle, using  aCombineModeConstant to specify how the two regions are combined."

	Gdip
		gdipSetClipRectI: self asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		combineMode: aCombineModeConstant!

clipRegion: aGdiplusRegion combineMode: aCombineModeConstant
	"Set the clipping region of the receiver to a region that is the combination of itself and the region
	specified by aGdiplusRegion, using  aCombineModeConstant to specify how the two regions are combined."

	Gdip
		gdipSetClipRegion: self asParameter
		region: aGdiplusRegion asParameter
		combineMode: aCombineModeConstant!

compositingMode
	"Answer an Integer that represents how rendered colors are combined with background colors."

	| compositingMode |
	compositingMode := ByteArray newFixed: 4.
	Gdip gdipGetCompositingMode: self asParameter compositingMode: compositingMode asParameter.
	^compositingMode sdwordAtOffset: 0!

compositingMode: aCompositingModeConstant
	"Set the receiver's compositing mode (how rendered colors are combined with background colors.)."

	Gdip gdipSetCompositingMode: self asParameter compositingMode: aCompositingModeConstant!

compositingQuality
	"Answer an Integer that represents whether gamma correction is applied when colors 
	are blended with background colors"

	| compositingQuality |
	compositingQuality := ByteArray newFixed: 4.
	Gdip gdipGetCompositingQuality: self asParameter compositingQuality: compositingQuality asParameter.
	^compositingQuality sdwordAtOffset: 0!

compositingQuality: aCompositingQualityConstant
	"Set the receiver's compositingQuality (whether gamma correction is applied when 
	colors are blended with background colors)"

	Gdip gdipSetCompositingQuality: self asParameter compositingQuality: aCompositingQualityConstant!

doWithCanvas: anOperation
	| hdc |
	hdc := self getHDC.
	[anOperation value: (Canvas withNonOwnedDC: hdc)]
		ensure: [hdc notNil ifTrue: [self releaseHDC: hdc]]!

doWithDC: anOperation
	"MSDN: 
Each call to the GetHDC method of a Graphics object should be paired with a call to the ReleaseHDC method of that same Graphics object. Do not call any methods of the Graphics object between the calls to GetHDC and ReleaseHDC. If you attempt to call a method of the Graphics object between GetHDC and ReleaseHDC, the method will fail and will return ObjectBusy. 
Any state changes you make to the device context between GetHDC and ReleaseHDC will be ignored by GDI+ and will not be reflected in rendering done by GDI+."

	| hdc |
	hdc := self getHDC.
	[anOperation value: hdc] ensure: [self releaseHDC: hdc]!

drawArc: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle
	"Draw an arc on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	Gdip
		gdipDrawArcI: self asParameter
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
		gdipDrawBezierI: self asParameter
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
		gdipDrawCachedBitmap: self asParameter
		cachedBitmap: aCachedBitmap asParameter
		x: aPoint x
		y: aPoint y!

drawClosedCurve: aPointsCollection pen: aGdiplusPen tension: aReal
	"Draw a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	Gdip
		gdipDrawClosedCurve2I: self asParameter
		pen: aGdiplusPen asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size
		tension: aReal!

drawCurve: aPointsCollection pen: aGdiplusPen
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."

	Gdip
		gdipDrawCurveI: self asParameter
		pen: aGdiplusPen asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size!

drawCurve: aPointsCollection pen: aGdiplusPen tension: aReal
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	Gdip
		gdipDrawCurve2I: self asParameter
		pen: aGdiplusPen asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size
		tension: aReal!

drawDropShadowRectangle: rect offset: offset alpha: alpha 
	| shadowRect shadow |
	shadowRect := rect topLeft // offset extent: rect extent // offset.
	shadow := Bitmap extent: shadowRect extent.
	shadow graphics fillRectangle: shadowRect
		brush: (SolidBrush color: (Color 
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
		gdipDrawEllipseI: self asParameter
		pen: aPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

drawImage: aGdiplusImage
	"Draw all of aGdiplusImage on the receiver, at the receiver's origin."

	self drawImage: aGdiplusImage at: Point.Zero!

drawImage: aGdiplusImage at: aPoint
	"Draw all of aGdiplusImage on the receiver, at aPoint."

	self 
		drawImage: aGdiplusImage
		at: aPoint
		extent: aGdiplusImage extent!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent
	"Draw all of aGdiplusImage on the receiver, sized to fit the specified rectangle."

	Gdip
		gdipDrawImageRectI: self asParameter
		image: aGdiplusImage asParameter
		x: dstOrigin x
		y: dstOrigin y
		width: dstExtent x
		height: dstExtent y!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent
	"Draw the portion of the aGdiplusImage specified by a source rectangle to a portion of the
	receiver specified by a destination rectangle.  The source image is scaled to fit the receiver."

	self 
		drawImage: aGdiplusImage
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: nil
		attributes: nil!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: aSrcUnit attributes: imageAttributes
	"Draw the portion of aGdiplusImage specified by srcOrigin and srcExtent to the receiver at the
	rectangle specified by dstOrigin and dstExtent. The image is stretched to fit the destination rectangle.
	srcUnit is the unit of measure for the source rectangle. imageAttributes specifies color adjustments."

	Gdip
		gdipDrawImageRectRectI: self asParameter
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

drawImage: anImage points: threePoints
	"Draw anImage on the receiver stretched to fit the parallelogram specified by threePoints."

	self assert: [threePoints size = 3].
	Gdip
		gdipDrawImagePointsI: self asParameter
		image: anImage asParameter
		dstpoints: (StructureArray withAll: (threePoints collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
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
		gdipDrawLineI: self asParameter
		pen: aGdiplusPen asParameter
		x1: fromPoint x
		y1: fromPoint y
		x2: toPoint x
		y2: toPoint y!

drawPath: aPath pen: aPen
	"Draw aPath on the receiver using aPen."

	Gdip
		gdipDrawPath: self asParameter
		pen: aPen asParameter
		path: aPath asParameter!

drawPie: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle
	"Draw a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	Gdip
		gdipDrawPieI: self asParameter
		pen: aGdiplusPen asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		startAngle: startAngle
		sweepAngle: sweepAngle!

drawPolygon: collectionOfPoints pen: aPen
	"Draw a polygon on the receiver using aPen."

	Gdip
		gdipDrawPolygonI: self asParameter
		pen: aPen asParameter
		points: (StructureArray withAll: (collectionOfPoints collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: collectionOfPoints size!

drawRectangle: aRectangle
	"Draw aRectangle on the receiver."

	self drawRectangle: aRectangle pen: Pen new!

drawRectangle: aRectangle pen: aPen
	"Draw a Rectangle on the receiver using aPen."

	Gdip
		gdipDrawRectangleI: self asParameter
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
		at: aPoint
		format: nil
		brush: nil!

drawString: aString font: aFont at: aPoint format: aStringFormat brush: aBrush
	"Draw aString on the receiver at aPoint using aFont, aStringFormat, and aBrush."

	self 
		drawString: aString
		font: aFont
		rect: (aPoint extent: Point.Zero)
		format: aStringFormat
		brush: aBrush!

drawString: aString font: aFont rect: aRectangle format: aStringFormat brush: aBrush
	"Draw aString on the receiver inside aRectangle, using font attributes (family name, size,
	and style) specified by aFont, text format information (layout and display manipulations)
	specified by aStringFormat, and aBrush to fill the string."

	| font format brush text |
	font := aFont ifNil: [Font new].
	format := aStringFormat ifNil: [StringFormat genericDefault].
	brush := aBrush ifNil: [SolidBrush new].
	"Note that we must convert to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	Gdip
		gdipDrawString: self asParameter
		str: text
		length: text size
		font: font asParameter
		layoutRect: (RECTF fromRectangle: aRectangle)
		stringFormat: format asParameter
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

	Gdip gdipEndContainer: self asParameter state: containerInteger!

fillClosedCurve: aPointsCollection brush: aGdiplusBrush
	"Fills a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."

	Gdip
		gdipFillClosedCurveI: self asParameter
		brush: aGdiplusBrush asParameter
		points: (StructureArray withAll: (aPointsCollection collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: aPointsCollection size!

fillEllipse: aRectangle brush: aGdiplusBrush
	"Fill the interior of an ellipse that is bounded by aRectangle on the receiver using aGdiplusBrush."

	Gdip
		gdipFillEllipseI: self asParameter
		brush: aGdiplusBrush asParameter
		x: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height!

fillPath: aPath brush: aBrush
	"Fill aPath on the receiver using a Brush."

	Gdip
		gdipFillPath: self asParameter
		brush: aBrush asParameter
		path: aPath asParameter!

fillPie: aRectangle brush: aGdiplusBrush startAngle: startAngle sweepAngle: sweepAngle
	"Fill a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusBrush."

	Gdip
		gdipFillPieI: self asParameter
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
		gdipFillPolygonI: self asParameter
		brush: aBrush asParameter
		points: (StructureArray withAll: (collectionOfPoints collect: [:e | POINTL fromPoint: e])
				elementClass: POINTL)
		count: collectionOfPoints size
		fillMode: aFillModeConstant!

fillRectangle: aRectangle brush: aGdiplusBrush
	"Fill aRectangle on the receiver using a aGdiplusBrush."

	Gdip
		gdipFillRectangleI: self asParameter
		brush: aGdiplusBrush asParameter
		x: aRectangle left asInteger
		y: aRectangle top asInteger
		width: aRectangle width asInteger
		height: aRectangle height asInteger!

fillRectangle: aRectangle color: aColor 
	| fillBrush |
	fillBrush := SolidBrush color: aColor.
	self fillRectangle: aRectangle brush: fillBrush.
	fillBrush free!

fillRegion: aRegion brush: aBrush
	"Fill aRegion on the receiver using aBrush."

	Gdip
		gdipFillRegion: self asParameter
		brush: aBrush asParameter
		region: aRegion asParameter!

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
	Gdip gdipGetDC: self asParameter hdc: gpHandle.
	^gpHandle!

interpolationMode
	"Answer an Integer that represents the receiver's interpolation mode (the algorithm 
	that is used when images are scaled or rotated)."

	| interpolationMode |
	interpolationMode := ByteArray newFixed: 4.
	Gdip gdipGetInterpolationMode: self asParameter interpolationMode: interpolationMode asParameter.
	^interpolationMode sdwordAtOffset: 0!

interpolationMode: anInterpolationModeConstant
	"Set the receiver's interpolation mode (the algorithm that is used when images are scaled or rotated)."

	Gdip gdipSetInterpolationMode: self asParameter interpolationMode: anInterpolationModeConstant!

measureString: aString font: aFont
	"Answer a Point that is the extent of aString as specified by aFont."

	^(self
		measureString: aString
		font: aFont
		rect: RECTF new
		format: nil) extent!

measureString: aString font: aFont rect: aRectangle format: aStringFormat
	"Answer a Rectangle that is the bounds of aString inside aRectangle as specified by aFont and aStringFormat."

	| boundRect text |
	boundRect := RECTF new.
	"Note that we must conver to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	Gdip
		gdipMeasureString: self asParameter
		str: text
		length: text size
		font: aFont asParameter
		layoutRect: (RECTF fromRectangle: aRectangle)
		stringFormat: aStringFormat asParameter
		boundingBox: boundRect
		codepointsFitted: nil
		linesFilled: nil.
	^boundRect!

pageScale
	"Answer the scaling factor currently set for the page transformation of the receiver."

	| scale |
	scale := ByteArray newFixed: 4.
	Gdip gdipGetPageScale: self asParameter scale: scale.
	^scale floatAtOffset: 0!

pageScale: aRealNumber
	"Set the scaling factor for the page transformation of the receiver to aRealNumber.
	The page transformation converts page coordinates to device coordinates."

	Gdip gdipSetPageScale: self asParameter scale: aRealNumber!

pageUnit
	"Answer the unit of measure currently set for the receiver."

	| unit |
	unit := ByteArray newFixed: 4.
	Gdip gdipGetPageUnit: self asParameter unit: unit.
	^unit sdwordAtOffset: 0!

pageUnit: aUnitConstant
	"Set the receiver's unit of measure."

	Gdip gdipSetPageUnit: self asParameter unit: aUnitConstant!

pageUnitName
	"Answer the receiver's page unit as a string."

	^(self class enumsUnit detect: [:e | e value = self pageUnit]) key!

pixelOffsetMode
	| pixelOffsetMode |
	pixelOffsetMode := ByteArray newFixed: 4.
	Gdip gdipGetPixelOffsetMode: self asParameter pixelOffsetMode: pixelOffsetMode.
	^pixelOffsetMode sdwordAtOffset: 0!

pixelOffsetMode: aPixelOffsetModeConstant
	"Set the type of pixel offsetting that is applied to lines and curves."

	Gdip gdipSetPixelOffsetMode: self asParameter pixelOffsetMode: aPixelOffsetModeConstant!

releaseHDC: anExternalHandle
	" 
	VOID ReleaseHDC(IN HDC hdc)
	    {
	        SetStatus(DllExports::GdipReleaseDC(nativeGraphics, hdc));
	    }"

	Gdip gdipReleaseDC: self asParameter hdc: anExternalHandle!

resetClip
	"Set the clipping region of the receiver to an infinite region."

	Gdip gdipResetClip: self asParameter!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	Gdip gdipResetWorldTransform: self asParameter!

resolution
	"Answer the resolution, in dots per inch, of the display device associated with the receiver."

	| dpi dpiX dpiY |
	dpi := ByteArray new: 4.
	Gdip gdipGetDpiX: self asParameter dpi: dpi.
	dpiX := dpi floatAtOffset: 0.
	Gdip gdipGetDpiY: self asParameter dpi: dpi.
	dpiY := dpi floatAtOffset: 0.
	^dpiX asInteger @ dpiY asInteger!

rotate: aRealAngle at: aPoint
	"Translate the receiver's transformation matrix by a Point and then rotate it by aRealAngle."

	self translateTransform: aPoint order: nil.
	self rotateTransform: aRealAngle order: nil!

rotateTransform: aRealAngle 
	"Rotate the receiver's transformation matrix by aRealAngle."

	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	Gdip
		gdipRotateWorldTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

scaleTransform: aRealPoint 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix defined by aRealPoint."

	self scaleTransform: aRealPoint order: nil!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	Gdip
		gdipScaleWorldTransform: self asParameter
		sx: aRealPoint x
		sy: aRealPoint y
		order: aMatrixOrderConstant!

smoothingMode
	| smoothingMode |
	smoothingMode := ByteArray newFixed: 4.
	Gdip gdipGetSmoothingMode: self asParameter smoothingMode: smoothingMode.
	^smoothingMode sdwordAtOffset: 0!

smoothingMode: aSmoothingModeConstant
	"Set the type of smoothing (antialiasing) that is applied to lines and curves."

	Gdip gdipSetSmoothingMode: self asParameter smoothingMode: aSmoothingModeConstant!

textRenderingHint: aTextRenderingHintConstant
	"Set the text rendering mode of the receiver."

	Gdip gdipSetTextRenderingHint: self asParameter mode: aTextRenderingHintConstant!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| gpHandle |
	gpHandle := Matrix new.
	Gdip gdipGetWorldTransform: self asParameter matrix: gpHandle asParameter.
	^gpHandle!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	Gdip gdipSetWorldTransform: self asParameter matrix: aGdiplusMatrix asParameter!

transformPoints: aPointsCollection destSpace: destSpace srcSpace: srcSpace
	"Convert aPointsCollection from one coordinate space to another. The conversion 
	is based on the current world and page transformations of the receiver."

	| points count |
	points := StructureArray
				withAll: aPointsCollection
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	points beUnfinalizable.
	count := points size.
	Gdip
		gdipTransformPointsI: self asParameter
		destSpace: destSpace
		srcSpace: srcSpace
		points: points
		count: count.
	points with: (1 to: count) do: [:pointl :i | aPointsCollection at: i put: pointl asPoint]!

translateTransform: aRealPoint 
	"Translate (shift) the receiver's transformation matrix by aRealPoint."

	self translateTransform: aRealPoint order: MatrixOrderPrepend!

translateTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a translation matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	Gdip
		gdipTranslateWorldTransform: self asParameter
		dx: aRealPoint x
		dy: aRealPoint y
		order: aMatrixOrderConstant! !
!Graphics.Gdiplus.GdiplusGraphics categoriesForMethods!
basicFree!private!realizing/unrealizing! !
beginContainer!accessing-transformations!public! !
clear!operations!public! !
clear:!operations!public! !
clipRectangle:combineMode:!operations!public! !
clipRegion:combineMode:!operations!public! !
compositingMode!accessing-modes!public! !
compositingMode:!accessing-modes!public! !
compositingQuality!accessing-modes!public! !
compositingQuality:!accessing-modes!public! !
doWithCanvas:!gdi interop!public! !
doWithDC:!gdi interop!public! !
drawArc:pen:startAngle:sweepAngle:!drawing-lines!public! !
drawBezier:pen:!drawing-lines!public! !
drawCachedBitmap:at:!drawing-bitmaps!public! !
drawClosedCurve:pen:tension:!drawing-lines!public! !
drawCurve:pen:!drawing-lines!public! !
drawCurve:pen:tension:!drawing-lines!public! !
drawDropShadowRectangle:offset:alpha:!public! !
drawEllipse:pen:!drawing-lines!public! !
drawImage:!drawing-bitmaps!public! !
drawImage:at:!drawing-bitmaps!public! !
drawImage:at:extent:!drawing-bitmaps!public! !
drawImage:at:extent:from:extent:!drawing-bitmaps!public! !
drawImage:at:extent:from:extent:unit:attributes:!drawing-bitmaps!public! !
drawImage:points:!drawing-bitmaps!public! !
drawImage:rectangle:!drawing-bitmaps!public! !
drawLine:pen:!drawing-lines!public! !
drawLineFrom:to:pen:!drawing-lines!public! !
drawPath:pen:!drawing-lines!public! !
drawPie:pen:startAngle:sweepAngle:!drawing-lines!public! !
drawPolygon:pen:!drawing-lines!public! !
drawRectangle:!drawing-lines!public! !
drawRectangle:pen:!drawing-lines!public! !
drawString:at:!drawing-strings!public! !
drawString:font:at:format:brush:!drawing-strings!public! !
drawString:font:rect:format:brush:!drawing-strings!public! !
drawString:layoutRect:!drawing-strings!public! !
endContainer:!accessing-transformations!public! !
fillClosedCurve:brush:!drawing-lines!public! !
fillEllipse:brush:!filling!public! !
fillPath:brush:!filling!public! !
fillPie:brush:startAngle:sweepAngle:!filling!public! !
fillPolygon:brush:!filling!public! !
fillPolygon:brush:fillMode:!filling!public! !
fillRectangle:brush:!filling!public! !
fillRectangle:color:!filling!public! !
fillRegion:brush:!filling!public! !
getHDC!gdi interop!private! !
interpolationMode!accessing-modes!public! !
interpolationMode:!accessing-modes!public! !
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
resetTransform!accessing-transformations!public! !
resolution!accessing!public! !
rotate:at:!accessing-transformations!public! !
rotateTransform:!accessing-transformations!public! !
rotateTransform:order:!accessing-transformations!public! !
scaleTransform:!accessing-transformations!public! !
scaleTransform:order:!accessing-transformations!public! !
smoothingMode!accessing-modes!public! !
smoothingMode:!accessing-modes!public! !
textRenderingHint:!accessing-modes!public! !
transform!accessing-transformations!public! !
transform:!accessing-transformations!public! !
transformPoints:destSpace:srcSpace:!accessing-transformations!public! !
translateTransform:!accessing-transformations!public! !
translateTransform:order:!accessing-transformations!public! !
!

!Graphics.Gdiplus.GdiplusGraphics class methodsFor!

exampleGdipGAlphaBlending
	"Using GDI+ .... Alpha Blending Lines and Fills ... Using Compositing Mode to Control Alpha Blending 

		self exampleGdipGAlphaBlending showExample
	"

	"Create a blank bitmap."

	| bitmap graphics redBrush greenBrush bitmap2 graphics2 |
	bitmap := Bitmap width: 180 height: 100.
	"Create a Graphics object that we can use to draw on the bitmap."
	graphics := bitmap graphics.
	"Create a red brush and a green brush, each with an alpha value of 160."
	redBrush := SolidBrush color: (Color fromArray: #(210 255 0 0)).
	greenBrush := SolidBrush color: (Color fromArray: #(210 0 255 0)).
	"Set the compositing mode so that when we draw overlapping ellipses, 
	the colors of the ellipses are not blended."
	graphics compositingMode: CompositingModeSourceCopy.
	"Fill an ellipse using a red brush that has an alpha value of 160."
	graphics fillEllipse: (0 @ 0 extent: 150 @ 70) brush: redBrush.
	"Fill a second ellipse using green brush that has an alpha value of 160. 
	The green ellipse overlaps the red ellipse, but the green is not blended with the red."
	graphics fillEllipse: (30 @ 30 extent: 150 @ 70) brush: greenBrush.
	"Prepare to draw on the screen."
	bitmap2 := Bitmap extent: 400 @ 200.
	graphics2 := bitmap2 graphics clear: Color white.
	graphics2 compositingQuality: CompositingQualityGammaCorrected.
	"Draw a multicolored background."
	graphics2 fillRectangle: (200 @ 0 extent: 60 @ 100) brush: (SolidBrush color: Color aqua).
	graphics2 fillRectangle: (260 @ 0 extent: 60 @ 100) brush: (SolidBrush color: Color yellow).
	graphics2 fillRectangle: (320 @ 0 extent: 60 @ 100) brush: (SolidBrush color: Color fuchsia).
	"Display the bitmap on a white background."
	graphics2 drawImage: bitmap at: 0 @ 0.
	"Display the bitmap on a multicolored background."
	graphics2 drawImage: bitmap at: 200 @ 0.
	^bitmap2!

exampleGdipGCropAndScale
	"This example draws an image with its upper-left corner at (0, 0) and then draws a portion 
	of the image, scaled so that it fills a specified destination rectangle.

		self exampleGdipGCropAndScale showExample
	"

	| image bitmap |
	bitmap := Bitmap extent: 800 @ 400.
	image := Image fromFile: 'Resources/Beach Ball.bmp' usingLocator: FileLocator installRelative.
	bitmap graphics
		drawImage: image at: 0 @ 0;
		drawImage: image
			at: 50 @ 100
			extent: (image extent * 1.3) ceiling
			from: 0 @ 0
			extent: (image extent * 0.7) ceiling.
	^bitmap!

exampleGdipGDrawingALine
	"From MSDN: Using GDI+ > Getting Started > Drawing a Line
	This example uses a pen to draw a line on a Graphics object (which is obtained from an Image (bitmap).

		self exampleGdipGDrawingALine showExample
	"

	| bitmap |
	bitmap := Bitmap extent: 250 @ 200.
	bitmap graphics
		drawLineFrom: 10 @ 10
		to: 200 @ 100
		pen: Pen red.
	^bitmap!

exampleGdipGDrawingAString
	"From MSDN: Using GDI+ > Getting Started > Drawing a String.
	This example draws a string on a Graphics object, using font and brush objects.
	The font is actually derived from a GdiplusFontFamily object, using the helper constructor 
	in GdiplusFont.  A second string is drawn relying on defaults for font and brush.

		self exampleGdipGDrawingAString showExample
	"

	| bitmap font |
	bitmap := Bitmap extent: 250 @ 100.
	font := Font name: 'Times New Roman' pointSize: 24.
	bitmap graphics
		drawString: 'Hello Dolphin!!'
			font: font
			at: 10 @ 20
			format: nil
			brush: SolidBrush blue;
		drawString: 'Hello Lagoon' at: 10 @ 75.
	^bitmap!

exampleGdipGDrawingShapes
	"This example draws and fills a number of shapes, including arcs, pies, and curves.

		self exampleGdipGDrawingShapes showExample
	"

	| bitmap graphics redPen blackPen greenBrush rectEllipse polygonPoints arcRect pieRect bezierPoints curvePoints closedCurvePoints |
	bitmap := Bitmap extent: 700 @ 400.
	graphics := bitmap graphics.
	redPen := Pen red width: 5.
	blackPen := Pen black.
	greenBrush := SolidBrush green.
	"Ellipse: Draw and fill."
	rectEllipse := 10 @ 10 extent: 200 @ 100.
	graphics drawEllipse: rectEllipse pen: redPen.
	graphics fillEllipse: rectEllipse brush: greenBrush.
	graphics drawRectangle: rectEllipse pen: blackPen.
	"Polygon: Draw and fill."
	polygonPoints := (OrderedCollection
				with: 100 @ 130
				with: 200 @ 160
				with: 150 @ 230
				with: 50 @ 230)
				add: 10 @ 160;
				yourself.
	graphics drawPolygon: polygonPoints pen: redPen.
	graphics fillPolygon: polygonPoints brush: greenBrush.
	1 to: polygonPoints size do: [:i | graphics drawString: i displayString at: (polygonPoints at: i)].
	"Arc: Draw"
	arcRect := rectEllipse translateBy: 220 @ 0.
	graphics
		drawArc: arcRect
		pen: redPen
		startAngle: 90
		sweepAngle: 215.
	graphics drawRectangle: arcRect pen: blackPen.
	"Pie: Draw and fill."
	pieRect := arcRect translateBy: 0 @ 120.
	graphics
		drawPie: pieRect
		pen: redPen
		startAngle: 0
		sweepAngle: 215.
	graphics
		fillPie: pieRect
		brush: greenBrush
		startAngle: 0
		sweepAngle: 215.
	graphics drawRectangle: pieRect pen: blackPen.
	"Bezier: Draw"
	bezierPoints := (polygonPoints collect: [:e | 0 @ 120 + e])
				removeLast;
				yourself.
	graphics drawBezier: bezierPoints pen: redPen.
	graphics drawPolygon: bezierPoints pen: blackPen.
	1 to: 4 do: [:i | graphics drawString: i displayString at: (bezierPoints at: i)].
	"Curve:  Draw"
	curvePoints := (polygonPoints collect: [:e | 220 @ 120 + e])
				removeAtIndex: 3;
				yourself.
	graphics drawCurve: curvePoints pen: redPen.	"same as with tension: 0.5"
	graphics
		drawCurve: curvePoints
		pen: blackPen
		tension: 0.
	graphics
		drawCurve: curvePoints
		pen: (Pen blue width: 3)
		tension: 1.
	graphics
		drawCurve: curvePoints
		pen: (Pen green width: 3)
		tension: 2.
	1 to: curvePoints size do: [:i | graphics drawString: i displayString at: (curvePoints at: i)].
	"Closed Curve:  Draw and fill"
	closedCurvePoints := (polygonPoints collect: [:e | 440 @ -120 + e])
				removeAtIndex: 3;
				yourself.
	graphics
		drawClosedCurve: closedCurvePoints
		pen: blackPen
		tension: 0.
	graphics
		drawClosedCurve: closedCurvePoints
		pen: redPen
		tension: 0.5.
	graphics
		drawClosedCurve: closedCurvePoints
		pen: (Pen blue width: 3)
		tension: -1.
	graphics
		drawClosedCurve: closedCurvePoints
		pen: (Pen green width: 3)
		tension: -2.
	1 to: curvePoints size do: [:i | graphics drawString: i displayString at: (closedCurvePoints at: i)].
	^bitmap!

exampleGdipGFromCanvas
	"This example creates aGdiplusGraphics from a Canvas.

		self showExample: self exampleGdipGFromCanvas
	"

	| bmp canvas graphics |
	bmp := DIBSection
				width: 256
				height: 256
				depth: 32.
	canvas := bmp canvas.
	self icon
		drawOn: bmp canvas
		at: 0 @ 0
		extent: 256 @ 256.
	canvas := bmp canvas.
	graphics := GdiplusGraphics fromCanvas: canvas.
	graphics drawString: 'Hi' at: 120 @ 120.
	bmp freeDC.
	^bmp!

exampleGdipGMeasureString
	"MSDN: GDI+ Reference > Classes > Graphics > Graphics Methods > MeasureString Methods
	This example draws a string, then measures the string size and draws a rectangle around it.

		self exampleGdipGMeasureString showExample
	"

	| bitmap graphics string font layoutRect format boundRect |
	bitmap := Bitmap extent: 300 @ 200.
	graphics := bitmap graphics.
	string := 'Measure the size of text to be placed in a rectangle.'.
	font := Font name: 'Arial' pointSize: 16.
	layoutRect := 30 @ 20 extent: 200 @ 125.
	format := StringFormat centered.
	boundRect := graphics
				measureString: string
				font: font
				rect: layoutRect
				format: format.
	graphics
		drawRectangle: layoutRect pen: Pen black;
		drawRectangle: boundRect pen: Pen blue;
		drawString: string
			font: font
			rect: layoutRect
			format: format
			brush: SolidBrush blue.
	^bitmap!

exampleGdipGRotate
	"MSDN:   GDI+ >  GDI+ Reference >  Classes >  Graphics >  Graphics Methods > RotateTransform
	This example draws two ellipses (in black) and then rotates both (in red).  Notice the text in the
	rotated ellipses is also rotated.
	
		self  exampleGdipGRotate showExample
	"

	| bitmap graphics rect1 rect2 blackPen redPen brush format |
	bitmap := Bitmap extent: 400 @ 350.
	graphics := bitmap graphics.
	rect1 := 0 @ 0 extent: 200 @ 80.
	rect2 := 150 @ 75 extent: 200 @ 80.
	blackPen := Pen black.
	redPen := Pen red.
	brush := SolidBrush red.
	format := StringFormat centered.
	graphics
		drawEllipse: rect1 pen: blackPen;
		rotateTransform: 30;
		drawEllipse: rect1 pen: redPen;
		drawString: '#1 rotated'
			font: nil
			rect: rect1
			format: format
			brush: brush;
		resetTransform;
		drawEllipse: rect2 pen: blackPen;
		rotateTransform: 30;
		drawEllipse: rect2 pen: redPen;
		drawString: '#2 rotated'
			font: nil
			rect: rect2
			format: format
			brush: brush.
	^bitmap!

exampleGdipGTransformations
	"MSDN:  GDI+ >  Using GDI+ >  Transformations > Using the World Transformation
	This example draws a rectangle, then applies several transformations to a graphics, drawing
	the rectangle each time.

		self exampleGdipGTransformations showExample
	"

	| bitmap graphics rect transform |
	bitmap := Bitmap extent: 550 @ 350.
	graphics := bitmap graphics.
	rect := 100 @ 50 extent: 100 @ 100.
	graphics
		drawRectangle: rect;
		drawString: 'Original' at: rect origin;
		scaleTransform: 1.75 @ 0.75 order: nil;
		drawRectangle: rect pen: Pen red;
		drawString: 'Scaled'
			font: nil
			at: rect origin
			format: nil
			brush: SolidBrush red;
		rotateTransform: 28 order: nil;
		drawRectangle: rect pen: Pen blue;
		drawString: ' and Rotated'
			font: nil
			at: rect origin
			format: nil
			brush: SolidBrush blue;
		translateTransform: 150 @ 0 order: nil;
		drawRectangle: rect;
		drawString: ' and Translated' at: rect origin.
	transform := graphics transform asArray collect: [:e | e roundTo: 1.0e-002].
	graphics resetTransform drawString: 'Final world transform: ' , transform displayString at: 10 @ 250.
	^bitmap!

exampleGdipGTransformPoints
	"MSDN:  GDI+ >  GDI+ Reference >  Classes >  Graphics >  Graphics Methods > TransformPoints
	This example shows how GdiplusGraphics>>transformPoints actually changes the points
	in an array.  A set of points is drawn, then the graphics is transformed and the points are
	transformed according to the graphics' transformation.  The graphics transformation is reset
	and the points are drawn again, showing the points have been transformed.

		self exampleGdipGTransformPoints showExample
	"

	| bitmap pen points |
	bitmap := Bitmap extent: 300 @ 200.
	pen := Pen blue width: 5.
	points := {10 @ 10. 150 @ 50}.
	bitmap graphics
		drawLineFrom: points first
			to: points second
			pen: pen;
		translateTransform: 30 @ 60;
		transformPoints: points
			destSpace: CoordinateSpacePage
			srcSpace: CoordinateSpaceWorld;
		resetTransform;
		drawLineFrom: points first
			to: points second
			pen: pen.
	^bitmap!

exampleGdipNestedContainers
	"MSDN:  Using GDI+ >  Using Graphics Containers > Nested Graphics Containers

		self exampleGdipNestedContainers showExample
	"

	| bitmap graphics brush container redPen bluePen aquaBrush greenBrush outerContainer innerContainer path region font |
	bitmap := Bitmap extent: 650 @ 450.
	"Transformations in Nested Containers"
	redPen := Pen red.
	graphics := bitmap graphics.
	graphics translateTransform: 100 @ 80.
	container := graphics beginContainer.
	graphics
		rotateTransform: 30;
		drawRectangle: (-60 @ -30 extent: 120 @ 60) pen: redPen;
		endContainer: container;
		drawRectangle: (-60 @ -30 extent: 120 @ 60) pen: redPen.

	"Clipping in Nested Containers"
	redPen := Pen red width: 2.
	bluePen := Pen blue width: 2.
	aquaBrush := SolidBrush color: Color aqua.
	greenBrush := SolidBrush color: Color paleGreen.
	graphics clipRectangle: (50 @ 65 extent: 150 @ 120) combineMode: nil.
	graphics fillRectangle: (50 @ 65 extent: 150 @ 120) brush: aquaBrush.
	container := graphics beginContainer.
	path := Path new addEllipse: (75 @ 50 extent: 100 @ 150).
	region := Region fromPath: path.
	graphics
		fillRegion: region brush: greenBrush;
		clipRegion: region combineMode: nil;
		drawLine: (50 @ 0 extent: 350 @ 300) pen: redPen;
		endContainer: container;
		drawLine: (70 @ 0 extent: 370 @ 300) pen: bluePen.

	"Several Layers of Nested Containers"
	graphics resetClip translateTransform: 175 @ 175.
	brush := SolidBrush blue.
	font := Font name: 'Times New Roman' pointSize: 36.
	graphics textRenderingHint: TextRenderingHintAntiAlias.
	outerContainer := graphics beginContainer.
	graphics textRenderingHint: TextRenderingHintSingleBitPerPixel.
	innerContainer := graphics beginContainer.
	graphics
		textRenderingHint: TextRenderingHintAntiAlias;
		drawString: 'Inner Container'
			font: font
			at: 20 @ 10
			format: nil
			brush: brush;
		endContainer: innerContainer;
		drawString: 'Outer Container'
			font: font
			at: 20 @ 50
			format: nil
			brush: brush;
		endContainer: outerContainer;
		drawString: 'Graphics Object'
			font: font
			at: 20 @ 90
			format: nil
			brush: brush.
	^bitmap!

exampleGdipState
	"MSDN:  Using GDI+ >  Using Graphics Containers > The State of a Graphics Object

		self exampleGdipState
	"

	"Quality Settings"

	| bitmap graphics pen brush region |
	bitmap := Bitmap extent: 250 @ 275.
	graphics := bitmap graphics.
	pen := Pen red width: 5.
	graphics smoothingMode: SmoothingModeAntiAlias.
	graphics drawEllipse: (10 @ 10 extent: 200 @ 100) pen: pen.
	graphics smoothingMode: SmoothingModeHighSpeed.
	graphics drawEllipse: (10 @ 150 extent: 200 @ 100) pen: pen.
	bitmap showExample.

	"Transformations"
	bitmap := Bitmap extent: 325 @ 325.
	graphics := bitmap graphics.
	pen := Pen red.
	graphics resetTransform.
	graphics rotateTransform: 30.
	graphics drawEllipse: (50 @ 10 extent: 50 @ 25) pen: pen.
	graphics pageUnit: UnitMillimeter.
	graphics drawEllipse: (50 @ 10 extent: 50 @ 25) pen: pen.
	bitmap showExample.

	"Clipping Region"
	bitmap := Bitmap extent: 175 @ 175.
	graphics := bitmap graphics.
	pen := Pen red width: 5.
	brush := SolidBrush color: (Color fromArray: #(255 180 255 255)).
	"Create a plus-shaped region by forming the union of two rectangles."
	region := Region fromRectangle: (50 @ 0 corner: 50 @ 150).
	region combineRectangle: (0 @ 50 corner: 150 @ 50) mode: CombineModeUnion.
	graphics fillRegion: region brush: brush.
	"Set the clipping region."
	graphics clipRegion: region combineMode: nil.
	"Draw two clipped lines."
	graphics drawLine: (0 @ 30 corner: 150 @ 160) pen: pen.
	graphics drawLine: (40 @ 20 corner: 190 @ 150) pen: pen.
	bitmap showExample!

fromCanvas: aCanvas
	^self fromInitializer: (GraphicsFromHDCInitializer canvas: aCanvas)!

fromImage: aGdiplusImage
	^self fromInitializer: (GraphicsFromImageInitializer image: aGdiplusImage)!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Canvas icon! !
!Graphics.Gdiplus.GdiplusGraphics class categoriesForMethods!
exampleGdipGAlphaBlending!examples!public!sunit! !
exampleGdipGCropAndScale!examples!public!sunit! !
exampleGdipGDrawingALine!examples!public!sunit! !
exampleGdipGDrawingAString!examples!public!sunit! !
exampleGdipGDrawingShapes!examples!public!sunit! !
exampleGdipGFromCanvas!examples!public!sunit! !
exampleGdipGMeasureString!examples!public!sunit! !
exampleGdipGRotate!examples!public!sunit! !
exampleGdipGTransformations!examples!public!sunit! !
exampleGdipGTransformPoints!examples!public!sunit! !
exampleGdipNestedContainers!examples!public!sunit! !
exampleGdipState!examples!public! !
fromCanvas:!instance creation!public! !
fromImage:!instance creation!public! !
icon!constants!development!public! !
!

