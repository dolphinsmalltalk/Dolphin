"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.RegionInitializer subclass: #'Graphics.Gdiplus.RegionFromRectangleInitializer'
	instanceVariableNames: 'rectangle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionFromRectangleInitializer guid: (Core.GUID fromString: '{4b87dc0a-0ca6-4f47-93af-ea525ced5f99}')!
Graphics.Gdiplus.RegionFromRectangleInitializer comment: ''!
!Graphics.Gdiplus.RegionFromRectangleInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateRegionRectI: (Rect marshal: rectangle) region: gpHandle.
	^gpHandle!

printAttributesOn: aStream
	aStream
		nextPutAll: 'fromRectangle: ';
		print: rectangle!

rectangle
	^rectangle!

rectangle: aRectangle
	rectangle := aRectangle! !
!Graphics.Gdiplus.RegionFromRectangleInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
printAttributesOn:!attributes!printing!private! !
rectangle!accessing!public! !
rectangle:!initializing!private! !
!

!Graphics.Gdiplus.RegionFromRectangleInitializer class methodsFor!

fromRectangle: aRectangle
	^self new rectangle: aRectangle! !
!Graphics.Gdiplus.RegionFromRectangleInitializer class categoriesForMethods!
fromRectangle:!instance creation!public! !
!

