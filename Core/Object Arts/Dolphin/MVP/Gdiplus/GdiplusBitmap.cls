"Filed out from Dolphin Smalltalk"!

GdiplusImage subclass: #GdiplusBitmap
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusBitmap guid: (GUID fromString: '{206fb497-cb98-42d3-a48f-1f83e25cce07}')!
GdiplusBitmap comment: 'GdiplusBitmap expands on GdiplusImage by providing additional methods for creating and manipulating raster images.'!
!GdiplusBitmap categoriesForClass!Unclassified! !
!GdiplusBitmap methodsFor!

asBitmap
	"Answer a <Bitmap> with the receiver's image."

	| status hbmReturn |
	hbmReturn := ExternalHandle new.
	(status := GdiplusLibrary default
				gdipCreateHBITMAPFromBitmap: self asParameter
				hbmReturn: hbmReturn
				background: 0) == Ok
		ifFalse: [^GdiplusError signal: 'Error in GdipCreateHBITMAPFromBitmap' with: status].
	^Bitmap fromOwnedHandle: hbmReturn!

asIcon
	"Answer an <Icon> with the receiver's image."

	| status hbmReturn |
	hbmReturn := ExternalHandle new.
	(status := GdiplusLibrary default 
				gdipCreateHICONFromBitmap: self asParameter hbmReturn: hbmReturn) == Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipCreateHICONFromBitmap' with: status].
	^Icon fromOwnedHandle: hbmReturn!

cloneBitmapRectangle: aRectangle format: aPixelFormatConstant 
	"Private - Answer a copy of the receiver."

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default 
				gdipCloneBitmapAreaI: aRectangle left
				y: aRectangle top
				width: aRectangle width
				height: aRectangle height
				format: aPixelFormatConstant
				srcBitmap: self handle
				dstBitmap: gpHandle) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipCloneBitmapAreaI' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
		yourself!

cloneFormat: aPixelFormatConstant 
	"Answer a copy of the receiver."

	^self cloneBitmapRectangle: (Point zero extent: self extent) format: aPixelFormatConstant!

lockBits: rect flags: flags format: format lockedBitmapData: lockedBitmapData
	| status |
	(status := GdiplusLibrary default
				gdipBitmapLockBits: self handle
				rect: rect
				flags: flags
				format: format
				lockedBitmapData: lockedBitmapData) = Ok
		ifFalse: [^GdiplusError signal: 'Error in GdipBitmapLockBits' with: status]
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

	| status color |
	color := DWORD new.
	status := GdiplusLibrary default
				gdipBitmapGetPixel: self asParameter
				x: aPoint x
				y: aPoint y
				color: color asParameter.
	status == Ok ifFalse: [GdiplusError signal: 'GdipBitmapGetPixel  failed' with: status].
	^Color fromArgbCode: color asInteger!

pixelAt: aPoint put: anARGB 
	"Set the pixel at aPoint to be anARGB"

	| status |
	status := GdiplusLibrary default 
				gdipBitmapSetPixel: self asParameter
				x: aPoint x
				y: aPoint y
				color: anARGB argbCode.
	status = Ok ifFalse: [GdiplusError signal: 'GdipBitmapSetPixel  failed' with: status]!

unlockBits: lockedBitmapData
	| status |
	(status := GdiplusLibrary default gdipBitmapUnlockBits: self handle
				lockedBitmapData: lockedBitmapData) = Ok
		ifFalse: [^GdiplusError signal: 'Error in GdipBitmapUnlockBits' with: status]! !
!GdiplusBitmap categoriesForMethods!
asBitmap!public! !
asIcon!public! !
cloneBitmapRectangle:format:!copying!private! !
cloneFormat:!copying!public! !
lockBits:flags:format:lockedBitmapData:!accessing!public! !
pixelAt:!accessing!public! !
pixelAt:put:!accessing!public! !
unlockBits:!accessing!public! !
!

!GdiplusBitmap class methodsFor!

exampleGdipBFromBitmap
	"This example displays a GdiplusBitmap created from a bitmap that's a copy of an icon.

		self exampleGdipBFromBitmap showExample
	"

	| bmp |
	bmp := Bitmap 
				gdipCopyOfIcon: self icon
				extent: 32 @ 32
				backcolor: Color black.
	^GdiplusBitmap fromBitmap: bmp!

exampleGdipBFromByteArray
	"This example displays a GdiplusBitmap created from a ByteArray.

		self exampleGdipBFromByteArray showExample
	"

	| testBytes |
	testBytes := self fileResource fish32x32pngBytes.
	^GdiplusBitmap fromByteArray: testBytes!

exampleGdipBFromDIB
	"This example creates aGdiplusBitmap from a DIBSection.

		self exampleGdipBFromDIB showExample
	"

	| bmp |
	bmp := DIBSection 
				gdipCopyOfIcon: self icon
				extent: 32 @ 32
				backcolor: Color black.
	^GdiplusBitmap fromBitmap: bmp!

