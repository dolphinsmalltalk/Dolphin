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
	| status numSought numFound gpHandles clonedHandle families |
	numSought := self familyCount.
	numFound := SDWORD new.
	gpHandles := DWORDArray new: numSought.
	(status := GdiplusLibrary default
				gdipGetFontCollectionFamilyList: self asParameter
				numSought: numSought
				gpfamilies: gpHandles
				numFound: numFound) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetFontCollectionFamilyList failed' with: status].
	families := OrderedCollection new.
	gpHandles asOrderedCollection do: 
			[:e |
			clonedHandle := Handle new.
			(status := GdiplusLibrary default gdipCloneFontFamily: e clonedFontFamily: clonedHandle) = Ok
				ifTrue: [families add: (FontFamily new handle: clonedHandle)]
				ifFalse: [GdiplusError signal: 'GdipCloneFontFamily failed' with: status]].
	^families!

familyCount
	"Answer the number of font families contained in the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetFontCollectionFamilyCount: self asParameter numFound: count)
		= Ok ifFalse: [GdiplusError signal: 'GdipGetFontCollectionFamilyCount failed' with: status].
	^count asInteger! !
!Graphics.Gdiplus.FontCollection categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.FontCollection categoriesFor: #families!accessing!public! !
!Graphics.Gdiplus.FontCollection categoriesFor: #familyCount!accessing!public! !

!Graphics.Gdiplus.FontCollection class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Font icon! !
!Graphics.Gdiplus.FontCollection class categoriesFor: #icon!constants!development!public! !

