"Filed out from Dolphin Smalltalk"!

Core.Tests.CollectionTest
	subclass: #'Core.Tests.AbstractSetTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.AbstractSetTest guid: (Core.GUID fromString: '{033c7642-45db-489a-b839-dfa0620bf22e}')!

Core.Tests.AbstractSetTest isNonInstantiable: true!

Core.Tests.AbstractSetTest comment: ''!

!Core.Tests.AbstractSetTest methodsFor!

assertCommutativelyEqual: aSet other: anotherSet
	self assert: aSet equals: anotherSet.
	self assert: anotherSet equals: aSet!

assertIs: copySet deepCopyOf: sourceSet
	self deny: copySet identicalTo: sourceSet.
	self assert: copySet size identicalTo: sourceSet size.
	self
		assertIs: copySet asSortedArray
		deepCopyOf: sourceSet asSortedArray
		visited: (IdentityDictionary with: copySet -> sourceSet)!

assertIs: copySet shallowCopyOf: sourceSet
	self deny: copySet identicalTo: sourceSet.
	self assert: copySet size identicalTo: sourceSet size.
	sourceSet asArray with: copySet asArray
		do: [:eachSource :eachCopy | self assert: eachSource identicalTo: eachCopy]!

assertValidSet: aSet 
	| any |
	any := aSet collect: [:each | each].
	any do: [:each | self assert: (aSet includes: each)]!

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
	self subclassResponsibility!

testAllInstancesValid
	| invalid |
	invalid := self collectionClass allInstances
				select: [:each | each anySatisfy: [:elem | (each includes: elem) not]].
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
	set := self newEmpty.
	self elements keysAndValuesDo: [:i :e | set add: i -> e].
	set size + 1 to: set size + 6 do: [:i | set add: i -> Object new].
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
	self assertCommutativelyEqual: set other: setb!

testIncludes
	| set elements |
	set := self newSet.
	elements := self elements.
	elements do: [:each | self assert: (set includes: each)].
	self deny: (set includes: elements second hash).
	self deny: (set includes: nil)!

testIsSelfEvaluating
	| circular |
	self newCollection: {1}.
	self assert: self newEmpty isSelfEvaluating.
	self assert: (self newCollection: {1}) isSelfEvaluating.
	self assert: (self newCollection: {1. 'a' -> $b. Object}) isSelfEvaluating.
	self deny: (self newCollection: {Object new}) isSelfEvaluating.
	circular := self newEmpty.
	circular add: circular.
	self deny: circular isSelfEvaluating.
	
!

testMaintainsLoadFactor
	"Verify that slop is maintained as items are added to the Set and it is grown."

	| subject expectedSlots primes |
	subject := self newEmpty.
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

testPrintString
	| setClass subject sortableAssociations unsortableAssociations |
	setClass := self collectionClass.
	self assert: setClass new printString equals: '<1p> new' << setClass.
	self assert: (setClass with: $a) printString equals: '(<1p> with: $a)' << setClass.
	self assert: (setClass with: Object) printString equals: '(<1p> with: Object)' << setClass.
	self assert: (setClass with: Object new) printString
		equals: '<2?an:a> <1p>(an Object)' << { setClass. setClass shortName first isVowel }.
	"Sets are unordered, so this test could break easily if we are not careful to avoid an unpredictable ordering."
	self assert: (setClass with: $a with: $b) printString equals: '(<1p> withAll: #($a $b))' << setClass.
	sortableAssociations := { 1 -> Object. 2 -> Association }.
	subject := setClass withAll: sortableAssociations.
	self assert: subject printString
		equals: '(<1p> withAll: <2p>)' << { setClass. sortableAssociations }.
	unsortableAssociations := { '1' -> Object. 2 -> Association }.
	subject := setClass withAll: unsortableAssociations.
	self assert: subject printString
		equals: '(<1p> withAll: <2p>)'
				<< { setClass. unsortableAssociations sort: [:a :b | a printString <= b printString] }!

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

!Core.Tests.AbstractSetTest categoriesForMethods!
assertCommutativelyEqual:other:!helpers!private! !
assertIs:deepCopyOf:!private!unit tests! !
assertIs:shallowCopyOf:!private!unit tests! !
assertValidSet:!private!unit tests! !
denyCommutativelyEqual:other:!helpers!private! !
elements!public!unit tests! !
loadFactor!constants!private! !
minimumCapacity!constants!private! !
newEmpty!helpers!private! !
newSet!private!unit tests! !
newSet:!private!unit tests! !
setSizes!helpers!private! !
testAddIfAbsent!public! !
testAllInstancesValid!public!unit tests! !
testClassSizeFor!public!unit tests! !
testCopy!public!unit tests! !
testDeepCopy!public!unit tests! !
testEquals!public!unit tests! !
testIncludes!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testMaintainsLoadFactor!public!unit tests! !
testNil!public!unit tests! !
testPrintString!public!unit tests! !
testRemove!public!unit tests! !
testShallowCopy!public!unit tests! !
!

