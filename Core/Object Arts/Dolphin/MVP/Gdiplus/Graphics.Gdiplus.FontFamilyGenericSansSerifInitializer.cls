"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.FontFamilyGenericInitializer
	subclass: #'Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer guid: (Core.GUID fromString: '{f784e19e-0b3b-498c-a5c4-456c191906c7}')!

Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer comment: ''!

!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipGetGenericFontFamilySansSerif: gpHandle.
	^gpHandle!

printAttributesOn: aStream
	aStream nextPutAll: #genericSansSerif! !

!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer class methodsFor!

uninitialize
	GenericSansSerif := nil! !

!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer class categoriesForMethods!
uninitialize!class hierarchy-removing!private! !
!

