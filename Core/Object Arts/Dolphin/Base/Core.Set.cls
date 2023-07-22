"Filed out from Dolphin Smalltalk"!

Core.Collection
	variableSubclass: #'Core.Set'
	instanceVariableNames: 'tally'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'MaxOffsetIndex' -> 16r402.
			'PrimeSizes'
				-> #(16r815 16r8BD 16r977 16rA39 16rAED 16rBB7 16rC5F 16rD1F 16rDD3 16rE8F 16rF47 16r1159 16r12B3 16r13FF 16r155F 16r16A9 16r17FF 16r1979 16r1AAB 16r1C09 16r1D5D 16r1EAD 16r224F 16r2581 16r2803 16r2A73 16r2D1D 16r2FCF 16r3277 16r356F 16r37D5 16r3AA5 16r3D73 16r44A1 16r4A6B 16r4FDB 16r5507 16r5A77 16r6023 16r64F7 16r6B05 16r6F9B 16r755F 16r7AA5 16r8BBB 16r9539 16r9F89 16rABC5 16rB629 16rBF5D 16rC9AF 16rD463 16rE005 16rEAEB 16rF5F9 16r113BD 16r1293B 16r139DB 16r14F53 16r16249 16r1762F 16r18AA3 16r19F15 16r1B227 16r1C441 16r1D773 16r1ED67 16r2263F 16r24BFB 16r274C9 16r29A3D 16r2C3FB 16r2E8FD 16r313B5 16r33BB3 16r36043 16r38C8F 16r3B4B9 16r3D633 16r44DE9 16r49745 16r4E99D 16r534EB 16r58771 16r5DAC1 16r62003 16r6740F 16r6C35F 16r71837 16r75AF1 16r7B0CB 16r895BD 16r93E53 16r9E1EB 16rA6687 16rB0AA7 16rBA5AB 16rC5545 16rCE3A5 16rD8593 16rE239F 16rEC23D 16rF7B59).
			'SmallPrimeOffsets'
				-> #[0 0 0 8 6 4 2 0 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 4 2 0 4 2 0 0 4 2 0 2 0 0 4 2 0 8 6 4 2 0 6 4 2 0 2 0 0 2 0 0 2 0 12 10 8 6 4 2 0 2 0 4 2 0 0 8 6 4 2 0 0 4 2 0 4 2 0 2 0 4 2 0 4 2 0 0 8 6 4 2 0 0 2 0 0 10 8 6 4 2 0 10 8 6 4 2 0 2 0 0 2 0 4 2 0 0 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 16 14 12 10 8 6 4 2 0 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 52 50 48 46 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 10 8 6 4 2 0 10 8 6 4 2 0 4 2 0 12 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 10 8 6 4 2 0 16 14 12 10 8 6 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 8 6 4 2 0 6 4 2 0 10 8 6 4 2 0 2 0 6 4 2 0 4 2 0 2 0 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 4 2 0 2 0 18 16 14 12 10 8 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 6 4 2 0 2 0 4 2 0 4 2 0 12 10 8 6 4 2 0 2 0 4 2 0 4 2 0 6 4 2 0 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 0 14 12 10 8 6 4 2 0 0 8 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 0 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 20 18 16 14 12 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 14 12 10 8 6 4 2 0 4 2 0 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 4 2 0 0 4 2 0 2 0 0 2 0 10 8 6 4 2 0 6 4 2 0 44 42 40 38 36 34 32 30 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 2 0 0 16 14 12 10 8 6 4 2 0 8 6 4 2 0 0 2 0 4 2 0 16 14 12 10 8 6 4 2 0 18 16 14 12 10 8 6 4 2 0 10 8 6 4 2 0 8 6 4 2 0 4 2 0 6 4 2 0 2 0 6 4 2 0 2 0 16 14 12 10 8 6 4 2 0 4 2 0 10 8 6 4 2 0 0 4 2 0 8 6 4 2 0 24 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 0 8 6 4 2 0 10 8 6 4 2 0 0 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 4 2 0 22 20 18 16 14 12 10 8 6 4 2 0 2 0 12 10 8 6 4 2 0 8 6 4 2 0 10 8 6 4 2 0 6 4 2 0 28 26 24 22 20 18 16 14 12 10 8 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 16 14 12 10 8 6 4 2 0 4 2 0 18 16 14 12 10 8 6 4 2 0 14 12 10 8 6 4 2 0 0 26 24 22 20 18 16 14 12 10 8 6 4 2 0 6 4 2 0 4 2 0 4 2 0 2 0 6 4 2 0 4 2 0 8 6 4 2 0 0 8 6 4 2 0 12 10 8 6 4 2 0]
		}!
