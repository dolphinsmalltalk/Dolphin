"Filed out from Dolphin Smalltalk X6"!

Collection variableSubclass: #Set
	instanceVariableNames: 'tally '
	classVariableNames: 'SmallPrimeOffsets'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Set guid: (GUID fromString: '{87B4C50B-026E-11D3-9FD7-00A0CC3E4A32}')!
Set comment: 'Set is a generic collection class which represents an unordered, extensible/contractible, collection, accessible only by value, not by external keys. Element comparison is by equality (i.e. using #hash and #=).'!
!Set categoriesForClass!Collections-Unordered! !
!Set methodsFor!

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

add: newElement
	"Include the <Object> newElement as one of the elements of the receiver. 
	If newElement is nil, then it is not added. Answer newElement.
	Note: If newElement is already in the receiver (i.e. has an equal element 
	already in the receiver), then this operation has no effect. Note further
	that if an equal element already exists then it is not overwritten, but the
	answer is still newElement. I tried to persuade the committee that the original
	element should be answered, but they didn't see the problem."

	| index |
	newElement isNil ifTrue: [^newElement].		"Sets cannot store empty objects"
	index := self findElementOrNil: newElement.
	(self basicAt: index) isNil
		ifTrue: [self privateAt: index put: newElement].
	^newElement!

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

averageProbesPerElement
	"Answer the average number of probes necessary to  find an element 
	in the receiver. Ideally this should be close to 1."

	| probes capacity |
	self isEmpty ifTrue: [^1].
	probes := 0.
	capacity := self basicSize.
	1 to: capacity
		do: 
			[:i | 
			| element |
			element := self basicAt: i.
			element notNil 
				ifTrue: 
					[| pos distance |
					pos := self bestSlotFor: element boundedBy: capacity.
					distance := i - pos.
					distance < 0 ifTrue: [distance := distance + capacity].
					probes := probes + distance + 1]].
	^probes asFloat / self size!

bestSlotFor: element boundedBy: capacity
	^self hash: element max: capacity!

collisions
	"Answer the <Integer> number of the elements which are not found
	on first probe."

	| answer capacity |
	answer := 0.
	capacity := self basicSize.
	1 to: capacity
		do: 
			[:i | 
			| element |
			element := self basicAt: i.
			element notNil 
				ifTrue: 
					[(self hash: element max: capacity) ~= i ifTrue: [answer := answer + 1]]].
	^answer!

copyElementsInto: newMe
	"Private - Add the receiver's elements into the argument, newMe.
	Part of the implementation of hashed collection resizing. Subclasses
	override as necessary."

	self do: [:element | newMe uncheckedAdd: element]!

copyWithoutDuplicates
	"Answers a copy of the receiver that contains no duplicate objects. 
	Implementation Note: Sets are already free of duplicates so a plain
	copy will do."

	^self shallowCopy!

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
	"Answer whether the receiver is equivalent to the <Object>, comperand.
	I often think this ought to be the definition of Set>>=, but for compatibility
	with other Smalltalks, we'll use the alternative selector.
	Implementation Note: Do our best to avoid an element-by-element
	comparison. The algorithm will be slowest where the comperand is
	equal to the receiver, but not identical."

	comperand == self ifTrue: [^true].
	comperand species == self species ifFalse: [^false].
	comperand size == self size ifFalse: [^false].
	self do: [:e | (comperand includes: e) ifFalse: [^false]].
	^true!

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
	capacity := self basicSize.
	index := self hash: anObject max: capacity.
	
	[| element |
	(element := self basicAt: index) isNil or: [anObject = element]] 
			whileFalse: [index := index \\ capacity + 1].
	^index!

fixCollisionsFrom: index
	"Private - Rehashes objects in the collection after index to see if any of
	them hash to index.  If so, that object is copied to index, and the
	process repeats with that object's index, until a nil is encountered."

	| slotIndex capacity element |
	slotIndex := index.
	capacity := self basicSize.
	[slotIndex := slotIndex \\ capacity + 1.
	  (element := self basicAt: slotIndex) isNil]
		whileFalse:  [ | hashIndex |
			hashIndex := self findElementOrNil: element.
			(self basicAt: hashIndex) isNil ifTrue: [self moveFrom: slotIndex to: hashIndex]]!

