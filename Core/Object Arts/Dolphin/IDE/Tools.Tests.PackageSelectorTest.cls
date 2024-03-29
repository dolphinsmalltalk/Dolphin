﻿"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableItemsTest
	subclass: #'Tools.Tests.PackageSelectorTest'
	instanceVariableNames: 'packageA defaultPackage'
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

losesSelectionOnPackageCreation
	"Private - Currently creating a new package completely resets the package selector."

	^true!

losesSelectionOnPackageRemoval
	"Private - Currently removing an existing package completely resets the package selector."

	^true!

removePackage: aPackage 
	Package manager removePackage: aPackage!

setUp
	super setUp.
	defaultPackage := Package manager defaultPackage!

tearDown
	Package manager defaultPackage: defaultPackage.
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
	<skipIf: #losesSelectionOnPackageRemoval>
	| selections |
	presenter selections: { self class owningPackage }.
	selections := presenter selections.
	self assert: (selections size = 1 and: [selections first = self class owningPackage]).
	self
		shouldnt: [packageA := self createPackage: 'Core\Object Arts\Dolphin\Tests\A']
		triggerAnyOf: #(#selectionChanged #selectionChanging)
		against: presenter.
	self assert: presenter selections = selections!

testPackageRemovalDoesntAlterSelection
	<skipIf: #losesSelectionOnPackageRemoval>
	| selections newSelections |
	packageA := self createPackage: 'Core\Object Arts\Dolphin\Tests\A'.
	presenter selections: { self class owningPackage }.
	selections := presenter selections.
	self assert: (selections size = 1 and: [selections first = self class owningPackage]).
	self
		shouldnt: [self removePackage: packageA]
		triggerAnyOf: #(#selectionChanged #selectionChanging)
		against: presenter.
	packageA := nil.
	newSelections := presenter selections.
	self assert: newSelections = selections!

testSetDefaultPackage
	presenter selections: { self class owningPackage }.
	presenter setAsDefaultPackage.
	self assert: Package manager defaultPackage identicalTo: self class owningPackage.
	presenter setAsDefaultPackage.
	self assertIsNil: Package manager defaultPackage.
	presenter setAsDefaultPackage.
	self assert: Package manager defaultPackage identicalTo: self class owningPackage.
	"Indirectly change the filter so that the default package is no longer in the list"
	presenter selections: { Object owningPackage }.
	presenter setAsDefaultPackage.
	"This used to error if the old default package was not in view"
	self assert: Package manager defaultPackage identicalTo: Object owningPackage! !
!Tools.Tests.PackageSelectorTest categoriesForMethods!
classToTest!helpers!private! !
createPackage:!helpers!private! !
losesSelectionOnPackageCreation!private!testing! !
losesSelectionOnPackageRemoval!private!testing! !
removePackage:!helpers!private! !
setUp!public!Running! !
tearDown!public!Running! !
testFilter!public!tests! !
testPackageCreationDoesntAlterSelection!public!tests! !
testPackageRemovalDoesntAlterSelection!public!tests! !
testSetDefaultPackage!public!tests! !
!

