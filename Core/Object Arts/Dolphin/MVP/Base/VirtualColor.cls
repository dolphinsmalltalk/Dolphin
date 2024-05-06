"Filed out from Dolphin Smalltalk"!

Color subclass: #VirtualColor
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

VirtualColor guid: (GUID fromString: '{aa0eebfb-75db-4ed8-a11f-55ac6b62948e}')!

VirtualColor isAbstract: true!

VirtualColor comment: '`VirtualColor` is the abstract class of `Color`s with an indirectly stored or calculated color value that can vary at run time.'!

!VirtualColor categoriesForClass!Drawing! !

!VirtualColor methodsFor!

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

rgbCode
	"Answer the receiver's color value in 24-bit RGB encoding with 8-bits per component in (blue, green, red) order."

	^self actualColor rgbCode! !

!VirtualColor categoriesForMethods!
argbCode!converting!public! !
asParameter!converting!public! !
asRGB!converting!public! !
isDefault!public!testing! !
isNone!public!testing! !
rgbCode!converting!public! !
!

