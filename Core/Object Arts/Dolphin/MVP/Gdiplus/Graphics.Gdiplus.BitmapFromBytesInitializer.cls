﻿"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.AbstractImageFromBytesInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromBytesInitializer'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.BitmapFromBytesInitializer guid: (Core.GUID fromString: '{6e7e335e-9dd7-44fa-8648-96e7d9528f11}')!

Graphics.Gdiplus.BitmapFromBytesInitializer comment: ''!

!Graphics.Gdiplus.BitmapFromBytesInitializer methodsFor!

basicCreateHandle
	"Private -  Bitmap::Bitmap(
	    IN IStream *stream, 
	    IN BOOL useEmbeddedColorManagement
	    )
	...
	 {
	        lastResult = DllExports::GdipCreateBitmapFromStream(stream, &bitmap);
	    }"

	| gpHandle stm |
	gpHandle := Handle new.
	stm := self iStream.
	Gdip gdipCreateBitmapFromStream: stm bitmap: gpHandle.
	stm free.
	^gpHandle! !

!Graphics.Gdiplus.BitmapFromBytesInitializer categoriesForMethods!
basicCreateHandle!private!realizing/unrealizing! !
!

