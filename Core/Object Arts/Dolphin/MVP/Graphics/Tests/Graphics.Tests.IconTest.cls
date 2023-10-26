"Filed out from Dolphin Smalltalk"!

Graphics.Tests.ImageTest
	subclass: #'Graphics.Tests.IconTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Graphics.Tests.IconTest guid: (Core.GUID fromString: '{96d9e7d9-8086-4706-b958-791a85a4e86c}')!
Graphics.Tests.IconTest comment: ''!
!Graphics.Tests.IconTest methodsFor!

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
	self verifyImage: image1 sameAs: image2!

testFromResource
	| icon1 icon2 |
	icon1 := Icon fromId: 'collection.ico'.
	icon2 := Collection icon.
	self assert: icon1 equals: icon2.
	self assert: icon2 equals: icon1.
	self assert: icon1 hash equals: icon2 hash.
	self assert: icon1 handle equals: icon2 handle.
	self assert: icon1 imageIndex equals: icon2 imageIndex.
	self assert: icon1 extent equals: Icon defaultExtent!

testFromShellStock
	| icon1 icon2 stockInfo icon3 |
	icon1 := Icon shellStock: SHSTOCKICONID.SIID_DOCASSOC.
	icon2 := Icon shellStock: SHSTOCKICONID.SIID_DOCASSOC.
	stockInfo := icon1 initializer getStockIconInfo: 0.
	icon3 := Icon fromId: stockInfo iIcon abs in: (ResourceLibrary open: stockInfo szPath).
	self assert: icon1 equals: icon2.
	self assert: icon2 equals: icon1.
	self assert: icon1 imageIndex equals: icon2 imageIndex.
	self assert: icon1 extent equals: Icon largeExtent.
	"Icon3 is the same actual icon, but we don't consider it equal because the initializer is different, and when moved to a different machine with a different OS version they may not be the same"
	self deny: icon1 equals: icon3.
	self assert: icon1 hash equals: icon2 hash.
	"Note that the GetStockIconInfo API does not appear to create the icons as shared, so each time the handle will be different"
	self deny: icon1 handle equals: icon2 handle.
	self deny: icon1 handle equals: icon3 handle!

testFromSystemId
	| icon1 icon2 |
	icon1 := Icon fromSystemId: OS.Win32Constants.IDI_SHIELD.
	icon2 := Icon shield.
	self assert: icon1 equals: icon2.
	self assert: icon2 equals: icon1.
	self assert: icon1 hash equals: icon2 hash.
	self assert: icon1 imageIndex equals: icon2 imageIndex.
	self assert: icon1 extent equals: Icon largeExtent.
	self deny: icon1 equals: Icon question.
	self deny: icon1 handle equals: Icon defaultHandle.
	self assert: icon1 handle equals: icon2 handle!

testImageIndexDoesntRealize
	"A test for #2270. Ensure that #imageIndex won't realize an icon that has previously been added to an ImageManager"

	| icon |
	Object defaultIcon imageIndex.
	icon := Object defaultIcon.
	self assertIsNil: icon basicHandle.
	icon imageIndex.
	self assertIsNil: icon basicHandle!

testNullIcon
	| null |
	null := Icon null.
	self assert: Icon null identicalTo: null.
	self assert: null handle equals: 0!

testStbConvertFromVersion1_resource
	| bytes icon |
	bytes := #[33 83 84 66 32 48 32 6 4 4 0 73 99 111 110 0 0 0 0 0 0 0 0 16 0 0 0 54 0 6 0 83 116 114 105 110 103 10 0 0 0 79 98 106 101 99 116 46 105 99 111 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 114 0 0 0 13 0 0 0 68 111 108 112 104 105 110 68 101 118 82 101 115 0 0 0 0].
	icon := Object fromBinaryStoreBytes: bytes.
	self assert: icon isKindOf: Icon.
	self assert: icon ownsHandle.
	self assert: icon initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: icon initializer identifier equals: 'Object.ico'.
	self assert: icon initializer module equals: SessionManager current defaultResourceLibrary.
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
	self assert: icon initializer isKindOf: IconFromSystemInitializer.
	self assert: icon initializer identifier equals: Win32Constants.IDI_ERROR.
	self assert: icon initializer isLoadShared.
	self assert: icon equals: Error icon.
	self assert: icon handle equals: Error icon handle!

