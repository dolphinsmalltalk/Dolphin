"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Brush subclass: #'Graphics.Gdiplus.HatchBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.HatchBrush guid: (Core.GUID fromString: '{1a1a5ea4-6151-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.HatchBrush comment: 'A hatch brush paints a background and paints, over that background, a foreground that consists of a pattern of lines, dots, dashes, squares, crosshatch, or some variation of these. The hatch brush consists of two colors: one for the background and one for the foreground.'!
!Graphics.Gdiplus.HatchBrush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.HatchBrush class methodsFor!

exampleGdipHBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with a Hatch Pattern
	This example fills an ellipse with a hatch pattern.

		self exampleGdipHBFillAShape showExample
	"

	| bitmap brush |
	bitmap := Bitmap extent: 250 @ 150.
	brush := HatchBrush
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
	bitmap := Bitmap extent: 600 @ 150.
	brush := HatchBrush
				style: HatchStyleLargeConfetti
				forecolor: Color yellow
				backcolor: Color blue.
	font := Font name: 'Arial' pointSize: 72.
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
	bitmap := Bitmap extent: 800 @ 530.
	font := Font name: 'Arial' pointSize: 10.
	styles := self enumsHatchStyle.
	styles removeLast.	"HatchStyleTotal doesn't work"
	styles keysAndValuesDo: 
			[:i :e |
			brush := HatchBrush
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
	^self fromInitializer: (HatchBrushInitializer
				style: aNumber
				forecolor: foreARGB
				backcolor: backARGB)! !
!Graphics.Gdiplus.HatchBrush class categoriesFor: #exampleGdipHBFillAShape!examples!public!sunit! !
!Graphics.Gdiplus.HatchBrush class categoriesFor: #exampleGdipHBFillAString!examples!public!sunit! !
!Graphics.Gdiplus.HatchBrush class categoriesFor: #exampleGdipHBStyles!examples!public!sunit! !
!Graphics.Gdiplus.HatchBrush class categoriesFor: #style:forecolor:backcolor:!instance creation!public! !

