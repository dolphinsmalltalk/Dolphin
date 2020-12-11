"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'OS.Tests.DiskVolumeInformationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Tests.DiskVolumeInformationTest guid: (Core.GUID fromString: '{b920c262-99c0-49b9-8710-57611ad81543}')!
OS.Tests.DiskVolumeInformationTest comment: ''!
!OS.Tests.DiskVolumeInformationTest categoriesForClass!Unclassified! !
!OS.Tests.DiskVolumeInformationTest methodsFor!

testFileSystemFlags
	| subject |
	subject := DiskVolumeInformation forSystemPath.
	self deny: subject fileSystemFlags equals: 0.
	self skipUnless: [subject fileSystemName = 'NTFS'].
	self assert: subject isSparseFileCapable! !
!OS.Tests.DiskVolumeInformationTest categoriesFor: #testFileSystemFlags!public! !

