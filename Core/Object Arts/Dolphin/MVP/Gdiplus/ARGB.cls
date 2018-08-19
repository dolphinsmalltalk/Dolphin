"Filed out from Dolphin Smalltalk 7"!

Color subclass: #ARGB
	instanceVariableNames: 'code'
	classVariableNames: 'DefaultA StdColours'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ARGB guid: (GUID fromString: '{5adf6d2a-72cb-4706-b355-516359e43521}')!
ARGB comment: ''!
!ARGB categoriesForClass!Unclassified! !
!ARGB methodsFor!

= anARGB
	^self species == anARGB species and: [self code = anARGB code]!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255)."

	^(code bitShift: -24) bitAnd: 255!

asARGB
	"Answer an <ARGB> equivalent of the receiver."

	^self!

asParameter
	"Answer the receiver such that it can be used for an API call."

	^code!

asRGB
	"Answer the receiver as an RGB, the encoding of which is actually BGR."

	^RGB fromInteger: (((code bitShift: -16) bitAnd: 16rFF)
				bitOr: ((code bitAnd: 16r00FF00) bitOr: ((code bitAnd: 16rFF) bitShift: 16)))!

blue
	"Answer the receiver's blue component (a SmallInteger in the range 0..255)."

	^code bitAnd: 255!

code
	"Private - Answer the value of the receiver's ''code'' instance variable."

	^code!

green
	"Answer the receiver's green component (a SmallInteger in the range 0..255)."

	^(code bitShift: -8) bitAnd: 16rFF!

hash
	"Answer the <integer> hash value for the receiver."

	^self code!

printOn: aStream
	"Put an ASCII representation of receiver onto aStream."

	| a |
	aStream
		nextPut: $(;
		display: self class.
	a := self alpha.
	a == 255
		ifFalse: 
			[aStream
				display: ' a: ';
				print: a].
	aStream
		display: ' r: ';
		print: self red;
		display: ' g: ';
		print: self green;
		display: ' b: ';
		print: self blue;
		nextPut: $)!

red
	"Answer the receiver's red component (a SmallInteger in the range 0..255)."

	^(code bitShift: -16) bitAnd: 255!

setCode: anInteger
	"Private - Set the <integer> value of the ARGB (i.e. that value passed to API calls
	to represent the color)."

	code := anInteger! !
!ARGB categoriesFor: #=!comparing!public! !
!ARGB categoriesFor: #alpha!accessing!public! !
!ARGB categoriesFor: #asARGB!converting!public! !
!ARGB categoriesFor: #asParameter!converting!public! !
!ARGB categoriesFor: #asRGB!converting!public! !
!ARGB categoriesFor: #blue!accessing!public! !
!ARGB categoriesFor: #code!accessing!private! !
!ARGB categoriesFor: #green!accessing!public! !
!ARGB categoriesFor: #hash!comparing!public! !
!ARGB categoriesFor: #printOn:!printing!public! !
!ARGB categoriesFor: #red!accessing!public! !
!ARGB categoriesFor: #setCode:!accessing!private! !

!ARGB class methodsFor!

a: alphaValue r: redValue g: greenValue b: blueValue
	"Answer an instance whose four components are given.
	 - Alternate constructor with no bounds checking"

	^self 
		fromInteger: ((blueValue bitOr: ((greenValue bitShift: 8) bitOr: (redValue bitShift: 16))) 
				bitOr: (alphaValue bitShift: 24))!

alpha: alphaValue red: redValue green: greenValue blue: blueValue
	"Answer an instance whose four component colour values are provided as the arguments, but
	which are clamped to the range 0..255."

	^self
		fromInteger: (((blueValue asInteger clampBetween: 0 and: 255)
				bitOr: (((greenValue asInteger clampBetween: 0 and: 255) bitShift: 8)
						bitOr: ((redValue asInteger clampBetween: 0 and: 255) bitShift: 16)))
					bitOr: ((alphaValue asInteger clampBetween: 0 and: 255) bitShift: 24))!

default
	"Answer the special Color respresenting the default colour.
	Pick an ARGB value that no one else is likely to choose"

	^DefaultA!

fromArray: anArray
	"Answer an instance whose four components are given as #(alpha red green blue).
	 - Alternate constructor  in a form that is easy to translate from C++ examples"

	^self 
		alpha: anArray first
		red: anArray second
		green: anArray third
		blue: anArray fourth!

fromInteger: anInteger
	"Answer an instance with the specified code value."

	<primitive: 157>
	^(self basicNew)
		setCode: anInteger;
		yourself!

fromNormalizedArray: anArray
	"Answer an instance whose four components are given as #(alpha red green blue).
	 Each component is expected to be between zero and one."

	^self 
		alpha: anArray first * 255
		red: anArray second * 255
		green: anArray third * 255
		blue: anArray fourth * 255!

green
	"Overridden because stdColor green is not a true 16r00FF00 green.  (stdColor lime is, though, go figure)"

	^self 
		r: 0
		g: 255
		b: 0!

