"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.LinearGradientBrushInitializer subclass: #'Graphics.Gdiplus.LinearGradientBrushFromRectInitializer'
	instanceVariableNames: 'rect mode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'LinearGradientModeNames' -> #('LinearGradientModeHorizontal' 'LinearGradientModeVertical' 'LinearGradientModeForwardDiagonal' 'LinearGradientModeBackwardDiagonal')
	}!
Graphics.Gdiplus.LinearGradientBrushFromRectInitializer guid: (Core.GUID fromString: '{e5737bca-1af2-4189-9de4-d6c506a8c20a}')!
Graphics.Gdiplus.LinearGradientBrushFromRectInitializer comment: ''!
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [super = anObject and: [rect = anObject rect and: [mode = anObject mode]]]!

basicCreateHandle
	"Private -  LinearGradientBrush(IN const Rect& rect,
                        IN const Color& color1,
                        IN const Color& color2,
                        IN LinearGradientMode mode)
    {
        GpLineGradient *brush = NULL;

        lastResult = DllExports::GdipCreateLineBrushFromRectI(&rect,
                                                              color1.GetValue(),
                                                              color2.GetValue(),
                                                              mode,
                                                              WrapModeTile,
                                                              &brush);"

	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateLineBrushFromRectI: (Rect marshal: rect)
		color1: color1 argbCode
		color2: color2 argbCode
		mode: mode
		wrapMode: wrapMode
		lineGradient: gpHandle.
	^gpHandle!

hash
	"Answer the <integer> hash value for the receiver."

	^((super hash + mode hash) hashMultiply + rect hash) hashMultiply!

mode
	"Answer the LinearGradientMode of the brushes created by t receiver."

	^mode!

printAttributesOn: aStream
	aStream
		nextPutAll: 'rect: ';
		print: rect;
		nextPutAll: ' color1: ';
		print: color1;
		nextPutAll: ' color2: ';
		print: color2;
		nextPutAll: ' mode: '.
	self
		printEnum: mode
		names: LinearGradientModeNames
		on: aStream.
	super printAttributesOn: aStream!

rect
	^rect!

rect: aRectangle color1: startColor color2: endColor mode: aLinearGradientMode
	rect := aRectangle.
	color1 := startColor.
	color2 := endColor.
	mode := aLinearGradientMode.
	wrapMode := self defaultWrapMode.
	^self! !
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
hash!comparing!public! !
mode!accessing!public! !
printAttributesOn:!printing!private! !
rect!accessing!public! !
rect:color1:color2:mode:!initializing!private! !
!

!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	^
	[:data |
	self
		rect: (data at: 2)
		color1: (data at: 3)
		color2: (data at: 4)
		mode: (data at: 5)]! !
!Graphics.Gdiplus.LinearGradientBrushFromRectInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
!

