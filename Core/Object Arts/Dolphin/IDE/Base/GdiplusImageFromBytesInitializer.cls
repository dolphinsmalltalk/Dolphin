"Filed out from Dolphin Smalltalk X6.1"!

GdiplusFromBytesInitializer subclass: #GdiplusImageFromBytesInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageFromBytesInitializer guid: (GUID fromString: '{351525B1-07B3-43C9-B7D0-BC92D49DB495}')!
GdiplusImageFromBytesInitializer comment: ''!
!GdiplusImageFromBytesInitializer categoriesForClass!Unclassified! !
!GdiplusImageFromBytesInitializer methodsFor!

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
	status := self library gdipLoadImageFromStream: self iStream asParameter image: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Image'! !
!GdiplusImageFromBytesInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusImageFromBytesInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !

