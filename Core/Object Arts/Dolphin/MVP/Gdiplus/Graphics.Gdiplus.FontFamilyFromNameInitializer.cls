"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FontFamilyInitializer subclass: #'Graphics.Gdiplus.FontFamilyFromNameInitializer'
	instanceVariableNames: 'name fontCollection'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamilyFromNameInitializer guid: (Core.GUID fromString: '{2688e140-b9b7-4e51-9b2d-f8bba5c90e2b}')!
Graphics.Gdiplus.FontFamilyFromNameInitializer comment: ''!
!Graphics.Gdiplus.FontFamilyFromNameInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontFamilyFromNameInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := Handle new.
	status := self library
				gdipCreateFontFamilyFromName: name
				fontCollection: fontCollection asParameter
				fontFamily: gpHandle.
	^status = Ok
		ifTrue: [gpHandle]
		ifFalse: 
			["For consistency of behaviour with GDI fonts in Dolphin, don't fail if the FontFamily doesn't exist on the machine, but rather return a generic font family. This is fairly likely anyway, and it is not particuarly useful to fail when the machine does not have the requested font installed."
			self class genericSansSerif createHandle]!

name: aString fontCollection: aFontCollection
	name := aString.
	fontCollection := aFontCollection! !
!Graphics.Gdiplus.FontFamilyFromNameInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.FontFamilyFromNameInitializer categoriesFor: #name:fontCollection:!initializing!private! !

