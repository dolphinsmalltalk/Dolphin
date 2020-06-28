"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusPathGradientFromPointsInitializer
	instanceVariableNames: 'pathPoints wrapMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!GdiplusPathGradientFromPointsInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusPathGradientFromPointsInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusPathGradientFromPointsInitializer categoriesFor: #points:wrapMode:!initializing!private! !

!GdiplusPathGradientFromPointsInitializer class methodsFor!

points: points wrapMode: aWrapModeConstant
	^self new points: points wrapMode: aWrapModeConstant! !
!GdiplusPathGradientFromPointsInitializer class categoriesFor: #points:wrapMode:!instance creation!public! !

