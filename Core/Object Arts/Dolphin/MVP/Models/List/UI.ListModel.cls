﻿"Filed out from Dolphin Smalltalk"!

Core.SequencedGrowableCollection
	subclass: #'UI.ListModel'
	instanceVariableNames: 'list events searchPolicy'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

UI.ListModel guid: (Core.GUID fromString: '{87b4c522-026e-11d3-9fd7-00a0cc3e4a32}')!

UI.ListModel comment: 'ListModel implements the <listModel> protocol for identity based <sequencedCollecion>s. All of the manipulations that modify the list will trigger notification events such that Observers will be informed of the changes. The <listModel> protocol defines the following events:

#listChanged
#item:addedAtIndex:
#itemRemovedAtIndex:
#itemUpdatedAtIndex:

ListModel now uses a configurable policy to locate its elements, which means that EqualityListModel is redundant and should no longer be used.

Instance Variables:
	list		<sequencedCollection> which is the underlying list being managed.
	events		<EventsCollection>  holding the model''s event registrations.
	searchPolicy	<searchPolicy>. Policy used to search the receiver''s collection for elements.



'!

!UI.ListModel categoriesForClass!Collections-Sequenceable!MVP-Models! !

!UI.ListModel methodsFor!

add: newElement
	"Add newElement as a new element of the receiver. Answers newElement."

	self addAnsweringIndex: newElement.
	^newElement!

add: newElement afterIndex: index
	"Add newElement to the receiver immediately after the element currently at the
	specified index. index must be between 0 and the receiver's current 
	size (if not raise an exception). Answer newElement."

	self list add: newElement afterIndex: index.
	self trigger: #item:addedAtIndex: with: newElement with: index+1.
	^newElement!

addAll: newElements
	"Include all the elements of the <collection> argument, newElements, as the receiver's elements. 
	Answer newElements. This implementation is not particularly efficient since it falls
	back on adding the new elements one by one. This is to ensure that the #add:atIndex
	notifications are correctly triggered.
	Note that this modifies and answers the receiver, not a copy."

	newElements do: [ :each | self add: each ].
	^newElements!

addAll: aCollection afterIndex: anInteger
	"Add all of the elements in the <collection>, aCollection, after the existing element of the receiver at the  one-based <integer> index, anInteger. Answer the newly added elements."

	self list addAll: aCollection afterIndex: anInteger.
	self
		trigger: #items:addedAtIndex:
		with: aCollection
		with: anInteger + 1.
	^aCollection!

addAnsweringIndex: newObject
	"Append newObject as the last element of the receiver. 
	Answer the index at which the object was added."

	| index |
	index := self list addAnsweringIndex: newObject.
	self trigger: #item:addedAtIndex: with: newObject with: index.
	^index!

at: anInteger
	"Answer the element at index, anInteger, in the receiver."

	^self list at: anInteger


!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	^self list at: index ifAbsent: exceptionBlock!

at: index put: newElement 
	"Replace the element of the receiver at the specified index with the argument, 
	newElement. If the index is out of bounds, raise an exception.
	Trigger the #itemUpdatedAtIndex: event to notify observers that the indexed
	item has been overwritten."

	self list at: index put: newElement.
	self notifyItem: newElement updatedAtIndex: index.
	^newElement!

beSorted
	"Sort the collection held by the receiver using a default sort block"

	self list: self list asSortedCollection.
!

beSorted: aSortBlock
	"Sort the collection held by the receiver using aSortBlock"

	self list: (self list asSortedCollectionUsing: (self sortAlgorithmClass newSortBlock: aSortBlock))!

beUnsorted
	"Change the list in the receiver into an OrderedCollection. The
	existing ordering will still be intact so there is no need to trigger
	a #list change event"

	| newList |
	newList := OrderedCollection new: list size.
	newList addAll: list.
	list := newList
!

copyingClass
	"Private - Answer the class of object expected when the receiver is copied in whole or in part."

	^OrderedCollection!

from: anInteger keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver starting with
	the element at the specified <integer> index. A <BoundsError> will be raised if either the
	starting index is out of bounds."

	"Implementation Note: Overridden here just in case the underlying list has a slow implementation of #size."

	self list from: anInteger keysAndValuesDo: operation!

from: startInteger to: stopInteger keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	between the <integer> indices, start and stop, inclusive with the element and its
	index as respectively the second and first arguments."

	self list 
		from: startInteger
		to: stopInteger
		keysAndValuesDo: operation!

getEvents
	"Private - Answer the EventsCollection belonging to the receiver, or nil if the receiver
	has no events registered for it"

	^events!

includes: target
	"Answer whether the argument, target, is one of the elements of the receiver.
	Implementation Note: Override in order to use the search policy."

	^(self indexOf: target) ~= 0!

