"Filed out from Dolphin Smalltalk 7"!

UI.Tests.SelectableTreeItemsTest subclass: #'UI.Tests.TreeViewTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.TreeViewTest guid: (Core.GUID fromString: '{9f22e0fe-4151-461c-a92a-f1d9f25e6605}')!
UI.Tests.TreeViewTest comment: ''!
!UI.Tests.TreeViewTest categoriesForClass!Unclassified! !
!UI.Tests.TreeViewTest methodsFor!

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
	| child root text |
	presenter hasLinesAtRoot: true.
	presenter view updateMode: aSymbol.
	root := '1' -> 1.
	presenter model addRoot: root.
	child := '1.1' -> 2.
	presenter model add: child asChildOf: root.
	presenter view expandAll: root.
	self paintTree.
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
		yourself!

testRefreshTreeDynamic
	self refreshTree: #dynamic!

testRefreshTreeLazy
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #lazy!

testRefreshTreeStatic
	"Just re-requesting the text is sufficient to get it to redisplay"

	self refreshTree: #static!

testSelectionSetter
	| object1 |
	object1 := '1'.
	presenter model: (TreeModel withRoots: {object1} searchPolicy: SearchPolicy equality).
	self assert: (presenter selection: object1) identicalTo: object1!

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
!UI.Tests.TreeViewTest categoriesFor: #classToTest!helpers!private! !
!UI.Tests.TreeViewTest categoriesFor: #getItemText:!helpers!private! !
!UI.Tests.TreeViewTest categoriesFor: #paintTree!helpers!private! !
!UI.Tests.TreeViewTest categoriesFor: #refreshTree:!helpers!private! !
!UI.Tests.TreeViewTest categoriesFor: #testCollapseOneLevel!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testCollapseTwoLevels!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testRefreshTreeDynamic!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testRefreshTreeLazy!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testRefreshTreeStatic!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testSelectionSetter!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testSelectionsPreservedOnRecreate!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testSetImageBlockDoesNotAffectSelection!public!unit tests! !
!UI.Tests.TreeViewTest categoriesFor: #testSetTextBlockDoesNotAffectSelection!public!unit tests! !

