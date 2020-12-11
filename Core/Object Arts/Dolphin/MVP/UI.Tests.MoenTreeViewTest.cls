"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'UI.Tests.MoenTreeViewTest'
	instanceVariableNames: 'treeModel treeView nodeA nodeB nodeC nodeD nodeE nodeF shell scroller useShell'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.Tests.MoenTreeViewTest guid: (Core.GUID fromString: '{547f1350-3d63-4e8c-9ea3-e13001609555}')!
UI.Tests.MoenTreeViewTest comment: 'SUnitBrowser openOnTestCase: self'!
!UI.Tests.MoenTreeViewTest categoriesForClass!Unclassified! !
!UI.Tests.MoenTreeViewTest methodsFor!

assertChildNode: node
	self deny: node parent identicalTo: treeView anchorNode.
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
	(treeModel hasChildren: node object)
		ifTrue: 
			[| children childObjects child |
			children := OrderedCollection new.
			child := node child.
			[child isNil] whileFalse: 
					[children add: child.
					child := child sibling].
			children do: [:each | self assert: (treeView findNodeForObject: each object) identicalTo: each].
			childObjects := children collect: [:each | each object].
			self assert: ((treeModel childrenOf: node object) noDifference: childObjects)]
		ifFalse: 
			[self assertIsNil: node child.
			self assert: (treeView hasChildren: node) not]!

assertExpandedRoot: node 
	self assert: node isExpanded.
	self assertPopulatedRoot: node.
!

assertInitialState
	self assert: treeView isAutoExpanding not.
	self assertUnexpandedRoot: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeE.
	self assertUnexpandedRoot: nodeF.

	self assert: (treeView hasChildren: nodeA) not.
	self assert: (treeView hasChildren: nodeB).
	self assert: (treeView hasChildren: nodeC).
	self assert: (treeView hasChildren: nodeD).
	self assert: (treeView hasChildren: nodeE).
	self assert: (treeView hasChildren: nodeF) not!

assertNodeInTree: node
	self assert: (treeView findNodeForObject: node object) identicalTo: node!

assertPopulatedChild: node 
	self assertChildNode: node.
	self assertCorrectlyPopulatedNode: node!

assertPopulatedRoot: node 
	self assertRootNode: node.
	self assertCorrectlyPopulatedNode: node!

assertRootNode: node
	"Private - N.B. This is using private knowledge of the MoenTreeView's implementation."

	self assert: node parent identicalTo: treeView anchorNode!

assertRootsInOrder
	treeView anchorNode children with: treeView model roots
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
	self assertIsNil: (treeView findNodeForObject: aMoenTreeNode object)!

createModel
	treeModel := TreeModel withRoots: #('A' 'B' 'C' 'D' 'E' 'F') searchPolicy: SearchPolicy equality.
	treeModel
		add: 'BA' asChildOf: 'B';
		add: 'CA' asChildOf: 'C';
		add: 'CB' asChildOf: 'C';
		add: 'CAA' asChildOf: 'CA';
		add: 'DA' asChildOf: 'D';
		add: 'DB' asChildOf: 'D';
		add: 'EA' asChildOf: 'E';
		add: 'EB' asChildOf: 'E'

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

createTree
	self destroyTree.
	self createModel.
	self createView.
	nodeA := treeView findNodeForObject: 'A'.
	nodeB := treeView findNodeForObject: 'B'.
	nodeC := treeView findNodeForObject: 'C'.
	nodeD := treeView findNodeForObject: 'D'.
	nodeE := treeView findNodeForObject: 'E'.
	nodeF := treeView findNodeForObject: 'F'!

createView
	treeView := MoenTreeView new.
	treeView hasButtons: true.
	treeView isAutoExpanding: false.
	treeView model: treeModel.
	useShell ifTrue: [scroller addSubView: treeView] ifFalse: [treeView show]!

destroyTree
	treeView notNil and: 
			[useShell ifTrue: [scroller removeSubView: treeView].
			treeView isOpen ifTrue: [treeView destroy].
			treeView := nil]!

