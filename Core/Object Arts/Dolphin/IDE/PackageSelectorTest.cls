"Filed out from Dolphin Smalltalk 7"!

SelectableItemsTest subclass: #PackageSelectorTest
	instanceVariableNames: 'packageA'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
PackageSelectorTest guid: (GUID fromString: '{EB6A3732-7F1E-4C12-B050-6446FCBDE374}')!
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

	self assert: presenter filter isNil.
	self assert: presenter packages isEmpty.
	self assert: presenter selections isEmpty.

	"Now select the root folder, check that we are filled with all packages"
	presenter autoSelect: false.
	presenter selectRootFolder.
	self assert: (presenter packagesPresenter list asSet equals: Package manager packages asSet).

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
	self assert: (presenter selections asSet equals: Package manager packages asSet)!

testPackageCreationDoesntAlterSelection
	| selections |
	presenter selections: (Array with: self class owningPackage).
	selections := presenter selections.
	self assert: (selections size = 1 and: [selections first = self class owningPackage]).
	self 
		shouldnt: [packageA := self createPackage: 'Object Arts\Dolphin\Tests\A']
		triggerAnyOf: #(#selectionChanged #selectionChanging)
		against: presenter.
	self assert: presenter selections = selections!

testPackageRemovalDoesntAlterSelection
	| selections newSelections |
	packageA := self createPackage: 'Object Arts\Dolphin\Tests\A'.
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
!PackageSelectorTest categoriesFor: #classToTest!helpers!private! !
!PackageSelectorTest categoriesFor: #createPackage:!helpers!private! !
!PackageSelectorTest categoriesFor: #removePackage:!helpers!private! !
!PackageSelectorTest categoriesFor: #tearDown!private! !
!PackageSelectorTest categoriesFor: #testFilter!public! !
!PackageSelectorTest categoriesFor: #testPackageCreationDoesntAlterSelection!public! !
!PackageSelectorTest categoriesFor: #testPackageRemovalDoesntAlterSelection!public! !

