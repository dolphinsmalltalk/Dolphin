"Filed out from Dolphin Smalltalk 7"!

Graphics.Image subclass: #'Graphics.Bitmap'
	instanceVariableNames: 'hdc flags extent'
	classVariableNames: 'SharedBitmaps'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'IsSharedMask' -> 16r2.
		'Map3DColorsMask' -> 16r1
	}!
Graphics.Bitmap guid: (Core.GUID fromString: '{87b4c63d-026e-11d3-9fd7-00a0cc3e4a32}')!
Graphics.Bitmap comment: 'Bitmap is the class of <Image>s that represent Windows'' device-dependent Bitmaps.

Instance Variables:
	hdc		<Canvas>. A cached canvas into which the bitmap has been selected.
	flags	<integer>. Various flags.
	extent	<Point>. Size of the bitmap.

Class Variables:
	SharedBitmaps		<WeakLookupTable>
	Map3DColorsMask	<integer>
	IsSharedMask		<integer>

'!
!Graphics.Bitmap categoriesForClass!Graphics-Tools! !
!Graphics.Bitmap methodsFor!

addToImageList: aWinImageList mask: aColorOrNil
	"Private - Add a pictorial representation of the receiver to aWinImageList."

	^aWinImageList addBitmap: self mask: aColorOrNil!

alphaBlendOn: aCanvas at: dstOrigin
	^self alphaBlendOn: aCanvas at: dstOrigin extent: self extent
!

alphaBlendOn: aCanvas at: dstOrigin extent: dstExtent 
	^self 
		alphaBlendOn: aCanvas
		at: dstOrigin
		extent: dstExtent
		from: 0 @ 0!

alphaBlendOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin 
	^self 
		alphaBlendOn: aCanvas
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: self extent!

alphaBlendOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent
	| blend |
	blend := BLENDFUNCTION new.
	blend
		blendPercentage: 100;
		usePerPixelAlpha: true.
	^self
		alphaBlendOn: aCanvas
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		blend: blend!

alphaBlendOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent blend: blendFunction
	"Alpha blend the specified rectangle of the receiver to the specified destination
	rectangle with the specified raster op. The receiver is stretched to
	fit the destination rectangle. Answers zero if the operation fails"

	^aCanvas alphaBlendBitmap: self 
		at: dstOrigin 
		extent: dstExtent 
		from: srcOrigin 
		extent: srcExtent 
		blend: blendFunction
!

asBitmap
	^self!

asByteArray
	"Answer a <ByteArray> representing the bits of the receiver in top-down 32bpp RGB form. Each
	DWORD in the ByteArray represents the red, green and blue values for a pixel. The value for
	blue is in the least significant byte, followed by the green and red bytes, with the high order
	byte of each DWORD being unused."

	| bmi canvas ret height bits byteSize size width |
	canvas := Canvas withOwnedDC: (GDILibrary default createCompatibleDC: nil).
	self freeDC.
	size := self extent.
	height := size y.
	width := size x.
	byteSize := 4 * width * height.
	bmi := BITMAPINFO new.
	bmi bmiHeader
		biWidth: width;
		biHeight: -1 * height;
		biPlanes: 1;
		biBitCount: 32;
		biCompression: BI_RGB;
		biSizeImage: byteSize.
	bits := ByteArray newFixed: byteSize.
	ret := GDILibrary default
				getDIBits: canvas asParameter
				hbm: self asParameter
				uStartScan: 0
				cScanLines: height
				lpvBits: bits
				lpbi: bmi
				uUsage: DIB_RGB_COLORS.
	(ret isZero or: [ret ~= height]) ifTrue: [Win32Error signal].
	^bits!

asSharedCopy
	"Looks to see if an identical copy of the receiver has already be stored in the SharedBitmaps
	cache. If so this shared copy is answered"

	^self class sharedCopyOf: self!

baseLoadFlags
	"Answer the basic load flags to be used when calling LoadImage() to realize the receiver."

	^LR_COLOR!

basicFree
	"Private - Must be sent to the receiver before it dies to avoid loss of a DC 
	and a large memory bitmap."

	self freeDC.
	super basicFree.
!

