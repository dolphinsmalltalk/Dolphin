"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection
	subclass: #'Core.SequencedGrowableCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.SequencedGrowableCollection guid: (Core.GUID fromString: '{87b4c50f-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.SequencedGrowableCollection isNonInstantiable: true!

Core.SequencedGrowableCollection comment: 'SequencedGrowableCollection is the abstract class of sequenceable, contractible, and extensible collections.

SequencedGrowableCollections comply with the ANSI protocols:
	Object
	collection
	extensibleCollection
	sequencedReadableCollection
	sequencedContractibleCollection
	sequencedCollection
	sequencedExtensibleCollection'!

!Core.SequencedGrowableCollection categoriesForClass!Collections-Sequenceable! !

!Core.SequencedGrowableCollection methodsFor!

add: newElement
	"Append, and answer, newElement as the last element of the receiver."

	^self addLast: newElement!

add: newElement after: target
	"Insert newElement as a new element of the receiver immediately after target. 
	Raise an exception if target is not present in the receiver. Answer newElement."

	^self add: newElement afterIndex: 
		(self indexOf: target ifAbsent: [self errorNotFound: target])!

add: anObject afterIndex: anInteger
	"Add the <Object> first argument to the receiver immediately after the element currently at the specified <integer> index. The index must be between 0 and the receiver's current size (if not raise an exception). Answer the new element."

	^self subclassResponsibility!

add: newElement before: target
	"Insert newElement as a new element of the receiver immediately before target. 
	Report an error if target is not present in the receiver. Answer newElement."

	^self add: newElement beforeIndex: 
		(self indexOf: target ifAbsent: [self errorNotFound: target])!

add: newElement beforeIndex: index
	"Add newElement to the receiver immediately before the element currently at the specified
	<integer> index (i.e. the newElement will then have that index). index must be between 1 
	and the receiver's current size plus 1 (if not raise an exception). Answer newElement."

	^self add: newElement afterIndex: index - 1!

addAll: aCollection
	"Include all the elements of the <collection> argument as the receiver's elements. 
	Answer the argument. Note that this modifies and answers the receiver, not a copy."

	^self addAllLast: aCollection!

addAll: newElements after: target
	"Insert the elements of the collection, newElements, as new elements of the receiver
	immediately after target. Answer the newly added elements. Raise an exception if target is
	not present in the receiver.
	Implementation Note: We could use reverseDo: to avoid having to keep updating the index,
	but not all Collections understand #reverseDo: because they are not all ordered."

	| index |
	index := self indexOf: target ifAbsent: [self errorNotFound: target].
	^self addAll: newElements afterIndex: index!

addAll: newElements afterIndex: index
	"Add all of the elements in the <collection>, newElements, after the existing element of
	the receiver at the one-based <integer> index, index. Answer the newly added elements."

	newElements inject: index into: [:i :e | self add: e afterIndex: i. i + 1].
	^newElements!

addAll: newElements before: target
	"Insert the elements of the collection, newElements, as a new element of the receiver
	immediately before target. Answer the newly added elements. Report an error if target is not
	present in the receiver."

	| index |
	index := self indexOf: target ifAbsent: [self errorNotFound: target].
	^self addAll: newElements beforeIndex: index!

addAll: newElements beforeIndex: index
	"Add all of the elements in the <collection>, newElements, before the existing element of
	the receiver at the one-based <integer> index, index. Answer the newly added elements."

	^self addAll: newElements afterIndex: index-1!

addAllFirst: aCollection
	"Prepend all elements of the <collection> argument to the receiver, in the order that they appear in the argument, as determined by its implementation of #do:. Answer the new elements.
	Note that the ANSI standard specifies that newElements must comply with <sequencedCollection>, but we relax this to <collection> since this is implementable purely in terms of #do: (or #inject:into: as here).."

	"Implementation Note: Avoid #reverseDo:, as not understood by all collections."

	aCollection inject: 0
		into: 
			[:i :e |
			self add: e afterIndex: i.
			i + 1].
	^aCollection!

addAllLast: aCollection
	"Append the elements of the <collection> argument to the receiver, in the order that they appear in that collection (as defined by its implementation of #do:). Answer the collection."

	aCollection do: [:each | self addLast: each].
	^aCollection!

