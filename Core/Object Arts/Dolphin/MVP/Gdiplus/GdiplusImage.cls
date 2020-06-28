"Filed out from Dolphin Smalltalk 7"!

GdiplusBase subclass: #GdiplusImage
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusImage guid: (GUID fromString: '{00b83139-f011-4475-99dd-34afd09c2e06}')!
GdiplusImage comment: 'GdiplusImage provides methods for loading and saving raster images (bitmaps) and vector images (metafiles).  Various methods are available to manipulate and display an image.  Different file types can be read from and saved to - see #encoderMimeTypes and #decoderMimeTypes.'!
!GdiplusImage categoriesForClass!Unclassified! !
!GdiplusImage methodsFor!

asBitmap
	"Answer a display-compatible <Bitmap> with the receiver's image."

	| bitmap |
	bitmap := Bitmap displayCompatibleWithExtent: self extent.
	self drawOn: bitmap canvas.
	bitmap freeDC.
	^bitmap!

asByteArray: mimeString 
	"SW: OLEPicture>>saveAsFile locks the hGlobal (other uses dont) ... is that necessary?"

	^self asByteArray: mimeString compression: nil!

asByteArray: mimeString compression: anIntegerOrNil 
	"SW: OLEPicture>>saveAsFile locks the hGlobal (other uses dont) ... is that necessary?"

	| pStream bytes |
	pStream := IStream onHGLOBAL.
	self 
		saveToIStream: pStream
		mimeType: mimeString
		encoderParams: (anIntegerOrNil isNil ifFalse: [self buildCompressionParameters: anIntegerOrNil]).
	bytes := pStream contents.
	pStream free.
	^bytes!

basicFree
	"Private - Free up external resources held by the receiver.
	Ignore any errors which might arise."

	GdiplusLibrary default gdipDisposeImage: handle!

basicRotate: aRotateConstant 
	"Rotate the receiver according to aRotateConstant."

	| status |
	(status := GdiplusLibrary default gdipImageRotateFlip: self asParameter rfType: aRotateConstant) 
		= Ok ifFalse: [^GdiplusError signal: 'Error rotating image' with: status]!

bounds
	"Answer the receiver's bounding rectangle.  Most images will have Point zero as the 
	upper-left corner, though a metafile may not, depending on the commands used to create it."

	| bounds |
	bounds := self getBounds first.
	^bounds origin rounded corner: bounds corner rounded!

buildCompressionParameters: anIntegerOrNil 
	| quality params encoderParameter |
	params := GpEncoderParameters new.
	params Count: 1.
	(encoderParameter := params Parameter first)
		Guid: EncoderQuality;
		Type: EncoderParameterValueTypeLong;
		NumberOfValues: 1.
	quality := DWORD new.
	encoderParameter Value: quality yourAddress.
	quality value: anIntegerOrNil.
	^params!

clone
	"Answer a copy of the receiver."

	| status gpHandle |
	gpHandle := ExternalHandle new.
	(status := GdiplusLibrary default gdipCloneImage: self handle cloneImage: gpHandle) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipCloneImage' with: status].
	^(self class fromOwnedHandle: gpHandle)
		initializer: initializer;
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

	self drawOn: aCanvas at: Point zero!

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

	| status size buffer |
	size := self encoderParameterListSize: aCLSID.
	buffer := GpEncoderParameters new: size.
	(status := GdiplusLibrary default 
				gdipGetEncoderParameterList: self asParameter
				clsidEncoder: aCLSID
				size: size
				buffer: buffer) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetEncoderParameterList failed' with: status].
	^buffer!

