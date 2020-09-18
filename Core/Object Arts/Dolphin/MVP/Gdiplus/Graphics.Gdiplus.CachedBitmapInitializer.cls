"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.CachedBitmapInitializer'
	instanceVariableNames: 'bitmap graphics'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CachedBitmapInitializer guid: (Core.GUID fromString: '{615de21c-61b0-11d7-b609-00e0987e8081}')!
Graphics.Gdiplus.CachedBitmapInitializer comment: ''!
!Graphics.Gdiplus.CachedBitmapInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.CachedBitmapInitializer methodsFor!

bitmap: aBitmap graphics: aGraphics
	bitmap := aBitmap.
	graphics := aGraphics!

createHandle
	| gpHandle |
	gpHandle := Address new.
	self library
		gdipCreateCachedBitmap: bitmap asParameter
		graphics: graphics asParameter
		cachedBitmap: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.CachedBitmapInitializer categoriesFor: #bitmap:graphics:!initializing!private! !
!Graphics.Gdiplus.CachedBitmapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.CachedBitmapInitializer class methodsFor!

bitmap: aBitmap graphics: aGraphics
	^self new bitmap: aBitmap graphics: aGraphics! !
!Graphics.Gdiplus.CachedBitmapInitializer class categoriesFor: #bitmap:graphics:!instance creation!public! !

