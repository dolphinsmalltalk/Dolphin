"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.RegionInitializer
	subclass: #'Graphics.Gdiplus.EmptyRegionInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.EmptyRegionInitializer guid: (Core.GUID fromString: '{a6a4384f-d90d-43bf-8b9a-6b7e40023754}')!

Graphics.Gdiplus.EmptyRegionInitializer comment: ''!

!Graphics.Gdiplus.EmptyRegionInitializer methodsFor!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCreateRegion: gpHandle;
		gdipSetEmpty: gpHandle.
	^gpHandle!

hashGet: aGpRegion
	^740873194!

isEmptyRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	^true!

isInfiniteRegion: aGdiplusRegion onGraphics: aGdiplusGraphics
	^false! !

!Graphics.Gdiplus.EmptyRegionInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
hashGet:!attributes!private! !
isEmptyRegion:onGraphics:!public!testing! !
isInfiniteRegion:onGraphics:!public!testing! !
!

