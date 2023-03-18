"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.BitmapInitializer
	subclass: #'Graphics.Gdiplus.BitmapFromBitmapAreaInitializer'
	instanceVariableNames: 'bitmap rectangle format'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.BitmapFromBitmapAreaInitializer guid: (Core.GUID fromString: '{d4a3b5dd-4eab-4917-842c-95bf34ac5067}')!
Graphics.Gdiplus.BitmapFromBitmapAreaInitializer comment: ''!
!Graphics.Gdiplus.BitmapFromBitmapAreaInitializer methodsFor!

= anObject
	"Answer whether the receiver and anObject are equivalent."

	^self species == anObject species
		and: [bitmap = anObject bitmap and: [rectangle = anObject rectangle and: [format = anObject format]]]!

basicCreateHandle
	| gpHandle |
	gpHandle := Handle new.
	Gdip
		gdipCloneBitmapAreaI: rectangle left
		y: rectangle top
		width: rectangle width
		height: rectangle height
		format: format
		srcBitmap: bitmap asParameter
		dstBitmap: gpHandle.
	^gpHandle!

bitmap
	^bitmap!

bitmap: aGdiplusBitmap rectangle: aRectangle format: aPixelFormat
	bitmap := aGdiplusBitmap.
	rectangle := aRectangle.
	format := aPixelFormat.
	^self!

format
	^format!

hash
	"Answer the <integer> hash value for the receiver."

	^(((self species hash + format hash) hashMultiply + rectangle hash) hashMultiply + bitmap hash)
		hashMultiply!

pixelFormatName
	^self class nameOfPixelFormat: format!

printImage: aGdiplusBitmap on: aWriteStream
	aWriteStream
		nextPut: $(;
		print: aGdiplusBitmap class;
		nextPutAll: ' bitmap: ';
		print: bitmap;
		nextPutAll: ' rectangle: ';
		print: rectangle;
		nextPutAll: ' format: ';
		print: Gdiplus;
		nextPut: $.;
		nextPutAll: self pixelFormatName;
		nextPut: $)!

rectangle
	^rectangle! !
!Graphics.Gdiplus.BitmapFromBitmapAreaInitializer categoriesForMethods!
=!comparing!public! !
basicCreateHandle!private!realizing/unrealizing! !
bitmap!accessing!public! !
bitmap:rectangle:format:!initializing!private! !
format!accessing!public! !
hash!comparing!public! !
pixelFormatName!accessing!public! !
printImage:on:!printing!public! !
rectangle!accessing!public! !
!

!Graphics.Gdiplus.BitmapFromBitmapAreaInitializer class methodsFor!

bitmap: aGdiplusBitmap rectangle: aRectangle format: aPixelFormat
	^self new
		bitmap: aGdiplusBitmap
		rectangle: aRectangle
		format: aPixelFormat! !
!Graphics.Gdiplus.BitmapFromBitmapAreaInitializer class categoriesForMethods!
bitmap:rectangle:format:!instance creation!public! !
!

