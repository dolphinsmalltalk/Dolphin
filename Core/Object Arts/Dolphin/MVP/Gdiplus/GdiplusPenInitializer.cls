"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusPenInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenInitializer guid: (GUID fromString: '{B5A5D186-B0EF-421C-BEFB-C5628A17FEE9}')!
GdiplusPenInitializer comment: ''!
!GdiplusPenInitializer categoriesForClass!Unclassified! !
!GdiplusPenInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating Pen'! !
!GdiplusPenInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusPenInitializer class methodsFor!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^GdiplusPenFromBrushInitializer new brush: aGdiplusBrush width: aFloat!

color: anARGB width: aFloat
	"Creates a Pen object that uses a specified color and width."

	^GdiplusPenFromColorInitializer new color: anARGB width: aFloat! !
!GdiplusPenInitializer class categoriesFor: #brush:width:!instance creation!public! !
!GdiplusPenInitializer class categoriesFor: #color:width:!instance creation!public! !

