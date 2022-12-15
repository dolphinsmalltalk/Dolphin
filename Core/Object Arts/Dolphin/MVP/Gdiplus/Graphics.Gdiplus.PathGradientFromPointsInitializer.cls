"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.PathGradientBrushInitializer subclass: #'Graphics.Gdiplus.PathGradientFromPointsInitializer'
	instanceVariableNames: 'points'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientFromPointsInitializer guid: (Core.GUID fromString: '{8f2007e1-7d6c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathGradientFromPointsInitializer comment: ''!
!Graphics.Gdiplus.PathGradientFromPointsInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self == anObject or: [super = anObject and: [points = anObject points]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreatePathGradientI: points
		count: points size
		wrapMode: wrapMode
		polyGradient: gpHandle.
	^gpHandle!

defaultCenterColor
	^Color.Black!

hash
	"Answer the <integer> hash value for the receiver."

	^(super hash + points hash) hashMultiply!

path
	^points size > 2
		ifTrue: [GraphicsPath polygon: points]
		ifFalse: 
			[GraphicsPath points: points types: (ByteArray new: points size withAll: PathPointTypeLine)]!

points
	^points!

points: aSequenceOfPoints wrapMode: aWrapModeConstant
	points := POINTLArray marshal: aSequenceOfPoints.
	wrapMode := aWrapModeConstant.
	centerColor := self defaultCenterColor.
	^self!

printAttributesOn: aStream
	aStream
		nextPutAll: #points:;
		space;
		print: points asArray.
	super printAttributesOn: aStream! !
!Graphics.Gdiplus.PathGradientFromPointsInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
defaultCenterColor!constants!private! !
hash!comparing!public! !
path!accessing!private! !
points!accessing!private! !
points:wrapMode:!initializing!private! !
printAttributesOn:!printing!private! !
!

!Graphics.Gdiplus.PathGradientFromPointsInitializer class methodsFor!

stbConvertFrom: anSTBClassFormat
	^[:data | self points: (data at: 2) wrapMode: (data at: 3)]! !
!Graphics.Gdiplus.PathGradientFromPointsInitializer class categoriesForMethods!
stbConvertFrom:!binary filing!public! !
!

