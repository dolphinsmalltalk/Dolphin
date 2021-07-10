"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PathGradientFromPointsInitializer'
	instanceVariableNames: 'pathPoints wrapMode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathGradientFromPointsInitializer guid: (Core.GUID fromString: '{8f2007e1-7d6c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathGradientFromPointsInitializer comment: ''!
!Graphics.Gdiplus.PathGradientFromPointsInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PathGradientFromPointsInitializer methodsFor!

createHandle
	| gpHandle points |
	gpHandle := Handle new.
	points := StructureArray
				withAll: pathPoints
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	points beUnfinalizable.
	self library
		gdipCreatePathGradientI: points
		count: pathPoints size
		wrapMode: wrapMode
		polyGradient: gpHandle.
	^gpHandle!

points: points wrapMode: aWrapModeConstant
	pathPoints := points.
	wrapMode := aWrapModeConstant! !
!Graphics.Gdiplus.PathGradientFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
points:wrapMode:!initializing!private! !
!

!Graphics.Gdiplus.PathGradientFromPointsInitializer class methodsFor!

points: points wrapMode: aWrapModeConstant
	^self new points: points wrapMode: aWrapModeConstant! !
!Graphics.Gdiplus.PathGradientFromPointsInitializer class categoriesForMethods!
points:wrapMode:!instance creation!public! !
!

