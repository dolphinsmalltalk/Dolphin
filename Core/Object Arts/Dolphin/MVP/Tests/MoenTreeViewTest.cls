"Filed out from Dolphin Smalltalk"!

SelectableTreeItemsTest subclass: #MoenTreeViewTest
	instanceVariableNames: 'nodeA nodeB nodeC nodeD nodeE nodeF shell scroller useShell'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

MoenTreeViewTest guid: (GUID fromString: '{547f1350-3d63-4e8c-9ea3-e13001609555}')!

MoenTreeViewTest comment: 'SUnitBrowser openOnTestCase: self'!

!MoenTreeViewTest categoriesForClass!Unclassified! !

!MoenTreeViewTest methodsFor!

assertChildNode: node
	self deny: node parent identicalTo: presenter anchorNode.
	self assertNodeInTree: node.
	self denyIsNil: node parent parent!

assertCollapsedChild: node 
	self assert: node isExpanded not.
	self assertPopulatedChild: node.
!

assertCollapsedRoot: node 
	self assert: node isExpanded not.
	self assertPopulatedRoot: node.
!

assertCorrectlyPopulatedNode: node
	self assert: node hasExpanded.
	(self treeModel hasChildren: node object)
		ifTrue: 
			[| children childObjects child |
			children := OrderedCollection new.
			child := node child.
			[child isNil] whileFalse: 
					[children add: child.
					child := child sibling].
			children do: [:each | self assert: (presenter findNodeForObject: each object) identicalTo: each].
			childObjects := children collect: [:each | each object].
			self assert: ((self treeModel childrenOf: node object) noDifference: childObjects)]
		ifFalse: 
			[self assertIsNil: node child.
			self assert: (presenter hasChildren: node) not]!

assertExpandedRoot: node 
	self assert: node isExpanded.
	self assertPopulatedRoot: node.
!

assertInitialState
	self assert: presenter isAutoExpanding not.
	self assertUnexpandedRoot: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeE.
	self assertUnexpandedRoot: nodeF.

	self assert: (presenter hasChildren: nodeA) not.
	self assert: (presenter hasChildren: nodeB).
	self assert: (presenter hasChildren: nodeC).
	self assert: (presenter hasChildren: nodeD).
	self assert: (presenter hasChildren: nodeE).
	self assert: (presenter hasChildren: nodeF) not!

assertNodeInTree: node
	self assert: (presenter findNodeForObject: node object) identicalTo: node!

assertPopulatedChild: node 
	self assertChildNode: node.
	self assertCorrectlyPopulatedNode: node!

assertPopulatedRoot: node 
	self assertRootNode: node.
	self assertCorrectlyPopulatedNode: node!

assertRootNode: node
	"Private - N.B. This is using private knowledge of the MoenTreeView's implementation."

	self assert: node parent identicalTo: presenter anchorNode!

assertRootsInOrder
	presenter anchorNode children with: presenter model roots
		do: [:eachNode :eachObject | self assert: eachNode object equals: eachObject]!

assertUnexpandedChild: node
	self assertUnexpandedNode: node.
	self denyIsNil: node parent!

assertUnexpandedNode: node
	self assert: node isExpanded not.
	self assert: node hasExpanded not.
	self assertIsNil: node child.
	self assertNodeInTree: node!

assertUnexpandedRoot: node 
	self assertUnexpandedNode: node.
	self assertRootNode: node.!

assertUnlinkedNode: aMoenTreeNode
	self assertIsNil: aMoenTreeNode child.
	self assertIsNil: aMoenTreeNode parent.
	self assertIsNil: aMoenTreeNode sibling.
	self assertIsNil: (presenter findNodeForObject: aMoenTreeNode object)!

classToTest
	^MoenTreeView!

