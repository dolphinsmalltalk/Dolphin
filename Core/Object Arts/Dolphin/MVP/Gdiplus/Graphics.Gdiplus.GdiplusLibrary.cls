"Filed out from Dolphin Smalltalk"!

External.WindowsSystemLibrary
	subclass: #'Graphics.Gdiplus.GdiplusLibrary'
	instanceVariableNames: 'token'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'FlatnessDefault' -> 0.25.
			'PixelFormatMax' -> 16rF.
			'PixelFormatUndefined' -> 16r0
		}!

Graphics.Gdiplus.GdiplusLibrary guid: (Core.GUID fromString: '{de97dca0-ad17-4002-a790-a4b99480a5b8}')!

Graphics.Gdiplus.GdiplusLibrary comment: 'Gdiplus is the `DynamicLinkLibrary` class to represent the dynamic link library, ''GDIPLUS.DLL''. It was generated from IDL built from the GDI+ header files. It contains wrapper methods for each of the methods in the GDI+ Flat API. The GDI+ class library (a set of C++ classes) sits on top of the flat API. There is very little documentation for the flat API, but the class library is, for the most part, a thin layer on top so it is easy to map between the C++ class library documentation and the corresponding flat API calls.
'!

!Graphics.Gdiplus.GdiplusLibrary categoriesForClass!External-Libraries-Win32! !

!Graphics.Gdiplus.GdiplusLibrary methodsFor!

close
	"Release the reference the receiver has to the External Library it represents. This may not cause the library to be unloaded, so it may still function. Answer whether the library was successfully closed."

	handle notNull ifTrue: [self uninitialize].
	^super close!

gdipAddPathArc: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathArc() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathArc(
			PGpPath path,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
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
			int width,
			int height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathArcI handle int32 int32 int32 int32 float float>
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

	<stdcall: errno GdipAddPathBezierI handle int32 int32 int32 int32 int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipAddPathBeziers: path points: points count: count
	"Invoke the GdipAddPathBeziers() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBeziers(
			PGpPath path,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipAddPathBeziers handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipAddPathBeziersI: path points: points count: count
	"Invoke the GdipAddPathBeziersI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathBeziersI(
			PGpPath path,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipAddPathBeziersI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve: path points: points count: count
	"Invoke the GdipAddPathClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve(
			PGpPath path,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipAddPathClosedCurve handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve2: path points: points count: count tension: tension
	"Invoke the GdipAddPathClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve2(
			PGpPath path,
			[in]POINTF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathClosedCurve2 handle POINTF* int32 float>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurve2I: path points: points count: count tension: tension
	"Invoke the GdipAddPathClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurve2I(
			PGpPath path,
			[in]POINTL* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathClosedCurve2I handle POINTL* int32 float>
	^self invalidCall: _failureCode!

gdipAddPathClosedCurveI: path points: points count: count
	"Invoke the GdipAddPathClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathClosedCurveI(
			PGpPath path,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipAddPathClosedCurveI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipAddPathCurve: path points: points count: count
	"Invoke the GdipAddPathCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve(
			PGpPath path,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipAddPathCurve handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipAddPathCurve2: path points: points count: count tension: tension
	"Invoke the GdipAddPathCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve2(
			PGpPath path,
			[in]POINTF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve2 handle POINTF* int32 float>
	^self invalidCall: _failureCode!

gdipAddPathCurve2I: path points: points count: count tension: tension
	"Invoke the GdipAddPathCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve2I(
			PGpPath path,
			[in]POINTL* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve2I handle POINTL* int32 float>
	^self invalidCall: _failureCode!

gdipAddPathCurve3: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipAddPathCurve3() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve3(
			PGpPath path,
			[in]POINTF* Points,
			int Count,
			int Offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve3 handle POINTF* int32 int32 int32 float>
	^self invalidCall: _failureCode!

gdipAddPathCurve3I: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipAddPathCurve3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurve3I(
			PGpPath path,
			[in]POINTL* Points,
			int Count,
			int Offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipAddPathCurve3I handle POINTL* int32 int32 int32 float>
	^self invalidCall: _failureCode!

gdipAddPathCurveI: path points: points count: count
	"Invoke the GdipAddPathCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathCurveI(
			PGpPath path,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipAddPathCurveI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipAddPathEllipse: path x: x y: y width: width height: height
	"Invoke the GdipAddPathEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathEllipse(
			PGpPath path,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipAddPathEllipse handle float float float float>
	^self invalidCall: _failureCode!

gdipAddPathEllipseI: path x: x y: y width: width height: height
	"Invoke the GdipAddPathEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathEllipseI(
			PGpPath path,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipAddPathEllipseI handle int32 int32 int32 int32>
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
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipAddPathLine2 handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipAddPathLine2I: path points: points count: count
	"Invoke the GdipAddPathLine2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLine2I(
			PGpPath path,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipAddPathLine2I handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipAddPathLineI: path x1: x1 y1: y1 x2: x2 y2: y2
	"Invoke the GdipAddPathLineI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathLineI(
			PGpPath path,
			int x1,
			int y1,
			int x2,
			int y2);"

	<stdcall: errno GdipAddPathLineI handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipAddPathPath: path addingPath: addingPath connect: connect
	"Invoke the GdipAddPathPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPath(
			PGpPath path,
			[in]PGpPath addingPath,
			BOOL connect);"

	<stdcall: errno GdipAddPathPath handle handle bool>
	^self invalidCall: _failureCode!

gdipAddPathPie: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipAddPathPie() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPie(
			PGpPath path,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
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
			int width,
			int height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipAddPathPieI handle int32 int32 int32 int32 float float>
	^self invalidCall: _failureCode!

gdipAddPathPolygon: path points: points count: count
	"Invoke the GdipAddPathPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPolygon(
			PGpPath path,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipAddPathPolygon handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipAddPathPolygonI: path points: points count: count
	"Invoke the GdipAddPathPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathPolygonI(
			PGpPath path,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipAddPathPolygonI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipAddPathRectangle: path x: x y: y width: width height: height
	"Invoke the GdipAddPathRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangle(
			PGpPath path,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipAddPathRectangle handle float float float float>
	^self invalidCall: _failureCode!

gdipAddPathRectangleI: path x: x y: y width: width height: height
	"Invoke the GdipAddPathRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangleI(
			PGpPath path,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipAddPathRectangleI handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipAddPathRectangles: path rects: rects count: count
	"Invoke the GdipAddPathRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectangles(
			PGpPath path,
			[in]RectF* rects,
			int Count);"

	<stdcall: errno GdipAddPathRectangles handle RectF* int32>
	^self invalidCall: _failureCode!

gdipAddPathRectanglesI: path rects: rects count: count
	"Invoke the GdipAddPathRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipAddPathRectanglesI(
			PGpPath path,
			[in]Rect* rects,
			int Count);"

	<stdcall: errno GdipAddPathRectanglesI handle Rect* int32>
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
			[in]RectF* layoutRect,
			[in]PGpStringFormat format);"

	<stdcall: errno GdipAddPathString handle lpwstr int32 handle int32 float RectF* handle>
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
			[in]Rect* layoutRect,
			[in]PGpStringFormat format);"

	<stdcall: errno GdipAddPathStringI handle lpwstr int32 handle int32 float Rect* handle>
	^self invalidCall: _failureCode!

gdipBeginContainer: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	"Invoke the GdipBeginContainer() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainer(
			PGpGraphics graphics,
			[in]RectF* dstrect,
			[in]RectF* srcRect,
			GpUnit Unit,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainer handle RectF* RectF* int32 uint32*>
	^self invalidCall: _failureCode!

gdipBeginContainer2: graphics state: state
	"Invoke the GdipBeginContainer2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainer2(
			PGpGraphics graphics,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainer2 handle uint32*>
	^self invalidCall: _failureCode!

gdipBeginContainerI: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	"Invoke the GdipBeginContainerI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBeginContainerI(
			PGpGraphics graphics,
			[in]Rect* dstrect,
			[in]Rect* srcRect,
			GpUnit Unit,
			GraphicsContainer* state);"

	<stdcall: errno GdipBeginContainerI handle Rect* Rect* int32 uint32*>
	^self invalidCall: _failureCode!

gdipBitmapApplyEffect: bitmap effect: effect roi: roi useAuxData: useAuxData auxData: auxData auxDataSize: auxDataSize
	"Invoke the GdipBitmapApplyEffect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapApplyEffect(
			PGpBitmap bitmap,
			PCGpEffect effect,
			Rect* roi,
			BOOL useAuxData,
			void** auxData,
			int* auxDataSize);"

	<stdcall: errno GdipBitmapApplyEffect handle handle Rect* bool void** int32*>
	^self invalidCall: _failureCode!

gdipBitmapConvertFormat: pInputBitmap format: format ditherType: ditherType paletteType: paletteType palette: palette alphaThresholdPercent: alphaThresholdPercent
	"Invoke the GdipBitmapConvertFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapConvertFormat(
			PGpBitmap pInputBitmap,
			PixelFormat format,
			DitherType DitherType,
			PaletteType PaletteType,
			ColorPalette* palette,
			REAL alphaThresholdPercent);"

	<stdcall: errno GdipBitmapConvertFormat handle int32 int32 int32 ColorPalette* float>
	^self invalidCall: _failureCode!

gdipBitmapCreateApplyEffect: inputBitmaps numInputs: numInputs effect: effect roi: roi outputRect: outputRect outputBitmap: outputBitmap useAuxData: useAuxData auxData: auxData auxDataSize: auxDataSize
	"Invoke the GdipBitmapCreateApplyEffect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapCreateApplyEffect(
			PGpBitmap* inputBitmaps,
			int numInputs,
			PCGpEffect effect,
			Rect* roi,
			Rect* outputRect,
			PGpBitmap* outputBitmap,
			BOOL useAuxData,
			void** auxData,
			int* auxDataSize);"

	<stdcall: errno GdipBitmapCreateApplyEffect handle* int32 handle Rect* Rect* handle* bool void** int32*>
	^self invalidCall: _failureCode!

gdipBitmapGetHistogram: bitmap format: format numberOfEntries: numberOfEntries channel0: channel0 channel1: channel1 channel2: channel2 channel3: channel3
	"Invoke the GdipBitmapGetHistogram() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapGetHistogram(
			PGpBitmap bitmap,
			HistogramFormat format,
			unsigned int NumberOfEntries,
			unsigned int* channel0,
			unsigned int* channel1,
			unsigned int* channel2,
			unsigned int* channel3);"

	<stdcall: errno GdipBitmapGetHistogram handle int32 uint32 uint32* uint32* uint32* uint32*>
	^self invalidCall: _failureCode!

gdipBitmapGetHistogramSize: format numberOfEntries: numberOfEntries
	"Invoke the GdipBitmapGetHistogramSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapGetHistogramSize(
			HistogramFormat format,
			[out]unsigned int* NumberOfEntries);"

	<stdcall: errno GdipBitmapGetHistogramSize int32 uint32*>
	^self invalidCall: _failureCode!

gdipBitmapGetPixel: bitmap x: x y: y color: color
	"Invoke the GdipBitmapGetPixel() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipBitmapGetPixel(
			[in]PGpBitmap bitmap,
			[in]int x,
			[in]int y,
			[out, retval]ARGB* Color);"

	<stdcall: int32 GdipBitmapGetPixel handle int32 int32 uint32*>
	^self invalidCall: _failureCode!

gdipBitmapLockBits: bitmap rect: rect flags: flags format: format lockedBitmapData: lockedBitmapData
	"Invoke the GdipBitmapLockBits() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapLockBits(
			[in]PGpBitmap bitmap,
			[in]Rect* Rect,
			[in]unsigned int Flags,
			[in]PixelFormat format,
			[out, retval]BitmapData* lockedBitmapData);"

	<stdcall: errno GdipBitmapLockBits handle Rect* uint32 int32 BitmapData*>
	^self invalidCall: _failureCode!

gdipBitmapSetPixel: bitmap x: x y: y color: color
	"Invoke the GdipBitmapSetPixel() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipBitmapSetPixel(
			[in]PGpBitmap bitmap,
			[in]int x,
			[in]int y,
			[in]ARGB Color);"

	<stdcall: errno GdipBitmapSetPixel handle int32 int32 uint32>
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

	<stdcall: errno GdipBitmapUnlockBits handle BitmapData*>
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
			[in]REAL width,
			[in]REAL height,
			[in]PixelFormat format,
			[in]PGpBitmap srcBitmap,
			[out, retval]PGpBitmap* dstBitmap);"

	<stdcall: errno GdipCloneBitmapArea float float float float int32 handle handle*>
	^self invalidCall: _failureCode!

gdipCloneBitmapAreaI: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap
	"Invoke the GdipCloneBitmapAreaI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCloneBitmapAreaI(
			[in]int x,
			[in]int y,
			[in]int width,
			[in]int height,
			[in]PixelFormat format,
			[in]PGpBitmap srcBitmap,
			[out, retval]PGpBitmap* dstBitmap);"

	<stdcall: errno GdipCloneBitmapAreaI int32 int32 int32 int32 int32 handle handle*>
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

	<stdcall: errno GdipCombineRegionPath handle handle int32>
	^self invalidCall: _failureCode!

gdipCombineRegionRect: region rect: rect combineMode: combineMode
	"Invoke the GdipCombineRegionRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRect(
			PGpRegion region,
			[in]RectF* Rect,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRect handle RectF* int32>
	^self invalidCall: _failureCode!

gdipCombineRegionRectI: region rect: rect combineMode: combineMode
	"Invoke the GdipCombineRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRectI(
			PGpRegion region,
			[in]Rect* Rect,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRectI handle Rect* int32>
	^self invalidCall: _failureCode!

gdipCombineRegionRegion: region region2: region2 combineMode: combineMode
	"Invoke the GdipCombineRegionRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCombineRegionRegion(
			PGpRegion region,
			PGpRegion region2,
			CombineMode CombineMode);"

	<stdcall: errno GdipCombineRegionRegion handle handle int32>
	^self invalidCall: _failureCode!

gdipComment: graphics sizeData: sizeData data: data
	"Invoke the GdipComment() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipComment(
			PGpGraphics graphics,
			unsigned int sizeData,
			[in]BYTE* Data);"

	<stdcall: errno GdipComment handle uint32 uint8*>
	^self invalidCall: _failureCode!

gdipConvertToEmfPlus: refGraphics metafile: metafile conversionFailureFlag: conversionFailureFlag emfType: emfType description: description out_metafile: out_metafile
	"Invoke the GdipConvertToEmfPlus() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipConvertToEmfPlus(
			PGpGraphics refGraphics,
			PGpMetafile metafile,
			int* conversionFailureFlag,
			EmfType EmfType,
			WCHAR* description,
			[out, retval]PGpMetafile* out_metafile);"

	<stdcall: errno GdipConvertToEmfPlus handle handle int32* int32 uint16* handle*>
	^self invalidCall: _failureCode!

gdipConvertToEmfPlusToFile: refGraphics metafile: metafile conversionFailureFlag: conversionFailureFlag filename: filename emfType: emfType description: description out_metafile: out_metafile
	"Invoke the GdipConvertToEmfPlusToFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipConvertToEmfPlusToFile(
			PGpGraphics refGraphics,
			PGpMetafile metafile,
			int* conversionFailureFlag,
			WCHAR* filename,
			EmfType EmfType,
			WCHAR* description,
			[out, retval]PGpMetafile* out_metafile);"

	<stdcall: errno GdipConvertToEmfPlusToFile handle handle int32* uint16* int32 uint16* handle*>
	^self invalidCall: _failureCode!

gdipConvertToEmfPlusToStream: refGraphics metafile: metafile conversionFailureFlag: conversionFailureFlag stream: stream emfType: emfType description: description out_metafile: out_metafile
	"Invoke the GdipConvertToEmfPlusToStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipConvertToEmfPlusToStream(
			PGpGraphics refGraphics,
			PGpMetafile metafile,
			int* conversionFailureFlag,
			IStream* stream,
			EmfType EmfType,
			WCHAR* description,
			[out, retval]PGpMetafile* out_metafile);"

	<stdcall: errno GdipConvertToEmfPlusToStream handle handle int32* OS.COM.IStream* int32 uint16* handle*>
	^self invalidCall: _failureCode!

gdipCreateAdjustableArrowCap: height width: width isFilled: isFilled cap: cap
	"Invoke the GdipCreateAdjustableArrowCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateAdjustableArrowCap(
			REAL height,
			REAL width,
			BOOL isFilled,
			[out, retval]PGpAdjustableArrowCap* cap);"

	<stdcall: errno GdipCreateAdjustableArrowCap float float bool handle*>
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
			[in]void* gdiBitmapData,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromGdiDib void* void* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromGraphics: width height: height target: target bitmap: bitmap
	"Invoke the GdipCreateBitmapFromGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromGraphics(
			[in]int width,
			[in]int height,
			[in]PGpGraphics target,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromGraphics int32 int32 handle handle*>
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

gdipCreateBitmapFromResource: hinstance lpBitmapName: lpBitmapName bitmap: bitmap
	"Invoke the GdipCreateBitmapFromResource() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromResource(
			[in]HINSTANCE HINSTANCE,
			[in]LPWSTR lpBitmapName,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromResource handle lpwstr handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromScan0: width height: height stride: stride format: format scan0: scan0 bitmap: bitmap
	"Invoke the GdipCreateBitmapFromScan0() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromScan0(
			[in]int width,
			[in]int height,
			[in]int Stride,
			[in]PixelFormat format,
			[in]BYTE* Scan0,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromScan0 int32 int32 int32 int32 uint8* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromStream: stream bitmap: bitmap
	"Invoke the GdipCreateBitmapFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromStream(
			[in]IStream* stream,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromStream OS.COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateBitmapFromStreamICM: stream bitmap: bitmap
	"Invoke the GdipCreateBitmapFromStreamICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateBitmapFromStreamICM(
			[in]IStream* stream,
			[out, retval]PGpBitmap* bitmap);"

	<stdcall: errno GdipCreateBitmapFromStreamICM OS.COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateCachedBitmap: bitmap graphics: graphics cachedBitmap: cachedBitmap
	"Invoke the GdipCreateCachedBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateCachedBitmap(
			PGpBitmap bitmap,
			PGpGraphics graphics,
			[out, retval]PGpCachedBitmap* cachedBitmap);"

	<stdcall: errno GdipCreateCachedBitmap handle handle handle*>
	^self invalidCall: _failureCode!

gdipCreateCustomLineCap: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset customCap: customCap
	"Invoke the GdipCreateCustomLineCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateCustomLineCap(
			PGpPath fillPath,
			PGpPath strokePath,
			GpLineCap baseCap,
			REAL baseInset,
			[out, retval]PGpCustomLineCap* customCap);"

	<stdcall: errno GdipCreateCustomLineCap handle handle int32 float handle*>
	^self invalidCall: _failureCode!

gdipCreateFont: fontFamily emSize: emSize style: style unit: unit font: font
	"Invoke the GdipCreateFont() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFont(
			[in]PGpFontFamily FontFamily,
			REAL emSize,
			int style,
			Unit Unit,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFont handle float int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFamilyFromName: name fontCollection: fontCollection fontFamily: fontFamily
	"Invoke the GdipCreateFontFamilyFromName() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipCreateFontFamilyFromName(
			[in]LPWSTR name,
			[in]PGpFontCollection fontCollection,
			[out, retval]PGpFontFamily* FontFamily);"

	<stdcall: int32 GdipCreateFontFamilyFromName lpwstr handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFromDC: hdc font: font
	"Invoke the GdipCreateFontFromDC() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFromDC(
			HDC HDC,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFontFromDC handle handle*>
	^self invalidCall: _failureCode!

