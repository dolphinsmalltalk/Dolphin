"Filed out from Dolphin Smalltalk 7"!

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
	^ARGB fromInteger: color value!

color: anARGB 
	| status |
	(status := GdiplusLibrary default gdipSetSolidFillColor: self asParameter color: anARGB asParameter) 
		= Ok ifFalse: [GdiplusError signal: 'GdipSetSolidFillColor failed' with: status]! !
!GdiplusSolidBrush categoriesFor: #color!accessing!public! !
!GdiplusSolidBrush categoriesFor: #color:!accessing!public! !

!GdiplusSolidBrush class methodsFor!

black
	^self color: ARGB black!

blue
	^self color: ARGB blue!

color: anARGB
	"Creates a SolidBrush object based on a color."

	^self fromInitializer: (GdiplusSolidBrushFromColorInitializer color: anARGB)!

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
		brush: (GdiplusSolidBrush color: (ARGB 
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
		fillRectangle: rect brush: (GdiplusSolidBrush color: Color white asARGB);
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
	^self color: ARGB green!

new
	^self black!

red
	^self color: ARGB red! !
!GdiplusSolidBrush class categoriesFor: #black!instance creation!public! !
!GdiplusSolidBrush class categoriesFor: #blue!instance creation!public! !
!GdiplusSolidBrush class categoriesFor: #color:!instance creation!public! !
!GdiplusSolidBrush class categoriesFor: #exampleGdipDropShadow!examples!public!sunit! !
!GdiplusSolidBrush class categoriesFor: #exampleGdipSBFillAShape!examples!public!sunit! !
!GdiplusSolidBrush class categoriesFor: #green!instance creation!public! !
!GdiplusSolidBrush class categoriesFor: #new!instance creation!public! !
!GdiplusSolidBrush class categoriesFor: #red!instance creation!public! !

