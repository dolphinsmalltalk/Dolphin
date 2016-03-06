"Filed out from Dolphin Smalltalk 7"!

Color subclass: #ColorRef
	instanceVariableNames: 'code'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ColorRef guid: (GUID fromString: '{ED5FCDEB-52E8-4A5C-9EB7-38BF3A3AA575}')!
ColorRef comment: 'ColorRef is the abstract class of palette independent (absolute) color values used with most Win32 APIs.

Instance Variables:
	code		<SmallInteger>. The COLORREF value. e.g. an RGB value.

'!
!ColorRef categoriesForClass!Unclassified! !
!ColorRef methodsFor!

= aColorRef
	"Answer true if the argument and the reciever are equal (i.e. they are represent the
	same colour value)."

	^self species == aColorRef species and: [self code = aColorRef code]!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^self isNone ifTrue: [0] ifFalse: [255]!

asColorRef
	"Answer the receiver as a ColorRef (an RGB value or one of the standard pseudo-colour constants)"

	^self!

asIndexedColor
	"Answer the receiver as an IndexedColour using the default palette."

	^self asIndexedColorUsingPalette: self defaultPalette
!

asIndexedColorUsingPalette: hPalette
	"Answer the receiver as an IndexedColour using hPalette"

	^self asRGB asIndexedColorUsingPalette: hPalette!

asParameter
	"Answer the receiver such that it can be used for an API call."

	^self code!

asRGB
	"Answer the <RGB> colour equivalent to the receiver."

	code > 16rFFFFFF ifTrue: [self errorNotARealColor].
	^RGB fromInteger: code!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^self isNone ifTrue: [StockBrush fromId: NULL_BRUSH] ifFalse: [super brush]!

code
	"Private - Answer the value of the receiver's ''code'' instance variable."

	^code!

errorNotARealColor
	"Private - Raise an error to the effect that the receiver does not represent a real colour
	value, and cannot therefore be converted to another type of <Color>."

	^self error: 'Cannot convert to another type of Color'!

hash
	"Answer the <integer> hash value for the receiver."

	^self code!

isDefault
	"Answer whether the receiver is the special <Color> representing the default colour. Which
	colour this represents in practice will depend on context."

	^code = CLR_DEFAULT!

isNone
	"Answer whether the receiver is the special <Color> representing no colour."

	^code = CLR_NONE!

printOn: aStream 
	"Put an ASCII representation of receiver onto aStream."

	aStream nextPut: $(.
	code = CLR_NONE 
		ifTrue: 
			[aStream
				display: Color;
				space;
				display: #none]
		ifFalse: 
			[code = CLR_DEFAULT 
				ifTrue: 
					[aStream
						display: Color;
						space;
						display: #default]
				ifFalse: 
					[aStream
						display: self class;
						space;
						display: #fromInteger:;
						space;
						print: code]].
	aStream nextPut: $)!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that value passed to API calls
	to represent the color)."

	code := anInteger! !
!ColorRef categoriesFor: #=!comparing!public! !
!ColorRef categoriesFor: #alpha!accessing!public! !
!ColorRef categoriesFor: #asColorRef!converting!public! !
!ColorRef categoriesFor: #asIndexedColor!converting!public! !
!ColorRef categoriesFor: #asIndexedColorUsingPalette:!converting!public! !
!ColorRef categoriesFor: #asParameter!converting!public! !
!ColorRef categoriesFor: #asRGB!converting!public! !
!ColorRef categoriesFor: #brush!converting!public! !
!ColorRef categoriesFor: #code!accessing!private! !
!ColorRef categoriesFor: #errorNotARealColor!exceptions!public! !
!ColorRef categoriesFor: #hash!comparing!public! !
!ColorRef categoriesFor: #isDefault!public!testing! !
!ColorRef categoriesFor: #isNone!public!testing! !
!ColorRef categoriesFor: #printOn:!development!printing!public! !
!ColorRef categoriesFor: #setCode:!accessing!private! !

!ColorRef class methodsFor!

default
	"Answer the special <ColorRef> respresenting the default colour."

	^(self basicNew)
		setCode: CLR_DEFAULT;
		yourself!

defaultColorRepresentation
	"Private - Answer a unique colour that we can use to represent (Color default). This is used in the ColorDialog to allow users to
	explicitly choose the default colour from a swatch"

	^Color 
		red: 200
		green: 200
		blue: 201!

fromInteger: anInteger 
	"Private - Answer an instance with the specified colorref code value."

	^(((anInteger bitShift: -24) == 16rFF ifTrue: [self] ifFalse: [RGB]) basicNew)
		setCode: anInteger;
		yourself!

none
	"Answer the special <ColorRef> respresenting no colour."

	^(self basicNew)
		setCode: CLR_NONE;
		yourself! !
!ColorRef class categoriesFor: #default!instance creation!public! !
!ColorRef class categoriesFor: #defaultColorRepresentation!private! !
!ColorRef class categoriesFor: #fromInteger:!instance creation!private! !
!ColorRef class categoriesFor: #none!instance creation!public! !