gdipCreateFontFromLogfontW: hdc logfont: logfont font: font
	"Invoke the GdipCreateFontFromLogfontW() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateFontFromLogfontW(
			HDC HDC,
			[in]LOGFONTW* LOGFONT,
			[out, retval]PGpFont* font);"

	<stdcall: errno GdipCreateFontFromLogfontW handle LOGFONTW* handle*>
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
			HANDLE hDevice,
			[out, retval]PGpGraphics* graphics);"

	<stdcall: errno GdipCreateFromHDC2 handle handle handle*>
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

	<stdcall: errno GdipCreateHatchBrush int32 uint32 uint32 handle*>
	^self invalidCall: _failureCode!

gdipCreateHBITMAPFromBitmap: bitmap hbmReturn: hbmReturn background: background
	"Invoke the GdipCreateHBITMAPFromBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateHBITMAPFromBitmap(
			[in]PGpBitmap bitmap,
			[out]HBITMAP* hbmReturn,
			[in]ARGB background);"

	<stdcall: errno GdipCreateHBITMAPFromBitmap handle handle* uint32>
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
			[in]POINTF* point1,
			[in]POINTF* point2,
			[in]ARGB color1,
			[in]ARGB color2,
			[in]GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrush POINTF* POINTF* uint32 uint32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRect: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRect(
			[in]RectF* Rect,
			ARGB color1,
			ARGB color2,
			LinearGradientMode mode,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRect RectF* uint32 uint32 int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectI(
			[in]Rect* Rect,
			ARGB color1,
			ARGB color2,
			LinearGradientMode mode,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectI Rect* uint32 uint32 int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectWithAngle: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectWithAngle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectWithAngle(
			[in]RectF* Rect,
			ARGB color1,
			ARGB color2,
			REAL angle,
			BOOL isAngleScalable,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectWithAngle RectF* uint32 uint32 float bool int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushFromRectWithAngleI: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushFromRectWithAngleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushFromRectWithAngleI(
			[in]Rect* Rect,
			ARGB color1,
			ARGB color2,
			REAL angle,
			BOOL isAngleScalable,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushFromRectWithAngleI Rect* uint32 uint32 float bool int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateLineBrushI: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient
	"Invoke the GdipCreateLineBrushI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateLineBrushI(
			[in]POINTL* point1,
			[in]POINTL* point2,
			ARGB color1,
			ARGB color2,
			GpWrapMode WrapMode,
			[out, retval]PGpLineGradient* lineGradient);"

	<stdcall: errno GdipCreateLineBrushI POINTL* POINTL* uint32 uint32 int32 handle*>
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
			[in]RectF* Rect,
			[in]POINTF* dstplg,
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix3 RectF* POINTF* handle*>
	^self invalidCall: _failureCode!

gdipCreateMatrix3I: rect dstplg: dstplg matrix: matrix
	"Invoke the GdipCreateMatrix3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMatrix3I(
			[in]Rect* Rect,
			[in]POINTL* dstplg,
			[out, retval]PGpMatrix* matrix);"

	<stdcall: errno GdipCreateMatrix3I Rect* POINTL* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromEmf: hEmf deleteEmf: deleteEmf metafile: metafile
	"Invoke the GdipCreateMetafileFromEmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromEmf(
			HENHMETAFILE hEmf,
			BOOL deleteEmf,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromEmf handle bool handle*>
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

	<stdcall: errno GdipCreateMetafileFromStream OS.COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromWmf: hWmf deleteWmf: deleteWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	"Invoke the GdipCreateMetafileFromWmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromWmf(
			HMETAFILE hWmf,
			BOOL deleteWmf,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromWmf handle bool WmfPlaceableFileHeader* handle*>
	^self invalidCall: _failureCode!

gdipCreateMetafileFromWmfFile: file wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	"Invoke the GdipCreateMetafileFromWmfFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateMetafileFromWmfFile(
			[in]LPWSTR file,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipCreateMetafileFromWmfFile lpwstr WmfPlaceableFileHeader* handle*>
	^self invalidCall: _failureCode!

gdipCreatePath: brushMode path: path
	"Invoke the GdipCreatePath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath(
			GpFillMode brushMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath int32 handle*>
	^self invalidCall: _failureCode!

gdipCreatePath2: points types: types count: count fillMode: fillMode path: path
	"Invoke the GdipCreatePath2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath2(
			[in]POINTF* Points,
			[in]BYTE* Types,
			int Count,
			GpFillMode FillMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath2 POINTF* uint8* int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreatePath2I: points types: types count: count fillMode: fillMode path: path
	"Invoke the GdipCreatePath2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePath2I(
			[in]POINTL* Points,
			[in]BYTE* Types,
			int Count,
			GpFillMode FillMode,
			[out, retval]PGpPath* path);"

	<stdcall: errno GdipCreatePath2I POINTL* uint8* int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreatePathGradient: points count: count wrapMode: wrapMode polyGradient: polyGradient
	"Invoke the GdipCreatePathGradient() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePathGradient(
			[in]POINTF* Points,
			int Count,
			GpWrapMode WrapMode,
			[out, retval]PGpPathGradient* polyGradient);"

	<stdcall: errno GdipCreatePathGradient POINTF* int32 int32 handle*>
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
			[in]POINTL* Points,
			int Count,
			GpWrapMode WrapMode,
			[out, retval]PGpPathGradient* polyGradient);"

	<stdcall: errno GdipCreatePathGradientI POINTL* int32 int32 handle*>
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
			REAL width,
			GpUnit Unit,
			[out, retval]PGpPen* pen);"

	<stdcall: errno GdipCreatePen1 uint32 float int32 handle*>
	^self invalidCall: _failureCode!

gdipCreatePen2: brush width: width unit: unit pen: pen
	"Invoke the GdipCreatePen2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreatePen2(
			PGpBrush brush,
			REAL width,
			GpUnit Unit,
			[out, retval]PGpPen* pen);"

	<stdcall: errno GdipCreatePen2 handle float int32 handle*>
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
			wireHRGN hRgn,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionHrgn handle handle*>
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
			[in]RectF* Rect,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRect RectF* handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionRectI: rect region: region
	"Invoke the GdipCreateRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionRectI(
			[in]Rect* Rect,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRectI Rect* handle*>
	^self invalidCall: _failureCode!

gdipCreateRegionRgnData: regionData size: size region: region
	"Invoke the GdipCreateRegionRgnData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateRegionRgnData(
			[in]BYTE* regionData,
			int Size,
			[out, retval]PGpRegion* region);"

	<stdcall: errno GdipCreateRegionRgnData uint8* int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateSolidFill: color brush: brush
	"Invoke the GdipCreateSolidFill() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateSolidFill(
			[in]ARGB Color,
			[out, retval]PGpSolidFill* brush);"

	<stdcall: errno GdipCreateSolidFill uint32 handle*>
	^self invalidCall: _failureCode!

gdipCreateStreamOnFile: filename access: access stream: stream
	"Invoke the GdipCreateStreamOnFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateStreamOnFile(
			[in]LPWSTR filename,
			unsigned int access,
			[out, retval]IStream** stream);"

	<stdcall: errno GdipCreateStreamOnFile lpwstr uint32 OS.COM.IStream**>
	^self invalidCall: _failureCode!

gdipCreateStringFormat: formatAttributes language: language format: format
	"Invoke the GdipCreateStringFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateStringFormat(
			int formatAttributes,
			LANGID language,
			[out, retval]PGpStringFormat* format);"

	<stdcall: errno GdipCreateStringFormat int32 uint16 handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture: image wrapMode: wrapMode texture: texture
	"Invoke the GdipCreateTexture() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture handle int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture2: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTexture2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture2(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[in]REAL x,
			[in]REAL y,
			[in]REAL width,
			[in]REAL height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture2 handle int32 float float float float handle*>
	^self invalidCall: _failureCode!

gdipCreateTexture2I: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTexture2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTexture2I(
			[in]PGpImage image,
			[in]GpWrapMode WrapMode,
			[in]int x,
			[in]int y,
			[in]int width,
			[in]int height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTexture2I handle int32 int32 int32 int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipCreateTextureIA: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture
	"Invoke the GdipCreateTextureIA() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipCreateTextureIA(
			[in]PGpImage image,
			[in]PGpImageAttributes imageAttributes,
			[in]REAL x,
			[in]REAL y,
			[in]REAL width,
			[in]REAL height,
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
			[in]int width,
			[in]int height,
			[out, retval]PGpTexture* texture);"

	<stdcall: errno GdipCreateTextureIAI handle handle int32 int32 int32 int32 handle*>
	^self invalidCall: _failureCode!

gdipDeleteBrush: brush
	"Invoke the GdipDeleteBrush() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteBrush(
			PGpBrush brush);"

	<stdcall: int32 GdipDeleteBrush handle>
	^self invalidCall: _failureCode!

gdipDeleteCachedBitmap: cachedBitmap
	"Invoke the GdipDeleteCachedBitmap() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteCachedBitmap(
			PGpCachedBitmap cachedBitmap);"

	<stdcall: int32 GdipDeleteCachedBitmap handle>
	^self invalidCall: _failureCode!

gdipDeleteCustomLineCap: customCap
	"Invoke the GdipDeleteCustomLineCap() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteCustomLineCap(
			PGpCustomLineCap customCap);"

	<stdcall: int32 GdipDeleteCustomLineCap handle>
	^self invalidCall: _failureCode!

gdipDeleteFont: font
	"Invoke the GdipDeleteFont() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteFont(
			PGpFont font);"

	<stdcall: int32 GdipDeleteFont handle>
	^self invalidCall: _failureCode!

gdipDeleteFontFamily: fontFamily
	"Invoke the GdipDeleteFontFamily() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteFontFamily(
			PGpFontFamily FontFamily);"

	<stdcall: int32 GdipDeleteFontFamily handle>
	^self invalidCall: _failureCode!

gdipDeleteGraphics: graphics
	"Invoke the GdipDeleteGraphics() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteGraphics(
			PGpGraphics graphics);"

	<stdcall: int32 GdipDeleteGraphics handle>
	^self invalidCall: _failureCode!

gdipDeleteMatrix: matrix
	"Invoke the GdipDeleteMatrix() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteMatrix(
			PGpMatrix matrix);"

	<stdcall: int32 GdipDeleteMatrix handle>
	^self invalidCall: _failureCode!

gdipDeletePath: path
	"Invoke the GdipDeletePath() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeletePath(
			PGpPath path);"

	<stdcall: int32 GdipDeletePath handle>
	^self invalidCall: _failureCode!

gdipDeletePathIter: iterator
	"Invoke the GdipDeletePathIter() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeletePathIter(
			[in]PGpPathIterator iterator);"

	<stdcall: int32 GdipDeletePathIter handle>
	^self invalidCall: _failureCode!

gdipDeletePen: pen
	"Invoke the GdipDeletePen() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeletePen(
			PGpPen pen);"

	<stdcall: int32 GdipDeletePen handle>
	^self invalidCall: _failureCode!

gdipDeletePrivateFontCollection: fontCollection
	"Invoke the GdipDeletePrivateFontCollection() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeletePrivateFontCollection(
			[out, retval]PGpFontCollection* fontCollection);"

	<stdcall: int32 GdipDeletePrivateFontCollection handle*>
	^self invalidCall: _failureCode!

gdipDeleteRegion: region
	"Invoke the GdipDeleteRegion() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteRegion(
			PGpRegion region);"

	<stdcall: int32 GdipDeleteRegion handle>
	^self invalidCall: _failureCode!

gdipDeleteStringFormat: format
	"Invoke the GdipDeleteStringFormat() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDeleteStringFormat(
			PGpStringFormat format);"

	<stdcall: int32 GdipDeleteStringFormat handle>
	^self invalidCall: _failureCode!

gdipDisposeImage: image
	"Invoke the GdipDisposeImage() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDisposeImage(
			[in]PGpImage image);"

	<stdcall: int32 GdipDisposeImage handle>
	^self invalidCall: _failureCode!

gdipDisposeImageAttributes: imageattr
	"Invoke the GdipDisposeImageAttributes() function of the module wrapped by the receiver.

		GpStatus_NoThrow __stdcall GdipDisposeImageAttributes(
			PGpImageAttributes imageattr);"

	<stdcall: int32 GdipDisposeImageAttributes handle>
	^self invalidCall: _failureCode!

gdipDrawArc: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	"Invoke the GdipDrawArc() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawArc(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
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
			int width,
			int height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawArcI handle handle int32 int32 int32 int32 float float>
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

	<stdcall: errno GdipDrawBezierI handle handle int32 int32 int32 int32 int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipDrawBeziers: graphics pen: pen points: points count: count
	"Invoke the GdipDrawBeziers() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBeziers(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipDrawBeziers handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawBeziersI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawBeziersI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawBeziersI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipDrawBeziersI handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipDrawCachedBitmap: graphics cachedBitmap: cachedBitmap x: x y: y
	"Invoke the GdipDrawCachedBitmap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCachedBitmap(
			PGpGraphics graphics,
			PGpCachedBitmap cachedBitmap,
			int x,
			int y);"

	<stdcall: errno GdipDrawCachedBitmap handle handle int32 int32>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve: graphics pen: pen points: points count: count
	"Invoke the GdipDrawClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipDrawClosedCurve handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve2: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve2(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawClosedCurve2 handle handle POINTF* int32 float>
	^self invalidCall: _failureCode!

gdipDrawClosedCurve2I: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurve2I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawClosedCurve2I handle handle POINTL* int32 float>
	^self invalidCall: _failureCode!

gdipDrawClosedCurveI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawClosedCurveI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipDrawClosedCurveI handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipDrawCurve: graphics pen: pen points: points count: count
	"Invoke the GdipDrawCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipDrawCurve handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawCurve2: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve2(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawCurve2 handle handle POINTF* int32 float>
	^self invalidCall: _failureCode!

gdipDrawCurve2I: graphics pen: pen points: points count: count tension: tension
	"Invoke the GdipDrawCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve2I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count,
			REAL tension);"

	<stdcall: errno GdipDrawCurve2I handle handle POINTL* int32 float>
	^self invalidCall: _failureCode!

gdipDrawCurve3: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipDrawCurve3() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve3(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count,
			int Offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipDrawCurve3 handle handle POINTF* int32 int32 int32 float>
	^self invalidCall: _failureCode!

gdipDrawCurve3I: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	"Invoke the GdipDrawCurve3I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurve3I(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count,
			int Offset,
			int numberOfSegments,
			REAL tension);"

	<stdcall: errno GdipDrawCurve3I handle handle POINTL* int32 int32 int32 float>
	^self invalidCall: _failureCode!

gdipDrawCurveI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawCurveI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipDrawCurveI handle handle POINTL* int32>
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

	<stdcall: errno GdipDrawDriverString handle uint16* int32 handle handle POINTF* int32 handle>
	^self invalidCall: _failureCode!

gdipDrawEllipse: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawEllipse(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipDrawEllipse handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawEllipseI: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawEllipseI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipDrawEllipseI handle handle int32 int32 int32 int32>
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

gdipDrawImageFX: graphics image: image source: source xForm: xForm effect: effect imageAttributes: imageAttributes srcUnit: srcUnit
	"Invoke the GdipDrawImageFX() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageFX(
			PGpGraphics graphics,
			PGpImage image,
			RectF* source,
			PGpMatrix xForm,
			PCGpEffect effect,
			PGpImageAttributes imageAttributes,
			GpUnit srcUnit);"

	<stdcall: errno GdipDrawImageFX handle handle RectF* handle handle handle int32>
	^self invalidCall: _failureCode!

gdipDrawImageI: graphics image: image x: x y: y
	"Invoke the GdipDrawImageI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageI(
			PGpGraphics graphics,
			PGpImage image,
			int x,
			int y);"

	<stdcall: errno GdipDrawImageI handle handle int32 int32>
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

	<stdcall: errno GdipDrawImagePointRect handle handle float float float float float float int32>
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

	<stdcall: errno GdipDrawImagePointRectI handle handle int32 int32 int32 int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipDrawImagePoints: graphics image: image dstpoints: dstpoints count: count
	"Invoke the GdipDrawImagePoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePoints(
			PGpGraphics graphics,
			PGpImage image,
			[in]POINTF* dstpoints,
			int Count);"

	<stdcall: errno GdipDrawImagePoints handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawImagePointsI: graphics image: image dstpoints: dstpoints count: count
	"Invoke the GdipDrawImagePointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsI(
			PGpGraphics graphics,
			PGpImage image,
			[in]POINTL* dstpoints,
			int Count);"

	<stdcall: errno GdipDrawImagePointsI handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipDrawImagePointsRect: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImagePointsRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsRect(
			PGpGraphics graphics,
			PGpImage image,
			[in]POINTF* Points,
			int Count,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort CALLBACK,
			void* callbackData);"

	<stdcall: errno GdipDrawImagePointsRect handle handle POINTF* int32 float float float float int32 handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawImagePointsRectI: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	"Invoke the GdipDrawImagePointsRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImagePointsRectI(
			PGpGraphics graphics,
			PGpImage image,
			[in]POINTL* Points,
			int Count,
			int srcx,
			int srcy,
			int srcwidth,
			int srcheight,
			GpUnit srcUnit,
			[in]PGpImageAttributes imageAttributes,
			DrawImageAbort CALLBACK,
			void* callbackData);"

	<stdcall: errno GdipDrawImagePointsRectI handle handle POINTL* int32 int32 int32 int32 int32 int32 handle void* void*>
	^self invalidCall: _failureCode!

gdipDrawImageRect: graphics image: image x: x y: y width: width height: height
	"Invoke the GdipDrawImageRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRect(
			PGpGraphics graphics,
			PGpImage image,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipDrawImageRect handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawImageRectI: graphics image: image x: x y: y width: width height: height
	"Invoke the GdipDrawImageRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawImageRectI(
			PGpGraphics graphics,
			PGpImage image,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipDrawImageRectI handle handle int32 int32 int32 int32>
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
			DrawImageAbort CALLBACK,
			void* callbackData);"

	<stdcall: errno GdipDrawImageRectRect handle handle float float float float float float float float int32 handle void* void*>
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
			DrawImageAbort CALLBACK,
			void* callbackData);"

	<stdcall: errno GdipDrawImageRectRectI handle handle int32 int32 int32 int32 int32 int32 int32 int32 int32 handle void* void*>
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

	<stdcall: errno GdipDrawLineI handle handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipDrawLines: graphics pen: pen points: points count: count
	"Invoke the GdipDrawLines() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLines(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipDrawLines handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawLinesI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawLinesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawLinesI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipDrawLinesI handle handle POINTL* int32>
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
			REAL width,
			REAL height,
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
			int width,
			int height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipDrawPieI handle handle int32 int32 int32 int32 float float>
	^self invalidCall: _failureCode!

gdipDrawPolygon: graphics pen: pen points: points count: count
	"Invoke the GdipDrawPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPolygon(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipDrawPolygon handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipDrawPolygonI: graphics pen: pen points: points count: count
	"Invoke the GdipDrawPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawPolygonI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipDrawPolygonI handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipDrawRectangle: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangle(
			PGpGraphics graphics,
			PGpPen pen,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipDrawRectangle handle handle float float float float>
	^self invalidCall: _failureCode!

