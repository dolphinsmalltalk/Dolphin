"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusHatchBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusHatchBrush guid: (GUID fromString: '{1a1a5ea4-6151-11d7-b609-00e0987e8081}')!

GdiplusHatchBrush comment: 'A hatch brush paints a background and paints, over that background, a foreground that consists of a pattern of lines, dots, dashes, squares, crosshatch, or some variation of these. The hatch brush consists of two colors: one for the background and one for the foreground.'!

!GdiplusHatchBrush categoriesForClass!Unclassified! !

!GdiplusHatchBrush class methodsFor!

exampleGdipHBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with a Hatch Pattern
	This example fills an ellipse with a hatch pattern.

		self exampleGdipHBFillAShape showExample
	"

	| bitmap brush |
	bitmap := GdiplusBitmap extent: 250 @ 150.
	brush := GdiplusHatchBrush
				style: HatchStyleHorizontal
				forecolor: Color red
				backcolor: Color cyan.
	bitmap graphics fillEllipse: (10 @ 10 extent: 200 @ 100) brush: brush.
	^bitmap!

exampleGdipHBFillAString
	"This example fills a string with a hatch pattern.

		self exampleGdipHBFillAString showExample
	"

	| bitmap brush font |
	bitmap := GdiplusBitmap extent: 600 @ 150.
	brush := GdiplusHatchBrush
				style: HatchStyleLargeConfetti
				forecolor: Color yellow
				backcolor: Color blue.
	font := GdiplusFont name: 'Arial' pointSize: 72.
	bitmap graphics
		drawString: 'Hello Dolphin'
		font: font
		at: 10 @ 10
		format: nil
		brush: brush.
	^bitmap!

exampleGdipHBStyles
	"This example displays the effects of all HatchStyle constants.

		self exampleGdipHBStyles showExample
	"

	| bitmap styles brush font row col corner |
	bitmap := GdiplusBitmap extent: 800 @ 530.
	font := GdiplusFont name: 'Arial' pointSize: 10.
	styles := self enumsHatchStyle.
	styles removeLast.	"HatchStyleTotal doesn't work"
	styles keysAndValuesDo: 
			[:i :e |
			brush := GdiplusHatchBrush
						style: e value
						forecolor: Color red
						backcolor: Color yellow.  
			col := (i - 1) \\ 8.
			row := ((i - 1) / 8) truncated.
			corner := (col * 100 + 5) @ (row * 75 + 5).
			bitmap graphics
				fillRectangle: (corner extent: 90 @ 65) brush: brush;
				drawString: (e key midString: e key size - 10 from: 11)
					font: font
					rect: (corner extent: 90 @ 65)
					format: nil
					brush: nil].
	^bitmap!

style: aNumber forecolor: foreARGB backcolor: backARGB
	^self fromInitializer: (GdiplusHatchBrushInitializer 
				style: aNumber
				forecolor: foreARGB
				backcolor: backARGB)! !

!GdiplusHatchBrush class categoriesForMethods!
exampleGdipHBFillAShape!examples!public!sunit! !
exampleGdipHBFillAString!examples!public!sunit! !
exampleGdipHBStyles!examples!public!sunit! !
style:forecolor:backcolor:!instance creation!public! !
!

