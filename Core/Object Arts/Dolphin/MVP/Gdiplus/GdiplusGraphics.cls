"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusGraphics
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusGraphics guid: (GUID fromString: '{76d4e292-3cd0-44ac-af53-a4209708faa5}')!

GdiplusGraphics comment: 'GdiplusGraphics class provides methods for drawing lines, curves, figures, images, and text. An instance stores attributes of the display device and attributes of the items to be drawn.

'!

!GdiplusGraphics categoriesForClass!Unclassified! !

!GdiplusGraphics methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteGraphics: handle!

beginContainer
	"Answer an <Integer> value that identifies the container."

	| status state |
	state := DWORD new.
	(status := GdiplusLibrary default gdipBeginContainer2: self asParameter state: state asParameter) 
		= Ok ifFalse: [GdiplusError signal: 'GdipBeginContainer2  failed' with: status].
	^state asInteger!

clear
	"Clear the receiver, i.e., erase everything on it."

	self clear: nil!

clear: aColor
	"Clear the receiver and (flood) fill it with the specified color."

	| status |
	(status := GdiplusLibrary default gdipGraphicsClear: self asParameter color: aColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipGraphicsClear failed' with: status]!

clipRectangle: aRectangle combineMode: aCombineModeConstant 
	"Set the clipping region of the receiver to a region that is the combination of itself and 
	aRectangle, using  aCombineModeConstant to specify how the two regions are combined."

	| status |
	(status := GdiplusLibrary default 
				gdipSetClipRectI: self asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				combineMode: aCombineModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetClipRectI failed' with: status]!

clipRegion: aGdiplusRegion combineMode: aCombineModeConstant 
	"Set the clipping region of the receiver to a region that is the combination of itself and the region
	specified by aGdiplusRegion, using  aCombineModeConstant to specify how the two regions are combined."

	| status |
	(status := GdiplusLibrary default 
				gdipSetClipRegion: self asParameter
				region: aGdiplusRegion asParameter
				combineMode: aCombineModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetClipRegion failed' with: status]!

compositingMode
	"Answer an Integer that represents how rendered colors are combined with background colors."

	| status compositingMode |
	compositingMode := SDWORD new.
	status := GdiplusLibrary default gdipGetCompositingMode: self asParameter
				compositingMode: compositingMode asParameter.
	status = Ok ifFalse: [GdiplusError signal: 'GdipGetCompositingMode failed' with: status].
	^compositingMode asInteger!

compositingMode: aCompositingModeConstant 
	"Set the receiver's compositing mode (how rendered colors are combined with background colors.)."

	| status |
	status := GdiplusLibrary default gdipSetCompositingMode: self asParameter
				compositingMode: aCompositingModeConstant.
	status = Ok ifFalse: [GdiplusError signal: 'GdipSetCompositingMode failed' with: status]!

compositingQuality
	"Answer an Integer that represents whether gamma correction is applied when colors 
	are blended with background colors"

	| status compositingQuality |
	compositingQuality := SDWORD new.
	status := GdiplusLibrary default gdipGetCompositingQuality: self asParameter
				compositingQuality: compositingQuality asParameter.
	status = Ok ifFalse: [GdiplusError signal: 'GdipGetCompositingQuality failed' with: status].
	^compositingQuality asInteger!

compositingQuality: aCompositingQualityConstant 
	"Set the receiver's compositingQuality (whether gamma correction is applied when 
	colors are blended with background colors)"

	| status |
	(status := GdiplusLibrary default gdipSetCompositingQuality: self asParameter
				compositingQuality: aCompositingQualityConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetCompositingQuality failed' with: status]!

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

dpi
	"Answer the dots per inch of the display device associated with the receiver. It is assumed that the horizontal and vertical dpi are the same, which will be the case for any display device."

	| status dpiY |
	dpiY := ByteArray newFixed: 4.
	(status := GdiplusLibrary default gdipGetDpiY: self asParameter dpi: dpiY) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetDpiY failed' with: status].
	^(dpiY floatAtOffset: 0) asInteger!

drawArc: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle 
	"Draw an arc on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawArcI: self asParameter
				pen: aGdiplusPen asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				startAngle: startAngle
				sweepAngle: sweepAngle) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawArcI failed' with: status]!

drawBezier: aPointsCollection pen: aGdiplusPen 
	"Draw a Bezier curve on the receiver, specified by four points using aGdiplusPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawBezierI: self asParameter
				pen: aGdiplusPen asParameter
				x1: aPointsCollection first x
				y1: aPointsCollection first y
				x2: aPointsCollection second x
				y2: aPointsCollection second y
				x3: aPointsCollection third x
				y3: aPointsCollection third y
				x4: aPointsCollection fourth x
				y4: aPointsCollection fourth y) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawBezierI failed' with: status]!

drawCachedBitmap: aCachedBitmap at: aPoint 
	| status |
	(status := GdiplusLibrary default 
				gdipDrawCachedBitmap: self asParameter
				cachedBitmap: aCachedBitmap asParameter
				x: aPoint x
				y: aPoint y) == Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawCachedBitmap failed' with: status]!

drawClosedCurve: aPointsCollection pen: aGdiplusPen tension: aReal
	"Draw a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	| status |
	(status := GdiplusLibrary default
				gdipDrawClosedCurve2I: self asParameter
				pen: aGdiplusPen asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size
				tension: aReal) = Ok
		ifFalse: [GdiplusError signal: 'GdipDrawClosedCurve2I failed' with: status]!

drawCurve: aPointsCollection pen: aGdiplusPen 
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawCurveI: self asParameter
				pen: aGdiplusPen asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawCurveI failed' with: status]!

drawCurve: aPointsCollection pen: aGdiplusPen tension: aReal 
	"Draw a cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen.
	aReal specifies how tightly the curve bends through the coordinates of the cardinal spline."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawCurve2I: self asParameter
				pen: aGdiplusPen asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size
				tension: aReal) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawCurve2I failed' with: status]!

