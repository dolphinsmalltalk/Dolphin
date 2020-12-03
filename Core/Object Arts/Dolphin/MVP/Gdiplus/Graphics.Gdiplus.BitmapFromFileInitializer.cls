"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FromFileInitializer subclass: #'Graphics.Gdiplus.BitmapFromFileInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromFileInitializer guid: (Core.GUID fromString: '{22318a95-8a19-46a9-8774-f3e8c2d5db86}')!
Graphics.Gdiplus.BitmapFromFileInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromFileInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.BitmapFromFileInitializer methodsFor!

createHandle
	"Private - GdiplusBitmap.h
		Bitmap::Bitmap(
	    IN const WCHAR *filename, 
	    IN BOOL useEmbeddedColorManagement
	...

	 {
	        lastResult = DllExports::GdipCreateBitmapFromFile(filename, &bitmap);
	    }"

	"Note: GdiplusBitmap.h uses a switch on useEmbeddedColorManagement to call different flat-api functions"

	| gpHandle status |
	gpHandle := Handle new.
	status := self library gdipCreateBitmapFromFile: self absoluteFilename bitmap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error loading Bitmap'! !
!Graphics.Gdiplus.BitmapFromFileInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.BitmapFromFileInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

