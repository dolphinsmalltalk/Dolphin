﻿"Filed out from Dolphin Smalltalk"!

Core.SequenceableCollection
	subclass: #'Core.ArrayedCollection'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.ArrayedCollection guid: (Core.GUID fromString: '{87b4c50c-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.ArrayedCollection isNonInstantiable: true!

Core.ArrayedCollection comment: 'ArrayedCollection is the class of <SequenceableCollection>s of a fixed size which are indexable by integer keys from 1 to the size of the collection.'!

!Core.ArrayedCollection categoriesForClass!Collections-Abstract! !

!Core.ArrayedCollection methodsFor!

add: newElement
	"ArrayedCollections are not, in general, extensible."

	^self shouldNotImplement!

allSatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for
	every element of the receiver."

	"Implementation Note: Override for performance reasons only (superclass method requires a
	full block)."

	1 to: self size do: [:i | (discriminator value: (self at: i)) ifFalse: [^false]].
	^true!

anySatisfy: discriminator
	"Answer whether the <monadicValuable>, discriminator, evaluates to true for any element of
	the receiver."

	"Implementation Note: Override for performance reasons only (superclass method requires a
	full block)."

	1 to: self size do: [:i | (discriminator value: (self at: i)) ifTrue: [^true]].
	^false!

at: index
	"Answer the receiver's indexed element at the <integer> argument, index."

	"Implementation Note: Subclasses are generally implemented as indexable objects, so we can use the indexable instance variable accessing primitive (i.e. revert to the Object implementation)."

	<primitive: 60>
	^self _primitiveError: _failureCode at: index!

at: index ifAbsent: exceptionBlock
	"Answer an <Object> which is the element of the receiver 
	at the specified index. If the index is out of bounds answer
	the result of evaluating the <niladicValuable> exceptionBlock."

	<primitive: 60>
	^exceptionBlock value!

at: index put: newElement
	"Replace the element of the receiver at the specified <integer> index with 
	the <Object> argument, newElement. If the index is out of bounds, raise 
	a BoundsError.

	Implementation Note: Subclasses are generally implemented as indexable objects,
	so we can use the indexable instance variable accessing primitive (i.e.
	revert to the Object implementation)."

	<primitive: 61>
	^self
		_primitiveError: _failureCode
		at: index
		put: newElement!

copyFrom: startInteger to: stopInteger
	"Answer a new <sequencedReadableCollection> like the receiver containing those elements of
	the receiver between the <integer> indices startInteger and stopInteger, inclusive, and in
	the same order."

	<primitive: 50>
	| len |
	len := stopInteger - startInteger + 1.
	^(self copyingClass new: len)
		replaceFrom: 1
		to: len
		with: self
		startingAt: startInteger!

decodeAt: anInteger
	"Private - Answer the encoded object beginning at the specified position in the receiver."

	<primitive: 60>
	^self _primitiveError: _failureCode at: anInteger!

decodeNextFrom: aReadStream
	"Private - Answer the next <Object> in the receiver's encoding from the <ReadStream> argument ."

	^aReadStream basicNextAvailable!