gdipDrawRectangleI: graphics pen: pen x: x y: y width: width height: height
	"Invoke the GdipDrawRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangleI(
			PGpGraphics graphics,
			PGpPen pen,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipDrawRectangleI handle handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipDrawRectangles: graphics pen: pen rects: rects count: count
	"Invoke the GdipDrawRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectangles(
			PGpGraphics graphics,
			PGpPen pen,
			[in]RectF* rects,
			int Count);"

	<stdcall: errno GdipDrawRectangles handle handle RectF* int32>
	^self invalidCall: _failureCode!

gdipDrawRectanglesI: graphics pen: pen rects: rects count: count
	"Invoke the GdipDrawRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawRectanglesI(
			PGpGraphics graphics,
			PGpPen pen,
			[in]Rect* rects,
			int Count);"

	<stdcall: errno GdipDrawRectanglesI handle handle Rect* int32>
	^self invalidCall: _failureCode!

gdipDrawString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat brush: brush
	"Invoke the GdipDrawString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipDrawString(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RectF* layoutRect,
			[in]PGpStringFormat stringFormat,
			[in]PGpBrush brush);"

	<stdcall: errno GdipDrawString handle lpwstr int32 handle RectF* handle handle>
	^self invalidCall: _failureCode!

gdipEmfToWmfBits: hEmf cbData16: cbData16 pData16: pData16 iMapMode: iMapMode eFlags: eFlags
	"Invoke the GdipEmfToWmfBits() function of the module wrapped by the receiver.

		unsigned int __stdcall GdipEmfToWmfBits(
			HENHMETAFILE hEmf,
			unsigned int cbData16,
			LPBYTE pData16,
			int iMapMode,
			int eFlags);"

	<stdcall: uint32 GdipEmfToWmfBits handle uint32 uint8* int32 int32>
	^self invalidCall: _failureCode!

gdipEndContainer: graphics state: state
	"Invoke the GdipEndContainer() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEndContainer(
			PGpGraphics graphics,
			GraphicsContainer state);"

	<stdcall: errno GdipEndContainer handle uint32>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPoint: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPoint(
			[in]PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoint,
			[in]EnumerateMetafileProc fnCallback,
			[in]void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPoint handle handle POINTF* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPointI: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPointI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINT* destPoint,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
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
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPoints handle handle POINTF* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestPointsI: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestPointsI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINT* destPoints,
			int Count,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestPointsI handle handle POINTL* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestRect: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestRect(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RectF* destRect,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestRect handle handle RectF* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileDestRectI: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileDestRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileDestRectI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]Rect* destRect,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileDestRectI handle handle Rect* void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPoint: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoint(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoint,
			[in]RectF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPoint handle handle POINTF* RectF* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPointI: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINT* destPoint,
			[in]Rect* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPointI handle handle POINTL* Rect* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPoints: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPoints(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINTF* destPoints,
			int Count,
			[in]RectF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPoints handle handle POINTF* int32 RectF* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestPointsI: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestPointsI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]POINT* destPoints,
			int Count,
			[in]Rect* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestPointsI handle handle POINTL* int32 Rect* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestRect: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRect(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]RectF* destRect,
			[in]RectF* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestRect handle handle RectF* RectF* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipEnumerateMetafileSrcRectDestRectI: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	"Invoke the GdipEnumerateMetafileSrcRectDestRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipEnumerateMetafileSrcRectDestRectI(
			PGpGraphics graphics,
			[in]PGpMetafile metafile,
			[in]Rect* destRect,
			[in]Rect* srcRect,
			Unit srcUnit,
			EnumerateMetafileProc fnCallback,
			void* callbackData,
			[in]PGpImageAttributes imageAttributes);"

	<stdcall: errno GdipEnumerateMetafileSrcRectDestRectI handle handle Rect* Rect* int32 void* void* handle>
	^self invalidCall: _failureCode!

gdipFillClosedCurve: graphics brush: brush points: points count: count
	"Invoke the GdipFillClosedCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipFillClosedCurve handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipFillClosedCurve2: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	"Invoke the GdipFillClosedCurve2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve2(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTF* Points,
			int Count,
			REAL tension,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillClosedCurve2 handle handle POINTF* int32 float int32>
	^self invalidCall: _failureCode!

gdipFillClosedCurve2I: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	"Invoke the GdipFillClosedCurve2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurve2I(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTL* Points,
			int Count,
			REAL tension,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillClosedCurve2I handle handle POINTL* int32 float int32>
	^self invalidCall: _failureCode!

gdipFillClosedCurveI: graphics brush: brush points: points count: count
	"Invoke the GdipFillClosedCurveI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillClosedCurveI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipFillClosedCurveI handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipFillEllipse: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillEllipse() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillEllipse(
			PGpGraphics graphics,
			PGpBrush brush,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipFillEllipse handle handle float float float float>
	^self invalidCall: _failureCode!

gdipFillEllipseI: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillEllipseI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillEllipseI(
			PGpGraphics graphics,
			PGpBrush brush,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipFillEllipseI handle handle int32 int32 int32 int32>
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
			REAL width,
			REAL height,
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
			int width,
			int height,
			REAL startAngle,
			REAL sweepAngle);"

	<stdcall: errno GdipFillPieI handle handle int32 int32 int32 int32 float float>
	^self invalidCall: _failureCode!

gdipFillPolygon: graphics brush: brush points: points count: count fillMode: fillMode
	"Invoke the GdipFillPolygon() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTF* Points,
			int Count,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillPolygon handle handle POINTF* int32 int32>
	^self invalidCall: _failureCode!

gdipFillPolygon2: graphics brush: brush points: points count: count
	"Invoke the GdipFillPolygon2() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon2(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTF* Points,
			int Count);"

	<stdcall: errno GdipFillPolygon2 handle handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipFillPolygon2I: graphics brush: brush points: points count: count
	"Invoke the GdipFillPolygon2I() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygon2I(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTL* Points,
			int Count);"

	<stdcall: errno GdipFillPolygon2I handle handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipFillPolygonI: graphics brush: brush points: points count: count fillMode: fillMode
	"Invoke the GdipFillPolygonI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillPolygonI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]POINTL* Points,
			int Count,
			GpFillMode FillMode);"

	<stdcall: errno GdipFillPolygonI handle handle POINTL* int32 int32>
	^self invalidCall: _failureCode!

gdipFillRectangle: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillRectangle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangle(
			PGpGraphics graphics,
			PGpBrush brush,
			REAL x,
			REAL y,
			REAL width,
			REAL height);"

	<stdcall: errno GdipFillRectangle handle handle float float float float>
	^self invalidCall: _failureCode!

gdipFillRectangleI: graphics brush: brush x: x y: y width: width height: height
	"Invoke the GdipFillRectangleI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangleI(
			PGpGraphics graphics,
			PGpBrush brush,
			int x,
			int y,
			int width,
			int height);"

	<stdcall: errno GdipFillRectangleI handle handle int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipFillRectangles: graphics brush: brush rects: rects count: count
	"Invoke the GdipFillRectangles() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectangles(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]RectF* rects,
			int Count);"

	<stdcall: errno GdipFillRectangles handle handle RectF* int32>
	^self invalidCall: _failureCode!

gdipFillRectanglesI: graphics brush: brush rects: rects count: count
	"Invoke the GdipFillRectanglesI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRectanglesI(
			PGpGraphics graphics,
			PGpBrush brush,
			[in]Rect* rects,
			int Count);"

	<stdcall: errno GdipFillRectanglesI handle handle Rect* int32>
	^self invalidCall: _failureCode!

gdipFillRegion: graphics brush: brush region: region
	"Invoke the GdipFillRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFillRegion(
			PGpGraphics graphics,
			PGpBrush brush,
			PGpRegion region);"

	<stdcall: errno GdipFillRegion handle handle handle>
	^self invalidCall: _failureCode!

gdipFindFirstImageItem: image item: item
	"Invoke the GdipFindFirstImageItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFindFirstImageItem(
			[in]PGpImage image,
			ImageItemData* item);"

	<stdcall: errno GdipFindFirstImageItem handle ImageItemData*>
	^self invalidCall: _failureCode!

gdipFindNextImageItem: image item: item
	"Invoke the GdipFindNextImageItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFindNextImageItem(
			[in]PGpImage image,
			ImageItemData* item);"

	<stdcall: errno GdipFindNextImageItem handle ImageItemData*>
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

	<stdcall: errno GdipFlush handle int32>
	^self invalidCall: _failureCode!

gdipFontCollectionEnumerable: fontCollection graphics: graphics numFound: numFound
	"Invoke the GdipFontCollectionEnumerable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFontCollectionEnumerable(
			PGpFontCollection fontCollection,
			PGpGraphics graphics,
			[out]int* numFound);"

	<stdcall: errno GdipFontCollectionEnumerable handle handle int32*>
	^self invalidCall: _failureCode!

gdipFontCollectionEnumerate: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound graphics: graphics
	"Invoke the GdipFontCollectionEnumerate() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipFontCollectionEnumerate(
			PGpFontCollection fontCollection,
			int numSought,
			PGpFontFamily* gpfamilies,
			[out]int* numFound,
			PGpGraphics graphics);"

	<stdcall: errno GdipFontCollectionEnumerate handle int32 handle* int32* handle>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapFillState: cap fillState: fillState
	"Invoke the GdipGetAdjustableArrowCapFillState() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapFillState(
			PGpAdjustableArrowCap cap,
			BOOL* fillState);"

	<stdcall: errno GdipGetAdjustableArrowCapFillState handle bool*>
	^self invalidCall: _failureCode!

gdipGetAdjustableArrowCapHeight: cap height: height
	"Invoke the GdipGetAdjustableArrowCapHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAdjustableArrowCapHeight(
			PGpAdjustableArrowCap cap,
			REAL* height);"

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
			REAL* width);"

	<stdcall: errno GdipGetAdjustableArrowCapWidth handle float*>
	^self invalidCall: _failureCode!

gdipGetAllPropertyItems: image totalBufferSize: totalBufferSize numProperties: numProperties allItems: allItems
	"Invoke the GdipGetAllPropertyItems() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetAllPropertyItems(
			[in]PGpImage image,
			[in]unsigned int totalBufferSize,
			[in]unsigned int numProperties,
			PropertyItem* allItems);"

	<stdcall: errno GdipGetAllPropertyItems handle uint32 uint32 PropertyItem*>
	^self invalidCall: _failureCode!

gdipGetBrushType: brush type: type
	"Invoke the GdipGetBrushType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetBrushType(
			PGpBrush brush,
			GpBrushType* Type);"

	<stdcall: errno GdipGetBrushType handle int32*>
	^self invalidCall: _failureCode!

gdipGetCellAscent: family style: style cellAscent: cellAscent
	"Invoke the GdipGetCellAscent() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCellAscent(
			[in]PGpFontFamily family,
			int style,
			[out, retval]UINT16* CellAscent);"

	<stdcall: errno GdipGetCellAscent handle int32 uint16*>
	^self invalidCall: _failureCode!

gdipGetCellDescent: family style: style cellDescent: cellDescent
	"Invoke the GdipGetCellDescent() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCellDescent(
			[in]PGpFontFamily family,
			int style,
			[out, retval]UINT16* CellDescent);"

	<stdcall: errno GdipGetCellDescent handle int32 uint16*>
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
			RectF* Rect);"

	<stdcall: errno GdipGetClipBounds handle RectF*>
	^self invalidCall: _failureCode!

gdipGetClipBoundsI: graphics rect: rect
	"Invoke the GdipGetClipBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetClipBoundsI(
			PGpGraphics graphics,
			Rect* Rect);"

	<stdcall: errno GdipGetClipBoundsI handle Rect*>
	^self invalidCall: _failureCode!

gdipGetCompositingMode: graphics compositingMode: compositingMode
	"Invoke the GdipGetCompositingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCompositingMode(
			PGpGraphics graphics,
			CompositingMode* CompositingMode);"

	<stdcall: errno GdipGetCompositingMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetCompositingQuality: graphics compositingQuality: compositingQuality
	"Invoke the GdipGetCompositingQuality() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCompositingQuality(
			PGpGraphics graphics,
			CompositingQuality* CompositingQuality);"

	<stdcall: errno GdipGetCompositingQuality handle int32*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapBaseCap: customCap baseCap: baseCap
	"Invoke the GdipGetCustomLineCapBaseCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapBaseCap(
			PGpCustomLineCap customCap,
			GpLineCap* baseCap);"

	<stdcall: errno GdipGetCustomLineCapBaseCap handle int32*>
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

	<stdcall: errno GdipGetCustomLineCapStrokeCaps handle int32* int32*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	"Invoke the GdipGetCustomLineCapStrokeJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapStrokeJoin(
			PGpCustomLineCap customCap,
			GpLineJoin* LineJoin);"

	<stdcall: errno GdipGetCustomLineCapStrokeJoin handle int32*>
	^self invalidCall: _failureCode!

gdipGetCustomLineCapType: customCap capType: capType
	"Invoke the GdipGetCustomLineCapType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetCustomLineCapType(
			PGpCustomLineCap customCap,
			CustomLineCapType* capType);"

	<stdcall: errno GdipGetCustomLineCapType handle int32*>
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
			[out, retval]UINT16* EmHeight);"

	<stdcall: errno GdipGetEmHeight handle int32 uint16*>
	^self invalidCall: _failureCode!

gdipGetEncoderParameterList: image clsidEncoder: clsidEncoder size: size buffer: buffer
	"Invoke the GdipGetEncoderParameterList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetEncoderParameterList(
			[in]PGpImage image,
			[in]GUID* clsidEncoder,
			[in]unsigned int Size,
			[out, retval]EncoderParameters* buffer);"

	<stdcall: errno GdipGetEncoderParameterList handle guid* uint32 EncoderParameters*>
	^self invalidCall: _failureCode!

gdipGetEncoderParameterListSize: image clsidEncoder: clsidEncoder size: size
	"Invoke the GdipGetEncoderParameterListSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetEncoderParameterListSize(
			[in]PGpImage image,
			[in]GUID* clsidEncoder,
			[out, retval]unsigned int* Size);"

	<stdcall: errno GdipGetEncoderParameterListSize handle guid* uint32*>
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

		GpStatus __stdcall GdipGetFamilyName(
			[in]PGpFontFamily family,
			[out, string]WCHAR name[32],
			[in]LANGID language);"

	<stdcall: errno GdipGetFamilyName handle lpwstr uint16>
	^self invalidCall: _failureCode!

gdipGetFontCollectionFamilyCount: fontCollection numFound: numFound
	"Invoke the GdipGetFontCollectionFamilyCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontCollectionFamilyCount(
			PGpFontCollection fontCollection,
			int* numFound);"

	<stdcall: errno GdipGetFontCollectionFamilyCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetFontCollectionFamilyList: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound
	"Invoke the GdipGetFontCollectionFamilyList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontCollectionFamilyList(
			PGpFontCollection fontCollection,
			int numSought,
			PGpFontFamily* gpfamilies,
			int* numFound);"

	<stdcall: errno GdipGetFontCollectionFamilyList handle int32 handle* int32*>
	^self invalidCall: _failureCode!

gdipGetFontHeight: font graphics: graphics height: height
	"Invoke the GdipGetFontHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontHeight(
			[in]PGpFont font,
			[in]PGpGraphics graphics,
			REAL* height);"

	<stdcall: errno GdipGetFontHeight handle handle float*>
	^self invalidCall: _failureCode!

gdipGetFontHeightGivenDPI: font dpi: dpi height: height
	"Invoke the GdipGetFontHeightGivenDPI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontHeightGivenDPI(
			[in]PGpFont font,
			REAL dpi,
			REAL* height);"

	<stdcall: errno GdipGetFontHeightGivenDPI handle float float*>
	^self invalidCall: _failureCode!

gdipGetFontSize: font size: size
	"Invoke the GdipGetFontSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontSize(
			PGpFont font,
			REAL* Size);"

	<stdcall: errno GdipGetFontSize handle float*>
	^self invalidCall: _failureCode!

gdipGetFontStyle: font style: style
	"Invoke the GdipGetFontStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontStyle(
			PGpFont font,
			FontStyle* style);"

	<stdcall: errno GdipGetFontStyle handle int32*>
	^self invalidCall: _failureCode!

gdipGetFontUnit: font unit: unit
	"Invoke the GdipGetFontUnit() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetFontUnit(
			PGpFont font,
			Unit* Unit);"

	<stdcall: errno GdipGetFontUnit handle int32*>
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

	<stdcall: errno GdipGetHatchBackgroundColor handle uint32*>
	^self invalidCall: _failureCode!

gdipGetHatchForegroundColor: brush forecol: forecol
	"Invoke the GdipGetHatchForegroundColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHatchForegroundColor(
			PGpHatch brush,
			ARGB* forecol);"

	<stdcall: errno GdipGetHatchForegroundColor handle uint32*>
	^self invalidCall: _failureCode!

gdipGetHatchStyle: brush hatchStyle: hatchStyle
	"Invoke the GdipGetHatchStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetHatchStyle(
			PGpHatch brush,
			GpHatchStyle* HatchStyle);"

	<stdcall: errno GdipGetHatchStyle handle int32*>
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

	<stdcall: errno GdipGetImageAttributesAdjustedPalette handle ColorPalette* int32>
	^self invalidCall: _failureCode!

gdipGetImageBounds: image srcRect: srcRect srcUnit: srcUnit
	"Invoke the GdipGetImageBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageBounds(
			[in]PGpImage image,
			RectF* srcRect,
			GpUnit* srcUnit);"

	<stdcall: errno GdipGetImageBounds handle RectF* int32*>
	^self invalidCall: _failureCode!

gdipGetImageDecoders: numDecoders size: size decoders: decoders
	"Invoke the GdipGetImageDecoders() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDecoders(
			unsigned int numDecoders,
			unsigned int Size,
			ImageCodecInfo* decoders);"

	<stdcall: errno GdipGetImageDecoders uint32 uint32 ImageCodecInfo*>
	^self invalidCall: _failureCode!

gdipGetImageDecodersSize: numDecoders size: size
	"Invoke the GdipGetImageDecodersSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDecodersSize(
			unsigned int* numDecoders,
			unsigned int* Size);"

	<stdcall: errno GdipGetImageDecodersSize uint32* uint32*>
	^self invalidCall: _failureCode!

gdipGetImageDimension: image width: width height: height
	"Invoke the GdipGetImageDimension() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageDimension(
			[in]PGpImage image,
			[out]REAL* width,
			[out]REAL* height);"

	<stdcall: errno GdipGetImageDimension handle float* float*>
	^self invalidCall: _failureCode!

gdipGetImageEncoders: numEncoders size: size encoders: encoders
	"Invoke the GdipGetImageEncoders() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageEncoders(
			[in]unsigned int numEncoders,
			[in]unsigned int Size,
			[in, out]ImageCodecInfo* encoders);"

	<stdcall: errno GdipGetImageEncoders uint32 uint32 ImageCodecInfo*>
	^self invalidCall: _failureCode!

gdipGetImageEncodersSize: numEncoders size: size
	"Invoke the GdipGetImageEncodersSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageEncodersSize(
			[out]unsigned int* numEncoders,
			[out]unsigned int* Size);"

	<stdcall: errno GdipGetImageEncodersSize uint32* uint32*>
	^self invalidCall: _failureCode!