exampleGdipBFromXPIcon
	"This example creates aGdiplusBitmap from an Icon file.
	The file contains  three XP formats; 16x16/32x32/48x48

		self exampleGdipBFromXPIcon showExample
	"

	| testIcon |
	testIcon := Icon fromFile: self fileResource pafWinXP32x32ico.
	^GdiplusBitmap fromIcon: testIcon!

exampleGdipBResize1
	"This example creates an image from an existing file and then creates several copies 
	of the image, each resized a different way.  The copies are all displayed, each with a 
	thin black line around the image bounds.

		self exampleGdipBResize1 showExample
	"

	| bitmap image copy1 copy2 copy3 copy4 |
	bitmap := GdiplusBitmap extent: 620 @ 200.
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	copy1 := GdiplusBitmap fromImage: image extent: 100 @ 150.
	copy2 := GdiplusBitmap fromImage: image centeredIn: 100 @ 150.
	copy3 := GdiplusBitmap fromImage: image scaledBy: 1 / 4.
	copy4 := GdiplusBitmap fromImage: image crop: (180 @ 220 extent: 200 @ 150).
	(bitmap graphics)
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
	resizedImage := GdiplusBitmap fromImage: image scaledBy: 1 / 3.
	toFile := self fileResource fileLocator localFileSpecFor: 'testResize.jpg'.
	resizedImage saveToFile: toFile.
	^self fromFile: toFile!

exampleGdipBResize3
	"This example resizes an image from an existing file and saves the resized image to a file.

		self exampleGdipBResize3 showExample
	"

	| image resizedImage toFile |
	image := self fromFile: self fileResource pafSeattleNightJpg.
	resizedImage := GdiplusBitmap fromImage: image centeredIn: 400 @ 200.
	toFile := self fileResource fileLocator localFileSpecFor: 'testResize.png'.
	resizedImage saveToFile: toFile.
	^self fromFile: toFile!

exampleLockBitsTest1Bmp
	| bitmap redBrush blueBrush |
	bitmap := GdiplusBitmap width: 30 height: 16.
	redBrush := GdiplusSolidBrush red.
	blueBrush := GdiplusSolidBrush blue.
	(bitmap graphics)
		fillRectangle: (0 @ 0 extent: 30 @ 4) brush: redBrush;
		fillRectangle: (0 @ 4 extent: 30 @ 4) brush: blueBrush;
		fillRectangle: (0 @ 8 extent: 30 @ 4) brush: redBrush;
		fillRectangle: (0 @ 12 extent: 30 @ 4) brush: blueBrush.
	^bitmap!

exampleLockBitsTest2Bmp
	| bitmap redBrush blueBrush |
	bitmap := GdiplusBitmap width: 120 height: 60.
	redBrush := GdiplusSolidBrush red.
	blueBrush := GdiplusSolidBrush blue.
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

	^self fromInitializer: (GdiplusBitmapFromBitmapInitializer bitmap: aBitmap)!

fromByteArray: aByteArray 
	"Answer an instance of the receiver created from data in aByteArray. The results is an instance with a persistent
	initializer that can be used after an image reload or after passing through STB serialization/deserialization."

	^self fromInitializer: (GdiplusBitmapFromBytesInitializer bytes: aByteArray)!

fromFile: aFilename usingLocator: aFileLocator
	"Answer an instance loaded from the file aFilename by using aFileLocator."

	^self fromInitializer: (GdiplusBitmapFromFileInitializer filename: aFilename
				fileLocator: aFileLocator)!

fromIcon: anIcon
	"Creates a Bitmap object based on an icon."

	^self fromInitializer: (GdiplusBitmapFromIconInitializer icon: anIcon)!

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
			at: Point zero
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

	^self fromInitializer: (GdiplusBitmapFromIStreamInitializer iStream: pStream)!

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

	^self fromInitializer: (GdiplusBitmapFromBlankInitializer 
				width: width
				height: height
				format: aPixelFormat)! !
!GdiplusBitmap class categoriesForMethods!
exampleGdipBFromBitmap!examples!public!sunit! !
exampleGdipBFromByteArray!examples!public!sunit! !
exampleGdipBFromDIB!examples!public!sunit! !
exampleGdipBFromXPIcon!examples!public!sunit! !
exampleGdipBResize1!examples!public!sunit! !
exampleGdipBResize2!examples!public!sunit! !
exampleGdipBResize3!examples!public!sunit! !
exampleLockBitsTest1Bmp!examples!private! !
exampleLockBitsTest2Bmp!examples!private! !
extent:!instance creation!public! !
fromBitmap:!instance creation!public! !
fromByteArray:!instance creation!public! !
fromFile:usingLocator:!instance creation!public! !
fromIcon:!instance creation!public! !
fromImage:centeredIn:!instance creation!public! !
fromImage:crop:!instance creation!public! !
fromImage:extent:!instance creation!public! !
fromImage:scaledBy:!instance creation!public! !
fromIStream:!instance creation!public! !
fromView:!public! !
new!instance creation!public! !
width:height:!instance creation!public! !
width:height:format:!instance creation!public! !
!

