"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.CachedBitmap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.CachedBitmap guid: (Core.GUID fromString: '{28e34ab0-3f39-40a2-9e59-af891814c197}')!

Graphics.Gdiplus.CachedBitmap comment: 'GdiplusCachedBitmap stores a bitmap in a format that is optimized for display on a particular device. To display an instance, call the GdiplusGraphics>>drawCachedBitmap method.

'!

!Graphics.Gdiplus.CachedBitmap methodsFor!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^CachedBitmapInitializer! !

!Graphics.Gdiplus.CachedBitmap categoriesForMethods!
initializerClass!private!realizing/unrealizing! !
!

!Graphics.Gdiplus.CachedBitmap class methodsFor!

bitmap: aBitmap graphics: aGraphics
	"Answer an instance of the receiver that is based on aBitmap and aGraphics objects."

	^self fromInitializer: (CachedBitmapInitializer bitmap: aBitmap graphics: aGraphics)!

icon
	"Answers an Icon that can be used to represent this class"

	^Bitmap icon! !

!Graphics.Gdiplus.CachedBitmap class categoriesForMethods!
bitmap:graphics:!instance creation!public! !
icon!constants!development!public! !
!

