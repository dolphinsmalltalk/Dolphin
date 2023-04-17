"Filed out from Dolphin Smalltalk"!

Graphics.VirtualColor
	subclass: #'Graphics.ColorAlpha'
	instanceVariableNames: 'color alpha'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.ColorAlpha guid: (Core.GUID fromString: '{b850bd0f-5791-45ef-bb42-13dbd39a77d2}')!
Graphics.ColorAlpha comment: '`ColorAlpha` is a `Color` that can decorate symbolic colours (e,.g. `SystemColor`s) with alpha (translucency), but preserving the original symbolic colour until the point where an RGBA or ARGB code is actually needed.'!
!Graphics.ColorAlpha categoriesForClass!Drawing! !
!Graphics.ColorAlpha methodsFor!

actualColor
	^color asRGB alpha: color alpha * alpha // 255!

alpha
	^alpha!

alpha: anAlphaInteger
	"Answer a `Color` which has the same red, green and blue components as the receiver, but with the <integer> alpha, anAlphaInteger.
	The alpha component is expected to be in the range [0,255], but is clamped to that if not."

	^ColorAlpha color: color alpha: alpha * (anAlphaInteger clampBetween: 0 and: 255) // 255!

isOpaque
	"Answer whether this <Color> is completely opaque."

	^alpha == 255!

normalizedAlpha
	"Answer the receiver's alpha component as a <Number> in the range [0,1], with 0 being completely transparent and 1 completely opaque."

	^self alpha / 255!

printOn: aStream
	aStream
		nextPut: $(;
		print: color;
		nextPutAll: ' alpha: ';
		print: alpha;
		nextPut: $)!

setColor: aColor alpha: anInteger
	color := aColor.
	alpha := anInteger! !
!Graphics.ColorAlpha categoriesForMethods!
actualColor!accessing!public! !
alpha!accessing!public! !
alpha:!accessing!public! !
isOpaque!public!testing! !
normalizedAlpha!accessing!public! !
printOn:!accessing!public! !
setColor:alpha:!initializing!private! !
!

!Graphics.ColorAlpha class methodsFor!

color: aColor alpha: anInteger
	| alpha |
	alpha := anInteger clampBetween: 0 and: 255.
	^alpha == 255 ifTrue: [aColor] ifFalse: [self newColor: aColor alpha: anInteger]!

newColor: aColor alpha: anInteger
	<primitive: 157>
	^self basicNew setColor: aColor alpha: anInteger! !
!Graphics.ColorAlpha class categoriesForMethods!
color:alpha:!instance creation!public! !
newColor:alpha:!instance creation!private! !
!

