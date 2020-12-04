"Filed out from Dolphin Smalltalk 7"!

UI.TreeModelAbstract subclass: #'UI.VirtualTreeModel'
	instanceVariableNames: 'roots getChildrenBlock getParentBlock hasChildrenBlock filter'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.VirtualTreeModel guid: (Core.GUID fromString: '{87b4c670-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.VirtualTreeModel comment: 'VirtualTreeModel provides an <treeModel> interface onto a tree like data structure where the elements in the tree are always aware of their position in the hierarchy. In general, Smalltalk Collections organise objects into groups, but the objects are unaware of their grouping. In this way an object can belong to more than one Collection at a time. For a tree that follows this behaviour use a <TreeModel>. However, some objects are implicitly aware of their location within a tree hierarchy (e.g. Smalltalk classes); in such cases a VirtualTreeModel can be used to represent the structure without having to duplicate it as a hierarchy of <TreeNode>s.  

VirtualTreeModel triggers the same modification events as a standard <treeModel>. However, the methods #add:asChildOf:, #move:asChildOf: and #remove: are only used to inform the tree model of changes that have been made externally to its structure. They do not actually modify the structure, though, since the VirtualTreeModel cannot be considered as owning it elements; they simply trigger the appropriate change notifications to inform the tree''s Observers. 

The virtual tree is represented by a collection of objects that are the root of the hierarchy. Navigation around the tree is specifying by three monadic valuables; the getChildrenBlock, the getParentBlock and the hasChildrenBlock. A monadic filter valuable can also be specified to determine which of the objects in the actual hierarchy will appear in the virtual tree, though by default all objects are included.

A VirtualTreeModel tree is configured by supplying a number of root objects using the #roots aspect and also by setting number of <monadicValuable> (usually blocks) to define the structure. The following aspects are used to do this:

#getChildrenBlock	: which answers a <sequencedCollection> of children for an object in the tree.
#hasChildrenBlock	: which answers a <boolean> to quickly identify whether an object has any children (usually implemented in terms of #getChildrenBlock).
#getParentBlock		: which answer the parent of an object, or nil if it is one of the roots.

Instance Variables:
	roots				<OrderedCollection> of root objects.
	getChildrenBlock 	<monadicValuable> used to identify the children of anobject in the tree.
	getParentBlock 		<monadicValuable> used to identify the parent of an object in the tree.
	hasChildrenBlock 	<monadicValuable> used to determine whether an object has children.
	filter				<monadicValuable> used to determine whether a object should be treated as part of the tree.'!
!UI.VirtualTreeModel categoriesForClass!MVP-Models! !
!UI.VirtualTreeModel methodsFor!

add: anObject asChildOf: aParentObject 
	"Pseudo-adds anObject to the receiver as a child of aParentObject. 
	Since the tree is managed externally to the receiver we just 
	inform our dependents of the change. Answer anObject"

	"Note that we must add the root, regardless of whether it passes the filter, as it
	 is needed to maintain the structure of the tree."

	aParentObject isNil ifTrue: [roots add: anObject].
	(filter value: anObject) ifTrue: [self notifyAdded: anObject toParent: aParentObject].
	^anObject!

basicRoots: aCollection
	"Private - Set the roots of the receiver's hierarchy to be the elements of the <collection>
	argument."

	 "N.B. the root collection may be updated so to avoid having a side effect on a shared
	 object, it is copied."

	roots := aCollection asOrderedCollection.
	roots == aCollection ifTrue: [roots := roots copy]!

clear
	"Clear the receiver (remove all nodes)."

	self roots: OrderedCollection new.
!

collapse: anObject ifAbsent: exceptionHandler
	"Removes the sub-trees beneath anObject in the receiver. If anObject does not 
	exist in the tree then answer the result of evaluating the <niladicValuable>, 
	exceptionHandler, otherwise answer anObject."

	anObject isNil ifTrue: [self basicRoots: #()].
	^self refreshTree: anObject!

defaultFilterBlock
	"Answer the <monadicValuable> discriminator used by the receiver (by default) to determine
	whether an object should be included in the tree."

	^[:each | each notNil]!

defaultGetChildrenBlock
	"Answer the <monadicValuable> used by the receiver (by default) to enumerate the children of
	an object in the tree."

	^[:each | each children]!

defaultGetParentBlock
	"Answer the <monadicValuable> used by the receiver (by default) to walk up to the parent of
	an object in the tree."

	^[:each | each parent]!

defaultHasChildrenBlock
	"Answer the <monadicValuable> discriminator used by the receiver (by default) to determine
	whether an object in the tree has any children."

	"Implementation Note: The getChildrenBlock can be used to implement this generally, but
	where the external tree provides a more efficient test it should be used."

	^[:anObject | (self childrenOf: anObject) notEmpty]!

filter
	"Answers the <monadicValuable> filter block that determines which
	elements within the virtual hierachy are to be considered part of the receiver."

	^filter!

filter: aOneArgBlock
	"Answers the <monadicValuable> filter block that determines which
	elements within the virtual hierachy are to be considered part of the receiver."

	filter := aOneArgBlock.!

getChildrenBlock: aBlock
	"Set the receiver's getChildrenBlock to aBlock. The block should answer a collection of
	children of the object passed as its parameter."

	getChildrenBlock := aBlock

!

getChildrenOf: anObject
	^(getChildrenBlock value: anObject) select: filter!

getParentBlock: aBlock
	"Set the receiver's getParentBlock to aBlock. The block should answer the parent of the
	object passed as its parameter."

	getParentBlock := aBlock

!

hasChildren: anObject 
	"Answer true if anObject has children within the hierarchy represented by the receiver.
	Evaluates the hasChildrenBlock for this purpose."

	^anObject isNil 
		ifTrue: [self roots notEmpty]
		ifFalse: [(filter value: anObject) and: [hasChildrenBlock value: anObject]]!

hasChildrenBlock: aMonadicValuable 
	"Set the receiver's hasChildrenBlock to the <monadicValuable> argument, which may also be
	nil to specify the default behaviour. The valuable should answer true if there are children
	of the object passed as its parameter. If the discriminator is nil then (by default) the
	getChildrenBlock will be used and the size of the resulting collection, after passing
	through the filter, used to determine the result."

	hasChildrenBlock := aMonadicValuable ifNil: [self defaultHasChildrenBlock]!

hasRoot: anObject
	^(filter value: anObject) and: 
			[| comparer |
			comparer := self searchPolicy.
			roots anySatisfy: [:each | comparer compare: anObject with: each]]!

includes: anObject
	"Answer whether the <Object> argument is one of the elements of the receiver. Uses
	the receiver's search policy for comparison."

	"Implementation Note: An <Object> is considered to be a member of a virtual tree if it
	passes the filter and its ultimate root is in the tree."

	^(filter value: anObject) and: 
			[| parents |
			parents := self allParentsOf: anObject.
			parents isEmpty or: [self hasRoot: parents first]]!

initialize
	"Private - Initialize some instance variables to defaults."

	getParentBlock := self defaultGetParentBlock.
	getChildrenBlock := self defaultGetChildrenBlock.
	filter := self defaultFilterBlock.
	self hasChildrenBlock: nil!

move: anObject asChildOf: aParentObject 
	"Pseudo-moves anObject in the receiver to be a child of aParentObject. Since the tree is
	mainly managed externally to the receiver, this usually involves nothing more than informing
	our dependents of the change. The exception is where an object is being promoted to a root,
	or conversely being demoted from a root, in which case the roots collection needs to be
	maintained."

	aParentObject isNil 
		ifTrue: 
			["Might have been promoted to root - if not one already"
			(roots includes: anObject) ifFalse: [roots add: anObject]]
		ifFalse: 
			["Might have been demoted from being a root"
			roots remove: anObject ifAbsent: []].
	(filter value: anObject) 
		ifTrue: 
			[self 
				trigger: #item:movedToParent:
				with: anObject
				with: aParentObject].
	^anObject!

notifyAdded: anObject toParent: parentObject 
	self 
		trigger: #item:addedInParent:
		with: anObject
		with: parentObject!

notifyRemove: anObject around: aBlock 
	| parent |
	parent := self parentOf: anObject.
	self trigger: #removingItem: with: anObject.
	aBlock value.
	self 
		trigger: #item:removedFromParent:
		with: anObject
		with: parent.
	^parent!

parentOf: anObject
	"Answer the parent of anObject within the hierarchy represented by the
	receiver. If anObject is a root of the hierarchy then answer nil.
	The getParentBlock is evaluated for this purpose"

	((self hasRoot: anObject) or: [anObject isNil]) ifTrue: [^nil].
	^getParentBlock value: anObject!

remove: anObject ifAbsent: aNiladicValuable 
	"Removes anObject from the receiver. If anObject does not exist in the tree then answer the
	result of evaluating the <niladicValuable> argument, otherwise answer anObject."

	"Implementation Note: Since the tree is managed externally to the receiver we just inform
	our dependents of the change, unless the object is a root in which case we must remove
	it from the roots collection."

	self notifyRemove: anObject around: [roots remove: anObject ifAbsent: []].
	^anObject!

roots
	"Answer the roots of the receiver's hierarchies."

	^roots select: filter! !
!UI.VirtualTreeModel categoriesFor: #add:asChildOf:!adding!public! !
!UI.VirtualTreeModel categoriesFor: #basicRoots:!accessing!private! !
!UI.VirtualTreeModel categoriesFor: #clear!public!removing! !
!UI.VirtualTreeModel categoriesFor: #collapse:ifAbsent:!public!removing! !
!UI.VirtualTreeModel categoriesFor: #defaultFilterBlock!constants!private! !
!UI.VirtualTreeModel categoriesFor: #defaultGetChildrenBlock!constants!private! !
!UI.VirtualTreeModel categoriesFor: #defaultGetParentBlock!constants!private! !
!UI.VirtualTreeModel categoriesFor: #defaultHasChildrenBlock!constants!private! !
!UI.VirtualTreeModel categoriesFor: #filter!accessing!public! !
!UI.VirtualTreeModel categoriesFor: #filter:!accessing!public! !
!UI.VirtualTreeModel categoriesFor: #getChildrenBlock:!adapters!public! !
!UI.VirtualTreeModel categoriesFor: #getChildrenOf:!hierarchy!private! !
!UI.VirtualTreeModel categoriesFor: #getParentBlock:!adapters!public! !
!UI.VirtualTreeModel categoriesFor: #hasChildren:!hierarchy!public!testing! !
!UI.VirtualTreeModel categoriesFor: #hasChildrenBlock:!adapters!public! !
!UI.VirtualTreeModel categoriesFor: #hasRoot:!hierarchy!public!testing! !
!UI.VirtualTreeModel categoriesFor: #includes:!hierarchy!public!searching! !
!UI.VirtualTreeModel categoriesFor: #initialize!initializing!private! !
!UI.VirtualTreeModel categoriesFor: #move:asChildOf:!public!updating! !
!UI.VirtualTreeModel categoriesFor: #notifyAdded:toParent:!events!private! !
!UI.VirtualTreeModel categoriesFor: #notifyRemove:around:!events!private! !
!UI.VirtualTreeModel categoriesFor: #parentOf:!hierarchy!public! !
!UI.VirtualTreeModel categoriesFor: #remove:ifAbsent:!public!removing! !
!UI.VirtualTreeModel categoriesFor: #roots!accessing!public! !

