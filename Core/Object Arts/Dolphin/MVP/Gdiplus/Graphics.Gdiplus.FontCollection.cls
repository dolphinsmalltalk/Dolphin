"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.FontCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontCollection guid: (Core.GUID fromString: '{c09d8c02-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontCollection isNonInstantiable: true!
Graphics.Gdiplus.FontCollection comment: 'GdiplusFontCollection is an abstract class that contains methods for enumerating the font families in a collection of fonts.

'!
!Graphics.Gdiplus.FontCollection categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontCollection methodsFor!

basicFree
	"Private - Overridden to suppress error message."

	!

families
	^self families: self familyCount!

families: anInteger
	| numFound families clonedHandle gpHandles |
	numFound := ByteArray newFixed: 4.
	gpHandles := DWORDArray new: anInteger.
	GdiplusLibrary default
		gdipGetFontCollectionFamilyList: self asParameter
		numSought: anInteger
		gpfamilies: gpHandles
		numFound: numFound.
	numFound := numFound sdwordAtOffset: 0.
	families := Array new: numFound.
	gpHandles
		from: 1
		to: numFound
		keysAndValuesDo: 
			[:eachKey :eachValue |
			clonedHandle := Handle new.
			GdiplusLibrary default gdipCloneFontFamily: eachValue clonedFontFamily: clonedHandle.
			families at: eachKey put: (FontFamily fromOwnedHandle: clonedHandle)].
	^families!

familyCount
	"Answer the number of font families contained in the receiver."

	| count |
	count := ByteArray newFixed: 4.
	GdiplusLibrary default gdipGetFontCollectionFamilyCount: self asParameter numFound: count.
	^count sdwordAtOffset: 0! !
!Graphics.Gdiplus.FontCollection categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.FontCollection categoriesFor: #families!accessing!public! !
!Graphics.Gdiplus.FontCollection categoriesFor: #families:!public! !
!Graphics.Gdiplus.FontCollection categoriesFor: #familyCount!accessing!public! !

!Graphics.Gdiplus.FontCollection class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Font icon! !
!Graphics.Gdiplus.FontCollection class categoriesFor: #icon!constants!development!public! !

