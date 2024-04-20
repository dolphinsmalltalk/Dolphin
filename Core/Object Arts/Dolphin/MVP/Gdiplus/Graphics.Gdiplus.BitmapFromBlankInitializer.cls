"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BitmapInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromBlankInitializer'
	instanceVariableNames: 'width height format'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.BitmapFromBlankInitializer guid: (Core.GUID fromString: '{0a5beb4b-18f8-4ebe-bb4e-68ce5d088f33}')!

Graphics.Gdiplus.BitmapFromBlankInitializer comment: ''!

!Graphics.Gdiplus.BitmapFromBlankInitializer methodsFor!

= anObject
	^self == anObject or: 
			[self species = anObject species
				and: [width = anObject width and: [height = anObject height and: [format = anObject format]]]]!

basicCreateHandle
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
	Gdip
		gdipCreateBitmapFromScan0: width asInteger
		height: height asInteger
		stride: 0
		format: format
		scan0: nil
		bitmap: gpHandle.
	^gpHandle!

format
	^format!

hash
	^(((self species hash + width hash) hashMultiply + height hash) hashMultiply + format hash)
		hashMultiply!

height
	^height!

pixelFormatName
	^self class nameOfPixelFormat: format!

printImage: aGdiplusBitmap on: aWriteStream
	"Private - Print an expression on the <WriteStream> argument that will create a copy of the <Image> initialized by the receiver."

	aWriteStream
		print: aGdiplusBitmap class;
		nextPutAll: ' width: ';
		print: width;
		nextPutAll: ' height: ';
		print: height;
		nextPutAll: ' format: ';
		nextPutAll: (Smalltalk shortNameFor: self pixelFormatName in: Gdiplus)!

width
	^width!

width: widthInteger height: heightInteger format: aPixelFormat
	width := widthInteger.
	height := heightInteger.
	format := aPixelFormat.
	^self! !

!Graphics.Gdiplus.BitmapFromBlankInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
format!accessing!private! !
hash!comparing!public! !
height!accessing!private! !
pixelFormatName!private!realizing/unrealizing! !
printImage:on:!printing!private! !
width!accessing!private! !
width:height:format:!initializing!private! !
!

!Graphics.Gdiplus.BitmapFromBlankInitializer class methodsFor!

width: width height: height format: aPixelFormat
	^self new 
		width: width
		height: height
		format: aPixelFormat! !

!Graphics.Gdiplus.BitmapFromBlankInitializer class categoriesForMethods!
width:height:format:!instance creation!public! !
!

