"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.GdiplusBase
	subclass: #'Graphics.Gdiplus.Image'
	instanceVariableNames: ''
	classVariableNames: 'DecodersByExtension DecodersByMimeType EncodersByExtension EncodersByMimeType'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Image guid: (Core.GUID fromString: '{00b83139-f011-4475-99dd-34afd09c2e06}')!
Graphics.Gdiplus.Image comment: 'GdiplusImage provides methods for loading and saving raster images (bitmaps) and vector images (metafiles).  Various methods are available to manipulate and display an image.  Different file types can be read from and saved to - see #encoderMimeTypes and #decoderMimeTypes.'!
!Graphics.Gdiplus.Image methodsFor!

addToImageList: aWinImageList mask: aColorOrNil
	"Add a pictorial representation of the receiver to aWinImageList scaled to the
	extent of the image list."

	| bitmap index extent |
	extent := aWinImageList extent.
	"The change to use a display compatible bitmap is for #2280"
	bitmap := (extent = self extent ifTrue: [self] ifFalse: [self class fromImage: self extent: extent])
				asBitmap.
	"We assume that the receiver contains transparency information so the mask color is ignored. Reference it to suppress warning of unref'd arg - the compiler will optimise this out."
	aColorOrNil.
	index := ComCtl32
				imageList_AddMasked: aWinImageList asParameter
				hbmImage: bitmap asParameter
				crMask: CLR_NONE.
	bitmap free.
	^index!

asBitmap
	"Answer a display-compatible <Bitmap> with the receiver's image."

	| bitmap |
	bitmap := Graphics.Bitmap displayCompatibleWithExtent: self extent.
	self drawOn: bitmap canvas.
	bitmap freeDC.
	^bitmap!

asByteArray: mimeString 
	"SW: OLEPicture>>saveAsFile locks the hGlobal (other uses don't) ... is that necessary?"

	^self asByteArray: mimeString compression: nil!

asByteArray: mimeString compression: anIntegerOrNil
	"SW: OLEPicture>>saveAsFile locks the hGlobal (other uses don't) ... is that necessary?"

	| pStream bytes |
	pStream := COM.IStream onHGLOBAL.
	self
		saveToIStream: pStream
		mimeType: mimeString
		encoderParams: (anIntegerOrNil isNil ifFalse: [self buildCompressionParameters: anIntegerOrNil]).
	bytes := pStream contents.
	pStream free.
	^bytes!

basicRotate: aRotateConstant
	"Rotate the receiver according to aRotateConstant."

	Gdip gdipImageRotateFlip: self asParameter rfType: aRotateConstant!

bounds
	"Answer the receiver's bounding rectangle.  Most images will have Point zero as the 
	upper-left corner, though a metafile may not, depending on the commands used to create it."

	| bounds rect |
	bounds := self getBounds.
	"Here we are assuming pels"
	self assert: bounds last = UnitPixel.
	rect := bounds first.
	^rect origin rounded corner: rect corner rounded!

buildCompressionParameters: anIntegerOrNil
	| quality params encoderParameter |
	params := EncoderParameters new.
	params Count: 1.
	(encoderParameter := params Parameter first)
		Guid: EncoderQuality;
		Type: EncoderParameterValueTypeLong;
		NumberOfValues: 1.
	quality := UInt32Bytes fromInteger: anIntegerOrNil.
	encoderParameter Value: quality yourAddress.
	"We have to ensure not to leave a dangling pointer to the parameter value"
	params valueBuffer: quality.
	^params!

clone
	"Answer a copy of the receiver."

	^super clone
		initializer: initializer copy;
		yourself!

copy
	"Answer a <GdiplusImage> which is a copy of the receiver.  
	NB:  If the receiver is realized, #clone should be faster."

	^handle notNull ifTrue: [self clone] ifFalse: [super copy]!

copyPropertiesFrom: anImage
	"Copy all <GpPropertyItem>s from anImage to the receiver.  Do not override any properties that already exist."

	anImage properties do: [:e | (self hasPropertyId: e id) ifFalse: [self property: e]]!

copyToClipboard
	"Copy the receiver to the system clipboard."

	self asBitmap copyToClipboard!

drawOn: aCanvas
	"Draw the receiver on aCanvas (no stretching)."

	self drawOn: aCanvas at: Point.Zero!

drawOn: aCanvas at: aPoint
	"Draw the receiver on aCanvas at position aPoint (no stretching)."

	self 
		drawOn: aCanvas
		at: aPoint
		extent: self extent!