moveChild: childObject of: parentNode toRoot: rootNode
	"Private - parent will get expanded"

	| node rootExpanded childExpanded rootObject |
	self assertPopulatedRoot: parentNode.
	rootObject := rootNode object.
	rootExpanded := rootNode isExpanded.
	childExpanded := (treeView findNodeForObject: childObject) isExpanded.

	"NNC x RNC - child's parent not expanded."
	treeModel move: childObject asChildOf: rootObject.
	node := treeView findNodeForObject: childObject.
	self assertPopulatedChild: node.
	self assert: node isExpanded identicalTo: childExpanded.
	self assert: rootNode isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: rootNode.
	self assertPopulatedRoot: parentNode.

	"Now move it back"
	treeModel move: childObject asChildOf: parentNode object.
	node := treeView findNodeForObject: childObject.
	self assert: rootNode isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: rootNode.
	self assert: node isExpanded identicalTo: childExpanded.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: parentNode.
	^node!

moveChild: anObject of: parentNode toUnexpandedRoot: rootNode
	"Private - child's parent not expanded."

	| node |
	treeModel move: anObject asChildOf: rootNode object.
	"CB is lost because F is unexpanded"
	self assertIsNil: (treeView findNodeForObject: anObject).
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: rootNode.

	"Now move it back"
	treeModel move: anObject asChildOf: parentNode object.
	node := treeView findNodeForObject: anObject.
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
	treeView expand: 'F'.
	rootExpanded ifFalse: [treeView collapse: 'F'].
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.

	"CA and CB will be the collapsed children (one has a child, the other does not)"
	treeView
		expand: 'CA';
		expand: 'CB'.
	childExpanded
		ifFalse: 
			[treeView
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
	treeView expand: 'D'.
	rootExpanded ifFalse: [treeView collapse: 'D'].
	self assert: nodeD hasExpanded.
	self assert: nodeD child object equals: 'DA'.

	"CA and CB will be the collapsed children (one has a child, the other does not)"
	treeView
		expand: 'CA';
		expand: 'CB'.
	childExpanded
		ifFalse: 
			[treeView
				collapse: 'CA';
				collapse: 'CB'].
	"parent will get expanded"
	self assert: nodeC child hasExpanded.
	self assert: nodeC child sibling hasExpanded.

	"NN[C|E] x RC[C|E]"
	treeModel move: 'CB' asChildOf: 'D'.
	node := treeView findNodeForObject: 'CB'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	node := treeView findNodeForObject: 'CB'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"NC[C|E] x RC[C|E]"
	treeModel move: 'CA' asChildOf: 'D'.
	node := treeView findNodeForObject: 'CA'.
	self assert: nodeD isExpanded identicalTo: rootExpanded.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: node.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	node := treeView findNodeForObject: 'CA'.
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
	treeView
		expand: 'CA';
		expand: 'CB'.
	isExpanded
		ifFalse: 
			[treeView
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
	treeView
		expand: 'CA';
		expand: 'CB'.
	isExpanded
		ifFalse: 
			[treeView
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
		toUnexpandedRoot: nodeD.
	self destroyTree!

moveRoots: moveeExpanded toRoots: toExpanded
	"A & F will be the previously expanded root with no children"

	self createTree.
	self assertInitialState.
	treeView expand: 'F'.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.
	treeView expand: 'A'.
	self assert: nodeA isExpanded.
	self assert: nodeA hasExpanded.
	self assertIsNil: nodeA child.
	"B & D will be the expanded root with children"
	treeView
		expand: 'D';
		expand: 'B'.
	self assert: nodeD hasExpanded.
	self denyIsNil: nodeD child.
	moveeExpanded
		ifFalse: 
			[treeView
				collapse: 'B';
				collapse: 'A'].
	self assert: nodeB hasExpanded.
	self assert: nodeB isExpanded identicalTo: moveeExpanded.
	self denyIsNil: nodeB child.
	toExpanded
		ifFalse: 
			[treeView
				collapse: 'D';
				collapse: 'F'].

	"RNC x RNC"
	treeModel move: 'A' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedChild: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedRoot: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"RNC x RCC"
	treeModel move: 'A' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedRoot: nodeA.
	self assert: nodeA isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"RCC x RNC"
	treeModel move: 'B' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedChild: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"Now move it back"
	treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertPopulatedRoot: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeF isExpanded equals: toExpanded.

	"RCC x RCC"
	treeModel move: 'B' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedChild: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded.

	"Now move it back"
	treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertPopulatedRoot: nodeB.
	self assert: nodeB isExpanded equals: moveeExpanded.
	self assert: nodeD isExpanded equals: toExpanded!

moveRootsToUnexpandedRoots: isExpanded
	self createTree.
	self assertInitialState.

	"F will be the expanded root with no children"
	treeView expand: 'F'.
	self assert: nodeF isExpanded.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.
	"B & D will be the expanded root with children"
	treeView expand: 'D'.
	self assert: nodeD hasExpanded.
	self assert: nodeD isExpanded.
	self denyIsNil: nodeD child.
	isExpanded
		ifFalse: 
			[treeView
				collapse: 'F';
				collapse: 'D'].

	"RNC x RNU"
	treeModel move: 'F' asChildOf: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertIsNil: (treeView findNodeForObject: 'F').

	"Now move it back (new node created)"
	treeModel move: 'F' asChildOf: nil.
	self deny: (treeView findNodeForObject: 'F') identicalTo: nodeF.
	nodeF := treeView findNodeForObject: 'F'.
	self assertUnexpandedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"Since nodeF was recreated, we must expand and collapse it to get back to where we were"
	treeView expandNode: nodeF.
	isExpanded ifFalse: [treeView collapseNode: nodeF cause: #unknown].

	"RNC x RCU"
	treeModel move: 'F' asChildOf: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertUnlinkedNode: nodeF.
	self assertIsNil: (treeView findNodeForObject: 'F').

	"Now move it back (new node created)"
	treeModel move: 'F' asChildOf: nil.
	self deny: (treeView findNodeForObject: 'F') identicalTo: nodeF.
	nodeF := treeView findNodeForObject: 'F'.
	self assertUnexpandedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"RCC x RNU"
	treeModel move: 'D' asChildOf: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertIsNil: (treeView findNodeForObject: 'D').

	"Now move it back (new node created)"
	treeModel move: 'D' asChildOf: nil.
	self deny: (treeView findNodeForObject: 'D') identicalTo: nodeD.
	nodeD := treeView findNodeForObject: 'D'.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeA.

	"Expand/collapse D again"
	treeView expandNode: nodeD.
	isExpanded ifTrue: [treeView collapseNode: nodeD cause: #unknown].

	"RCC x RCU"
	treeModel move: 'D' asChildOf: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertIsNil: (treeView findNodeForObject: 'D').

	"Now move it back (new node created)"
	treeModel move: 'D' asChildOf: nil.
	self deny: (treeView findNodeForObject: 'D') identicalTo: nodeD.
	nodeD := treeView findNodeForObject: 'D'.
	self assertUnexpandedRoot: nodeD.
	self assertUnexpandedRoot: nodeB.
	self destroyTree!

moveUnexpandedChild: parentExpanded toUnexpandedRoot: targetNode
	"Private - NNU x RCU - child's parent expanded (therefore CB should be in tree)."

	| node object |
	object := targetNode object.
	treeView expandNode: nodeC.
	parentExpanded ifFalse: [treeView collapseNode: nodeC cause: #unknown].
	node := treeView findNodeForObject: 'CB'.
	treeModel move: 'CB' asChildOf: object.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: 'CB').

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	self deny: (treeView findNodeForObject: 'CB') identicalTo: node.
	node := treeView findNodeForObject: 'CB'.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedChild: node.

	"NCU x RCU - child's parent expanded but not child expanded."
	node := treeView findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	treeModel move: 'CA' asChildOf: object.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: 'CA').

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	self deny: (treeView findNodeForObject: 'CA') identicalTo: node.
	node := treeView findNodeForObject: 'CA'.
	self assertPopulatedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedChild: node!

moveUnexpandedChildOfUnexpandedParentToRoot: targetNode
	| object |
	object := targetNode object.
	self assertUnexpandedRoot: targetNode.

	"NNU x RCU - child's parent not expanded."
	treeModel move: 'CB' asChildOf: object.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: 'CB').

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: 'CB').

	"NCU x RCU - neither child nor child's parent expanded."
	treeModel move: 'CA' asChildOf: object.
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: 'CA').

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	self assertIsNil: (treeView findNodeForObject: 'CA').
	self assertUnexpandedRoot: nodeC.
	self assertUnexpandedRoot: targetNode!

moveUnexpandedChildToRoot: isExpanded target: anObject
	| node targetNode |
	self createTree.
	self assertInitialState.
	targetNode := treeView findNodeForObject: anObject.

	"D will be the collapsed root with children"
	treeView expandNode: targetNode.
	isExpanded ifFalse: [treeView collapseNode: targetNode cause: #unknown].
	self assertPopulatedRoot: targetNode.

	"NNU x RCC - child's parent not expanded."
	treeModel move: 'CB' asChildOf: anObject.
	node := treeView findNodeForObject: 'CB'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assertUnexpandedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	self assertIsNil: (treeView findNodeForObject: 'CB').
	self assertIsNil: node parent.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedRoot: nodeC.

	"NCU x RNC - neither child nor child's parent expanded."
	treeModel move: 'CA' asChildOf: anObject.
	node := treeView findNodeForObject: 'CA'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assertUnexpandedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	self assertIsNil: (treeView findNodeForObject: 'CA').
	self assertIsNil: node parent.
	self assertIsNil: node parent.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedRoot: nodeC.
	treeView expandNode: nodeC.

	"NNU x RNC - child's parent expanded (therefore CB should be in tree)."
	node := treeView findNodeForObject: 'CB'.
	treeModel move: 'CB' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"NCU x RCC - child's parent expanded but not child expanded."
	self assert: nodeC isExpanded.
	node := treeView findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	treeModel move: 'CA' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node).
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node).
	self assertPopulatedRoot: nodeC.
	treeView collapseNode: nodeC cause: #unknown.

	"NCU x RCC - child's parent collapsed (therefore CB should be in tree)."
	node := treeView findNodeForObject: 'CB'.
	treeModel move: 'CB' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CB' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node) not.
	self assertPopulatedRoot: nodeC.

	"NCU x RCC - child's parent collapsed but not child expanded."
	node := treeView findNodeForObject: 'CA'.
	self assert: node parent equals: nodeC.
	treeModel move: 'CA' asChildOf: anObject.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node).
	self assertPopulatedRoot: nodeC.

	"Now move it back"
	treeModel move: 'CA' asChildOf: 'C'.
	self assertPopulatedRoot: targetNode.
	self assertUnexpandedChild: node.
	self assert: (treeView hasChildren: node).
	self assertPopulatedRoot: nodeC.
	self destroyTree!

