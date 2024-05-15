"Filed out from Dolphin Smalltalk"!

ImageTest subclass: #AbstractBitmapTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

AbstractBitmapTest guid: (GUID fromString: '{4f99494c-fb6f-4960-aa99-454d2256ab25}')!

AbstractBitmapTest isAbstract: true!

AbstractBitmapTest comment: ''!

!AbstractBitmapTest categoriesForClass!Unclassified! !

!AbstractBitmapTest methodsFor!

beachBallColorDepth
	^24!

canonicalInstance
	^self subjectClass fromId: 'Tools.bmp'.!

expectedImageExtent
	^928 @ 16!

imageFile
	^'Core\DolphinVM\res\Tools.bmp'!

testDisplayCompatible
	| bitmap1 |
	bitmap1 := self subjectClass displayCompatibleWithExtent: 123 @ 456.
	self assert: bitmap1 depth equals: SystemMetrics current defaultColorDepth.
	self assert: bitmap1 extent equals: 123 @ 456.
	self deny: bitmap1 isPersistent!

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
	bitmap2 := self subjectClass fromId: 'Tools.bmp'.
	self assert: bitmap1 equals: bitmap2.
	self assert: bitmap2 equals: bitmap1.
	self assert: bitmap1 hash equals: bitmap2 hash.
	self assert: bitmap1 extent y equals: 16!

verifyImage: bitmap1 sameAs: bitmap2
	self assert: bitmap1 asByteArray equals: bitmap2 asByteArray! !

!AbstractBitmapTest categoriesForMethods!
beachBallColorDepth!public! !
canonicalInstance!public! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
testDisplayCompatible!public! !
testFromFileFallback!public! !
testFromResource!public! !
verifyImage:sameAs:!helpers!private! !
!

