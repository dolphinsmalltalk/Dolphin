"Filed out from Dolphin Smalltalk 7"!

External.DynamicLinkLibrary subclass: #'Graphics.Gdiplus.GdiplusLibrary'
	instanceVariableNames: 'token'
	classVariableNames: ''
	imports: #(#{Graphics.Gdiplus.GdiplusConstants})
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.GdiplusLibrary guid: (Core.GUID fromString: '{de97dca0-ad17-4002-a790-a4b99480a5b8}')!
Graphics.Gdiplus.GdiplusLibrary comment: 'Gdiplus is the <ExternalLibrary> class to represent the dynamic link library, ''GDIPLUS.DLL''. It was generated from IDL built from the GDI+ header files. It contains wrapper methods for each of the methods in the GDI+ Flat API. The GDI+ class library (a set of C++ classes) sits on top of the flat API. There is very little documentation for the flat API, but the class library is, for the most part, a thin layer on top so it is easy to map between the C++ class library documentation and the corresponding flat API calls.
'!
!Graphics.Gdiplus.GdiplusLibrary categoriesForClass!External-Libraries-Win32! !
!Graphics.Gdiplus.GdiplusLibrary methodsFor!

close
	"Release the reference the receiver has to the External Library	it represents. This may
	not cause the library to be unloaded, so it may still function. Answer whether the
	library was successfully closed. We also free any standard IMalloc instances."

	handle notNull ifTrue: [self uninitialize].
	^super close!

gdipAddPathArc: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathArc() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathArc(
			PGpPath path,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathArc handle float float float float float float>
	^self invalidCall: _failureCode!

gdipAddPathArcI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathArcI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathArcI(
			PGpPath path,
			int x,
			int y,
			int Width,
			int Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathArcI handle sdword sdword sdword sdword float float>
	^self invalidCall: _failureCode!

gdipAddPathBezier: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	"Invoke the GdipAddPathBezier() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBezier(
			PGpPath path,
			REAL x1,
			REAL y1,
			REAL x2,
			REAL y2,
			REAL x3,
			REAL y3,
			REAL x4,
			REAL y4);"

	<stdcall: errno GdipAddPathBezier handle float float float float float float float float>
	^self invalidCall: _failureCode!

gdipAddPathBezierI: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	"Invoke the GdipAddPathBezierI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBezierI(
			PGpPath path,
			int x1,
			int y1,
			int x2,
			int y2,
			int x3,
			int y3,
			int x4,
			int y4);"

	<stdcall: errno GdipAddPathBezierI handle sdword sdword sdword sdword sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipAddPathBeziers: path points: points count: count
	"Invoke the GdipAddPathBeziers() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBeziers(
			PGpPath path,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipAddPathBeziers handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathBeziersI: path points: points count: count
	"Invoke the GdipAddPathBeziersI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBeziersI(
			PGpPath path,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipAddPathBeziersI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve: path points: points count: count
	"Invoke the GdipAddPathClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve(
			PGpPath path,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipAddPathClosedCurve handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve2: path points: points count: count tension: tension
	"Invoke the GdipAddPathClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve2(
			PGpPath path,
			[in]GpPointF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathClosedCurve2 handle POINTF* sdword float>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve2I: path points: points count: count tension: tension
	"Invoke the GdipAddPathClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve2I(
			PGpPath path,
			[in]GpPoint* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathClosedCurve2I handle POINTL* sdword float>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurveI: path points: points count: count
	"Invoke the GdipAddPathClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurveI(
			PGpPath path,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipAddPathClosedCurveI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathCurve: path points: points count: count
	"Invoke the GdipAddPathCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve(
			PGpPath path,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipAddPathCurve handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathCurve2: path points: points count: count tension: tension
	"Invoke the GdipAddPathCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve2(
			PGpPath path,
			[in]GpPointF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve2 handle POINTF* sdword float>
	^self invalidCall: _failureCode!

gdipAddPathCurve2I: path points: points count: count tension: tension
	"Invoke the GdipAddPathCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve2I(
			PGpPath path,
			[in]GpPoint* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve2I handle POINTL* sdword float>
	^self invalidCall: _failureCode!

gdipAddPathCurve3: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipAddPathCurve3() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve3(
			PGpPath path,
			[in]GpPointF* Points,
			int Count,
			int offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve3 handle POINTF* sdword sdword sdword float>
	^self invalidCall: _failureCode!

gdipAddPathCurve3I: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipAddPathCurve3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve3I(
			PGpPath path,
			[in]GpPoint* Points,
			int Count,
			int offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve3I handle POINTL* sdword sdword sdword float>
	^self invalidCall: _failureCode!

gdipAddPathCurveI: path points: points count: count
	"Invoke the GdipAddPathCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurveI(
			PGpPath path,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipAddPathCurveI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathEllipse: path x: x y: y width: width height: height
	"Invoke the GdipAddPathEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathEllipse(
			PGpPath path,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipAddPathEllipse handle float float float float>
	^self invalidCall: _failureCode!

gdipAddPathEllipseI: path x: x y: y width: width height: height
	"Invoke the GdipAddPathEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathEllipseI(
			PGpPath path,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipAddPathEllipseI handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipAddPathLine: path x1: x1 y1: y1 x2: x2 y2: y2
	"Invoke the GdipAddPathLine() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLine(
			PGpPath path,
			REAL x1,
			REAL y1,
			REAL x2,
			REAL y2);"

	<stdcall: errno GdipAddPathLine handle float float float float>
	^self invalidCall: _failureCode!

gdipAddPathLine2: path points: points count: count
	"Invoke the GdipAddPathLine2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLine2(
			PGpPath path,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipAddPathLine2 handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathLine2I: path points: points count: count
	"Invoke the GdipAddPathLine2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLine2I(
			PGpPath path,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipAddPathLine2I handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathLineI: path x1: x1 y1: y1 x2: x2 y2: y2
	"Invoke the GdipAddPathLineI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLineI(
			PGpPath path,
			int x1,
			int y1,
			int x2,
			int y2);"

	<stdcall: errno GdipAddPathLineI handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipAddPathPath: path addingPath: addingPath connect: connect
	"Invoke the GdipAddPathPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPath(
			PGpPath path,
			[in]PGpPath addingPath,
			long connect);"

	<stdcall: errno GdipAddPathPath handle handle sdword>
	^self invalidCall: _failureCode!

gdipAddPathPie: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathPie() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPie(
			PGpPath path,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathPie handle float float float float float float>
	^self invalidCall: _failureCode!

gdipAddPathPieI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathPieI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPieI(
			PGpPath path,
			int x,
			int y,
			int Width,
			int Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathPieI handle sdword sdword sdword sdword float float>
	^self invalidCall: _failureCode!

gdipAddPathPolygon: path points: points count: count
	"Invoke the GdipAddPathPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPolygon(
			PGpPath path,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipAddPathPolygon handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathPolygonI: path points: points count: count
	"Invoke the GdipAddPathPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPolygonI(
			PGpPath path,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipAddPathPolygonI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathRectangle: path x: x y: y width: width height: height
	"Invoke the GdipAddPathRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangle(
			PGpPath path,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipAddPathRectangle handle float float float float>
	^self invalidCall: _failureCode!

gdipAddPathRectangleI: path x: x y: y width: width height: height
	"Invoke the GdipAddPathRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangleI(
			PGpPath path,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipAddPathRectangleI handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipAddPathRectangles: path rects: rects count: count
	"Invoke the GdipAddPathRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangles(
			PGpPath path,
			[in]GpRectF* rects,
			int Count);"

	<stdcall: errno GdipAddPathRectangles handle RECTF* sdword>
	^self invalidCall: _failureCode!

gdipAddPathRectanglesI: path rects: rects count: count
	"Invoke the GdipAddPathRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectanglesI(
			PGpPath path,
			[in]GpRect* rects,
			int Count);"

	<stdcall: errno GdipAddPathRectanglesI handle RECTL* sdword>
	^self invalidCall: _failureCode!

gdipAddPathString: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format
	"Invoke the GdipAddPathString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathString(
			PGpPath path,
			[in]LPWSTR string,
			int length,
			[in]PGpFontFamily family,
			int style,
			REAL emSize,
			[in]RECTF* layoutRect,
			[in]PGpStringFormat format);"

	<stdcall: errno GdipAddPathString handle lpwstr sdword handle sdword float RECTF* handle>
	^self invalidCall: _failureCode!

gdipAddPathStringI: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format
	"Invoke the GdipAddPathStringI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathStringI(
			PGpPath path,
			[in]LPWSTR string,
			int length,
			[in]PGpFontFamily family,
			int style,
			REAL emSize,
			[in]RECTL* layoutRect,
			[in]PGpStringFormat format);"

	<stdcall: errno GdipAddPathStringI handle lpwstr sdword handle sdword float RECTL* handle>
	^self invalidCall: _failureCode!

gdipBeginContainer: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	"Invoke the GdipBeginContainer() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainer(
			PGpGraphics graphics,
			[in]GpRectF* dstrect,
			[in]GpRectF* srcRect,
			GpUnit Unit,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainer handle RECTF* RECTF* sdword dword*>
	^self invalidCall: _failureCode!

gdipBeginContainer2: graphics state: state
	"Invoke the GdipBeginContainer2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainer2(
			PGpGraphics graphics,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainer2 handle dword*>
	^self invalidCall: _failureCode!

gdipBeginContainerI: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	"Invoke the GdipBeginContainerI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainerI(
			PGpGraphics graphics,
			[in]GpRect* dstrect,
			[in]GpRect* srcRect,
			GpUnit Unit,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainerI handle RECTL* RECTL* sdword dword*>
	^self invalidCall: _failureCode!

gdipBitmapGetPixel: bitmap x: x y: y color: color
	"Invoke the GdipBitmapGetPixel() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapGetPixel(
			[in]PGpBitmap bitmap,
			[in]int x,
			[in]int y,
			[out, retval]ARGB* Color);"

	<stdcall: errno GdipBitmapGetPixel handle sdword sdword dword*>
	^self invalidCall: _failureCode!

gdipBitmapLockBits: bitmap rect: rect flags: flags format: format lockedBitmapData: lockedBitmapData
	"Invoke the GdipBitmapLockBits() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapLockBits(
			[in]PGpBitmap bitmap,
			[in]GpRect* rect,
			[in]unsigned int Flags,
			[in]PixelFormat format,
			[out, retval]BitmapData* lockedBitmapData);"

	<stdcall: errno GdipBitmapLockBits handle RECTL* dword sdword GpBitmapData*>
	^self invalidCall: _failureCode!

gdipBitmapSetPixel: bitmap x: x y: y color: color
	"Invoke the GdipBitmapSetPixel() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapSetPixel(
			[in]PGpBitmap bitmap,
			[in]int x,
			[in]int y,
			[in]ARGB Color);"

	<stdcall: errno GdipBitmapSetPixel handle sdword sdword dword>
	^self invalidCall: _failureCode!

gdipBitmapSetResolution: bitmap xdpi: xdpi ydpi: ydpi
	"Invoke the GdipBitmapSetResolution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapSetResolution(
			[in]PGpBitmap bitmap,
			[in]REAL xdpi,
			[in]REAL ydpi);"

	<stdcall: errno GdipBitmapSetResolution handle float float>
	^self invalidCall: _failureCode!

gdipBitmapUnlockBits: bitmap lockedBitmapData: lockedBitmapData
	"Invoke the GdipBitmapUnlockBits() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapUnlockBits(
			[in]PGpBitmap bitmap,
			[in]BitmapData* lockedBitmapData);"

	<stdcall: errno GdipBitmapUnlockBits handle GpBitmapData*>
	^self invalidCall: _failureCode!

gdipClearPathMarkers: path
	"Invoke the GdipClearPathMarkers() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipClearPathMarkers(
			PGpPath path);"

	<stdcall: errno GdipClearPathMarkers handle>
	^self invalidCall: _failureCode!

gdipCloneBitmapArea: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap
	"Invoke the GdipCloneBitmapArea() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneBitmapArea(
			[in]REAL x,
			[in]REAL y,
			[in]REAL Width,
			[in]REAL Height,
			[in]PixelFormat format,
			[in]PGpBitmap srcBitmap,
			[out, retval]PGpBitmap* dstBitmap);"

	<stdcall: errno GdipCloneBitmapArea float float float float sdword handle handle*>
	^self invalidCall: _failureCode!

gdipCloneBitmapAreaI: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap
	"Invoke the GdipCloneBitmapAreaI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneBitmapAreaI(
			[in]int x,
			[in]int y,
			[in]int Width,
			[in]int Height,
			[in]PixelFormat format,
			[in]PGpBitmap srcBitmap,
			[out, retval]PGpBitmap* dstBitmap);"

	<stdcall: errno GdipCloneBitmapAreaI sdword sdword sdword sdword sdword handle handle*>
	^self invalidCall: _failureCode!

gdipCloneBrush: brush cloneBrush: cloneBrush
	"Invoke the GdipCloneBrush() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneBrush(
			PGpBrush brush,
			[out, retval]PGpBrush* cloneBrush);"

	<stdcall: errno GdipCloneBrush handle handle*>
	^self invalidCall: _failureCode!

gdipCloneCustomLineCap: customCap clonedCap: clonedCap
	"Invoke the GdipCloneCustomLineCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneCustomLineCap(
			PGpCustomLineCap customCap,
			[out, retval]PGpCustomLineCap* clonedCap);"

	<stdcall: errno GdipCloneCustomLineCap handle handle*>
	^self invalidCall: _failureCode!

gdipCloneFont: font cloneFont: cloneFont
	"Invoke the GdipCloneFont() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneFont(
			PGpFont font,
			[out, retval]PGpFont* cloneFont);"

	<stdcall: errno GdipCloneFont handle handle*>
	^self invalidCall: _failureCode!

gdipCloneFontFamily: fontFamily clonedFontFamily: clonedFontFamily
	"Invoke the GdipCloneFontFamily() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneFontFamily(
			PGpFontFamily FontFamily,
			[out, retval]PGpFontFamily* clonedFontFamily);"

	<stdcall: errno GdipCloneFontFamily handle handle*>
	^self invalidCall: _failureCode!

gdipCloneImage: image cloneImage: cloneImage
	"Invoke the GdipCloneImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneImage(
			[in]PGpImage image,
			[out, retval]PGpImage* cloneImage);"

	<stdcall: errno GdipCloneImage handle handle*>
	^self invalidCall: _failureCode!

gdipCloneImageAttributes: imageattr cloneImageattr: cloneImageattr
	"Invoke the GdipCloneImageAttributes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneImageAttributes(
			[in]PGpImageAttributes imageattr,
			[out, retval]PGpImageAttributes* cloneImageattr);"

	<stdcall: errno GdipCloneImageAttributes handle handle*>
	^self invalidCall: _failureCode!

gdipCloneMatrix: matrix cloneMatrix: cloneMatrix
	"Invoke the GdipCloneMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneMatrix(
			PGpMatrix matrix,
			[out, retval]PGpMatrix* cloneMatrix);"

	<stdcall: errno GdipCloneMatrix handle handle*>
	^self invalidCall: _failureCode!

gdipClonePath: path clonePath: clonePath
	"Invoke the GdipClonePath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipClonePath(
			PGpPath path,
			[out, retval]PGpPath* clonePath);"

	<stdcall: errno GdipClonePath handle handle*>
	^self invalidCall: _failureCode!

gdipClonePen: pen clonepen: clonepen
	"Invoke the GdipClonePen() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipClonePen(
			PGpPen pen,
			[out, retval]PGpPen* clonepen);"

	<stdcall: errno GdipClonePen handle handle*>
	^self invalidCall: _failureCode!

gdipCloneRegion: region cloneRegion: cloneRegion
	"Invoke the GdipCloneRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneRegion(
			PGpRegion region,
			[out, retval]PGpRegion* cloneRegion);"

	<stdcall: errno GdipCloneRegion handle handle*>
	^self invalidCall: _failureCode!

gdipCloneStringFormat: format newFormat: newFormat
	"Invoke the GdipCloneStringFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneStringFormat(
			[in]PGpStringFormat format,
			[out, retval]PGpStringFormat* newFormat);"

	<stdcall: errno GdipCloneStringFormat handle handle*>
	^self invalidCall: _failureCode!

gdipClosePathFigure: path
	"Invoke the GdipClosePathFigure() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipClosePathFigure(
			PGpPath path);"

	<stdcall: errno GdipClosePathFigure handle>
	^self invalidCall: _failureCode!

gdipClosePathFigures: path
	"Invoke the GdipClosePathFigures() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipClosePathFigures(
			PGpPath path);"

	<stdcall: errno GdipClosePathFigures handle>
	^self invalidCall: _failureCode!

gdipCombineRegionPath: region path: path combineMode: combineMode
	"Invoke the GdipCombineRegionPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionPath(
			PGpRegion region,
			PGpPath path,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionPath handle handle sdword>
	^self invalidCall: _failureCode!

gdipCombineRegionRect: region rect: rect combineMode: combineMode
	"Invoke the GdipCombineRegionRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRect(
			PGpRegion region,
			[in]GpRectF* rect,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRect handle RECTF* sdword>
	^self invalidCall: _failureCode!

gdipCombineRegionRectI: region rect: rect combineMode: combineMode
	"Invoke the GdipCombineRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRectI(
			PGpRegion region,
			[in]GpRect* rect,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRectI handle RECTL* sdword>
	^self invalidCall: _failureCode!

gdipCombineRegionRegion: region region2: region2 combineMode: combineMode
	"Invoke the GdipCombineRegionRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRegion(
			PGpRegion region,
			PGpRegion region2,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRegion handle handle sdword>
	^self invalidCall: _failureCode!

gdipComment: graphics sizeData: sizeData data: data
	"Invoke the GdipComment() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipComment(
			PGpGraphics graphics,
			unsigned int sizeData,
			[in]BYTE* data);"

	<stdcall: errno GdipComment handle dword byte*>
	^self invalidCall: _failureCode!

gdipCreateAdjustableArrowCap: height width: width isFilled: isFilled cap: cap
	"Invoke the GdipCreateAdjustableArrowCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateAdjustableArrowCap(
			REAL Height,
			REAL Width,
			long isFilled,
			[out, retval]PGpAdjustableArrowCap* cap);"

	<stdcall: errno GdipCreateAdjustableArrowCap float float sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromDirectDrawSurface: surface bitmap: bitmap
	"Invoke the GdipCreateBitmapFromDirectDrawSurface() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromDirectDrawSurface(
			[in]IDirectDrawSurface7* surface,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromDirectDrawSurface void** handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromFile: filename bitmap: bitmap
	"Invoke the GdipCreateBitmapFromFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromFile(
			[in]LPWSTR filename,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromFile lpwstr handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromFileICM: filename bitmap: bitmap
	"Invoke the GdipCreateBitmapFromFileICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromFileICM(
			[in]LPWSTR filename,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromFileICM lpwstr handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromGdiDib: gdiBitmapInfo gdiBitmapData: gdiBitmapData bitmap: bitmap
	"Invoke the GdipCreateBitmapFromGdiDib() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromGdiDib(
			[in]BITMAPINFO* gdiBitmapInfo,
			[in]VOID* gdiBitmapData,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromGdiDib void* void* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromGraphics: width height: height target: target bitmap: bitmap
	"Invoke the GdipCreateBitmapFromGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromGraphics(
			[in]int Width,
			[in]int Height,
			[in]PGpGraphics target,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromGraphics sdword sdword handle handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap
	"Invoke the GdipCreateBitmapFromHBITMAP() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromHBITMAP(
			[in]HBITMAP hbm,
			[in]HPALETTE hpal,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromHBITMAP handle handle handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromHICON: hicon bitmap: bitmap
	"Invoke the GdipCreateBitmapFromHICON() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromHICON(
			[in]HICON HICON,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromHICON handle handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromResource: hInstance lpBitmapName: lpBitmapName bitmap: bitmap
	"Invoke the GdipCreateBitmapFromResource() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromResource(
			[in]void* hInstance,
			[in]LPWSTR lpBitmapName,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromResource void* lpwstr handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromScan0: width height: height stride: stride format: format scan0: scan0 bitmap: bitmap
	"Invoke the GdipCreateBitmapFromScan0() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromScan0(
			[in]int Width,
			[in]int Height,
			[in]int Stride,
			[in]PixelFormat format,
			[in]BYTE* Scan0,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromScan0 sdword sdword sdword sdword byte* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromStream: stream bitmap: bitmap
	"Invoke the GdipCreateBitmapFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromStream(
			[in]IStream* stream,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromStream COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromStreamICM: stream bitmap: bitmap
	"Invoke the GdipCreateBitmapFromStreamICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromStreamICM(
			[in]IStream* stream,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromStreamICM COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateCachedBitmap: bitmap graphics: graphics cachedBitmap: cachedBitmap
	"Invoke the GdipCreateCachedBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateCachedBitmap(
			PGpBitmap bitmap,
			PGpGraphics graphics,
			[out, retval]GpCachedBitmap** cachedBitmap);"

	<stdcall: errno GdipCreateCachedBitmap handle handle handle**>
	^self invalidCall: _failureCode!

gdipCreateCustomLineCap: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset customCap: customCap
	"Invoke the GdipCreateCustomLineCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateCustomLineCap(
			PGpPath fillPath,
			PGpPath strokePath,
			GpLineCap baseCap,
			REAL baseInset,
			[out, retval]PGpCustomLineCap* customCap);"

	<stdcall: errno GdipCreateCustomLineCap handle handle sdword float handle*>
	^self invalidCall: _failureCode!

gdipCreateFont: fontFamily emSize: emSize style: style unit: unit font: font
	"Invoke the GdipCreateFont() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFont(
			[in]PGpFontFamily FontFamily,
			REAL emSize,
			int style,
			Unit Unit,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFont handle float sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFamilyFromName: name fontCollection: fontCollection fontFamily: fontFamily
	"Invoke the GdipCreateFontFamilyFromName() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFamilyFromName(
			[in]LPWSTR name,
			[in]PGpFontCollection fontCollection,
			[out, retval]PGpFontFamily* FontFamily);"

	<stdcall: sdword GdipCreateFontFamilyFromName lpwstr handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFromDC: hdc font: font
	"Invoke the GdipCreateFontFromDC() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFromDC(
			HDC HDC,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFontFromDC handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFromLogfontA: hdc logfont: logfont font: font
	"Invoke the GdipCreateFontFromLogfontA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFromLogfontA(
			HDC HDC,
			[in]LOGFONTA* LOGFONT,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFontFromLogfontA handle LOGFONT* handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFromLogfontW: hdc logfont: logfont font: font
	"Invoke the GdipCreateFontFromLogfontA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFromLogfontA(
			HDC HDC,
			[in]LOGFONTW* LOGFONT,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFontFromLogfontA handle LOGFONTW* handle*>
	^self invalidCall: _failureCode!

