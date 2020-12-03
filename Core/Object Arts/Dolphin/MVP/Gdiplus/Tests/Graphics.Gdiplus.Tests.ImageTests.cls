"Filed out from Dolphin Smalltalk 7"!

Graphics.Gdiplus.Tests.GdiplusTest subclass: #'Graphics.Gdiplus.Tests.ImageTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageTests guid: (Core.GUID fromString: '{f51a7675-4fec-411d-a3a4-3a11dd7d104a}')!
Graphics.Gdiplus.Tests.ImageTests isNonInstantiable: true!
Graphics.Gdiplus.Tests.ImageTests comment: ''!
!Graphics.Gdiplus.Tests.ImageTests categoriesForClass!Unclassified! !
!Graphics.Gdiplus.Tests.ImageTests methodsFor!

testAsByteArrayRoundTrip
	| bytes bitmap |
	bytes := model asByteArray: 'image/png'.
	bitmap := Bitmap fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/png')!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer identicalTo: clone initializer.
	self denyIsNil: clone basicHandle.
	self assert: (clone asByteArray: 'image/bmp') equals: (model asByteArray: 'image/bmp')!

testExtent
	self assert: model extent equals: 32 @ 32!

testJpegContentType
	self assert: (Image encoderClsid: 'image/jpeg') equals: (Image encoderClsidForExtension: 'jpg')!

testSaveToFileJpeg
	"GdiplusImage>>#saveToFile: should be matching against GpImageCodecInfo's FilenameExtension ... not its MimeType"

	model saveToFile: (File temporaryFilenameWithPrefix: 'gdipTests') , '.jpg'! !
!Graphics.Gdiplus.Tests.ImageTests categoriesFor: #testAsByteArrayRoundTrip!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageTests categoriesFor: #testClone!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageTests categoriesFor: #testExtent!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageTests categoriesFor: #testJpegContentType!public!unit tests! !
!Graphics.Gdiplus.Tests.ImageTests categoriesFor: #testSaveToFileJpeg!public!unit tests! !

