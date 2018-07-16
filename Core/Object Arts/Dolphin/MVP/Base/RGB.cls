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

blue
	"Answer the receiver's blue component (a SmallInteger in the range 0..255)."

	^(code bitShift: -16) bitAnd: 16rFF!

green
	"Answer the receiver's green component (a SmallInteger in the range 0..255)."

	^(code bitShift: -8) bitAnd: 16rFF!

hls
	"Answer the hue, luminance, and saturation values that correspond to the receiver."

	| hue luminance saturation |
	hue := WORD new.
	luminance := WORD new.
	saturation := WORD new.
	ShlwapiLibrary default
		colorRGBToHLS: self asParameter
		pwHue: hue
		pwLuminance: luminance
		pwSaturation: saturation.
	^{hue asInteger. luminance asInteger. saturation asInteger}!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	aStream
		nextPut: $(;
		display: self class;
		display: ' red: ';
		print: self red;
		display: ' green: ';
		print: self green;
		display: ' blue: ';
		print: self blue;
		nextPut: $)!

red
	"Answer the receiver's red component (a SmallInteger in the range 0..255)."

	^code bitAnd: 16rFF!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that value passed to API calls
	to represent the color)."

	code := anInteger bitAnd: 16rFFFFFF! !
!RGB categoriesFor: #asIndexedColorUsingPalette:!converting!public! !
!RGB categoriesFor: #asRGB!converting!public! !
!RGB categoriesFor: #blue!accessing!public! !
!RGB categoriesFor: #green!accessing!public! !
!RGB categoriesFor: #hls!converting!public! !
!RGB categoriesFor: #printOn:!printing!public! !
!RGB categoriesFor: #red!accessing!public! !
!RGB categoriesFor: #setCode:!accessing!private! !

!RGB class methodsFor!

fromInteger: anInteger 
	"Answer an instance whose three component colour values are embedded in anInteger."

	<primitive: 157>
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
					red: 255
					green: 0
					blue: 0);
		at: #darkRed
			put: (self
					red: 128
					green: 0
					blue: 0);
		at: #blue
			put: (self
					red: 0
					green: 0
					blue: 255);
		at: #darkBlue
			put: (self
					red: 0
					green: 0
					blue: 128);
		at: #green
			put: (self
					red: 0
					green: 255
					blue: 0);
		at: #darkGreen
			put: (self
					red: 0
					green: 128
					blue: 0);
		at: #yellow
			put: (self
					red: 255
					green: 255
					blue: 0);
		at: #brown
			put: (self
					red: 128
					green: 128
					blue: 0);
		at: #magenta
			put: (self
					red: 255
					green: 0
					blue: 255);
		at: #darkMagenta
			put: (self
					red: 128
					green: 0
					blue: 128);
		at: #cyan
			put: (self
					red: 0
					green: 255
					blue: 255);
		at: #darkCyan
			put: (self
					red: 0
					green: 128
					blue: 128);
		at: #white
			put: (self
					red: 255
					green: 255
					blue: 255);
		at: #gray
			put: (self
					red: 204
					green: 204
					blue: 204);
		at: #darkGray
			put: (self
					red: 128
					green: 128
					blue: 128);
		at: #black
			put: (self
					red: 0
					green: 0
					blue: 0);
		shrink.
	namedColors do: [:each | each isImmutable: true].
	self addClassConstant: 'StdColours' value: namedColors!

named: aSymbol
	"Answer an instance whose name is aSymbol."

	^StdColours at: aSymbol!

red: redValue green: greenValue blue: blueValue
	"Answer an instance whose three component colour values are given."

	^self fromInteger: 
		((((redValue max: 0) min: 16rFF) asInteger) 
			bitOr: (((((greenValue max: 0) min: 16rFF) asInteger) bitShift: 8) 
				bitOr: ((((blueValue max: 0) min: 16rFF) asInteger) bitShift: 16)))
!

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
!RGB class categoriesFor: #red:green:blue:!instance creation!public! !
!RGB class categoriesFor: #stbConvertFrom:!binary filing!public! !
!RGB class categoriesFor: #stbVersion!binary filing!public! !

