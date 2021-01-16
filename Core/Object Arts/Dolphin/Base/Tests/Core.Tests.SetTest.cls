"Filed out from Dolphin Smalltalk 7"!

Core.Tests.CollectionTest subclass: #'Core.Tests.SetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SetTest guid: (Core.GUID fromString: '{2108692a-0ee3-46ea-a9d6-46b3227871c6}')!
Core.Tests.SetTest comment: ''!
!Core.Tests.SetTest categoriesForClass!Unclassified! !
!Core.Tests.SetTest methodsFor!

assertCommutativelyEqual: aSet other: anotherSet
	self assert: aSet equals: anotherSet.
	self assert: anotherSet equals: aSet!

assertIs: copySet shallowCopyOf: sourceSet
	self deny: copySet identicalTo: sourceSet.
	self assert: copySet size identicalTo: sourceSet size.
	sourceSet asArray with: copySet asArray
		do: [:eachSource :eachCopy | self assert: eachSource identicalTo: eachCopy]!

assertValidSet: aSet 
	| any |
	any := aSet collect: [:each | each].
	any do: [:each | self assert: (aSet includes: each)]!

collectionClass
	^Set!

denyCommutativelyEqual: aSet other: anotherSet
	self deny: aSet equals: anotherSet.
	self deny: anotherSet equals: aSet!

elements
	^#(1 'b' #a)!

loadFactor
	^2.0 / 3!

minimumCapacity
	^3!

newEmpty
	^self collectionClass new!

newSet
	| elements |
	elements := self elements.
	^self newSet: elements!

newSet: elements
	| set |
	set := self newEmpty.
	elements do: 
			[:each |
			set add: each.
			self assert: (set includes: each)].
	^set!

setSizes
	| lastSmall |
	lastSmall := (Set.SmallPrimeOffsets at: Set.MaxOffsetIndex) + (Set.MaxOffsetIndex * 2 + 1).
	^((Set preferredSizesFrom: (Integer primesUpTo: lastSmall + 256))
		select: [:each | each <= lastSmall]) , (Set.PrimeSizes select: [:each | each > lastSmall])!

testAddIfAbsent
	| subject element1 element2 |
	subject := Set new.
	element1 := 'a'.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	self assert: subject asArray equals: {element1}.
	self assert: (subject addIfAbsent: element1) identicalTo: 'a'.
	element2 := String with: $a.
	self assert: (subject addIfAbsent: element2) identicalTo: element1.
	self assert: (subject includes: element2).
	self assert: subject asArray equals: {element1}!

testAllHealthy
	"Test whether all subinstances are correctly hashed."

	| unhealthy |
	unhealthy := Set allSubinstances reject: [:each | each isHealthy].
	self assert: unhealthy asArray equals: #()!

testAllInstancesValid
	| invalid |
	invalid := self collectionClass allSubinstances
				select: [:each | (each isKindOf: Dictionary) not and: [each anySatisfy: [:elem | (each includes: elem) not]]].
	self assert: invalid isEmpty!

testClassSizeFor
	"The capacity algorithm should be a prime that allows for at least 1.5x the size requested. Minimum capacity is 5."

	| actualSlots previousPrime primes |
	primes := self setSizes asSortedCollection.
	1 to: 4096
		do: 
			[:size |
			| expectedSlots i |
			expectedSlots := size / self loadFactor.
			actualSlots := self collectionClass sizeFor: size.
			self assert: actualSlots isPrime.
			self assert: expectedSlots <= actualSlots.
			i := primes anyIndexOf: actualSlots.
			self deny: i equals: 0.
			expectedSlots >= self minimumCapacity
				ifTrue: 
					[previousPrime := primes at: i - 1.
					self assert: previousPrime < expectedSlots]]!

testCopy
	"A copy of a set should be a shallow copy. i.e. it shares the same elements, but is not itself the same object"

	| set copy |
	set := self newSet.
	copy := set copy.
	self assertIs: copy shallowCopyOf: set.
	self assertValidSet: copy!

testDeepCopy
	"#2066"

	| set copy |
	set := self newSet.
	5 timesRepeat: [set add: Object new].
	set shrink.
	set do: [:each | self assert: (set includes: each)].
	copy := set deepCopy.
	self assertIs: copy deepCopyOf: set.
	self assertValidSet: copy!

