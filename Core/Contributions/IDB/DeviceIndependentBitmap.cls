"Filed out from Dolphin Smalltalk"!

Bitmap subclass: #DeviceIndependentBitmap
	instanceVariableNames: 'depth bitmapStruct bitmapInfoStruct bitmapInfoHeaderStruct dibSectionStruct'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DeviceIndependentBitmap guid: (GUID fromString: '{48f23686-5426-11d3-998b-bca753d3b065}')!
DeviceIndependentBitmap comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DeviceIndependentBitmap categoriesForClass!Graphics-Tools!IDB Goodies! !
!DeviceIndependentBitmap methodsFor!

baseLoadFlags
	"Answer the basic load flags to be used when calling LoadImage() to realize the receiver."

	^##(LR_COLOR | LR_CREATEDIBSECTION)!

bitmapInfoStruct
	"Answer the value of the receiver's instance variable bitmapInfoStruct"

	self cacheInfo.
	^bitmapInfoStruct!

bitmapStruct
	"Answer the value of the receiver's instance variable bitmapStruct"

	self cacheInfo.
	^bitmapStruct!

cacheInfo
	"Cache all the information about the receiver that we can, but only once. We save 
	the structures containing the information, rather than just the information itself, as 
	these may be useful later.
	Note that this works for both created and fileIn DeviceIndependentBitmaps"

	dibSectionStruct isNil ifFalse: [^self].
	dibSectionStruct := DIBSECTION new.
	self getData: dibSectionStruct.
	bitmapStruct := BITMAP fromBytes: dibSectionStruct dsBm.
	bitmapInfoHeaderStruct := BITMAPINFOHEADER fromBytes: dibSectionStruct dsBmih.
	bitmapInfoStruct := BITMAPINFO colorDepth: bitmapInfoHeaderStruct biBitCount.
	bitmapInfoStruct bmiHeader: bitmapInfoHeaderStruct.
	bitmapInfoHeaderStruct biBitCount <= 8 
		ifTrue: [bitmapInfoStruct bmiColors: self getColorTable bytes]!

clearCached
	"Private - Not sure if this is absolutely necessary..."

	super clearCached.
	bitmapStruct := bitmapInfoStruct := bitmapInfoHeaderStruct := dibSectionStruct := nil!

copyToClipboard
	"Copy the receiver to the Clipboard using the DIBSection format"

	Clipboard current setDeviceIndependentBitmap: self copy!

createHandle
	"If the receiver is not a resource (identifier not nil) then we create it here. Some of the
	options, (bottom up, no compression, RGB not PAL etc) are hard wired here but
	could be dynamically altered if this is not the format required"

	| bitmapInfo |
	identifier isNil ifFalse: [^super createHandle].
	bitmapInfo := BITMAPINFO colorDepth: depth.
	bitmapInfo
		bmiHeader: ((BITMAPINFOHEADER new)
					biWidth: extent x;
					biHeight: extent y;
					biPlanes: 1;
					biBitCount: depth;
					biCompression: BI_RGB;
					biSizeImage: 0;
					biXPelsPerMeter: 0;
					biYPelsPerMeter: 0;
					biClrUsed: 0;
					biClrImportant: 0;
					yourself);
		bmiColors: (self class colorTableForDepth: depth) bytes.
	^GDILibrary default 
		createDIBSection: 0
		pbmi: bitmapInfo
		iUsage: DIB_RGB_COLORS
		ppvBits: ExternalAddress new
		hSection: 0
		dwOffset: 0!

depth
	"Answer the bitmap color depth.
	Note that this does not just answer the depth IV as that is not initialized by fileIn bitmaps"

	self cacheInfo.
	^bitmapInfoHeaderStruct biBitCount!

erase
	"Clear the receivers image to white"

	self canvas fillRectangle: (Rectangle origin: Point zero extent: self extent)
		brush: Brush white!

extent
	"Answer the bitmap extent
	Note that this does not just answer the extent IV as that is not initialized by fileIn bitmaps"

	self cacheInfo.
	^bitmapInfoHeaderStruct biWidth @ bitmapInfoHeaderStruct biHeight!

