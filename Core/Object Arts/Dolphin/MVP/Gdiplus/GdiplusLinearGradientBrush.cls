"Filed out from Dolphin Smalltalk 7"!

GdiplusBrush subclass: #GdiplusLinearGradientBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusLinearGradientBrush guid: (GUID fromString: '{0ea671c7-823f-4367-89b3-c28e45a365ea}')!
GdiplusLinearGradientBrush comment: 'GdiplusLinearGradientBrush paints a color gradient in which the color changes evenly from the starting boundary line of an instance to its ending boundary line. Boundary lines are two parallel straight lines. The color gradient is perpendicular to the boundary lines, changing gradually across the stroke from starting to ending boundary lines. The color gradient has one color at the starting boundary line and another color at the ending boundary line.'!
!GdiplusLinearGradientBrush categoriesForClass!Unclassified! !
!GdiplusLinearGradientBrush methodsFor!

blendCount
	"Private - Answer the number of blend factors currently set for the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetLineBlendCount: self asParameter count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetLineBlendCount failed' with: status].
	^count asInteger!

blendFactors
	"Answer a two-element array that holds two arrays that contain the receiver's blend factors 
	and their corresponding blend positions."

	| status count factorsArray positionsArray |
	count := self blendCount.
	factorsArray := FLOATArray new length: count.
	positionsArray := FLOATArray new length: count.
	status := GdiplusLibrary default
				gdipGetLineBlend: self asParameter
				blend: factorsArray
				positions: positionsArray
				count: count.
	status = Ok ifFalse: [GdiplusError signal: 'GdipGetBlend failed' with: status].
	^{factorsArray asArray. positionsArray asArray}!

