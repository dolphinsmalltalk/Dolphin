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
	GdiplusLibrary default
		gdipSetPathGradientSigmaBlend: self asParameter
		focus: focusReal
		scale: scaleReal!

blendColors
	| count blend positions |
	count := self blendColorsCount.
	blend := DWORDArray new: count.
	positions := FLOATArray new: count.
	GdiplusLibrary default
		gdipGetPathGradientPresetBlend: self asParameter
		blend: blend
		positions: positions
		count: count.
	^{blend asArray collect: [:e | Color fromArgbCode: e]. positions asArray}!

blendColors: colorsArray positions: positionsArray
	"Set the preset colors and the blend positions of this path gradient brush.  colorsArray
	specifies the interpolation colors for the gradient. Each color in colorsArray 
	corresponds to a blend position in positionsArray.  Each blend position is a number from
	 0 through 1, where 0 indicates the boundary of the gradient and 1 indicates the center point. 
	A blend position between 0 and 1 specifies the set of all points that are a certain fraction of 
	the distance from the boundary to the center point. For example, a blend position of 0.7 
	specifies the set of all points that are 70 percent of the way from the boundary to the center point."

	self assert: [colorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	GdiplusLibrary default
		gdipSetPathGradientPresetBlend: self asParameter
		blend: (DWORDArray withAll: (colorsArray collect: [:e | e argbCode]))
		positions: (FLOATArray withAll: positionsArray)
		count: colorsArray size!

blendColorsCount
	"Answer the <Integer> number of preset colors currently set for the receiver."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPathGradientPresetBlendCount: self asParameter count: count.
	^count value!

blendFactors
	| count factors positions |
	count := self blendFactorsCount.
	factors := FLOATArray new: count.
	positions := FLOATArray new: count.
	GdiplusLibrary default
		gdipGetPathGradientBlend: self asParameter
		blend: factors
		positions: positions
		count: count.
	^{factors asArray. positions asArray}!

blendFactors: factorsArray positions: positionsArray
	| status |
	self assert: [factorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [factorsArray allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	GdiplusLibrary default
		gdipSetPathGradientBlend: self asParameter
		blend: (FLOATArray withAll: factorsArray)
		positions: (FLOATArray withAll: positionsArray)
		count: factorsArray size!

blendFactorsCount
	"Answer the <Integer> number of blend factors currently set for the receiver."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPathGradientBlendCount: self asParameter count: count.
	^count value!

blendTriangularShape: focusReal scale: scaleReal
	GdiplusLibrary default
		gdipSetPathGradientLinearBlend: self asParameter
		focus: focusReal
		scale: scaleReal!

bounds
	"Answer a bounding Rectangle for the receiver."

	| rect |
	rect := GpRect newBuffer.
	GdiplusLibrary default gdipGetPathGradientRectI: self asParameter rect: rect.
	^rect asRectangle!

centerColor
	"Answer the ARGB color that appears at the receiver's center point."

	| color |
	color := DWORDBytes new.
	(GdiplusLibrary default gdipGetPathGradientCenterColor: self asParameter colors: color).
	^Color fromArgbCode: color value!

centerColor: aColor
	"Set the color that appears at the receiver's center point."

	GdiplusLibrary default gdipSetPathGradientCenterColor: self asParameter colors: aColor argbCode!

centerPoint
	"Answer the center point of the receiver."

	| point |
	point := POINT new.
	GdiplusLibrary default gdipGetPathGradientCenterPointI: self asParameter points: point.
	^point asPoint!

centerPoint: aPoint
	"Set the center point of the receiver. By default, the center point is at the centroid of the 
	receiver's boundary path, but it can be set to any location inside or outside the path."

	GdiplusLibrary default gdipSetPathGradientCenterPointI: self asParameter
		points: (POINTL fromPoint: aPoint)!

focusScales
	"Answer a Point that represents the x and y scale factors for the receiver's center color relative to its boundary path."

	| x y |
	x := FLOAT new.
	y := FLOAT new.
	GdiplusLibrary default
		gdipGetPathGradientFocusScales: self asParameter
		xScale: x
		yScale: y.
	^x value @ y value!

focusScales: aPoint
	"Specify that the receiver's center color should appear within the receiver's boundary path 
	scaled by a factor of aPoint in the x and y directions."

	GdiplusLibrary default
		gdipSetPathGradientFocusScales: self asParameter
		xScale: aPoint x
		yScale: aPoint y!

isGammaCorrected
	"Answer whether or not gamma correction is applied to the receiver."

	| result |
	result := SDWORD new.
	GdiplusLibrary default gdipGetPathGradientGammaCorrection: self asParameter
		useGammaCorrection: result asParameter.
	^result ~= 0!

isGammaCorrected: aBoolean
	"Set whether or not gamma correction should be applied to the receiver."

	GdiplusLibrary default gdipSetPathGradientGammaCorrection: self asParameter
		useGammaCorrection: aBoolean asParameter!

multiplyTransform: aGdiplusMatrix 
	"Set the receiver's transformation matrix to the product of itself and aGdiplusMatrix."

	self multiplyTransform: aGdiplusMatrix order: nil!

multiplyTransform: aGdiplusMatrix order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and aGdiplusMatrix
	with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipMultiplyPathGradientTransform: self asParameter
		matrix: aGdiplusMatrix asParameter
		order: aMatrixOrderConstant!

pointCount
	"Private - Answer the number of points that define the receiver's boundary path."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPathGradientPointCount: self asParameter count: count.
	^count asInteger!

resetTransform
	"Set the receiver's transformation matrix to the identity matrix."

	GdiplusLibrary default gdipResetPathGradientTransform: self asParameter!

rotateTransform: aRealPoint 
	"Rotate the receiver's transformation matrix by aRealPoint."

	self rotateTransform: aRealPoint order: nil!

rotateTransform: aRealAngle order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a rotation matrix 
	defined by aRealAngle with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipRotatePathGradientTransform: self asParameter
		angle: aRealAngle
		order: aMatrixOrderConstant!

scaleTransform: aRealPoint 
	"Scale the receiver's transformation matrix by aRealPoint."

	self scaleTransform: aRealPoint order: nil!

scaleTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a scaling matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipScalePathGradientTransform: self asParameter
		sx: aRealPoint x
		sy: aRealPoint y
		order: aMatrixOrderConstant!

surroundColor: aColor
	"Set the specified <Color> as the single color that appears on the receiver's boundary."

	self surroundColors: (Array new: self pointCount withAll: aColor)!

surroundColors
	"Answer an Array of ARGB that are the receiver's boundary colors."

	| count colors |
	count := self surroundColorsCount.
	colors := DWORDArray new: count.
	count := DWORDBytes fromInteger: count.
	GdiplusLibrary default
		gdipGetPathGradientSurroundColorsWithCount: self asParameter
		color: colors
		count: count.
	^colors collect: [:e | Color fromArgbCode: e]!

surroundColors: colorsArray
	"Set the colors that appear on the receiver's boundaries."

	GdiplusLibrary default
		gdipSetPathGradientSurroundColorsWithCount: self asParameter
		color: (DWORDArray withAll: (colorsArray collect: [:e | e argbCode]))
		count: (DWORDBytes fromInteger: colorsArray size)!

surroundColorsCount
	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetPathGradientSurroundColorCount: self asParameter count: count.
	^count value!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| matrix |
	matrix := GdiplusMatrix new.
	GdiplusLibrary default gdipGetPathGradientTransform: self asParameter matrix: matrix asParameter.
	^matrix!

transform: aGdiplusMatrix
	"Set aGdiplusMatrix as the transformation matrix of the receiver."

	GdiplusLibrary default gdipSetPathGradientTransform: self asParameter
		matrix: aGdiplusMatrix asParameter!

translateTransform: aRealPoint 
	"Translate (shift) the receiver's transformation matrix by aRealPoint."

	self translateTransform: aRealPoint order: nil!

translateTransform: aRealPoint order: aMatrixOrderConstant
	"Set the receiver's transformation matrix to the product of itself and a translation matrix
	defined by aRealPoint with the order of transformation specified by aMatrixOrderConstant."

	GdiplusLibrary default
		gdipTranslatePathGradientTransform: self asParameter
		dx: aRealPoint x
		dy: aRealPoint y
		order: aMatrixOrderConstant!

wrapMode
	"Answer a number that indicates if and how painting is done outside the receiver's boundary path."

	| mode |
	mode := DWORDBytes new.
	GdiplusLibrary default gdipGetPathGradientWrapMode: self asParameter wrapMode: mode.
	^mode asInteger!

wrapMode: aWrapModeConstant
	"Set if and how painting is done outside the receiver's boundary path."

	GdiplusLibrary default gdipSetPathGradientWrapMode: self asParameter wrapMode: aWrapModeConstant! !

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