gdipGetImageFlags: image flags: flags
	"Invoke the GdipGetImageFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageFlags(
			[in]PGpImage image,
			[out, retval]unsigned int* Flags);"

	<stdcall: errno GdipGetImageFlags handle uint32*>
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
			[out, retval]unsigned int* height);"

	<stdcall: errno GdipGetImageHeight handle uint32*>
	^self invalidCall: _failureCode!

gdipGetImageHorizontalResolution: image resolution: resolution
	"Invoke the GdipGetImageHorizontalResolution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageHorizontalResolution(
			[in]PGpImage image,
			[out, retval]REAL* resolution);"

	<stdcall: errno GdipGetImageHorizontalResolution handle float*>
	^self invalidCall: _failureCode!

gdipGetImageItemData: image item: item
	"Invoke the GdipGetImageItemData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageItemData(
			[in]PGpImage image,
			ImageItemData* item);"

	<stdcall: errno GdipGetImageItemData handle ImageItemData*>
	^self invalidCall: _failureCode!

gdipGetImagePalette: image palette: palette size: size
	"Invoke the GdipGetImagePalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePalette(
			[in]PGpImage image,
			ColorPalette* palette,
			int Size);"

	<stdcall: errno GdipGetImagePalette handle ColorPalette* int32>
	^self invalidCall: _failureCode!

gdipGetImagePaletteSize: image size: size
	"Invoke the GdipGetImagePaletteSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePaletteSize(
			[in]PGpImage image,
			[out, retval]int* Size);"

	<stdcall: errno GdipGetImagePaletteSize handle int32*>
	^self invalidCall: _failureCode!

gdipGetImagePixelFormat: image format: format
	"Invoke the GdipGetImagePixelFormat() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImagePixelFormat(
			[in]PGpImage image,
			[out, retval]PixelFormat* format);"

	<stdcall: errno GdipGetImagePixelFormat handle int32*>
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
			[in]void* callbackData);"

	<stdcall: errno GdipGetImageThumbnail handle uint32 uint32 handle* void* void*>
	^self invalidCall: _failureCode!

gdipGetImageType: image type: type
	"Invoke the GdipGetImageType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetImageType(
			[in]PGpImage image,
			[out, retval]ImageType* Type);"

	<stdcall: errno GdipGetImageType handle int32*>
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
			[out, retval]unsigned int* width);"

	<stdcall: errno GdipGetImageWidth handle uint32*>
	^self invalidCall: _failureCode!

gdipGetInterpolationMode: graphics interpolationMode: interpolationMode
	"Invoke the GdipGetInterpolationMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetInterpolationMode(
			PGpGraphics graphics,
			InterpolationMode* InterpolationMode);"

	<stdcall: errno GdipGetInterpolationMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetLineBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetLineBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineBlend(
			PGpLineGradient brush,
			REAL* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetLineBlend handle float* float* int32>
	^self invalidCall: _failureCode!

gdipGetLineBlendCount: brush count: count
	"Invoke the GdipGetLineBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineBlendCount(
			PGpLineGradient brush,
			int* Count);"

	<stdcall: errno GdipGetLineBlendCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetLineColors: brush colors: colors
	"Invoke the GdipGetLineColors() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineColors(
			PGpLineGradient brush,
			ARGB* colors);"

	<stdcall: errno GdipGetLineColors handle uint32*>
	^self invalidCall: _failureCode!

gdipGetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipGetLineGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineGammaCorrection(
			PGpLineGradient brush,
			BOOL* useGammaCorrection);"

	<stdcall: errno GdipGetLineGammaCorrection handle bool*>
	^self invalidCall: _failureCode!

gdipGetLinePresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetLinePresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLinePresetBlend(
			PGpLineGradient brush,
			ARGB* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetLinePresetBlend handle uint32* float* int32>
	^self invalidCall: _failureCode!

gdipGetLinePresetBlendCount: brush count: count
	"Invoke the GdipGetLinePresetBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLinePresetBlendCount(
			PGpLineGradient brush,
			int* Count);"

	<stdcall: errno GdipGetLinePresetBlendCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetLineRect: brush rect: rect
	"Invoke the GdipGetLineRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineRect(
			PGpLineGradient brush,
			RectF* Rect);"

	<stdcall: errno GdipGetLineRect handle RectF*>
	^self invalidCall: _failureCode!

gdipGetLineRectI: brush rect: rect
	"Invoke the GdipGetLineRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineRectI(
			PGpLineGradient brush,
			Rect* Rect);"

	<stdcall: errno GdipGetLineRectI handle Rect*>
	^self invalidCall: _failureCode!

gdipGetLineSpacing: family style: style lineSpacing: lineSpacing
	"Invoke the GdipGetLineSpacing() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLineSpacing(
			[in]PGpFontFamily family,
			int style,
			[out, retval]UINT16* LineSpacing);"

	<stdcall: errno GdipGetLineSpacing handle int32 uint16*>
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

	<stdcall: errno GdipGetLineWrapMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetLogFontW: font graphics: graphics logfontw: logfontw
	"Invoke the GdipGetLogFontW() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetLogFontW(
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

	<stdcall: errno GdipGetMetafileDownLevelRasterizationLimit handle uint32*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromEmf: hEmf header: header
	"Invoke the GdipGetMetafileHeaderFromEmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromEmf(
			HENHMETAFILE hEmf,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromEmf handle MetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromFile: filename header: header
	"Invoke the GdipGetMetafileHeaderFromFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromFile(
			[in]LPWSTR filename,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromFile lpwstr MetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromMetafile: metafile header: header
	"Invoke the GdipGetMetafileHeaderFromMetafile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromMetafile(
			PGpMetafile metafile,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromMetafile handle MetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromStream: stream header: header
	"Invoke the GdipGetMetafileHeaderFromStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromStream(
			IStream* stream,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromStream COM.IStream* MetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetMetafileHeaderFromWmf: hWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader header: header
	"Invoke the GdipGetMetafileHeaderFromWmf() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetMetafileHeaderFromWmf(
			HMETAFILE hWmf,
			[in]WmfPlaceableFileHeader* WmfPlaceableFileHeader,
			MetafileHeader* header);"

	<stdcall: errno GdipGetMetafileHeaderFromWmf handle WmfPlaceableFileHeader* MetafileHeader*>
	^self invalidCall: _failureCode!

gdipGetNearestColor: graphics argb: argb
	"Invoke the GdipGetNearestColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetNearestColor(
			PGpGraphics graphics,
			ARGB* ARGB);"

	<stdcall: errno GdipGetNearestColor handle uint32*>
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

	<stdcall: errno GdipGetPageUnit handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathData: path pathData: pathData
	"Invoke the GdipGetPathData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathData(
			PGpPath path,
			GpPathData* pathData);"

	<stdcall: errno GdipGetPathData handle PathData*>
	^self invalidCall: _failureCode!

gdipGetPathFillMode: path fillMode: fillMode
	"Invoke the GdipGetPathFillMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathFillMode(
			PGpPath path,
			GpFillMode* FillMode);"

	<stdcall: errno GdipGetPathFillMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetPathGradientBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientBlend(
			PGpPathGradient brush,
			REAL* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetPathGradientBlend handle float* float* int32>
	^self invalidCall: _failureCode!

gdipGetPathGradientBlendCount: brush count: count
	"Invoke the GdipGetPathGradientBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientBlendCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientBlendCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterColor: brush colors: colors
	"Invoke the GdipGetPathGradientCenterColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterColor(
			PGpPathGradient brush,
			ARGB* colors);"

	<stdcall: errno GdipGetPathGradientCenterColor handle uint32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterPoint: brush points: points
	"Invoke the GdipGetPathGradientCenterPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterPoint(
			PGpPathGradient brush,
			POINTF* Points);"

	<stdcall: errno GdipGetPathGradientCenterPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipGetPathGradientCenterPointI: brush points: points
	"Invoke the GdipGetPathGradientCenterPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientCenterPointI(
			PGpPathGradient brush,
			POINTL* Points);"

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
			BOOL* useGammaCorrection);"

	<stdcall: errno GdipGetPathGradientGammaCorrection handle bool*>
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

	<stdcall: errno GdipGetPathGradientPointCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientPresetBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipGetPathGradientPresetBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPresetBlend(
			PGpPathGradient brush,
			ARGB* blend,
			REAL* positions,
			int Count);"

	<stdcall: errno GdipGetPathGradientPresetBlend handle uint32* float* int32>
	^self invalidCall: _failureCode!

gdipGetPathGradientPresetBlendCount: brush count: count
	"Invoke the GdipGetPathGradientPresetBlendCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientPresetBlendCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientPresetBlendCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientRect: brush rect: rect
	"Invoke the GdipGetPathGradientRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientRect(
			PGpPathGradient brush,
			RectF* Rect);"

	<stdcall: errno GdipGetPathGradientRect handle RectF*>
	^self invalidCall: _failureCode!

gdipGetPathGradientRectI: brush rect: rect
	"Invoke the GdipGetPathGradientRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientRectI(
			PGpPathGradient brush,
			Rect* Rect);"

	<stdcall: errno GdipGetPathGradientRectI handle Rect*>
	^self invalidCall: _failureCode!

gdipGetPathGradientSurroundColorCount: brush count: count
	"Invoke the GdipGetPathGradientSurroundColorCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientSurroundColorCount(
			PGpPathGradient brush,
			int* Count);"

	<stdcall: errno GdipGetPathGradientSurroundColorCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathGradientSurroundColorsWithCount: brush color: color count: count
	"Invoke the GdipGetPathGradientSurroundColorsWithCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathGradientSurroundColorsWithCount(
			PGpPathGradient brush,
			ARGB* Color,
			int* Count);"

	<stdcall: errno GdipGetPathGradientSurroundColorsWithCount handle uint32* int32*>
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

	<stdcall: errno GdipGetPathGradientWrapMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetPathLastPoint: path lastPoint: lastPoint
	"Invoke the GdipGetPathLastPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathLastPoint(
			PGpPath path,
			POINTF* lastPoint);"

	<stdcall: errno GdipGetPathLastPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipGetPathPoints: path points: points count: count
	"Invoke the GdipGetPathPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathPoints(
			PGpPath path,
			POINTF* Points,
			int Count);"

	<stdcall: errno GdipGetPathPoints handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipGetPathPointsI: path points: points count: count
	"Invoke the GdipGetPathPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathPointsI(
			PGpPath path,
			POINTL* Points,
			int Count);"

	<stdcall: errno GdipGetPathPointsI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipGetPathTypes: path types: types count: count
	"Invoke the GdipGetPathTypes() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathTypes(
			PGpPath path,
			BYTE* Types,
			int Count);"

	<stdcall: errno GdipGetPathTypes handle uint8* int32>
	^self invalidCall: _failureCode!

gdipGetPathWorldBounds: path bounds: bounds matrix: matrix pen: pen
	"Invoke the GdipGetPathWorldBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathWorldBounds(
			PGpPath path,
			RectF* bounds,
			[in]PGpMatrix matrix,
			[in]PGpPen pen);"

	<stdcall: errno GdipGetPathWorldBounds handle RectF* handle handle>
	^self invalidCall: _failureCode!

gdipGetPathWorldBoundsI: path bounds: bounds matrix: matrix pen: pen
	"Invoke the GdipGetPathWorldBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPathWorldBoundsI(
			PGpPath path,
			Rect* bounds,
			[in]PGpMatrix matrix,
			[in]PGpPen pen);"

	<stdcall: errno GdipGetPathWorldBoundsI handle Rect* handle handle>
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

	<stdcall: errno GdipGetPenColor handle uint32*>
	^self invalidCall: _failureCode!

gdipGetPenCompoundArray: pen dash: dash count: count
	"Invoke the GdipGetPenCompoundArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCompoundArray(
			PGpPen pen,
			REAL* dash,
			int Count);"

	<stdcall: errno GdipGetPenCompoundArray handle float* int32>
	^self invalidCall: _failureCode!

gdipGetPenCompoundCount: pen count: count
	"Invoke the GdipGetPenCompoundCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenCompoundCount(
			PGpPen pen,
			int* Count);"

	<stdcall: errno GdipGetPenCompoundCount handle int32*>
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

	<stdcall: errno GdipGetPenDashArray handle float* int32>
	^self invalidCall: _failureCode!

gdipGetPenDashCap197819: pen dashCap: dashCap
	"Invoke the GdipGetPenDashCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashCap197819(
			PGpPen pen,
			GpDashCap* DashCap);"

	<stdcall: errno GdipGetPenDashCap197819 handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenDashCount: pen count: count
	"Invoke the GdipGetPenDashCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashCount(
			PGpPen pen,
			int* Count);"

	<stdcall: errno GdipGetPenDashCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenDashOffset: pen offset: offset
	"Invoke the GdipGetPenDashOffset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashOffset(
			PGpPen pen,
			REAL* Offset);"

	<stdcall: errno GdipGetPenDashOffset handle float*>
	^self invalidCall: _failureCode!

gdipGetPenDashStyle: pen dashStyle: dashStyle
	"Invoke the GdipGetPenDashStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenDashStyle(
			PGpPen pen,
			GpDashStyle* DashStyle);"

	<stdcall: errno GdipGetPenDashStyle handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenEndCap: pen endCap: endCap
	"Invoke the GdipGetPenEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenEndCap(
			PGpPen pen,
			GpLineCap* endCap);"

	<stdcall: errno GdipGetPenEndCap handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenFillType: pen type: type
	"Invoke the GdipGetPenFillType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenFillType(
			PGpPen pen,
			GpPenType* Type);"

	<stdcall: errno GdipGetPenFillType handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenLineJoin: pen lineJoin: lineJoin
	"Invoke the GdipGetPenLineJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenLineJoin(
			PGpPen pen,
			GpLineJoin* LineJoin);"

	<stdcall: errno GdipGetPenLineJoin handle int32*>
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

	<stdcall: errno GdipGetPenMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenStartCap: pen startCap: startCap
	"Invoke the GdipGetPenStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenStartCap(
			PGpPen pen,
			GpLineCap* startCap);"

	<stdcall: errno GdipGetPenStartCap handle int32*>
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

	<stdcall: errno GdipGetPenUnit handle int32*>
	^self invalidCall: _failureCode!

gdipGetPenWidth: pen width: width
	"Invoke the GdipGetPenWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPenWidth(
			PGpPen pen,
			REAL* width);"

	<stdcall: errno GdipGetPenWidth handle float*>
	^self invalidCall: _failureCode!

gdipGetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	"Invoke the GdipGetPixelOffsetMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPixelOffsetMode(
			PGpGraphics graphics,
			PixelOffsetMode* PixelOffsetMode);"

	<stdcall: errno GdipGetPixelOffsetMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetPointCount: path count: count
	"Invoke the GdipGetPointCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPointCount(
			PGpPath path,
			int* Count);"

	<stdcall: errno GdipGetPointCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetPropertyCount: image numOfProperty: numOfProperty
	"Invoke the GdipGetPropertyCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyCount(
			[in]PGpImage image,
			[out, retval]unsigned int* numOfProperty);"

	<stdcall: errno GdipGetPropertyCount handle uint32*>
	^self invalidCall: _failureCode!

gdipGetPropertyIdList: image numOfProperty: numOfProperty list: list
	"Invoke the GdipGetPropertyIdList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyIdList(
			[in]PGpImage image,
			[in]unsigned int numOfProperty,
			unsigned long* list);"

	<stdcall: errno GdipGetPropertyIdList handle uint32 uint32*>
	^self invalidCall: _failureCode!

gdipGetPropertyItem: image propId: propId propSize: propSize buffer: buffer
	"Invoke the GdipGetPropertyItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyItem(
			[in]PGpImage image,
			[in]unsigned long propId,
			[in]unsigned int propSize,
			PropertyItem* buffer);"

	<stdcall: errno GdipGetPropertyItem handle uint32 uint32 PropertyItem*>
	^self invalidCall: _failureCode!

gdipGetPropertyItemSize: image propId: propId size: size
	"Invoke the GdipGetPropertyItemSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertyItemSize(
			[in]PGpImage image,
			[in]unsigned long propId,
			unsigned int* Size);"

	<stdcall: errno GdipGetPropertyItemSize handle uint32 uint32*>
	^self invalidCall: _failureCode!

gdipGetPropertySize: image totalBufferSize: totalBufferSize numProperties: numProperties
	"Invoke the GdipGetPropertySize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetPropertySize(
			[in]PGpImage image,
			unsigned int* totalBufferSize,
			unsigned int* numProperties);"

	<stdcall: errno GdipGetPropertySize handle uint32* uint32*>
	^self invalidCall: _failureCode!

gdipGetRegionBounds: region graphics: graphics rect: rect
	"Invoke the GdipGetRegionBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionBounds(
			PGpRegion region,
			PGpGraphics graphics,
			RectF* Rect);"

	<stdcall: errno GdipGetRegionBounds handle handle RectF*>
	^self invalidCall: _failureCode!

gdipGetRegionBoundsI: region graphics: graphics rect: rect
	"Invoke the GdipGetRegionBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionBoundsI(
			PGpRegion region,
			PGpGraphics graphics,
			Rect* Rect);"

	<stdcall: errno GdipGetRegionBoundsI handle handle Rect*>
	^self invalidCall: _failureCode!

gdipGetRegionData: region buffer: buffer bufferSize: bufferSize sizeFilled: sizeFilled
	"Invoke the GdipGetRegionData() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionData(
			PGpRegion region,
			BYTE* buffer,
			unsigned int bufferSize,
			unsigned int* sizeFilled);"

	<stdcall: errno GdipGetRegionData handle uint8* uint32 uint32*>
	^self invalidCall: _failureCode!

gdipGetRegionDataSize: region bufferSize: bufferSize
	"Invoke the GdipGetRegionDataSize() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionDataSize(
			PGpRegion region,
			unsigned int* bufferSize);"

	<stdcall: errno GdipGetRegionDataSize handle uint32*>
	^self invalidCall: _failureCode!

gdipGetRegionHRgn: region graphics: graphics hRgn: hRgn
	"Invoke the GdipGetRegionHRgn() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionHRgn(
			PGpRegion region,
			PGpGraphics graphics,
			wireHRGN* hRgn);"

	<stdcall: errno GdipGetRegionHRgn handle handle handle*>
	^self invalidCall: _failureCode!

gdipGetRegionScans: region rects: rects count: count matrix: matrix
	"Invoke the GdipGetRegionScans() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScans(
			PGpRegion region,
			RectF* rects,
			int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScans handle RectF* int32* handle>
	^self invalidCall: _failureCode!

gdipGetRegionScansCount: region count: count matrix: matrix
	"Invoke the GdipGetRegionScansCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScansCount(
			PGpRegion region,
			unsigned int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScansCount handle uint32* handle>
	^self invalidCall: _failureCode!

gdipGetRegionScansI: region rects: rects count: count matrix: matrix
	"Invoke the GdipGetRegionScansI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRegionScansI(
			PGpRegion region,
			Rect* rects,
			int* Count,
			PGpMatrix matrix);"

	<stdcall: errno GdipGetRegionScansI handle Rect* int32* handle>
	^self invalidCall: _failureCode!

gdipGetRenderingOrigin: graphics x: x y: y
	"Invoke the GdipGetRenderingOrigin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetRenderingOrigin(
			PGpGraphics graphics,
			int* x,
			int* y);"

	<stdcall: errno GdipGetRenderingOrigin handle int32* int32*>
	^self invalidCall: _failureCode!