createModel
	^(TreeModel withRoots: #('A' 'B' 'C' 'D' 'E' 'F') searchPolicy: SearchPolicy equality)
		add: 'BA' asChildOf: 'B';
		add: 'CA' asChildOf: 'C';
		add: 'CB' asChildOf: 'C';
		add: 'CAA' asChildOf: 'CA';
		add: 'DA' asChildOf: 'D';
		add: 'DB' asChildOf: 'D';
		add: 'EA' asChildOf: 'E';
		add: 'EB' asChildOf: 'E';
		yourself

"
A
B - BA
C - CA - CAA
    - CB
D - DA
    - DB
E - EA
    - EB
F"!

createShell
	(useShell and: [shell isNil]) ifFalse: [^self].
	shell := ShellView new create.
	shell layoutManager: BorderLayout new.
	scroller := shell addSubView: ScrollingDecorator new.
	scroller arrangement: #center.
	shell rectangle: (100 @ 100 extent: 200 @ 300).
	shell show!

createTree
	self destroyTree.
	self createShell.
	self createView.
	presenter model: self createModel.
	nodeA := presenter findNodeForObject: 'A'.
	nodeB := presenter findNodeForObject: 'B'.
	nodeC := presenter findNodeForObject: 'C'.
	nodeD := presenter findNodeForObject: 'D'.
	nodeE := presenter findNodeForObject: 'E'.
	nodeF := presenter findNodeForObject: 'F'!

createView
	presenter := MoenTreeView new
				hasButtons: true;
				isAutoExpanding: false;
				yourself.
	useShell ifTrue: [scroller addSubView: presenter] ifFalse: [presenter show]!

destroyPresenter
	super destroyPresenter.
	shell := scroller := nil!

destroyTree
	presenter notNil and: 
			[useShell ifTrue: [scroller removeSubView: presenter].
			presenter isOpen ifTrue: [presenter destroy].
			presenter := nil]!

initializePresenter
	self
		createShell;
		createView!

mouseDownEventOn: anObject buttons: anArray
	| position |
	position := (presenter nodeForObject: anObject ifAbsent: [])
				ifNil: [presenter clientRectangle corner - 1]
				ifNotNil: [:node | node rectangle origin + 1].
	^self mouseDownEventAt: position buttons: anArray!

moveChild: childObject of: parentNode toRoot: rootNode
	"Private - parent will get expanded"

	| node rootExpanded childExpanded rootObject |
	self assertPopulatedRoot: parentNode.
	rootObject := rootNode object.
	rootExpanded := rootNode isExpanded.
	childExpanded := (presenter findNodeForObject: childObject) isExpanded.

	"NNC x RNC - child's parent not expanded."
	self treeModel move: childObject asChildOf: rootObject.
	node := presenter findNodeForObject: childObject.
	self assertPopulatedChild: node.
	self assert: node isExpanded identicalTo: childExpanded.
	self assert: rootNode isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: rootNode.
	self assertPopulatedRoot: parentNode.

	"Now move it back"
	self treeModel move: childObject asChildOf: parentNode object.
	node := presenter findNodeForObject: childObject.
	self assert: rootNode isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: rootNode.
	self assert: node isExpanded identicalTo: childExpanded.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: parentNode.
	^node!

moveChild: anObject of: parentNode toUnexpandedRoot: rootNode
	"Private - child's parent not expanded."

	| node |
	self treeModel move: anObject asChildOf: rootNode object.
	"CB is lost because F is unexpanded"
	self assertIsNil: (presenter findNodeForObject: anObject).
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: rootNode.

	"Now move it back"
	self treeModel move: anObject asChildOf: parentNode object.
	node := presenter findNodeForObject: anObject.
	self assertPopulatedRoot: parentNode.
	self assertUnexpandedRoot: rootNode.
	self assertUnexpandedChild: node.	"New node created so reverts to unexpanded state"
	^node!

moveChild: childExpanded toChildlessRoot: rootExpanded
	"NNC x RNC - child's parent not expanded."

	"Now move it back"

	"NCC x RNC - neither child nor child's parent expanded."

	self createTree.
	self assertInitialState.

	"F will be the expanded root with no children"
	presenter expand: 'F'.
	rootExpanded ifFalse: [presenter collapse: 'F'].
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.

	"CA and CB will be the collapsed children (one has a child, the other does not)"
	presenter
		expand: 'CA';
		expand: 'CB'.
	childExpanded
		ifFalse: 
			[presenter
				collapse: 'CA';
				collapse: 'CB'.
			self assertCollapsedChild: nodeC child.
			self assertCollapsedChild: nodeC child sibling].
	"parent will get expanded"
	self
		moveChild: 'CB'
		of: nodeC
		toRoot: nodeF.
	self
		moveChild: 'CA'
		of: nodeC
		toRoot: nodeF!

moveChild: childExpanded toRootWithChildren: rootExpanded
	| node |
	self createTree.
	self assertInitialState.

	"D will be the expanded root with no children"
	presenter expand: 'D'.
	rootExpanded ifFalse: [presenter collapse: 'D'].
	self assert: nodeD hasExpanded.
	self assert: nodeD child object equals: 'DA'.

	"CA and CB will be the collapsed children (one has a child, the other does not)"
	presenter
		expand: 'CA';
		expand: 'CB'.
	childExpanded
		ifFalse: 
			[presenter
				collapse: 'CA';
				collapse: 'CB'].
	"parent will get expanded"
	self assert: nodeC child hasExpanded.
	self assert: nodeC child sibling hasExpanded.

	"NN[C|E] x RC[C|E]"
	self treeModel move: 'CB' asChildOf: 'D'.
	node := presenter findNodeForObject: 'CB'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	node := presenter findNodeForObject: 'CB'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"NC[C|E] x RC[C|E]"
	self treeModel move: 'CA' asChildOf: 'D'.
	node := presenter findNodeForObject: 'CA'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	node := presenter findNodeForObject: 'CA'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC!

moveChildToUnexpandedRoot: isExpanded
	"CB is lost because F is unexpanded"

	"Now move it back"

	"New node created so reverts to unexpanded state"

	"NCC x RNU - neither child nor child's parent expanded."

	self createTree.
	self assertInitialState.

	"F will be the collapsed root with no children"
	self assert: nodeF isExpanded not.
	self assert: nodeF hasExpanded not.
	self assertIsNil: nodeF child.

	"CA and CB will be the collapsed children (one has a child, the other does not)"
	presenter
		expand: 'CA';
		expand: 'CB'.
	isExpanded
		ifFalse: 
			[presenter
				collapse: 'CA';
				collapse: 'CB'].
	"parent will get expanded"
	self assertPopulatedRoot: nodeC.
	"child's parent not expanded."
	self
		moveChild: 'CB'
		of: nodeC
		toUnexpandedRoot: nodeF.
	self
		moveChild: 'CA'
		of: nodeC
		toUnexpandedRoot: nodeF.

	"Creation of new nodes will have lost expansion of CA and CB"
	presenter
		expand: 'CA';
		expand: 'CB'.
	isExpanded
		ifFalse: 
			[presenter
				collapse: 'CA';
				collapse: 'CB'].


	"NNC x RCU - child's parent not expanded."
	self
		moveChild: 'CB'
		of: nodeC
		toUnexpandedRoot: nodeD.

	"NCC x RCU - neither child nor child's parent expanded."
	self
		moveChild: 'CA'
		of: nodeC
		toUnexpandedRoot: nodeD!

moveRoots: moveeExpanded toRoots: toExpanded
	"A & F will be the previously expanded root with no children"

	self createTree.
	self assertInitialState.
	presenter expand: 'F'.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.
	presenter expand: 'A'.
	self assert: nodeA isExpanded.
	self assert: nodeA hasExpanded.
	self assertIsNil: nodeA child.
	"B & D will be the expanded root with children"
	presenter
		expand: 'D';
		expand: 'B'.
	self assert: nodeD hasExpanded.
	self denyIsNil: nodeD child.
	moveeExpanded
		ifFalse: 
			[presenter
				collapse: 'B';
				collapse: 'A'].
	self assert: nodeB hasExpanded.
	self assert: nodeB isExpanded identicalTo: moveeExpanded.
	self denyIsNil: nodeB child.
	toExpanded
		ifFalse: 
			[presenter
				collapse: 'D';
				collapse: 'F'].

	"RNC x RNC"
	self treeModel move: 'A' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedChild: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedRoot: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"RNC x RCC"
	self treeModel move: 'A' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedRoot: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"RCC x RNC"
	self treeModel move: 'B' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedChild: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"Now move it back"
	self treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedRoot: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"RCC x RCC"
	self treeModel move: 'B' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"Now move it back"
	self treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedRoot: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded!

moveRootsToUnexpandedRoots: isExpanded
	self createTree.
	self assertInitialState.

	"F will be the expanded root with no children"
	presenter expand: 'F'.
	self assert: nodeF isExpanded.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.
	"B & D will be the expanded root with children"
	presenter expand: 'D'.
	self assert: nodeD hasExpanded.
	self assert: nodeD isExpanded.
	self denyIsNil: nodeD child.
	isExpanded
		ifFalse: 
			[presenter
				collapse: 'F';
				collapse: 'D'].

	"RNC x RNU"
	self treeModel move: 'F' asChildOf: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertIsNil: (presenter findNodeForObject: 'F').

	"Now move it back (new node created)"
	self treeModel move: 'F' asChildOf: nil.
	self deny: (presenter findNodeForObject: 'F') identicalTo: nodeF.
	nodeF := presenter findNodeForObject: 'F'.
	self assertUnexpandedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"Since nodeF was recreated, we must expand and collapse it to get back to where we were"
	presenter expandNode: nodeF.
	isExpanded ifFalse: [presenter collapseNode: nodeF cause: #unknown].

	"RNC x RCU"
	self treeModel move: 'F' asChildOf: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertUnlinkedNode: nodeF.
	self assertIsNil: (presenter findNodeForObject: 'F').

	"Now move it back (new node created)"
	self treeModel move: 'F' asChildOf: nil.
	self deny: (presenter findNodeForObject: 'F') identicalTo: nodeF.
	nodeF := presenter findNodeForObject: 'F'.
	self assertUnexpandedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"RCC x RNU"
	self treeModel move: 'D' asChildOf: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertIsNil: (presenter findNodeForObject: 'D').

	"Now move it back (new node created)"
	self treeModel move: 'D' asChildOf: nil.
	self deny: (presenter findNodeForObject: 'D') identicalTo: nodeD.
	nodeD := presenter findNodeForObject: 'D'.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeA.

	"Expand/collapse D again"
	presenter expandNode: nodeD.
	isExpanded ifTrue: [presenter collapseNode: nodeD cause: #unknown].

	"RCC x RCU"
	self treeModel move: 'D' asChildOf: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertIsNil: (presenter findNodeForObject: 'D').

	"Now move it back (new node created)"
	self treeModel move: 'D' asChildOf: nil.
	self deny: (presenter findNodeForObject: 'D') identicalTo: nodeD.
	nodeD := presenter findNodeForObject: 'D'.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeB!

moveUnexpandedChild: parentExpanded toUnexpandedRoot: targetNode
	"Private - NNU x RCU - child's parent expanded (therefore CB should be in tree)."

	| node object |
	object := targetNode object.
	presenter expandNode: nodeC.
	parentExpanded ifFalse: [presenter collapseNode: nodeC cause: #unknown].
	node := presenter findNodeForObject: 'CB'.
	self treeModel move: 'CB' asChildOf: object.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: 'CB').

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	self deny: (presenter findNodeForObject: 'CB') identicalTo: node.
	node := presenter findNodeForObject: 'CB'.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedChild: node.

	"NCU x RCU - child's parent expanded but not child expanded."
	node := presenter findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	self treeModel move: 'CA' asChildOf: object.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: 'CA').

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	self deny: (presenter findNodeForObject: 'CA') identicalTo: node.
	node := presenter findNodeForObject: 'CA'.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedChild: node!

moveUnexpandedChildOfUnexpandedParentToRoot: targetNode
	| object |
	object := targetNode object.
	self assertUnexpandedRoot: targetNode.

	"NNU x RCU - child's parent not expanded."
	self treeModel move: 'CB' asChildOf: object.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: 'CB').

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: 'CB').

	"NCU x RCU - neither child nor child's parent expanded."
	self treeModel move: 'CA' asChildOf: object.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: 'CA').

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	self assertIsNil: (presenter findNodeForObject: 'CA').
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode!

