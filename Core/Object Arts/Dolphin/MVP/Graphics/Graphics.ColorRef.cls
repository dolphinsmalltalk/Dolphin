"Filed out from Dolphin Smalltalk"!

Graphics.AbstractRGB
	subclass: #'Graphics.ColorRef'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ColorRef guid: (Core.GUID fromString: '{ed5fcdeb-52e8-4a5c-9eb7-38bf3a3aa575}')!
Graphics.ColorRef isNonInstantiable: true!
Graphics.ColorRef comment: '`ColorRef` is the abstract class of palette independent (absolute) color values used with most Win32 GDI APIs that have a specific integer encoding described in the Windows documentation as a COLORREF.

## Instance Variables:
  `code`		`<integer>`; a Windows `COLORREF` value. e.g. an `RGB` value.

'!
!Graphics.ColorRef methodsFor!

asColorRef
	"Answer the receiver as a <ColorRef> (an <RGB> or one of the standard pseudo-colour constants Color default and Color none)"

	^self!

asCOLORREF
	"Answer the receiver's 32-bit <integer> COLORREF encoding. This is basically an BGR encoding, but the high bits (that would be used for an alpha value in an ARGB) are used for some special values, either
	to indicate indexed colours, or for Color none and Color default."

	^code!

errorNotARealColor
	"Private - Raise an error to the effect that the receiver does not represent a real colour
	value, and cannot therefore be converted to another type of <Color>."

	^self error: 'Cannot convert to an RGB'! !
!Graphics.ColorRef categoriesForMethods!
asColorRef!converting!public! !
asCOLORREF!accessing!public! !
errorNotARealColor!exceptions!private! !
!

!Graphics.ColorRef class methodsFor!

defaultColorRepresentation
	"Private - Answer a unique colour that we can use to represent (Color default). This is used in the ColorDialog to allow users to
	explicitly choose the default colour from a swatch"

	^self 
		r: 200
		g: 200
		b: 201!

fromCOLORREF: anInteger
	"Private - Answer an instance with the specified colorref code value."

	^Win32Constants.CLR_NONE = anInteger
		ifTrue: [None]
		ifFalse: [Win32Constants.CLR_DEFAULT = anInteger ifTrue: [Default] ifFalse: [self rgbClass fromRgbCode: anInteger]]!

stbReadFrom: anSTBInFiler format: anSTBClassConversion size: anInteger
	"Read a sub-instance of the receiver from the binary filer, aSTBInFiler."

	"Implementation Note: Overridden in order to maintain unique instances without using a proxy"

	| answer ref |
	ref := anSTBInFiler register: nil.
	answer := self fromCOLORREF: anSTBInFiler basicNext.
	anSTBInFiler fixup: ref to: answer.
	^answer! !
!Graphics.ColorRef class categoriesForMethods!
defaultColorRepresentation!constants!private! !
fromCOLORREF:!instance creation!private! !
stbReadFrom:format:size:!binary filing!public! !
!

