"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusRegionFromRectangleInitializer
	instanceVariableNames: 'rectangle'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusRegionFromRectangleInitializer guid: (GUID fromString: '{4b87dc0a-0ca6-4f47-93af-ea525ced5f99}')!

GdiplusRegionFromRectangleInitializer comment: ''!

!GdiplusRegionFromRectangleInitializer categoriesForClass!Unclassified! !

!GdiplusRegionFromRectangleInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipCreateRegionRectI: (GpRect marshal: rectangle) region: gpHandle.
	^gpHandle!

rectangle: aRectangle
	rectangle := aRectangle! !

!GdiplusRegionFromRectangleInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
rectangle:!initializing!private! !
!

!GdiplusRegionFromRectangleInitializer class methodsFor!

fromRectangle: aRectangle
	^self new rectangle: aRectangle! !

!GdiplusRegionFromRectangleInitializer class categoriesForMethods!
fromRectangle:!instance creation!public! !
!

