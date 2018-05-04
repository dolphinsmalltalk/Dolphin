"Filed out from Dolphin Smalltalk 7"!

GdiplusBase subclass: #GdiplusFont
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusFont guid: (GUID fromString: '{5b5d4ae1-5c87-11d7-b609-00e0987e8081}')!
GdiplusFont comment: 'GdiplusFont encapsulates the characteristics, such as family, height, size, and style (or combination of styles), of a specific font. A GdiplusFont is used when drawing strings on a GdiplusGraphics.'!
!GdiplusFont categoriesForClass!Unclassified! !
!GdiplusFont methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteFont: handle!

emSize
	"Answer the font size (commonly called the em size) of this Font object. The size is in the units of this Font object."

	| status size |
	size := FLOAT new.
	(status := GdiplusLibrary default gdipGetFontSize: self asParameter size: size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetFontSize failed' with: status].
	^size value!

family
	"Answer the FontFamily on which the receiver is based."

	| status gpHandle |
	gpHandle := GdiplusInstalledFontCollection new families first.
	(status := GdiplusLibrary default gdipGetFamily: self asParameter family: gpHandle asParameter) 
		= Ok ifFalse: [GdiplusError signal: 'GdipGetFamily failed' with: status].
	^gpHandle!

height
	"Answer the receiver's line spacing, in pixels. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| status height |
	height := FLOAT new.
	(status := GdiplusLibrary default 
				gdipGetFontHeightGivenDPI: self asParameter
				dpi: DesktopView current resolution y
				height: height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetFontHeightGivenDPI failed' with: status].
	^height value!

heightFromGraphics: aGdiplusGraphics 
	"Answer the receiver's line spacing, in units. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| status height |
	height := FLOAT new.
	(status := GdiplusLibrary default 
				gdipGetFontHeight: self asParameter
				graphics: aGdiplusGraphics asParameter
				height: height) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetFontHeight failed' with: status].
	^height value!

name
	"Answer the FontFamily name on which the receiver is based."

	^self family name!

unit
	"Answer an Integer, that represents the receiver's unit of measure."

	| status unit |
	unit := SDWORD new.
	(status := GdiplusLibrary default gdipGetFontUnit: self asParameter unit: unit) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetFontUnit failed' with: status].
	^unit value! !
!GdiplusFont categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusFont categoriesFor: #emSize!accessing!public! !
!GdiplusFont categoriesFor: #family!accessing!public! !
!GdiplusFont categoriesFor: #height!accessing!public! !
!GdiplusFont categoriesFor: #heightFromGraphics:!accessing!public! !
!GdiplusFont categoriesFor: #name!accessing!public! !
!GdiplusFont categoriesFor: #unit!accessing!public! !

!GdiplusFont class methodsFor!

exampleGdipFontHeight
	"MSDN:  Font::GetHeight
	This example gets a font's line spacing and draws a few strings with different spacings between them.

		self exampleGdipFontHeight showExample
	"

	| bitmap graphics font brush height |
	bitmap := GdiplusBitmap extent: 450 @ 150.
	graphics := bitmap graphics.
	font := GdiplusFont name: 'Arial' emSize: 18.
	brush := GdiplusSolidBrush black.
	height := font heightFromGraphics: graphics.
	graphics
		drawString: 'The first line of text at the very top'
			font: font
			at: Point zero
			format: nil
			brush: nil;
		drawString: 'The second line of text maybe too close'
			font: font
			at: 0 @ 0.6 * height
			format: nil
			brush: nil;
		drawString: 'The third line of text is single spaced'
			font: font
			at: 0 @ 1.6 * height
			format: nil
			brush: nil.
	^bitmap!

fontFamily: fontFamily emSize: emSize
	^self 
		fontFamily: fontFamily
		emSize: emSize
		style: FontStyleRegular
		unit: UnitPoint!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self fromInitializer: (GdiplusFontFromFontFamilyInitializer 
				fontFamily: fontFamily asParameter
				emSize: emSize
				style: style
				unit: unit)!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon!

name: aFontFamilyString emSize: emSize
	"Answer an instance of the receiver from aFontFamilyString (e.g., 'Arial') and specified emSize."

	^self fontFamily: (GdiplusFontFamily fromName: aFontFamilyString) emSize: emSize!

name: aFontFamilyString emSize: emSize style: style unit: unit
	^self 
		fontFamily: (GdiplusFontFamily fromName: aFontFamilyString)
		emSize: emSize
		style: style
		unit: unit!

new
	"Answer a new initialized instance of the receiver."

	^self name: 'Arial' emSize: Font default pointSize! !
!GdiplusFont class categoriesFor: #exampleGdipFontHeight!examples!public!sunit! !
!GdiplusFont class categoriesFor: #fontFamily:emSize:!instance creation!public! !
!GdiplusFont class categoriesFor: #fontFamily:emSize:style:unit:!instance creation!public! !
!GdiplusFont class categoriesFor: #icon!constants!development!public! !
!GdiplusFont class categoriesFor: #name:emSize:!instance creation!public! !
!GdiplusFont class categoriesFor: #name:emSize:style:unit:!instance creation!public! !
!GdiplusFont class categoriesFor: #new!instance creation!public! !