moveUnexpandedChildToRoot: isExpanded target: anObject
	| node targetNode |
	self createTree.
	self assertInitialState.
	targetNode := presenter findNodeForObject: anObject.

	"D will be the collapsed root with children"
	presenter expandNode: targetNode.
	isExpanded ifFalse: [presenter collapseNode: targetNode cause: #unknown].
	self assertPopulatedRoot: targetNode.

	"NNU x RCC - child's parent not expanded."
	self treeModel move: 'CB' asChildOf: anObject.
	node := presenter findNodeForObject: 'CB'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assertUnexpandedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	self assertIsNil: (presenter findNodeForObject: 'CB').
	self assertIsNil: node parent.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedRoot: nodeC.

	"NCU x RNC - neither child nor child's parent expanded."
	self treeModel move: 'CA' asChildOf: anObject.
	node := presenter findNodeForObject: 'CA'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assertUnexpandedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	self assertIsNil: (presenter findNodeForObject: 'CA').
	self assertIsNil: node parent.
	self assertIsNil: node parent.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedRoot: nodeC.
	presenter expandNode: nodeC.

	"NNU x RNC - child's parent expanded (therefore CB should be in tree)."
	node := presenter findNodeForObject: 'CB'.
	self treeModel move: 'CB' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"NCU x RCC - child's parent expanded but not child expanded."
	self assert: nodeC isExpanded.
	node := presenter findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	self treeModel move: 'CA' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node).
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node).
	self assertPopulatedRoot: nodeC.
	presenter collapseNode: nodeC cause: #unknown.

	"NCU x RCC - child's parent collapsed (therefore CB should be in tree)."
	node := presenter findNodeForObject: 'CB'.
	self treeModel move: 'CB' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CB' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"NCU x RCC - child's parent collapsed but not child expanded."
	node := presenter findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	self treeModel move: 'CA' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node).
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	self treeModel move: 'CA' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (presenter hasChildren: node).
	self assertPopulatedRoot: nodeC!

