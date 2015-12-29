"Filed out from Dolphin Smalltalk X6"!

GdiplusFromFileInitializer subclass: #GdiplusBitmapFromFileInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromFileInitializer guid: (GUID fromString: '{22318A95-8A19-46A9-8774-F3E8C2D5DB86}')!
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
	status := self library gdipCreateBitmapFromFile: self absoluteFilename asUnicodeString
				bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!GdiplusBitmapFromFileInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromFileInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

