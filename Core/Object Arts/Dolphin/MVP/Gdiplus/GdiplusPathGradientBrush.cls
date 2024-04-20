"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusPathGradientBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusPathGradientBrush guid: (GUID fromString: '{c8f38622-766b-11d7-b609-00e0987e8081}')!

GdiplusPathGradientBrush comment: 'A path gradient brush paints a color gradient in which the color changes from a center point outward to a boundary that is defined by a closed curve or path. The color gradient has one color at the center point and one or multiple colors at the boundary. '!

!GdiplusPathGradientBrush categoriesForClass!Unclassified! !

!GdiplusPathGradientBrush methodsFor!

blendBellShape: focusReal scale: scaleReal 
	| status |
	(status := GdiplusLibrary default 
				gdipSetPathGradientSigmaBlend: self asParameter
				focus: focusReal
				scale: scaleReal) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientSigmaBlend failed' with: status]!

blendColors
	| status count blend positions |
	count := self blendColorsCount.
	blend := DWORDArray new: count.
	positions := FLOATArray new: count.
	(status := GdiplusLibrary default
				gdipGetPathGradientPresetBlend: self asParameter
				blend: blend
				positions: positions
				count: count) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientPresetBlend failed' with: status].
	^Array with: (blend asArray collect: [:e | Color fromArgbCode: e]) with: positions asArray!

