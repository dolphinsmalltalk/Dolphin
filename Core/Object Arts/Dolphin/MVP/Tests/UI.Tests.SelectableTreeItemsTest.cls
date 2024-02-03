"Filed out from Dolphin Smalltalk"!

UI.Tests.SelectableItemsTest
	subclass: #'UI.Tests.SelectableTreeItemsTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.SelectableTreeItemsTest guid: (Core.GUID fromString: '{cccec658-6b6a-4d9f-a9ac-2701da23a46e}')!
UI.Tests.SelectableTreeItemsTest isNonInstantiable: true!
UI.Tests.SelectableTreeItemsTest comment: ''!
!UI.Tests.SelectableTreeItemsTest methodsFor!

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

defaultSelectionChangedAction
	^
	[events addLast: ((SelectionChangedEvent forSource: presenter)
				newSelections: presenter view selections;
				yourself)]!

getItemImage: anObject
	| view |
	view := presenter view.
	^view getItemImage: (view handleFromObject: anObject)!

getItemText: anObject
	| view |
	view := presenter view.
	^view getItemText: (view handleFromObject: anObject)!

imageIndexForNode: anAssociation
	^anAssociation value odd ifTrue: [(self objectsToTest at: anAssociation value) iconImageIndex]!

isSelectionLostOnRemove
	^false!

mouseDownEventOn: anObject buttons: anArray
	| position treeView |
	treeView := presenter view.
	position := (treeView handleFromObject: anObject)
				ifNil: [treeView clientRectangle corner - 1]
				ifNotNil: [:hItem | (treeView itemRect: hItem textOnly: true) origin + 1].
	^self mouseDownEventAt: position buttons: anArray!

objectsToTest
	^{Object. View. Behavior. Magnitude. ArithmeticValue. Point. Number. Point3D}!

paintTree
	false
		ifTrue: 
			[(presenter view)
				invalidate;
				update]!

refreshTree: aSymbol
	| root text nodes |
	presenter view updateMode: aSymbol.
	root := '1' -> 0.
	presenter model
		removeAll;
		addRoot: root.
	nodes := OrderedCollection with: root.
	1 to: 4 do: [:each | presenter model add: (nodes add: 1 + (each / 10.0) -> each) asChildOf: root].
	presenter view expandAll: root.
	self paintTree.
	text := root displayString.
	self assert: (self getItemText: root) equals: text.
	nodes do: 
			[:each |
			self assert: (self getItemImage: each)
				equals: ((self imageIndexForNode: each)
						ifNil: [CommCtrlConstants.I_IMAGENONE]
						ifNotNil: [:index | index - 1])].
	root value: 3.
	presenter view updateMode == #dynamic
		ifTrue: 
			["Just re-requesting the text should be sufficient to get it to redisplay"
			self assert: (self getItemText: root) equals: root displayString]
		ifFalse: 
			[self assert: (self getItemText: root) equals: text.
			self paintTree.
			self assert: (self getItemText: root) equals: text].
	presenter model refreshTree: root.
	self assert: (self getItemText: root) equals: root displayString.
	presenter view expandAll: root.
	presenter view model do: 
			[:each |
			self assert: (self getItemImage: each)
				equals: ((self imageIndexForNode: each)
						ifNil: [CommCtrlConstants.I_IMAGENONE]
						ifNotNil: [:index | index - 1])].
	self paintTree!

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
			classes reverseDo: [:each | self treeModel remove: each].
			classes reverseDo: [:each | self denyContains: each]].
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

testCollapseOneLevel
	presenter view hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	presenter view expandAll: '1'.
	presenter model collapse: '1'.
	self paintTree!

testCollapseTwoLevels
	| treeView |
	treeView := presenter view.
	treeView hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	#('1.1.1' '1.1.2') do: [:each | presenter model add: each asChildOf: '1.1'].
	treeView expandAll: '1'.
	self
		assert: (treeView isExpanded: '1');
		assert: (treeView isExpanded: '1.1');
		yourself.
	presenter model collapse: '1.1'.
	self
		paintTree;
		assert: (treeView isExpanded: '1');
		deny: (treeView isExpanded: '1.1');
		yourself.
	presenter model collapse: '1'.
	self paintTree
		deny: (treeView isExpanded: '1');
		deny: (treeView isExpanded: '1.1');
		yourself!

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

