"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontFamilyGenericInitializer subclass: #'Graphics.Gdiplus.FontFamilyGenericSerifInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyGenericSerifInitializer guid: (Core.GUID fromString: '{57c9fb99-3104-48e2-b5e7-d4f2041b5a3e}')!
Graphics.Gdiplus.FontFamilyGenericSerifInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetGenericFontFamilySerif: gpHandle.
	^gpHandle!

printAttributesOn: aStream
	aStream nextPutAll: #genericSerif! !
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.FontFamilyGenericSerifInitializer class methodsFor!

uninitialize
	GenericSerif := nil! !
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

