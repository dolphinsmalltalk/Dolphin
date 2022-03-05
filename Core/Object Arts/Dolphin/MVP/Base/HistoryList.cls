"Filed out from Dolphin Smalltalk"!

Object subclass: #HistoryList
	instanceVariableNames: 'history position maxAge searchPolicy'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
HistoryList guid: (GUID fromString: '{87b4c490-026e-11d3-9fd7-00a0cc3e4a32}')!
HistoryList comment: 'HistoryList maintains a list of recent visits which can be navigated back and forth, with similar behaviour to a Web browser''s history list.

Instance Variables:
	history		<OrderedCollection>. The history, oldest first.
	position		<integer>. Current position in the history, usually points at most recent visit.
	maxAge		<integer>. Maximum size to which the history list can grow before older items are discarded.
	searchPolicy	<SearchPolicy> used to compare items when adding/removing visits.

'!
!HistoryList categoriesForClass!MVP-Presenters-Support! !
!HistoryList methodsFor!

addLast: anObject 
	"Add a visit to the <Object>, location, to the receiver's history list after the
	current position such that it becomes current. Any history which was 
	forward of the previous position is discarded."

	position = history size 
		ifFalse: 
			[" Discard anything forward of this point"
			self clearFuture].
	position = maxAge 
		ifTrue: 
			[history := (history copyLikeOfSize: maxAge)
						replaceFrom: 1
							to: maxAge - 1
							with: history
							startingAt: 2;
						at: maxAge put: anObject;
						yourself]
		ifFalse: 
			[history addLast: anObject.
			position := position + 1]!

clear
	"Clear any past and future history."

	self initialize: maxAge!

clearFuture
	"Clear the future sequence in the receiver forward of the current position."

	self hasFuture ifTrue: [
		history := history copyFrom: 1 to: position]!

clearPast
	"Clear the past sequence in the receiver before the current position."

	self hasPast ifTrue: [
		history := history copyFrom: position to: history size.
		position := self isEmpty ifTrue: [0] ifFalse: [1]].!

close
	"Present to complete the implementation of the <sequencedStream> protocol."

	^self clear!

contents
	"Answer all of the objects in the collection accessed by the receiver.
	Generally the collection will be the same class as the one accessed by the receiver."

	^history!

current
	"Answer the current location in the history list.
	Raise a <BoundsError> exception if the list is empty."

	^history at: position!

current: location
	"Replace the current location in the history list with
	the specified new location.
	Raise a <BoundsError> exception if the list is empty."

	history at: position put: location!

futureSize
	"Answer the number of visits in the history which were made after the
	current one."

	^history size - position!

goBack: count 
	"Move back up to <Integer> count positions in the receiver's history list.
	This will increase the forward history by that amount"

	self position: (position - count max: 0).
	^self notEmpty ifTrue: [self current]!

goForward: count
	"Move forward up to <Integer> count positions in the receiver's history list.
	This will increase the backward history by that amount."

	position := (position + count) min: history size.
	^self current
	!

hasFuture
	"Answer whether their are an future visits in the receiver."

	^self futureSize > 0!

hasPast
	"Answer whether there are any past visits in the receiver."

	^self pastSize > 0!

initialize: anInteger 
	"Private - Initialize the receiver's instance variables."

	history := OrderedCollection new.
	position := 0.
	maxAge := anInteger.
	self searchPolicy: SearchPolicy equality!

isEmpty
	"Answer whether the receiver's past history is empty."

	^position == 0!

next
	"Answer the next item in the receiver's future sequence after the current
	position, or raise a BoundsError if none."

	^history at: position + 1!

next: count
	"Answer up to<Integer> count visits after the current position.
	The current position is unaffected."

	^history copyFrom: position + 1 to: (position + count min: history size)!

notEmpty
	"Answer whether the receiver has a past history."
	^self isEmpty not!

past
	"Answer the past sequence values from the receiver, in descending chronological
	order (i.e. most recent visits first). The current position is unaffected."

	^self previous: self pastSize
!

pastSize
	"Answer the number of visits in the history which were made before the
	current one."

	^position - 1!

position
	"Answer the receiver's current position reference for accessing the collection.
	This will be zero if the receiver has no visit history."

	^position
!

