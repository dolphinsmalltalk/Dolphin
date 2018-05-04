"Filed out from Dolphin Smalltalk 7"!

Object subclass: #Color
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Color guid: (GUID fromString: '{87b4c465-026e-11d3-9fd7-00a0cc3e4a32}')!
Color isAbstract: true!
Color comment: 'Color is the abstract class of colours. Concreate subclasses represent the different types of colour object, such as the logical system colours (SystemColor), palletized colours (IndexedColor), and colours composed of arbitrary proportions of red, green, and blue elements (RGB).'!
!Color categoriesForClass!Drawing! !
!Color methodsFor!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^255!

asColorRef
	"Answer the receiver as a ColorRef (an RGB value or one of the standard pseudo-colour constants)"

	^self asRGB!

asDword
	"Answer the receiver in a form suitable for passing as a 32-bit unsigned integer parameter."

	^self asParameter!

asGrayscale
	| grey rgb |
	rgb := self asRGB.
	grey := (rgb red * 30 + (rgb green * 59) + (rgb blue * 11)) // 100.
	^Color 
		red: grey
		green: grey
		blue: grey!

asIndexedColor
	"Answer the receiver as an IndexedColour."

	^self subclassResponsibility!

asParameter
	"Answer the reciever in a form suitable for an API call."

	^self subclassResponsibility!

asRGB
	"Answer the receiver as an RGB"

	^self subclassResponsibility!

asUIntPtr
	"Answer the receiver in a form suitable for passing/returning as a Windows LRESULT
	(32 or 64-bit, depending on host OS) return value. The default is self (which will cause the
	default window proc. of the window to be called for most objects other than Integers when
	used as a return value)."

	^self asParameter!

blue
	"Answer the receiver's blue component (a SmallInteger in the range 0..255)."

	^self asRGB blue!

brush
	"Answer a Brush configured for solid painting of the receiver's color."

	^self brushClass newColor: self!

brushClass
	"Private - Answer the class of Brush to be used in conjunction with the receiver."

	^Brush!

defaultPalette
	"Private - Answer the default palette."

	^GDILibrary default getStockObject: DEFAULT_PALETTE
!

faded
	"Answer a new color which is a faded (half intensity) copy of the receiver."

	^self fadedBy: 2!