getColorTable
	"Answer the color table being used by the receiver. If there is no table (the color
	depth > 8) then we answer nil. We make an attempt to check the number of colors used, and
	create a table of that size, but most bitmaps will probably provide a full table"

	| colorsUsed table colorsLoaded |
	self cacheInfo.
	bitmapInfoHeaderStruct biBitCount > 8 ifTrue: [^nil].
	colorsUsed := bitmapInfoHeaderStruct biClrUsed = 0 
				ifTrue: [2 raisedToInteger: bitmapInfoHeaderStruct biBitCount]
				ifFalse: [bitmapInfoHeaderStruct biClrUsed].
	table := StructureArray length: colorsUsed elementClass: RGBQUAD.
	colorsLoaded := GDILibrary default 
				getDIBColorTable: self canvas asParameter
				uStartIndex: 0
				cEntries: colorsUsed
				pColors: table.
	colorsLoaded == colorsUsed ifFalse: [^Win32Error signal].
	^table!

imageBytes
	"Answer a ByteArray initialized from the receivers image bits"

	self cacheInfo.
	^ByteArray fromAddress: bitmapStruct bmBits length: bitmapInfoHeaderStruct biSizeImage!

saveToFile: aString
	"Save the receiver to a file named aString. Overwrites without warning"

	| stream |
	stream := FileStream write: aString text: false.
	[self saveToStream: stream] ensure: [stream close]!

saveToStream: aStream
	"Save the receiver to aStream"

	| bitmapFileHeaderStruct |
	self cacheInfo.
	bitmapFileHeaderStruct := BITMAPFILEHEADER new.
	bitmapFileHeaderStruct
		bfType: 19778;
		bfSize: bitmapFileHeaderStruct size + bitmapInfoStruct size 
					+ bitmapInfoHeaderStruct biSizeImage;
		bfOffBits: bitmapFileHeaderStruct size + bitmapInfoStruct size.
	aStream
		nextPutAll: bitmapFileHeaderStruct bytes;
		nextPutAll: bitmapInfoStruct bytes;
		nextPutAll: self imageBytes!

setColorTable: anRGBQUADArray
	"If the receivers color depth is less than or equal to 8 then set its color table 
	to anRGBQuadArray."

	| colorsUsed colorsSet |
	self cacheInfo.
	bitmapInfoHeaderStruct biBitCount <= 8 ifFalse: [^self].
	colorsUsed := 2 raisedToInteger: bitmapInfoHeaderStruct biBitCount.
	self assert: [anRGBQUADArray size = colorsUsed].
	colorsSet := GDILibrary default 
				setDIBColorTable: self canvas asParameter
				uStartIndex: 0
				cEntries: colorsUsed
				pColors: anRGBQUADArray.
	colorsUsed = colorsSet ifFalse: [^Win32Error signal].

	"reset the cache"
	bitmapInfoStruct bmiColors: self getColorTable bytes!

width: widthInteger height: heightInteger depth: depthInteger
	"Answer a new instance of the required type. 
	Note that the extent and depth IVs are only used by the createHandle method, any requests
	for the receivers extent and depth will use the cached information"

	self assert: [#(1 4 8 16 24 32) includes: depthInteger].
	extent := widthInteger @ heightInteger.
	depth := depthInteger.

	"IRV"
	^self! !
!DeviceIndependentBitmap categoriesForMethods!
baseLoadFlags!constants!public! !
bitmapInfoStruct!accessing!public! !
bitmapStruct!accessing!public! !
cacheInfo!helpers!private! !
clearCached!helpers!private! !
copyToClipboard!copying!public! !
createHandle!public!realizing/unrealizing! !
depth!accessing!public! !
erase!drawing!public! !
extent!accessing!public! !
getColorTable!accessing!public! !
imageBytes!accessing!public! !
saveToFile:!file operations!public! !
saveToStream:!file operations!public! !
setColorTable:!accessing!public! !
width:height:depth:!initializing!public! !
!

!DeviceIndependentBitmap class methodsFor!

colorTableDepth1
	"Answer a default color table to be used for depth 1 (monochrome) bitmaps"

	^(StructureArray length: 2 elementClass: RGBQUAD)
		at: 1
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 0;
					rgbGreen: 0);
		at: 2
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbBlue: 255;
					rgbGreen: 255);
		yourself!

colorTableDepth16
	^StructureArray length: 1 elementClass: RGBQUAD!

colorTableDepth24
	^StructureArray length: 1 elementClass: RGBQUAD!

colorTableDepth32
	^StructureArray length: 1 elementClass: RGBQUAD!

