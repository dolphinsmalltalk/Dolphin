"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableItemsTest subclass: #'Tools.Tests.PackageSelectorTest'
	instanceVariableNames: 'packageA'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackageSelectorTest guid: (Core.GUID fromString: '{eb6a3732-7f1e-4c12-b050-6446fcbde374}')!
Tools.Tests.PackageSelectorTest comment: ''!
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
	self assert: presenter selections asSet equals: Package manager packages asSet!

testPackageCreationDoesntAlterSelection
	| selections |
	self skip: 'Creating a new package completely resets the package selector.'.
	presenter selections: (Array with: self class owningPackage).
	selections := presenter selections.
	self assert: (selections size = 1 and: [selections first = self class owningPackage]).
	self 
		shouldnt: [packageA := self createPackage: 'Core\Object Arts\Dolphin\Tests\A']
		triggerAnyOf: #(#selectionChanged #selectionChanging)
		against: presenter.
	self assert: presenter selections = selections!

testPackageRemovalDoesntAlterSelection
	| selections newSelections |
	self skip: 'Removing a package resets the selection.'.
	packageA := self createPackage: 'Core\Object Arts\Dolphin\Tests\A'.
	presenter selections: (Array with: self class owningPackage).
	selections := presenter selections.
	self assert: (selections size = 1 and: [selections first = self class owningPackage]).
	self 
		shouldnt: [self removePackage: packageA]
		triggerAnyOf: #(#selectionChanged #selectionChanging)
		against: presenter.
	packageA := nil.
	newSelections := presenter selections.
	self assert: newSelections = selections! !
!Tools.Tests.PackageSelectorTest categoriesForMethods!
classToTest!helpers!private! !
createPackage:!helpers!private! !
removePackage:!helpers!private! !
tearDown!private! !
testFilter!public! !
testPackageCreationDoesntAlterSelection!public! !
testPackageRemovalDoesntAlterSelection!public! !
!