moveUnexpandedChildToUnexpandedChild
	"Private - RNU x NNU"

	treeModel move: 'EA' asChildOf: 'CB'.
	self assert: (treeView roots includes: nodeA) not.
	self assert: (treeView roots includes: nodeF).
	self assert: nodeA isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeA) not.
	"Because CB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self should: [treeView findNodeForObject: 'EA'] raise: NotFoundError.
	self assertIsNil: nodeF child.

	"Now move it back"
	treeModel move: 'EA' asChildOf: 'E'.
	nodeE hasExpanded
		ifTrue: 
			[| node |
			node := treeView findNodeForObject: 'EA'.
			self assert: (treeView roots includes: node) not.
			self assertUnexpandedChild: node.
			self assertIsNil: node parent parent.
			self assert: node parent child equals: node.
			self assert: node parent object equals: 'E'.
			self assertIsNil: node sibling.
			self assertIsNil: node child]
		ifFalse: [self should: [treeView findNodeForObject: 'EA'] raise: NotFoundError].


	"RCU x NNU"
	treeModel move: 'B' asChildOf: 'CB'.
	self assert: (treeView roots includes: nodeB) not.
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self should: [treeView findNodeForObject: 'B'] raise: NotFoundError.
	self should: [treeView findNodeForObject: 'BA'] raise: NotFoundError.
	self assertIsNil: nodeF child.

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	nodeB := treeView findNodeForObject: 'B'.
	self assert: (treeView roots includes: nodeB).
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	self assertIsNil: nodeB parent.
	self assertIsNil: nodeB child.
	self assertIsNil: nodeF child.

	"RNU x NCU"
	treeModel move: 'A' asChildOf: 'B'.
	self assert: (treeView roots includes: nodeA) not.
	self assert: (treeView roots includes: nodeB).
	self assert: nodeA isExpanded not.
	self assert: nodeB isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (treeView hasChildren: nodeA) not.
	self assert: (treeView hasChildren: nodeB).
	"Because nodeB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self should: [treeView findNodeForObject: 'A'] raise: NotFoundError.
	self assertIsNil: nodeB child.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	nodeA := treeView findNodeForObject: 'A'.
	self assert: (treeView roots includes: nodeA).
	self assert: (treeView roots includes: nodeB).
	self assert: nodeA isExpanded not.
	self assert: nodeB isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (treeView hasChildren: nodeA) not.
	self assert: (treeView hasChildren: nodeB).
	self assertIsNil: nodeA parent.
	self assertIsNil: nodeB child.

	"RCU x NCU"
	treeModel move: 'B' asChildOf: 'CA'.
	self assert: (treeView roots includes: nodeB) not.
	self assert: (treeView roots includes: nodeD).
	self assert: nodeB isExpanded not.
	self assert: nodeD isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeD hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	self assert: (treeView hasChildren: nodeD).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self should: [treeView findNodeForObject: 'B'] raise: NotFoundError.
	self should: [treeView findNodeForObject: 'BA'] raise: NotFoundError.
	self assertIsNil: nodeD child.

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	nodeB := treeView findNodeForObject: 'B'.
	self assert: (treeView roots includes: nodeB).
	self assert: (treeView roots includes: nodeD).
	self assert: nodeB isExpanded not.
	self assert: nodeD isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeD hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	self assert: (treeView hasChildren: nodeD).
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
	treeModel move: source asChildOf: dest.
	self assertUnexpandedRoot: targetNode.
	self assertIsNil: (treeView findNodeForObject: source).

	"Now 'move' it back (actually add it again)"
	treeModel move: source asChildOf: nil.
	new := treeView findNodeForObject: source.
	self deny: new identicalTo: node.
	self assertUnexpandedRoot: targetNode.
	self assertUnexpandedRoot: new.
	^new!

