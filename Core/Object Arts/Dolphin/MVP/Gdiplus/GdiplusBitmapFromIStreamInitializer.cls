"Filed out from Dolphin Smalltalk 7"!

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
	status := self library gdipCreateBitmapFromStream: iStream asParameter bitmap: gpHandle.
	self assertStatusOk: status.
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'!

isPersistent
	^false!

iStream: pStream
	iStream := pStream! !
!GdiplusBitmapFromIStreamInitializer categoriesFor: #createHandle!public!realizing/unrealizing! !
!GdiplusBitmapFromIStreamInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusBitmapFromIStreamInitializer categoriesFor: #isPersistent!public!testing! !
!GdiplusBitmapFromIStreamInitializer categoriesFor: #iStream:!accessing!public! !

!GdiplusBitmapFromIStreamInitializer class methodsFor!

iStream: pStream
	^self new iStream: pStream! !
!GdiplusBitmapFromIStreamInitializer class categoriesFor: #iStream:!instance creation!public! !

