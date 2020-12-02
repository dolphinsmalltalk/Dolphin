"Filed out from Dolphin Smalltalk 7"!

GdiplusBase subclass: #GdiplusCachedBitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusCachedBitmap guid: (GUID fromString: '{28e34ab0-3f39-40a2-9e59-af891814c197}')!
GdiplusCachedBitmap comment: 'GdiplusCachedBitmap stores a bitmap in a format that is optimized for display on a particular device. To display an instance, call the GdiplusGraphics>>drawCachedBitmap method.

'!
!GdiplusCachedBitmap categoriesForClass!Unclassified! !
!GdiplusCachedBitmap methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteCachedBitmap: handle! !
!GdiplusCachedBitmap categoriesFor: #basicFree!private!realizing/unrealizing! !

!GdiplusCachedBitmap class methodsFor!

bitmap: aBitmap graphics: aGraphics
	"Answer an instance of the receiver that is based on aBitmap and aGraphics objects."

	^self 
		fromInitializer: (GdiplusCachedBitmapInitializer bitmap: aBitmap graphics: aGraphics)!

exampleGdipCBPerformance
	"MSDN: Using GDI+ > Using Images, Bitmaps, and Metafiles > Using a Cached Bitmap to Improve Performance
	This example creates an image from file and a cached bitmap from the image.  It draws 
	each a number of times, then shows the elapsed times.

		RichTextPresenter showOn: self exampleGdipCBPerformance
	"

	| bitmap graphics image cachedBitmap strm time1 time2 |
	bitmap := GdiplusBitmap new.
	graphics := bitmap graphics.
	image := GdiplusImage fromFile: 'Resources/Beach Ball.bmp' usingLocator: FileLocator installRelative.
	cachedBitmap := GdiplusCachedBitmap bitmap: image graphics: graphics.
	strm := String smalltalkWriteStream.
	strm
		display: 'CachedBitmap drawing time';
		cr.
	time1 := [100 timesRepeat: [graphics drawImage: image at: 10 @ 10]] timeToRun.
	strm display: '#drawImage: '.
	time1 displayOn: strm.
	strm cr.
	time2 := [100 timesRepeat: [graphics drawCachedBitmap: cachedBitmap at: 10 @ 200]] timeToRun.
	strm display: '#drawCachedBitmap: '.
	time2 displayOn: strm.
	^strm contents!

icon
	"Answers an Icon that can be used to represent this class"

	^Bitmap icon! !
!GdiplusCachedBitmap class categoriesFor: #bitmap:graphics:!instance creation!public! !
!GdiplusCachedBitmap class categoriesFor: #exampleGdipCBPerformance!examples!public!sunit! !
!GdiplusCachedBitmap class categoriesFor: #icon!constants!development!public! !