testStbConvertFromVersion3_resource
	| bytes icon |
	bytes := #[33 83 84 66 32 49 32 70 5 4 0 3 0 0 0 73 99 111 110 0 0 0 0 0 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 82 0 0 0 10 0 0 0 79 98 106 101 99 116 46 105 99 111 14 2 31 0 83 84 66 69 120 116 101 114 110 97 108 82 101 115 111 117 114 99 101 76 105 98 114 97 114 121 80 114 111 120 121 0 0 0 0 82 0 0 0 16 0 0 0 100 111 108 112 104 105 110 100 114 48 48 53 46 100 108 108 0 0 0 0].
	icon := Object fromBinaryStoreBytes: bytes.
	self assert: icon isKindOf: Icon.
	self assert: icon ownsHandle.
	self assert: icon initializer isKindOf: ImageFromStringResourceInitializer.
	self assert: icon initializer identifier equals: 'Object.ico'.
	self assert: icon initializer module equals: SessionManager current defaultResourceLibrary.
	self assert: icon equals: Object icon.
	self assert: icon extent equals: Icon largeExtent.
	icon free!

testStbConvertFromVersion3_system
	| bytes icon |
	bytes := #[33 83 84 66 32 49 32 70 5 4 0 3 0 0 0 73 99 111 110 0 0 0 0 0 0 0 0 16 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 0 0 0 0 154 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 186 0 0 0 0 0 0 0 82 0 0 0 7 0 0 0 99 117 114 114 101 110 116 3 254 0 0 1 0 0 0].
	"Tools.STBDebugger dumpToTranscript: bytes readStream"
	icon := Object fromBinaryStoreBytes: bytes.
	self assert: icon isKindOf: Icon.
	self assert: icon ownsHandle.
	self assert: icon initializer isKindOf: IconFromSystemInitializer.
	self assert: icon initializer identifier equals: Win32Constants.IDI_ERROR.
	self assert: icon initializer isLoadShared.
	self assert: icon equals: Error icon.
	self assert: icon handle equals: Error icon handle!

testStlConvertFromVersion3_file
	| rehydrated comparand |
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Core\DolphinVM\res\collection.ico' nil).
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: 'Icon fromFile: ''Core\DolphinVM\res\collection.ico'''.
	comparand := Icon fromFile: 'Core\DolphinVM\res\Collection.ico'.
	self assert: rehydrated equals: comparand.
	"Icon's loaded from files are not shared, so the handles will be different"
	self deny: rehydrated initializer isLoadShared.
	self deny: rehydrated handle equals: comparand handle.
	self assert: rehydrated extent equals: Icon largeExtent!

testStlConvertFromVersion3_resource
	| rehydrated comparand |
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 8 'Collection.ico' 2032142 ##(Smalltalk.STBExternalResourceLibraryProxy) 8 'dolphindr7.dll' nil).
	self assert: rehydrated isPersistent.
	self assert: rehydrated printString equals: 'Icon fromId: ''Collection.ico'''.
	self assert: rehydrated initializer isLoadShared.
	comparand := Collection icon.
	self assert: rehydrated equals: comparand!

testStlConvertFromVersion3_system
	| rehydrated comparand |
	comparand := Icon warning.
	rehydrated := Object
				fromLiteralStoreArray: #(#'!!STL' 4 263494 3 ##(Smalltalk.Icon) nil true 1572870 ##(Smalltalk.ImageRelativeFileLocator) 65031 1).
	self deny: rehydrated identicalTo: comparand.
	self assert: rehydrated equals: comparand.
	self assert: rehydrated initializer isLoadShared.
	self assert: rehydrated handle equals: comparand handle.
	self assert: rehydrated extent equals: Icon warning extent!

testWithExtent
	| subject source |
	source := Collection icon.
	subject := source withExtent: 24 @ 24.
	self assert: subject equals: source.
	self assert: subject hash equals: source hash.
	self deny: subject handle equals: source handle.
	self assert: subject imageIndex equals: source imageIndex.
	self assert: source extent equals: Icon largeExtent.
	self assert: subject extent equals: 24 @ 24!

verifyImage: anIcon1 sameAs: anIcon2
	"Private - Assumes icons were loaded with LR_SHARED."

	self assert: anIcon1 handle equals: anIcon2 handle! !
!Graphics.Tests.IconTest categoriesForMethods!
imageFile!public! !
subjectClass!constants!private! !
testFromFileFallback!public! !
testFromResource!public! !
testFromShellStock!public! !
testFromSystemId!public! !
testImageIndexDoesntRealize!public! !
testNullIcon!public! !
testStbConvertFromVersion1_resource!public!unit tests! !
testStbConvertFromVersion1_system!public!unit tests! !
testStbConvertFromVersion3_resource!public!unit tests! !
testStbConvertFromVersion3_system!public!unit tests! !
testStlConvertFromVersion3_file!public! !
testStlConvertFromVersion3_resource!public! !
testStlConvertFromVersion3_system!public! !
testWithExtent!public! !
verifyImage:sameAs:!helpers!private! !
!

