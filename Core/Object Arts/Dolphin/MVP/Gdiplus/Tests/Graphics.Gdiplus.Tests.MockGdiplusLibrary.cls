"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusLibrary subclass: #'Graphics.Gdiplus.Tests.MockGdiplusLibrary'
	instanceVariableNames: 'process messages'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.MockGdiplusLibrary guid: (Core.GUID fromString: '{9b3f9739-55ff-4517-a48e-695d9df4dc96}')!
Graphics.Gdiplus.Tests.MockGdiplusLibrary comment: ''!
!Graphics.Gdiplus.Tests.MockGdiplusLibrary methodsFor!

gdipAddPathArc: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathArc: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipAddPathArc:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathArcI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathArcI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipAddPathArcI:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathBezier: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathBezier: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4].
	messages addLast: (Message selector: #gdipAddPathBezier:x1:y1:x2:y2:x3:y3:x4:y4: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathBezierI: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathBezierI: path x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4].
	messages addLast: (Message selector: #gdipAddPathBezierI:x1:y1:x2:y2:x3:y3:x4:y4: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathBeziers: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathBeziers: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathBeziers:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathBeziersI: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathBeziersI: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathBeziersI:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathClosedCurve: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathClosedCurve: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathClosedCurve:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathClosedCurve2: path points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathClosedCurve2: path points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipAddPathClosedCurve2:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathClosedCurve2I: path points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathClosedCurve2I: path points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipAddPathClosedCurve2I:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathClosedCurveI: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathClosedCurveI: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathClosedCurveI:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurve: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurve: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathCurve:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurve2: path points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurve2: path points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipAddPathCurve2:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurve2I: path points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurve2I: path points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipAddPathCurve2I:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurve3: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurve3: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension].
	messages addLast: (Message selector: #gdipAddPathCurve3:points:count:offset:numberOfSegments:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurve3I: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurve3I: path points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension].
	messages addLast: (Message selector: #gdipAddPathCurve3I:points:count:offset:numberOfSegments:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathCurveI: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathCurveI: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathCurveI:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathEllipse: path x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathEllipse: path x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipAddPathEllipse:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathEllipseI: path x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathEllipseI: path x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipAddPathEllipseI:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathLine: path x1: x1 y1: y1 x2: x2 y2: y2
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathLine: path x1: x1 y1: y1 x2: x2 y2: y2].
	messages addLast: (Message selector: #gdipAddPathLine:x1:y1:x2:y2: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathLine2: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathLine2: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathLine2:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathLine2I: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathLine2I: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathLine2I:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathLineI: path x1: x1 y1: y1 x2: x2 y2: y2
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathLineI: path x1: x1 y1: y1 x2: x2 y2: y2].
	messages addLast: (Message selector: #gdipAddPathLineI:x1:y1:x2:y2: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathPath: path addingPath: addingPath connect: connect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathPath: path addingPath: addingPath connect: connect].
	messages addLast: (Message selector: #gdipAddPathPath:addingPath:connect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathPie: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathPie: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipAddPathPie:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathPieI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathPieI: path x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipAddPathPieI:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathPolygon: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathPolygon: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathPolygon:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathPolygonI: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathPolygonI: path points: points count: count].
	messages addLast: (Message selector: #gdipAddPathPolygonI:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathRectangle: path x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathRectangle: path x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipAddPathRectangle:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathRectangleI: path x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathRectangleI: path x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipAddPathRectangleI:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathRectangles: path rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathRectangles: path rects: rects count: count].
	messages addLast: (Message selector: #gdipAddPathRectangles:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathRectanglesI: path rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathRectanglesI: path rects: rects count: count].
	messages addLast: (Message selector: #gdipAddPathRectanglesI:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathString: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathString: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format].
	messages addLast: (Message selector: #gdipAddPathString:string:length:family:style:emSize:layoutRect:format: arguments: activeProc topFrame arguments).
	^S_OK!

gdipAddPathStringI: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipAddPathStringI: path string: string length: length family: family style: style emSize: emSize layoutRect: layoutRect format: format].
	messages addLast: (Message selector: #gdipAddPathStringI:string:length:family:style:emSize:layoutRect:format: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBeginContainer: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBeginContainer: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state].
	messages addLast: (Message selector: #gdipBeginContainer:dstrect:srcRect:unit:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBeginContainer2: graphics state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBeginContainer2: graphics state: state].
	messages addLast: (Message selector: #gdipBeginContainer2:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBeginContainerI: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBeginContainerI: graphics dstrect: dstrect srcRect: srcRect unit: unit state: state].
	messages addLast: (Message selector: #gdipBeginContainerI:dstrect:srcRect:unit:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBitmapGetPixel: bitmap x: x y: y color: color
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBitmapGetPixel: bitmap x: x y: y color: color].
	messages addLast: (Message selector: #gdipBitmapGetPixel:x:y:color: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBitmapLockBits: bitmap rect: rect flags: flags format: format lockedBitmapData: lockedBitmapData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBitmapLockBits: bitmap rect: rect flags: flags format: format lockedBitmapData: lockedBitmapData].
	messages addLast: (Message selector: #gdipBitmapLockBits:rect:flags:format:lockedBitmapData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBitmapSetPixel: bitmap x: x y: y color: color
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBitmapSetPixel: bitmap x: x y: y color: color].
	messages addLast: (Message selector: #gdipBitmapSetPixel:x:y:color: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBitmapSetResolution: bitmap xdpi: xdpi ydpi: ydpi
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBitmapSetResolution: bitmap xdpi: xdpi ydpi: ydpi].
	messages addLast: (Message selector: #gdipBitmapSetResolution:xdpi:ydpi: arguments: activeProc topFrame arguments).
	^S_OK!

gdipBitmapUnlockBits: bitmap lockedBitmapData: lockedBitmapData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipBitmapUnlockBits: bitmap lockedBitmapData: lockedBitmapData].
	messages addLast: (Message selector: #gdipBitmapUnlockBits:lockedBitmapData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipClearPathMarkers: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipClearPathMarkers: path].
	messages addLast: (Message selector: #gdipClearPathMarkers: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneBitmapArea: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneBitmapArea: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap].
	messages addLast: (Message selector: #gdipCloneBitmapArea:y:width:height:format:srcBitmap:dstBitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneBitmapAreaI: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneBitmapAreaI: x y: y width: width height: height format: format srcBitmap: srcBitmap dstBitmap: dstBitmap].
	messages addLast: (Message selector: #gdipCloneBitmapAreaI:y:width:height:format:srcBitmap:dstBitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneBrush: brush cloneBrush: cloneBrush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneBrush: brush cloneBrush: cloneBrush].
	messages addLast: (Message selector: #gdipCloneBrush:cloneBrush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneCustomLineCap: customCap clonedCap: clonedCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneCustomLineCap: customCap clonedCap: clonedCap].
	messages addLast: (Message selector: #gdipCloneCustomLineCap:clonedCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneFont: font cloneFont: cloneFont
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneFont: font cloneFont: cloneFont].
	messages addLast: (Message selector: #gdipCloneFont:cloneFont: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneFontFamily: fontFamily clonedFontFamily: clonedFontFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneFontFamily: fontFamily clonedFontFamily: clonedFontFamily].
	messages addLast: (Message selector: #gdipCloneFontFamily:clonedFontFamily: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneImage: image cloneImage: cloneImage
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneImage: image cloneImage: cloneImage].
	messages addLast: (Message selector: #gdipCloneImage:cloneImage: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneImageAttributes: imageattr cloneImageattr: cloneImageattr
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneImageAttributes: imageattr cloneImageattr: cloneImageattr].
	messages addLast: (Message selector: #gdipCloneImageAttributes:cloneImageattr: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneMatrix: matrix cloneMatrix: cloneMatrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneMatrix: matrix cloneMatrix: cloneMatrix].
	messages addLast: (Message selector: #gdipCloneMatrix:cloneMatrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipClonePath: path clonePath: clonePath
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipClonePath: path clonePath: clonePath].
	messages addLast: (Message selector: #gdipClonePath:clonePath: arguments: activeProc topFrame arguments).
	^S_OK!

gdipClonePen: pen clonepen: clonepen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipClonePen: pen clonepen: clonepen].
	messages addLast: (Message selector: #gdipClonePen:clonepen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneRegion: region cloneRegion: cloneRegion
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneRegion: region cloneRegion: cloneRegion].
	messages addLast: (Message selector: #gdipCloneRegion:cloneRegion: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCloneStringFormat: format newFormat: newFormat
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCloneStringFormat: format newFormat: newFormat].
	messages addLast: (Message selector: #gdipCloneStringFormat:newFormat: arguments: activeProc topFrame arguments).
	^S_OK!

gdipClosePathFigure: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipClosePathFigure: path].
	messages addLast: (Message selector: #gdipClosePathFigure: arguments: activeProc topFrame arguments).
	^S_OK!

gdipClosePathFigures: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipClosePathFigures: path].
	messages addLast: (Message selector: #gdipClosePathFigures: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCombineRegionPath: region path: path combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCombineRegionPath: region path: path combineMode: combineMode].
	messages addLast: (Message selector: #gdipCombineRegionPath:path:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCombineRegionRect: region rect: rect combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCombineRegionRect: region rect: rect combineMode: combineMode].
	messages addLast: (Message selector: #gdipCombineRegionRect:rect:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCombineRegionRectI: region rect: rect combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCombineRegionRectI: region rect: rect combineMode: combineMode].
	messages addLast: (Message selector: #gdipCombineRegionRectI:rect:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCombineRegionRegion: region region2: region2 combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCombineRegionRegion: region region2: region2 combineMode: combineMode].
	messages addLast: (Message selector: #gdipCombineRegionRegion:region2:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipComment: graphics sizeData: sizeData data: data
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipComment: graphics sizeData: sizeData data: data].
	messages addLast: (Message selector: #gdipComment:sizeData:data: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateAdjustableArrowCap: height width: width isFilled: isFilled cap: cap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateAdjustableArrowCap: height width: width isFilled: isFilled cap: cap].
	messages addLast: (Message selector: #gdipCreateAdjustableArrowCap:width:isFilled:cap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromDirectDrawSurface: surface bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromDirectDrawSurface: surface bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromDirectDrawSurface:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromFile: filename bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromFile: filename bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromFile:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromFileICM: filename bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromFileICM: filename bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromFileICM:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromGdiDib: gdiBitmapInfo gdiBitmapData: gdiBitmapData bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromGdiDib: gdiBitmapInfo gdiBitmapData: gdiBitmapData bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromGdiDib:gdiBitmapData:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromGraphics: width height: height target: target bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromGraphics: width height: height target: target bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromGraphics:height:target:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromHBITMAP: hbm hpal: hpal bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromHBITMAP:hpal:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromHICON: hicon bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromHICON: hicon bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromHICON:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromResource: hInstance lpBitmapName: lpBitmapName bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromResource: hInstance lpBitmapName: lpBitmapName bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromResource:lpBitmapName:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromScan0: width height: height stride: stride format: format scan0: scan0 bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromScan0: width height: height stride: stride format: format scan0: scan0 bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromScan0:height:stride:format:scan0:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromStream: stream bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromStream: stream bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromStream:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateBitmapFromStreamICM: stream bitmap: bitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateBitmapFromStreamICM: stream bitmap: bitmap].
	messages addLast: (Message selector: #gdipCreateBitmapFromStreamICM:bitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateCachedBitmap: bitmap graphics: graphics cachedBitmap: cachedBitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateCachedBitmap: bitmap graphics: graphics cachedBitmap: cachedBitmap].
	messages addLast: (Message selector: #gdipCreateCachedBitmap:graphics:cachedBitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateCustomLineCap: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset customCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateCustomLineCap: fillPath strokePath: strokePath baseCap: baseCap baseInset: baseInset customCap: customCap].
	messages addLast: (Message selector: #gdipCreateCustomLineCap:strokePath:baseCap:baseInset:customCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFont: fontFamily emSize: emSize style: style unit: unit font: font
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFont: fontFamily emSize: emSize style: style unit: unit font: font].
	messages addLast: (Message selector: #gdipCreateFont:emSize:style:unit:font: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFontFamilyFromName: name fontCollection: fontCollection fontFamily: fontFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFontFamilyFromName: name fontCollection: fontCollection fontFamily: fontFamily].
	messages addLast: (Message selector: #gdipCreateFontFamilyFromName:fontCollection:fontFamily: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFontFromDC: hdc font: font
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFontFromDC: hdc font: font].
	messages addLast: (Message selector: #gdipCreateFontFromDC:font: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFontFromLogfontA: hdc logfont: logfont font: font
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFontFromLogfontA: hdc logfont: logfont font: font].
	messages addLast: (Message selector: #gdipCreateFontFromLogfontA:logfont:font: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFontFromLogfontW: hdc logfont: logfont font: font
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFontFromLogfontW: hdc logfont: logfont font: font].
	messages addLast: (Message selector: #gdipCreateFontFromLogfontW:logfont:font: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFromHDC: hdc graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFromHDC: hdc graphics: graphics].
	messages addLast: (Message selector: #gdipCreateFromHDC:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFromHDC2: hdc hDevice: hDevice graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFromHDC2: hdc hDevice: hDevice graphics: graphics].
	messages addLast: (Message selector: #gdipCreateFromHDC2:hDevice:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFromHWND: hwnd graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFromHWND: hwnd graphics: graphics].
	messages addLast: (Message selector: #gdipCreateFromHWND:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateFromHWNDICM: hwnd graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateFromHWNDICM: hwnd graphics: graphics].
	messages addLast: (Message selector: #gdipCreateFromHWNDICM:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateHalftonePalette
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateHalftonePalette].
	messages addLast: (Message selector: #gdipCreateHalftonePalette arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateHatchBrush: hatchStyle forecol: forecol backcol: backcol brush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateHatchBrush: hatchStyle forecol: forecol backcol: backcol brush: brush].
	messages addLast: (Message selector: #gdipCreateHatchBrush:forecol:backcol:brush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateHBITMAPFromBitmap: bitmap hbmReturn: hbmReturn background: background
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateHBITMAPFromBitmap: bitmap hbmReturn: hbmReturn background: background].
	messages addLast: (Message selector: #gdipCreateHBITMAPFromBitmap:hbmReturn:background: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateHICONFromBitmap: bitmap hbmReturn: hbmReturn
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateHICONFromBitmap: bitmap hbmReturn: hbmReturn].
	messages addLast: (Message selector: #gdipCreateHICONFromBitmap:hbmReturn: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateImageAttributes: imageattr
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateImageAttributes: imageattr].
	messages addLast: (Message selector: #gdipCreateImageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrush: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrush: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrush:point2:color1:color2:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrushFromRect: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrushFromRect: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrushFromRect:color1:color2:mode:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrushFromRectI: rect color1: color1 color2: color2 mode: mode wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrushFromRectI:color1:color2:mode:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrushFromRectWithAngle: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrushFromRectWithAngle: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrushFromRectWithAngle:color1:color2:angle:isAngleScalable:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrushFromRectWithAngleI: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrushFromRectWithAngleI: rect color1: color1 color2: color2 angle: angle isAngleScalable: isAngleScalable wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrushFromRectWithAngleI:color1:color2:angle:isAngleScalable:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateLineBrushI: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateLineBrushI: point1 point2: point2 color1: color1 color2: color2 wrapMode: wrapMode lineGradient: lineGradient].
	messages addLast: (Message selector: #gdipCreateLineBrushI:point2:color1:color2:wrapMode:lineGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMatrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMatrix: matrix].
	messages addLast: (Message selector: #gdipCreateMatrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMatrix2: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMatrix2: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy matrix: matrix].
	messages addLast: (Message selector: #gdipCreateMatrix2:m12:m21:m22:dx:dy:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMatrix3: rect dstplg: dstplg matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMatrix3: rect dstplg: dstplg matrix: matrix].
	messages addLast: (Message selector: #gdipCreateMatrix3:dstplg:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMatrix3I: rect dstplg: dstplg matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMatrix3I: rect dstplg: dstplg matrix: matrix].
	messages addLast: (Message selector: #gdipCreateMatrix3I:dstplg:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMetafileFromEmf: hEmf deleteEmf: deleteEmf metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMetafileFromEmf: hEmf deleteEmf: deleteEmf metafile: metafile].
	messages addLast: (Message selector: #gdipCreateMetafileFromEmf:deleteEmf:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMetafileFromFile: file metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMetafileFromFile: file metafile: metafile].
	messages addLast: (Message selector: #gdipCreateMetafileFromFile:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMetafileFromStream: stream metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMetafileFromStream: stream metafile: metafile].
	messages addLast: (Message selector: #gdipCreateMetafileFromStream:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMetafileFromWmf: hWmf deleteWmf: deleteWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMetafileFromWmf: hWmf deleteWmf: deleteWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile].
	messages addLast: (Message selector: #gdipCreateMetafileFromWmf:deleteWmf:wmfPlaceableFileHeader:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateMetafileFromWmfFile: file wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateMetafileFromWmfFile: file wmfPlaceableFileHeader: wmfPlaceableFileHeader metafile: metafile].
	messages addLast: (Message selector: #gdipCreateMetafileFromWmfFile:wmfPlaceableFileHeader:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePath: brushMode path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePath: brushMode path: path].
	messages addLast: (Message selector: #gdipCreatePath:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePath2: points types: types count: count fillMode: fillMode path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePath2: points types: types count: count fillMode: fillMode path: path].
	messages addLast: (Message selector: #gdipCreatePath2:types:count:fillMode:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePath2I: points types: types count: count fillMode: fillMode path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePath2I: points types: types count: count fillMode: fillMode path: path].
	messages addLast: (Message selector: #gdipCreatePath2I:types:count:fillMode:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePathGradient: points count: count wrapMode: wrapMode polyGradient: polyGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePathGradient: points count: count wrapMode: wrapMode polyGradient: polyGradient].
	messages addLast: (Message selector: #gdipCreatePathGradient:count:wrapMode:polyGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePathGradientFromPath: path polyGradient: polyGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePathGradientFromPath: path polyGradient: polyGradient].
	messages addLast: (Message selector: #gdipCreatePathGradientFromPath:polyGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePathGradientI: points count: count wrapMode: wrapMode polyGradient: polyGradient
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePathGradientI: points count: count wrapMode: wrapMode polyGradient: polyGradient].
	messages addLast: (Message selector: #gdipCreatePathGradientI:count:wrapMode:polyGradient: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePathIter: iterator path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePathIter: iterator path: path].
	messages addLast: (Message selector: #gdipCreatePathIter:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePen1: color width: width unit: unit pen: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePen1: color width: width unit: unit pen: pen].
	messages addLast: (Message selector: #gdipCreatePen1:width:unit:pen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreatePen2: brush width: width unit: unit pen: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreatePen2: brush width: width unit: unit pen: pen].
	messages addLast: (Message selector: #gdipCreatePen2:width:unit:pen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegion: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegion: region].
	messages addLast: (Message selector: #gdipCreateRegion: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegionHrgn: hRgn region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegionHrgn: hRgn region: region].
	messages addLast: (Message selector: #gdipCreateRegionHrgn:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegionPath: path region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegionPath: path region: region].
	messages addLast: (Message selector: #gdipCreateRegionPath:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegionRect: rect region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegionRect: rect region: region].
	messages addLast: (Message selector: #gdipCreateRegionRect:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegionRectI: rect region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegionRectI: rect region: region].
	messages addLast: (Message selector: #gdipCreateRegionRectI:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateRegionRgnData: regionData size: size region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateRegionRgnData: regionData size: size region: region].
	messages addLast: (Message selector: #gdipCreateRegionRgnData:size:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateSolidFill: color brush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateSolidFill: color brush: brush].
	messages addLast: (Message selector: #gdipCreateSolidFill:brush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateStreamOnFile: filename access: access stream: stream
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateStreamOnFile: filename access: access stream: stream].
	messages addLast: (Message selector: #gdipCreateStreamOnFile:access:stream: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateStringFormat: formatAttributes language: language format: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateStringFormat: formatAttributes language: language format: format].
	messages addLast: (Message selector: #gdipCreateStringFormat:language:format: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateTexture: image wrapMode: wrapMode texture: texture
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateTexture: image wrapMode: wrapMode texture: texture].
	messages addLast: (Message selector: #gdipCreateTexture:wrapMode:texture: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateTexture2: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateTexture2: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture].
	messages addLast: (Message selector: #gdipCreateTexture2:wrapMode:x:y:width:height:texture: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateTexture2I: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateTexture2I: image wrapMode: wrapMode x: x y: y width: width height: height texture: texture].
	messages addLast: (Message selector: #gdipCreateTexture2I:wrapMode:x:y:width:height:texture: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateTextureIA: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateTextureIA: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture].
	messages addLast: (Message selector: #gdipCreateTextureIA:imageAttributes:x:y:width:height:texture: arguments: activeProc topFrame arguments).
	^S_OK!

gdipCreateTextureIAI: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipCreateTextureIAI: image imageAttributes: imageAttributes x: x y: y width: width height: height texture: texture].
	messages addLast: (Message selector: #gdipCreateTextureIAI:imageAttributes:x:y:width:height:texture: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteBrush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteBrush: brush].
	messages addLast: (Message selector: #gdipDeleteBrush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteCachedBitmap: cachedBitmap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteCachedBitmap: cachedBitmap].
	messages addLast: (Message selector: #gdipDeleteCachedBitmap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteCustomLineCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteCustomLineCap: customCap].
	messages addLast: (Message selector: #gdipDeleteCustomLineCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteFont: font
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteFont: font].
	messages addLast: (Message selector: #gdipDeleteFont: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteFontFamily: fontFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteFontFamily: fontFamily].
	messages addLast: (Message selector: #gdipDeleteFontFamily: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteGraphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteGraphics: graphics].
	messages addLast: (Message selector: #gdipDeleteGraphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteMatrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteMatrix: matrix].
	messages addLast: (Message selector: #gdipDeleteMatrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeletePath: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeletePath: path].
	messages addLast: (Message selector: #gdipDeletePath: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeletePathIter: iterator
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeletePathIter: iterator].
	messages addLast: (Message selector: #gdipDeletePathIter: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeletePen: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeletePen: pen].
	messages addLast: (Message selector: #gdipDeletePen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeletePrivateFontCollection: fontCollection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeletePrivateFontCollection: fontCollection].
	messages addLast: (Message selector: #gdipDeletePrivateFontCollection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteRegion: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteRegion: region].
	messages addLast: (Message selector: #gdipDeleteRegion: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDeleteStringFormat: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDeleteStringFormat: format].
	messages addLast: (Message selector: #gdipDeleteStringFormat: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDisposeImage: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDisposeImage: image].
	messages addLast: (Message selector: #gdipDisposeImage: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDisposeImageAttributes: imageattr
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDisposeImageAttributes: imageattr].
	messages addLast: (Message selector: #gdipDisposeImageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawArc: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawArc: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipDrawArc:pen:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawArcI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawArcI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipDrawArcI:pen:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawBezier: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawBezier: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4].
	messages addLast: (Message selector: #gdipDrawBezier:pen:x1:y1:x2:y2:x3:y3:x4:y4: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawBezierI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawBezierI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2 x3: x3 y3: y3 x4: x4 y4: y4].
	messages addLast: (Message selector: #gdipDrawBezierI:pen:x1:y1:x2:y2:x3:y3:x4:y4: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawBeziers: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawBeziers: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawBeziers:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawBeziersI: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawBeziersI: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawBeziersI:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCachedBitmap: graphics cachedBitmap: cachedBitmap x: x y: y
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCachedBitmap: graphics cachedBitmap: cachedBitmap x: x y: y].
	messages addLast: (Message selector: #gdipDrawCachedBitmap:cachedBitmap:x:y: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawClosedCurve: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawClosedCurve: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawClosedCurve:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawClosedCurve2: graphics pen: pen points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawClosedCurve2: graphics pen: pen points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipDrawClosedCurve2:pen:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawClosedCurve2I: graphics pen: pen points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawClosedCurve2I: graphics pen: pen points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipDrawClosedCurve2I:pen:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawClosedCurveI: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawClosedCurveI: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawClosedCurveI:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurve: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurve: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawCurve:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurve2: graphics pen: pen points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurve2: graphics pen: pen points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipDrawCurve2:pen:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurve2I: graphics pen: pen points: points count: count tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurve2I: graphics pen: pen points: points count: count tension: tension].
	messages addLast: (Message selector: #gdipDrawCurve2I:pen:points:count:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurve3: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurve3: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension].
	messages addLast: (Message selector: #gdipDrawCurve3:pen:points:count:offset:numberOfSegments:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurve3I: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurve3I: graphics pen: pen points: points count: count offset: offset numberOfSegments: numberOfSegments tension: tension].
	messages addLast: (Message selector: #gdipDrawCurve3I:pen:points:count:offset:numberOfSegments:tension: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawCurveI: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawCurveI: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawCurveI:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawDriverString: graphics text: text length: length font: font brush: brush positions: positions flags: flags matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawDriverString: graphics text: text length: length font: font brush: brush positions: positions flags: flags matrix: matrix].
	messages addLast: (Message selector: #gdipDrawDriverString:text:length:font:brush:positions:flags:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawEllipse: graphics pen: pen x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawEllipse: graphics pen: pen x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawEllipse:pen:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawEllipseI: graphics pen: pen x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawEllipseI: graphics pen: pen x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawEllipseI:pen:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImage: graphics image: image x: x y: y
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImage: graphics image: image x: x y: y].
	messages addLast: (Message selector: #gdipDrawImage:image:x:y: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImageI: graphics image: image x: x y: y
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImageI: graphics image: image x: x y: y].
	messages addLast: (Message selector: #gdipDrawImageI:image:x:y: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePointRect: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePointRect: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit].
	messages addLast: (Message selector: #gdipDrawImagePointRect:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePointRectI: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePointRectI: graphics image: image x: x y: y srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit].
	messages addLast: (Message selector: #gdipDrawImagePointRectI:image:x:y:srcx:srcy:srcwidth:srcheight:srcUnit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePoints: graphics image: image dstpoints: dstpoints count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePoints: graphics image: image dstpoints: dstpoints count: count].
	messages addLast: (Message selector: #gdipDrawImagePoints:image:dstpoints:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePointsI: graphics image: image dstpoints: dstpoints count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePointsI: graphics image: image dstpoints: dstpoints count: count].
	messages addLast: (Message selector: #gdipDrawImagePointsI:image:dstpoints:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePointsRect: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePointsRect: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData].
	messages addLast: (Message selector: #gdipDrawImagePointsRect:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImagePointsRectI: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImagePointsRectI: graphics image: image points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData].
	messages addLast: (Message selector: #gdipDrawImagePointsRectI:image:points:count:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImageRect: graphics image: image x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImageRect: graphics image: image x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawImageRect:image:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImageRectI: graphics image: image x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImageRectI: graphics image: image x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawImageRectI:image:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImageRectRect: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImageRectRect: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData].
	messages addLast: (Message selector: #gdipDrawImageRectRect:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawImageRectRectI: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawImageRectRectI: graphics image: image dstx: dstx dsty: dsty dstwidth: dstwidth dstheight: dstheight srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight srcUnit: srcUnit imageAttributes: imageAttributes callback: callback callbackData: callbackData].
	messages addLast: (Message selector: #gdipDrawImageRectRectI:image:dstx:dsty:dstwidth:dstheight:srcx:srcy:srcwidth:srcheight:srcUnit:imageAttributes:callback:callbackData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawLine: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawLine: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2].
	messages addLast: (Message selector: #gdipDrawLine:pen:x1:y1:x2:y2: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawLineI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawLineI: graphics pen: pen x1: x1 y1: y1 x2: x2 y2: y2].
	messages addLast: (Message selector: #gdipDrawLineI:pen:x1:y1:x2:y2: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawLines: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawLines: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawLines:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawLinesI: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawLinesI: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawLinesI:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawPath: graphics pen: pen path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawPath: graphics pen: pen path: path].
	messages addLast: (Message selector: #gdipDrawPath:pen:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawPie: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawPie: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipDrawPie:pen:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawPieI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawPieI: graphics pen: pen x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipDrawPieI:pen:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawPolygon: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawPolygon: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawPolygon:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawPolygonI: graphics pen: pen points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawPolygonI: graphics pen: pen points: points count: count].
	messages addLast: (Message selector: #gdipDrawPolygonI:pen:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawRectangle: graphics pen: pen x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawRectangle: graphics pen: pen x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawRectangle:pen:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawRectangleI: graphics pen: pen x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawRectangleI: graphics pen: pen x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipDrawRectangleI:pen:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawRectangles: graphics pen: pen rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawRectangles: graphics pen: pen rects: rects count: count].
	messages addLast: (Message selector: #gdipDrawRectangles:pen:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawRectanglesI: graphics pen: pen rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawRectanglesI: graphics pen: pen rects: rects count: count].
	messages addLast: (Message selector: #gdipDrawRectanglesI:pen:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipDrawString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat brush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipDrawString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat brush: brush].
	messages addLast: (Message selector: #gdipDrawString:str:length:font:layoutRect:stringFormat:brush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEmfToWmfBits: hEmf cbData16: cbData16 pData16: pData16 iMapMode: iMapMode eFlags: eFlags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEmfToWmfBits: hEmf cbData16: cbData16 pData16: pData16 iMapMode: iMapMode eFlags: eFlags].
	messages addLast: (Message selector: #gdipEmfToWmfBits:cbData16:pData16:iMapMode:eFlags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEndContainer: graphics state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEndContainer: graphics state: state].
	messages addLast: (Message selector: #gdipEndContainer:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestPoint: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestPoint: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestPoint:metafile:destPoint:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestPointI: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestPointI: graphics metafile: metafile destPoint: destPoint fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestPointI:metafile:destPoint:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestPoints: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestPoints: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestPoints:metafile:destPoints:count:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestPointsI: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestPointsI: graphics metafile: metafile destPoints: destPoints count: count fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestPointsI:metafile:destPoints:count:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestRect: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestRect: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestRect:metafile:destRect:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileDestRectI: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileDestRectI: graphics metafile: metafile destRect: destRect fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileDestRectI:metafile:destRect:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestPoint: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestPoint: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestPoint:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestPointI: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestPointI: graphics metafile: metafile destPoint: destPoint srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestPointI:metafile:destPoint:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestPoints: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestPoints: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestPoints:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestPointsI: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestPointsI: graphics metafile: metafile destPoints: destPoints count: count srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestPointsI:metafile:destPoints:count:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestRect: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestRect: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestRect:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipEnumerateMetafileSrcRectDestRectI: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipEnumerateMetafileSrcRectDestRectI: graphics metafile: metafile destRect: destRect srcRect: srcRect srcUnit: srcUnit fnCallback: fnCallback callbackData: callbackData imageAttributes: imageAttributes].
	messages addLast: (Message selector: #gdipEnumerateMetafileSrcRectDestRectI:metafile:destRect:srcRect:srcUnit:fnCallback:callbackData:imageAttributes: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillClosedCurve: graphics brush: brush points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillClosedCurve: graphics brush: brush points: points count: count].
	messages addLast: (Message selector: #gdipFillClosedCurve:brush:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillClosedCurve2: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillClosedCurve2: graphics brush: brush points: points count: count tension: tension fillMode: fillMode].
	messages addLast: (Message selector: #gdipFillClosedCurve2:brush:points:count:tension:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillClosedCurve2I: graphics brush: brush points: points count: count tension: tension fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillClosedCurve2I: graphics brush: brush points: points count: count tension: tension fillMode: fillMode].
	messages addLast: (Message selector: #gdipFillClosedCurve2I:brush:points:count:tension:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillClosedCurveI: graphics brush: brush points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillClosedCurveI: graphics brush: brush points: points count: count].
	messages addLast: (Message selector: #gdipFillClosedCurveI:brush:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillEllipse: graphics brush: brush x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillEllipse: graphics brush: brush x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipFillEllipse:brush:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillEllipseI: graphics brush: brush x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillEllipseI: graphics brush: brush x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipFillEllipseI:brush:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPath: graphics brush: brush path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPath: graphics brush: brush path: path].
	messages addLast: (Message selector: #gdipFillPath:brush:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPie: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPie: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipFillPie:brush:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPieI: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPieI: graphics brush: brush x: x y: y width: width height: height startAngle: startAngle sweepAngle: sweepAngle].
	messages addLast: (Message selector: #gdipFillPieI:brush:x:y:width:height:startAngle:sweepAngle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPolygon: graphics brush: brush points: points count: count fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPolygon: graphics brush: brush points: points count: count fillMode: fillMode].
	messages addLast: (Message selector: #gdipFillPolygon:brush:points:count:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPolygon2: graphics brush: brush points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPolygon2: graphics brush: brush points: points count: count].
	messages addLast: (Message selector: #gdipFillPolygon2:brush:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPolygon2I: graphics brush: brush points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPolygon2I: graphics brush: brush points: points count: count].
	messages addLast: (Message selector: #gdipFillPolygon2I:brush:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillPolygonI: graphics brush: brush points: points count: count fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillPolygonI: graphics brush: brush points: points count: count fillMode: fillMode].
	messages addLast: (Message selector: #gdipFillPolygonI:brush:points:count:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillRectangle: graphics brush: brush x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillRectangle: graphics brush: brush x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipFillRectangle:brush:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillRectangleI: graphics brush: brush x: x y: y width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillRectangleI: graphics brush: brush x: x y: y width: width height: height].
	messages addLast: (Message selector: #gdipFillRectangleI:brush:x:y:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillRectangles: graphics brush: brush rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillRectangles: graphics brush: brush rects: rects count: count].
	messages addLast: (Message selector: #gdipFillRectangles:brush:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillRectanglesI: graphics brush: brush rects: rects count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillRectanglesI: graphics brush: brush rects: rects count: count].
	messages addLast: (Message selector: #gdipFillRectanglesI:brush:rects:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFillRegion: graphics brush: brush region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFillRegion: graphics brush: brush region: region].
	messages addLast: (Message selector: #gdipFillRegion:brush:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFlattenPath: path matrix: matrix flatness: flatness
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFlattenPath: path matrix: matrix flatness: flatness].
	messages addLast: (Message selector: #gdipFlattenPath:matrix:flatness: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFlush: graphics intention: intention
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFlush: graphics intention: intention].
	messages addLast: (Message selector: #gdipFlush:intention: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFontCollectionEnumerable: fontCollection graphics: graphics numFound: numFound
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFontCollectionEnumerable: fontCollection graphics: graphics numFound: numFound].
	messages addLast: (Message selector: #gdipFontCollectionEnumerable:graphics:numFound: arguments: activeProc topFrame arguments).
	^S_OK!

gdipFontCollectionEnumerate: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipFontCollectionEnumerate: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound graphics: graphics].
	messages addLast: (Message selector: #gdipFontCollectionEnumerate:numSought:gpfamilies:numFound:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetAdjustableArrowCapFillState: cap fillState: fillState
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetAdjustableArrowCapFillState: cap fillState: fillState].
	messages addLast: (Message selector: #gdipGetAdjustableArrowCapFillState:fillState: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetAdjustableArrowCapHeight: cap height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetAdjustableArrowCapHeight: cap height: height].
	messages addLast: (Message selector: #gdipGetAdjustableArrowCapHeight:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetAdjustableArrowCapMiddleInset: cap middleInset: middleInset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetAdjustableArrowCapMiddleInset: cap middleInset: middleInset].
	messages addLast: (Message selector: #gdipGetAdjustableArrowCapMiddleInset:middleInset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetAdjustableArrowCapWidth: cap width: width
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetAdjustableArrowCapWidth: cap width: width].
	messages addLast: (Message selector: #gdipGetAdjustableArrowCapWidth:width: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetAllPropertyItems: image totalBufferSize: totalBufferSize numProperties: numProperties allItems: allItems
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetAllPropertyItems: image totalBufferSize: totalBufferSize numProperties: numProperties allItems: allItems].
	messages addLast: (Message selector: #gdipGetAllPropertyItems:totalBufferSize:numProperties:allItems: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetBrushType: brush type: type
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetBrushType: brush type: type].
	messages addLast: (Message selector: #gdipGetBrushType:type: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCellAscent: family style: style cellAscent: cellAscent
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCellAscent: family style: style cellAscent: cellAscent].
	messages addLast: (Message selector: #gdipGetCellAscent:style:cellAscent: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCellDescent: family style: style cellDescent: cellDescent
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCellDescent: family style: style cellDescent: cellDescent].
	messages addLast: (Message selector: #gdipGetCellDescent:style:cellDescent: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetClip: graphics region: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetClip: graphics region: region].
	messages addLast: (Message selector: #gdipGetClip:region: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetClipBounds: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetClipBounds: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetClipBounds:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetClipBoundsI: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetClipBoundsI: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetClipBoundsI:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCompositingMode: graphics compositingMode: compositingMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCompositingMode: graphics compositingMode: compositingMode].
	messages addLast: (Message selector: #gdipGetCompositingMode:compositingMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCompositingQuality: graphics compositingQuality: compositingQuality
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCompositingQuality: graphics compositingQuality: compositingQuality].
	messages addLast: (Message selector: #gdipGetCompositingQuality:compositingQuality: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapBaseCap: customCap baseCap: baseCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapBaseCap: customCap baseCap: baseCap].
	messages addLast: (Message selector: #gdipGetCustomLineCapBaseCap:baseCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapBaseInset: customCap inset: inset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapBaseInset: customCap inset: inset].
	messages addLast: (Message selector: #gdipGetCustomLineCapBaseInset:inset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap].
	messages addLast: (Message selector: #gdipGetCustomLineCapStrokeCaps:startCap:endCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin].
	messages addLast: (Message selector: #gdipGetCustomLineCapStrokeJoin:lineJoin: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapType: customCap capType: capType
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapType: customCap capType: capType].
	messages addLast: (Message selector: #gdipGetCustomLineCapType:capType: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetCustomLineCapWidthScale: customCap widthScale: widthScale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetCustomLineCapWidthScale: customCap widthScale: widthScale].
	messages addLast: (Message selector: #gdipGetCustomLineCapWidthScale:widthScale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetDC: graphics hdc: hdc
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetDC: graphics hdc: hdc].
	messages addLast: (Message selector: #gdipGetDC:hdc: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetDpiX: graphics dpi: dpi
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetDpiX: graphics dpi: dpi].
	messages addLast: (Message selector: #gdipGetDpiX:dpi: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetDpiY: graphics dpi: dpi
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetDpiY: graphics dpi: dpi].
	messages addLast: (Message selector: #gdipGetDpiY:dpi: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetEmHeight: family style: style emHeight: emHeight
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetEmHeight: family style: style emHeight: emHeight].
	messages addLast: (Message selector: #gdipGetEmHeight:style:emHeight: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetEncoderParameterList: image clsidEncoder: clsidEncoder size: size buffer: buffer
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetEncoderParameterList: image clsidEncoder: clsidEncoder size: size buffer: buffer].
	messages addLast: (Message selector: #gdipGetEncoderParameterList:clsidEncoder:size:buffer: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetEncoderParameterListSize: image clsidEncoder: clsidEncoder size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetEncoderParameterListSize: image clsidEncoder: clsidEncoder size: size].
	messages addLast: (Message selector: #gdipGetEncoderParameterListSize:clsidEncoder:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFamily: font family: family
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFamily: font family: family].
	messages addLast: (Message selector: #gdipGetFamily:family: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFamilyName: family name: name language: language
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFamilyName: family name: name language: language].
	messages addLast: (Message selector: #gdipGetFamilyName:name:language: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontCollectionFamilyCount: fontCollection numFound: numFound
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontCollectionFamilyCount: fontCollection numFound: numFound].
	messages addLast: (Message selector: #gdipGetFontCollectionFamilyCount:numFound: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontCollectionFamilyList: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontCollectionFamilyList: fontCollection numSought: numSought gpfamilies: gpfamilies numFound: numFound].
	messages addLast: (Message selector: #gdipGetFontCollectionFamilyList:numSought:gpfamilies:numFound: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontHeight: font graphics: graphics height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontHeight: font graphics: graphics height: height].
	messages addLast: (Message selector: #gdipGetFontHeight:graphics:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontHeightGivenDPI: font dpi: dpi height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontHeightGivenDPI: font dpi: dpi height: height].
	messages addLast: (Message selector: #gdipGetFontHeightGivenDPI:dpi:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontSize: font size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontSize: font size: size].
	messages addLast: (Message selector: #gdipGetFontSize:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontStyle: font style: style
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontStyle: font style: style].
	messages addLast: (Message selector: #gdipGetFontStyle:style: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetFontUnit: font unit: unit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetFontUnit: font unit: unit].
	messages addLast: (Message selector: #gdipGetFontUnit:unit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetGenericFontFamilyMonospace: nativeFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetGenericFontFamilyMonospace: nativeFamily].
	messages addLast: (Message selector: #gdipGetGenericFontFamilyMonospace: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetGenericFontFamilySansSerif: nativeFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetGenericFontFamilySansSerif: nativeFamily].
	messages addLast: (Message selector: #gdipGetGenericFontFamilySansSerif: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetGenericFontFamilySerif: nativeFamily
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetGenericFontFamilySerif: nativeFamily].
	messages addLast: (Message selector: #gdipGetGenericFontFamilySerif: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetHatchBackgroundColor: brush backcol: backcol
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetHatchBackgroundColor: brush backcol: backcol].
	messages addLast: (Message selector: #gdipGetHatchBackgroundColor:backcol: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetHatchForegroundColor: brush forecol: forecol
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetHatchForegroundColor: brush forecol: forecol].
	messages addLast: (Message selector: #gdipGetHatchForegroundColor:forecol: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetHatchStyle: brush hatchStyle: hatchStyle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetHatchStyle: brush hatchStyle: hatchStyle].
	messages addLast: (Message selector: #gdipGetHatchStyle:hatchStyle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetHemfFromMetafile: metafile hEmf: hEmf
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetHemfFromMetafile: metafile hEmf: hEmf].
	messages addLast: (Message selector: #gdipGetHemfFromMetafile:hEmf: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageAttributesAdjustedPalette: imageattr colorPalette: colorPalette colorAdjustType: colorAdjustType
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageAttributesAdjustedPalette: imageattr colorPalette: colorPalette colorAdjustType: colorAdjustType].
	messages addLast: (Message selector: #gdipGetImageAttributesAdjustedPalette:colorPalette:colorAdjustType: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageBounds: image srcRect: srcRect srcUnit: srcUnit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageBounds: image srcRect: srcRect srcUnit: srcUnit].
	messages addLast: (Message selector: #gdipGetImageBounds:srcRect:srcUnit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageDecoders: numDecoders size: size decoders: decoders
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageDecoders: numDecoders size: size decoders: decoders].
	messages addLast: (Message selector: #gdipGetImageDecoders:size:decoders: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageDecodersSize: numDecoders size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageDecodersSize: numDecoders size: size].
	messages addLast: (Message selector: #gdipGetImageDecodersSize:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageDimension: image width: width height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageDimension: image width: width height: height].
	messages addLast: (Message selector: #gdipGetImageDimension:width:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageEncoders: numEncoders size: size encoders: encoders
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageEncoders: numEncoders size: size encoders: encoders].
	messages addLast: (Message selector: #gdipGetImageEncoders:size:encoders: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageEncodersSize: numEncoders size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageEncodersSize: numEncoders size: size].
	messages addLast: (Message selector: #gdipGetImageEncodersSize:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageFlags: image flags: flags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageFlags: image flags: flags].
	messages addLast: (Message selector: #gdipGetImageFlags:flags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageGraphicsContext: image graphics: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageGraphicsContext: image graphics: graphics].
	messages addLast: (Message selector: #gdipGetImageGraphicsContext:graphics: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageHeight: image height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageHeight: image height: height].
	messages addLast: (Message selector: #gdipGetImageHeight:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageHorizontalResolution: image resolution: resolution
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageHorizontalResolution: image resolution: resolution].
	messages addLast: (Message selector: #gdipGetImageHorizontalResolution:resolution: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImagePalette: image palette: palette size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImagePalette: image palette: palette size: size].
	messages addLast: (Message selector: #gdipGetImagePalette:palette:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImagePaletteSize: image size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImagePaletteSize: image size: size].
	messages addLast: (Message selector: #gdipGetImagePaletteSize:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImagePixelFormat: image format: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImagePixelFormat: image format: format].
	messages addLast: (Message selector: #gdipGetImagePixelFormat:format: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageRawFormat: image format: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageRawFormat: image format: format].
	messages addLast: (Message selector: #gdipGetImageRawFormat:format: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageThumbnail: image thumbWidth: thumbWidth thumbHeight: thumbHeight thumbImage: thumbImage pfnCallback: pfnCallback callbackData: callbackData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageThumbnail: image thumbWidth: thumbWidth thumbHeight: thumbHeight thumbImage: thumbImage pfnCallback: pfnCallback callbackData: callbackData].
	messages addLast: (Message selector: #gdipGetImageThumbnail:thumbWidth:thumbHeight:thumbImage:pfnCallback:callbackData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageType: image type: type
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageType: image type: type].
	messages addLast: (Message selector: #gdipGetImageType:type: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageVerticalResolution: image resolution: resolution
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageVerticalResolution: image resolution: resolution].
	messages addLast: (Message selector: #gdipGetImageVerticalResolution:resolution: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetImageWidth: image width: width
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetImageWidth: image width: width].
	messages addLast: (Message selector: #gdipGetImageWidth:width: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetInterpolationMode: graphics interpolationMode: interpolationMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetInterpolationMode: graphics interpolationMode: interpolationMode].
	messages addLast: (Message selector: #gdipGetInterpolationMode:interpolationMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipGetLineBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineBlendCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineBlendCount: brush count: count].
	messages addLast: (Message selector: #gdipGetLineBlendCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineColors: brush colors: colors
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineColors: brush colors: colors].
	messages addLast: (Message selector: #gdipGetLineColors:colors: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection].
	messages addLast: (Message selector: #gdipGetLineGammaCorrection:useGammaCorrection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLinePresetBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLinePresetBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipGetLinePresetBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLinePresetBlendCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLinePresetBlendCount: brush count: count].
	messages addLast: (Message selector: #gdipGetLinePresetBlendCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineRect: brush rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineRect: brush rect: rect].
	messages addLast: (Message selector: #gdipGetLineRect:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineRectI: brush rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineRectI: brush rect: rect].
	messages addLast: (Message selector: #gdipGetLineRectI:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineSpacing: family style: style lineSpacing: lineSpacing
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineSpacing: family style: style lineSpacing: lineSpacing].
	messages addLast: (Message selector: #gdipGetLineSpacing:style:lineSpacing: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipGetLineTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLineWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLineWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipGetLineWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLogFontA: font graphics: graphics logfonta: logfonta
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLogFontA: font graphics: graphics logfonta: logfonta].
	messages addLast: (Message selector: #gdipGetLogFontA:graphics:logfonta: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetLogFontW: font graphics: graphics logfonta: logfonta
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetLogFontW: font graphics: graphics logfonta: logfonta].
	messages addLast: (Message selector: #gdipGetLogFontW:graphics:logfonta: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMatrixElements: matrix matrixOut: matrixOut
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMatrixElements: matrix matrixOut: matrixOut].
	messages addLast: (Message selector: #gdipGetMatrixElements:matrixOut: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi].
	messages addLast: (Message selector: #gdipGetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileHeaderFromEmf: hEmf header: header
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileHeaderFromEmf: hEmf header: header].
	messages addLast: (Message selector: #gdipGetMetafileHeaderFromEmf:header: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileHeaderFromFile: filename header: header
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileHeaderFromFile: filename header: header].
	messages addLast: (Message selector: #gdipGetMetafileHeaderFromFile:header: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileHeaderFromMetafile: metafile header: header
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileHeaderFromMetafile: metafile header: header].
	messages addLast: (Message selector: #gdipGetMetafileHeaderFromMetafile:header: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileHeaderFromStream: stream header: header
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileHeaderFromStream: stream header: header].
	messages addLast: (Message selector: #gdipGetMetafileHeaderFromStream:header: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetMetafileHeaderFromWmf: hWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader header: header
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetMetafileHeaderFromWmf: hWmf wmfPlaceableFileHeader: wmfPlaceableFileHeader header: header].
	messages addLast: (Message selector: #gdipGetMetafileHeaderFromWmf:wmfPlaceableFileHeader:header: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetNearestColor: graphics argb: argb
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetNearestColor: graphics argb: argb].
	messages addLast: (Message selector: #gdipGetNearestColor:argb: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPageScale: graphics scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPageScale: graphics scale: scale].
	messages addLast: (Message selector: #gdipGetPageScale:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPageUnit: graphics unit: unit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPageUnit: graphics unit: unit].
	messages addLast: (Message selector: #gdipGetPageUnit:unit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathData: path pathData: pathData
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathData: path pathData: pathData].
	messages addLast: (Message selector: #gdipGetPathData:pathData: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathFillMode: path fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathFillMode: path fillMode: fillMode].
	messages addLast: (Message selector: #gdipGetPathFillMode:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipGetPathGradientBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientBlendCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientBlendCount: brush count: count].
	messages addLast: (Message selector: #gdipGetPathGradientBlendCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientCenterColor: brush colors: colors
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientCenterColor: brush colors: colors].
	messages addLast: (Message selector: #gdipGetPathGradientCenterColor:colors: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientCenterPoint: brush points: points
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientCenterPoint: brush points: points].
	messages addLast: (Message selector: #gdipGetPathGradientCenterPoint:points: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientCenterPointI: brush points: points
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientCenterPointI: brush points: points].
	messages addLast: (Message selector: #gdipGetPathGradientCenterPointI:points: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientFocusScales: brush xScale: xScale yScale: yScale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientFocusScales: brush xScale: xScale yScale: yScale].
	messages addLast: (Message selector: #gdipGetPathGradientFocusScales:xScale:yScale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection].
	messages addLast: (Message selector: #gdipGetPathGradientGammaCorrection:useGammaCorrection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientPath: brush path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientPath: brush path: path].
	messages addLast: (Message selector: #gdipGetPathGradientPath:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientPointCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientPointCount: brush count: count].
	messages addLast: (Message selector: #gdipGetPathGradientPointCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientPresetBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientPresetBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipGetPathGradientPresetBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientPresetBlendCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientPresetBlendCount: brush count: count].
	messages addLast: (Message selector: #gdipGetPathGradientPresetBlendCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientRect: brush rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientRect: brush rect: rect].
	messages addLast: (Message selector: #gdipGetPathGradientRect:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientRectI: brush rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientRectI: brush rect: rect].
	messages addLast: (Message selector: #gdipGetPathGradientRectI:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientSurroundColorCount: brush count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientSurroundColorCount: brush count: count].
	messages addLast: (Message selector: #gdipGetPathGradientSurroundColorCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientSurroundColorsWithCount: brush color: color count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientSurroundColorsWithCount: brush color: color count: count].
	messages addLast: (Message selector: #gdipGetPathGradientSurroundColorsWithCount:color:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipGetPathGradientTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathGradientWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathGradientWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipGetPathGradientWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathLastPoint: path lastPoint: lastPoint
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathLastPoint: path lastPoint: lastPoint].
	messages addLast: (Message selector: #gdipGetPathLastPoint:lastPoint: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathPoints: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathPoints: path points: points count: count].
	messages addLast: (Message selector: #gdipGetPathPoints:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathPointsI: path points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathPointsI: path points: points count: count].
	messages addLast: (Message selector: #gdipGetPathPointsI:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathTypes: path types: types count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathTypes: path types: types count: count].
	messages addLast: (Message selector: #gdipGetPathTypes:types:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathWorldBounds: path bounds: bounds matrix: matrix pen: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathWorldBounds: path bounds: bounds matrix: matrix pen: pen].
	messages addLast: (Message selector: #gdipGetPathWorldBounds:bounds:matrix:pen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPathWorldBoundsI: path bounds: bounds matrix: matrix pen: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPathWorldBoundsI: path bounds: bounds matrix: matrix pen: pen].
	messages addLast: (Message selector: #gdipGetPathWorldBoundsI:bounds:matrix:pen: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenBrushFill: pen brush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenBrushFill: pen brush: brush].
	messages addLast: (Message selector: #gdipGetPenBrushFill:brush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenColor: pen argb: argb
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenColor: pen argb: argb].
	messages addLast: (Message selector: #gdipGetPenColor:argb: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenCompoundArray: pen dash: dash count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenCompoundArray: pen dash: dash count: count].
	messages addLast: (Message selector: #gdipGetPenCompoundArray:dash:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenCompoundCount: pen count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenCompoundCount: pen count: count].
	messages addLast: (Message selector: #gdipGetPenCompoundCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenCustomEndCap: pen customCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenCustomEndCap: pen customCap: customCap].
	messages addLast: (Message selector: #gdipGetPenCustomEndCap:customCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenCustomStartCap: pen customCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenCustomStartCap: pen customCap: customCap].
	messages addLast: (Message selector: #gdipGetPenCustomStartCap:customCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenDashArray: pen dash: dash count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenDashArray: pen dash: dash count: count].
	messages addLast: (Message selector: #gdipGetPenDashArray:dash:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenDashCap197819: pen dashCap: dashCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenDashCap197819: pen dashCap: dashCap].
	messages addLast: (Message selector: #gdipGetPenDashCap197819:dashCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenDashCount: pen count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenDashCount: pen count: count].
	messages addLast: (Message selector: #gdipGetPenDashCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenDashOffset: pen offset: offset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenDashOffset: pen offset: offset].
	messages addLast: (Message selector: #gdipGetPenDashOffset:offset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenDashStyle: pen dashStyle: dashStyle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenDashStyle: pen dashStyle: dashStyle].
	messages addLast: (Message selector: #gdipGetPenDashStyle:dashStyle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenEndCap: pen endCap: endCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenEndCap: pen endCap: endCap].
	messages addLast: (Message selector: #gdipGetPenEndCap:endCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenFillType: pen type: type
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenFillType: pen type: type].
	messages addLast: (Message selector: #gdipGetPenFillType:type: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenLineJoin: pen lineJoin: lineJoin
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenLineJoin: pen lineJoin: lineJoin].
	messages addLast: (Message selector: #gdipGetPenLineJoin:lineJoin: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenMiterLimit: pen miterLimit: miterLimit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenMiterLimit: pen miterLimit: miterLimit].
	messages addLast: (Message selector: #gdipGetPenMiterLimit:miterLimit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenMode: pen penMode: penMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenMode: pen penMode: penMode].
	messages addLast: (Message selector: #gdipGetPenMode:penMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenStartCap: pen startCap: startCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenStartCap: pen startCap: startCap].
	messages addLast: (Message selector: #gdipGetPenStartCap:startCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenTransform: pen matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenTransform: pen matrix: matrix].
	messages addLast: (Message selector: #gdipGetPenTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenUnit: pen unit: unit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenUnit: pen unit: unit].
	messages addLast: (Message selector: #gdipGetPenUnit:unit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPenWidth: pen width: width
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPenWidth: pen width: width].
	messages addLast: (Message selector: #gdipGetPenWidth:width: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode].
	messages addLast: (Message selector: #gdipGetPixelOffsetMode:pixelOffsetMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPointCount: path count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPointCount: path count: count].
	messages addLast: (Message selector: #gdipGetPointCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPropertyCount: image numOfProperty: numOfProperty
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPropertyCount: image numOfProperty: numOfProperty].
	messages addLast: (Message selector: #gdipGetPropertyCount:numOfProperty: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPropertyIdList: image numOfProperty: numOfProperty list: list
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPropertyIdList: image numOfProperty: numOfProperty list: list].
	messages addLast: (Message selector: #gdipGetPropertyIdList:numOfProperty:list: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPropertyItem: image propId: propId propSize: propSize buffer: buffer
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPropertyItem: image propId: propId propSize: propSize buffer: buffer].
	messages addLast: (Message selector: #gdipGetPropertyItem:propId:propSize:buffer: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPropertyItemSize: image propId: propId size: size
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPropertyItemSize: image propId: propId size: size].
	messages addLast: (Message selector: #gdipGetPropertyItemSize:propId:size: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetPropertySize: image totalBufferSize: totalBufferSize numProperties: numProperties
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetPropertySize: image totalBufferSize: totalBufferSize numProperties: numProperties].
	messages addLast: (Message selector: #gdipGetPropertySize:totalBufferSize:numProperties: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionBounds: region graphics: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionBounds: region graphics: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetRegionBounds:graphics:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionBoundsI: region graphics: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionBoundsI: region graphics: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetRegionBoundsI:graphics:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionData: region buffer: buffer bufferSize: bufferSize sizeFilled: sizeFilled
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionData: region buffer: buffer bufferSize: bufferSize sizeFilled: sizeFilled].
	messages addLast: (Message selector: #gdipGetRegionData:buffer:bufferSize:sizeFilled: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionDataSize: region bufferSize: bufferSize
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionDataSize: region bufferSize: bufferSize].
	messages addLast: (Message selector: #gdipGetRegionDataSize:bufferSize: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionHRgn: region graphics: graphics hRgn: hRgn
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionHRgn: region graphics: graphics hRgn: hRgn].
	messages addLast: (Message selector: #gdipGetRegionHRgn:graphics:hRgn: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionScans: region rects: rects count: count matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionScans: region rects: rects count: count matrix: matrix].
	messages addLast: (Message selector: #gdipGetRegionScans:rects:count:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionScansCount: region count: count matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionScansCount: region count: count matrix: matrix].
	messages addLast: (Message selector: #gdipGetRegionScansCount:count:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRegionScansI: region rects: rects count: count matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRegionScansI: region rects: rects count: count matrix: matrix].
	messages addLast: (Message selector: #gdipGetRegionScansI:rects:count:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetRenderingOrigin: graphics x: x y: y
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetRenderingOrigin: graphics x: x y: y].
	messages addLast: (Message selector: #gdipGetRenderingOrigin:x:y: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetSmoothingMode: graphics smoothingMode: smoothingMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetSmoothingMode: graphics smoothingMode: smoothingMode].
	messages addLast: (Message selector: #gdipGetSmoothingMode:smoothingMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetSolidFillColor: brush color: color
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetSolidFillColor: brush color: color].
	messages addLast: (Message selector: #gdipGetSolidFillColor:color: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatAlign: format align: align
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatAlign: format align: align].
	messages addLast: (Message selector: #gdipGetStringFormatAlign:align: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatDigitSubstitution: format language: language substitute: substitute
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatDigitSubstitution: format language: language substitute: substitute].
	messages addLast: (Message selector: #gdipGetStringFormatDigitSubstitution:language:substitute: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatFlags: format flags: flags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatFlags: format flags: flags].
	messages addLast: (Message selector: #gdipGetStringFormatFlags:flags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix].
	messages addLast: (Message selector: #gdipGetStringFormatHotkeyPrefix:hotkeyPrefix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatLineAlign: format align: align
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatLineAlign: format align: align].
	messages addLast: (Message selector: #gdipGetStringFormatLineAlign:align: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatMeasurableCharacterRangeCount: format count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatMeasurableCharacterRangeCount: format count: count].
	messages addLast: (Message selector: #gdipGetStringFormatMeasurableCharacterRangeCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatTabStopCount: format count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatTabStopCount: format count: count].
	messages addLast: (Message selector: #gdipGetStringFormatTabStopCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatTabStops: format count: count firstTabOffset: firstTabOffset tabStops: tabStops
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatTabStops: format count: count firstTabOffset: firstTabOffset tabStops: tabStops].
	messages addLast: (Message selector: #gdipGetStringFormatTabStops:count:firstTabOffset:tabStops: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetStringFormatTrimming: format trimming: trimming
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetStringFormatTrimming: format trimming: trimming].
	messages addLast: (Message selector: #gdipGetStringFormatTrimming:trimming: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetTextContrast: graphics contrast: contrast
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetTextContrast: graphics contrast: contrast].
	messages addLast: (Message selector: #gdipGetTextContrast:contrast: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetTextRenderingHint: graphics mode: mode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetTextRenderingHint: graphics mode: mode].
	messages addLast: (Message selector: #gdipGetTextRenderingHint:mode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetTextureImage: brush image: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetTextureImage: brush image: image].
	messages addLast: (Message selector: #gdipGetTextureImage:image: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetTextureTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetTextureTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipGetTextureTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetTextureWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetTextureWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipGetTextureWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetVisibleClipBounds: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetVisibleClipBounds: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetVisibleClipBounds:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetVisibleClipBoundsI: graphics rect: rect
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetVisibleClipBoundsI: graphics rect: rect].
	messages addLast: (Message selector: #gdipGetVisibleClipBoundsI:rect: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGetWorldTransform: graphics matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGetWorldTransform: graphics matrix: matrix].
	messages addLast: (Message selector: #gdipGetWorldTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipGraphicsClear: graphics color: color
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipGraphicsClear: graphics color: color].
	messages addLast: (Message selector: #gdipGraphicsClear:color: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageForceValidation: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageForceValidation: image].
	messages addLast: (Message selector: #gdipImageForceValidation: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageGetFrameCount: image dimensionID: dimensionID count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageGetFrameCount: image dimensionID: dimensionID count: count].
	messages addLast: (Message selector: #gdipImageGetFrameCount:dimensionID:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageGetFrameDimensionsCount: image count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageGetFrameDimensionsCount: image count: count].
	messages addLast: (Message selector: #gdipImageGetFrameDimensionsCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageGetFrameDimensionsList: image dimensionIDs: dimensionIDs count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageGetFrameDimensionsList: image dimensionIDs: dimensionIDs count: count].
	messages addLast: (Message selector: #gdipImageGetFrameDimensionsList:dimensionIDs:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageRotateFlip: image rfType: rfType
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageRotateFlip: image rfType: rfType].
	messages addLast: (Message selector: #gdipImageRotateFlip:rfType: arguments: activeProc topFrame arguments).
	^S_OK!

gdipImageSelectActiveFrame: image dimensionID: dimensionID frameIndex: frameIndex
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipImageSelectActiveFrame: image dimensionID: dimensionID frameIndex: frameIndex].
	messages addLast: (Message selector: #gdipImageSelectActiveFrame:dimensionID:frameIndex: arguments: activeProc topFrame arguments).
	^S_OK!

gdipInvertMatrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipInvertMatrix: matrix].
	messages addLast: (Message selector: #gdipInvertMatrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsClipEmpty: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsClipEmpty: graphics result: result].
	messages addLast: (Message selector: #gdipIsClipEmpty:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsEmptyRegion: region graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsEmptyRegion: region graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsEmptyRegion:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsEqualRegion: region region2: region2 graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsEqualRegion: region region2: region2 graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsEqualRegion:region2:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsInfiniteRegion: region graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsInfiniteRegion: region graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsInfiniteRegion:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsMatrixEqual: matrix matrix2: matrix2 result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsMatrixEqual: matrix matrix2: matrix2 result: result].
	messages addLast: (Message selector: #gdipIsMatrixEqual:matrix2:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsMatrixIdentity: matrix result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsMatrixIdentity: matrix result: result].
	messages addLast: (Message selector: #gdipIsMatrixIdentity:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsMatrixInvertible: matrix result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsMatrixInvertible: matrix result: result].
	messages addLast: (Message selector: #gdipIsMatrixInvertible:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsOutlineVisiblePathPoint: path x: x y: y pen: pen graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsOutlineVisiblePathPoint: path x: x y: y pen: pen graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsOutlineVisiblePathPoint:x:y:pen:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsOutlineVisiblePathPointI: path x: x y: y pen: pen graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsOutlineVisiblePathPointI: path x: x y: y pen: pen graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsOutlineVisiblePathPointI:x:y:pen:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsStyleAvailable: family style: style isStyleAvailable: isStyleAvailable
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsStyleAvailable: family style: style isStyleAvailable: isStyleAvailable].
	messages addLast: (Message selector: #gdipIsStyleAvailable:style:isStyleAvailable: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleClipEmpty: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleClipEmpty: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisibleClipEmpty:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisiblePathPoint: path x: x y: y graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisiblePathPoint: path x: x y: y graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisiblePathPoint:x:y:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisiblePathPointI: path x: x y: y graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisiblePathPointI: path x: x y: y graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisiblePathPointI:x:y:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisiblePoint: graphics x: x y: y result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisiblePoint: graphics x: x y: y result: result].
	messages addLast: (Message selector: #gdipIsVisiblePoint:x:y:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisiblePointI: graphics x: x y: y result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisiblePointI: graphics x: x y: y result: result].
	messages addLast: (Message selector: #gdipIsVisiblePointI:x:y:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRect: graphics x: x y: y width: width height: height result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRect: graphics x: x y: y width: width height: height result: result].
	messages addLast: (Message selector: #gdipIsVisibleRect:x:y:width:height:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRectI: graphics x: x y: y width: width height: height result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRectI: graphics x: x y: y width: width height: height result: result].
	messages addLast: (Message selector: #gdipIsVisibleRectI:x:y:width:height:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRegionPoint: region x: x y: y graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRegionPoint: region x: x y: y graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisibleRegionPoint:x:y:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRegionPointI: region x: x y: y graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRegionPointI: region x: x y: y graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisibleRegionPointI:x:y:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRegionRect: region x: x y: y width: width height: height graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRegionRect: region x: x y: y width: width height: height graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisibleRegionRect:x:y:width:height:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipIsVisibleRegionRectI: region x: x y: y width: width height: height graphics: graphics result: result
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipIsVisibleRegionRectI: region x: x y: y width: width height: height graphics: graphics result: result].
	messages addLast: (Message selector: #gdipIsVisibleRegionRectI:x:y:width:height:graphics:result: arguments: activeProc topFrame arguments).
	^S_OK!

gdipLoadImageFromFile: filename image: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipLoadImageFromFile: filename image: image].
	messages addLast: (Message selector: #gdipLoadImageFromFile:image: arguments: activeProc topFrame arguments).
	^S_OK!

gdipLoadImageFromFileICM: filename image: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipLoadImageFromFileICM: filename image: image].
	messages addLast: (Message selector: #gdipLoadImageFromFileICM:image: arguments: activeProc topFrame arguments).
	^S_OK!

gdipLoadImageFromStream: stream image: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipLoadImageFromStream: stream image: image].
	messages addLast: (Message selector: #gdipLoadImageFromStream:image: arguments: activeProc topFrame arguments).
	^S_OK!

gdipLoadImageFromStreamICM: stream image: image
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipLoadImageFromStreamICM: stream image: image].
	messages addLast: (Message selector: #gdipLoadImageFromStreamICM:image: arguments: activeProc topFrame arguments).
	^S_OK!

gdiplusNotificationHook: token1
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdiplusNotificationHook: token1].
	messages addLast: (Message selector: #gdiplusNotificationHook: arguments: activeProc topFrame arguments).
	^S_OK!

gdiplusNotificationUnhook: token1
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdiplusNotificationUnhook: token1].
	messages addLast: (Message selector: #gdiplusNotificationUnhook: arguments: activeProc topFrame arguments).
	^S_OK!

gdiplusShutdown: token1
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdiplusShutdown: token1].
	messages addLast: (Message selector: #gdiplusShutdown: arguments: activeProc topFrame arguments).
	^S_OK!

gdiplusStartup: token1 input: input output: output
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdiplusStartup: token1 input: input output: output].
	messages addLast: (Message selector: #gdiplusStartup:input:output: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMeasureCharacterRanges: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat regionCount: regionCount regions: regions
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMeasureCharacterRanges: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat regionCount: regionCount regions: regions].
	messages addLast: (Message selector: #gdipMeasureCharacterRanges:str:length:font:layoutRect:stringFormat:regionCount:regions: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMeasureDriverString: graphics text: text length: length font: font positions: positions flags: flags matrix: matrix boundingBox: boundingBox
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMeasureDriverString: graphics text: text length: length font: font positions: positions flags: flags matrix: matrix boundingBox: boundingBox].
	messages addLast: (Message selector: #gdipMeasureDriverString:text:length:font:positions:flags:matrix:boundingBox: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMeasureString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat boundingBox: boundingBox codepointsFitted: codepointsFitted linesFilled: linesFilled
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMeasureString: graphics str: str length: length font: font layoutRect: layoutRect stringFormat: stringFormat boundingBox: boundingBox codepointsFitted: codepointsFitted linesFilled: linesFilled].
	messages addLast: (Message selector: #gdipMeasureString:str:length:font:layoutRect:stringFormat:boundingBox:codepointsFitted:linesFilled: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyLineTransform: brush matrix: matrix order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyLineTransform: brush matrix: matrix order: order].
	messages addLast: (Message selector: #gdipMultiplyLineTransform:matrix:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyMatrix: matrix matrix2: matrix2 order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyMatrix: matrix matrix2: matrix2 order: order].
	messages addLast: (Message selector: #gdipMultiplyMatrix:matrix2:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyPathGradientTransform: brush matrix: matrix order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyPathGradientTransform: brush matrix: matrix order: order].
	messages addLast: (Message selector: #gdipMultiplyPathGradientTransform:matrix:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyPenTransform: pen matrix: matrix order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyPenTransform: pen matrix: matrix order: order].
	messages addLast: (Message selector: #gdipMultiplyPenTransform:matrix:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyTextureTransform: brush matrix: matrix order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyTextureTransform: brush matrix: matrix order: order].
	messages addLast: (Message selector: #gdipMultiplyTextureTransform:matrix:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipMultiplyWorldTransform: graphics matrix: matrix order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipMultiplyWorldTransform: graphics matrix: matrix order: order].
	messages addLast: (Message selector: #gdipMultiplyWorldTransform:matrix:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipNewInstalledFontCollection: fontCollection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipNewInstalledFontCollection: fontCollection].
	messages addLast: (Message selector: #gdipNewInstalledFontCollection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipNewPrivateFontCollection: fontCollection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipNewPrivateFontCollection: fontCollection].
	messages addLast: (Message selector: #gdipNewPrivateFontCollection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterCopyData: iterator resultCount: resultCount points: points types: types startIndex: startIndex endIndex: endIndex
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterCopyData: iterator resultCount: resultCount points: points types: types startIndex: startIndex endIndex: endIndex].
	messages addLast: (Message selector: #gdipPathIterCopyData:resultCount:points:types:startIndex:endIndex: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterEnumerate: iterator resultCount: resultCount points: points types: types count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterEnumerate: iterator resultCount: resultCount points: points types: types count: count].
	messages addLast: (Message selector: #gdipPathIterEnumerate:resultCount:points:types:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterGetCount: iterator count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterGetCount: iterator count: count].
	messages addLast: (Message selector: #gdipPathIterGetCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterGetSubpathCount: iterator count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterGetSubpathCount: iterator count: count].
	messages addLast: (Message selector: #gdipPathIterGetSubpathCount:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterHasCurve: iterator hasCurve: hasCurve
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterHasCurve: iterator hasCurve: hasCurve].
	messages addLast: (Message selector: #gdipPathIterHasCurve:hasCurve: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterIsValid: iterator valid: valid
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterIsValid: iterator valid: valid].
	messages addLast: (Message selector: #gdipPathIterIsValid:valid: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterNextMarker: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterNextMarker: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex].
	messages addLast: (Message selector: #gdipPathIterNextMarker:resultCount:startIndex:endIndex: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterNextMarkerPath: iterator resultCount: resultCount path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterNextMarkerPath: iterator resultCount: resultCount path: path].
	messages addLast: (Message selector: #gdipPathIterNextMarkerPath:resultCount:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterNextPathType: iterator resultCount: resultCount pathType: pathType startIndex: startIndex endIndex: endIndex
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterNextPathType: iterator resultCount: resultCount pathType: pathType startIndex: startIndex endIndex: endIndex].
	messages addLast: (Message selector: #gdipPathIterNextPathType:resultCount:pathType:startIndex:endIndex: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterNextSubpath: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex isClosed: isClosed
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterNextSubpath: iterator resultCount: resultCount startIndex: startIndex endIndex: endIndex isClosed: isClosed].
	messages addLast: (Message selector: #gdipPathIterNextSubpath:resultCount:startIndex:endIndex:isClosed: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterNextSubpathPath: iterator resultCount: resultCount path: path isClosed: isClosed
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterNextSubpathPath: iterator resultCount: resultCount path: path isClosed: isClosed].
	messages addLast: (Message selector: #gdipPathIterNextSubpathPath:resultCount:path:isClosed: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPathIterRewind: iterator
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPathIterRewind: iterator].
	messages addLast: (Message selector: #gdipPathIterRewind: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPlayMetafileRecord: metafile recordType: recordType flags: flags dataSize: dataSize data: data
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPlayMetafileRecord: metafile recordType: recordType flags: flags dataSize: dataSize data: data].
	messages addLast: (Message selector: #gdipPlayMetafileRecord:recordType:flags:dataSize:data: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPrivateAddFontFile: fontCollection filename: filename
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPrivateAddFontFile: fontCollection filename: filename].
	messages addLast: (Message selector: #gdipPrivateAddFontFile:filename: arguments: activeProc topFrame arguments).
	^S_OK!

gdipPrivateAddMemoryFont: fontCollection memory: memory length: length
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipPrivateAddMemoryFont: fontCollection memory: memory length: length].
	messages addLast: (Message selector: #gdipPrivateAddMemoryFont:memory:length: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafile: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafile: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafile:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafileFileName: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafileFileName: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafileFileName:referenceHdc:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafileFileNameI: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafileFileNameI: filename referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafileFileNameI:referenceHdc:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafileI: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafileI: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafileI:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafileStream: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafileStream: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafileStream:referenceHdc:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRecordMetafileStreamI: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRecordMetafileStreamI: stream referenceHdc: referenceHdc type: type frameRect: frameRect frameUnit: frameUnit description: description metafile: metafile].
	messages addLast: (Message selector: #gdipRecordMetafileStreamI:referenceHdc:type:frameRect:frameUnit:description:metafile: arguments: activeProc topFrame arguments).
	^S_OK!

gdipReleaseDC: graphics hdc: hdc
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipReleaseDC: graphics hdc: hdc].
	messages addLast: (Message selector: #gdipReleaseDC:hdc: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRemovePropertyItem: image propId: propId
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRemovePropertyItem: image propId: propId].
	messages addLast: (Message selector: #gdipRemovePropertyItem:propId: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetClip: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetClip: graphics].
	messages addLast: (Message selector: #gdipResetClip: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetImageAttributes: imageattr type: type
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetImageAttributes: imageattr type: type].
	messages addLast: (Message selector: #gdipResetImageAttributes:type: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetLineTransform: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetLineTransform: brush].
	messages addLast: (Message selector: #gdipResetLineTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetPageTransform: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetPageTransform: graphics].
	messages addLast: (Message selector: #gdipResetPageTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetPath: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetPath: path].
	messages addLast: (Message selector: #gdipResetPath: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetPathGradientTransform: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetPathGradientTransform: brush].
	messages addLast: (Message selector: #gdipResetPathGradientTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetPenTransform: pen
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetPenTransform: pen].
	messages addLast: (Message selector: #gdipResetPenTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetTextureTransform: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetTextureTransform: brush].
	messages addLast: (Message selector: #gdipResetTextureTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipResetWorldTransform: graphics
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipResetWorldTransform: graphics].
	messages addLast: (Message selector: #gdipResetWorldTransform: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRestoreGraphics: graphics state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRestoreGraphics: graphics state: state].
	messages addLast: (Message selector: #gdipRestoreGraphics:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipReversePath: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipReversePath: path].
	messages addLast: (Message selector: #gdipReversePath: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotateLineTransform: brush angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotateLineTransform: brush angle: angle order: order].
	messages addLast: (Message selector: #gdipRotateLineTransform:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotateMatrix: matrix angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotateMatrix: matrix angle: angle order: order].
	messages addLast: (Message selector: #gdipRotateMatrix:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotatePathGradientTransform: brush angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotatePathGradientTransform: brush angle: angle order: order].
	messages addLast: (Message selector: #gdipRotatePathGradientTransform:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotatePenTransform: pen angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotatePenTransform: pen angle: angle order: order].
	messages addLast: (Message selector: #gdipRotatePenTransform:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotateTextureTransform: brush angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotateTextureTransform: brush angle: angle order: order].
	messages addLast: (Message selector: #gdipRotateTextureTransform:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipRotateWorldTransform: graphics angle: angle order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipRotateWorldTransform: graphics angle: angle order: order].
	messages addLast: (Message selector: #gdipRotateWorldTransform:angle:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSaveAdd: image encoderParams: encoderParams
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSaveAdd: image encoderParams: encoderParams].
	messages addLast: (Message selector: #gdipSaveAdd:encoderParams: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSaveAddImage: image newImage: newImage encoderParams: encoderParams
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSaveAddImage: image newImage: newImage encoderParams: encoderParams].
	messages addLast: (Message selector: #gdipSaveAddImage:newImage:encoderParams: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSaveGraphics: graphics state: state
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSaveGraphics: graphics state: state].
	messages addLast: (Message selector: #gdipSaveGraphics:state: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSaveImageToFile: image filename: filename clsidEncoder: clsidEncoder encoderParams: encoderParams
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSaveImageToFile: image filename: filename clsidEncoder: clsidEncoder encoderParams: encoderParams].
	messages addLast: (Message selector: #gdipSaveImageToFile:filename:clsidEncoder:encoderParams: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSaveImageToStream: image stream: stream clsidEncoder: clsidEncoder encoderParams: encoderParams
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSaveImageToStream: image stream: stream clsidEncoder: clsidEncoder encoderParams: encoderParams].
	messages addLast: (Message selector: #gdipSaveImageToStream:stream:clsidEncoder:encoderParams: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScaleLineTransform: brush sx: sx sy: sy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScaleLineTransform: brush sx: sx sy: sy order: order].
	messages addLast: (Message selector: #gdipScaleLineTransform:sx:sy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScaleMatrix: matrix scaleX: scaleX scaleY: scaleY order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScaleMatrix: matrix scaleX: scaleX scaleY: scaleY order: order].
	messages addLast: (Message selector: #gdipScaleMatrix:scaleX:scaleY:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScalePathGradientTransform: brush sx: sx sy: sy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScalePathGradientTransform: brush sx: sx sy: sy order: order].
	messages addLast: (Message selector: #gdipScalePathGradientTransform:sx:sy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScalePenTransform: pen sx: sx sy: sy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScalePenTransform: pen sx: sx sy: sy order: order].
	messages addLast: (Message selector: #gdipScalePenTransform:sx:sy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScaleTextureTransform: brush sx: sx sy: sy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScaleTextureTransform: brush sx: sx sy: sy order: order].
	messages addLast: (Message selector: #gdipScaleTextureTransform:sx:sy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipScaleWorldTransform: graphics sx: sx sy: sy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipScaleWorldTransform: graphics sx: sx sy: sy order: order].
	messages addLast: (Message selector: #gdipScaleWorldTransform:sx:sy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetAdjustableArrowCapFillState: cap fillState: fillState
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetAdjustableArrowCapFillState: cap fillState: fillState].
	messages addLast: (Message selector: #gdipSetAdjustableArrowCapFillState:fillState: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetAdjustableArrowCapHeight: cap height: height
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetAdjustableArrowCapHeight: cap height: height].
	messages addLast: (Message selector: #gdipSetAdjustableArrowCapHeight:height: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetAdjustableArrowCapMiddleInset: cap middleInset: middleInset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetAdjustableArrowCapMiddleInset: cap middleInset: middleInset].
	messages addLast: (Message selector: #gdipSetAdjustableArrowCapMiddleInset:middleInset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetAdjustableArrowCapWidth: cap width: width
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetAdjustableArrowCapWidth: cap width: width].
	messages addLast: (Message selector: #gdipSetAdjustableArrowCapWidth:width: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipGraphics: graphics srcgraphics: srcgraphics combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipGraphics: graphics srcgraphics: srcgraphics combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipGraphics:srcgraphics:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipHrgn: graphics hRgn: hRgn combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipHrgn: graphics hRgn: hRgn combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipHrgn:hRgn:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipPath: graphics path: path combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipPath: graphics path: path combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipPath:path:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipRect: graphics x: x y: y width: width height: height combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipRect: graphics x: x y: y width: width height: height combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipRect:x:y:width:height:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipRectI: graphics x: x y: y width: width height: height combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipRectI: graphics x: x y: y width: width height: height combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipRectI:x:y:width:height:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetClipRegion: graphics region: region combineMode: combineMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetClipRegion: graphics region: region combineMode: combineMode].
	messages addLast: (Message selector: #gdipSetClipRegion:region:combineMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCompositingMode: graphics compositingMode: compositingMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCompositingMode: graphics compositingMode: compositingMode].
	messages addLast: (Message selector: #gdipSetCompositingMode:compositingMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCompositingQuality: graphics compositingQuality: compositingQuality
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCompositingQuality: graphics compositingQuality: compositingQuality].
	messages addLast: (Message selector: #gdipSetCompositingQuality:compositingQuality: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCustomLineCapBaseCap: customCap baseCap: baseCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCustomLineCapBaseCap: customCap baseCap: baseCap].
	messages addLast: (Message selector: #gdipSetCustomLineCapBaseCap:baseCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCustomLineCapBaseInset: customCap inset: inset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCustomLineCapBaseInset: customCap inset: inset].
	messages addLast: (Message selector: #gdipSetCustomLineCapBaseInset:inset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCustomLineCapStrokeCaps: customCap startCap: startCap endCap: endCap].
	messages addLast: (Message selector: #gdipSetCustomLineCapStrokeCaps:startCap:endCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCustomLineCapStrokeJoin: customCap lineJoin: lineJoin].
	messages addLast: (Message selector: #gdipSetCustomLineCapStrokeJoin:lineJoin: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetCustomLineCapWidthScale: customCap widthScale: widthScale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetCustomLineCapWidthScale: customCap widthScale: widthScale].
	messages addLast: (Message selector: #gdipSetCustomLineCapWidthScale:widthScale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetEmpty: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetEmpty: region].
	messages addLast: (Message selector: #gdipSetEmpty: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesCachedBackground: imageattr enableFlag: enableFlag
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesCachedBackground: imageattr enableFlag: enableFlag].
	messages addLast: (Message selector: #gdipSetImageAttributesCachedBackground:enableFlag: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesColorKeys: imageattr type: type enableFlag: enableFlag colorLow: colorLow colorHigh: colorHigh
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesColorKeys: imageattr type: type enableFlag: enableFlag colorLow: colorLow colorHigh: colorHigh].
	messages addLast: (Message selector: #gdipSetImageAttributesColorKeys:type:enableFlag:colorLow:colorHigh: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesColorMatrix: imageattr type: type enableFlag: enableFlag colorMatrix: colorMatrix grayMatrix: grayMatrix flags: flags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesColorMatrix: imageattr type: type enableFlag: enableFlag colorMatrix: colorMatrix grayMatrix: grayMatrix flags: flags].
	messages addLast: (Message selector: #gdipSetImageAttributesColorMatrix:type:enableFlag:colorMatrix:grayMatrix:flags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesGamma: imageattr type: type enableFlag: enableFlag gamma: gamma
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesGamma: imageattr type: type enableFlag: enableFlag gamma: gamma].
	messages addLast: (Message selector: #gdipSetImageAttributesGamma:type:enableFlag:gamma: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesICMMode: imageattr on: on
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesICMMode: imageattr on: on].
	messages addLast: (Message selector: #gdipSetImageAttributesICMMode:on: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesNoOp: imageattr type: type enableFlag: enableFlag
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesNoOp: imageattr type: type enableFlag: enableFlag].
	messages addLast: (Message selector: #gdipSetImageAttributesNoOp:type:enableFlag: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesOutputChannel: imageattr type: type enableFlag: enableFlag channelFlags: channelFlags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesOutputChannel: imageattr type: type enableFlag: enableFlag channelFlags: channelFlags].
	messages addLast: (Message selector: #gdipSetImageAttributesOutputChannel:type:enableFlag:channelFlags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesOutputChannelColorProfile: imageattr type: type enableFlag: enableFlag colorProfileFilename: colorProfileFilename
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesOutputChannelColorProfile: imageattr type: type enableFlag: enableFlag colorProfileFilename: colorProfileFilename].
	messages addLast: (Message selector: #gdipSetImageAttributesOutputChannelColorProfile:type:enableFlag:colorProfileFilename: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesRemapTable: imageattr type: type enableFlag: enableFlag mapSize: mapSize map: map
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesRemapTable: imageattr type: type enableFlag: enableFlag mapSize: mapSize map: map].
	messages addLast: (Message selector: #gdipSetImageAttributesRemapTable:type:enableFlag:mapSize:map: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesThreshold: imageattr type: type enableFlag: enableFlag threshold: threshold
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesThreshold: imageattr type: type enableFlag: enableFlag threshold: threshold].
	messages addLast: (Message selector: #gdipSetImageAttributesThreshold:type:enableFlag:threshold: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesToIdentity: imageattr type: type
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesToIdentity: imageattr type: type].
	messages addLast: (Message selector: #gdipSetImageAttributesToIdentity:type: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImageAttributesWrapMode: imageattr wrap: wrap argb: argb clamp: clamp
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImageAttributesWrapMode: imageattr wrap: wrap argb: argb clamp: clamp].
	messages addLast: (Message selector: #gdipSetImageAttributesWrapMode:wrap:argb:clamp: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetImagePalette: image palette: palette
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetImagePalette: image palette: palette].
	messages addLast: (Message selector: #gdipSetImagePalette:palette: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetInfinite: region
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetInfinite: region].
	messages addLast: (Message selector: #gdipSetInfinite: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetInterpolationMode: graphics interpolationMode: interpolationMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetInterpolationMode: graphics interpolationMode: interpolationMode].
	messages addLast: (Message selector: #gdipSetInterpolationMode:interpolationMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipSetLineBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineColors: brush color1: color1 color2: color2
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineColors: brush color1: color1 color2: color2].
	messages addLast: (Message selector: #gdipSetLineColors:color1:color2: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineGammaCorrection: brush useGammaCorrection: useGammaCorrection].
	messages addLast: (Message selector: #gdipSetLineGammaCorrection:useGammaCorrection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineLinearBlend: brush focus: focus scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineLinearBlend: brush focus: focus scale: scale].
	messages addLast: (Message selector: #gdipSetLineLinearBlend:focus:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLinePresetBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLinePresetBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipSetLinePresetBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineSigmaBlend: brush focus: focus scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineSigmaBlend: brush focus: focus scale: scale].
	messages addLast: (Message selector: #gdipSetLineSigmaBlend:focus:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipSetLineTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetLineWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetLineWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipSetLineWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetMatrixElements: matrix m11: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetMatrixElements: matrix m11: m11 m12: m12 m21: m21 m22: m22 dx: dx dy: dy].
	messages addLast: (Message selector: #gdipSetMatrixElements:m11:m12:m21:m22:dx:dy: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetMetafileDownLevelRasterizationLimit: metafile metafileRasterizationLimitDpi: metafileRasterizationLimitDpi].
	messages addLast: (Message selector: #gdipSetMetafileDownLevelRasterizationLimit:metafileRasterizationLimitDpi: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPageScale: graphics scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPageScale: graphics scale: scale].
	messages addLast: (Message selector: #gdipSetPageScale:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPageUnit: graphics unit: unit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPageUnit: graphics unit: unit].
	messages addLast: (Message selector: #gdipSetPageUnit:unit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathFillMode: path fillMode: fillMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathFillMode: path fillMode: fillMode].
	messages addLast: (Message selector: #gdipSetPathFillMode:fillMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipSetPathGradientBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientCenterColor: brush colors: colors
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientCenterColor: brush colors: colors].
	messages addLast: (Message selector: #gdipSetPathGradientCenterColor:colors: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientCenterPoint: brush points: points
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientCenterPoint: brush points: points].
	messages addLast: (Message selector: #gdipSetPathGradientCenterPoint:points: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientCenterPointI: brush points: points
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientCenterPointI: brush points: points].
	messages addLast: (Message selector: #gdipSetPathGradientCenterPointI:points: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientFocusScales: brush xScale: xScale yScale: yScale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientFocusScales: brush xScale: xScale yScale: yScale].
	messages addLast: (Message selector: #gdipSetPathGradientFocusScales:xScale:yScale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientGammaCorrection: brush useGammaCorrection: useGammaCorrection].
	messages addLast: (Message selector: #gdipSetPathGradientGammaCorrection:useGammaCorrection: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientLinearBlend: brush focus: focus scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientLinearBlend: brush focus: focus scale: scale].
	messages addLast: (Message selector: #gdipSetPathGradientLinearBlend:focus:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientPath: brush path: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientPath: brush path: path].
	messages addLast: (Message selector: #gdipSetPathGradientPath:path: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientPresetBlend: brush blend: blend positions: positions count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientPresetBlend: brush blend: blend positions: positions count: count].
	messages addLast: (Message selector: #gdipSetPathGradientPresetBlend:blend:positions:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientSigmaBlend: brush focus: focus scale: scale
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientSigmaBlend: brush focus: focus scale: scale].
	messages addLast: (Message selector: #gdipSetPathGradientSigmaBlend:focus:scale: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientSurroundColorsWithCount: brush color: color count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientSurroundColorsWithCount: brush color: color count: count].
	messages addLast: (Message selector: #gdipSetPathGradientSurroundColorsWithCount:color:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipSetPathGradientTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathGradientWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathGradientWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipSetPathGradientWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPathMarker: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPathMarker: path].
	messages addLast: (Message selector: #gdipSetPathMarker: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenBrushFill: pen brush: brush
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenBrushFill: pen brush: brush].
	messages addLast: (Message selector: #gdipSetPenBrushFill:brush: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenColor: pen argb: argb
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenColor: pen argb: argb].
	messages addLast: (Message selector: #gdipSetPenColor:argb: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenCompoundArray: pen dash: dash count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenCompoundArray: pen dash: dash count: count].
	messages addLast: (Message selector: #gdipSetPenCompoundArray:dash:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenCustomEndCap: pen customCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenCustomEndCap: pen customCap: customCap].
	messages addLast: (Message selector: #gdipSetPenCustomEndCap:customCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenCustomStartCap: pen customCap: customCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenCustomStartCap: pen customCap: customCap].
	messages addLast: (Message selector: #gdipSetPenCustomStartCap:customCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenDashArray: pen dash: dash count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenDashArray: pen dash: dash count: count].
	messages addLast: (Message selector: #gdipSetPenDashArray:dash:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenDashCap197819: pen dashCap: dashCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenDashCap197819: pen dashCap: dashCap].
	messages addLast: (Message selector: #gdipSetPenDashCap197819:dashCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenDashOffset: pen offset: offset
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenDashOffset: pen offset: offset].
	messages addLast: (Message selector: #gdipSetPenDashOffset:offset: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenDashStyle: pen dashStyle: dashStyle
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenDashStyle: pen dashStyle: dashStyle].
	messages addLast: (Message selector: #gdipSetPenDashStyle:dashStyle: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenEndCap: pen endCap: endCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenEndCap: pen endCap: endCap].
	messages addLast: (Message selector: #gdipSetPenEndCap:endCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenLineCap197819: pen startCap: startCap endCap: endCap dashCap: dashCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenLineCap197819: pen startCap: startCap endCap: endCap dashCap: dashCap].
	messages addLast: (Message selector: #gdipSetPenLineCap197819:startCap:endCap:dashCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenLineJoin: pen lineJoin: lineJoin
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenLineJoin: pen lineJoin: lineJoin].
	messages addLast: (Message selector: #gdipSetPenLineJoin:lineJoin: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenMiterLimit: pen miterLimit: miterLimit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenMiterLimit: pen miterLimit: miterLimit].
	messages addLast: (Message selector: #gdipSetPenMiterLimit:miterLimit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenMode: pen penMode: penMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenMode: pen penMode: penMode].
	messages addLast: (Message selector: #gdipSetPenMode:penMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenStartCap: pen startCap: startCap
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenStartCap: pen startCap: startCap].
	messages addLast: (Message selector: #gdipSetPenStartCap:startCap: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenTransform: pen matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenTransform: pen matrix: matrix].
	messages addLast: (Message selector: #gdipSetPenTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenUnit: pen unit: unit
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenUnit: pen unit: unit].
	messages addLast: (Message selector: #gdipSetPenUnit:unit: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPenWidth: pen width: width
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPenWidth: pen width: width].
	messages addLast: (Message selector: #gdipSetPenWidth:width: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPixelOffsetMode: graphics pixelOffsetMode: pixelOffsetMode].
	messages addLast: (Message selector: #gdipSetPixelOffsetMode:pixelOffsetMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetPropertyItem: image item: item
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetPropertyItem: image item: item].
	messages addLast: (Message selector: #gdipSetPropertyItem:item: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetRenderingOrigin: graphics x: x y: y
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetRenderingOrigin: graphics x: x y: y].
	messages addLast: (Message selector: #gdipSetRenderingOrigin:x:y: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetSmoothingMode: graphics smoothingMode: smoothingMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetSmoothingMode: graphics smoothingMode: smoothingMode].
	messages addLast: (Message selector: #gdipSetSmoothingMode:smoothingMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetSolidFillColor: brush color: color
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetSolidFillColor: brush color: color].
	messages addLast: (Message selector: #gdipSetSolidFillColor:color: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatAlign: format align: align
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatAlign: format align: align].
	messages addLast: (Message selector: #gdipSetStringFormatAlign:align: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatDigitSubstitution: format language: language substitute: substitute
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatDigitSubstitution: format language: language substitute: substitute].
	messages addLast: (Message selector: #gdipSetStringFormatDigitSubstitution:language:substitute: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatFlags: format flags: flags
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatFlags: format flags: flags].
	messages addLast: (Message selector: #gdipSetStringFormatFlags:flags: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatHotkeyPrefix: format hotkeyPrefix: hotkeyPrefix].
	messages addLast: (Message selector: #gdipSetStringFormatHotkeyPrefix:hotkeyPrefix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatLineAlign: format align: align
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatLineAlign: format align: align].
	messages addLast: (Message selector: #gdipSetStringFormatLineAlign:align: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatMeasurableCharacterRanges: format rangeCount: rangeCount ranges: ranges
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatMeasurableCharacterRanges: format rangeCount: rangeCount ranges: ranges].
	messages addLast: (Message selector: #gdipSetStringFormatMeasurableCharacterRanges:rangeCount:ranges: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatTabStops: format firstTabOffset: firstTabOffset count: count tabStops: tabStops
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatTabStops: format firstTabOffset: firstTabOffset count: count tabStops: tabStops].
	messages addLast: (Message selector: #gdipSetStringFormatTabStops:firstTabOffset:count:tabStops: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetStringFormatTrimming: format trimming: trimming
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetStringFormatTrimming: format trimming: trimming].
	messages addLast: (Message selector: #gdipSetStringFormatTrimming:trimming: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetTextContrast: graphics contrast: contrast
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetTextContrast: graphics contrast: contrast].
	messages addLast: (Message selector: #gdipSetTextContrast:contrast: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetTextRenderingHint: graphics mode: mode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetTextRenderingHint: graphics mode: mode].
	messages addLast: (Message selector: #gdipSetTextRenderingHint:mode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetTextureTransform: brush matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetTextureTransform: brush matrix: matrix].
	messages addLast: (Message selector: #gdipSetTextureTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetTextureWrapMode: brush wrapMode: wrapMode
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetTextureWrapMode: brush wrapMode: wrapMode].
	messages addLast: (Message selector: #gdipSetTextureWrapMode:wrapMode: arguments: activeProc topFrame arguments).
	^S_OK!

gdipSetWorldTransform: graphics matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipSetWorldTransform: graphics matrix: matrix].
	messages addLast: (Message selector: #gdipSetWorldTransform:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipShearMatrix: matrix shearX: shearX shearY: shearY order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipShearMatrix: matrix shearX: shearX shearY: shearY order: order].
	messages addLast: (Message selector: #gdipShearMatrix:shearX:shearY:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipStartPathFigure: path
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipStartPathFigure: path].
	messages addLast: (Message selector: #gdipStartPathFigure: arguments: activeProc topFrame arguments).
	^S_OK!

gdipStringFormatGetGenericDefault: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipStringFormatGetGenericDefault: format].
	messages addLast: (Message selector: #gdipStringFormatGetGenericDefault: arguments: activeProc topFrame arguments).
	^S_OK!

gdipStringFormatGetGenericTypographic: format
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipStringFormatGetGenericTypographic: format].
	messages addLast: (Message selector: #gdipStringFormatGetGenericTypographic: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTestControl: cntrl param: param
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTestControl: cntrl param: param].
	messages addLast: (Message selector: #gdipTestControl:param: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformMatrixPoints: matrix pts: pts count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformMatrixPoints: matrix pts: pts count: count].
	messages addLast: (Message selector: #gdipTransformMatrixPoints:pts:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformMatrixPointsI: matrix pts: pts count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformMatrixPointsI: matrix pts: pts count: count].
	messages addLast: (Message selector: #gdipTransformMatrixPointsI:pts:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformPath: path matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformPath: path matrix: matrix].
	messages addLast: (Message selector: #gdipTransformPath:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformPoints: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformPoints: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count].
	messages addLast: (Message selector: #gdipTransformPoints:destSpace:srcSpace:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformPointsI: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformPointsI: graphics destSpace: destSpace srcSpace: srcSpace points: points count: count].
	messages addLast: (Message selector: #gdipTransformPointsI:destSpace:srcSpace:points:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTransformRegion: region matrix: matrix
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTransformRegion: region matrix: matrix].
	messages addLast: (Message selector: #gdipTransformRegion:matrix: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateClip: graphics dx: dx dy: dy
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateClip: graphics dx: dx dy: dy].
	messages addLast: (Message selector: #gdipTranslateClip:dx:dy: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateClipI: graphics dx: dx dy: dy
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateClipI: graphics dx: dx dy: dy].
	messages addLast: (Message selector: #gdipTranslateClipI:dx:dy: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateLineTransform: brush dx: dx dy: dy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateLineTransform: brush dx: dx dy: dy order: order].
	messages addLast: (Message selector: #gdipTranslateLineTransform:dx:dy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateMatrix: matrix offsetX: offsetX offsetY: offsetY order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateMatrix: matrix offsetX: offsetX offsetY: offsetY order: order].
	messages addLast: (Message selector: #gdipTranslateMatrix:offsetX:offsetY:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslatePathGradientTransform: brush dx: dx dy: dy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslatePathGradientTransform: brush dx: dx dy: dy order: order].
	messages addLast: (Message selector: #gdipTranslatePathGradientTransform:dx:dy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslatePenTransform: pen dx: dx dy: dy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslatePenTransform: pen dx: dx dy: dy order: order].
	messages addLast: (Message selector: #gdipTranslatePenTransform:dx:dy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateRegion: region dx: dx dy: dy
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateRegion: region dx: dx dy: dy].
	messages addLast: (Message selector: #gdipTranslateRegion:dx:dy: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateRegionI: region dx: dx dy: dy
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateRegionI: region dx: dx dy: dy].
	messages addLast: (Message selector: #gdipTranslateRegionI:dx:dy: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateTextureTransform: brush dx: dx dy: dy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateTextureTransform: brush dx: dx dy: dy order: order].
	messages addLast: (Message selector: #gdipTranslateTextureTransform:dx:dy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipTranslateWorldTransform: graphics dx: dx dy: dy order: order
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipTranslateWorldTransform: graphics dx: dx dy: dy order: order].
	messages addLast: (Message selector: #gdipTranslateWorldTransform:dx:dy:order: arguments: activeProc topFrame arguments).
	^S_OK!

gdipVectorTransformMatrixPoints: matrix pts: pts count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipVectorTransformMatrixPoints: matrix pts: pts count: count].
	messages addLast: (Message selector: #gdipVectorTransformMatrixPoints:pts:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipVectorTransformMatrixPointsI: matrix pts: pts count: count
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipVectorTransformMatrixPointsI: matrix pts: pts count: count].
	messages addLast: (Message selector: #gdipVectorTransformMatrixPointsI:pts:count: arguments: activeProc topFrame arguments).
	^S_OK!

gdipWarpPath: path matrix: matrix points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight warpMode: warpMode flatness: flatness
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipWarpPath: path matrix: matrix points: points count: count srcx: srcx srcy: srcy srcwidth: srcwidth srcheight: srcheight warpMode: warpMode flatness: flatness].
	messages addLast: (Message selector: #gdipWarpPath:matrix:points:count:srcx:srcy:srcwidth:srcheight:warpMode:flatness: arguments: activeProc topFrame arguments).
	^S_OK!

gdipWidenPath: nativePath pen: pen matrix: matrix flatness: flatness
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipWidenPath: nativePath pen: pen matrix: matrix flatness: flatness].
	messages addLast: (Message selector: #gdipWidenPath:pen:matrix:flatness: arguments: activeProc topFrame arguments).
	^S_OK!

gdipWindingModeOutline: path matrix: matrix flatness: flatness
	| activeProc |
	(activeProc := Processor activeProcess) == process ifFalse: [^super gdipWindingModeOutline: path matrix: matrix flatness: flatness].
	messages addLast: (Message selector: #gdipWindingModeOutline:matrix:flatness: arguments: activeProc topFrame arguments).
	^S_OK!

initialize
	process := Processor activeProcess.
	self resetMessages!

messages
	^messages!

resetMessages
	messages := OrderedCollection new! !
!Graphics.Gdiplus.Tests.MockGdiplusLibrary categoriesForMethods!
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
gdipCreateFontFromLogfontA:logfont:font:!**auto generated**!GDI+ Flat API-Font Functions!public! !
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
gdipGetFamily:family:!**auto generated**!GDI+ Flat API-FontFamily Functions!public! !
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
gdipGetLineSpacing:style:lineSpacing:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineTransform:matrix:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLineWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-LinearGradientBrush Functions!public! !
gdipGetLogFontA:graphics:logfonta:!**auto generated**!GDI+ Flat API-Font Functions!public! !
gdipGetLogFontW:graphics:logfonta:!**auto generated**!GDI+ Flat API-Font Functions!public! !
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
gdipGetPathGradientBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientBlendCount:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientCenterColor:colors:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientCenterPoint:points:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientCenterPointI:points:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientFocusScales:xScale:yScale:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientPath:path:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientPointCount:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientPresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientPresetBlendCount:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientRect:rect:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientRectI:rect:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientSurroundColorCount:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientTransform:matrix:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipGetPathGradientWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-PathGradientBrush Functions!public! !
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
gdipImageForceValidation:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameCount:dimensionID:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameDimensionsCount:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageGetFrameDimensionsList:dimensionIDs:count:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageRotateFlip:rfType:!**auto generated**!GDI+ Flat API-Image Functions!public! !
gdipImageSelectActiveFrame:dimensionID:frameIndex:!**auto generated**!GDI+ Flat API-Image Functions!public! !
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
gdipMultiplyWorldTransform:matrix:order:!**auto generated**!public! !
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
gdipSetPathGradientBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientCenterColor:colors:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientCenterPoint:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientCenterPointI:points:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientFocusScales:xScale:yScale:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientGammaCorrection:useGammaCorrection:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientLinearBlend:focus:scale:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientPath:path:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientPresetBlend:blend:positions:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientSigmaBlend:focus:scale:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientSurroundColorsWithCount:color:count:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientTransform:matrix:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathGradientWrapMode:wrapMode:!**auto generated**!GDI+ Flat API-GraphicsPath Functions!GDI+ Flat API-PathGradientBrush Functions!public! !
gdipSetPathMarker:!**auto generated**!public! !
gdipSetPenBrushFill:brush:!**auto generated**!public! !
gdipSetPenColor:argb:!**auto generated**!public! !
gdipSetPenCompoundArray:dash:count:!**auto generated**!public! !
gdipSetPenCustomEndCap:customCap:!**auto generated**!public! !
gdipSetPenCustomStartCap:customCap:!**auto generated**!public! !
gdipSetPenDashArray:dash:count:!**auto generated**!public! !
gdipSetPenDashCap197819:dashCap:!**auto generated**!public! !
gdipSetPenDashOffset:offset:!**auto generated**!public! !
gdipSetPenDashStyle:dashStyle:!**auto generated**!public! !
gdipSetPenEndCap:endCap:!**auto generated**!public! !
gdipSetPenLineCap197819:startCap:endCap:dashCap:!**auto generated**!public! !
gdipSetPenLineJoin:lineJoin:!**auto generated**!public! !
gdipSetPenMiterLimit:miterLimit:!**auto generated**!public! !
gdipSetPenMode:penMode:!**auto generated**!public! !
gdipSetPenStartCap:startCap:!**auto generated**!public! !
gdipSetPenTransform:matrix:!**auto generated**!public! !
gdipSetPenUnit:unit:!**auto generated**!public! !
gdipSetPenWidth:width:!**auto generated**!public! !
gdipSetPixelOffsetMode:pixelOffsetMode:!**auto generated**!public! !
gdipSetPropertyItem:item:!**auto generated**!public! !
gdipSetRenderingOrigin:x:y:!**auto generated**!public! !
gdipSetSmoothingMode:smoothingMode:!**auto generated**!public! !
gdipSetSolidFillColor:color:!**auto generated**!public! !
gdipSetStringFormatAlign:align:!**auto generated**!public! !
gdipSetStringFormatDigitSubstitution:language:substitute:!**auto generated**!public! !
gdipSetStringFormatFlags:flags:!**auto generated**!public! !
gdipSetStringFormatHotkeyPrefix:hotkeyPrefix:!**auto generated**!public! !
gdipSetStringFormatLineAlign:align:!**auto generated**!public! !
gdipSetStringFormatMeasurableCharacterRanges:rangeCount:ranges:!**auto generated**!public! !
gdipSetStringFormatTabStops:firstTabOffset:count:tabStops:!**auto generated**!public! !
gdipSetStringFormatTrimming:trimming:!**auto generated**!public! !
gdipSetTextContrast:contrast:!**auto generated**!public! !
gdipSetTextRenderingHint:mode:!**auto generated**!public! !
gdipSetTextureTransform:matrix:!**auto generated**!public! !
gdipSetTextureWrapMode:wrapMode:!**auto generated**!public! !
gdipSetWorldTransform:matrix:!**auto generated**!public! !
gdipShearMatrix:shearX:shearY:order:!**auto generated**!public! !
gdipStartPathFigure:!**auto generated**!public! !
gdipStringFormatGetGenericDefault:!**auto generated**!public! !
gdipStringFormatGetGenericTypographic:!**auto generated**!public! !
gdipTestControl:param:!**auto generated**!public! !
gdipTransformMatrixPoints:pts:count:!**auto generated**!public! !
gdipTransformMatrixPointsI:pts:count:!**auto generated**!public! !
gdipTransformPath:matrix:!**auto generated**!public! !
gdipTransformPoints:destSpace:srcSpace:points:count:!**auto generated**!public! !
gdipTransformPointsI:destSpace:srcSpace:points:count:!**auto generated**!public! !
gdipTransformRegion:matrix:!**auto generated**!public! !
gdipTranslateClip:dx:dy:!**auto generated**!public! !
gdipTranslateClipI:dx:dy:!**auto generated**!public! !
gdipTranslateLineTransform:dx:dy:order:!**auto generated**!public! !
gdipTranslateMatrix:offsetX:offsetY:order:!**auto generated**!public! !
gdipTranslatePathGradientTransform:dx:dy:order:!**auto generated**!public! !
gdipTranslatePenTransform:dx:dy:order:!**auto generated**!public! !
gdipTranslateRegion:dx:dy:!**auto generated**!public! !
gdipTranslateRegionI:dx:dy:!**auto generated**!public! !
gdipTranslateTextureTransform:dx:dy:order:!**auto generated**!public! !
gdipTranslateWorldTransform:dx:dy:order:!**auto generated**!public! !
gdipVectorTransformMatrixPoints:pts:count:!**auto generated**!public! !
gdipVectorTransformMatrixPointsI:pts:count:!**auto generated**!public! !
gdipWarpPath:matrix:points:count:srcx:srcy:srcwidth:srcheight:warpMode:flatness:!**auto generated**!public! !
gdipWidenPath:pen:matrix:flatness:!**auto generated**!public! !
gdipWindingModeOutline:matrix:flatness:!**auto generated**!public! !
initialize!initializing!private! !
messages!accessing!public! !
resetMessages!operations!public! !
!

!Graphics.Gdiplus.Tests.MockGdiplusLibrary class methodsFor!

generateMockMethods
	"Private - 
	self generateMockMethods
	"

	| gdipMethods autogen |
	autogen := '**auto generated**'.
	self removeCategory: autogen.
	gdipMethods := GdiplusLibrary methodDictionary
				select: [:each | (each selector beginsWith: 'gdip') and: [(self includesSelector: each) not]].
	gdipMethods do: 
			[:each |
			| source signature |
			source := String writeStream.
			signature := each getSource readStream upTo: $\r.
			source
				nextPutAll: signature;
				crtab;
				nextPutAll: '| activeProc |';
				crtab;
				nextPutAll: '(activeProc := Processor activeProcess) == process ifFalse: [^super ';
				nextPutAll: signature;
				nextPutAll: '].';
				crtab;
				nextPutAll: 'messages addLast: (Message selector: ';
				print: each selector;
				nextPutAll: ' arguments: activeProc topFrame arguments).';
				crtab;
				nextPutAll: '^S_OK'.
			Graphics.Gdiplus.Tests.MockGdiplusLibrary compile: source contents classified: autogen]!

new
	^super new initialize! !
!Graphics.Gdiplus.Tests.MockGdiplusLibrary class categoriesForMethods!
generateMockMethods!helpers!private! !
new!instance creation!public! !
!

