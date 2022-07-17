"Filed out from Dolphin Smalltalk"!

Object subclass: #Color
	instanceVariableNames: ''
	classVariableNames: 'Black ColorNames CommonColors Default Face3d NamedColors None White Window WindowText'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

Color guid: (GUID fromString: '{87b4c465-026e-11d3-9fd7-00a0cc3e4a32}')!

Color isAbstract: true!

Color comment: '`Color` is the abstract class of colours. 

Concrete subclasses represent the different types of colour object: `SystemColor` for the logical system colours that vary depending on the Windows theme; `IndexedColor` for a limited range of palletized colours; `RGB` for general purpose representation of colours composed of arbitrary proportions of red, green, and blue, and `ARGB` the same but with alpha (translucency).

The special singleton subclasses `ColorDefault` and `ColorNone` represent the default colour of some Window or control in a specific context, and full transparency.

There are also the virtual colours, `ThemeColor` and `PluggableColor`, to represent symbolic (i.e. named, logical) and dynamic/calculated colours respectively. These can be resolved to an absolute colour from the list of concrete colour types when required.'!

!Color categoriesForClass!Drawing! !

!Color methodsFor!

= aColor
	"Answer whether the receiver and argument are equivalent (i.e. represent the same colour)."

	^self == aColor or: [aColor species == self species and: [aColor argbCode = self argbCode]]!

actualColor
	^self!

adjustBrightness: aNumber
	"Answer a new <Color> that is derived from this color but with the specified relative brightness."

	"Brightness is clamped to a minimum of 0.005 so that hue information is not lost"

	^Color
		h: self hue
		s: self hsvSaturation
		v: (self brightness + aNumber clampBetween: 0.005 and: 1.0)
		alpha: self normalizedAlpha!

adjustSaturation: saturationNumber brightness: brightnessNumber
	"Adjust the relative saturation and brightness of this color. (lowest value is 0.005 so that hue information is not lost)"

	^Color
		h: self hue
		s: (self hsvSaturation + saturationNumber clampBetween: 0.005 and: 1.0)
		v: (self brightness + brightnessNumber clampBetween: 0.005 and: 1.0)
		alpha: self normalizedAlpha!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^255!

alpha: anAlphaInteger
	"Answer a `Color` which has the same red, green and blue components as the receiver, but with the <integer> alpha, anAlphaInteger.
	The alpha component is expected to be in the range [0,255], but is clamped to that if not."

	^anAlphaInteger >= 255 ifTrue: [self] ifFalse: [self asRGB alpha: anAlphaInteger]!

alphaMask
	"Private - Answer the receiver's alpha bits as they would compose into an ARGB."

	^16rFF000000!

argbClass
	^self class argbClass!

argbCode
	"Answer the receiver's colour value in 32-bit ARGB encoding with 8-bits per component in alpha, red, green, blue order."

	| bgr |
	bgr := self rgbCode.
	^self alphaMask bitOr: (((bgr bitShift: -16) bitAnd: 16rFF)
				bitOr: ((bgr bitAnd: 16r00FF00) bitOr: ((bgr bitAnd: 16rFF) bitShift: 16)))!

asColorRef
	"Answer the receiver as a <ColorRef> (an <RGB> or one of the standard pseudo-colour constants Color default and Color none)."

	^self asRGB!

asCOLORREF
	"Answer the receiver's COLORREF encoding. This is basically an BGR encoding, but the high bits (that would be used for an alpha value in an ARGB) are used for some special values, either
	to indicate indexed colours, or for Color none and Color default."

	^self rgbCode!

asDword
	"Answer the receiver in a form suitable for passing as a 32-bit unsigned integer parameter."

	^self asParameter!

asGrayscale
	"Answer a <Color> that is a grayscale representation of the receiver."

	^self asRGB asGrayscale!

asParameter
	"Answer the receiver in a form suitable for an API call."

	"It is recommended not to use this conversion, as the result will vary depending on the colour encoding, and so may not work if the encoding is not that expected by the API being called. Rather you should use (for example) #rgbCode or #argbCode."

	^self subclassResponsibility!

asRGB
	"Answer the receiver as an <RGB>"

	^self subclassResponsibility!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^self asParameter!

blue
	"Answer the receiver's blue component component expressed as an <integer> in the range [0,255]."

	^self asRGB blue!

brightness
	"Answer a <Number> in the range [0,1] representing the brightness of this color in the HSV colour model."

	^self asRGB brightness!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^self brushClass newColor: self!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^Brush!

chroma
	"Answer a <Number> in the range [0,1] representing the chroma value of the receiver."

	^self asRGB chroma!

defaultPalette
	"Private - Answer the default palette."

	^GDILibrary default getStockObject: Win32Constants.DEFAULT_PALETTE
!

faded
	"Answer a new color which is a faded (half intensity) copy of the receiver."

	^self fadedBy: 2!

fadedBy: aNumber
	"Answer a new <Color> which is a copy of the receiver faded by
	the specified factor."

	^self asRGB fadedBy: aNumber!

green
	"Answer the receiver's green component component expressed as an <integer> in the range [0,255]."

	^self asRGB green!

hash
	"Answer the <SmallInteger> hash code for the receiver."

	^self argbCode hashMultiply!

hls
	"Answer a three-element <Array> containing hue, luminance, and saturation values that correspond to the receiver in the HLS colour system."

	^self asRGB hls!

hslSaturation
	"Answer a <Number> in the range [0,1] representing the HSL saturation of the receiver."

	^self asRGB hslSaturation!

hsv
	"Answer a three-element <Array> containing the hue, saturation and brightness values that describe the receiver in the HSV colour system."

	^self asRGB hsv!

hsvSaturation
	"Answer a <Number> in the range [0,1] representing the HSV saturation of the receiver."

	^self asRGB hsvSaturation!

hue
	"Answer a <Number> in the range [0,360] representing the receiver's hue in the HSV or HLS color models."

	^self asRGB hue!

intensity: aFraction
	"Answer a new <Color> which is a copy of the receiver given a fractional intensity away from black."

	^self asRGB intensity: aFraction!

isDefault
	"Answer whether the receiver is the special <Color> representing the default colour for the
	situation. The user of the colour, or the object of which it is an attribute, interprets
	this appropriately based on its own notion of a default color. As an example for TabViews
	this would translate to the system '3d face' colour."

	^false!

