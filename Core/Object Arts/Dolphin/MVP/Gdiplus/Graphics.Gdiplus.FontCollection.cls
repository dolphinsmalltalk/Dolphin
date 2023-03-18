"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.FontCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontCollection guid: (Core.GUID fromString: '{c09d8c02-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontCollection isNonInstantiable: true!
Graphics.Gdiplus.FontCollection comment: 'GdiplusFontCollection is an abstract class that contains methods for enumerating the font families in a collection of fonts.

'!
!Graphics.Gdiplus.FontCollection methodsFor!

families
	^self families: self familyCount!

families: anInteger
	| numFound families clonedHandle gpHandles |
	numFound := UInt32Bytes new.
	gpHandles := UIntPtrArray new: anInteger.
	Gdip
		gdipGetFontCollectionFamilyList: self asParameter
		numSought: anInteger
		gpfamilies: gpHandles
		numFound: numFound.
	numFound := numFound asSignedInteger.
	families := Array new: numFound.
	gpHandles
		from: 1
		to: numFound
		keysAndValuesDo: 
			[:eachKey :eachValue |
			clonedHandle := Handle new.
			Gdip gdipCloneFontFamily: eachValue clonedFontFamily: clonedHandle.
			families at: eachKey put: (FontFamily fromOwnedHandle: clonedHandle)].
	^families!

familiesByName
	| families count |
	count := self familyCount.
	families := LookupTable new: count.
	(self families: count) do: [:each | families at: each name put: each].
	^families!

familyCount
	"Answer the number of font families contained in the receiver."

	| count |
	count := UInt32Bytes new.
	Gdip gdipGetFontCollectionFamilyCount: self asParameter numFound: count.
	^count asSignedInteger! !
!Graphics.Gdiplus.FontCollection categoriesForMethods!
families!accessing!public! !
families:!accessing!public! !
familiesByName!accessing!public! !
familyCount!accessing!public! !
!

!Graphics.Gdiplus.FontCollection class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon!

installed
	^InstalledFontCollection new!

installedFamilies
	^self installed familiesByName! !
!Graphics.Gdiplus.FontCollection class categoriesForMethods!
icon!constants!development!public! !
installed!instance creation!public! !
installedFamilies!enquiries!public! !
!

