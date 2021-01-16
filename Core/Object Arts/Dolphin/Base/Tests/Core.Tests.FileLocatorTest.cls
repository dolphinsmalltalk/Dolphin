"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.FileLocatorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.FileLocatorTest guid: (Core.GUID fromString: '{635f7234-ba5a-4a72-97b1-40d81990cad7}')!
Core.Tests.FileLocatorTest comment: ''!
!Core.Tests.FileLocatorTest categoriesForClass!Unclassified! !
!Core.Tests.FileLocatorTest methodsFor!

testImageRelativeFileLocator
	| locator relative fullpath |
	locator := FileLocator imageRelative.

	"File in base directory."
	fullpath := File composePath: SessionManager current imageBase subPath: 'dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'dolphin.img'.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sub-directory"
	fullpath := File composePath: SessionManager current imageBase subPath: 'backup\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in parent directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin4\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath!

testInstallRelativeFileLocator
	| locator relative fullpath base |
	locator := FileLocator installRelative.

	"File in base directory."
	base := SessionManager current installationDirectory.
	fullpath := File composePath: base subPath: 'dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'dolphin.img'.
	self assert: ((locator localFileSpecFor: relative) sameAs: fullpath).

	"File in sub-directory"
	fullpath := File composePath: base subPath: 'backup\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: 'backup\dolphin.img'.
	self assert: ((locator localFileSpecFor: relative) sameAs: fullpath).

	"File in parent directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in sibling directory"
	fullpath := File composePath: SessionManager current imageBase subPath: '..\dolphin4\dolphin.img'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different hierarchy - should use absolute path"
	fullpath := 'd:\blah\blah.txt'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath.

	"File in different drive - should use absolute path"
	fullpath := 'c:\winnt\system32\user32.dll'.
	relative := locator relativePathTo: fullpath.
	self assert: relative equals: fullpath.
	self assert: (locator localFileSpecFor: relative) equals: fullpath!

testSingletonSerialisation
	"
literalStoreArray
"

	| singletons array bytes |
	singletons := {FileLocator absolute. FileLocator imageRelative. FileLocator installRelative}.
	array := #(#'!!STL' 3 98 3 1114638 ##(Smalltalk.STBSingletonProxy) 8 ##(Kernel.AbsoluteFileLocator) 8 #current 426 8 ##(Kernel.ImageRelativeFileLocator) 464 426 8 ##(Kernel.InstallRelativeFileLocator) 464).
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.
	array := singletons literalStoreArray.
	self assert: ((Object fromLiteralStoreArray: array) asIdentitySet - singletons) isEmpty.
	bytes := #[33 83 84 66 32 51 32 98 0 0 0 3 0 0 0 14 2 17 0 83 84 66 83 105 110 103 108 101 116 111 110 80 114 111 120 121 154 0 0 0 82 0 0 0 7 0 0 0 68 111 108 112 104 105 110 82 0 0 0 19 0 0 0 65 98 115 111 108 117 116 101 70 105 108 101 76 111 99 97 116 111 114 178 0 0 0 7 0 0 0 99 117 114 114 101 110 116 170 1 0 0 154 0 0 0 208 1 0 0 82 0 0 0 24 0 0 0 73 109 97 103 101 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 240 1 0 0 170 1 0 0 154 0 0 0 208 1 0 0 82 0 0 0 26 0 0 0 73 110 115 116 97 108 108 82 101 108 97 116 105 118 101 70 105 108 101 76 111 99 97 116 111 114 240 1 0 0].
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty.
	bytes := singletons binaryStoreBytes.
	self assert: ((Object fromBinaryStoreBytes: bytes) asIdentitySet - singletons) isEmpty! !
!Core.Tests.FileLocatorTest categoriesFor: #testImageRelativeFileLocator!public!unit tests! !
!Core.Tests.FileLocatorTest categoriesFor: #testInstallRelativeFileLocator!public!unit tests! !
!Core.Tests.FileLocatorTest categoriesFor: #testSingletonSerialisation!public!unit tests! !

