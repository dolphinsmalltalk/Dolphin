"Filed out from Dolphin Smalltalk"!

GdiplusInitializer subclass: #GdiplusBitmapFromIStreamInitializer
	instanceVariableNames: 'iStream'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

GdiplusBitmapFromIStreamInitializer guid: (GUID fromString: '{f3cd9058-7788-4cff-95d9-04dda741ef4e}')!

GdiplusBitmapFromIStreamInitializer comment: ''!

!GdiplusBitmapFromIStreamInitializer categoriesForClass!Unclassified! !

!GdiplusBitmapFromIStreamInitializer methodsFor!

createHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle |
	gpHandle := ExternalHandle new.
	self library gdipCreateBitmapFromStream: iStream asParameter bitmap: gpHandle.
	^gpHandle!

isPersistent
	^false!

iStream: pStream
	iStream := pStream! !

!GdiplusBitmapFromIStreamInitializer categoriesForMethods!
createHandle!private!realizing/unrealizing! !
isPersistent!public!testing! !
iStream:!initializing!private! !
!

!GdiplusBitmapFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !

!GdiplusBitmapFromIStreamInitializer class categoriesForMethods!
iStream:!instance creation!public! !
!

