"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.FromFileInitializer subclass: #'Graphics.Gdiplus.ImageFromFileInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.ImageFromFileInitializer guid: (Core.GUID fromString: '{b5f81fe6-1de3-4f3d-bffd-2380b0ea2a90}')!
Graphics.Gdiplus.ImageFromFileInitializer comment: ''!
!Graphics.Gdiplus.ImageFromFileInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.ImageFromFileInitializer methodsFor!

createHandle
	"Private - GdiplusBitmap.h
		  Image(
        IN const WCHAR* filename,
        IN BOOL useEmbeddedColorManagement = FALSE
    );"

	"Note: GdiplusBitmap.h uses a switch on useEmbeddedColorManagement to call different flat-api functions"

	| gpHandle |
	gpHandle := Handle new.
	self library gdipLoadImageFromFile: self absoluteFilename image: gpHandle.
	^gpHandle! !
!Graphics.Gdiplus.ImageFromFileInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !

