"Filed out from Dolphin Smalltalk 7"!

Graphics.AbstractRGB subclass: #'Graphics.ARGB'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ARGB guid: (Core.GUID fromString: '{5adf6d2a-72cb-4706-b355-516359e43521}')!
Graphics.ARGB comment: '`ARGB` is the class of colour values specified as individual 8-bit red, green, blue and alpha levels encoded as a 32-bit <integer> value with the components in A,R,G,B order. This encoding is used with all of the more modern Windows graphics APIs such as Gdiplus, DirectDraw, Direct3D, etc.'!
!Graphics.ARGB categoriesForClass!Unclassified! !
!Graphics.ARGB methodsFor!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255)."

	^(code bitShift: -24) bitAnd: 255!

alpha: anAlphaInteger
	"Answer an <ARGB> which has the same red, green and blue components as the receiver, but with the <integer> alpha, anAlphaInteger.
	The alpha component is expected to be in the range [0,255], but is clamped to that if not."

	^self class fromArgbCode: ((code bitAnd: 16rFFFFFF)
				bitOr: ((anAlphaInteger asInteger clampBetween: 0 and: 255) bitShift: 24))!

alphaMask
	"Private - Answer the receiver's alpha bits as they would compose into an ARGB."

	^code bitAnd: 16rFF000000!

argb
	"Answer a four-element <Array> containing alpha, red, green, and blue components of the receiver expressed as integer in the range [0,255]."

	^{self alpha. self red. self green. self blue}!

argbCode
	"Answer the receiver's colour value in 32-bit ARGB encoding with 8-bits per component in alpha, red, green, blue order."

	"In this case the native representation"

	^code!

asRGB
	"Answer an <RGB> representing an opaque version of the receiver but with the same red, green and blue components."

	^Color fromRgbCode: (((code bitShift: -16) bitAnd: 16rFF)
				bitOr: ((code bitAnd: 16r00FF00) bitOr: ((code bitAnd: 16rFF) bitShift: 16)))!

blue
	"Answer the receiver's blue component component expressed as an <integer> in the range [0,255]."

	^code bitAnd: 255!

isNone
	"Answer whether the receiver is a special <Color> representing no colour."

	^code == 16r00FFFFFF!

normalizedAlpha
	"Answer the receiver's alpha component as a <Number> in the range [0,1], with 0 being completely transparent and 1 completely opaque."

	^self alpha / 255!

red
	"Answer the receiver's red component component expressed as an <integer> in the range [0,255]."

	^(code bitShift: -16) bitAnd: 255! !
!Graphics.ARGB categoriesFor: #alpha!accessing!public! !
!Graphics.ARGB categoriesFor: #alpha:!accessing!public! !
!Graphics.ARGB categoriesFor: #alphaMask!accessing!private! !
!Graphics.ARGB categoriesFor: #argb!converting!public! !
!Graphics.ARGB categoriesFor: #argbCode!accessing!public! !
!Graphics.ARGB categoriesFor: #asRGB!converting!public! !
!Graphics.ARGB categoriesFor: #blue!accessing!public! !
!Graphics.ARGB categoriesFor: #isNone!public!testing! !
!Graphics.ARGB categoriesFor: #normalizedAlpha!accessing!public! !
!Graphics.ARGB categoriesFor: #red!accessing!public! !

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
!Graphics.ARGB class categoriesFor: #a:r:g:b:!instance creation!public! !
!Graphics.ARGB class categoriesFor: #alpha:red:green:blue:!instance creation!public! !
!Graphics.ARGB class categoriesFor: #default!instance creation!public! !
!Graphics.ARGB class categoriesFor: #fromArgbCode:!instance creation!public! !
!Graphics.ARGB class categoriesFor: #fromInteger:!instance creation!private! !
!Graphics.ARGB class categoriesFor: #none!instance creation!public! !
!Graphics.ARGB class categoriesFor: #r:g:b:!instance creation!public! !
!Graphics.ARGB class categoriesFor: #red:green:blue:!instance creation!public! !
!Graphics.ARGB class categoriesFor: #transparent!instance creation!public! !