drawDropShadowRectangle: rect offset: offset alpha: alpha 
	| shadowRect shadow |
	shadowRect := rect topLeft // offset extent: rect extent // offset.
	shadow := GdiplusBitmap extent: shadowRect extent.
	shadow graphics fillRectangle: shadowRect
		brush: (GdiplusSolidBrush color: (Color 
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

	| status |
	(status := GdiplusLibrary default 
				gdipDrawEllipseI: self asParameter
				pen: aPen asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawEllipseI failed' with: status]!

drawImage: aGdiplusImage
	"Draw all of aGdiplusImage on the receiver, at the receiver's origin."

	| status |
	(status := GdiplusLibrary default
				gdipDrawImageI: self asParameter
				image: aGdiplusImage asParameter
				x: 0
				y: 0) == Ok
		ifFalse: [GdiplusError signal: 'GdipDrawImageI failed' with: status]!

drawImage: aGdiplusImage at: aPoint
	"Draw all of aGdiplusImage on the receiver, at aPoint."

	| status |
	(status := GdiplusLibrary default
				gdipDrawImageI: self asParameter
				image: aGdiplusImage asParameter
				x: aPoint x
				y: aPoint y) == Ok
		ifFalse: [GdiplusError signal: 'GdipDrawImageI failed' with: status]!

drawImage: aGdiplusImage at: dstOrigin extent: dstExtent 
	"Draw all of aGdiplusImage on the receiver, sized to fit the specified rectangle."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawImageRect: self asParameter
				image: aGdiplusImage asParameter
				x: dstOrigin x
				y: dstOrigin y
				width: dstExtent x
				height: dstExtent y) == Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawImageRectI failed' with: status]!

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

	| status |
	(status := GdiplusLibrary default
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
				callbackData: nil) == Ok
		ifFalse: [GdiplusError signal: 'GdipDrawImageRectRectI failed' with: status]!

drawImage: aGdiplusImage attributes: imageAttributes
	"Draw the <Gdiplus.Image> 1st argument at its full extent at the receiver's origin with <ImageAttributes> specified by the 2nd argument."

	| extent |
	extent := aGdiplusImage extent.
	self
		drawImage: aGdiplusImage
		at: Point.Zero
		extent: extent
		from: Point.Zero
		extent: extent
		unit: UnitPixel
		attributes: imageAttributes!

drawImage: anImage points: threePoints
	"Draw anImage on the receiver stretched to fit the parallelogram specified by threePoints."

	| status |
	self assert: [threePoints size = 3].
	(status := GdiplusLibrary default
				gdipDrawImagePointsI: self asParameter
				image: anImage asParameter
				dstpoints: (POINTLArray marshal: threePoints)
				count: threePoints size) == Ok
		ifFalse: [GdiplusError signal: 'GdipDrawImagePointsI failed' with: status]!

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

	| status |
	(status := GdiplusLibrary default 
				gdipDrawLineI: self asParameter
				pen: aGdiplusPen asParameter
				x1: fromPoint x
				y1: fromPoint y
				x2: toPoint x
				y2: toPoint y) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawLineI failed' with: status]!

drawPath: aPath
	self drawPath: aPath pen: GdiplusPen black!

drawPath: aPath pen: aPen 
	"Draw aPath on the receiver using aPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawPath: self asParameter
				pen: aPen asParameter
				path: aPath asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawPath failed' with: status]!

drawPie: aRectangle pen: aGdiplusPen startAngle: startAngle sweepAngle: sweepAngle 
	"Draw a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawPieI: self asParameter
				pen: aGdiplusPen asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				startAngle: startAngle
				sweepAngle: sweepAngle) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawPieI failed' with: status]!

drawPolygon: aPointsCollection pen: aPen 
	"Draw a polygon on the receiver using aPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawPolygonI: self asParameter
				pen: aPen asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size) == Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawPolygonI failed' with: status]!

