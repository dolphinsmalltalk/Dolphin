"Filed out from Dolphin Smalltalk"!

FolderTest subclass: #PackageFolderTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

PackageFolderTest guid: (GUID fromString: '{3a14afc2-659e-4b7b-af2f-dc8631af7128}')!

PackageFolderTest comment: ''!

!PackageFolderTest categoriesForClass!Unclassified! !

!PackageFolderTest methodsFor!

folderClass
	^PackageFolder!

rootFolder
	^'$'!

testForPackage
	| dolphin dolphinPackage dolphinPackageFolder |
	dolphinPackage := Object owningPackage.
	dolphinPackageFolder := dolphinPackage packageFolder.
	dolphin := self folderClass forPackage: dolphinPackage.
	self assert: dolphin name equals: 'Base'.
	self assert: dolphin folderName equals: '$\' , dolphinPackageFolder! !

!PackageFolderTest categoriesForMethods!
folderClass!constants!private! !
rootFolder!public!unit tests! !
testForPackage!public!unit tests! !
!

