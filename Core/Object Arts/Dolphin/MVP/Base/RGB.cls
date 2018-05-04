"Filed out from Dolphin Smalltalk 7"!

ColorRef subclass: #RGB
	instanceVariableNames: ''
	classVariableNames: 'StdColours'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
RGB guid: (GUID fromString: '{87b4c53b-026e-11d3-9fd7-00a0cc3e4a32}')!
RGB comment: 'RGB is the class of colour values specified as red, green and blue levels. The magnitude of each the primary colour components can be specified in the range from 0 to 255 inclusive, with 0 indicating minimum intensity.

Some examples specified as the colour name and the corresponding RGB values:
	Red 		255, 0, 0 
	Green 		0, 255, 0 
	Blue 		0, 0, 255 
	Cyan 		0, 255, 255 
	Magenta 	255, 0, 255 
	Yellow 		255, 255, 0 
	White 		255, 255, 255 
	Black 		0, 0, 0 

Class Variables:
	StdColours		<IdentityDictionary>

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
	^Array 
		with: hue asInteger
		with: luminance asInteger
		with: saturation asInteger!

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

	^(self basicNew)
		setCode: anInteger;
		yourself!

initialize
	"Private - Initialise the map of standard colour names to #(R G B) values."

	StdColours := ##((IdentityDictionary new: 16)
				at: #red put: #(255 0 0);
				at: #darkRed put: #(128 0 0);
				at: #blue put: #(0 0 255);
				at: #darkBlue put: #(0 0 128);
				at: #green put: #(0 255 0);
				at: #darkGreen put: #(0 128 0);
				at: #yellow put: #(255 255 0);
				at: #brown put: #(128 128 0);
				at: #magenta put: #(255 0 255);
				at: #darkMagenta put: #(128 0 128);
				at: #cyan put: #(0 255 255);
				at: #darkCyan put: #(0 128 128);
				at: #white put: #(255 255 255);
				at: #gray put: #(204 204 204);
				at: #darkGray put: #(128 128 128);
				at: #black put: #(0 0 0);
				yourself)!

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

	^1!

stdColor: aSymbol
	"Answer an instance whose name is aSymbol."

	| rgbValue |
	rgbValue := StdColours at: aSymbol.
	^self
		red: (rgbValue at: 1)
		green: (rgbValue at: 2)
		blue: (rgbValue at: 3)
! !
!RGB class categoriesFor: #fromInteger:!instance creation!public! !
!RGB class categoriesFor: #initialize!development!initializing!private! !
!RGB class categoriesFor: #red:green:blue:!instance creation!public! !
!RGB class categoriesFor: #stbConvertFrom:!binary filing!public! !
!RGB class categoriesFor: #stbVersion!binary filing!public! !
!RGB class categoriesFor: #stdColor:!instance creation!public! !

