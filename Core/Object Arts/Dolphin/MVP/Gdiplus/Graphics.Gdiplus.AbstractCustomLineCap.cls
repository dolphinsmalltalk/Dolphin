"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.AbstractCustomLineCap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.AbstractCustomLineCap guid: (Core.GUID fromString: '{024a0681-d554-4d57-a149-592647711f27}')!
Graphics.Gdiplus.AbstractCustomLineCap isNonInstantiable: true!
Graphics.Gdiplus.AbstractCustomLineCap comment: ''!
!Graphics.Gdiplus.AbstractCustomLineCap methodsFor!

strokeJoin
	"Answer the style of line join (how intersecting lines are joined) for the stroke."

	^self initializer strokeJoin!

strokeJoin: aLineJoinConstant
	"Set the style of line join (how intersecting lines are joined) for the stroke."

	"This has no effect on filled AdjustableArrowCaps, although can affect the point of the arrow when unfilled."

	initializer strokeJoinOf: self set: aLineJoinConstant!

widthScale
	"Answer the amount to scale the receiver relative to the width of the GdiplusPen used to draw lines."

	^self initializer widthScale!

widthScale: aNumber
	"Set the amount to scale the receiver relative to the width of the GdiplusPen used to 
	draw lines. The default value of 1.0 does not scale the line cap."

	initializer widthScaleOf: self set: aNumber! !
!Graphics.Gdiplus.AbstractCustomLineCap categoriesForMethods!
strokeJoin!accessing!public! !
strokeJoin:!accessing!public! !
widthScale!accessing!public! !
widthScale:!accessing!public! !
!

