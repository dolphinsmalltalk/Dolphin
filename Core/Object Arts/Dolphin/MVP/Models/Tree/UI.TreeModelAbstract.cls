"Filed out from Dolphin Smalltalk"!

Core.Model
	subclass: #'UI.TreeModelAbstract'
	instanceVariableNames: 'searchPolicy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
UI.TreeModelAbstract guid: (Core.GUID fromString: '{87b4c66d-026e-11d3-9fd7-00a0cc3e4a32}')!
UI.TreeModelAbstract isNonInstantiable: true!
UI.TreeModelAbstract comment: 'TreeModelAbstract is the abstract superclass for classes implementing the <treeModel> protocol. All of the manipulations that modify  the underlying tree structure will trigger notification events such that Observers will be informed of the changes. The <treeModel> protocol defines the following events:

#treeChanged:
#item:addedInParent:
#item:movedToParent:
#item:removedFromParent:
#itemUpdated:

Instance Variables:
	searchPolicy		Pluggable <searchPolicy> used for comparing objects against those in the tree.

'!
!UI.TreeModelAbstract categoriesForClass!MVP-Models! !
!UI.TreeModelAbstract methodsFor!

add: leaf asChildOf: branch
	"Adds the <Object>, leaf, to the receiver as a child of the <Object>,
	branch. If branch is nil then leaf is added as a root of the tree.
	Answer leaf, or the existing leaf if already present."

	^self subclassResponsibility!

addRoot: anObject
	^self add: anObject asChildOf: nil!

allParentsOf: anObject 
	"Answer the an OrderedCollection of all the parents of anObject 
	within the hierarchy managed by the receiver. The collection is
	ordered oldest ancestor first (i.e. the immediate parent is last).
	If anObject is a root of the hierarchy then answer an empty collection. 
	If anObject does not exist in the receiver then raise a suitable exception."

	| parent |
	parent := self parentOf: anObject.
	^parent isNil 
		ifTrue: [OrderedCollection new: 16]
		ifFalse: 
			[(self allParentsOf: parent)
				addLast: parent;
				yourself]!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: This does not have to be accurate, but it should be fast
	(i.e. don't calculate it by counting the receiver's elements).
	The default is to guess at 8. Subclasses which can give a more
	accurate size quickly will get better conversion performance."

	^8!

