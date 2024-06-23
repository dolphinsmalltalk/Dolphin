"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.DiskVolumeInformationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.DiskVolumeInformationTest guid: (Core.GUID fromString: '{b920c262-99c0-49b9-8710-57611ad81543}')!

OS.Tests.DiskVolumeInformationTest comment: ''!

!OS.Tests.DiskVolumeInformationTest methodsFor!

testDiskSpaceCalcs
		| subject |
	subject := DiskVolumeInformation forSystemPath.
	self assert: subject freeBytes < subject totalBytes.
	self assert: subject freeBytes <= subject totalFreeBytes.
	self assert: subject totalFreeBytes < subject totalBytes!

testFileSystemFlags
	| subject |
	subject := DiskVolumeInformation forSystemPath.
	self deny: subject fileSystemFlags equals: 0.
	self skipUnless: [subject fileSystemName = 'NTFS'].
	self assert: subject isSparseFileCapable! !

!OS.Tests.DiskVolumeInformationTest categoriesForMethods!
testDiskSpaceCalcs!public! !
testFileSystemFlags!public! !
!

