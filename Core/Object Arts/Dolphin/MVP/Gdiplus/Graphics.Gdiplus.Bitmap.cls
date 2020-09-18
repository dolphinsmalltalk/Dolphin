"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Image subclass: #'Graphics.Gdiplus.Bitmap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Bitmap guid: (Core.GUID fromString: '{206fb497-cb98-42d3-a48f-1f83e25cce07}')!
Graphics.Gdiplus.Bitmap comment: 'GdiplusBitmap expands on GdiplusImage by providing additional methods for creating and manipulating raster images.'!
!Graphics.Gdiplus.Bitmap categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Bitmap methodsFor!

asBitmap
	"Answer a <Bitmap> with the receiver's image."

	| hbmReturn |
	hbmReturn := Handle new.
	GdiplusLibrary default
		gdipCreateHBITMAPFromBitmap: self asParameter
		hbmReturn: hbmReturn
		background: 0.
	^Graphics.Bitmap fromOwnedHandle: hbmReturn!

asIcon
	"Answer an <Icon> with the receiver's image."

	| hbmReturn |
	hbmReturn := Handle new.
	GdiplusLibrary default gdipCreateHICONFromBitmap: self asParameter hbmReturn: hbmReturn.
	^Icon fromOwnedHandle: hbmReturn!

cloneBitmapRectangle: aRectangle format: aPixelFormatConstant
	"Private - Answer a copy of the receiver."

	| gpHandle |
	gpHandle := Handle new.
	GdiplusLibrary default
		gdipCloneBitmapAreaI: aRectangle left
		y: aRectangle top
		width: aRectangle width
		height: aRectangle height
		format: aPixelFormatConstant
		srcBitmap: self handle
		dstBitmap: gpHandle.
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

cloneFormat: aPixelFormatConstant
	"Answer a copy of the receiver."

	^self cloneBitmapRectangle: (Rectangle extent: self extent) format: aPixelFormatConstant!

lockBits: rect flags: flags format: format lockedBitmapData: lockedBitmapData
	GdiplusLibrary default
		gdipBitmapLockBits: self handle
		rect: rect
		flags: flags
		format: format
		lockedBitmapData: lockedBitmapData
	"Invoke the GdipBitmapLockBits() function of the module wrapped by the receiver.

		Status __stdcall GdipBitmapLockBits(
			[in] ExternalHandle bitmap,
			[in] RECT* rect,
			[in] unsigned int flags,
			[in] int format,
			[out, retval] GpBitmapData* lockedBitmapData);

	<stdcall: sdword GdipBitmapLockBits  handle RECT* dword sdword GpBitmapData*>
	^self invalidCall"!

pixelAt: aPoint
	"Answer an ARGB that is the color of the receiver at aPoint."

	| color |
	color := ByteArray newFixed: 4.
	GdiplusLibrary default
		gdipBitmapGetPixel: self asParameter
		x: aPoint x
		y: aPoint y
		color: color.
	^Color fromArgbCode: (color dwordAtOffset: 0)!

pixelAt: aPoint put: anARGB
	"Set the pixel at aPoint to be anARGB"

	GdiplusLibrary default
		gdipBitmapSetPixel: self asParameter
		x: aPoint x
		y: aPoint y
		color: anARGB argbCode!

unlockBits: lockedBitmapData
	GdiplusLibrary default gdipBitmapUnlockBits: self handle lockedBitmapData: lockedBitmapData! !
!Graphics.Gdiplus.Bitmap categoriesFor: #asBitmap!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #asIcon!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #cloneBitmapRectangle:format:!copying!private! !
!Graphics.Gdiplus.Bitmap categoriesFor: #cloneFormat:!copying!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #lockBits:flags:format:lockedBitmapData:!accessing!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #pixelAt:!accessing!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #pixelAt:put:!accessing!public! !
!Graphics.Gdiplus.Bitmap categoriesFor: #unlockBits:!accessing!public! !

!Graphics.Gdiplus.Bitmap class methodsFor!

exampleGdipBFromBitmap
	"This example displays a GdiplusBitmap created from a bitmap that's a copy of an icon.

		self exampleGdipBFromBitmap showExample
	"

	| bmp |
	bmp := Graphics.Bitmap
				gdipCopyOfIcon: self icon
				extent: 32 @ 32
				backcolor: Color black.
	^Bitmap fromBitmap: bmp!

exampleGdipBFromByteArray
	"This example displays a GdiplusBitmap created from a ByteArray.

		self exampleGdipBFromByteArray showExample
	"

	| testBytes |
	testBytes := self fileResource fish32x32pngBytes.
	^Bitmap fromByteArray: testBytes!

