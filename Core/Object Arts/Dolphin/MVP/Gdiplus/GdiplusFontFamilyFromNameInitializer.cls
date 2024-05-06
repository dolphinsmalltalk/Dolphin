"Filed out from Dolphin Smalltalk"!

GdiplusFontFamilyInitializer subclass: #GdiplusFontFamilyFromNameInitializer
	instanceVariableNames: 'name fontCollection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontFamilyFromNameInitializer guid: (GUID fromString: '{2688e140-b9b7-4e51-9b2d-f8bba5c90e2b}')!

GdiplusFontFamilyFromNameInitializer comment: ''!

!GdiplusFontFamilyFromNameInitializer categoriesForClass!Unclassified! !

!GdiplusFontFamilyFromNameInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateFontFamilyFromName: name
				fontCollection: fontCollection asParameter
				fontFamily: gpHandle.
	^status == Ok 
		ifTrue: [gpHandle]
		ifFalse: [
			"For consistency of behaviour with GDI fonts in Dolphin, don't fail if the FontFamily doesn't exist on the machine, but rather return a generic font family. This is fairly likely anyway, and it is not particuarly useful to fail when the machine does not have the requested font installed."
			self class genericSansSerif createHandle].!

name: aString fontCollection: aFontCollection
	name := aString.
	fontCollection := aFontCollection! !

!GdiplusFontFamilyFromNameInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
name:fontCollection:!initializing!private! !
!

