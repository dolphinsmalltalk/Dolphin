"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBrushInitializer subclass: #'Graphics.Gdiplus.PathGradientBrushInitializer'
	instanceVariableNames: 'centerColor centerPoint surroundColors focusScales'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientBrushInitializer guid: (Core.GUID fromString: '{bb3a4f15-88b6-4b1d-a774-940ea0c83fd2}')!
Graphics.Gdiplus.PathGradientBrushInitializer isNonInstantiable: true!
Graphics.Gdiplus.PathGradientBrushInitializer comment: ''!
!Graphics.Gdiplus.PathGradientBrushInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^super = anObject and: 
			[centerColor = anObject centerColor and: 
					[self centerPoint = anObject centerPoint
						and: [self surroundColors = anObject surroundColors and: [self focusScales = anObject focusScales]]]]!

applyAdditionalAttributes: aHandle
	"Private - Note that due to errors in the IDL, the 2nd argument of some property-set functions appear to be expecting a collection when they aren't"

	super applyAdditionalAttributes: aHandle.
	centerColor = self defaultCenterColor ifFalse: [self setCenterColor: aHandle].
	centerPoint ifNotNil: [self setCenterPoint: aHandle].
	surroundColors ifNotNil: [self setSurroundColors: aHandle]!

centerColor
	^centerColor!

centerColor: aHandle set: aColor
	centerColor := aColor ifNil: [self defaultCenterColor].
	aHandle ifNotNil: [self setCenterColor: aHandle]!

centerPoint
	^centerPoint!

centerPoint: aHandle set: aPoint
	centerPoint := aPoint.
	aHandle ifNotNil: [self setCenterPoint: aHandle]!

centerPointGet: aHandle
	^centerPoint ifNil: [^self getCenterPoint: aHandle]!

defaultCenterColor
	^self subclassResponsibility!

defaultWrapMode
	^WrapModeClamp!

focusScales
	^focusScales!

focusScales: aHandle set: aPoint
	focusScales := aPoint isZero ifFalse: [aPoint].
	aHandle
		ifNotNil: 
			[Gdip
				gdipSetPathGradientFocusScales: aHandle
				xScale: aPoint x
				yScale: aPoint y]!

focusScalesGet: aHandle
	^focusScales ifNil: [self getFocusScales: aHandle]!

gdipGetBlend: aHandle blend: factorsFloatArray positions: positionsFloatArray
	Gdip
		gdipGetPathGradientBlend: aHandle
		blend: factorsFloatArray
		positions: positionsFloatArray
		count: factorsFloatArray size!

gdipGetBlend: aHandle count: aUInt32Bytes
	Gdip gdipGetPathGradientBlendCount: aHandle count: aUInt32Bytes!

gdipGetPresetBlend: aHandle blend: anARGBArray positions: aFLOATArray
	Gdip
		gdipGetPathGradientPresetBlend: aHandle
		blend: anARGBArray
		positions: aFLOATArray
		count: anARGBArray size!

gdipGetPresetBlend: aHandle count: count
	Gdip gdipGetPathGradientPresetBlendCount: aHandle count: count!

gdipGetTransform: aHandle matrix: matrix
	Gdip gdipGetPathGradientTransform: aHandle matrix: matrix handle!

gdipLinearBlend: aHandle focus: focusReal scale: scaleReal
	Gdip
		gdipSetPathGradientLinearBlend: aHandle
		focus: focusReal
		scale: scaleReal!

gdipMultiplyTransform: aGpBrush matrix: aGpMatrix order: aMatrixOrderConstant
	Gdip
		gdipMultiplyPathGradientTransform: aGpBrush
		matrix: aGpMatrix
		order: aMatrixOrderConstant!

gdipResetTransform: aHandle
	Gdip gdipResetPathGradientTransform: aHandle!

gdipRotateTransform: aHandle angle: aNumber order: aMatrixOrderConstant
	Gdip
		gdipRotatePathGradientTransform: aHandle
		angle: aNumber asFloat
		order: aMatrixOrderConstant!

gdipScaleTransform: aHandle width: widthFloat height: heightFloat order: aMatrixOrderConstant
	Gdip
		gdipScalePathGradientTransform: aHandle
		sx: widthFloat
		sy: heightFloat
		order: aMatrixOrderConstant!

gdipSetBlend: aHandle blend: factors positions: positions
	Gdip
		gdipSetPathGradientBlend: aHandle
		blend: factors
		positions: positions
		count: factors size!

gdipSetGammaCorrection: aHandle value: aBoolean
	Gdip gdipSetPathGradientGammaCorrection: aHandle useGammaCorrection: aBoolean!

gdipSetPresetBlend: aHandle blend: colors positions: positions
	Gdip
		gdipSetPathGradientPresetBlend: aHandle
		blend: colors
		positions: positions
		count: colors size!

gdipSetSigmaBlend: aHandle focus: focusReal scale: scaleReal
	Gdip
		gdipSetPathGradientSigmaBlend: aHandle
		focus: focusReal
		scale: scaleReal!

gdipSetTransform: aHandle matrix: aMatrix
	Gdip gdipSetPathGradientTransform: aHandle matrix: aMatrix handle!

gdipSetWrap: aHandle mode: aWrapModeConstant
	Gdip gdipSetPathGradientWrapMode: aHandle wrapMode: aWrapModeConstant!

gdipTranslateTransform: aHandle dx: dxFloat dy: dyFloat order: aMatrixOrderConstant
	Gdip
		gdipTranslatePathGradientTransform: aHandle
		dx: dxFloat
		dy: dyFloat
		order: aMatrixOrderConstant!

getCenterColor: aHandle
	| color |
	color := ARGBBytes new.
	Gdip gdipGetPathGradientCenterColor: aHandle colors: color.
	^color value!