moveUnexpandedRootsToRoots: isExpanded
	"Private - Tests: RNU x RNC, RNU x RCC, RCU x RNC, RCU x RCC"

	self createTree.
	self assertInitialState.

	"F will be the collapsed root with no children"
	treeView expand: 'F'.
	self assert: nodeF hasExpanded.
	self assertIsNil: nodeF child.

	"B & D will be the collapsed root with children"
	treeView expand: 'D'.
	self assert: nodeD hasExpanded.
	self denyIsNil: nodeD child.
	isExpanded
		ifFalse: 
			[treeView
				collapse: 'F';
				collapse: 'D'].
	self assertPopulatedRoot: nodeF.
	self assert: nodeF isExpanded identicalTo: isExpanded.

	"RNU x RNC"
	treeModel move: 'A' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedChild: nodeA.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedRoot: nodeA.

	"RNU x RCC"
	treeModel move: 'A' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedChild: nodeA.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedRoot: nodeA.

	"RCU x RNC: Move an unexpanded root with children to be a child of an previously expanded root with no children,
	but which is currently collapsed."
	treeModel move: 'B' asChildOf: 'F'.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedChild: nodeB.

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeF.
	self assertUnexpandedRoot: nodeB.

	"RCU x RCC"
	treeModel move: 'B' asChildOf: 'D'.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedChild: nodeB.

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	self assertPopulatedRoot: nodeD.
	self assertUnexpandedRoot: nodeB.
	self destroyTree!

