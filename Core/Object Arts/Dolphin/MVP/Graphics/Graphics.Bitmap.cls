"Filed out from Dolphin Smalltalk"!

Graphics.Image
	subclass: #'Graphics.Bitmap'
	instanceVariableNames: 'hdc flags extent'
	classVariableNames: 'SharedBitmaps'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { '_Map3DColorsMask_Obsolete' -> 16r1. 'IsSharedMask' -> 16r2 }!

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
	32-bit integer in the ByteArray represents the red, green and blue values for a pixel. The value for
	blue is in the least significant byte, followed by the green and red bytes, with the high order
	byte of each 32-bits being unused."

	| bmi canvas ret height bits byteSize size width |
	canvas := Canvas withOwnedDC: (Gdi32 createCompatibleDC: nil).
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
	ret := Gdi32
				getDIBits: canvas asParameter
				hbm: self asParameter
				uStartScan: 0
				cScanLines: height
				lpvBits: bits
				lpbi: bmi
				uUsage: DIB_RGB_COLORS.
	(ret isZero or: [ret ~= height]) ifTrue: [Win32Error signal].
	^bits!

asIcon
	^Icon fromBitmap: self!

asSharedCopy
	"Looks to see if an identical copy of the receiver has already be stored in the SharedBitmaps
	cache. If so this shared copy is answered"

	^self class sharedCopyOf: self!

basicFree
	"Private - Must be sent to the receiver before it dies to avoid loss of a DC 
	and a large memory bitmap."

	self freeDC.
	super basicFree.
!

bitmapInfoStructClass
	^BITMAP!

cacheInfo
	"Private - Cache info about the receiver garnered from the bitmap itself."

	| bitmapInfo |
	bitmapInfo := self getInfo.
	extent := bitmapInfo extent.!

canvas
	"Answer a Canvas to access the bitmap"

	^Canvas withNonOwnedDC: self hdc!

clearCached
	"Private - Clear down the receiver's handles and cached info."
 
	super clearCached.
	hdc := nil.
	extent := nil!

copy
	"Answer a <Bitmap> which is a copy of the receiver (one which shares the identifier information, but not the bitmap handle itself)."

	^(initializer isPersistent or: [handle isNull])
		ifTrue: [super copy]
		ifFalse: [self copyBits]!

copyBits
	"Private - Answer a <Bitmap> which is a copy of the receiver, made by copying the
	actual bits of the bitmap."

	| copy size hadDC |
	size := self extent.
	hadDC := hdc notNil.
	copy := self class compatible: self canvas extent: size.
	copy canvas 
		drawBitmap: self
		at: Point.Zero
		extent: size
		from: Point.Zero
		extent: size
		rop: SRCCOPY.
	copy freeDC.
	hadDC ifFalse: [self freeDC].
	^copy!

createHandle
	"Private - Answer an external handle to the image represented by the receiver."

	extent := nil.
	^super createHandle!