moveUnexpandedChildToUnexpandedChild
	"Private - RNU x NNU"

	self treeModel move: 'EA' asChildOf: 'CB'.
	self assert: (presenter roots includes: nodeA) not.
	self assert: (presenter roots includes: nodeF).
	self assert: nodeA isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeA) not.
	"Because CB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self should: [presenter findNodeForObject: 'EA'] raise: NotFoundError.
	self assertIsNil: nodeF child.

	"Now move it back"
	self treeModel move: 'EA' asChildOf: 'E'.
	nodeE hasExpanded
		ifTrue: 
			[| node |
			node := presenter findNodeForObject: 'EA'.
			self assert: (presenter roots includes: node) not.
			self assertUnexpandedChild: node.
			self assertIsNil: node parent parent.
			self assert: node parent child equals: node.
			self assert: node parent object equals: 'E'.
			self assertIsNil: node sibling.
			self assertIsNil: node child]
		ifFalse: [self should: [presenter findNodeForObject: 'EA'] raise: NotFoundError].


	"RCU x NNU"
	self treeModel move: 'B' asChildOf: 'CB'.
	self assert: (presenter roots includes: nodeB) not.
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self should: [presenter findNodeForObject: 'B'] raise: NotFoundError.
	self should: [presenter findNodeForObject: 'BA'] raise: NotFoundError.
	self assertIsNil: nodeF child.

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	nodeB := presenter findNodeForObject: 'B'.
	self assert: (presenter roots includes: nodeB).
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	self assertIsNil: nodeB parent.
	self assertIsNil: nodeB child.
	self assertIsNil: nodeF child.

	"RNU x NCU"
	self treeModel move: 'A' asChildOf: 'B'.
	self assert: (presenter roots includes: nodeA) not.
	self assert: (presenter roots includes: nodeB).
	self assert: nodeA isExpanded not.
	self assert: nodeB isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (presenter hasChildren: nodeA) not.
	self assert: (presenter hasChildren: nodeB).
	"Because nodeB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self should: [presenter findNodeForObject: 'A'] raise: NotFoundError.
	self assertIsNil: nodeB child.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	nodeA := presenter findNodeForObject: 'A'.
	self assert: (presenter roots includes: nodeA).
	self assert: (presenter roots includes: nodeB).
	self assert: nodeA isExpanded not.
	self assert: nodeB isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (presenter hasChildren: nodeA) not.
	self assert: (presenter hasChildren: nodeB).
	self assertIsNil: nodeA parent.
	self assertIsNil: nodeB child.

	"RCU x NCU"
	self treeModel move: 'B' asChildOf: 'CA'.
	self assert: (presenter roots includes: nodeB) not.
	self assert: (presenter roots includes: nodeD).
	self assert: nodeB isExpanded not.
	self assert: nodeD isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeD hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	self assert: (presenter hasChildren: nodeD).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self should: [presenter findNodeForObject: 'B'] raise: NotFoundError.
	self should: [presenter findNodeForObject: 'BA'] raise: NotFoundError.
	self assertIsNil: nodeD child.

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	nodeB := presenter findNodeForObject: 'B'.
	self assert: (presenter roots includes: nodeB).
	self assert: (presenter roots includes: nodeD).
	self assert: nodeB isExpanded not.
	self assert: nodeD isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeD hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	self assert: (presenter hasChildren: nodeD).
	self assertIsNil: nodeB parent.
	self assertIsNil: nodeB child.
	self assertIsNil: nodeD child!

