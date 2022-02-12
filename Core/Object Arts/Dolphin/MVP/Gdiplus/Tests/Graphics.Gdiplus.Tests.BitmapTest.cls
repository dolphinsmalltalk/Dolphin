"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.ImageTests subclass: #'Graphics.Gdiplus.Tests.BitmapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.BitmapTest guid: (Core.GUID fromString: '{fa986dbc-acca-46d6-98c9-d51feb7d04d6}')!
Graphics.Gdiplus.Tests.BitmapTest comment: ''!
!Graphics.Gdiplus.Tests.BitmapTest categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.BitmapTest methodsFor!

gdiBitmapClass
	^Graphics.Bitmap!

setUp
	super setUp.
	model := self subjectClass fromFile: self fileResource pafFish32x32png!

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
	self assert: (b1 dwordAtOffset: fileHeader byteSize) equals: BITMAPINFOHEADER._BITMAPINFOHEADER_Size.
	infoHeader := BITMAPINFOHEADER fromAddress: b1 yourAddress + fileHeader byteSize.
	infoHeader biSizeImage: b1 size - fileHeader byteSize - infoHeader size.
	self assert: b1 equals: b2!

testAsByteArrayRoundTripBmp
	| bytes bitmap |
	model := self subjectClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	bytes := model asByteArray: 'image/bmp'.
	bitmap := self subjectClass fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/bmp')!

testFromBitmap
	| bmp |
	bmp := self gdiBitmapClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := self subjectClass fromBitmap: bmp.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testFromFile
	model := self subjectClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	self assert: model extent equals: 100 @ 100.
	self assertPersistedValid!

testFromIcon
	model := self subjectClass fromIcon: self icon.
	self assert: model isPersistent.
	"mmm ... how does it choose the icon format to use?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromIconXP
	model := self subjectClass fromIcon: (Icon fromFile: self fileResource pafWinXP32x32ico).
	model handle.
	"SW: Why did I have 48@48 ?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromWidthHeight
	model := self subjectClass width: 100 height: 100.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testGetPixel
	| bmp |
	bmp := self gdiBitmapClass fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := self subjectClass fromBitmap: bmp.
	self assert: (model pixelAt: 50 @ 50) equals: Color blue!

testPixelAfterSave
	| bitmap baseFile extensions supportsAlpha toFile image transparentBlack |
	bitmap := self subjectClass extent: 100 @ 100.
	transparentBlack := Color black alpha: 0.
	self assert: (bitmap pixelAt: 1 @ 1) equals: transparentBlack.
	baseFile := bitmap class fileResource fileLocator localFileSpecFor: 'testPixelAfterSave'.
	extensions := #('bmp' 'jpeg' 'gif' 'tiff' 'png').
	supportsAlpha := #(false false false true true).
	extensions with: supportsAlpha
		do: 
			[:ext :supported |
			toFile := File path: baseFile extension: ext.
			bitmap saveToFile: toFile.
			image := self subjectClass fromFile: toFile.
			self assert: (image pixelAt: 1 @ 1) = transparentBlack equals: supported]! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesForMethods!
gdiBitmapClass!constants!private! !
setUp!public!setup! !
subjectClass!constants!private! !
testAsByteArray!public!unit tests! !
testAsByteArrayRoundTripBmp!public!unit tests! !
testFromBitmap!public!unit tests! !
testFromFile!public!unit tests! !
testFromIcon!public!unit tests! !
testFromIconXP!public!unit tests! !
testFromWidthHeight!public!unit tests! !
testGetPixel!public!unit tests! !
testPixelAfterSave!public!unit tests! !
!

