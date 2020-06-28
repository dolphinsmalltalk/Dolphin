"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusCachedBitmapInitializer
	instanceVariableNames: 'bitmap graphics'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusCachedBitmapInitializer guid: (GUID fromString: '{615de21c-61b0-11d7-b609-00e0987e8081}')!
GdiplusCachedBitmapInitializer comment: ''!
!GdiplusCachedBitmapInitializer categoriesForClass!Unclassified! !
!GdiplusCachedBitmapInitializer methodsFor!

bitmap: aBitmap graphics: aGraphics
	bitmap := aBitmap.
	graphics := aGraphics!

createHandle
	| gpHandle status |
	gpHandle := ExternalAddress new.
	status := self library
				gdipCreateCachedBitmap: bitmap asParameter
				graphics: graphics asParameter
				cachedBitmap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating CachedBitmap'! !
!GdiplusCachedBitmapInitializer categoriesFor: #bitmap:graphics:!initializing!private! !
!GdiplusCachedBitmapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusCachedBitmapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusCachedBitmapInitializer class methodsFor!

bitmap: aBitmap graphics: aGraphics
	^self new bitmap: aBitmap graphics: aGraphics! !
!GdiplusCachedBitmapInitializer class categoriesFor: #bitmap:graphics:!instance creation!public! !