drawRectangle: aRectangle
	"Draw aRectangle on the receiver."

	self drawRectangle: aRectangle pen: GdiplusPen new!

drawRectangle: aRectangle pen: aPen 
	"Draw a Rectangle on the receiver using aPen."

	| status |
	(status := GdiplusLibrary default 
				gdipDrawRectangleI: self asParameter
				pen: aPen asParameter
				x: aRectangle left asInteger
				y: aRectangle top asInteger
				width: aRectangle width asInteger
				height: aRectangle height asInteger) = Ok 
		ifFalse: [GdiplusError signal: 'GdipDrawRectangleI failed' with: status]!

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
		rect: (RECTF origin: aPoint extent: Point.Zero)
		format: aStringFormat
		brush: aBrush!

drawString: aString font: aFont rect: aRectangle format: aStringFormat brush: aBrush
	"Draw aString on the receiver inside aRectangle, using font attributes (family name, size,
	and style) specified by aFont, text format information (layout and display manipulations)
	specified by aStringFormat, and aBrush to fill the string."

	| status font format brush text |
	font := aFont ifNil: [GdiplusFont new].
	format := aStringFormat ifNil: [GdiplusStringFormat genericDefault].
	brush := aBrush ifNil: [GdiplusSolidBrush new].
	"Note that we must convert to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	(status := GdiplusLibrary default
				gdipDrawString: self asParameter
				str: text
				length: text size
				font: font asParameter
				layoutRect: (RECTF marshal: aRectangle)
				stringFormat: format asParameter
				brush: brush asParameter) == Ok
		ifFalse: [GdiplusError signal: 'GdipDrawString failed' with: status]!

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

	| status |
	(status := GdiplusLibrary default gdipEndContainer: self asParameter state: containerInteger) = Ok 
		ifFalse: [GdiplusError signal: 'GdipEndContainer  failed' with: status]!

erase
	"Clear the receiver to white."

	| status |
	(status := GdiplusLibrary default gdipGraphicsClear: self asParameter color: -1) == Ok
		ifFalse: [GdiplusError signal: 'GdipGraphicsClear failed' with: status]!