isGrayscale
	"Answer whether each of this Colors red, green and blue components are of the same magnitude, i.e. it is a shade of grey."

	^self asRGB isGrayscale!

isNone
	"Answer whether the receiver is the special <Color> representing no colour (transparent)."

	^false!

isTransparent
	"Answer whether this <Color> is completely transparent."

	^self alpha = 0!

lighter
	"Answer a lighter shade of this color."

	^ self adjustSaturation: -0.03 brightness: 0.08!

lightness
	"Answer a <Number> in the range [0,1] representing the lightness of the receiver in the HSL colour system."

	^self asRGB lightness!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity."

	^self asRGB luminance!

name
	"Answer the symbolic name of the colour, or nil if it does not have a name (or known name)."

	^ColorNames lookup: self!

normalizedAlpha
	"Answer the receiver's alpha component as a <Number> in the range [0,1], with 0 being completely transparent and 1 completely opaque."

	^1!

normalizedAlpha: aNumber
	"Answer an <ARGB> which has the same red, green and blue components as the receiver, but with the alpha, aNumber.
	The alpha component is expected to be in the range [0,1], but is clamped to that if not."

	^self alpha: (aNumber * 255) rounded!

normalizedBlue
	"Answer a <Number> in the range [0,1] representing the receiver's blue component."

	^self blue / 255!

normalizedGreen
	"Answer a <Number> in the range [0,1] representing the receiver's green component."

	^self green / 255!

normalizedRed
	"Answer a <Number> in the range [0,1] representing the receiver's red component."

	^self red / 255!

pen
	"Answer a <Pen> configured for painting solid 1-pixel wide lines of the receiver's color."

	^self penClass newColor: self!

penClass
	"Private - Answer the class of Pen to be used in conjunction with the receiver."

	^Pen!

printOn: aPuttableStream
	"Append, to the <puttableStream> argument a string whose characters are the same as those which would result from sending a #printString message to the receiver."

	self name
		ifNotNil: 
			[:symbol |
			(Color class canUnderstand: symbol)
				ifTrue: 
					[aPuttableStream
						print: Color;
						space;
						display: symbol]
				ifFalse: 
					[aPuttableStream
						nextPut: $(;
						display: Color;
						space;
						display: #named:;
						space;
						print: symbol;
						nextPut: $)]]
		ifNil: 
			[| a |
			aPuttableStream
				nextPut: $(;
				display: Color.
			a := self alpha.
			a == 255
				ifFalse: 
					[aPuttableStream
						display: ' a: ';
						print: a].
			aPuttableStream
				display: ' r: ';
				print: self red;
				display: ' g: ';
				print: self green;
				display: ' b: ';
				print: self blue;
				nextPut: $)]!

red
	"Answer the receiver's red component expressed as an <integer> in the range [0,255]."

	^self asRGB red!

registerName: aSymbol
	"Some colours are registered for reverse lookup, so that for example if we have RGB(255,255,0) then it is printed as Color yellow.
	We don't register logical colours in the Color registry, though, as it doesn't necessarily make sense to make an equivalent RGB to the named system colour."

	!

rgb
	"Answer a three-element <Array> containing red, green, and blue components of the receiver expressed as integer in the range [0,255]."

	^self asRGB rgb!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^self asRGB rgbCode!

setAlpha: aFloat 
	^self alpha: aFloat * 255!

species
	^##(self)!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler."

	self name
		ifNil: [anSTBOutFiler saveObject: self]
		ifNotNil: 
			[:symbol |
			anSTBOutFiler
				writeClass: Color withPrefix: STBPrefix forData;
				register: self.
			anSTBOutFiler nextPut: symbol]! !

!Color categoriesForMethods!
=!comparing!public! !
actualColor!accessing!private! !
adjustBrightness:!public! !
adjustSaturation:brightness:!public! !
alpha!accessing!public! !
alpha:!accessing!public! !
alphaMask!accessing!private! !
argbClass!constants!private! !
argbCode!accessing!public! !
asColorRef!converting!public! !
asCOLORREF!accessing!public! !
asDword!converting!public! !
asGrayscale!converting!public! !
asParameter!converting!public! !
asRGB!converting!public! !
asUIntPtr!converting!public! !
blue!accessing!public! !
brightness!accessing!public! !
brush!converting!public! !
brushClass!constants!private! !
chroma!accessing!public! !
defaultPalette!constants!private! !
faded!converting!public! !
fadedBy:!converting!public! !
green!accessing!public! !
hash!comparing!public! !
hls!converting!public! !
hslSaturation!accessing!public! !
hsv!converting!public! !
hsvSaturation!accessing!public! !
hue!accessing!public! !
intensity:!converting!public! !
isDefault!public!testing! !
isGrayscale!public!testing! !
isNone!public!testing! !
isTransparent!public!testing! !
lighter!public! !
lightness!public! !
luminance!accessing!public! !
name!accessing!public! !
normalizedAlpha!public! !
normalizedAlpha:!public! !
normalizedBlue!accessing!public! !
normalizedGreen!accessing!public! !
normalizedRed!accessing!public! !
pen!converting!public! !
penClass!constants!private! !
printOn:!printing!public! !
red!accessing!public! !
registerName:!private! !
rgb!converting!public! !
rgbCode!accessing!public! !
setAlpha:!public! !
species!accessing!public! !
stbSaveOn:!binary filing!public! !
!

Color methodProtocol: #color attributes: #(#readOnly) selectors: #(#asParameter #asRGB #brush #pen)!

!Color class methodsFor!

a: alphaInteger r: redInteger g: greenInteger b: blueInteger
	"Answer a minimal instance whose four components are given by the <integer> arguments, each of which must be in the range [0,255] (this is not checked)."

	^alphaInteger >= 255
		ifTrue: 
			[self rgbClass
				r: redInteger
				g: greenInteger
				b: blueInteger]
		ifFalse: 
			[self argbClass
				a: alphaInteger
				r: redInteger
				g: greenInteger
				b: blueInteger]!

addNamed: aSymbol color: aColor
	"Register the <Color>, aColor, as a named colour with the symbolic name, aSymbol."

	aColor registerName: aSymbol.
	^NamedColors at: aSymbol put: aColor!

aliceBlue
	^self named: #aliceBlue!