getCenterPoint: aHandle
	| point |
	point := POINTL newBuffer.
	Gdip gdipGetPathGradientCenterPointI: aHandle points: point.
	^point!

getFocusScales: aHandle
	| scales |
	scales := POINTF newBuffer.
	Gdip
		gdipGetPathGradientFocusScales: aHandle
		xScale: scales
		yScale: scales yourAddress + 4.
	^scales!

getRectangle: aHandle
	| rect |
	rect := Rect newBuffer.
	Gdip gdipGetPathGradientRectI: aHandle rect: rect.
	^rect asRectangle!

getSurroundColors: aHandle
	| requested colors received |
	requested := self getSurroundColorsCount: aHandle.
	colors := ARGBArray new: requested.
	received := UInt32Bytes fromInteger: requested.
	Gdip
		gdipGetPathGradientSurroundColorsWithCount: aHandle
		color: colors
		count: received.
	received := received asSignedInteger.
	^received = requested ifTrue: [colors] ifFalse: [colors copyFrom: 1 to: received]!

getSurroundColorsCount: aHandle
	"This actually returns the number of points in the path, not necessarily the number of surround colours - it is effectively a maximum."

	| count |
	count := UInt32Bytes new.
	Gdip gdipGetPathGradientSurroundColorCount: aHandle count: count.
	^count asSignedInteger!

hash
	"Answer the <integer> hash value for the receiver."

	^((((super hash + focusScales hash) hashMultiply + surroundColors hash) hashMultiply
		+ centerPoint hash) hashMultiply
		+ centerColor hash) hashMultiply!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^super isSelfEvaluating and: 
			[centerColor = self defaultCenterColor
				and: [centerPoint isNil and: [surroundColors isNil and: [focusScales isNil and: [blend isNil]]]]]!

path
	^self subclassResponsibility!

pointCountGet: aHandle
	| count |
	count := UInt32Bytes new.
	Gdip gdipGetPathGradientPointCount: aHandle count: count.
	^count asSignedInteger!

printAttributesOn: aStream
	super printAttributesOn: aStream.
	centerColor = self defaultCenterColor
		ifFalse: 
			[aStream
				nextPutAll: '; centerColor: ';
				print: centerColor].
	centerPoint isNil
		ifFalse: 
			[aStream
				nextPutAll: '; centerPoint: ';
				print: centerPoint].
	surroundColors isNil
		ifFalse: 
			[aStream
				nextPutAll: '; surroundColors: ';
				print: surroundColors].
	focusScales isNil
		ifFalse: 
			[aStream
				nextPutAll: '; focusScales: ';
				print: focusScales].
	blend isNil
		ifFalse: 
			[aStream
				nextPutAll: '; blend: ';
				print: blend]!

setCenterColor: aHandle
	Gdip gdipSetPathGradientCenterColor: aHandle colors: centerColor argbCode!

setCenterPoint: aHandle
	Gdip gdipSetPathGradientCenterPointI: aHandle points: (POINTL marshal: centerPoint)!

setSurroundColors: aHandle
	| colors |
	colors := ARGBArray marshal: surroundColors.
	Gdip
		gdipSetPathGradientSurroundColorsWithCount: aHandle
		color: colors
		count: (UInt32Bytes fromInteger: surroundColors size)!

surroundColors
	^surroundColors!

surroundColors: aHandle set: aSequenceOfColor
	surroundColors := aSequenceOfColor.
	self setSurroundColors: aHandle!

surroundColorsGet: aHandle
	^surroundColors ifNil: [self getSurroundColors: aHandle]! !
!Graphics.Gdiplus.PathGradientBrushInitializer categoriesForMethods!
=!comparing!public! !
applyAdditionalAttributes:!private!realizing/unrealizing! !
centerColor!attributes!private! !
centerColor:set:!attributes!private! !
centerPoint!attributes!private! !
centerPoint:set:!attributes!private! !
centerPointGet:!attributes!private! !
defaultCenterColor!constants!private! !
defaultWrapMode!constants!private! !
focusScales!attributes!private! !
focusScales:set:!attributes!private! !
focusScalesGet:!attributes!private! !
gdipGetBlend:blend:positions:!helpers!private! !
gdipGetBlend:count:!attributes!private! !
gdipGetPresetBlend:blend:positions:!attributes!private! !
gdipGetPresetBlend:count:!attributes!private! !
gdipGetTransform:matrix:!operations!private!transformations! !
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
getCenterColor:!attributes!private! !
getCenterPoint:!attributes!private! !
getFocusScales:!attributes!private! !
getRectangle:!attributes!private! !
getSurroundColors:!attributes!private! !
getSurroundColorsCount:!attributes!private! !
hash!comparing!public! !
isSelfEvaluating!public!testing! !
path!accessing!private! !
pointCountGet:!attributes!private! !
printAttributesOn:!printing!private! !
setCenterColor:!attributes!private! !
setCenterPoint:!attributes!private! !
setSurroundColors:!attributes!private! !
surroundColors!attributes!private! !
surroundColors:set:!attributes!private! !
surroundColorsGet:!attributes!private! !
!

!Graphics.Gdiplus.PathGradientBrushInitializer class methodsFor!

path: aGraphicsPath wrapMode: aWrapModeConstant
	^PathGradientFromPathInitializer new path: aGraphicsPath wrapMode: aWrapModeConstant!

points: aSequenceOfPoints wrapMode: aWrapModeConstant
	^PathGradientFromPointsInitializer new points: aSequenceOfPoints wrapMode: aWrapModeConstant! !
!Graphics.Gdiplus.PathGradientBrushInitializer class categoriesForMethods!
path:wrapMode:!instance creation!public! !
points:wrapMode:!instance creation!public! !
!

