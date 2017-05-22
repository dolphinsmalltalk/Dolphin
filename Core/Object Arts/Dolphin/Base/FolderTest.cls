"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #FolderTest
	instanceVariableNames: 'c windows system root oa'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FolderTest guid: (GUID fromString: '{8b810291-5941-433e-a94c-b16bc3505368}')!
FolderTest comment: ''!
!FolderTest categoriesForClass!Unclassified! !
!FolderTest methodsFor!

folderClass
	^Folder!

rootFolder
	^'\'!

setUp
	c := self folderClass pathname: 'c:\'.
	windows := self folderClass pathname: 'c:\windows\'.
	system := self folderClass pathname: 'c:\windows\system32\'.
	root := self folderClass pathname: ''.
	oa := self folderClass pathname: 'Object Arts\'.!

testFolderName
	self assert: root folderName = self rootFolder.
	self assert: (c folderName endsWith: '(C:)').
	self assert: windows folderName = 'c:\windows\'.
	self assert: system folderName = 'c:\windows\system32\'.
	self assert: oa folderName = ((self rootFolder copyWithout: $\), '\Object Arts\').!

testName
	self assert: root name = self rootFolder.
	self assert: (c name endsWith: '(C:)').
	self assert: windows name = 'windows'.
	self assert: system name = 'system32'.
	self assert: oa name = 'Object Arts'.! !
!FolderTest categoriesFor: #folderClass!constants!private! !
!FolderTest categoriesFor: #rootFolder!public!unit tests! !
!FolderTest categoriesFor: #setUp!public!Running! !
!FolderTest categoriesFor: #testFolderName!public!unit tests! !
!FolderTest categoriesFor: #testName!public!unit tests! !

