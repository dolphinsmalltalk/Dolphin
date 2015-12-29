"Filed out from Dolphin Smalltalk X6"!

GdiplusBase subclass: #GdiplusFontCollection
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFontCollection guid: (GUID fromString: '{C09D8C02-5F28-11D7-B609-00E0987E8081}')!
GdiplusFontCollection comment: 'GdiplusFontCollection is an abstract class that contains methods for enumerating the font families in a collection of fonts.

'!
!GdiplusFontCollection categoriesForClass!Unclassified! !
!GdiplusFontCollection methodsFor!

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
			clonedHandle := ExternalHandle new.
			(status := GdiplusLibrary default gdipCloneFontFamily: e clonedFontFamily: clonedHandle) = Ok 
				ifTrue: [families add: (GdiplusFontFamily new handle: clonedHandle)]
				ifFalse: [GdiplusError signal: 'GdipCloneFontFamily failed' with: status]].
	^families!

familyCount
	"Answer the number of font families contained in the receiver."

	| status count |
	count := SDWORD new.
	(status := GdiplusLibrary default gdipGetFontCollectionFamilyCount: self asParameter numFound: count) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetFontCollectionFamilyCount failed' with: status].
	^count asInteger! !
!GdiplusFontCollection categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusFontCollection categoriesFor: #families!accessing!public! !
!GdiplusFontCollection categoriesFor: #familyCount!accessing!public! !

!GdiplusFontCollection class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon! !
!GdiplusFontCollection class categoriesFor: #icon!constants!development!public! !