cacheInfo
	"Private - Cache info about the receiver garnered from the bitmap itself."

	| bitmapInfo |
	bitmapInfo := self getInfo.
	extent := bitmapInfo extent.!

canvas
	"Answer a Canvas to access the bitmap"

	hdc isNil
		ifTrue: 
			[hdc := GDILibrary default createCompatibleDC: nil.
			GDILibrary default selectObject: hdc hgdiobj: self asParameter].
	^Canvas withNonOwnedDC: hdc!

clearCached
	"Private - Clear down the receiver's handles and cached info."
 
	super clearCached.
	hdc := nil.
	"We don't always clear down the extent, because it may not be cached 
	 information, but have been set by the instantiator. However if loading
	 from an external resource we need to consider the possibility that
	 the bitmap has been changed in the meantime."
	self identifier isNil ifFalse: [extent := nil]!

copy
	"Answer a <Bitmap> which is a copy of the receiver (one which shares the identifier
	information, but not the bitmap handle itself)."

	^(self identifier isNil and: [handle notNull])
		ifTrue: [self copyBits]
		ifFalse: [super copy]!

copyBits
	"Private - Answer a <Bitmap> which is a copy of the receiver, made by copying the
	actual bits of the bitmap."

	| copy size hadDC |
	size := self extent.
	hadDC := hdc notNil.
	copy := self class compatible: self canvas extent: size.
	copy canvas 
		drawBitmap: self
		at: 0 @ 0
		extent: size
		from: 0 @ 0
		extent: size
		rop: SRCCOPY.
	copy freeDC.
	hadDC ifFalse: [self freeDC].
	^copy!

copyToClipboard
	"Copy the receiver to the clipboard."

	UI.Clipboard current setBitmap: self!

createPalette
	"Private - Attempt the create an answer an HPALETTE for the receiver's palette.
	Answers nil if the receiver has no palette."

	^self getColorTable
		ifNotNil: 
			[:colors |
			| lp palEntries len |
			lp := LOGPALETTE new.
			lp palVersion: 16r300.
			palEntries := lp palPalEntry.
			self assert: [colors byteSize <= palEntries byteSize].
			"Just assign it over directly"
			len := palEntries size min: colors size.
			palEntries
				replaceFrom: 1
				to: len
				with: colors
				startingAt: 1.
			palEntries length: len.
			lp palNumEntries: len.
			GDILibrary default createPalette: lp]!

createWatermarkAlphaPercent: percent backcolor: backcolor
	| blend combined transparentColor mask rect watermark hasAlpha |
	transparentColor := self canvas pixelAt: 0 @ 0.
	rect := 0 @ 0 extent: self extent.
	"Create the watermark image by fading the source bitmap"
	watermark := Bitmap displayCompatibleWithExtent: self extent.
	watermark canvas
		backcolor: backcolor;
		erase.
	blend := BLENDFUNCTION new.
	hasAlpha := self hasAlpha.
	blend
		blendPercentage: percent;
		usePerPixelAlpha: hasAlpha.
	self
		alphaBlendOn: watermark canvas
		at: 0 @ 0
		extent: self extent
		from: 0 @ 0
		extent: self extent
		blend: blend.
	hasAlpha ifTrue: [^watermark].
	"If no alpha channel, we must do our own masking, so create a monochrome AND mask bitmap"
	mask := Bitmap
				width: self extent x
				height: self extent y
				depth: 1.
	mask canvas
		backcolor: transparentColor;
		bitBlt: self canvas
			rectangle: rect
			to: 0 @ 0
			rop: SRCCOPY.
	self free.
	"Mask out the transparent areas of the image (i.e. those in the transparent colour)"
	watermark canvas
		backcolor: Color black;
		forecolor: Color white;
		bitBlt: mask canvas
			rectangle: rect
			to: 0 @ 0
			rop: SRCAND.

	"Now use the mask to paint the background colour in the transparent areas"
	combined := Bitmap displayCompatibleWithExtent: self extent.
	combined canvas
		backcolor: backcolor;
		bitBlt: mask canvas
			rectangle: rect
			to: 0 @ 0
			rop: MERGECOPY.
	mask free.
	"Finally combine background and image"
	combined canvas
		bitBlt: watermark canvas
		rectangle: rect
		to: 0 @ 0
		rop: SRCPAINT.
	watermark free.
	self freeDC.
	combined freeDC.
	^combined!

