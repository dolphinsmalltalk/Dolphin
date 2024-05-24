"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusFontFamily
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontFamily guid: (GUID fromString: '{c09d8c08-5f28-11d7-b609-00e0987e8081}')!

GdiplusFontFamily comment: 'GdiplusFontFamily represents a set of fonts that make up a font family. A font family is a group of fonts that have the same typeface but different styles.

'!

!GdiplusFontFamily categoriesForClass!Unclassified! !

!GdiplusFontFamily methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteFontFamily: handle!

clone
	"Answer a copy of the receiver."

	| gpHandle |
	gpHandle := ExternalHandle new.
	GdiplusLibrary default gdipCloneFontFamily: self asParameter clonedFontFamily: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

lineSpacing
	"Answer the vertical distance between the base lines of two consecutive lines of text."

	| lineSpacing |
	lineSpacing := DWORDBytes new.
	GdiplusLibrary default
		gdipGetLineSpacing: self asParameter
		style: 0
		lineSpacing: lineSpacing.
	^lineSpacing asInteger!

name
	"Answer the String name of the receiver (e.g., 'Arial')."

	| name |
	name := Utf16String newFixed: LF_FACESIZE.
	GdiplusLibrary default
		gdipGetFamilyName: self asParameter
		name: name
		language: 0.
	^name asString trimNulls! !

!GdiplusFontFamily categoriesForMethods!
basicFree!private!realizing/unrealizing! !
clone!copying!public! !
lineSpacing!accessing!public! !
name!accessing!public! !
!

!GdiplusFontFamily class methodsFor!

fromName: aString
	^self fromName: aString fontCollection: nil!

fromName: aString fontCollection: aFontCollection
	^self fromInitializer: (GdiplusFontFamilyInitializer name: aString
				fontCollection: aFontCollection)!

genericSansSerif
	^self fromInitializer: GdiplusFontFamilyInitializer genericSansSerif!

genericSerif
	^self fromInitializer: GdiplusFontFamilyInitializer genericSerif!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon! !

!GdiplusFontFamily class categoriesForMethods!
fromName:!instance creation!public! !
fromName:fontCollection:!instance creation!public! !
genericSansSerif!instance creation!public! !
genericSerif!instance creation!public! !
icon!constants!development!public! !
!

