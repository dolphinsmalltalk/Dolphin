"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Brush subclass: #'Graphics.Gdiplus.PathGradientBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientBrush guid: (Core.GUID fromString: '{c8f38622-766b-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathGradientBrush comment: 'A path gradient brush paints a color gradient in which the color changes from a center point outward to a boundary that is defined by a closed curve or path. The color gradient has one color at the center point and one or multiple colors at the boundary. '!
!Graphics.Gdiplus.PathGradientBrush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PathGradientBrush methodsFor!

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
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientPresetBlendCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

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
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientBlendCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

blendTriangularShape: focusReal scale: scaleReal
	GdiplusLibrary default
		gdipSetPathGradientLinearBlend: self asParameter
		focus: focusReal
		scale: scaleReal!

bounds
	"Answer a bounding Rectangle for the receiver."

	| rect |
	rect := RECTL new.
	GdiplusLibrary default gdipGetPathGradientRectI: self asParameter rect: rect.
	^rect asRectangle!

centerColor
	"Answer the ARGB color that appears at the receiver's center point."

	| color |
	color := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientCenterColor: self asParameter colors: color.
	^Color fromArgbCode: (color dwordAtOffset: 0)!

centerColor: aColor
	"Set the color that appears at the receiver's center point."

	GdiplusLibrary default gdipSetPathGradientCenterColor: self asParameter colors: aColor argbCode!

centerPoint
	"Answer the center point of the receiver."

	| point |
	point := POINTL new.
	GdiplusLibrary default gdipGetPathGradientCenterPointI: self asParameter points: point.
	^point asPoint!

centerPoint: aPoint
	"Set the center point of the receiver. By default, the center point is at the centroid of the 
	receiver's boundary path, but it can be set to any location inside or outside the path."

	GdiplusLibrary default gdipSetPathGradientCenterPointI: self asParameter
		points: (POINTL fromPoint: aPoint)!

focusScales
	"Answer a Point that represents the x and y scale factors for the receiver's center color relative to its boundary path."

	| buf y |
	buf := ByteArray newFixed: 8.
	GdiplusLibrary default
		gdipGetPathGradientFocusScales: self asParameter
		xScale: buf
		yScale: buf yourAddress + 4.
	^(buf floatAtOffset: 0) @ (buf floatAtOffset: 4)!

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
	result := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientGammaCorrection: self asParameter
		useGammaCorrection: result asParameter.
	^(result sdwordAtOffset: 0) ~~ 0!

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
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientPointCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

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
	count := DWORD fromInteger: count.
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
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientSurroundColorCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

transform
	"Answer a GdiplusMatrix that is the receiver's transformation matrix."

	| matrix |
	matrix := Matrix new.
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
	mode := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetPathGradientWrapMode: self asParameter wrapMode: mode.
	^mode dwordAtOffset: 0!

wrapMode: aWrapModeConstant
	"Set if and how painting is done outside the receiver's boundary path."

	GdiplusLibrary default gdipSetPathGradientWrapMode: self asParameter wrapMode: aWrapModeConstant! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendBellShape:scale:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendColors!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendColors:positions:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendColorsCount!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendFactors!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendFactors:positions:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendFactorsCount!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #blendTriangularShape:scale:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #bounds!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #centerColor!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #centerColor:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #centerPoint!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #centerPoint:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #focusScales!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #focusScales:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #isGammaCorrected!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #isGammaCorrected:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #multiplyTransform:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #multiplyTransform:order:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #pointCount!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #resetTransform!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #rotateTransform:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #rotateTransform:order:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #scaleTransform:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #scaleTransform:order:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #surroundColor:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #surroundColors!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #surroundColors:!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #surroundColorsCount!accessing-properties!private! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #transform!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #transform:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #translateTransform:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #translateTransform:order:!accessing-transformations!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #wrapMode!accessing-properties!public! !
!Graphics.Gdiplus.PathGradientBrush categoriesFor: #wrapMode:!accessing-properties!public! !

!Graphics.Gdiplus.PathGradientBrush class methodsFor!