gdipCreateFromHDC: hdc graphics: graphics
	"Invoke the GdipCreateFromHDC() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFromHDC(
			HDC HDC,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipCreateFromHDC handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFromHDC2: hdc hDevice: hDevice graphics: graphics
	"Invoke the GdipCreateFromHDC2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFromHDC2(
			HDC HDC,
			void* hDevice,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipCreateFromHDC2 handle void* handle*>
	^self invalidCall: _failureCode!

gdipCreateFromHWND: hwnd graphics: graphics
	"Invoke the GdipCreateFromHWND() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFromHWND(
			HWND HWND,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipCreateFromHWND handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFromHWNDICM: hwnd graphics: graphics
	"Invoke the GdipCreateFromHWNDICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFromHWNDICM(
			HWND HWND,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipCreateFromHWNDICM handle handle*>
	^self invalidCall: _failureCode!

gdipCreateHalftonePalette
	"Invoke the GdipCreateHalftonePalette() function of the module wrapped by the receiver.
	Helpstring: Creates the Win9x Halftone Palette (even on NT) with correct Desktop colors

		HPALETTE __stdcall GdipCreateHalftonePalette();"

	<stdcall: handle GdipCreateHalftonePalette>
	^self invalidCall: _failureCode!

gdipCreateHatchBrush: hatchStyle forecol: forecol backcol: backcol brush: brush
	"Invoke the GdipCreateHatchBrush() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateHatchBrush(
			GpHatchStyle HatchStyle,
			ARGB forecol,
			ARGB backcol,
			[out, retval]PGpHatch* brush);"

	<stdcall: errno GdipCreateHatchBrush sdword dword dword handle*>
	^self invalidCall: _failureCode!

gdipCreateHBITMAPFromBitmap: bitmap hbmReturn: hbmReturn background: background
	"Invoke the GdipCreateHBITMAPFromBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateHBITMAPFromBitmap(
			[in]PGpBitmap bitmap,
			[out]HBITMAP* hbmReturn,
			[in]ARGB background);"

	<stdcall: errno GdipCreateHBITMAPFromBitmap handle handle* dword>
	^self invalidCall: _failureCode!

gdipCreateHICONFromBitmap: bitmap hbmReturn: hbmReturn
	"Invoke the GdipCreateHICONFromBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateHICONFromBitmap(
			[in]PGpBitmap bitmap,
			[out, retval]HICON* hbmReturn);"

	<stdcall: errno GdipCreateHICONFromBitmap handle handle*>
	^self invalidCall: _failureCode!

gdipCreateImageAttributes: imageattr
	"Invoke the GdipCreateImageAttributes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateImageAttributes(
			[out, retval]PGpImageAttributes* imageattr);"

	<stdcall: errno GdipCreateImageAttributes handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrush: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrush() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrush(
			[in]GpPointF* point1,
			[in]GpPointF* point2,
			[in]ARGB color1,
			[in]ARGB color2,
			[in]GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrush POINTF* POINTF* dword dword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRect: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRect(
			[in]GpRectF* rect,
			ARGB color1,
			ARGB color2,
			LinearGradientMode mode,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRect RECTF* dword dword sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectI(
			[in]GpRect* rect,
			ARGB color1,
			ARGB color2,
			LinearGradientMode mode,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectI RECTL* dword dword sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectWithAngle: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectWithAngle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectWithAngle(
			[in]GpRectF* rect,
			ARGB color1,
			ARGB color2,
			REAL angle,
			long isAngleScalable,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectWithAngle RECTF* dword dword float sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectWithAngleI: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectWithAngleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectWithAngleI(
			[in]GpRect* rect,
			ARGB color1,
			ARGB color2,
			REAL angle,
			long isAngleScalable,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectWithAngleI RECTL* dword dword float sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushI: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushI(
			[in]GpPoint* point1,
			[in]GpPoint* point2,
			ARGB color1,
			ARGB color2,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushI POINTL* POINTL* dword dword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateMatrix: matrix
	"Invoke the GdipCreateMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMatrix(
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix handle*>
	^self invalidCall: _failureCode!

gdipCreateMatrix2: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy matrix: matrix
	"Invoke the GdipCreateMatrix2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMatrix2(
			REAL m11,
			REAL m12,
			REAL m21,
			REAL m22,
			REAL dx,
			REAL dy,
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix2 float float float float float float handle*>
	^self invalidCall: _failureCode!

gdipCreateMatrix3: rect dstplg: dstplg matrix: matrix
	"Invoke the GdipCreateMatrix3() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMatrix3(
			[in]GpRectF* rect,
			[in]GpPointF* dstplg,
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix3 RECTF* POINTF* handle*>
	^self invalidCall: _failureCode!

gdipCreateMatrix3I: rect dstplg: dstplg matrix: matrix
	"Invoke the GdipCreateMatrix3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMatrix3I(
			[in]GpRect* rect,
			[in]GpPoint* dstplg,
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix3I RECTL* POINTL* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromEmf: hEmf deleteEmf: deleteEmf metafile: metafile
	"Invoke the GdipCreateMetafileFromEmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromEmf(
			HENHMETAFILE hEmf,
			long deleteEmf,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromEmf handle sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromFile: file metafile: metafile
	"Invoke the GdipCreateMetafileFromFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromFile(
			[in]LPWSTR file,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromFile lpwstr handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromStream: stream metafile: metafile
	"Invoke the GdipCreateMetafileFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromStream(
			IStream* stream,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromStream COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromWmf: hWmf deleteWmf: deleteWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	"Invoke the GdipCreateMetafileFromWmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromWmf(
			HMETAFILE hWmf,
			long deleteWmf,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromWmf handle sdword GpWmfPlaceableFileHeader* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromWmfFile: file wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	"Invoke the GdipCreateMetafileFromWmfFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromWmfFile(
			[in]LPWSTR file,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromWmfFile lpwstr GpWmfPlaceableFileHeader* handle*>
	^self invalidCall: _failureCode!

gdipCreatePath: brushMode path: path
	"Invoke the GdipCreatePath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath(
			GpFillMode brushMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePath2: points types: types count: count fillMode: fillMode path: path
	"Invoke the GdipCreatePath2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath2(
			[in]GpPointF* Points,
			[in]BYTE* Types,
			int Count,
			GpFillMode FillMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath2 POINTF* byte* sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePath2I: points types: types count: count fillMode: fillMode path: path
	"Invoke the GdipCreatePath2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath2I(
			[in]GpPoint* Points,
			[in]BYTE* Types,
			int Count,
			GpFillMode FillMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath2I POINTL* byte* sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePathGradient: points count: count wrapMode: wrapMode polyGradient: polyGradient
	"Invoke the GdipCreatePathGradient() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePathGradient(
			[in]GpPointF* Points,
			int Count,
			GpWrapMode WrapMode,
			[out, retval]PGpPathGradient* polyGradient);"

	<stdcall: errno GdipCreatePathGradient POINTF* sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePathGradientFromPath: path polyGradient: polyGradient
	"Invoke the GdipCreatePathGradientFromPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePathGradientFromPath(
			[in]PGpPath path,
			[out, retval]PGpPathGradient* polyGradient);"

	<stdcall: errno GdipCreatePathGradientFromPath handle handle*>
	^self invalidCall: _failureCode!

gdipCreatePathGradientI: points count: count wrapMode: wrapMode polyGradient: polyGradient
	"Invoke the GdipCreatePathGradientI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePathGradientI(
			[in]GpPoint* Points,
			int Count,
			GpWrapMode WrapMode,
			[out, retval]PGpPathGradient* polyGradient);"

	<stdcall: errno GdipCreatePathGradientI POINTL* sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePathIter: iterator path: path
	"Invoke the GdipCreatePathIter() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePathIter(
			[out]PGpPathIterator* iterator,
			[in]PGpPath path);"

	<stdcall: errno GdipCreatePathIter handle* handle>
	^self invalidCall: _failureCode!

gdipCreatePen1: color width: width unit: unit pen: pen
	"Invoke the GdipCreatePen1() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePen1(
			ARGB Color,
			REAL Width,
			GpUnit Unit,
			[out, retval]PGpPen* pen);"

	<stdcall: errno GdipCreatePen1 dword float sdword handle*>
	^self invalidCall: _failureCode!

gdipCreatePen2: brush width: width unit: unit pen: pen
	"Invoke the GdipCreatePen2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePen2(
			PGpBrush brush,
			REAL Width,
			GpUnit Unit,
			[out, retval]PGpPen* pen);"

	<stdcall: errno GdipCreatePen2 handle float sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateRegion: region
	"Invoke the GdipCreateRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegion(
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegion handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionHrgn: hRgn region: region
	"Invoke the GdipCreateRegionHrgn() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionHrgn(
			void* hRgn,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionHrgn void* handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionPath: path region: region
	"Invoke the GdipCreateRegionPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionPath(
			PGpPath path,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionPath handle handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionRect: rect region: region
	"Invoke the GdipCreateRegionRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionRect(
			[in]GpRectF* rect,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRect RECTF* handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionRectI: rect region: region
	"Invoke the GdipCreateRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionRectI(
			[in]GpRect* rect,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRectI RECTL* handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionRgnData: regionData size: size region: region
	"Invoke the GdipCreateRegionRgnData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionRgnData(
			[in]BYTE* regionData,
			int size,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRgnData byte* sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateSolidFill: color brush: brush
	"Invoke the GdipCreateSolidFill() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateSolidFill(
			[in]ARGB Color,
			[out, retval]PGpSolidFill* brush);"

	<stdcall: errno GdipCreateSolidFill dword handle*>
	^self invalidCall: _failureCode!

gdipCreateStreamOnFile: filename access: access stream: stream
	"Invoke the GdipCreateStreamOnFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateStreamOnFile(
			[in]LPWSTR filename,
			unsigned int access,
			[out, retval]IStream** stream);"

	<stdcall: errno GdipCreateStreamOnFile lpwstr dword COM.IStream**>
	^self invalidCall: _failureCode!

gdipCreateStringFormat: formatAttributes language: language format: format
	"Invoke the GdipCreateStringFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateStringFormat(
			int formatAttributes,
			LANGID language,
			[out, retval]PGpStringFormat* format);"

	<stdcall: errno GdipCreateStringFormat sdword word handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture: image wrapMode: wrapMode texture: texture
	"Invoke the GdipCreateTexture() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture handle sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture2: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTexture2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture2(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[in]REAL x,
			[in]REAL y,
			[in]REAL Width,
			[in]REAL Height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture2 handle sdword float float float float handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture2I: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTexture2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture2I(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[in]int x,
			[in]int y,
			[in]int Width,
			[in]int Height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture2I handle sdword sdword sdword sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipCreateTextureIA: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTextureIA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTextureIA(
			[in]PGpImage image,
			[in]PGpImageAttributes imageAttributes,
			[in]REAL x,
			[in]REAL y,
			[in]REAL Width,
			[in]REAL Height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTextureIA handle handle float float float float handle*>
	^self invalidCall: _failureCode!

gdipCreateTextureIAI: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTextureIAI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTextureIAI(
			[in]PGpImage image,
			[in]PGpImageAttributes imageAttributes,
			[in]int x,
			[in]int y,
			[in]int Width,
			[in]int Height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTextureIAI handle handle sdword sdword sdword sdword handle*>
	^self invalidCall: _failureCode!

gdipDeleteBrush: brush
	"Invoke the GdipDeleteBrush() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteBrush(
			PGpBrush brush);"

	<stdcall: sdword GdipDeleteBrush handle>
	^self invalidCall: _failureCode!

gdipDeleteCachedBitmap: cachedBitmap
	"Invoke the GdipDeleteCachedBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteCachedBitmap(
			GpCachedBitmap* cachedBitmap);"

	<stdcall: sdword GdipDeleteCachedBitmap handle*>
	^self invalidCall: _failureCode!

gdipDeleteCustomLineCap: customCap
	"Invoke the GdipDeleteCustomLineCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteCustomLineCap(
			PGpCustomLineCap customCap);"

	<stdcall: sdword GdipDeleteCustomLineCap handle>
	^self invalidCall: _failureCode!

gdipDeleteFont: font
	"Invoke the GdipDeleteFont() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteFont(
			PGpFont font);"

	<stdcall: sdword GdipDeleteFont handle>
	^self invalidCall: _failureCode!

gdipDeleteFontFamily: fontFamily
	"Invoke the GdipDeleteFontFamily() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteFontFamily(
			PGpFontFamily FontFamily);"

	<stdcall: sdword GdipDeleteFontFamily handle>
	^self invalidCall: _failureCode!

gdipDeleteGraphics: graphics
	"Invoke the GdipDeleteGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteGraphics(
			PGpGraphics graphics);"

	<stdcall: sdword GdipDeleteGraphics handle>
	^self invalidCall: _failureCode!

gdipDeleteMatrix: matrix
	"Invoke the GdipDeleteMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteMatrix(
			PGpMatrix matrix);"

	<stdcall: sdword GdipDeleteMatrix handle>
	^self invalidCall: _failureCode!

gdipDeletePath: path
	"Invoke the GdipDeletePath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeletePath(
			PGpPath path);"

	<stdcall: sdword GdipDeletePath handle>
	^self invalidCall: _failureCode!

gdipDeletePathIter: iterator
	"Invoke the GdipDeletePathIter() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeletePathIter(
			[in]PGpPathIterator iterator);"

	<stdcall: errno GdipDeletePathIter handle>
	^self invalidCall: _failureCode!

gdipDeletePen: pen
	"Invoke the GdipDeletePen() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeletePen(
			PGpPen pen);"

	<stdcall: sdword GdipDeletePen handle>
	^self invalidCall: _failureCode!

gdipDeletePrivateFontCollection: fontCollection
	"Invoke the GdipDeletePrivateFontCollection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeletePrivateFontCollection(
			[out, retval]PGpFontCollection* fontCollection);"

	<stdcall: errno GdipDeletePrivateFontCollection handle*>
	^self invalidCall: _failureCode!

gdipDeleteRegion: region
	"Invoke the GdipDeleteRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteRegion(
			PGpRegion region);"

	<stdcall: sdword GdipDeleteRegion handle>
	^self invalidCall: _failureCode!

gdipDeleteStringFormat: format
	"Invoke the GdipDeleteStringFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDeleteStringFormat(
			PGpStringFormat format);"

	<stdcall: sdword GdipDeleteStringFormat handle>
	^self invalidCall: _failureCode!

gdipDisposeImage: image
	"Invoke the GdipDisposeImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDisposeImage(
			[in]PGpImage image);"

	<stdcall: sdword GdipDisposeImage handle>
	^self invalidCall: _failureCode!

gdipDisposeImageAttributes: imageattr
	"Invoke the GdipDisposeImageAttributes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDisposeImageAttributes(
			PGpImageAttributes imageattr);"

	<stdcall: sdword GdipDisposeImageAttributes handle>
	^self invalidCall: _failureCode!

gdipDrawArc: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipDrawArc() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawArc(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawArc handle handle float float float float float float>
	^self invalidCall: _failureCode!

gdipDrawArcI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipDrawArcI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawArcI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int Width,
			int Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawArcI handle handle sdword sdword sdword sdword float float>
	^self invalidCall: _failureCode!

gdipDrawBezier: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	"Invoke the GdipDrawBezier() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBezier(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x1,
			REAL y1,
			REAL x2,
			REAL y2,
			REAL x3,
			REAL y3,
			REAL x4,
			REAL y4);"

	<stdcall: errno GdipDrawBezier handle handle float float float float float float float float>
	^self invalidCall: _failureCode!

gdipDrawBezierI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	"Invoke the GdipDrawBezierI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBezierI(
			PGpGraphics graphics,
			PGpPen pen,
			int x1,
			int y1,
			int x2,
			int y2,
			int x3,
			int y3,
			int x4,
			int y4);"

	<stdcall: errno GdipDrawBezierI handle handle sdword sdword sdword sdword sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawBeziers: graphics pen: pen points: points count: count
	"Invoke the GdipDrawBeziers() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBeziers(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipDrawBeziers handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawBeziersI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawBeziersI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBeziersI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipDrawBeziersI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawCachedBitmap: graphics cachedBitmap: cachedBitmap x: x y: y
	"Invoke the GdipDrawCachedBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCachedBitmap(
			PGpGraphics graphics,
			GpCachedBitmap* cachedBitmap,
			int x,
			int y);"

	<stdcall: errno GdipDrawCachedBitmap handle handle* sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve: graphics pen: pen points: points count: count
	"Invoke the GdipDrawClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipDrawClosedCurve handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve2: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve2(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawClosedCurve2 handle handle POINTF* sdword float>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve2I: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve2I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawClosedCurve2I handle handle POINTL* sdword float>
	^self invalidCall: _failureCode!

gdipDrawClosedCurveI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurveI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipDrawClosedCurveI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawCurve: graphics pen: pen points: points count: count
	"Invoke the GdipDrawCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipDrawCurve handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawCurve2: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve2(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawCurve2 handle handle POINTF* sdword float>
	^self invalidCall: _failureCode!

gdipDrawCurve2I: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve2I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawCurve2I handle handle POINTL* sdword float>
	^self invalidCall: _failureCode!

gdipDrawCurve3: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipDrawCurve3() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve3(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count,
			int offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipDrawCurve3 handle handle POINTF* sdword sdword sdword float>
	^self invalidCall: _failureCode!

gdipDrawCurve3I: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipDrawCurve3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve3I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count,
			int offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipDrawCurve3I handle handle POINTL* sdword sdword sdword float>
	^self invalidCall: _failureCode!

gdipDrawCurveI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurveI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipDrawCurveI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawDriverString: graphics text: text length: length font: font brush: brush positions: positions flags: flags matrix: matrix
	"Invoke the GdipDrawDriverString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawDriverString(
			PGpGraphics graphics,
			[in]UINT16* text,
			int length,
			[in]PGpFont font,
			[in]PGpBrush brush,
			[in]POINTF* positions,
			int Flags,
			[in]PGpMatrix matrix);"

	<stdcall: errno GdipDrawDriverString handle word* sdword handle handle POINTF* sdword handle>
	^self invalidCall: _failureCode!

gdipDrawEllipse: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawEllipse(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipDrawEllipse handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawEllipseI: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawEllipseI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipDrawEllipseI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawImage: graphics image: image x: x y: y
	"Invoke the GdipDrawImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImage(
			PGpGraphics graphics,
			PGpImage image,
			REAL x,
			REAL y);"

	<stdcall: errno GdipDrawImage handle handle float float>
	^self invalidCall: _failureCode!

gdipDrawImageI: graphics image: image x: x y: y
	"Invoke the GdipDrawImageI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageI(
			PGpGraphics graphics,
			PGpImage image,
			int x,
			int y);"

	<stdcall: errno GdipDrawImageI handle handle sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawImagePointRect: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit
	"Invoke the GdipDrawImagePointRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointRect(
			PGpGraphics graphics,
			PGpImage image,
			REAL x,
			REAL y,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			GpUnit srcUnit);"

	<stdcall: errno GdipDrawImagePointRect handle handle float float float float float float sdword>
	^self invalidCall: _failureCode!

gdipDrawImagePointRectI: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit
	"Invoke the GdipDrawImagePointRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointRectI(
			PGpGraphics graphics,
			PGpImage image,
			int x,
			int y,
			int srcx,
			int srcy,
			int srcwidth,
			int srcheight,
			GpUnit srcUnit);"

	<stdcall: errno GdipDrawImagePointRectI handle handle sdword sdword sdword sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawImagePoints: graphics image: image dstpoints: dstpoints count: count
	"Invoke the GdipDrawImagePoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePoints(
			PGpGraphics graphics,
			PGpImage image,
			[in]GpPointF* dstpoints,
			int Count);"

	<stdcall: errno GdipDrawImagePoints handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawImagePointsI: graphics image: image dstpoints: dstpoints count: count
	"Invoke the GdipDrawImagePointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsI(
			PGpGraphics graphics,
			PGpImage image,
			[in]GpPoint* dstpoints,
			int Count);"

	<stdcall: errno GdipDrawImagePointsI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawImagePointsRect: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImagePointsRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsRect(
			PGpGraphics graphics,
			PGpImage image,
			[in]GpPointF* Points,
			int Count,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort callback,
			VOID* callbackData);"

	<stdcall: errno GdipDrawImagePointsRect handle handle POINTF* sdword float float float float sdword handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawImagePointsRectI: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImagePointsRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsRectI(
			PGpGraphics graphics,
			PGpImage image,
			[in]GpPoint* Points,
			int Count,
			int srcx,
			int srcy,
			int srcwidth,
			int srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort callback,
			VOID* callbackData);"

	<stdcall: errno GdipDrawImagePointsRectI handle handle POINTL* sdword sdword sdword sdword sdword sdword handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawImageRect: graphics image: image x: x y: y width: width height: height
	"Invoke the GdipDrawImageRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRect(
			PGpGraphics graphics,
			PGpImage image,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipDrawImageRect handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawImageRectI: graphics image: image x: x y: y width: width height: height
	"Invoke the GdipDrawImageRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRectI(
			PGpGraphics graphics,
			PGpImage image,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipDrawImageRectI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawImageRectRect: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImageRectRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRectRect(
			PGpGraphics graphics,
			PGpImage image,
			REAL dstx,
			REAL dsty,
			REAL dstwidth,
			REAL dstheight,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort callback,
			VOID* callbackData);"

	<stdcall: errno GdipDrawImageRectRect handle handle float float float float float float float float sdword handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawImageRectRectI: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImageRectRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRectRectI(
			PGpGraphics graphics,
			PGpImage image,
			int dstx,
			int dsty,
			int dstwidth,
			int dstheight,
			int srcx,
			int srcy,
			int srcwidth,
			int srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort callback,
			VOID* callbackData);"

	<stdcall: errno GdipDrawImageRectRectI handle handle sdword sdword sdword sdword sdword sdword sdword sdword sdword handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawLine: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2
	"Invoke the GdipDrawLine() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLine(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x1,
			REAL y1,
			REAL x2,
			REAL y2);"

	<stdcall: errno GdipDrawLine handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawLineI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2
	"Invoke the GdipDrawLineI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLineI(
			PGpGraphics graphics,
			PGpPen pen,
			int x1,
			int y1,
			int x2,
			int y2);"

	<stdcall: errno GdipDrawLineI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawLines: graphics pen: pen points: points count: count
	"Invoke the GdipDrawLines() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLines(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipDrawLines handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawLinesI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawLinesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLinesI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipDrawLinesI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawPath: graphics pen: pen path: path
	"Invoke the GdipDrawPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPath(
			PGpGraphics graphics,
			PGpPen pen,
			PGpPath path);"

	<stdcall: errno GdipDrawPath handle handle handle>
	^self invalidCall: _failureCode!

