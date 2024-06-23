"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractImageFromFileInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromFileInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.BitmapFromFileInitializer guid: (Core.GUID fromString: '{22318a95-8a19-46a9-8774-f3e8c2d5db86}')!

Graphics.Gdiplus.BitmapFromFileInitializer comment: ''!

!Graphics.Gdiplus.BitmapFromFileInitializer methodsFor!

basicCreateHandle
	"Private - GdiplusBitmap.h
		Bitmap::Bitmap(
	    IN const WCHAR *filename, 
	    IN BOOL useEmbeddedColorManagement
	...

	 {
	        lastResult = DllExports::GdipCreateBitmapFromFile(filename, &bitmap);
	    }"

	"Note: GdiplusBitmap.h uses a switch on useEmbeddedColorManagement to call different flat-api functions"

	| gpHandle |
	gpHandle := Handle new.
	Gdip gdipCreateBitmapFromFile: self absoluteFilename bitmap: gpHandle.
	^gpHandle! !

!Graphics.Gdiplus.BitmapFromFileInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