Core.Set guid: (Core.GUID fromString: '{87b4c50b-026e-11d3-9fd7-00a0cc3e4a32}')!
Core.Set comment: 'Set is a generic collection class which represents an unordered, extensible/contractible, collection, accessible only by value, not by external keys. Element comparison is by equality (i.e. using #hash and #=).'!
!Core.Set categoriesForClass!Collections-Unordered! !
!Core.Set methodsFor!

- others
	"Answer a <Set> containing the elements of the receiver that are 
	not present in the <collection>, others."

	^self reject: [:each | others includes: each]!

_deepCopy: anIdentityDictionary 
	"Private - Answer a 'deep copy' of the receiver, cloning only those parts not already included
	in the <IdentityDictionary> argument."

	^anIdentityDictionary at: self
		ifAbsent: 
			[| clone |
			clone := self copyEmpty.
			anIdentityDictionary at: self put: clone.
			self _deepCopyElementsInto: clone trail: anIdentityDictionary.
			clone]!

_deepCopyElementsInto: aSet trail: anIdentityDictionary 
	self do: [:element | aSet uncheckedAdd: (element _deepCopy: anIdentityDictionary)]!

= comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	comperand == self ifTrue: [^true].
	(comperand class conformsToProtocol: #Set) ifFalse: [^false].
	comperand size == self size ifFalse: [^false].
	^self allSatisfy: [:each | comperand includes: each]!

add: anObject
	"Include the <Object> argument as one of the elements of the receiver. If the argument is
	nil, then it is not added. Answer the argument."

	"Note: If the argument is already in the receiver (i.e. has an equal element already in the
	receiver), then this operation has no effect. Note further that if an equal element already
	exists then it is not overwritten, but the answer is still the argument. See also
	#addNewElement:"

	| index |
	anObject ifNil: [^anObject].	"Sets cannot store empty objects"
	(self basicAt: (index := self findElementOrNil: anObject)) isNil
		ifTrue: [self privateAt: index put: anObject].
	^anObject!

addIfAbsent: anObject
	"Include the <Object> argument as one of the elements of the receiver, unless an equivalent object is already present.
	Answer either the existing member, or anObject if it becomes a member."

	| index |
	^(self basicAt: (index := self findElementOrNil: anObject))
		ifNil: 
			[self privateAt: index put: anObject.
			anObject]!

addNewElement: anObject
	"Include the <Object> newElement as one of the elements of the receiver. 
	If newElement is nil, then it is not added. Answer true if the object was
	not already a member of the set, else false."

	| index |
	anObject ifNil: [^false].
	^(self basicAt: (index := self findElementOrNil: anObject))
		ifNil: 
			[self privateAt: index put: anObject.
			true]
		ifNotNil: [false]!

approxSize
	"Private - Answer the approximate size of the receiver.
	Implementation Note: Sets keep a tally, so we can use the actual size."

	^self size!

asSet
	"Answer a <Set> whose elements are those stored in the receiver 
	(any duplicates are therefore eliminated)."

	^self!

at: index
	"Generate an exception to the effect that Sets are not keyed."

	^self errorNotKeyed
!

at: index put: value
	"Generate an exception to the effect that Sets are not keyed."

	^self errorNotKeyed
!

copyElementsInto: newMe
	"Private - Add the receiver's elements into the argument, newMe.
	Part of the implementation of hashed collection resizing. Subclasses
	override as necessary."

	self do: [:element | newMe uncheckedAdd: element]!

copyWithoutDuplicates
	"Answers a copy of the receiver that contains no duplicate objects. 
	Implementation Note: Set>>distinct answers self, but we need a copy."

	^self shallowCopy!

