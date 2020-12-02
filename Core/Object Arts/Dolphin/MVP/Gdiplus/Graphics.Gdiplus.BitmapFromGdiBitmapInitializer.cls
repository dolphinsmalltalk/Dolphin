"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusBitmapFromBitmapInitializer
	instanceVariableNames: 'bitmap'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusBitmapFromBitmapInitializer guid: (GUID fromString: '{72187357-d718-4876-aaea-2cfefd2c5fd7}')!
GdiplusBitmapFromBitmapInitializer comment: ''!
!GdiplusBitmapFromBitmapInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromBitmapInitializer methodsFor!

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
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #bitmap:!initializing!private! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusBitmapFromBitmapInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

!GdiplusBitmapFromBitmapInitializer class methodsFor!

bitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Windows Microsoft® Windows® 
	Graphics Device Interface (GDI) bitmap and a handle to a GDI palette."

	"SW: Would there be any need to allow the user to supply the HPALETTE ?"

	^self new bitmap: aBitmap! !
!GdiplusBitmapFromBitmapInitializer class categoriesFor: #bitmap:!instance creation!public! !

