"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusPathGradientFromPointsInitializer
	instanceVariableNames: 'pathPoints wrapMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusPathGradientFromPointsInitializer guid: (GUID fromString: '{8f2007e1-7d6c-11d7-b609-00e0987e8081}')!

GdiplusPathGradientFromPointsInitializer comment: ''!

!GdiplusPathGradientFromPointsInitializer categoriesForClass!Unclassified! !

!GdiplusPathGradientFromPointsInitializer methodsFor!

createHandle
	| gpHandle points |
	gpHandle := ExternalHandle new.
	points := POINTLArray marshal: pathPoints.
	self library
		gdipCreatePathGradientI: points
		count: pathPoints size
		wrapMode: wrapMode
		polyGradient: gpHandle.
	^gpHandle!

points: points wrapMode: aWrapModeConstant
	pathPoints := points.
	wrapMode := aWrapModeConstant! !

!GdiplusPathGradientFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
points:wrapMode:!initializing!private! !
!

!GdiplusPathGradientFromPointsInitializer class methodsFor!

points: points wrapMode: aWrapModeConstant
	^self new points: points wrapMode: aWrapModeConstant! !

!GdiplusPathGradientFromPointsInitializer class categoriesForMethods!
points:wrapMode:!instance creation!public! !
!

