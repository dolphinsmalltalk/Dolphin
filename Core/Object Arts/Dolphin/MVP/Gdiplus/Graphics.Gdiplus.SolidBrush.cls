"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Brush
	subclass: #'Graphics.Gdiplus.SolidBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.SolidBrush guid: (Core.GUID fromString: '{7f8ddb06-89ba-471a-a00c-73f32cbb0af7}')!
Graphics.Gdiplus.SolidBrush comment: 'A solid brush paints a single, constant color that can be opaque or transparent.'!
!Graphics.Gdiplus.SolidBrush methodsFor!

actualColor
	^self color actualColor!

asColor
	^self color!

color
	^initializer color!

color: aColor
	"Change the receiver's colour."

	initializer colorOf: self set: aColor!

evaluationClass
	^Brush!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^SolidBrushFromColorInitializer!

isNone
	"Answer whether the receiver paints nothing (is transparent)."

	^self color isNone!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity. For a SolidBrush this is accurate."

	^self color luminance! !
!Graphics.Gdiplus.SolidBrush categoriesForMethods!
actualColor!accessing!public! !
asColor!converting!public! !
color!accessing!public! !
color:!accessing!public! !
evaluationClass!constants!private! !
initializerClass!constants!private! !
isNone!public!testing! !
luminance!accessing!public! !
!

!Graphics.Gdiplus.SolidBrush class methodsFor!

color: aColor
	"Creates a SolidBrush object based on a color."

	^self fromInitializer: (SolidBrushFromColorInitializer color: aColor)!

new
	^self black! !
!Graphics.Gdiplus.SolidBrush class categoriesForMethods!
color:!instance creation!public! !
new!instance creation!public! !
!

