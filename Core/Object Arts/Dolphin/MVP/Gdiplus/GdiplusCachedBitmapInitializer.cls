"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusCachedBitmapInitializer
	instanceVariableNames: 'bitmap graphics'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusCachedBitmapInitializer guid: (GUID fromString: '{615de21c-61b0-11d7-b609-00e0987e8081}')!

GdiplusCachedBitmapInitializer comment: ''!

!GdiplusCachedBitmapInitializer categoriesForClass!Unclassified! !

!GdiplusCachedBitmapInitializer methodsFor!

bitmap: aBitmap graphics: aGraphics
	bitmap := aBitmap.
	graphics := aGraphics!

createHandle
	| gpHandle |
	gpHandle := ExternalHandle new.
	self library
		gdipCreateCachedBitmap: bitmap asParameter
		graphics: graphics asParameter
		cachedBitmap: gpHandle.
	^gpHandle! !

!GdiplusCachedBitmapInitializer categoriesForMethods!
bitmap:graphics:!initializing!private! !
createHandle!private!realizing/unrealizing! !
!

!GdiplusCachedBitmapInitializer class methodsFor!

bitmap: aBitmap graphics: aGraphics
	^self new bitmap: aBitmap graphics: aGraphics! !

!GdiplusCachedBitmapInitializer class categoriesForMethods!
bitmap:graphics:!instance creation!public! !
!

