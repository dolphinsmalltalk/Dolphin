﻿"Filed out from Dolphin Smalltalk"!

ImageTest subclass: #IconTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IconTest guid: (GUID fromString: '{96d9e7d9-8086-4706-b958-791a85a4e86c}')!

IconTest comment: ''!

!IconTest categoriesForClass!Unclassified! !

!IconTest methodsFor!

canonicalInstance
	^self subjectClass question!

defaultHandle
	^Icon question handle!

expectedImageExtent
	^Icon largeExtent!

imageFile
	^'Core\DolphinVM\res\Collection.ico'!

subjectClass
	^Icon!

testFromFileFallback
	| image1 image2 filename |
	filename := File splitFilenameFrom: self imageFile.
	image1 := self subjectClass fromFile: filename.
	image2 := self subjectClass fromId: filename.
	self deny: image1 equals: image2.
	self assert: image1 hash equals: image2 hash.
	self deny: image1 imageIndex equals: image2 imageIndex.
	self assert: image1 extent equals: self expectedImageExtent.
	SessionManager current productVersion >= 8 ifTrue: [self verifyImage: image1 sameAs: image2].
	image1 free.
	image2 free!

testFromResource
	| icon1 icon2 |
	icon1 := Icon fromId: 'Collection.ico'.
	icon2 := Collection icon.
	self assert: icon1 equals: icon2.
	self assert: icon2 equals: icon1.
	self assert: icon1 hash equals: icon2 hash.
	SessionManager current productVersion >= 8 ifTrue: [self assert: icon1 handle equals: icon2 handle].
	self assert: icon1 imageIndex equals: icon2 imageIndex.
	self assert: icon1 extent equals: Icon defaultExtent.
	icon1 free.
	icon2 free!

testFromSystemId
	| icon1 icon2 |
	icon1 := Icon fromSystemId: Win32Constants.IDI_APPLICATION.
	icon2 := Icon defaultApplication.
	self assert: icon1 equals: icon2.
	self assert: icon2 equals: icon1.
	self assert: icon1 hash equals: icon2 hash.
	self assert: icon1 imageIndex equals: icon2 imageIndex.
	self assert: icon1 extent equals: Icon largeExtent.
	self deny: icon1 equals: Icon question.
	self deny: icon1 handle equals: self defaultHandle.
	SessionManager current productVersion >= 8 ifTrue: [self assert: icon1 handle equals: icon2 handle].
	icon1 free.
	icon2 free!

testImageIndexDoesntRealize
	"A test for #2270. Ensure that #imageIndex won't realize an icon that has previously been added to an ImageManager"

	| icon |
	Object icon imageIndex.
	icon := Object icon.
	self assertIsNil: icon basicHandle.
	icon imageIndex.
	self assertIsNil: icon basicHandle!

testStandardSizeFor
	-2 to: 0 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 0 @ 0].
	1 to: 19 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 16 @ 16].
	20 to: 23 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 20 @ 20].
	24 to: 31 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 24 @ 24].
	32 to: 39 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 32 @ 32].
	40 to: 47 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 40 @ 40].
	48 to: 63 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 48 @ 48].
	64 to: 95 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 64 @ 64].
	96 to: 127 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 96 @ 96].
	128 to: 255 do: [:i | self assert: (Icon standardSizeFor: i @ i) equals: 128 @ 128].
	self assert: (Icon standardSizeFor: Icon.LargestStandardSize) equals: Icon.LargestStandardSize.
	self assert: (Icon standardSizeFor: Icon.LargestStandardSize * 2) equals: Icon.LargestStandardSize.
	self assert: (Icon standardSizeFor: Icon.LargestStandardSize * 2.25)
		equals: Icon.LargestStandardSize!

testStbConvertFromVersion1_resource
	| bytes icon |
	bytes := #[33 83 84 66 32 48 32 6 4 4 0 73 99 111 110 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 10 0 0 0 79 98 106 101 99 116 46 105 99 111 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 114 0 0 0 13 0 0 0 68 111 108 112 104 105 110 68 101 118 82 101 115 0 0 0 0].
	icon := Object fromBinaryStoreBytes: bytes.
	self assert: icon isKindOf: Icon.
	self assert: icon ownsHandle.
	self assert: icon identifier equals: 'object.ico'.
	self assert: icon instanceHandle equals: SessionManager current defaultResourceLibrary.
	self assert: icon equals: Object icon.
	self assert: icon extent equals: Icon largeExtent.
	icon free!

testStbConvertFromVersion1_system
	| bytes icon |
	bytes := #[33 83 84 66 32 48 32 6 4 4 0 73 99 111 110 0 0 0 0 0 0 0 0 16 0 0 0 3 254 0 0 1 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	icon := Object fromBinaryStoreBytes: bytes.
	self assert: icon isKindOf: Icon.
	self assert: icon ownsHandle.
	self assert: icon identifier equals: Win32Constants.IDI_ERROR.
	self assert: icon instanceHandle equals: 0.
	self assert: icon equals: Error icon.
	SessionManager current productVersion >= 8
		ifTrue: [self assert: icon handle equals: Error icon handle].
	icon free!

verifyImage: anIcon1 sameAs: anIcon2
	"Private - Assumes icons were loaded with LR_SHARED."

	self assert: anIcon1 handle equals: anIcon2 handle! !

!IconTest categoriesForMethods!
canonicalInstance!helpers!private! !
defaultHandle!constants!private! !
expectedImageExtent!constants!private! !
imageFile!constants!private! !
subjectClass!constants!private! !
testFromFileFallback!public!unit tests! !
testFromResource!public!unit tests! !
testFromSystemId!public!unit tests! !
testImageIndexDoesntRealize!public!unit tests! !
testStandardSizeFor!public!unit tests! !
testStbConvertFromVersion1_resource!public!unit tests! !
testStbConvertFromVersion1_system!public!unit tests! !
verifyImage:sameAs:!private! !
!