initialize
	"Initialize the 'Common color constants' as defined in GdiPlusColor.h"

	"
	self initialize
	"

	"SW - Should this be named CommonColors?"

	| stdColours |
	(stdColours := IdentityDictionary new)
		at: #aliceBlue put: 16rFFF0F8FF;
		at: #antiqueWhite put: 16rFFFAEBD7;
		at: #aqua put: 16rFF00FFFF;
		at: #aquamarine put: 16rFF7FFFD4;
		at: #azure put: 16rFFF0FFFF;
		at: #beige put: 16rFFF5F5DC;
		at: #bisque put: 16rFFFFE4C4;
		at: #black put: 16rFF000000;
		at: #blanchedAlmond put: 16rFFFFEBCD;
		at: #blue put: 16rFF0000FF;
		at: #blueViolet put: 16rFF8A2BE2;
		at: #brown put: 16rFFA52A2A;
		at: #burlyWood put: 16rFFDEB887;
		at: #cadetBlue put: 16rFF5F9EA0;
		at: #chartreuse put: 16rFF7FFF00;
		at: #chocolate put: 16rFFD2691E;
		at: #coral put: 16rFFFF7F50;
		at: #cornflowerBlue put: 16rFF6495ED;
		at: #cornsilk put: 16rFFFFF8DC;
		at: #crimson put: 16rFFDC143C;
		at: #cyan put: 16rFF00FFFF;
		at: #darkBlue put: 16rFF00008B;
		at: #darkCyan put: 16rFF008B8B;
		at: #darkGoldenrod put: 16rFFB8860B;
		at: #darkGray put: 16rFFA9A9A9;
		at: #darkGreen put: 16rFF006400;
		at: #darkKhaki put: 16rFFBDB76B;
		at: #darkMagenta put: 16rFF8B008B;
		at: #darkOliveGreen put: 16rFF556B2F;
		at: #darkOrange put: 16rFFFF8C00;
		at: #darkOrchid put: 16rFF9932CC;
		at: #darkRed put: 16rFF8B0000;
		at: #darkSalmon put: 16rFFE9967A;
		at: #darkSeaGreen put: 16rFF8FBC8B;
		at: #darkSlateBlue put: 16rFF483D8B;
		at: #darkSlateGray put: 16rFF2F4F4F;
		at: #darkTurquoise put: 16rFF00CED1;
		at: #darkViolet put: 16rFF9400D3;
		at: #deepPink put: 16rFFFF1493;
		at: #deepSkyBlue put: 16rFF00BFFF;
		at: #dimGray put: 16rFF696969;
		at: #dodgerBlue put: 16rFF1E90FF;
		at: #firebrick put: 16rFFB22222;
		at: #floralWhite put: 16rFFFFFAF0;
		at: #forestGreen put: 16rFF228B22;
		at: #fuchsia put: 16rFFFF00FF;
		at: #gainsboro put: 16rFFDCDCDC;
		at: #ghostWhite put: 16rFFF8F8FF;
		at: #gold put: 16rFFFFD700;
		at: #goldenrod put: 16rFFDAA520;
		at: #gray put: 16rFF808080;
		at: #green put: 16rFF008000;
		at: #greenYellow put: 16rFFADFF2F;
		at: #honeydew put: 16rFFF0FFF0;
		at: #hotPink put: 16rFFFF69B4;
		at: #indianRed put: 16rFFCD5C5C;
		at: #indigo put: 16rFF4B0082;
		at: #ivory put: 16rFFFFFFF0;
		at: #khaki put: 16rFFF0E68C;
		at: #lavender put: 16rFFE6E6FA;
		at: #lavenderBlush put: 16rFFFFF0F5;
		at: #lawnGreen put: 16rFF7CFC00;
		at: #lemonChiffon put: 16rFFFFFACD;
		at: #lightBlue put: 16rFFADD8E6;
		at: #lightCoral put: 16rFFF08080;
		at: #lightCyan put: 16rFFE0FFFF;
		at: #lightGoldenrodYellow put: 16rFFFAFAD2;
		at: #lightGray put: 16rFFD3D3D3;
		at: #lightGreen put: 16rFF90EE90;
		at: #lightPink put: 16rFFFFB6C1;
		at: #lightSalmon put: 16rFFFFA07A;
		at: #lightSeaGreen put: 16rFF20B2AA;
		at: #lightSkyBlue put: 16rFF87CEFA;
		at: #lightSlateGray put: 16rFF778899;
		at: #lightSteelBlue put: 16rFFB0C4DE;
		at: #lightYellow put: 16rFFFFFFE0;
		at: #lime put: 16rFF00FF00;
		at: #limeGreen put: 16rFF32CD32;
		at: #linen put: 16rFFFAF0E6;
		at: #magenta put: 16rFFFF00FF;
		at: #maroon put: 16rFF800000;
		at: #mediumAquamarine put: 16rFF66CDAA;
		at: #mediumBlue put: 16rFF0000CD;
		at: #mediumOrchid put: 16rFFBA55D3;
		at: #mediumPurple put: 16rFF9370DB;
		at: #mediumSeaGreen put: 16rFF3CB371;
		at: #mediumSlateBlue put: 16rFF7B68EE;
		at: #mediumSpringGreen put: 16rFF00FA9A;
		at: #mediumTurquoise put: 16rFF48D1CC;
		at: #mediumVioletRed put: 16rFFC71585;
		at: #midnightBlue put: 16rFF191970;
		at: #mintCream put: 16rFFF5FFFA;
		at: #mistyRose put: 16rFFFFE4E1;
		at: #moccasin put: 16rFFFFE4B5;
		at: #navajoWhite put: 16rFFFFDEAD;
		at: #navy put: 16rFF000080;
		at: #oldLace put: 16rFFFDF5E6;
		at: #olive put: 16rFF808000;
		at: #oliveDrab put: 16rFF6B8E23;
		at: #orange put: 16rFFFFA500;
		at: #orangeRed put: 16rFFFF4500;
		at: #orchid put: 16rFFDA70D6;
		at: #paleGoldenrod put: 16rFFEEE8AA;
		at: #paleGreen put: 16rFF98FB98;
		at: #paleTurquoise put: 16rFFAFEEEE;
		at: #paleVioletRed put: 16rFFDB7093;
		at: #papayaWhip put: 16rFFFFEFD5;
		at: #peachPuff put: 16rFFFFDAB9;
		at: #peru put: 16rFFCD853F;
		at: #pink put: 16rFFFFC0CB;
		at: #plum put: 16rFFDDA0DD;
		at: #powderBlue put: 16rFFB0E0E6;
		at: #purple put: 16rFF800080;
		at: #red put: 16rFFFF0000;
		at: #rosyBrown put: 16rFFBC8F8F;
		at: #royalBlue put: 16rFF4169E1;
		at: #saddleBrown put: 16rFF8B4513;
		at: #salmon put: 16rFFFA8072;
		at: #sandyBrown put: 16rFFF4A460;
		at: #seaGreen put: 16rFF2E8B57;
		at: #seaShell put: 16rFFFFF5EE;
		at: #sienna put: 16rFFA0522D;
		at: #silver put: 16rFFC0C0C0;
		at: #skyBlue put: 16rFF87CEEB;
		at: #slateBlue put: 16rFF6A5ACD;
		at: #slateGray put: 16rFF708090;
		at: #snow put: 16rFFFFFAFA;
		at: #springGreen put: 16rFF00FF7F;
		at: #steelBlue put: 16rFF4682B4;
		at: #tan put: 16rFFD2B48C;
		at: #teal put: 16rFF008080;
		at: #thistle put: 16rFFD8BFD8;
		at: #tomato put: 16rFFFF6347;
		at: #transparent put: 16r00FFFFFF;
		at: #turquoise put: 16rFF40E0D0;
		at: #violet put: 16rFFEE82EE;
		at: #wheat put: 16rFFF5DEB3;
		at: #white put: 16rFFFFFFFF;
		at: #whiteSmoke put: 16rFFF5F5F5;
		at: #yellow put: 16rFFFFFF00;
		at: #yellowGreen put: 16rFF9ACD32;
		yourself.
	stdColours := stdColours collect: 
					[:each |
					(self fromInteger: each)
						isImmutable: true;
						yourself].
	self addClassConstant: 'StdColours'
		value: (stdColours
				shrink;
				isImmutable: true;
				yourself).
	self addClassConstant: 'DefaultA'
		value: (self
				alpha: 200
				red: 200
				green: 200
				blue: 201)!