drawOn: aCanvas at: dstOrigin extent: dstExtent
	"Draw the receiver on aCanvas at Point dstOrigin, and with size dstExtent. 
	The receiver is stretched to fit the destination rectangle."

	| graphics |
	(graphics := GdiplusGraphics fromCanvas: aCanvas)
		drawImage: self
		at: dstOrigin
		extent: dstExtent.
	graphics free!

drawOn: aCanvas at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent
	"Draw the portion of the receiver specified by srcOrigin and srcExtent to aCanvas at the rectangle 
	specified by dstOrigin and dstExtent. The receiver is stretched to fit the destination rectangle."

	(GdiplusGraphics fromCanvas: aCanvas)
		drawImage: self
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent!

drawOnGraphics: aGraphics at: dstOrigin extent: dstExtent from: srcOrigin extent: srcExtent unit: srcUnit attributes: anImageAttributes
	"Draw the portion of the receiver specified by srcOrigin and srcExtent to aGraphics at the rectangle 
	specified by dstOrigin and dstExtent. The receiver is stretched to fit the destination rectangle.
	srcUnit is the unit of measure for the source rectangle. imageAttributes specifies color adjustments."

	aGraphics 
		drawImage: self
		at: dstOrigin
		extent: dstExtent
		from: srcOrigin
		extent: srcExtent
		unit: srcUnit
		attributes: anImageAttributes!

encoderParameterList: aCLSID
	"Answer a list of the parameters supported by the image encoder specified by aCLSID."

	| size buffer |
	size := self encoderParameterListSize: aCLSID.
	buffer := EncoderParameters new: size.
	Gdip
		gdipGetEncoderParameterList: self asParameter
		clsidEncoder: aCLSID
		size: size
		buffer: buffer.
	^buffer!

encoderParameterListSize: aCLSID
	"Answer the size, in bytes, of the parameter list for the image encoder specified by aCLSID."

	| size |
	size := UInt32Bytes new.
	Gdip
		gdipGetEncoderParameterListSize: self asParameter
		clsidEncoder: aCLSID
		size: size.
	^size asInteger!

erase
	"Clear the image to solid white."

	| graphics |
	graphics := self graphics.
	graphics clear: Color white.
	graphics free!

extent
	"Answer a <Point> specifying the dimensions of the receiver in pixels."

	| buf width hImage |
	buf := UInt32Bytes new.
	hImage := self asParameter.
	Gdip gdipGetImageWidth: hImage width: buf.
	width := buf asInteger.
	Gdip gdipGetImageHeight: hImage height: buf.
	^width @ buf asInteger!

filename
	"Answer the <readableString> filename associated with the receiver.
	NB:  A GdiplusBitmap doesn't have a filename."

	^self initializer absoluteFilename!

flags
	"Answer an <Integer> specifying single-bit flags (attributes) of the receiver."

	| flags |
	flags := UInt32Bytes new.
	Gdip gdipGetImageFlags: self asParameter flags: flags.
	^flags asInteger!

flipX
	"Flip the receiver on the horizontal axis (i.e., a mirror image)."

	self basicRotate: RotateNoneFlipX!

flipY
	"Flip the receiver on the vertical axis (i.e., upside down)."

	self basicRotate: RotateNoneFlipY!

frameCount
	"Answer the number of frames in the receiver's first frame dimension."

	^self frameCount: self frameDimensionsList first!

frameCount: aFrameDimensionGUID
	"Answer the number of frames in the specified dimension of the receiver."

	| count |
	count := UInt32Bytes new.
	Gdip
		gdipImageGetFrameCount: self asParameter
		dimensionID: aFrameDimensionGUID asParameter
		count: count.
	^count asInteger!

frameDimension
	"Private - Answer the <GUID> associated with the receiver's filename, or nil.
	NB: This doesn't seem used.  Maybe deprecate it."

	self mimeType = 'image/gif' ifTrue: [^FrameDimensionTime].
	self mimeType = 'image/tiff' ifTrue: [^FrameDimensionPage].
	^nil!

frameDimensionsCount
	"Answer an Integer that is the number of frame dimensions in the receiver.  Most image files, 
	single- or multi-frame, have just 1, but they can have more."

	| count |
	count := UInt32Bytes new.
	Gdip gdipImageGetFrameDimensionsCount: self asParameter count: count.
	^count asInteger!

frameDimensionsList
	"Answer a collection of GUIDs that represent the receiver's frame dimensions."

	| guids |
	guids := StructureArray length: self frameDimensionsCount elementClass: GUID.
	Gdip
		gdipImageGetFrameDimensionsList: self asParameter
		dimensionIDs: guids
		count: guids size.
	^guids asArray!

