"Filed out from Dolphin Smalltalk 7"!

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

setUp
	super setUp.
	model := Bitmap fromFile: self fileResource pafFish32x32png!

testAsByteArrayRoundTripBmp
	| bytes bitmap |
	model := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	bytes := model asByteArray: 'image/bmp'.
	bitmap := Bitmap fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/bmp')!

testFromBitmap
	| bmp |
	bmp := Graphics.Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := Bitmap fromBitmap: bmp.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testFromFile
	model := Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	self assert: model extent equals: 100 @ 100.
	self assertPersistedValid!

testFromIcon
	model := Bitmap fromIcon: self icon.
	self assert: model isPersistent.
	"mmm ... how does it choose the icon format to use?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromIconXP
	model := Bitmap fromIcon: (Icon fromFile: self fileResource pafWinXP32x32ico).
	model handle.
	"SW: Why did I have 48@48 ?"
	self assert: model extent equals: 32 @ 32.
	self assertPersistedValid!

testFromWidthHeight
	model := Bitmap width: 100 height: 100.
	self assert: model isPersistent.
	self assert: model extent equals: 100 @ 100.
	"assert what?"
	self assertPersistedValid!

testGetPixel
	| bmp |
	bmp := Graphics.Bitmap fromFile: self fileResource pafRgb0000FF_100x100bmp.
	model := Gdiplus.Bitmap fromBitmap: bmp.
	self assert: (model pixelAt: 50 @ 50) equals: Color blue!

testPixelAfterSave
	| bitmap baseFile extensions supportsAlpha toFile image transparentBlack |
	bitmap := Bitmap extent: 100 @ 100.
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
			image := Bitmap fromFile: toFile.
			self assert: (image pixelAt: 1 @ 1) = transparentBlack equals: supported]! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #setUp!public!setup! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testAsByteArrayRoundTripBmp!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testFromBitmap!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testFromFile!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testFromIcon!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testFromIconXP!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testFromWidthHeight!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testGetPixel!public!unit tests! !
!Graphics.Gdiplus.Tests.BitmapTest categoriesFor: #testPixelAfterSave!public!unit tests! !