distinct
	"Answer a <collection> like the receiver containing only one occurrence of each element."

	^self!

do: operation 
	"Evaluate the <monadicValuable> argument, operation, for each of the 
	elementss of the receiver. Answers the receiver."

	tally == 0 ifTrue: [^self].	"Nothing to do"
	1 to: self basicSize
		do: [:index | (self basicAt: index) ifNotNil: [:element | operation value: element]]!

elements
	"Private - Answers the contents of the receiver as an OrderedCollection"

	^self asOrderedCollection!

elements: anOrderedCollection
	"Private - Sets the contents of the receiver from anOrderedCollection"

	| originalContents|
	originalContents:= self shallowCopy.
	self removeAll: originalContents.
	self addAll: anOrderedCollection.
!

equals: comperand
	"Answer whether the receiver is equivalent to the <Object>, comperand."

	Notification deprecated.
	^self = comperand!

find: target
	"Answer the actual element of the receiver which matches (however 'match' is defined)
	the argument, target. This can be useful when eliminating duplicates."

	^self find: target ifAbsent: [self errorNotFound: target]!

find: target ifAbsent: exceptionHandler 
	"Answer the actual element of the receiver which matches (however 'match' is defined)
	the argument, target. If there is no such element, then the result of evaluating the
	niladic valuable, exceptionHandler, is answered."

	^(self basicAt: (self findElementOrNil: target)) ifNil: [exceptionHandler value]!

findElementOrNil: anObject
	"Private - Answer the index of the given object in the receiver, or, if not found,
	the index of the first empty slot including and after that to which the object hashes.
	Implementation Note: This implementation is tuned to give the best performance on the
	current VM. Although it might seem worthwhile unrolling the loop to avoid performing
	a division operation inside the loop, in practice that operation is rarely taken and
	average performance suffers from the extra temporaries used."

	| capacity index |
	index := anObject hash \\ (capacity := self basicSize) + 1.

	[| element |
	(element := self basicAt: index) isNil or: [anObject = element]]
			whileFalse: [index := index \\ capacity + 1].
	^index!

fixCollisionsFrom: index
	"Private - Rehashes objects in the collection after index to see if any of them hash to index.  If so, that object is copied to index, and the algorithm repeats with that object's index, until a nil is encountered."

	| slotIndex element capacity |
	slotIndex := index.
	capacity := self basicSize.
	
	[slotIndex := slotIndex \\ capacity + 1.
	(element := self basicAt: slotIndex) isNil] whileFalse: 
				[| hashIndex |
				hashIndex := self findElementOrNil: element.
				(self basicAt: hashIndex) isNil ifTrue: [self moveFrom: slotIndex to: hashIndex]]!

grow
	"Private - Expand the receiver to a capacity suitable for holding more elements"

	self resize: (self size - 1) * 2!

hash: anObject max: anInteger
	^anObject hash \\ anInteger + 1!

identityIncludes: anObject
	"Answer whether the <Object> argument is one of the receiver's elements."

	"Implementation Note: If anObject is identical to any object in the Set, then it must also
	be equal to that object, which means it must have the same hash value as that object, and
	therefore we can use a hashed lookup to optimize this method over the serial search in the
	Collection implementation."

	| element |
	element := self basicAt: (self findElementOrNil: anObject).
	^element notNil and: [element == anObject]!

includes: target
	"Answer whether the <Object> argument, target, is one of 
	the elements of the receiver."

	^(self basicAt: (self findElementOrNil: target)) notNil!

initialize
	"Private - Instance variable initialization. The tally records the number of elements."

	tally := 0
!

isHealthy
	"Test that object hashes match their positions stored in set's array,
	answer true if everything ok, false otherwise
	
	Set allSubInstances select: [:badSet |
		badSet isHealthy not ]
	"

	1 to: self basicSize
		do: [:i | (self basicAt: i) ifNotNil: [:element | (self findElementOrNil: element) == i ifFalse: [^false]]].
	^true!

isSelfEvaluating
	"Answer whether or not the receiver has a printString representation that evaluates back to an equivalent object."

	^self isEmpty or: [self isSelfEvaluating: IdentitySet new]!

