"Filed out from Dolphin Smalltalk 7"!

UI.Tests.SelectableItemsTest subclass: #'Tools.Tests.PackageSelectorTest'
	instanceVariableNames: 'packageA'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackageSelectorTest guid: (Core.GUID fromString: '{eb6a3732-7f1e-4c12-b050-6446fcbde374}')!
Tools.Tests.PackageSelectorTest comment: ''!
!Tools.Tests.PackageSelectorTest categoriesForClass!Unclassified! !
!Tools.Tests.PackageSelectorTest methodsFor!

classToTest
	^PackageSelector!

createPackage: aString
	^Package manager newPackage: aString!

removePackage: aPackage 
	Package manager removePackage: aPackage!

tearDown
	packageA notNil ifTrue: [self removePackage: packageA].
	super tearDown!

testFilter
	"Check that with no filter selected, there are no selected packages"

	self assertIsNil: presenter filter.
	self assert: presenter packages isEmpty.
	self assert: presenter selections isEmpty.

	"Now select the root folder, check that we are filled with all packages"
	presenter autoSelect: false.
	presenter selectRootFolder.
	self assert: presenter packagesPresenter list asSet equals: Package manager packages asSet.

	"With auto select off, the selections should be made automatically"
	self deny: presenter autoSelect.
	presenter selectRootFolder.
	self assert: presenter selections isEmpty.

	"With auto select on, the selections should be made automatically"
	presenter autoSelect: true.
	presenter
		selectNoFolder;
		selectRootFolder.
	self assert: presenter autoSelect.
	self assert: presenter selections asSet equals: Package manager packages asSet! !
!Tools.Tests.PackageSelectorTest categoriesFor: #classToTest!helpers!private! !
!Tools.Tests.PackageSelectorTest categoriesFor: #createPackage:!helpers!private! !
!Tools.Tests.PackageSelectorTest categoriesFor: #removePackage:!helpers!private! !
!Tools.Tests.PackageSelectorTest categoriesFor: #tearDown!private! !
!Tools.Tests.PackageSelectorTest categoriesFor: #testFilter!public! !