keyAtValue: value ifAbsent: operation
	"Answer the <integer> key of the <Object> argument, value. 
	If there is no such value, answer the result of evaluating the 
	<niladicValuable>, operation."

	^searchPolicy keyAtValue: value in: self list ifAbsent: operation!

keysAndValuesDo: operation 
	"Evaluate the <dyadicValuable>, operation, for each element of the receiver
	with the <integer> index of that element and the element itself as the arguments."

	"Implementation Note: Overridden here just in case the underlying list has a slow implementation of #size."

	self list keysAndValuesDo: operation!

list
	"Answer the contents of the receiver"

	^list!

list: aSequenceableCollection 
	"Set the list of the receiver, i.e. the collection that it represents"

	list == aSequenceableCollection ifTrue: [^self].
	list := aSequenceableCollection.
	self notifyListChanged!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.

	Implementation Note: Implemented here only to improve performance, since the
	underlying 'list' may have a fast implementation of #nextIdentityIndexOf:from:to:"

	^self list nextIdentityIndexOf: anElement from: start to: stop!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: We must delegate to our <searchPolicy>."

	^self searchPolicy nextIndexOf: anElement in: self list from: start to: stop!

notifyItem: anObject updatedAtIndex: anInteger 
	self 
		trigger: #item:updatedAtIndex:
		with: anObject
		with: anInteger.
	"Trigger the old event too, for backwards compatibility"
	self trigger: #itemUpdatedAtIndex: with: anInteger!

notifyListChanged
	self trigger: #listChanged!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy
	does not share any state with the original, apart from the elements. Answer the receiver. In
	the case of a ListModel we need to ensure the contained collection is copied too, and the
	copy has no event registrations."

	super postCopy.
	list := list copy.
	events := nil.
	^self!

refresh: anObject
	"The <Object>, anObject, has been updated in some way. If anObject is an element of
	the receiver then notify observers of the index in the receiver that has been updated and
	answer that index, otherwise raise a <NotFoundError>."

	^self refresh: anObject ifAbsent: [self errorNotFound: anObject]!

refresh: anObject ifAbsent: exceptionHandler 
	"The <Object>, anObject, has been updated in some way. If anObject is an element of
	the receiver then notify observers of the index in the receiver that has been updated and
	answer that index, otherwise answer the result of evaluating the <niladicValuable>,
	exceptionHandler."

	| index |
	index := self indexOf: anObject.
	index == 0 ifTrue: [^exceptionHandler value].
	self notifyItem: anObject updatedAtIndex: index.
	^index!

refreshAtIndex: anInteger 
	"Update, and answer, an object in the receiver at anInteger index because 
	its contents have changed. If anInteger index does not exist in the list 
	then raise a suitable exception. Answer anObject."

	| elem |
	elem := self list at: anInteger.
	self notifyItem: elem updatedAtIndex: anInteger.
	^elem!

removeAll
	"Empty the receiver of all contents.
	Implementation Note: We must be careful how we do this since we must preserve any
	attributes of the collection (e.g. the sort block of a sorted collection), but it must be empty
	even if a non-resizable collection such as an <Array>."

	self notEmpty ifTrue: [self list: (self list copyEmpty: 0)]!

removeAtIndex: anInteger
	"Remove, and answer, the element of the receiver at the specified 
	<integer> index, by shuffling elements which succeed it down one slot.
	Raise an BoundsError if there is no element with that index."

	| elem |
	elem := self list removeAtIndex: anInteger.
	self trigger: #item:removedAtIndex: with: elem with: anInteger.
	^elem!

resize: anInteger
	"Private - Resize the receiver to accommodate anInteger elements.
	Answer the receiver."

	self list resize: anInteger.
	^self!

searchPolicy
	"Answer the receiver's current <searchPolicy>."

	^searchPolicy!

searchPolicy: policy
	"Set the receiver's <searchPolicy> to the argument."

	searchPolicy := policy!

select: discriminator
	"Evaluate the monadic valuable argument, discriminator, for each of the receiver's elements.
	Answer a new Collection like the receiver containing only those elements for which 
	the discriminator evaluates to true."

	^self list select: discriminator!

setEvents: anEventsCollectionOrNil
	"Private - Set the EventsCollection of the receiver to be anEventsCollectionOrNil.
	Answer the receiver."

	events := anEventsCollectionOrNil!

setList: collection searchPolicy: policy
	"Private - Initialize the receiver's identity instance variables. Answer the receiver."

	list := collection.
	searchPolicy := policy!

size
	"Answer the number of elements in the receiver."

	^self list size

!

sort: aDyadicValuable
	list sort: aDyadicValuable.
	self notifyListChanged!

