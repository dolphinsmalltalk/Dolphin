"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusGraphicsPathFromPointsInitializer
	instanceVariableNames: 'pathPoints pathTypes fillMode'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusGraphicsPathFromPointsInitializer guid: (GUID fromString: '{FCEF1A11-834C-11D7-B609-00E0987E8081}')!
GdiplusGraphicsPathFromPointsInitializer comment: ''!
!GdiplusGraphicsPathFromPointsInitializer categoriesForClass!Unclassified! !
!GdiplusGraphicsPathFromPointsInitializer methodsFor!

createHandle
	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library 
				gdipCreatePath2I: (StructureArray withAll: (pathPoints collect: [:e | POINTL fromPoint: e])
						elementClass: POINTL)
				types: (ByteArray withAll: pathTypes)
				count: pathPoints size
				fillMode: fillMode
				path: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating GraphicsPath'!

points: points types: types fillMode: aFillModeConstant 
	pathPoints := points.
	pathTypes := types.
	fillMode := aFillModeConstant! !
!GdiplusGraphicsPathFromPointsInitializer categoriesFor: #createHandle!public! !
!GdiplusGraphicsPathFromPointsInitializer categoriesFor: #gdiplusConstructorErrorDescription!public! !
!GdiplusGraphicsPathFromPointsInitializer categoriesFor: #points:types:fillMode:!public! !

!GdiplusGraphicsPathFromPointsInitializer class methodsFor!

points: points types: types fillMode: aFillModeConstant 
	^self new 
		points: points
		types: types
		fillMode: aFillModeConstant! !
!GdiplusGraphicsPathFromPointsInitializer class categoriesFor: #points:types:fillMode:!public! !

