"Filed out from Dolphin Smalltalk 7"!

ColorRef subclass: #RGB
	instanceVariableNames: ''
	classVariableNames: 'StdColours'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RGB guid: (GUID fromString: '{87b4c53b-026e-11d3-9fd7-00a0cc3e4a32}')!
RGB comment: '`RGB` is the class of colour values specified as red, green and blue levels. The magnitude of each the primary colour components can be specified in the range from 0 to 255 inclusive, with 0 indicating minimum intensity.

## Class Variables:
  `StdColours`		`IdentityDictionary` of `Symbol` colour names to instances, e.g. `RGB red`




'!
!RGB categoriesForClass!Drawing! !
!RGB methodsFor!

asIndexedColorUsingPalette: hPalette 
	"Answer the receiver as an IndexedColour using hPalette"

	| index |
	index := GDILibrary default getNearestPaletteIndex: hPalette crColor: self asParameter.
	^index < 0 
		ifTrue: [GDILibrary default systemError]
		ifFalse: [IndexedColor withIndex: (index bitOr: 16r1000000)]!

asRGB
	"Answer the <RGB> colour equivalent to the receiver."

	^self!

basicHls
	| hls base |
	hls := ByteArray newFixed: 6.
	base := hls yourAddress.
	ShlwapiLibrary default
		colorRGBToHLS: code
		pwHue: base
		pwLuminance: base + 2
		pwSaturation: base + 4.
	^hls!

blue
	"Answer the receiver's blue component (a SmallInteger in the range 0..255)."

	^(code bitShift: -16) bitAnd: 16rFF!

green
	"Answer the receiver's green component (a SmallInteger in the range 0..255)."

	^(code bitShift: -8) bitAnd: 16rFF!

hls
	"Answer the hue, luminance, and saturation values that correspond to the receiver."

	| hls |
	hls := self basicHls.
	^{hls wordAtOffset: 0. hls wordAtOffset: 2. hls wordAtOffset: 4}!

hue
	"Answer the hue of the receiver."

	^self basicHls wordAtOffset: 0!

luminance
	"Answer the luminance of the receiver."

	^self basicHls wordAtOffset: 2!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		nextPut: $(;
		display: self class;
		display: ' r: ';
		print: self red;
		display: ' g: ';
		print: self green;
		display: ' b: ';
		print: self blue;
		nextPut: $)!

red
	"Answer the receiver's red component (a SmallInteger in the range 0..255)."

	^code bitAnd: 16rFF!

saturation
	"Answer the saturation of the receiver."

	^self basicHls wordAtOffset: 4!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that value passed to API calls
	to represent the color)."

	code := anInteger bitAnd: 16rFFFFFF! !
!RGB categoriesFor: #asIndexedColorUsingPalette:!converting!public! !
!RGB categoriesFor: #asRGB!converting!public! !
!RGB categoriesFor: #basicHls!converting!private! !
!RGB categoriesFor: #blue!accessing!public! !
!RGB categoriesFor: #green!accessing!public! !
!RGB categoriesFor: #hls!converting!public! !
!RGB categoriesFor: #hue!accessing!public! !
!RGB categoriesFor: #luminance!accessing!public! !
!RGB categoriesFor: #printOn:!printing!public! !
!RGB categoriesFor: #red!accessing!public! !
!RGB categoriesFor: #saturation!accessing!public! !
!RGB categoriesFor: #setCode:!accessing!private! !

!RGB class methodsFor!

fromInteger: anInteger 
	"Answer an instance whose three component colour values are embedded in anInteger."

	^(self basicNew)
		setCode: anInteger;
		yourself
!

initialize
	"Private - Initialise the map of standard colour names to constant instances.
		self initialize
	"

	| namedColors |
	namedColors := IdentityDictionary new.
	namedColors
		at: #red
			put: (self
					r: 255
					g: 0
					b: 0);
		at: #darkRed
			put: (self
					r: 128
					g: 0
					b: 0);
		at: #blue
			put: (self
					r: 0
					g: 0
					b: 255);
		at: #darkBlue
			put: (self
					r: 0
					g: 0
					b: 128);
		at: #green
			put: (self
					r: 0
					g: 255
					b: 0);
		at: #darkGreen
			put: (self
					r: 0
					g: 128
					b: 0);
		at: #yellow
			put: (self
					r: 255
					g: 255
					b: 0);
		at: #brown
			put: (self
					r: 128
					g: 128
					b: 0);
		at: #magenta
			put: (self
					r: 255
					g: 0
					b: 255);
		at: #darkMagenta
			put: (self
					r: 128
					g: 0
					b: 128);
		at: #cyan
			put: (self
					r: 0
					g: 255
					b: 255);
		at: #darkCyan
			put: (self
					r: 0
					g: 128
					b: 128);
		at: #white
			put: (self
					r: 255
					g: 255
					b: 255);
		at: #gray
			put: (self
					r: 204
					g: 204
					b: 204);
		at: #darkGray
			put: (self
					r: 128
					g: 128
					b: 128);
		at: #black
			put: (self
					r: 0
					g: 0
					b: 0);
		shrink.
	namedColors do: [:each | each isImmutable: true].
	self addClassConstant: 'StdColours' value: namedColors!

named: aSymbol
	"Answer an instance whose name is aSymbol."

	^StdColours at: aSymbol!

r: redValue g: greenValue b: blueValue
	"Answer a new instance whose red, green and blue components are specified as the
	arguments, which are expected to be in the range 0..255. See also #red:green:blue:"

	^self fromInteger: (redValue bitOr: ((greenValue bitShift: 8) bitOr: (blueValue bitShift: 16)))!

red: redValue green: greenValue blue: blueValue
	"Answer an instance whose three component colour values are given."

	^self fromInteger: ((redValue asInteger clampBetween: 0 and: 255)
				bitOr: (((greenValue asInteger clampBetween: 0 and: 255) bitShift: 8)
						bitOr: ((blueValue asInteger clampBetween: 0 and: 255) bitShift: 16)))!

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

stbVersion
	"Answer the current binary filer version number for instances of the receiver."

	^1! !
!RGB class categoriesFor: #fromInteger:!instance creation!public! !
!RGB class categoriesFor: #initialize!development!initializing!private! !
!RGB class categoriesFor: #named:!instance creation!public! !
!RGB class categoriesFor: #r:g:b:!instance creation!public! !
!RGB class categoriesFor: #red:green:blue:!instance creation!public! !
!RGB class categoriesFor: #stbConvertFrom:!binary filing!public! !
!RGB class categoriesFor: #stbVersion!binary filing!public! !

