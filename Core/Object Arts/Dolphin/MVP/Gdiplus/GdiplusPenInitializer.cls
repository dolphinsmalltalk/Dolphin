"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusPenInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusPenInitializer guid: (GUID fromString: '{b5a5d186-b0ef-421c-befb-c5628a17fee9}')!
GdiplusPenInitializer isAbstract: true!
GdiplusPenInitializer comment: ''!
!GdiplusPenInitializer categoriesForClass!Unclassified! !
!GdiplusPenInitializer methodsFor!

gdiplusConstructorErrorDescription
	^'Error creating Pen'! !
!GdiplusPenInitializer categoriesForMethods!
gdiplusConstructorErrorDescription!constants!private! !
!

!GdiplusPenInitializer class methodsFor!

brush: aGdiplusBrush width: aFloat
	"Creates a Pen object that uses the attributes of a brush and a real number to set the width of this Pen object"

	^GdiplusPenFromBrushInitializer new brush: aGdiplusBrush width: aFloat!

color: anARGB width: aFloat
	"Creates a Pen object that uses a specified color and width."

	^GdiplusPenFromColorInitializer new color: anARGB width: aFloat! !
!GdiplusPenInitializer class categoriesForMethods!
brush:width:!instance creation!public! !
color:width:!instance creation!public! !
!

