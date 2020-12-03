"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FontFamilyInitializer subclass: #'Graphics.Gdiplus.FontFamilyGenericSerifInitializer'
	instanceVariableNames: ''
	classVariableNames: 'Default'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyGenericSerifInitializer guid: (Core.GUID fromString: '{57c9fb99-3104-48e2-b5e7-d4f2041b5a3e}')!
Graphics.Gdiplus.FontFamilyGenericSerifInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := Handle new.
	status := self library gdipGetGenericFontFamilySerif: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle! !
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.FontFamilyGenericSerifInitializer class methodsFor!

uninitialize
	GenericSerif := nil! !
!Graphics.Gdiplus.FontFamilyGenericSerifInitializer class categoriesFor: #uninitialize!class hierarchy-removing!private! !