grow
	"Private - Expand the receiver to a capacity suitable for holding more elements"

	self resize: self size * 2!

hash: anObject max: anInteger
	^anObject hash \\ anInteger + 1!

identityIncludes: target
	"Answer whether the <Object> argument, target, is one of the receiver's elements.
	Implementation Note: If anObject is identical to any object in the Set, then
	it must also be equal to that object, which means it must have the same hash
	value as that object, and therefore we can use a hashed lookup to optimize
	this method over the serial search in the Collection implementation."

	| element |
	element := self basicAt: (self findElementOrNil: target).
	^element notNil and: [element == target]!

includes: target
	"Answer whether the <Object> argument, target, is one of 
	the elements of the receiver."

	^(self basicAt: (self findElementOrNil: target)) notNil!

initialize
	"Private - Instance variable initialization. The tally records the number of elements."

	tally := 0
!

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

privateAt: index put: newObject
	"Private - Insert newObject as the element of the receiver at index. Attempts to maintain the
	'optimal' load factor (and thereby ensures there is always a least one empty slot in the Set, an 
	invariant required by the search algorithm)."

	| capacity |
	self basicAt: index put: newObject.
	tally := tally + 1.
	capacity := self basicSize.
	capacity - tally <= (capacity bitShift: -2) ifTrue: [self grow].
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

removeIndex: anInteger
	"Private - Remove the element at index, anInteger, in the receiver. Does not
	check that the element is empty."

	self basicAt: anInteger put: nil.
	tally := tally - 1.
	self fixCollisionsFrom: anInteger!

resize: anInteger
	"Private - Resize the receiver to have a capacity suitable for accomodating
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

stbSaveOn: anSTBOutFiler
	"Save out a binary representation of the receiver to anSTBOutFiler."

	anSTBOutFiler saveObject: self as: (STBCollectionProxy forCollection: self)!

uncheckedAdd: newObject
	"Private - Add newObject to the receiver, without checking to see if it is already present.
	We also assume the receiver is large enough to accommodate the new element, and so do not
	attempt to maintain the load factor."

	tally := tally + 1.
	^self basicAt: (self findElementOrNil: newObject) put: newObject! !
!Set categoriesFor: #-!public!removing! !
!Set categoriesFor: #_deepCopy:!copying!private! !
!Set categoriesFor: #_deepCopyElementsInto:trail:!copying!private! !
!Set categoriesFor: #add:!adding!public! !
!Set categoriesFor: #approxSize!accessing!private! !
!Set categoriesFor: #asSet!converting!public! !
!Set categoriesFor: #at:!accessing!public! !
!Set categoriesFor: #at:put:!accessing!public! !
!Set categoriesFor: #averageProbesPerElement!development!public!statistics! !
!Set categoriesFor: #bestSlotFor:boundedBy:!development!private!statistics! !
!Set categoriesFor: #collisions!development!public!statistics! !
!Set categoriesFor: #copyElementsInto:!mutating!private! !
!Set categoriesFor: #copyWithoutDuplicates!copying!public! !
!Set categoriesFor: #do:!enumerating!public! !
!Set categoriesFor: #elements!accessing!private! !
!Set categoriesFor: #elements:!accessing!private! !
!Set categoriesFor: #equals:!comparing!public! !
!Set categoriesFor: #find:!public!searching! !
!Set categoriesFor: #find:ifAbsent:!public!searching! !
!Set categoriesFor: #findElementOrNil:!private!searching! !
!Set categoriesFor: #fixCollisionsFrom:!private!removing! !
!Set categoriesFor: #grow!adding!private! !
!Set categoriesFor: #hash:max:!private!searching! !
!Set categoriesFor: #identityIncludes:!public!searching! !
!Set categoriesFor: #includes:!public!searching! !
!Set categoriesFor: #initialize!initializing!private! !
!Set categoriesFor: #moveFrom:to:!private!removing! !
!Set categoriesFor: #occurrencesOf:!public!searching! !
!Set categoriesFor: #postResize:!adding!private! !
!Set categoriesFor: #preResize:!adding!private! !
!Set categoriesFor: #privateAt:put:!accessing!private! !
!Set categoriesFor: #rehash!operations!public! !
!Set categoriesFor: #remove:ifAbsent:!public!removing! !
!Set categoriesFor: #removeIndex:!private!removing! !
!Set categoriesFor: #resize:!mutating!private! !
!Set categoriesFor: #shrink!mutating!public! !
!Set categoriesFor: #size!accessing!public! !
!Set categoriesFor: #stbSaveOn:!binary filing!public! !
!Set categoriesFor: #uncheckedAdd:!adding!private! !

