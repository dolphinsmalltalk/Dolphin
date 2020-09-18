"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Brush subclass: #'Graphics.Gdiplus.SolidBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.SolidBrush guid: (Core.GUID fromString: '{7f8ddb06-89ba-471a-a00c-73f32cbb0af7}')!
Graphics.Gdiplus.SolidBrush comment: 'A solid brush paints a single, constant color that can be opaque or transparent.'!
!Graphics.Gdiplus.SolidBrush categoriesForClass!Unclassified! !
!Graphics.Gdiplus.SolidBrush methodsFor!

color
	| color |
	color := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetSolidFillColor: self asParameter color: color.
	^Color fromArgbCode: (color dwordAtOffset: 0)!

color: aColor
	GdiplusLibrary default gdipSetSolidFillColor: self asParameter color: aColor argbCode! !
!Graphics.Gdiplus.SolidBrush categoriesFor: #color!accessing!public! !
!Graphics.Gdiplus.SolidBrush categoriesFor: #color:!accessing!public! !

!Graphics.Gdiplus.SolidBrush class methodsFor!

black
	^self color: Color black!

blue
	^self color: Color blue!

color: aColor
	"Creates a SolidBrush object based on a color."

	^self fromInitializer: (SolidBrushFromColorInitializer color: aColor)!

exampleGdipDropShadow
	"
	self exampleGdipDropShadow showExample
	"

	| rect shadowRect shadow bitmap offset |
	rect := 0 @ 0 corner: 100 @ 60.
	offset := 8 @ 8.
	shadowRect := rect topLeft // offset corner: rect extent // offset.
	shadow := Bitmap extent: shadowRect extent.
	shadow graphics fillRectangle: shadowRect
		brush: (SolidBrush color: (Color
						a: 128
						r: 0
						g: 0
						b: 0)).
	bitmap := Bitmap extent: rect extent + (offset * 2).
	bitmap graphics
		interpolationMode: InterpolationModeHighQualityBicubic;
		drawImage: shadow
			at: offset
			extent: rect extent
			from: 0 @ 0
			extent: shadowRect extent.
	bitmap graphics
		fillRectangle: rect brush: (SolidBrush color: Color white);
		drawRectangle: rect.
	^bitmap!

exampleGdipSBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with a Solid Color

		self exampleGdipSBFillAShape showExample
	"

	| bitmap |
	bitmap := Bitmap extent: 200 @ 150.
	bitmap graphics fillEllipse: (50 @ 50 extent: 100 @ 60) brush: SolidBrush red.
	^bitmap!

green
	^self color: Color green!

new
	^self black!

red
	^self color: Color red! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #black!instance creation!public! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #blue!instance creation!public! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #color:!instance creation!public! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #exampleGdipDropShadow!examples!public!sunit! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #exampleGdipSBFillAShape!examples!public!sunit! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #green!instance creation!public! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.SolidBrush class categoriesFor: #red!instance creation!public! !

