"Filed out from Dolphin Smalltalk"!

Graphics.Color
	subclass: #'Graphics.AbstractRGB'
	instanceVariableNames: 'code'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.AbstractRGB guid: (Core.GUID fromString: '{3f709950-6d41-46a2-bf1f-f6092de13e68}')!
Graphics.AbstractRGB isNonInstantiable: true!
Graphics.AbstractRGB comment: '`AbstractColor` is the abstract class of colours specified by individual colour components.

 Concrete subclasses `RGB` represent colours composed of arbitrary proportions of red, green, and blue, and `ARGB` the same but with alpha (translucency).'!
!Graphics.AbstractRGB categoriesForClass!Drawing! !
!Graphics.AbstractRGB methodsFor!

asInteger
	"Answer the encoded <integer> value of the receiver."

	^code!

asParameter
	"Answer the receiver such that it can be used for an API call."

	"It is recommended not to use this conversion, as the result will vary depending on the colour encoding, and so may not work if the encoding is not that expected by the API being called. Rather you should use (for example) #rgbCode or #argbCode."

	^code!

registerName: aSymbol
	(ColorNames includesKey: self) ifFalse: [ColorNames at: self put: aSymbol]!

setCode: anInteger
	"Private - Set the <integer> value of the ColorRef (i.e. that encoded integer value passed to API calls to represent the color)."

	code := anInteger! !
!Graphics.AbstractRGB categoriesForMethods!
asInteger!converting!public! !
asParameter!converting!public! !
registerName:!helpers!private! !
setCode:!accessing!private! !
!

