"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontFamilyGenericInitializer subclass: #'Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer guid: (Core.GUID fromString: '{f784e19e-0b3b-498c-a5c4-456c191906c7}')!
Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetGenericFontFamilyMonospace: gpHandle.
	^gpHandle!

printAttributesOn: aStream
	aStream nextPutAll: #genericMonospace! !
!Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer class methodsFor!

uninitialize
	GenericSansSerif := nil! !
!Graphics.Gdiplus.FontFamilyGenericMonospaceInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