createPalette
	"Private - Attempt the create an answer an HPALETTE for the receiver's palette.
	Answers nil if the receiver has no palette."

	| colors target lp |
	colors := self getColorTable.
	colors ifNil: [^nil].
	lp := LOGPALETTE newBuffer
				palVersion: 16r300;
				palNumEntries: colors size.
	"We have to convert from BGRs in the color table to RGBs for the palette"
	colors := colors bytes.
	target := lp bytes.
	1 to: colors size
		by: 4
		do: 
			[:i |
			target
				at: i + ##(LOGPALETTE._OffsetOf_palPalEntry + PALETTEENTRY._OffsetOf_peRed)
					put: (colors at: i + RGBQUAD._OffsetOf_rgbRed);
				at: i + ##(LOGPALETTE._OffsetOf_palPalEntry + PALETTEENTRY._OffsetOf_peGreen)
					put: (colors at: i + RGBQUAD._OffsetOf_rgbGreen);
				at: i + ##(LOGPALETTE._OffsetOf_palPalEntry + PALETTEENTRY._OffsetOf_peBlue) put: (colors at: i)].
	^Gdi32 createPalette: lp!

createWatermarkAlphaPercent: anInteger backcolor: aColor
	^self class initializer: (WatermarkBitmapInitializer
				image: self
				alphaPercent: anInteger
				backcolor: aColor)!

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

	^User32
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

erase
	"Clear the bitmap to solid white."

	self canvas fillRectangle: (RECTL extent: self extent) brush: Brush white!

extent
	"Answers the dimensions of the receiver in pixels"

	extent isNil ifTrue: [self cacheInfo].
	^extent!

freeDC
	"Free the receiver's cached memory DC.
	Implementation Note: The hdc is lazily created by #canvas so needs to be tested first."

	hdc ifNil: [^self].
	Gdi32 deleteDC: hdc.	"Ignore errors"
	hdc := nil!

getColorTable
	"Answer an array of RGBQUADs describing the palette in the receiver.
	Answer nil if the receiver has no color table"

	"At present this method is only available for DIBSections"

	^nil!

getInfo
	"Answers a bitmap information structure class containing details about the receiver."

	| bitmapInfo |
	bitmapInfo := self bitmapInfoStructClass newBuffer.
	self getData: bitmapInfo.
	^bitmapInfo!

getMap3DColors
	"Answer whether the receiver's colours will be mapped to suitable 3D ones when loaded in."

	^initializer isLoadMap3dColors!

hasAlpha
	"Answer whether the receiver has an alpha channel."

	#todo. "Work out how to determine this, if indeed it is possible. Otherwise an explicit flag will be needed"
	^false!

hdc
	^hdc
		ifNil: 
			[hdc := Gdi32 createCompatibleDC: nil.
			Gdi32 selectObject: hdc hgdiobj: self asParameter.
			hdc]!

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

pixelData
	"Answer a UInt32Array of the (A)RGB pixel data contained in the receiver. This simple but NOT FAST."

	| pixData n canvas ext |
	ext := self extent.
	pixData := UInt32Array new: ext x * ext y.
	n := 1.
	canvas := self canvas.
	0 to: ext x - 1
		do: 
			[:x |
			0 to: ext y - 1
				do: 
					[:y |
					pixData at: n put: (canvas getPixel: x @ y).
					n := n + 1]].
	self freeDC.
	^pixData!

setMap3DColors: aBoolean
	"Set whether the receiver's colours will be mapped to suitable 3D ones when loaded in."

	initializer isLoadMap3dColors: aBoolean!

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

!Graphics.Bitmap categoriesForMethods!
addToImageList:mask:!double dispatch!private! !
alphaBlendOn:at:!drawing-bitmaps!public! !
alphaBlendOn:at:extent:!drawing-bitmaps!public! !
alphaBlendOn:at:extent:from:!drawing-bitmaps!public! !
alphaBlendOn:at:extent:from:extent:!drawing-bitmaps!public! !
alphaBlendOn:at:extent:from:extent:blend:!drawing-bitmaps!public! !
asBitmap!public! !
asByteArray!converting!public! !
asIcon!public! !
asSharedCopy!converting!public! !
basicFree!private!realizing/unrealizing! !
bitmapInfoStructClass!constants!private! !
cacheInfo!helpers!private! !
canvas!accessing!public! !
clearCached!initializing!private! !
copy!copying!public! !
copyBits!copying!private! !
createHandle!private!realizing/unrealizing! !
createPalette!private!realizing/unrealizing! !
createWatermarkAlphaPercent:backcolor:!helpers!public! !
depth!accessing!public! !
detachHandle!accessing!public! !
drawDisabledOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:from:extent:!drawing-bitmaps!public! !
drawOn:at:extent:from:extent:rop:!drawing-bitmaps!public! !
drawOn:at:from:extent:!drawing-bitmaps!public! !
drawOn:at:from:extent:rop:!drawing-bitmaps!public! !
erase!drawing!public! !
extent!accessing!public! !
freeDC!public!realizing/unrealizing! !
getColorTable!accessing!public! !
getInfo!accessing!public! !
getMap3DColors!accessing!public! !
hasAlpha!public!testing! !
hdc!accessing!public! !
initialize!initializing!private! !
isShared!private!testing! !
isShared:!accessing!private! !
pixelData!accessing!public! !
setMap3DColors:!accessing!public! !
stbFixup:at:!binary filing!public! !
!

!Graphics.Bitmap class methodsFor!

blankInitializerClass
	^BitmapFromBlankInitializer!

bytesInitializerClass
	^BitmapFromBytesInitializer!

compatible: canvas extent: size
	"Answer a new instance of the receiver with suitable dimensions and
	available colours the same as canvas."

	^self compatible: canvas width: size x height: size y!

compatible: aCanvas width: widthInteger height: heightInteger
	"Answer a new instance of the receiver with the requested dimensions and available colours the same as those of the <Canvas>, aCanvas."

	^self fromOwnedHandle: (Gdi32
				createCompatibleBitmap: aCanvas asParameter
				nWidth: widthInteger
				nHeight: heightInteger)!

displayCompatibleWithExtent: aPoint
	"Answer a new instance of the receiver with suitable dimensions and
	available a colour depth compatible with the display."

	^self initializer: (DisplayCompatibleBitmapInitializer extent: aPoint)!

extent: aPoint
	^self extent: aPoint depth: 24!

extent: aPoint depth: depthInteger
	"Answers a DIBSection bitmap of the specified dimensions and colour depth. The number of colour bits per pixel are given by depthInteger, which must be one of 1,4,8,16,24 or 32."

	^self initializer: (self blankInitializerClass extent: aPoint depth: depthInteger)!

extent: aPoint depth: depthInteger planes: planesInteger
	"Answers a DIBSection bitmap of the specified dimensions and colour depth. The number of colour bits per pixel are given by depthInteger, which must be one of 1,4,8,16,24 or 32."

	^self initializer: (self blankInitializerClass
				extent: aPoint
				depth: depthInteger
				planes: planesInteger)!

filesType
	"Private - Answer a two element array suitable for adding to the FileDialog
	with the fileTypes: message."

	^#('Bitmap Files (*.bmp;*.dib;*.rle)' '*.bmp;*.dib;*.rle')!

fromId: anIntegerOrStringId inFile: aString
	"Answer a new instance with a resourceID of anIntegerOrStringId
	from the resource library with the path, aString."

	^self fromId: anIntegerOrStringId inFile: aString flags: LR_COLOR!

fromId: anIntegerOrStringId inFile: aString flags: anInteger
	"Answer a new instance with a resourceID of anIntegerOrStringId
	from the resource library with the path, aString, and the LR_XXX
	flags in anInteger."

	| bitmap |
	bitmap := self fromId: anIntegerOrStringId in: (External.ResourceLibrary open: aString).
	bitmap flags: anInteger.
	^bitmap!

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

imageType
	"Private - Answer the Win32 image type for the receiver."

	^IMAGE_BITMAP!

initialize
	"Private - Initialize the receiver's class variables
		Bitmap initialize
	"

	SharedBitmaps := WeakLookupTable new!

new
	^self extent: 0 @ 0 depth: 1!

sharedCopyOf: aBitmap
	"Answers a cached copy of aBitmap if one has already been loaded from the same
	identifier. This can help save memory if the bitmap is not intended to be modified, 
	e.g. if it contains toolbar button images."

	^SharedBitmaps at: aBitmap initializer ifAbsentPutClean: [aBitmap isShared: true. aBitmap]!

stbConvertFromVersion0: anArray
	"Private - Convert from version 0 Bitmap. 
	Version 1 adds a caching inst var for the extent to avoid having to keep querying 
	the BITMAPINFOHEADER."

	^self stbConvertFromVersion1: (anArray copyWith: nil)!

stbConvertFromVersion1: anArray
	"Private - Convert from version 1 Bitmaps. 
	Version 2 converts flags from a boolean to a Map3DColorsMask"

	anArray at: 6 put: ((anArray at: 6) ifTrue: [_Map3DColorsMask_Obsolete] ifFalse: [0]).
	^self stbConvertFromVersion2: anArray!

stbConvertFromVersion3: anArray
	"Private - Version 4 replaces the identifier, fileLocator and instanceHandle instance variables with initializers.
	The Map3DColorsMask flag is transferred to the initializer as the LR_LOADMAP3DCOLORS flag."

	| vars initializer flags |
	vars := super stbConvertFromVersion3: anArray.
	flags := vars at: 5.
	vars at: 5 put: (flags bitAnd: IsSharedMask).
	initializer := vars at: 3.
	(flags allMask: _Map3DColorsMask_Obsolete) ifTrue: [initializer flag: LR_LOADMAP3DCOLORS set: true].
	^vars!

width: widthInteger height: heightInteger depth: depthInteger
	"Answer a new instance of the receiver of extent (widthInteger, heightInteger), and the
	colour depth specified by the number of bits per pixel, depthInteger."

	^self extent: widthInteger @ heightInteger depth: depthInteger!

width: widthInteger height: heightInteger depth: depthInteger planes: planesInteger
	"Answer a new instance of the receiver of extent (widthInteger, heightInteger), the colour depth specified by the number of bits per pixel, depthInteger, and the number of planes specified by planesInteger. "

	^self initializer: (self blankInitializerClass
				extent: widthInteger @ heightInteger
				depth: depthInteger
				planes: planesInteger)!

width: widthInteger height: heightInteger planes: planesInteger bitsPerPixel: bpsInteger bits: byteObject
	"Answer a new instance of the receiver with suitable dimensions and the bits in or pointed at by the byteObject argument, which might typically be a <ByteArray> or an <ExternalAddress>."

	^self initializer: (self bytesInitializerClass
				extent: widthInteger @ heightInteger
				depth: bpsInteger
				planes: planesInteger
				bytes: byteObject)! !

!Graphics.Bitmap class categoriesForMethods!
blankInitializerClass!constants!private! !
bytesInitializerClass!constants!private! !
compatible:extent:!instance creation!public! !
compatible:width:height:!instance creation!public! !
displayCompatibleWithExtent:!instance creation!public! !
extent:!instance creation!public! !
extent:depth:!instance creation!public! !
extent:depth:planes:!instance creation!public! !
filesType!constants!private! !
fromId:inFile:!instance creation!public! !
fromId:inFile:flags:!instance creation!public! !
fromView:!instance creation!public! !
fromView:background:!instance creation!public! !
imageType!constants!private! !
initialize!development!initializing!private! !
new!instance creation!public! !
sharedCopyOf:!instance creation!public! !
stbConvertFromVersion0:!binary filing!private! !
stbConvertFromVersion1:!binary filing!private! !
stbConvertFromVersion3:!binary filing!private! !
width:height:depth:!instance creation!public! !
width:height:depth:planes:!instance creation!public! !
width:height:planes:bitsPerPixel:bits:!instance creation!public! !
!

