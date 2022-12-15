"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BitmapInitializer subclass: #'Graphics.Gdiplus.BitmapFromGdiBitmapInitializer'
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromGdiBitmapInitializer guid: (Core.GUID fromString: '{72187357-d718-4876-aaea-2cfefd2c5fd7}')!
Graphics.Gdiplus.BitmapFromGdiBitmapInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer methodsFor!

= anObject
	^self == anObject or: [self species = anObject species and: [bitmap = anObject bitmap]]!

basicCreateHandle
	"Private -  Bitmap::Bitmap(
	    IN HBITMAP hbm, 
	    IN HPALETTE hpal
	    )
	{
	    GpBitmap *bitmap = NULL;

	    lastResult = DllExports::GdipCreateBitmapFromHBITMAP(hbm, hpal, &bitmap);"

	| gpHandle hPalette |
	gpHandle := Handle new.
	hPalette := bitmap createPalette.

	"MSDN: Do not pass to the GDI+ Bitmap constructor a GDI bitmap or a GDI palette
	that is currently (or was previously) selected into a device context."

	"SW: This handles 'currently' ,,, but what about 'or was previously' ???"
	bitmap freeDC.
	Gdip
		gdipCreateBitmapFromHBITMAP: bitmap asParameter
		hpal: hPalette
		bitmap: gpHandle.
	^gpHandle!

bitmap
	^bitmap!

bitmap: aBitmap
	bitmap := aBitmap.
	^self!

hash
	^(self species hash + bitmap hash) hashMultiply!

printImage: aGdiplusBitmap on: aWriteStream
	aWriteStream
		nextPut: $(;
		print: aGdiplusBitmap class;
		nextPutAll: ' bitmap: ';
		print: bitmap;
		nextPut: $)! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
bitmap!accessing!private! !
bitmap:!initializing!private! !
hash!comparing!public! !
printImage:on:!printing!public! !
!

!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer class methodsFor!

bitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Windows Microsoft® Windows® 
	Graphics Device Interface (GDI) bitmap and a handle to a GDI palette."

	"SW: Would there be any need to allow the user to supply the HPALETTE ?"

	^self new bitmap: aBitmap! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer class categoriesForMethods!
bitmap:!instance creation!public! !
!

