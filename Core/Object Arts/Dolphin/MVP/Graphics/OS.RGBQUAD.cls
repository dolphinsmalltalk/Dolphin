"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.RGBQUAD'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_rgbBlue' -> 16r0.
			'_OffsetOf_rgbGreen' -> 16r1.
			'_OffsetOf_rgbRed' -> 16r2.
			'_OffsetOf_rgbReserved' -> 16r3.
			'_RGBQUAD_Size' -> 16r4
		}!

OS.RGBQUAD guid: (Core.GUID fromString: '{87b4c60d-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.RGBQUAD comment: '<RGBQUAD> is an <ExternalStructure> class to wrap the struct ''Win.RGBQUAD'' from type information in the ''Windows API (ANSI)'' library.

The type library contains no documentation for this struct

Warning: This comment was automatically generated from the struct''s type information, but any changes made here will not be overwritten if the wrapper class is regenerated.

IDL definition follows:

typedef 
struct tagRGBQUAD {
	BYTE rgbBlue;
	BYTE rgbGreen;
	BYTE rgbRed;
	BYTE rgbReserved;
} RGBQUAD;
'!

!OS.RGBQUAD categoriesForClass!External-Data-Structured-Win32! !

!OS.RGBQUAD methodsFor!

asColor
	"Answer a new Colour based on the receiver's data"

	^self color!

blue
	^self rgbBlue!

color
	^Graphics.Color fromRgbCode: self rgbCode!

color: aColor
	"Set the <Color> value of the receiver."

	bytes uint32AtOffset: 0 put: (aColor argbCode bitAnd: 16rFFFFFF)!

green
	^self rgbGreen!

red
	^self rgbRed!

rgbBlue
	"Answer the <Integer> value of the receiver's 'rgbBlue' field."

	^bytes uint8AtOffset: _OffsetOf_rgbBlue!

rgbBlue: anInteger
	"Set the receiver's 'rgbBlue' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_rgbBlue put: anInteger!

rgbCode
	"Answer the receiver's <integer> color value in 24-bit RGB encoding with 8-bits per component in COLORREF order (red as low-order byte, green 2nd byte, and blue 3rd byte)."

	| bgr |
	bgr := bytes uint32AtOffset: 0.
	^(((bgr bitAnd: 16rFF) bitShift: 16) bitOr: (bgr bitAnd: 16r00FF00))
		bitOr: ((bgr bitShift: -16) bitAnd: 16rFF)!

rgbGreen
	"Answer the <Integer> value of the receiver's 'rgbGreen' field."

	^bytes uint8AtOffset: _OffsetOf_rgbGreen!

rgbGreen: anInteger
	"Set the receiver's 'rgbGreen' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_rgbGreen put: anInteger!

rgbRed
	"Answer the <Integer> value of the receiver's 'rgbRed' field."

	^bytes uint8AtOffset: _OffsetOf_rgbRed!

rgbRed: anInteger
	"Set the receiver's 'rgbRed' field to the value of the argument, anInteger"

	bytes uint8AtOffset: _OffsetOf_rgbRed put: anInteger! !

!OS.RGBQUAD categoriesForMethods!
asColor!converting!public! !
blue!accessing!public! !
color!accessing!public! !
color:!accessing!public! !
green!accessing!public! !
red!accessing!public! !
rgbBlue!**compiled accessors**!public! !
rgbBlue:!**compiled accessors**!public! !
rgbCode!accessing!public! !
rgbGreen!**compiled accessors**!public! !
rgbGreen:!**compiled accessors**!public! !
rgbRed!**compiled accessors**!public! !
rgbRed:!**compiled accessors**!public! !
!

!OS.RGBQUAD class methodsFor!

byteSize
	^_RGBQUAD_Size!

defineFields
	"Define the fields of the RGBQUAD structure.
		RGBQUAD compileDefinition
	
		typedef 
		struct tagRGBQUAD {
			BYTE rgbBlue;
			BYTE rgbGreen;
			BYTE rgbRed;
			BYTE rgbReserved;
		} RGBQUAD;
"

	self
		defineField: #rgbBlue type: UInt8Field new;
		defineField: #rgbGreen type: UInt8Field new;
		defineField: #rgbRed type: UInt8Field new;
		defineField: #rgbReserved type: UInt8Field filler!

fromColor: aColor
	"Answer a new instance of the receiver equivalent to the <Color> argument."

	^self newBuffer
		color: aColor;
		yourself!

getFieldNames
	^#(#rgbBlue #rgbGreen #rgbRed)! !

!OS.RGBQUAD class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromColor:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

