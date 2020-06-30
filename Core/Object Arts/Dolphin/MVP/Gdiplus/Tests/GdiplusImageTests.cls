"Filed out from Dolphin Smalltalk 7"!

GdiplusTests subclass: #GdiplusImageTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
GdiplusImageTests guid: (GUID fromString: '{f51a7675-4fec-411d-a3a4-3a11dd7d104a}')!
GdiplusImageTests isAbstract: true!
GdiplusImageTests comment: ''!
!GdiplusImageTests categoriesForClass!Unclassified! !
!GdiplusImageTests methodsFor!

testAsByteArrayRoundTrip
	| bytes bitmap |
	bytes := model asByteArray: 'image/png'.
	bitmap := GdiplusBitmap fromByteArray: bytes.
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
	self assert: (GdiplusImage encoderClsid: 'image/jpeg')
		equals: (GdiplusImage encoderClsidForExtension: 'jpg')!

testSaveToFileJpeg
	"GdiplusImage>>#saveToFile: should be matching against GpImageCodecInfo's FilenameExtension ... not its MimeType"

	model saveToFile: (File temporaryFilenameWithPrefix: 'gdipTests') , '.jpg'! !
!GdiplusImageTests categoriesFor: #testAsByteArrayRoundTrip!public!unit tests! !
!GdiplusImageTests categoriesFor: #testClone!public!unit tests! !
!GdiplusImageTests categoriesFor: #testExtent!public!unit tests! !
!GdiplusImageTests categoriesFor: #testJpegContentType!public!unit tests! !
!GdiplusImageTests categoriesFor: #testSaveToFileJpeg!public!unit tests! !

