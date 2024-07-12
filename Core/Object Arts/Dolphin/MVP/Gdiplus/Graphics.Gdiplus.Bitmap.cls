"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Image
	subclass: #'Graphics.Gdiplus.Bitmap'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Gdiplus.Bitmap guid: (Core.GUID fromString: '{206fb497-cb98-42d3-a48f-1f83e25cce07}')!

Graphics.Gdiplus.Bitmap comment: 'GdiplusBitmap expands on GdiplusImage by providing additional methods for creating and manipulating raster images.'!

!Graphics.Gdiplus.Bitmap methodsFor!

asBitmap
	"Answer a <Bitmap> with the receiver's image."

	| hbmReturn |
	hbmReturn := Handle new.
	Gdip
		gdipCreateHBITMAPFromBitmap: self asParameter
		hbmReturn: hbmReturn
		background: 0.
	^Graphics.Bitmap fromOwnedHandle: hbmReturn!

asIcon
	"Answer an <Icon> with the receiver's image."

	| hbmReturn |
	hbmReturn := Handle new.
	Gdip gdipCreateHICONFromBitmap: self asParameter hbmReturn: hbmReturn.
	^Icon fromOwnedHandle: hbmReturn!

cloneFormat: aPixelFormatConstant
	"Answer a copy of the receiver, but with the specified PixelFormat."

	^self cloneRectangle: (Rectangle extent: self extent) format: aPixelFormatConstant!

cloneRectangle: aRectangle
	^self cloneRectangle: aRectangle format: self pixelFormat!

cloneRectangle: aRectangle format: aPixelFormatConstant
	^self class fromInitializer: (BitmapFromBitmapAreaInitializer
				bitmap: self
				rectangle: aRectangle
				format: aPixelFormatConstant)!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^BitmapInitializer!

lockBits: aRectangle
	^self lockBits: aRectangle flags: ImageLockModeRead!

lockBits: aRectangle flags: flagsInteger
	^self lockBits: aRectangle flags: flagsInteger format: PixelFormat32bppARGB!

lockBits: aRectangle flags: flagsInteger format: formatInteger
	| data |
	data := BitmapData newBuffer.
	Gdip
		gdipBitmapLockBits: self handle
		rect: (Rect marshal: aRectangle)
		flags: flagsInteger
		format: formatInteger
		lockedBitmapData: data.
	^data!

mimeType
	^self filename isNil ifTrue: ['image/bmp'] ifFalse: [super mimeType]!

pixelAt: aPoint
	"Answer an ARGB that is the color of the receiver at aPoint."

	| color |
	color := ByteArray newFixed: 4.
	Gdip
		gdipBitmapGetPixel: self handle
		x: aPoint x
		y: aPoint y
		color: color.
	^Color fromArgbCode: (color uint32AtOffset: 0)!

pixelAt: aPoint put: anARGB
	"Set the pixel at aPoint to be anARGB"

	Gdip
		gdipBitmapSetPixel: self asParameter
		x: aPoint x
		y: aPoint y
		color: anARGB argbCode!

resolution: aPoint
	"Set  the horizontal and vertical DPI of the receiver to those specified by the <point> argument."

	Gdip
		gdipBitmapSetResolution: self asParameter
		xdpi: aPoint x
		ydpi: aPoint y!

unlockBits: lockedBitmapData
	Gdip gdipBitmapUnlockBits: self handle lockedBitmapData: lockedBitmapData! !

!Graphics.Gdiplus.Bitmap categoriesForMethods!
asBitmap!converting!public! !
asIcon!converting!public! !
cloneFormat:!copying!public! !
cloneRectangle:!copying!public! !
cloneRectangle:format:!copying!public! !
initializerClass!private!realizing/unrealizing! !
lockBits:!accessing!public! !
lockBits:flags:!accessing!public! !
lockBits:flags:format:!accessing!public! !
mimeType!public! !
pixelAt:!accessing!public! !
pixelAt:put:!accessing!public! !
resolution:!accessing!public! !
unlockBits:!accessing!public! !
!

!Graphics.Gdiplus.Bitmap class methodsFor!

extent: aPoint
	"Creates a Bitmap object of a specified size with the default pixel format PixelFormat32bppARGB."

	^self width: aPoint x height: aPoint y!

extent: aPoint format: aPixelFormat
	"Creates a Bitmap object of a specified size and PixelFormat."

	^self
		width: aPoint x
		height: aPoint y
		format: aPixelFormat!

fromBitmap: aBitmap
	"Creates a Bitmap object based on a handle to a Microsoft® Windows®
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

	"The gdipCloneBitmapArea API seems to be rather slow; directly drawing the area into a new bitmap takes about half as long, although the result will not be persistable."

	| bitmap extent |
	extent := aRectangle extent.
	bitmap := self extent: extent.
	bitmap graphics
		drawImage: aGdiplusImage
			at: Point.Zero
			extent: extent
			from: aRectangle origin
			extent: extent;
		free.
	^bitmap!

fromImage: aGdiplusImage extent: aPoint
	"Answer an instance of the receiver based on aGdiplusImage sized to extent aPoint."

	| bitmap |
	bitmap := self extent: aPoint.
	bitmap graphics
		interpolationMode: InterpolationModeHighQualityBicubic;
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
	^self fromBitmap: (Graphics.Bitmap fromView: aView)
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

!Graphics.Gdiplus.Bitmap class categoriesForMethods!
extent:!instance creation!public! !
extent:format:!instance creation!public! !
fromBitmap:!instance creation!public! !
fromByteArray:!instance creation!public! !
fromFile:usingLocator:!instance creation!public! !
fromIcon:!instance creation!public! !
fromImage:centeredIn:!instance creation!public! !
fromImage:crop:!instance creation!public! !
fromImage:extent:!instance creation!public! !
fromImage:scaledBy:!instance creation!public! !
fromIStream:!instance creation!public! !
fromView:!instance creation!public! !
new!instance creation!public! !
width:height:!instance creation!public! !
width:height:format:!instance creation!public! !
!

