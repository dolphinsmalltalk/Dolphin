"Filed out from Dolphin Smalltalk"!

SingletonSearchPolicy subclass: #EqualitySearchPolicy
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
EqualitySearchPolicy guid: (GUID fromString: '{1086b60a-da69-4d8d-82df-be610ba9d062}')!
EqualitySearchPolicy comment: 'EqualitySearchPolicy is for configuring pluggable collections and models to use equality based search and comparisons, i.e. using #= and #hash, etc. Using an instance of this search policy a <PluggableSet> will behave in the same way as a <Set>.'!
!EqualitySearchPolicy categoriesForClass!Collections-Support! !
!EqualitySearchPolicy methodsFor!

compare: operand1 with: operand2
	"Answer whether the <Object>, operand1, is considered equivalent to the <Object> argument,
	operand2, by this search policy."

	^operand1 = operand2!

hash: operand max: maximum
	"Answer a suitable hash value for the <Object>, operand, under this search policy, 
	between 1 and the <integer>, maximum.
	Implementation Note: Override to avoid a message send (seems trivial but performance
	of search policies can be important)."

	^operand hash \\ maximum + 1!

keyAtValue: value in: collection ifAbsent: operation
	"Answer the <Object> key of the <Object> argument, value in the keyed
	collection, collection, using the receiver's search policy. If there is no such 
	value, answer the result of evaluating the <niladicValuable>, operation.
	The reverse mapping equality search operation is used: The collection argument
	must respond to #keyAtEqualValue:ifAbsent: (there is no keyedCollection protocol
	defined at present)."

	^collection keyAtEqualValue: value ifAbsent: operation!

name
	"Answer the name of the `SearchPolicy`. This is nil apart from the named singletons."

	^#equality!

newLookupTable
	"Answer a new <LookupTable> with the receiver as its search policy."

	^LookupTable new!

newSet
	"Answer a new <Set> with the receiver as its search policy."

	^Set new!

nextIndexOf: anElement in: collection from: start to: stop
	"Answer the index of the next occurrence of anElement in the <sequencedReadableCollection>
	argument,  collection, between startIndex and stopIndex inclusive. If there are no such occurrences, 
	answer 0."

	^collection nextIndexOf: anElement from: start to: stop! !
!EqualitySearchPolicy categoriesForMethods!
compare:with:!comparing!public! !
hash:max:!comparing!public! !
keyAtValue:in:ifAbsent:!public!searching! !
name!accessing!public! !
newLookupTable!operations!public! !
newSet!operations!public! !
nextIndexOf:in:from:to:!public!searching! !
!