moveUnexpandedRootsToUnexpandedChildren
	"Private - RNU x NNU"

	treeModel move: 'A' asChildOf: 'CB'.
	self assertUnlinkedNode: nodeA.
	self assertRootsInOrder.
	self assertUnexpandedRoot: nodeF.
	self assert: nodeA isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeA) not.
	"Because CB is unexpanded, nodeA will no longer be linked into the tree."
	self assertIsNil: nodeA parent.
	self assertIsNil: (treeView findNodeForObject: 'A').
	self assertIsNil: nodeF child.

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	nodeA := treeView findNodeForObject: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assert: nodeF isExpanded not.
	self assert: nodeF hasExpanded not.
	self assertIsNil: nodeF child.

	"RCU x NNU"
	treeModel move: 'B' asChildOf: 'CB'.
	self assertUnlinkedNode: nodeB.
	self assert: nodeB isExpanded not.
	self assert: nodeF isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertIsNil: nodeB parent.
	self assertIsNil: (treeView findNodeForObject: 'B').
	self assertIsNil: (treeView findNodeForObject: 'BA').
	self assertIsNil: nodeF child.

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	nodeB := treeView findNodeForObject: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assert: nodeF isExpanded not.
	self assert: nodeF hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	self assertIsNil: nodeF child.

	"RNU x NCU"
	treeModel move: 'A' asChildOf: 'B'.
	"Because nodeB is unexpanded, nodeA will no longer be linked into the tree."
	self assertUnlinkedNode: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assert: nodeA isExpanded not.
	self assert: nodeA hasExpanded not.
	self assert: (treeView hasChildren: nodeA) not.
	self assert: (treeView hasChildren: nodeB).

	"Now move it back"
	treeModel move: 'A' asChildOf: nil.
	nodeA := treeView findNodeForObject: 'A'.
	self assertUnexpandedRoot: nodeA.
	self assertUnexpandedRoot: nodeB.
	self assert: (treeView hasChildren: nodeA) not.
	self assert: (treeView hasChildren: nodeB).

	"RCU x NCU"
	treeModel move: 'B' asChildOf: 'CA'.
	"Because nodeF is unexpanded, nodeB will no longer be linked into the tree."
	self assertUnlinkedNode: nodeB.
	self assertUnexpandedRoot: nodeD.
	self assert: nodeB isExpanded not.
	self assert: nodeB hasExpanded not.
	self assert: (treeView hasChildren: nodeB).
	self assert: (treeView hasChildren: nodeD).
	self assertIsNil: (treeView findNodeForObject: 'BA').

	"Now move B back"
	treeModel move: 'B' asChildOf: nil.
	nodeB := treeView findNodeForObject: 'B'.
	self assertUnexpandedRoot: nodeB.
	self assertUnexpandedRoot: nodeD.
	self assert: (treeView hasChildren: nodeB).
	self assert: (treeView hasChildren: nodeD)!