isSelfEvaluating: visitedSet
	"Private - Answer whether the receiver can be represented as a literal (i.e. it has a printed
	representation which can be directly understood by the compiler)."

	^(visitedSet addNewElement: self)
		and: [self allSatisfy: [:element | element isSelfEvaluating: visitedSet]]!

moveFrom: fromIndex to: toIndex
	"Private - Destructively move the element at index, fromIndex, over
	the element (normally nil) at index, toIndex. Must be overridden by subclasses
	with a different structure which wish to inherit the collision repair mechanism."

	self basicAt: toIndex put: (self basicAt: fromIndex).
	self basicAt: fromIndex put: nil!

occurrencesOf: target
	"Answer an <integer> which is the number of occurrences of target in the receiver.
	Implementation Note: Sets cannot contain duplicates, so this is either 0 or 1"

	^(self includes: target) ifTrue: [1] ifFalse: [0]!

postResize: oldMe
	"Private - This message is sent by the receiver when resizing, after the
	receiver's elements have been added to a new Collection and the
	receiver has become that collection. It is a chance for the receiver
	to perform any final state changes needed."!

preResize: newMe
	"Private - This message is sent by the receiver when resizing, before the receiver's elements are added
	to newMe. It gives the receiver the opportunity to copy other parts of its state into newMe.
	See also, #postResize and #copyEmpty: (which is subtly different, since it is used for creating copies of the
	receiver, not for rebuilding it). Subclasses should implement as necessary."
!

printSelfEvaluatingOn: aStream
	tally == 0
		ifTrue: 
			[aStream
				print: self class;
				space;
				nextPutAll: #new.
			^self].
	aStream
		nextPut: $(;
		print: self class;
		space.
	tally == 1
		ifTrue: 
			[aStream
				nextPutAll: #with:;
				space;
				print: self anyOne;
				nextPut: $)]
		ifFalse: 
			[aStream
				nextPutAll: #withAll:;
				space;
				print: (self sortSelfEvaluatingElements: self asArray locale: aStream locale);
				nextPut: $)]!

privateAt: index put: newObject
	"Private - Insert newObject as the element of the receiver at index. Attempts to maintain the
	'optimal' load factor (and thereby ensures there is always a least one empty slot in the Set, an 
	invariant required by the search algorithm)."

	self basicAt: index put: newObject.
	(tally := tally + 1) * 3 > (self basicSize * 2) ifTrue: [self grow].
	^newObject!

rehash
	"Rehash the receiver by making use of the resizing mechanism, which essentially builds a
	new collection. 
	Implementation Note: It is important that #resize: is not optimised as this method
	is used to reconstruct valid Sets from invalidated ones (e.g. where the hash value of
	an Object has changed)."

	self resize: self size!