gdipGetSmoothingMode: graphics smoothingMode: smoothingMode
	"Invoke the GdipGetSmoothingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetSmoothingMode(
			PGpGraphics graphics,
			SmoothingMode* SmoothingMode);"

	<stdcall: errno GdipGetSmoothingMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetSolidFillColor: brush color: color
	"Invoke the GdipGetSolidFillColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetSolidFillColor(
			[in]PGpSolidFill brush,
			[out, retval]ARGB* Color);"

	<stdcall: errno GdipGetSolidFillColor handle uint32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatAlign: format align: align
	"Invoke the GdipGetStringFormatAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatAlign(
			[in]PGpStringFormat format,
			StringAlignment* align);"

	<stdcall: errno GdipGetStringFormatAlign handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatDigitSubstitution: format language: language substitute: substitute
	"Invoke the GdipGetStringFormatDigitSubstitution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatDigitSubstitution(
			[in]PGpStringFormat format,
			LANGID* language,
			StringDigitSubstitute* substitute);"

	<stdcall: errno GdipGetStringFormatDigitSubstitution handle uint16* int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatFlags: format flags: flags
	"Invoke the GdipGetStringFormatFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatFlags(
			[in]PGpStringFormat format,
			int* Flags);"

	<stdcall: errno GdipGetStringFormatFlags handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	"Invoke the GdipGetStringFormatHotkeyPrefix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatHotkeyPrefix(
			[in]PGpStringFormat format,
			int* HotkeyPrefix);"

	<stdcall: errno GdipGetStringFormatHotkeyPrefix handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatLineAlign: format align: align
	"Invoke the GdipGetStringFormatLineAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatLineAlign(
			[in]PGpStringFormat format,
			StringAlignment* align);"

	<stdcall: errno GdipGetStringFormatLineAlign handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatMeasurableCharacterRangeCount: format count: count
	"Invoke the GdipGetStringFormatMeasurableCharacterRangeCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatMeasurableCharacterRangeCount(
			[in]PGpStringFormat format,
			int* Count);"

	<stdcall: errno GdipGetStringFormatMeasurableCharacterRangeCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTabStopCount: format count: count
	"Invoke the GdipGetStringFormatTabStopCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTabStopCount(
			[in]PGpStringFormat format,
			int* Count);"

	<stdcall: errno GdipGetStringFormatTabStopCount handle int32*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTabStops: format count: count firstTabOffset: firstTabOffset tabStops: tabStops
	"Invoke the GdipGetStringFormatTabStops() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTabStops(
			[in]PGpStringFormat format,
			int Count,
			REAL* firstTabOffset,
			REAL* tabStops);"

	<stdcall: errno GdipGetStringFormatTabStops handle int32 float* float*>
	^self invalidCall: _failureCode!

gdipGetStringFormatTrimming: format trimming: trimming
	"Invoke the GdipGetStringFormatTrimming() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetStringFormatTrimming(
			[in]PGpStringFormat format,
			StringTrimming* trimming);"

	<stdcall: errno GdipGetStringFormatTrimming handle int32*>
	^self invalidCall: _failureCode!

gdipGetTextContrast: graphics contrast: contrast
	"Invoke the GdipGetTextContrast() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextContrast(
			PGpGraphics graphics,
			unsigned int* contrast);"

	<stdcall: errno GdipGetTextContrast handle uint32*>
	^self invalidCall: _failureCode!

gdipGetTextRenderingHint: graphics mode: mode
	"Invoke the GdipGetTextRenderingHint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetTextRenderingHint(
			PGpGraphics graphics,
			TextRenderingHint* mode);"

	<stdcall: errno GdipGetTextRenderingHint handle int32*>
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

	<stdcall: errno GdipGetTextureWrapMode handle int32*>
	^self invalidCall: _failureCode!

gdipGetVisibleClipBounds: graphics rect: rect
	"Invoke the GdipGetVisibleClipBounds() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetVisibleClipBounds(
			PGpGraphics graphics,
			RectF* Rect);"

	<stdcall: errno GdipGetVisibleClipBounds handle RectF*>
	^self invalidCall: _failureCode!

gdipGetVisibleClipBoundsI: graphics rect: rect
	"Invoke the GdipGetVisibleClipBoundsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGetVisibleClipBoundsI(
			PGpGraphics graphics,
			Rect* Rect);"

	<stdcall: errno GdipGetVisibleClipBoundsI handle Rect*>
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

	<stdcall: errno GdipGraphicsClear handle uint32>
	^self invalidCall: _failureCode!

gdipGraphicsSetAbort: pGraphics pIAbort: pIAbort
	"Invoke the GdipGraphicsSetAbort() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipGraphicsSetAbort(
			PGpGraphics pGraphics,
			GdiplusAbort* pIAbort);"

	<stdcall: errno GdipGraphicsSetAbort handle void**>
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

	<stdcall: errno GdipImageGetFrameCount handle guid* uint32*>
	^self invalidCall: _failureCode!

gdipImageGetFrameDimensionsCount: image count: count
	"Invoke the GdipImageGetFrameDimensionsCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageGetFrameDimensionsCount(
			[in]PGpImage image,
			[out, retval]unsigned int* Count);"

	<stdcall: errno GdipImageGetFrameDimensionsCount handle uint32*>
	^self invalidCall: _failureCode!

gdipImageGetFrameDimensionsList: image dimensionIDs: dimensionIDs count: count
	"Invoke the GdipImageGetFrameDimensionsList() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageGetFrameDimensionsList(
			[in]PGpImage image,
			GUID* dimensionIDs,
			unsigned int Count);"

	<stdcall: errno GdipImageGetFrameDimensionsList handle guid* uint32>
	^self invalidCall: _failureCode!

gdipImageRotateFlip: image rfType: rfType
	"Invoke the GdipImageRotateFlip() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageRotateFlip(
			[in]PGpImage image,
			[in]RotateFlipType rfType);"

	<stdcall: errno GdipImageRotateFlip handle int32>
	^self invalidCall: _failureCode!

gdipImageSelectActiveFrame: image dimensionID: dimensionID frameIndex: frameIndex
	"Invoke the GdipImageSelectActiveFrame() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageSelectActiveFrame(
			[in]PGpImage image,
			[in]GUID* dimensionID,
			[in]unsigned int frameIndex);"

	<stdcall: errno GdipImageSelectActiveFrame handle guid* uint32>
	^self invalidCall: _failureCode!

gdipImageSetAbort: pImage pIAbort: pIAbort
	"Invoke the GdipImageSetAbort() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipImageSetAbort(
			PGpImage pImage,
			GdiplusAbort* pIAbort);"

	<stdcall: errno GdipImageSetAbort handle void**>
	^self invalidCall: _failureCode!

gdipInitializePalette: palette paletteType: paletteType optimalColors: optimalColors useTransparentColor: useTransparentColor bitmap: bitmap
	"Invoke the GdipInitializePalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipInitializePalette(
			[out]ColorPalette* palette,
			PaletteType PaletteType,
			int optimalColors,
			BOOL useTransparentColor,
			PGpBitmap bitmap);"

	<stdcall: errno GdipInitializePalette ColorPalette* int32 int32 bool handle>
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
			BOOL* result);"

	<stdcall: errno GdipIsClipEmpty handle bool*>
	^self invalidCall: _failureCode!

gdipIsEmptyRegion: region graphics: graphics result: result
	"Invoke the GdipIsEmptyRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsEmptyRegion(
			PGpRegion region,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsEmptyRegion handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsEqualRegion: region region2: region2 graphics: graphics result: result
	"Invoke the GdipIsEqualRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsEqualRegion(
			PGpRegion region,
			PGpRegion region2,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsEqualRegion handle handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsInfiniteRegion: region graphics: graphics result: result
	"Invoke the GdipIsInfiniteRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsInfiniteRegion(
			PGpRegion region,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsInfiniteRegion handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsMatrixEqual: matrix matrix2: matrix2 result: result
	"Invoke the GdipIsMatrixEqual() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixEqual(
			[in]PGpMatrix matrix,
			[in]PGpMatrix matrix2,
			BOOL* result);"

	<stdcall: errno GdipIsMatrixEqual handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsMatrixIdentity: matrix result: result
	"Invoke the GdipIsMatrixIdentity() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixIdentity(
			[in]PGpMatrix matrix,
			BOOL* result);"

	<stdcall: errno GdipIsMatrixIdentity handle bool*>
	^self invalidCall: _failureCode!

gdipIsMatrixInvertible: matrix result: result
	"Invoke the GdipIsMatrixInvertible() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsMatrixInvertible(
			[in]PGpMatrix matrix,
			BOOL* result);"

	<stdcall: errno GdipIsMatrixInvertible handle bool*>
	^self invalidCall: _failureCode!

gdipIsOutlineVisiblePathPoint: path x: x y: y pen: pen graphics: graphics result: result
	"Invoke the GdipIsOutlineVisiblePathPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsOutlineVisiblePathPoint(
			PGpPath path,
			REAL x,
			REAL y,
			PGpPen pen,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsOutlineVisiblePathPoint handle float float handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsOutlineVisiblePathPointI: path x: x y: y pen: pen graphics: graphics result: result
	"Invoke the GdipIsOutlineVisiblePathPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsOutlineVisiblePathPointI(
			PGpPath path,
			int x,
			int y,
			PGpPen pen,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsOutlineVisiblePathPointI handle int32 int32 handle handle bool*>
	^self invalidCall: _failureCode!

gdipIsStyleAvailable: family style: style isStyleAvailable: isStyleAvailable
	"Invoke the GdipIsStyleAvailable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsStyleAvailable(
			[in]PGpFontFamily family,
			int style,
			[out, retval]BOOL* IsStyleAvailable);"

	<stdcall: errno GdipIsStyleAvailable handle int32 bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleClipEmpty: graphics result: result
	"Invoke the GdipIsVisibleClipEmpty() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleClipEmpty(
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleClipEmpty handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisiblePathPoint: path x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisiblePathPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePathPoint(
			PGpPath path,
			REAL x,
			REAL y,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisiblePathPoint handle float float handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisiblePathPointI: path x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisiblePathPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePathPointI(
			PGpPath path,
			int x,
			int y,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisiblePathPointI handle int32 int32 handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisiblePoint: graphics x: x y: y result: result
	"Invoke the GdipIsVisiblePoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePoint(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			BOOL* result);"

	<stdcall: errno GdipIsVisiblePoint handle float float bool*>
	^self invalidCall: _failureCode!

gdipIsVisiblePointI: graphics x: x y: y result: result
	"Invoke the GdipIsVisiblePointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisiblePointI(
			PGpGraphics graphics,
			int x,
			int y,
			BOOL* result);"

	<stdcall: errno GdipIsVisiblePointI handle int32 int32 bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRect: graphics x: x y: y width: width height: height result: result
	"Invoke the GdipIsVisibleRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRect(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRect handle float float float float bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRectI: graphics x: x y: y width: width height: height result: result
	"Invoke the GdipIsVisibleRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRectI(
			PGpGraphics graphics,
			int x,
			int y,
			int width,
			int height,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRectI handle int32 int32 int32 int32 bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionPoint: region x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionPoint(
			PGpRegion region,
			REAL x,
			REAL y,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRegionPoint handle float float handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionPointI: region x: x y: y graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionPointI(
			PGpRegion region,
			int x,
			int y,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRegionPointI handle int32 int32 handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionRect: region x: x y: y width: width height: height graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionRect(
			PGpRegion region,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRegionRect handle float float float float handle bool*>
	^self invalidCall: _failureCode!

gdipIsVisibleRegionRectI: region x: x y: y width: width height: height graphics: graphics result: result
	"Invoke the GdipIsVisibleRegionRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipIsVisibleRegionRectI(
			PGpRegion region,
			int x,
			int y,
			int width,
			int height,
			PGpGraphics graphics,
			BOOL* result);"

	<stdcall: errno GdipIsVisibleRegionRectI handle int32 int32 int32 int32 handle bool*>
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

	<stdcall: errno GdipLoadImageFromStream OS.COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdipLoadImageFromStreamICM: stream image: image
	"Invoke the GdipLoadImageFromStreamICM() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipLoadImageFromStreamICM(
			[in]IStream* stream,
			[out, retval]PGpImage* image);"

	<stdcall: errno GdipLoadImageFromStreamICM OS.COM.IStream* handle*>
	^self invalidCall: _failureCode!

gdiplusNotificationHook: token1
	"Invoke the GdiplusNotificationHook() function of the module wrapped by the receiver.

		GpStatus __stdcall GdiplusNotificationHook(
			unsigned long* token);"

	<stdcall: errno GdiplusNotificationHook uint32*>
	^self invalidCall: _failureCode!

gdiplusNotificationUnhook: token1
	"Invoke the GdiplusNotificationUnhook() function of the module wrapped by the receiver.

		void __stdcall GdiplusNotificationUnhook(
			unsigned long token);"

	<stdcall: void GdiplusNotificationUnhook uint32>
	^self invalidCall: _failureCode!

gdiplusShutdown: token1
	"Invoke the GdiplusShutdown() function of the module wrapped by the receiver.

		void __stdcall GdiplusShutdown(
			[in]unsigned long token);"

	<stdcall: void GdiplusStartup uint32>
	^self invalidCall: _failureCode!

gdiplusStartup: token1 input: input output: output
	"Invoke the GdiplusStartup() function of the module wrapped by the receiver.

		GpStatus __stdcall GdiplusStartup(
			[out]unsigned long* token,
			[in]GdiplusStartupInput* input,
			[out]GdiplusStartupOutput* output);"

	<stdcall: errno GdiplusStartup uint32* GdiplusStartupInput* GdiplusStartupOutput*>
	^self invalidCall: _failureCode!

gdipMeasureCharacterRanges: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat regionCount: regionCount regions: regions
	"Invoke the GdipMeasureCharacterRanges() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMeasureCharacterRanges(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RectF* layoutRect,
			[in]PGpStringFormat stringFormat,
			int regionCount,
			[out, retval]PGpRegion* regions);"

	<stdcall: errno GdipMeasureCharacterRanges handle lpwstr int32 handle RectF* handle int32 handle*>
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
			RectF* BoundingBox);"

	<stdcall: errno GdipMeasureDriverString handle uint16* int32 handle POINTF* int32 handle RectF*>
	^self invalidCall: _failureCode!

gdipMeasureString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat boundingBox: boundingBox codepointsFitted: codepointsFitted linesFilled: linesFilled
	"Invoke the GdipMeasureString() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMeasureString(
			PGpGraphics graphics,
			[in]LPWSTR str,
			int length,
			[in]PGpFont font,
			[in]RectF* layoutRect,
			[in]PGpStringFormat stringFormat,
			RectF* BoundingBox,
			int* codepointsFitted,
			int* linesFilled);"

	<stdcall: errno GdipMeasureString handle lpwstr int32 handle RectF* handle RectF* int32* int32*>
	^self invalidCall: _failureCode!

gdipMultiplyLineTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyLineTransform(
			PGpLineGradient brush,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyLineTransform handle handle int32>
	^self invalidCall: _failureCode!

gdipMultiplyMatrix: matrix matrix2: matrix2 order: order
	"Invoke the GdipMultiplyMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyMatrix(
			PGpMatrix matrix,
			PGpMatrix matrix2,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyMatrix handle handle int32>
	^self invalidCall: _failureCode!

gdipMultiplyPathGradientTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyPathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyPathGradientTransform(
			PGpPathGradient brush,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyPathGradientTransform handle handle int32>
	^self invalidCall: _failureCode!

gdipMultiplyPenTransform: pen matrix: matrix order: order
	"Invoke the GdipMultiplyPenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyPenTransform(
			PGpPen pen,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyPenTransform handle handle int32>
	^self invalidCall: _failureCode!

gdipMultiplyTextureTransform: brush matrix: matrix order: order
	"Invoke the GdipMultiplyTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyTextureTransform(
			[in]PGpTexture brush,
			[in]PGpMatrix matrix,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyTextureTransform handle handle int32>
	^self invalidCall: _failureCode!

gdipMultiplyWorldTransform: graphics matrix: matrix order: order
	"Invoke the GdipMultiplyWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipMultiplyWorldTransform(
			PGpGraphics graphics,
			[in]PGpMatrix matrix,
			GpMatrixOrder order);"

	<stdcall: errno GdipMultiplyWorldTransform handle handle int32>
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
			POINTF* Points,
			BYTE* Types,
			int startIndex,
			int endIndex);"

	<stdcall: errno GdipPathIterCopyData handle int32* POINTF* uint8* int32 int32>
	^self invalidCall: _failureCode!

gdipPathIterEnumerate: iterator resultCount: resultCount points: points types: types count: count
	"Invoke the GdipPathIterEnumerate() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterEnumerate(
			PGpPathIterator iterator,
			int* resultCount,
			POINTF* Points,
			BYTE* Types,
			int Count);"

	<stdcall: errno GdipPathIterEnumerate handle int32* POINTF* uint8* int32>
	^self invalidCall: _failureCode!

gdipPathIterGetCount: iterator count: count
	"Invoke the GdipPathIterGetCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterGetCount(
			PGpPathIterator iterator,
			int* Count);"

	<stdcall: errno GdipPathIterGetCount handle int32*>
	^self invalidCall: _failureCode!

gdipPathIterGetSubpathCount: iterator count: count
	"Invoke the GdipPathIterGetSubpathCount() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterGetSubpathCount(
			PGpPathIterator iterator,
			int* Count);"

	<stdcall: errno GdipPathIterGetSubpathCount handle int32*>
	^self invalidCall: _failureCode!

gdipPathIterHasCurve: iterator hasCurve: hasCurve
	"Invoke the GdipPathIterHasCurve() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterHasCurve(
			PGpPathIterator iterator,
			BOOL* hasCurve);"

	<stdcall: errno GdipPathIterHasCurve handle bool*>
	^self invalidCall: _failureCode!

gdipPathIterIsValid: iterator valid: valid
	"Invoke the GdipPathIterIsValid() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterIsValid(
			PGpPathIterator iterator,
			BOOL* valid);"

	<stdcall: errno GdipPathIterIsValid handle bool*>
	^self invalidCall: _failureCode!

gdipPathIterNextMarker: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex
	"Invoke the GdipPathIterNextMarker() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextMarker(
			PGpPathIterator iterator,
			int* resultCount,
			int* startIndex,
			int* endIndex);"

	<stdcall: errno GdipPathIterNextMarker handle int32* int32* int32*>
	^self invalidCall: _failureCode!

gdipPathIterNextMarkerPath: iterator resultCount: resultCount path: path
	"Invoke the GdipPathIterNextMarkerPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextMarkerPath(
			PGpPathIterator iterator,
			int* resultCount,
			PGpPath path);"

	<stdcall: errno GdipPathIterNextMarkerPath handle int32* handle>
	^self invalidCall: _failureCode!

gdipPathIterNextPathType: iterator resultCount: resultCount pathType: pathType startIndex: startIndex endIndex: endIndex
	"Invoke the GdipPathIterNextPathType() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextPathType(
			PGpPathIterator iterator,
			int* resultCount,
			BYTE* pathType,
			int* startIndex,
			int* endIndex);"

	<stdcall: errno GdipPathIterNextPathType handle int32* uint8* int32* int32*>
	^self invalidCall: _failureCode!

gdipPathIterNextSubpath: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex isClosed: isClosed
	"Invoke the GdipPathIterNextSubpath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextSubpath(
			PGpPathIterator iterator,
			int* resultCount,
			int* startIndex,
			int* endIndex,
			BOOL* isClosed);"

	<stdcall: errno GdipPathIterNextSubpath handle int32* int32* int32* bool*>
	^self invalidCall: _failureCode!