alpha: alphaValue red: redValue green: greenValue blue: blueValue
	"Answer an instance whose four component colour values are provided as the arguments, but
	which are clamped to the range 0..255."

	^self
		a: (alphaValue asInteger clampBetween: 0 and: 255)
		r: (redValue asInteger clampBetween: 0 and: 255)
		g: (greenValue asInteger clampBetween: 0 and: 255)
		b: (blueValue asInteger clampBetween: 0 and: 255)!

antiqueWhite
	^self named: #antiqueWhite!

applicationWorkspace
	"Answer the background colour for an application's workspace area (e.g. the background of
	the main window MDI applications). This is typically a dark grey."

	^self named: #applicationWorkspace!

aqua
	^self named: #aqua!

aquamarine
	^self named: #aquamarine!

argbClass
	^ARGB!

argbNoneCode
	"Answer the ARGB encoding for the special 'none' (transparent) color. Our convention is transparent white."

	^16r00FFFFFF!

azure
	^self named: #azure!

beige
	^self named: #beige!

bisque
	^self named: #bisque!

black
	^Black!

blanchedAlmond
	^self named: #blanchedAlmond!

blue
	^self named: #blue!

blueViolet
	^self named: #blueViolet!

brightness: aNumber
	"Answer a <Color> that is a shade of grey with the specified brightness, expected to be in the range [0,1]."

	| v |
	v := (aNumber * 255) rounded clampBetween: 0 and: 255.
	^self
		a: 255
		r: v
		g: v
		b: v!

brown
	^self named: #brown!

burlyWood
	^self named: #burlyWood!

byteSize
	"Answer the byte size of the receiver when converted to parameter format (i.e. by asParameter)."

	^4!

cadetBlue
	^self named: #cadetBlue!

caption
	^self named: #caption!

chartreuse
	^self named: #chartreuse!

chocolate
	^self named: #chocolate!

commonColors
	"Answer the set of common, named, colours. These are ordered by hue, saturation and then value (brightness)."

	^CommonColors!

commonGreen
	^self named: #commonGreen!

coral
	^self named: #coral!

cornflowerBlue
	^self named: #cornflowerBlue!

cornsilk
	^self named: #cornsilk!

crimson
	^self named: #crimson!

cyan
	^self named: #cyan!

darkBlue
	^self named: #darkBlue!

darkCyan
	^self named: #darkCyan!

darkGoldenrod
	^self named: #darkGoldenrod!

darkGray
	^self named: #darkGray!

darkGreen
	^self named: #darkGreen!

darkKhaki
	^self named: #darkKhaki!

darkMagenta
	^self named: #darkMagenta!

darkOliveGreen
	^self named: #darkOliveGreen!

darkOrange
	^self named: #darkOrange!

darkOrchid
	^self named: #darkOrchid!

darkRed
	^self named: #darkRed!

darkSalmon
	^self named: #darkSalmon!

darkSeaGreen
	^self named: #darkSeaGreen!

darkShadow3d
	"Answer a <Color> representing 3D-shadow system color."

	^self named: #darkShadow3d!

darkSlateBlue
	^self named: #darkSlateBlue!

darkSlateGray
	^self named: #darkSlateGray!

darkTurquoise
	^self named: #darkTurquoise!

darkViolet
	^self named: #darkViolet!

deepPink
	^self named: #deepPink!

deepSkyBlue
	^self named: #deepSkyBlue!

default
	"Answer the special <Color> representing the 'default' colour in any context."

	^Default!

dialog
	"Answer the <Color> used for the background of built-in dialogs."

	^self named: #dialog!

dimGray
	^self named: #dimGray!

dodgerBlue
	^self named: #dodgerBlue!

face3d
	"Answer the 3D button/menu face system color."

	^Face3d!

firebrick
	^self named: #firebrick!

floralWhite
	^self named: #floralWhite!

forestGreen
	^self named: #forestGreen!

fromAddress: anAddress
	"Answer a new Colour, based on the 32-bit integer value at anAddress."

	^self fromCOLORREF: (anAddress asExternalAddress sdwordAtOffset: 0)!

fromArgbCode: anInteger
	"Answer a <Color> representing the specified encoded value. Note that the encoding of the argument is assumed to be 8-bit RGB, as used by ARGB, not the BGR encoding used by ColorRef's.
	If the argument specifies an alpha value other than 255, then aside from the special 'none' encoding, an ARGB will be answered as ColorRefs cannot represent transparency."

	^((anInteger bitShift: -24) bitAnd: 16rFF) ~~ 16rFF
		ifTrue: 
			[anInteger == self argbNoneCode ifTrue: [self none] ifFalse: [self argbClass fromArgbCode: anInteger]]
		ifFalse: 
			[self fromRgbCode: (((anInteger bitShift: -16) bitAnd: 16rFF)
						bitOr: ((anInteger bitAnd: 16r00FF00) bitOr: ((anInteger bitAnd: 16rFF) bitShift: 16)))]!

fromArray: anArray
	"Answer an instance whose three or (optionally) four (components are provided in the Array argument in order [alpha], red, green, blue."

	^anArray size > 3
		ifTrue: 
			[self
				alpha: anArray first
				red: anArray second
				green: anArray third
				blue: anArray fourth]
		ifFalse: 
			[self
				red: anArray first
				green: anArray second
				blue: anArray third]!

fromCOLORREF: anInteger
	"Answer an appropriate <Color> to represent the color code value, anInteger."

	^((anInteger bitAnd: 16rFFFFFF) < 256 and: [(anInteger bitAnd: 16rFF000000) == 16r1000000]) 
		ifTrue: [IndexedColor withIndex: anInteger]
		ifFalse: [ColorRef fromCOLORREF: anInteger]!

