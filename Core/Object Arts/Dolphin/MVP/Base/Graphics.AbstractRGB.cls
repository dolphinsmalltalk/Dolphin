"Filed out from Dolphin Smalltalk 7"!

Color subclass: #AbstractRGB
	instanceVariableNames: 'code'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractRGB guid: (GUID fromString: '{3f709950-6d41-46a2-bf1f-f6092de13e68}')!
AbstractRGB isAbstract: true!
AbstractRGB comment: '`AbstractColor` is the abstract class of colours specified by individual colour components.

 Concrete subclasses `RGB` represent colours composed of arbitrary proportions of red, green, and blue, and `ARGB` the same but with alpha (translucency).'!
!AbstractRGB categoriesForClass!Drawing! !
!AbstractRGB methodsFor!

asGrayscale
	"Answer a <Color> that is a grayscale representation of the receiver."

	| grey |
	grey := (self red * 30 + (self green * 59) + (self blue * 11)) // 100.
	^Color
		a: self alpha
		r: grey
		g: grey
		b: grey!

asInteger
	"Answer the encoded <integer> value of the receiver."

	^code!

asParameter
	"Answer the receiver such that it can be used for an API call."

	"It is recommended not to use this conversion, as the result will vary depending on the colour encoding, and so may not work if the encoding is not that expected by the API being called. Rather you should use (for example) #rgbCode or #argbCode."

	^code!

brightness
	"Answer a <Number> in the range [0,1] representing the brightness of this color in the HSV colour model."

	^((self red max: self green) max: self blue) / 255.0!

chroma
	"Answer a <Number> in the range [0,1] representing the chroma value of the receiver."

	| r g b |
	r := self red.
	g := self green.
	b := self blue.
	^(((r max: g) max: b) - ((r min: g) min: b)) / 255.0!

code
	"Private - Answer the value of the receiver's ''code'' instance variable."

	^code!