moveUnexpandedRoot: node toUnexpandedRoot: targetNode
	"Private - Move an unexpanded root to be a child of another unexpanded root"

	| source dest new |
	self assertUnexpandedRoot: node.
	self assertUnexpandedRoot: targetNode.
	source := node object.
	dest := node object.
	self treeModel move: source asChildOf: dest.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (presenter findNodeForObject: source).

	"Now 'move' it back (actually add it again)"
	self treeModel move: source asChildOf: nil.
	new := presenter findNodeForObject: source.
	self deny: new identicalTo: node.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedRoot: new.
	^new!

moveUnexpandedRootsToRoots: isExpanded
	"Private - Tests: RNU x RNC, RNU x RCC, RCU x RNC, RCU x RCC"

	self createTree.
	self assertInitialState.

	"F will be the collapsed root with no children"
	presenter expand: 'F'.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.

	"B & D will be the collapsed root with children"
	presenter expand: 'D'.
	self assert: nodeD hasExpanded.
	self denyIsNil: nodeD child.
	isExpanded
		ifFalse: 
			[presenter
				collapse: 'F';
				collapse: 'D'].
	self assertPopulatedRoot: nodeF.
	self assert: nodeF isExpanded identicalTo: isExpanded.

	"RNU x RNC"
	self treeModel move: 'A' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedChild: nodeA.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"RNU x RCC"
	self treeModel move: 'A' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedChild: nodeA.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedRoot: nodeA.

	"RCU x RNC: Move an unexpanded root with children to be a child of an previously expanded root with no children,
	but which is currently collapsed."
	self treeModel move: 'B' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedChild: nodeB.

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedRoot: nodeB.

	"RCU x RCC"
	self treeModel move: 'B' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedChild: nodeB.

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedRoot: nodeB!

moveUnexpandedRootsToUnexpandedChildren
	"Private - RNU x NNU"

	self treeModel move: 'A' asChildOf: 'CB'.
	self assertUnlinkedNode: nodeA.
	self assertRootsInOrder.
	self assertUnexpandedRoot: nodeF.
	self assert: nodeA isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeA) not.
	"Because CB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self assertIsNil: (presenter findNodeForObject: 'A').
	self assertIsNil: nodeF child.

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	nodeA := presenter findNodeForObject: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assert: nodeF isExpanded not.
	self assert: nodeF hasExpanded not.
	self assertIsNil: nodeF child.

	"RCU x NNU"
	self treeModel move: 'B' asChildOf: 'CB'.
	self assertUnlinkedNode: nodeB.
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self assertIsNil: (presenter findNodeForObject: 'B').
	self assertIsNil: (presenter findNodeForObject: 'BA').
	self assertIsNil: nodeF child.

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	nodeB := presenter findNodeForObject: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assert: nodeF isExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	self assertIsNil: nodeF child.

	"RNU x NCU"
	self treeModel move: 'A' asChildOf: 'B'.
	"Because nodeB is unexpanded, nodeA will no longer be linked into the tree."
	self assertUnlinkedNode: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assert: nodeA isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: (presenter hasChildren: nodeA) not.
	self assert: (presenter hasChildren: nodeB).

	"Now move it back"
	self treeModel move: 'A' asChildOf: nil.
	nodeA := presenter findNodeForObject: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assert: (presenter hasChildren: nodeA) not.
	self assert: (presenter hasChildren: nodeB).

	"RCU x NCU"
	self treeModel move: 'B' asChildOf: 'CA'.
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertUnlinkedNode: nodeB.
	self assertUnexpandedRoot: nodeD.
	self assert: nodeB isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (presenter hasChildren: nodeB).
	self assert: (presenter hasChildren: nodeD).
	self assertIsNil: (presenter findNodeForObject: 'BA').

	"Now move B back"
	self treeModel move: 'B' asChildOf: nil.
	nodeB := presenter findNodeForObject: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertUnexpandedRoot: nodeD.
	self assert: (presenter hasChildren: nodeB).
	self assert: (presenter hasChildren: nodeD)!

runCase
	useShell := true.
	super runCase.
	useShell := false.
	super runCase!

testMoveChildToChildlessRoot
	"Tests: NNC x RNC, NCC x RNC,
		NNC x RNE, NCC x RNE
		NNE x RNC, NCE x RNC,
		NNE x RNE, NCE x RNE"

	#nocreate.
	self moveChild: false toChildlessRoot: false.
	self moveChild: false toChildlessRoot: true.
	self moveChild: true toChildlessRoot: false.
	self moveChild: true toChildlessRoot: true!

testMoveChildToRootWithChildren
	#nocreate.
	"NNC x RCC, NCC x RCC"
	self moveChild: false toRootWithChildren: false.
	"NNC x RCE, NCC x RCE"
	self moveChild: false toRootWithChildren: true.
	"NNE x RCC, NCE x RCC"
	self moveChild: true toRootWithChildren: false.
	"NNE x RCE, NCE x RCE"
	self moveChild: true toRootWithChildren: true!

