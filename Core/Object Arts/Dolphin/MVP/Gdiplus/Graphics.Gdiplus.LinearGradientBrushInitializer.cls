"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBrushInitializer subclass: #'Graphics.Gdiplus.LinearGradientBrushInitializer'
	instanceVariableNames: 'color1 color2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrushInitializer guid: (Core.GUID fromString: '{5dd72bf9-0464-4f05-b1b3-faa11a8e112e}')!
Graphics.Gdiplus.LinearGradientBrushInitializer isNonInstantiable: true!
Graphics.Gdiplus.LinearGradientBrushInitializer comment: ''!
!Graphics.Gdiplus.LinearGradientBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^super = anObject and: [color1 = anObject color1 and: [color2 = anObject color2]]!

color
	"Not a single colour"

	^self shouldNotImplement!

color1
	^color1!

color2
	^color2!

colorsGet: aHandle
	| colors |
	colors := ByteArray new: 8.
	Gdip gdipGetLineColors: aHandle colors: colors.
	^{Color fromArgbCode: (colors dwordAtOffset: 0). Color fromArgbCode: (colors dwordAtOffset: 4)}!

colorsSet: aHandle start: endColor end: startColor
	Gdip
		gdipSetLineColors: aHandle
		color1: startColor argbCode
		color2: endColor argbCode.
	color1 := startColor.
	color2 := endColor!

gdipGetBlend: aHandle blend: factorsFloatArray positions: positionsFloatArray
	Gdip
		gdipGetLineBlend: aHandle
		blend: factorsFloatArray
		positions: positionsFloatArray
		count: factorsFloatArray size!

gdipGetBlend: aHandle count: aUInt32Bytes
	Gdip gdipGetLineBlendCount: aHandle count: aUInt32Bytes!

gdipGetPresetBlend: aHandle blend: anARGBArray positions: aFLOATArray
	Gdip
		gdipGetLinePresetBlend: aHandle
		blend: anARGBArray
		positions: aFLOATArray
		count: anARGBArray size!

gdipGetPresetBlend: aHandle count: aUInt32Bytes
	Gdip gdipGetLinePresetBlendCount: aHandle count: aUInt32Bytes!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetLineTransform: aHandle matrix: matrix handle!

gdipLinearBlend: aHandle focus: focusReal scale: scaleReal
	Gdip
		gdipSetLineLinearBlend: aHandle
		focus: focusReal
		scale: scaleReal!

gdipMultiplyTransform: aGpBrush matrix: aGpMatrix order: aMatrixOrderConstant
	Gdip
		gdipMultiplyLineTransform: aGpBrush
		matrix: aGpMatrix
		order: aMatrixOrderConstant!

gdipResetTransform: aHandle
	Gdip gdipResetLineTransform: aHandle!

gdipRotateTransform: aHandle angle: aNumber order: aMatrixOrderConstant
	Gdip
		gdipRotateLineTransform: aHandle
		angle: aNumber asFloat
		order: aMatrixOrderConstant!

gdipScaleTransform: aHandle width: widthFloat height: heightFloat order: aMatrixOrderConstant
	Gdip
		gdipScaleLineTransform: aHandle
		sx: widthFloat
		sy: heightFloat
		order: aMatrixOrderConstant!

gdipSetBlend: aHandle blend: factors positions: positions
	Gdip
		gdipSetLineBlend: aHandle
		blend: factors
		positions: positions
		count: factors size!

gdipSetGammaCorrection: aHandle value: aBoolean
	Gdip gdipSetLineGammaCorrection: aHandle useGammaCorrection: aBoolean!

gdipSetPresetBlend: aHandle blend: colors positions: positions
	Gdip
		gdipSetLinePresetBlend: aHandle
		blend: colors
		positions: positions
		count: colors size!

gdipSetSigmaBlend: aHandle focus: focusReal scale: scaleReal
	Gdip
		gdipSetLineSigmaBlend: aHandle
		focus: focusReal
		scale: scaleReal!

gdipSetTransform: aHandle matrix: aMatrix
	Gdip gdipSetLineTransform: aHandle matrix: aMatrix handle!

gdipSetWrap: aHandle mode: aWrapModeConstant
	Gdip gdipSetLineWrapMode: aHandle wrapMode: aWrapModeConstant!

gdipTranslateTransform: aHandle dx: dxFloat dy: dyFloat order: aMatrixOrderConstant
	Gdip
		gdipTranslateLineTransform: aHandle
		dx: dxFloat
		dy: dyFloat
		order: aMatrixOrderConstant!

