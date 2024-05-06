"Filed out from Dolphin Smalltalk"!

TreeNode subclass: #ProfilerTreeNode
	instanceVariableNames: 'tally time classes selectors'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ProfilerTreeNode guid: (GUID fromString: '{425d0ebd-542e-11d3-998b-d5ca2c3c1d61}')!

ProfilerTreeNode comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!

!ProfilerTreeNode categoriesForClass!IDB Goodies! !

!ProfilerTreeNode methodsFor!

addFrame: aStackFrame elapsedTime: anInteger
	"If aStackFrame is already present a child of the receiver then we just update its values
	(tally and time). If it is a new child then  we have to create an empty node and add it to 
	the tree first
	Answer the child node"

	| node |
	node := self children detect: [:eachChild | eachChild object isSameFrameAs: aStackFrame]
				ifNone: [self addChildNode: (ProfilerTreeNode for: (ProfilerFrame frame: aStackFrame))].
	node incrementTimeBy: anInteger.
	^node!

allClasses
	"Answer a Set of all the classes used by nodes between this node and the
	root of the tree. Cache the Set for improved performance (any subnodes doing
	the same thing will only need to go this far up the tree). The cache is cleared
	via clearCache when the tree is changed"

	classes isNil 
		ifTrue: 
			[classes := self parent notNil 
						ifTrue: 
							[(self parent allClasses copy)
								add: self object methodClass;
								yourself]
						ifFalse: [Set new]].
	^classes!

allParentFrames
	"Answer an OrderedCollection of all the frame objects between the receiver
	and the root node"

	| frames node |
	frames := OrderedCollection new.
	node := self.
	[node object isNil] whileFalse: 
			[frames add: node object.
			node := node parent].
	^frames!

allSelectors
	"Answer a Set of all the methods (a description is an Association containging the method 
	class and the selector name) used by nodes between this node and the root of the tree. 
	Cache the Set for improved performance (any subnodes doingthe same thing will only 	need 
	to go this far up the tree). The cache is cleared via clearCache when the tree is changed"

	selectors isNil 
		ifTrue: 
			[selectors := self parent notNil 
						ifTrue: 
							[(self parent allSelectors copy)
								add: self object selectorDescription;
								yourself]
						ifFalse: [Set new]].
	^selectors!

children
	"Answers an SortedColletion of the child nodes of the receiver
	The profiler tree looks better if the children nodes are in ip order so
	that the execution flow goes through the nodes in sequence. Subclassing seems
	the only way to order the child nodes?"

	children isNil ifTrue: [^SortedCollection sortBlock: [:a :b | a object ip <= b object ip]].
	^children!

clearCache
	"The tree is either being reused or a new set of samples are about to be added
	to it. In either case we must clear all the cached values for this node and all of its kiddies"

	classes := nil.
	selectors := nil.
	self children do: [:each | each clearCache]!

firstChild
	^self hasChildren ifTrue: [self children first]!

hasChildren
	^self children notEmpty!

incrementTimeBy: anInteger 
	"Add another sample to this node."

	tally := tally + 1.
	time := time + anInteger!

isAbove: aFloat 
	"Answers true if either of the fields isAbove aFloat (a percentage).
	This should really just check one filed, for the receivers type of tree, but this is much easier
	and should make little difference as the percentages are usually very similar"

	^tally > aFloat or: [time > aFloat]!

isChildOfFrameFor: aCompiledCode 
	"Answer true if the frame represented by this node has the same class and selector
	as aCompiledCode. If not check the parent of this node etc etc"

	self object isNil ifTrue: [^false].
	(self object doClassAndSelectorMatch: aCompiledCode) ifTrue: [^true].
	^self parent isChildOfFrameFor: aCompiledCode!

isDolphinBranch
	"Answer true is this node, and all of its children, are in the Dolphin
	package. Used to filter out the Dolphin classes in the tree"

	self object isInSystemPackage ifFalse: [^false].
	^self children allSatisfy: [:each | each isDolphinBranch]!

isParentOfFrameFor: aCompiledCode 
	"Answer true if the frame represented by this node has the same class and selector
	as aCompiledCode. If not check the children of this node etc etc. Only answers true
	if neither this node or any of its subnodes match aCompiledCode"

	(self object doClassAndSelectorMatch: aCompiledCode) ifTrue: [^true].
	^self children anySatisfy: [:each | each isParentOfFrameFor: aCompiledCode]!

object: aProfilerFrame
	"Set aFarame as the object for this node and initialize the tally and time counts"

	object := aProfilerFrame.
	tally := time := 0!

tally
	"Answer the value of the receiver's instance variable tally.
	This method was automatically generated, but may be modified."

	^tally!

time
	"Answer the value of the receiver's instance variable time.
	This method was automatically generated, but may be modified."

	^time! !

!ProfilerTreeNode categoriesForMethods!
addFrame:elapsedTime:!profiling!public! !
allClasses!operations!public! !
allParentFrames!operations!public! !
allSelectors!operations!public! !
children!accessing!public! !
clearCache!operations!public! !
firstChild!accessing!public! !
hasChildren!public!testing! !
incrementTimeBy:!operations!public! !
isAbove:!public!testing! !
isChildOfFrameFor:!public!testing! !
isDolphinBranch!public!testing! !
isParentOfFrameFor:!public!testing! !
object:!accessing!public! !
tally!accessing!public! !
time!accessing!public! !
!

