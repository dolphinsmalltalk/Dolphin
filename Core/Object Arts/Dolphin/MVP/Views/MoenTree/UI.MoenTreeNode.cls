"Filed out from Dolphin Smalltalk"!

Core.Object
	subclass: #'UI.MoenTreeNode'
	instanceVariableNames: 'object contour offset position parent child sibling clip extent flags'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: { 'ExpandedMask' -> 16r1. 'HasExpandedMask' -> 16r2 }!
UI.MoenTreeNode guid: (Core.GUID fromString: '{63ce49d1-2faf-11d3-93ba-00a024ca708a}')!
UI.MoenTreeNode comment: 'MoenTreeNode is a private helper class which is part of the implementation of the <MoenTreeView>.

Each node in a MoenTreeView is represented by an instance of this class.

Instance Variables:

	object		<Object>. Element stored at this node.
	contour		<MoenContour>
	offset		<Point>
	position		<Point>
	parent 		<MoenTreeNode>. Pointer up to parent. nil if a root.
	child 		<MoenTreeNode>. Pointer to first child. nil if no children.
	sibling 		<MoenTreeNode>. Pointer to next sibling. nil if no next sibling.
	clip		<Rectangle>. Clipping rectangle for this node.
	extent		<Point>. Height and width of this node.
	flags		<integer>. Various flags.

Class Variables:
	ExpandedMask	<integer>. Bit mask for setting/testing ''expanded'' flag
	HasExpandedMask	<integer>. Bit mask for setting/testing ''hasExpanded'' flag.
'!
!UI.MoenTreeNode categoriesForClass!MVP-Views-Support! !
!UI.MoenTreeNode methodsFor!