gdipPathIterNextSubpathPath: iterator resultCount: resultCount path: path isClosed: isClosed
	"Invoke the GdipPathIterNextSubpathPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipPathIterNextSubpathPath(
			PGpPathIterator iterator,
			int* resultCount,
			PGpPath path,
			BOOL* isClosed);"

	<stdcall: errno GdipPathIterNextSubpathPath handle int32* handle bool*>
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
			unsigned int DataSize,
			[in]BYTE* Data);"

	<stdcall: errno GdipPlayMetafileRecord handle int32 uint32 uint32 uint8*>
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

	<stdcall: errno GdipPrivateAddMemoryFont handle void* int32>
	^self invalidCall: _failureCode!

gdipRecordMetafile: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafile(
			HDC referenceHdc,
			EmfType Type,
			[in]RectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafile handle int32 RectF* int32 lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileFileName: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileFileName() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileFileName(
			[in]LPWSTR filename,
			HDC referenceHdc,
			EmfType Type,
			[in]RectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileFileName lpwstr handle int32 RectF* int32 lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileFileNameI: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileFileNameI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileFileNameI(
			[in]LPWSTR filename,
			HDC referenceHdc,
			EmfType Type,
			[in]Rect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileFileNameI lpwstr handle int32 Rect* int32 lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileI: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileI(
			HDC referenceHdc,
			EmfType Type,
			[in]Rect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileI handle int32 Rect* int32 lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileStream: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileStream(
			IStream* stream,
			HDC referenceHdc,
			EmfType Type,
			[in]RectF* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileStream OS.COM.IStream* handle int32 RectF* int32 lpwstr handle*>
	^self invalidCall: _failureCode!

gdipRecordMetafileStreamI: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	"Invoke the GdipRecordMetafileStreamI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRecordMetafileStreamI(
			IStream* stream,
			HDC referenceHdc,
			EmfType Type,
			[in]Rect* frameRect,
			MetafileFrameUnit frameUnit,
			[in]LPWSTR description,
			[out, retval]PGpMetafile* metafile);"

	<stdcall: errno GdipRecordMetafileStreamI OS.COM.IStream* handle int32 Rect* int32 lpwstr handle*>
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

	<stdcall: errno GdipRemovePropertyItem handle uint32>
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

	<stdcall: errno GdipResetImageAttributes handle int32>
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

	<stdcall: errno GdipRestoreGraphics handle uint32>
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

	<stdcall: errno GdipRotateLineTransform handle float int32>
	^self invalidCall: _failureCode!

gdipRotateMatrix: matrix angle: angle order: order
	"Invoke the GdipRotateMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateMatrix(
			PGpMatrix matrix,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotateMatrix handle float int32>
	^self invalidCall: _failureCode!

gdipRotatePathGradientTransform: brush angle: angle order: order
	"Invoke the GdipRotatePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotatePathGradientTransform(
			PGpPathGradient brush,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotatePathGradientTransform handle float int32>
	^self invalidCall: _failureCode!

gdipRotatePenTransform: pen angle: angle order: order
	"Invoke the GdipRotatePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotatePenTransform(
			PGpPen pen,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotatePenTransform handle float int32>
	^self invalidCall: _failureCode!

gdipRotateTextureTransform: brush angle: angle order: order
	"Invoke the GdipRotateTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateTextureTransform(
			[in]PGpTexture brush,
			[in]REAL angle,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipRotateTextureTransform handle float int32>
	^self invalidCall: _failureCode!

gdipRotateWorldTransform: graphics angle: angle order: order
	"Invoke the GdipRotateWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipRotateWorldTransform(
			PGpGraphics graphics,
			REAL angle,
			GpMatrixOrder order);"

	<stdcall: errno GdipRotateWorldTransform handle float int32>
	^self invalidCall: _failureCode!

gdipSaveAdd: image encoderParams: encoderParams
	"Invoke the GdipSaveAdd() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveAdd(
			[in]PGpImage image,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveAdd handle EncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveAddImage: image newImage: newImage encoderParams: encoderParams
	"Invoke the GdipSaveAddImage() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveAddImage(
			[in]PGpImage image,
			[in]PGpImage newImage,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveAddImage handle handle EncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveGraphics: graphics state: state
	"Invoke the GdipSaveGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveGraphics(
			PGpGraphics graphics,
			GraphicsState* state);"

	<stdcall: errno GdipSaveGraphics handle uint32*>
	^self invalidCall: _failureCode!

gdipSaveImageToFile: image filename: filename clsidEncoder: clsidEncoder encoderParams: encoderParams
	"Invoke the GdipSaveImageToFile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveImageToFile(
			[in]PGpImage image,
			[in]LPWSTR filename,
			[in]GUID* clsidEncoder,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveImageToFile handle lpwstr guid* EncoderParameters*>
	^self invalidCall: _failureCode!

gdipSaveImageToStream: image stream: stream clsidEncoder: clsidEncoder encoderParams: encoderParams
	"Invoke the GdipSaveImageToStream() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSaveImageToStream(
			[in]PGpImage image,
			[in]IStream* stream,
			[in]GUID* clsidEncoder,
			[in]EncoderParameters* encoderParams);"

	<stdcall: errno GdipSaveImageToStream handle COM.IStream* guid* EncoderParameters*>
	^self invalidCall: _failureCode!

gdipScaleLineTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScaleLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleLineTransform(
			PGpLineGradient brush,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleLineTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipScaleMatrix: matrix scaleX: scaleX scaleY: scaleY order: order
	"Invoke the GdipScaleMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleMatrix(
			PGpMatrix matrix,
			REAL scaleX,
			REAL scaleY,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleMatrix handle float float int32>
	^self invalidCall: _failureCode!

gdipScalePathGradientTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScalePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScalePathGradientTransform(
			PGpPathGradient brush,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScalePathGradientTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipScalePenTransform: pen sx: sx sy: sy order: order
	"Invoke the GdipScalePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScalePenTransform(
			PGpPen pen,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScalePenTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipScaleTextureTransform: brush sx: sx sy: sy order: order
	"Invoke the GdipScaleTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleTextureTransform(
			[in]PGpTexture brush,
			[in]REAL sx,
			[in]REAL sy,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipScaleTextureTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipScaleWorldTransform: graphics sx: sx sy: sy order: order
	"Invoke the GdipScaleWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipScaleWorldTransform(
			PGpGraphics graphics,
			REAL sx,
			REAL sy,
			GpMatrixOrder order);"

	<stdcall: errno GdipScaleWorldTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapFillState: cap fillState: fillState
	"Invoke the GdipSetAdjustableArrowCapFillState() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapFillState(
			PGpAdjustableArrowCap cap,
			BOOL fillState);"

	<stdcall: errno GdipSetAdjustableArrowCapFillState handle bool>
	^self invalidCall: _failureCode!

gdipSetAdjustableArrowCapHeight: cap height: height
	"Invoke the GdipSetAdjustableArrowCapHeight() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetAdjustableArrowCapHeight(
			PGpAdjustableArrowCap cap,
			REAL height);"

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
			REAL width);"

	<stdcall: errno GdipSetAdjustableArrowCapWidth handle float>
	^self invalidCall: _failureCode!

gdipSetClipGraphics: graphics srcgraphics: srcgraphics combineMode: combineMode
	"Invoke the GdipSetClipGraphics() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipGraphics(
			PGpGraphics graphics,
			PGpGraphics srcgraphics,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipGraphics handle handle int32>
	^self invalidCall: _failureCode!

gdipSetClipHrgn: graphics hRgn: hRgn combineMode: combineMode
	"Invoke the GdipSetClipHrgn() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipHrgn(
			PGpGraphics graphics,
			wireHRGN hRgn,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipHrgn handle handle int32>
	^self invalidCall: _failureCode!

gdipSetClipPath: graphics path: path combineMode: combineMode
	"Invoke the GdipSetClipPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipPath(
			PGpGraphics graphics,
			PGpPath path,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipPath handle handle int32>
	^self invalidCall: _failureCode!

gdipSetClipRect: graphics x: x y: y width: width height: height combineMode: combineMode
	"Invoke the GdipSetClipRect() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRect(
			PGpGraphics graphics,
			REAL x,
			REAL y,
			REAL width,
			REAL height,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRect handle float float float float int32>
	^self invalidCall: _failureCode!

gdipSetClipRectI: graphics x: x y: y width: width height: height combineMode: combineMode
	"Invoke the GdipSetClipRectI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRectI(
			PGpGraphics graphics,
			int x,
			int y,
			int width,
			int height,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRectI handle int32 int32 int32 int32 int32>
	^self invalidCall: _failureCode!

gdipSetClipRegion: graphics region: region combineMode: combineMode
	"Invoke the GdipSetClipRegion() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetClipRegion(
			PGpGraphics graphics,
			PGpRegion region,
			CombineMode CombineMode);"

	<stdcall: errno GdipSetClipRegion handle handle int32>
	^self invalidCall: _failureCode!

gdipSetCompositingMode: graphics compositingMode: compositingMode
	"Invoke the GdipSetCompositingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCompositingMode(
			PGpGraphics graphics,
			CompositingMode CompositingMode);"

	<stdcall: errno GdipSetCompositingMode handle int32>
	^self invalidCall: _failureCode!

gdipSetCompositingQuality: graphics compositingQuality: compositingQuality
	"Invoke the GdipSetCompositingQuality() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCompositingQuality(
			PGpGraphics graphics,
			CompositingQuality CompositingQuality);"

	<stdcall: errno GdipSetCompositingQuality handle int32>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapBaseCap: customCap baseCap: baseCap
	"Invoke the GdipSetCustomLineCapBaseCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapBaseCap(
			PGpCustomLineCap customCap,
			GpLineCap baseCap);"

	<stdcall: errno GdipSetCustomLineCapBaseCap handle int32>
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

	<stdcall: errno GdipSetCustomLineCapStrokeCaps handle int32 int32>
	^self invalidCall: _failureCode!

gdipSetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	"Invoke the GdipSetCustomLineCapStrokeJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetCustomLineCapStrokeJoin(
			PGpCustomLineCap customCap,
			GpLineJoin LineJoin);"

	<stdcall: errno GdipSetCustomLineCapStrokeJoin handle int32>
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
			BOOL enableFlag);"

	<stdcall: errno GdipSetImageAttributesCachedBackground handle bool>
	^self invalidCall: _failureCode!

gdipSetImageAttributesColorKeys: imageattr type: type enableFlag: enableFlag colorLow: colorLow colorHigh: colorHigh
	"Invoke the GdipSetImageAttributesColorKeys() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesColorKeys(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			ARGB colorLow,
			ARGB colorHigh);"

	<stdcall: errno GdipSetImageAttributesColorKeys handle int32 bool uint32 uint32>
	^self invalidCall: _failureCode!

gdipSetImageAttributesColorMatrix: imageattr type: type enableFlag: enableFlag colorMatrix: colorMatrix grayMatrix: grayMatrix flags: flags
	"Invoke the GdipSetImageAttributesColorMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesColorMatrix(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			[in]ColorMatrix* ColorMatrix,
			[in]ColorMatrix* grayMatrix,
			ColorMatrixFlags Flags);"

	<stdcall: errno GdipSetImageAttributesColorMatrix handle int32 bool ColorMatrix* ColorMatrix* int32>
	^self invalidCall: _failureCode!

gdipSetImageAttributesGamma: imageattr type: type enableFlag: enableFlag gamma: gamma
	"Invoke the GdipSetImageAttributesGamma() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesGamma(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			REAL gamma);"

	<stdcall: errno GdipSetImageAttributesGamma handle int32 bool float>
	^self invalidCall: _failureCode!

gdipSetImageAttributesICMMode: imageattr on: on
	"Invoke the GdipSetImageAttributesICMMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesICMMode(
			PGpImageAttributes imageattr,
			BOOL on);"

	<stdcall: errno GdipSetImageAttributesICMMode handle bool>
	^self invalidCall: _failureCode!

gdipSetImageAttributesNoOp: imageattr type: type enableFlag: enableFlag
	"Invoke the GdipSetImageAttributesNoOp() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesNoOp(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag);"

	<stdcall: errno GdipSetImageAttributesNoOp handle int32 bool>
	^self invalidCall: _failureCode!

gdipSetImageAttributesOutputChannel: imageattr type: type enableFlag: enableFlag channelFlags: channelFlags
	"Invoke the GdipSetImageAttributesOutputChannel() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesOutputChannel(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			ColorChannelFlags channelFlags);"

	<stdcall: errno GdipSetImageAttributesOutputChannel handle int32 bool int32>
	^self invalidCall: _failureCode!

gdipSetImageAttributesOutputChannelColorProfile: imageattr type: type enableFlag: enableFlag colorProfileFilename: colorProfileFilename
	"Invoke the GdipSetImageAttributesOutputChannelColorProfile() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesOutputChannelColorProfile(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			[in]LPWSTR colorProfileFilename);"

	<stdcall: errno GdipSetImageAttributesOutputChannelColorProfile handle int32 bool lpwstr>
	^self invalidCall: _failureCode!

gdipSetImageAttributesRemapTable: imageattr type: type enableFlag: enableFlag mapSize: mapSize map: map
	"Invoke the GdipSetImageAttributesRemapTable() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesRemapTable(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			unsigned int mapSize,
			[in]ColorMap* map);"

	<stdcall: errno GdipSetImageAttributesRemapTable handle int32 bool uint32 ColorMap*>
	^self invalidCall: _failureCode!

gdipSetImageAttributesThreshold: imageattr type: type enableFlag: enableFlag threshold: threshold
	"Invoke the GdipSetImageAttributesThreshold() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesThreshold(
			PGpImageAttributes imageattr,
			ColorAdjustType Type,
			BOOL enableFlag,
			REAL threshold);"

	<stdcall: errno GdipSetImageAttributesThreshold handle int32 bool float>
	^self invalidCall: _failureCode!

gdipSetImageAttributesToIdentity: imageattr type: type
	"Invoke the GdipSetImageAttributesToIdentity() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesToIdentity(
			PGpImageAttributes imageattr,
			ColorAdjustType Type);"

	<stdcall: errno GdipSetImageAttributesToIdentity handle int32>
	^self invalidCall: _failureCode!

gdipSetImageAttributesWrapMode: imageattr wrap: wrap argb: argb clamp: clamp
	"Invoke the GdipSetImageAttributesWrapMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImageAttributesWrapMode(
			PGpImageAttributes imageattr,
			WrapMode wrap,
			ARGB ARGB,
			BOOL clamp);"

	<stdcall: errno GdipSetImageAttributesWrapMode handle int32 uint32 bool>
	^self invalidCall: _failureCode!

gdipSetImagePalette: image palette: palette
	"Invoke the GdipSetImagePalette() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetImagePalette(
			[in]PGpImage image,
			[in]ColorPalette* palette);"

	<stdcall: errno GdipSetImagePalette handle ColorPalette*>
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

	<stdcall: errno GdipSetInterpolationMode handle int32>
	^self invalidCall: _failureCode!

gdipSetLineBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetLineBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineBlend(
			PGpLineGradient brush,
			[in]REAL* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetLineBlend handle float* float* int32>
	^self invalidCall: _failureCode!

gdipSetLineColors: brush color1: color1 color2: color2
	"Invoke the GdipSetLineColors() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineColors(
			PGpLineGradient brush,
			ARGB color1,
			ARGB color2);"

	<stdcall: errno GdipSetLineColors handle uint32 uint32>
	^self invalidCall: _failureCode!

gdipSetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	"Invoke the GdipSetLineGammaCorrection() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetLineGammaCorrection(
			PGpLineGradient brush,
			BOOL useGammaCorrection);"

	<stdcall: errno GdipSetLineGammaCorrection handle bool>
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

	<stdcall: errno GdipSetLinePresetBlend handle uint32* float* int32>
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

	<stdcall: errno GdipSetLineWrapMode handle int32>
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

	<stdcall: errno GdipSetMetafileDownLevelRasterizationLimit handle uint32>
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

	<stdcall: errno GdipSetPageUnit handle int32>
	^self invalidCall: _failureCode!

gdipSetPathFillMode: path fillMode: fillMode
	"Invoke the GdipSetPathFillMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathFillMode(
			PGpPath path,
			GpFillMode FillMode);"

	<stdcall: errno GdipSetPathFillMode handle int32>
	^self invalidCall: _failureCode!

gdipSetPathGradientBlend: brush blend: blend positions: positions count: count
	"Invoke the GdipSetPathGradientBlend() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientBlend(
			PGpPathGradient brush,
			[in]REAL* blend,
			[in]REAL* positions,
			int Count);"

	<stdcall: errno GdipSetPathGradientBlend handle float* float* int32>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterColor: brush colors: colors
	"Invoke the GdipSetPathGradientCenterColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterColor(
			PGpPathGradient brush,
			ARGB colors);"

	<stdcall: errno GdipSetPathGradientCenterColor handle uint32>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterPoint: brush points: points
	"Invoke the GdipSetPathGradientCenterPoint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterPoint(
			PGpPathGradient brush,
			[in]POINTF* Points);"

	<stdcall: errno GdipSetPathGradientCenterPoint handle POINTF*>
	^self invalidCall: _failureCode!

gdipSetPathGradientCenterPointI: brush points: points
	"Invoke the GdipSetPathGradientCenterPointI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPathGradientCenterPointI(
			PGpPathGradient brush,
			[in]POINTL* Points);"

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
			BOOL useGammaCorrection);"

	<stdcall: errno GdipSetPathGradientGammaCorrection handle bool>
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

	<stdcall: errno GdipSetPathGradientPresetBlend handle uint32* float* int32>
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

	<stdcall: errno GdipSetPathGradientSurroundColorsWithCount handle uint32* int32*>
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

	<stdcall: errno GdipSetPathGradientWrapMode handle int32>
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

	<stdcall: errno GdipSetPenColor handle uint32>
	^self invalidCall: _failureCode!

gdipSetPenCompoundArray: pen dash: dash count: count
	"Invoke the GdipSetPenCompoundArray() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenCompoundArray(
			PGpPen pen,
			[in]REAL* dash,
			int Count);"

	<stdcall: errno GdipSetPenCompoundArray handle float* int32>
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

	<stdcall: errno GdipSetPenDashArray handle float* int32>
	^self invalidCall: _failureCode!

gdipSetPenDashArray: aHandle dashes: aCollectionOfNumbers
	self
		gdipSetPenDashArray: aHandle
		dash: (FLOATArray marshal: aCollectionOfNumbers)
		count: aCollectionOfNumbers size!

gdipSetPenDashCap197819: pen dashCap: dashCap
	"Invoke the GdipSetPenDashCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashCap197819(
			PGpPen pen,
			GpDashCap DashCap);"

	<stdcall: errno GdipSetPenDashCap197819 handle int32>
	^self invalidCall: _failureCode!

gdipSetPenDashOffset: pen offset: offset
	"Invoke the GdipSetPenDashOffset() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashOffset(
			PGpPen pen,
			REAL Offset);"

	<stdcall: errno GdipSetPenDashOffset handle float>
	^self invalidCall: _failureCode!

gdipSetPenDashStyle: pen dashStyle: dashStyle
	"Invoke the GdipSetPenDashStyle() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenDashStyle(
			PGpPen pen,
			GpDashStyle DashStyle);"

	<stdcall: errno GdipSetPenDashStyle handle int32>
	^self invalidCall: _failureCode!