frames
	"Answer an OrderedCollection of GdiplusImage that are the receiver's frames in the first frame dimension."

	| images bitmap |
	images := OrderedCollection new.
	0 to: self frameCount - 1
		do: 
			[:i |
			self selectActiveFrame: i.
			bitmap := Bitmap extent: self extent.
			bitmap graphics drawImage: self.
			images add: bitmap].
	^images!

freeDC
	"For compatibility with <Image>."!

getBounds
	"Private - Answer a 2-element array, the first element a bounding Rectangle, the second 
	element the UnitConstant that indicates the unit of measure for the bounding rectangle."

	| rect unit |
	rect := RectF new.
	unit := UInt32Bytes new.
	Gdip
		gdipGetImageBounds: self asParameter
		srcRect: rect
		srcUnit: unit.
	^{rect asRectangle. unit asSignedInteger}!

graphics
	"Answer a GdiplusGraphics instance based on the receiver."

	^GdiplusGraphics fromImage: self!

hasAlpha
	"Answer whether the image has an alpha channel."

	^self flags allMask: ImageFlagsHasAlpha!

hasDPI
	"Answer whether the image contains DPI information."

	^self flags allMask: ImageFlagsHasRealDPI!

hasPixelSize
	"Answer whether the image contains pixel size information."

	^self flags allMask: ImageFlagsHasRealPixelSize!

hasPropertyId: aPropertyTagConstant
	"Answer whether the receiver contains the GpPropertyItem specified by aPropertyTagConstant."

	^self propertyIdList includes: aPropertyTagConstant!

hasThumbnail
	"LAS:  This might not be useful.  I've seen images with no thumbnail data but with a 
	thumbnail width and height, indicating there's a thumbnail embedded, and I've seen 
	thumbnails with thumbnail data, but no thumbnail width or height."

	^self hasThumbnailData or: [self hasPropertyId: PropertyTagThumbnailWidth]!

hasThumbnailData
	"Answer whether the receiver contains its own thumbnail data."

	^self hasPropertyId: PropertyTagThumbnailData!

hasTranslucency
	"Answer whether there are any translucent pixels in the receiver (i.e. that have alpha other than 0 (completely transparent) or 255 (opaque)."

	^self flags allMask: ImageFlagsHasTranslucent!

height
	"Answer an <Integer> specifying the height of the receiver in pixels."

	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetImageHeight: self asParameter height: buf.
	^buf asInteger!

initializerClass
	"Answer the class of initializer usually associated with the receiver and which understands how to perform operations on the native Gdiplus objects such as disposing of them."

	^ImageInitializer!

isCMYK
	"Answer whether the image is using the CMYK colour space."

	^self flags allMask: ImageFlagsColorSpaceCMYK!

isGrayScale
	"Answer whether the image is a grey-scale image"

	^self flags allMask: ImageFlagsColorSpaceGRAY!

isLandscape
	"Answer whether the receiver is wider than its height."

	^self extent x > self extent y!

isPartiallyScalable
	"Answer whether the image allows for some scaling, even if not seamlessly scalable to any size."

	^self flags allMask: ImageFlagsPartiallyScalable!

isPortrait
	"Answer whether the receiver is narrower than its width."

	^self isLandscape not!

isReadOnly
	"Answer whether the image is read-only."

	^self flags allMask: ImageFlagsReadOnly!

isRGB
	"Answer whether the image is using the RGB colour space."

	^self flags allMask: ImageFlagsColorSpaceRGB!

isScalable
	"Answer whether the image is fully scalable (e.g. vector graphics)."

	^self flags allMask: ImageFlagsScalable!

isValid
	"Answer whether the receiver can be realized."

	^[self handle notNull] on: Error do: [:err | false]!

isYCBCR
	"Answer whether the image is using the YCBCR colour space."

	^self flags allMask: ImageFlagsColorSpaceYCBCR!

isYCCK
	"Answer whether the image is using the YCCK colour space."

	^self flags allMask: ImageFlagsColorSpaceYCCK!

mimeType
	"Answer the <readableString> mimeType of the filename associated with the receiver.
	NB:  Problem with this is that a GdiplusBitmap doesn't have a filename."

	^self class encoderMimeTypeForExtension: (File splitExtensionFrom: self filename)!

palette
	"Answer the receiver's color palette, a <ColorPalette>."

	| size palette |
	size := self paletteSize.
	palette := ColorPalette new: size.
	Gdip
		gdipGetImagePalette: self handle
		palette: palette
		size: size.
	^palette!

palette: aColorPalette
	"Set the receiver's color palette to the <ColorPalette> argument."

	Gdip gdipSetImagePalette: self handle palette: aColorPalette asParameter!

paletteSize
	"Private - Answer the size, in bytes, of the receiver's color palette."

	| size |
	size := UInt32Bytes new.
	Gdip gdipGetImagePaletteSize: self asParameter size: size.
	^size asInteger!

