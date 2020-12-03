"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Font'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Font guid: (Core.GUID fromString: '{5b5d4ae1-5c87-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Font comment: 'GdiplusFont encapsulates the characteristics, such as family, height, size, and style (or combination of styles), of a specific font. A GdiplusFont is used when drawing strings on a GdiplusGraphics.'!
!Graphics.Gdiplus.Font categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Font methodsFor!

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
	gpHandle := InstalledFontCollection new families first.
	(status := GdiplusLibrary default gdipGetFamily: self asParameter family: gpHandle asParameter) = Ok
		ifFalse: [GdiplusError signal: 'GdipGetFamily failed' with: status].
	^gpHandle!

height
	"Answer the receiver's line spacing, in pixels. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| status height |
	height := FLOAT new.
	(status := GdiplusLibrary default
				gdipGetFontHeightGivenDPI: self asParameter
				dpi: UI.DesktopView current resolution y
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
!Graphics.Gdiplus.Font categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Gdiplus.Font categoriesFor: #emSize!accessing!public! !
!Graphics.Gdiplus.Font categoriesFor: #family!accessing!public! !
!Graphics.Gdiplus.Font categoriesFor: #height!accessing!public! !
!Graphics.Gdiplus.Font categoriesFor: #heightFromGraphics:!accessing!public! !
!Graphics.Gdiplus.Font categoriesFor: #name!accessing!public! !
!Graphics.Gdiplus.Font categoriesFor: #unit!accessing!public! !

!Graphics.Gdiplus.Font class methodsFor!

exampleGdipFontHeight
	"MSDN:  Font::GetHeight
	This example gets a font's line spacing and draws a few strings with different spacings between them.

		self exampleGdipFontHeight showExample
	"

	| bitmap graphics font height |
	bitmap := Bitmap extent: 450 @ 150.
	graphics := bitmap graphics.
	font := Font name: 'Arial' pointSize: 18.
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
	Notification deprecated.
	^self fontFamily: fontFamily pointSize: emSize!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self fromInitializer: (FontFromFontFamilyInitializer
				fontFamily: fontFamily asParameter
				emSize: emSize
				style: style
				unit: unit)!

fontFamily: aGdiplusFontFamily pointSize: anInteger
	^self 
		fontFamily: aGdiplusFontFamily
		emSize: anInteger
		style: FontStyleRegular
		unit: UnitPoint!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Font icon!

name: aFontFamilyString emSize: emSize
	Notification deprecated.
	^self name: aFontFamilyString pointSize: emSize!

name: aFontFamilyString emSize: emSize style: style unit: unit
	^self
		fontFamily: (FontFamily fromName: aFontFamilyString)
		emSize: emSize
		style: style
		unit: unit!

name: aFontFamilyString pixelSize: pels
	"Answer an instance of the receiver from aFontFamilyString (e.g., 'Arial') and specified pixel height."

	^self name: aFontFamilyString pixelSize: pels style: FontStyleRegular!

name: aFontFamilyString pixelSize: pels style: styleInteger
	"Answer an instance of the receiver from aFontFamilyString (e.g., 'Arial') and specified pixel height and style."

	^self name: aFontFamilyString emSize: pels style: styleInteger unit: UnitPixel!

name: aFontFamilyString pointSize: emSize
	"Answer an instance of the receiver from aFontFamilyString (e.g., 'Arial') and specified point size."

	^self
		name: aFontFamilyString
		pointSize: emSize
		style: FontStyleRegular!

name: aFontFamilyString pointSize: emSize style: styleInteger
	"Answer an instance of the receiver from aFontFamilyString (e.g., 'Arial') and specified point size and style."

	^self
		name: aFontFamilyString
		emSize: emSize
		style: styleInteger
		unit: UnitPoint!

new
	"Answer a new initialized instance of the receiver for the default font."

	^self fontFamily: FontFamily genericSansSerif pointSize: Graphics.Font default pointSize! !
!Graphics.Gdiplus.Font class categoriesFor: #exampleGdipFontHeight!examples!public!sunit! !
!Graphics.Gdiplus.Font class categoriesFor: #fontFamily:emSize:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #fontFamily:emSize:style:unit:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #fontFamily:pointSize:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #icon!constants!development!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:emSize:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:emSize:style:unit:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:pixelSize:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:pixelSize:style:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:pointSize:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #name:pointSize:style:!instance creation!public! !
!Graphics.Gdiplus.Font class categoriesFor: #new!instance creation!public! !

