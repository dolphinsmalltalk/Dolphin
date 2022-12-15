"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBrush subclass: #'Graphics.Gdiplus.LinearGradientBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrush guid: (Core.GUID fromString: '{0ea671c7-823f-4367-89b3-c28e45a365ea}')!
Graphics.Gdiplus.LinearGradientBrush comment: 'GdiplusLinearGradientBrush paints a color gradient in which the color changes evenly from the starting boundary line of an instance to its ending boundary line. Boundary lines are two parallel straight lines. The color gradient is perpendicular to the boundary lines, changing gradually across the stroke from starting to ending boundary lines. The color gradient has one color at the starting boundary line and another color at the ending boundary line.'!
!Graphics.Gdiplus.LinearGradientBrush methodsFor!

colors
	^{self startingColor. self endingColor}!

colors: aPair
	self startingColor: aPair first endingColor: aPair second!

endingColor
	^initializer color2!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^LinearGradientBrushInitializer!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity.
	For a gradient brush we approximate based on the the mid-point colour, although this may be very inaccurate if the blend is customised."

	^(self startingColor luminance + self endingColor luminance) / 2.0!

mode
	^initializer mode!

startingColor
	^initializer color1!

startingColor: startColor endingColor: endColor
	"Set the receiver's starting and ending colors."

	initializer
		colorsSet: self asParameter
		start: endColor
		end: startColor! !
!Graphics.Gdiplus.LinearGradientBrush categoriesForMethods!
colors!accessing!public! !
colors:!accessing!public! !
endingColor!accessing!public! !
initializerClass!constants!private! !
luminance!accessing!public! !
mode!accessing!public! !
startingColor!accessing!public! !
startingColor:endingColor:!accessing!public! !
!

!Graphics.Gdiplus.LinearGradientBrush class methodsFor!

newPoint1: point1 point2: point2 color1: color1 color2: color2 wrapMode: aWrapModeConstant
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	| rect extent mode |
	rect := point1 corner: point2.
	extent := rect extent.
	extent x = 0
		ifTrue: 
			[mode := LinearGradientModeVertical.
			extent := extent y.
			rect := ((point1 x - extent) // 2) @ point1 y extent: extent @ extent]
		ifFalse: 
			[extent y = 0
				ifTrue: 
					[extent := extent x.
					rect := point1 x @ ((point1 y - extent) // 2) extent: extent @ extent]
				ifFalse: [#todo	"Implement for x and y extents"]].
	^self
		rect: rect
		color1: color1
		color2: color2
		mode: mode
		wrapMode: aWrapModeConstant!

point1: point1 point2: point2 color1: color1 color2: color2
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self
		point1: point1
		point2: point2
		color1: color1
		color2: color2
		wrapMode: WrapModeTile!

point1: point1 point2: point2 color1: color1 color2: color2 wrapMode: aWrapModeConstant
	"Answer a LinearGradientBrush using a set of boundary points and boundary colors."

	^self fromInitializer: (LinearGradientBrushFromPointsInitializer
				point1: point1
				point2: point2
				color1: color1
				color2: color2
				wrapMode: aWrapModeConstant)!

rect: aRectangle color1: aColor1 color2: aColor2 mode: aLinearGradientMode
	"Answer a LinearGradientBrush using a set of boundary points specified by a Rectangle, and boundary colors."

	^self fromInitializer: (LinearGradientBrushFromRectInitializer
				rect: aRectangle
				color1: aColor1
				color2: aColor2
				mode: aLinearGradientMode)!

rect: aRectangle color1: aColor1 color2: aColor2 mode: aLinearGradientMode wrapMode: aWrapModeConstant
	"Answer a LinearGradientBrush using a set of boundary points specified by a Rectangle, and boundary colors."

	^(self fromInitializer: (LinearGradientBrushFromRectInitializer
				rect: aRectangle
				color1: aColor1
				color2: aColor2
				mode: aLinearGradientMode))
		wrapMode: aWrapModeConstant;
		yourself! !
!Graphics.Gdiplus.LinearGradientBrush class categoriesForMethods!
newPoint1:point2:color1:color2:wrapMode:!instance creation!public! !
point1:point2:color1:color2:!instance creation!public! !
point1:point2:color1:color2:wrapMode:!instance creation!public! !
rect:color1:color2:mode:!instance creation!public! !
rect:color1:color2:mode:wrapMode:!instance creation!public! !
!