gdipSetPenEndCap: pen endCap: endCap
	"Invoke the GdipSetPenEndCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenEndCap(
			PGpPen pen,
			GpLineCap endCap);"

	<stdcall: errno GdipSetPenEndCap handle int32>
	^self invalidCall: _failureCode!

gdipSetPenLineCap197819: pen startCap: startCap endCap: endCap dashCap: dashCap
	"Invoke the GdipSetPenLineCap197819() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenLineCap197819(
			PGpPen pen,
			GpLineCap startCap,
			GpLineCap endCap,
			GpDashCap DashCap);"

	<stdcall: errno GdipSetPenLineCap197819 handle int32 int32 int32>
	^self invalidCall: _failureCode!

gdipSetPenLineJoin: pen lineJoin: lineJoin
	"Invoke the GdipSetPenLineJoin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenLineJoin(
			PGpPen pen,
			GpLineJoin LineJoin);"

	<stdcall: errno GdipSetPenLineJoin handle int32>
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

	<stdcall: errno GdipSetPenMode handle int32>
	^self invalidCall: _failureCode!

gdipSetPenStartCap: pen startCap: startCap
	"Invoke the GdipSetPenStartCap() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenStartCap(
			PGpPen pen,
			GpLineCap startCap);"

	<stdcall: errno GdipSetPenStartCap handle int32>
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

	<stdcall: errno GdipSetPenUnit handle int32>
	^self invalidCall: _failureCode!

gdipSetPenWidth: pen width: width
	"Invoke the GdipSetPenWidth() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPenWidth(
			PGpPen pen,
			REAL width);"

	<stdcall: errno GdipSetPenWidth handle float>
	^self invalidCall: _failureCode!

gdipSetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	"Invoke the GdipSetPixelOffsetMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPixelOffsetMode(
			PGpGraphics graphics,
			PixelOffsetMode PixelOffsetMode);"

	<stdcall: errno GdipSetPixelOffsetMode handle int32>
	^self invalidCall: _failureCode!

gdipSetPropertyItem: image item: item
	"Invoke the GdipSetPropertyItem() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetPropertyItem(
			[in]PGpImage image,
			[in]PropertyItem* item);"

	<stdcall: errno GdipSetPropertyItem handle PropertyItem*>
	^self invalidCall: _failureCode!

gdipSetRenderingOrigin: graphics x: x y: y
	"Invoke the GdipSetRenderingOrigin() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetRenderingOrigin(
			PGpGraphics graphics,
			int x,
			int y);"

	<stdcall: errno GdipSetRenderingOrigin handle int32 int32>
	^self invalidCall: _failureCode!

gdipSetSmoothingMode: graphics smoothingMode: smoothingMode
	"Invoke the GdipSetSmoothingMode() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetSmoothingMode(
			PGpGraphics graphics,
			SmoothingMode SmoothingMode);"

	<stdcall: errno GdipSetSmoothingMode handle int32>
	^self invalidCall: _failureCode!

gdipSetSolidFillColor: brush color: color
	"Invoke the GdipSetSolidFillColor() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetSolidFillColor(
			[in]PGpSolidFill brush,
			[in]ARGB Color);"

	<stdcall: errno GdipSetSolidFillColor handle uint32>
	^self invalidCall: _failureCode!

gdipSetStringFormatAlign: format align: align
	"Invoke the GdipSetStringFormatAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatAlign(
			PGpStringFormat format,
			StringAlignment align);"

	<stdcall: errno GdipSetStringFormatAlign handle int32>
	^self invalidCall: _failureCode!

gdipSetStringFormatDigitSubstitution: format language: language substitute: substitute
	"Invoke the GdipSetStringFormatDigitSubstitution() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatDigitSubstitution(
			PGpStringFormat format,
			LANGID language,
			StringDigitSubstitute substitute);"

	<stdcall: errno GdipSetStringFormatDigitSubstitution handle uint16 int32>
	^self invalidCall: _failureCode!

gdipSetStringFormatFlags: format flags: flags
	"Invoke the GdipSetStringFormatFlags() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatFlags(
			PGpStringFormat format,
			int Flags);"

	<stdcall: errno GdipSetStringFormatFlags handle int32>
	^self invalidCall: _failureCode!

gdipSetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	"Invoke the GdipSetStringFormatHotkeyPrefix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatHotkeyPrefix(
			PGpStringFormat format,
			int HotkeyPrefix);"

	<stdcall: errno GdipSetStringFormatHotkeyPrefix handle int32>
	^self invalidCall: _failureCode!

gdipSetStringFormatLineAlign: format align: align
	"Invoke the GdipSetStringFormatLineAlign() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatLineAlign(
			PGpStringFormat format,
			StringAlignment align);"

	<stdcall: errno GdipSetStringFormatLineAlign handle int32>
	^self invalidCall: _failureCode!

gdipSetStringFormatMeasurableCharacterRanges: format rangeCount: rangeCount ranges: ranges
	"Invoke the GdipSetStringFormatMeasurableCharacterRanges() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatMeasurableCharacterRanges(
			PGpStringFormat format,
			int rangeCount,
			[in]CharacterRange* ranges);"

	<stdcall: errno GdipSetStringFormatMeasurableCharacterRanges handle int32 CharacterRange*>
	^self invalidCall: _failureCode!

gdipSetStringFormatTabStops: format firstTabOffset: firstTabOffset count: count tabStops: tabStops
	"Invoke the GdipSetStringFormatTabStops() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatTabStops(
			PGpStringFormat format,
			REAL firstTabOffset,
			int Count,
			[in]REAL* tabStops);"

	<stdcall: errno GdipSetStringFormatTabStops handle float int32 float*>
	^self invalidCall: _failureCode!

gdipSetStringFormatTrimming: format trimming: trimming
	"Invoke the GdipSetStringFormatTrimming() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetStringFormatTrimming(
			PGpStringFormat format,
			StringTrimming trimming);"

	<stdcall: errno GdipSetStringFormatTrimming handle int32>
	^self invalidCall: _failureCode!

gdipSetTextContrast: graphics contrast: contrast
	"Invoke the GdipSetTextContrast() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextContrast(
			PGpGraphics graphics,
			unsigned int contrast);"

	<stdcall: errno GdipSetTextContrast handle uint32>
	^self invalidCall: _failureCode!

gdipSetTextRenderingHint: graphics mode: mode
	"Invoke the GdipSetTextRenderingHint() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipSetTextRenderingHint(
			PGpGraphics graphics,
			TextRenderingHint mode);"

	<stdcall: errno GdipSetTextRenderingHint handle int32>
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

	<stdcall: errno GdipSetTextureWrapMode handle int32>
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

	<stdcall: errno GdipShearMatrix handle float float int32>
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
			void* param);"

	<stdcall: errno GdipTestControl int32 void*>
	^self invalidCall: _failureCode!

gdipTransformMatrixPoints: matrix pts: pts count: count
	"Invoke the GdipTransformMatrixPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformMatrixPoints(
			PGpMatrix matrix,
			POINTF* pts,
			int Count);"

	<stdcall: errno GdipTransformMatrixPoints handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipTransformMatrixPointsI: matrix pts: pts count: count
	"Invoke the GdipTransformMatrixPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformMatrixPointsI(
			PGpMatrix matrix,
			POINTL* pts,
			int Count);"

	<stdcall: errno GdipTransformMatrixPointsI handle POINTL* int32>
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
			POINTF* Points,
			int Count);"

	<stdcall: errno GdipTransformPoints handle int32 int32 POINTF* int32>
	^self invalidCall: _failureCode!

gdipTransformPointsI: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count
	"Invoke the GdipTransformPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTransformPointsI(
			PGpGraphics graphics,
			GpCoordinateSpace destSpace,
			GpCoordinateSpace srcSpace,
			POINTL* Points,
			int Count);"

	<stdcall: errno GdipTransformPointsI handle int32 int32 POINTL* int32>
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

	<stdcall: errno GdipTranslateClipI handle int32 int32>
	^self invalidCall: _failureCode!

gdipTranslateLineTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslateLineTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateLineTransform(
			PGpLineGradient brush,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateLineTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipTranslateMatrix: matrix offsetX: offsetX offsetY: offsetY order: order
	"Invoke the GdipTranslateMatrix() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateMatrix(
			PGpMatrix matrix,
			REAL offsetX,
			REAL offsetY,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateMatrix handle float float int32>
	^self invalidCall: _failureCode!

gdipTranslatePathGradientTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslatePathGradientTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslatePathGradientTransform(
			PGpPathGradient brush,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslatePathGradientTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipTranslatePenTransform: pen dx: dx dy: dy order: order
	"Invoke the GdipTranslatePenTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslatePenTransform(
			PGpPen pen,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslatePenTransform handle float float int32>
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

	<stdcall: errno GdipTranslateRegionI handle int32 int32>
	^self invalidCall: _failureCode!

gdipTranslateTextureTransform: brush dx: dx dy: dy order: order
	"Invoke the GdipTranslateTextureTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateTextureTransform(
			[in]PGpTexture brush,
			[in]REAL dx,
			[in]REAL dy,
			[in]GpMatrixOrder order);"

	<stdcall: errno GdipTranslateTextureTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipTranslateWorldTransform: graphics dx: dx dy: dy order: order
	"Invoke the GdipTranslateWorldTransform() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipTranslateWorldTransform(
			PGpGraphics graphics,
			REAL dx,
			REAL dy,
			GpMatrixOrder order);"

	<stdcall: errno GdipTranslateWorldTransform handle float float int32>
	^self invalidCall: _failureCode!

gdipVectorTransformMatrixPoints: matrix pts: pts count: count
	"Invoke the GdipVectorTransformMatrixPoints() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipVectorTransformMatrixPoints(
			PGpMatrix matrix,
			POINTF* pts,
			int Count);"

	<stdcall: errno GdipVectorTransformMatrixPoints handle POINTF* int32>
	^self invalidCall: _failureCode!

gdipVectorTransformMatrixPointsI: matrix pts: pts count: count
	"Invoke the GdipVectorTransformMatrixPointsI() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipVectorTransformMatrixPointsI(
			PGpMatrix matrix,
			POINTL* pts,
			int Count);"

	<stdcall: errno GdipVectorTransformMatrixPointsI handle POINTL* int32>
	^self invalidCall: _failureCode!

gdipWarpPath: path matrix: matrix points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight warpMode: warpMode flatness: flatness
	"Invoke the GdipWarpPath() function of the module wrapped by the receiver.

		GpStatus __stdcall GdipWarpPath(
			PGpPath path,
			PGpMatrix matrix,
			[in]POINTF* Points,
			int Count,
			REAL srcx,
			REAL srcy,
			REAL srcwidth,
			REAL srcheight,
			WarpMode WarpMode,
			REAL flatness);"

	<stdcall: errno GdipWarpPath handle handle POINTF* int32 float float float float int32 float>
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
	input := GdiplusStartupInputEx new.
	input GdiplusVersion: 2.
	newToken := UInt32Bytes new.
	self
		gdiplusStartup: newToken
		input: input
		output: nil.
	token := newToken asInteger!

invalidCall: anInteger
	"Private - An invalid external call was attempted through one of the receiver's methods. The argument is the failure code from the external call primitive, which in the case of the GdiplusLibrary will be the non-zero GpStatus return code from the function call."

	^anInteger < 0
		ifTrue: [self invalidCall: anInteger fromFrame: Processor activeProcess topFrame sender]
		ifFalse: 
			[| method frame |
			frame := Processor activeProcess topFrame sender.
			method := frame method.
			GdiplusError signal: method functionName , ' failed' with: anInteger]!

uninitialize
	"Private - Reverse the initialize"

	token ifNil: [^self].
	self gdiplusShutdown: token.
	token := nil!

unmarshalFloats: aByteArrayOrAddress count: anInteger
	| offset points |
	points := Array new: anInteger.
	offset := 0.
	1 to: anInteger
		do: 
			[:i |
			points at: i put: (aByteArrayOrAddress floatAtOffset: offset).
			offset := offset + 4].
	^points! !