testMoveChildToUnexpandedRoot
	"Tests: NNC x RNU, NCC x RNU,
		NNC x RCU, NCC x RCU,
		NNE x RNU, NCE x RNU,
		NNE x RCU, NCE x RCU"
	#nocreate.
	self moveChildToUnexpandedRoot: true.
	self moveChildToUnexpandedRoot: false!

testMoveRootsToRoots
	"Tests: RNC x RNC, RNC x RCC, RCC x RNC, RCC x RCC,
		RNC x RNE, RNC x RCE, RCC x RNE, RCC x RCE,
		RNE x RNC, RCE x RNC, RNE x RCC, RCE x RCC,
		RNE x RNE, RCE x RNE, RNE x RCE, RCE x RCE"
	#nocreate.
	self moveRoots: false toRoots: false.
	self moveRoots: false toRoots: true.
	self moveRoots: true toRoots: false.
	self moveRoots: true toRoots: true!

testMoveRootsToUnexpandedRoots
	"Tests: RNC x RNU, RNC x RCU, RCC x RNU, RCC x RCU"
	#nocreate.
	self moveRootsToUnexpandedRoots: true.
	self moveRootsToUnexpandedRoots: false!

testMoveSelectionDown
	| treeModel |
	treeModel := TreeModel withRoots: #('A') searchPolicy: SearchPolicy equality.
	presenter model: treeModel.
	presenter selection: 'A'.
	self assert: presenter selection equals: 'A'.
	"Test with a singe selected root"
	presenter moveSelectionDown.
	"Selection should not move since there is no down sibling."
	self assert: presenter selection equals: 'A'.
	"Test move down to next root."
	treeModel addRoot: 'B'.
	presenter moveSelectionDown.
	self assert: presenter selection equals: 'B'.
	"Test attempted move off last root"
	presenter moveSelectionDown.
	"Selection should not move since there is no down sibling."
	self assert: presenter selection equals: 'B'.
	"Test with a single selected child of a last  root"
	treeModel add: 'AA' asChildOf: 'A'.
	presenter selection: 'AA'.
	self assert: presenter selection equals: 'AA'.
	presenter moveSelectionDown.
	"Selection should move to B."
	self assert: presenter selection equals: 'B'.
	"Now test move to immediate sibling"
	treeModel add: 'AB' asChildOf: 'A'.
	presenter selection: 'AA'.
	presenter moveSelectionDown.
	self assert: presenter selection equals: 'AB'.

	"Test move to immediate parent's sibling where parent is a root."
	treeModel add: 'BA' asChildOf: 'B'.
	presenter selection: 'BA'.
	self assert: presenter selection equals: 'BA'.
	presenter moveSelectionDown.
	"Selection should not move."
	self assert: presenter selection equals: 'BA'.

	"Test move to sibling of non-immediate root parent."
	treeModel add: 'ABA' asChildOf: 'AB'.
	presenter selection: 'ABA'.
	presenter moveSelectionDown.
	"Selection should move to next root."
	self assert: presenter selection equals: 'B'.

	"Test move to sibling of immediate parent which is not a root"
	treeModel add: 'BAA' asChildOf: 'BA'.
	treeModel add: 'BB' asChildOf: 'B'.
	presenter selection: 'BAA'.
	presenter moveSelectionDown.
	"Selection should move to non-immediate parent."
	self assert: presenter selection equals: 'BB'.

	"Test move to sibling of non-immediate parent which is not a root"
	treeModel add: 'ABAA' asChildOf: 'ABA'.
	treeModel add: 'AC' asChildOf: 'A'.
	presenter selection: 'ABAA'.
	presenter moveSelectionDown.
	"Selection should move to non-immediate parent."
	self assert: presenter selection equals: 'AC'!

testMoveUnexpandedChildToRoot
	"Tests: NNU x RCC, NCU x RCC, NNU x RCE, NCU x RCE,
		NNU x RNE, NCU x RNE, NNU x RNC, NCU x RNC"
	#nocreate.
	self moveUnexpandedChildToRoot: true target: 'F'.
	self moveUnexpandedChildToRoot: false target: 'F'.
	self moveUnexpandedChildToRoot: true target: 'D'.
	self moveUnexpandedChildToRoot: false target: 'D'!

testMoveUnexpandedChildToUnexpandedRoot
	"Tests: NNU x RNU, NCU x RNU"

	#nocreate.
	self createTree.
	self assertInitialState.
	self moveUnexpandedChildOfUnexpandedParentToRoot: nodeF.
	self moveUnexpandedChildOfUnexpandedParentToRoot: nodeD.
	self moveUnexpandedChild: true toUnexpandedRoot: nodeF.
	self moveUnexpandedChild: false toUnexpandedRoot: nodeF.
	self moveUnexpandedChild: true toUnexpandedRoot: nodeD.
	self moveUnexpandedChild: false toUnexpandedRoot: nodeD!

testMoveUnexpandedRootsToRoots
	"Tests: RNU x RNC, RNU x RCC, RCU x RNC, RCU x RCC,
		RNU x RNE, RNU x RCE, RCU x RNE, RCU x RCE"

	#nocreate.
	self moveUnexpandedRootsToRoots: true.
	self moveUnexpandedRootsToRoots: false!

