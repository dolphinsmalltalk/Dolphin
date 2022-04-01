"Filed out from Dolphin Smalltalk"!

Tools.Tests.ClassSelectorTest subclass: #'Tools.Tests.ClassListSelectorTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Tools.Tests.ClassListSelectorTest guid: (Core.GUID fromString: '{1e05f062-5ab2-4d18-b534-77cb8b7ca82e}')!
Tools.Tests.ClassListSelectorTest comment: ''!
!Tools.Tests.ClassListSelectorTest methodsFor!

assertContains: anObject
	"Private - Asserts that the receiver contains anObject. We do this by trying to select the object since this allows us to verify whether the view is actually displaying the object in addition to it just appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection of the class-hierarchy presenter."

	| sel classHierarchy |
	classHierarchy := presenter classHierarchyPresenter.
	sel := classHierarchy selectionOrNil.
	classHierarchy selection: anObject.
	self assert: classHierarchy selection identicalTo: anObject.
	classHierarchy selectionOrNil: sel!

classToTest
	^ClassListSelector
!

denyContains: anObject 
	"Private - Asserts that the receiver does not contain anObject. We do this by trying to select the object since this allows
	us to verify whether the view is actually displaying the object in addition to it jsut appearing in the model"

	"We need to take care that altering the selection of the receiver doesn't change the filter. Therefore we use the selection
	of the #selectableItems presenter"

	| sel |
	sel := presenter selectableItems selectionOrNil.
	self should: [presenter selectableItems selection: anObject] raise: NotFoundError.
	presenter selectableItems selectionOrNil: sel!

initializePresenter
	super initializePresenter.
	presenter browserEnvironment: Refactory.Browser.BrowserEnvironment new!

listModel
	^presenter model!

removalOfSelectionLeaves: aClass
	"Private - Answer the class that we would expect to be selected following the removal of aClass when it was originally selected in the receiver"

	^presenter selectableItems == presenter classesListPresenter
		ifFalse: [super removalOfSelectionLeaves: aClass]!

resetSelection
	super resetSelection.
	self assertContains: Object.
	self assertContains: Behavior.!

testAddRemoveListItems
	"Test adding and removing classes"

	| nilSubclasses classHierarchy |
	classHierarchy := presenter classHierarchyPresenter.
	self resetSelection.

	"Add classes"
	self createClassesABC do: [:each | self assertContains: each].
	self createClassesDEF do: [:each | self assertContains: each].

	"Add some subclasses of nil"
	nilSubclasses := self createClassesGHI.
	nilSubclasses do: [:each | self assertContains: each].

	"Now remove some classes from the list - first a leaf"
	self listModel remove: dolphinTestC.
	self denyContains: dolphinTestC.
	self assertContains: dolphinTestB.
	self assertContains: dolphinTestA.

	"Now a branch - needs to remain behind"
	self listModel remove: dolphinTestA.
	self assertContains: dolphinTestA.
	self assert: (classHierarchy view includesItem: dolphinTestA).
	classHierarchy selection: dolphinTestA.
	self assertIsNil: presenter classesListPresenter selectionOrNil.
	self assertContains: dolphinTestB.
	self assert: (classHierarchy view includesItem: dolphinTestB).
	presenter view cardLayout showCard: classHierarchy view.
	presenter selection: dolphinTestB.
	presenter view cardLayout showCard: presenter classesListPresenter view.
	self assert: presenter classesListPresenter selectionOrNil identicalTo: dolphinTestB.

	"Now remove a child, then a branch, then the last child of that branch. The branch should go too"
	self listModel remove: dolphinTestF.
	self denyContains: dolphinTestF.
	self listModel remove: dolphinTestD.
	self assertContains: dolphinTestD.
	self assertContains: dolphinTestE.
	self assert: (classHierarchy view includesItem: dolphinTestD).
	self listModel remove: dolphinTestE.
	"When we remove E, D should disappear too as it is no longer needed as an infrastructural node"
	self deny: (classHierarchy view includesItem: dolphinTestD).
	self denyContains: dolphinTestD.

	"Remove a popular root"
	self listModel remove: Object.
	self assertContains: Object.
	self assert: (self treeModel roots includes: Object).
	self should: [presenter classesListPresenter selection: Object] raise: Error.

	"Remove a lonely root"
	self listModel remove: dolphinTestG.
	self should: [presenter classesListPresenter selection: dolphinTestG] raise: Error.
	self denyContains: dolphinTestG.
	self deny: (self treeModel roots includes: dolphinTestG).
	self assert: ((self treeModel instVarNamed: 'roots') includes: dolphinTestG).
	"Remove from tree from root"
	presenter classesListPresenter selection: ProtoObject.
	ProtoObject withAllSubclassesDo: [:each | self listModel remove: each].
	self assert: presenter classesListPresenter selectionOrNil isNil.
	self should: [presenter classesListPresenter selection: ProtoObject] raise: Error.
	self denyContains: ProtoObject.
	self deny: (self treeModel roots includes: ProtoObject).
	"Should still be in roots collection, even if filtered out by accessor"
	self assert: ((self treeModel instVarNamed: 'roots') includes: ProtoObject).
	"Add them back"
	ProtoObject withAllSubclasses reverseDo: [:each | self listModel add: each].
	"Now remove tree from bottom up"
	ProtoObject withAllSubclasses reverseDo: 
			[:each |
			self listModel remove: each.
			self deny: (self treeModel filter value: each)].
	self denyContains: ProtoObject.
	self deny: (self treeModel roots includes: ProtoObject).
	"Agaion should still be in roots collection, even if filtered out by accessor"
	self assert: ((self treeModel instVarNamed: 'roots') includes: ProtoObject).

	"Finally remove the classes through the tree"
	self removeClassesGHI.
	nilSubclasses do: [:each | self denyContains: each]!

treeModel
	^presenter classHierarchyPresenter treeModel! !
!Tools.Tests.ClassListSelectorTest categoriesForMethods!
assertContains:!helpers!private! !
classToTest!helpers!private! !
denyContains:!helpers!private! !
initializePresenter!public!Running! !
listModel!accessing!private! !
removalOfSelectionLeaves:!helpers!private! !
resetSelection!helpers!private! !
testAddRemoveListItems!public!unit tests! !
treeModel!accessing!private! !
!

