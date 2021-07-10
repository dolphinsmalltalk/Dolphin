"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.PathFromPointsInitializer'
	instanceVariableNames: 'pathPoints pathTypes fillMode'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.PathFromPointsInitializer guid: (Core.GUID fromString: '{fcef1a11-834c-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.PathFromPointsInitializer comment: ''!
!Graphics.Gdiplus.PathFromPointsInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.PathFromPointsInitializer methodsFor!

createHandle
	| gpHandle points |
	gpHandle := Handle new.
	points := StructureArray
				withAll: pathPoints
				elementClass: POINTL
				initializer: [:pointl :point | pointl x: point x y: point y].
	points beUnfinalizable.
	self library
		gdipCreatePath2I: points
		types: pathTypes
		count: pathPoints size
		fillMode: fillMode
		path: gpHandle.
	^gpHandle!

points: points types: types fillMode: aFillModeConstant 
	pathPoints := points.
	pathTypes := types asByteArray.
	fillMode := aFillModeConstant! !
!Graphics.Gdiplus.PathFromPointsInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
points:types:fillMode:!initializing!private! !
!

!Graphics.Gdiplus.PathFromPointsInitializer class methodsFor!

points: points types: types fillMode: aFillModeConstant 
	^self new 
		points: points
		types: types
		fillMode: aFillModeConstant! !
!Graphics.Gdiplus.PathFromPointsInitializer class categoriesForMethods!
points:types:fillMode:!public! !
!

