"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DiskVolumeInformationTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DiskVolumeInformationTest guid: (GUID fromString: '{b920c262-99c0-49b9-8710-57611ad81543}')!
DiskVolumeInformationTest comment: ''!
!DiskVolumeInformationTest categoriesForClass!Unclassified! !
!DiskVolumeInformationTest methodsFor!

testFileSystemFlags
	self deny: DiskVolumeInformation forSystemPath fileSystemFlags equals: 0! !
!DiskVolumeInformationTest categoriesFor: #testFileSystemFlags!public! !