testMoveUnexpandedRootsToUnexpandedChildren
	"Tests: RNU x NNU, RNU x NCU, RCU x NNU, RCU x NCU"

	#nocreate.
	self createTree.
	self assertInitialState.
	self assert: presenter anchorNode child identicalTo: nodeA.
	self moveUnexpandedRootsToUnexpandedChildren.

	"Now repeat with the 'CA' and 'CB' nodes actually in the tree"
	presenter expand: 'C'.
	self moveUnexpandedRootsToUnexpandedChildren.

	"And again but with 'C' collapsed"
	presenter collapse: 'C'.
	self moveUnexpandedRootsToUnexpandedChildren.
!

testMoveUnexpandedRootsToUnexpandedRoots
	"Tests: RNU x RNU, RNU x RCU, RCU x RNU, RCU x RCU"

	#nocreate.
	self createTree.
	"Now 'move' it back (actually add it again)"

	"RCU x RNU: Move an unexpanded root with children to be a child of another root with no children"
	self assertInitialState.

	"RNU x RNU: Move an unexpanded root with no children to be a child of another root with no children"
	nodeA := self moveUnexpandedRoot: nodeA toUnexpandedRoot: nodeF.

	"RCU x RNU"
	nodeB := self moveUnexpandedRoot: nodeB toUnexpandedRoot: nodeF.

	"RNU x RCU: Move an unexpanded root with no children to be a child of another root with children"
	nodeA := self moveUnexpandedRoot: nodeA toUnexpandedRoot: nodeB.

	"RCU x RCU: Move an unexpanded root with children to be a child of another root with children"
	nodeB := self moveUnexpandedRoot: nodeB toUnexpandedRoot: nodeD!

testRemoveSelection
	| treeModel |
	treeModel := TreeModel withRoots: #('A' 'B' 'C') searchPolicy: SearchPolicy equality.
	presenter model: treeModel.
	presenter selection: 'B'.
	"Remove selected middle root"
	self
		should: [treeModel remove: 'B']
		trigger: #selectionChanged
		against: presenter presenter.
	"Selection moves down to next sibling"
	self assert: presenter selection equals: 'C'.
	"Remove selected last root"
	self
		should: [treeModel remove: 'C']
		trigger: #selectionChanged
		against: presenter presenter.
	"Selection moves up to previous sibling"
	self assert: presenter selection equals: 'A'.
	"Remove first (and last) root"
	self
		should: [treeModel remove: 'A']
		trigger: #selectionChanged
		against: presenter presenter.
	"Selection lost (no other items to select)"
	self assertIsNil: presenter selectionOrNil.
	self
		should: [presenter selection]
		raise: Error
		matching: [:ex | ex messageText = 'No object selected'].
	treeModel := TreeModel withRoots: #('ROOT1' 'ROOT2' 'ROOT3') searchPolicy: SearchPolicy equality.
	#('A' 'B' 'C') do: [:each | treeModel add: each asChildOf: 'ROOT2'].
	presenter model: treeModel.
	presenter selection: 'B'.
	"Remove selected middle child"
	treeModel remove: 'B'.
	"Selection moves down to next sibling"
	self assert: presenter selection equals: 'C'.
	"Remove selected last child"
	treeModel remove: 'C'.
	"Selection moves to prev sibling"
	self assert: presenter selection equals: 'A'.
	"Remove first child"
	treeModel remove: 'A'.
	"Selection moves to parent"
	self assert: presenter selection equals: 'ROOT2'!

