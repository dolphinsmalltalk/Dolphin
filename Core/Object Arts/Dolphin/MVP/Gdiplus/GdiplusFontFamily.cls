﻿"Filed out from Dolphin Smalltalk 7"!

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

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipCloneFontFamily: self asParameter clonedFontFamily: gpHandle) 
		= Ok ifFalse: [GdiplusError signal: 'GdipCloneFontFamily failed' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

lineSpacing
	"Answer the vertical distance between the base lines of two consecutive lines of text."

	| status lineSpacing |
	lineSpacing := DWORD new.
	(status := GdiplusLibrary default 
				gdipGetLineSpacing: self asParameter
				style: 0
				lineSpacing: lineSpacing) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetLineSpacing failed' with: status].
	^lineSpacing asInteger!

name
	"Answer the String name of the receiver (e.g., 'Arial')."

	| status name |
	name := Utf16String newFixed: LF_FACESIZE.
	(status := GdiplusLibrary default
				gdipGetFamilyName: self asParameter
				name: name
				language: 0) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetFamilyName failed' with: status].
	^name asString trimNulls! !
!GdiplusFontFamily categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusFontFamily categoriesFor: #clone!copying!public! !
!GdiplusFontFamily categoriesFor: #lineSpacing!accessing!public! !
!GdiplusFontFamily categoriesFor: #name!accessing!public! !

!GdiplusFontFamily class methodsFor!

exampleGdipFFClone
	"MSDN: FontFamily::Clone
	This example creates a GdiplusFontFamily, clones it, then creates a GdiplusFont from the clone.

		self exampleGdipFFClone showExample
	"

	| bitmap fontFamily cloneFontFamily font |
	bitmap := GdiplusBitmap extent: 250 @ 100.
	fontFamily := GdiplusFontFamily fromName: 'arial'.
	cloneFontFamily := fontFamily clone.
	font := GdiplusFont fontFamily: cloneFontFamily emSize: 16.
	bitmap graphics 
		drawString: 'This is an Arial font'
		font: font
		at: 10 @ 10
		format: nil
		brush: nil.
	^bitmap!

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
!GdiplusFontFamily class categoriesFor: #exampleGdipFFClone!examples!public!sunit! !
!GdiplusFontFamily class categoriesFor: #fromName:!instance creation!public! !
!GdiplusFontFamily class categoriesFor: #fromName:fontCollection:!instance creation!public! !
!GdiplusFontFamily class categoriesFor: #genericSansSerif!instance creation!public! !
!GdiplusFontFamily class categoriesFor: #genericSerif!instance creation!public! !
!GdiplusFontFamily class categoriesFor: #icon!constants!development!public! !