exampleGdipBFromDIB
	"This example creates aGdiplusBitmap from a DIBSection.

		self exampleGdipBFromDIB showExample
	"

	| bmp |
	bmp := DIBSection
				gdipCopyOfIcon: self icon
				extent: 32 @ 32
				backcolor: Color black.
	^Gdiplus.Bitmap fromBitmap: bmp!

exampleGdipBFromXPIcon
	"This example creates aGdiplusBitmap from an Icon file.
	The file contains  three XP formats; 16x16/32x32/48x48

		self exampleGdipBFromXPIcon showExample
	"

	| testIcon |
	testIcon := Icon fromFile: self fileResource pafWinXP32x32ico.
	^Bitmap fromIcon: testIcon!

exampleGdipBResize1
	"This example creates an image from an existing file and then creates several copies 
	of the image, each resized a different way.  The copies are all displayed, each with a 
	thin black line around the image bounds.

		self exampleGdipBResize1 showExample
	"

	| bitmap image copy1 copy2 copy3 copy4 |
	bitmap := Bitmap extent: 620 @ 200.
	image := Image fromFile: self fileResource pafEyeJpg.
	copy1 := Bitmap fromImage: image extent: 100 @ 150.
	copy2 := Bitmap fromImage: image centeredIn: 100 @ 150.
	copy3 := Bitmap fromImage: image scaledBy: 1 / 4.
	copy4 := Bitmap fromImage: image crop: (180 @ 220 extent: 200 @ 150).
	bitmap graphics
		drawImage: copy1 at: 10 @ 10;
		drawRectangle: (10 @ 10 extent: copy1 extent);
		drawString: 'withExtent:' at: 10 @ 170;
		drawImage: copy2 at: 120 @ 10;
		drawRectangle: (120 @ 10 extent: copy2 extent);
		drawString: 'withCentering:' at: 120 @ 170;
		drawImage: copy3 at: 230 @ 10;
		drawRectangle: (230 @ 10 extent: copy3 extent);
		drawString: 'withScale:' at: 230 @ 170;
		drawImage: copy4 at: 400 @ 10;
		drawRectangle: (400 @ 10 extent: copy4 extent);
		drawString: 'withCrop:' at: 400 @ 170.
	^bitmap!

exampleGdipBResize2
	"This example resizes an image from an existing file and saves the resized image to a file.

		self exampleGdipBResize2 showExample
	"

	| image resizedImage toFile |
	image := self fromFile: self fileResource pafSeattleNightJpg.
	resizedImage := Bitmap fromImage: image scaledBy: 1 / 3.
	toFile := self fileResource fileLocator localFileSpecFor: 'testResize.jpg'.
	resizedImage saveToFile: toFile.
	^self fromFile: toFile!

exampleGdipBResize3
	"This example resizes an image from an existing file and saves the resized image to a file.

		self exampleGdipBResize3 showExample
	"

	| image resizedImage toFile |
	image := self fromFile: self fileResource pafSeattleNightJpg.
	resizedImage := Bitmap fromImage: image centeredIn: 400 @ 200.
	toFile := self fileResource fileLocator localFileSpecFor: 'testResize.png'.
	resizedImage saveToFile: toFile.
	^self fromFile: toFile!

exampleLockBitsTest1Bmp
	| bitmap redBrush blueBrush |
	bitmap := Bitmap width: 30 height: 16.
	redBrush := SolidBrush red.
	blueBrush := SolidBrush blue.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 30 @ 4) brush: redBrush;
		fillRectangle: (0 @ 4 extent: 30 @ 4) brush: blueBrush;
		fillRectangle: (0 @ 8 extent: 30 @ 4) brush: redBrush;
		fillRectangle: (0 @ 12 extent: 30 @ 4) brush: blueBrush.
	^bitmap
!

exampleLockBitsTest2Bmp
	| bitmap redBrush blueBrush |
	bitmap := Bitmap width: 120 height: 60.
	redBrush := SolidBrush red.
	blueBrush := SolidBrush blue.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 120 @ 12) brush: redBrush;
		fillRectangle: (0 @ 12 extent: 120 @ 12) brush: blueBrush;
		fillRectangle: (0 @ 24 extent: 120 @ 12) brush: redBrush;
		fillRectangle: (0 @ 36 extent: 120 @ 12) brush: blueBrush;
		fillRectangle: (0 @ 48 extent: 120 @ 12) brush: redBrush.
	^bitmap!