fadedBy: aNumber
	"Answer a new <Color> which is a copy of the receiver faded by
	the specified factor."

	| rgb |
	rgb := self asRGB.
	^Color 
		red: 255 - ((255 - rgb red) // aNumber)
		green: 255 - ((255 - rgb green) // aNumber)
		blue: 255 - ((255 - rgb blue) // aNumber)!

green
	"Answer the receiver's green component (a SmallInteger in the range 0..255)."

	^self asRGB green!

hls
	"Answer the hue, luminance, and saturation values that correspond to the receiver."

	^self asRGB hls!

hue
	"Answer the hue of the receiver."

	^self asRGB hls at: 1!

intensity: aFraction 
	"Answer a new <Color> which is a copy of the receiver given a fractional intensity
	away from black."

	| rgb multiplier |
	rgb := self asRGB.
	multiplier := aFraction min: 1.
	^Color 
		red: (rgb red * multiplier) rounded
		green: (rgb green * multiplier) rounded
		blue: (rgb blue * multiplier) rounded!

isDefault
	"Answer whether the receiver is the special <Color> representing no colour."

	^false!

isNone
	"Answer whether the receiver is the special <Color> representing no colour."

	^false!

luminance
	"Answer the luminance of the receiver."

	^self asRGB hls at: 2!

pen
	"Answer a Pen configured for solid painting of the receiver's color."

	^self penClass color: self!

penClass
	"Private - Answer the class of Pen to be used in conjunction with the receiver."

	^Pen!

red
	"Answer the receiver's red component (a SmallInteger in the range 0..255)."

	^self asRGB red!

saturation
	"Answer the saturation of the receiver."

	^self asRGB hls at: 3! !
!Color categoriesFor: #alpha!accessing!public! !
!Color categoriesFor: #asColorRef!converting!public! !
!Color categoriesFor: #asDword!converting!public! !
!Color categoriesFor: #asGrayscale!converting!public! !
!Color categoriesFor: #asIndexedColor!converting!public! !
!Color categoriesFor: #asParameter!converting!public! !
!Color categoriesFor: #asRGB!converting!public! !
!Color categoriesFor: #asUIntPtr!converting!public! !
!Color categoriesFor: #blue!accessing!public! !
!Color categoriesFor: #brush!converting!public! !
!Color categoriesFor: #brushClass!constants!private! !
!Color categoriesFor: #defaultPalette!constants!private! !
!Color categoriesFor: #faded!converting!public! !
!Color categoriesFor: #fadedBy:!converting!public! !
!Color categoriesFor: #green!accessing!public! !
!Color categoriesFor: #hls!converting!public! !
!Color categoriesFor: #hue!accessing!public! !
!Color categoriesFor: #intensity:!converting!public! !
!Color categoriesFor: #isDefault!public!testing! !
!Color categoriesFor: #isNone!public!testing! !
!Color categoriesFor: #luminance!accessing!public! !
!Color categoriesFor: #pen!converting!public! !
!Color categoriesFor: #penClass!constants!private! !
!Color categoriesFor: #red!accessing!public! !
!Color categoriesFor: #saturation!accessing!public! !

Color methodProtocol: #color attributes: #(#readOnly) selectors: #(#asParameter #asRGB #brush #pen)!

!Color class methodsFor!

applicationWorkspace
	"Answer the background colour for an application's workspace area (e.g. the background of
	the main window MDI applications). This is typically a dark grey."

	^self systemColor: COLOR_APPWORKSPACE!

black
	"Answer an instance respresenting black."

	^self stdColor: #black!

blue
	"Answer an instance respresenting blue."

	^self stdColor: #blue!

brown
	"Answer an instance respresenting brown."

	^self stdColor: #brown!

byteSize
	"Answer the byte size of the receiver when converted to parameter format (i.e. by asParameter)."

	^4!

cyan
	"Answer an instance respresenting cyan."

	^self stdColor: #cyan!

darkBlue
	"Answer an instance respresenting darkBlue."

	^self stdColor: #darkBlue!

darkCyan
	"Answer an instance respresenting dark cyan."

	^self stdColor: #darkCyan!

darkGray
	"Answer an instance respresenting darkGray."

	^self stdColor: #darkGray!

darkGreen
	"Answer an instance respresenting darkGreen."

	^self stdColor: #darkGreen!

darkMagenta
	"Answer an instance respresenting darkMagenta."

	^self stdColor: #darkMagenta!

darkRed
	"Answer an instance respresenting darkRed."

	^self stdColor: #darkRed!

darkShadow3d
	"Answer the 3D shadow system color."

	^self systemColor: COLOR_3DDKSHADOW!

default
	"Answer the special <Color> respresenting the default colour."

	^ColorRef default!

dialog
	"Answer the standard dialog background system color."

	^self systemColor: COLOR_3DFACE!

face3d
	"Answer the 3D button/menu face system color."

	^self systemColor: COLOR_3DFACE!

fromAddress: anAddress
	"Answer a new Colour, based on the 32-bit integer value at anAddress."

	^self fromInteger: (anAddress asExternalAddress sdwordAtOffset: 0)!

fromHTMLSpec: aString
	"Answer an instance of the receiver from the HTML format RGB specification. These
	are of the form #RRGGBB where RR is the hex value for the red component, etc."

	| red green blue source rgb |
	source := aString readStream.
	rgb := (source peekFor: $#)
		ifTrue: [Integer readFrom: source radix: 16]
		ifFalse: [Integer readFrom: source radix: 10].
	blue := rgb bitAnd: 16rFF.
	rgb := rgb bitShift: -8.
	green := rgb bitAnd: 16rFF.
	rgb := rgb bitShift: -8.
	red := rgb bitAnd: 16rFF.
	^self red: red green: green blue: blue!

fromInteger: anInteger
	"Answer an appropriate <Color> to represent the color code value, anInteger."

	^((anInteger bitAnd: 16rFFFFFF) < 256 and: [(anInteger bitAnd: 16rFF000000) == 16r1000000]) 
		ifTrue: [IndexedColor withIndex: anInteger]
		ifFalse: [ColorRef fromInteger: anInteger]!

gray
	"Answer an instance respresenting gray."

	^self stdColor: #gray!

green
	"Answer an instance respresenting green."

	^self stdColor: #green!

highlight
	"Answer the Highlight system color."

	^self systemColor: COLOR_HIGHLIGHT!

highlight3d
	"Answer the 3D Highlight system color."

	^self systemColor: COLOR_3DHIGHLIGHT!

hls: anArray
	^self hue: anArray first luminance: anArray second saturation: anArray third!

hue: h luminance: l saturation: s 
	^RGB fromInteger: (ShlwapiLibrary default 
				colorHLSToRGB: h
				wLuminance: l
				wSaturation: s)!

hue: hue saturation: saturation value: value 
	"Answer a new RGB instance representing the HSV color denoted by the arguments.

	Valid range for arguments:
		hue			[0, 360]
		saturation	[0, 1]
		value		[0, 1]."

	| red green blue |
	saturation isZero 
		ifTrue: 
			["Color on black-white center line, assume achromatic"

			red := green := blue := value]
		ifFalse: 
			["Chromatic"

			| h i f p q t |
			h := hue.
			h = 360 ifTrue: [h := 0].
			h := h / 60.
			i := h floor.
			f := h - i.
			p := value * (1.0 - saturation).
			q := value * (1.0 - (saturation * f)).
			t := value * (1.0 - (saturation * (1.0 - f))).
			i == 0 
				ifTrue: 
					[red := value.
					green := t.
					blue := p].
			i == 1 
				ifTrue: 
					[red := q.
					green := value.
					blue := p].
			i == 2 
				ifTrue: 
					[red := p.
					green := value.
					blue := t].
			i == 3 
				ifTrue: 
					[red := p.
					green := q.
					blue := value].
			i == 4 
				ifTrue: 
					[red := t.
					green := p.
					blue := value].
			i == 5 
				ifTrue: 
					[red := value.
					green := p.
					blue := q]].
	^self 
		red: (red * 255) truncated
		green: (green * 255) truncated
		blue: (blue * 255) truncated.
	#todo	"Replace by call to system function for conversion"!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

light3d
	"Answer the light 3D system color."

	^self systemColor: COLOR_3DLIGHT!

magenta
	"Answer an instance respresenting magenta."

	^self stdColor: #magenta!

menu
	"Answer the standard window menu background color."

	^self systemColor: COLOR_MENU!

new
	"Color's are immutable and must be instantiated through one of the specific instance creation
	methods."

	^self shouldNotImplement!

none
	"Answer the special IndexedColour respresenting no colour."

	^ColorRef none
!

red
	"Answer an instance respresenting red."

	^self stdColor: #red!

red: redValue green: greenValue blue: blueValue
	"Answer an RGB with the given component values."

	^RGB
		red: redValue
		green: greenValue
		blue: blueValue
!

shadow3d
	"Answer the 3D shadow system color."

	^self systemColor: COLOR_3DSHADOW!

stdColor: aSymbol
	"Private - Answer an instance whose name is aSymbol."

	^IndexedColor stdColor: aSymbol!

systemColor: anInteger
	"Answer a new sub-instance of the receiver for the specified system colour."

	^SystemColor fromId: anInteger!

tooltip
	"Answer the standard tooltip background colour."

	^self systemColor: COLOR_INFOBK!

tooltipText
	"Answer the standard tooltip text colour."

	^self systemColor: COLOR_INFOTEXT!

white
	"Answer an instance respresenting white."

	^self stdColor: #white!

window
	"Answer the standard window background system color."

	^self systemColor: COLOR_WINDOW!

windowText
	"Answer the standard window text system color."

	^self systemColor: COLOR_WINDOWTEXT!

withIndex: anInteger
	"Answer an IndexedColour with index anInteger."

	^IndexedColor withIndex: anInteger
!

yellow
	"Answer an instance respresenting yellow."

	^self stdColor: #yellow! !
!Color class categoriesFor: #applicationWorkspace!constants!public! !
!Color class categoriesFor: #black!instance creation!public! !
!Color class categoriesFor: #blue!instance creation!public! !
!Color class categoriesFor: #brown!instance creation!public! !
!Color class categoriesFor: #byteSize!constants!public! !
!Color class categoriesFor: #cyan!instance creation!public! !
!Color class categoriesFor: #darkBlue!instance creation!public! !
!Color class categoriesFor: #darkCyan!instance creation!public! !
!Color class categoriesFor: #darkGray!instance creation!public! !
!Color class categoriesFor: #darkGreen!instance creation!public! !
!Color class categoriesFor: #darkMagenta!instance creation!public! !
!Color class categoriesFor: #darkRed!instance creation!public! !
!Color class categoriesFor: #darkShadow3d!instance creation!public! !
!Color class categoriesFor: #default!instance creation!public! !
!Color class categoriesFor: #dialog!instance creation!public! !
!Color class categoriesFor: #face3d!constants!public! !
!Color class categoriesFor: #fromAddress:!instance creation!public! !
!Color class categoriesFor: #fromHTMLSpec:!instance creation!public! !
!Color class categoriesFor: #fromInteger:!instance creation!public! !
!Color class categoriesFor: #gray!instance creation!public! !
!Color class categoriesFor: #green!instance creation!public! !
!Color class categoriesFor: #highlight!constants!public! !
!Color class categoriesFor: #highlight3d!instance creation!public! !
!Color class categoriesFor: #hls:!public! !
!Color class categoriesFor: #hue:luminance:saturation:!public! !
!Color class categoriesFor: #hue:saturation:value:!instance creation!public! !
!Color class categoriesFor: #icon!constants!public! !
!Color class categoriesFor: #light3d!constants!public! !
!Color class categoriesFor: #magenta!instance creation!public! !
!Color class categoriesFor: #menu!instance creation!public! !
!Color class categoriesFor: #new!instance creation!public! !
!Color class categoriesFor: #none!instance creation!public! !
!Color class categoriesFor: #red!instance creation!public! !
!Color class categoriesFor: #red:green:blue:!instance creation!public! !
!Color class categoriesFor: #shadow3d!instance creation!public! !
!Color class categoriesFor: #stdColor:!instance creation!private! !
!Color class categoriesFor: #systemColor:!instance creation!public! !
!Color class categoriesFor: #tooltip!instance creation!public! !
!Color class categoriesFor: #tooltipText!instance creation!public! !
!Color class categoriesFor: #white!instance creation!public! !
!Color class categoriesFor: #window!instance creation!public! !
!Color class categoriesFor: #windowText!instance creation!public! !
!Color class categoriesFor: #withIndex:!instance creation!public! !
!Color class categoriesFor: #yellow!instance creation!public! !

Color class methodProtocol: #'color factory' attributes: #(#readOnly) selectors: #(#black #hue:saturation:value: #red:green:blue: #systemColor: #white #withIndex:)!

