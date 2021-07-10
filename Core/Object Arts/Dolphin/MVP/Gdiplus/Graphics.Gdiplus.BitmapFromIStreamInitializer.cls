"Filed out from Dolphin Smalltalk"!

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
!Graphics.Gdiplus.BitmapFromIStreamInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
isPersistent!public!testing! !
iStream:!initializing!private! !
!

!Graphics.Gdiplus.BitmapFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!Graphics.Gdiplus.BitmapFromIStreamInitializer class categoriesForMethods!
iStream:!instance creation!public! !
!

