"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.FolderTest'
	instanceVariableNames: 'c windows system root oa'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.FolderTest guid: (Core.GUID fromString: '{8b810291-5941-433e-a94c-b16bc3505368}')!
UI.Tests.FolderTest comment: ''!
!UI.Tests.FolderTest categoriesForClass!Unclassified! !
!UI.Tests.FolderTest methodsFor!

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
	self assertIsNil: empty parent! !
!UI.Tests.FolderTest categoriesFor: #folderClass!constants!private! !
!UI.Tests.FolderTest categoriesFor: #rootFolder!public!unit tests! !
!UI.Tests.FolderTest categoriesFor: #setUp!public!Running! !
!UI.Tests.FolderTest categoriesFor: #testFolderName!public!unit tests! !
!UI.Tests.FolderTest categoriesFor: #testName!public!unit tests! !
!UI.Tests.FolderTest categoriesFor: #testParent!public!unit tests! !