gdipDrawPie: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipDrawPie() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPie(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawPie handle handle float float float float float float>
	^self invalidCall: _failureCode!

gdipDrawPieI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipDrawPieI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPieI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int Width,
			int Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawPieI handle handle sdword sdword sdword sdword float float>
	^self invalidCall: _failureCode!

gdipDrawPolygon: graphics pen: pen points: points count: count
	"Invoke the GdipDrawPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPolygon(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipDrawPolygon handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawPolygonI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPolygonI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipDrawPolygonI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawRectangle: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangle(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipDrawRectangle handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawRectangleI: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangleI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipDrawRectangleI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipDrawRectangles: graphics pen: pen rects: rects count: count
	"Invoke the GdipDrawRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangles(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpRectF* rects,
			int Count);"

	<stdcall: errno GdipDrawRectangles handle handle RECTF* sdword>
	^self invalidCall: _failureCode!

gdipDrawRectanglesI: graphics pen: pen rects: rects count: count
	"Invoke the GdipDrawRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectanglesI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]GpRect* rects,
			int Count);"

	<stdcall: errno GdipDrawRectanglesI handle handle RECTL* sdword>
	^self invalidCall: _failureCode!

gdipDrawString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat brush: brush
	"Invoke the GdipDrawString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawString(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RECTF* layoutRect,
			[in]PGpStringFormat stringFormat,
			[in]PGpBrush brush);"

	<stdcall: errno GdipDrawString handle lpwstr sdword handle RECTF* handle handle>
	^self invalidCall: _failureCode!

gdipEmfToWmfBits: hEmf cbData16: cbData16 pData16: pData16 iMapMode: iMapMode eFlags: eFlags
	"Invoke the GdipEmfToWmfBits() function of the module wrapped by the receiver.

		unsigned int __stdcall GdipEmfToWmfBits(
			HENHMETAFILE hEmf,
			unsigned int cbData16,
			LPBYTE pData16,
			int iMapMode,
			int eFlags);"

	<stdcall: dword GdipEmfToWmfBits handle dword byte* sdword sdword>
	^self invalidCall: _failureCode!

gdipEndContainer: graphics state: state
	"Invoke the GdipEndContainer() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEndContainer(
			PGpGraphics graphics,
			GraphicsContainer state);"

	<stdcall: errno GdipEndContainer handle dword>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPoint: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPoint(
			[in]PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoint,
			[in]EnumerateMetafileProc fnCallback,
			[in]VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPoint handle handle POINTF* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPointI: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPointI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTL* destPoint,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPointI handle handle POINTL* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPoints: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPoints(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoints,
			int Count,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPoints handle handle POINTF* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPointsI: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPointsI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTL* destPoints,
			int Count,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPointsI handle handle POINTL* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestRect: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestRect(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RECTF* destRect,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestRect handle handle RECTF* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestRectI: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestRectI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RECTL* destRect,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestRectI handle handle RECTL* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPoint: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoint(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoint,
			[in]RECTF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPoint handle handle POINTF* RECTF* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPointI: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTL* destPoint,
			[in]RECTL* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPointI handle handle POINTL* RECTL* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPoints: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoints(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoints,
			int Count,
			[in]RECTF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPoints handle handle POINTF* sdword RECTF* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPointsI: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointsI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTL* destPoints,
			int Count,
			[in]RECTL* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPointsI handle handle POINTL* sdword RECTL* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestRect: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRect(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RECTF* destRect,
			[in]RECTF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestRect handle handle RECTF* RECTF* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestRectI: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRectI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RECTL* destRect,
			[in]RECTL* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			VOID* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestRectI handle handle RECTL* RECTL* sdword void* void* handle>
	^self invalidCall: _failureCode!

gdipFillClosedCurve: graphics brush: brush points: points count: count
	"Invoke the GdipFillClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipFillClosedCurve handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipFillClosedCurve2: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	"Invoke the GdipFillClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve2(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPointF* Points,
			int Count,
			REAL tension,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillClosedCurve2 handle handle POINTF* sdword float sdword>
	^self invalidCall: _failureCode!

gdipFillClosedCurve2I: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	"Invoke the GdipFillClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve2I(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPoint* Points,
			int Count,
			REAL tension,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillClosedCurve2I handle handle POINTL* sdword float sdword>
	^self invalidCall: _failureCode!

gdipFillClosedCurveI: graphics brush: brush points: points count: count
	"Invoke the GdipFillClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurveI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipFillClosedCurveI handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipFillEllipse: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillEllipse(
			PGpGraphics graphics,
			PGpBrush brush,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipFillEllipse handle handle float float float float>
	^self invalidCall: _failureCode!

gdipFillEllipseI: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillEllipseI(
			PGpGraphics graphics,
			PGpBrush brush,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipFillEllipseI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipFillPath: graphics brush: brush path: path
	"Invoke the GdipFillPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPath(
			PGpGraphics graphics,
			PGpBrush brush,
			PGpPath path);"

	<stdcall: errno GdipFillPath handle handle handle>
	^self invalidCall: _failureCode!

gdipFillPie: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipFillPie() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPie(
			PGpGraphics graphics,
			PGpBrush brush,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipFillPie handle handle float float float float float float>
	^self invalidCall: _failureCode!

gdipFillPieI: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipFillPieI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPieI(
			PGpGraphics graphics,
			PGpBrush brush,
			int x,
			int y,
			int Width,
			int Height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipFillPieI handle handle sdword sdword sdword sdword float float>
	^self invalidCall: _failureCode!

gdipFillPolygon: graphics brush: brush points: points count: count fillMode: fillMode
	"Invoke the GdipFillPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPointF* Points,
			int Count,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillPolygon handle handle POINTF* sdword sdword>
	^self invalidCall: _failureCode!

gdipFillPolygon2: graphics brush: brush points: points count: count
	"Invoke the GdipFillPolygon2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon2(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPointF* Points,
			int Count);"

	<stdcall: errno GdipFillPolygon2 handle handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipFillPolygon2I: graphics brush: brush points: points count: count
	"Invoke the GdipFillPolygon2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon2I(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPoint* Points,
			int Count);"

	<stdcall: errno GdipFillPolygon2I handle handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipFillPolygonI: graphics brush: brush points: points count: count fillMode: fillMode
	"Invoke the GdipFillPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygonI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpPoint* Points,
			int Count,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillPolygonI handle handle POINTL* sdword sdword>
	^self invalidCall: _failureCode!

gdipFillRectangle: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangle(
			PGpGraphics graphics,
			PGpBrush brush,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height);"

	<stdcall: errno GdipFillRectangle handle handle float float float float>
	^self invalidCall: _failureCode!

gdipFillRectangleI: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangleI(
			PGpGraphics graphics,
			PGpBrush brush,
			int x,
			int y,
			int Width,
			int Height);"

	<stdcall: errno GdipFillRectangleI handle handle sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipFillRectangles: graphics brush: brush rects: rects count: count
	"Invoke the GdipFillRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangles(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpRectF* rects,
			int Count);"

	<stdcall: errno GdipFillRectangles handle handle RECTF* sdword>
	^self invalidCall: _failureCode!

gdipFillRectanglesI: graphics brush: brush rects: rects count: count
	"Invoke the GdipFillRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectanglesI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]GpRect* rects,
			int Count);"

	<stdcall: errno GdipFillRectanglesI handle handle RECTL* sdword>
	^self invalidCall: _failureCode!

gdipFillRegion: graphics brush: brush region: region
	"Invoke the GdipFillRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRegion(
			PGpGraphics graphics,
			PGpBrush brush,
			PGpRegion region);"

	<stdcall: errno GdipFillRegion handle handle handle>
	^self invalidCall: _failureCode!

gdipFlattenPath: path matrix: matrix flatness: flatness
	"Invoke the GdipFlattenPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFlattenPath(
			PGpPath path,
			PGpMatrix matrix,
			REAL flatness);"

	<stdcall: errno GdipFlattenPath handle handle float>
	^self invalidCall: _failureCode!

gdipFlush: graphics intention: intention
	"Invoke the GdipFlush() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFlush(
			PGpGraphics graphics,
			GpFlushIntention intention);"

	<stdcall: errno GdipFlush handle sdword>
	^self invalidCall: _failureCode!

gdipFontCollectionEnumerable: fontCollection graphics: graphics numFound: numFound
	"Invoke the GdipFontCollectionEnumerable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFontCollectionEnumerable(
			PGpFontCollection fontCollection,
			PGpGraphics graphics,
			int* numFound);"

	<stdcall: errno GdipFontCollectionEnumerable handle handle sdword*>
	^self invalidCall: _failureCode!

gdipFontCollectionEnumerate: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound graphics: graphics
	"Invoke the GdipFontCollectionEnumerate() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFontCollectionEnumerate(
			PGpFontCollection fontCollection,
			int numSought,
			PGpFontFamily* gpfamilies,
			int* numFound,
			PGpGraphics graphics);"

	<stdcall: errno GdipFontCollectionEnumerate handle sdword handle* sdword* handle>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapFillState: cap fillState: fillState
	"Invoke the GdipGetAdjustableArrowCapFillState() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapFillState(
			PGpAdjustableArrowCap cap,
			long* fillState);"

	<stdcall: errno GdipGetAdjustableArrowCapFillState handle sdword*>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapHeight: cap height: height
	"Invoke the GdipGetAdjustableArrowCapHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapHeight(
			PGpAdjustableArrowCap cap,
			REAL* Height);"

	<stdcall: errno GdipGetAdjustableArrowCapHeight handle float*>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapMiddleInset: cap middleInset: middleInset
	"Invoke the GdipGetAdjustableArrowCapMiddleInset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapMiddleInset(
			PGpAdjustableArrowCap cap,
			REAL* middleInset);"

	<stdcall: errno GdipGetAdjustableArrowCapMiddleInset handle float*>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapWidth: cap width: width
	"Invoke the GdipGetAdjustableArrowCapWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapWidth(
			PGpAdjustableArrowCap cap,
			REAL* Width);"

	<stdcall: errno GdipGetAdjustableArrowCapWidth handle float*>
	^self invalidCall: _failureCode!

gdipGetAllPropertyItems: image totalBufferSize: totalBufferSize numProperties: numProperties allItems: allItems
	"Invoke the GdipGetAllPropertyItems() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAllPropertyItems(
			[in]PGpImage image,
			[in]unsigned int totalBufferSize,
			[in]unsigned int numProperties,
			PropertyItem* allItems);"

	<stdcall: errno GdipGetAllPropertyItems handle dword dword GpPropertyItem*>
	^self invalidCall: _failureCode!

gdipGetBrushType: brush type: type
	"Invoke the GdipGetBrushType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetBrushType(
			PGpBrush brush,
			GpBrushType* Type);"

	<stdcall: errno GdipGetBrushType handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCellAscent: family style: style cellAscent: cellAscent
	"Invoke the GdipGetCellAscent() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCellAscent(
			[in]PGpFontFamily family,
			int style,
			UINT16* CellAscent);"

	<stdcall: errno GdipGetCellAscent handle sdword word*>
	^self invalidCall: _failureCode!

gdipGetCellDescent: family style: style cellDescent: cellDescent
	"Invoke the GdipGetCellDescent() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCellDescent(
			[in]PGpFontFamily family,
			int style,
			UINT16* CellDescent);"

	<stdcall: errno GdipGetCellDescent handle sdword word*>
	^self invalidCall: _failureCode!

gdipGetClip: graphics region: region
	"Invoke the GdipGetClip() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetClip(
			PGpGraphics graphics,
			PGpRegion region);"

	<stdcall: errno GdipGetClip handle handle>
	^self invalidCall: _failureCode!

gdipGetClipBounds: graphics rect: rect
	"Invoke the GdipGetClipBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetClipBounds(
			PGpGraphics graphics,
			GpRectF* rect);"

	<stdcall: errno GdipGetClipBounds handle RECTF*>
	^self invalidCall: _failureCode!

gdipGetClipBoundsI: graphics rect: rect
	"Invoke the GdipGetClipBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetClipBoundsI(
			PGpGraphics graphics,
			GpRect* rect);"

	<stdcall: errno GdipGetClipBoundsI handle RECTL*>
	^self invalidCall: _failureCode!

gdipGetCompositingMode: graphics compositingMode: compositingMode
	"Invoke the GdipGetCompositingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCompositingMode(
			PGpGraphics graphics,
			CompositingMode* CompositingMode);"

	<stdcall: errno GdipGetCompositingMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCompositingQuality: graphics compositingQuality: compositingQuality
	"Invoke the GdipGetCompositingQuality() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCompositingQuality(
			PGpGraphics graphics,
			CompositingQuality* CompositingQuality);"

	<stdcall: errno GdipGetCompositingQuality handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapBaseCap: customCap baseCap: baseCap
	"Invoke the GdipGetCustomLineCapBaseCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapBaseCap(
			PGpCustomLineCap customCap,
			GpLineCap* baseCap);"

	<stdcall: errno GdipGetCustomLineCapBaseCap handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapBaseInset: customCap inset: inset
	"Invoke the GdipGetCustomLineCapBaseInset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapBaseInset(
			PGpCustomLineCap customCap,
			REAL* inset);"

	<stdcall: errno GdipGetCustomLineCapBaseInset handle float*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap
	"Invoke the GdipGetCustomLineCapStrokeCaps() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapStrokeCaps(
			PGpCustomLineCap customCap,
			GpLineCap* startCap,
			GpLineCap* endCap);"

	<stdcall: errno GdipGetCustomLineCapStrokeCaps handle sdword* sdword*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	"Invoke the GdipGetCustomLineCapStrokeJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapStrokeJoin(
			PGpCustomLineCap customCap,
			GpLineJoin* LineJoin);"

	<stdcall: errno GdipGetCustomLineCapStrokeJoin handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapType: customCap capType: capType
	"Invoke the GdipGetCustomLineCapType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapType(
			PGpCustomLineCap customCap,
			CustomLineCapType* capType);"

	<stdcall: errno GdipGetCustomLineCapType handle sdword*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapWidthScale: customCap widthScale: widthScale
	"Invoke the GdipGetCustomLineCapWidthScale() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapWidthScale(
			PGpCustomLineCap customCap,
			REAL* widthScale);"

	<stdcall: errno GdipGetCustomLineCapWidthScale handle float*>
	^self invalidCall: _failureCode!

gdipGetDC: graphics hdc: hdc
	"Invoke the GdipGetDC() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetDC(
			PGpGraphics graphics,
			HDC* HDC);"

	<stdcall: errno GdipGetDC handle handle*>
	^self invalidCall: _failureCode!

gdipGetDpiX: graphics dpi: dpi
	"Invoke the GdipGetDpiX() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetDpiX(
			PGpGraphics graphics,
			REAL* dpi);"

	<stdcall: errno GdipGetDpiX handle float*>
	^self invalidCall: _failureCode!

gdipGetDpiY: graphics dpi: dpi
	"Invoke the GdipGetDpiY() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetDpiY(
			PGpGraphics graphics,
			REAL* dpi);"

	<stdcall: errno GdipGetDpiY handle float*>
	^self invalidCall: _failureCode!

gdipGetEmHeight: family style: style emHeight: emHeight
	"Invoke the GdipGetEmHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetEmHeight(
			[in]PGpFontFamily family,
			int style,
			UINT16* EmHeight);"

	<stdcall: errno GdipGetEmHeight handle sdword word*>
	^self invalidCall: _failureCode!

gdipGetEncoderParameterList: image clsidEncoder: clsidEncoder size: size buffer: buffer
	"Invoke the GdipGetEncoderParameterList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetEncoderParameterList(
			[in]PGpImage image,
			[in]GUID* clsidEncoder,
			[in]unsigned int size,
			[out, retval]EncoderParameters* buffer);"

	<stdcall: errno GdipGetEncoderParameterList handle guid* dword GpEncoderParameters*>
	^self invalidCall: _failureCode!

gdipGetEncoderParameterListSize: image clsidEncoder: clsidEncoder size: size
	"Invoke the GdipGetEncoderParameterListSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetEncoderParameterListSize(
			[in]PGpImage image,
			[in]GUID* clsidEncoder,
			[out, retval]unsigned int* size);"

	<stdcall: errno GdipGetEncoderParameterListSize handle guid* dword*>
	^self invalidCall: _failureCode!

gdipGetFamily: font family: family
	"Invoke the GdipGetFamily() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFamily(
			PGpFont font,
			[out, retval]PGpFontFamily* family);"

	<stdcall: errno GdipGetFamily handle handle*>
	^self invalidCall: _failureCode!

gdipGetFamilyName: family name: name language: language
	"Invoke the GdipGetFamilyName() function of the module wrapped by the receiver.

		Status __stdcall GdipGetFamilyName(
			ExternalHandle family,
			short name[32],
			unsigned short language);"

	<stdcall: errno GdipGetFamilyName handle lpwstr word>
	^self invalidCall: _failureCode!

gdipGetFontCollectionFamilyCount: fontCollection numFound: numFound
	"Invoke the GdipGetFontCollectionFamilyCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontCollectionFamilyCount(
			PGpFontCollection fontCollection,
			int* numFound);"

	<stdcall: errno GdipGetFontCollectionFamilyCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetFontCollectionFamilyList: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound
	"Invoke the GdipGetFontCollectionFamilyList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontCollectionFamilyList(
			PGpFontCollection fontCollection,
			int numSought,
			PGpFontFamily* gpfamilies,
			int* numFound);"

	<stdcall: errno GdipGetFontCollectionFamilyList handle sdword handle* sdword*>
	^self invalidCall: _failureCode!

gdipGetFontHeight: font graphics: graphics height: height
	"Invoke the GdipGetFontHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontHeight(
			[in]PGpFont font,
			[in]PGpGraphics graphics,
			REAL* Height);"

	<stdcall: errno GdipGetFontHeight handle handle float*>
	^self invalidCall: _failureCode!

gdipGetFontHeightGivenDPI: font dpi: dpi height: height
	"Invoke the GdipGetFontHeightGivenDPI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontHeightGivenDPI(
			[in]PGpFont font,
			REAL dpi,
			REAL* Height);"

	<stdcall: errno GdipGetFontHeightGivenDPI handle float float*>
	^self invalidCall: _failureCode!

gdipGetFontSize: font size: size
	"Invoke the GdipGetFontSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontSize(
			PGpFont font,
			REAL* size);"

	<stdcall: errno GdipGetFontSize handle float*>
	^self invalidCall: _failureCode!

gdipGetFontStyle: font style: style
	"Invoke the GdipGetFontStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontStyle(
			PGpFont font,
			FontStyle* style);"

	<stdcall: errno GdipGetFontStyle handle sdword*>
	^self invalidCall: _failureCode!

gdipGetFontUnit: font unit: unit
	"Invoke the GdipGetFontUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontUnit(
			PGpFont font,
			Unit* Unit);"

	<stdcall: errno GdipGetFontUnit handle sdword*>
	^self invalidCall: _failureCode!

gdipGetGenericFontFamilyMonospace: nativeFamily
	"Invoke the GdipGetGenericFontFamilyMonospace() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetGenericFontFamilyMonospace(
			[out, retval]PGpFontFamily* nativeFamily);"

	<stdcall: errno GdipGetGenericFontFamilyMonospace handle*>
	^self invalidCall: _failureCode!

gdipGetGenericFontFamilySansSerif: nativeFamily
	"Invoke the GdipGetGenericFontFamilySansSerif() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetGenericFontFamilySansSerif(
			[out, retval]PGpFontFamily* nativeFamily);"

	<stdcall: errno GdipGetGenericFontFamilySansSerif handle*>
	^self invalidCall: _failureCode!

gdipGetGenericFontFamilySerif: nativeFamily
	"Invoke the GdipGetGenericFontFamilySerif() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetGenericFontFamilySerif(
			[out, retval]PGpFontFamily* nativeFamily);"

	<stdcall: errno GdipGetGenericFontFamilySerif handle*>
	^self invalidCall: _failureCode!

gdipGetHatchBackgroundColor: brush backcol: backcol
	"Invoke the GdipGetHatchBackgroundColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHatchBackgroundColor(
			PGpHatch brush,
			ARGB* backcol);"

	<stdcall: errno GdipGetHatchBackgroundColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetHatchForegroundColor: brush forecol: forecol
	"Invoke the GdipGetHatchForegroundColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHatchForegroundColor(
			PGpHatch brush,
			ARGB* forecol);"

	<stdcall: errno GdipGetHatchForegroundColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetHatchStyle: brush hatchStyle: hatchStyle
	"Invoke the GdipGetHatchStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHatchStyle(
			PGpHatch brush,
			GpHatchStyle* HatchStyle);"

	<stdcall: errno GdipGetHatchStyle handle sdword*>
	^self invalidCall: _failureCode!

gdipGetHemfFromMetafile: metafile hEmf: hEmf
	"Invoke the GdipGetHemfFromMetafile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHemfFromMetafile(
			PGpMetafile metafile,
			HENHMETAFILE* hEmf);"

	<stdcall: errno GdipGetHemfFromMetafile handle handle*>
	^self invalidCall: _failureCode!

gdipGetImageAttributesAdjustedPalette: imageattr colorPalette: colorPalette colorAdjustType: colorAdjustType
	"Invoke the GdipGetImageAttributesAdjustedPalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageAttributesAdjustedPalette(
			PGpImageAttributes imageattr,
			ColorPalette* ColorPalette,
			ColorAdjustType ColorAdjustType);"

	<stdcall: errno GdipGetImageAttributesAdjustedPalette handle GpColorPalette* sdword>
	^self invalidCall: _failureCode!

gdipGetImageBounds: image srcRect: srcRect srcUnit: srcUnit
	"Invoke the GdipGetImageBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageBounds(
			[in]PGpImage image,
			GpRectF* srcRect,
			GpUnit* srcUnit);"

	<stdcall: errno GdipGetImageBounds handle RECTF* sdword*>
	^self invalidCall: _failureCode!

gdipGetImageDecoders: numDecoders size: size decoders: decoders
	"Invoke the GdipGetImageDecoders() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDecoders(
			unsigned int numDecoders,
			unsigned int size,
			ImageCodecInfo* decoders);"

	<stdcall: errno GdipGetImageDecoders dword dword GpImageCodecInfo*>
	^self invalidCall: _failureCode!