fillClosedCurve: aPointsCollection brush: aGdiplusBrush
	"Fills a closed cardinal spline on the receiver that passes through aPointsCollection using aGdiplusPen."
	| status |
	(status := GdiplusLibrary default 
				gdipFillClosedCurveI: self asParameter
				brush: aGdiplusBrush asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipFillClosedCurveI failed' with: status]!

fillEllipse: aRectangle brush: aGdiplusBrush 
	"Fill the interior of an ellipse that is bounded by aRectangle on the receiver using aGdiplusBrush."

	| status |
	(status := GdiplusLibrary default 
				gdipFillEllipseI: self asParameter
				brush: aGdiplusBrush asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipFillEllipseI failed' with: status]!

fillPath: aPath brush: aBrush 
	"Fill aPath on the receiver using a Brush."

	| status |
	(status := GdiplusLibrary default 
				gdipFillPath: self asParameter
				brush: aBrush asParameter
				path: aPath asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipFillPath failed' with: status]!

fillPie: aRectangle brush: aGdiplusBrush startAngle: startAngle sweepAngle: sweepAngle 
	"Fill a pie on the receiver in aRectangle, from startAngle with length sweepAngle, using aGdiplusBrush."

	| status |
	(status := GdiplusLibrary default 
				gdipFillPieI: self asParameter
				brush: aGdiplusBrush asParameter
				x: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				startAngle: startAngle
				sweepAngle: sweepAngle) = Ok 
		ifFalse: [GdiplusError signal: 'GdipFillPieI failed' with: status]!

fillPolygon: collectionOfPoints brush: aBrush
	"Fill the interior of a polygon on the receiver with aBrush."

	self 
		fillPolygon: collectionOfPoints
		brush: aBrush
		fillMode: nil!

fillPolygon: aPointsCollection brush: aBrush fillMode: aFillModeConstant
	"Fill the interior of a polygon on the receiver with aBrush.  aFillMode specifies how to fill a closed area
	that is within another closed area and that is created when the curve or path passes over itself."

	| status |
	(status := GdiplusLibrary default
				gdipFillPolygonI: self asParameter
				brush: aBrush asParameter
				points: (POINTLArray marshal: aPointsCollection)
				count: aPointsCollection size
				fillMode: aFillModeConstant) == Ok
		ifFalse: [GdiplusError signal: 'GdipFillPolygonI failed' with: status]!

fillRectangle: aRectangle brush: aGdiplusBrush 
	"Fill aRectangle on the receiver using a aGdiplusBrush."

	| status |
	(status := GdiplusLibrary default 
				gdipFillRectangleI: self asParameter
				brush: aGdiplusBrush asParameter
				x: aRectangle left asInteger
				y: aRectangle top asInteger
				width: aRectangle width asInteger
				height: aRectangle height asInteger) == Ok 
		ifFalse: [GdiplusError signal: 'GdipFillRectangleI failed' with: status]!

fillRectangle: aRectangle color: aColor
	| fillBrush |
	fillBrush := GdiplusSolidBrush color: aColor.
	self fillRectangle: aRectangle brush: fillBrush.
	fillBrush free!

fillRegion: aRegion brush: aBrush 
	"Fill aRegion on the receiver using aBrush."

	| status |
	(status := GdiplusLibrary default 
				gdipFillRegion: self asParameter
				brush: aBrush asParameter
				region: aRegion asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipFillRegion failed' with: status]!

getHDC
	"
	HDC GetHDC()
	    {
	        HDC     hdc = NULL;
	
	        SetStatus(DllExports::GdipGetDC(nativeGraphics, &hdc));
	
	        return hdc;
	    }"

	| status gpHandle |
	gpHandle := ExternalHandle new.
	status := GdiplusLibrary default gdipGetDC: self asParameter hdc: gpHandle.
	status = Ok ifFalse: [GdiplusError signal: 'GdipGetDC failed' with: status].
	^gpHandle!

interpolationMode
	"Answer an Integer that represents the receiver's interpolation mode (the algorithm 
	that is used when images are scaled or rotated)."

	| status interpolationMode |
	interpolationMode := SDWORD new.
	(status := GdiplusLibrary default gdipGetInterpolationMode: self asParameter
				interpolationMode: interpolationMode asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetInterpolationMode failed' with: status].
	^interpolationMode asInteger!

interpolationMode: anInterpolationModeConstant 
	"Set the receiver's interpolation mode (the algorithm that is used when images are scaled or rotated)."

	| status |
	(status := GdiplusLibrary default gdipSetInterpolationMode: self asParameter
				interpolationMode: anInterpolationModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetInterpolationMode failed' with: status]!

measureCharacterRanges: aString font: aFont rect: aRectangle format: aStringFormat
	| count regions handles utf16 status |
	count := aStringFormat measurableCharacterRangeCount.
	regions := Array new: count.
	handles := HandleArray new: count.
	1 to: count
		do: 
			[:i |
			| region |
			region := GdiplusRegion new.
			regions at: i put: region.
			handles at: i put: region asParameter].
	utf16 := aString asUtf16String.
	(status := GdiplusLibrary default
		gdipMeasureCharacterRanges: self handle
		str: utf16
		length: utf16 size
		font: aFont asParameter
		layoutRect: (RECTF marshal: aRectangle)
		stringFormat: aStringFormat asParameter
		regionCount: count
		regions: handles) == Ok ifFalse: [GdiplusError signal: 'GdipMeasureCharacterRanges failed' with: status].
	^regions!

measureString: aString font: aFont
	"Answer a Point that is the extent of aString as specified by aFont."

	^(self 
		measureString: aString
		font: aFont
		rect: RECTF new
		format: nil) extent!

measureString: aString font: aFont rect: aRectangle format: aStringFormat
	"Answer a Rectangle that is the bounds of aString inside aRectangle as specified by aFont and aStringFormat."

	| status boundRect text |
	boundRect := RECTF new.
	"Note that we must conver to UTF-16 explicitly to ensure we pass the correct string length."
	text := aString asUtf16String.
	(status := GdiplusLibrary default
				gdipMeasureString: self asParameter
				str: text
				length: text size
				font: aFont asParameter
				layoutRect: (RECTF fromRectangle: aRectangle)
				stringFormat: aStringFormat asParameter
				boundingBox: boundRect
				codepointsFitted: nil
				linesFilled: nil) == Ok
		ifFalse: [GdiplusError signal: 'GdipMeasureString failed' with: status].
	^boundRect!

pageScale
	"Answer the scaling factor currently set for the page transformation of the receiver."

	| status scale |
	scale := FLOAT new.
	(status := GdiplusLibrary default gdipGetPageScale: self asParameter scale: scale) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPageScale failed' with: status].
	^scale value!

pageScale: aRealNumber 
	"Set the scaling factor for the page transformation of the receiver to aRealNumber.
	The page transformation converts page coordinates to device coordinates."

	| status |
	(status := GdiplusLibrary default gdipSetPageScale: self asParameter scale: aRealNumber) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPageScale failed' with: status]!

pageUnit
	"Answer the unit of measure currently set for the receiver."

	| status unit |
	unit := SDWORD new.
	(status := GdiplusLibrary default gdipGetPageUnit: self asParameter unit: unit) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPageUnit failed' with: status].
	^unit value!

pageUnit: aUnitConstant 
	"Set the receiver's unit of measure."

	| status |
	(status := GdiplusLibrary default gdipSetPageUnit: self asParameter unit: aUnitConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPageUnit failed' with: status]!

pageUnitName
	"Answer the receiver's page unit as a string."

	^(self class enumsUnit detect: [:e | e value = self pageUnit]) key!

pixelOffsetMode
	| status pixelOffsetMode |
	pixelOffsetMode := SDWORD new.
	(status := GdiplusLibrary default gdipGetPixelOffsetMode: self asParameter
				pixelOffsetMode: pixelOffsetMode) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPixelOffsetMode failed' with: status].
	^pixelOffsetMode asInteger!

pixelOffsetMode: aPixelOffsetModeConstant 
	"Set the type of pixel offsetting that is applied to lines and curves."

	| status |
	(status := GdiplusLibrary default gdipSetPixelOffsetMode: self asParameter
				pixelOffsetMode: aPixelOffsetModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPixelOffsetMode failed' with: status]!

releaseHDC: anExternalHandle 
	" 
	VOID ReleaseHDC(IN HDC hdc)
	    {
	        SetStatus(DllExports::GdipReleaseDC(nativeGraphics, hdc));
	    }"

	| status |
	status := GdiplusLibrary default gdipReleaseDC: self asParameter hdc: anExternalHandle.
	status = Ok ifFalse: [GdiplusError signal: 'ReleaseHDC failed' with: status]!

resetClip
	"Set the clipping region of the receiver to an infinite region."

	| status |
	(status := GdiplusLibrary default gdipResetClip: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipResetClip failed' with: status]!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	| status |
	(status := GdiplusLibrary default gdipResetWorldTransform: self asParameter) == Ok 
		ifFalse: [GdiplusError signal: 'GdipResetWorldTransform failed' with: status]!

resolution
	"Answer a <Point> specifying the horizontal and vertical DPI of the receiver."

	| buf status dpiX |
	buf := ByteArray new: 4.
	(status := GdiplusLibrary default gdipGetDpiX: self asParameter dpi: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdpiGetDpiX failed' with: status].
	dpiX := buf floatAtOffset: 0.
	(status := GdiplusLibrary default gdipGetDpiY: self asParameter dpi: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetDpiY failed' with: status].
	^dpiX asInteger @ (buf floatAtOffset: 0) asInteger!

rotate: aRealAngle at: aPoint
	"Translate the receiver's transformation matrix by a Point and then rotate it by aRealAngle."

	self translateTransform: aPoint order: nil.
	self rotateTransform: aRealAngle order: nil!

rotateTransform: aRealAngle 
	"Rotate the receiver's transformation matrix by aRealAngle."

	self rotateTransform: aRealAngle order: MatrixOrderPrepend!

rotateTransform: aNumber order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default
				gdipRotateWorldTransform: self asParameter
				angle: aNumber asFloat
				order: aMatrixOrderConstant) = Ok
		ifFalse: [GdiplusError signal: 'GdipRotateWorldTransform failed' with: status]!

scaleTransform: aRealPoint 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix defined by aRealPoint."

	self scaleTransform: aRealPoint order: nil!

scaleTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipScaleWorldTransform: self asParameter
				sx: aRealPoint x asFloat
				sy: aRealPoint y asFloat
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipScaleWorldTransform failed' with: status]!

smoothingMode
	| status smoothingMode |
	smoothingMode := SDWORD new.
	(status := GdiplusLibrary default gdipGetSmoothingMode: self asParameter
				smoothingMode: smoothingMode) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetSmoothingMode failed' with: status].
	^smoothingMode asInteger!

smoothingMode: aSmoothingModeConstant 
	"Set the type of smoothing (antialiasing) that is applied to lines and curves."

	| status |
	(status := GdiplusLibrary default gdipSetSmoothingMode: self asParameter
				smoothingMode: aSmoothingModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetSmoothingMode failed' with: status]!

textRenderingHint: aTextRenderingHintConstant 
	"Set the text rendering mode of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetTextRenderingHint: self asParameter
				mode: aTextRenderingHintConstant) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetTextRenderingHint filed' with: status]!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| status gpHandle |
	gpHandle := GdiplusMatrix new.
	(status := GdiplusLibrary default gdipGetWorldTransform: self asParameter
				matrix: gpHandle asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetWorldTransform failed' with: status].
	^gpHandle!

transform: aGdiplusMatrix 
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetWorldTransform: self asParameter
				matrix: aGdiplusMatrix asParameter) == Ok 
		ifFalse: [GdiplusError signal: 'GdipSetWorldTransform failed' with: status]!

transformPoints: aPointsCollection destSpace: destSpace srcSpace: srcSpace
	"Convert aPointsCollection from one coordinate space to another. The conversion 
	is based on the current world and page transformations of the receiver."

	| status points count |
	points := POINTLArray marshal: aPointsCollection.
	count := points size.
	(status := GdiplusLibrary default
				gdipTransformPointsI: self asParameter
				destSpace: destSpace
				srcSpace: srcSpace
				points: points
				count: count) == Ok
		ifFalse: [GdiplusError signal: 'GdipTransformPointsI failed' with: status].
	^points!

translateTransform: aRealPoint 
	"Translate (shift) the receiver's transformation matrix by aRealPoint."

	self translateTransform: aRealPoint order: MatrixOrderPrepend!

translateTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a translation matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipTranslateWorldTransform: self asParameter
				dx: aRealPoint x
				dy: aRealPoint y
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipTranslateWorldTransform failed' with: status]! !

!GdiplusGraphics categoriesForMethods!
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
dpi!accessing!public! !
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
drawString:font:at:format:brush:!drawing-strings!public! !
drawString:font:rect:format:brush:!drawing-strings!public! !
drawString:layoutRect:!drawing-strings!public! !
endContainer:!accessing-transformations!public! !
erase!operations!public! !
fillClosedCurve:brush:!drawing-lines!public! !
fillEllipse:brush:!filling!public! !
fillPath:brush:!filling!public! !
fillPie:brush:startAngle:sweepAngle:!filling!public! !
fillPolygon:brush:!filling!public! !
fillPolygon:brush:fillMode:!filling!public! !
fillRectangle:brush:!filling!public! !
fillRectangle:color:!public! !
fillRegion:brush:!filling!public! !
getHDC!gdi interop!private! !
interpolationMode!accessing-modes!public! !
interpolationMode:!accessing-modes!public! !
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

!GdiplusGraphics class methodsFor!

fromCanvas: aCanvas
	^self fromInitializer: (GdiplusGraphicsFromHDCInitializer canvas: aCanvas)!

fromImage: aGdiplusImage
	^self fromInitializer: (GdiplusGraphicsFromImageInitializer image: aGdiplusImage)!

icon
	"Answers an Icon that can be used to represent this class"

	^Canvas icon! !

!GdiplusGraphics class categoriesForMethods!
fromCanvas:!instance creation!public! !
fromImage:!instance creation!public! !
icon!constants!development!public! !
!

