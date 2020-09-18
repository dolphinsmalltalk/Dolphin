"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FontFamilyInitializer subclass: #'Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer guid: (Core.GUID fromString: '{f784e19e-0b3b-498c-a5c4-456c191906c7}')!
Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipGetGenericFontFamilySansSerif: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer class methodsFor!

uninitialize
	GenericSansSerif := nil! !
!Graphics.Gdiplus.FontFamilyGenericSansSerifInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

