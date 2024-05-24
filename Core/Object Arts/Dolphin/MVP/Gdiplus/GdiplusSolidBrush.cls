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
	| color |
	color := DWORDBytes new.
	GdiplusLibrary default gdipGetSolidFillColor: self asParameter color: color.
	^Color fromArgbCode: color value!

color: aColor
	GdiplusLibrary default gdipSetSolidFillColor: self asParameter color: aColor argbCode! !

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
green!instance creation!public! !
new!instance creation!public! !
red!instance creation!public! !
!