runCase
	useShell := true.
	super runCase.
	useShell := false.
	super runCase!

setUp
	useShell
		ifTrue: 
			[shell := ShellView new create.
			shell layoutManager: BorderLayout new.
			scroller := shell addSubView: ScrollingDecorator new.
			scroller arrangement: #center.
			shell rectangle: (100 @ 100 extent: 200 @ 300).
			shell show]!

tearDown
	useShell ifTrue: [shell destroy] ifFalse: [treeView isNil ifFalse: [treeView destroy]].
	shell := scroller := treeView := treeModel := nil!

testMoveChildToChildlessRoot
	"Tests: NNC x RNC, NCC x RNC,
		NNC x RNE, NCC x RNE
		NNE x RNC, NCE x RNC,
		NNE x RNE, NCE x RNE"

	self moveChild: false toChildlessRoot: false.
	self moveChild: false toChildlessRoot: true.
	self moveChild: true toChildlessRoot: false.
	self moveChild: true toChildlessRoot: true.
	self destroyTree!

testMoveChildToRootWithChildren
	"NNC x RCC, NCC x RCC"
	self moveChild: false toRootWithChildren: false.
	"NNC x RCE, NCC x RCE"
	self moveChild: false toRootWithChildren: true.
	"NNE x RCC, NCE x RCC"
	self moveChild: true toRootWithChildren: false.
	"NNE x RCE, NCE x RCE"
	self moveChild: true toRootWithChildren: true.

	self destroyTree!

testMoveChildToUnexpandedRoot
	"Tests: NNC x RNU, NCC x RNU,
		NNC x RCU, NCC x RCU,
		NNE x RNU, NCE x RNU,
		NNE x RCU, NCE x RCU"

	self moveChildToUnexpandedRoot: true.
	self moveChildToUnexpandedRoot: false!

testMoveRootsToRoots
	"Tests: RNC x RNC, RNC x RCC, RCC x RNC, RCC x RCC,
		RNC x RNE, RNC x RCE, RCC x RNE, RCC x RCE,
		RNE x RNC, RCE x RNC, RNE x RCC, RCE x RCC,
		RNE x RNE, RCE x RNE, RNE x RCE, RCE x RCE"

	self moveRoots: false toRoots: false.
	self moveRoots: false toRoots: true.
	self moveRoots: true toRoots: false.
	self moveRoots: true toRoots: true.
	self destroyTree!

testMoveRootsToUnexpandedRoots
	"Tests: RNC x RNU, RNC x RCU, RCC x RNU, RCC x RCU"

	self moveRootsToUnexpandedRoots: true.
	self moveRootsToUnexpandedRoots: false!