asArray
	"Answer an Array whose elements are those of the receiver.
	(ordering is that of the #do: operation as implemented by the receiver)."

	| stream |
	stream := Array writeStream: self approxSize.
	self do: [:e | stream nextPut: e].
	^stream grabContents!

asBag
	"Answer a Bag whose elements are those stored in the receiver"

	^(Bag new: self size)
		addAll: self;
		yourself!

asOrderedCollection
	"Answer an <OrderedCollection> whose elements are those of the receiver
	(ordering is that of the #do: operation as implemented by the receiver).
	Implementation Note: Avoid OrderedCollection>>addAll:, because
	it sends (indirectly) #size, which is slow to calculate."

	| answer |
	answer := OrderedCollection new: self approxSize.
	self do: [:each | answer addLast: each].
	^answer!

asSet
	"Answer a Set whose elements are those stored in the receiver (any duplicates are therefore 
	eliminated)."

	^(Set new: self approxSize)
		addAll: self;
		yourself!

asSortedCollection
	"Answer a SortedCollection whose elements are those of the receiver, sorted so that each 
	element is less than or equal to (<=) its successors. The elements must understand #<=."

	^(SortedCollection new: self approxSize)
		addAll: self;
		yourself!

asSortedCollection: discriminator
	"Answer a SortedCollection whose elements are those of the receiver, sorted according to 
	the argument dynadic valuable argument, discriminator.
	Note: The discriminator does not need to be a BlockClosure, it must simply
	understand the #value:value: message from the dyadic valuable protocol."

	^(SortedCollection new: self approxSize)
		sortBlock: discriminator;
		addAll: self;
		yourself!

basicRoots: aCollection
	"Private - Set the roots of the receiver's hierarchy to be
	the elements of the <collection> argument, added in that
	collections #do: order."

	^self subclassResponsibility!

childrenOf: anObject
	"Answer an <OrderedCollection> of the children of anObject within 
	the hierarchy managed by the receiver. If anObject is nil then answer
	the roots. If anObject does not exist in the receiver then raise a suitable 
	exception."

	^anObject isNil
		ifTrue: [self roots]
		ifFalse: [self getChildrenOf: anObject]!

clear
	"Clear the receiver (remove all nodes)."

	^self subclassResponsibility!

collapse: anObject
	"Removes the sub-trees beneath anObject in the receiver. If anObject does not exist
	in the tree then raise a suitable exception."

	^self collapse: anObject ifAbsent: [self errorNotFound: anObject]!

collapse: anObject ifAbsent: exceptionHandler
	"Removes the sub-trees beneath anObject in the receiver. If anObject does not 
	exist in the tree then answer the result of evaluating the <niladicValuable>, 
	exceptionHandler, otherwise answer anObject."

	^self subclassResponsibility!

countElements
	"Private - Count, and answer, the number of elements in the receiver.
	Implementation Note: Could be implemented more elegantly with #inject:into:, but
	this implementation is about twice as fast."

	| tally |
	tally := 0.
	self do: [ :each | tally := tally + 1].
	^tally!

depthOf: anObject
	"Answer the depth of anObject in the tree. Roots are at depth 0, and then immediate children at depth 1, and so on."

	| answer current |
	answer := 0.
	current := anObject.
	[(current := self parentOf: current) notNil] whileTrue: [answer := answer + 1].
	^answer!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler.
	Implementation Note: It is important for Shared subclasses that the exceptionHandler is 
	not evaluated inside the enumeration in case it is a niladic block containing an explicit 
	return (we try to avoid explicit returns from critical sections, as these require an unwind)."

	self do: [:each | (discriminator value: each) ifTrue: [^each]].
	^exceptionHandler value!

do: operation
	"Evaluate monadic value argument, operation, for each of the elements of the 
	receiver. Answers the receiver. The elements are enumerated using a 'pre-order'
	or 'depth-first' traversal where the parent is visited before the children."

	^self preOrderDo: operation

	!

endOrderDo: operation
	"Evaluate monadic value argument, operation, for each of the elements of the 
	receiver. Answers the receiver. The elements are enumerated using an 'end-order'
	traversal where the parent is visited after the children."

	self roots do: [ :each |
		self endOrderDo: operation on: each ]!

endOrderDo: operation on: anObject
	"Private - Evaluate monadic value argument, operation, for each of the elements 
	beneath anObject in the receiver. Answers the receiver. The elements are enumerated 
	using a 'end-order' traversal where anObject is visited after it's children."

	(self childrenOf: anObject) do: [:each |
		self endOrderDo: operation on: each ].
	operation value: anObject.


	!

formattedPrintOn: aStream
	"Print the receiver on aStream using a depth first traversal and with hyphens to indent
	levels in the hierarchy. This can be useful for debugging purposes."

	self do: 
			[:each | 
			(self allParentsOf: each) size timesRepeat: [aStream nextPut: $-].
			each printOn: aStream.
			aStream cr]!

getChildrenOf: anObject
	"Private - Answer a <sequencedReadableCollection> of the children of anObject within the
	hierarchy managed by the receiver. If anObject does not exist in the receiver then raise a
	suitable exception."

	^self subclassResponsibility!

hasChildren: anObject
	"Answer true if anObject has children within the hierarchy managed by the receiver. If
	anObject does not exist in the receiver then raise a suitable exception. Subclasses may be
	able to provide a more efficient implementation."

	^(self childrenOf: anObject) size > 0!

includes: anObject 
	"Answer whether the argument, anObject, is one of the elements of the receiver. Uses
	the receiver's search policy for comparison."

	"Subclasses may wish to override to provide a more efficient implementation."

	| comparer |
	comparer := self searchPolicy.
	self do: [:each | (comparer compare: anObject with: each) ifTrue: [^true]].
	^false!

isEmpty
	"Answer whether the receiver contains any objects."

	^self roots isEmpty!

keyOfNode: node in: collection ifAbsent: exceptionHandler
	"Answer the 'key' of the specified <Object> node in the specified keyed collection, or the
	result of evaluating the <niladicValuable> exception handler if no match is found. This
	method is used to allow the model to determine the comparison policy used to locate elements
	in collections (e.g. equality vs. identity)."

	^self searchPolicy
		keyAtValue: node
		in: collection
		ifAbsent: exceptionHandler!

move: anObject asChildOf: aParentObject
	"Moves anObject in the receiver to be a child of aParentObject. If aParentObject is nil then
	anObject is added as a root of the tree. If anObject does not exist in the tree or
	aParentObject does not exist then raise a suitable exception. Answer anObject." 

	^self subclassResponsibility


	!

notEmpty
	"Answer whether the receiver contains any objects."

	^self isEmpty not!

parentOf: anObject
	"Answer the parent of anObject within the hierarchy managed by the receiver. If anObject is
	a root of the hierarchy then answer nil. If anObject does not exist in the receiver then
	raise a suitable exception."

	^self subclassResponsibility
!

preOrderDo: aMonadicValuable 
	"Evaluate the <monadicValuable> argument for each of the elements of the receiver. Answers
	the receiver. The elements are enumerated using a 'pre-order' or 'depth-first' traversal
	where the parent is visited before the children."

	self roots do: [:each | self preOrderDo: aMonadicValuable on: each]!

preOrderDo: aMonadicValuable on: anObject 
	aMonadicValuable value: anObject.
	(self childrenOf: anObject) do: [:each | self preOrderDo: aMonadicValuable on: each]!

refresh: anObject
	"Update anObject in the receiver because its contents have changed although its position
	in the hierarchy has not. If anObject does not exist in the tree then raise a suitable
	exception. Answer anObject."

	^self refresh: anObject ifAbsent: [self errorNotFound: anObject]!

refresh: anObject ifAbsent: exceptionHandler
	"Update anObject in the receiver because its contents have changed although its position
	in the hierarchy has not. If anObject does not exist in the tree then answer the result of
	evaluating the <niladicValuable>, exceptionHandler, otherwise answer anObject."

	(self includes: anObject) ifFalse: [^exceptionHandler value].
	self trigger: #itemUpdated: with: anObject.
	^anObject


	!

refreshTree: anObject 
	"Update the hierarchy below the argument in the receiver. If the specified object is not in
	the tree then raise a suitable exception. A nil argument implies the entire tree is to be
	refreshed. Answer anObject."

	anObject isNil ifFalse: [(self includes: anObject) ifFalse: [self errorNotFound: anObject]].
	self trigger: #treeChanged: with: anObject.
	^anObject!

remove: anObject
	"Removes anObject from the receiver. If anObject does not exist in the tree then raise a
	suitable exception. Answer anObject."

	^self remove: anObject ifAbsent: [self errorNotFound: anObject]!

remove: anObject ifAbsent: aNiladicValuable 
	"Removes anObject from the receiver. If anObject does not exist in the tree then answer the
	result of evaluating the <niladicValuable> argument, otherwise answer anObject. Note that
	two events are triggered. The first is fired before the item is actually removed from the
	model. This gives observers a chance to perform any processing that may require that the
	item still be part of the model - e.g. enumerating the children. This is particularly
	important because when a branch node is removed, no events are triggered for the removal of
	any child nodes. The second event is a notification that the item has actually been removed.
	The parent item accompanies the event as it is likely that this can no longer be queried
	from the model."

	^self subclassResponsibility!

removeAll
	"Removes all the objects in the receiver. A synonym for #clear"

	self clear

	!

removeAll: aCollection
	"Remove each element of the <collection> argument from the receiver, raising an Exception if any are not elements of the receiver. Answer the argument."

	aCollection do: [:each | self remove: each].
	^aCollection!

reset
	"Private - Reinitialize the receiver."

	^self!

roots
	"Answer the roots of the receiver's hierarchies."

	^self subclassResponsibility
!

roots: aCollection
	"Set the roots of the receiver's hierarchies to the <Collection> argument."

	self reset.
	self basicRoots: aCollection.
	self trigger: #treeChanged: with: nil.!

searchPolicy
	"Answer the <searchPolicy> used to compare and search for elements by the receiver."

	^searchPolicy!

searchPolicy: aSearchPolicy
	"Private - N.B. The searchPolicy cannot be changed after a tree has been created.
	This method is only for use during STB conversion of old instances."

	searchPolicy := aSearchPolicy!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements. Answer a new <sequencedReadableCollection> containing only those elements for which the discriminator evaluates to true. The order of the selected elements in the resulting collection will be the same as the #do: enumeration order of the tree, which by default is performed using a pre-order traversal."

	| stream |
	stream := Array writeStream: self approxSize.
	self do: [:each | (discriminator value: each) ifTrue: [stream nextPut: each]].
	^stream contents!

setRoots: aCollection
	"Private - Initialize the receiver with the roots in the <Collection> argument."

	self initialize.
	self basicRoots: aCollection!

setRoots: aCollection searchPolicy: aSearchPolicy
	"Private - Initialize the receiver with the roots in the <Collection> argument and
	the specified <SearchPolicy>."

	searchPolicy := aSearchPolicy.
	self setRoots: aCollection!

size
	"Answer the number of elements in the receiver."

	"Implementation Note: This implementation is rather inefficient, and subclasses will
	probably want to override it."

	^self countElements!

withAllChildren: anObject
	"Answer an <OrderedCollection> containing the <Object> argument (which must be in the tree
	represented by the receiver) and all of the children of that object in this tree."

	| children |
	children := OrderedCollection new: 64.
	children add: anObject.
	(self childrenOf: anObject) do: [:each |
		children addAll: (self withAllChildren: each) ].
	^children!

