"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Brush subclass: #'Graphics.Gdiplus.LinearGradientBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrush guid: (Core.GUID fromString: '{0ea671c7-823f-4367-89b3-c28e45a365ea}')!
Graphics.Gdiplus.LinearGradientBrush comment: 'GdiplusLinearGradientBrush paints a color gradient in which the color changes evenly from the starting boundary line of an instance to its ending boundary line. Boundary lines are two parallel straight lines. The color gradient is perpendicular to the boundary lines, changing gradually across the stroke from starting to ending boundary lines. The color gradient has one color at the starting boundary line and another color at the ending boundary line.'!
!Graphics.Gdiplus.LinearGradientBrush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.LinearGradientBrush methodsFor!

blendCount
	"Private - Answer the number of blend factors currently set for the receiver."

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetLineBlendCount: self asParameter count: count.
	^count sdwordAtOffset: 0!

blendFactors
	"Answer a two-element array that holds two arrays that contain the receiver's blend factors 
	and their corresponding blend positions."

	| count factorsArray positionsArray |
	count := self blendCount.
	factorsArray := FLOATArray new length: count.
	positionsArray := FLOATArray new length: count.
	GdiplusLibrary default
		gdipGetLineBlend: self asParameter
		blend: factorsArray
		positions: positionsArray
		count: count.
	^{factorsArray asArray. positionsArray asArray}!

blendFactors: factorsArray positions: positionsArray
	"Set the receiver's blend factors and blend positions to create a custom blend."

	self assert: [factorsArray size = positionsArray size].
	self assert: [positionsArray size >= 2].
	self assert: [factorsArray allSatisfy: [:each | each between: 0 and: 1]].
	self assert: [positionsArray first = 0 and: [positionsArray last = 1]].
	GdiplusLibrary default
		gdipSetLineBlend: self asParameter
		blend: (FLOATArray withAll: factorsArray)
		positions: (FLOATArray withAll: positionsArray)
		count: positionsArray size!

isGammaCorrected
	"Answer whether gamma correction is applied to the receiver when rendering."

	| result |
	result := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetLineGammaCorrection: self asParameter useGammaCorrection: result.
	^(result sdwordAtOffset: 0) ~~ 0!

isGammaCorrected: aBoolean
	"Set whether gamma correction is applied to the receiver when rendering."

	GdiplusLibrary default gdipSetLineGammaCorrection: self asParameter
		useGammaCorrection: aBoolean asParameter!

startingColor: startColor endingColor: endColor
	"Set the receiver's starting and ending colors."

	GdiplusLibrary default
		gdipSetLineColors: self asParameter
		color1: startColor argbCode
		color2: endColor argbCode! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #blendCount!accessing!private! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #blendFactors!accessing!public! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #blendFactors:positions:!accessing!public! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #isGammaCorrected!accessing!public! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #isGammaCorrected:!accessing!public! !
!Graphics.Gdiplus.LinearGradientBrush categoriesFor: #startingColor:endingColor:!accessing!public! !

!Graphics.Gdiplus.LinearGradientBrush class methodsFor!

exampleGdipLGChangingColors
	"This example shows changing starting and ending colors.

		self exampleGdipLGChangingColors showExample
	"

	| bitmap graphics points colors brush |
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	colors := #(#red #green #blue #magenta #cyan).
	brush := LinearGradientBrush
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
	bitmap := Bitmap extent: 600 @ 400.
	brush := LinearGradientBrush
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
	bitmap := Bitmap extent: 600 @ 400.
	brush := LinearGradientBrush
				point1: 0 @ 0
				point2: 200 @ 100
				color1: Color blue
				color2: Color green.
	pen := Pen brush: brush width: 10.
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
	bitmap := Bitmap extent: 600 @ 250.
	brush := LinearGradientBrush
				point1: 0 @ 10
				point2: 200 @ 10
				color1: Color red
				color2: Color blue.
	pen := Pen brush: brush width: 3.
	bitmap graphics
		drawLine: (0 @ 10 corner: 200 @ 10) pen: pen;
		fillEllipse: (0 @ 30 extent: 200 @ 100) brush: brush;
		fillRectangle: (0 @ 155 extent: 500 @ 30) brush: brush.
	^bitmap!

exampleGdipLGModeConstants
	"This example shows the different effects of LinearGradientMode constants.

		self exampleGdipLGModeConstants showExample
	"

	| bitmap graphics points enum brush |
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	points keysAndValuesDo: 
			[:i :point |
			enum := self enumsLinearGradientMode at: i.
			brush := LinearGradientBrush
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
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	points := {0 @ 0. 300 @ 0. 0 @ 200. 300 @ 200}.
	points keysAndValuesDo: 
			[:i :point |
			enum := self enumsLinearGradientMode at: i.
			brush := LinearGradientBrush
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

	^self fromInitializer: (LinearGradientBrushFromPointsInitializer
				point1: point1
				point2: point2
				color1: color1
				color2: color2)!

rect: rect color1: color1 color2: color2 mode: aLinearGradientMode
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (LinearGradientBrushFromRectInitializer
				rect: rect
				color1: color1
				color2: color2
				mode: aLinearGradientMode)! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGChangingColors!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGCustom!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGDiagonal!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGHorizontal!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGModeConstants!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #exampleGdipLGTiling!examples!public!sunit! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #point1:point2:color1:color2:!instance creation!public! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesFor: #rect:color1:color2:mode:!instance creation!public! !

