"Filed out from Dolphin Smalltalk"!

SelectableTreeItemsTest subclass: #TreeViewTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
TreeViewTest guid: (GUID fromString: '{9f22e0fe-4151-461c-a92a-f1d9f25e6605}')!
TreeViewTest comment: ''!
!TreeViewTest categoriesForClass!Unclassified! !
!TreeViewTest methodsFor!

classToTest
	^TreeView!

getItemText: anObject
	| treeView |
	treeView := presenter view.
	^treeView getItemText: (treeView handleFromObject: anObject)!

paintTree
	false
		ifTrue: 
			[(presenter view)
				invalidate;
				update]!

refreshTree: aSymbol
	| tvItem child root text |
	presenter hasLinesAtRoot: true.
	presenter view updateMode: aSymbol.
	root := '1' -> 1.
	presenter model addRoot: root.
	child := '1.1' -> 2.
	presenter model add: child asChildOf: root.
	presenter view expandAll: root.
	self paintTree.
	tvItem := self getItemText: root.
	text := root displayString.
	self assert: (self getItemText: root) equals: text.
	root value: 3.
	presenter view updateMode == #dynamic
		ifFalse: 
			[self assert: (self getItemText: root) equals: text.
			self paintTree.
			self assert: (self getItemText: root) equals: text]
		ifTrue: 
			["Just re-requesting the text is sufficient to get it to redisplay"
			self assert: (self getItemText: root) equals: root displayString].
	presenter model refreshTree: root.
	self assert: (self getItemText: root) equals: root displayString.
	self paintTree!

testCollapseOneLevel
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	presenter view expandAll: '1'.
	presenter model collapse: '1'.
	self paintTree!

testCollapseTwoLevels
	presenter hasLinesAtRoot: true.
	presenter model: (TreeModel withRoots: #('1') searchPolicy: SearchPolicy equality).
	presenter model add: '1.1' asChildOf: '1'.
	#('1.1.1' '1.1.2') do: [:each | presenter model add: each asChildOf: '1.1'].
	presenter view expandAll: '1'.
	self
		assert: (presenter isExpanded: '1');
		assert: (presenter isExpanded: '1.1');
		yourself.
	presenter model collapse: '1.1'.
	self
		paintTree;
		assert: (presenter isExpanded: '1');
		deny: (presenter isExpanded: '1.1');
		yourself.
	presenter model collapse: '1'.
	self paintTree
		deny: (presenter isExpanded: '1');
		deny: (presenter isExpanded: '1.1');
		yourself.
!

testRefreshTreeDynamic
	self refreshTree: #dynamic!

testRefreshTreeLazy
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #lazy!

testRefreshTreeStatic
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #static!

testSelectionSetter
	| object1 object2 |
	object1 := '1'.
	presenter model: (TreeModel withRoots: (Array with: object1) searchPolicy: SearchPolicy equality).
	self assert: (object2 := presenter selection: object1) identicalTo: object1!

testSelectionsPreservedOnRecreate
	| root child |
	presenter hasLinesAtRoot: true.
	root := '1'.
	presenter model addRoot: root.
	child := '1.1'.
	presenter model add: child asChildOf: root.
	presenter selection: child.
	presenter recreate.
	self assert: presenter selection equals: child
!

testSetImageBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetImageBlockDoesNotAffectSelection.
			presenter view model clear]!

testSetTextBlockDoesNotAffectSelection
	presenter view class updateModes do: 
			[:each | 
			presenter view updateMode: each.
			super testSetTextBlockDoesNotAffectSelection.
			presenter view model clear]! !
!TreeViewTest categoriesForMethods!
classToTest!helpers!private! !
getItemText:!helpers!private! !
paintTree!helpers!private! !
refreshTree:!helpers!private! !
testCollapseOneLevel!public!unit tests! !
testCollapseTwoLevels!public!unit tests! !
testRefreshTreeDynamic!public!unit tests! !
testRefreshTreeLazy!public!unit tests! !
testRefreshTreeStatic!public!unit tests! !
testSelectionSetter!public!unit tests! !
testSelectionsPreservedOnRecreate!public!unit tests! !
testSetImageBlockDoesNotAffectSelection!public!unit tests! !
testSetTextBlockDoesNotAffectSelection!public!unit tests! !
!

