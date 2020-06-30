"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DiskVolumeInformationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
DiskVolumeInformationTest guid: (GUID fromString: '{b920c262-99c0-49b9-8710-57611ad81543}')!
DiskVolumeInformationTest comment: ''!
!DiskVolumeInformationTest categoriesForClass!Unclassified! !
!DiskVolumeInformationTest methodsFor!

testFileSystemFlags
	| subject |
	subject := DiskVolumeInformation forSystemPath.
	self deny: subject fileSystemFlags equals: 0.
	self skipUnless: [subject fileSystemName = 'NTFS'].
	self assert: subject isSparseFileCapable! !
!DiskVolumeInformationTest categoriesFor: #testFileSystemFlags!public! !

