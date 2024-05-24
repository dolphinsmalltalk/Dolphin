"Filed out from Dolphin Smalltalk"!

GdiplusFromFileInitializer subclass: #GdiplusImageFromFileInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusImageFromFileInitializer guid: (GUID fromString: '{b5f81fe6-1de3-4f3d-bffd-2380b0ea2a90}')!

GdiplusImageFromFileInitializer comment: ''!

!GdiplusImageFromFileInitializer categoriesForClass!Unclassified! !

!GdiplusImageFromFileInitializer methodsFor!

createHandle
	"Private - GdiplusBitmap.h
		  Image(
        IN const WCHAR* filename,
        IN BOOL useEmbeddedColorManagement = FALSE
    );"

	"Note: GdiplusBitmap.h uses a switch on useEmbeddedColorManagement to call different flat-api functions"

	| gpHandle  |
	gpHandle := ExternalHandle new.
	self library gdipLoadImageFromFile: self absoluteFilename image: gpHandle.
	^gpHandle! !

!GdiplusImageFromFileInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
!