gdipGetImageDecodersSize: numDecoders size: size
	"Invoke the GdipGetImageDecodersSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDecodersSize(
			unsigned int* numDecoders,
			unsigned int* size);"

	<stdcall: errno GdipGetImageDecodersSize dword* dword*>
	^self invalidCall: _failureCode!

gdipGetImageDimension: image width: width height: height
	"Invoke the GdipGetImageDimension() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDimension(
			[in]PGpImage image,
			[out]REAL* Width,
			[out]REAL* Height);"

	<stdcall: errno GdipGetImageDimension handle float* float*>
	^self invalidCall: _failureCode!

gdipGetImageEncoders: numEncoders size: size encoders: encoders
	"Invoke the GdipGetImageEncoders() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageEncoders(
			[in]unsigned int numEncoders,
			[in]unsigned int size,
			[in, out]ImageCodecInfo* encoders);"

	<stdcall: errno GdipGetImageEncoders dword dword GpImageCodecInfo*>
	^self invalidCall: _failureCode!

gdipGetImageEncodersSize: numEncoders size: size
	"Invoke the GdipGetImageEncodersSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageEncodersSize(
			[out]unsigned int* numEncoders,
			[out]unsigned int* size);"

	<stdcall: errno GdipGetImageEncodersSize dword* dword*>
	^self invalidCall: _failureCode!

gdipGetImageFlags: image flags: flags
	"Invoke the GdipGetImageFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageFlags(
			[in]PGpImage image,
			[out, retval]unsigned int* Flags);"

	<stdcall: errno GdipGetImageFlags handle dword*>
	^self invalidCall: _failureCode!

gdipGetImageGraphicsContext: image graphics: graphics
	"Invoke the GdipGetImageGraphicsContext() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageGraphicsContext(
			[in]PGpImage image,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipGetImageGraphicsContext handle handle*>
	^self invalidCall: _failureCode!

gdipGetImageHeight: image height: height
	"Invoke the GdipGetImageHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageHeight(
			[in]PGpImage image,
			[out, retval]unsigned int* Height);"

	<stdcall: errno GdipGetImageHeight handle dword*>
	^self invalidCall: _failureCode!

gdipGetImageHorizontalResolution: image resolution: resolution
	"Invoke the GdipGetImageHorizontalResolution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageHorizontalResolution(
			[in]PGpImage image,
			[out, retval]REAL* resolution);"

	<stdcall: errno GdipGetImageHorizontalResolution handle float*>
	^self invalidCall: _failureCode!

gdipGetImagePalette: image palette: palette size: size
	"Invoke the GdipGetImagePalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePalette(
			[in]PGpImage image,
			ColorPalette* palette,
			int size);"

	<stdcall: errno GdipGetImagePalette handle GpColorPalette* sdword>
	^self invalidCall: _failureCode!

gdipGetImagePaletteSize: image size: size
	"Invoke the GdipGetImagePaletteSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePaletteSize(
			[in]PGpImage image,
			[out, retval]int* size);"

	<stdcall: errno GdipGetImagePaletteSize handle sdword*>
	^self invalidCall: _failureCode!

gdipGetImagePixelFormat: image format: format
	"Invoke the GdipGetImagePixelFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePixelFormat(
			[in]PGpImage image,
			[out, retval]PixelFormat* format);"

	<stdcall: errno GdipGetImagePixelFormat handle sdword*>
	^self invalidCall: _failureCode!

gdipGetImageRawFormat: image format: format
	"Invoke the GdipGetImageRawFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageRawFormat(
			[in]PGpImage image,
			[out, retval]GUID* format);"

	<stdcall: errno GdipGetImageRawFormat handle guid*>
	^self invalidCall: _failureCode!

gdipGetImageThumbnail: image thumbWidth: thumbWidth thumbHeight: thumbHeight thumbImage: thumbImage pfnCallback: pfnCallback callbackData: callbackData
	"Invoke the GdipGetImageThumbnail() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageThumbnail(
			[in]PGpImage image,
			[in]unsigned int thumbWidth,
			[in]unsigned int thumbHeight,
			[out]PGpImage* thumbImage,
			[in]GetThumbnailImageAbort pfnCallback,
			[in]VOID* callbackData);"

	<stdcall: errno GdipGetImageThumbnail handle dword dword handle* void* void*>
	^self invalidCall: _failureCode!

gdipGetImageType: image type: type
	"Invoke the GdipGetImageType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageType(
			[in]PGpImage image,
			[out, retval]ImageType* Type);"

	<stdcall: errno GdipGetImageType handle sdword*>
	^self invalidCall: _failureCode!

gdipGetImageVerticalResolution: image resolution: resolution
	"Invoke the GdipGetImageVerticalResolution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageVerticalResolution(
			[in]PGpImage image,
			[out, retval]REAL* resolution);"

	<stdcall: errno GdipGetImageVerticalResolution handle float*>
	^self invalidCall: _failureCode!

gdipGetImageWidth: image width: width
	"Invoke the GdipGetImageWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageWidth(
			[in]PGpImage image,
			[out, retval]unsigned int* Width);"

	<stdcall: errno GdipGetImageWidth handle dword*>
	^self invalidCall: _failureCode!

gdipGetInterpolationMode: graphics interpolationMode: interpolationMode
	"Invoke the GdipGetInterpolationMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetInterpolationMode(
			PGpGraphics graphics,
			InterpolationMode* InterpolationMode);"

	<stdcall: errno GdipGetInterpolationMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetLineBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetLineBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineBlend(
			PGpLineGradient brush,
			REAL* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetLineBlend handle float* float* sdword>
	^self invalidCall: _failureCode!

gdipGetLineBlendCount: brush count: count
	"Invoke the GdipGetLineBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineBlendCount(
			PGpLineGradient brush,
			int* Count);"

	<stdcall: errno GdipGetLineBlendCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetLineColors: brush colors: colors
	"Invoke the GdipGetLineColors() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineColors(
			PGpLineGradient brush,
			ARGB* colors);"

	<stdcall: errno GdipGetLineColors handle dword*>
	^self invalidCall: _failureCode!

gdipGetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipGetLineGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineGammaCorrection(
			PGpLineGradient brush,
			long* useGammaCorrection);"

	<stdcall: errno GdipGetLineGammaCorrection handle sdword*>
	^self invalidCall: _failureCode!

gdipGetLinePresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetLinePresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLinePresetBlend(
			PGpLineGradient brush,
			ARGB* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetLinePresetBlend handle dword* float* sdword>
	^self invalidCall: _failureCode!

gdipGetLinePresetBlendCount: brush count: count
	"Invoke the GdipGetLinePresetBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLinePresetBlendCount(
			PGpLineGradient brush,
			int* Count);"

	<stdcall: errno GdipGetLinePresetBlendCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetLineRect: brush rect: rect
	"Invoke the GdipGetLineRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineRect(
			PGpLineGradient brush,
			GpRectF* rect);"

	<stdcall: errno GdipGetLineRect handle RECTF*>
	^self invalidCall: _failureCode!

gdipGetLineRectI: brush rect: rect
	"Invoke the GdipGetLineRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineRectI(
			PGpLineGradient brush,
			GpRect* rect);"

	<stdcall: errno GdipGetLineRectI handle RECTL*>
	^self invalidCall: _failureCode!

gdipGetLineSpacing: family style: style lineSpacing: lineSpacing
	"Invoke the GdipGetLineSpacing() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineSpacing(
			[in]PGpFontFamily family,
			int style,
			UINT16* LineSpacing);"

	<stdcall: errno GdipGetLineSpacing handle sdword word*>
	^self invalidCall: _failureCode!

gdipGetLineTransform: brush matrix: matrix
	"Invoke the GdipGetLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineTransform(
			PGpLineGradient brush,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetLineTransform handle handle>
	^self invalidCall: _failureCode!

gdipGetLineWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipGetLineWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineWrapMode(
			PGpLineGradient brush,
			GpWrapMode* WrapMode);"

	<stdcall: errno GdipGetLineWrapMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetLogFontA: font graphics: graphics logfonta: logfonta
	"Invoke the GdipGetLogFontA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLogFontA(
			PGpFont font,
			PGpGraphics graphics,
			LOGFONTA* LOGFONTA);"

	<stdcall: errno GdipGetLogFontA handle handle LOGFONT*>
	^self invalidCall: _failureCode!

gdipGetLogFontW: font graphics: graphics logfonta: logfonta
	"Invoke the GdipGetLogFontA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLogFontA(
			PGpFont font,
			PGpGraphics graphics,
			LOGFONTW* LOGFONTW);"

	<stdcall: errno GdipGetLogFontW handle handle LOGFONTW*>
	^self invalidCall: _failureCode!

gdipGetMatrixElements: matrix matrixOut: matrixOut
	"Invoke the GdipGetMatrixElements() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMatrixElements(
			[in]PGpMatrix matrix,
			REAL* matrixOut);"

	<stdcall: errno GdipGetMatrixElements handle float*>
	^self invalidCall: _failureCode!

gdipGetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi
	"Invoke the GdipGetMetafileDownLevelRasterizationLimit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileDownLevelRasterizationLimit(
			[in]PGpMetafile metafile,
			unsigned int* metafileRasterizationLimitDpi);"

	<stdcall: errno GdipGetMetafileDownLevelRasterizationLimit handle dword*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromEmf: hEmf header: header
	"Invoke the GdipGetMetafileHeaderFromEmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromEmf(
			HENHMETAFILE hEmf,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromEmf handle GpMetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromFile: filename header: header
	"Invoke the GdipGetMetafileHeaderFromFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromFile(
			[in]LPWSTR filename,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromFile lpwstr GpMetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromMetafile: metafile header: header
	"Invoke the GdipGetMetafileHeaderFromMetafile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromMetafile(
			PGpMetafile metafile,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromMetafile handle GpMetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromStream: stream header: header
	"Invoke the GdipGetMetafileHeaderFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromStream(
			IStream* stream,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromStream COM.IStream* GpMetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromWmf: hWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader header: header
	"Invoke the GdipGetMetafileHeaderFromWmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromWmf(
			HMETAFILE hWmf,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromWmf handle GpWmfPlaceableFileHeader* GpMetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetNearestColor: graphics argb: argb
	"Invoke the GdipGetNearestColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetNearestColor(
			PGpGraphics graphics,
			ARGB* ARGB);"

	<stdcall: errno GdipGetNearestColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetPageScale: graphics scale: scale
	"Invoke the GdipGetPageScale() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPageScale(
			PGpGraphics graphics,
			REAL* scale);"

	<stdcall: errno GdipGetPageScale handle float*>
	^self invalidCall: _failureCode!

gdipGetPageUnit: graphics unit: unit
	"Invoke the GdipGetPageUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPageUnit(
			PGpGraphics graphics,
			GpUnit* Unit);"

	<stdcall: errno GdipGetPageUnit handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathData: path pathData: pathData
	"Invoke the GdipGetPathData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathData(
			PGpPath path,
			GpPathData* pathData);"

	<stdcall: errno GdipGetPathData handle GpPathData*>
	^self invalidCall: _failureCode!

gdipGetPathFillMode: path fillMode: fillMode
	"Invoke the GdipGetPathFillMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathFillMode(
			PGpPath path,
			GpFillMode* FillMode);"

	<stdcall: errno GdipGetPathFillMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetPathGradientBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientBlend(
			PGpPathGradient brush,
			REAL* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetPathGradientBlend handle float* float* sdword>
	^self invalidCall: _failureCode!

gdipGetPathGradientBlendCount: brush count: count
	"Invoke the GdipGetPathGradientBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientBlendCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientBlendCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterColor: brush colors: colors
	"Invoke the GdipGetPathGradientCenterColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterColor(
			PGpPathGradient brush,
			ARGB* colors);"

	<stdcall: errno GdipGetPathGradientCenterColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterPoint: brush points: points
	"Invoke the GdipGetPathGradientCenterPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterPoint(
			PGpPathGradient brush,
			GpPointF* Points);"

	<stdcall: errno GdipGetPathGradientCenterPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterPointI: brush points: points
	"Invoke the GdipGetPathGradientCenterPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterPointI(
			PGpPathGradient brush,
			GpPoint* Points);"

	<stdcall: errno GdipGetPathGradientCenterPointI handle POINTL*>
	^self invalidCall: _failureCode!

gdipGetPathGradientFocusScales: brush xScale: xScale yScale: yScale
	"Invoke the GdipGetPathGradientFocusScales() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientFocusScales(
			PGpPathGradient brush,
			REAL* xScale,
			REAL* yScale);"

	<stdcall: errno GdipGetPathGradientFocusScales handle float* float*>
	^self invalidCall: _failureCode!

gdipGetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipGetPathGradientGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientGammaCorrection(
			PGpPathGradient brush,
			long* useGammaCorrection);"

	<stdcall: errno GdipGetPathGradientGammaCorrection handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientPath: brush path: path
	"Invoke the GdipGetPathGradientPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPath(
			PGpPathGradient brush,
			PGpPath path);"

	<stdcall: errno GdipGetPathGradientPath handle handle>
	^self invalidCall: _failureCode!

gdipGetPathGradientPointCount: brush count: count
	"Invoke the GdipGetPathGradientPointCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPointCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientPointCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientPresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetPathGradientPresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPresetBlend(
			PGpPathGradient brush,
			ARGB* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetPathGradientPresetBlend handle dword* float* sdword>
	^self invalidCall: _failureCode!

gdipGetPathGradientPresetBlendCount: brush count: count
	"Invoke the GdipGetPathGradientPresetBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPresetBlendCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientPresetBlendCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientRect: brush rect: rect
	"Invoke the GdipGetPathGradientRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientRect(
			PGpPathGradient brush,
			GpRectF* rect);"

	<stdcall: errno GdipGetPathGradientRect handle RECTF*>
	^self invalidCall: _failureCode!

gdipGetPathGradientRectI: brush rect: rect
	"Invoke the GdipGetPathGradientRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientRectI(
			PGpPathGradient brush,
			GpRect* rect);"

	<stdcall: errno GdipGetPathGradientRectI handle RECTL*>
	^self invalidCall: _failureCode!

gdipGetPathGradientSurroundColorCount: brush count: count
	"Invoke the GdipGetPathGradientSurroundColorCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientSurroundColorCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientSurroundColorCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientSurroundColorsWithCount: brush color: color count: count
	"Invoke the GdipGetPathGradientSurroundColorsWithCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientSurroundColorsWithCount(
			PGpPathGradient brush,
			ARGB* Color,
			int* Count);"

	<stdcall: errno GdipGetPathGradientSurroundColorsWithCount handle dword* sdword*>
	^self invalidCall: _failureCode!

gdipGetPathGradientTransform: brush matrix: matrix
	"Invoke the GdipGetPathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientTransform(
			PGpPathGradient brush,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetPathGradientTransform handle handle>
	^self invalidCall: _failureCode!

gdipGetPathGradientWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipGetPathGradientWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientWrapMode(
			PGpPathGradient brush,
			GpWrapMode* WrapMode);"

	<stdcall: errno GdipGetPathGradientWrapMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPathLastPoint: path lastPoint: lastPoint
	"Invoke the GdipGetPathLastPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathLastPoint(
			PGpPath path,
			GpPointF* lastPoint);"

	<stdcall: errno GdipGetPathLastPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipGetPathPoints: path points: points count: count
	"Invoke the GdipGetPathPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathPoints(
			PGpPath path,
			GpPointF* Points,
			int Count);"

	<stdcall: errno GdipGetPathPoints handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipGetPathPointsI: path points: points count: count
	"Invoke the GdipGetPathPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathPointsI(
			PGpPath path,
			GpPoint* Points,
			int Count);"

	<stdcall: errno GdipGetPathPointsI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipGetPathTypes: path types: types count: count
	"Invoke the GdipGetPathTypes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathTypes(
			PGpPath path,
			BYTE* Types,
			int Count);"

	<stdcall: errno GdipGetPathTypes handle byte* sdword>
	^self invalidCall: _failureCode!

gdipGetPathWorldBounds: path bounds: bounds matrix: matrix pen: pen
	"Invoke the GdipGetPathWorldBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathWorldBounds(
			PGpPath path,
			GpRectF* bounds,
			[in]PGpMatrix matrix,
			[in]PGpPen pen);"

	<stdcall: errno GdipGetPathWorldBounds handle RECTF* handle handle>
	^self invalidCall: _failureCode!

gdipGetPathWorldBoundsI: path bounds: bounds matrix: matrix pen: pen
	"Invoke the GdipGetPathWorldBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathWorldBoundsI(
			PGpPath path,
			GpRect* bounds,
			[in]PGpMatrix matrix,
			[in]PGpPen pen);"

	<stdcall: errno GdipGetPathWorldBoundsI handle RECTL* handle handle>
	^self invalidCall: _failureCode!

gdipGetPenBrushFill: pen brush: brush
	"Invoke the GdipGetPenBrushFill() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenBrushFill(
			PGpPen pen,
			[out, retval]PGpBrush* brush);"

	<stdcall: errno GdipGetPenBrushFill handle handle*>
	^self invalidCall: _failureCode!

gdipGetPenColor: pen argb: argb
	"Invoke the GdipGetPenColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenColor(
			PGpPen pen,
			ARGB* ARGB);"

	<stdcall: errno GdipGetPenColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetPenCompoundArray: pen dash: dash count: count
	"Invoke the GdipGetPenCompoundArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCompoundArray(
			PGpPen pen,
			REAL* dash,
			int Count);"

	<stdcall: errno GdipGetPenCompoundArray handle float* sdword>
	^self invalidCall: _failureCode!

gdipGetPenCompoundCount: pen count: count
	"Invoke the GdipGetPenCompoundCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCompoundCount(
			PGpPen pen,
			int* Count);"

	<stdcall: errno GdipGetPenCompoundCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenCustomEndCap: pen customCap: customCap
	"Invoke the GdipGetPenCustomEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCustomEndCap(
			PGpPen pen,
			[out, retval]PGpCustomLineCap* customCap);"

	<stdcall: errno GdipGetPenCustomEndCap handle handle*>
	^self invalidCall: _failureCode!

gdipGetPenCustomStartCap: pen customCap: customCap
	"Invoke the GdipGetPenCustomStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCustomStartCap(
			PGpPen pen,
			[out, retval]PGpCustomLineCap* customCap);"

	<stdcall: errno GdipGetPenCustomStartCap handle handle*>
	^self invalidCall: _failureCode!

gdipGetPenDashArray: pen dash: dash count: count
	"Invoke the GdipGetPenDashArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashArray(
			PGpPen pen,
			REAL* dash,
			int Count);"

	<stdcall: errno GdipGetPenDashArray handle float* sdword>
	^self invalidCall: _failureCode!

gdipGetPenDashCap197819: pen dashCap: dashCap
	"Invoke the GdipGetPenDashCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashCap197819(
			PGpPen pen,
			GpDashCap* DashCap);"

	<stdcall: errno GdipGetPenDashCap197819 handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenDashCount: pen count: count
	"Invoke the GdipGetPenDashCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashCount(
			PGpPen pen,
			int* Count);"

	<stdcall: errno GdipGetPenDashCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenDashOffset: pen offset: offset
	"Invoke the GdipGetPenDashOffset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashOffset(
			PGpPen pen,
			REAL* offset);"

	<stdcall: errno GdipGetPenDashOffset handle float*>
	^self invalidCall: _failureCode!

gdipGetPenDashStyle: pen dashStyle: dashStyle
	"Invoke the GdipGetPenDashStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashStyle(
			PGpPen pen,
			GpDashStyle* DashStyle);"

	<stdcall: errno GdipGetPenDashStyle handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenEndCap: pen endCap: endCap
	"Invoke the GdipGetPenEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenEndCap(
			PGpPen pen,
			GpLineCap* endCap);"

	<stdcall: errno GdipGetPenEndCap handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenFillType: pen type: type
	"Invoke the GdipGetPenFillType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenFillType(
			PGpPen pen,
			GpPenType* Type);"

	<stdcall: errno GdipGetPenFillType handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenLineJoin: pen lineJoin: lineJoin
	"Invoke the GdipGetPenLineJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenLineJoin(
			PGpPen pen,
			GpLineJoin* LineJoin);"

	<stdcall: errno GdipGetPenLineJoin handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenMiterLimit: pen miterLimit: miterLimit
	"Invoke the GdipGetPenMiterLimit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenMiterLimit(
			PGpPen pen,
			REAL* miterLimit);"

	<stdcall: errno GdipGetPenMiterLimit handle float*>
	^self invalidCall: _failureCode!

gdipGetPenMode: pen penMode: penMode
	"Invoke the GdipGetPenMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenMode(
			PGpPen pen,
			GpPenAlignment* penMode);"

	<stdcall: errno GdipGetPenMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenStartCap: pen startCap: startCap
	"Invoke the GdipGetPenStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenStartCap(
			PGpPen pen,
			GpLineCap* startCap);"

	<stdcall: errno GdipGetPenStartCap handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenTransform: pen matrix: matrix
	"Invoke the GdipGetPenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenTransform(
			PGpPen pen,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetPenTransform handle handle>
	^self invalidCall: _failureCode!

gdipGetPenUnit: pen unit: unit
	"Invoke the GdipGetPenUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenUnit(
			PGpPen pen,
			GpUnit* Unit);"

	<stdcall: errno GdipGetPenUnit handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPenWidth: pen width: width
	"Invoke the GdipGetPenWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenWidth(
			PGpPen pen,
			REAL* Width);"

	<stdcall: errno GdipGetPenWidth handle float*>
	^self invalidCall: _failureCode!

gdipGetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	"Invoke the GdipGetPixelOffsetMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPixelOffsetMode(
			PGpGraphics graphics,
			PixelOffsetMode* PixelOffsetMode);"

	<stdcall: errno GdipGetPixelOffsetMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPointCount: path count: count
	"Invoke the GdipGetPointCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPointCount(
			PGpPath path,
			int* Count);"

	<stdcall: errno GdipGetPointCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetPropertyCount: image numOfProperty: numOfProperty
	"Invoke the GdipGetPropertyCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyCount(
			[in]PGpImage image,
			[out, retval]unsigned int* numOfProperty);"

	<stdcall: errno GdipGetPropertyCount handle dword*>
	^self invalidCall: _failureCode!

gdipGetPropertyIdList: image numOfProperty: numOfProperty list: list
	"Invoke the GdipGetPropertyIdList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyIdList(
			[in]PGpImage image,
			[in]unsigned int numOfProperty,
			unsigned long* list);"

	<stdcall: errno GdipGetPropertyIdList handle dword dword*>
	^self invalidCall: _failureCode!