depth
	"Answer the color depth (number of bits per pixel) of the receiver.
	At this level, this information is not cached."

	^self getInfo depth!

detachHandle
	"Answer the receiver's handle, and if owned, relinquish ownership
	to the caller."

	self freeDC.
	^super detachHandle!

drawDisabledOn: aCanvas at: aPoint extent: sizePoint
	"Draw a disabled/grayed representation of the receiver on aCanvas at aPoint with extent sizePoint."

	^UserLibrary default
		drawState: aCanvas asParameter
		hbr: nil
		lpOutputFunc: nil
		lData: self asParameter asInteger
		wData: 0
		x: aPoint x
		y: aPoint y
		cx: sizePoint x
		cy: sizePoint y
		fuFlags: ##(DST_BITMAP | DSS_DISABLED)!

drawOn: aCanvas at: dstOrigin extent: dstExtent
	"Copies the receiver to aCanvas at the position specified by the Point, dstOrigin,
	and the with size specified by the Point, dstExtent. The receiver is stretched
	to fit the destination rectangle."

	^self
		drawOn: aCanvas
		at: dstOrigin
		extent: dstExtent
		from: Point.Zero
		extent: self extent
		rop: SRCCOPY!

drawOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent
	"Copies the specified rectangle of the receiver to the specified destination
	rectangle. The specified source rectangle of the receiver is stretched to fit
	the specified destination rectangle of the canvas."

	^self 
		drawOn: aCanvas 
		at: dstOrigin 
		extent: dstExtent 
		from: srcOrigin
		extent: srcExtent 
		rop: SRCCOPY!

drawOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent rop: dwRasterOp
	"Draw the specified rectangle of the receiver to the specified destination
	rectangle with the specified raster op. The receiver is stretched to
	fit the destination rectangle. Answers zero if the operation fails"

	^aCanvas drawBitmap: self 
		at: dstOrigin 
		extent: dstExtent 
		from: srcOrigin 
		extent: srcExtent 
		rop: dwRasterOp
!

drawOn: aCanvas at: dstOrigin from: srcOrigin extent: srcExtent
	"BitBlt (without stretching) the specified rectangle of the receiver to the 
	specified destination point, using the specified raster Op."

	^self 
		drawOn: aCanvas 
		at: dstOrigin
		extent: srcExtent
		from: srcOrigin
		extent: srcExtent
		rop: SRCCOPY!

drawOn: aCanvas at: dstOrigin from: srcOrigin extent: srcExtent rop: dwROP
	"BitBlt (without stretching) the specified rectangle of the receiver to the 
	specified destination point, using the specified raster Op."

	^self 
		drawOn: aCanvas 
		at: dstOrigin
		extent: srcExtent
		from: srcOrigin
		extent: srcExtent
		rop: dwROP.

!

extent
	"Answers the dimensions of the receiver in pixels"

	extent isNil ifTrue: [self cacheInfo].
	^extent!

freeDC
	"Private - Free the receiver's cached memory DC.
	Implementation Note: The hdc is lazily created by #canvas so needs to be tested first."

	hdc isNil ifTrue: [^self].
	GDILibrary default deleteDC: hdc.	"Ignore errors"
	hdc := nil!

getColorTable
	"Answer an array of RGBQUADs describing the palette in the receiver.
	Answer nil if the receiver has no color table"

	"At present this method is only available for DIBSections"

	^nil!

getInfo
	"Answers a bitmap information structure class containing details about the receiver."

	| bitmapInfo |
	bitmapInfo := BITMAP new.
	self getData: bitmapInfo.
	^bitmapInfo!

getMap3DColors
	"Answer whether the receivers colours will be mapped to suitable 3D ones
	when loaded in."

	^flags allMask: Map3DColorsMask.!

getPaletteEntries
	"Answer a <StructureArray> of <PALETTEENTRY>s describing the receiver's colour palette."

	| len colors palEntries |
	colors := self getColorTable ?? #().
	len := colors size.
	palEntries := StructureArray length: len elementClass: PALETTEENTRY.
	palEntries beUnfinalizable.
	palEntries
		replaceFrom: 1
		to: len
		with: colors
		startingAt: 1.
	^palEntries!