testMoveSelectionDown
	treeModel := TreeModel withRoots: #('A') searchPolicy: SearchPolicy equality.
	self createView.
	treeView selection: 'A'.
	self assert: treeView selection equals: 'A'.
	"Test with a singe selected root"
	treeView moveSelectionDown.
	"Selection should not move since there is no down sibling."
	self assert: treeView selection equals: 'A'.
	"Test move down to next root."
	treeModel addRoot: 'B'.
	treeView moveSelectionDown.
	self assert: treeView selection equals: 'B'.
	"Test attempted move off last root"
	treeView moveSelectionDown.
	"Selection should not move since there is no down sibling."
	self assert: treeView selection equals: 'B'.
	"Test with a single selected child of a last  root"
	treeModel add: 'AA' asChildOf: 'A'.
	treeView selection: 'AA'.
	self assert: treeView selection equals: 'AA'.
	treeView moveSelectionDown.
	"Selection should move to B."
	self assert: treeView selection equals: 'B'.
	"Now test move to immediate sibling"
	treeModel add: 'AB' asChildOf: 'A'.
	treeView selection: 'AA'.
	treeView moveSelectionDown.
	self assert: treeView selection equals: 'AB'.

	"Test move to immediate parent's sibling where parent is a root."
	treeModel add: 'BA' asChildOf: 'B'.
	treeView selection: 'BA'.
	self assert: treeView selection equals: 'BA'.
	treeView moveSelectionDown.
	"Selection should not move."
	self assert: treeView selection equals: 'BA'.

	"Test move to sibling of non-immediate root parent."
	treeModel add: 'ABA' asChildOf: 'AB'.
	treeView selection: 'ABA'.
	treeView moveSelectionDown.
	"Selection should move to next root."
	self assert: treeView selection equals: 'B'.

	"Test move to sibling of immediate parent which is not a root"
	treeModel add: 'BAA' asChildOf: 'BA'.
	treeModel add: 'BB' asChildOf: 'B'.
	treeView selection: 'BAA'.
	treeView moveSelectionDown.
	"Selection should move to non-immediate parent."
	self assert: treeView selection equals: 'BB'.

	"Test move to sibling of non-immediate parent which is not a root"
	treeModel add: 'ABAA' asChildOf: 'ABA'.
	treeModel add: 'AC' asChildOf: 'A'.
	treeView selection: 'ABAA'.
	treeView moveSelectionDown.
	"Selection should move to non-immediate parent."
	self assert: treeView selection equals: 'AC'!

testMoveUnexpandedChildToRoot
	"Tests: NNU x RCC, NCU x RCC, NNU x RCE, NCU x RCE,
		NNU x RNE, NCU x RNE, NNU x RNC, NCU x RNC"

	self moveUnexpandedChildToRoot: true target: 'F'.
	self moveUnexpandedChildToRoot: false target: 'F'.
	self moveUnexpandedChildToRoot: true target: 'D'.
	self moveUnexpandedChildToRoot: false target: 'D'.
	self destroyTree!

testMoveUnexpandedChildToUnexpandedRoot
	"Tests: NNU x RNU, NCU x RNU"

	self createTree.
	self assertInitialState.
	self moveUnexpandedChildOfUnexpandedParentToRoot: nodeF.
	self moveUnexpandedChildOfUnexpandedParentToRoot: nodeD.
	self moveUnexpandedChild: true toUnexpandedRoot: nodeF.
	self moveUnexpandedChild: false toUnexpandedRoot: nodeF.
	self moveUnexpandedChild: true toUnexpandedRoot: nodeD.
	self moveUnexpandedChild: false toUnexpandedRoot: nodeD.
	self destroyTree!

testMoveUnexpandedRootsToRoots
	"Tests: RNU x RNC, RNU x RCC, RCU x RNC, RCU x RCC,
		RNU x RNE, RNU x RCE, RCU x RNE, RCU x RCE"

	self moveUnexpandedRootsToRoots: true.
	self moveUnexpandedRootsToRoots: false.
	self destroyTree!

testMoveUnexpandedRootsToUnexpandedChildren
	"Tests: RNU x NNU, RNU x NCU, RCU x NNU, RCU x NCU"

	self createTree.
	self assertInitialState.
	self assert: treeView anchorNode child identicalTo: nodeA.
	self moveUnexpandedRootsToUnexpandedChildren.

	"Now repeat with the 'CA' and 'CB' nodes actually in the tree"
	treeView expand: 'C'.
	self moveUnexpandedRootsToUnexpandedChildren.

	"And again but with 'C' collapsed"
	treeView collapse: 'C'.
	self moveUnexpandedRootsToUnexpandedChildren.
	self destroyTree!