pixelFormat
	| flags |
	flags := UInt32Bytes new.
	Gdip gdipGetImagePixelFormat: self handle format: flags.
	^flags asSignedInteger!

pixelFormatName
	^BitmapInitializer nameOfPixelFormat: self pixelFormat!

printOn: aStream
	initializer printImage: self on: aStream!

properties
	"Answer a <GpPropertyItem> list of all the receiver's property items."

	^self propertyIdList collect: [:e | self propertyFromId: e]!

propertiesCount
	"Private - Answer an <Integer> specifying the number of properties of the receiver."

	| propertyCount |
	propertyCount := UInt32Bytes new.
	Gdip gdipGetPropertyCount: self asParameter numOfProperty: propertyCount.
	^propertyCount asInteger!

propertiesSize
	"Private - Answer the total size, in bytes, of all the receiver's property items."

	^self propertiesSizeAndCount first!

propertiesSizeAndCount
	"Private - Answer a two-element array containing the total size, in bytes, of all the
	property items, and the number of property items, stored in the receiver."

	| buf |
	buf := ByteArray new: 8.
	Gdip
		gdipGetPropertySize: self asParameter
		totalBufferSize: buf
		numProperties: buf yourAddress + 4.
	^{buf int32AtOffset: 0. buf int32AtOffset: 4}!

property: aGpPropertyItem
	"Set aGpPropertyItem to be one of the receiver's property items."

	Gdip gdipSetPropertyItem: self asParameter item: aGpPropertyItem!

propertyFromId: aPropertyTagConstant
	"Answer the receiver's <GpPropertyItem> identified by aPropertyTagConstant."

	| propertyItem propSize |
	propSize := self propertySize: aPropertyTagConstant.
	propertyItem := PropertyItem new: propSize.
	Gdip
		gdipGetPropertyItem: self asParameter
		propId: aPropertyTagConstant
		propSize: propSize
		buffer: propertyItem.
	^propertyItem!

