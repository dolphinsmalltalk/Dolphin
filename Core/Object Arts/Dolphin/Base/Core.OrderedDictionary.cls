"Filed out from Dolphin Smalltalk"!

Core.Dictionary
	variableSubclass: #'Core.OrderedDictionary'
	instanceVariableNames: 'order'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.OrderedDictionary guid: (Core.GUID fromString: '{54e3fd51-1923-4f89-a6fe-6e2b7c37d2a6}')!

Core.OrderedDictionary comment: '`OrderedDictionary` is a `Dictionary` that remembers the insertion order of its associations. A `Dictionary` enumerates its elements in unspecified order, but `OrderedDictionary` will always enumerate then in the order in which they were added.

Although the computational complexity of adding, updating, and looking up elements by key in an `OrderedDictionary` is the same as `Dictionary`, i.e. O(1), the overhead of maintaining the order does increase O. 

Note that although `OrderedDictionary` instances have an order, they are not sequenceable collections.'!

!Core.OrderedDictionary methodsFor!

, operand
	"This is an auto-generated target implementation for the protocol <sequencedReadableCollection>
	and remains to be correctly implemented."

	^Error notYetImplemented!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand. OrderedDictionaries are equal to other dictionary-like objects with the equal keys and values in the same order."

	| i |
	comperand == self ifTrue: [^true].
	(comperand class conformsToProtocol: #abstractDictionary) ifFalse: [^false].
	comperand size == self size ifFalse: [^false].
	i := 1.
	comperand associationsDo: 
			[:each |
			(order at: i) = each ifFalse: [^false].
			i := i + 1].
	^true!

associationsDo: aMonadicValuable
	"Evaluate the <monadicValuable> argument, for each of the receiver's key/value mappings in the order in which they were added."

	1 to: tally do: [:i | aMonadicValuable value: (order at: i)]!

do: aMonadicValuable
	"Evaluate <monadicValuable> argument, operation, for each of the element of the receiver. Answers the receiver."

	1 to: tally do: [:i | aMonadicValuable value: (order at: i) value]!

indexOfKey: anObject
	"Answer the <integer> index of the key argument, or 0 if it is not one of the receiver's keys."

	1 to: tally do: [:i | (order at: i) key = anObject ifTrue: [^i]].
	^0!

initialize
	super initialize.
	order := Array new: self basicSize!

keys
	"Answer a <sequencedReadableCollection> containing the receiver's keys in the order in which they were added."

	| keys |
	keys := Array new: tally.
	1 to: tally do: [:i | keys at: i put: (order at: i) key].
	^keys!

keysAndValuesDo: aDyadicValuable
	"Evaluate the <dyadicValuable>, operation, for each key/value pair in the receiver.
	The key/values pairs are visited in the order in which they were added."

	1 to: tally
		do: 
			[:i |
			| each |
			each := order at: i.
			aDyadicValuable value: each key value: each value]!

last: anInteger
	"Answer a copy of the receiver comprising the rightmost anInteger elements."

	^self copyFrom: tally - anInteger + 1 to: tally!

postCopy
	"Apply any final flourish to the copy that may be required in order to ensure that the copy does not share any state with the original, apart from the elements."

	"The superclass implementation will copy the associations, and we then need to ensure these replace the originals in a new copy of the order array."

	| newOrder |
	super postCopy.
	newOrder := Array new: order size.
	1 to: tally do: [:i | newOrder at: i put: (self basicAt: (self findKeyOrNil: (order at: i) key))].
	order := newOrder!

privateAt: index put: newObject
	self basicAt: index put: newObject.
	order at: (tally := tally + 1) put: newObject.
	tally * 3 > (self basicSize * 2) ifTrue: [self grow].
	^newObject!

removeKey: anObject ifAbsent: aNiladicValuable
	"Remove the association from the receiver with the <Object> key, anObject. If the key is not in the receiver, answer the result of evaluating the <niladicValuable>, aNiladicValuable. Otherwise, answer the value associated with the key."

	| result index |
	index := self indexOfKey: anObject.
	index == 0 ifTrue: [^aNiladicValuable value].
	result := super removeKey: anObject ifAbsent: [Error signal: 'order array not consistent with hashed content'].
	order
		replaceFrom: index
		to: tally
		with: order
		startingAt: index + 1.
	order at: tally + 1 put: nil.
	^result!

resize: anInteger
	super resize: anInteger.
	order resize: self basicSize!

reverseDo: arg1
	"This is an auto-generated target implementation for the protocol <sequencedReadableCollection>
	and remains to be correctly implemented."

	^Error notYetImplemented!

sort
	"Perform an in-place sort of the contents of the receiver using the default sort algorithm and sort order, which is defined by the result of sending #<= to pairs of elements."

	self sortUsing: self class defaultSortAlgorithm!

sort: aDyadicValuable
	"Perform an in-place sort against the receiver using the specified <dyadicValuable> sort block."

	self sortUsing: (SortAlgorithm defaultSort: aDyadicValuable)!

sorted: aSortBlockOrNil

	^ self copy sort: aSortBlockOrNil!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"

	tally <= 1 ifTrue: [^self].
	aSortAlgorithm
		sort: order
		from: 1
		to: tally!

uncheckedAdd: anAssociation 
	super uncheckedAdd: anAssociation.
	^order at: tally put: anAssociation!

with: arg1 do: arg2
	"This is an auto-generated target implementation for the protocol <sequencedReadableCollection>
	and remains to be correctly implemented."

	^Error notYetImplemented! !

!Core.OrderedDictionary categoriesForMethods!
,!public! !
=!public! !
associationsDo:!public! !
do:!public! !
indexOfKey:!public! !
initialize!private! !
keys!accessing!public! !
keysAndValuesDo:!public! !
last:!public! !
postCopy!public! !
privateAt:put:!public! !
removeKey:ifAbsent:!public! !
resize:!public! !
reverseDo:!public! !
sort!public! !
sort:!public! !
sorted:!public! !
sortUsing:!public! !
uncheckedAdd:!public! !
with:do:!public! !
!

