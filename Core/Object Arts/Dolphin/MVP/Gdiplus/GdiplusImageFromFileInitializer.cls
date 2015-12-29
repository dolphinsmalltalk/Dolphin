"Filed out from Dolphin Smalltalk X6"!

GdiplusFromFileInitializer subclass: #GdiplusImageFromFileInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromFileInitializer guid: (GUID fromString: '{B5F81FE6-1DE3-4F3D-BFFD-2380B0EA2A90}')!
GdiplusImageFromFileInitializer comment: ''!
!GdiplusImageFromFileInitializer categoriesForClass!Unclassified! !
!GdiplusImageFromFileInitializer methodsFor!

createHandle
	"GdiplusBitmap.h
		  Image(
        IN const WCHAR* filename,
        IN BOOL useEmbeddedColorManagement = FALSE
    );"

	"Note: GdiplusBitmap.h uses a switch on useEmbeddedColorManagement to call different flat-api functions"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipLoadImageFromFile: self absoluteFilename asUnicodeString image: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Image'! !
!GdiplusImageFromFileInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusImageFromFileInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

