"Filed out from Dolphin Smalltalk 7"!

Tools.Tests.ClassSelectorTest subclass: #'Tools.Tests.PackagedClassSelectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.PackagedClassSelectorTest guid: (Core.GUID fromString: '{85913f04-2759-4d36-864b-eac86b435a51}')!
Tools.Tests.PackagedClassSelectorTest comment: ''!
!Tools.Tests.PackagedClassSelectorTest categoriesForClass!Unclassified! !
!Tools.Tests.PackagedClassSelectorTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	presenter selectableItems selection: anObject ifAbsent: [].
	self assert: presenter selectableItems selection identicalTo: anObject.
	presenter selectableItems selectionOrNil: sel!

classToTest
	^PackagedClassSelector!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	self should: [presenter selectableItems selection: anObject] raise: NotFoundError.
	presenter selectableItems selectionOrNil: sel!

removalOfSelectionLeaves: aClass 
	"Private - Answer the class that we would expect to be selected follwing the removal of aClass when it was originally
	selected in the receiver"

	^nil
	"	siblings := aClass superclass subclasses.
	^siblings size = 1 
		ifTrue: [aClass superclass]
		ifFalse: [siblings after: aClass]"!

resetSelection
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageA) parent.
	super resetSelection!

testFilteredPackageAddRemove
	"Test adding/removing classes with a filter in place"

	| abc def |
	self resetSelection.
	"Filter on B"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageB).

	"These classes should not be displayed"
	abc := self createClassesABC.	"Package A"
	abc do: [:each | self denyContains: each].

	"These classes should be displayed"
	def := self createClassesDEF.	"Package B"
	def do: [:each | self assertContains: each].

	"Switch filter to C"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageC).
	abc do: [:each | self denyContains: each].
	def do: [:each | self assertContains: each].

	"Switch filter to A - should show all"
	presenter packagesPresenter filterPresenter selection: (PackageFolder forPackage: packageA).
	abc do: [:each | self assertContains: each].
	def do: [:each | self assertContains: each].

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC.
	abc do: [:each | self denyContains: each].
	def do: [:each | self denyContains: each]!

testFilteredPackagedHierarchyMove
	"Test moving classes with a filter in place."

	self resetSelection.
	(presenter instVarNamed: 'classesPresenter') view ensureVisible.
	presenter packages: {packageB}.
	self assert: presenter selectableItems selectableItems treeModel asArray isEmpty.
	self createClassesABC.
	self assert: presenter selectableItems selectableItems treeModel asArray isEmpty.
	self createClassesDEF.
	self assertContains: Object.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.

	"Now move some classes under superclasses which are not in the selected package - the tree must update
	to include these."
	"	(self runKnownBug: '#1078' test: #testFilteredPackagedHierarchyMove) ifFalse: [^self]."

	"First move a leaf, but for extra interest make it the selection"
	presenter selection: dolphinTestF.
	self create: #DolphinTestF subclassOf: dolphinTestA.
	self assertContains: dolphinTestF.
	self assert: presenter selection identicalTo: dolphinTestF.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.

	"A should now be in the tree (greyed of course)"
	self assertContains: dolphinTestA.
	"B is a subclass of A, but still should not be in the tree"
	self denyContains: dolphinTestB.
	"Now move a tree of classes under B, bringing it in too"
	self create: #DolphinTestD subclassOf: dolphinTestB.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self assertContains: dolphinTestA.
	self assertContains: dolphinTestB.

	"Now if we move D back, B should disappear"
	self create: #DolphinTestD subclassOf: Object.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self assertContains: dolphinTestA.
	self denyContains: dolphinTestB.

	"And finally move F back under D"
	self create: #DolphinTestF subclassOf: dolphinTestD.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assertContains: dolphinTestF.
	self denyContains: dolphinTestA.
	self denyContains: dolphinTestB.

	"Tidy up"
	self removeClassesDEF.
	self removeClassesABC! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #assertContains:!helpers!private! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #classToTest!helpers!private! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #denyContains:!helpers!private! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #removalOfSelectionLeaves:!helpers!private! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #resetSelection!helpers!private! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #testFilteredPackageAddRemove!public!unit tests! !
!Tools.Tests.PackagedClassSelectorTest categoriesFor: #testFilteredPackagedHierarchyMove!public!unit tests! !

