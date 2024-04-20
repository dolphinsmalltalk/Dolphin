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
			[in] GpRect* rect,
			[in] unsigned int flags,
			[in] int format,
			[out, retval] GpBitmapData* lockedBitmapData);

	<stdcall: sdword GdipBitmapLockBits  handle GpRect* dword sdword GpBitmapData*>
	^self invalidCall"!

pixelAt: aPoint
	"Answer an ARGB that is the color of the receiver at aPoint."

	| status color |
	color := ByteArray newFixed: 4.
	status := GdiplusLibrary default
				gdipBitmapGetPixel: self asParameter
				x: aPoint x
				y: aPoint y
				color: color.
	status == Ok ifFalse: [GdiplusError signal: 'GdipBitmapGetPixel  failed' with: status].
	^Color fromArgbCode: (color dwordAtOffset: 0)!

pixelAt: aPoint put: anARGB 
	"Set the pixel at aPoint to be anARGB"

	| status |
	status := GdiplusLibrary default 
				gdipBitmapSetPixel: self asParameter
				x: aPoint x
				y: aPoint y
				color: anARGB argbCode.
	status = Ok ifFalse: [GdiplusError signal: 'GdipBitmapSetPixel  failed' with: status]!

resolution: aPoint
	"Set  the horizontal and vertical DPI of the receiver to those specified by the <point> argument."

	| status |
	(status := GdiplusLibrary default
				gdipBitmapSetResolution: self asParameter
				xdpi: aPoint x
				ydpi: aPoint y) == Ok
		ifFalse: [GdiplusError signal: 'gdipBitmapSetResolution: failed' with: status]!

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
resolution:!accessing!public! !
unlockBits:!accessing!public! !
!

!GdiplusBitmap class methodsFor!

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
			at: Point.Zero
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

