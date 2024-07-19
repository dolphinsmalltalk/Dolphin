"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest
	subclass: #'Graphics.Tests.AbstractBitmapTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Graphics.Tests.AbstractBitmapTest guid: (Core.GUID fromString: '{298209a8-ba31-4a36-8c59-550f0222918b}')!

Graphics.Tests.AbstractBitmapTest isNonInstantiable: true!

Graphics.Tests.AbstractBitmapTest comment: ''!

!Graphics.Tests.AbstractBitmapTest methodsFor!

canonicalInstance
	^self subjectClass fromId: 'Tools.bmp'.!

expectedImageExtent
	^928 @ 16!

imageFile
	^'Core\DolphinVM\res\Tools.bmp'!

stlVersion3_file
	^self subclassResponsibility!

stlVersion3_resource
	^self subclassResponsibility!

testDisplayCompatible
	| bitmap1 |
	bitmap1 := self subjectClass displayCompatibleWithExtent: 123 @ 456.
	self assert: bitmap1 depth equals: SystemMetrics current defaultColorDepth.
	self assert: bitmap1 extent equals: 123 @ 456.
	self deny: bitmap1 isPersistent!

testDrawWithNegativeExtent
	| subject bitmap canvas actualEndColor startColor extent |
	"Create a colour gradient as the source to draw from"
	extent := 48 @ 48.
	subject := self subjectClass displayCompatibleWithExtent: extent.
	canvas := subject canvas.
	startColor := Color red.
	canvas
		fillRectangle: (0 @ 0 extent: subject extent)
		startColor: startColor
		endColor: Color blue
		verticalGradient: true.
	actualEndColor := canvas pixelAt: extent - 1.
	bitmap := DIBSection compatible: subject canvas extent: extent.
	canvas := bitmap canvas.
	"Should draw inverted onto the target if we specify negative extent"
	subject
		drawOn: canvas
		at: extent - 1
		extent: extent negated
		from: 0 @ 0
		extent: extent.
	self assert: (canvas pixelAt: 0 @ 0) equals: actualEndColor.
	self assert: (canvas pixelAt: extent - 1) equals: startColor.
	bitmap free!

testFromFileFallback
	| bitmap1 bitmap2 |
	bitmap1 := self subjectClass fromFile: 'HeaderPin.bmp'.
	self assert: bitmap1 isPersistent.
	bitmap2 := self subjectClass fromId: 'HeaderPin.bmp'.
	self deny: bitmap1 equals: bitmap2.
	self assert: bitmap1 hash equals: bitmap2 hash.
	self verifyImage: bitmap1 sameAs: bitmap2!

testFromResource
	| bitmap1 bitmap2 |
	bitmap1 := self canonicalInstance.
	self assert: bitmap1 isPersistent.
	self assert: bitmap1 initializer isLoadShared.
	bitmap2 := self subjectClass fromId: 'Tools.bmp'.
	self assert: bitmap1 equals: bitmap2.
	self assert: bitmap2 equals: bitmap1.
	self assert: bitmap1 hash equals: bitmap2 hash.
	self assert: bitmap1 extent y equals: 16!

testStlConvertFromVersion3_file
	| rehydrated comparand |
	rehydrated := Object fromLiteralStoreArray: self stlVersion3_file.
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString
		equals: '<1p> fromFile: ''resources\Beach Ball.bmp''' << self subjectClass.
	comparand := self subjectClass fromFile: 'Resources\beach ball.bmp'.
	self assert: rehydrated equals: comparand.
	"Icon's loaded from files are not shared, so the handles will be different"
	self deny: rehydrated initializer isLoadShared.
	self deny: rehydrated handle equals: comparand handle.
	self assert: rehydrated extent equals: comparand extent!

testStlConvertFromVersion3_resource
	| rehydrated comparand |
	rehydrated := Object fromLiteralStoreArray: self stlVersion3_resource.
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: '<1p> fromId: ''tools.bmp''' << self subjectClass.
	self assert: rehydrated initializer isLoadShared.
	comparand := self canonicalInstance.
	self assert: rehydrated equals: comparand!

verifyImage: bitmap1 sameAs: bitmap2
	self assert: bitmap1 asByteArray equals: bitmap2 asByteArray! !

!Graphics.Tests.AbstractBitmapTest categoriesForMethods!
canonicalInstance!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
stlVersion3_file!constants!private! !
stlVersion3_resource!constants!private! !
testDisplayCompatible!public!unit tests! !
testDrawWithNegativeExtent!public! !
testFromFileFallback!public!unit tests! !
testFromResource!public! !
testStlConvertFromVersion3_file!public! !
testStlConvertFromVersion3_resource!public! !
verifyImage:sameAs:!public!unit tests! !
!

