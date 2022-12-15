"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.FontFamily'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.FontFamily guid: (Core.GUID fromString: '{c09d8c08-5f28-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.FontFamily comment: 'GdiplusFontFamily represents a set of fonts that make up a font family. A font family is a group of fonts that have the same typeface but different styles.

'!
!Graphics.Gdiplus.FontFamily methodsFor!

cellAscent
	^self cellAscent: FontStyleRegular!

cellAscent: aFontStyleConstant
	| cellAscent |
	cellAscent := ByteArray newFixed: 2.
	Gdip
		gdipGetCellAscent: self handle
		style: aFontStyleConstant
		cellAscent: cellAscent.
	^cellAscent wordAtOffset: 0!

cellDescent
	^self cellDescent: FontStyleRegular!

cellDescent: aFontStyleConstant
	| cellAscent |
	cellAscent := ByteArray newFixed: 2.
	Gdip
		gdipGetCellDescent: self handle
		style: aFontStyleConstant
		cellDescent: cellAscent.
	^cellAscent wordAtOffset: 0!

clone
	"Answer a copy of the receiver."

	^super clone
		initializer: initializer copy;
		yourself!

emHeight
	^self emHeight: FontStyleRegular!

emHeight: aFontStyleConstant
	| emHeight |
	emHeight := ByteArray newFixed: 2.
	Gdip
		gdipGetEmHeight: self handle
		style: aFontStyleConstant
		emHeight: emHeight.
	^emHeight wordAtOffset: 0!

fontCollection
	^self initializer fontCollection!

getName: anInteger
	| name |
	name := Utf16String newFixed: LF_FACESIZE.
	Gdip
		gdipGetFamilyName: self asParameter
		name: name
		language: anInteger.
	^name asString trimNulls!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^FontFamilyFromNameInitializer!

isStyleAvailable: aFontStyleConstant
	| buf |
	buf := UInt32Bytes new.
	Gdip
		gdipIsStyleAvailable: self handle
		style: aFontStyleConstant
		isStyleAvailable: buf.
	^buf asBoolean!

lineSpacing
	"Answer the vertical distance between the base lines of two consecutive lines of regularly-styled text."

	^self lineSpacing: FontStyleRegular!

lineSpacing: aFontStyleConstant
	"Answer the vertical distance between the base lines of two consecutive lines of text with this font in the specified style."

	| lineSpacing |
	lineSpacing := ByteArray newFixed: 2.
	Gdip
		gdipGetLineSpacing: self asParameter
		style: aFontStyleConstant
		lineSpacing: lineSpacing.
	^lineSpacing wordAtOffset: 0!

name
	"Answer the String name of the receiver (e.g., 'Arial')."

	^self getName: Locale userDefault languageId! !
!Graphics.Gdiplus.FontFamily categoriesForMethods!
cellAscent!accessing!public! !
cellAscent:!accessing!public! !
cellDescent!accessing!public! !
cellDescent:!accessing!public! !
clone!copying!public! !
emHeight!accessing!public! !
emHeight:!accessing!public! !
fontCollection!accessing!private! !
getName:!helpers!private! !
initializerClass!constants!private! !
isStyleAvailable:!enquiries!public! !
lineSpacing!accessing!public! !
lineSpacing:!accessing!public! !
name!accessing!public! !
!

!Graphics.Gdiplus.FontFamily class methodsFor!

genericMonospace
	^self fromInitializer: FontFamilyInitializer genericMonospace!

genericSansSerif
	^self fromInitializer: FontFamilyInitializer genericSansSerif!

genericSerif
	^self fromInitializer: FontFamilyInitializer genericSerif!

icon
	"Answers an Icon that can be used to represent this class"

	^Font icon!

name: aString
	^self name: aString fontCollection: nil!

name: aString fontCollection: aFontCollection
	^self fromInitializer: (FontFamilyInitializer name: aString fontCollection: aFontCollection)! !
!Graphics.Gdiplus.FontFamily class categoriesForMethods!
genericMonospace!instance creation!public! !
genericSansSerif!instance creation!public! !
genericSerif!instance creation!public! !
icon!constants!development!public! !
name:!instance creation!public! !
name:fontCollection:!instance creation!public! !
!

