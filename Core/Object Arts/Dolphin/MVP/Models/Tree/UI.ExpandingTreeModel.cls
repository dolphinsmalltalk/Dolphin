"Filed out from Dolphin Smalltalk"!

UI.TreeModel
	subclass: #'UI.ExpandingTreeModel'
	instanceVariableNames: 'getChildrenBlock hasChildrenBlock'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.ExpandingTreeModel guid: (Core.GUID fromString: '{14185f62-d296-4f25-80ad-ee85ed9d2e08}')!
UI.ExpandingTreeModel comment: 'ExpandingTreeModel is a specialized <TreeModel> that dynamically generates the set of child nodes for a node, but only on first request. The tree is still built with a hierarchy of <TreeNodes>, but starts off only with the roots. As the user navigates through the tree (actually as the client view requests them) the tree is fleshed out.

See also VirtualTreeModel, which is a fully dynamic tree model.

Instance Variables:
	getChildrenBlock 	<monadicValuable> used to identify the children of an object in the tree.

'!
!UI.ExpandingTreeModel categoriesForClass!MVP-Models! !
!UI.ExpandingTreeModel methodsFor!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements)."

	^50!

childrenOfNode: node
	"Private - Answer an <OrderedCollection> of the child nodes of the <TreeNode>, node."

	| children |
	(children := node getChildren) isNil 
		ifTrue: 
			[self expandNodeChildren: node.
			children := node children].
	^children!

defaultGetChildrenBlock
	^[:node | node children]!

expandNodeChildren: aTreeNode
	"Private - Dynamically expand the <ExpandingTreeNode>, node, to populate it
	with its children. Answer an <OrderedCollection> of <TreeNode> containing the
	children. Note that because TreeNode stores nil instead of an empty
	collection (to save space), each access to the children of a leaf node will
	require a further attempt at expanding the children. This has an upside, in that
	a connected tree view will update to display an expansion button when/if a former
	leaf acquires children."

	(self getChildrenOfNode: aTreeNode) 
		do: [:each | self add: each asChildOfNode: aTreeNode]!

getChildrenBlock
	"Answer the <monadicValuable> which when evaluated answers a <sequencedReadableCollection>
	of the children of its argument."

	^getChildrenBlock!

getChildrenBlock: monad
	"Set the <monadicValuable> which when evaluated answers a <sequencedReadableCollection>
	of the children of its argument."

	getChildrenBlock := monad!

getChildrenOfNode: aTreeNode
	"Private - Answer an <OrderedCollection> of <TreeNode>s, being the calculated collection
	of children of the specified parent node."

	^self getChildrenBlock value: aTreeNode object!

hasChildren: anObject
	"Answer true if anObject has children within the hierarchy managed by the
	receiver. If anObject does not exist in the receiver then raise a suitable
	exception"

	| node |
	node := anObject isNil ifTrue: [anchorNode] ifFalse: [self getNodeFor: anObject].
	^node getChildren notNil or: 
			[self hasChildrenBlock 
				ifNil: 
					[self expandNodeChildren: node.
					node children notEmpty]
				ifNotNil: [:block | block value: anObject]]!

hasChildrenBlock
	^hasChildrenBlock!

hasChildrenBlock: aMonadicValuableOrNil
	"If the hasChildrenBlock is nil (the default) then the tree determines whether there are 
	any children by expanding them using the getChildrenBlock (i.e. they will be retained)."

	hasChildrenBlock := aMonadicValuableOrNil!

initialize
	"Private - Initialize the receiver"

	getChildrenBlock := self defaultGetChildrenBlock.
	super initialize.
!

roots
	"Answer the roots of the receiver's hierarchy.
	Implementation Note: Override because we don't want to apply the getChildrenBlock
	against the anchor node if it is empty."

	^anchorNode children collect: [:each | each object]!

size
	"Answer the number of elements in the receiver."

	"Implementation Note: We must override back to the superclass implementation in order to
	count the number of nodes in the tree when fully expanded."

	^self countElements! !
!UI.ExpandingTreeModel categoriesForMethods!
approxSize!accessing!private! !
childrenOfNode:!hierarchy!private! !
defaultGetChildrenBlock!initializing!private! !
expandNodeChildren:!hierarchy!private! !
getChildrenBlock!accessing!public! !
getChildrenBlock:!accessing!public! !
getChildrenOfNode:!hierarchy!private! !
hasChildren:!hierarchy!public!testing! !
hasChildrenBlock!accessing!public! !
hasChildrenBlock:!accessing!public! !
initialize!initializing!private! !
roots!hierarchy!public! !
size!accessing!public! !
!

