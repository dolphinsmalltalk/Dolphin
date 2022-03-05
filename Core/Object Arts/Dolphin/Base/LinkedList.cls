"Filed out from Dolphin Smalltalk"!

SequencedGrowableCollection subclass: #LinkedList
	instanceVariableNames: 'firstLink lastLink'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
LinkedList guid: (GUID fromString: '{87b4c521-026e-11d3-9fd7-00a0cc3e4a32}')!
LinkedList comment: 'LinkedList is a class of <SequencedGrowableCollection> which is sequenced, ordered, contractible, expandable, readable and  writeable. The implementation is as an intrusively, singly, linked list (i.e. the elements hold the pointer to the next element), and requires that the elements of a LinkedList must be a kind of <Link> (or support the same protocol).

N.B. LinkedList is primarily present as an implementation artifact. The fact that it expects its elements to hold the makes it of limited use, since, unlike other SequenceableCollections, it cannot hold any type of object, and each element can only every exist in one linked list.

Instance Variables:
	firstLink		<Link>. Head of the list.
	lastList		<Link>. Tail of the list.'!
!LinkedList categoriesForClass!Collections-Sequenceable! !
!LinkedList methodsFor!

addFirst: aLink
	"Add aLink at the head of the list; answer aLink."

	self isEmpty ifTrue: [lastLink := aLink].
	aLink nextLink: firstLink.
	^firstLink := aLink!

addLast: aLink
	"Add aLink at then end of the list; answer aLink."

	self isEmpty 
		ifTrue: [firstLink := aLink]
		ifFalse: [lastLink nextLink: aLink].
	lastLink := aLink.
	^aLink!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: The size of LinkedLists must be calculated (no tally
	is kept), which is expensive, so we revert to the basic collection
	implementation."

	^2!

at: index
	"Answer the element that is the index'th Link of the linked list."

	| i aLink |
	i := 1.
	aLink := firstLink.
	[aLink isNil] whileFalse: [
		i = index ifTrue: [^aLink].
		i := i + 1.
		aLink := aLink nextLink].
	^self errorSubscriptBounds: index
!

at: index put: anObject
	"Store anObject as the index'th element of the receiver.
	Not supported by LinkedLists at present."

	^self shouldNotImplement!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the elements of the 
	receiver. Answers the receiver."

	| aLink |
	aLink := firstLink.
	[aLink isNil] whileFalse: [ 
		operation value: aLink.
		aLink := aLink nextLink]!

isEmpty
	"Answer whether the receiver contains no elements. 
	Implemenation Note: Override superclass to provide a more efficient implementation."

	^firstLink isNil
!

remove: oldElement ifAbsent: exceptionHandler 
	"Remove oldElement from the list and answer it, or evaluate the niladic
	valuable exceptionHandler if it's not found in the list.
	Implemenation Note: We use identity comparison, because the Links
	of a list are unique (necessitated by the 'intrusive' implementation)."

	oldElement == firstLink 
		ifTrue: 
			[firstLink := firstLink nextLink.
			firstLink isNil ifTrue: [lastLink := nil]]
		ifFalse: 
			[| currLink |
			currLink := firstLink.
			
			[currLink isNil ifTrue: [^exceptionHandler value].
			currLink nextLink == oldElement] 
					whileFalse: [currLink := currLink nextLink].
			currLink nextLink: oldElement nextLink.
			oldElement == lastLink ifTrue: [lastLink := currLink]].
	oldElement nextLink: nil.
	^oldElement

	" A slightly neater, but slower (because of the need to use two locals), implementation"
	"	| currLink prevLink |
	currLink := firstLink.
	[ currLink isNil ifTrue: [ ^exceptionHandler value ]. currLink == oldElement ] whileFalse: [
		prevLink := currLink.
		currLink := currLink nextLink ].
	currLink == firstLink 
		ifTrue: [ firstLink := currLink nextLink ]
		ifFalse: [ prevLink nextLink: currLink nextLink ].
	currLink == lastLink ifTrue: [ lastLink := prevLink ].
	oldElement nextLink: nil.
	^oldElement"!

removeAll
	"Empty the receiver of all contents"

	firstLink := lastLink := nil!

removeAllSuchThat: aBlock 
	"Evaluate aBlock for each element and remove all that elements from the receiver for that
	aBlock evaluates to true. For LinkedLists, it's safe to use do:."

	self do: [:each | (aBlock value: each) ifTrue: [self remove: each]]!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise an BoundsError if there is no element with that index."

	| currLink prevLink i |
	index < 1 ifTrue: [^self errorSubscriptBounds: index].
	currLink := firstLink.
	i := 1.
	[currLink isNil ifTrue: [^self errorSubscriptBounds: index]. 	"ran off the end"
	 i = index] whileFalse: [
		i := i + 1.
		prevLink := currLink.
		currLink := currLink nextLink ].
	currLink == firstLink 
		ifTrue: [firstLink := currLink nextLink]
		ifFalse: [prevLink nextLink: currLink nextLink].
	currLink == lastLink ifTrue: [lastLink := prevLink].
	currLink nextLink: nil.
	^currLink!

removeFirstIfAbsent: exceptionHandler
	"Remove and answer the first element of the receiver, but if the
	receiver is empty answer the result of evaluating the niladic valuable,
	exceptionHandler."

	| aLink |
	self isEmpty ifTrue: [^exceptionHandler value].
	aLink := firstLink.
	firstLink == lastLink
		ifTrue: [firstLink := nil. lastLink := nil]
		ifFalse: [firstLink := aLink nextLink].
	aLink nextLink: nil.
	^aLink
!

removeLastIfAbsent: exceptionHandler 
	"Remove and answer the last element of the receiver, but if the
	receiver is empty answer the result of evaluating the niladic valuable,
	exceptionHandler."

	| aLink |
	self isEmpty ifTrue: [^exceptionHandler value].
	aLink := lastLink.
	firstLink == lastLink 
		ifTrue: 
			[firstLink := nil.
			lastLink := nil]
		ifFalse: 
			["The list is singly linked, so we must iterate through it"

			| temp |
			temp := firstLink.
			[temp nextLink == lastLink] whileFalse: [temp := temp nextLink].
			temp nextLink: nil.
			lastLink := temp].
	^aLink! !
!LinkedList categoriesForMethods!
addFirst:!adding!public! !
addLast:!adding!public! !
approxSize!accessing!private! !
at:!accessing!public! !
at:put:!accessing!public! !
do:!enumerating!public! !
isEmpty!public!testing! !
remove:ifAbsent:!public!removing! !
removeAll!public!removing! !
removeAllSuchThat:!public!removing! !
removeAtIndex:!public!removing! !
removeFirstIfAbsent:!public!removing! !
removeLastIfAbsent:!public!removing! !
!