extent: aPoint
	"Creates a Bitmap object of a specified size with the default pixel format PixelFormat32bppARGB."

	^self width: aPoint x height: aPoint y!

fromBitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Windows Microsoft® Windows® 
	Graphics Device Interface (GDI) bitmap and a handle to a GDI palette."

	"MSDN: Do not pass to the GDI+ Bitmap constructor a GDI bitmap or a GDI
	palette that is currently (***or was previously*** ?) selected into a device context."

	^self fromInitializer: (BitmapFromGdiBitmapInitializer bitmap: aBitmap)!

fromByteArray: aByteArray
	"Answer an instance of the receiver created from data in aByteArray. The results is an instance with a persistent
	initializer that can be used after an image reload or after passing through STB serialization/deserialization."

	^self fromInitializer: (BitmapFromBytesInitializer bytes: aByteArray)!

fromFile: aFilename usingLocator: aFileLocator
	"Answer an instance loaded from the file aFilename by using aFileLocator."

	^self fromInitializer: (BitmapFromFileInitializer filename: aFilename fileLocator: aFileLocator)!

fromIcon: anIcon
	"Creates a Bitmap object based on an icon."

	^self fromInitializer: (BitmapFromIconInitializer icon: anIcon)!

fromImage: aGdiplusImage centeredIn: aPoint
	"Answer an instance of the receiver based on aGdiplusImage and sized proportionally to fit
	in a rectangle whose extent is aPoint.  If the instance is smaller than the rectangle, center it."

	| bitmap scale extent |
	bitmap := self extent: aPoint.
	extent := aGdiplusImage extent.
	(scale := aPoint x / extent x) * extent y > aPoint y
		ifTrue: [scale := aPoint y / aGdiplusImage height].
	extent := scale * extent.
	bitmap graphics
		drawImage: aGdiplusImage
			at: ((aPoint - extent) / 2) rounded
			extent: extent rounded;
		free.
	^bitmap!

fromImage: aGdiplusImage crop: aRectangle
	"Answer an instance of the receiver containing the portion of aGdiplusImage specified by aRectangle"

	| bitmap |
	bitmap := self extent: aRectangle extent.
	bitmap graphics
		drawImage: aGdiplusImage
			at: Point.Zero
			extent: bitmap extent
			from: aRectangle origin
			extent: aRectangle extent;
		free.
	^bitmap!

fromImage: aGdiplusImage extent: aPoint
	"Answer an instance of the receiver based on aGdiplusImage sized to extent aPoint."

	| bitmap |
	bitmap := self extent: aPoint.
	bitmap graphics
		drawImage: aGdiplusImage
			at: 0 @ 0
			extent: aPoint;
		free.
	^bitmap!

fromImage: aGdiplusImage scaledBy: aNumber 
	"Answer an instance of the receiver based on aGdiplusImage sized to 
	aGdiplusImage's extent scaled by aNumber."

	^self fromImage: aGdiplusImage extent: (aGdiplusImage extent * aNumber) rounded!

fromIStream: pStream
	"Creates a Bitmap object based on a stream."

	^self fromInitializer: (BitmapFromIStreamInitializer iStream: pStream)!

fromView: aView 
	^self fromBitmap: (Bitmap fromView: aView)
!

new
	"Answer a new initialized instance of the receiver."

	^self width: 600 height: 400!

width: width height: height
	"Answer an instance of the receiver of the specified size with each pixel represented by 32 bits
	(8 bits each for the alpha, red, green, and blue components)."

	^self 
		width: width
		height: height
		format: PixelFormat32bppARGB!

width: width height: height format: aPixelFormat
	"Creates a Bitmap object of a specified size and pixel format. The pixel data
	 must be provided after the Bitmap object is constructed."

	"aPixelFormat ... The default value is PixelFormat32bppARGB. "

	^self fromInitializer: (BitmapFromBlankInitializer
				width: width
				height: height
				format: aPixelFormat)! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBFromBitmap!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBFromByteArray!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBFromDIB!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBFromXPIcon!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBResize1!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBResize2!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleGdipBResize3!examples!public!sunit! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleLockBitsTest1Bmp!examples!private! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #exampleLockBitsTest2Bmp!examples!private! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #extent:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromBitmap:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromByteArray:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromFile:usingLocator:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromIcon:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromImage:centeredIn:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromImage:crop:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromImage:extent:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromImage:scaledBy:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromIStream:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #fromView:!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #new!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #width:height:!instance creation!public! !
!Graphics.Gdiplus.Bitmap class categoriesFor: #width:height:format:!instance creation!public! !