withAllParents: anObject 
	"Answer a new <OrderedCollection> containing the <Object> argument (which must be in the
	tree represented by the receiver) and all of the parents of that object in this tree."

	^(self allParentsOf: anObject)
		addLast: anObject;
		yourself! !
!UI.TreeModelAbstract categoriesForMethods!
add:asChildOf:!adding!public! !
addRoot:!accessing!public! !
allParentsOf:!hierarchy!public! !
approxSize!accessing!private! !
asArray!converting!public! !
asBag!converting!public! !
asOrderedCollection!converting!public! !
asSet!converting!public! !
asSortedCollection!converting!public! !
asSortedCollection:!converting!public! !
basicRoots:!accessing!private! !
childrenOf:!hierarchy!public! !
clear!public!removing! !
collapse:!public!removing! !
collapse:ifAbsent:!public!removing! !
countElements!accessing!private! !
depthOf:!hierarchy!public! !
detect:ifNone:!converting!public! !
do:!enumerating!public! !
endOrderDo:!enumerating!public! !
endOrderDo:on:!enumerating!private! !
formattedPrintOn:!development!printing!public! !
getChildrenOf:!hierarchy!private! !
hasChildren:!hierarchy!public!testing! !
includes:!hierarchy!public!searching! !
isEmpty!public!testing! !
keyOfNode:in:ifAbsent:!public!searching! !
move:asChildOf:!public!updating! !
notEmpty!public!testing! !
parentOf:!hierarchy!public! !
preOrderDo:!enumerating!public! !
preOrderDo:on:!enumerating!private! !
refresh:!public!updating! !
refresh:ifAbsent:!public!updating! !
refreshTree:!public!updating! !
remove:!public!removing! !
remove:ifAbsent:!public!removing! !
removeAll!public!removing! !
removeAll:!public!removing! !
reset!private!removing! !
roots!hierarchy!public! !
roots:!accessing!public! !
searchPolicy!accessing!public! !
searchPolicy:!initializing!private! !
select:!converting!public! !
setRoots:!initializing!private! !
setRoots:searchPolicy:!initializing!private! !
size!accessing!public! !
withAllChildren:!hierarchy!public! !
withAllParents:!hierarchy!public! !
!

