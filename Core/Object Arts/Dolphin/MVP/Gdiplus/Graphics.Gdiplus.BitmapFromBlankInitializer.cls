"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Initializer subclass: #'Graphics.Gdiplus.BitmapFromBlankInitializer'
	instanceVariableNames: 'width height format'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromBlankInitializer guid: (Core.GUID fromString: '{0a5beb4b-18f8-4ebe-bb4e-68ce5d088f33}')!
Graphics.Gdiplus.BitmapFromBlankInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromBlankInitializer categoriesForClass!Unclassified! !
!Graphics.Gdiplus.BitmapFromBlankInitializer methodsFor!

createHandle
	"Private -  Bitmap::Bitmap(
	    IN INT width,
	    IN INT height,
	    IN PixelFormat format
	    )
	{
	    GpBitmap *bitmap = NULL;

	    lastResult = DllExports::GdipCreateBitmapFromScan0(width,
                                                       height,
                                                       0,
                                                       format,
                                                       NULL,
                                                       &bitmap);"

	| gpHandle |
	gpHandle := Handle new.
	self library
		gdipCreateBitmapFromScan0: width
		height: height
		stride: 0
		format: format
		scan0: 0
		bitmap: gpHandle.
	^gpHandle!

width: widthInteger height: heightInteger format: aPixelFormat
	width := widthInteger.
	height := heightInteger.
	format := aPixelFormat.
	^self! !
!Graphics.Gdiplus.BitmapFromBlankInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!Graphics.Gdiplus.BitmapFromBlankInitializer categoriesFor: #width:height:format:!initializing!private! !

!Graphics.Gdiplus.BitmapFromBlankInitializer class methodsFor!

width: width height: height format: aPixelFormat
	^self new 
		width: width
		height: height
		format: aPixelFormat! !
!Graphics.Gdiplus.BitmapFromBlankInitializer class categoriesFor: #width:height:format:!instance creation!public! !