!Graphics.Gdiplus.GdiplusLibrary categoriesForMethods!
close!public!realizing/unrealizing! !
gdipAddPathArc:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathArcI:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathBezier:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathBezierI:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathBeziers:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathBeziersI:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathClosedCurve:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathClosedCurve2:points:count:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathClosedCurve2I:points:count:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathClosedCurveI:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurve:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurve2:points:count:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurve2I:points:count:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurve3:points:count:offset:numberOfSegments:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurve3I:points:count:offset:numberOfSegments:tension:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathCurveI:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathEllipse:x:y:width:height:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathEllipseI:x:y:width:height:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathLine:x1:y1:x2:y2:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathLine2:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathLine2I:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathLineI:x1:y1:x2:y2:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathPath:addingPath:connect:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathPie:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathPieI:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathPolygon:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathPolygonI:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathRectangle:x:y:width:height:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathRectangleI:x:y:width:height:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathRectangles:rects:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathRectanglesI:rects:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathString:string:length:family:style:emSize:layoutRect:format:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipAddPathStringI:string:length:family:style:emSize:layoutRect:format:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipBeginContainer:dstrect:srcRect:unit:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipBeginContainer2:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipBeginContainerI:dstrect:srcRect:unit:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipBitmapApplyEffect:effect:roi:useAuxData:auxData:auxDataSize:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapConvertFormat:format:ditherType:paletteType:palette:alphaThresholdPercent:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapCreateApplyEffect:numInputs:effect:roi:outputRect:outputBitmap:useAuxData:auxData:auxDataSize:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapGetHistogram:format:numberOfEntries:channel0:channel1:channel2:channel3:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapGetHistogramSize:numberOfEntries:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapGetPixel:x:y:color:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapLockBits:rect:flags:format:lockedBitmapData:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapSetPixel:x:y:color:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapSetResolution:xdpi:ydpi:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipBitmapUnlockBits:lockedBitmapData:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipClearPathMarkers:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipCloneBitmapArea:y:width:height:format:srcBitmap:dstBitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCloneBitmapAreaI:y:width:height:format:srcBitmap:dstBitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCloneBrush:cloneBrush:!**auto generated**!GDI+ Flat API-Brush Functions!public! !
gdipCloneCustomLineCap:clonedCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipCloneFont:cloneFont:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipCloneFontFamily:clonedFontFamily:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipCloneImage:cloneImage:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipCloneImageAttributes:cloneImageattr:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipCloneMatrix:cloneMatrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipClonePath:clonePath:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipClonePen:clonepen:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipCloneRegion:cloneRegion:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCloneStringFormat:newFormat:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipClosePathFigure:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipClosePathFigures:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipCombineRegionPath:path:combineMode:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCombineRegionRect:rect:combineMode:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCombineRegionRectI:rect:combineMode:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCombineRegionRegion:region2:combineMode:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipComment:sizeData:data:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipConvertToEmfPlus:metafile:conversionFailureFlag:emfType:description:out_metafile:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipConvertToEmfPlusToFile:metafile:conversionFailureFlag:filename:emfType:description:out_metafile:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipConvertToEmfPlusToStream:metafile:conversionFailureFlag:stream:emfType:description:out_metafile:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipCreateAdjustableArrowCap:width:isFilled:cap:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipCreateBitmapFromDirectDrawSurface:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromFile:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromFileICM:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromGdiDib:gdiBitmapData:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromGraphics:height:target:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromHBITMAP:hpal:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromHICON:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromResource:lpBitmapName:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromStream:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateBitmapFromStreamICM:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateCachedBitmap:graphics:cachedBitmap:!**auto generated**!GDI+ Flat API-CachedBitmap Functions!public! !
gdipCreateCustomLineCap:strokePath:baseCap:baseInset:customCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipCreateFont:emSize:style:unit:font:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipCreateFontFamilyFromName:fontCollection:fontFamily:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipCreateFontFromDC:font:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipCreateFontFromLogfontW:logfont:font:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipCreateFromHDC:graphics:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateFromHDC2:hDevice:graphics:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateFromHWND:graphics:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateFromHWNDICM:graphics:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateHalftonePalette!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateHatchBrush:forecol:backcol:brush:!**auto generated**!GDI+ Flat API-HatchBrush Functions!public! !
gdipCreateHBITMAPFromBitmap:hbmReturn:background:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateHICONFromBitmap:hbmReturn:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipCreateImageAttributes:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipCreateLineBrush:point2:color1:color2:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateLineBrushFromRect:color1:color2:mode:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateLineBrushFromRectWithAngle:color1:color2:angle:isAngleScalable:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateLineBrushFromRectWithAngleI:color1:color2:angle:isAngleScalable:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipCreateMatrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipCreateMatrix2:m12:m21:m22:dx:dy:matrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipCreateMatrix3:dstplg:matrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipCreateMatrix3I:dstplg:matrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipCreateMetafileFromEmf:deleteEmf:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateMetafileFromFile:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateMetafileFromStream:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateMetafileFromWmf:deleteWmf:wmfPlaceableFileHeader:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateMetafileFromWmfFile:wmfPlaceableFileHeader:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreatePath:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipCreatePath2:types:count:fillMode:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipCreatePath2I:types:count:fillMode:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipCreatePathGradient:count:wrapMode:polyGradient:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipCreatePathGradientFromPath:polyGradient:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipCreatePathGradientI:count:wrapMode:polyGradient:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipCreatePathIter:path:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipCreatePen1:width:unit:pen:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipCreatePen2:width:unit:pen:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipCreateRegion:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateRegionHrgn:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateRegionPath:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateRegionRect:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateRegionRectI:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateRegionRgnData:size:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipCreateSolidFill:brush:!**auto generated**!GDI+ Flat API-SolidBrush Functions!public! !
gdipCreateStreamOnFile:access:stream:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipCreateStringFormat:language:format:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipCreateTexture:wrapMode:texture:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipCreateTexture2:wrapMode:x:y:width:height:texture:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipCreateTexture2I:wrapMode:x:y:width:height:texture:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipCreateTextureIA:imageAttributes:x:y:width:height:texture:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipCreateTextureIAI:imageAttributes:x:y:width:height:texture:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipDeleteBrush:!**auto generated**!GDI+ Flat API-Brush Functions!public! !
gdipDeleteCachedBitmap:!**auto generated**!GDI+ Flat API-CachedBitmap Functions!public! !
gdipDeleteCustomLineCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipDeleteFont:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipDeleteFontFamily:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipDeleteGraphics:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDeleteMatrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipDeletePath:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipDeletePathIter:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipDeletePen:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipDeletePrivateFontCollection:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipDeleteRegion:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipDeleteStringFormat:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipDisposeImage:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDisposeImageAttributes:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipDrawArc:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawArcI:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawBezier:pen:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawBezierI:pen:x1:y1:x2:y2:x3:y3:x4:y4:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawBeziers:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawBeziersI:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCachedBitmap:cachedBitmap:x:y:!**auto generated**!GDI+ Flat API-CachedBitmap Functions!public! !
gdipDrawClosedCurve:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawClosedCurve2:pen:points:count:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawClosedCurve2I:pen:points:count:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawClosedCurveI:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurve:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurve2:pen:points:count:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurve2I:pen:points:count:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurve3:pen:points:count:offset:numberOfSegments:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurve3I:pen:points:count:offset:numberOfSegments:tension:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawCurveI:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawDriverString:text:length:font:brush:positions:flags:matrix:!**auto generated**!GDI+ Flat API-Text Functions!public! !
gdipDrawEllipse:pen:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawEllipseI:pen:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawImage:image:x:y:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImageFX:image:source:xForm:effect:imageAttributes:srcUnit:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawImageI:image:x:y:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePointRect:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePointRectI:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePoints:image:dstpoints:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePointsI:image:dstpoints:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePointsRect:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImagePointsRectI:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImageRect:image:x:y:width:height:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImageRectI:image:x:y:width:height:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImageRectRect:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawImageRectRectI:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipDrawLine:pen:x1:y1:x2:y2:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawLineI:pen:x1:y1:x2:y2:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawLines:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawLinesI:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawPath:pen:path:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawPie:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawPieI:pen:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawPolygon:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawPolygonI:pen:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawRectangle:pen:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawRectangleI:pen:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawRectangles:pen:rects:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawRectanglesI:pen:rects:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipDrawString:str:length:font:layoutRect:stringFormat:brush:!**auto generated**!GDI+ Flat API-Text Functions!public! !
gdipEmfToWmfBits:cbData16:pData16:iMapMode:eFlags:!**auto generated**!GDI+ Flat API-CachedBitmap Functions!public! !
gdipEndContainer:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestPoint:metafile:destPoint:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestPointI:metafile:destPoint:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestPoints:metafile:destPoints:count:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestPointsI:metafile:destPoints:count:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestRect:metafile:destRect:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileDestRectI:metafile:destRect:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestPoint:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestPointI:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestPoints:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestPointsI:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestRect:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipEnumerateMetafileSrcRectDestRectI:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillClosedCurve:brush:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillClosedCurve2:brush:points:count:tension:fillMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillClosedCurve2I:brush:points:count:tension:fillMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillClosedCurveI:brush:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillEllipse:brush:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillEllipseI:brush:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPath:brush:path:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPie:brush:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPieI:brush:x:y:width:height:startAngle:sweepAngle:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPolygon:brush:points:count:fillMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPolygon2:brush:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPolygon2I:brush:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillPolygonI:brush:points:count:fillMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillRectangle:brush:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillRectangleI:brush:x:y:width:height:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillRectangles:brush:rects:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillRectanglesI:brush:rects:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFillRegion:brush:region:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipFindFirstImageItem:item:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipFindNextImageItem:item:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipFlattenPath:matrix:flatness:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipFlush:intention:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipFontCollectionEnumerable:graphics:numFound:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipFontCollectionEnumerate:numSought:gpfamilies:numFound:graphics:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetAdjustableArrowCapFillState:fillState:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipGetAdjustableArrowCapHeight:height:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipGetAdjustableArrowCapMiddleInset:middleInset:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipGetAdjustableArrowCapWidth:width:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipGetAllPropertyItems:totalBufferSize:numProperties:allItems:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetBrushType:type:!**auto generated**!GDI+ Flat API-Brush Functions!public! !
gdipGetCellAscent:style:cellAscent:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetCellDescent:style:cellDescent:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetClip:region:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetClipBounds:rect:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetClipBoundsI:rect:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetCompositingMode:compositingMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetCompositingQuality:compositingQuality:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetCustomLineCapBaseCap:baseCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetCustomLineCapBaseInset:inset:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetCustomLineCapStrokeCaps:startCap:endCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetCustomLineCapStrokeJoin:lineJoin:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetCustomLineCapType:capType:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetCustomLineCapWidthScale:widthScale:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipGetDC:hdc:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetDpiX:dpi:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetDpiY:dpi:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetEmHeight:style:emHeight:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetEncoderParameterList:clsidEncoder:size:buffer:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetEncoderParameterListSize:clsidEncoder:size:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetFamily:family:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFamilyName:name:language:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetFontCollectionFamilyCount:numFound:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontCollectionFamilyList:numSought:gpfamilies:numFound:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontHeight:graphics:height:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontHeightGivenDPI:dpi:height:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontSize:size:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontStyle:style:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetFontUnit:unit:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetGenericFontFamilyMonospace:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetGenericFontFamilySansSerif:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetGenericFontFamilySerif:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetHatchBackgroundColor:backcol:!**auto generated**!GDI+ Flat API-HatchBrush Functions!public! !
gdipGetHatchForegroundColor:forecol:!**auto generated**!GDI+ Flat API-HatchBrush Functions!public! !
gdipGetHatchStyle:hatchStyle:!**auto generated**!GDI+ Flat API-HatchBrush Functions!public! !
gdipGetHemfFromMetafile:hEmf:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetImageAttributesAdjustedPalette:colorPalette:colorAdjustType:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipGetImageBounds:srcRect:srcUnit:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageDecoders:size:decoders:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetImageDecodersSize:size:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetImageDimension:width:height:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageEncoders:size:encoders:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetImageEncodersSize:size:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetImageFlags:flags:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageGraphicsContext:graphics:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageHeight:height:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageHorizontalResolution:resolution:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageItemData:item:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImagePalette:palette:size:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImagePaletteSize:size:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImagePixelFormat:format:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageRawFormat:format:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageThumbnail:thumbWidth:thumbHeight:thumbImage:pfnCallback:callbackData:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageType:type:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageVerticalResolution:resolution:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetImageWidth:width:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetInterpolationMode:interpolationMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetLineBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineBlendCount:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineColors:colors:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLinePresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLinePresetBlendCount:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineRect:rect:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineRectI:rect:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineSpacing:style:lineSpacing:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipGetLineTransform:matrix:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLogFontW:graphics:logfontw:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetMatrixElements:matrixOut:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipGetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetMetafileHeaderFromEmf:header:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetMetafileHeaderFromFile:header:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetMetafileHeaderFromMetafile:header:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetMetafileHeaderFromStream:header:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetMetafileHeaderFromWmf:wmfPlaceableFileHeader:header:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetNearestColor:argb:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetPageScale:scale:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetPageUnit:unit:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetPathData:pathData:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathFillMode:fillMode:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientBlendCount:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientCenterColor:colors:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientCenterPoint:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientCenterPointI:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientFocusScales:xScale:yScale:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientPath:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientPointCount:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientPresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientPresetBlendCount:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientRect:rect:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientRectI:rect:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientSurroundColorCount:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientTransform:matrix:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathGradientWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathLastPoint:lastPoint:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathPoints:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathPointsI:points:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathTypes:types:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathWorldBounds:bounds:matrix:pen:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPathWorldBoundsI:bounds:matrix:pen:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPenBrushFill:brush:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenColor:argb:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenCompoundArray:dash:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenCompoundCount:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenCustomEndCap:customCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenCustomStartCap:customCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenDashArray:dash:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenDashCap197819:dashCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenDashCount:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenDashOffset:offset:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenDashStyle:dashStyle:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenEndCap:endCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenFillType:type:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenLineJoin:lineJoin:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenMiterLimit:miterLimit:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenMode:penMode:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenStartCap:startCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenTransform:matrix:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenUnit:unit:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPenWidth:width:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipGetPixelOffsetMode:pixelOffsetMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetPointCount:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipGetPropertyCount:numOfProperty:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetPropertyIdList:numOfProperty:list:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetPropertyItem:propId:propSize:buffer:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetPropertyItemSize:propId:size:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetPropertySize:totalBufferSize:numProperties:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipGetRegionBounds:graphics:rect:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionBoundsI:graphics:rect:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionData:buffer:bufferSize:sizeFilled:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionDataSize:bufferSize:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionHRgn:graphics:hRgn:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionScans:rects:count:matrix:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionScansCount:count:matrix:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRegionScansI:rects:count:matrix:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipGetRenderingOrigin:x:y:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetSmoothingMode:smoothingMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetSolidFillColor:color:!**auto generated**!GDI+ Flat API-SolidBrush Functions!public! !
gdipGetStringFormatAlign:align:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatDigitSubstitution:language:substitute:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatFlags:flags:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatHotkeyPrefix:hotkeyPrefix:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatLineAlign:align:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatMeasurableCharacterRangeCount:count:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatTabStopCount:count:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatTabStops:count:firstTabOffset:tabStops:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetStringFormatTrimming:trimming:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipGetTextContrast:contrast:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetTextRenderingHint:mode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetTextureImage:image:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipGetTextureTransform:matrix:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipGetTextureWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipGetVisibleClipBounds:rect:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetVisibleClipBoundsI:rect:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGetWorldTransform:matrix:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGraphicsClear:color:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipGraphicsSetAbort:pIAbort:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipImageForceValidation:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameCount:dimensionID:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameDimensionsCount:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameDimensionsList:dimensionIDs:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageRotateFlip:rfType:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageSelectActiveFrame:dimensionID:frameIndex:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageSetAbort:pIAbort:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipInitializePalette:paletteType:optimalColors:useTransparentColor:bitmap:!**auto generated**!GDI+ Flat API-Bitmap Functions!public! !
gdipInvertMatrix:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipIsClipEmpty:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsEmptyRegion:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsEqualRegion:region2:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsInfiniteRegion:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsMatrixEqual:matrix2:result:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipIsMatrixIdentity:result:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipIsMatrixInvertible:result:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipIsOutlineVisiblePathPoint:x:y:pen:graphics:result:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipIsOutlineVisiblePathPointI:x:y:pen:graphics:result:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipIsStyleAvailable:style:isStyleAvailable:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
gdipIsVisibleClipEmpty:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsVisiblePathPoint:x:y:graphics:result:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipIsVisiblePathPointI:x:y:graphics:result:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipIsVisiblePoint:x:y:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsVisiblePointI:x:y:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsVisibleRect:x:y:width:height:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsVisibleRectI:x:y:width:height:result:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipIsVisibleRegionPoint:x:y:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsVisibleRegionPointI:x:y:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsVisibleRegionRect:x:y:width:height:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipIsVisibleRegionRectI:x:y:width:height:graphics:result:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipLoadImageFromFile:image:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipLoadImageFromFileICM:image:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipLoadImageFromStream:image:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipLoadImageFromStreamICM:image:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdiplusNotificationHook:!**auto generated**!GDI+ Flat API-Notification Functions!public! !
gdiplusNotificationUnhook:!**auto generated**!GDI+ Flat API-Notification Functions!public! !
gdiplusShutdown:!**auto generated**!GDI+ Flat API-Other Functions!public! !
gdiplusStartup:input:output:!**auto generated**!GDI+ Flat API-Other Functions!public! !
gdipMeasureCharacterRanges:str:length:font:layoutRect:stringFormat:regionCount:regions:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipMeasureDriverString:text:length:font:positions:flags:matrix:boundingBox:!**auto generated**!GDI+ Flat API-Text Functions!public! !
gdipMeasureString:str:length:font:layoutRect:stringFormat:boundingBox:codepointsFitted:linesFilled:!**auto generated**!GDI+ Flat API-Text Functions!public! !
gdipMultiplyLineTransform:matrix:order:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipMultiplyMatrix:matrix2:order:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipMultiplyPathGradientTransform:matrix:order:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipMultiplyPenTransform:matrix:order:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipMultiplyTextureTransform:matrix:order:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipMultiplyWorldTransform:matrix:order:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipNewInstalledFontCollection:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipNewPrivateFontCollection:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipPathIterCopyData:resultCount:points:types:startIndex:endIndex:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterEnumerate:resultCount:points:types:count:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterGetCount:count:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterGetSubpathCount:count:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterHasCurve:hasCurve:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterIsValid:valid:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterNextMarker:resultCount:startIndex:endIndex:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterNextMarkerPath:resultCount:path:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterNextPathType:resultCount:pathType:startIndex:endIndex:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterNextSubpath:resultCount:startIndex:endIndex:isClosed:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterNextSubpathPath:resultCount:path:isClosed:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPathIterRewind:!**auto generated**!GDI+ Flat API-PathIterator Functions!public! !
gdipPlayMetafileRecord:recordType:flags:dataSize:data:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipPrivateAddFontFile:filename:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipPrivateAddMemoryFont:memory:length:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipRecordMetafile:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRecordMetafileFileName:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRecordMetafileFileNameI:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRecordMetafileI:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRecordMetafileStream:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRecordMetafileStreamI:referenceHdc:type:frameRect:frameUnit:description:metafile:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipReleaseDC:hdc:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRemovePropertyItem:propId:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipResetClip:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipResetImageAttributes:type:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipResetLineTransform:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipResetPageTransform:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipResetPath:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipResetPathGradientTransform:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipResetPenTransform:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipResetTextureTransform:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipResetWorldTransform:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipRestoreGraphics:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipReversePath:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipRotateLineTransform:angle:order:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipRotateMatrix:angle:order:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipRotatePathGradientTransform:angle:order:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipRotatePenTransform:angle:order:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipRotateTextureTransform:angle:order:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipRotateWorldTransform:angle:order:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSaveAdd:encoderParams:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipSaveAddImage:newImage:encoderParams:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipSaveGraphics:state:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSaveImageToFile:filename:clsidEncoder:encoderParams:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipSaveImageToStream:stream:clsidEncoder:encoderParams:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipScaleLineTransform:sx:sy:order:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipScaleMatrix:scaleX:scaleY:order:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipScalePathGradientTransform:sx:sy:order:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipScalePenTransform:sx:sy:order:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipScaleTextureTransform:sx:sy:order:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipScaleWorldTransform:sx:sy:order:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetAdjustableArrowCapFillState:fillState:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipSetAdjustableArrowCapHeight:height:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipSetAdjustableArrowCapMiddleInset:middleInset:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipSetAdjustableArrowCapWidth:width:!**auto generated**!GDI+ Flat API-AdjustableArrowCap Functions!public! !
gdipSetClipGraphics:srcgraphics:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetClipHrgn:hRgn:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetClipPath:path:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetClipRect:x:y:width:height:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetClipRectI:x:y:width:height:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetClipRegion:region:combineMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetCompositingMode:compositingMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetCompositingQuality:compositingQuality:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetCustomLineCapBaseCap:baseCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipSetCustomLineCapBaseInset:inset:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipSetCustomLineCapStrokeCaps:startCap:endCap:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipSetCustomLineCapStrokeJoin:lineJoin:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipSetCustomLineCapWidthScale:widthScale:!**auto generated**!GDI+ Flat API-CustomLineCap Functions!public! !
gdipSetEmpty:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipSetImageAttributesCachedBackground:enableFlag:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesColorKeys:type:enableFlag:colorLow:colorHigh:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesColorMatrix:type:enableFlag:colorMatrix:grayMatrix:flags:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesGamma:type:enableFlag:gamma:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesICMMode:on:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesNoOp:type:enableFlag:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesOutputChannel:type:enableFlag:channelFlags:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesOutputChannelColorProfile:type:enableFlag:colorProfileFilename:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesRemapTable:type:enableFlag:mapSize:map:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesThreshold:type:enableFlag:threshold:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesToIdentity:type:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImageAttributesWrapMode:wrap:argb:clamp:!**auto generated**!GDI+ Flat API-ImageAttributes Functions!public! !
gdipSetImagePalette:palette:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipSetInfinite:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipSetInterpolationMode:interpolationMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetLineBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineColors:color1:color2:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineLinearBlend:focus:scale:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLinePresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineSigmaBlend:focus:scale:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineTransform:matrix:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetLineWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipSetMatrixElements:m11:m12:m21:m22:dx:dy:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipSetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetPageScale:scale:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetPageUnit:unit:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetPathFillMode:fillMode:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientCenterColor:colors:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientCenterPoint:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientCenterPointI:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientFocusScales:xScale:yScale:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientLinearBlend:focus:scale:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientPath:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientPresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientSigmaBlend:focus:scale:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientTransform:matrix:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathGradientWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPathMarker:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipSetPenBrushFill:brush:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenColor:argb:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenCompoundArray:dash:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenCustomEndCap:customCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenCustomStartCap:customCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenDashArray:dash:count:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenDashArray:dashes:!operations!public! !
gdipSetPenDashCap197819:dashCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenDashOffset:offset:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenDashStyle:dashStyle:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenEndCap:endCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenLineCap197819:startCap:endCap:dashCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenLineJoin:lineJoin:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenMiterLimit:miterLimit:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenMode:penMode:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenStartCap:startCap:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenTransform:matrix:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenUnit:unit:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPenWidth:width:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipSetPixelOffsetMode:pixelOffsetMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetPropertyItem:item:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipSetRenderingOrigin:x:y:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetSmoothingMode:smoothingMode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetSolidFillColor:color:!**auto generated**!GDI+ Flat API-SolidBrush Functions!public! !
gdipSetStringFormatAlign:align:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatDigitSubstitution:language:substitute:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatFlags:flags:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatHotkeyPrefix:hotkeyPrefix:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatLineAlign:align:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatMeasurableCharacterRanges:rangeCount:ranges:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatTabStops:firstTabOffset:count:tabStops:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetStringFormatTrimming:trimming:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipSetTextContrast:contrast:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetTextRenderingHint:mode:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipSetTextureTransform:matrix:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipSetTextureWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipSetWorldTransform:matrix:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipShearMatrix:shearX:shearY:order:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipStartPathFigure:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipStringFormatGetGenericDefault:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipStringFormatGetGenericTypographic:!**auto generated**!GDI+ Flat API-String Format Functions!public! !
gdipTestControl:param:!**auto generated**!GDI+ Flat API-Text Functions!public! !
gdipTransformMatrixPoints:pts:count:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipTransformMatrixPointsI:pts:count:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipTransformPath:matrix:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipTransformPoints:destSpace:srcSpace:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipTransformPointsI:destSpace:srcSpace:points:count:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipTransformRegion:matrix:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipTranslateClip:dx:dy:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipTranslateClipI:dx:dy:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipTranslateLineTransform:dx:dy:order:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipTranslateMatrix:offsetX:offsetY:order:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipTranslatePathGradientTransform:dx:dy:order:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipTranslatePenTransform:dx:dy:order:!**auto generated**!GDI+ Flat API-Pen Functions!public! !
gdipTranslateRegion:dx:dy:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipTranslateRegionI:dx:dy:!**auto generated**!GDI+ Flat API-Region Functions!public! !
gdipTranslateTextureTransform:dx:dy:order:!**auto generated**!GDI+ Flat API-TextureBrush Functions!public! !
gdipTranslateWorldTransform:dx:dy:order:!**auto generated**!GDI+ Flat API-Graphics Functions!public! !
gdipVectorTransformMatrixPoints:pts:count:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipVectorTransformMatrixPointsI:pts:count:!**auto generated**!GDI+ Flat API-Matrix Functions!public! !
gdipWarpPath:matrix:points:count:srcx:srcy:srcwidth:srcheight:warpMode:flatness:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipWidenPath:pen:matrix:flatness:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
gdipWindingModeOutline:matrix:flatness:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!public! !
initialize!initializing!private! !
invalidCall:!exceptions!private! !
uninitialize!private!realizing/unrealizing! !
unmarshalFloats:count:!helpers!private! !
!

!Graphics.Gdiplus.GdiplusLibrary class methodsFor!

fileName
	"Answer the host system file name for the library."

	^'GdiPlus'
!

sharedVariableName
	^#{Graphics.Gdiplus.Gdip}! !

!Graphics.Gdiplus.GdiplusLibrary class categoriesForMethods!
fileName!**auto generated**!constants!public! !
sharedVariableName!constants!private! !
!

