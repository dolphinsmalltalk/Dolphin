"Filed out from Dolphin Smalltalk"!

Graphics.Gdiplus.Tests.GdiplusObjectTest
	subclass: #'Graphics.Gdiplus.Tests.ImageTests'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Gdiplus.Tests.ImageTests guid: (Core.GUID fromString: '{f51a7675-4fec-411d-a3a4-3a11dd7d104a}')!
Graphics.Gdiplus.Tests.ImageTests isNonInstantiable: true!
Graphics.Gdiplus.Tests.ImageTests comment: ''!
!Graphics.Gdiplus.Tests.ImageTests methodsFor!

assertClonedValid
	| clone |
	clone := super assertClonedValid.
	self assert: (clone asByteArray: 'image/bmp') equals: (model asByteArray: 'image/bmp')!

createCanonicalSubject
	^self subjectClass fromFile: self fileResource pafFish32x32png!

setUp
	super setUp.
	self newCanonicalModel!

testAsByteArrayRoundTrip
	| bytes bitmap |
	bytes := model asByteArray: 'image/png'.
	bitmap := Bitmap fromByteArray: bytes.
	self assert: bytes equals: (bitmap asByteArray: 'image/png')!

testBounds
	self assert: model bounds equals: (0 @ 0 extent: 32 @ 32)!

testExtent
	self assert: model extent equals: 32 @ 32!

testJpegContentType
	self assert: (Image encoderClsid: 'image/jpeg') equals: (Image encoderClsidForExtension: 'jpg')!

testResolution
	self deny: model hasDPI.
	self assert: model resolution equals: 96@96.
	self freeModel.
	model := self subjectClass fromFile: self fileResource pafSeattleNightJpg.
	self assert: model hasDPI.
	self assert: model resolution equals: 72@72.



	
!

testSaveToFileJpeg
	"GdiplusImage>>#saveToFile: should be matching against GpImageCodecInfo's FilenameExtension ... not its MimeType"

	model saveToFile: (self fileResource fileLocator localFileSpecFor: 'gdipTests.jpg')! !
!Graphics.Gdiplus.Tests.ImageTests categoriesForMethods!
assertClonedValid!asserting!private! !
createCanonicalSubject!private!running! !
setUp!public!running! !
testAsByteArrayRoundTrip!public!unit tests! !
testBounds!public!unit tests! !
testExtent!public!unit tests! !
testJpegContentType!public!unit tests! !
testResolution!public!unit tests! !
testSaveToFileJpeg!public!unit tests! !
!

