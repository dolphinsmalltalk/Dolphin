"Filed out from Dolphin Smalltalk 7"!

GdiplusFromFileInitializer subclass: #GdiplusBitmapFromFileInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromFileInitializer guid: (GUID fromString: '{22318a95-8a19-46a9-8774-f3e8c2d5db86}')!
GdiplusBitmapFromFileInitializer comment: ''!
!GdiplusBitmapFromFileInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromFileInitializer methodsFor!

createHandle
	"GdiplusBitmap.h
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
	status := self library gdipCreateBitmapFromFile: self absoluteFilename 
				bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!GdiplusBitmapFromFileInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromFileInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