propertyIdList
	"Answer an <Integer> list of all the property IDs of the receiver."

	| list count |
	count := self propertiesCount.
	count = 0 ifTrue: [^#()].
	list := UInt32Array new: count.
	Gdip
		gdipGetPropertyIdList: self asParameter
		numOfProperty: self propertiesCount
		list: list.
	^list asArray!

propertySize: aPropertyTagConstant
	"Private - Answer the integer size of the receiver's property identified by aPropertyTagConstant."

	| size |
	size := UInt32Bytes new.
	Gdip
		gdipGetPropertyItemSize: self asParameter
		propId: aPropertyTagConstant
		size: size.
	^size asInteger!

propertyTagDateTime
	"Answer a String that is the date and time the image was created, or nil, if the property doesn't exist."

	(self isValid and: [self hasPropertyId: PropertyTagDateTime]) 
		ifTrue: 
			[^(self propertyFromId: PropertyTagDateTime) valueArray asString trimNulls trimBlanks].
	^nil!

rectScaledToFit: aRectangle
	"Answer a rectangle within which the receiver will be sized proportionally."

	| scale extent origin |
	extent := self extent.
	scale := aRectangle width / extent x.
	scale * extent y > aRectangle height ifTrue: [scale := aRectangle height / extent y].
	extent := scale * extent.
	origin := aRectangle origin + ((aRectangle extent - extent) / 2).
	"NB: might need to use truncate instead of rounded below"
	^origin rounded extent: extent rounded!

rectScaledToFit: aRectangle centered: aBoolean
	"Answer a rectangle within which the receiver will be sized proportionally."

	| scale extent origin |
	extent := self extent.
	scale := aRectangle width / extent x.
	scale * extent y > aRectangle height ifTrue: [scale := aRectangle height / extent y].
	extent := scale * extent.
	origin := aRectangle origin.
	aBoolean ifTrue: [origin := origin + ((aRectangle extent - extent) / 2)].
	"NB: might need to use truncate instead of rounded below"
	^origin rounded extent: extent truncated!

resolution
	| buf x |
	buf := ByteArray new: 4.
	Gdip gdipGetImageHorizontalResolution: self asParameter resolution: buf.
	x := buf floatAtOffset: 0.
	Gdip gdipGetImageVerticalResolution: handle resolution: buf.
	^x @ (buf floatAtOffset: 0)!

rotateLeft
	"Rotate the receiver 90 degrees counterclockwise."

	self basicRotate: Rotate270FlipNone!

rotateRight
	"Rotate the receiver 90 degrees clockwise."

	self basicRotate: Rotate90FlipNone!

saveAdd: aGpEncoderParameters
	"Close the receiver's disk file.  Used with multi-frame images."

	Gdip gdipSaveAdd: self asParameter encoderParams: aGpEncoderParameters!

saveAddImage: aGdiplusImage encoderParams: aGpEncoderParameters
	"Add aGdiplusImage to the receiver and save it as a frame in the receiver's disk file."

	Gdip
		gdipSaveAddImage: self asParameter
		newImage: aGdiplusImage asParameter
		encoderParams: aGpEncoderParameters!

saveFramesToFiles
	"Save the receiver's frames to files with names constructed from the receiver's filename and the frame 
	index (e.g., file00.gif, file01.gif, etc)."

	self saveFramesToFiles: (File splitPathFrom: self filename)!

saveFramesToFiles: directoryString
	"Save the receiver's frames to files in the specified directory with names constructed 
	from the receiver's filename and the frame index (e.g., file00.gif, file01.gif, etc).  
	Use the image encoder associated with the file's extension."

	| frameCount stem digits toFile ext |
	(frameCount := self frameCount) = 1 ifTrue: [^nil].
	stem := File splitStemFrom: self filename.
	ext := File splitExtensionFrom: self filename.
	digits := frameCount numberOfDigitsInBase: 10.
	0 to: frameCount - 1
		do: 
			[:i |
			toFile := File
						composePath: directoryString
						stem: (String writeStream
								nextPutAll: stem;
								nextPutAll: (i printStringBase: 10 nDigits: digits);
								yourself) contents
						extension: ext.
			self selectActiveFrame: i.
			self saveToFile: toFile]!

saveToFile: pathString
	"Save the receiver to the specified file.  Use the image encoder associated with  the file's extension."

	self saveToFile: pathString encoderParams: nil!

saveToFile: pathString clsidEncoder: aCLSIDEncoder encoderParams: aGpEncoderParameters
	"Private - Save the receiver to the specified file, using the image encoder associated with 
	aCLSIDEncoder and parameters specified by aGpEncoderParameters.
	NB:  In general, this method should not be called directly (i.e., use other save methods)
	since the image encoder is normally derived from the pathString."

	Gdip
		gdipSaveImageToFile: self asParameter
		filename: pathString
		clsidEncoder: aCLSIDEncoder
		encoderParams: aGpEncoderParameters!

saveToFile: pathString compression: anIntegerOrNil 
	"Save the receiver to the specified file, and with the specified <integer> compression
	level. Use the image encoder associated with the file's extension. The compression level may
	have no effect, depending on the encoder."

	self saveToFile: pathString
		encoderParams: (anIntegerOrNil isNil ifFalse: [self buildCompressionParameters: anIntegerOrNil])!

saveToFile: pathString encoderParams: aGpEncoderParameters
	"Save the receiver to the specified file with parameters specified by aGpEncoderParameters.
	Use the image encoder associated with the file's extension."

	self
		saveToFile: pathString
		clsidEncoder: (self class encoderClsidForExtension: (File splitExtensionFrom: pathString))
		encoderParams: aGpEncoderParameters!

saveToIStream: pStream mimeType: mimeString 
	"Save the receiver to the specified IStream using the image encoder associated with mimeString."

	"MSDN: Do not save an image to the same stream that was used to construct the image. 
	Doing so might damage the stream. "

	self 
		saveToIStream: pStream
		mimeType: mimeString
		encoderParams: nil!

saveToIStream: pStream mimeType: mimeString encoderParams: aGpEncoderParameters
	"Save the receiver to the specified IStream using the image encoder associated with mimeString
	and parameters specified by aGpEncoderParameters."

	"MSDN: Do not save an image to the same stream that was used to construct the image. 
	Doing so might damage the stream. "

	Gdip
		gdipSaveImageToStream: self asParameter
		stream: pStream
		clsidEncoder: (self class encoderClsid: mimeString)
		encoderParams: aGpEncoderParameters!

selectActiveFrame: anInteger
	"Switch to the frame in the receiver specified by zero-indexed anInteger, in the receiver's first frame
	dimension.  All changes made to the previously active frame are discarded unless saved before switching."

	self selectActiveFrame: anInteger dimensionID: self frameDimensionsList first asParameter!

selectActiveFrame: anInteger dimensionID: aFrameDimensionGUID
	"Switch to the frame in the receiver specified by zero-indexed anInteger, in the frame 
	dimension specified by aFrameDimensionGUID.  All changes made to the previously 
	active frame are discarded unless saved before switching."

	Gdip
		gdipImageSelectActiveFrame: self asParameter
		dimensionID: aFrameDimensionGUID asParameter
		frameIndex: anInteger!

showExample
	"Private - for developmental ease, so that any image or bitmap is easily displayed from a workspace."

	^self class showExample: self!

thumbnailExtent
	"Answer the receiver's thumbnail extent, or Point zero if no thumbnail is embedded in receiver."

	^self thumbnailWidth @ self thumbnailHeight!

thumbnailHeight
	"Answer the receiver's embedded thumbnail height, or 0 if not found."

	^(self hasPropertyId: PropertyTagThumbnailHeight) 
		ifTrue: [(self propertyFromId: PropertyTagThumbnailHeight) valueArray first]
		ifFalse: [0]!

thumbnailScaledBy: aNumber
	"Answer a copy of the receiver sized to the receiver's extent scaled by aNumber."

	^self thumbnailWithExtent: (self extent * aNumber) rounded!

thumbnailWidth
	"Answer the receiver's embedded thumbnail width, or 0 if not found."

	^(self hasPropertyId: PropertyTagThumbnailWidth) 
		ifTrue: [(self propertyFromId: PropertyTagThumbnailWidth) valueArray first]
		ifFalse: [0]!

thumbnailWithExtent: aPoint
	"Answer a copy of the receiver sized to aPoint.  If the receiver has embedded thumbnail data,
	that data will be used, else it will generate the thumbnail.  NB:  If the receiver has an embedded
	thumbnail and it is smaller than aPoint, the thumbnail will be resized to aPoint, in which case
	the resolution will not be as good as if the receiver was resized directly, assuming that the 
	receiver's size is greater than aPoint.  See also GdiplusBitmap class>>fromImage:extent:"

	^Image new
		initializer: (ImageThumbnailInitializer image: self extent: aPoint);
		yourself!

thumbnailWithHeight: anInteger
	"Answer an Image based on the receiver that is sized proportionally, with height equal to anInteger."

	| extent |
	extent := self extent.
	^self thumbnailWithExtent: (extent x / extent y * anInteger) rounded @ anInteger!

width
	"Answer an <Integer> specifying the width of the receiver in pixels."

	| buf |
	buf := UInt32Bytes new.
	Gdip gdipGetImageWidth: self asParameter width: buf.
	^buf asInteger! !
!Graphics.Gdiplus.Image categoriesForMethods!
addToImageList:mask:!double dispatch!public! !
asBitmap!converting!public! !
asByteArray:!converting!public! !
asByteArray:compression:!converting!public! !
basicRotate:!operations!public! !
bounds!accessing!public! !
buildCompressionParameters:!converting!helpers!private! !
clone!copying!public! !
copy!copying!public! !
copyPropertiesFrom:!accessing-properties!public! !
copyToClipboard!copying!public! !
drawOn:!drawing-bitmaps!public! !
drawOn:at:!drawing-bitmaps!public! !
drawOn:at:extent:!drawing-bitmaps!public! !
drawOn:at:extent:from:extent:!drawing-bitmaps!public! !
drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-gdiplus!public! !
encoderParameterList:!accessing-encoders!private! !
encoderParameterListSize:!accessing-encoders!private! !
erase!drawing!public! !
extent!accessing!public! !
filename!accessing!public! !
flags!accessing!public! !
flipX!operations!public! !
flipY!operations!public! !
frameCount!accessing-frames!public! !
frameCount:!accessing-frames!public! !
frameDimension!accessing-frames!private! !
frameDimensionsCount!accessing-frames!public! !
frameDimensionsList!accessing-frames!public! !
frames!accessing-frames!public! !
freeDC!public!realizing/unrealizing! !
getBounds!accessing!private! !
graphics!accessing!public! !
hasAlpha!public!testing! !
hasDPI!public!testing! !
hasPixelSize!public!testing! !
hasPropertyId:!accessing-properties!public!testing! !
hasThumbnail!private!testing!thumbnails! !
hasThumbnailData!public!testing!thumbnails! !
hasTranslucency!public!testing! !
height!accessing!public! !
initializerClass!private!realizing/unrealizing! !
isCMYK!public!testing! !
isGrayScale!public!testing! !
isLandscape!public!testing! !
isPartiallyScalable!public!testing! !
isPortrait!public!testing! !
isReadOnly!public!testing! !
isRGB!public!testing! !
isScalable!public!testing! !
isValid!public!testing! !
isYCBCR!public!testing! !
isYCCK!public!testing! !
mimeType!accessing!public! !
palette!accessing!public! !
palette:!accessing!public! !
paletteSize!accessing!private! !
pixelFormat!accessing!public! !
pixelFormatName!accessing!public! !
printOn:!printing!public! !
properties!accessing-properties!public! !
propertiesCount!accessing-properties!private! !
propertiesSize!accessing-properties!private! !
propertiesSizeAndCount!accessing-properties!private! !
property:!accessing-properties!public! !
propertyFromId:!accessing-properties!public! !
propertyIdList!accessing-properties!public! !
propertySize:!accessing-properties!private! !
propertyTagDateTime!accessing-properties!public! !
rectScaledToFit:!helpers!public! !
rectScaledToFit:centered:!helpers!public! !
resolution!public!testing! !
rotateLeft!operations!public! !
rotateRight!operations!public! !
saveAdd:!file operations!public! !
saveAddImage:encoderParams:!file operations!public! !
saveFramesToFiles!file operations!public! !
saveFramesToFiles:!file operations!public! !
saveToFile:!file operations!public! !
saveToFile:clsidEncoder:encoderParams:!file operations!private! !
saveToFile:compression:!file operations!public! !
saveToFile:encoderParams:!file operations!public! !
saveToIStream:mimeType:!file operations!public! !
saveToIStream:mimeType:encoderParams:!file operations!public! !
selectActiveFrame:!accessing-frames!public! !
selectActiveFrame:dimensionID:!accessing-frames!public! !
showExample!development!private! !
thumbnailExtent!public!thumbnails! !
thumbnailHeight!public!thumbnails! !
thumbnailScaledBy:!operations!public!thumbnails! !
thumbnailWidth!public!thumbnails! !
thumbnailWithExtent:!operations!public!thumbnails! !
thumbnailWithHeight:!operations!public!thumbnails! !
width!accessing!public! !
!

Graphics.Gdiplus.Image methodProtocol: #image attributes: #(#readOnly) selectors: #(#addToImageList:mask: #drawOn: #drawOn:at: #drawOn:at:extent: #extent #freeDC #isPersistent)!

!Graphics.Gdiplus.Image class methodsFor!

cacheDecoderClsids
	DecodersByExtension := LookupTable new.
	DecodersByMimeType := LookupTable new.
	self decoders do: [:each | | clsid |
		clsid := each Clsid.
		DecodersByMimeType at: each MimeType put: clsid.
		($; split: each FilenameExtension) do: [:ext |
			DecodersByExtension at: ($. split: ext) last caseFolded put: clsid]]!

cacheEncoderClsids
	EncodersByExtension := LookupTable new.
	EncodersByMimeType := LookupTable new.
	self encoders do: [:each | | clsid |
		clsid := each Clsid.
		EncodersByMimeType at: each MimeType put: clsid.
		($; split: each FilenameExtension) do: [:ext |
			EncodersByExtension at: ($. split: ext) last caseFolded put: clsid]]!

decoderClsid: aMimeTypeString
	"Private - Answer the <CLSID> of the image decoder for the specified MIME type.

		(self decoderClsid: 'image/jpeg')
	"

	^self decodersByMimeType at: aMimeTypeString!

decoderFileExtensions
	"Answer a list of strings that represent the supported decoder file extensions."

	^self decodersByExtension keys!

decoderMimeTypes
	"Answer a list of strings that represent the supported decoder mime types."

	^self decodersByMimeType keys!

decoders
	"Answer a <StructureArray> of <GpImageCodecInfo> that describe the available image
	decoders."

	^self getImageCodecs: false!

decodersByExtension
	^DecodersByExtension
		ifNil: 
			[self cacheDecoderClsids.
			DecodersByExtension]!

decodersByMimeType
	^DecodersByMimeType
		ifNil: 
			[self cacheDecoderClsids.
			DecodersByMimeType]!

encoderClsid: aMimeTypeString
	"Private - Answer the <CLSID> of the image encoder for the specified MIME type.

		(self encoderClsid: 'image/jpeg') = (self encoderClsidForExtension: 'jpg')
	"

	^self encodersByMimeType at: aMimeTypeString!

encoderClsidForExtension: aString
	"Answer a GUID that represents the image encoder associated with aString file extension.

		self encoderClsidForExtension: 'jpg'
	"

	^self encodersByExtension at: (Locale.Invariant foldcaseString: aString)!

encoderFileExtensions
	"Answer a list of strings that represent the supported encoder file extensions."

	^self encodersByExtension keys!

encoderMimeTypeForExtension: aString
	"Answer a String mime type associated with aString file extension.

	 	self encoderMimeTypeForExtension: 'jpg'
	"

	^self encodersByMimeType keyAtValue: (self encoderClsidForExtension: aString)!

encoderMimeTypes
	"Answer a list of strings that represent the supported image encoder mime types."

	^self encodersByMimeType keys!

encoders
	"Answer a <StructureArray> of <GpImageCodecInfo> that describe the available image
	encoders."

	^self getImageCodecs: true!

encodersByExtension
	^EncodersByExtension
		ifNil: 
			[self cacheEncoderClsids.
			EncodersByExtension]!

encodersByMimeType
	^EncodersByMimeType
		ifNil: 
			[self cacheEncoderClsids.
			EncodersByMimeType]!

fileTypes
	"Answer an array of file types for use with the <FileOpenDialog>."

	| all types |
	all := String writeStream.
	types := OrderedCollection new.
	self decoders do: 
			[:each |
			| extensions |
			extensions := each FilenameExtension asLowercase.
			all
				nextPut: $;;
				nextPutAll: extensions.
			types
				addLast: {'<1s> (<2s>)' expandMacrosWithArguments: {each FormatDescription. extensions}
							locale: Locale invariant.
						extensions}].
	types
		addLast: {'All Images'. all contents};
		addLast: UI.FileDialog allFilesType.
	^types asArray!

fromByteArray: aByteArray
	"Answer an instance of the receiver created from data in aByteArray. The results is an instance with a persistent
	initializer that can be used after an image reload or after passing through STB serialization/deserialization."

	^self fromInitializer: (ImageFromBytesInitializer bytes: aByteArray)!

fromFile: aFilename
	"Answer an instance of the receiver created from data in the specified file."

	^self fromFile: aFilename usingLocator: FileLocator default!

fromFile: aFilename usingLocator: aFileLocator
	"Answer an instance of the receiver created from data in the specified file."

	^self fromInitializer: (ImageFromFileInitializer filename: aFilename fileLocator: aFileLocator)!

fromIStream: pStream
	"Answer an instance of the receiver created from data in the specified IStream."

	^self fromInitializer: (ImageFromIStreamInitializer iStream: pStream)!

getImageCodecs: aBoolean
	"Private - Answer a <StructureArray> of <GpImageCodecInfo>s, describing either the available encoders
	or decoders, depending on the <boolean> argument."

	"Implementation Note: The GdipGetImage[De|En]coders() functions populates a block of memory with
	first an array of GdipImageCodecInfo structures, and then various strings pointed at by the
	fields of those structures. This makes it difficult to convert the result into a Smalltalk
	array since it would mean having to internalize all the strings. A StructureArray is
	probably adequate for purpose, so unless a specific use-case requires a full Smalltalk
	collection we might as well leave it as a single block of memory accessed via a
	StructureArray."

	| numCodecs buf byteSize |
	buf := ByteArray newFixed: 8.
	aBoolean
		ifTrue: [Gdip gdipGetImageEncodersSize: buf size: buf yourAddress + 4]
		ifFalse: [Gdip gdipGetImageDecodersSize: buf size: buf yourAddress + 4].
	numCodecs := buf uint32AtOffset: 0.
	byteSize := buf uint32AtOffset: 4.
	buf := Memory new: byteSize.
	aBoolean
		ifTrue: 
			[Gdip
				gdipGetImageEncoders: numCodecs
				size: byteSize
				encoders: buf]
		ifFalse: 
			[Gdip
				gdipGetImageDecoders: numCodecs
				size: byteSize
				decoders: buf].
	^StructureArray
		fromAddress: buf
		length: numCodecs
		elementClass: ImageCodecInfo!

icon
	"Answers an Icon that can be used to represent this class"

	^Graphics.Image icon!

nameOfImageFlag: anInteger
	^Gdiplus.ImageFlagsNames at: anInteger highBit + 1!

onStartup2
	"Private - Perform system startup processing for all subclasses."

	DecodersByExtension := DecodersByMimeType := EncodersByExtension := EncodersByMimeType := nil! !
!Graphics.Gdiplus.Image class categoriesForMethods!
cacheDecoderClsids!helpers!private! !
cacheEncoderClsids!helpers!private! !
decoderClsid:!enquiries!private! !
decoderFileExtensions!enquiries!public! !
decoderMimeTypes!enquiries!public! !
decoders!enquiries!public! !
decodersByExtension!enquiries!private! !
decodersByMimeType!enquiries!private! !
encoderClsid:!enquiries!private! !
encoderClsidForExtension:!enquiries!private! !
encoderFileExtensions!enquiries!public! !
encoderMimeTypeForExtension:!enquiries!private! !
encoderMimeTypes!enquiries!public! !
encoders!enquiries!public! !
encodersByExtension!enquiries!private! !
encodersByMimeType!enquiries!private! !
fileTypes!enquiries!public! !
fromByteArray:!instance creation!public! !
fromFile:!instance creation!public! !
fromFile:usingLocator:!instance creation!public! !
fromIStream:!instance creation!public! !
getImageCodecs:!helpers!private! !
icon!constants!public! !
nameOfImageFlag:!enquiries!public! !
onStartup2!event handling!private! !
!

