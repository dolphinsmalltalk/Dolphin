"Filed out from Dolphin Smalltalk"!

SelectableItemsTest subclass: #SelectableTreeItemsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectableTreeItemsTest guid: (GUID fromString: '{cccec658-6b6a-4d9f-a9ac-2701da23a46e}')!
SelectableTreeItemsTest isAbstract: true!
SelectableTreeItemsTest comment: ''!
!SelectableTreeItemsTest categoriesForClass!Unclassified! !
!SelectableTreeItemsTest methodsFor!

addAllObjects: objects 
	objects do: [:each | self treeModel add: each asChildOf: each superclass].
!

addAllTestObjects
	| objects |
	objects := self objectsToTest.
	self addAllObjects: objects.
	objects do: [:each | self assertContains: each].
	^objects!

addRoot: anObject 
	self treeModel addRoot: anObject!

objectsToTest
	^(OrderedCollection new)
		add: Object;
		add: View;
		add: Behavior;
		add: Magnitude;
		add: ArithmeticValue;
		add: Point;
		add: Number;
		add: Point3D;
		yourself!

testAddRemove
	"Test adding and removing to the model"

	| objects |
	objects := self objectsToTest.
	1 to: objects size
		do: 
			[:n |
			| classes |
			classes := objects copyFrom: 1 to: n.
			classes do: [:each | self treeModel add: each asChildOf: each superclass].
			classes do: [:each | self assertContains: each].
			classes reverse do: [:each | self treeModel remove: each].
			classes reverse do: [:each | self denyContains: each]].
	self assert: self treeModel isEmpty.
	self assert: presenter model isEmpty.
	"Test removal of a branch with children"
	self addAllTestObjects.
	self assert: (presenter model includes: ArithmeticValue).
	self treeModel remove: ArithmeticValue.
	self assert: (presenter model asArray intersection: ArithmeticValue subclasses) isEmpty.
	"Test removal of a root with children"
	self assert: presenter model size > 1.
	self treeModel remove: Object.
	self assert: presenter model isEmpty.
	"Test removeAll"
	self addAllTestObjects.
	self treeModel removeAll.
	objects do: [:each | self denyContains: each].
	self assert: presenter model isEmpty.
	self assert: presenter view size equals: 0!

testHierarchyMove
	"Test moving classes around the hierarchy"

	"Make some changes to the hierarchy which shouldn't alter the displayed classes"

	| objects |
	objects := self addAllTestObjects copy.
	self treeModel move: Number asChildOf: Object.
	objects do: [:each | self assertContains: each].
	self treeModel move: Magnitude asChildOf: Number.
	objects do: [:each | self assertContains: each].
	"Now remove the moved classes"
	self treeModel removeAll.
	objects do: [:each | self denyContains: each].
	self deny: presenter hasSelection.
	self assert: presenter model isEmpty.

	"Check that moving a selected class doesn't alter selection
	or trigger #selectionChanged events"
	self
		shouldnt: [self addAllObjects: objects]
		trigger: #selectionChanged
		against: presenter.
	presenter selection: Number.
	self
		shouldnt: [self treeModel move: Number asChildOf: Object]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection equals: Number.

	"Check that moving the parent of a selected class doesn't alter selection.
	and trigger a #selectionChanged event"
	presenter selection: ArithmeticValue.
	self assert: (self treeModel parentOf: presenter selection) identicalTo: Magnitude.
	self
		shouldnt: [self treeModel move: Magnitude asChildOf: Object]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection identicalTo: ArithmeticValue.

	"Tidy up"
	self treeModel removeAll!

testSelection
	"Test selection"

	| objects |
	objects := self objectsToTest.
	self addAllObjects: objects.
	objects do: 
			[:each |
			self
				should: [presenter selection: each]
				trigger: #selectionChanged
				butNot: #selectionChanging:
				against: presenter.
			self assert: presenter selection identicalTo: each].
	self
		should: [presenter resetSelection]
		trigger: #selectionChanged
		butNot: #selectionChanging:
		against: presenter.

	"remove should not upset selection"
	presenter selection: objects first.
	self
		shouldnt: [self treeModel remove: objects last]
		triggerAnyOf: #(#selectionChanged #selectionChanging:)
		against: presenter.
	self assert: presenter selection identicalTo: objects first.

	"add should not upset selection"
	self
		shouldnt: [self treeModel add: objects last asChildOf: objects last superclass]
		triggerAnyOf: #(#selectionChanged #selectionChanging:)
		against: presenter.
	self assert: presenter selection identicalTo: objects first.
	"remove of selected object should trigger #selectionChanged and leave the parent of the selection selected"
	(Array
		with: Number
		with: Point3D
		with: Point
		with: ArithmeticValue) do: 
				[:each |
				presenter selection: each.
				self
					should: [self treeModel remove: each]
					trigger: #selectionChanged
					butNot: #selectionChanging:
					against: presenter.
				"If the selected object has siblings, the next of those should be selected, if not the parent"
				presenter selection = each superclass
					ifTrue: 
						["Parent selected, should be no remaining siblings"
						self assert: (self treeModel childrenOf: presenter selection) isEmpty]
					ifFalse: [self assert: presenter selection superclass equals: each superclass]].

	"No selection tests"
	objects do: [:each | self treeModel add: each asChildOf: each superclass].
	objects do: 
			[:each |
			presenter selection: each.
			self
				should: [presenter resetSelection]
				trigger: #selectionChanged
				butNot: #selectionChanging:
				against: presenter.
			self assertIsNil: presenter selectionOrNil.
			self should: [presenter selection] raise: Error].
	self treeModel removeAll!

testSelectionChangeTriggeredOnRemove
	self addRoot: #a.
	self addRoot: #b.
	presenter selection: #a.
	self 
		should: [self treeModel remove: #a]
		trigger: #selectionChanged
		butNot: #selectionChanging:
		against: presenter.
	self 
		should: [self treeModel remove: #b]
		trigger: #selectionChanged
		butNot: #selectionChanging:
		against: presenter!

testSetImageBlockDoesNotAffectSelection
	| objects |
	objects := self addAllTestObjects.
	presenter view viewMode: #smallIcons.
	presenter selection: objects last.
	self
		shouldnt: [presenter view getImageBlock: [:each | each icon imageIndex + 1]]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection identicalTo: objects last.
	self
		shouldnt: [presenter selection: objects last]
		trigger: #selectionChanging:
		against: presenter!

testSetTextBlockDoesNotAffectSelection
	| objects |
	objects := self addAllTestObjects.
	presenter selection: objects last.
	self
		shouldnt: 
			["Remove an object after the selection"
			presenter view getTextBlock: [:each | each printString , ' &c']]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection identicalTo: objects last.
	self
		shouldnt: [presenter selection: objects last]
		trigger: #selectionChanging:
		against: presenter!

treeModel
	^presenter model! !
!SelectableTreeItemsTest categoriesForMethods!
addAllObjects:!private!unit tests! !
addAllTestObjects!private!unit tests! !
addRoot:!public!unit tests! !
objectsToTest!helpers!private! !
testAddRemove!public!unit tests! !
testHierarchyMove!public!unit tests! !
testSelection!public!unit tests! !
testSelectionChangeTriggeredOnRemove!public!unit tests! !
testSetImageBlockDoesNotAffectSelection!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
treeModel!public!unit tests! !
!