verifyUpgradedView: anInteger identifier: aResourceIdentifier
	| view |
	super verifyUpgradedView: anInteger identifier: aResourceIdentifier.
	view := self view.
	self assert: view backcolor identicalTo: Color default.
	self assert: view isAutoExpanding.
	self assert: view anchorNode isExpanded.
	self assert: view anchorNode hasExpanded.
	self assert: view hasWordWrap.
	self assert: (view instVarNamed: 'iconExtent') equals: Icon smallExtent .
	self assert: (view instVarNamed: 'textInset') equals: Icon smallExtent x + (view dpi // USER_DEFAULT_SCREEN_DPI) @ 0.
	self assert: view margin isKindOf: Point.
	self assert: view maxTextExtent equals: 9999 @ 9999.
	self assert: view linePen isKindOf: Pen! !

!MoenTreeViewTest categoriesForMethods!
assertChildNode:!helpers!private! !
assertCollapsedChild:!helpers!private! !
assertCollapsedRoot:!helpers!private! !
assertCorrectlyPopulatedNode:!helpers!private! !
assertExpandedRoot:!helpers!private! !
assertInitialState!helpers!private! !
assertNodeInTree:!helpers!private! !
assertPopulatedChild:!helpers!private! !
assertPopulatedRoot:!helpers!private! !
assertRootNode:!helpers!private! !
assertRootsInOrder!helpers!private! !
assertUnexpandedChild:!helpers!private! !
assertUnexpandedNode:!helpers!private! !
assertUnexpandedRoot:!helpers!private! !
assertUnlinkedNode:!helpers!private! !
classToTest!helpers!private! !
createModel!helpers!private! !
createShell!helpers!private! !
createTree!helpers!private! !
createView!helpers!private! !
destroyPresenter!public!Running! !
destroyTree!private!Running! !
initializePresenter!helpers!public! !
mouseDownEventOn:buttons:!helpers!private! !
moveChild:of:toRoot:!helpers!private! !
moveChild:of:toUnexpandedRoot:!helpers!private! !
moveChild:toChildlessRoot:!helpers!private! !
moveChild:toRootWithChildren:!helpers!private! !
moveChildToUnexpandedRoot:!helpers!private! !
moveRoots:toRoots:!helpers!private! !
moveRootsToUnexpandedRoots:!helpers!private! !
moveUnexpandedChild:toUnexpandedRoot:!helpers!private! !
moveUnexpandedChildOfUnexpandedParentToRoot:!helpers!private! !
moveUnexpandedChildToRoot:target:!helpers!private! !
moveUnexpandedChildToUnexpandedChild!helpers!private! !
moveUnexpandedRoot:toUnexpandedRoot:!helpers!private! !
moveUnexpandedRootsToRoots:!helpers!private! !
moveUnexpandedRootsToUnexpandedChildren!helpers!private! !
runCase!public!Running! !
testMoveChildToChildlessRoot!public!unit tests! !
testMoveChildToRootWithChildren!public!unit tests! !
testMoveChildToUnexpandedRoot!public!unit tests! !
testMoveRootsToRoots!public!unit tests! !
testMoveRootsToUnexpandedRoots!public!unit tests! !
testMoveSelectionDown!public!unit tests! !
testMoveUnexpandedChildToRoot!public!unit tests! !
testMoveUnexpandedChildToUnexpandedRoot!public!unit tests! !
testMoveUnexpandedRootsToRoots!public!unit tests! !
testMoveUnexpandedRootsToUnexpandedChildren!public!unit tests! !
testMoveUnexpandedRootsToUnexpandedRoots!public!unit tests! !
testRemoveSelection!public!unit tests! !
verifyUpgradedView:identifier:!helpers!private! !
!

!MoenTreeViewTest class methodsFor!

resource_Moen_tree_D6
	"Answer the literal data from which the 'Moen tree' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_tree)
	"

	^#(#'!!STL' 3 788558 10 ##(Smalltalk.STBViewProxy) 8 ##(Smalltalk.MoenTreeView) 98 30 0 0 98 2 8 1409286144 1 416 590918 3 ##(Smalltalk.TreeModel) 0 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) 0 0 0 234 256 98 0 524550 ##(Smalltalk.ColorRef) 8 4278190080 0 517 0 0 0 416 788998 ##(Smalltalk.MoenTreeNode) 0 721926 ##(Smalltalk.MoenContour) 0 0 0 0 328198 ##(Smalltalk.Point) 1 1 752 0 0 0 0 0 7 459270 ##(Smalltalk.Message) 8 #displayString 98 0 432 268435457 738 5 3 1049670 1 ##(Smalltalk.IconImageManager) 738 1 1 41 0 197382 ##(Smalltalk.Pen) 0 16 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 738 33 33 738 19999 19999 114721 880 738 35 1 0 0 0 983302 ##(Smalltalk.MessageSequence) 202 208 98 1 721670 ##(Smalltalk.MessageSend) 8 #createAt:extent: 98 2 738 2799 21 738 271 251 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 119 5 0 0 10 0 0 0 254 5 0 0 135 0 0 0] 98 0 738 193 193 0 27)!

resource_Moen_tree_D7
	"Answer the literal data from which the 'Moen tree' resource can be reconstituted.
	DO NOT EDIT OR RECATEGORIZE THIS METHOD.

	If you wish to modify this resource evaluate:
	ViewComposer openOn: (ResourceIdentifier class: self selector: #resource_Moen_tree)
	"

	^#(#'!!STL' 4 788558 10 ##(Smalltalk.STBViewProxy) ##(Smalltalk.MoenTreeView) 34 30 nil nil 34 2 8 1409286144 1 416 590918 3 ##(Smalltalk.TreeModel) nil 1310726 ##(Smalltalk.IdentitySearchPolicy) 525062 ##(Smalltalk.TreeNode) nil nil nil 170 192 8 #() 327686 ##(Smalltalk.Color) #default nil 517 nil nil nil 416 788998 ##(Smalltalk.MoenTreeNode) nil 721926 ##(Smalltalk.MoenContour) nil nil nil nil 328198 ##(Smalltalk.Point) 1 1 720 nil nil nil nil nil 7 459270 ##(Smalltalk.Message) #displayString 8 #() ##(Smalltalk.MoenTreeView) 268435457 706 5 3 1049926 1 ##(Smalltalk.IconImageManager) 706 1 1 41 nil 197382 ##(Smalltalk.Pen) nil true 393478 ##(Smalltalk.LOGPEN) 8 #[0 0 0 0 1 0 0 0 0 0 0 0 192 192 192 0] 706 33 33 706 19999 19999 114721 832 706 35 1 nil nil nil 983302 ##(Smalltalk.MessageSequence) 138 144 34 1 721670 ##(Smalltalk.MessageSend) #createAt:extent: 34 2 706 3839 21 706 271 251 416 983302 ##(Smalltalk.WINDOWPLACEMENT) 8 #[44 0 0 0 0 0 0 0 1 0 0 0 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 255 127 7 0 0 10 0 0 0 6 8 0 0 135 0 0 0] 8 #() 706 193 193 nil 27 )! !

!MoenTreeViewTest class categoriesForMethods!
resource_Moen_tree_D6!public!resources-views! !
resource_Moen_tree_D7!public!resources-views! !
!