fadedBy: aNumber
	"Answer a new <Color> which is a copy of the receiver faded by the specified factor."

	^Color
		a: self alpha
		r: 255 - ((255 - self red) // aNumber)
		g: 255 - ((255 - self green) // aNumber)
		b: 255 - ((255 - self blue) // aNumber)!

green
	"Answer the receiver's green component component expressed as an <integer> in the range [0,255]."

	^(code bitShift: -8) bitAnd: 16rFF!

hls
	"Answer a three element <Array> representing the hue, lightness, and saturation values that correspond to the receiver."

	| r g b max min span h chroma |
	r := self red.
	g := self green.
	b := self blue.
	max := (r max: g) max: b.
	min := (r min: g) min: b.
	span := max - min.
	span == 0
		ifTrue: [h := 0.0]
		ifFalse: 
			[h := r == max
						ifTrue: [(g - b) asFloat / span * 60.0]
						ifFalse: 
							[g == max
								ifTrue: [120.0 + ((b - r) asFloat / span * 60.0)]
								ifFalse: [240.0 + ((r - g) asFloat / span * 60.0)]].
			h < 0.0 ifTrue: [h := 360.0 + h]].
	chroma := (max - min) asFloat / 255.0.
	^{h.
		(max + min) asFloat / ##(255.0 * 2).
		chroma isZero
			ifTrue: [chroma]
			ifFalse: [chroma / (1.0 - ((max + min) / ##(255.0 * 2) * 2.0 - 1.0) abs)]}!

hslSaturation
	"Answer a <Float> in the range [0.0, 1.0] representing the HSL saturation of the receiver."

	| chroma r g b max min |
	r := self red.
	g := self green.
	b := self blue.
	max := (r max: g) max: b.
	min := (r min: g) min: b.
	chroma := (max - min) / 255.0.
	"Chroma is zero for black and white, which are the two cases of division by zero below."
	^chroma isZero
		ifTrue: [chroma]
		ifFalse: [chroma / (1.0 - ((max + min) / ##(255.0 * 2) * 2.0 - 1.0) abs)]!

hsv
	"Answer a three-element <Array> representing the hue, saturation and brightness values that describe the receiver in the HSV colour system."

	| r g b max min span h |
	r := self red.
	g := self green.
	b := self blue.
	max := (r max: g) max: b.
	min := (r min: g) min: b.
	span := max - min.
	span == 0
		ifTrue: [h := 0.0]
		ifFalse: 
			[h := r == max
						ifTrue: [(g - b) asFloat / span * 60.0]
						ifFalse: 
							[g == max
								ifTrue: [120.0 + ((b - r) asFloat / span * 60.0)]
								ifFalse: [240.0 + ((r - g) asFloat / span * 60.0)]].
			h < 0.0 ifTrue: [h := 360.0 + h]].
	^{h.
		max isZero ifTrue: [0.0] ifFalse: [(max - ((r min: g) min: b)) asFloat / max asFloat].
		max / 255.0}!

hsvSaturation
	"Answer a <Number> in the range [0, 1] representing the HSV saturation of the receiver."

	| max r g b |
	r := self red.
	g := self green.
	b := self blue.
	max := (r max: g) max: b.
	^max isZero ifTrue: [0.0] ifFalse: [(max - ((r min: g) min: b)) asFloat / max]!

hue
	"Answer a <Number> in the range [0,360] representing the receiver's hue in the HSV or HLS color models."

	| r g b max min span h |
	r := self red.
	g := self green.
	b := self blue.
	max := (r max: g) max: b.
	min := (r min: g) min: b.
	span := max - min.
	span == 0 ifTrue: [^0.0].
	h := r == max
				ifTrue: [(g - b) asFloat / span * 60.0]
				ifFalse: 
					[g == max
						ifTrue: [120.0 + ((b - r) asFloat / span * 60.0)]
						ifFalse: [240.0 + ((r - g) asFloat / span * 60.0)]].
	^h < 0.0 ifTrue: [360.0 + h] ifFalse: [h]!

intensity: aNumber
	"Answer a new <Color> which is a copy of the receiver the specified fractional intensity away from black."

	| multiplier |
	multiplier := aNumber clampBetween: 0 and: 1.
	^Color
		a: self alpha
		r: (multiplier * self red) rounded
		g: (multiplier * self green) rounded
		b: (multiplier * self blue) rounded!

isGrayscale
	"Answer whether each of this Colors red, green and blue components are of the same magnitude, i.e. it is a shade of grey."

	| red |
	red := self red.
	^red = self green and: [red = self blue]!

lightness
	"Answer a <Number> in the range [0,1] representing the lightness of the receiver in the HSL colour system."

	| r g b |
	r := self red.
	g := self green.
	b := self blue.
	^(((r max: g) max: b) + ((r min: g) min: b)) / ##(255.0 * 2)!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity."

	^(299 * self red + (587 * self green) + (114 * self blue)) / ##(1000.0 * 255.0)!

registerName: aSymbol
	(ColorNames includesKey: self) ifFalse: [ColorNames at: self put: aSymbol]!

rgb
	"Answer a three-element <Array> containing red, green, and blue components of the receiver expressed as integer in the range [0,255]."

	^{self red. self green. self blue}!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that encoded integer value passed to API calls to represent the color)."

	code := anInteger! !
!AbstractRGB categoriesFor: #asGrayscale!converting!public! !
!AbstractRGB categoriesFor: #asInteger!converting!public! !
!AbstractRGB categoriesFor: #asParameter!converting!public! !
!AbstractRGB categoriesFor: #brightness!accessing!public! !
!AbstractRGB categoriesFor: #chroma!accessing!public! !
!AbstractRGB categoriesFor: #code!accessing!private! !
!AbstractRGB categoriesFor: #fadedBy:!converting!public! !
!AbstractRGB categoriesFor: #green!accessing!public! !
!AbstractRGB categoriesFor: #hls!converting!public! !
!AbstractRGB categoriesFor: #hslSaturation!accessing!public! !
!AbstractRGB categoriesFor: #hsv!converting!public! !
!AbstractRGB categoriesFor: #hsvSaturation!accessing!public! !
!AbstractRGB categoriesFor: #hue!accessing!public! !
!AbstractRGB categoriesFor: #intensity:!converting!public! !
!AbstractRGB categoriesFor: #isGrayscale!public!testing! !
!AbstractRGB categoriesFor: #lightness!accessing!public! !
!AbstractRGB categoriesFor: #luminance!accessing!public! !
!AbstractRGB categoriesFor: #registerName:!helpers!private! !
!AbstractRGB categoriesFor: #rgb!converting!public! !
!AbstractRGB categoriesFor: #setCode:!accessing!private! !

