﻿"Filed out from Dolphin Smalltalk"!

Graphics.AbstractRGB
	subclass: #'Graphics.ARGB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.ARGB guid: (Core.GUID fromString: '{5adf6d2a-72cb-4706-b355-516359e43521}')!

Graphics.ARGB comment: '`ARGB` is the class of colour values specified as individual 8-bit red, green, blue and alpha levels encoded as a 32-bit <integer> value with the components in A,R,G,B order. This encoding is used with all of the more modern Windows graphics APIs such as Gdiplus, DirectDraw, Direct3D, etc.'!

!Graphics.ARGB methodsFor!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255)."

	^(code bitShift: -24) bitAnd: 255!

alpha: anAlphaInteger
	"Answer an <ARGB> which has the same red, green and blue components as the receiver, but with the <integer> alpha, anAlphaInteger.
	The alpha component is expected to be in the range [0,255], but is clamped to that if not."

	| alpha |
	alpha := self alpha * (anAlphaInteger asInteger clampBetween: 0 and: 255) // 255.
	^self class fromArgbCode: ((code bitAnd: 16rFFFFFF) bitOr: (alpha bitShift: 24))!

alphaMask
	"Private - Answer the receiver's alpha bits as they would compose into an ARGB."

	^code bitAnd: 16rFF000000!

argbCode
	"Answer the receiver's colour value in 32-bit ARGB encoding with 8-bits per component in alpha, red, green, blue order."

	"In this case the native representation"

	^code!

asARGB
	"Answer the receiver as an <ARGB>."

	^self!

blue
	"Answer the receiver's blue component component expressed as an <integer> in the range [0,255]."

	^code bitAnd: 16rFF!

green
	"Answer the receiver's green component component expressed as an <integer> in the range [0,255]."

	^(code bitShift: -8) bitAnd: 16rFF!

isNone
	"Answer whether the receiver is a special <Color> representing no colour."

	^code == 16r00FFFFFF!

isOpaque
	"Answer whether this <Color> is completely opaque."

	^self alpha == 255!

normalizedAlpha
	"Answer the receiver's alpha component as a <Number> in the range [0,1], with 0 being completely transparent and 1 completely opaque."

	^self alpha / 255!

red
	"Answer the receiver's red component component expressed as an <integer> in the range [0,255]."

	^(code bitShift: -16) bitAnd: 16rFF!

rgbCode
	"Answer the receiver's <integer> color value in 24-bit RGB encoding with 8-bits per component in COLORREF order (red as low-order byte, green 2nd byte, and blue 3rd byte)."

	^((code bitShift: -16) bitAnd: 16rFF)
		bitOr: ((code bitAnd: 16r00FF00) bitOr: ((code bitAnd: 16rFF) bitShift: 16))! !

!Graphics.ARGB categoriesForMethods!
alpha!accessing!public! !
alpha:!accessing!public! !
alphaMask!accessing!private! !
argbCode!accessing!public! !
asARGB!converting!public! !
blue!accessing!public! !
green!accessing!public! !
isNone!public!testing! !
isOpaque!public!testing! !
normalizedAlpha!accessing!public! !
red!accessing!public! !
rgbCode!public! !
!

!Graphics.ARGB class methodsFor!

a: alphaValue r: redValue g: greenValue b: blueValue
	"Answer an instance whose four components are given.
	 - Alternate constructor with no bounds checking"

	^self 
		fromArgbCode: ((blueValue bitOr: ((greenValue bitShift: 8) bitOr: (redValue bitShift: 16))) 
				bitOr: (alphaValue bitShift: 24))!

alpha: alphaValue red: redValue green: greenValue blue: blueValue
	"Answer an instance whose four component colour values are provided as the arguments, but
	which are clamped to the range 0..255."

	^self
		fromArgbCode: (((blueValue asInteger clampBetween: 0 and: 255)
				bitOr: (((greenValue asInteger clampBetween: 0 and: 255) bitShift: 8)
						bitOr: ((redValue asInteger clampBetween: 0 and: 255) bitShift: 16)))
					bitOr: ((alphaValue asInteger clampBetween: 0 and: 255) bitShift: 24))!

default
	"Answer the special Color respresenting the default colour.
	Pick an ARGB value that no one else is likely to choose"

	^self
		alpha: 200
		red: 200
		green: 200
		blue: 201!

fromArgbCode: anInteger
	"Answer an instance representing the specified encoded value. Note that the encoding is RGB, as used by ARGB, not the BGR encoding used by ColorRef's"

	<primitive: 157>
	^(self basicNew)
		setCode: anInteger;
		yourself!

fromInteger: anInteger
	"Private - Answer an instance with the specified code value, which is assumed to be in the receiver's native encoding. This should only be used for loading from STB."

	^self fromArgbCode: anInteger!

none
	^self fromArgbCode: self argbNoneCode!

r: redInteger g: greenInteger b: blueInteger
	"Answer a fully opaque instance whose red, green and blue components are specified as the
	arguments, which are expected to be in the range 0..255."

	^self
		fromArgbCode: ((blueInteger bitOr: ((greenInteger bitShift: 8) bitOr: (redInteger bitShift: 16)))
				bitOr: 16rFF000000)!

red: redValue green: greenValue blue: blueValue
	"Answer a fully opaque instance whose red, green and blue components are specified as the
	arguments, which are clamped to the range 0..255."

	^self
		alpha: 255
		red: redValue
		green: greenValue
		blue: blueValue!

transparent
	^self none! !

!Graphics.ARGB class categoriesForMethods!
a:r:g:b:!instance creation!public! !
alpha:red:green:blue:!instance creation!public! !
default!instance creation!public! !
fromArgbCode:!instance creation!public! !
fromInteger:!instance creation!private! !
none!instance creation!public! !
r:g:b:!instance creation!public! !
red:green:blue:!instance creation!public! !
transparent!instance creation!public! !
!