hasAlpha
	"Answer whether the receiver has an alpha channel."

	#todo. "Work out how to determine this, if indeed it is possible. Otherwise an explicit flag will be needed"
	^false!

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_BITMAP!

initialize
	"Private - Initialize the state of the receiver."

	super initialize.
	flags := 0.!

isShared
	"Private - Answer true if the receiver is in the shared cache"

	^flags allMask: IsSharedMask.!

isShared: aBoolean
	"Private - Sets the flag to indicate that the receiver is in the shared cache"

	flags := flags mask: IsSharedMask set: aBoolean
!

isTransparent
	"Answer whether the receiver will be, or was, loaded as a 'transparent' bitmap
	(that is with the LR_LOADTRANSPARENT flag)."

	^flags allMask: LR_LOADTRANSPARENT.!

isTransparent: aBoolean 
	"Set whether the receiver will be loaded as a 'transparent' bitmap
	(that is with the LR_LOADTRANSPARENT flag). If the bitmap is already
	realized then this has no effect."

	flags := flags mask: LR_LOADTRANSPARENT set: aBoolean!

loadFlags
	| fuLoad |
	fuLoad := self baseLoadFlags.
	self getMap3DColors ifTrue: [fuLoad := fuLoad bitOr: LR_LOADMAP3DCOLORS].
	^fuLoad bitOr: (flags bitAnd: ##((LR_LOADTRANSPARENT - 1) bitInvert))
!

loadFromFile: pathString extent: anObject
	"Private - Attempts to load the receiver from a disk file
	Answers the bitmap's handle, or nil if the image could not be loaded."

	| fuLoad |
	fuLoad := self baseLoadFlags bitOr: LR_LOADFROMFILE.
	self getMap3DColors ifTrue: [fuLoad := fuLoad bitOr: LR_LOADMAP3DCOLORS].
	^UserLibrary default
		loadImage: 0
		lpszName: pathString asResourceId
		uType: self imageType
		cxDesired: 0
		cyDesired: 0
		fuLoad: fuLoad!

loadFromInstance: hModule
	"Private - Attempts to load the receiver as a resource from an instance.
	Answers the bitmaps handle, or nil if the bitmap could not be loaded."

	extent := nil.	"Any old cached extent may be invalid and no longer match the loaded resource."
	^UserLibrary default
		loadImage: hModule asParameter
		lpszName: identifier asResourceId
		uType: self imageType
		cxDesired: 0
		cyDesired: 0
		fuLoad: self loadFlags!

pixelData
	"Answer a DWORDArray of the (A)RGB pixel data contained in the receiver. This simple but NOT FAST."

	| pixData n canvas |
	pixData := DWORDArray new: self extent x * self extent y.
	n := 1.
	canvas := self canvas.
	0 to: self extent x - 1
		do: 
			[:x |
			0 to: self extent y - 1
				do: 
					[:y |
					pixData at: n put: (canvas getPixel: x @ y).
					n := n + 1]].
	self freeDC.
	^pixData!

setMap3DColors: aBoolean
	"Set whether the receivers colours will be mapped to suitable 3D ones
	when loaded in."

	flags := flags mask: Map3DColorsMask set: aBoolean.!

stbFixup: anSTBInFiler at: newObjectIndex
	"Answer the true object that must be used to represent the receiver when read from anSTBInFiler.
	If the receiver is flagged as being shared then make sure we answer a shared instance and
	patch the in-filer read map to use that shared instance for any other references."

	| answer |
	answer := super stbFixup: anSTBInFiler at: newObjectIndex.
	self isShared 
		ifTrue: 
			[answer := self asSharedCopy.
			anSTBInFiler fixup: newObjectIndex to: answer].
	^answer! !
!Graphics.Bitmap categoriesFor: #addToImageList:mask:!double dispatch!private! !
!Graphics.Bitmap categoriesFor: #alphaBlendOn:at:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #alphaBlendOn:at:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #alphaBlendOn:at:extent:from:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #alphaBlendOn:at:extent:from:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #alphaBlendOn:at:extent:from:extent:blend:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #asBitmap!public! !
!Graphics.Bitmap categoriesFor: #asByteArray!converting!public! !
!Graphics.Bitmap categoriesFor: #asSharedCopy!converting!public! !
!Graphics.Bitmap categoriesFor: #baseLoadFlags!constants!public! !
!Graphics.Bitmap categoriesFor: #basicFree!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #cacheInfo!helpers!private! !
!Graphics.Bitmap categoriesFor: #canvas!accessing!public! !
!Graphics.Bitmap categoriesFor: #clearCached!initializing!private! !
!Graphics.Bitmap categoriesFor: #copy!copying!public! !
!Graphics.Bitmap categoriesFor: #copyBits!copying!private! !
!Graphics.Bitmap categoriesFor: #copyToClipboard!copying!public! !
!Graphics.Bitmap categoriesFor: #createPalette!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #createWatermarkAlphaPercent:backcolor:!helpers!public! !
!Graphics.Bitmap categoriesFor: #depth!accessing!public! !
!Graphics.Bitmap categoriesFor: #detachHandle!accessing!public! !
!Graphics.Bitmap categoriesFor: #drawDisabledOn:at:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #drawOn:at:extent:from:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #drawOn:at:extent:from:extent:rop:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #drawOn:at:from:extent:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #drawOn:at:from:extent:rop:!drawing-bitmaps!public! !
!Graphics.Bitmap categoriesFor: #extent!accessing!public! !
!Graphics.Bitmap categoriesFor: #freeDC!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #getColorTable!accessing!public! !
!Graphics.Bitmap categoriesFor: #getInfo!accessing!public! !
!Graphics.Bitmap categoriesFor: #getMap3DColors!accessing!public! !
!Graphics.Bitmap categoriesFor: #getPaletteEntries!accessing!public! !
!Graphics.Bitmap categoriesFor: #hasAlpha!public!testing! !
!Graphics.Bitmap categoriesFor: #imageType!constants!private! !
!Graphics.Bitmap categoriesFor: #initialize!initializing!private! !
!Graphics.Bitmap categoriesFor: #isShared!private!testing! !
!Graphics.Bitmap categoriesFor: #isShared:!accessing!private! !
!Graphics.Bitmap categoriesFor: #isTransparent!accessing!public! !
!Graphics.Bitmap categoriesFor: #isTransparent:!accessing!public! !
!Graphics.Bitmap categoriesFor: #loadFlags!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #loadFromFile:extent:!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #loadFromInstance:!private!realizing/unrealizing! !
!Graphics.Bitmap categoriesFor: #pixelData!accessing!public! !
!Graphics.Bitmap categoriesFor: #setMap3DColors:!accessing!public! !
!Graphics.Bitmap categoriesFor: #stbFixup:at:!binary filing!public! !

!Graphics.Bitmap class methodsFor!

compatible: canvas extent: size
	"Answer a new instance of the receiver with suitable dimensions and
	available colours the same as canvas."

	^self compatible: canvas width: size x height: size y!

compatible: canvas width: width height: height
	"Answer a new instance of the receiver with suitable dimensions and
	available colours the same as canvas."

	^self fromOwnedHandle: (GDILibrary default
				createCompatibleBitmap: canvas asParameter
				nWidth: width
				nHeight: height)!

displayCompatibleWithExtent: aPoint
	"Answer a new instance of the receiver with suitable dimensions and
	available a colour depth compatible with the display."

	| answer canvas |
	canvas := Canvas forDisplay.
	answer := self 
				compatible: canvas
				width: aPoint x
				height: aPoint y.
	canvas free.
	^answer!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Bitmap Files (*.bmp)' '*.bmp')!

fromId: anIntegerOrStringId inFile: aString
	"Answer a new instance with a resourceID of anIntegerOrStringId
	from the resource library with the path, aString."

	^self fromId: anIntegerOrStringId inFile: aString flags: LR_COLOR!

fromId: anIntegerOrStringId inFile: aString flags: anInteger
	"Answer a new instance with a resourceID of anIntegerOrStringId
	from the resource library with the path, aString, and the LR_XXX
	flags in anInteger."

	| reslib icon |
	reslib := External.ResourceLibrary open: aString.
	icon := self fromOwnedHandle: (UserLibrary default
						loadImage: reslib asParameter
						lpszName: anIntegerOrStringId asResourceId
						uType: IMAGE_BITMAP
						cxDesired: 0
						cyDesired: 0
						fuLoad: anInteger).
	icon instanceHandle: reslib handle.
	^icon!

fromView: aView
	"Answer a new bitmap instance of the receiver containing a dump of the current state of the 
	<View> argument."

	^self fromView: aView background: Brush white!

fromView: aView background: aBrush
	"Answer a new bitmap instance of the receiver containing a dump of the current state of the <View> argument, painted over the top of a bitmap erased with the specified background brush.
	In most cases Views are opaque and the background pattern will not be visible at all, but for transparent views with any transparency this will show through."

	| answer canvas ext |
	ext := aView extent.
	answer := self displayCompatibleWithExtent: ext.
	canvas := answer canvas.
	canvas fillRectangle: (RECTL extent: ext) brush: aBrush.
	aView
		sendMessage: WM_PRINT
		wParam: canvas handle
		lParam: ##(PRF_CLIENT | PRF_ERASEBKGND | PRF_CHILDREN | PRF_NONCLIENT | PRF_OWNED).
	answer freeDC.
	^answer!

initialize
	"Private - Initialize the receiver's class variables
		Bitmap initialize
	"

	SharedBitmaps := WeakLookupTable new!

sharedCopyOf: aBitmap
	"Answers a cached copy of aBitmap if one has already been loaded from the same
	identifier. This can help save memory if the bitmap is not intended to be modified, 
	e.g. if it contains toolbar button images."

	^SharedBitmaps at: aBitmap fullIdentifier ifAbsentPutClean: [aBitmap isShared: true. aBitmap]!

stbConvertFrom: anSTBClassFormat
	"Convert from version 0 Bitmap. 
	Version 1 adds a caching inst var for the extent to avoid having to keep querying 
	the BITMAPINFOHEADER.. 
	Version 2  converts flags from a boolean to a Map3DColorsMask.
	Version 3 adds Image>>locator instance variable"

	^
	[:data |
	| newInstance |
	newInstance := self basicNew.
	1 to: data size do: [:i | newInstance instVarAt: i put: (data at: i)].
	anSTBClassFormat version < 3
		ifTrue: 
			[data size to: 1
				by: -1
				do: 
					[:i |
					| offset |
					offset := i <= 2 ifTrue: [0] ifFalse: [1].
					newInstance instVarAt: i + offset put: (newInstance instVarAt: i)].
			newInstance fileLocator: FileLocator default].
	anSTBClassFormat version < 2
		ifTrue: 
			[| isMap3D |
			isMap3D := newInstance instVarAt: 7.
			newInstance instVarAt: 7 put: 0.
			newInstance setMap3DColors: isMap3D].
	newInstance]!

width: widthInteger height: heightInteger depth: depthInteger 
	"Answer a new instance of the receiver of extent (widthInteger, heightInteger), and the
	colour depth specified by the number of bits per pixel, depthInteger."

	^self 
		width: widthInteger
		height: heightInteger
		planes: 1
		bitsPerPixel: depthInteger
		bits: nil!

width: widthInteger height: heightInteger planes: planesInteger bitsPerPixel: bpsInteger bits: anExternalAddressOrNil
	"Answer a new instance of the receiver with suitable dimensions."

	^self fromOwnedHandle: (GDILibrary default
				createBitmap: widthInteger
				nHeight: heightInteger
				cPlanes: planesInteger
				cBitsPerPel: bpsInteger
				lpvBits: anExternalAddressOrNil)! !
!Graphics.Bitmap class categoriesFor: #compatible:extent:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #compatible:width:height:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #displayCompatibleWithExtent:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #filesType!constants!private! !
!Graphics.Bitmap class categoriesFor: #fromId:inFile:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #fromId:inFile:flags:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #fromView:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #fromView:background:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #initialize!development!initializing!private! !
!Graphics.Bitmap class categoriesFor: #sharedCopyOf:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #stbConvertFrom:!binary filing!public! !
!Graphics.Bitmap class categoriesFor: #width:height:depth:!instance creation!public! !
!Graphics.Bitmap class categoriesFor: #width:height:planes:bitsPerPixel:bits:!instance creation!public! !

