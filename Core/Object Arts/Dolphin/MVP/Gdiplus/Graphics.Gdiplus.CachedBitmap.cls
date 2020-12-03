"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.GdiplusBase subclass: #'Graphics.Gdiplus.CachedBitmap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.CachedBitmap guid: (Core.GUID fromString: '{28e34ab0-3f39-40a2-9e59-af891814c197}')!
Graphics.Gdiplus.CachedBitmap comment: 'GdiplusCachedBitmap stores a bitmap in a format that is optimized for display on a particular device. To display an instance, call the GdiplusGraphics>>drawCachedBitmap method.

'!
!Graphics.Gdiplus.CachedBitmap categoriesForClass!Unclassified! !
!Graphics.Gdiplus.CachedBitmap methodsFor!

basicFree
	"Private - Free up external resources held by the receiver.  Ignore any errors which might arise."

	GdiplusLibrary default gdipDeleteCachedBitmap: handle! !
!Graphics.Gdiplus.CachedBitmap categoriesFor: #basicFree!private!realizing/unrealizing! !

!Graphics.Gdiplus.CachedBitmap class methodsFor!

bitmap: aBitmap graphics: aGraphics
	"Answer an instance of the receiver that is based on aBitmap and aGraphics objects."

	^self fromInitializer: (CachedBitmapInitializer bitmap: aBitmap graphics: aGraphics)!

exampleGdipCBPerformance
	"MSDN: Using GDI+ > Using Images, Bitmaps, and Metafiles > Using a Cached Bitmap to Improve Performance
	This example creates an image from file and a cached bitmap from the image.  It draws 
	each a number of times, then shows the elapsed times.

		RichTextPresenter showOn: self exampleGdipCBPerformance
	"

	| bitmap graphics image cachedBitmap strm time1 time2 |
	bitmap := Bitmap new.
	graphics := bitmap graphics.
	image := Image fromFile: 'Resources/Beach Ball.bmp' usingLocator: FileLocator installRelative.
	cachedBitmap := CachedBitmap bitmap: image graphics: graphics.
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
!Graphics.Gdiplus.CachedBitmap class categoriesFor: #bitmap:graphics:!instance creation!public! !
!Graphics.Gdiplus.CachedBitmap class categoriesFor: #exampleGdipCBPerformance!examples!public!sunit! !
!Graphics.Gdiplus.CachedBitmap class categoriesFor: #icon!constants!development!public! !

