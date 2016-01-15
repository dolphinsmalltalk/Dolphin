"Filed out from Dolphin Smalltalk 7"!

FolderTest subclass: #PackageFolderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageFolderTest guid: (GUID fromString: '{3A14AFC2-659E-4B7B-AF2F-DC8631AF7128}')!
PackageFolderTest comment: ''!
!PackageFolderTest categoriesForClass!Unclassified! !
!PackageFolderTest methodsFor!

folderClass
	^PackageFolder!

rootFolder
	^'$'!

testForPackage
	| dolphin |
	dolphin := self folderClass forPackage: (Package manager packageNamed: 'Dolphin').
	self assert: dolphin name = 'Base'.
	self assert: dolphin folderName = '$\Object Arts\Dolphin\Base\'.
	! !
!PackageFolderTest categoriesFor: #folderClass!constants!private! !
!PackageFolderTest categoriesFor: #rootFolder!public!unit tests! !
!PackageFolderTest categoriesFor: #testForPackage!public!unit tests! !

