"Filed out from Dolphin Smalltalk 7"!

GdiplusFromFileInitializer subclass: #GdiplusBitmapFromFileInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusBitmapFromFileInitializer guid: (GUID fromString: '{22318a95-8a19-46a9-8774-f3e8c2d5db86}')!
GdiplusBitmapFromFileInitializer comment: ''!
!GdiplusBitmapFromFileInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromFileInitializer methodsFor!

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
	gpHandle := ExternalHandle new.
	status := self library gdipCreateBitmapFromFile: self absoluteFilename bitmap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error loading Bitmap'! !
!GdiplusBitmapFromFileInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusBitmapFromFileInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

