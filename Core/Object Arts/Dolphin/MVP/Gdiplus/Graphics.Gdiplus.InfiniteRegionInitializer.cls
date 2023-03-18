"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.RegionInitializer
	subclass: #'Graphics.Gdiplus.InfiniteRegionInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.InfiniteRegionInitializer guid: (Core.GUID fromString: '{730f8107-9456-402d-b146-620e70cb6940}')!
Graphics.Gdiplus.InfiniteRegionInitializer comment: ''!
!Graphics.Gdiplus.InfiniteRegionInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateRegion: gpHandle.
	^gpHandle!

hashGet: aGpRegion
	^924935433!

isEmptyRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	^false!

isInfiniteRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	^true! !
!Graphics.Gdiplus.InfiniteRegionInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
hashGet:!attributes!private! !
isEmptyRegion:onGraphics:!public!testing! !
isInfiniteRegion:onGraphics:!public!testing! !
!