exampleGdipPGBlendColors
	"This example displays a triangular brush with different color and positions controlling the gradient areas.

		self exampleGdipPGBlendColors showExample
	"

	| bitmap graphics brush colors |
	bitmap := Bitmap extent: 400 @ 400.
	graphics := bitmap graphics.
	brush := PathGradientBrush points: {100 @ 0. 200 @ 200. 0 @ 200} wrapMode: WrapModeTile.
	colors := self rgb.
	graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 0 + 10.
	brush blendColors: colors positions: #(0 0.1 1).
	graphics
		fillRectangle: (200 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Pos: ' , (((brush blendColors at: 2) at: 2) roundTo: 0.1) displayString
			at: 200 @ 0 + 10.
	brush blendColors: colors positions: #(0 0.5 1).
	graphics
		fillRectangle: (0 @ 200 extent: 200 @ 200) brush: brush;
		drawString: 'Pos: ' , (((brush blendColors at: 2) at: 2) roundTo: 0.1) displayString
			at: 0 @ 200 + 10.
	brush blendColors: colors positions: #(0 0.9 1).
	graphics
		fillRectangle: (200 @ 200 extent: 200 @ 200) brush: brush;
		drawString: 'Pos: ' , (((brush blendColors at: 2) at: 2) roundTo: 0.1) displayString
			at: 200 @ 200 + 10.
	^bitmap!

exampleGdipPGBlendFactors
	"This example shows the effects of setting blend factors and positions on ellipse and rectangle brushes.

		self exampleGdipPGBlendFactors showExample
	"

	| bitmap graphics path brush |
	bitmap := Bitmap extent: 600 @ 300.
	graphics := bitmap graphics.
	path := Path new addEllipse: (0 @ 0 corner: 200 @ 150).
	(brush := PathGradientBrush path: path)
		wrapMode: WrapModeTile;
		centerColor: Color blue;
		surroundColors: (Array new: brush pointCount withAll: Color red).
	graphics fillRectangle: (0 @ 0 extent: 200 @ 150) brush: brush.
	brush blendFactors: #(0 0.4 0.8 1) positions: #(0 0.1 0.9 1).
	graphics fillRectangle: (200 @ 0 extent: 200 @ 150) brush: brush.
	brush blendFactors: #(0 0.1 0.5 1) positions: #(0 0.3 0.7 1).
	graphics fillRectangle: (400 @ 0 extent: 200 @ 150) brush: brush.
	path := Path new addRectangle: (0 @ 0 corner: 200 @ 150).
	(brush := PathGradientBrush path: path)
		wrapMode: WrapModeTile;
		centerColor: Color blue;
		surroundColors: {Color green. Color red}.
	graphics fillRectangle: (0 @ 150 extent: 200 @ 150) brush: brush.
	brush blendFactors: #(0 0.4 0.8 1) positions: #(0 0.1 0.9 1).
	graphics fillRectangle: (200 @ 150 extent: 200 @ 150) brush: brush.
	brush blendFactors: #(0 0.1 0.5 1) positions: #(0 0.3 0.7 1).
	graphics fillRectangle: (400 @ 150 extent: 200 @ 150) brush: brush.
	^bitmap!

exampleGdipPGBounds
	"This example creates a path gradient brush from a polygon defined by 4 points and gets the
	bounding rectangle of that polygon, i.e., the smallest rectangle that the polygon fits in.  It then
	fills the polygon with the brush and draws outlines of the polygon and the bounding rectangle.
	NB:  See comment below regarding problem with #bounds.

		self exampleGdipPGBounds showExample
	"

	| bitmap points brush bounds |
	bitmap := Bitmap extent: 250 @ 300.
	points := {0 @ 0. 120 @ 20. 70 @ 80. 30 @ 180}.
	"Uncomment the next line and see how this doesn't seem to work right."
	"points := points collect: [:e | e + (20 @ 30)]."
	brush := PathGradientBrush points: points.
	bitmap graphics translateTransform: 20 @ 30.
	bounds := brush bounds.
	bitmap graphics
		fillRectangle: bounds brush: brush;
		drawRectangle: bounds pen: Pen new;
		drawPolygon: points pen: Pen red.
	"	fillPolygon: points brush: brush.	"
	^bitmap!

exampleGdipPGCenterColor
	"This example creates a GdiplusPathGradientBrush from a path and sets its center color.

		self exampleGdipPGCenterColor showExample
	"

	| bitmap path brush |
	bitmap := Bitmap extent: 350 @ 250.
	path := Path new addEllipse: (10 @ 10 corner: 300 @ 200).
	brush := PathGradientBrush path: path.
	brush centerColor: Color blue.
	bitmap graphics fillRectangle: (10 @ 10 corner: 300 @ 200) brush: brush.
	^bitmap!

exampleGdipPGCenterPoint
	"This example shows the effect of changing the center point.

		self exampleGdipPGCenterPoint showExample
	"

	| bitmap graphics path brush |
	bitmap := Bitmap extent: 300 @ 450.
	graphics := bitmap graphics.
	path := Path new addEllipse: (Point zero extent: 300 @ 150).
	(brush := PathGradientBrush path: path)
		centerColor: Color blue;
		wrapMode: WrapModeTile;
		surroundColor: Color cyan.
	graphics fillEllipse: (0 @ 0 extent: 300 @ 150) brush: brush.
	graphics drawString: 'Center Point - center' at: 0 @ 0 + 10.
	brush centerPoint: 250 @ 75.
	graphics fillEllipse: (0 @ 150 extent: 300 @ 150) brush: brush.
	graphics drawString: 'Center Point - on right, inside ellipse' at: 0 @ 150 + 10.
	brush centerPoint: 300 @ 75.
	graphics fillEllipse: (0 @ 300 extent: 300 @ 150) brush: brush.
	graphics drawString: 'Center Point - on right, outside ellipse' at: 0 @ 300 + 10.
	^bitmap!

exampleGdipPGFocusScales
	"This example shows a triangle brush at normal size and then with focus scaled.

		self exampleGdipPGFocusScales showExample
	"

	| bitmap brush focusBrush |
	bitmap := Bitmap extent: 500 @ 250.
	brush := PathGradientBrush points: self triangle.
	brush blendColors: {Color red. Color blue} positions: #(0 1).
	focusBrush := brush clone focusScales: 0.2 @ 0.6.
	bitmap graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 0;
		translateTransform: 250 @ 0;
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: focusBrush;
		drawString: 'Focus scales' at: 0 @ 0.
	^bitmap!

exampleGdipPGGamma
	"MSDN:  Using GDI+ >  Filling Shapes with a Gradient Brush > Applying Gamma Correction to a Gradient
	This example shows a brush based on a star-shaped path with and without gamma correction applied.

		self exampleGdipPGGamma showExample
	"

	| bitmap points path colors brush |
	bitmap := Bitmap extent: 400 @ 200.
	points := OrderedCollection new
				add: 75 @ 0;
				add: 100 @ 50;
				add: 150 @ 50;
				add: 112 @ 75;
				add: 150 @ 150;
				add: 75 @ 100;
				add: 0 @ 150;
				add: 37 @ 75;
				add: 0 @ 50;
				add: 50 @ 50;
				yourself.
	path := Path new addLines: points.
	colors := OrderedCollection new
				add: Color black;
				add: Color green;
				add: Color blue;
				add: Color white;
				add: Color black;
				add: Color green;
				add: Color blue;
				add: Color white;
				add: Color black;
				add: Color green;
				yourself.
	(brush := PathGradientBrush path: path)
		centerColor: Color red;
		surroundColors: colors.
	bitmap graphics fillPath: path brush: brush.
	brush isGammaCorrected: true.
	bitmap graphics
		translateTransform: 200 @ 0;
		fillPath: path brush: brush;
		resetTransform;
		drawString: 'Original' at: 0 @ 160;
		drawString: 'Gamma corrected' at: 200 @ 160.
	^bitmap!

exampleGdipPGMultiply
	"This example shows a triangle brush at normal size, then scaled, then scaled and multiplied.

		self exampleGdipPGMultiply showExample
	"

	| bitmap graphics points matrix brush |
	bitmap := Bitmap extent: 650 @ 350.
	graphics := bitmap graphics.
	points := {0 @ 0. 150 @ 0. 150 @ 150}.
	brush := PathGradientBrush points: points.
	graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 40.
	matrix := Matrix fromArray: #(1 0 0 1 150 150).
	brush scaleTransform: 3 @ 1 order: nil.
	graphics
		fillRectangle: (0 @ 0 extent: 450 @ 150) brush: brush;
		drawString: 'Scaled' at: 200 @ 0.
	brush multiplyTransform: matrix order: MatrixOrderAppend.
	graphics
		fillRectangle: (0 @ 0 extent: 600 @ 300) brush: brush;
		drawString: 'Scaled and Multiplied' at: 350 @ 150.
	^bitmap!

exampleGdipPGScale
	"This example shows a triangle brush at normal size and then scaled.

		self exampleGdipPGScale showExample
	"

	| bitmap brush scaledBrush |
	bitmap := Bitmap extent: 650 @ 350.
	brush := PathGradientBrush points: self triangle.
	brush centerColor: Color red.
	scaledBrush := brush copy scaleTransform: 3 @ 1.5.
	bitmap graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 40;
		fillRectangle: (0 @ 0 extent: 600 @ 600) brush: scaledBrush;
		drawString: 'Scaled' at: 200 @ 0.
	^bitmap!

exampleGdipPGSurroundColors
	"This example creates a path gradient brush from a path, then sets its center and outer boundary colors.

		self exampleGdipPGSurroundColors showExample
	"

	| bitmap brush |
	bitmap := Bitmap extent: 400 @ 400.
	brush := PathGradientBrush points: self triangle.
	brush wrapMode: WrapModeTile.
	brush centerColor: Color yellow.
	bitmap graphics fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush.
	brush surroundColor: Color red.
	bitmap graphics fillRectangle: (200 @ 0 extent: 200 @ 200) brush: brush.
	brush surroundColors: {Color red. Color green}.
	bitmap graphics fillRectangle: (0 @ 200 extent: 200 @ 200) brush: brush.
	brush surroundColors: self rgb.
	bitmap graphics fillRectangle: (200 @ 200 extent: 200 @ 200) brush: brush.
	^bitmap!

exampleGdipPGSurroundColors2
	"This example creates a path gradient brush from a an elliptical path, then sets its outer boundary colors.

		self exampleGdipPGSurroundColors2 showExample
	"

	| bitmap path brush |
	bitmap := Bitmap extent: 600 @ 450.
	path := Path new addEllipse: (0 @ 0 extent: 200 @ 150).
	(brush := PathGradientBrush path: path)
		wrapMode: WrapModeTile;
		centerColor: Color yellow.
	bitmap graphics fillRectangle: (0 @ 0 extent: 200 @ 150) brush: brush.
	brush surroundColors: {Color red}.
	bitmap graphics fillRectangle: (200 @ 0 extent: 200 @ 150) brush: brush.
	brush surroundColors: {Color red. Color green}.
	bitmap graphics fillRectangle: (400 @ 0 extent: 200 @ 150) brush: brush.
	brush surroundColors: self rgb.
	bitmap graphics fillRectangle: (0 @ 150 extent: 200 @ 150) brush: brush.
	brush surroundColors: self rgb , {Color cyan}.
	bitmap graphics fillRectangle: (200 @ 150 extent: 200 @ 150) brush: brush.
	brush surroundColors: self rgb , {Color cyan. Color magenta}.
	bitmap graphics fillRectangle: (400 @ 150 extent: 200 @ 150) brush: brush.
	brush surroundColors: self rgb , {Color cyan. Color magenta. Color black}.
	bitmap graphics fillRectangle: (0 @ 300 extent: 200 @ 150) brush: brush.
	brush
		surroundColors: (Array new: 13 withAll: Color cyan) , (Array new: 13 withAll: Color magenta)
				, (Array new: 13 withAll: Color yellow) , (Array new: 13 withAll: Color red)
				, (Array new: 13 withAll: Color blue).
	bitmap graphics fillRectangle: (200 @ 300 extent: 200 @ 150) brush: brush.
	brush surroundColor: Color red.
	bitmap graphics fillRectangle: (400 @ 300 extent: 200 @ 150) brush: brush.
	^bitmap!

exampleGdipPGTransform
	"This example shows a triangle brush at normal size, then scaled, then scaled and multiplied.

		self exampleGdipPGTransform showExample
	"

	| bitmap graphics matrix brush |
	bitmap := Bitmap extent: 500 @ 350.
	graphics := bitmap graphics.
	brush := PathGradientBrush points: self triangle.
	brush wrapMode: WrapModeTile.
	brush centerColor: Color yellow.
	brush surroundColors: self rgb.
	graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 0.
	"Set the transformation for the brush (rotate, then translate)."
	matrix := Matrix fromArray: #(0 1 -1 0 250 100).
	brush transform: matrix.
	graphics
		fillRectangle: (250 @ 100 extent: 200 @ 200) brush: brush;
		drawString: 'Rotated and translated' at: 250 @ 80.
	^bitmap!

exampleGdipPGTranslate
	"This example shows a triangle brush before and after translation.

		self exampleGdipPGTranslate showExample
	"

	| bitmap brush translateBrush |
	bitmap := Bitmap extent: 400 @ 300.
	brush := PathGradientBrush points: self triangle.
	brush centerColor: Color blue.
	translateBrush := brush clone translateTransform: 125 @ 75.
	bitmap graphics
		fillRectangle: (0 @ 0 extent: 200 @ 200) brush: brush;
		drawString: 'Original' at: 0 @ 0;
		fillRectangle: (0 @ 0 extent: 400 @ 300) brush: translateBrush;
		drawString: 'Translated' at: 200 @ 75.
	^bitmap!

exampleGdipPGWrapMode
	"This example displays the effects of different WrapMode constants.

		self exampleGdipPGWrapMode showExample
	"

	| bitmap pathPoints brush points modes |
	bitmap := Bitmap extent: 600 @ 400.
	pathPoints := {5 @ 5. 25 @ 30. 35 @ 60. 10 @ 50}.
	points := {0 @ 0. 200 @ 0. 400 @ 0. 0 @ 200. 200 @ 200}.
	"Take out 'reverse' in next line and see the effect on WrapModeClamp."
	modes := self enumsWrapMode reverse.
	self assert: [points size = modes size].
	modes with: points
		do: 
			[:assoc :point |
			brush := PathGradientBrush points: pathPoints wrapMode: assoc value.
			brush centerColor: Color red.
			bitmap graphics
				fillRectangle: (point + 10 extent: 180 @ 180) brush: brush;
				drawString: assoc key at: point].
	^bitmap!

examplesWorkspace
	"Private - These are examples in progress.  Evaluate each block separately (or all at once).

		self examplesWorkspace
	"

	| graphics bitmap points brush path colors rect |
	#'Graphics.Gdiplus.PathGradientBrush'.

	"#blendFactors:positions:"
	graphics := (bitmap := Bitmap new) graphics.
	path := Path new addEllipse: (10 @ 10 corner: 300 @ 200).
	brush := PathGradientBrush path: path.
	brush centerColor: Color red.
	brush surroundColor: Color cyan.
	brush blendFactors: #(0 0.4 0.8 1) positions: #(0 0.3 0.7 1).
	graphics fillRectangle: (10 @ 10 corner: 350 @ 350) brush: brush.
	bitmap showExample.

	"blendTriangularShape:scale:"
	graphics := (bitmap := Bitmap new) graphics.
	path := Path new addEllipse: (10 @ 10 corner: 300 @ 200).
	brush := PathGradientBrush path: path.
	brush centerColor: Color red.
	colors := {Color blue}.
	brush surroundColors: colors.
	brush blendTriangularShape: 0.2 scale: 0.7.
	graphics fillRectangle: (10 @ 10 corner: 350 @ 350) brush: brush.
	bitmap showExample.

	"blendBellShape:scale:"
	graphics := (bitmap := Bitmap new) graphics.
	path := Path new addEllipse: (10 @ 10 corner: 300 @ 200).
	brush := PathGradientBrush path: path.
	brush centerColor: Color red.
	colors := {Color blue}.
	brush surroundColors: colors.
	brush blendBellShape: 0.2 scale: 0.7.
	graphics fillRectangle: (10 @ 10 corner: 350 @ 350) brush: brush.
	bitmap showExample.

	"#bounds"
	graphics := (bitmap := Bitmap new) graphics.
	points := {30 @ 20. 150 @ 40. 100 @ 100. 60 @ 200}.
	"	points := points collect: [:e | e - (30@20)].		"
	"	points := points collect: [:e | e + (100@100)].	"
	brush := PathGradientBrush points: points.
	rect := brush bounds.
	graphics fillRectangle: rect brush: brush.
	graphics drawRectangle: rect pen: Pen new.
	graphics drawPolygon: points pen: Pen red.
	"	graphics fillPolygon: points brush: brush.	"
	bitmap showExample!

path: aGdiplusPath
	"Answer an instance of the receiver with boundary aGdiplusPath."

	^self fromInitializer: (PathGradientFromPathInitializer path: aGdiplusPath)!

points: points 
	"Answer an instance of the receiver with boundary path specified by points."

	^self points: points wrapMode: WrapModeClamp!

points: points wrapMode: aWrapModeConstant
	"Answer an instance of the receiver with boundary path specified by points and 
	wrap mode specified by aWrapModeConstant."

	^self
		fromInitializer: (PathGradientFromPointsInitializer points: points wrapMode: aWrapModeConstant)!

rgb
	"Private - Answer a 3-element Array containing red, green, and blue Colors."

	^{Color red. Color green. Color blue}!

triangle
	^{100 @ 0. 200 @ 200. 0 @ 200}! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGBlendColors!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGBlendFactors!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGBounds!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGCenterColor!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGCenterPoint!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGFocusScales!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGGamma!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGMultiply!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGScale!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGSurroundColors!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGSurroundColors2!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGTransform!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGTranslate!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #exampleGdipPGWrapMode!examples!public!sunit! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #examplesWorkspace!examples!private! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #path:!instance creation!public! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #points:!instance creation!public! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #points:wrapMode:!instance creation!public! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #rgb!examples!private! !
!Graphics.Gdiplus.PathGradientBrush class categoriesFor: #triangle!examples!private! !

