"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.Font'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Font guid: (Core.GUID fromString: '{5b5d4ae1-5c87-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.Font comment: '<Gdiplus.Font> encapsulates the characteristics, such as family, height, size, and style (or combination of styles), of a specific font. A <Gdiplus.Font> is used when drawing strings on a GdiplusGraphics.

Font instances do not have any attributes that can be altered after instantiation.

'!
!Graphics.Gdiplus.Font methodsFor!

cellHeight
	"Answer the receiver's cell height, i.e. the maximum height of a character, including ascenders and descenders, but excluding line spacing.
	The height will be in the receiver's units, typically pixels."

	| family |
	family := self family.
	^self emSize * (family cellAscent + family cellDescent) / family emHeight!

clone
	"Answer a copy of the receiver."

	"The cloned Font references the same FontFamily instance, so although we can rebuild from the handle we just copy across the initializer to avoid attaching two Smalltalk FontFamily owners of the same native object.
	This also preserves the generic singletons, which we may as well do since Fonts are immutable."

	^super clone
		initializer: initializer copy;
		yourself!

emSize
	"Answer the font size (commonly called the em size) of this Font object. The size is in the units of this Font object."

	| size |
	size := ByteArray newFixed: 4.
	Gdip gdipGetFontSize: self asParameter size: size.
	^size floatAtOffset: 0!

family
	"Answer the FontFamily on which the receiver is based."

	^self initializer fontFamily!

height
	"Answer the receiver's line spacing, in pixels. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| height |
	height := ByteArray newFixed: 4.
	Gdip
		gdipGetFontHeightGivenDPI: self handle
		dpi: UI.DesktopView current resolution y
		height: height.
	^height floatAtOffset: 0!

heightFromGraphics: aGdiplusGraphics
	"Answer the receiver's line spacing, in units. The line spacing is the vertical distance
	between the base lines of two consecutive lines of text. Thus, the line spacing includes
	the blank space between lines along with the height of the character itself."

	| height |
	height := ByteArray newFixed: 4.
	Gdip
		gdipGetFontHeight: self asParameter
		graphics: aGdiplusGraphics asParameter
		height: height.
	^height floatAtOffset: 0!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^FontFromFontFamilyInitializer!

name
	"Answer the FontFamily name on which the receiver is based."

	^self family name!

style
	^self initializer style!

unit
	"Answer an Integer, that represents the receiver's unit of measure."

	^self initializer unit! !
!Graphics.Gdiplus.Font categoriesForMethods!
cellHeight!accessing!public! !
clone!copying!public! !
emSize!accessing!public! !
family!accessing!public! !
height!accessing!public! !
heightFromGraphics:!accessing!public! !
initializerClass!constants!private! !
name!accessing!public! !
style!accessing!public! !
unit!accessing!public! !
!

!Graphics.Gdiplus.Font class methodsFor!

fontFamily: fontFamily emSize: emSize
	Notification deprecated.
	^self fontFamily: fontFamily pointSize: emSize!

fontFamily: fontFamily emSize: emSize style: style unit: unit
	^self fromInitializer: (FontFromFontFamilyInitializer
				fontFamily: fontFamily
				emSize: emSize
				style: style
				unit: unit)!

fontFamily: aGdiplusFontFamily pointSize: anInteger
	^self 
		fontFamily: aGdiplusFontFamily
		emSize: anInteger
		style: FontStyleRegular
		unit: UnitPoint!

genericMonospace
	"Answer a new generic monospace font of the default size."

	^self genericMonospace: Graphics.Font default pointSize!

genericMonospace: anInteger
	"Answer a new generic monospace font of the specified point size."

	^self fontFamily: FontFamily genericMonospace pointSize: anInteger!

genericSansSerif
	"Answer a new sans-serif instance of the receiver of default size."

	^self genericSansSerif: Graphics.Font default pointSize!

genericSansSerif: anInteger
	"Answer a new sans-serif instance of the receiver of specified point size."

	^self fontFamily: FontFamily genericSansSerif pointSize: anInteger!

genericSerif
	"Answer a new generic serif font of the default size."

	^self genericSerif: Graphics.Font default pointSize!

genericSerif: anInteger
	"Answer a new generic serif font of the specified point size."

	^self fontFamily: FontFamily genericSerif pointSize: anInteger!

name: aFontFamilyString emSize: emSize
	Notification deprecated.
	^self name: aFontFamilyString pointSize: emSize!

name: aFontFamilyString emSize: emSize style: style unit: unit
	^self
		fontFamily: (FontFamily name: aFontFamilyString)
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

	^self genericSansSerif! !
!Graphics.Gdiplus.Font class categoriesForMethods!
fontFamily:emSize:!instance creation!public! !
fontFamily:emSize:style:unit:!instance creation!public! !
fontFamily:pointSize:!instance creation!public! !
genericMonospace!instance creation!public! !
genericMonospace:!instance creation!public! !
genericSansSerif!instance creation!public! !
genericSansSerif:!instance creation!public! !
genericSerif!instance creation!public! !
genericSerif:!instance creation!public! !
name:emSize:!instance creation!public! !
name:emSize:style:unit:!instance creation!public! !
name:pixelSize:!instance creation!public! !
name:pixelSize:style:!instance creation!public! !
name:pointSize:!instance creation!public! !
name:pointSize:style:!instance creation!public! !
new!instance creation!public! !
!