UI.TreeModelAbstract methodProtocol: #treeModel attributes: #(#readOnly) selectors: #(#add:asChildOf: #addRoot: #allParentsOf: #childrenOf: #clear #do: #endOrderDo: #hasChildren: #includes: #isEmpty #move:asChildOf: #parentOf: #preOrderDo: #refresh: #refreshTree: #remove: #remove:ifAbsent: #removeAll #roots #roots: #size #withAllChildren: #withAllParents:)!

!UI.TreeModelAbstract class methodsFor!

defaultSearchPolicy
	"Answer the default <searchPolicy> used by instances of the receiver."

	^SearchPolicy identity!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Answer an instance of the receiver; instances must be initialized"

	^self withRoots: OrderedCollection new!

stbConvertFromVersion2: anArray
	"Private - Perform an STB conversion from a version 2 <TreeModelAbstract> to version 3.
	Version 3 adds 'searchPolicy' instance variable."

	| size |
	size := anArray size + 1.
	^(Array new: size)
		at: 1 put: (anArray at: 1);
		at: 2 put: self defaultSearchPolicy;
		replaceFrom: 3
			to: size
			with: anArray
			startingAt: 2;
		yourself!

stbVersion
	^3!

withRoots: aCollection 
	"Answer an instance of the receiver with the roots in aCollection"

	^self withRoots: aCollection searchPolicy: self defaultSearchPolicy!

withRoots: aCollection searchPolicy: aSearchPolicy
	"Answer an instance of the receiver with the roots in aCollection"

	^self basicNew
		setRoots: aCollection searchPolicy: aSearchPolicy! !
!UI.TreeModelAbstract class categoriesForMethods!
defaultSearchPolicy!constants!public! !
icon!constants!public! !
new!instance creation!public! !
stbConvertFromVersion2:!binary filing!private! !
stbVersion!binary filing!public! !
withRoots:!instance creation!public! !
withRoots:searchPolicy:!instance creation!public! !
!