testMoveUnexpandedRootsToUnexpandedRoots
	"Tests: RNU x RNU, RNU x RCU, RCU x RNU, RCU x RCU"

	"Now 'move' it back (actually add it again)"

	"RCU x RNU: Move an unexpanded root with children to be a child of another root with no children"

	self createTree.
	self assertInitialState.

	"RNU x RNU: Move an unexpanded root with no children to be a child of another root with no children"
	nodeA := self moveUnexpandedRoot: nodeA toUnexpandedRoot: nodeF.

	"RCU x RNU"
	nodeB := self moveUnexpandedRoot: nodeB toUnexpandedRoot: nodeF.

	"RNU x RCU: Move an unexpanded root with no children to be a child of another root with children"
	nodeA := self moveUnexpandedRoot: nodeA toUnexpandedRoot: nodeB.

	"RCU x RCU: Move an unexpanded root with children to be a child of another root with children"
	nodeB := self moveUnexpandedRoot: nodeB toUnexpandedRoot: nodeD.

	self destroyTree!

testRemoveSelection
	treeModel := TreeModel withRoots: #('A' 'B' 'C') searchPolicy: SearchPolicy equality.
	self createView.
	treeView selection: 'B'.
	"Remove selected middle root"
	self
		should: [treeModel remove: 'B']
		trigger: #selectionChanged
		against: treeView presenter.
	"Selection moves down to next sibling"
	self assert: treeView selection equals: 'C'.
	"Remove selected last root"
	self
		should: [treeModel remove: 'C']
		trigger: #selectionChanged
		against: treeView presenter.
	"Selection moves up to previous sibling"
	self assert: treeView selection equals: 'A'.
	"Remove first (and last) root"
	self
		should: [treeModel remove: 'A']
		trigger: #selectionChanged
		against: treeView presenter.
	"Selection lost (no other items to select)"
	self assertIsNil: treeView selectionOrNil.
	self
		should: [treeView selection]
		raise: Error
		matching: [:ex | ex messageText = 'No object selected'].
	treeModel := TreeModel withRoots: #('ROOT1' 'ROOT2' 'ROOT3') searchPolicy: SearchPolicy equality.
	#('A' 'B' 'C') do: [:each | treeModel add: each asChildOf: 'ROOT2'].
	treeView model: treeModel.
	treeView selection: 'B'.
	"Remove selected middle child"
	treeModel remove: 'B'.
	"Selection moves down to next sibling"
	self assert: treeView selection equals: 'C'.
	"Remove selected last child"
	treeModel remove: 'C'.
	"Selection moves to prev sibling"
	self assert: treeView selection equals: 'A'.
	"Remove first child"
	treeModel remove: 'A'.
	"Selection moves to parent"
	self assert: treeView selection equals: 'ROOT2'! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertChildNode:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertCollapsedChild:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertCollapsedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertCorrectlyPopulatedNode:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertExpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertInitialState!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertNodeInTree:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertPopulatedChild:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertPopulatedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertRootNode:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertRootsInOrder!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertUnexpandedChild:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertUnexpandedNode:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertUnexpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #assertUnlinkedNode:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #createModel!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #createTree!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #createView!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #destroyTree!private!Running! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveChild:of:toRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveChild:of:toUnexpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveChild:toChildlessRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveChild:toRootWithChildren:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveChildToUnexpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveRoots:toRoots:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveRootsToUnexpandedRoots:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedChild:toUnexpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedChildOfUnexpandedParentToRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedChildToRoot:target:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedChildToUnexpandedChild!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedRoot:toUnexpandedRoot:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedRootsToRoots:!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #moveUnexpandedRootsToUnexpandedChildren!helpers!private! !
!UI.Tests.MoenTreeViewTest categoriesFor: #runCase!public!Running! !
!UI.Tests.MoenTreeViewTest categoriesFor: #setUp!helpers!public! !
!UI.Tests.MoenTreeViewTest categoriesFor: #tearDown!public!Running! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveChildToChildlessRoot!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveChildToRootWithChildren!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveChildToUnexpandedRoot!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveRootsToRoots!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveRootsToUnexpandedRoots!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveSelectionDown!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveUnexpandedChildToRoot!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveUnexpandedChildToUnexpandedRoot!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveUnexpandedRootsToRoots!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveUnexpandedRootsToUnexpandedChildren!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testMoveUnexpandedRootsToUnexpandedRoots!public!unit tests! !
!UI.Tests.MoenTreeViewTest categoriesFor: #testRemoveSelection!public!unit tests! !

