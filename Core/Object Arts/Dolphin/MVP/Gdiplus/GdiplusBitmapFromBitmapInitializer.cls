"Filed out from Dolphin Smalltalk X6"!

GdiplusInitializer subclass: #GdiplusBitmapFromBitmapInitializer
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromBitmapInitializer guid: (GUID fromString: '{72187357-D718-4876-AAEA-2CFEFD2C5FD7}')!
GdiplusBitmapFromBitmapInitializer comment: ''!
!GdiplusBitmapFromBitmapInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromBitmapInitializer methodsFor!

bitmap: aBitmap
	bitmap := aBitmap!

createHandle
	" Bitmap::Bitmap(
	    IN HBITMAP hbm, 
	    IN HPALETTE hpal
	    )
	{
	    GpBitmap *bitmap = NULL;

	    lastResult = DllExports::GdipCreateBitmapFromHBITMAP(hbm, hpal, &bitmap);"

	| gpHandle status hPalette |
	gpHandle := ExternalHandle new.
	hPalette := bitmap createPalette.

	"MSDN: Do not pass to the GDI+ Bitmap constructor a GDI bitmap or a GDI palette
	that is currently (or was previously) selected into a device context."

	"SW: This handles 'currently' ,,, but what about 'or was previously' ???"
	bitmap freeDC.
	status := self library 
				gdipCreateBitmapFromHBITMAP: bitmap asParameter
				hpal: hPalette
				bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #bitmap:!accessing!public! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusBitmapFromBitmapInitializer class methodsFor!

bitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Windows Microsoft® Windows® 
	Graphics Device Interface (GDI) bitmap and a handle to a GDI palette."

	"SW: Would there be any need to allow the user to supply the HPALETTE ?"

	^self new bitmap: aBitmap! !
!GdiplusBitmapFromBitmapInitializer class categoriesFor: #bitmap:!instance creation!public! !

