"Filed out from Dolphin Smalltalk"!

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

	| size |
	size := FLOAT new.
	GdiplusLibrary default gdipGetFontSize: self asParameter size: size.
	^size value!

family
	"Answer the FontFamily on which the receiver is based."

	| gpHandle |
	gpHandle := GdiplusInstalledFontCollection new families first.
	GdiplusLibrary default gdipGetFamily: self asParameter family: gpHandle asParameter.
	^gpHandle!

height
	"Answer the receiver's line spacing, in pixels. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	#highDpiToDo. "Callers of this may need to use #heightAtDpi: instead for per-monitor DPI"
	^self heightAtDpi: SystemMetrics current dpi!

heightAtDpi: anInteger
	| height |
	height := FLOAT new.
	GdiplusLibrary default
		gdipGetFontHeightGivenDPI: self asParameter
		dpi: anInteger
		height: height.
	^height value!

heightFromGraphics: aGdiplusGraphics
	"Answer the receiver's line spacing, in units. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| status height |
	height := FLOAT new.
	GdiplusLibrary default
		gdipGetFontHeight: self asParameter
		graphics: aGdiplusGraphics asParameter
		height: height.
	^height value!

name
	"Answer the FontFamily name on which the receiver is based."

	^self family name!

unit
	"Answer an Integer, that represents the receiver's unit of measure."

	| unit |
	unit := SDWORD new.
	GdiplusLibrary default gdipGetFontUnit: self asParameter unit: unit.
	^unit value! !

!GdiplusFont categoriesForMethods!
basicFree!private!realizing/unrealizing! !
emSize!accessing!public! !
family!accessing!public! !
height!accessing!public! !
heightAtDpi:!accessing!public! !
heightFromGraphics:!accessing!public! !
name!accessing!public! !
unit!accessing!public! !
!

!GdiplusFont class methodsFor!

fontFamily: fontFamily emSize: emSize
	Notification deprecated.
	^self fontFamily: fontFamily pointSize: emSize
!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self fromInitializer: (GdiplusFontFromFontFamilyInitializer 
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

	^Font icon!

name: aFontFamilyString emSize: emSize
	Notification deprecated.
	^self name: aFontFamilyString pointSize: emSize!

name: aFontFamilyString emSize: emSize style: style unit: unit
	^self 
		fontFamily: (GdiplusFontFamily fromName: aFontFamilyString)
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

	^self fontFamily: GdiplusFontFamily genericSansSerif pointSize: Font default pointSize! !

!GdiplusFont class categoriesForMethods!
fontFamily:emSize:!instance creation!public! !
fontFamily:emSize:style:unit:!instance creation!public! !
fontFamily:pointSize:!instance creation!public! !
icon!constants!development!public! !
name:emSize:!instance creation!public! !
name:emSize:style:unit:!instance creation!public! !
name:pixelSize:!instance creation!public! !
name:pixelSize:style:!instance creation!public! !
name:pointSize:!instance creation!public! !
name:pointSize:style:!instance creation!public! !
new!instance creation!public! !
!

