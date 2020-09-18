"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PenInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PenInitializer guid: (Core.GUID fromString: '{b5a5d186-b0ef-421c-befb-c5628a17fee9}')!
Graphics.Gdiplus.PenInitializer isNonInstantiable: true!
Graphics.Gdiplus.PenInitializer comment: ''!
!Graphics.Gdiplus.PenInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PenInitializer class methodsFor!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^PenFromBrushInitializer new brush: aGdiplusBrush width: aFloat!

color: anARGB width: aFloat
	"Creates a Pen object that uses a specified color and width."

	^PenFromColorInitializer new color: anARGB width: aFloat! !
!Graphics.Gdiplus.PenInitializer class categoriesFor: #brush:width:!instance creation!public! !
!Graphics.Gdiplus.PenInitializer class categoriesFor: #color:width:!instance creation!public! !