gdipGetPropertyItem: image propId: propId propSize: propSize buffer: buffer
	"Invoke the GdipGetPropertyItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyItem(
			[in]PGpImage image,
			[in]unsigned long propId,
			[in]unsigned int propSize,
			PropertyItem* buffer);"

	<stdcall: errno GdipGetPropertyItem handle dword dword GpPropertyItem*>
	^self invalidCall: _failureCode!

gdipGetPropertyItemSize: image propId: propId size: size
	"Invoke the GdipGetPropertyItemSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyItemSize(
			[in]PGpImage image,
			[in]unsigned long propId,
			unsigned int* size);"

	<stdcall: errno GdipGetPropertyItemSize handle dword dword*>
	^self invalidCall: _failureCode!

gdipGetPropertySize: image totalBufferSize: totalBufferSize numProperties: numProperties
	"Invoke the GdipGetPropertySize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertySize(
			[in]PGpImage image,
			unsigned int* totalBufferSize,
			unsigned int* numProperties);"

	<stdcall: errno GdipGetPropertySize handle dword* dword*>
	^self invalidCall: _failureCode!

gdipGetRegionBounds: region graphics: graphics rect: rect
	"Invoke the GdipGetRegionBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionBounds(
			PGpRegion region,
			PGpGraphics graphics,
			GpRectF* rect);"

	<stdcall: errno GdipGetRegionBounds handle handle RECTF*>
	^self invalidCall: _failureCode!

gdipGetRegionBoundsI: region graphics: graphics rect: rect
	"Invoke the GdipGetRegionBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionBoundsI(
			PGpRegion region,
			PGpGraphics graphics,
			GpRect* rect);"

	<stdcall: errno GdipGetRegionBoundsI handle handle RECTL*>
	^self invalidCall: _failureCode!

gdipGetRegionData: region buffer: buffer bufferSize: bufferSize sizeFilled: sizeFilled
	"Invoke the GdipGetRegionData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionData(
			PGpRegion region,
			BYTE* buffer,
			unsigned int bufferSize,
			unsigned int* sizeFilled);"

	<stdcall: errno GdipGetRegionData handle byte* dword dword*>
	^self invalidCall: _failureCode!

gdipGetRegionDataSize: region bufferSize: bufferSize
	"Invoke the GdipGetRegionDataSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionDataSize(
			PGpRegion region,
			unsigned int* bufferSize);"

	<stdcall: errno GdipGetRegionDataSize handle dword*>
	^self invalidCall: _failureCode!

gdipGetRegionHRgn: region graphics: graphics hRgn: hRgn
	"Invoke the GdipGetRegionHRgn() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionHRgn(
			PGpRegion region,
			PGpGraphics graphics,
			void** hRgn);"

	<stdcall: errno GdipGetRegionHRgn handle handle void**>
	^self invalidCall: _failureCode!

gdipGetRegionScans: region rects: rects count: count matrix: matrix
	"Invoke the GdipGetRegionScans() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScans(
			PGpRegion region,
			GpRectF* rects,
			int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScans handle RECTF* sdword* handle>
	^self invalidCall: _failureCode!

gdipGetRegionScansCount: region count: count matrix: matrix
	"Invoke the GdipGetRegionScansCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScansCount(
			PGpRegion region,
			unsigned int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScansCount handle dword* handle>
	^self invalidCall: _failureCode!

gdipGetRegionScansI: region rects: rects count: count matrix: matrix
	"Invoke the GdipGetRegionScansI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScansI(
			PGpRegion region,
			GpRect* rects,
			int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScansI handle RECTL* sdword* handle>
	^self invalidCall: _failureCode!

gdipGetRenderingOrigin: graphics x: x y: y
	"Invoke the GdipGetRenderingOrigin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRenderingOrigin(
			PGpGraphics graphics,
			int* x,
			int* y);"

	<stdcall: errno GdipGetRenderingOrigin handle sdword* sdword*>
	^self invalidCall: _failureCode!

gdipGetSmoothingMode: graphics smoothingMode: smoothingMode
	"Invoke the GdipGetSmoothingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetSmoothingMode(
			PGpGraphics graphics,
			SmoothingMode* SmoothingMode);"

	<stdcall: errno GdipGetSmoothingMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetSolidFillColor: brush color: color
	"Invoke the GdipGetSolidFillColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetSolidFillColor(
			[in]PGpSolidFill brush,
			[out, retval]ARGB* Color);"

	<stdcall: errno GdipGetSolidFillColor handle dword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatAlign: format align: align
	"Invoke the GdipGetStringFormatAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatAlign(
			[in]PGpStringFormat format,
			StringAlignment* align);"

	<stdcall: errno GdipGetStringFormatAlign handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatDigitSubstitution: format language: language substitute: substitute
	"Invoke the GdipGetStringFormatDigitSubstitution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatDigitSubstitution(
			[in]PGpStringFormat format,
			LANGID* language,
			StringDigitSubstitute* substitute);"

	<stdcall: errno GdipGetStringFormatDigitSubstitution handle word* sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatFlags: format flags: flags
	"Invoke the GdipGetStringFormatFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatFlags(
			[in]PGpStringFormat format,
			int* Flags);"

	<stdcall: errno GdipGetStringFormatFlags handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	"Invoke the GdipGetStringFormatHotkeyPrefix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatHotkeyPrefix(
			[in]PGpStringFormat format,
			int* HotkeyPrefix);"

	<stdcall: errno GdipGetStringFormatHotkeyPrefix handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatLineAlign: format align: align
	"Invoke the GdipGetStringFormatLineAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatLineAlign(
			[in]PGpStringFormat format,
			StringAlignment* align);"

	<stdcall: errno GdipGetStringFormatLineAlign handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatMeasurableCharacterRangeCount: format count: count
	"Invoke the GdipGetStringFormatMeasurableCharacterRangeCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatMeasurableCharacterRangeCount(
			[in]PGpStringFormat format,
			int* Count);"

	<stdcall: errno GdipGetStringFormatMeasurableCharacterRangeCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTabStopCount: format count: count
	"Invoke the GdipGetStringFormatTabStopCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTabStopCount(
			[in]PGpStringFormat format,
			int* Count);"

	<stdcall: errno GdipGetStringFormatTabStopCount handle sdword*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTabStops: format count: count firstTabOffset: firstTabOffset tabStops: tabStops
	"Invoke the GdipGetStringFormatTabStops() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTabStops(
			[in]PGpStringFormat format,
			int Count,
			REAL* firstTabOffset,
			REAL* tabStops);"

	<stdcall: errno GdipGetStringFormatTabStops handle sdword float* float*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTrimming: format trimming: trimming
	"Invoke the GdipGetStringFormatTrimming() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTrimming(
			[in]PGpStringFormat format,
			StringTrimming* trimming);"

	<stdcall: errno GdipGetStringFormatTrimming handle sdword*>
	^self invalidCall: _failureCode!

gdipGetTextContrast: graphics contrast: contrast
	"Invoke the GdipGetTextContrast() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextContrast(
			PGpGraphics graphics,
			unsigned int* contrast);"

	<stdcall: errno GdipGetTextContrast handle dword*>
	^self invalidCall: _failureCode!

gdipGetTextRenderingHint: graphics mode: mode
	"Invoke the GdipGetTextRenderingHint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextRenderingHint(
			PGpGraphics graphics,
			TextRenderingHint* mode);"

	<stdcall: errno GdipGetTextRenderingHint handle sdword*>
	^self invalidCall: _failureCode!

gdipGetTextureImage: brush image: image
	"Invoke the GdipGetTextureImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextureImage(
			[in]PGpTexture brush,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipGetTextureImage handle handle*>
	^self invalidCall: _failureCode!

gdipGetTextureTransform: brush matrix: matrix
	"Invoke the GdipGetTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextureTransform(
			[in]PGpTexture brush,
			[in]PGpMatrix matrix);"

	<stdcall: errno GdipGetTextureTransform handle handle>
	^self invalidCall: _failureCode!

gdipGetTextureWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipGetTextureWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextureWrapMode(
			[in]PGpTexture brush,
			[out, retval]GpWrapMode* WrapMode);"

	<stdcall: errno GdipGetTextureWrapMode handle sdword*>
	^self invalidCall: _failureCode!

gdipGetVisibleClipBounds: graphics rect: rect
	"Invoke the GdipGetVisibleClipBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetVisibleClipBounds(
			PGpGraphics graphics,
			GpRectF* rect);"

	<stdcall: errno GdipGetVisibleClipBounds handle RECTF*>
	^self invalidCall: _failureCode!

gdipGetVisibleClipBoundsI: graphics rect: rect
	"Invoke the GdipGetVisibleClipBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetVisibleClipBoundsI(
			PGpGraphics graphics,
			GpRect* rect);"

	<stdcall: errno GdipGetVisibleClipBoundsI handle RECTL*>
	^self invalidCall: _failureCode!

gdipGetWorldTransform: graphics matrix: matrix
	"Invoke the GdipGetWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetWorldTransform(
			PGpGraphics graphics,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetWorldTransform handle handle>
	^self invalidCall: _failureCode!

gdipGraphicsClear: graphics color: color
	"Invoke the GdipGraphicsClear() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGraphicsClear(
			PGpGraphics graphics,
			ARGB Color);"

	<stdcall: errno GdipGraphicsClear handle dword>
	^self invalidCall: _failureCode!

gdipImageForceValidation: image
	"Invoke the GdipImageForceValidation() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageForceValidation(
			[in]PGpImage image);"

	<stdcall: errno GdipImageForceValidation handle>
	^self invalidCall: _failureCode!

gdipImageGetFrameCount: image dimensionID: dimensionID count: count
	"Invoke the GdipImageGetFrameCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageGetFrameCount(
			[in]PGpImage image,
			[in]GUID* dimensionID,
			unsigned int* Count);"

	<stdcall: errno GdipImageGetFrameCount handle guid* dword*>
	^self invalidCall: _failureCode!

gdipImageGetFrameDimensionsCount: image count: count
	"Invoke the GdipImageGetFrameDimensionsCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageGetFrameDimensionsCount(
			[in]PGpImage image,
			[out, retval]unsigned int* Count);"

	<stdcall: errno GdipImageGetFrameDimensionsCount handle dword*>
	^self invalidCall: _failureCode!

gdipImageGetFrameDimensionsList: image dimensionIDs: dimensionIDs count: count
	"Invoke the GdipImageGetFrameDimensionsList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageGetFrameDimensionsList(
			[in]PGpImage image,
			GUID* dimensionIDs,
			unsigned int Count);"

	<stdcall: errno GdipImageGetFrameDimensionsList handle guid* dword>
	^self invalidCall: _failureCode!

gdipImageRotateFlip: image rfType: rfType
	"Invoke the GdipImageRotateFlip() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageRotateFlip(
			[in]PGpImage image,
			[in]RotateFlipType rfType);"

	<stdcall: errno GdipImageRotateFlip handle sdword>
	^self invalidCall: _failureCode!

gdipImageSelectActiveFrame: image dimensionID: dimensionID frameIndex: frameIndex
	"Invoke the GdipImageSelectActiveFrame() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageSelectActiveFrame(
			[in]PGpImage image,
			[in]GUID* dimensionID,
			[in]unsigned int frameIndex);"

	<stdcall: errno GdipImageSelectActiveFrame handle guid* dword>
	^self invalidCall: _failureCode!

gdipInvertMatrix: matrix
	"Invoke the GdipInvertMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipInvertMatrix(
			PGpMatrix matrix);"

	<stdcall: errno GdipInvertMatrix handle>
	^self invalidCall: _failureCode!

gdipIsClipEmpty: graphics result: result
	"Invoke the GdipIsClipEmpty() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsClipEmpty(
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsClipEmpty handle sdword*>
	^self invalidCall: _failureCode!

gdipIsEmptyRegion: region graphics: graphics result: result
	"Invoke the GdipIsEmptyRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsEmptyRegion(
			PGpRegion region,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsEmptyRegion handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsEqualRegion: region region2: region2 graphics: graphics result: result
	"Invoke the GdipIsEqualRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsEqualRegion(
			PGpRegion region,
			PGpRegion region2,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsEqualRegion handle handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsInfiniteRegion: region graphics: graphics result: result
	"Invoke the GdipIsInfiniteRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsInfiniteRegion(
			PGpRegion region,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsInfiniteRegion handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsMatrixEqual: matrix matrix2: matrix2 result: result
	"Invoke the GdipIsMatrixEqual() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixEqual(
			[in]PGpMatrix matrix,
			[in]PGpMatrix matrix2,
			long* result);"

	<stdcall: errno GdipIsMatrixEqual handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsMatrixIdentity: matrix result: result
	"Invoke the GdipIsMatrixIdentity() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixIdentity(
			[in]PGpMatrix matrix,
			long* result);"

	<stdcall: errno GdipIsMatrixIdentity handle sdword*>
	^self invalidCall: _failureCode!

gdipIsMatrixInvertible: matrix result: result
	"Invoke the GdipIsMatrixInvertible() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixInvertible(
			[in]PGpMatrix matrix,
			long* result);"

	<stdcall: errno GdipIsMatrixInvertible handle sdword*>
	^self invalidCall: _failureCode!

gdipIsOutlineVisiblePathPoint: path x: x y: y pen: pen graphics: graphics result: result
	"Invoke the GdipIsOutlineVisiblePathPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsOutlineVisiblePathPoint(
			PGpPath path,
			REAL x,
			REAL y,
			PGpPen pen,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsOutlineVisiblePathPoint handle float float handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsOutlineVisiblePathPointI: path x: x y: y pen: pen graphics: graphics result: result
	"Invoke the GdipIsOutlineVisiblePathPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsOutlineVisiblePathPointI(
			PGpPath path,
			int x,
			int y,
			PGpPen pen,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsOutlineVisiblePathPointI handle sdword sdword handle handle sdword*>
	^self invalidCall: _failureCode!

gdipIsStyleAvailable: family style: style isStyleAvailable: isStyleAvailable
	"Invoke the GdipIsStyleAvailable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsStyleAvailable(
			[in]PGpFontFamily family,
			int style,
			long* IsStyleAvailable);"

	<stdcall: errno GdipIsStyleAvailable handle sdword sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleClipEmpty: graphics result: result
	"Invoke the GdipIsVisibleClipEmpty() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleClipEmpty(
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisibleClipEmpty handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisiblePathPoint: path x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisiblePathPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePathPoint(
			PGpPath path,
			REAL x,
			REAL y,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisiblePathPoint handle float float handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisiblePathPointI: path x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisiblePathPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePathPointI(
			PGpPath path,
			int x,
			int y,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisiblePathPointI handle sdword sdword handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisiblePoint: graphics x: x y: y result: result
	"Invoke the GdipIsVisiblePoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePoint(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			long* result);"

	<stdcall: errno GdipIsVisiblePoint handle float float sdword*>
	^self invalidCall: _failureCode!

gdipIsVisiblePointI: graphics x: x y: y result: result
	"Invoke the GdipIsVisiblePointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePointI(
			PGpGraphics graphics,
			int x,
			int y,
			long* result);"

	<stdcall: errno GdipIsVisiblePointI handle sdword sdword sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRect: graphics x: x y: y width: width height: height result: result
	"Invoke the GdipIsVisibleRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRect(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			long* result);"

	<stdcall: errno GdipIsVisibleRect handle float float float float sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRectI: graphics x: x y: y width: width height: height result: result
	"Invoke the GdipIsVisibleRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRectI(
			PGpGraphics graphics,
			int x,
			int y,
			int Width,
			int Height,
			long* result);"

	<stdcall: errno GdipIsVisibleRectI handle sdword sdword sdword sdword sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionPoint: region x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionPoint(
			PGpRegion region,
			REAL x,
			REAL y,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisibleRegionPoint handle float float handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionPointI: region x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionPointI(
			PGpRegion region,
			int x,
			int y,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisibleRegionPointI handle sdword sdword handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionRect: region x: x y: y width: width height: height graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionRect(
			PGpRegion region,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisibleRegionRect handle float float float float handle sdword*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionRectI: region x: x y: y width: width height: height graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionRectI(
			PGpRegion region,
			int x,
			int y,
			int Width,
			int Height,
			PGpGraphics graphics,
			long* result);"

	<stdcall: errno GdipIsVisibleRegionRectI handle sdword sdword sdword sdword handle sdword*>
	^self invalidCall: _failureCode!

gdipLoadImageFromFile: filename image: image
	"Invoke the GdipLoadImageFromFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipLoadImageFromFile(
			[in]LPWSTR filename,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipLoadImageFromFile lpwstr handle*>
	^self invalidCall: _failureCode!

gdipLoadImageFromFileICM: filename image: image
	"Invoke the GdipLoadImageFromFileICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipLoadImageFromFileICM(
			[in]LPWSTR filename,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipLoadImageFromFileICM lpwstr handle*>
	^self invalidCall: _failureCode!

gdipLoadImageFromStream: stream image: image
	"Invoke the GdipLoadImageFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipLoadImageFromStream(
			[in]IStream* stream,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipLoadImageFromStream COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipLoadImageFromStreamICM: stream image: image
	"Invoke the GdipLoadImageFromStreamICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipLoadImageFromStreamICM(
			[in]IStream* stream,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipLoadImageFromStreamICM COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdiplusNotificationHook: token1
	"Invoke the GdiplusNotificationHook() function of the module wrapped by the receiver.

		GpStatus __stdcall GdiplusNotificationHook(
			ULONG_PTR* token);"

	<stdcall: errno GdiplusNotificationHook uintptr*>
	^self invalidCall: _failureCode!

gdiplusNotificationUnhook: token1
	"Invoke the GdiplusNotificationUnhook() function of the module wrapped by the receiver.

		void __stdcall GdiplusNotificationUnhook(
			ULONG_PTR token);"

	<stdcall: void GdiplusNotificationUnhook uintptr>
	^self invalidCall: _failureCode!

gdiplusShutdown: token1
	"Invoke the GdiplusShutdown() function of the module wrapped by the receiver.

		void __stdcall GdiplusShutdown(
			[in]ULONG_PTR token);"

	<stdcall: void GdiplusStartup uintptr>
	^self invalidCall: _failureCode!

gdiplusStartup: token1 input: input output: output
	"Invoke the GdiplusStartup() function of the module wrapped by the receiver.

		GpStatus __stdcall GdiplusStartup(
			[out]ULONG_PTR* token,
			[in]GdiplusStartupInput* input,
			[out]GdiplusStartupOutput* output);"

	<stdcall: errno GdiplusStartup uintptr* GdiplusStartupInput* GdiplusStartupOutput*>
	^self invalidCall: _failureCode!

gdipMeasureCharacterRanges: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat regionCount: regionCount regions: regions
	"Invoke the GdipMeasureCharacterRanges() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMeasureCharacterRanges(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RECTF* layoutRect,
			[in]PGpStringFormat stringFormat,
			int regionCount,
			[out, retval]PGpRegion* regions);"

	<stdcall: errno GdipMeasureCharacterRanges handle lpwstr sdword handle RECTF* handle sdword handle*>
	^self invalidCall: _failureCode!

gdipMeasureDriverString: graphics text: text length: length font: font positions: positions flags: flags matrix: matrix boundingBox: boundingBox
	"Invoke the GdipMeasureDriverString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMeasureDriverString(
			PGpGraphics graphics,
			[in]UINT16* text,
			int length,
			[in]PGpFont font,
			[in]POINTF* positions,
			int Flags,
			[in]PGpMatrix matrix,
			RECTF* BoundingBox);"

	<stdcall: errno GdipMeasureDriverString handle word* sdword handle POINTF* sdword handle RECTF*>
	^self invalidCall: _failureCode!

gdipMeasureString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat boundingBox: boundingBox codepointsFitted: codepointsFitted linesFilled: linesFilled
	"Invoke the GdipMeasureString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMeasureString(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RECTF* layoutRect,
			[in]PGpStringFormat stringFormat,
			RECTF* BoundingBox,
			int* codepointsFitted,
			int* linesFilled);"

	<stdcall: errno GdipMeasureString handle lpwstr sdword handle RECTF* handle RECTF* sdword* sdword*>
	^self invalidCall: _failureCode!

gdipMultiplyLineTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyLineTransform(
			PGpLineGradient brush,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyLineTransform handle handle sdword>
	^self invalidCall: _failureCode!

gdipMultiplyMatrix: matrix matrix2: matrix2 order: order
	"Invoke the GdipMultiplyMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyMatrix(
			PGpMatrix matrix,
			PGpMatrix matrix2,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyMatrix handle handle sdword>
	^self invalidCall: _failureCode!

gdipMultiplyPathGradientTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyPathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyPathGradientTransform(
			PGpPathGradient brush,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyPathGradientTransform handle handle sdword>
	^self invalidCall: _failureCode!

gdipMultiplyPenTransform: pen matrix: matrix order: order
	"Invoke the GdipMultiplyPenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyPenTransform(
			PGpPen pen,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyPenTransform handle handle sdword>
	^self invalidCall: _failureCode!

gdipMultiplyTextureTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyTextureTransform(
			[in]PGpTexture brush,
			[in]PGpMatrix matrix,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyTextureTransform handle handle sdword>
	^self invalidCall: _failureCode!

gdipMultiplyWorldTransform: graphics matrix: matrix order: order
	"Invoke the GdipMultiplyWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyWorldTransform(
			PGpGraphics graphics,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyWorldTransform handle handle sdword>
	^self invalidCall: _failureCode!

gdipNewInstalledFontCollection: fontCollection
	"Invoke the GdipNewInstalledFontCollection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipNewInstalledFontCollection(
			[out, retval]PGpFontCollection* fontCollection);"

	<stdcall: errno GdipNewInstalledFontCollection handle*>
	^self invalidCall: _failureCode!

gdipNewPrivateFontCollection: fontCollection
	"Invoke the GdipNewPrivateFontCollection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipNewPrivateFontCollection(
			[out, retval]PGpFontCollection* fontCollection);"

	<stdcall: errno GdipNewPrivateFontCollection handle*>
	^self invalidCall: _failureCode!

gdipPathIterCopyData: iterator resultCount: resultCount points: points types: types startIndex: startIndex endIndex: endIndex
	"Invoke the GdipPathIterCopyData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterCopyData(
			PGpPathIterator iterator,
			int* resultCount,
			GpPointF* Points,
			BYTE* Types,
			int startIndex,
			int endIndex);"

	<stdcall: errno GdipPathIterCopyData handle sdword* POINTF* byte* sdword sdword>
	^self invalidCall: _failureCode!

