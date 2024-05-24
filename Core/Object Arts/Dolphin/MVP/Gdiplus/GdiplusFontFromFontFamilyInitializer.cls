"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusFontFromFontFamilyInitializer
	instanceVariableNames: 'fontFamily emSize style unit'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusFontFromFontFamilyInitializer guid: (GUID fromString: '{f4b7aa80-5fd1-11d7-b609-00e0987e8081}')!

GdiplusFontFromFontFamilyInitializer comment: ''!

!GdiplusFontFromFontFamilyInitializer categoriesForClass!Unclassified! !

!GdiplusFontFromFontFamilyInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library
		gdipCreateFont: fontFamily
		emSize: emSize
		style: style
		unit: unit
		font: gpHandle.
	^gpHandle!

fontFamily: aFontFamily emSize: aNumberSize style: aNumberStyle unit: aNumberUnit
	fontFamily := aFontFamily.
	emSize := aNumberSize.
	style := aNumberStyle.
	unit := aNumberUnit! !

!GdiplusFontFromFontFamilyInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
fontFamily:emSize:style:unit:!initializing!private! !
!

!GdiplusFontFromFontFamilyInitializer class methodsFor!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self new 
		fontFamily: fontFamily
		emSize: emSize
		style: style
		unit: unit! !

!GdiplusFontFromFontFamilyInitializer class categoriesForMethods!
fontFamily:emSize:style:unit:!instance creation!public! !
!

