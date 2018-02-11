"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusFontFamilyInitializer
	instanceVariableNames: 'name fontCollection'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFontFamilyInitializer guid: (GUID fromString: '{c09d8c09-5f28-11d7-b609-00e0987e8081}')!
GdiplusFontFamilyInitializer comment: ''!
!GdiplusFontFamilyInitializer categoriesForClass!Unclassified! !
!GdiplusFontFamilyInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateFontFamilyFromName: name asUtf16String
				fontCollection: fontCollection asParameter
				fontFamily: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating FontFamily'!

name: aString fontCollection: aFontCollection
	name := aString.
	fontCollection := aFontCollection! !
!GdiplusFontFamilyInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusFontFamilyInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusFontFamilyInitializer categoriesFor: #name:fontCollection:!accessing!public! !

!GdiplusFontFamilyInitializer class methodsFor!

name: aString fontCollection: aFontCollection
	^self new name: aString fontCollection: aFontCollection! !
!GdiplusFontFamilyInitializer class categoriesFor: #name:fontCollection:!accessing!public! !

