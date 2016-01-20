"Filed out from Dolphin Smalltalk 7"!

SelectableItemsTest subclass: #SelectableTreeItemsTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SelectableTreeItemsTest guid: (GUID fromString: '{CCCEC658-6B6A-4D9F-A9AC-2701DA23A46E}')!
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
	self assert: presenter view size = 0!

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
	self assert: presenter selection = Number.

	"Check that moving the parent of a selected class doesn't alter selection.
	and trigger a #selectionChanged event"
	presenter selection: ArithmeticValue.
	self assert: (self treeModel parentOf: presenter selection) == Magnitude.
	self 
		shouldnt: [self treeModel move: Magnitude asChildOf: Object]
		trigger: #selectionChanged
		against: presenter.
	self assert: presenter selection == ArithmeticValue.

	"Tidy up"
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
	self assert: presenter selection == objects last.
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
	self assert: presenter selection == objects last.
	self 
		shouldnt: [presenter selection: objects last]
		trigger: #selectionChanging:
		against: presenter!

treeModel
	^presenter model! !
!SelectableTreeItemsTest categoriesFor: #addAllObjects:!private!unit tests! !
!SelectableTreeItemsTest categoriesFor: #addAllTestObjects!private!unit tests! !
!SelectableTreeItemsTest categoriesFor: #addRoot:!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #objectsToTest!helpers!private! !
!SelectableTreeItemsTest categoriesFor: #testAddRemove!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #testHierarchyMove!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #testSelectionChangeTriggeredOnRemove!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #testSetImageBlockDoesNotAffectSelection!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!SelectableTreeItemsTest categoriesFor: #treeModel!public!unit tests! !

!SelectableTreeItemsTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!SelectableTreeItemsTest class categoriesFor: #isAbstract!public!Testing! !

