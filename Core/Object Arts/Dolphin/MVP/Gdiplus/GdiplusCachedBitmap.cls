"Filed out from Dolphin Smalltalk"!

GdiplusBase subclass: #GdiplusCachedBitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusCachedBitmap guid: (GUID fromString: '{28e34ab0-3f39-40a2-9e59-af891814c197}')!

GdiplusCachedBitmap comment: 'GdiplusCachedBitmap stores a bitmap in a format that is optimized for display on a particular device. To display an instance, call the GdiplusGraphics>>drawCachedBitmap method.

'!

!GdiplusCachedBitmap categoriesForClass!Unclassified! !

!GdiplusCachedBitmap methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteCachedBitmap: handle! !

!GdiplusCachedBitmap categoriesForMethods!
basicFree!private!realizing/unrealizing! !
!

!GdiplusCachedBitmap class methodsFor!

bitmap: aBitmap graphics: aGraphics
	"Answer an instance of the receiver that is based on aBitmap and aGraphics objects."

	^self 
		fromInitializer: (GdiplusCachedBitmapInitializer bitmap: aBitmap graphics: aGraphics)!

icon
	"Answers an Icon that can be used to represent this class"

	^Bitmap icon! !

!GdiplusCachedBitmap class categoriesForMethods!
bitmap:graphics:!instance creation!public! !
icon!constants!development!public! !
!

