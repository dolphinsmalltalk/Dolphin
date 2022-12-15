"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GradientBrush subclass: #'Graphics.Gdiplus.PathGradientBrush'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientBrush guid: (Core.GUID fromString: '{c8f38622-766b-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathGradientBrush comment: 'A path gradient brush paints a color gradient in which the color changes from a center point outward to a boundary that is defined by a closed curve or path. The color gradient has one color at the center point and one or multiple colors at the boundary. '!
!Graphics.Gdiplus.PathGradientBrush methodsFor!

centerColor
	"Answer the <Color> that appears at the receiver's center point."

	^initializer centerColor!

centerColor: aColor
	"Set the <Color> that appears at the receiver's center point."

	initializer centerColor: handle set: aColor!

centerPoint
	"Answer the center <point> of the receiver."

	^initializer centerPointGet: self handle!

centerPoint: aPoint
	"Set the center <point> of the receiver. By default, the center point is at the centroid of the receiver's boundary path, but it can be set to any location inside or outside the path."

	initializer centerPoint: handle set: aPoint!

focusScales
	"Answer a <point> that represents the x and y scale factors for the receiver's center color relative to its boundary path."

	^initializer focusScalesGet: self handle!

focusScales: aPoint
	"Specify that the receiver's center color should appear within the receiver's boundary path scaled by a factor of the <point> argument in the x and y directions."

	initializer focusScales: handle set: aPoint!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^PathGradientBrushInitializer!

luminance
	"Answer a <Number> in the range [0,1] representing the luminance of the receiver, a brightness value weighted by the human eye's color sensitivity.
	For a gradient brush we approximate based on the mid-point colour, although this may be very inaccurate if the path is irregular or the blend customised."

	^self centerColor luminance!

path
	"Answer the <Path> associated with the receiver."

	"The GdipGetPathGradientPath function has never actually been implemented (and probabably never will be). Because of this we are unable to reconstruct a PathGradientBrush from the handle of the native object,
	but we preserve the path in the initializer."

	^self initializer path!

pointCount
	"Private - Answer the number of points that define the receiver's boundary path."

	^initializer pointCountGet: self handle!

surroundColor: aColor
	"Set the specified <Color> as the single color that appears on the receiver's boundary."

	self surroundColors: {aColor}!

surroundColors
	"Answer an <ARGBArray> containing the receiver's boundary colours. This may contain fewer colours than there are points on the path if the trailing points have the same colour."

	^initializer surroundColorsGet: self handle!

surroundColors: aSequenceOfColor
	"Set the colors that appear on the receiver's boundaries. The colours are applied in sequenced to the point's on the receiver's path. If there are insufficient colours, then the final colour is applied to all remaining points. In effect this means that a single colour can be applied to all points by specifying a single-colour sequence."

	initializer surroundColors: self handle set: aSequenceOfColor! !
!Graphics.Gdiplus.PathGradientBrush categoriesForMethods!
centerColor!accessing!public! !
centerColor:!accessing!public! !
centerPoint!accessing!public! !
centerPoint:!accessing!public! !
focusScales!accessing!public! !
focusScales:!accessing!public! !
initializerClass!constants!private! !
luminance!accessing!public! !
path!accessing!public! !
pointCount!accessing!public! !
surroundColor:!accessing!public! !
surroundColors!accessing!public! !
surroundColors:!accessing!public! !
!

!Graphics.Gdiplus.PathGradientBrush class methodsFor!

path: aGraphicsPath
	"Answer an instance of the receiver with boundary specified by the <GraphicsPath> argument, and wrapping-mode, WrapModeClamp."

	^self path: aGraphicsPath wrapMode: WrapModeClamp!

path: aGraphicsPath wrapMode: aWrapModeConstant
	"Answer an instance of the receiver with boundary specified by the <GraphicsPath> 1st argument, and wrapping-mode specified by the <integer> 2nd argument, a member of the WrapMode enumeration."

	^self
		fromInitializer: (PathGradientBrushInitializer path: aGraphicsPath wrapMode: aWrapModeConstant)!

points: points 
	"Answer an instance of the receiver with boundary path specified by points. The brush does not tile."

	^self points: points wrapMode: WrapModeClamp!

points: points wrapMode: aWrapModeConstant
	"Answer an instance of the receiver with boundary path specified by points and 
	wrap mode specified by aWrapModeConstant."

	^self fromInitializer: (PathGradientBrushInitializer points: points wrapMode: aWrapModeConstant)! !
!Graphics.Gdiplus.PathGradientBrush class categoriesForMethods!
path:!instance creation!public! !
path:wrapMode:!instance creation!public! !
points:!instance creation!public! !
points:wrapMode:!instance creation!public! !
!