fromHTMLSpec: aString
	"Answer an instance of the receiver from the HTML format RGB specification. These
	are of the form #RRGGBB where RR is the hex value for the red component, etc."

	| source rgb |
	source := aString readStream.
	rgb := (source peekFor: $#)
				ifTrue: [Integer readFrom: source radix: 16]
				ifFalse: [Integer readFrom: source radix: 10].
	^self
		r: ((rgb bitShift: -16) bitAnd: 16rFF)
		g: ((rgb bitShift: -8) bitAnd: 16rFF)
		b: (rgb bitAnd: 16rFF)!

fromInteger: anInteger
	"Private - Answer an appropriate <Color> to represent the color code value, anInteger. This should only be used for loading from STB."

	^self fromCOLORREF: anInteger!

fromNormalizedArray: anArray
	"Answer an instance whose four components are given as #(alpha red green blue).
	 Each component is expected to be between zero and one."

	^anArray size > 3
		ifTrue: 
			[self
				alpha: anArray first * 255
				red: anArray second * 255
				green: anArray third * 255
				blue: anArray fourth * 255]
		ifFalse: 
			[self
				red: anArray first * 255
				green: anArray second * 255
				blue: anArray third * 255]!

fromRgbCode: anInteger
	"Answer a <Color> representing the specified encoded value. Note that the encoding of the argument is assumed to be 8-bit RGB, as used by ARGB, not the BGR encoding used by ColorRef's.
	If the argument specifies an alpha value other than 255, then aside from the special 'none' encoding, an ARGB will be answered as ColorRefs cannot represent translucent colours."

	^self rgbClass fromRgbCode: anInteger!

fuchsia
	^self named: #fuchsia!

gainsboro
	^self named: #gainsboro!

generateCommonColorAccessors
	"Private - Generated methods to return each of the named 'common' colours.
		self generateCommonColorAccessors.
	"

	| autogenerated |
	autogenerated := '**auto generated**' asMethodCategory.
	(self commonColors , {self named: #transparent} select: 
			[:each |
			| symbol |
			symbol := each name.
			(Color class includesSelector: symbol) not
				or: [autogenerated includesMethod: (Color class compiledMethodAt: symbol)]])
		do: 
			[:each |
			| s symbol |
			symbol := each name.
			s := String writeStream.
			s
				nextPutAll: symbol;
				crtab;
				nextPutAll: '^self ';
				display: #named:;
				space;
				print: symbol.
			Color class compile: s contents categories: #('**auto generated**' 'common colors')]!

ghostWhite
	^self named: #ghostWhite!

gold
	^self named: #gold!

goldenrod
	^self named: #goldenrod!

gray
	^self named: #gray!

grayText
	"Answer the Gray Text system color."

	^Color named: #grayText!

green
	^self named: #green!

greenYellow
	^self named: #greenYellow!

h: hueNumber s: saturationNumber l: lightnessNumber
	"Answer a new opaque <Color> with hue, saturation and lightness values from the HLS colour model as represented by the arguments.
	hueNumber specifies the angle in degrees of the color on a color circle where red is zero degrees. Saturation and lightness are numbers in the range [0,1], with higher values for each representing more saturated and lighter colours respectively.
	Lightness values range from black at lightness 0, through vivid hues at lightness 0.5, to white at lightness 1. For example, (Color h: 0 s: 1 l: 0.5) is pure red."

	^self
		h: hueNumber
		s: saturationNumber
		l: lightnessNumber
		alpha: 1.0!

h: hueNumber s: saturationNumber l: lightnessNumber alpha: alphaNumber
	"Answer a new <Color> with hue, saturation and lightness values from the HLS colour model as represented by the arguments, and with translucency specified by the alpha value."

	| s l hf i f lo hi up dn red green blue |
	s := saturationNumber asFloat clampBetween: 0.0 and: 1.0.
	l := lightnessNumber asFloat clampBetween: 0.0 and: 1.0.
	s isZero
		ifTrue: [red := green := blue := l]
		ifFalse: 
			[hf := hueNumber asFloat \\ 360.0 / 60.0.
			i := hf truncated.	"integer part of hue"
			f := hf fractionPart.	"fractional part of hue"

			"Color components follow a step function between levels hi & lo with sloped transitions up & dn. Each component is phased according to hue."
			hi := l < 0.5 ifTrue: [(1.0 + s) * l] ifFalse: [l + s - (l * s)].
			lo := 2.0 * l - hi.
			up := (hi - lo) * f + lo.
			dn := (lo - hi) * f + hi.
			i == 0
				ifTrue: 
					[red := hi.
					green := up.
					blue := lo].
			i == 1
				ifTrue: 
					[red := dn.
					green := hi.
					blue := lo].
			i == 2
				ifTrue: 
					[red := lo.
					green := hi.
					blue := up].
			i == 3
				ifTrue: 
					[red := lo.
					green := dn.
					blue := hi].
			i == 4
				ifTrue: 
					[red := up.
					green := lo.
					blue := hi].
			i == 5
				ifTrue: 
					[red := hi.
					green := lo.
					blue := dn]].
	^self
		a: ((alphaNumber asFloat clampBetween: 0.0 and: 1.0) * 255) rounded
		r: (red * 255) rounded
		g: (green * 255) rounded
		b: (blue * 255) rounded!

h: hueNumber s: saturationNumber v: brightnessNumber
	"Answer a new <Color> with hue, saturation and brightness values from the HSV colour model as represented by the arguments.

	Expected range for arguments to which they will be clamped:
		hue			[0, 360]
		saturation		[0, 1]
		brightness		[0, 1]."

	^self
		h: hueNumber
		s: saturationNumber
		v: brightnessNumber
		alpha: 1!

h: hueNumber s: saturationNumber v: brightnessNumber alpha: alphaNumber
	"Answer a new <Color> with hue, saturation and brightness values from the HSV colour model as represented by the arguments, and with translucency specified by the alpha value.

	Expected range for arguments (to which they are clamped):
		hue		[0, 360]
		saturation	[0, 1]
		value		[0, 1]
		alpha	[0, 1]"

	| s v h red green blue |
	s := saturationNumber asFloat clampBetween: 0.0 and: 1.0.
	v := brightnessNumber asFloat clampBetween: 0.0 and: 1.0.
	h := hueNumber asFloat clampBetween: 0.0 and: 360.0.
	s isZero
		ifTrue: 
			["Color on black-white center line, assume achromatic"
			red := green := blue := v]
		ifFalse: 
			[| i f p q t |
			"Chromatic"
			h = 360 ifTrue: [h := 0].
			h := h / 60.
			i := h floor.
			f := h - i.
			p := v * (1.0 - s).
			q := v * (1.0 - (s * f)).
			t := v * (1.0 - (s * (1.0 - f))).
			i == 0
				ifTrue: 
					[red := v.
					green := t.
					blue := p].
			i == 1
				ifTrue: 
					[red := q.
					green := v.
					blue := p].
			i == 2
				ifTrue: 
					[red := p.
					green := v.
					blue := t].
			i == 3
				ifTrue: 
					[red := p.
					green := q.
					blue := v].
			i == 4
				ifTrue: 
					[red := t.
					green := p.
					blue := v].
			i == 5
				ifTrue: 
					[red := v.
					green := p.
					blue := q]].
	^self
		a: ((alphaNumber asFloat clampBetween: 0.0 and: 1.0) * 255) rounded
		r: (red * 255) rounded
		g: (green * 255) rounded
		b: (blue * 255) rounded!

highlight
	"Answer the Highlight system color."

	^self named: #highlight!

highlight3d
	"Answer the 3D Highlight system color."

	^self named: #highlight3d!

highlightText
	"Answer the Highlight Text system color."

	^Color named: #highlightText!

hls: anArray
	"Answer a <Color> with the hue, lightness and saturation values specified by the first three elements of the <Array> argument."

	^self
		h: anArray first
		s: anArray third
		l: anArray second!

honeydew
	^self named: #honeydew!

hotlight
	"Answer the 'hotlight' system color."

	^self named: #hotlight!

hotPink
	^self named: #hotPink!

hsv: anArrayOfFloat
	"Answer a <Color> with the hue, saturation and brightness values specified by the first three elements of the <Array> argument."

	^self
		h: anArrayOfFloat first
		s: anArrayOfFloat second
		v: anArrayOfFloat third!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

inactiveCaption
	"Answer the 'inactive caption' system colour (i.e. the fill color of the captions of inactive windows)."

	^self named: #inactiveCaption!

indexedColorClass
	^IndexedColor!

indianRed
	^self named: #indianRed!

indigo
	^self named: #indigo!

initialize
	| default |
	NamedColors := LookupTable new.
	ColorNames := LookupTable new.
	default := ColorDefault basicNew
				setCode: Win32Constants.CLR_DEFAULT;
				isImmutable: true;
				yourself.
	self
		addNamed: #default color: default;
		addClassConstant: 'Default' value: default.
	self addClassConstant: 'None'
		value: (ColorNone basicNew
				setCode: Win32Constants.CLR_NONE;
				isImmutable: true;
				yourself).
	self initializeCommonColors.
	#(#black #white) do: [:each | self addClassConstant: each capitalized value: (self named: each)]!

initializeCommonColors
	"Private - Initialize the common colours, as defined in several Windows SDK header files, e.g. gdipluscolor.h.

	Note that we replace the green (a mid-green) with lime (full saturation green) since the standard definition conflicts with the normal expectation that red, green and blue colours are just fully saturated versions of that component. The 'Common Colors' representation where green is a mid-green and lime is 100% green is just too confusing, although #lime is still an alias for green and #commonGreen refers to the 'Common Colors' half-saturation green.

	Some of the other common colour names as defined for later Windows APIs (Gdiplus, Direct2d, etc) do not quite match the original IndexedColor RGB values for the colour of that name as historically used in Dolphin, e.g. the old #darkRed is actually called #maroon in the common colour set and #darkRed itself is slightly lighter. As these differences are relatively insignificant and likely to have only cosmetic effect versus the historic IndexedColor of the same name, the conflict has been resolved in favour of the common colors definition. The original colour is still provided if directly enquired of the IndexedColor class."

	| commonColors |
	ColorNames := LookupTable new.
	commonColors := Set new.
	"Some of the colours have more than one name, e.g. Aqua and Cyan. It is important that the dominant name is enumerated first as this is the name the colour will have once instantiated. It will also be the name of the generated accessor method."
	#(#aliceBlue 16rFFF0F8FF #antiqueWhite 16rFFFAEBD7 #cyan 16rFF00FFFF #aqua 16rFF00FFFF #aquamarine 16rFF7FFFD4 #azure 16rFFF0FFFF #beige 16rFFF5F5DC #bisque 16rFFFFE4C4 #black 16rFF000000 #blanchedAlmond 16rFFFFEBCD #blue 16rFF0000FF #blueViolet 16rFF8A2BE2 #brown 16rFFA52A2A #burlyWood 16rFFDEB887 #cadetBlue 16rFF5F9EA0 #chartreuse 16rFF7FFF00 #chocolate 16rFFD2691E #coral 16rFFFF7F50 #cornflowerBlue 16rFF6495ED #cornsilk 16rFFFFF8DC #crimson 16rFFDC143C #darkBlue 16rFF00008B #darkCyan 16rFF008B8B #darkGoldenrod 16rFFB8860B #darkGray 16rFFA9A9A9 #darkGreen 16rFF006400 #darkKhaki 16rFFBDB76B #darkMagenta 16rFF8B008B #darkOliveGreen 16rFF556B2F #darkOrange 16rFFFF8C00 #darkOrchid 16rFF9932CC #darkRed 16rFF8B0000 #darkSalmon 16rFFE9967A #darkSeaGreen 16rFF8FBC8B #darkSlateBlue 16rFF483D8B #darkSlateGray 16rFF2F4F4F #darkTurquoise 16rFF00CED1 #darkViolet 16rFF9400D3 #deepPink 16rFFFF1493 #deepSkyBlue 16rFF00BFFF #dimGray 16rFF696969 #dodgerBlue 16rFF1E90FF #firebrick 16rFFB22222 #floralWhite 16rFFFFFAF0 #forestGreen 16rFF228B22 #magenta 16rFFFF00FF #fuchsia 16rFFFF00FF #gainsboro 16rFFDCDCDC #ghostWhite 16rFFF8F8FF #gold 16rFFFFD700 #goldenrod 16rFFDAA520 #gray 16rFF808080 #green 16rFF00FF00 #commonGreen 16rFF008000 #greenYellow 16rFFADFF2F #honeydew 16rFFF0FFF0 #hotPink 16rFFFF69B4 #indianRed 16rFFCD5C5C #indigo 16rFF4B0082 #ivory 16rFFFFFFF0 #khaki 16rFFF0E68C #lavender 16rFFE6E6FA #lavenderBlush 16rFFFFF0F5 #lawnGreen 16rFF7CFC00 #lemonChiffon 16rFFFFFACD #lightBlue 16rFFADD8E6 #lightCoral 16rFFF08080 #lightCyan 16rFFE0FFFF #lightGoldenrodYellow 16rFFFAFAD2 #lightGray 16rFFD3D3D3 #lightGreen 16rFF90EE90 #lightPink 16rFFFFB6C1 #lightSalmon 16rFFFFA07A #lightSeaGreen 16rFF20B2AA #lightSkyBlue 16rFF87CEFA #lightSlateGray 16rFF778899 #lightSteelBlue 16rFFB0C4DE #lightYellow 16rFFFFFFE0 #lime 16rFF00FF00 #limeGreen 16rFF32CD32 #linen 16rFFFAF0E6 #maroon 16rFF800000 #mediumAquamarine 16rFF66CDAA #mediumBlue 16rFF0000CD #mediumOrchid 16rFFBA55D3 #mediumPurple 16rFF9370DB #mediumSeaGreen 16rFF3CB371 #mediumSlateBlue 16rFF7B68EE #mediumSpringGreen 16rFF00FA9A #mediumTurquoise 16rFF48D1CC #mediumVioletRed 16rFFC71585 #midnightBlue 16rFF191970 #mintCream 16rFFF5FFFA #mistyRose 16rFFFFE4E1 #moccasin 16rFFFFE4B5 #navajoWhite 16rFFFFDEAD #navy 16rFF000080 #oldLace 16rFFFDF5E6 #olive 16rFF808000 #oliveDrab 16rFF6B8E23 #orange 16rFFFFA500 #orangeRed 16rFFFF4500 #orchid 16rFFDA70D6 #paleGoldenrod 16rFFEEE8AA #paleGreen 16rFF98FB98 #paleTurquoise 16rFFAFEEEE #paleVioletRed 16rFFDB7093 #papayaWhip 16rFFFFEFD5 #peachPuff 16rFFFFDAB9 #peru 16rFFCD853F #pink 16rFFFFC0CB #plum 16rFFDDA0DD #powderBlue 16rFFB0E0E6 #purple 16rFF800080 #red 16rFFFF0000 #rosyBrown 16rFFBC8F8F #royalBlue 16rFF4169E1 #saddleBrown 16rFF8B4513 #salmon 16rFFFA8072 #sandyBrown 16rFFF4A460 #seaGreen 16rFF2E8B57 #seaShell 16rFFFFF5EE #sienna 16rFFA0522D #silver 16rFFC0C0C0 #skyBlue 16rFF87CEEB #slateBlue 16rFF6A5ACD #slateGray 16rFF708090 #snow 16rFFFFFAFA #springGreen 16rFF00FF7F #steelBlue 16rFF4682B4 #tan 16rFFD2B48C #teal 16rFF008080 #thistle 16rFFD8BFD8 #tomato 16rFFFF6347 #transparent 16rFFFFFF #turquoise 16rFF40E0D0 #violet 16rFFEE82EE #wheat 16rFFF5DEB3 #white 16rFFFFFFFF #whiteSmoke 16rFFF5F5F5 #yellow 16rFFFFFF00 #yellowGreen 16rFF9ACD32)
		pairsDo: 
			[:n :v |
			| color |
			color := (self fromArgbCode: v)
						isImmutable: true;
						yourself.
			self addNamed: n color: color.
			color isTransparent ifFalse: [commonColors add: color]].
	self addClassConstant: 'CommonColors'
		value: (commonColors asSortedCollection: 
					[:c1 :c2 |
					| a b |
					a := c1 hsv.
					b := c2 hsv.
					a first < b first
						or: [a first = b first and: [a second < b second or: [a second = b second and: [a third < b third]]]]])
				asArray!

ivory
	^self named: #ivory!

khaki
	^self named: #khaki!

lavender
	^self named: #lavender!

lavenderBlush
	^self named: #lavenderBlush!

lawnGreen
	^self named: #lawnGreen!

lemonChiffon
	^self named: #lemonChiffon!

light3d
	"Answer the light 3D system color"

	^self named: #light3d!

lightBlue
	^self named: #lightBlue!

lightCoral
	^self named: #lightCoral!

lightCyan
	^self named: #lightCyan!

lightGoldenrodYellow
	^self named: #lightGoldenrodYellow!

lightGray
	^self named: #lightGray!

lightGreen
	^self named: #lightGreen!

lightPink
	^self named: #lightPink!

lightSalmon
	^self named: #lightSalmon!

lightSeaGreen
	^self named: #lightSeaGreen!

lightSkyBlue
	^self named: #lightSkyBlue!

lightSlateGray
	^self named: #lightSlateGray!

lightSteelBlue
	^self named: #lightSteelBlue!

lightYellow
	^self named: #lightYellow!

lime
	^self named: #lime!

limeGreen
	^self named: #limeGreen!

linen
	^self named: #linen!

magenta
	^self named: #magenta!

maroon
	^self named: #maroon!

mediumAquamarine
	^self named: #mediumAquamarine!

mediumBlue
	^self named: #mediumBlue!

mediumOrchid
	^self named: #mediumOrchid!

mediumPurple
	^self named: #mediumPurple!

mediumSeaGreen
	^self named: #mediumSeaGreen!

mediumSlateBlue
	^self named: #mediumSlateBlue!

mediumSpringGreen
	^self named: #mediumSpringGreen!

mediumTurquoise
	^self named: #mediumTurquoise!

mediumVioletRed
	^self named: #mediumVioletRed!

menu
	"Answer the standard window menu background color."

	^self named: #menu!

menuBar
	"Answer the standard window top-level menu background color."

	^self named: #menuBar!

menuHilight
	"Answer the standard window menu color for hilighted items."

	^self named: #menuHilight!

menuText
	"Answer the 'menu text' system colour (i.e. the foreground colour of text on menus)."

	^self named: #menuText!

midnightBlue
	^self named: #midnightBlue!

mintCream
	^self named: #mintCream!

mistyRose
	^self named: #mistyRose!

moccasin
	^self named: #moccasin!

named: aSymbol
	^NamedColors at: aSymbol!

navajoWhite
	^self named: #navajoWhite!

navy
	^self named: #navy!

new
	"Color's are generally immutable and must be instantiated through one of the specific instance creation
	methods."

	^self shouldNotImplement!

none
	"Answer the special IndexedColour respresenting no colour."

	^None
!

oldLace
	^self named: #oldLace!

olive
	^self named: #olive!

oliveDrab
	^self named: #oliveDrab!

orange
	^self named: #orange!

orangeRed
	^self named: #orangeRed!

orchid
	^self named: #orchid!

paleGoldenrod
	^self named: #paleGoldenrod!

paleGreen
	^self named: #paleGreen!

paleTurquoise
	^self named: #paleTurquoise!

paleVioletRed
	^self named: #paleVioletRed!

papayaWhip
	^self named: #papayaWhip!

peachPuff
	^self named: #peachPuff!

peru
	^self named: #peru!

pink
	^self named: #pink!

plum
	^self named: #plum!

powderBlue
	^self named: #powderBlue!

purple
	^self named: #purple!

r: redValue g: greenValue b: blueValue
	"Answer an RGB with the given component values, which are expected to be in the range 0.255."

	^self rgbClass
		r: redValue
		g: greenValue
		b: blueValue!

red
	^self named: #red!

red: redValue green: greenValue blue: blueValue
	"Answer an RGB with the given component values, which are clamped to the range 0.255."

	^self rgbClass
		red: redValue
		green: greenValue
		blue: blueValue!

removeNamed: aSymbol
	"Unregister the specified named color."

	^NamedColors removeKey: aSymbol ifAbsent: []!

rgbClass
	^RGB!

rosyBrown
	^self named: #rosyBrown!

royalBlue
	^self named: #royalBlue!

saddleBrown
	^self named: #saddleBrown!

salmon
	^self named: #salmon!

sandyBrown
	^self named: #sandyBrown!

seaGreen
	^self named: #seaGreen!

seaShell
	^self named: #seaShell!

shadow3d
	"Answer the 3D shadow system color."

	^self named: #shadow3d!

sienna
	^self named: #sienna!

silver
	^self named: #silver!

skyBlue
	^self named: #skyBlue!

slateBlue
	^self named: #slateBlue!

slateGray
	^self named: #slateGray!

snow
	^self named: #snow!

springGreen
	^self named: #springGreen!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read an instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using an
	STBSingletonProxy."

	| answer ref value |
	ref := anSTBInFiler register: nil.
	value := anSTBInFiler basicNext.
	answer := value isInteger ifTrue: [self fromInteger: value] ifFalse: [self named: value].
	anSTBInFiler fixup: ref to: answer.
	^answer!

steelBlue
	^self named: #steelBlue!

systemColor: anInteger
	"Answer a new sub-instance of the receiver for the specified system colour."

	^self systemColorClass withIndex: anInteger!

systemColorClass
	^SystemColor!

tan
	^self named: #tan!

teal
	^self named: #teal!

thistle
	^self named: #thistle!

tomato
	^self named: #tomato!

tooltip
	"Answer the standard tooltip background colour."

	^self named: #tooltip!

tooltipText
	"Answer the standard tooltip text colour."

	^self named: #tooltipText!

transparent
	^self named: #transparent!

turquoise
	^self named: #turquoise!

violet
	^self named: #violet!

wheat
	^self named: #wheat!

white
	^White!

whiteSmoke
	^self named: #whiteSmoke!

window
	"Answer the standard window background system color."

	^Window!

windowText
	"Answer the standard window text system color."

	^WindowText!

withIndex: anInteger
	^self indexedColorClass withIndex: anInteger!

yellow
	^self named: #yellow!

yellowGreen
	^self named: #yellowGreen! !

!Color class categoriesForMethods!
a:r:g:b:!instance creation!public! !
addNamed:color:!named colors!public! !
aliceBlue!**auto generated**!common colors!public! !
alpha:red:green:blue:!instance creation!public! !
antiqueWhite!**auto generated**!common colors!public! !
applicationWorkspace!named colors!public!system colors! !
aqua!**auto generated**!common colors!public! !
aquamarine!**auto generated**!common colors!public! !
argbClass!constants!private! !
argbNoneCode!constants!public! !
azure!**auto generated**!common colors!public! !
beige!**auto generated**!common colors!public! !
bisque!**auto generated**!common colors!public! !
black!common colors!public! !
blanchedAlmond!**auto generated**!common colors!public! !
blue!**auto generated**!common colors!public! !
blueViolet!**auto generated**!common colors!public! !
brightness:!instance creation!public! !
brown!**auto generated**!common colors!public! !
burlyWood!**auto generated**!common colors!public! !
byteSize!constants!public! !
cadetBlue!**auto generated**!common colors!public! !
caption!instance creation!public! !
chartreuse!**auto generated**!common colors!public! !
chocolate!**auto generated**!common colors!public! !
commonColors!common colors!constants!public! !
commonGreen!**auto generated**!common colors!public! !
coral!**auto generated**!common colors!public! !
cornflowerBlue!**auto generated**!common colors!public! !
cornsilk!**auto generated**!common colors!public! !
crimson!**auto generated**!common colors!public! !
cyan!**auto generated**!common colors!public! !
darkBlue!**auto generated**!common colors!public! !
darkCyan!**auto generated**!common colors!public! !
darkGoldenrod!**auto generated**!common colors!public! !
darkGray!**auto generated**!common colors!public! !
darkGreen!**auto generated**!common colors!public! !
darkKhaki!**auto generated**!common colors!public! !
darkMagenta!**auto generated**!common colors!public! !
darkOliveGreen!**auto generated**!common colors!public! !
darkOrange!**auto generated**!common colors!public! !
darkOrchid!**auto generated**!common colors!public! !
darkRed!**auto generated**!common colors!public! !
darkSalmon!**auto generated**!common colors!public! !
darkSeaGreen!**auto generated**!common colors!public! !
darkShadow3d!named colors!public!system colors! !
darkSlateBlue!**auto generated**!common colors!public! !
darkSlateGray!**auto generated**!common colors!public! !
darkTurquoise!**auto generated**!common colors!public! !
darkViolet!**auto generated**!common colors!public! !
deepPink!**auto generated**!common colors!public! !
deepSkyBlue!**auto generated**!common colors!public! !
default!instance creation!named colors!public! !
dialog!named colors!public!system colors! !
dimGray!**auto generated**!common colors!public! !
dodgerBlue!**auto generated**!common colors!public! !
face3d!instance creation!public! !
firebrick!**auto generated**!common colors!public! !
floralWhite!**auto generated**!common colors!public! !
forestGreen!**auto generated**!common colors!public! !
fromAddress:!instance creation!public! !
fromArgbCode:!instance creation!public! !
fromArray:!instance creation!public! !
fromCOLORREF:!instance creation!public! !
fromHTMLSpec:!instance creation!public! !
fromInteger:!instance creation!private! !
fromNormalizedArray:!instance creation!public! !
fromRgbCode:!instance creation!public! !
fuchsia!**auto generated**!common colors!public! !
gainsboro!**auto generated**!common colors!public! !
generateCommonColorAccessors!class initialization!private! !
ghostWhite!**auto generated**!common colors!public! !
gold!**auto generated**!common colors!public! !
goldenrod!**auto generated**!common colors!public! !
gray!**auto generated**!common colors!public! !
grayText!instance creation!public! !
green!**auto generated**!common colors!public! !
greenYellow!**auto generated**!common colors!public! !
h:s:l:!instance creation!public! !
h:s:l:alpha:!instance creation!public! !
h:s:v:!instance creation!public! !
h:s:v:alpha:!instance creation!public! !
highlight!instance creation!public! !
highlight3d!named colors!public!system colors! !
highlightText!instance creation!public! !
hls:!instance creation!public! !
honeydew!**auto generated**!common colors!public! !
hotlight!named colors!public!system colors! !
hotPink!**auto generated**!common colors!public! !
hsv:!instance creation!public! !
icon!constants!public! !
inactiveCaption!named colors!public!system colors! !
indexedColorClass!constants!public! !
indianRed!**auto generated**!common colors!public! !
indigo!**auto generated**!common colors!public! !
initialize!class initialization!development!public! !
initializeCommonColors!class initialization!private! !
ivory!**auto generated**!common colors!public! !
khaki!**auto generated**!common colors!public! !
lavender!**auto generated**!common colors!public! !
lavenderBlush!**auto generated**!common colors!public! !
lawnGreen!**auto generated**!common colors!public! !
lemonChiffon!**auto generated**!common colors!public! !
light3d!named colors!public!system colors! !
lightBlue!**auto generated**!common colors!public! !
lightCoral!**auto generated**!common colors!public! !
lightCyan!**auto generated**!common colors!public! !
lightGoldenrodYellow!**auto generated**!common colors!public! !
lightGray!**auto generated**!common colors!public! !
lightGreen!**auto generated**!common colors!public! !
lightPink!**auto generated**!common colors!public! !
lightSalmon!**auto generated**!common colors!public! !
lightSeaGreen!**auto generated**!common colors!public! !
lightSkyBlue!**auto generated**!common colors!public! !
lightSlateGray!**auto generated**!common colors!public! !
lightSteelBlue!**auto generated**!common colors!public! !
lightYellow!**auto generated**!common colors!public! !
lime!**auto generated**!common colors!public! !
limeGreen!**auto generated**!common colors!public! !
linen!**auto generated**!common colors!public! !
magenta!**auto generated**!common colors!public! !
maroon!**auto generated**!common colors!public! !
mediumAquamarine!**auto generated**!common colors!public! !
mediumBlue!**auto generated**!common colors!public! !
mediumOrchid!**auto generated**!common colors!public! !
mediumPurple!**auto generated**!common colors!public! !
mediumSeaGreen!**auto generated**!common colors!public! !
mediumSlateBlue!**auto generated**!common colors!public! !
mediumSpringGreen!**auto generated**!common colors!public! !
mediumTurquoise!**auto generated**!common colors!public! !
mediumVioletRed!**auto generated**!common colors!public! !
menu!named colors!public!system colors! !
menuBar!named colors!public!system colors! !
menuHilight!named colors!public!system colors! !
menuText!named colors!public!system colors! !
midnightBlue!**auto generated**!common colors!public! !
mintCream!**auto generated**!common colors!public! !
mistyRose!**auto generated**!common colors!public! !
moccasin!**auto generated**!common colors!public! !
named:!instance creation!named colors!public! !
navajoWhite!**auto generated**!common colors!public! !
navy!**auto generated**!common colors!public! !
new!instance creation!public! !
none!instance creation!named colors!public! !
oldLace!**auto generated**!common colors!public! !
olive!**auto generated**!common colors!public! !
oliveDrab!**auto generated**!common colors!public! !
orange!**auto generated**!common colors!public! !
orangeRed!**auto generated**!common colors!public! !
orchid!**auto generated**!common colors!public! !
paleGoldenrod!**auto generated**!common colors!public! !
paleGreen!**auto generated**!common colors!public! !
paleTurquoise!**auto generated**!common colors!public! !
paleVioletRed!**auto generated**!common colors!public! !
papayaWhip!**auto generated**!common colors!public! !
peachPuff!**auto generated**!common colors!public! !
peru!**auto generated**!common colors!public! !
pink!**auto generated**!common colors!public! !
plum!**auto generated**!common colors!public! !
powderBlue!**auto generated**!common colors!public! !
purple!**auto generated**!common colors!public! !
r:g:b:!instance creation!public! !
red!**auto generated**!common colors!public! !
red:green:blue:!instance creation!public! !
removeNamed:!named colors!public! !
rgbClass!constants!instance creation!public! !
rosyBrown!**auto generated**!common colors!public! !
royalBlue!**auto generated**!common colors!public! !
saddleBrown!**auto generated**!common colors!public! !
salmon!**auto generated**!common colors!public! !
sandyBrown!**auto generated**!common colors!public! !
seaGreen!**auto generated**!common colors!public! !
seaShell!**auto generated**!common colors!public! !
shadow3d!named colors!public!system colors! !
sienna!**auto generated**!common colors!public! !
silver!**auto generated**!common colors!public! !
skyBlue!**auto generated**!common colors!public! !
slateBlue!**auto generated**!common colors!public! !
slateGray!**auto generated**!common colors!public! !
snow!**auto generated**!common colors!public! !
springGreen!**auto generated**!common colors!public! !
stbReadFrom:format:size:!binary filing!public! !
steelBlue!**auto generated**!common colors!public! !
systemColor:!instance creation!public! !
systemColorClass!constants!public! !
tan!**auto generated**!common colors!public! !
teal!**auto generated**!common colors!public! !
thistle!**auto generated**!common colors!public! !
tomato!**auto generated**!common colors!public! !
tooltip!named colors!public!system colors! !
tooltipText!named colors!public!system colors! !
transparent!**auto generated**!common colors!public! !
turquoise!**auto generated**!common colors!public! !
violet!**auto generated**!common colors!public! !
wheat!**auto generated**!common colors!public! !
white!common colors!public! !
whiteSmoke!**auto generated**!common colors!public! !
window!named colors!public!system colors! !
windowText!named colors!public!system colors! !
withIndex:!instance creation!public! !
yellow!**auto generated**!common colors!public! !
yellowGreen!**auto generated**!common colors!public! !
!

