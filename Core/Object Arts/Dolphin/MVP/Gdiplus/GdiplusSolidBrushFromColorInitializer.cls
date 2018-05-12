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
	color := anARGB!

createHandle
	" SolidBrush(IN const Color& color)
    	{
       	 GpSolidFill *brush = NULL;

	        lastResult = DllExports::GdipCreateSolidFill(color.GetValue(), &brush);
	    };"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateSolidFill: color asParameter brush: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating SolidBrush'! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #color:!accessing!public! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusSolidBrushFromColorInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusSolidBrushFromColorInitializer class methodsFor!

color: anARGB
	^self new color: anARGB! !
!GdiplusSolidBrushFromColorInitializer class categoriesFor: #color:!instance creation!public! !