testRefreshTree
	presenter view
		hasLinesAtRoot: true;
		viewMode: #smallIcons;
		getImageBlock: [:assoc | self imageIndexForNode: assoc].
	self viewClass updateModes do: [:each | self refreshTree: each]!

testSelection
	"Test selection"

	| objects event |
	objects := self objectsToTest.
	self addAllObjects: objects.
	self observeSelectionEvents.
	"We don't expect #selectionChanging: events when changing the selection programmatically"
	selectionChanging := [:selChanging | self fail: 'Unexpected #selectionChanging: event triggered'].
	objects do: 
			[:each |
			events := OrderedCollection new.
			presenter selection: each.
			self assert: presenter selection identicalTo: each.
			event := events single.
			self assert: event isKindOf: SelectionChangedEvent.
			self assert: event newSelections equals: { each }].
	events := OrderedCollection new.
	presenter resetSelection.
	event := events single.
	self assert: event isKindOf: SelectionChangedEvent.
	self assert: event newSelections equals: #().

	"remove should not upset selection"
	presenter selection: objects first.
	events := OrderedCollection new.
	self treeModel remove: objects last.
	self assert: presenter selection identicalTo: objects first.
	self assert: events isEmpty.

	"add should not upset selection"
	self treeModel add: objects last asChildOf: objects last superclass.
	self assert: presenter selection identicalTo: objects first.
	self assert: events isEmpty.
	"remove of selected object should trigger #selectionChanged and leave either a sibling, or the parent of the selection selected"
	{ Number. Point3D. Point. ArithmeticValue } do: 
			[:each |
			presenter selection: each.
			events := OrderedCollection new.
			self treeModel remove: each.
			event := events single.
			self assert: event isKindOf: SelectionChangedEvent.
			self isSelectionLostOnRemove
				ifFalse: 
					["If the selected object has siblings, the next of those should be selected, if not the parent"
					presenter selection = each superclass
						ifTrue: 
							["Parent selected, should be no remaining siblings of the removed child"
							self assert: (self treeModel childrenOf: presenter selection) isEmpty]
						ifFalse: [self assert: presenter selection superclass equals: each superclass].
					self assert: event newSelections equals: { presenter selection }]
				ifTrue: 
					[self deny: presenter hasSelection.
					self assert: event newSelections equals: #()]].

	"No selection tests"
	objects do: [:each | self treeModel add: each asChildOf: each superclass].
	objects do: 
			[:each |
			presenter selection: each.
			events := OrderedCollection new.
			presenter resetSelection.
			self assertIsNil: presenter selectionOrNil.
			event := events single.
			self assert: event isKindOf: SelectionChangedEvent.
			self assert: event newSelections equals: #().
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
	"TreeListPresenter is based on ListView, which has different behaviour with regards to selection when the selected item is removed. In a TreeView, the selection is moved to a sibling or parent. In the ListView, the selection is just removed. We don't try to fight it."
	self isSelectionLostOnRemove
		ifTrue: 
			[self deny: presenter hasSelection.
			self
				shouldnt: [self treeModel remove: #b]
				triggerAnyOf: #(#selectionChanging: #selectionChanged)
				against: presenter]
		ifFalse: 
			[self assert: presenter hasSelection.
			self
				should: [self treeModel remove: #b]
				trigger: #selectionChanged
				butNot: #selectionChanging:
				against: presenter]!

testSelectionChanging
	| objects selection selChanging selChanged |
	presenter view topView extent: 600 @ 600.
	objects := self objectsToTest.
	self addAllObjects: objects.
	presenter view expandAll.
	self
		observeSelectionEvents;
		setupClickTimeout.
	selection := nil.
	objects do: 
			[:each |
			events := OrderedCollection new.
			self sendClickEvent: (self mouseDownEventOn: each buttons: {each ifNil: [#right] ifNotNil: [#left]}).
			self assert: events size equals: 2.
			selChanging := events first.
			self assert: selChanging isKindOf: SelectionChangingEvent.
			self assert: selChanging newSelections equals: {each}.
			self assert: selChanging oldSelections equals: (selection ifNil: [#()] ifNotNil: [{selection}]).
			selection := presenter selection.
			self assert: selection identicalTo: each.
			selChanged := events second.
			self assert: selChanged isKindOf: SelectionChangedEvent.
			self assert: selChanging newSelections equals: {each}].
	"Clear selection with right-click over no-man's land"
	events := OrderedCollection new.
	self sendClickEvent: (self mouseDownEventOn: nil buttons: {#right}).
	self deny: presenter hasSelection.
	self assert: events size equals: 2.
	selChanging := events first.
	self assert: selChanging isKindOf: SelectionChangingEvent.
	self assert: selChanging newSelections equals: #().
	self assert: selChanging oldSelections equals: {objects last}.
	selChanged := events second.
	self assert: selChanged isKindOf: SelectionChangedEvent.
	self assert: selChanging newSelections equals: #()!

testSelectionSetter
	| object1 |
	object1 := '1'.
	presenter model: (TreeModel withRoots: {object1} searchPolicy: SearchPolicy equality).
	self assert: (presenter selection: object1) identicalTo: object1!

testSelectionsPreservedOnRecreate
	| root child |
	presenter view hasLinesAtRoot: true.
	root := '1'.
	presenter model addRoot: root.
	child := '1.1'.
	presenter model add: child asChildOf: root.
	presenter selection: child.
	presenter view recreate.
	self assert: presenter selection equals: child
!

testSetImageBlockDoesNotAffectSelection
	| objects |
	objects := self addAllTestObjects.
	presenter view class updateModes do: 
			[:each |
			presenter view updateMode: each.
			presenter view viewMode: #smallIcons.
			presenter selection: objects last.
			self
				shouldnt: [presenter view getImageBlock: [:each1 | each1 icon imageIndex + 1]]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selection identicalTo: objects last.
			self
				shouldnt: [presenter selection: objects last]
				trigger: #selectionChanging:
				against: presenter]!

testSetTextBlockDoesNotAffectSelection
	| objects |
	objects := self addAllTestObjects.
	presenter view class updateModes do: 
			[:each |
			presenter view updateMode: each.
			presenter selection: objects last.
			self
				shouldnt: 
					["Remove an object after the selection"
					presenter view getTextBlock: [:each1 | each1 printString , ' &c']]
				trigger: #selectionChanged
				against: presenter.
			self assert: presenter selection identicalTo: objects last.
			self
				shouldnt: [presenter selection: objects last]
				trigger: #selectionChanging:
				against: presenter]!

treeModel
	^presenter model! !
!UI.Tests.SelectableTreeItemsTest categoriesForMethods!
addAllObjects:!private!unit tests! !
addAllTestObjects!private!unit tests! !
addRoot:!public!unit tests! !
defaultSelectionChangedAction!helpers!private! !
getItemImage:!helpers!private! !
getItemText:!helpers!private! !
imageIndexForNode:!helpers!private! !
isSelectionLostOnRemove!private!testing! !
mouseDownEventOn:buttons:!helpers!private! !
objectsToTest!helpers!private! !
paintTree!helpers!private! !
refreshTree:!helpers!private! !
testAddRemove!public!unit tests! !
testCollapseOneLevel!public!unit tests! !
testCollapseTwoLevels!public!unit tests! !
testHierarchyMove!public!unit tests! !
testRefreshTree!public!unit tests! !
testSelection!public!unit tests! !
testSelectionChangeTriggeredOnRemove!public!unit tests! !
testSelectionChanging!public!unit tests! !
testSelectionSetter!public!unit tests! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetImageBlockDoesNotAffectSelection!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
treeModel!public!unit tests! !
!