position: anInteger
	"Set the receiver's current position reference for accessing the collection
	to the the argument, anInteger. If the argument is not within the bounds of
	the receiver's collection, report an error."

	(anInteger between: 0 and: history size)
		ifTrue: [position := anInteger]
		ifFalse: [^self errorSubscriptBounds: position]
!

previous
	"Answer the previous item in the receiver's past sequence immediately 
	before the current position, or raise a BoundsError error if none."

	^history at: position - 1!

previous: count
	"Answer up to <Integer> count previous visits, in descending chronological
	order (i.e. most recent visits first). The current position is unaffected."

	^(history copyFrom: position - (count min: position-1) to: position - 1) reverse!

remove: anObject 
	self removeMatching: [:each | self searchPolicy compare: each with: anObject].
	self shrink!

removeMatching: discriminator 
	"Remove those items from the history list for which the <monadicValuable>, discriminator, evaluates
	to true. This is useful when a UI item is removed so that it can no longer be visited. The current position
	is maintained if possible."

	| newHistory oldPosition |
	newHistory := history class new: history size.
	oldPosition := position.
	history keysAndValuesDo: 
			[:i :each | 
			(discriminator value: each) 
				ifTrue: 
					["If removing a past sequence value, then need to shift current position back too"
					i <= oldPosition ifTrue: [position := position - 1]]
				ifFalse: [newHistory addLast: each]].
	history := newHistory.
	position := position max: 0!

reset
	"Set the receiver's position reference to the beginning of the collection"

	self position: 0
!

searchPolicy
	^searchPolicy!

searchPolicy: anObject
	searchPolicy := anObject!

setToEnd
	"Set the receivers position reference to the end of the collection."

	position := history size!

shrink
	"Merge adjacent visits in the history list to the same item. This can arise when items are removed from the list."

	| consolidated last oldPosition |
	self isEmpty ifTrue: [^self].
	consolidated := OrderedCollection new: history size.
	last := history first.
	consolidated addLast: history first.
	oldPosition := position.
	history from: 2
		keysAndValuesDo: 
			[:i :each | 
			(self searchPolicy compare: last with: each) 
				ifTrue: [i <= oldPosition ifTrue: [position := position - 1]]
				ifFalse: 
					[consolidated addLast: each.
					last := each]].
	history := consolidated!

skip: count
	"Move the current position in the history list by the specified <integer> number
	of positions."

	self position: position + count!

upToEnd
	"Answer the future sequence values after the current position in the receiver."

	^self next: self futureSize!

visit: item 
	"Record a new visit to the <Object>, item, unless already visiting that object."

	(self isEmpty or: [(self searchPolicy compare: self current with: item) not]) 
		ifTrue: [self addLast: item]
		ifFalse: [self current: item]! !
!HistoryList categoriesForMethods!
addLast:!adding!public! !
clear!operations!public! !
clearFuture!operations!public! !
clearPast!operations!public! !
close!operations!public! !
contents!accessing!public! !
current!accessing!public! !
current:!accessing!public! !
futureSize!accessing!public! !
goBack:!operations!public! !
goForward:!operations!public! !
hasFuture!public!testing! !
hasPast!accessing!public! !
initialize:!initializing!private! !
isEmpty!public!testing! !
next!accessing!public! !
next:!accessing!public! !
notEmpty!public!testing! !
past!accessing!public! !
pastSize!accessing!public! !
position!positioning!public! !
position:!positioning!public! !
previous!accessing!public! !
previous:!accessing!public! !
remove:!public!removing! !
removeMatching:!public!removing! !
reset!positioning!public! !
searchPolicy!accessing!public! !
searchPolicy:!accessing!public! !
setToEnd!positioning!public! !
shrink!operations!public! !
skip:!operations!public! !
upToEnd!accessing!public! !
visit:!operations!public! !
!

HistoryList methodProtocol: #sequencedStream attributes: #(#ansi #readOnly) selectors: #(#close #contents #isEmpty #position #position: #reset #setToEnd)!

!HistoryList class methodsFor!

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

new
	"Answer a new initialized instance of the receiver
	with capacity for the default maximum number of
	items."

	^self new: 100!

new: maxAge
	"Answer a new initialized instance of the receiver
	with capacity for the specified maximum number of items."

	^super new initialize: maxAge! !
!HistoryList class categoriesForMethods!
icon!constants!public! !
new!instance creation!public! !
new:!instance creation!public! !
!

