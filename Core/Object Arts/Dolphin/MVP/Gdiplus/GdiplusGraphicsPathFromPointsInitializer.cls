"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusGraphicsPathFromPointsInitializer
	instanceVariableNames: 'pathPoints pathTypes fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusGraphicsPathFromPointsInitializer guid: (GUID fromString: '{fcef1a11-834c-11d7-b609-00e0987e8081}')!

GdiplusGraphicsPathFromPointsInitializer comment: ''!

!GdiplusGraphicsPathFromPointsInitializer categoriesForClass!Unclassified! !

!GdiplusGraphicsPathFromPointsInitializer methodsFor!

createHandle
	| gpHandle status points |
	gpHandle := ExternalHandle new.
	points := StructureArray
				withAll: pathPoints
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	points beUnfinalizable.
	status := self library
				gdipCreatePath2I: points
				types: pathTypes
				count: pathPoints size
				fillMode: fillMode
				path: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating GraphicsPath'!

points: points types: types fillMode: aFillModeConstant 
	pathPoints := points.
	pathTypes := types asByteArray.
	fillMode := aFillModeConstant! !

!GdiplusGraphicsPathFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
gdiplusConstructorErrorDescription!constants!private! !
points:types:fillMode:!initializing!private! !
!

!GdiplusGraphicsPathFromPointsInitializer class methodsFor!

points: points types: types fillMode: aFillModeConstant 
	^self new 
		points: points
		types: types
		fillMode: aFillModeConstant! !

!GdiplusGraphicsPathFromPointsInitializer class categoriesForMethods!
points:types:fillMode:!public! !
!

