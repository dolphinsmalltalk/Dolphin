"Filed out from Dolphin Smalltalk"!

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
	self assert: root folderName equals: self rootFolder.
	self assert: (c folderName endsWith: '(C:)').
	self assert: windows folderName equals: 'c:\windows\'.
	self assert: system folderName equals: 'c:\windows\system32\'.
	self assert: oa folderName equals: (self rootFolder copyWithout: $\) , '\Object Arts\'!

testName
	self assert: root name equals: self rootFolder.
	self assert: (c name endsWith: '(C:)').
	self assert: windows name equals: 'windows'.
	self assert: system name equals: 'system32'.
	self assert: oa name equals: 'Object Arts'!

testParent
	| subject empty top |
	top := Folder pathname: 'A\'.
	#('A\B' 'A\B\' 'A\£' 'A\£\' 'A\🐬' 'A\🐬\') do: 
			[:each |
			subject := (Folder pathname: each) parent.
			self assert: subject equals: top].
	subject := top parent.
	empty := Folder pathname: ''.
	self assert: subject equals: empty.
	self assertIsNil: empty parent!

testParentOfDriveRoot
	self assertIsNil: c parent.
	self assertIsNil: windows parent parent! !

!FolderTest categoriesForMethods!
folderClass!constants!private! !
rootFolder!public!unit tests! !
setUp!public!Running! !
testFolderName!public!unit tests! !
testName!public!unit tests! !
testParent!public!unit tests! !
testParentOfDriveRoot!public!unit tests! !
!