getRectangle: aHandle
	| rect |
	rect := Rect newBuffer.
	Gdip gdipGetLineRectI: aHandle rect: rect.
	^rect asRectangle!

hash
	"Answer the <integer> hash value for the receiver."

	^((super hash + color1 hash) hashMultiply + color2 hash) hashMultiply!

mode
	"Answer the LinearGradientMode of the brushes created by t receiver."

	^self subclassResponsibility! !
!Graphics.Gdiplus.LinearGradientBrushInitializer categoriesForMethods!
=!comparing!public! !
color!accessing!public! !
color1!accessing!public! !
color2!accessing!public! !
colorsGet:!accessing!public! !
colorsSet:start:end:!attributes!private! !
gdipGetBlend:blend:positions:!helpers!private! !
gdipGetBlend:count:!attributes!private! !
gdipGetPresetBlend:blend:positions:!attributes!private! !
gdipGetPresetBlend:count:!attributes!private! !
gdipGetTransform:matrix:!private!transformations! !
gdipLinearBlend:focus:scale:!operations!private! !
gdipMultiplyTransform:matrix:order:!private!transformations! !
gdipResetTransform:!private!transformations! !
gdipRotateTransform:angle:order:!private!transformations! !
gdipScaleTransform:width:height:order:!private!transformations! !
gdipSetBlend:blend:positions:!attributes!private! !
gdipSetGammaCorrection:value:!attributes!private! !
gdipSetPresetBlend:blend:positions:!attributes!private! !
gdipSetSigmaBlend:focus:scale:!operations!private! !
gdipSetTransform:matrix:!private!transformations! !
gdipSetWrap:mode:!attributes!private! !
gdipTranslateTransform:dx:dy:order:!private!transformations! !
getRectangle:!attributes!private! !
hash!comparing!public! !
mode!accessing!public! !
!

!Graphics.Gdiplus.LinearGradientBrushInitializer class methodsFor!

point1: point1 point2: point2 color1: aColor1 color2: aColor2
	"SW: The C++ class has a separate constructor for these parameters, and there is a separate FlatAPI constructor.
		- I *think* this is equivalent ... if not, we need another GdiplusLinearGradientBrushInitializer class"

	"SW: Update: I switched to using a separate initializer as it wasn't clear to me that using the rect initializer was identical.
	In addition, I was getting 'out of memory' errors when passing rectangles with an extent with a 0 height/width 
	[bmg: That would be because the points initializer expects origin and corner points, and the rect initializer origin and width. Even so the rect initializer allows an extra parameter to be specified on creation, so it isn't clear that we can consolidate to one initializer just yet."

	^self
		point1: point1
		point2: point2
		color1: aColor1
		color2: aColor2
		wrapMode: WrapModeTile!

point1: point1 point2: point2 color1: aColor1 color2: aColor2 wrapMode: aWrapModeConstant
	"SW: The C++ class has a separate constructor for these parameters, and there is a separate FlatAPI constructor.
		- I *think* this is equivalent ... if not, we need another GdiplusLinearGradientBrushInitializer class"

	"SW: Update: I switched to using a separate initializer as it wasn't clear to me that using the rect initializer was identical.
	In addition, I was getting 'out of memory' errors when passing rectangles with an extent with a 0 height/width"

	^LinearGradientBrushFromPointsInitializer new
		point1: point1
		point2: point2
		color1: aColor1
		color2: aColor2
		wrapMode: aWrapModeConstant!

rect: rect color1: color1 color2: color2 mode: aLinearGradientMode
	"Creates a LinearGradientBrush object from a set of boundary points and boundary colors."

	"typedef enum {
	    LinearGradientModeHorizontal = 0,
	    LinearGradientModeVertical = 1,
	    LinearGradientModeForwardDiagonal = 2,
	    LinearGradientModeBackwardDiagonal = 3
	} LinearGradientMode;"

	^LinearGradientBrushFromRectInitializer new
		rect: rect
		color1: color1
		color2: color2
		mode: aLinearGradientMode! !
!Graphics.Gdiplus.LinearGradientBrushInitializer class categoriesForMethods!
point1:point2:color1:color2:!instance creation!public! !
point1:point2:color1:color2:wrapMode:!instance creation!public! !
rect:color1:color2:mode:!instance creation!public! !
!

