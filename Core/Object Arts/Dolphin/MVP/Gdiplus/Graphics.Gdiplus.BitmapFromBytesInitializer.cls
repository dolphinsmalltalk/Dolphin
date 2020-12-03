"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FromBytesInitializer subclass: #'Graphics.Gdiplus.BitmapFromBytesInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromBytesInitializer guid: (Core.GUID fromString: '{6e7e335e-9dd7-44fa-8648-96e7d9528f11}')!
Graphics.Gdiplus.BitmapFromBytesInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromBytesInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.BitmapFromBytesInitializer methodsFor!

createHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle status stm |
	gpHandle := Handle new.
	stm := self iStream.
	status := self library gdipCreateBitmapFromStream: stm bitmap: gpHandle.
	stm free.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!Graphics.Gdiplus.BitmapFromBytesInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.BitmapFromBytesInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

