"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.FontFromFontFamilyInitializer'
	instanceVariableNames: 'fontFamily emSize style unit'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFromFontFamilyInitializer guid: (Core.GUID fromString: '{f4b7aa80-5fd1-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontFromFontFamilyInitializer comment: ''!
!Graphics.Gdiplus.FontFromFontFamilyInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := Handle new.
	status := self library
				gdipCreateFont: fontFamily
				emSize: emSize
				style: style
				unit: unit
				font: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

fontFamily: aFontFamily emSize: aNumberSize style: aNumberStyle unit: aNumberUnit
	fontFamily := aFontFamily.
	emSize := aNumberSize.
	style := aNumberStyle.
	unit := aNumberUnit!

gdiplusConstructorErrorDescription
	^'Error creating Font'! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer categoriesFor: #fontFamily:emSize:style:unit:!initializing!private! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!Graphics.Gdiplus.FontFromFontFamilyInitializer class methodsFor!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self new 
		fontFamily: fontFamily
		emSize: emSize
		style: style
		unit: unit! !
!Graphics.Gdiplus.FontFromFontFamilyInitializer class categoriesFor: #fontFamily:emSize:style:unit:!instance creation!public! !

