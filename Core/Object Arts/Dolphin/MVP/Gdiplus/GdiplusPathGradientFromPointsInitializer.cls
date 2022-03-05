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
	| gpHandle status points |
	gpHandle := ExternalHandle new.
	points := StructureArray
				withAll: pathPoints
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	points beUnfinalizable.
	status := self library
				gdipCreatePathGradientI: points
				count: pathPoints size
				wrapMode: wrapMode
				polyGradient: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating PathGradient'!

points: points wrapMode: aWrapModeConstant
	pathPoints := points.
	wrapMode := aWrapModeConstant! !
!GdiplusPathGradientFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
points:wrapMode:!initializing!private! !
!

!GdiplusPathGradientFromPointsInitializer class methodsFor!

points: points wrapMode: aWrapModeConstant
	^self new points: points wrapMode: aWrapModeConstant! !
!GdiplusPathGradientFromPointsInitializer class categoriesForMethods!
points:wrapMode:!instance creation!public! !
!

