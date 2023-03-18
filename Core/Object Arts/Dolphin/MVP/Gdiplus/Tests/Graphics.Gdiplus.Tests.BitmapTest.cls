"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.ImageTests subclass: #'Graphics.Gdiplus.Tests.BitmapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapTest guid: (Core.GUID fromString: '{fa986dbc-acca-46d6-98c9-d51feb7d04d6}')!
Graphics.Gdiplus.Tests.BitmapTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapTest methodsFor!

gdiBitmapClass
	^Graphics.Bitmap!

subjectClass
	^Bitmap!

testAsByteArray
	| b1 b2 infoHeader fileHeader |
	model := self subjectClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	b1 := model asByteArray: 'image/bmp'.
	b2 := self fileResource rgb0000FF_100x100bmpBytes.
	self assert: b1 size equals: b2 size.
	"difference is in the first 100 bytes ... what is the problem?"
	"The problem is that the API doesn't store down the biSizeImage value into the BITMAPINFOHEADER - we patch it up here, but probably this should be done in #asByteArray:"
	fileHeader := BITMAPFILEHEADER fromBytes: b1.
	self assert: fileHeader bfSize equals: b1 size.
	self assert: (b1 uint32AtOffset: fileHeader byteSize) equals: BITMAPINFOHEADER._BITMAPINFOHEADER_Size.
	infoHeader := BITMAPINFOHEADER fromAddress: b1 yourAddress + fileHeader byteSize.
	infoHeader biSizeImage: b1 size - fileHeader byteSize - infoHeader size.
	self assert: b1 equals: b2!

testAsByteArrayRoundTripBmp
	| bytes bitmap |
	model := self subjectClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	bytes := model asByteArray: 'image/bmp'.
	bitmap := self subjectClass fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/bmp').
	bitmap free!

testCloneFormat
	| source recreated palette |
	source := self subjectClass fromFile: self fileResource pafFish32x32png.
	self assert: source pixelFormatName equals: 'PixelFormat32bppARGB'.
	model := source cloneRectangle: (1 @ 1 extent: 30 @ 30) format: Gdiplus.PixelFormat8bppIndexed.
	source free.
	self assert: model pixelFormatName equals: 'PixelFormat8bppIndexed'.
	palette := model palette.
	self assert: palette Count equals: 224.
	self assert: (palette Flags bitAnd: 16rF) equals: 0.
	self deny: model initializer identicalTo: source initializer.
	self assert: model extent equals: 30 @ 30.
	recreated := self assertPersistedValid.
	self assert: recreated pixelFormatName equals: 'PixelFormat8bppIndexed'.
	self assert: recreated extent equals: 30 @ 30.
	self assert: recreated palette equals: palette.
	recreated free.
	self assertClonedValid free!

testFromBitmap
	| bmp |
	bmp := self gdiBitmapClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := self subjectClass fromBitmap: bmp.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	self assert: (model pixelAt: 50 @ 50) equals: Color blue.
	self assertPersistedValid free.
	self assertClonedValid free.
	bmp free!

testFromFile
	model := self subjectClass fromFile: self fileResource pafFish32x32png.
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid.
	self assert: model hasAlpha.
	"This isn't correct - the PNG does have translucent pixels"
	self deny: model hasTranslucency.
	"Not sure what it takes to be partially scalable"
	self deny: model isPartiallyScalable.
	self deny: model hasDPI.
	self assert: model hasPixelSize.
	self assert: model isRGB.
	self assertClonedValid free!

testFromIcon
	model := self subjectClass fromIcon: self icon.
	self assert: model isPersistent.
	"mmm ... how does it choose the icon format to use?"
	self assert: model extent equals: 32 @ 32.
	self assert: model frameCount equals: 1.
	self deny: model hasAlpha.
	self deny: model isScalable.
	self deny: model hasTranslucency.
	self deny: model isPartiallyScalable.
	self assertPersistedValid free.
	self assertClonedValid free
	!

testFromIconXP
	model := self subjectClass fromIcon: (Icon fromFile: self fileResource pafWinXP32x32ico).
	model handle.
	"SW: Why did I have 48@48 ?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid free.
	self assertClonedValid free!

testFromWidthHeight
	model := self subjectClass width: 50 height: 100.
	self assert: model isPersistent.
	self assert: model extent equals: 50 @ 100.
	"assert what?"
	self assertPersistedValid free.
	self assertClonedValid free!

testGetPixel
	| bmp |
	bmp := self gdiBitmapClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := self subjectClass fromBitmap: bmp.
	self assert: (model pixelAt: 50 @ 50) equals: Color blue.
	bmp free!

testLockBits
	| bmp bitmapData rect expectedPels actualPels |
	bmp := Bitmap fromFile: self fileResource pafFish32x32png.
	rect := 25 @ 14 extent: 3 @ 3.
	expectedPels := OrderedCollection new.
	rect top to: rect bottom - 1
		do: [:y | rect left to: rect right - 1 do: [:x | expectedPels add: (bmp pixelAt: x @ y)]].
	expectedPels := expectedPels asArray.
	self assert: expectedPels size equals: 9.
	bitmapData := bmp lockBits: rect.
	
	[| scan0 stride |
	self assert: bitmapData Width equals: 3.
	self assert: bitmapData Height equals: 3.
	scan0 := bitmapData Scan0.
	stride := bitmapData Stride.
	actualPels := OrderedCollection new.
	0 to: 2
		do: 
			[:i |
			0 to: 2 do: [:j | actualPels add: (ARGB fromArgbCode: (scan0 uint32AtOffset: stride * i + (j * 4)))]]]
			ensure: [bmp unlockBits: bitmapData].
	actualPels := actualPels asArray.
	self assert: actualPels equals: expectedPels.
	bmp free!

testPixelAfterSave
	| bitmap baseFile extensions supportsAlpha toFile image transparentBlack |
	bitmap := self subjectClass extent: 100 @ 100.
	transparentBlack := Color black alpha: 0.
	self assert: (bitmap pixelAt: 1 @ 1) equals: transparentBlack.
	baseFile := self fileResource fileLocator localFileSpecFor: 'testPixelAfterSave'.
	extensions := #('bmp' 'jpeg' 'gif' 'tiff' 'png').
	supportsAlpha := #(false false false true true).
	extensions with: supportsAlpha
		do: 
			[:ext :supported |
			toFile := File path: baseFile extension: ext.
			bitmap saveToFile: toFile.
			image := self subjectClass fromFile: toFile.
			self assert: (image pixelAt: 1 @ 1) = transparentBlack equals: supported].
	bitmap free! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesForMethods!
gdiBitmapClass!constants!private! !
subjectClass!constants!private! !
testAsByteArray!public!unit tests! !
testAsByteArrayRoundTripBmp!public!unit tests! !
testCloneFormat!public!unit tests! !
testFromBitmap!public!unit tests! !
testFromFile!public!unit tests! !
testFromIcon!public!unit tests! !
testFromIconXP!public!unit tests! !
testFromWidthHeight!public!unit tests! !
testGetPixel!public!unit tests! !
testLockBits!public!unit tests! !
testPixelAfterSave!public!unit tests! !
!

