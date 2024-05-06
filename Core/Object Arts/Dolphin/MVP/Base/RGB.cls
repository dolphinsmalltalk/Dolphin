"Filed out from Dolphin Smalltalk"!

ColorRef subclass: #RGB
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

RGB guid: (GUID fromString: '{87b4c53b-026e-11d3-9fd7-00a0cc3e4a32}')!

RGB comment: '`RGB` is the class of colour values specified as individual 8-bit red, green and blue levels encoded as a 32-bit integer with components in B,G,R order (aka a COLORREF). The RGB encoding is used with the older GDI and common control APIs, and cannot represent alpha/translucency, except for the special case of complete transparency (see `ColorNone`).



'!

!RGB categoriesForClass!Drawing! !

!RGB methodsFor!

alpha: anAlphaInteger
	"Answer an <Color> that has the same red, green and blue components as the receiver, but with the <integer> alpha, anAlphaInteger.
	The alpha component is expected to be in the range [0,255], but is clamped to that if not."

	| alpha |
	alpha := anAlphaInteger asInteger clampBetween: 0 and: 255.
	^alpha == 255
		ifTrue: [self]
		ifFalse: 
			[self argbClass
				fromArgbCode: ((((code bitShift: -16) bitAnd: 16rFF)
						bitOr: ((code bitAnd: 16r00FF00) bitOr: ((code bitAnd: 16rFF) bitShift: 16)))
							bitOr: (alpha bitShift: 24))]!

asRGB
	"Answer the <RGB> colour equivalent to the receiver."

	^self!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^code!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that value passed to API calls to represent the color)."

	code := anInteger bitAnd: 16rFFFFFF! !

!RGB categoriesForMethods!
alpha:!accessing!public! !
asRGB!converting!public! !
rgbCode!accessing!public! !
setCode:!accessing!private! !
!

!RGB class methodsFor!

fromInteger: anInteger
	"Private - Answer an instance whose three component colour values are embedded in anInteger. This should only be used for STB loading. Use fromRgbCode: instead."

	^self basicNew
		setCode: anInteger;
		yourself!

fromRgbCode: anInteger
	"Answer an instance whose three component colour values are embedded in anInteger. The Integer is expected to be an integer encoding the red, green and blue components of the colour in BGR order, with each component represented by 8-bits."

	^self basicNew
		setCode: anInteger;
		yourself!

r: redInteger g: greenInteger b: blueInteger
	"Answer a new instance whose red, green and blue components are specified as the arguments, which are expected to be in the range 0..255. The result is undefined if any of the arguments are out of range.See also #red:green:blue:"

	^self
		fromRgbCode: (redInteger bitOr: ((greenInteger bitShift: 8) bitOr: (blueInteger bitShift: 16)))!

red: redInteger green: greenInteger blue: blueInteger
	"Answer an instance whose three component colour values are given by the <integer> arguments. These are expected to be in the range [0,255], but are clamped to that if not."

	^self fromRgbCode: ((redInteger asInteger clampBetween: 0 and: 255)
				bitOr: (((greenInteger asInteger clampBetween: 0 and: 255) bitShift: 8)
						bitOr: ((blueInteger asInteger clampBetween: 0 and: 255) bitShift: 16)))!

stbConvertFrom: anSTBClassFormat 
	"Convert from earlier version models.
	1: Separate red/green/blue instance variables replaced by a single inst. var in superclass."

	^anSTBClassFormat version < 1 
		ifTrue: 
			[
			[:data | 
			self 
				red: (data at: 1)
				green: (data at: 2)
				blue: (data at: 3)]]
		ifFalse: [super stbConvertFrom: anSTBClassFormat]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to support conversion from pre version 1 instances, which can be found in STB files from versions of Dolphin predating 6.0"

	^(anSTBClassConversion notNil and: [anSTBClassConversion version < 1])
		ifTrue: [anSTBInFiler readObjectOfClass: self format: anSTBClassConversion]
		ifFalse: 
			["Otherwise use the custom deserialization in ColorRef"
			super stbReadFrom: anSTBInFiler format: anSTBClassConversion]!

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !

!RGB class categoriesForMethods!
fromInteger:!instance creation!private! !
fromRgbCode:!instance creation!public! !
r:g:b:!instance creation!public! !
red:green:blue:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbReadFrom:format:!binary filing!public! !
stbVersion!binary filing!public! !
!

