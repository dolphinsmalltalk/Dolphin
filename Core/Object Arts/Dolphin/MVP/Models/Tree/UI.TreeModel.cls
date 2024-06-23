"Filed out from Dolphin Smalltalk"!

UI.TreeModelAbstract
	subclass: #'UI.TreeModel'
	instanceVariableNames: 'anchorNode objectNodeMap'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.TreeModel guid: (Core.GUID fromString: '{87b4c66f-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.TreeModel comment: 'TreeModel implements the <treeModel> protocol and organises a collection of objects into a tree like data structure. The tree is built of a hierarchy of <TreeNodes>. Objects can be added to the tree using #add:asChildOf: and they can be removed using #remove:. An object already in the tree can be moved from one location in the hierarchy to another by using the #move:asChildOf: message. Root nodes in the tree can be considered as having a parent of nil. 

Instance Variables:
	anchorNode	<TreeNode> or nil, representing the root of the tree.
	objectNodeMap	<IdentityDictionary> mapping tree objects to <TreeNodes>

'!

!UI.TreeModel categoriesForClass!MVP-Models! !

!UI.TreeModel methodsFor!

add: leafObject asChildOf: parentObject
	"Adds the <Object>, leafObject, to the receiver as a child of the <Object>, parentObject,
	answering the new leaf. If the parent is nil then leaf is added as a root of the tree. If
	leaf already exists in the tree, then answer the existing node which is left in place (i.e.
	it is not an error to attempt to add an equivalent node twice, and the existing node is not
	overwritten with the new object). If the parent does not exist then raise a <NotFoundError>."

	| parentNode |
	(objectNodeMap lookup: leafObject) ifNotNil: [:childNode | ^childNode object].
	parentNode := parentObject isNil ifTrue: [anchorNode] ifFalse: [self getNodeFor: parentObject].
	self addChild: leafObject parentNode: parentNode.
	self
		trigger: #item:addedInParent:
		with: leafObject
		with: parentObject.
	^leafObject!

add: anObject asChildOfNode: aTreeNode
	"Private - Adds the <Object>, anObject, to the receiver as a child of the <TreeNode>,
	aTreeNode, answering the new leaf <TreeNode>. If the object already exists in the tree 
	(determined by comparison using the receiver's search policy), then the existing node is 
	answered and no change is made to the tree (an invariant of TreeModels is that they may
	not contain duplicate nodes)."

	^(objectNodeMap lookup: anObject) ifNil: [self addChild: anObject parentNode: aTreeNode]!

addChild: anObject parentNode: parentNode
	"Private - Create a child leaf and add under the specified parent node.
	Answer the new child node. This is the basic add operation."

	| childNode |
	childNode := self newNode: anObject.
	objectNodeMap at: anObject put: childNode.
	parentNode addChildNode: childNode.
	^childNode!

approxSize
	"Private - Answer the approximate size of the receiver. Since TreeModels keep an
	object to node mapping dictionary we can use the size of this"

	^self size!

asBag
	"Answer a Bag whose elements are those stored in the receiver"

	^objectNodeMap keys asBag!

asSet
	"Answer a Set whose elements are those stored in the receiver (any duplicates are therefore 
	eliminated)."

	^objectNodeMap keys asSet!

basicRoots: aCollection
	"Private - Set the roots of the receiver's hierarchy to be
	the elements of the <collection> argument, added in that
	collections #do: order."

	aCollection do: [:each | self addChild: each parentNode: anchorNode]!

childrenOfNode: node
	"Private - Answer an <OrderedCollection> of the child nodes of the <TreeNode>, node."

	^node children!

clear
	"Clear the receiver (remove all nodes)."

	self reset.
	self refreshTree: nil.!

collapse: anObject ifAbsent: exceptionHandler
	"Removes the sub-trees beneath anObject in the receiver. If anObject does not 
	exist in the tree then answer the result of evaluating the <niladicValuable>, 
	exceptionHandler, otherwise answer anObject."

	^(objectNodeMap lookup: anObject)
		ifNil: [exceptionHandler value]
		ifNotNil: 
			[:node |
			self forgetChildrenOfNode: node.
			node beChildless.
			self refreshTree: anObject]!

depthOf: anObject
	"Answer the depth of anObject in the tree. Roots are at depth 0, and then immediate children at depth 1, and so on."

	| answer ancestor |
	answer := -1.
	ancestor := self parentNodeOf: anObject.
	[ancestor isNil] whileFalse: 
			[answer := answer + 1.
			ancestor := ancestor parent].
	^answer!

forgetChildrenOfNode: aTreeNode
	"Private - Note that we access the children collection directly as we merely want to 
	remove existing children from the objectNodeMap."

	aTreeNode getChildren 
		ifNotNil: [:childNodes | childNodes do: [:each | self forgetNode: each]]!

forgetNode: aTreeNode
	self forgetChildrenOfNode: aTreeNode.
	objectNodeMap removeKey: aTreeNode object!

getChildrenOf: anObject
	"Private - Answer an OrderedCollection of the children of anObject within 
	the hierarchy managed by the receiver. If anObject does not exist 
	in the receiver then raise a suitable exception."

	| node |
	node := self getNodeFor: anObject.
	^(self childrenOfNode: node) collect: [:each | each object]!

getNodeFor: anObject
	"Private - Answer the <TreeNode> that represents the <Object>, anObject, which
	must be an element of this tree model."

	^(objectNodeMap lookup: anObject) ifNil: [self errorNotFound: anObject]!

hasChildren: anObject
	"Answer true if anObject has children within the hierarchy managed by the
	receiver. If anObject does not exist in the receiver then raise a suitable
	exception"

	^(self childrenOfNode: (anObject isNil 
				ifTrue: [anchorNode]
				ifFalse: [self getNodeFor: anObject])) 
		notEmpty!

includes: anObject
	"Answer whether the argument, anObject, is one of the elements of the receiver.
	Uses the receiver's searchPolicy for comparison."

	^(objectNodeMap lookup: anObject) notNil!

initialize
	"Private - Initialize the receiver"

	self reset!

move: anObject asChildOf: aParentObject
	"Moves anObject in the receiver to be a child of aParentObject. If
	aParentObject is nil then anObject is added as a root of the tree.
	If anObject does not exist in the tree or aParentObject does not exist
	then raise a suitable exception. Answer anObject."

	| parentNode childNode |

	"Find the parent node"
	parentNode := aParentObject isNil
		ifTrue: [anchorNode]
		ifFalse: [self getNodeFor: aParentObject].

	"Find the child node"
	childNode := self getNodeFor: anObject.

	"Move it"
	childNode parent removeChildNode: childNode.
	parentNode addChildNode: childNode.

	"Inform dependents"	
	self trigger: #item:movedToParent: with: anObject with: aParentObject.

	^anObject!

newNode: anObject
	^self nodeClass for: anObject!

nodeClass
	"Answer the class of object to be used to represent the receiver's nodes."

	^TreeNode!

parentNodeOf: anObject
	^(objectNodeMap lookup: anObject) ifNotNil: [:node | node parent]!

parentOf: anObject
	"Answer the parent of anObject within the hierarchy managed by the
	receiver. If anObject is a root of the hierarchy then answer nil.
	If anObject does not exist in the receiver then raise a suitable
	exception."

	^(self parentNodeOf: anObject)
		ifNil: [self errorNotFound: anObject]
		ifNotNil: [:parent | parent object]!

remove: anObject ifAbsent: aNiladicValuable
	"Removes anObject from the receiver. If anObject does not exist in the tree then answer the
	result of evaluating the <niladicValuable> argument, otherwise answer anObject."

	| node parentNode |
	node := objectNodeMap lookup: anObject.
	node isNil ifTrue: [^aNiladicValuable value].
	"Inform observers before the remove (item is still a valid element of the model)"
	self trigger: #removingItem: with: anObject.
	parentNode := node parent.
	parentNode removeChildNode: node.
	self forgetNode: node.
	"Inform observers after the remove (item is no longer in the model)"
	self
		trigger: #item:removedFromParent:
		with: anObject
		with: parentNode object.
	^anObject!

reset
	"Private - Reset the receiver (remove all nodes)."

	anchorNode := self newNode: nil.
	objectNodeMap := searchPolicy newLookupTable!

rootNodes
	^self childrenOfNode: anchorNode!

roots
	"Answer the roots of the receiver's hierarchy.
	Note that the roots of the tree must always be available."

	^self rootNodes collect: [:each | each object]!

size
	"Answer the number of elements in the receiver"

	^objectNodeMap size! !

!UI.TreeModel categoriesForMethods!
add:asChildOf:!adding!public! !
add:asChildOfNode:!adding!private! !
addChild:parentNode:!adding!private! !
approxSize!accessing!private! !
asBag!converting!public! !
asSet!converting!public! !
basicRoots:!accessing!private! !
childrenOfNode:!hierarchy!private! !
clear!public!removing! !
collapse:ifAbsent:!public!removing! !
depthOf:!hierarchy!public! !
forgetChildrenOfNode:!operations!private! !
forgetNode:!operations!private! !
getChildrenOf:!hierarchy!private! !
getNodeFor:!hierarchy!private! !
hasChildren:!hierarchy!public!testing! !
includes:!hierarchy!public!searching! !
initialize!initializing!private! !
move:asChildOf:!public!updating! !
newNode:!adding!private! !
nodeClass!constants!public! !
parentNodeOf:!hierarchy!private! !
parentOf:!hierarchy!public! !
remove:ifAbsent:!public!removing! !
reset!private!removing! !
rootNodes!hierarchy!private! !
roots!hierarchy!public! !
size!accessing!public! !
!

!UI.TreeModel class methodsFor!

new
	"Answer a new empty instance of the receiver with the 
	default search policy."

	^self withRoots: #()!

stbConvertFromVersion1: anArray
	"Private - Perform an STB conversion from a version 1 <Model> to version 2.
	Version 2 added 'searchPolicy' instance variable."

	| size |
	size := anArray size + 1.
	^(Array new: size)
		replaceFrom: 1
			to: 3
			with: anArray
			startingAt: 1;
		at: 4 put: self defaultSearchPolicy;
		replaceFrom: 5
			to: size
			with: anArray
			startingAt: 4;
		yourself!

stbConvertFromVersion2: anArray
	"Private - Perform an STB conversion from a version 2 <Model> to version 3.
	Version 3 moves 'searchPolicy' instance variable (pushed up)."

	^anArray shallowCopy
		at: 1 put: (anArray at: 1);
		at: 2 put: (anArray at: 4);
		replaceFrom: 3
			to: 4
			with: anArray
			startingAt: 2;
		replaceFrom: 5
			to: anArray size
			with: anArray
			startingAt: 5;
		yourself! !

!UI.TreeModel class categoriesForMethods!
new!instance creation!public! !
stbConvertFromVersion1:!binary filing!private! !
stbConvertFromVersion2:!binary filing!private! !
!

