"Filed out from Dolphin Smalltalk X6"!

GdiplusTests subclass: #GdiplusImageTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
GdiplusImageTests guid: (GUID fromString: '{F51A7675-4FEC-411D-A3A4-3A11DD7D104A}')!
GdiplusImageTests comment: ''!
!GdiplusImageTests categoriesForClass!Unclassified! !
!GdiplusImageTests methodsFor!

testAsByteArrayRoundTrip
	| bytes bitmap |
	bytes := model asByteArray: 'image/png'.
	bitmap := GdiplusBitmap fromByteArray: bytes.
	self assert: bytes = (bitmap asByteArray: 'image/png')!

testClone
	"force realize"

	| clone |
	model handle.
	clone := model clone.
	self assert: model initializer == clone initializer.
	self assert: clone basicHandle notNil.
	self assert: (clone asByteArray: 'image/bmp') = (model asByteArray: 'image/bmp')!

testExtent
	self assert: model extent = (32 @ 32)!

testJpegContentType
	self assert: (GdiplusImage encoderClsid: 'image/jpeg') 
				= (GdiplusImage encoderClsidForExtension: 'jpg')!

testSaveToFileJpeg
	"GdiplusImage>>#saveToFile: should be matching against GpImageCodecInfo's FilenameExtension ... not its MimeType"

	model saveToFile: (File temporaryFilenameWithPrefix: 'gdipTests') , '.jpg'! !
!GdiplusImageTests categoriesFor: #testAsByteArrayRoundTrip!public!unit tests! !
!GdiplusImageTests categoriesFor: #testClone!public!unit tests! !
!GdiplusImageTests categoriesFor: #testExtent!public!unit tests! !
!GdiplusImageTests categoriesFor: #testJpegContentType!public!unit tests! !
!GdiplusImageTests categoriesFor: #testSaveToFileJpeg!public!unit tests! !