encoderParameterListSize: aCLSID 
	"Answer the size, in bytes, of the parameter list for the image encoder specified by aCLSID."

	| status size |
	size := DWORD new.
	(status := GdiplusLibrary default 
				gdipGetEncoderParameterListSize: self asParameter
				clsidEncoder: aCLSID
				size: size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipGetEncoderParameterListSize failed' with: status].
	^size asInteger!

extent
	"Answer a <Point> specifying the dimensions of the receiver in pixels."

	| buf status lib width |
	buf := DWORDBytes new.
	lib := GdiplusLibrary default.
	(status := lib gdipGetImageWidth: self asParameter width: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetImageWidth failed' with: status].
	width := buf asInteger.
	(status := lib gdipGetImageHeight: self asParameter height: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetImageHeight failed' with: status].
	^width @ buf asInteger!

filename
	"Answer the <readableString> filename associated with the receiver.
	NB:  A GdiplusBitmap doesn't have a filename."

	^self initializer absoluteFilename!

flags
	"Answer an <Integer> specifying single-bit flags (attributes) of the receiver."

	| flags status |
	flags := DWORD new.
	(status := GdiplusLibrary default gdipGetImageFlags: self asParameter flags: flags) = Ok
		ifFalse: [^GdiplusError signal: 'GdipGetImageFlags failed' with: status].
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

	| status count |
	count := DWORD new.
	(status := GdiplusLibrary default 
				gdipImageGetFrameCount: self asParameter
				dimensionID: aFrameDimensionGUID asParameter
				count: count) = Ok 
		ifFalse: [GdiplusError signal: 'GdipImageGetFrameCount failed' with: status].
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

	| status count |
	count := DWORD new.
	(status := GdiplusLibrary default gdipImageGetFrameDimensionsCount: self asParameter count: count) 
		= Ok ifFalse: [GdiplusError signal: 'GdipImageGetFrameDimensionsCount failed' with: status].
	^count asInteger!

frameDimensionsList
	"Answer a collection of GUIDs that represent the receiver's frame dimensions."

	| status guids |
	guids := StructureArray length: self frameDimensionsCount elementClass: GUID.
	(status := GdiplusLibrary default 
				gdipImageGetFrameDimensionsList: self asParameter
				dimensionIDs: guids
				count: guids size) = Ok 
		ifFalse: [GdiplusError signal: 'GdipImageGetFrameDimensionsList failed' with: status].
	^guids asArray!

frames
	"Answer an OrderedCollection of GdiplusImage that are the receiver's frames in the first frame dimension."

	| images bitmap |
	images := OrderedCollection new.
	0 to: self frameCount - 1
		do: 
			[:i | 
			self selectActiveFrame: i.
			bitmap := GdiplusBitmap extent: self extent.
			bitmap graphics drawImage: self.
			images add: bitmap].
	^images!

freeDC
	"For compatibility with <Image>."!

getBounds
	"Private - Answer a 2-element array, the first element a bounding Rectangle, the second 
	element the UnitConstant that indicates the unit of measure for the bounding rectangle."

	| status rect unit |
	rect := RECTF new.
	unit := SDWORD new.
	(status := GdiplusLibrary default
				gdipGetImageBounds: self asParameter
				srcRect: rect
				srcUnit: unit) = Ok
		ifFalse: [^GdiplusError signal: 'GdipGetImageBounds failed' with: status].
	^{rect asRectangle. unit value}!

graphics
	"Answer a GdiplusGraphics instance based on the receiver."

	^GdiplusGraphics fromImage: self!

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

height
	"Answer an <Integer> specifying the height of the receiver in pixels."

	| buf status |
	buf := DWORDBytes new.
	(status := GdiplusLibrary default gdipGetImageHeight: self asParameter height: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetImageHeight failed' with: status].
	^buf asInteger!

isLandscape
	"Answer whether the receiver is wider than its height."

	^self extent x > self extent y!

isPortrait
	"Answer whether the receiver is narrower than its width."

	^self isLandscape not!

isValid
	"Answer whether the receiver can be realized."

	^[self handle notNull] on: Error do: [:err | false]!

mimeType
	"Answer the <readableString> mimeType of the filename associated with the receiver.
	NB:  Problem with this is that a GdiplusBitmap doesn't have a filename."

	^self class encoderMimeTypeForExtension: (File splitExtensionFrom: self filename)!

palette
	"Answer the receiver's color palette, a <GpColorPalette>."

	| size palette status |
	size := self paletteSize.
	palette := GpColorPalette new: size.
	(status := GdiplusLibrary default 
				gdipGetImagePalette: self asParameter
				palette: palette
				size: size) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetImagePalette failed' with: status].
	^palette!

palette: aGpColorPalette 
	"Set the receiver's color palette to aGpColorPalette."

	| status |
	(status := GdiplusLibrary default gdipSetImagePalette: self asParameter
				palette: aGpColorPalette asParameter) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipSetImagePalette failed' with: status]!

paletteSize
	"Private - Answer the size, in bytes, of the receiver's color palette."

	| size status |
	size := DWORD new.
	(status := GdiplusLibrary default gdipGetImagePaletteSize: self asParameter size: size) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetImagePaletteSize failed' with: status].
	^size asInteger!

pixelFormat
	| flags status |
	flags := SDWORD new.
	(status := GdiplusLibrary default gdipGetImagePixelFormat: self asParameter format: flags) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetImagePixelFormat failed' with: status].
	^flags asInteger!

properties
	"Answer a <GpPropertyItem> list of all the receiver's property items."

	^self propertyIdList collect: [:e | self propertyFromId: e]!

propertiesCount
	"Private - Answer an <Integer> specifying the number of properties of the receiver."

	| propertyCount status |
	propertyCount := DWORD new.
	(status := GdiplusLibrary default gdipGetPropertyCount: self asParameter
				numOfProperty: propertyCount) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetPropertyCount failed' with: status].
	^propertyCount asInteger!

propertiesSize
	"Private - Answer the total size, in bytes, of all the receiver's property items."

	^self propertiesSizeAndCount first!

propertiesSizeAndCount
	"Private - Answer a two-element array containing the total size, in bytes, of all the
	property items, and the number of property items, stored in the receiver."

	| size count status |
	size := SDWORD new.
	count := SDWORD new.
	(status := GdiplusLibrary default
				gdipGetPropertySize: self asParameter
				totalBufferSize: size
				numProperties: count) = Ok
		ifFalse: [^GdiplusError signal: 'GdipGetPropertySize failed' with: status].
	^{size asInteger. count asInteger}!

property: aGpPropertyItem 
	"Set aGpPropertyItem to be one of the receiver's property items."

	| status |
	(status := GdiplusLibrary default gdipSetPropertyItem: self asParameter item: aGpPropertyItem) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipSetPropertyItem failed' with: status]!

propertyFromId: aPropertyTagConstant 
	"Answer the receiver's <GpPropertyItem> identified by aPropertyTagConstant."

	| propertyItem propSize status |
	propSize := self propertySize: aPropertyTagConstant.
	propertyItem := GpPropertyItem new: propSize.
	(status := GdiplusLibrary default 
				gdipGetPropertyItem: self asParameter
				propId: aPropertyTagConstant
				propSize: propSize
				buffer: propertyItem) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetPropertyItem failed' with: status].
	^propertyItem!

propertyIdList
	"Answer an <Integer> list of all the property IDs of the receiver."

	| list status count |
	count := self propertiesCount.
	count = 0 ifTrue: [^#()].
	list := DWORDArray new: count.
	(status := GdiplusLibrary default 
				gdipGetPropertyIdList: self asParameter
				numOfProperty: self propertiesCount
				list: list) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetPropertyIdList failed' with: status].
	^list asArray!

propertySize: aPropertyTagConstant 
	"Private - Answer the integer size of the receiver's property identified by aPropertyTagConstant."

	| size status |
	size := DWORD new.
	(status := GdiplusLibrary default 
				gdipGetPropertyItemSize: self asParameter
				propId: aPropertyTagConstant
				size: size) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipGetPropertyItemSize failed' with: status].
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

rotateLeft
	"Rotate the receiver 90 degrees counterclockwise."

	self basicRotate: Rotate270FlipNone!

rotateRight
	"Rotate the receiver 90 degrees clockwise."

	self basicRotate: Rotate90FlipNone!

saveAdd: aGpEncoderParameters 
	"Close the receiver's disk file.  Used with multi-frame images."

	| status |
	(status := GdiplusLibrary default gdipSaveAdd: self asParameter encoderParams: aGpEncoderParameters) 
		= Ok ifFalse: [^GdiplusError signal: 'GdipSaveAdd failed' with: status]!

saveAddImage: aGdiplusImage encoderParams: aGpEncoderParameters 
	"Add aGdiplusImage to the receiver and save it as a frame in the receiver's disk file."

	| status |
	(status := GdiplusLibrary default 
				gdipSaveAddImage: self asParameter
				newImage: aGdiplusImage asParameter
				encoderParams: aGpEncoderParameters) = Ok 
		ifFalse: [^GdiplusError signal: 'GdipSaveAddImage failed' with: status]!

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

	| status |
	(status := GdiplusLibrary default
				gdipSaveImageToFile: self asParameter
				filename: pathString
				clsidEncoder: aCLSIDEncoder
				encoderParams: aGpEncoderParameters) = Ok
		ifFalse: [^GdiplusError signal: 'Error saving image' with: status]!

saveToFile: pathString compression: anIntegerOrNil 
	"Save the receiver to the specified file, and with the specified <integer> compression
	level. Use the image encoder associated with the file's extension. The compression level may
	have no effect, depending on the encoder."

	self saveToFile: pathString
		encoderParams: (anIntegerOrNil isNil ifFalse: [self buildCompressionParameters: anIntegerOrNil])!

saveToFile: pathString encoderParams: aGpEncoderParameters
	"Save the receiver to the specified file with parameters specified by aGpEncoderParameters.
	Use the image encoder associated with the file's extension."

	| mimeType encoder |
	mimeType := self class encoderMimeTypeForExtension: (File splitExtensionFrom: pathString).
	encoder := self class encoderClsid: mimeType.
	self 
		saveToFile: pathString
		clsidEncoder: encoder
		encoderParams: aGpEncoderParameters!

saveToIStream: pStream mimeType: mimeString 
	"Save the receiver to the specified IStream using  the image encoder associated with mimeString."

	"MSDN: Do not save an image to the same stream that was used to construct the image. 
	Doing so might damage the stream. "

	self 
		saveToIStream: pStream
		mimeType: mimeString
		encoderParams: nil!

saveToIStream: pStream mimeType: mimeString encoderParams: aGpEncoderParameters 
	"Save the receiver to the specified IStream using  the image encoder associated with mimeString
	and parameters specified by aGpEncoderParameters."

	"MSDN: Do not save an image to the same stream that was used to construct the image. 
	Doing so might damage the stream. "

	| encoder status |
	encoder := self class encoderClsid: mimeString.
	status := GdiplusLibrary default 
				gdipSaveImageToStream: self asParameter
				stream: pStream
				clsidEncoder: encoder
				encoderParams: aGpEncoderParameters.
	status = Ok ifFalse: [^GdiplusError signal: 'Error saving image' with: status]!

selectActiveFrame: anInteger
	"Switch to the frame in the receiver specified by zero-indexed anInteger, in the receiver's first frame
	dimension.  All changes made to the previously active frame are discarded unless saved before switching."

	self selectActiveFrame: anInteger dimensionID: self frameDimensionsList first asParameter!

selectActiveFrame: anInteger dimensionID: aFrameDimensionGUID 
	"Switch to the frame in the receiver specified by zero-indexed anInteger, in the frame 
	dimension specified by aFrameDimensionGUID.  All changes made to the previously 
	active frame are discarded unless saved before switching."

	| status |
	(status := GdiplusLibrary default 
				gdipImageSelectActiveFrame: self asParameter
				dimensionID: aFrameDimensionGUID asParameter
				frameIndex: anInteger) = Ok 
		ifFalse: [GdiplusError signal: 'GdipImageSelectActiveFrame failed' with: status]!

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

	| gpImage status |
	gpImage := ExternalHandle new.
	(status := GdiplusLibrary default 
				gdipGetImageThumbnail: self asParameter
				thumbWidth: aPoint x
				thumbHeight: aPoint y
				thumbImage: gpImage
				pfnCallback: nil
				callbackData: nil) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipGetImageThumbnail' with: status].
	^(self class fromOwnedHandle: gpImage)
		initializer: (self class fromFile: self filename) initializer;
		yourself!

thumbnailWithExtent2: aPoint 
	"Answer a copy of the receiver sized to aPoint.  If the receiver has embedded thumbnail data,
	that data will be used, else it will generate the thumbnail.  NB:  If the receiver has an embedded
	thumbnail and it is smaller than aPoint, the thumbnail will be resized to aPoint, in which case
	the resolution will not be as good as if the receiver was resized directly, assuming that the 
	receiver's size is greater than aPoint.  See also GdiplusBitmap class>>fromImage:extent:"

	| gpImage status |
	gpImage := ExternalHandle new.
	(status := GdiplusLibrary default 
				gdipGetImageThumbnail: self asParameter
				thumbWidth: aPoint x
				thumbHeight: aPoint y
				thumbImage: gpImage
				pfnCallback: nil
				callbackData: nil) = Ok 
		ifFalse: [^GdiplusError signal: 'Error in GdipGetImageThumbnail' with: status].
	^(self class fromOwnedHandle: gpImage)
		initializer: self initializer;
		yourself!

thumbnailWithHeight: anInteger
	"Answer an Image based on the receiver that is sized proportionally, with height equal to anInteger."

	| extent |
	extent := self extent.
	^self thumbnailWithExtent: (extent x / extent y * anInteger) rounded @ anInteger!

width
	"Answer an <Integer> specifying the width of the receiver in pixels."

	| buf status |
	buf := DWORDBytes new.
	(status := GdiplusLibrary default gdipGetImageWidth: self asParameter width: buf) == Ok
		ifFalse: [GdiplusError signal: 'GdipGetImageWidth failed' with: status].
	^buf asInteger! !
!GdiplusImage categoriesFor: #asBitmap!public! !
!GdiplusImage categoriesFor: #asByteArray:!converting!public! !
!GdiplusImage categoriesFor: #asByteArray:compression:!converting!public! !
!GdiplusImage categoriesFor: #basicFree!private!realizing/unrealizing! !
!GdiplusImage categoriesFor: #basicRotate:!operations!public! !
!GdiplusImage categoriesFor: #bounds!accessing!public! !
!GdiplusImage categoriesFor: #buildCompressionParameters:!converting!helpers!private! !
!GdiplusImage categoriesFor: #clone!copying!public! !
!GdiplusImage categoriesFor: #copy!copying!public! !
!GdiplusImage categoriesFor: #copyPropertiesFrom:!accessing-properties!public! !
!GdiplusImage categoriesFor: #copyToClipboard!copying!public! !
!GdiplusImage categoriesFor: #drawOn:!drawing-bitmaps!public! !
!GdiplusImage categoriesFor: #drawOn:at:!drawing-bitmaps!public! !
!GdiplusImage categoriesFor: #drawOn:at:extent:!drawing-bitmaps!public! !
!GdiplusImage categoriesFor: #drawOn:at:extent:from:extent:!drawing-bitmaps!public! !
!GdiplusImage categoriesFor: #drawOnGraphics:at:extent:from:extent:unit:attributes:!drawing-gdiplus!public! !
!GdiplusImage categoriesFor: #encoderParameterList:!accessing-encoders!private! !
!GdiplusImage categoriesFor: #encoderParameterListSize:!accessing-encoders!private! !
!GdiplusImage categoriesFor: #extent!accessing!public! !
!GdiplusImage categoriesFor: #filename!accessing!public! !
!GdiplusImage categoriesFor: #flags!accessing!public! !
!GdiplusImage categoriesFor: #flipX!operations!public! !
!GdiplusImage categoriesFor: #flipY!operations!public! !
!GdiplusImage categoriesFor: #frameCount!accessing-frames!public! !
!GdiplusImage categoriesFor: #frameCount:!accessing-frames!public! !
!GdiplusImage categoriesFor: #frameDimension!accessing-frames!private! !
!GdiplusImage categoriesFor: #frameDimensionsCount!accessing-frames!public! !
!GdiplusImage categoriesFor: #frameDimensionsList!accessing-frames!public! !
!GdiplusImage categoriesFor: #frames!accessing-frames!public! !
!GdiplusImage categoriesFor: #freeDC!public! !
!GdiplusImage categoriesFor: #getBounds!accessing!private! !
!GdiplusImage categoriesFor: #graphics!accessing!public! !
!GdiplusImage categoriesFor: #hasPropertyId:!accessing-properties!public!testing! !
!GdiplusImage categoriesFor: #hasThumbnail!private!testing!thumbnails! !
!GdiplusImage categoriesFor: #hasThumbnailData!public!testing!thumbnails! !
!GdiplusImage categoriesFor: #height!accessing!public! !
!GdiplusImage categoriesFor: #isLandscape!public!testing! !
!GdiplusImage categoriesFor: #isPortrait!public!testing! !
!GdiplusImage categoriesFor: #isValid!public!testing! !
!GdiplusImage categoriesFor: #mimeType!accessing!public! !
!GdiplusImage categoriesFor: #palette!accessing!public! !
!GdiplusImage categoriesFor: #palette:!accessing!public! !
!GdiplusImage categoriesFor: #paletteSize!accessing!private! !
!GdiplusImage categoriesFor: #pixelFormat!accessing!public! !
!GdiplusImage categoriesFor: #properties!accessing-properties!public! !
!GdiplusImage categoriesFor: #propertiesCount!accessing-properties!private! !
!GdiplusImage categoriesFor: #propertiesSize!accessing-properties!private! !
!GdiplusImage categoriesFor: #propertiesSizeAndCount!accessing-properties!private! !
!GdiplusImage categoriesFor: #property:!accessing-properties!public! !
!GdiplusImage categoriesFor: #propertyFromId:!accessing-properties!public! !
!GdiplusImage categoriesFor: #propertyIdList!accessing-properties!public! !
!GdiplusImage categoriesFor: #propertySize:!accessing-properties!private! !
!GdiplusImage categoriesFor: #propertyTagDateTime!accessing-properties!public! !
!GdiplusImage categoriesFor: #rectScaledToFit:!helpers!public! !
!GdiplusImage categoriesFor: #rectScaledToFit:centered:!helpers!public! !
!GdiplusImage categoriesFor: #rotateLeft!operations!public! !
!GdiplusImage categoriesFor: #rotateRight!operations!public! !
!GdiplusImage categoriesFor: #saveAdd:!file operations!public! !
!GdiplusImage categoriesFor: #saveAddImage:encoderParams:!file operations!public! !
!GdiplusImage categoriesFor: #saveFramesToFiles!file operations!public! !
!GdiplusImage categoriesFor: #saveFramesToFiles:!file operations!public! !
!GdiplusImage categoriesFor: #saveToFile:!file operations!public! !
!GdiplusImage categoriesFor: #saveToFile:clsidEncoder:encoderParams:!file operations!private! !
!GdiplusImage categoriesFor: #saveToFile:compression:!file operations!public! !
!GdiplusImage categoriesFor: #saveToFile:encoderParams:!file operations!public! !
!GdiplusImage categoriesFor: #saveToIStream:mimeType:!file operations!public! !
!GdiplusImage categoriesFor: #saveToIStream:mimeType:encoderParams:!file operations!public! !
!GdiplusImage categoriesFor: #selectActiveFrame:!accessing-frames!public! !
!GdiplusImage categoriesFor: #selectActiveFrame:dimensionID:!accessing-frames!public! !
!GdiplusImage categoriesFor: #showExample!development!private! !
!GdiplusImage categoriesFor: #thumbnailExtent!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailHeight!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailScaledBy:!operations!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailWidth!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailWithExtent:!operations!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailWithExtent2:!operations!public!thumbnails! !
!GdiplusImage categoriesFor: #thumbnailWithHeight:!operations!public!thumbnails! !
!GdiplusImage categoriesFor: #width!accessing!public! !

!GdiplusImage class methodsFor!

decoderFileExtensions
	"Answer a list of strings that represent the supported decoder file extensions."

	| extensions |
	extensions := OrderedCollection new.
	self decoders do: 
			[:decoder |
			| strm |
			strm := decoder FilenameExtension readStream.
			[strm atEnd] whileFalse: [(strm skipTo: $.) ifTrue: [extensions add: (strm upTo: $;)]]].
	^extensions!

decoderMimeTypes
	"Answer a list of strings that represent the supported decoder mime types."

	^self decoders collect: [:e | e MimeType asString]!

decoders
	"Answer a <StructureArray> of <GpImageCodecInfo> that describe the available image
	decoders."

	^self getImageCodecs: false!

encoderClsid: aMimeTypeString
	"Private - Answer the <CLSID> of the image encoder for the specified MIME type.

		(self encoderClsid: 'image/jpeg') = (self encoderClsidForExtension: 'jpg')
	"

	^(self encoders detect: [:each | each MimeType = aMimeTypeString]) Clsid!

encoderClsidForExtension: aString
	"Answer a GUID that represents the image encoder associated with aString file extension.

		self encoderClsidForExtension: 'jpg'
	"

	^(self encoders detect: 
			[:e | 
			(e FilenameExtension asString asLowercase indexOfSubCollection: aString asLowercase) > 0]) 
		Clsid!

encoderFileExtensions
	"Answer a list of strings that represent the supported encoder file extensions."

	| extensions |
	extensions := OrderedCollection new.
	self encoders do: 
			[:encoder |
			| strm |
			strm := encoder FilenameExtension readStream.
			[strm atEnd] whileFalse: [(strm skipTo: $.) ifTrue: [extensions add: (strm upTo: $;)]]].
	^extensions!

encoderMimeTypeForExtension: aString
	"Answer a String mime type associated with aString file extension.

	 	self encoderMimeTypeForExtension: 'jpg'
	"

	^(self encoders detect: 
			[:e | 
			(e FilenameExtension asString asLowercase indexOfSubCollection: aString asLowercase) > 0]) 
		MimeType asString!

encoderMimeTypes
	"Answer a list of strings that represent the supported image encoder mime types."

	^self encoders collect: [:e | e MimeType asString]!

encoders
	"Answer a <StructureArray> of <GpImageCodecInfo> that describe the available image
	encoders."

	^self getImageCodecs: true!

exampleGdipIDecoderFileExtensions
	"This example displays the file extensions for all of the available image decoders.

		RichTextPresenter showOn: self exampleGdipIDecoderFileExtensions
	"

	| strm |
	strm := String new writeStream.
	strm
		display: 'Decoder file extensions: ';
		cr.
	self decoderFileExtensions do: 
			[:e | 
			strm
				tab;
				display: e;
				cr].
	^strm contents!

exampleGdipIDecoders
	"MSDN:  Using GDI+ >  Using Image Encoders and Decoders > Listing Installed Decoders
	This example displays the mime types for all of the available image decoders.

		RichTextPresenter showOn: self exampleGdipIDecoders
	"

	| strm |
	strm := String new writeStream.
	strm
		display: 'Decoder mime types: ';
		cr.
	self decoderMimeTypes do: 
			[:e | 
			strm
				tab;
				display: e;
				cr].
	^strm contents!

exampleGdipIEncoderClsid
	"MSDN:  Using GDI+ >  Using Image Encoders and Decoders > Retrieving the Class Identifier
	This example displays information about the image encoder for the png mime type.

		RichTextPresenter showOn: self exampleGdipIEncoderClsid
	"

	| strm |
	strm := String new writeStream.
	self encoders keysAndValuesDo: 
			[:i :e | 
			e MimeType asString = 'image/png' 
				ifTrue: 
					[strm
						display: 'An ImageCodecInfo object representing the PNG encoder';
						cr;
						display: 'was found at position ';
						display: i displayString;
						display: ' in the array.';
						cr;
						display: 'The CLSID of the PNG encoder is ';
						display: e Clsid.
					^strm contents]]!

exampleGdipIEncoderFileExtensions
	"This example displays the file extensions for all of the available image encoders.

		RichTextPresenter showOn: self exampleGdipIEncoderFileExtensions
	"

	| strm |
	strm := String new writeStream.
	strm
		display: 'Encoder file extensions: ';
		cr.
	self encoderFileExtensions do: 
			[:e | 
			strm
				tab;
				display: e;
				cr].
	^strm contents!

exampleGdipIEncoderParameters
	"MSDN: Using GDI+ >  Using Image Encoders & Decoders > Determining Parameters Supported
	This example displays information about the image encoder for the jpeg mime type, as well as
	one of the encoder parameters - EncoderQuality.

		RichTextPresenter showOn: self exampleGdipIEncoderParameters
	"

	| image mimeType encoderClsid listSize encoderParameters encoder encoderParameterName valueType strm |
	image := GdiplusBitmap new.
	mimeType := 'image/jpeg'.
	encoderClsid := GdiplusImage encoderClsid: mimeType.
	listSize := image encoderParameterListSize: encoderClsid.
	encoderParameters := image encoderParameterList: encoderClsid.
	strm := String new writeStream.
	encoder := encoderParameters Parameter at: 2.
	encoderParameterName := (image class guidsEncoder detect: [:e | e value = encoder Guid]) 
				key.
	valueType := ULARGE_INTEGER atAddress: encoder Value.
	strm
		display: 'Parameters supported by mime type ' , mimeType;
		cr;
		cr;
		display: ('The parameter list requires %i bytes.' sprintfWith: listSize);
		cr;
		display: ('There are %i GpEncoderParameter objects in the array.' 
					sprintfWith: encoderParameters Count);
		cr;
		cr;
		display: 'Parameter 2: ' , encoderParameterName;
		cr;
		display: 'The GUID is ' , encoder Guid displayString;
		cr;
		display: 'The value type is ' , encoder Type displayString;
		cr;
		display: 'The number of values is ' , encoder NumberOfValues displayString;
		cr;
		display: '	The minimum possible quality value is ' , valueType lowPart displayString;
		cr;
		display: '	The maximum possible quality value is ' , valueType highPart displayString;
		cr.
	^strm contents!

exampleGdipIEncoders
	"MSDN:  Using GDI+ >  Using Image Encoders and Decoders > Listing Installed Encoders
	This example displays the mime types for all of the available image encoders.

		RichTextPresenter showOn: self exampleGdipIEncoders
	"

	| strm |
	strm := String new writeStream.
	strm
		display: 'Encoder mime types: ';
		cr.
	self encoderMimeTypes do: 
			[:e | 
			strm
				tab;
				display: e;
				cr].
	^strm contents!

exampleGdipIEncoderValues
	"MSDN: Using GDI+ >  Using Image Encoders & Decoders > Determining Parameters > EncoderValue
	A given encoder supports certain parameter categories, and for each of those categories, that encoder
	allows certain values.  This example displays information about the image encoder for the jpeg mime 
	type, as well as one of the encoder parameters - EncoderTransformation.

		RichTextPresenter showOn: self exampleGdipIEncoderValues
	"

	| image mimeType encoderClsid listSize encoderParameters encoder encoderParameterName valueType valueTypeName strm |
	image := GdiplusBitmap new.
	mimeType := 'image/jpeg'.
	encoderClsid := GdiplusImage encoderClsid: mimeType.
	listSize := image encoderParameterListSize: encoderClsid.
	encoderParameters := image encoderParameterList: encoderClsid.
	strm := String new writeStream.
	encoder := encoderParameters Parameter at: 1.
	encoderParameterName := (image class guidsEncoder detect: [:e | e value = encoder Guid]) 
				key.
	valueType := DWORDArray fromAddress: encoder Value yourAddress
				length: encoder NumberOfValues.
	valueTypeName := (image class enumsEncoderParameterValueType 
				detect: [:e | e value = encoder Type]) key.
	strm
		display: 'Parameters supported by mime type ' , mimeType;
		cr;
		cr;
		display: ('The parameter list requires %i bytes.' sprintfWith: listSize);
		cr;
		display: ('There are %i EncoderParameter objects in the array.' 
					sprintfWith: encoderParameters Count);
		cr;
		cr;
		display: 'Parameter 1: ' , encoderParameterName;
		cr;
		display: 'The GUID is ' , encoder Guid displayString;
		cr;
		display: 'The value type is ' , encoder Type displayString , ', which is type ' 
					, valueTypeName;
		cr;
		display: 'The number of values is ' , encoder NumberOfValues displayString;
		cr;
		display: 'The allowable values are :';
		cr.
	valueType do: 
			[:e | 
			strm
				display: '	' , e asInteger displayString , ': ' 
							, (image class enumsEncoderParameterValueType detect: [:t | t value = encoder Type]) key;
				cr].
	^strm contents!

exampleGdipIFlags
	"This example enumerates the ImageFlags values for an image.

		RichTextPresenter showOn: self exampleGdipIFlags
	"

	| image col strm |
	image := self fromFile: self fileResource pafEyeJpg.
	col := Dictionary new.
	strm := String new writeStream.
	strm
		display: 'Image flags for file ' , image filename , ': ';
		cr.
	GdiplusBase enumsImageFlags do: 
			[:e | 
			strm
				tab;
				display: (e key midString: e key size - 10 from: 11);
				nextPut: $ ;
				display: (73750 bitAnd: e value) = e value;
				cr].
	^strm contents!

exampleGdipIInterpMode
	"MSDN: GDI+ > Using GDI+ > Using Images, Bitmaps, and Metafiles 
		> Using Interpolation Mode to Control Image Quality During Scaling
	This example displays the same image drawn using different interpolation modes.

		self exampleGdipIInterpMode showExample
	"

	| bitmap image |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	bitmap := GdiplusBitmap extent: 600 @ 420.
	(bitmap graphics)
		interpolationMode: InterpolationModeLowQuality;
		drawImage: image
			at: 0 @ 0
			extent: (0.4 * image extent) rounded;
		drawString: 'LowQuality' at: 0 @ 0;
		interpolationMode: InterpolationModeBilinear;
		drawImage: image
			at: 0 @ 210
			extent: (0.4 * image extent) rounded;
		drawString: 'Bilinear' at: 0 @ 210;
		interpolationMode: InterpolationModeNearestNeighbor;
		drawImage: image
			at: 300 @ 0
			extent: (0.4 * image extent) rounded;
		drawString: 'NearestNeighbor' at: 300 @ 0;
		interpolationMode: InterpolationModeHighQualityBicubic;
		drawImage: image
			at: 300 @ 210
			extent: (0.4 * image extent) rounded;
		drawString: 'HighQualityBicubic' at: 300 @ 210.
	^bitmap!

exampleGdipIJPEGCompression
	"MSDN: Using GDI+ >  Using Image Encoders & Decoders > Setting JPEG Compression Level
	This example saves the same image to several different files, using different compression levels.
	It then reads all files back and displays the images.

		self exampleGdipIJPEGCompression showExample
	"

	| image encoderParameters encoderParameter quality images bitmap toFile points |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	encoderParameters := GpEncoderParameters new.
	encoderParameters Count: 1.
	(encoderParameter := encoderParameters Parameter first)
		Guid: EncoderQuality;
		Type: EncoderParameterValueTypeLong;
		NumberOfValues: 1.
	quality := DWORD new.
	encoderParameter Value: quality yourAddress.
	images := OrderedCollection new.
	#(0 30 70 100) do: 
			[:num |
			quality value: num.
			toFile := self fileResource fileLocator localFileSpecFor: 'test' , num displayString , '.jpg'.
			image saveToFile: toFile encoderParams: encoderParameters.
			images add: (GdiplusImage fromFile: toFile)].
	bitmap := GdiplusBitmap extent: 810 @ 610.
	points := {0 @ 0. 410 @ 0. 0 @ 310. 410 @ 310}.
	images keysAndValuesDo: 
			[:i :e |
			| point fileSize text |
			fileSize := ((File find: e filename) first fileSize / 1024) rounded.
			point := points at: i.
			text := (File splitFilenameFrom: e filename) , ' (' , fileSize displayString , ' kb)'.
			bitmap graphics
				drawImage: e
					at: point
					extent: 400 @ 300;
				drawString: text at: point].
	^bitmap!

exampleGdipILoadImage
	"This example loads an image from a file.

		self exampleGdipILoadImage showExample
	"

	^GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp!

exampleGdipILoadImages
	"From MSDN: Using GDI+ > Using Images, Bitmaps, and Metafiles > Loading and Displaying Bitmaps
	This example displays two images, one loaded from a disk file, the other from an Icon resource.

		self exampleGdipILoadImages showExample
	"

	| bitmap image |
	bitmap := GdiplusBitmap extent: 620 @ 200.
	image := GdiplusImage fromFile: 'Resources/Beach Ball.bmp'
				usingLocator: FileLocator installRelative.
	bitmap graphics drawImage: image at: 60 @ 10.
	image := GdiplusBitmap fromIcon: Icon warning.
	bitmap graphics drawImage: image at: 10 @ 60.
	^bitmap!

exampleGdipILosslessRotation
	"MSDN:  Using GDI+ >  Using Image Encoders & Decoders > Transforming a JPEG Without Loss
	This example creates a GdiplusImage, rotates it left, saves it under a new filename, and answers 
	a GdiplusImage from the new file.  Note: only image files whose width and height are
	multiples of 16 can be rotated with no loss in quality.

		self exampleGdipILosslessRotation showExample
	"

	| image encoderParameters toFilename encValue |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	"self assert: [image extent / 16 truncated * 16 = image extent]."
	encoderParameters := GpEncoderParameters new Count: 1.
	encValue := DWORD fromInteger: EncoderValueTransformRotate90.
	(encoderParameters Parameter first)
		Guid: EncoderTransformation;
		Type: EncoderParameterValueTypeLong;
		NumberOfValues: 1;
		Value: encValue yourAddress.
	toFilename := self fileResource fileLocator localFileSpecFor: 'testLosslessRotation.jpg'.
	image saveToFile: toFilename encoderParams: encoderParameters.
	^GdiplusImage fromFile: toFilename!

exampleGdipIMetadata
	"MSDN:  GDI+ >  Using GDI+ >  Using Images, Bitmaps, and Metafiles > Reading and Writing Metadata
	This example reads and displays a file's property items (metadata).

		SmalltalkWorkspaceDocument show workspace text: self exampleGdipIMetadata			
	"

	| image strm |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	strm := String writeStream.
	strm
		display: 'File: ' , image filename;
		cr;
		display: ('There are %i property items in the file.' sprintfWith: image propertiesCount);
		cr;
		display: ('The total size of all property items is %i bytes.' 
					sprintfWith: image propertiesSize);
		cr.
	image properties keysAndValuesDo: 
			[:i :e | 
			strm
				display: 'Property item ' , i displayString;
				cr;
				display: '  id: ' , e id hex;
				cr;
				display: '  type: ' , e typeName;
				cr;
				display: '  length: ' , e length displayString;
				cr].
	^strm contents!

exampleGdipIMetadata2
	"This example lists all of a file's image property items' descriptions and values.

		SmalltalkWorkspaceDocument show workspace text: self exampleGdipIMetadata2		
	"

	| image strm |
	image := GdiplusImage fromFile: self fileResource pafEyeJpg.
	(strm := String writeStream)
		nextPutAll: image filename;
		cr;
		cr.
	image properties do: 
			[:e | 
			strm
				nextPutAll: e id hex , ': ';
				nextPutAll: e name , ' = ';
				nextPutAll: e valueArray displayString;
				cr].
	^strm contents!

exampleGdipIMultiFrame
	"MSDN:  Using GDI+ >  Using Image Encoders & Decoders > Multiple-Frame Image 
	This example creates a multiple-frame image and saves it to disk.  It then loads the file
	and displays some frame information.

		RichTextPresenter showOn: self exampleGdipIMultiFrame
	"

	| encoderParameters parameter value encoderClsid image1 image2 image3 toFile strm guids |
	encoderParameters := GpEncoderParameters new Count: 1.
	parameter := encoderParameters Parameter first.
	value := DWORD new.
	parameter
		Guid: EncoderSaveFlag;
		Type: EncoderParameterValueTypeLong;
		NumberOfValues: 1;
		Value: value yourAddress.
	encoderClsid := GdiplusImage encoderClsid: 'image/tiff'.
	image1 := GdiplusImage fromFile: self fileResource pafEyeJpg.
	image2 := GdiplusImage fromFile: self fileResource pafFish32x32png.
	image3 := GdiplusImage fromFile: self fileResource pafRgb0000FF_100x100bmp.
	toFile := self fileResource fileLocator localFileSpecFor: 'testMultiframeImage.tif'.
	value value: EncoderValueMultiFrame.
	image1 saveToFile: toFile encoderParams: encoderParameters.
	value value: EncoderValueFrameDimensionPage.
	image1 saveAddImage: image2 encoderParams: encoderParameters.
	image1 saveAddImage: image3 encoderParams: encoderParameters.
	value value: EncoderValueFlush.
	image1 saveAdd: encoderParameters.
	image1 := GdiplusImage fromFile: toFile.
	guids := image1 frameDimensionsList.
	(strm := String new writeStream)
		display: 'Frame information for file: ' , image1 filename;
		cr;
		display: ('The number of dimensions is %i.' sprintfWith: image1 frameDimensionsCount);
		cr;
		display: ('The first dimension ID is %s.' sprintfWith: guids first displayString);
		cr;
		display: ('The number of frames in that dimension is %i.' 
					sprintfWith: (image1 frameCount: guids first));
		cr.
	^strm contents!

exampleGdipIMultiFrame2
	"MSDN:  Using GDI+ >  Using Image Encoders & Decoders > Copying Individual Frames 
	This example saves each frame in a multiple-frame image to its own file on disk.  
	It then loads all images from these files and displays them on a single bitmap.

		self exampleGdipIMultiFrame2 showExample
	"

	| image bitmap graphics srcFile dstFile0 dstFile1 dstFile2 |
	srcFile := self fileResource fileLocator localFileSpecFor: 'testMultiframeImage.tif'.
	(File exists: srcFile) ifFalse: [^nil].
	dstFile0 := self fileResource fileLocator localFileSpecFor: 'testMultiframe0.png'.
	dstFile1 := self fileResource fileLocator localFileSpecFor: 'testMultiframe1.png'.
	dstFile2 := self fileResource fileLocator localFileSpecFor: 'testMultiframe2.png'.
	image := GdiplusImage fromFile: srcFile.
	image selectActiveFrame: 0.
	image saveToFile: dstFile0.
	image selectActiveFrame: 1.
	image saveToFile: dstFile1.
	image selectActiveFrame: 2.
	image saveToFile: dstFile2.
	bitmap := GdiplusBitmap extent: 260 @ 350.
	graphics := bitmap graphics.
	image := GdiplusImage fromFile: dstFile0.
	graphics 
		drawImage: image
		at: 10 @ 10
		extent: 240 @ 180.
	image := GdiplusImage fromFile: dstFile1.
	graphics drawImage: image at: 10 @ 200.
	image := GdiplusImage fromFile: dstFile2.
	graphics drawImage: image at: 10 @ 240.
	^bitmap!

exampleGdipIMultiFrame3
	"This example prompts for a multi-frame image file, e.g., an animated gif.  
	It then displays every sixth frame in a separate view.

		self exampleGdipIMultiFrame3
	"

	| frames |
	frames := GdiplusImage prompt frames.
	1 to: frames size
		by: 6
		do: [:i | ImagePresenter show: 'Basic image' on: (frames at: i)]!

exampleGdipIPrinting1
	"This example prints an image, plain and simple.  No units conversion or scaling is done.
	The sample image has an extent of 909@682 which in default units of hundredths of inches
	is 9.09 in. wide by 6.82 in. high.  If the prompted-for printer is set for portrait, the image will
	be clipped, if set for landscape the full picture should print.

		self exampleGdipIPrinting1
	"

	| printer graphics image |
	printer := PrinterCanvas choose.
	graphics := GdiplusGraphics fromCanvas: printer.
	image := GdiplusImage fromFile: self fileResource pafSeattleNightJpg.
	printer startDoc.
	graphics drawImage: image.
	printer endDoc!

exampleGdipIPrinting2
	"This example draws an image scaled to fit the page's longer dimension.  It prompts for a 
	printer and displays a preview, then prompts for whether the image should be printed.

		self exampleGdipIPrinting2
	"

	| printer graphics image pageExtent layoutRect bitmap graphicsB |
	printer := PrinterCanvas choose.
	graphics := GdiplusGraphics fromCanvas: printer.
	image := GdiplusImage fromFile: self fileResource pafSeattleNightJpg.
	"Convert pixels to hundredths of inches."
	pageExtent := (printer extent * 100 / graphics resolution) truncated.
	pageExtent x < pageExtent y ifTrue: [image rotateLeft].
	layoutRect := Point zero extent: (image extent scaledTo: pageExtent) truncated.
	"Preview image"
	bitmap := GdiplusBitmap extent: (pageExtent / 2) rounded.
	graphicsB := bitmap graphics.
	graphicsB scaleTransform: 0.5 @ 0.5 order: nil.
	graphicsB drawImage: image rectangle: layoutRect.
	bitmap showExample.
	"Print image"
	(MessageBox confirm: 'Ok to print?') ifFalse: [^nil].
	printer startDoc.
	graphics drawImage: image rectangle: layoutRect.
	printer endDoc!

exampleGdipIPrinting3
	"This example prints some example bitmaps.  The page is divided into three sections - 2 quarter pages at the top and a half page at the bottom.  

		self exampleGdipIPrinting3
	"

	| printer graphics image1 image2 image3 res margin pageSize layoutSize boundingRect layoutRect |
	image1 := self exampleGdipIMultiFrame2.
	image2 := GdiplusGraphics exampleGdipGDrawingShapes rotateLeft.
	image3 := GdiplusHatchBrush exampleGdipHBStyles.
	printer := PrinterCanvas choose.
	printer ifNil: [^self].
	graphics := GdiplusGraphics fromCanvas: printer.
	"Calculate 1/4 of page in hundredths of inches."
	res := graphics resolution.
	pageSize := ((printer extent x / res x) @ (printer extent y / res y) * 100) truncated.
	margin := 25.
	layoutSize := ((pageSize - margin) / 2) truncated.
	pageSize x > pageSize y ifTrue: [graphics rotate: 90 at: pageSize x @ 0].
	"Print first image in upper left."
	printer startDoc.
	boundingRect := Point zero extent: layoutSize.
	layoutRect := image1 rectScaledToFit: boundingRect centered: true.
	graphics drawImage: image1 rectangle: layoutRect.
	graphics drawRectangle: boundingRect.
	"Print second image in upper right."
	boundingRect := (pageSize x - layoutSize x) @ 0 extent: layoutSize.
	layoutRect := image2 rectScaledToFit: boundingRect centered: true.
	graphics drawImage: image2 rectangle: layoutRect.
	graphics drawRectangle: boundingRect.
	"Print third image in lower half."
	boundingRect := 0 @ (pageSize y - layoutSize y) extent: pageSize x @ layoutSize y.
	layoutRect := image3 rectScaledToFit: boundingRect centered: true.
	graphics drawImage: image3 rectangle: layoutRect.
	graphics drawRectangle: boundingRect.
	printer endDoc!

exampleGdipIPrinting4LabeledToAPage
	"This example prompts for and prints 4 images on a page.  First the printer dialog is shown and
	then a file open dialog (four times).  A text label (e.g., filename or date) is printed for each 
	picture, within the picture's frame at the lower right, taking into account any rotation.  A preview 
	window shows what the printed page will look like and a prompt is issued whether to print or not.

		self exampleGdipIPrinting4LabeledToAPage
	"

	| printer graphicsPrn res pagesize isPrinterPortrait margin quarterExtent font images image rotate extents corners bitmap graphicsB labels angle extent measure drawBlock x |
	printer := PrinterCanvas choose.
	graphicsPrn := GdiplusGraphics fromCanvas: printer.
	res := graphicsPrn resolution.
	pagesize := (printer extent / res * 100) truncated.	"hundredths of inches"
	isPrinterPortrait := pagesize x < pagesize y.
	margin := 25.	"1/4 inch"
	"Calculate 1/4 of page in hundredths of inches."
	quarterExtent := ((printer extent / res * 100 - margin) / 2) truncated.
	font := GdiplusFont name: 'Arial' pointSize: 6.

	"Load images, rotate as needed, calculate extents, assign labels."
	images := Array new: 4.
	rotate := Array new: 4.
	extents := Array new: 4.
	labels := Array new: 4.
	1 to: 4
		do: 
			[:i |
			image := GdiplusImage prompt.
			images at: i put: image.
			labels at: i put: (File splitStemFrom: image filename).
			image isLandscape = isPrinterPortrait
				ifTrue: 
					[rotate at: i put: true.
					extents at: i put: (image extent transpose scaledTo: quarterExtent) truncated]
				ifFalse: 
					[rotate at: i put: false.
					extents at: i put: (image extent scaledTo: quarterExtent) truncated]].

	"Calculate corners for each image."
	corners := Array new: 4.
	corners at: 1 put: Point zero.
	corners at: 2 put: ((extents at: 1) x + margin) @ 0.
	corners at: 3 put: 0 @ (quarterExtent y + margin).
	corners at: 4 put: ((extents at: 3) x + margin) @ (corners at: 3) y.

	"This could easily be a separate method."
	drawBlock := 
			[:graphics :scale |
			1 to: 4
				do: 
					[:i |
					angle := (rotate at: i) ifTrue: [90] ifFalse: [0].
					extent := (rotate at: i) ifTrue: [(extents at: i) transpose] ifFalse: [extents at: i].
					x := (rotate at: i) ifTrue: [(extents at: i) x] ifFalse: [0].
					measure := graphics measureString: (labels at: i) font: font.
					graphics
						resetTransform;
						scaleTransform: scale order: nil;
						translateTransform: (corners at: i);
						rotate: angle at: x @ 0;
						drawImage: (images at: i)
							at: 0 @ 0
							extent: extent;
						drawString: (labels at: i)
							font: font
							at: extent - measure
							format: nil
							brush: GdiplusSolidBrush red]].

	"Preview images.  Draw them on a bitmap that's scaled to half the printer page."
	bitmap := GdiplusBitmap extent: (pagesize / 2) rounded.
	graphicsB := bitmap graphics.
	drawBlock value: graphicsB value: 0.5 @ 0.5.
	bitmap showExample.

	"Print images"
	(MessageBox confirm: 'Ok to print?') ifFalse: [^nil].
	printer startDoc.
	drawBlock value: graphicsPrn value: 1 @ 1.
	printer endDoc!

exampleGdipIPropertiesCopy
	"This example takes an image from an existing file, resizes the image, copies all
	of the first image's property items to the second, and saves the second image to file.  
	It then loads the second file image and answers the image.

		self exampleGdipIPropertiesCopy showExample
	"

	| image resizedImage toFile |
	image := self fromFile: self fileResource pafEyeJpg.
	resizedImage := GdiplusBitmap fromImage: image scaledBy: 1 / 4.
	resizedImage copyPropertiesFrom: image.
	toFile := self fileResource fileLocator localFileSpecFor: 'testPropertiesCopy.jpg'.
	resizedImage saveToFile: toFile.
	^self fromFile: toFile!

exampleGdipIPropertyItem
	"MSDN:  GDI+ >  GDI+ Reference >  Classes >  Image >  Image Methods > SetPropertyItem 
	This example creates an Image object based on a jpeg file (some image formats, e.g., bmp,
	don't support properties), sets the Title property, then retrieves and displays the new title.  Note
	that it does not save the image back to file.

		Notification signal: 'The image title is: ' , self exampleGdipIPropertyItem			
	"

	| image title propItem |
	image := GdiplusImage fromFile: 'Resources/LagoonSideBar.jpg'
				usingLocator: FileLocator installRelative.
	title := 'Lagoon Sidebar'.
	(propItem := GpPropertyItem new)
		id: PropertyTagImageTitle;
		length: title size;
		Type: PropertyTagTypeASCII;
		Value: title yourAddress.
	image property: propItem.
	propItem := title := nil.
	propItem := image propertyFromId: PropertyTagImageTitle.
	^title := AnsiString fromAddress: propItem Value!

exampleGdipIPropertyItems
	"This example prompts for a directory.  For each jpeg in the directory, the filename,
	number of properties, and file extent are displayed.   It also checks for certain properties 
	of each image and displays them if they exist.

		RichTextPresenter show value: self exampleGdipIPropertyItems
	"

	| directory filenames strm image |
	(directory := #{BrowseFolderDialog} value new
				value: 'c:\my documents';
				showModal) ifNil: [^nil].
	filenames := (File find: (File appendPathDelimiter: directory) , '*.jpg') 
				collect: [:e | e path].
	strm := String writeStream.
	filenames do: 
			[:filename | 
			image := GdiplusImage fromFile: filename.
			"Force realization now."
			(
			[image handle.
			true] on: Error do: [:err | false]) 
				ifTrue: 
					[strm
						nextPutAll: image propertiesCount displayString;
						nextPutAll: ': ';
						nextPutAll: filename;
						nextPutAll: ', extent = ';
						nextPutAll: image extent displayString;
						cr.
					(image hasPropertyId: PropertyTagExifUserComment) 
						ifTrue: 
							[strm
								tab;
								nextPutAll: 'PropertyTagExifUserComment: ';
								nextPutAll: (image propertyFromId: 37510) valueArray asString trimNulls trimBlanks;
								cr].
					(image hasPropertyId: PropertyTagSoftwareUsed) 
						ifTrue: 
							[strm
								tab;
								nextPutAll: 'PropertyTagSoftwareUsed: ';
								nextPutAll: (image propertyFromId: 305) valueArray asString trimNulls trimBlanks;
								cr].
					(image hasPropertyId: PropertyTagThumbnailWidth) 
						ifTrue: 
							[strm
								tab;
								nextPutAll: 'PropertyTagThumbnailWidth: ';
								nextPutAll: (image propertyFromId: 20499) valueArray first displayString;
								cr].
					(image hasPropertyId: PropertyTagThumbnailData) 
						ifTrue: 
							[strm
								tab;
								nextPutAll: 'Image has PropertyTagThumbnailData';
								cr]]].
	^strm contents!

exampleGdipISaveFrames
	"This example prompts for a multi-frame file (e.g., an animated gif) and saves each frame to a separate file.
	Output files are saved in the GdiplusTests file resource directory.

		self exampleGdipISaveFrames
	"

	GdiplusImage prompt saveFramesToFiles: self fileResource fileLocator basePath!

exampleGdipISkewing
	"MSDN: GDI+ > Using GDI+ > Using Images, Bitmaps, and Metafiles 
	> Rotating, Reflecting, and Skewing Images

		self exampleGdipISkewing showExample
	"

	| bitmap image graphics |
	bitmap := GdiplusBitmap extent: 300 @ 250.
	graphics := bitmap graphics.
	image := (GdiplusImage fromFile: 'Resources/Beach Ball.bmp'
				usingLocator: FileLocator installRelative) thumbnailWithHeight: 75.
	graphics
		drawImage: image at: 10 @ 10;
		drawImage: image points: {200 @ 20. 110 @ 200. 250 @ 50}.
	^bitmap!

exampleGdipIThumbnails
	"MSDN: GDI+ > Using GDI+ > Using Images, Bitmaps, and Metafiles > Creating Thumbnail Images

		self exampleGdipIThumbnails	 showExample
	"

	| bitmap image thumbnail |
	bitmap := GdiplusBitmap extent: 600 @ 300.
	image := GdiplusImage fromFile: 'Resources/Beach Ball.bmp'
				usingLocator: FileLocator installRelative.
	thumbnail := image thumbnailScaledBy: 0.4.
	(bitmap graphics)
		drawImage: image at: 10 @ 10;
		drawImage: thumbnail at: 10 @ 200.
	^bitmap!

fileTypes
	"Answer an array of file types for use with the <FileOpenDialog>."

	| all types |
	all := String writeStream.
	types := OrderedCollection new.
	self decoders do: 
			[:each |
			| extensions |
			extensions := each FilenameExtension asString asLowercase.
			all
				nextPut: $;;
				nextPutAll: extensions.
			types addLast: {'<1s> (<2s>)' expandMacrosWith: each FormatDescription asString with: extensions.
						extensions}].
	types
		addLast: {'All Images'. all contents};
		addLast: FileDialog allFilesType.
	^types asArray!

fromByteArray: aByteArray 
	"Answer an instance of the receiver created from data in aByteArray. The results is an instance with a persistent
	initializer that can be used after an image reload or after passing through STB serialization/deserialization."

	^self fromInitializer: (GdiplusImageFromBytesInitializer bytes: aByteArray)!

fromFile: aFilename
	"Answer an instance of the receiver created from data in the specified file."

	^self fromFile: aFilename usingLocator: FileLocator default!

fromFile: aFilename usingLocator: aFileLocator
	"Answer an instance of the receiver created from data in the specified file."

	^self fromInitializer: (GdiplusImageFromFileInitializer filename: aFilename
				fileLocator: aFileLocator)!

fromIStream: pStream
	"Answer an instance of the receiver created from data in the specified IStream."

	^self fromInitializer: (GdiplusImageFromIStreamInitializer iStream: pStream)!

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

	| numCodecs lib codecs buf byteSize status |
	numCodecs := DWORD new.
	byteSize := DWORD new.
	lib := GdiplusLibrary default.
	status := aBoolean 
				ifTrue: [lib gdipGetImageEncodersSize: numCodecs size: byteSize]
				ifFalse: [lib gdipGetImageDecodersSize: numCodecs size: byteSize].
	status = Ok ifFalse: [^GdiplusError signal: 'Error in GdipGetImage[De|En]codersSize' with: status].
	numCodecs := numCodecs asInteger.
	byteSize := byteSize asInteger.
	buf := ExternalMemory new: byteSize.
	status := aBoolean 
				ifTrue: 
					[lib 
						gdipGetImageEncoders: numCodecs
						size: byteSize
						encoders: buf]
				ifFalse: 
					[lib 
						gdipGetImageDecoders: numCodecs
						size: byteSize
						decoders: buf].
	status = Ok ifFalse: [^GdiplusError signal: 'Error in GdipGetImage[De|En]coders' with: status].
	codecs := StructureArray 
				fromAddress: buf
				length: numCodecs
				elementClass: GpImageCodecInfo.
	^codecs!

icon
	"Answers an Icon that can be used to represent this class"

	^Image icon!

mimeTypeForExtension: aString
	"Answer a String mime type associated with the file extension aString.

		self mimeTypeForExtension: 'jpg'
	"

	^(self encoders
		detect: [:e | (e FilenameExtension asString asLowercase indexOfSubCollection: aString asLowercase) > 0]
		ifNone: []) ifNotNil: [:encoder | encoder MimeType asString]!

prompt
	"Prompt for an image file.  Answer an Image created from that file or nil."

	^((FileOpenDialog new fileTypes: self fileTypes)
		defaultExtension: 'png';
		showModal) ifNotNil: [:file | self fromFile: file]! !
!GdiplusImage class categoriesFor: #decoderFileExtensions!enquiries!public! !
!GdiplusImage class categoriesFor: #decoderMimeTypes!enquiries!public! !
!GdiplusImage class categoriesFor: #decoders!enquiries!public! !
!GdiplusImage class categoriesFor: #encoderClsid:!enquiries!private! !
!GdiplusImage class categoriesFor: #encoderClsidForExtension:!enquiries!private! !
!GdiplusImage class categoriesFor: #encoderFileExtensions!enquiries!public! !
!GdiplusImage class categoriesFor: #encoderMimeTypeForExtension:!enquiries!private! !
!GdiplusImage class categoriesFor: #encoderMimeTypes!enquiries!public! !
!GdiplusImage class categoriesFor: #encoders!enquiries!public! !
!GdiplusImage class categoriesFor: #exampleGdipIDecoderFileExtensions!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIDecoders!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIEncoderClsid!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIEncoderFileExtensions!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIEncoderParameters!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIEncoders!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIEncoderValues!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIFlags!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIInterpMode!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIJPEGCompression!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipILoadImage!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipILoadImages!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipILosslessRotation!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIMetadata!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIMetadata2!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIMultiFrame!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIMultiFrame2!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIMultiFrame3!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipIPrinting1!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipIPrinting2!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipIPrinting3!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipIPrinting4LabeledToAPage!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipIPropertiesCopy!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIPropertyItem!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIPropertyItems!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipISaveFrames!examples!public! !
!GdiplusImage class categoriesFor: #exampleGdipISkewing!examples!public!sunit! !
!GdiplusImage class categoriesFor: #exampleGdipIThumbnails!examples!public!sunit! !
!GdiplusImage class categoriesFor: #fileTypes!enquiries!public! !
!GdiplusImage class categoriesFor: #fromByteArray:!instance creation!public! !
!GdiplusImage class categoriesFor: #fromFile:!instance creation!public! !
!GdiplusImage class categoriesFor: #fromFile:usingLocator:!instance creation!public! !
!GdiplusImage class categoriesFor: #fromIStream:!instance creation!public! !
!GdiplusImage class categoriesFor: #getImageCodecs:!helpers!private! !
!GdiplusImage class categoriesFor: #icon!constants!public! !
!GdiplusImage class categoriesFor: #mimeTypeForExtension:!enquiries!private! !
!GdiplusImage class categoriesFor: #prompt!instance creation!public! !

