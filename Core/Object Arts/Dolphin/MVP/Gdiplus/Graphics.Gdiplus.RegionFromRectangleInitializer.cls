"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.RegionFromRectangleInitializer'
	instanceVariableNames: 'rectangle'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionFromRectangleInitializer guid: (Core.GUID fromString: '{4b87dc0a-0ca6-4f47-93af-ea525ced5f99}')!
Graphics.Gdiplus.RegionFromRectangleInitializer comment: ''!
!Graphics.Gdiplus.RegionFromRectangleInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.RegionFromRectangleInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateRegionRectI: rectangle asParameter region: gpHandle.
	^gpHandle!

rectangle: aRectangle
	rectangle := aRectangle! !
!Graphics.Gdiplus.RegionFromRectangleInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.RegionFromRectangleInitializer categoriesFor: #rectangle:!initializing!private! !

!Graphics.Gdiplus.RegionFromRectangleInitializer class methodsFor!

fromRectangle: aRectangle
	^self new rectangle: aRectangle! !
!Graphics.Gdiplus.RegionFromRectangleInitializer class categoriesFor: #fromRectangle:!instance creation!public! !

