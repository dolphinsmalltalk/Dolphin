"Filed out from Dolphin Smalltalk"!

Graphics.Color subclass: #'Graphics.VirtualColor'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.VirtualColor guid: (Core.GUID fromString: '{aa0eebfb-75db-4ed8-a11f-55ac6b62948e}')!
Graphics.VirtualColor isNonInstantiable: true!
Graphics.VirtualColor comment: '`VirtualColor` is the abstract class of `Color`s with an indirectly stored or calculated color value that can vary at run time.'!
!Graphics.VirtualColor categoriesForClass!Drawing! !
!Graphics.VirtualColor methodsFor!

actualColor
	^self subclassResponsibility!

alpha
	"Answer the receiver's alpha component (a SmallInteger in the range 0..255). This specifies
	the opacity of the colour, with 0 being completely transparent and 255 completely opaque."

	^self actualColor alpha!

argbCode
	"Answer the receiver's colour value in 32-bit ARGB encoding with 8-bits per component in alpha, red, green, blue order."

	^self actualColor argbCode!

asParameter
	"It is recommended not to use this conversion, as the result will vary depending on the colour encoding, and so may not work if the encoding is not that expected by the API being called. Rather you should use (for example) #rgbCode or #argbCode."

	^self actualColor asParameter!

asRGB
	"Answer the receiver as an RGB"

	^self actualColor asRGB!

isDefault
	"Answer whether the <Color> to which the receiver resolves is 'Color default'"

	^self actualColor isDefault!

isNone
	"Answer whether the <Color> to which the receiver resolves is 'Color none'"

	^self actualColor isNone!

isSymbolic
	"Answer whether the receiver is the symbolic <Color> that does not correspond to a fixed RGB(A) value."

	^true!

rgbaCode
	"Answer the receiver's colour value in 32-bit RGBA encoding (or ABGR if you prefer), i.e. red | (green << 8) | (blue << 16) | (alpha << 24)."

	^self actualColor rgbaCode!

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^self actualColor rgbCode! !
!Graphics.VirtualColor categoriesForMethods!
actualColor!accessing!private! !
alpha!accessing!public! !
argbCode!converting!public! !
asParameter!converting!public! !
asRGB!converting!public! !
isDefault!public!testing! !
isNone!public!testing! !
isSymbolic!public!testing! !
rgbaCode!accessing!public! !
rgbCode!converting!public! !
!

!Graphics.VirtualColor class methodsFor!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Override back to default implementation"

	^anSTBInFiler
		readObjectOfClass: self
		format: anSTBClassConversion
		size: anInteger! !
!Graphics.VirtualColor class categoriesForMethods!
stbReadFrom:format:size:!binary filing!public! !
!