Set methodProtocol: #Set attributes: #(#ansi #readOnly) selectors: #(#add: #addAll: #allSatisfy: #anySatisfy: #asArray #asBag #asByteArray #asOrderedCollection #asSet #asSortedCollection #asSortedCollection: #collect: #detect: #detect:ifNone: #do: #do:separatedBy: #includes: #inject:into: #isEmpty #notEmpty #occurrencesOf: #rehash #reject: #remove: #remove:ifAbsent: #removeAll: #select: #size)!

!Set class methodsFor!

initialize
	"Private - Initialize the receiver's class variables."

	self initializeSizeTable!

initializeSizeTable
	"Private - Construct a difference table which can be used to calculate the nearest 
	larger prime for each odd integer up to a certain limit.  The greater the limit the more
	table space is used, although as this is a byte array this isn't likely to be a problem.
	Ultimately the use of a byte array limits the table size since at some point the offset
	to the next prime will be greater than 255.

		self initializeSizeTable
	"

	| primes last count max |
	max := (2**12)+1.	"Max size for which entry will be found in table"
	primes := Integer primesUpTo: max+255.
	count := max bitShift: -1.
	SmallPrimeOffsets := ByteArray new: count.
	last := 1.
	1 to: count do: [:i | | n p |
		n := (i bitShift: 1) bitOr: 1.
		[(p := primes at: last) >= n] whileFalse: [last := last + 1].
		SmallPrimeOffsets at: i put: p - n]!

new
	"Answer a new instance of the receiver with the default initial capacity.
	Implementation Note: Although it is tempting to implement this using
	#basicNew: to avoid going through the sizing code, that makes subclassing
	much more fragile (e.g. they will often need to override #new as well as
	#new:), so avoid the temptation."

	^self new: 2!

new: count
	"Answer a new instance of the receiver with an initial capacity of at least 
	<integer> count elements (i.e. the size is a hint)."

	^(self basicNew: (self sizeFor: count)) initialize!

sizeFor: anInteger
	"Private - Answer the size of Set that should be created to hold anInteger elements.
	This formula should be kept in step with that in the instance method #privateAt:put:.
	Try to answer only prime sizes as these give a better hash distribution."

	^anInteger < 2 
		ifTrue: 
			["Minimum capacity of Dolphin hashed collection is 2"

			2]
		ifFalse: 
			[| n i |
			n := anInteger * 100 // 75 bitOr: 1.
			i := n bitShift: -1.
			^i > SmallPrimeOffsets basicSize 
				ifTrue: 
					["Larger sizes just left odd"

					n]
				ifFalse: 
					["Calculate nearest prime larger than requested size plus 25% slop"

					(SmallPrimeOffsets basicAt: i) + n]]! !
!Set class categoriesFor: #initialize!development!initializing!private! !
!Set class categoriesFor: #initializeSizeTable!initializing!private! !
!Set class categoriesFor: #new!instance creation!public! !
!Set class categoriesFor: #new:!instance creation!public! !
!Set class categoriesFor: #sizeFor:!instance creation!private! !

Set class methodProtocol: #'Set factory' attributes: #(#ansi #readOnly) selectors: #(#new #new: #with: #with:with: #with:with:with: #with:with:with:with: #withAll:)!

