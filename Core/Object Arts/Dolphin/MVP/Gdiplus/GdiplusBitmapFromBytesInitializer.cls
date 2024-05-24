"Filed out from Dolphin Smalltalk"!

GdiplusFromBytesInitializer subclass: #GdiplusBitmapFromBytesInitializer
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromBytesInitializer guid: (GUID fromString: '{6e7e335e-9dd7-44fa-8648-96e7d9528f11}')!

GdiplusBitmapFromBytesInitializer comment: ''!

!GdiplusBitmapFromBytesInitializer categoriesForClass!Unclassified! !

!GdiplusBitmapFromBytesInitializer methodsFor!

createHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle stm |
	gpHandle := ExternalHandle new.
	stm := self iStream.
	self library gdipCreateBitmapFromStream: stm bitmap: gpHandle.
	stm free.
	^gpHandle! !

!GdiplusBitmapFromBytesInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
!

