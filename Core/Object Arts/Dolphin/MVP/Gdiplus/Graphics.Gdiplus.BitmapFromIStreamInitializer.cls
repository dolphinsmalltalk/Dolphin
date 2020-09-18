"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.BitmapFromIStreamInitializer'
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromIStreamInitializer guid: (Core.GUID fromString: '{f3cd9058-7788-4cff-95d9-04dda741ef4e}')!
Graphics.Gdiplus.BitmapFromIStreamInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer methodsFor!

createHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle |
	gpHandle := Handle new.
	self library gdipCreateBitmapFromStream: iStream asParameter bitmap: gpHandle.
	^gpHandle!

isPersistent
	^false!

iStream: pStream
	iStream := pStream! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesFor: #isPersistent!public!testing! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesFor: #iStream:!initializing!private! !

!Graphics.Gdiplus.BitmapFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer class categoriesFor: #iStream:!instance creation!public! !

