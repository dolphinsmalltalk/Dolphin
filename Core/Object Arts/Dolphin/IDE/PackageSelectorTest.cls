"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #PackageSelectorTest
	instanceVariableNames: 'packageA'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageSelectorTest guid: (GUID fromString: '{eb6a3732-7f1e-4c12-b050-6446fcbde374}')!
PackageSelectorTest comment: ''!
!PackageSelectorTest categoriesForClass!Unclassified! !
!PackageSelectorTest methodsFor!

classToTest
	^PackageSelector!

createPackage: name 
	^Package manager newPackage: name!

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
!PackageSelectorTest categoriesForMethods!
classToTest!helpers!private! !
createPackage:!helpers!private! !
removePackage:!helpers!private! !
tearDown!private! !
testFilter!public! !
!

