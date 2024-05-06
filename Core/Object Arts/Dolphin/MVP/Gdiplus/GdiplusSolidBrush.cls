"Filed out from Dolphin Smalltalk"!

GdiplusBrush subclass: #GdiplusSolidBrush
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'GdiplusConstants'
	classInstanceVariableNames: ''!

GdiplusSolidBrush guid: (GUID fromString: '{7f8ddb06-89ba-471a-a00c-73f32cbb0af7}')!

GdiplusSolidBrush comment: 'A solid brush paints a single, constant color that can be opaque or transparent.'!

!GdiplusSolidBrush categoriesForClass!Unclassified! !

!GdiplusSolidBrush methodsFor!

color
	| status color |
	color := DWORD new.
	(status := GdiplusLibrary default gdipGetSolidFillColor: self asParameter color: color) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetSolidFillColor failed' with: status].
	^Color fromArgbCode: color value!

color: aColor
	| status |
	(status := GdiplusLibrary default gdipSetSolidFillColor: self asParameter color: aColor argbCode)
		== Ok ifFalse: [GdiplusError signal: 'GdipSetSolidFillColor failed' with: status]! !

!GdiplusSolidBrush categoriesForMethods!
color!accessing!public! !
color:!accessing!public! !
!

!GdiplusSolidBrush class methodsFor!

black
	^self color: Color black!

blue
	^self color: Color blue!

color: aColor
	"Creates a SolidBrush object based on a color."

	^self fromInitializer: (GdiplusSolidBrushFromColorInitializer color: aColor)!

exampleGdipDropShadow
	"
	self exampleGdipDropShadow showExample
	"

	| rect shadowRect shadow bitmap offset |
	rect := 0 @ 0 corner: 100 @ 60.
	offset := 8@8.
	shadowRect := rect topLeft // offset corner: rect extent // offset.
	shadow := GdiplusBitmap extent: shadowRect extent.
	shadow graphics fillRectangle: shadowRect
		brush: (GdiplusSolidBrush color: (Color 
						a: 128
						r: 0
						g: 0
						b: 0)).
	bitmap := GdiplusBitmap extent: rect extent + (offset*2).
	(bitmap graphics)
		interpolationMode: InterpolationModeHighQualityBicubic;
		drawImage: shadow
			at: offset
			extent: rect extent
			from: 0 @ 0
			extent: shadowRect extent.
	(bitmap graphics)
		fillRectangle: rect brush: (GdiplusSolidBrush color: Color white);
		drawRectangle: rect.
	^bitmap!

exampleGdipSBFillAShape
	"MSDN: GDI+ > Using GDI+ > Using a Brush to Fill Shapes > Filling a Shape with a Solid Color

		self exampleGdipSBFillAShape showExample
	"

	| bitmap |
	bitmap := GdiplusBitmap extent: 200 @ 150.
	bitmap graphics fillEllipse: (50 @ 50 extent: 100 @ 60) brush: GdiplusSolidBrush red.
	^bitmap!

green
	^self color: Color green!

new
	^self black!

red
	^self color: Color red! !

!GdiplusSolidBrush class categoriesForMethods!
black!instance creation!public! !
blue!instance creation!public! !
color:!instance creation!public! !
exampleGdipDropShadow!examples!public!sunit! !
exampleGdipSBFillAShape!examples!public!sunit! !
green!instance creation!public! !
new!instance creation!public! !
red!instance creation!public! !
!

