"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.RegionFromPathInitializer'
	instanceVariableNames: 'path'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.RegionFromPathInitializer guid: (Core.GUID fromString: '{2e7c1bb2-37d2-4d8b-9135-3eb9ab2ed1bb}')!
Graphics.Gdiplus.RegionFromPathInitializer comment: ''!
!Graphics.Gdiplus.RegionFromPathInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.RegionFromPathInitializer methodsFor!

createHandle
	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateRegionPath: path asParameter region: gpHandle.
	^gpHandle!

isPersistent
	^path isPersistent!

path: aPath
	path := aPath! !
!Graphics.Gdiplus.RegionFromPathInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.RegionFromPathInitializer categoriesFor: #isPersistent!public! !
!Graphics.Gdiplus.RegionFromPathInitializer categoriesFor: #path:!initializing!private! !

!Graphics.Gdiplus.RegionFromPathInitializer class methodsFor!

fromPath: aPath
	^self new path: aPath! !
!Graphics.Gdiplus.RegionFromPathInitializer class categoriesFor: #fromPath:!instance creation!public! !

