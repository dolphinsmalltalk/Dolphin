"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusSolidBrushFromColorInitializer
	instanceVariableNames: 'color'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusSolidBrushFromColorInitializer guid: (GUID fromString: '{02b80350-515e-40c3-8ec4-b328a7a4bcbb}')!
GdiplusSolidBrushFromColorInitializer comment: ''!
!GdiplusSolidBrushFromColorInitializer categoriesForClass!Unclassified! !
!GdiplusSolidBrushFromColorInitializer methodsFor!

color: anARGB
	color := anARGB asARGB!

createHandle
	"Private -  SolidBrush(IN const Color& color)
    	{
       	 GpSolidFill *brush = NULL;

	        lastResult = DllExports::GdipCreateSolidFill(color.GetValue(), &brush);
	    };"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	(status := self library gdipCreateSolidFill: color asParameter brush: gpHandle) == Ok
		ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating SolidBrush'! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #color:!initializing!private! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusSolidBrushFromColorInitializer class methodsFor!

color: anARGB
	^self new color: anARGB! !
!GdiplusSolidBrushFromColorInitializer class categoriesFor: #color:!instance creation!public! !