remove: anObject ifAbsent: aBlock 
	"If oldObject is one of the receiver's elements, then remove it from the receiver 
	and answer oldObject (as Sets cannot contain duplicates, only one element is ever 
	removed). If oldObject is not an element of the receiver (i.e. no element of the 
	receiver is #= to oldObject) then answer the result of evaluating aBlock."

	| index |
	index := self findElementOrNil: anObject.
	^(self basicAt: index) 
		ifNil: [aBlock value]
		ifNotNil: 
			[:element | 
			self removeIndex: index.
			element]!

removeAll
	"Remove each element from the receiver and leave it empty."

	| newMe |
	newMe := self copyEmpty.
	self preResize: newMe.
	self become: newMe.
	"newMe is now the old me!!"
	self postResize: newMe!

removeIndex: anInteger
	"Private - Remove the element at index, anInteger, in the receiver. Does not
	check that the element is empty."

	self basicAt: anInteger put: nil.
	tally := tally - 1.
	self fixCollisionsFrom: anInteger!

resize: anInteger
	"Private - Resize the receiver to have a capacity suitable for accommodating
	at least anInteger elements. Answer the receiver (resized). The receiver is
	rehashed regardless of whether it is already of the correct capacity (this
	is important)."

	| newMe |
	newMe := self copyEmpty: anInteger.
	self preResize: newMe.
	self copyElementsInto: newMe.
	self become: newMe.
	"newMe is now the old me!!"
	self postResize: newMe
!

shrink
	"Rebuild the collection with the optimal size for its current number of elements,
	as #rehash, but doesn't resize if already correct size."

	| size |
	size := self size.
	(self basicSize = (self class sizeFor: size)) 
		ifFalse: [self resize: size]!

size
	"Answer an <integer> specifying the number of elements in the receiver."

	^tally!

sortSelfEvaluatingElements: anArray locale: aLocale
	"Private - We want the elements printed in a stable order, e.g. so that if in source code we don't get gratuitous diffs occurring. We use the natural sort order of the elements if possible (generally this is true for self-evaluating forms in source), but if not we sort by the printed order of the source representation. As we want the order to be stable, we use case-sensitive comparison."

	^[anArray sort: [:a :b | a <==> b <= 0]] on: Error
		do: 
			[:ex |
			| stream |
			"Very unlikely we'll get here, but if the elements are heterogenous or don't respond to #<==>, sort them according to their printString representation"
			stream := String writeStream
						locale: aLocale;
						yourself.
			anArray sort: 
					[:a :b |
					| ap bp |
					stream reset.
					a printOn: stream.
					ap := stream contents.
					stream reset.
					b printOn: stream.
					bp := stream contents.
					ap <==> bp <= 0]]!

uncheckedAdd: newObject
	"Private - Add newObject to the receiver, without checking to see if it is already present.
	We also assume the receiver is large enough to accommodate the new element, and so do not
	attempt to maintain the load factor."

	tally := tally + 1.
	^self basicAt: (self findElementOrNil: newObject) put: newObject! !
!Core.Set categoriesForMethods!
-!public!removing! !
_deepCopy:!copying!private! !
_deepCopyElementsInto:trail:!copying!private! !
=!comparing!public! !
add:!adding!public! !
addIfAbsent:!adding!public! !
addNewElement:!adding!public! !
approxSize!accessing!private! !
asSet!converting!public! !
at:!accessing!public! !
at:put:!accessing!public! !
copyElementsInto:!mutating!private! !
copyWithoutDuplicates!copying!public! !
distinct!public!set operations! !
do:!debugger-step through!enumerating!public! !
elements!accessing!private! !
elements:!initializing!private! !
equals:!comparing!public! !
find:!public!searching! !
find:ifAbsent:!public!searching! !
findElementOrNil:!private!searching! !
fixCollisionsFrom:!private!removing! !
grow!helpers!private! !
hash:max:!private!searching! !
identityIncludes:!public!searching! !
includes:!public!searching! !
initialize!initializing!private! !
isHealthy!public! !
isSelfEvaluating!public!testing! !
isSelfEvaluating:!private!testing! !
moveFrom:to:!private!removing! !
occurrencesOf:!public!searching! !
postResize:!adding!private! !
preResize:!adding!private! !
printSelfEvaluatingOn:!printing!private! !
privateAt:put:!accessing!private! !
rehash!operations!public! !
remove:ifAbsent:!public!removing! !
removeAll!public! !
removeIndex:!private!removing! !
resize:!mutating!private! !
shrink!mutating!public! !
size!accessing!public! !
sortSelfEvaluatingElements:locale:!printing!private! !
uncheckedAdd:!adding!private! !
!

Core.Set methodProtocol: #Set attributes: #(#ansi #readOnly) selectors: #(#add: #addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #select: #size)!

!Core.Set class methodsFor!

defaultCapacity
	^2!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize.
	"

	| primes last count max smallPrimeOffsets largePrimeSizes |
	"Construct a difference table which can be used to calculate the nearest larger prime for
	each odd integer up to a certain limit. The greater the limit the more table space is used,
	although as this is a byte array this isn't likely to be a problem. Ultimately the use of a
	byte array limits the table size since at some point the offset to the next prime will be
	greater than 255."
	max := 2053.
	primes := self preferredSizesFrom: (Integer primesUpTo: max + 255).
	count := max bitShift: -1.
	smallPrimeOffsets := ByteArray new: count.
	last := 1.
	1 to: count
		do: 
			[:i |
			| n p |
			n := (i bitShift: 1) bitOr: 1.
			[(p := primes at: last) >= n] whileFalse: [last := last + 1].
			smallPrimeOffsets at: i put: p - n].	"Good prime sizes for larger tables"
	largePrimeSizes := #(1129 1151 1543 2069 2237 2423 2617 2797 2999 3167 3359 3539 3727 3911 4441 4787 5119 5471 5801 6143 6521 6827 7177 7517 7853 8783 9601 10243 10867 11549 12239 12919 13679 14293 15013 15731 17569 19051 20443 21767 23159 24611 25847 27397 28571 30047 31397 35771 38201 40841 43973 46633 48989 51631 54371 57349 60139 62969 70589 76091 80347 85843 90697 95791 101027 106261 111143 115777 120691 126311 140863 150523 160969 170557 181243 190717 201653 211891 221251 232591 242873 251443 282089 300869 321949 341227 362353 383681 401411 422927 443231 464951 482033 504011 562621 605779 647659 681607 723623 763307 808261 844709 886163 926623 967229 1014617)
				select: [:each | each > (primes at: last)].
	self addClassConstant: 'SmallPrimeOffsets' value: smallPrimeOffsets.
	self addClassConstant: 'MaxOffsetIndex' value: count.
	self addClassConstant: 'PrimeSizes' value: largePrimeSizes!

new
	"Answer a new instance of the receiver with the default initial capacity.
	Implementation Note: Although it is tempting to implement this using
	#basicNew: to avoid going through the sizing code, that makes subclassing
	much more fragile (e.g. they will often need to override #new as well as
	#new:), so avoid the temptation."

	^self new: self defaultCapacity!

new: count
	"Answer a new instance of the receiver with an initial capacity of at least 
	<integer> count elements (i.e. the size is a hint)."

	^(self basicNew: (self sizeFor: count)) initialize!

preferredSizesFrom: aCollection
	| avoidFactorsOf |
	"Reject any candidate primes which divide 256**k +- a, for k=[1..8] and a=[-32..32], unless < 256"
	avoidFactorsOf := OrderedCollection new.
	1 to: 8
		do: 
			[:k |
			| n |
			n := 256 raisedToInteger: k.
			-32 to: 32 do: [:a | avoidFactorsOf add: n + a]].
	^aCollection reject: 
			[:each |
			(##("Some primes to avoid as they nearly divide into one of our hash multipliers, 48271, or 16777619"
			Set new
				addAll: #(431 1609 101051);
				addAll: #(11 13 83 1123 5333);
				yourself) includes: each)
				or: [each > 256 and: [avoidFactorsOf anySatisfy: [:m | m \\ each == 0]]]	"Some primes to avoid as they nearly divide into one of our hash multipliers, 48271, or 16777619"]!

sizeFor: anInteger
	"Private - Answer the size of Set that should be created to hold anInteger elements.
	This formula should be kept in step with that in the instance method #privateAt:put:.
	Try to answer only prime sizes as these give a better hash distribution."

	| n i index low high |
	anInteger < 3
		ifTrue: 
			["Minimum capacity of Dolphin hashed collection is 3"
			^3].
	"Use a load factor of 0.6666~ as this can be calculated without division and is less than (1 - log(2))"
	n := anInteger + (anInteger + 1 bitShift: -1) bitOr: 1.
	i := n bitShift: -1.
	i <= MaxOffsetIndex ifTrue: [^(SmallPrimeOffsets basicAt: i) + n].

	"If outside range or blessed prime sizes (highly unlikely), then just return nearest odd number"
	high := PrimeSizes size.
	n > (PrimeSizes at: high) ifTrue: [^n bitOr: 1].

	"Binary search the blessed prime sizes"
	low := 1.
	
	[index := (high + low) // 2.
	low > high]
			whileFalse: [(PrimeSizes at: index) < n ifTrue: [low := index + 1] ifFalse: [high := index - 1]].
	^PrimeSizes at: low! !
!Core.Set class categoriesForMethods!
defaultCapacity!constants!private! !
initialize!development!initializing!private! !
new!instance creation!public! !
new:!instance creation!public! !
preferredSizesFrom:!development!initializing!private! !
sizeFor:!instance creation!private! !
!

Core.Set class methodProtocol: #'Set factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