blendFactors: factorsArray positions: positionsArray 
	"Set the receiver's blend factors and blend positions to create a custom blend."

	| status |
	self assert: [factorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [factorsArray allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	status := GdiplusLibrary default 
				gdipSetLineBlend: self asParameter
				blend: (FLOATArray withAll: factorsArray)
				positions: (FLOATArray withAll: positionsArray)
				count: positionsArray size.
	status = Ok ifFalse: [GdiplusError signal: 'GdipSetLineBlend failed' with: status]!

isGammaCorrected
	"Answer whether gamma correction is applied to the receiver when rendering."

	| status result |
	result := SDWORD new.
	(status := GdiplusLibrary default gdipGetLineGammaCorrection: self asParameter
				useGammaCorrection: result) = Ok 
		ifFalse: [GdiplusError signal: 'GdipgetLineGammaCorrection failed' with: status].
	^result ~= 0!

isGammaCorrected: aBoolean 
	"Set whether gamma correction is applied to the receiver when rendering."

	| status |
	(status := GdiplusLibrary default gdipSetLineGammaCorrection: self asParameter
				useGammaCorrection: aBoolean asParameter) = Ok 
		ifFalse: [GdiplusError signal: 'GdipSetLineGammaCorrection failed' with: status]!

startingColor: startColor endingColor: endColor
	"Set the receiver's starting and ending colors."

	| status |
	(status := GdiplusLibrary default
				gdipSetLineColors: self asParameter
				color1: startColor argbCode
				color2: endColor argbCode) == Ok
		ifFalse: [GdiplusError signal: 'GdipSetLineColors failed' with: status]! !
!GdiplusLinearGradientBrush categoriesFor: #blendCount!accessing!private! !
!GdiplusLinearGradientBrush categoriesFor: #blendFactors!accessing!public! !
!GdiplusLinearGradientBrush categoriesFor: #blendFactors:positions:!accessing!public! !
!GdiplusLinearGradientBrush categoriesFor: #isGammaCorrected!accessing!public! !
!GdiplusLinearGradientBrush categoriesFor: #isGammaCorrected:!accessing!public! !
!GdiplusLinearGradientBrush categoriesFor: #startingColor:endingColor:!accessing!public! !

!GdiplusLinearGradientBrush class methodsFor!

exampleGdipLGChangingColors
	"This example shows changing starting and ending colors.

		self exampleGdipLGChangingColors showExample
	"

	| bitmap graphics points colors brush |
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	colors := #(#red #green #blue #magenta #cyan).
	brush := GdiplusLinearGradientBrush
				point1: 0 @ 0
				point2: 0 @ 200
				color1: Color blue
				color2: Color blue.
	points keysAndValuesDo: 
			[:i :point |
			brush startingColor: (Color named: (colors at: i)) endingColor: (Color named: (colors at: i + 1)).
			graphics fillRectangle: (point extent: 300 @ 200) brush: brush].
	^bitmap!

exampleGdipLGCustom
	"MSDN:   Using GDI+ >  Filling Shapes with a Gradient Brush > Creating a Linear Gradient, Custom
	This example uses a customized linear gradient brush to fill an ellipse and a rectangle.

		self exampleGdipLGCustom showExample
	"

	| bitmap brush |
	bitmap := GdiplusBitmap extent: 600 @ 400.
	brush := GdiplusLinearGradientBrush
				point1: 0 @ 10
				point2: 200 @ 10
				color1: Color black
				color2: Color red.
	brush blendFactors: #(0.0 0.5 1.0) positions: #(0.0 0.2 1.0).
	bitmap graphics
		fillEllipse: (0 @ 30 extent: 200 @ 100) brush: brush;
		fillRectangle: (0 @ 155 extent: 500 @ 30) brush: brush.
	^bitmap!

exampleGdipLGDiagonal
	"MSDN:   Using GDI+ >  Filling Shapes with a Gradient Brush > Creating a Linear Gradient, Diagonal
	This example uses a customized linear gradient brush to fill an ellipse and a line.

		self exampleGdipLGDiagonal showExample
	"

	| bitmap brush pen |
	bitmap := GdiplusBitmap extent: 600 @ 400.
	brush := GdiplusLinearGradientBrush
				point1: 0 @ 0
				point2: 200 @ 100
				color1: Color blue
				color2: Color green.
	pen := GdiplusPen brush: brush width: 10.
	bitmap graphics
		drawLine: (0 @ 0 extent: 600 @ 300) pen: pen;
		fillEllipse: (10 @ 100 extent: 200 @ 100) brush: brush.
	^bitmap!

exampleGdipLGHorizontal
	"MSDN:   Using GDI+ >  Filling Shapes with a Gradient Brush > Creating a Linear Gradient, Horizontal
	This example uses a horizontal linear gradient brush to draw a line and fill an ellipse and rectangle.

		self exampleGdipLGHorizontal showExample
	"

	| bitmap brush pen |
	bitmap := GdiplusBitmap extent: 600 @ 250.
	brush := GdiplusLinearGradientBrush 
				point1: 0 @ 10
				point2: 200 @ 10
				color1: Color red
				color2: Color blue.
	pen := GdiplusPen brush: brush width: 3.
	(bitmap graphics)
		drawLine: (0 @ 10 corner: 200 @ 10) pen: pen;
		fillEllipse: (0 @ 30 extent: 200 @ 100) brush: brush;
		fillRectangle: (0 @ 155 extent: 500 @ 30) brush: brush.
	^bitmap!

exampleGdipLGModeConstants
	"This example shows the different effects of LinearGradientMode constants.

		self exampleGdipLGModeConstants showExample
	"

	| bitmap graphics points enum brush |
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	points keysAndValuesDo: 
			[:i :point |
			enum := self enumsLinearGradientMode at: i.
			brush := GdiplusLinearGradientBrush
						rect: (0 @ 0 corner: 300 @ 200)
						color1: Color red
						color2: Color yellow
						mode: enum value.
			graphics
				fillRectangle: (point extent: 300 @ 200) brush: brush;
				drawString: enum key at: point].
	^bitmap!

exampleGdipLGTiling
	"This example shows the different effects of tiling with LinearGradientMode constants.

		self exampleGdipLGTiling showExample
	"

	| bitmap graphics points enum brush |
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	points keysAndValuesDo: 
			[:i :point |
			enum := self enumsLinearGradientMode at: i.
			brush := GdiplusLinearGradientBrush
						rect: (0 @ 0 corner: 75 @ 50)
						color1: Color blue
						color2: Color cyan
						mode: enum value.
			graphics
				fillRectangle: (point extent: 300 @ 200) brush: brush;
				drawString: enum key at: point].
	^bitmap!

point1: point1 point2: point2 color1: color1 color2: color2
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (GdiplusLinearGradientBrushFromPointsInitializer 
				point1: point1
				point2: point2
				color1: color1
				color2: color2)!

rect: rect color1: color1 color2: color2 mode: aLinearGradientMode
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (GdiplusLinearGradientBrushFromRectInitializer 
				rect: rect
				color1: color1
				color2: color2
				mode: aLinearGradientMode)! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGChangingColors!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGCustom!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGDiagonal!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGHorizontal!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGModeConstants!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #exampleGdipLGTiling!examples!public!sunit! !
!GdiplusLinearGradientBrush class categoriesFor: #point1:point2:color1:color2:!instance creation!public! !
!GdiplusLinearGradientBrush class categoriesFor: #rect:color1:color2:mode:!instance creation!public! !