buttonRectangle
	"Private - Answer the rectangle occupied by the expand/contract button which
	is outside the normal client area of the receiver."

	| pels |
	pels := self buttonSize.
	^self rectangle rightCenter + (1 @ (pels // 2 - pels)) extent: pels @ pels!

buttonSize
	^9!

calculateClipRect
	"Private - Calculate, cache, and answer the receiver's clipping rectangle.
	The clipping rectangle is that area which precisely contains the receiver
	and all its _visible_ children."

	| rect |
	rect := self position extent: self extent + (self buttonSize@0).
	self visibleChildrenDo: [:each | rect := rect merge: each calculateClipRect].
	self clip: rect.
	^rect

!

child
	"Private - Answer the value of the receiver's 'child' instance variable."

	^child!

child: anObject
	"Private - Set the value of the receiver's 'child' instance variable to the argument, anObject."

	child := anObject!

children
	"This is a debugging method and is not used by the MoenTreeView implementation itself."

	| answer |
	answer := OrderedCollection new.
	self childrenDo: [:each | answer add: each].
	^answer!

childrenDo: operation
	"Private - Evaluate the <monadicValue> argument, operation, against each 
	of the receiver's immediate child nodes."

	| each |
	each := self child.
	[each notNil] whileTrue: 
			[operation value: each.
			each := each sibling]!

clip
	"Private - Answer the value of the receiver's 'clip' instance variable."

	^clip!

clip: aRectangle
	clip := aRectangle!

contour
	"Private - Answer the value of the receiver's 'contour' instance variable."

	^contour!

contour: anObject
	"Private - Set the value of the receiver's 'contour' instance variable to the argument, anObject."

	contour := anObject!

endOrderDo: operation 
	"Private - Evaluate monadic value argument, operation, for each of the nodes
	beneath the receiver, and then for the receiver (i.e. an 'end-order' traversal).
	Answer the result of the evaluation against the receiver."

	| each |
	each := self child.
	[each notNil] whileTrue: 
			[operation value: each.
			each := each sibling].
	^operation value: self!

extent
	^extent!

extent: aPoint
	extent := aPoint!

hasExpanded
	^flags allMask: HasExpandedMask!

hasExpanded: aBoolean 
	flags := flags mask: HasExpandedMask set: aBoolean!

hasVisibleChildren
	^child notNil and: [self isExpanded]!

isChild: aMoenTreeNode 
	"Private - Answer whether the <MoenTreeNode> argument is a direct or indirect child of the receiver."

	| each |
	each := aMoenTreeNode parent.
	[each notNil] whileTrue: [each == self ifTrue: [^true]. each := each parent].
	^false!

isExpanded
	^flags allMask: ExpandedMask!

isExpanded: aBoolean 
	flags := flags mask: ExpandedMask set: aBoolean!

isVisible
	"Private - Answer whether the receiver is in a visible part of the tree.
	Note that this doesn't mean that the node is actually visible on screen,
	just that it would be visible if within the viewable part of the window."

	^parent isNil or: [parent isExpanded and: [parent isVisible]]!

keyAtEqualValue: anObject ifAbsent: exceptionHandler 
	"Answer the name of the argument, anObject. If there is no such value, answer
	the result of evaluating the niladic valuable, exceptionHandler.
	Equality is used for comparison of the values. 
	Implementation Note: This message is sent to the receiver if an <EqualitySearchPolicy>
	 is installed in the owning MoenTreeView's model."

	self preOrderDo: [:each | anObject = each object ifTrue: [^each]].
	^exceptionHandler value!

keyAtValue: anObject ifAbsent: operation 
	"Answer the <MoenTreeNode> in the receiver who's associated element
	is the <Object> argument.  If there is no such value, answer the result of 
	evaluating the  <niladicValuable>, operation. Identity is used for comparison 
	of the values.
	Implementation Note: This message is sent to the receiver if an <IdentitySearchPolicy>
	is installed in the owning MoenTreeView's model"

	self preOrderDo: [:each | anObject == each object ifTrue: [^each]].
	^operation value!

keysAndValuesDo: operation
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver 
	where the 'keys' are the nodes, and the 'values' are the objects stored in the nodes.
	The order is as defined by a pre-order traversal.
	Implementation Note: This message is sent to the receiver if a <SearchPolicy>
	is installed in the owning MoenTreeView's model"

	self preOrderDo: [:each | operation value: each value: each object]!

object
	"Private - Answer the <Object> which is the element stored in this node."

	^object!

offset
	^offset!

offset: aPoint
	offset := aPoint!

parent
	"Private - Answer the <MoenTreeNode> which is the receiver's parent node."

	^parent!

parent: aMoenTreeNode
	parent := aMoenTreeNode!

position
	^position!

position: aPoint
	position := aPoint!

preOrderDo: operation 
	"Private - Evaluate the <monadicValue> argument, operation, against the receiver
	and then against each of its children (i.e. a 'pre-order' or 'depth-first' traversal)."

	| each |
	operation value: self.
	each := self child.
	[each notNil] whileTrue: 
			[each preOrderDo: operation.
			each := each sibling]!

printOn: aStream
	"Append a textual representation of the receiver to the <puttableStream> argument
	as a developer might want to see it."

	aStream 
		basicPrint: self;
		nextPut: $(;
		print: self object;
		nextPut: $)!

rectangle
	"Private - Answer the rectangle covered by the receiver's label and image."

	^position extent: extent!

setObject: anObject parent: aMoenTreeNode
	"Private - Initialize the receiver's instance variables."

	contour := MoenContour new.
	offset := position := 0 @ 0.
	object := anObject.
	parent := aMoenTreeNode.
	flags := 0.
	^self!

sibling
	"Private - Answer the <MoenTreeNode> which is the receiver's next sibling."

	^sibling!

sibling: aMoenTreeNode
	sibling := aMoenTreeNode!

visibleChildrenDo: operation
	"Private - Evaluate the <monadicValue> argument, operation, against each 
	of the receiver's immediate, visible, child nodes."

	self isExpanded ifTrue: [self childrenDo: operation]!

visiblePreOrderDo: operation 
	"Private - Evaluate the <monadicValue> argument, operation, against the receiver
	and then against each of its visible children (i.e. a 'pre-order' or 'depth-first' traversal)."

	operation value: self.
	self visibleChildrenDo: [:each | each visiblePreOrderDo: operation]! !
!UI.MoenTreeNode categoriesForMethods!
buttonRectangle!accessing!private! !
buttonSize!constants!private! !
calculateClipRect!geometry!private! !
child!accessing!private! !
child:!accessing!private! !
children!enumerating!private! !
childrenDo:!enumerating!private! !
clip!accessing!private! !
clip:!accessing!private! !
contour!accessing!private! !
contour:!accessing!private! !
endOrderDo:!enumerating!private! !
extent!accessing!private! !
extent:!accessing!private! !
hasExpanded!private!testing! !
hasExpanded:!accessing!private! !
hasVisibleChildren!private!testing! !
isChild:!accessing!private! !
isExpanded!private!testing! !
isExpanded:!accessing!private! !
isVisible!private!testing! !
keyAtEqualValue:ifAbsent:!accessing!private! !
keyAtValue:ifAbsent:!accessing!private! !
keysAndValuesDo:!enumerating!private! !
object!accessing!private! !
offset!accessing!private! !
offset:!accessing!private! !
parent!accessing!private! !
parent:!accessing!private! !
position!accessing!private! !
position:!accessing!private! !
preOrderDo:!enumerating!private! !
printOn:!development!printing!public! !
rectangle!accessing!private! !
setObject:parent:!initializing!private! !
sibling!accessing!private! !
sibling:!accessing!private! !
visibleChildrenDo:!enumerating!private! !
visiblePreOrderDo:!enumerating!private! !
!

!UI.MoenTreeNode class methodsFor!

new
	"Use #object:parent: to create nodes"

	^self shouldNotImplement!

object: anObject parent: aMoenTreeNode
	^self basicNew setObject: anObject parent: aMoenTreeNode! !
!UI.MoenTreeNode class categoriesForMethods!
new!instance creation!public! !
object:parent:!instance creation!public! !
!