sortAlgorithmClass
	"Answer the class of algorithm to be used for sorting the receiver's contents. Use a stable sorting algorithm."

	^MergesortAlgorithm!

species
	"Answer the preferred class of the receiver - not always the same as the answer to #class (although this implementation uses the class primitive, which should not fail). Normally used when comparing two objects to determine if they are of the comparable types."

	^OrderedCollection!

stbSaveOn: anSTBOutFiler
	"Output the receiver to anSTBOutFiler. We must ensure that the local events collection
	is NOT saved to the filer"

	anSTBOutFiler override: events with: nil.
	super stbSaveOn: anSTBOutFiler.! !

!UI.ListModel categoriesForMethods!
add:!adding!public! !
add:afterIndex:!adding!public! !
addAll:!adding!public! !
addAll:afterIndex:!adding!public! !
addAnsweringIndex:!adding!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
beSorted!public!sorting! !
beSorted:!public!sorting! !
beUnsorted!public!sorting! !
copyingClass!copying!private! !
from:keysAndValuesDo:!enumerating!public! !
from:to:keysAndValuesDo:!enumerating!public! !
getEvents!events!private! !
includes:!public!searching! !
keyAtValue:ifAbsent:!accessing!public! !
keysAndValuesDo:!enumerating!public! !
list!accessing!public! !
list:!accessing!public! !
nextIdentityIndexOf:from:to:!public!searching! !
nextIndexOf:from:to:!public!searching! !
notifyItem:updatedAtIndex:!private!updating! !
notifyListChanged!private!updating! !
postCopy!copying!public! !
refresh:!public!updating! !
refresh:ifAbsent:!public!updating! !
refreshAtIndex:!public!updating! !
removeAll!public!removing! !
removeAtIndex:!public!removing! !
resize:!mutating!private! !
searchPolicy!accessing!public! !
searchPolicy:!accessing!public! !
select:!enumerating!public! !
setEvents:!events!private! !
setList:searchPolicy:!initializing!private! !
size!accessing!public! !
sort:!public! !
sortAlgorithmClass!public!sorting! !
species!constants!public! !
stbSaveOn:!binary filing!public! !
!

UI.ListModel methodProtocol: #listModel attributes: #(#readOnly) selectors: #(#list #list:)!
UI.ListModel methodProtocol: #model attributes: #(#readOnly) selectors: #()!

!UI.ListModel class methodsFor!

defaultSearchPolicy
	"Answer the default <searchPolicy> used by instances of the receiver."

	^SearchPolicy identity!

new
	"Answer a new initialized instance of the receiver, with the default search policy
	installed, on an empty OrderedCollection."

	^self on: OrderedCollection new!

new: count
	"Answer a new instance of the receiver with an initial capacity of at least 
	<integer> count elements (i.e. the size is a hint)."

	^self on: (OrderedCollection new: count)!

newEquality
	"Answer a new initialized instance of the receiver with the equality <SearchPolicy>."

	^self newWithSearchPolicy: SearchPolicy equality!

newWithSearchPolicy: searchPolicy
	"Answer a new instance of the receiver with the specified <SearchPolicy>."

	^self on: OrderedCollection new searchPolicy: searchPolicy!

ofSize: anInteger
	^self on: (OrderedCollection ofSize: anInteger)!

on: aSequenceableCollection
	"Answer an instance of the receiver wrapped around the <sequencedCollection> argument
	and using the default <SearchPolicy>."

	^self on: aSequenceableCollection searchPolicy: self defaultSearchPolicy!

on: list searchPolicy: searchPolicy
	"Answer a new initialized instance of the receiver, on the <sequencedReadableCollection>, list,
	and the <searchPolicy>, searchPolicy."

	^super new
		setList: list searchPolicy: searchPolicy
!

stbConvertFrom: anSTBClassFormat
	"Convert from earlier version models.
	1: Added 'events' instance variable to ListModel.
	2: Added 'searchPolicy' instance variable."

	anSTBClassFormat version < 2
		ifTrue: [^[:data | (self stbConvertFromVersions0and1: data) becomeA: self]].
	^super stbConvertFrom: anSTBClassFormat!

stbConvertFromVersions0and1: data
	^(data resize: self instSize)
		at: 3 put: self defaultSearchPolicy;
		yourself!

stbVersion
	^2! !

!UI.ListModel class categoriesForMethods!
defaultSearchPolicy!constants!public! !
new!instance creation!public! !
new:!instance creation!public! !
newEquality!instance creation!public! !
newWithSearchPolicy:!instance creation!public! !
ofSize:!instance creation!private! !
on:!instance creation!public! !
on:searchPolicy:!instance creation!public! !
stbConvertFrom:!binary filing!public! !
stbConvertFromVersions0and1:!binary filing!public! !
stbVersion!binary filing!public! !
!

