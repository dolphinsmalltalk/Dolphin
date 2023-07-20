"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.LinearGradientBrushInitializer
	subclass: #'Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer'
	instanceVariableNames: 'point1 point2'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer guid: (Core.GUID fromString: '{e82f4257-44c1-45f0-8130-6e92d59ab946}')!
Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer comment: ''!
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject
		or: [super = anObject and: [point1 = anObject point1 and: [point2 = anObject point2]]]!

basicCreateHandle
	"Private - LinearGradientBrush(IN const Point& point1,
                        IN const Point& point2,
                        IN const Color& color1,
                        IN const Color& color2)
    {
        GpLineGradient *brush = NULL;

        lastResult = DllExports::GdipCreateLineBrushI(&point1,
                                                      &point2,
                                                      color1.GetValue(),
                                                      color2.GetValue(),
                                                      WrapModeTile,
                                                      &brush);"

	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateLineBrushI: (POINTL marshal: point1)
		point2: (POINTL marshal: point2)
		color1: color1 argbCode
		color2: color2 argbCode
		wrapMode: wrapMode
		lineGradient: gpHandle.
	^gpHandle!

hash
	"Answer the <integer> hash value for the receiver."

	^((super hash + point1 hash) hashMultiply + point2 hash) hashMultiply!

mode
	"Answer the LinearGradientMode of the brushes created by the receiver."

	"There is no API to query the mode, so we must deduce it"

	| rect ext |
	rect := point1 corner: point2.
	ext := rect extent.
	ext y = 0 ifTrue: [^LinearGradientModeHorizontal].
	ext x = 0 ifTrue: [^LinearGradientModeVertical].
	^point1 < point2
		ifTrue: [LinearGradientModeForwardDiagonal]
		ifFalse: [LinearGradientModeBackwardDiagonal]!

point1
	^point1!

point1: aPoint1 point2: aPoint2 color1: startColor color2: endColor wrapMode: aWrapModeConstant
	point1 := aPoint1.
	point2 := aPoint2.
	color1 := startColor.
	color2 := endColor.
	wrapMode := aWrapModeConstant.
	^self!

point2
	^point2!

printAttributesOn: aStream
	aStream
		nextPutAll: 'point1: ';
		print: point1;
		nextPutAll: ' point2: ';
		print: point2;
		nextPutAll: ' color1: ';
		print: color1;
		nextPutAll: ' color2: ';
		print: color2.
	super printAttributesOn: aStream! !
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
hash!comparing!public! !
mode!accessing!public! !
point1!accessing!private! !
point1:point2:color1:color2:wrapMode:!initializing!public! !
point2!accessing!private! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	anSTBClassFormat version == 0
		ifTrue: 
			[^
			[:data |
			self
				point1: (data at: 2)
				point2: (data at: 3)
				color1: (data at: 4)
				color2: (data at: 5)]].
	^super stbConvertFrom: anSTBClassFormat! !
!Graphics.Gdiplus.LinearGradientBrushFromPointsInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
!