named: aSymbol
	"Answer an instance whose name is aSymbol."

	^StdColours at: aSymbol!

none
	^self fromInteger: 16r00FFFFFF!

r: redInteger g: greenInteger b: blueInteger
	"Answer a fully opaque instance whose red, green and blue components are specified as the
	arguments, which are expected to be in the range 0..255."

	^self
		a: 255
		r: redInteger
		g: greenInteger
		b: blueInteger!

red: redValue green: greenValue blue: blueValue
	"Answer a fully opaque instance whose red, green and blue components are specified as the
	arguments, which are clamped to the range 0..255."

	^self
		alpha: 255
		red: redValue
		green: greenValue
		blue: blueValue!

stdColor: aSymbol
	Notification deprecated.
	^self named: aSymbol!

stdColourTable
	^StdColours! !
!ARGB class categoriesFor: #a:r:g:b:!instance creation!public! !
!ARGB class categoriesFor: #alpha:red:green:blue:!instance creation!public! !
!ARGB class categoriesFor: #default!instance creation!public! !
!ARGB class categoriesFor: #fromArray:!instance creation!public! !
!ARGB class categoriesFor: #fromInteger:!instance creation!public! !
!ARGB class categoriesFor: #fromNormalizedArray:!instance creation!public! !
!ARGB class categoriesFor: #green!instance creation!public! !
!ARGB class categoriesFor: #initialize!initializing!public! !
!ARGB class categoriesFor: #named:!instance creation!public! !
!ARGB class categoriesFor: #none!instance creation!public! !
!ARGB class categoriesFor: #r:g:b:!instance creation!public! !
!ARGB class categoriesFor: #red:green:blue:!instance creation!public! !
!ARGB class categoriesFor: #stdColor:!instance creation!public! !
!ARGB class categoriesFor: #stdColourTable!helpers!public! !

