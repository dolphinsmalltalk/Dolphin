"Filed out from Dolphin Smalltalk"!

Bitmap subclass: #DIBSection
	instanceVariableNames: 'depth imageBits'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DIBSection guid: (GUID fromString: '{f44c914a-2b3f-11d3-8368-7a8b5a000000}')!

DIBSection comment: ''!

!DIBSection categoriesForClass!Graphics-Tools! !

!DIBSection methodsFor!

baseLoadFlags
	"Answer the basic load flags to be used when calling LoadImage() to realize the receiver."

	^##(LR_COLOR | LR_CREATEDIBSECTION)!

cacheInfo
	"Private - Cache info about the receiver garnered from the bitmap itself.
	Since we also grab a pointer to the image bits, it is now possible to scribble
	all over a DIB loaded from resources/a file. This should only get invoked
	for DIBSections loaded from a resource or file."

	| bitmapInfo |
	bitmapInfo := self getInfo.
	extent := bitmapInfo extent.
	depth := bitmapInfo depth.
	imageBits := bitmapInfo bmBits!

clearCached
	"Private - Clear down the receiver's handles and cached info."
 
	super clearCached.
	imageBits := nil.
	"The depth may doesn't change after creation, so we don't clear it."!

copyToGlobalHeap
	| hGlobal pGlobal ds header headerSize endHeader colorTable imageSize |
	ds := self getDIBSECTION.
	header := ds dsBmih.
	colorTable := header biBitCount <= 8 ifTrue: [self getColorTable bytes] ifFalse: [#[]].
	headerSize := header byteSize.
	imageSize := header biSizeImage.
	hGlobal := KernelLibrary default globalAlloc: ##(GHND | GMEM_DDESHARE)
				dwBytes: headerSize + colorTable size + imageSize.
	pGlobal := KernelLibrary default globalLock: hGlobal.
	pGlobal
		replaceFrom: 1
		to: headerSize
		with: header
		startingAt: 1.
	pGlobal
		replaceFrom: headerSize + 1
		to: (endHeader := headerSize + colorTable size)
		with: colorTable
		startingAt: 1.
	pGlobal
		replaceFrom: endHeader + 1
		to: endHeader + imageSize
		with: ds dsBm bmBits
		startingAt: 1.
	KernelLibrary default globalUnlock: hGlobal.
	^hGlobal!

createHandle
	"Private - Answer an external handle to the image represented by the receiver.
	If the receiver has an identifier, then we attempt to load the external resource,
	otherwise we create a DIBSECTION for manipulation."

	| info dibSection |
	identifier isNil ifFalse: [^super createHandle].
	info := BITMAPINFOHEADER new.
	info
		biWidth: extent x;
		biHeight: extent y negated;
		biPlanes: 1;
		biBitCount: depth;
		biCompression: BI_RGB.
	"It would be nice if we could set the bitmap resolution, and we can into biX/YPelsPerMeter, but there is no point as it does not appear to persist."

	"Slot for pointer to the bitmap bits"
	imageBits := ExternalAddress new.

	"Create the bitmap but differently for RGB and paletized usage"
	depth > 8
		ifTrue: 
			["RGB usage"
			dibSection := GDILibrary default
						createDIBSection: 0
						pbmi: info
						iUsage: DIB_RGB_COLORS
						ppvBits: imageBits
						hSection: 0
						dwOffset: 0]
		ifFalse: 
			[| palBitmap canvas bits |
			"Paletized usage"
			bits := DWORD new.
			palBitmap := Bitmap
						width: 1
						height: 1
						planes: 1
						bitsPerPixel: depth
						bits: bits.
			canvas := palBitmap canvas.
			dibSection := GDILibrary default
						createDIBSection: canvas asParameter
						pbmi: info
						iUsage: DIB_PAL_COLORS
						ppvBits: imageBits
						hSection: 0
						dwOffset: 0.
			palBitmap free].
	^dibSection!

depth
	"Answer the colour depth of the receiver."

	depth isNil ifTrue: [self cacheInfo].
	^depth!

erase
	"Private - Erase area occupied by the DIB."

	self canvas 
		fillRectangle: (RECT extent: self extent) 
		brush: Brush white!

errorInappropriateColorTable: aRGBQUADArray
	"Raise an error that the receiver cannot hold aRGBQUADArray as its colour table"

	^self error: 'Inappropriate color table'!

getColorTable
	"Answer a StructureArray of RGBQUADs which is the colour table for the receiver.
	Answer nil if the receiver has no color table"

	| bits canvas size quads |
	bits := self depth.
	bits > 8 ifTrue: [^nil].
	size := 2 raisedToInteger: bits.
	quads := StructureArray length: size elementClass: RGBQUAD.
	canvas := self canvas.
	size := GDILibrary default 
				getDIBColorTable: canvas asParameter
				uStartIndex: 0
				cEntries: size
				pColors: quads.
	size == 0 ifTrue: [^Win32Error signal].
	quads length: size.
	^quads!

getDIBSECTION
	"Answers a DIBSECTION structure class containing details about the receiver."

	| ds |
	ds := DIBSECTION new.
	self getData: ds.
	^ds!

imageBits
	"Answer the handle of the receiver's image bits"

	imageBits isNil ifTrue: [self cacheInfo].
	^imageBits!

resolution
	"Answer an <Point> specifying the horizontal and vertical DPI of the receiver."

	| info bmih resX |
	info := self getDIBSECTION.
	bmih := info dsBmih.
	resX := bmih biXPelsPerMeter.
	resX == 0
		ifTrue: 
			["Unspecified, assume system DPI"
			^self canvas resolution].
	^resX @ bmih biYPelsPerMeter!

setColorTable: anRGBQUADArray 
	"Sets the colour table for the receiver to be that in anRGBQUADArray.
	Signals #errorInvalidColorTable if the table is the wrong size, or not appropriate,
	for the receiver"

	| bits size newSize canvas |
	bits := self depth.
	size := 2 raisedToInteger: bits.
	anRGBQUADArray size = size 
		ifFalse: 
			["Inappropriate colour table size"

			self errorInappropriateColorTable: anRGBQUADArray].
	canvas := self canvas.
	newSize := GDILibrary default 
				setDIBColorTable: canvas asParameter
				uStartIndex: 0
				cEntries: size
				pColors: anRGBQUADArray.
	size == newSize ifFalse: [^Win32Error signal]!

width: w height: h depth: d
	"Private - Initializes the receiver to dimensions width*height. The number of colour bits
	per pixel are given by depth. Note that paletized DIBs are now supported but an
	appropriate color table will need to be set using #setColorTable before using the 
	DIBSection. Answer the receiver."

	extent := w@h.
	depth := d! !

!DIBSection categoriesForMethods!
baseLoadFlags!constants!public! !
cacheInfo!helpers!private! !
clearCached!initializing!private! !
copyToGlobalHeap!accessing!private! !
createHandle!private!realizing/unrealizing! !
depth!accessing!public! !
erase!drawing!private! !
errorInappropriateColorTable:!exceptions!public! !
getColorTable!accessing!public! !
getDIBSECTION!accessing!public! !
imageBits!accessing!public! !
resolution!accessing!public! !
setColorTable:!accessing!public! !
width:height:depth:!initializing!private! !
!

!DIBSection class methodsFor!

fromGlobalHandle: anExternalHandle
	"Answer a new <DIBSection> instantiated with header and bits from the global memory block
	with the specified handle. The memory block is assumed to contain a BITMAPINFO structure
	followed by the image bits."

	| pBitmap header offset dibSection |
	pBitmap := KernelLibrary default globalLock: anExternalHandle.
	header := BITMAPINFOHEADER fromAddress: pBitmap.
	dibSection := self
				width: header biWidth
				height: header biHeight
				depth: header biBitCount.
	offset := header size + 1.
	header biBitCount <= 8
		ifTrue: 
			[| colorTable |
			colorTable := StructureArray
						fromAddress: (pBitmap yourAddress + header byteSize) asExternalAddress
						length: (2 raisedToInteger: header biBitCount)
						elementClass: RGBQUAD.
			colorTable beUnfinalizable.
			dibSection setColorTable: colorTable.
			offset := offset + colorTable size].
	dibSection imageBits
		replaceFrom: 1
		to: header biSizeImage
		with: pBitmap
		startingAt: offset.
	KernelLibrary default globalUnlock: anExternalHandle.
	^dibSection!

width: width height: height
	"Answers a true-colour DIBSection bitmap of dimensions width*height*24 bits/pixel."

	^self
		width: width 
		height: height 
		depth: 24
		!

width: width height: height depth: depth
	"Answers a DIBSection bitmap of dimensions width*height. The number of colour bits
	per pixel are given by depth, which must be one of 1,4,8,16,24 or 32 (although
	see instance side for further current limitations)."

	^super new
		width: width 
		height: height 
		depth: depth
		! !

!DIBSection class categoriesForMethods!
fromGlobalHandle:!instance creation!public! !
width:height:!instance creation!public! !
width:height:depth:!instance creation!public! !
!