addFirst: newElement
	"Insert newElement as the first element of the receiver."

	^self add: newElement afterIndex: 0
!

addLast: newElement
	"Insert newElement as the last element of the receiver."

	^self add: newElement afterIndex: self size!

remove: oldElement ifAbsent: exceptionHandler
	"Remove the first occurrence of the <Object> oldElement from the receiver, and answer it. If
	oldElement is not present in the receiver, answer the result of evaluating the
	<niladicValuable>, exceptionHandler."

	| index |
	^(index := self indexOf: oldElement) == 0
		ifTrue: [exceptionHandler value]
		ifFalse: [self removeAtIndex: index]!

removeAll
	"Empty the receiver of all contents"

	^self subclassResponsibility!

removeAtIndex: index
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise a <BoundsError> if there is no element with that index."

	^self subclassResponsibility!

removeFirst
	"Remove and answer the first element of the receiver, 
	raising an exception if the receiver is empty."

	^self removeFirstIfAbsent: [self errorSubscriptBounds: 1]!

removeFirstIfAbsent: exceptionHandler
	"Remove and answer the first element of the receiver, but if the
	receiver is empty answer the result of evaluating the <niladicValuable>,
	exceptionHandler."

	self isEmpty ifTrue: [^exceptionHandler value].
	^self removeAtIndex: 1!

removeLast
	"Remove and answer the last element of the receiver, 
	raising an exception if the receiver is empty."

	^self removeLastIfAbsent: [self errorSubscriptBounds: 1]!

removeLastIfAbsent: exceptionHandler
	"Remove and answer the last element of the receiver, but if the
	receiver is empty answer the result of evaluating the <niladicValuable>,
	exceptionHandler."

	self isEmpty ifTrue: [^exceptionHandler value].
	^self removeAtIndex: self size! !

!Core.SequencedGrowableCollection categoriesForMethods!
add:!adding!public! !
add:after:!adding!public! !
add:afterIndex:!adding!public! !
add:before:!adding!public! !
add:beforeIndex:!adding!public! !
addAll:!adding!public! !
addAll:after:!adding!public! !
addAll:afterIndex:!adding!public! !
addAll:before:!adding!public! !
addAll:beforeIndex:!adding!public! !
addAllFirst:!adding!public! !
addAllLast:!adding!public! !
addFirst:!adding!public! !
addLast:!adding!public! !
remove:ifAbsent:!public!removing! !
removeAll!public!removing! !
removeAtIndex:!public!removing! !
removeFirst!public!removing! !
removeFirstIfAbsent:!public!removing! !
removeLast!public!removing! !
removeLastIfAbsent:!public!removing! !
!

Core.SequencedGrowableCollection methodProtocol: #OrderedCollection attributes: #(#ansi #readOnly) selectors: #(#, #add: #add:after: #add:afterIndex: #add:before: #add:beforeIndex: #addAll: #addAll:after: #addAll:afterIndex: #addAll:before: #addAll:beforeIndex: #addAllFirst: #addAllLast: #addFirst: #addLast: #after: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #at: #at:ifAbsent: #at:put: #atAll:put: #atAllPut: #before: #collect: #copyFrom:to: #copyReplaceAll:with: #copyReplaceFrom:to:with: #copyReplaceFrom:to:withObject: #copyReplacing:withObject: #copyWith: #copyWithout: #detect: #detect:ifNone: #do: #do:separatedBy: #findFirst: #findLast: #first #from:to:do: #from:to:keysAndValuesDo: #includes: #indexOf: #indexOf:ifAbsent: #indexOfSubCollection:startingAt: #indexOfSubCollection:startingAt:ifAbsent: #inject:into: #isEmpty #keysAndValuesDo: #last #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #removeAtIndex: #removeFirst #removeLast #replaceFrom:to:with: #replaceFrom:to:with:startingAt: #replaceFrom:to:withObject: #reverse #reverseDo: #select: #size #with:do:)!
Core.SequencedGrowableCollection methodProtocol: #sequencedContractibleCollection attributes: #(#ansi #readOnly) selectors: #(#allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #removeAtIndex: #removeFirst #removeLast #select: #size)!

Core.SequencedGrowableCollection class methodProtocol: #'OrderedCollection factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

