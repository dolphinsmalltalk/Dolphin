"Filed out from Dolphin Smalltalk 7"!

UI.Tests.FolderTest subclass: #'Tools.Tests.PackageFolderTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackageFolderTest guid: (Core.GUID fromString: '{3a14afc2-659e-4b7b-af2f-dc8631af7128}')!
Tools.Tests.PackageFolderTest comment: ''!
!Tools.Tests.PackageFolderTest categoriesForClass!Unclassified! !
!Tools.Tests.PackageFolderTest methodsFor!

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
!Tools.Tests.PackageFolderTest categoriesFor: #folderClass!constants!private! !
!Tools.Tests.PackageFolderTest categoriesFor: #rootFolder!public!unit tests! !
!Tools.Tests.PackageFolderTest categoriesFor: #testForPackage!public!unit tests! !

