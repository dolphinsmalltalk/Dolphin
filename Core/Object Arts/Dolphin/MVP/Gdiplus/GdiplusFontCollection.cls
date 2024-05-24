"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusFontCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontCollection guid: (GUID fromString: '{c09d8c02-5f28-11d7-b609-00e0987e8081}')!

GdiplusFontCollection isAbstract: true!

GdiplusFontCollection comment: 'GdiplusFontCollection is an abstract class that contains methods for enumerating the font families in a collection of fonts.

'!

!GdiplusFontCollection categoriesForClass!Unclassified! !

!GdiplusFontCollection methodsFor!

basicFree
	"Private - Overridden to suppress error message."

	!

families
	| numSought numFound gpHandles clonedHandle families |
	numSought := self familyCount.
	numFound := SDWORD new.
	gpHandles := DWORDArray new: numSought.
	GdiplusLibrary default
		gdipGetFontCollectionFamilyList: self asParameter
		numSought: numSought
		gpfamilies: gpHandles
		numFound: numFound.
	families := OrderedCollection new.
	gpHandles asOrderedCollection do: 
			[:e |
			clonedHandle := ExternalHandle new.
			GdiplusLibrary default gdipCloneFontFamily: e clonedFontFamily: clonedHandle.
			families add: (GdiplusFontFamily new handle: clonedHandle)].
	^families!

familyCount
	"Answer the number of font families contained in the receiver."

	| count |
	count := SDWORD new.
	GdiplusLibrary default gdipGetFontCollectionFamilyCount: self asParameter numFound: count.
	^count asInteger! !

!GdiplusFontCollection categoriesForMethods!
basicFree!private!realizing/unrealizing! !
families!accessing!public! !
familyCount!accessing!public! !
!

!GdiplusFontCollection class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon! !

!GdiplusFontCollection class categoriesForMethods!
icon!constants!development!public! !
!