blendColors: colorsArray positions: positionsArray
	"Set the preset colors and the blend positions of this path gradient brush.  colorsArray
	specifies the interpolation colors for the gradient. Each color in colorsArray 
	corresponds to a blend position in positionsArray.  Each blend position is a number from
	 0 through 1, where 0 indicates the boundary of the gradient and 1 indicates the center point. 
	A blend position between 0 and 1 specifies the set of all points that are a certain fraction of 
	the distance from the boundary to the center point. For example, a blend position of 0.7 
	specifies the set of all points that are 70 percent of the way from the boundary to the center point."

	| status |
	self assert: [colorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	(status := GdiplusLibrary default
				gdipSetPathGradientPresetBlend: self asParameter
				blend: (DWORDArray withAll: (colorsArray collect: [:e | e argbCode]))
				positions: (FLOATArray withAll: positionsArray)
				count: colorsArray size) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientPresetBlend failed' with: status]!

blendColorsCount
	"Answer the <Integer> number of preset colors currently set for the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientPresetBlendCount: self asParameter count: count)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPathGradientPresetBlendCount failed' with: status].
	^count value!

blendFactors
	| status count factors positions |
	count := self blendFactorsCount.
	factors := FLOATArray new: count.
	positions := FLOATArray new: count.
	(status := GdiplusLibrary default
				gdipGetPathGradientBlend: self asParameter
				blend: factors
				positions: positions
				count: count) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientBlend failed' with: status].
	^Array with: factors asArray with: positions asArray!

blendFactors: factorsArray positions: positionsArray 
	| status |
	self assert: [factorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [factorsArray allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	(status := GdiplusLibrary default 
				gdipSetPathGradientBlend: self asParameter
				blend: (FLOATArray withAll: factorsArray)
				positions: (FLOATArray withAll: positionsArray)
				count: factorsArray size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientBlend failed' with: status]!

blendFactorsCount
	"Answer the <Integer> number of blend factors currently set for the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientBlendCount: self asParameter count: count) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientBlendCount failed' with: status].
	^count value!

blendTriangularShape: focusReal scale: scaleReal 
	| status |
	(status := GdiplusLibrary default 
				gdipSetPathGradientLinearBlend: self asParameter
				focus: focusReal
				scale: scaleReal) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientLinearBlend failed' with: status]!

bounds
	"Answer a bounding Rectangle for the receiver."

	| status rect |
	rect := GpRect newBuffer.
	(status := GdiplusLibrary default gdipGetPathGradientRectI: self asParameter rect: rect) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientRectI failed' with: status].
	^rect asRectangle!

centerColor
	"Answer the ARGB color that appears at the receiver's center point."

	| status color |
	color := DWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientCenterColor: self asParameter colors: color)
		== Ok ifFalse: [GdiplusError signal: 'GdipGetPathGradientCenterColor failed' with: status].
	^Color fromArgbCode: color value!

centerColor: aColor
	"Set the color that appears at the receiver's center point."

	| status |
	(status := GdiplusLibrary default gdipSetPathGradientCenterColor: self asParameter
				colors: aColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientCenterColor failed' with: status]!

centerPoint
	"Answer the center point of the receiver."

	| status point |
	point := POINT new.
	(status := GdiplusLibrary default gdipGetPathGradientCenterPointI: self asParameter points: point)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPathGradientCenterPointI failed' with: status].
	^point asPoint!

centerPoint: aPoint 
	"Set the center point of the receiver. By default, the center point is at the centroid of the 
	receiver's boundary path, but it can be set to any location inside or outside the path."

	| status |
	(status := GdiplusLibrary default gdipSetPathGradientCenterPointI: self asParameter
				points: (POINTL fromPoint: aPoint)) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientCenterPointI failed' with: status]!

focusScales
	"Answer a Point that represents the x and y scale factors for the receiver's center color relative to its boundary path."

	| status x y |
	x := FLOAT new.
	y := FLOAT new.
	(status := GdiplusLibrary default
				gdipGetPathGradientFocusScales: self asParameter
				xScale: x
				yScale: y) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientFocusScales failed' with: status].
	^x value @ y value!

focusScales: aPoint 
	"Specify that the receiver's center color should appear within the receiver's boundary path 
	scaled by a factor of aPoint in the x and y directions."

	| status |
	(status := GdiplusLibrary default 
				gdipSetPathGradientFocusScales: self asParameter
				xScale: aPoint x
				yScale: aPoint y) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientFocusScales failed' with: status]!

isGammaCorrected
	"Answer whether or not gamma correction is applied to the receiver."

	| status result |
	result := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientGammaCorrection: self asParameter
				useGammaCorrection: result asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientGammaCorrection failed' with: status].
	^result ~= 0!

isGammaCorrected: aBoolean 
	"Set whether or not gamma correction should be applied to the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPathGradientGammaCorrection: self asParameter
				useGammaCorrection: aBoolean asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientGammaCorrection failed' with: status]!

multiplyTransform: aGdiplusMatrix 
	"Set the receiver's transformation matrix to the product of itself and aGdiplusMatrix."

	self multiplyTransform: aGdiplusMatrix order: nil!

multiplyTransform: aGdiplusMatrix order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and aGdiplusMatrix
	with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipMultiplyPathGradientTransform: self asParameter
				matrix: aGdiplusMatrix asParameter
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipMultiplyPathGradientTransform failed' with: status]!

pointCount
	"Private - Answer the number of points that define the receiver's boundary path."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientPointCount: self asParameter count: count) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPathGradientPointCount failed' with: status].
	^count asInteger!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	| status |
	(status := GdiplusLibrary default gdipResetPathGradientTransform: self asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipResetPathGradientTransform failed' with: status]!

rotateTransform: aRealPoint 
	"Rotate the receiver's transformation matrix by aRealPoint."

	self rotateTransform: aRealPoint order: nil!

rotateTransform: aRealAngle order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipRotatePathGradientTransform: self asParameter
				angle: aRealAngle
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipRotatePathGradientTransform failed' with: status]!

scaleTransform: aRealPoint 
	"Scale the receiver's transformation matrix by aRealPoint."

	self scaleTransform: aRealPoint order: nil!

scaleTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipScalePathGradientTransform: self asParameter
				sx: aRealPoint x
				sy: aRealPoint y
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipScalePathGradientTransform failed' with: status]!

surroundColor: aColor
	"Set the specified <Color> as the single color that appears on the receiver's boundary."

	self surroundColors: (Array new: self pointCount withAll: aColor)!

surroundColors
	"Answer an Array of ARGB that are the receiver's boundary colors."

	| status count colors |
	count := self surroundColorsCount.
	colors := DWORDArray new: count.
	count := DWORD fromInteger: count. 
	(status := GdiplusLibrary default
				gdipGetPathGradientSurroundColorsWithCount: self asParameter
				color: colors
				count: count) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientSurroundColorsWithCount failed' with: status].
	^colors collect: [:e | Color fromArgbCode: e]!

surroundColors: colorsArray
	"Set the colors that appear on the receiver's boundaries."

	| status |
	(status := GdiplusLibrary default
				gdipSetPathGradientSurroundColorsWithCount: self asParameter
				color: (DWORDArray withAll: (colorsArray collect: [:e | e argbCode]))
				count: (DWORD new value: colorsArray size)) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientSurroundColorsWithCount failed' with: status]!

surroundColorsCount
	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientSurroundColorCount: self asParameter
				count: count) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientSurroundColorCount failed' with: status].
	^count value!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| status matrix |
	matrix := GdiplusMatrix new.
	(status := GdiplusLibrary default gdipGetPathGradientTransform: self asParameter
				matrix: matrix asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetPathGradientTransform failed' with: status].
	^matrix!

transform: aGdiplusMatrix 
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	| status |
	(status := GdiplusLibrary default gdipSetPathGradientTransform: self asParameter
				matrix: aGdiplusMatrix asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientTransform failed' with: status]!

translateTransform: aRealPoint 
	"Translate (shift) the receiver's transformation matrix by aRealPoint."

	self translateTransform: aRealPoint order: nil!

translateTransform: aRealPoint order: aMatrixOrderConstant 
	"Set the receiver's transformation matrix to the product of itself and a translation matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	| status |
	(status := GdiplusLibrary default 
				gdipTranslatePathGradientTransform: self asParameter
				dx: aRealPoint x
				dy: aRealPoint y
				order: aMatrixOrderConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipTranslatePathGradientTransform failed' with: status]!

wrapMode
	"Answer a number that indicates if and how painting is done outside the receiver's boundary path."

	| status mode |
	mode := DWORD new.
	(status := GdiplusLibrary default gdipGetPathGradientWrapMode: self asParameter wrapMode: mode) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetPathGradientWrapMode failed' with: status].
	^mode asInteger!

wrapMode: aWrapModeConstant 
	"Set if and how painting is done outside the receiver's boundary path."

	| status |
	(status := GdiplusLibrary default gdipSetPathGradientWrapMode: self asParameter
				wrapMode: aWrapModeConstant) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetPathGradientWrapMode failed' with: status]! !

!GdiplusPathGradientBrush categoriesForMethods!
blendBellShape:scale:!accessing-properties!public! !
blendColors!accessing-properties!public! !
blendColors:positions:!accessing-properties!public! !
blendColorsCount!accessing-properties!public! !
blendFactors!accessing-properties!public! !
blendFactors:positions:!accessing-properties!public! !
blendFactorsCount!accessing-properties!public! !
blendTriangularShape:scale:!accessing-properties!public! !
bounds!accessing-properties!public! !
centerColor!accessing-properties!public! !
centerColor:!accessing-properties!public! !
centerPoint!accessing-properties!public! !
centerPoint:!accessing-properties!public! !
focusScales!accessing-properties!public! !
focusScales:!accessing-properties!public! !
isGammaCorrected!accessing-properties!public! !
isGammaCorrected:!accessing-properties!public! !
multiplyTransform:!accessing-transformations!public! !
multiplyTransform:order:!accessing-transformations!public! !
pointCount!accessing-properties!public! !
resetTransform!accessing-transformations!public! !
rotateTransform:!accessing-transformations!public! !
rotateTransform:order:!accessing-transformations!public! !
scaleTransform:!accessing-transformations!public! !
scaleTransform:order:!accessing-transformations!public! !
surroundColor:!accessing-properties!public! !
surroundColors!accessing-properties!public! !
surroundColors:!accessing-properties!public! !
surroundColorsCount!accessing-properties!private! !
transform!accessing-transformations!public! !
transform:!accessing-transformations!public! !
translateTransform:!accessing-transformations!public! !
translateTransform:order:!accessing-transformations!public! !
wrapMode!accessing-properties!public! !
wrapMode:!accessing-properties!public! !
!

!GdiplusPathGradientBrush class methodsFor!

path: aGdiplusPath 
	"Answer an instance of the receiver with boundary aGdiplusPath."

	^self fromInitializer: (GdiplusPathGradientFromPathInitializer path: aGdiplusPath)!

points: points 
	"Answer an instance of the receiver with boundary path specified by points."

	^self points: points wrapMode: WrapModeClamp!

points: points wrapMode: aWrapModeConstant 
	"Answer an instance of the receiver with boundary path specified by points and 
	wrap mode specified by aWrapModeConstant."

	^self fromInitializer: (GdiplusPathGradientFromPointsInitializer points: points
				wrapMode: aWrapModeConstant)! !

!GdiplusPathGradientBrush class categoriesForMethods!
path:!instance creation!public! !
points:!instance creation!public! !
points:wrapMode:!instance creation!public! !
!

