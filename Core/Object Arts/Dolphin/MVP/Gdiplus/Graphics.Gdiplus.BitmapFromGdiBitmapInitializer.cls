"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.BitmapFromGdiBitmapInitializer'
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromGdiBitmapInitializer guid: (Core.GUID fromString: '{72187357-d718-4876-aaea-2cfefd2c5fd7}')!
Graphics.Gdiplus.BitmapFromGdiBitmapInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer methodsFor!

bitmap: aBitmap
	bitmap := aBitmap!

createHandle
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
	self library
		gdipCreateBitmapFromHBITMAP: bitmap asParameter
		hpal: hPalette
		bitmap: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer categoriesFor: #bitmap:!initializing!private! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer class methodsFor!

bitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Windows Microsoft® Windows® 
	Graphics Device Interface (GDI) bitmap and a handle to a GDI palette."

	"SW: Would there be any need to allow the user to supply the HPALETTE ?"

	^self new bitmap: aBitmap! !
!Graphics.Gdiplus.BitmapFromGdiBitmapInitializer class categoriesFor: #bitmap:!instance creation!public! !

