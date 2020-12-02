"Filed out from Dolphin Smalltalk 7"!

GdiplusInitializer subclass: #GdiplusBitmapFromBlankInitializer
	instanceVariableNames: 'width height format'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusBitmapFromBlankInitializer guid: (GUID fromString: '{0a5beb4b-18f8-4ebe-bb4e-68ce5d088f33}')!
GdiplusBitmapFromBlankInitializer comment: ''!
!GdiplusBitmapFromBlankInitializer categoriesForClass!Unclassified! !
!GdiplusBitmapFromBlankInitializer methodsFor!

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

	| gpHandle status |
	gpHandle := ExternalHandle new.
	status := self library
				gdipCreateBitmapFromScan0: width
				height: height
				stride: 0
				format: format
				scan0: 0
				bitmap: gpHandle.
	status == Ok ifFalse: [self gdiplusErrorWith: status].
	^gpHandle!

gdiplusConstructorErrorDescription
	^'Error creating Bitmap'!

width: widthInteger height: heightInteger format: aPixelFormat
	width := widthInteger.
	height := heightInteger.
	format := aPixelFormat.
	^self! !
!GdiplusBitmapFromBlankInitializer categoriesFor: #createHandle!private!realizing/unrealizing! !
!GdiplusBitmapFromBlankInitializer categoriesFor: #gdiplusConstructorErrorDescription!constants!private! !
!GdiplusBitmapFromBlankInitializer categoriesFor: #width:height:format:!initializing!private! !

!GdiplusBitmapFromBlankInitializer class methodsFor!

width: width height: height format: aPixelFormat
	^self new 
		width: width
		height: height
		format: aPixelFormat! !
!GdiplusBitmapFromBlankInitializer class categoriesFor: #width:height:format:!instance creation!public! !