gdipPathIterEnumerate: iterator resultCount: resultCount points: points types: types count: count
	"Invoke the GdipPathIterEnumerate() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterEnumerate(
			PGpPathIterator iterator,
			int* resultCount,
			GpPointF* Points,
			BYTE* Types,
			int Count);"

	<stdcall: errno GdipPathIterEnumerate handle sdword* POINTF* byte* sdword>
	^self invalidCall: _failureCode!

gdipPathIterGetCount: iterator count: count
	"Invoke the GdipPathIterGetCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterGetCount(
			PGpPathIterator iterator,
			int* Count);"

	<stdcall: errno GdipPathIterGetCount handle sdword*>
	^self invalidCall: _failureCode!

gdipPathIterGetSubpathCount: iterator count: count
	"Invoke the GdipPathIterGetSubpathCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterGetSubpathCount(
			PGpPathIterator iterator,
			int* Count);"

	<stdcall: errno GdipPathIterGetSubpathCount handle sdword*>
	^self invalidCall: _failureCode!

gdipPathIterHasCurve: iterator hasCurve: hasCurve
	"Invoke the GdipPathIterHasCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterHasCurve(
			PGpPathIterator iterator,
			long* hasCurve);"

	<stdcall: errno GdipPathIterHasCurve handle sdword*>
	^self invalidCall: _failureCode!

gdipPathIterIsValid: iterator valid: valid
	"Invoke the GdipPathIterIsValid() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterIsValid(
			PGpPathIterator iterator,
			long* valid);"

	<stdcall: errno GdipPathIterIsValid handle sdword*>
	^self invalidCall: _failureCode!

gdipPathIterNextMarker: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex
	"Invoke the GdipPathIterNextMarker() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextMarker(
			PGpPathIterator iterator,
			int* resultCount,
			int* startIndex,
			int* endIndex);"

	<stdcall: errno GdipPathIterNextMarker handle sdword* sdword* sdword*>
	^self invalidCall: _failureCode!

gdipPathIterNextMarkerPath: iterator resultCount: resultCount path: path
	"Invoke the GdipPathIterNextMarkerPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextMarkerPath(
			PGpPathIterator iterator,
			int* resultCount,
			PGpPath path);"

	<stdcall: errno GdipPathIterNextMarkerPath handle sdword* handle>
	^self invalidCall: _failureCode!

gdipPathIterNextPathType: iterator resultCount: resultCount pathType: pathType startIndex: startIndex endIndex: endIndex
	"Invoke the GdipPathIterNextPathType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextPathType(
			PGpPathIterator iterator,
			int* resultCount,
			BYTE* pathType,
			int* startIndex,
			int* endIndex);"

	<stdcall: errno GdipPathIterNextPathType handle sdword* byte* sdword* sdword*>
	^self invalidCall: _failureCode!

gdipPathIterNextSubpath: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex isClosed: isClosed
	"Invoke the GdipPathIterNextSubpath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextSubpath(
			PGpPathIterator iterator,
			int* resultCount,
			int* startIndex,
			int* endIndex,
			long* isClosed);"

	<stdcall: errno GdipPathIterNextSubpath handle sdword* sdword* sdword* sdword*>
	^self invalidCall: _failureCode!

gdipPathIterNextSubpathPath: iterator resultCount: resultCount path: path isClosed: isClosed
	"Invoke the GdipPathIterNextSubpathPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextSubpathPath(
			PGpPathIterator iterator,
			int* resultCount,
			PGpPath path,
			long* isClosed);"

	<stdcall: errno GdipPathIterNextSubpathPath handle sdword* handle sdword*>
	^self invalidCall: _failureCode!

gdipPathIterRewind: iterator
	"Invoke the GdipPathIterRewind() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterRewind(
			PGpPathIterator iterator);"

	<stdcall: errno GdipPathIterRewind handle>
	^self invalidCall: _failureCode!

gdipPlayMetafileRecord: metafile recordType: recordType flags: flags dataSize: dataSize data: data
	"Invoke the GdipPlayMetafileRecord() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPlayMetafileRecord(
			[in]PGpMetafile metafile,
			EmfPlusRecordType recordType,
			unsigned int Flags,
			unsigned int dataSize,
			[in]BYTE* data);"

	<stdcall: errno GdipPlayMetafileRecord handle sdword dword dword byte*>
	^self invalidCall: _failureCode!

gdipPrivateAddFontFile: fontCollection filename: filename
	"Invoke the GdipPrivateAddFontFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPrivateAddFontFile(
			PGpFontCollection fontCollection,
			[in]LPWSTR filename);"

	<stdcall: errno GdipPrivateAddFontFile handle lpwstr>
	^self invalidCall: _failureCode!

gdipPrivateAddMemoryFont: fontCollection memory: memory length: length
	"Invoke the GdipPrivateAddMemoryFont() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPrivateAddMemoryFont(
			PGpFontCollection fontCollection,
			[in]void* memory,
			int length);"

	<stdcall: errno GdipPrivateAddMemoryFont handle void* sdword>
	^self invalidCall: _failureCode!

gdipRecordMetafile: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafile(
			HDC referenceHdc,
			EmfType Type,
			[in]GpRectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafile handle sdword RECTF* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileFileName: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileFileName() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileFileName(
			[in]LPWSTR filename,
			HDC referenceHdc,
			EmfType Type,
			[in]GpRectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileFileName lpwstr handle sdword RECTF* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileFileNameI: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileFileNameI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileFileNameI(
			[in]LPWSTR filename,
			HDC referenceHdc,
			EmfType Type,
			[in]GpRect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileFileNameI lpwstr handle sdword RECTL* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileI: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileI(
			HDC referenceHdc,
			EmfType Type,
			[in]GpRect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileI handle sdword RECTL* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileStream: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileStream(
			IStream* stream,
			HDC referenceHdc,
			EmfType Type,
			[in]GpRectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileStream COM.IStream* handle sdword RECTF* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileStreamI: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileStreamI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileStreamI(
			IStream* stream,
			HDC referenceHdc,
			EmfType Type,
			[in]GpRect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileStreamI COM.IStream* handle sdword RECTL* sdword lpwstr handle*>
	^self invalidCall: _failureCode!

gdipReleaseDC: graphics hdc: hdc
	"Invoke the GdipReleaseDC() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipReleaseDC(
			PGpGraphics graphics,
			HDC HDC);"

	<stdcall: errno GdipReleaseDC handle handle>
	^self invalidCall: _failureCode!

gdipRemovePropertyItem: image propId: propId
	"Invoke the GdipRemovePropertyItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRemovePropertyItem(
			[in]PGpImage image,
			[in]unsigned long propId);"

	<stdcall: errno GdipRemovePropertyItem handle dword>
	^self invalidCall: _failureCode!

gdipResetClip: graphics
	"Invoke the GdipResetClip() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetClip(
			PGpGraphics graphics);"

	<stdcall: errno GdipResetClip handle>
	^self invalidCall: _failureCode!

gdipResetImageAttributes: imageattr type: type
	"Invoke the GdipResetImageAttributes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetImageAttributes(
			PGpImageAttributes imageattr,
			ColorAdjustType Type);"

	<stdcall: errno GdipResetImageAttributes handle sdword>
	^self invalidCall: _failureCode!

gdipResetLineTransform: brush
	"Invoke the GdipResetLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetLineTransform(
			PGpLineGradient brush);"

	<stdcall: errno GdipResetLineTransform handle>
	^self invalidCall: _failureCode!

gdipResetPageTransform: graphics
	"Invoke the GdipResetPageTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetPageTransform(
			PGpGraphics graphics);"

	<stdcall: errno GdipResetPageTransform handle>
	^self invalidCall: _failureCode!

gdipResetPath: path
	"Invoke the GdipResetPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetPath(
			PGpPath path);"

	<stdcall: errno GdipResetPath handle>
	^self invalidCall: _failureCode!

gdipResetPathGradientTransform: brush
	"Invoke the GdipResetPathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetPathGradientTransform(
			PGpPathGradient brush);"

	<stdcall: errno GdipResetPathGradientTransform handle>
	^self invalidCall: _failureCode!

gdipResetPenTransform: pen
	"Invoke the GdipResetPenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetPenTransform(
			PGpPen pen);"

	<stdcall: errno GdipResetPenTransform handle>
	^self invalidCall: _failureCode!

gdipResetTextureTransform: brush
	"Invoke the GdipResetTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetTextureTransform(
			[in]PGpTexture brush);"

	<stdcall: errno GdipResetTextureTransform handle>
	^self invalidCall: _failureCode!

gdipResetWorldTransform: graphics
	"Invoke the GdipResetWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipResetWorldTransform(
			PGpGraphics graphics);"

	<stdcall: errno GdipResetWorldTransform handle>
	^self invalidCall: _failureCode!

gdipRestoreGraphics: graphics state: state
	"Invoke the GdipRestoreGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRestoreGraphics(
			PGpGraphics graphics,
			GraphicsState state);"

	<stdcall: errno GdipRestoreGraphics handle dword>
	^self invalidCall: _failureCode!

gdipReversePath: path
	"Invoke the GdipReversePath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipReversePath(
			PGpPath path);"

	<stdcall: errno GdipReversePath handle>
	^self invalidCall: _failureCode!

gdipRotateLineTransform: brush angle: angle order: order
	"Invoke the GdipRotateLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateLineTransform(
			PGpLineGradient brush,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotateLineTransform handle float sdword>
	^self invalidCall: _failureCode!

gdipRotateMatrix: matrix angle: angle order: order
	"Invoke the GdipRotateMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateMatrix(
			PGpMatrix matrix,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotateMatrix handle float sdword>
	^self invalidCall: _failureCode!

gdipRotatePathGradientTransform: brush angle: angle order: order
	"Invoke the GdipRotatePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotatePathGradientTransform(
			PGpPathGradient brush,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotatePathGradientTransform handle float sdword>
	^self invalidCall: _failureCode!

gdipRotatePenTransform: pen angle: angle order: order
	"Invoke the GdipRotatePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotatePenTransform(
			PGpPen pen,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotatePenTransform handle float sdword>
	^self invalidCall: _failureCode!

gdipRotateTextureTransform: brush angle: angle order: order
	"Invoke the GdipRotateTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateTextureTransform(
			[in]PGpTexture brush,
			[in]REAL angle,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipRotateTextureTransform handle float sdword>
	^self invalidCall: _failureCode!

gdipRotateWorldTransform: graphics angle: angle order: order
	"Invoke the GdipRotateWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateWorldTransform(
			PGpGraphics graphics,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotateWorldTransform handle float sdword>
	^self invalidCall: _failureCode!

gdipSaveAdd: image encoderParams: encoderParams
	"Invoke the GdipSaveAdd() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveAdd(
			[in]PGpImage image,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveAdd handle GpEncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveAddImage: image newImage: newImage encoderParams: encoderParams
	"Invoke the GdipSaveAddImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveAddImage(
			[in]PGpImage image,
			[in]PGpImage newImage,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveAddImage handle handle GpEncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveGraphics: graphics state: state
	"Invoke the GdipSaveGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveGraphics(
			PGpGraphics graphics,
			GraphicsState* state);"

	<stdcall: errno GdipSaveGraphics handle dword*>
	^self invalidCall: _failureCode!

gdipSaveImageToFile: image filename: filename clsidEncoder: clsidEncoder encoderParams: encoderParams
	"Invoke the GdipSaveImageToFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveImageToFile(
			[in]PGpImage image,
			[in]LPWSTR filename,
			[in]GUID* clsidEncoder,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveImageToFile handle lpwstr guid* GpEncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveImageToStream: image stream: stream clsidEncoder: clsidEncoder encoderParams: encoderParams
	"Invoke the GdipSaveImageToStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveImageToStream(
			[in]PGpImage image,
			[in]IStream* stream,
			[in]GUID* clsidEncoder,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveImageToStream handle COM.IStream* guid* GpEncoderParameters*>
	^self invalidCall: _failureCode!

gdipScaleLineTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScaleLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleLineTransform(
			PGpLineGradient brush,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleLineTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipScaleMatrix: matrix scaleX: scaleX scaleY: scaleY order: order
	"Invoke the GdipScaleMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleMatrix(
			PGpMatrix matrix,
			REAL scaleX,
			REAL scaleY,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleMatrix handle float float sdword>
	^self invalidCall: _failureCode!

gdipScalePathGradientTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScalePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScalePathGradientTransform(
			PGpPathGradient brush,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScalePathGradientTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipScalePenTransform: pen sx: sx sy: sy order: order
	"Invoke the GdipScalePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScalePenTransform(
			PGpPen pen,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScalePenTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipScaleTextureTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScaleTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleTextureTransform(
			[in]PGpTexture brush,
			[in]REAL sx,
			[in]REAL sy,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipScaleTextureTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipScaleWorldTransform: graphics sx: sx sy: sy order: order
	"Invoke the GdipScaleWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleWorldTransform(
			PGpGraphics graphics,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleWorldTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapFillState: cap fillState: fillState
	"Invoke the GdipSetAdjustableArrowCapFillState() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapFillState(
			PGpAdjustableArrowCap cap,
			long fillState);"

	<stdcall: errno GdipSetAdjustableArrowCapFillState handle sdword>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapHeight: cap height: height
	"Invoke the GdipSetAdjustableArrowCapHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapHeight(
			PGpAdjustableArrowCap cap,
			REAL Height);"

	<stdcall: errno GdipSetAdjustableArrowCapHeight handle float>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapMiddleInset: cap middleInset: middleInset
	"Invoke the GdipSetAdjustableArrowCapMiddleInset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapMiddleInset(
			PGpAdjustableArrowCap cap,
			REAL middleInset);"

	<stdcall: errno GdipSetAdjustableArrowCapMiddleInset handle float>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapWidth: cap width: width
	"Invoke the GdipSetAdjustableArrowCapWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapWidth(
			PGpAdjustableArrowCap cap,
			REAL Width);"

	<stdcall: errno GdipSetAdjustableArrowCapWidth handle float>
	^self invalidCall: _failureCode!

gdipSetClipGraphics: graphics srcgraphics: srcgraphics combineMode: combineMode
	"Invoke the GdipSetClipGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipGraphics(
			PGpGraphics graphics,
			PGpGraphics srcgraphics,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipGraphics handle handle sdword>
	^self invalidCall: _failureCode!

gdipSetClipHrgn: graphics hRgn: hRgn combineMode: combineMode
	"Invoke the GdipSetClipHrgn() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipHrgn(
			PGpGraphics graphics,
			void* hRgn,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipHrgn handle void* sdword>
	^self invalidCall: _failureCode!

gdipSetClipPath: graphics path: path combineMode: combineMode
	"Invoke the GdipSetClipPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipPath(
			PGpGraphics graphics,
			PGpPath path,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipPath handle handle sdword>
	^self invalidCall: _failureCode!

gdipSetClipRect: graphics x: x y: y width: width height: height combineMode: combineMode
	"Invoke the GdipSetClipRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRect(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			REAL Width,
			REAL Height,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRect handle float float float float sdword>
	^self invalidCall: _failureCode!

gdipSetClipRectI: graphics x: x y: y width: width height: height combineMode: combineMode
	"Invoke the GdipSetClipRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRectI(
			PGpGraphics graphics,
			int x,
			int y,
			int Width,
			int Height,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRectI handle sdword sdword sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipSetClipRegion: graphics region: region combineMode: combineMode
	"Invoke the GdipSetClipRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRegion(
			PGpGraphics graphics,
			PGpRegion region,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRegion handle handle sdword>
	^self invalidCall: _failureCode!

gdipSetCompositingMode: graphics compositingMode: compositingMode
	"Invoke the GdipSetCompositingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCompositingMode(
			PGpGraphics graphics,
			CompositingMode CompositingMode);"

	<stdcall: errno GdipSetCompositingMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetCompositingQuality: graphics compositingQuality: compositingQuality
	"Invoke the GdipSetCompositingQuality() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCompositingQuality(
			PGpGraphics graphics,
			CompositingQuality CompositingQuality);"

	<stdcall: errno GdipSetCompositingQuality handle sdword>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapBaseCap: customCap baseCap: baseCap
	"Invoke the GdipSetCustomLineCapBaseCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapBaseCap(
			PGpCustomLineCap customCap,
			GpLineCap baseCap);"

	<stdcall: errno GdipSetCustomLineCapBaseCap handle sdword>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapBaseInset: customCap inset: inset
	"Invoke the GdipSetCustomLineCapBaseInset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapBaseInset(
			PGpCustomLineCap customCap,
			REAL inset);"

	<stdcall: errno GdipSetCustomLineCapBaseInset handle float>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap
	"Invoke the GdipSetCustomLineCapStrokeCaps() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapStrokeCaps(
			PGpCustomLineCap customCap,
			GpLineCap startCap,
			GpLineCap endCap);"

	<stdcall: errno GdipSetCustomLineCapStrokeCaps handle sdword sdword>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	"Invoke the GdipSetCustomLineCapStrokeJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapStrokeJoin(
			PGpCustomLineCap customCap,
			GpLineJoin LineJoin);"

	<stdcall: errno GdipSetCustomLineCapStrokeJoin handle sdword>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapWidthScale: customCap widthScale: widthScale
	"Invoke the GdipSetCustomLineCapWidthScale() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapWidthScale(
			PGpCustomLineCap customCap,
			REAL widthScale);"

	<stdcall: errno GdipSetCustomLineCapWidthScale handle float>
	^self invalidCall: _failureCode!

gdipSetEmpty: region
	"Invoke the GdipSetEmpty() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetEmpty(
			PGpRegion region);"

	<stdcall: errno GdipSetEmpty handle>
	^self invalidCall: _failureCode!

gdipSetImageAttributesCachedBackground: imageattr enableFlag: enableFlag
	"Invoke the GdipSetImageAttributesCachedBackground() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesCachedBackground(
			PGpImageAttributes imageattr,
			long enableFlag);"

	<stdcall: errno GdipSetImageAttributesCachedBackground handle sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesColorKeys: imageattr type: type enableFlag: enableFlag colorLow: colorLow colorHigh: colorHigh
	"Invoke the GdipSetImageAttributesColorKeys() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesColorKeys(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			ARGB colorLow,
			ARGB colorHigh);"

	<stdcall: errno GdipSetImageAttributesColorKeys handle sdword sdword dword dword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesColorMatrix: imageattr type: type enableFlag: enableFlag colorMatrix: colorMatrix grayMatrix: grayMatrix flags: flags
	"Invoke the GdipSetImageAttributesColorMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesColorMatrix(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			[in]ColorMatrix* ColorMatrix,
			[in]ColorMatrix* grayMatrix,
			ColorMatrixFlags Flags);"

	<stdcall: errno GdipSetImageAttributesColorMatrix handle sdword sdword GpColorMatrix* GpColorMatrix* sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesGamma: imageattr type: type enableFlag: enableFlag gamma: gamma
	"Invoke the GdipSetImageAttributesGamma() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesGamma(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			REAL gamma);"

	<stdcall: errno GdipSetImageAttributesGamma handle sdword sdword float>
	^self invalidCall: _failureCode!

gdipSetImageAttributesICMMode: imageattr on: on
	"Invoke the GdipSetImageAttributesICMMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesICMMode(
			PGpImageAttributes imageattr,
			long on);"

	<stdcall: errno GdipSetImageAttributesICMMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesNoOp: imageattr type: type enableFlag: enableFlag
	"Invoke the GdipSetImageAttributesNoOp() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesNoOp(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag);"

	<stdcall: errno GdipSetImageAttributesNoOp handle sdword sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesOutputChannel: imageattr type: type enableFlag: enableFlag channelFlags: channelFlags
	"Invoke the GdipSetImageAttributesOutputChannel() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesOutputChannel(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			ColorChannelFlags channelFlags);"

	<stdcall: errno GdipSetImageAttributesOutputChannel handle sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesOutputChannelColorProfile: imageattr type: type enableFlag: enableFlag colorProfileFilename: colorProfileFilename
	"Invoke the GdipSetImageAttributesOutputChannelColorProfile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesOutputChannelColorProfile(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			[in]LPWSTR colorProfileFilename);"

	<stdcall: errno GdipSetImageAttributesOutputChannelColorProfile handle sdword sdword lpwstr>
	^self invalidCall: _failureCode!

gdipSetImageAttributesRemapTable: imageattr type: type enableFlag: enableFlag mapSize: mapSize map: map
	"Invoke the GdipSetImageAttributesRemapTable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesRemapTable(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			unsigned int mapSize,
			[in]ColorMap* map);"

	<stdcall: errno GdipSetImageAttributesRemapTable handle sdword sdword dword GpColorMap*>
	^self invalidCall: _failureCode!

gdipSetImageAttributesThreshold: imageattr type: type enableFlag: enableFlag threshold: threshold
	"Invoke the GdipSetImageAttributesThreshold() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesThreshold(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			long enableFlag,
			REAL threshold);"

	<stdcall: errno GdipSetImageAttributesThreshold handle sdword sdword float>
	^self invalidCall: _failureCode!

gdipSetImageAttributesToIdentity: imageattr type: type
	"Invoke the GdipSetImageAttributesToIdentity() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesToIdentity(
			PGpImageAttributes imageattr,
			ColorAdjustType Type);"

	<stdcall: errno GdipSetImageAttributesToIdentity handle sdword>
	^self invalidCall: _failureCode!

gdipSetImageAttributesWrapMode: imageattr wrap: wrap argb: argb clamp: clamp
	"Invoke the GdipSetImageAttributesWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesWrapMode(
			PGpImageAttributes imageattr,
			WrapMode wrap,
			ARGB ARGB,
			long clamp);"

	<stdcall: errno GdipSetImageAttributesWrapMode handle sdword dword sdword>
	^self invalidCall: _failureCode!

gdipSetImagePalette: image palette: palette
	"Invoke the GdipSetImagePalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImagePalette(
			[in]PGpImage image,
			[in]ColorPalette* palette);"

	<stdcall: errno GdipSetImagePalette handle GpColorPalette*>
	^self invalidCall: _failureCode!

gdipSetInfinite: region
	"Invoke the GdipSetInfinite() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetInfinite(
			PGpRegion region);"

	<stdcall: errno GdipSetInfinite handle>
	^self invalidCall: _failureCode!

gdipSetInterpolationMode: graphics interpolationMode: interpolationMode
	"Invoke the GdipSetInterpolationMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetInterpolationMode(
			PGpGraphics graphics,
			InterpolationMode InterpolationMode);"

	<stdcall: errno GdipSetInterpolationMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetLineBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetLineBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineBlend(
			PGpLineGradient brush,
			[in]REAL* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetLineBlend handle float* float* sdword>
	^self invalidCall: _failureCode!

gdipSetLineColors: brush color1: color1 color2: color2
	"Invoke the GdipSetLineColors() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineColors(
			PGpLineGradient brush,
			ARGB color1,
			ARGB color2);"

	<stdcall: errno GdipSetLineColors handle dword dword>
	^self invalidCall: _failureCode!

gdipSetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipSetLineGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineGammaCorrection(
			PGpLineGradient brush,
			long useGammaCorrection);"

	<stdcall: errno GdipSetLineGammaCorrection handle sdword>
	^self invalidCall: _failureCode!

gdipSetLineLinearBlend: brush focus: focus scale: scale
	"Invoke the GdipSetLineLinearBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineLinearBlend(
			PGpLineGradient brush,
			REAL focus,
			REAL scale);"

	<stdcall: errno GdipSetLineLinearBlend handle float float>
	^self invalidCall: _failureCode!

gdipSetLinePresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetLinePresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLinePresetBlend(
			PGpLineGradient brush,
			[in]ARGB* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetLinePresetBlend handle dword* float* sdword>
	^self invalidCall: _failureCode!

gdipSetLineSigmaBlend: brush focus: focus scale: scale
	"Invoke the GdipSetLineSigmaBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineSigmaBlend(
			PGpLineGradient brush,
			REAL focus,
			REAL scale);"

	<stdcall: errno GdipSetLineSigmaBlend handle float float>
	^self invalidCall: _failureCode!

gdipSetLineTransform: brush matrix: matrix
	"Invoke the GdipSetLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineTransform(
			PGpLineGradient brush,
			[in]PGpMatrix matrix);"

	<stdcall: errno GdipSetLineTransform handle handle>
	^self invalidCall: _failureCode!

gdipSetLineWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipSetLineWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineWrapMode(
			PGpLineGradient brush,
			GpWrapMode WrapMode);"

	<stdcall: errno GdipSetLineWrapMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetMatrixElements: matrix m11: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy
	"Invoke the GdipSetMatrixElements() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetMatrixElements(
			PGpMatrix matrix,
			REAL m11,
			REAL m12,
			REAL m21,
			REAL m22,
			REAL dx,
			REAL dy);"

	<stdcall: errno GdipSetMatrixElements handle float float float float float float>
	^self invalidCall: _failureCode!

gdipSetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi
	"Invoke the GdipSetMetafileDownLevelRasterizationLimit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetMetafileDownLevelRasterizationLimit(
			PGpMetafile metafile,
			unsigned int metafileRasterizationLimitDpi);"

	<stdcall: errno GdipSetMetafileDownLevelRasterizationLimit handle dword>
	^self invalidCall: _failureCode!

gdipSetPageScale: graphics scale: scale
	"Invoke the GdipSetPageScale() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPageScale(
			PGpGraphics graphics,
			REAL scale);"

	<stdcall: errno GdipSetPageScale handle float>
	^self invalidCall: _failureCode!

gdipSetPageUnit: graphics unit: unit
	"Invoke the GdipSetPageUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPageUnit(
			PGpGraphics graphics,
			GpUnit Unit);"

	<stdcall: errno GdipSetPageUnit handle sdword>
	^self invalidCall: _failureCode!

gdipSetPathFillMode: path fillMode: fillMode
	"Invoke the GdipSetPathFillMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathFillMode(
			PGpPath path,
			GpFillMode FillMode);"

	<stdcall: errno GdipSetPathFillMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetPathGradientBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetPathGradientBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientBlend(
			PGpPathGradient brush,
			[in]REAL* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetPathGradientBlend handle float* float* sdword>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterColor: brush colors: colors
	"Invoke the GdipSetPathGradientCenterColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterColor(
			PGpPathGradient brush,
			ARGB colors);"

	<stdcall: errno GdipSetPathGradientCenterColor handle dword>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterPoint: brush points: points
	"Invoke the GdipSetPathGradientCenterPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterPoint(
			PGpPathGradient brush,
			[in]GpPointF* Points);"

	<stdcall: errno GdipSetPathGradientCenterPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterPointI: brush points: points
	"Invoke the GdipSetPathGradientCenterPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterPointI(
			PGpPathGradient brush,
			[in]GpPoint* Points);"

	<stdcall: errno GdipSetPathGradientCenterPointI handle POINTL*>
	^self invalidCall: _failureCode!

gdipSetPathGradientFocusScales: brush xScale: xScale yScale: yScale
	"Invoke the GdipSetPathGradientFocusScales() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientFocusScales(
			PGpPathGradient brush,
			REAL xScale,
			REAL yScale);"

	<stdcall: errno GdipSetPathGradientFocusScales handle float float>
	^self invalidCall: _failureCode!

gdipSetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipSetPathGradientGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientGammaCorrection(
			PGpPathGradient brush,
			long useGammaCorrection);"

	<stdcall: errno GdipSetPathGradientGammaCorrection handle sdword>
	^self invalidCall: _failureCode!

gdipSetPathGradientLinearBlend: brush focus: focus scale: scale
	"Invoke the GdipSetPathGradientLinearBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientLinearBlend(
			PGpPathGradient brush,
			REAL focus,
			REAL scale);"

	<stdcall: errno GdipSetPathGradientLinearBlend handle float float>
	^self invalidCall: _failureCode!

gdipSetPathGradientPath: brush path: path
	"Invoke the GdipSetPathGradientPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientPath(
			PGpPathGradient brush,
			[in]PGpPath path);"

	<stdcall: errno GdipSetPathGradientPath handle handle>
	^self invalidCall: _failureCode!

gdipSetPathGradientPresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetPathGradientPresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientPresetBlend(
			PGpPathGradient brush,
			[in]ARGB* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetPathGradientPresetBlend handle dword* float* sdword>
	^self invalidCall: _failureCode!

gdipSetPathGradientSigmaBlend: brush focus: focus scale: scale
	"Invoke the GdipSetPathGradientSigmaBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientSigmaBlend(
			PGpPathGradient brush,
			REAL focus,
			REAL scale);"

	<stdcall: errno GdipSetPathGradientSigmaBlend handle float float>
	^self invalidCall: _failureCode!

gdipSetPathGradientSurroundColorsWithCount: brush color: color count: count
	"Invoke the GdipSetPathGradientSurroundColorsWithCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientSurroundColorsWithCount(
			PGpPathGradient brush,
			[in]ARGB* Color,
			int* Count);"

	<stdcall: errno GdipSetPathGradientSurroundColorsWithCount handle dword* sdword*>
	^self invalidCall: _failureCode!

gdipSetPathGradientTransform: brush matrix: matrix
	"Invoke the GdipSetPathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientTransform(
			PGpPathGradient brush,
			PGpMatrix matrix);"

	<stdcall: errno GdipSetPathGradientTransform handle handle>
	^self invalidCall: _failureCode!

gdipSetPathGradientWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipSetPathGradientWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientWrapMode(
			PGpPathGradient brush,
			GpWrapMode WrapMode);"

	<stdcall: errno GdipSetPathGradientWrapMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetPathMarker: path
	"Invoke the GdipSetPathMarker() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathMarker(
			PGpPath path);"

	<stdcall: errno GdipSetPathMarker handle>
	^self invalidCall: _failureCode!

gdipSetPenBrushFill: pen brush: brush
	"Invoke the GdipSetPenBrushFill() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenBrushFill(
			PGpPen pen,
			PGpBrush brush);"

	<stdcall: errno GdipSetPenBrushFill handle handle>
	^self invalidCall: _failureCode!

gdipSetPenColor: pen argb: argb
	"Invoke the GdipSetPenColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenColor(
			PGpPen pen,
			ARGB ARGB);"

	<stdcall: errno GdipSetPenColor handle dword>
	^self invalidCall: _failureCode!

gdipSetPenCompoundArray: pen dash: dash count: count
	"Invoke the GdipSetPenCompoundArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenCompoundArray(
			PGpPen pen,
			[in]REAL* dash,
			int Count);"

	<stdcall: errno GdipSetPenCompoundArray handle float* sdword>
	^self invalidCall: _failureCode!

gdipSetPenCustomEndCap: pen customCap: customCap
	"Invoke the GdipSetPenCustomEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenCustomEndCap(
			PGpPen pen,
			PGpCustomLineCap customCap);"

	<stdcall: errno GdipSetPenCustomEndCap handle handle>
	^self invalidCall: _failureCode!

gdipSetPenCustomStartCap: pen customCap: customCap
	"Invoke the GdipSetPenCustomStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenCustomStartCap(
			PGpPen pen,
			PGpCustomLineCap customCap);"

	<stdcall: errno GdipSetPenCustomStartCap handle handle>
	^self invalidCall: _failureCode!

gdipSetPenDashArray: pen dash: dash count: count
	"Invoke the GdipSetPenDashArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashArray(
			PGpPen pen,
			[in]REAL* dash,
			int Count);"

	<stdcall: errno GdipSetPenDashArray handle float* sdword>
	^self invalidCall: _failureCode!

gdipSetPenDashCap197819: pen dashCap: dashCap
	"Invoke the GdipSetPenDashCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashCap197819(
			PGpPen pen,
			GpDashCap DashCap);"

	<stdcall: errno GdipSetPenDashCap197819 handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenDashOffset: pen offset: offset
	"Invoke the GdipSetPenDashOffset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashOffset(
			PGpPen pen,
			REAL offset);"

	<stdcall: errno GdipSetPenDashOffset handle float>
	^self invalidCall: _failureCode!

gdipSetPenDashStyle: pen dashStyle: dashStyle
	"Invoke the GdipSetPenDashStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashStyle(
			PGpPen pen,
			GpDashStyle DashStyle);"

	<stdcall: errno GdipSetPenDashStyle handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenEndCap: pen endCap: endCap
	"Invoke the GdipSetPenEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenEndCap(
			PGpPen pen,
			GpLineCap endCap);"

	<stdcall: errno GdipSetPenEndCap handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenLineCap197819: pen startCap: startCap endCap: endCap dashCap: dashCap
	"Invoke the GdipSetPenLineCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenLineCap197819(
			PGpPen pen,
			GpLineCap startCap,
			GpLineCap endCap,
			GpDashCap DashCap);"

	<stdcall: errno GdipSetPenLineCap197819 handle sdword sdword sdword>
	^self invalidCall: _failureCode!

gdipSetPenLineJoin: pen lineJoin: lineJoin
	"Invoke the GdipSetPenLineJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenLineJoin(
			PGpPen pen,
			GpLineJoin LineJoin);"

	<stdcall: errno GdipSetPenLineJoin handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenMiterLimit: pen miterLimit: miterLimit
	"Invoke the GdipSetPenMiterLimit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenMiterLimit(
			PGpPen pen,
			REAL miterLimit);"

	<stdcall: errno GdipSetPenMiterLimit handle float>
	^self invalidCall: _failureCode!

gdipSetPenMode: pen penMode: penMode
	"Invoke the GdipSetPenMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenMode(
			PGpPen pen,
			GpPenAlignment penMode);"

	<stdcall: errno GdipSetPenMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenStartCap: pen startCap: startCap
	"Invoke the GdipSetPenStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenStartCap(
			PGpPen pen,
			GpLineCap startCap);"

	<stdcall: errno GdipSetPenStartCap handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenTransform: pen matrix: matrix
	"Invoke the GdipSetPenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenTransform(
			PGpPen pen,
			PGpMatrix matrix);"

	<stdcall: errno GdipSetPenTransform handle handle>
	^self invalidCall: _failureCode!

gdipSetPenUnit: pen unit: unit
	"Invoke the GdipSetPenUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenUnit(
			PGpPen pen,
			GpUnit Unit);"

	<stdcall: errno GdipSetPenUnit handle sdword>
	^self invalidCall: _failureCode!

gdipSetPenWidth: pen width: width
	"Invoke the GdipSetPenWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenWidth(
			PGpPen pen,
			REAL Width);"

	<stdcall: errno GdipSetPenWidth handle float>
	^self invalidCall: _failureCode!

gdipSetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	"Invoke the GdipSetPixelOffsetMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPixelOffsetMode(
			PGpGraphics graphics,
			PixelOffsetMode PixelOffsetMode);"

	<stdcall: errno GdipSetPixelOffsetMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetPropertyItem: image item: item
	"Invoke the GdipSetPropertyItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPropertyItem(
			[in]PGpImage image,
			[in]PropertyItem* item);"

	<stdcall: errno GdipSetPropertyItem handle GpPropertyItem*>
	^self invalidCall: _failureCode!

gdipSetRenderingOrigin: graphics x: x y: y
	"Invoke the GdipSetRenderingOrigin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetRenderingOrigin(
			PGpGraphics graphics,
			int x,
			int y);"

	<stdcall: errno GdipSetRenderingOrigin handle sdword sdword>
	^self invalidCall: _failureCode!

gdipSetSmoothingMode: graphics smoothingMode: smoothingMode
	"Invoke the GdipSetSmoothingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetSmoothingMode(
			PGpGraphics graphics,
			SmoothingMode SmoothingMode);"

	<stdcall: errno GdipSetSmoothingMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetSolidFillColor: brush color: color
	"Invoke the GdipSetSolidFillColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetSolidFillColor(
			[in]PGpSolidFill brush,
			[in]ARGB Color);"

	<stdcall: errno GdipSetSolidFillColor handle dword>
	^self invalidCall: _failureCode!

gdipSetStringFormatAlign: format align: align
	"Invoke the GdipSetStringFormatAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatAlign(
			PGpStringFormat format,
			StringAlignment align);"

	<stdcall: errno GdipSetStringFormatAlign handle sdword>
	^self invalidCall: _failureCode!

gdipSetStringFormatDigitSubstitution: format language: language substitute: substitute
	"Invoke the GdipSetStringFormatDigitSubstitution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatDigitSubstitution(
			PGpStringFormat format,
			LANGID language,
			StringDigitSubstitute substitute);"

	<stdcall: errno GdipSetStringFormatDigitSubstitution handle word sdword>
	^self invalidCall: _failureCode!

gdipSetStringFormatFlags: format flags: flags
	"Invoke the GdipSetStringFormatFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatFlags(
			PGpStringFormat format,
			int Flags);"

	<stdcall: errno GdipSetStringFormatFlags handle sdword>
	^self invalidCall: _failureCode!

gdipSetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	"Invoke the GdipSetStringFormatHotkeyPrefix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatHotkeyPrefix(
			PGpStringFormat format,
			int HotkeyPrefix);"

	<stdcall: errno GdipSetStringFormatHotkeyPrefix handle sdword>
	^self invalidCall: _failureCode!

gdipSetStringFormatLineAlign: format align: align
	"Invoke the GdipSetStringFormatLineAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatLineAlign(
			PGpStringFormat format,
			StringAlignment align);"

	<stdcall: errno GdipSetStringFormatLineAlign handle sdword>
	^self invalidCall: _failureCode!

gdipSetStringFormatMeasurableCharacterRanges: format rangeCount: rangeCount ranges: ranges
	"Invoke the GdipSetStringFormatMeasurableCharacterRanges() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatMeasurableCharacterRanges(
			PGpStringFormat format,
			int rangeCount,
			[in]CharacterRange* ranges);"

	<stdcall: errno GdipSetStringFormatMeasurableCharacterRanges handle sdword GpCharacterRange*>
	^self invalidCall: _failureCode!

gdipSetStringFormatTabStops: format firstTabOffset: firstTabOffset count: count tabStops: tabStops
	"Invoke the GdipSetStringFormatTabStops() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatTabStops(
			PGpStringFormat format,
			REAL firstTabOffset,
			int Count,
			[in]REAL* tabStops);"

	<stdcall: errno GdipSetStringFormatTabStops handle float sdword float*>
	^self invalidCall: _failureCode!

gdipSetStringFormatTrimming: format trimming: trimming
	"Invoke the GdipSetStringFormatTrimming() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatTrimming(
			PGpStringFormat format,
			StringTrimming trimming);"

	<stdcall: errno GdipSetStringFormatTrimming handle sdword>
	^self invalidCall: _failureCode!

gdipSetTextContrast: graphics contrast: contrast
	"Invoke the GdipSetTextContrast() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextContrast(
			PGpGraphics graphics,
			unsigned int contrast);"

	<stdcall: errno GdipSetTextContrast handle dword>
	^self invalidCall: _failureCode!

gdipSetTextRenderingHint: graphics mode: mode
	"Invoke the GdipSetTextRenderingHint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextRenderingHint(
			PGpGraphics graphics,
			TextRenderingHint mode);"

	<stdcall: errno GdipSetTextRenderingHint handle sdword>
	^self invalidCall: _failureCode!

gdipSetTextureTransform: brush matrix: matrix
	"Invoke the GdipSetTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextureTransform(
			[in]PGpTexture brush,
			[in]PGpMatrix matrix);"

	<stdcall: errno GdipSetTextureTransform handle handle>
	^self invalidCall: _failureCode!

gdipSetTextureWrapMode: brush wrapMode: wrapMode
	"Invoke the GdipSetTextureWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextureWrapMode(
			[in]PGpTexture brush,
			[in]GpWrapMode WrapMode);"

	<stdcall: errno GdipSetTextureWrapMode handle sdword>
	^self invalidCall: _failureCode!

gdipSetWorldTransform: graphics matrix: matrix
	"Invoke the GdipSetWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetWorldTransform(
			PGpGraphics graphics,
			PGpMatrix matrix);"

	<stdcall: errno GdipSetWorldTransform handle handle>
	^self invalidCall: _failureCode!

gdipShearMatrix: matrix shearX: shearX shearY: shearY order: order
	"Invoke the GdipShearMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipShearMatrix(
			PGpMatrix matrix,
			REAL shearX,
			REAL shearY,
			GpMatrixOrder order);"

	<stdcall: errno GdipShearMatrix handle float float sdword>
	^self invalidCall: _failureCode!

gdipStartPathFigure: path
	"Invoke the GdipStartPathFigure() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipStartPathFigure(
			PGpPath path);"

	<stdcall: errno GdipStartPathFigure handle>
	^self invalidCall: _failureCode!

gdipStringFormatGetGenericDefault: format
	"Invoke the GdipStringFormatGetGenericDefault() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipStringFormatGetGenericDefault(
			[out, retval]PGpStringFormat* format);"

	<stdcall: errno GdipStringFormatGetGenericDefault handle*>
	^self invalidCall: _failureCode!

gdipStringFormatGetGenericTypographic: format
	"Invoke the GdipStringFormatGetGenericTypographic() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipStringFormatGetGenericTypographic(
			[out, retval]PGpStringFormat* format);"

	<stdcall: errno GdipStringFormatGetGenericTypographic handle*>
	^self invalidCall: _failureCode!

gdipTestControl: cntrl param: param
	"Invoke the GdipTestControl() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTestControl(
			GpTestControlEnum cntrl,
			VOID* param);"

	<stdcall: errno GdipTestControl sdword void*>
	^self invalidCall: _failureCode!

gdipTransformMatrixPoints: matrix pts: pts count: count
	"Invoke the GdipTransformMatrixPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformMatrixPoints(
			PGpMatrix matrix,
			GpPointF* pts,
			int Count);"

	<stdcall: errno GdipTransformMatrixPoints handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipTransformMatrixPointsI: matrix pts: pts count: count
	"Invoke the GdipTransformMatrixPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformMatrixPointsI(
			PGpMatrix matrix,
			GpPoint* pts,
			int Count);"

	<stdcall: errno GdipTransformMatrixPointsI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipTransformPath: path matrix: matrix
	"Invoke the GdipTransformPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformPath(
			PGpPath path,
			PGpMatrix matrix);"

	<stdcall: errno GdipTransformPath handle handle>
	^self invalidCall: _failureCode!

gdipTransformPoints: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count
	"Invoke the GdipTransformPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformPoints(
			PGpGraphics graphics,
			GpCoordinateSpace destSpace,
			GpCoordinateSpace srcSpace,
			GpPointF* Points,
			int Count);"

	<stdcall: errno GdipTransformPoints handle sdword sdword POINTF* sdword>
	^self invalidCall: _failureCode!

gdipTransformPointsI: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count
	"Invoke the GdipTransformPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformPointsI(
			PGpGraphics graphics,
			GpCoordinateSpace destSpace,
			GpCoordinateSpace srcSpace,
			GpPoint* Points,
			int Count);"

	<stdcall: errno GdipTransformPointsI handle sdword sdword POINTL* sdword>
	^self invalidCall: _failureCode!

gdipTransformRegion: region matrix: matrix
	"Invoke the GdipTransformRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformRegion(
			PGpRegion region,
			PGpMatrix matrix);"

	<stdcall: errno GdipTransformRegion handle handle>
	^self invalidCall: _failureCode!

gdipTranslateClip: graphics dx: dx dy: dy
	"Invoke the GdipTranslateClip() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateClip(
			PGpGraphics graphics,
			REAL dx,
			REAL dy);"

	<stdcall: errno GdipTranslateClip handle float float>
	^self invalidCall: _failureCode!

gdipTranslateClipI: graphics dx: dx dy: dy
	"Invoke the GdipTranslateClipI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateClipI(
			PGpGraphics graphics,
			int dx,
			int dy);"

	<stdcall: errno GdipTranslateClipI handle sdword sdword>
	^self invalidCall: _failureCode!

gdipTranslateLineTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslateLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateLineTransform(
			PGpLineGradient brush,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateLineTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipTranslateMatrix: matrix offsetX: offsetX offsetY: offsetY order: order
	"Invoke the GdipTranslateMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateMatrix(
			PGpMatrix matrix,
			REAL offsetX,
			REAL offsetY,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateMatrix handle float float sdword>
	^self invalidCall: _failureCode!

gdipTranslatePathGradientTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslatePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslatePathGradientTransform(
			PGpPathGradient brush,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslatePathGradientTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipTranslatePenTransform: pen dx: dx dy: dy order: order
	"Invoke the GdipTranslatePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslatePenTransform(
			PGpPen pen,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslatePenTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipTranslateRegion: region dx: dx dy: dy
	"Invoke the GdipTranslateRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateRegion(
			PGpRegion region,
			REAL dx,
			REAL dy);"

	<stdcall: errno GdipTranslateRegion handle float float>
	^self invalidCall: _failureCode!

gdipTranslateRegionI: region dx: dx dy: dy
	"Invoke the GdipTranslateRegionI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateRegionI(
			PGpRegion region,
			int dx,
			int dy);"

	<stdcall: errno GdipTranslateRegionI handle sdword sdword>
	^self invalidCall: _failureCode!

gdipTranslateTextureTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslateTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateTextureTransform(
			[in]PGpTexture brush,
			[in]REAL dx,
			[in]REAL dy,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipTranslateTextureTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipTranslateWorldTransform: graphics dx: dx dy: dy order: order
	"Invoke the GdipTranslateWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateWorldTransform(
			PGpGraphics graphics,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateWorldTransform handle float float sdword>
	^self invalidCall: _failureCode!

gdipVectorTransformMatrixPoints: matrix pts: pts count: count
	"Invoke the GdipVectorTransformMatrixPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipVectorTransformMatrixPoints(
			PGpMatrix matrix,
			GpPointF* pts,
			int Count);"

	<stdcall: errno GdipVectorTransformMatrixPoints handle POINTF* sdword>
	^self invalidCall: _failureCode!

gdipVectorTransformMatrixPointsI: matrix pts: pts count: count
	"Invoke the GdipVectorTransformMatrixPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipVectorTransformMatrixPointsI(
			PGpMatrix matrix,
			GpPoint* pts,
			int Count);"

	<stdcall: errno GdipVectorTransformMatrixPointsI handle POINTL* sdword>
	^self invalidCall: _failureCode!

gdipWarpPath: path matrix: matrix points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight warpMode: warpMode flatness: flatness
	"Invoke the GdipWarpPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipWarpPath(
			PGpPath path,
			PGpMatrix matrix,
			[in]GpPointF* Points,
			int Count,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			WarpMode WarpMode,
			REAL flatness);"

	<stdcall: errno GdipWarpPath handle handle POINTF* sdword float float float float sdword float>
	^self invalidCall: _failureCode!

gdipWidenPath: nativePath pen: pen matrix: matrix flatness: flatness
	"Invoke the GdipWidenPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipWidenPath(
			PGpPath nativePath,
			PGpPen pen,
			PGpMatrix matrix,
			REAL flatness);"

	<stdcall: errno GdipWidenPath handle handle handle float>
	^self invalidCall: _failureCode!

gdipWindingModeOutline: path matrix: matrix flatness: flatness
	"Invoke the GdipWindingModeOutline() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipWindingModeOutline(
			PGpPath path,
			PGpMatrix matrix,
			REAL flatness);"

	<stdcall: errno GdipWindingModeOutline handle handle float>
	^self invalidCall: _failureCode!

initialize
	"Private - Initialize and answer the receiver."

	| input newToken |
	input := GdiplusStartupInput new.
	input GdiplusVersion: 1.
	newToken := DWORDBytes new.
	self
		gdiplusStartup: newToken
		input: input
		output: nil.
	token := newToken asInteger!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive, which in the case of the GdiplusLibrary will be the non-zero GpStatus return code from the function call."

	^anInteger < 0
		ifTrue: [super invalidCall: anInteger]
		ifFalse: 
			[| method frame |
			frame := Processor activeProcess topFrame sender.
			method := frame method.
			GdiplusError signal: method functionName , ' failed' with: anInteger]!

uninitialize
	"Private - Reverse the initialize"

	token isNil ifTrue: [^self].
	self gdiplusShutdown: token.
	token := nil! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #close!public!realizing/unrealizing! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathArc:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathArcI:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathBezier:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathBezierI:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathBeziers:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathBeziersI:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathClosedCurve:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathClosedCurve2:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathClosedCurve2I:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathClosedCurveI:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurve:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurve2:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurve2I:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurve3:points:count:offset:numberOfSegments:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurve3I:points:count:offset:numberOfSegments:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathCurveI:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathEllipse:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathEllipseI:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathLine:x1:y1:x2:y2:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathLine2:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathLine2I:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathLineI:x1:y1:x2:y2:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathPath:addingPath:connect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathPie:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathPieI:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathPolygon:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathPolygonI:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathRectangle:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathRectangleI:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathRectangles:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathRectanglesI:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathString:string:length:family:style:emSize:layoutRect:format:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipAddPathStringI:string:length:family:style:emSize:layoutRect:format:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBeginContainer:dstrect:srcRect:unit:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBeginContainer2:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBeginContainerI:dstrect:srcRect:unit:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBitmapGetPixel:x:y:color:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBitmapLockBits:rect:flags:format:lockedBitmapData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBitmapSetPixel:x:y:color:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBitmapSetResolution:xdpi:ydpi:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipBitmapUnlockBits:lockedBitmapData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipClearPathMarkers:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneBitmapArea:y:width:height:format:srcBitmap:dstBitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneBitmapAreaI:y:width:height:format:srcBitmap:dstBitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneBrush:cloneBrush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneCustomLineCap:clonedCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneFont:cloneFont:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneFontFamily:clonedFontFamily:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneImage:cloneImage:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneImageAttributes:cloneImageattr:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneMatrix:cloneMatrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipClonePath:clonePath:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipClonePen:clonepen:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneRegion:cloneRegion:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCloneStringFormat:newFormat:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipClosePathFigure:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipClosePathFigures:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCombineRegionPath:path:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCombineRegionRect:rect:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCombineRegionRectI:rect:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCombineRegionRegion:region2:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipComment:sizeData:data:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateAdjustableArrowCap:width:isFilled:cap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromDirectDrawSurface:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromFile:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromFileICM:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromGdiDib:gdiBitmapData:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromGraphics:height:target:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromHBITMAP:hpal:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromHICON:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromResource:lpBitmapName:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromStream:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateBitmapFromStreamICM:bitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateCachedBitmap:graphics:cachedBitmap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateCustomLineCap:strokePath:baseCap:baseInset:customCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFont:emSize:style:unit:font:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFontFamilyFromName:fontCollection:fontFamily:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFontFromDC:font:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFontFromLogfontA:logfont:font:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFontFromLogfontW:logfont:font:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFromHDC:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFromHDC2:hDevice:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFromHWND:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateFromHWNDICM:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateHalftonePalette!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateHatchBrush:forecol:backcol:brush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateHBITMAPFromBitmap:hbmReturn:background:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateHICONFromBitmap:hbmReturn:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateImageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrush:point2:color1:color2:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrushFromRect:color1:color2:mode:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrushFromRectWithAngle:color1:color2:angle:isAngleScalable:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrushFromRectWithAngleI:color1:color2:angle:isAngleScalable:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMatrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMatrix2:m12:m21:m22:dx:dy:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMatrix3:dstplg:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMatrix3I:dstplg:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMetafileFromEmf:deleteEmf:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMetafileFromFile:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMetafileFromStream:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMetafileFromWmf:deleteWmf:wmfPlaceableFileHeader:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateMetafileFromWmfFile:wmfPlaceableFileHeader:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePath:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePath2:types:count:fillMode:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePath2I:types:count:fillMode:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePathGradient:count:wrapMode:polyGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePathGradientFromPath:polyGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePathGradientI:count:wrapMode:polyGradient:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePathIter:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePen1:width:unit:pen:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreatePen2:width:unit:pen:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegion:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegionHrgn:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegionPath:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegionRect:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegionRectI:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateRegionRgnData:size:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateSolidFill:brush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateStreamOnFile:access:stream:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateStringFormat:language:format:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateTexture:wrapMode:texture:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateTexture2:wrapMode:x:y:width:height:texture:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateTexture2I:wrapMode:x:y:width:height:texture:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateTextureIA:imageAttributes:x:y:width:height:texture:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipCreateTextureIAI:imageAttributes:x:y:width:height:texture:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteBrush:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteCachedBitmap:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteCustomLineCap:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteFont:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteFontFamily:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteGraphics:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteMatrix:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeletePath:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeletePathIter:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeletePen:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeletePrivateFontCollection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteRegion:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDeleteStringFormat:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDisposeImage:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDisposeImageAttributes:!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawArc:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawArcI:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawBezier:pen:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawBezierI:pen:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawBeziers:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawBeziersI:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCachedBitmap:cachedBitmap:x:y:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawClosedCurve:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawClosedCurve2:pen:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawClosedCurve2I:pen:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawClosedCurveI:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurve:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurve2:pen:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurve2I:pen:points:count:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurve3:pen:points:count:offset:numberOfSegments:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurve3I:pen:points:count:offset:numberOfSegments:tension:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawCurveI:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawDriverString:text:length:font:brush:positions:flags:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawEllipse:pen:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawEllipseI:pen:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImage:image:x:y:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImageI:image:x:y:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePointRect:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePointRectI:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePoints:image:dstpoints:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePointsI:image:dstpoints:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePointsRect:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImagePointsRectI:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImageRect:image:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImageRectI:image:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImageRectRect:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawImageRectRectI:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawLine:pen:x1:y1:x2:y2:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawLineI:pen:x1:y1:x2:y2:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawLines:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawLinesI:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawPath:pen:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawPie:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawPieI:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawPolygon:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawPolygonI:pen:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawRectangle:pen:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawRectangleI:pen:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawRectangles:pen:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawRectanglesI:pen:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipDrawString:str:length:font:layoutRect:stringFormat:brush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEmfToWmfBits:cbData16:pData16:iMapMode:eFlags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEndContainer:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestPoint:metafile:destPoint:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestPointI:metafile:destPoint:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestPoints:metafile:destPoints:count:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestPointsI:metafile:destPoints:count:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestRect:metafile:destRect:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileDestRectI:metafile:destRect:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestPoint:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestPointI:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestPoints:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestPointsI:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestRect:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipEnumerateMetafileSrcRectDestRectI:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillClosedCurve:brush:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillClosedCurve2:brush:points:count:tension:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillClosedCurve2I:brush:points:count:tension:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillClosedCurveI:brush:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillEllipse:brush:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillEllipseI:brush:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPath:brush:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPie:brush:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPieI:brush:x:y:width:height:startAngle:sweepAngle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPolygon:brush:points:count:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPolygon2:brush:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPolygon2I:brush:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillPolygonI:brush:points:count:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillRectangle:brush:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillRectangleI:brush:x:y:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillRectangles:brush:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillRectanglesI:brush:rects:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFillRegion:brush:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFlattenPath:matrix:flatness:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFlush:intention:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFontCollectionEnumerable:graphics:numFound:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipFontCollectionEnumerate:numSought:gpfamilies:numFound:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetAdjustableArrowCapFillState:fillState:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetAdjustableArrowCapHeight:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetAdjustableArrowCapMiddleInset:middleInset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetAdjustableArrowCapWidth:width:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetAllPropertyItems:totalBufferSize:numProperties:allItems:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetBrushType:type:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCellAscent:style:cellAscent:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCellDescent:style:cellDescent:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetClip:region:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetClipBounds:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetClipBoundsI:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCompositingMode:compositingMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCompositingQuality:compositingQuality:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapBaseCap:baseCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapBaseInset:inset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapStrokeCaps:startCap:endCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapStrokeJoin:lineJoin:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapType:capType:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetCustomLineCapWidthScale:widthScale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetDC:hdc:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetDpiX:dpi:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetDpiY:dpi:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetEmHeight:style:emHeight:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetEncoderParameterList:clsidEncoder:size:buffer:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetEncoderParameterListSize:clsidEncoder:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFamily:family:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFamilyName:name:language:!modified!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontCollectionFamilyCount:numFound:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontCollectionFamilyList:numSought:gpfamilies:numFound:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontHeight:graphics:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontHeightGivenDPI:dpi:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontSize:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontStyle:style:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetFontUnit:unit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetGenericFontFamilyMonospace:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetGenericFontFamilySansSerif:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetGenericFontFamilySerif:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetHatchBackgroundColor:backcol:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetHatchForegroundColor:forecol:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetHatchStyle:hatchStyle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetHemfFromMetafile:hEmf:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageAttributesAdjustedPalette:colorPalette:colorAdjustType:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageBounds:srcRect:srcUnit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageDecoders:size:decoders:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageDecodersSize:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageDimension:width:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageEncoders:size:encoders:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageEncodersSize:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageFlags:flags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageGraphicsContext:graphics:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageHeight:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageHorizontalResolution:resolution:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImagePalette:palette:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImagePaletteSize:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImagePixelFormat:format:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageRawFormat:format:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageThumbnail:thumbWidth:thumbHeight:thumbImage:pfnCallback:callbackData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageType:type:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageVerticalResolution:resolution:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetImageWidth:width:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetInterpolationMode:interpolationMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineBlendCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineColors:colors:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineGammaCorrection:useGammaCorrection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLinePresetBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLinePresetBlendCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineRect:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineRectI:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineSpacing:style:lineSpacing:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLineWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLogFontA:graphics:logfonta:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetLogFontW:graphics:logfonta:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMatrixElements:matrixOut:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileHeaderFromEmf:header:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileHeaderFromFile:header:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileHeaderFromMetafile:header:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileHeaderFromStream:header:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetMetafileHeaderFromWmf:wmfPlaceableFileHeader:header:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetNearestColor:argb:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPageScale:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPageUnit:unit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathData:pathData:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathFillMode:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientBlendCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientCenterColor:colors:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientCenterPoint:points:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientCenterPointI:points:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientFocusScales:xScale:yScale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientPath:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientPointCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientPresetBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientPresetBlendCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientRect:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientRectI:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientSurroundColorCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathGradientWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathLastPoint:lastPoint:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathPoints:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathPointsI:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathTypes:types:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathWorldBounds:bounds:matrix:pen:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPathWorldBoundsI:bounds:matrix:pen:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenBrushFill:brush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenColor:argb:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenCompoundArray:dash:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenCompoundCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenCustomEndCap:customCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenCustomStartCap:customCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenDashArray:dash:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenDashCap197819:dashCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenDashCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenDashOffset:offset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenDashStyle:dashStyle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenEndCap:endCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenFillType:type:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenLineJoin:lineJoin:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenMiterLimit:miterLimit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenMode:penMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenStartCap:startCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenUnit:unit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPenWidth:width:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPixelOffsetMode:pixelOffsetMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPointCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPropertyCount:numOfProperty:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPropertyIdList:numOfProperty:list:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPropertyItem:propId:propSize:buffer:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPropertyItemSize:propId:size:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetPropertySize:totalBufferSize:numProperties:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionBounds:graphics:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionBoundsI:graphics:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionData:buffer:bufferSize:sizeFilled:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionDataSize:bufferSize:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionHRgn:graphics:hRgn:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionScans:rects:count:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionScansCount:count:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRegionScansI:rects:count:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetRenderingOrigin:x:y:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetSmoothingMode:smoothingMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetSolidFillColor:color:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatAlign:align:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatDigitSubstitution:language:substitute:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatFlags:flags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatHotkeyPrefix:hotkeyPrefix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatLineAlign:align:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatMeasurableCharacterRangeCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatTabStopCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatTabStops:count:firstTabOffset:tabStops:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetStringFormatTrimming:trimming:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetTextContrast:contrast:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetTextRenderingHint:mode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetTextureImage:image:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetTextureTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetTextureWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetVisibleClipBounds:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetVisibleClipBoundsI:rect:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGetWorldTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipGraphicsClear:color:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageForceValidation:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageGetFrameCount:dimensionID:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageGetFrameDimensionsCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageGetFrameDimensionsList:dimensionIDs:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageRotateFlip:rfType:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipImageSelectActiveFrame:dimensionID:frameIndex:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipInvertMatrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsClipEmpty:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsEmptyRegion:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsEqualRegion:region2:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsInfiniteRegion:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsMatrixEqual:matrix2:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsMatrixIdentity:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsMatrixInvertible:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsOutlineVisiblePathPoint:x:y:pen:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsOutlineVisiblePathPointI:x:y:pen:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsStyleAvailable:style:isStyleAvailable:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleClipEmpty:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisiblePathPoint:x:y:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisiblePathPointI:x:y:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisiblePoint:x:y:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisiblePointI:x:y:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRect:x:y:width:height:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRectI:x:y:width:height:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRegionPoint:x:y:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRegionPointI:x:y:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRegionRect:x:y:width:height:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipIsVisibleRegionRectI:x:y:width:height:graphics:result:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipLoadImageFromFile:image:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipLoadImageFromFileICM:image:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipLoadImageFromStream:image:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipLoadImageFromStreamICM:image:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdiplusNotificationHook:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdiplusNotificationUnhook:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdiplusShutdown:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdiplusStartup:input:output:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMeasureCharacterRanges:str:length:font:layoutRect:stringFormat:regionCount:regions:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMeasureDriverString:text:length:font:positions:flags:matrix:boundingBox:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMeasureString:str:length:font:layoutRect:stringFormat:boundingBox:codepointsFitted:linesFilled:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyLineTransform:matrix:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyMatrix:matrix2:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyPathGradientTransform:matrix:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyPenTransform:matrix:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyTextureTransform:matrix:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipMultiplyWorldTransform:matrix:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipNewInstalledFontCollection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipNewPrivateFontCollection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterCopyData:resultCount:points:types:startIndex:endIndex:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterEnumerate:resultCount:points:types:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterGetCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterGetSubpathCount:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterHasCurve:hasCurve:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterIsValid:valid:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterNextMarker:resultCount:startIndex:endIndex:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterNextMarkerPath:resultCount:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterNextPathType:resultCount:pathType:startIndex:endIndex:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterNextSubpath:resultCount:startIndex:endIndex:isClosed:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterNextSubpathPath:resultCount:path:isClosed:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPathIterRewind:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPlayMetafileRecord:recordType:flags:dataSize:data:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPrivateAddFontFile:filename:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipPrivateAddMemoryFont:memory:length:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafile:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafileFileName:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafileFileNameI:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafileI:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafileStream:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRecordMetafileStreamI:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipReleaseDC:hdc:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRemovePropertyItem:propId:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetClip:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetImageAttributes:type:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetLineTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetPageTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetPath:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetPathGradientTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetPenTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetTextureTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipResetWorldTransform:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRestoreGraphics:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipReversePath:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotateLineTransform:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotateMatrix:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotatePathGradientTransform:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotatePenTransform:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotateTextureTransform:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipRotateWorldTransform:angle:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSaveAdd:encoderParams:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSaveAddImage:newImage:encoderParams:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSaveGraphics:state:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSaveImageToFile:filename:clsidEncoder:encoderParams:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSaveImageToStream:stream:clsidEncoder:encoderParams:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScaleLineTransform:sx:sy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScaleMatrix:scaleX:scaleY:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScalePathGradientTransform:sx:sy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScalePenTransform:sx:sy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScaleTextureTransform:sx:sy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipScaleWorldTransform:sx:sy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetAdjustableArrowCapFillState:fillState:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetAdjustableArrowCapHeight:height:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetAdjustableArrowCapMiddleInset:middleInset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetAdjustableArrowCapWidth:width:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipGraphics:srcgraphics:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipHrgn:hRgn:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipPath:path:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipRect:x:y:width:height:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipRectI:x:y:width:height:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetClipRegion:region:combineMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCompositingMode:compositingMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCompositingQuality:compositingQuality:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCustomLineCapBaseCap:baseCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCustomLineCapBaseInset:inset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCustomLineCapStrokeCaps:startCap:endCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCustomLineCapStrokeJoin:lineJoin:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetCustomLineCapWidthScale:widthScale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetEmpty:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesCachedBackground:enableFlag:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesColorKeys:type:enableFlag:colorLow:colorHigh:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesColorMatrix:type:enableFlag:colorMatrix:grayMatrix:flags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesGamma:type:enableFlag:gamma:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesICMMode:on:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesNoOp:type:enableFlag:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesOutputChannel:type:enableFlag:channelFlags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesOutputChannelColorProfile:type:enableFlag:colorProfileFilename:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesRemapTable:type:enableFlag:mapSize:map:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesThreshold:type:enableFlag:threshold:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesToIdentity:type:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImageAttributesWrapMode:wrap:argb:clamp:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetImagePalette:palette:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetInfinite:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetInterpolationMode:interpolationMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineColors:color1:color2:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineGammaCorrection:useGammaCorrection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineLinearBlend:focus:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLinePresetBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineSigmaBlend:focus:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetLineWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetMatrixElements:m11:m12:m21:m22:dx:dy:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPageScale:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPageUnit:unit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathFillMode:fillMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientCenterColor:colors:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientCenterPoint:points:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientCenterPointI:points:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientFocusScales:xScale:yScale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientLinearBlend:focus:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientPath:path:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientPresetBlend:blend:positions:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientSigmaBlend:focus:scale:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathGradientWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPathMarker:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenBrushFill:brush:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenColor:argb:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenCompoundArray:dash:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenCustomEndCap:customCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenCustomStartCap:customCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenDashArray:dash:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenDashCap197819:dashCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenDashOffset:offset:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenDashStyle:dashStyle:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenEndCap:endCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenLineCap197819:startCap:endCap:dashCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenLineJoin:lineJoin:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenMiterLimit:miterLimit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenMode:penMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenStartCap:startCap:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenUnit:unit:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPenWidth:width:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPixelOffsetMode:pixelOffsetMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetPropertyItem:item:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetRenderingOrigin:x:y:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetSmoothingMode:smoothingMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetSolidFillColor:color:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatAlign:align:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatDigitSubstitution:language:substitute:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatFlags:flags:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatHotkeyPrefix:hotkeyPrefix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatLineAlign:align:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatMeasurableCharacterRanges:rangeCount:ranges:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatTabStops:firstTabOffset:count:tabStops:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetStringFormatTrimming:trimming:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetTextContrast:contrast:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetTextRenderingHint:mode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetTextureTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetTextureWrapMode:wrapMode:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipSetWorldTransform:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipShearMatrix:shearX:shearY:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipStartPathFigure:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipStringFormatGetGenericDefault:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipStringFormatGetGenericTypographic:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTestControl:param:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformMatrixPoints:pts:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformMatrixPointsI:pts:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformPath:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformPoints:destSpace:srcSpace:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformPointsI:destSpace:srcSpace:points:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTransformRegion:matrix:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateClip:dx:dy:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateClipI:dx:dy:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateLineTransform:dx:dy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateMatrix:offsetX:offsetY:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslatePathGradientTransform:dx:dy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslatePenTransform:dx:dy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateRegion:dx:dy:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateRegionI:dx:dy:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateTextureTransform:dx:dy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipTranslateWorldTransform:dx:dy:order:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipVectorTransformMatrixPoints:pts:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipVectorTransformMatrixPointsI:pts:count:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipWarpPath:matrix:points:count:srcx:srcy:srcwidth:srcheight:warpMode:flatness:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipWidenPath:pen:matrix:flatness:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #gdipWindingModeOutline:matrix:flatness:!**auto generated**!public! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #initialize!initializing!private! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #invalidCall:!exceptions!private! !
!Graphics.Gdiplus.GdiplusLibrary categoriesFor: #uninitialize!private!realizing/unrealizing! !

!Graphics.Gdiplus.GdiplusLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'GDIPLUS'
! !
!Graphics.Gdiplus.GdiplusLibrary class categoriesFor: #fileName!**auto generated**!constants!public! !

