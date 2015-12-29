"Filed out from Dolphin Smalltalk X6.1"!

GdiplusFromBytesInitializer subclass: #GdiplusBitmapFromBytesInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmapFromBytesInitializer guid: (GUID fromString: '{6E7E335E-9DD7-44FA-8648-96E7D9528F11}')!
GdiplusBitmapFromBytesInitializer comment: ''!
!GdiplusBitmapFromBytesInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromBytesInitializer methodsFor!

createHandle
	" Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library gdipCreateBitmapFromStream: self iStream asParameter bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'! !
!GdiplusBitmapFromBytesInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromBytesInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