colorTableDepth4
	"Answer a default color table to be used for depth 4 (VGA) bitmaps"

	^(StructureArray length: 16 elementClass: RGBQUAD)
		at: 1
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 0;
					rgbGreen: 0);
		at: 2
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbBlue: 0;
					rgbGreen: 0);
		at: 3
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 0;
					rgbGreen: 128);
		at: 4
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbBlue: 0;
					rgbGreen: 128);
		at: 5
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 128;
					rgbGreen: 0);
		at: 6
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbBlue: 128;
					rgbGreen: 0);
		at: 7
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 128;
					rgbGreen: 128);
		at: 8
			put: ((RGBQUAD new)
					rgbRed: 192;
					rgbBlue: 192;
					rgbGreen: 192);
		at: 9
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbBlue: 128;
					rgbGreen: 128);
		at: 10
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbBlue: 0;
					rgbGreen: 0);
		at: 11
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 0;
					rgbGreen: 255);
		at: 12
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbBlue: 0;
					rgbGreen: 255);
		at: 13
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 255;
					rgbGreen: 0);
		at: 14
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbBlue: 255;
					rgbGreen: 0);
		at: 15
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbBlue: 255;
					rgbGreen: 255);
		at: 16
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbBlue: 255;
					rgbGreen: 255);
		yourself!

colorTableDepth8
	"Answer a default color table to be used for depth 8 (super VGA) bitmaps"

	| table index |
	table := StructureArray length: 256 elementClass: RGBQUAD.
	table
		at: 1
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 0;
					rgbBlue: 0);
		at: 2
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 0;
					rgbBlue: 128);
		at: 3
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 128;
					rgbBlue: 0);
		at: 4
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 128;
					rgbBlue: 128);
		at: 5
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbGreen: 0;
					rgbBlue: 0);
		at: 6
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbGreen: 0;
					rgbBlue: 128);
		at: 7
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbGreen: 128;
					rgbBlue: 0);
		at: 8
			put: ((RGBQUAD new)
					rgbRed: 192;
					rgbGreen: 192;
					rgbBlue: 192);
		at: 9
			put: ((RGBQUAD new)
					rgbRed: 128;
					rgbGreen: 128;
					rgbBlue: 128);
		at: 10
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 0;
					rgbBlue: 255);
		at: 11
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 255;
					rgbBlue: 0);
		at: 12
			put: ((RGBQUAD new)
					rgbRed: 0;
					rgbGreen: 255;
					rgbBlue: 255);
		at: 13
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbGreen: 0;
					rgbBlue: 0);
		at: 14
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbGreen: 0;
					rgbBlue: 255);
		at: 15
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbGreen: 255;
					rgbBlue: 0);
		at: 16
			put: ((RGBQUAD new)
					rgbRed: 255;
					rgbGreen: 255;
					rgbBlue: 255).
	index := 17.
	#(0 50 101 152 203 254) do: 
			[:red | 
			#(0 50 101 152 203 254) do: 
					[:green | 
					#(0 50 101 152 203 254) do: 
							[:blue | 
							table at: index
								put: ((RGBQUAD new)
										rgbRed: red;
										rgbGreen: green;
										rgbBlue: blue).
							index := index + 1]]].
	0 to: 242
		by: 11
		do: 
			[:all | 
			table at: index
				put: ((RGBQUAD new)
						rgbRed: all;
						rgbGreen: all;
						rgbBlue: all).
			index := index + 1].
	table at: index
		put: ((RGBQUAD new)
				rgbRed: 255;
				rgbGreen: 255;
				rgbBlue: 255).
	^table!

colorTableForDepth: anInteger
	"Answer an instance of the default color table to be used for 
	DeviceIndependentBitmaps with anInteger color depth"

	^self perform: ('colorTableDepth' , anInteger printString) asSymbol!

width: width height: height depth: depth
	"Answer a DeviceIndependentBitmap with the appropritae parameters
	depth = 1, 4, 8, 16, 24 or 32"

	^self new 
		width: width
		height: height
		depth: depth! !
!DeviceIndependentBitmap class categoriesForMethods!
colorTableDepth1!constants!public! !
colorTableDepth16!constants!public! !
colorTableDepth24!constants!public! !
colorTableDepth32!constants!public! !
colorTableDepth4!constants!public! !
colorTableDepth8!constants!public! !
colorTableForDepth:!accessing!public! !
width:height:depth:!instance creation!public! !
!