testEquals
	"Sets and IdentitySets are equal if they have the same elements"

	| set setb |
	set := self newSet.
	"Identical"
	self assert: set equals: set.
	setb := self newSet.
	"Equal"
	self assertCommutativelyEqual: setb other: set.
	setb := setb asIdentitySet.
	self assertCommutativelyEqual: setb other: set.
	"Extra object in one set - not equal"
	setb add: Object new.
	self denyCommutativelyEqual: setb other: set.
	"Same size, but differ by one element"
	setb remove: self elements last.
	self denyCommutativelyEqual: setb other: set.
	"Sets are never equals to arrays"
	self denyCommutativelyEqual: set other: self elements.
	"Empty sets"
	setb := self newEmpty.
	self assert: setb equals: setb.
	self denyCommutativelyEqual: setb other: set.
	"Two empty sets are equal"
	set := self newEmpty.
	self assertCommutativelyEqual: set other: setb.
	"Elements are compared with #=; Integer 1 is equal to Float 1.0"
	set := self newSet: #(1).
	setb := self newSet: #(1.0).
	self assertCommutativelyEqual: set other: setb!

testIncludes
	| set elements |
	set := self newSet.
	elements := self elements.
	elements do: [:each | self assert: (set includes: each)].
	self deny: (set includes: elements second hash).
	self deny: (set includes: nil)!

testMaintainsLoadFactor
	"Verify that slop is maintained as items are added to the Set and it is grown."

	| subject expectedSlots primes |
	subject := self collectionClass new.
	self assert: subject size equals: 0.
	self assert: subject basicSize equals: self minimumCapacity.
	expectedSlots := self minimumCapacity.
	primes := self setSizes.
	(1 to: 2048) keysAndValuesDo: 
			[:expectedSize :each |
			| minimumSlots actualSlots actualSize originalSlots slop minGrownSlots |
			minimumSlots := expectedSize / self loadFactor.
			originalSlots := subject basicSize.
			subject add: each.
			actualSize := subject size.
			actualSlots := subject basicSize.
			self assert: actualSlots >= minimumSlots.
			slop := actualSlots - actualSize.
			self assert: slop >= (actualSlots - (actualSlots * self loadFactor)).
			"If growth is needed, should grow to at least double the capacity"
			minGrownSlots := (expectedSize - 1) * 2 / self loadFactor.
			originalSlots < minimumSlots ceiling
				ifTrue: [expectedSlots := primes detect: [:p | p >= minGrownSlots]].
			self assert: actualSize equals: expectedSize.
			self assert: actualSlots equals: expectedSlots]!

testNil
	| set |
	set := self newEmpty.
	self shouldnt: [set add: nil] raise: Error!

testRemove
	| set elements |
	set := self newSet.
	elements := self elements.
	self should: [set remove: elements second hash] raise: NotFoundError.
	self assert: (set remove: elements second) identicalTo: elements second.
	self should: [set remove: elements second] raise: NotFoundError!

testShallowCopy
	| set copy |
	set := self newSet.
	copy := set shallowCopy.
	self assertIs: copy shallowCopyOf: set.
	self assertValidSet: copy! !
!Core.Tests.SetTest categoriesFor: #assertCommutativelyEqual:other:!helpers!private! !
!Core.Tests.SetTest categoriesFor: #assertIs:shallowCopyOf:!private!unit tests! !
!Core.Tests.SetTest categoriesFor: #assertValidSet:!private!unit tests! !
!Core.Tests.SetTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.SetTest categoriesFor: #denyCommutativelyEqual:other:!helpers!private! !
!Core.Tests.SetTest categoriesFor: #elements!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #loadFactor!constants!private! !
!Core.Tests.SetTest categoriesFor: #minimumCapacity!constants!private! !
!Core.Tests.SetTest categoriesFor: #newEmpty!helpers!private! !
!Core.Tests.SetTest categoriesFor: #newSet!private!unit tests! !
!Core.Tests.SetTest categoriesFor: #newSet:!private!unit tests! !
!Core.Tests.SetTest categoriesFor: #setSizes!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testAddIfAbsent!public! !
!Core.Tests.SetTest categoriesFor: #testAllHealthy!public! !
!Core.Tests.SetTest categoriesFor: #testAllInstancesValid!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testClassSizeFor!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testCopy!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testDeepCopy!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testEquals!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testIncludes!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testMaintainsLoadFactor!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testNil!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testRemove!public!unit tests! !
!Core.Tests.SetTest categoriesFor: #testShallowCopy!public!unit tests! !