detect: discriminator ifNone: exceptionHandler
	"Evaluate the <monadicValuable> argument, discriminator, for each of the receiver's 
	elements.  Answer the first element (in the #do: order) for which discriminator evaluates 
	to true. If none evaluates to true answer the result of evaluating the <niladicValuable> 
	argument, exceptionHandler."

	"Implementation Note: Override to a more optimal solution that avoids the full block required in the general purpose Collection implementation using only #do:"

	1 to: self size
		do: 
			[:i |
			| each |
			each := self at: i.
			(discriminator value: each) ifTrue: [^each]].
	^exceptionHandler value!

do: operation
	"Evaluate the <monadicValuable> argument, operation, for each of the elements of the 
	receiver. Answers the receiver. The elements are evaluated in index order.
	Implementation Note: Override the superclass for efficiency."

	1 to: self size do: [:i | operation value: (self at: i)]!

do: aMonadicValuable separatedBy: aNiladicValuable
	"Evaluate the <monadicValuable> first argument for each of the receiver's elements, interspersed with evaluations of the <niladicValuable> second argument. The separator argument is first evaluated after the first element, and is not evaluated after the last element (i.e. it is not evaluated at all if there are less than two elements)."

	"Implementation Note: As elegant as the <Collection> implementation is, it is not particularly efficient as it requires two full blocks. Therefore we override here for efficiency, as this is a very useful operation for printing and joining."

	| count |
	(count := self size) == 0 ifTrue: [^self].
	aMonadicValuable value: (self at: 1).
	2 to: count
		do: 
			[:i |
			aNiladicValuable value.
			aMonadicValuable value: (self at: i)]!

findFirst: discriminator
	"Answer the index of the first element of the receiver for which the monadic
	valuable argument, discriminator, evaluates to true. If there are no such elements,
	answer 0.
	Implementation Note: Override superclass to provide a more efficient implementation.
	ArrayedCollections have a very fast implementation of #at:, so it is better to inline
	the loop."

	1 to: self size do: [:i | (discriminator value: (self at: i)) ifTrue: [^i]].
	^0!

identityIncludes: anObject
	"Answer whether the argument, anObject, is one of the receiver's elements."

	"Implementation Note: Override superclass to provide a more efficient implementation using the identity search primitive."

	^(self
		nextIdentityIndexOf: anObject
		from: 1
		to: self size) ~~ 0!

includes: anObject
	"Answer whether the argument, anObject, is one of the elements of the receiver."

	"Implementation Note: Override superclass only to provide a more efficient implementation."

	^(self
		nextIndexOf: anObject
		from: 1
		to: self size) ~~ 0!

inject: anObject into: aDyadicValuable
	"Evaluate the <dyadicValuable> argument, aDyadicValuable, once for each element in the
	receiver, passing the elements as the second argument, and passing the value of the previous
	evaluation as the first argument, starting with the <Object> argument, initialValue. The
	operation must answer the value it wishes to have passed as its first argument the next time
	it is evaluated. The traversal is in the #do: order. Answer the final value of the
	operation. This enumeration is particularly useful for performing summations and other
	statistical operations."

	"Implementation Note: Override superclass implementation for efficiency. By inlining the do:
	implementation we can avoid requiring a full block."

	| nextValue |
	nextValue := anObject.
	1 to: self size do: [:i | nextValue := aDyadicValuable value: nextValue value: (self at: i)].
	^nextValue!

lookup: keyInteger
	"Answer the value named by the <Integer> argument, keyInteger, or nil if there is no such key in the receiver.
	Clearly if the receiver can contain nil values then it will not be possible to distinguish between the absence
	of the key and the key being associated with a nil value. However, this method expresses the
	very common pattern of passing an empty block as absent handler to #at:ifAbsent:"

	<primitive: 60>
	^nil!

nextIdentityIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver's indexable
	variables between startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Override the inherited implementation to make use of the primitive"

	<primitive: 59>
	start to: stop do: [:i | (self at: i) == anElement ifTrue: [^i]].
	^0!

nextIndexOf: anElement from: start to: stop
	"Answer the index of the next occurrence of anElement in the receiver between 
	startIndex and stopIndex inclusive. If there are no such occurrences, answer 0.
	Implementation Note: Override the superclass to provide a more efficient
	inlined implementation."

	start to: stop do: [:i | (self at: i) = anElement ifTrue: [^i]].
	^0!

removeAll
	"Remove each element from the receiver and leave it empty."

	self shouldNotImplement!

replaceIdentity: anObject with: newElement
	"If the receiver contains an identity match for anObject replace the first with newElement, 
	otherwise increase the size of the receiver, and append newElement. Answer the index.
	This is a very useful method in many system support tasks (e.g. the Dependency mechanism)"

	| size index |
	size := self size.
	index := self nextIdentityIndexOf: anObject from: 1 to: size.
	index == 0 ifTrue: [ 
		index := size + 1.
		self resize: index ].
	self at: index put: newElement.
	^index!

resize: anInteger 
	"Override back to the primitive implementation for indexable objects (see Object>>resize:)"

	<primitive: 101>
	^super resize: anInteger!

size
	"Answer the size of the collection."

	"Implementation Note: Subclasses are generally implemented as indexable objects, so we can use the indexable instance variable size primitive.
	This primitive should not fail."

	<primitive: 62>
	^self primitiveFailed: _failureCode!

sort
	"Perform an in-place sort of the contents of the receiver using the default sort algorithm and sort order, which is defined by the result of sending #<= to pairs of elements."

	self sortUsing: self class defaultSortAlgorithm!

sort: aDyadicValuable
	"Perform an in-place sort against the receiver using the specified <dyadicValuable> sort block."

	self sortUsing: (SortAlgorithm defaultSort: aDyadicValuable)!

sortUsing: aSortAlgorithm
	"Perform an in-place sort against the receiver using the specified sort algorithm"
	
	aSortAlgorithm 
		sort: self
		from: 1
		to: self size! !

!Core.ArrayedCollection categoriesForMethods!
add:!adding!public! !
allSatisfy:!enumerating!public! !
anySatisfy:!enumerating!public! !
at:!accessing!public! !
at:ifAbsent:!accessing!public! !
at:put:!accessing!public! !
copyFrom:to:!public! !
decodeAt:!encode/decode!private! !
decodeNextFrom:!encode/decode!private! !
detect:ifNone:!public!searching! !
do:!debugger-step through!enumerating!public! !
do:separatedBy:!enumerating!public! !
findFirst:!public!searching! !
identityIncludes:!public!searching! !
includes:!public!searching! !
inject:into:!enumerating!public! !
lookup:!accessing!public! !
nextIdentityIndexOf:from:to:!public!searching! !
nextIndexOf:from:to:!public!searching! !
removeAll!public! !
replaceIdentity:with:!public!replacing! !
resize:!mutating!public! !
size!accessing!public! !
sort!public!sorting! !
sort:!public!sorting! !
sortUsing:!public!sorting! !
!

!Core.ArrayedCollection class methodsFor!

new
	"Answer a new, empty, instance of the receiver."

	^self new: 0!

new: elementCount withAll: elementValue
	"Answer a new instance of the receiver with <integer>, anInteger, elements, each of which is initialized to the <Object>, anObject."

	<primitive: 71>
	^(self new: elementCount)
		atAllPut: elementValue;
		yourself!

with: element1
	"Answer a new instance of the receiver containing the single 
	<Object> element, element1."

	^(self new: 1)
		at: 1 put: element1;
		yourself!

with: element1 with: element2
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements"

	^(self new: 2)
		at: 1 put: element1;
		at: 2 put: element2;
		yourself!

with: element1 with: element2 with: element3
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	^(self new: 3)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		yourself!

with: element1 with: element2 with: element3 with: element4
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements."

	^(self new: 4)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		yourself!

with: element1 with: element2 with: element3 with: element4 with: element5
	"Answer an instance of the receiver containing the <Object>
	arguments as its elements.
	N.B. This is not an ANSI standard method (up to 4 elements are supported
	by <Array factory> #with:&c messages, for more one must use #withAll:)."

	^(self new: 5)
		at: 1 put: element1;
		at: 2 put: element2;
		at: 3 put: element3;
		at: 4 put: element4;
		at: 5 put: element5;
		yourself!

withAll: newElements
	"Answer a new instance of the receiver containing all of the 
	elements of the <collection> newElements."

	| answer |
	answer := self new: newElements size.
	newElements inject: 1 into: [:i :elem | answer at: i put: elem. i + 1].
	^answer! !

!Core.ArrayedCollection class categoriesForMethods!
new!instance creation!public! !
new:withAll:!instance creation!public! !
with:!instance creation!public! !
with:with:!instance creation!public! !
with:with:with:!instance creation!public! !
with:with:with:with:!instance creation!public! !
with:with:with:with:with:!instance creation!public! !
withAll:!instance creation!public! !
!

Core.ArrayedCollection class methodProtocol: #'Array factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

