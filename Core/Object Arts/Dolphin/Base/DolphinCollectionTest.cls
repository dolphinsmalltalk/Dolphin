"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DolphinCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DolphinCollectionTest guid: (GUID fromString: '{c0608062-bc41-43cf-aefc-c89e6b500e6d}')!
DolphinCollectionTest comment: ''!
!DolphinCollectionTest categoriesForClass!Unclassified! !
!DolphinCollectionTest methodsFor!

assimilate: anObject
	^anObject!

assimilateElements: aCollection 
	^aCollection asArray collect: [:each | self assimilate: each]!

newCollection: aCollection
	^self collectionClass withAll: (self assimilateElements: aCollection)!

testAllSatisfy
	| subject |
	subject := self newCollection: #().
	"Empty should satisfy any predicate"
	self assert: (subject allSatisfy: [:each | false]).
	"Test with one, two, more than two elements"
	1 to: 3
		do: 
			[:i |
			| elems visited |
			elems := (1 to: i) collect: [:c | self assimilate: c].
			subject := self newCollection: elems.
			visited := OrderedCollection new.
			self
				assert: (subject allSatisfy: 
							[:e |
							visited add: e.
							e between: elems first and: elems last]).
			self assert: elems asSet equals: visited asSet.
			"Fail on first, middle, last"
			elems keysAndValuesDo: 
					[:k :c |
					visited := OrderedCollection new.
					self
						deny: (subject allSatisfy: 
									[:e |
									visited add: e.
									visited size < k]).
					self assert: (subject asArray copyFrom: 1 to: k) equals: visited asArray]]!

testAnyone
	| subject any |
	subject := self newCollection: #().
	self should: [subject anyOne] raise: Error.
	subject := self newCollection: #($a).
	self assert: subject anyOne equals: (self assimilate: $a).
	subject := self newCollection: #($a $b).
	any := subject anyOne.
	self assert: (subject anySatisfy: [:each | each == any])!

testAnySatisfy
	| subject |
	subject := self newCollection: #().
	"Empty should not satisfy any predicate"
	self deny: (subject anySatisfy: [:each | true]).
	"Test with one, two, more than two elements"
	1 to: 3
		do: 
			[:i |
			| elems visited |
			elems := (1 to: i) collect: [:c | self assimilate: c].
			subject := self newCollection: elems.
			visited := OrderedCollection new.
			"None satisfy - whole collection evaluated against predicate"
			self deny: (subject anySatisfy: 
							[:e |
							visited add: e.
							false]).
			self assert: elems asSet equals: visited asSet.
			"Find a match on first, middle, last"
			elems keysAndValuesDo: 
					[:k :c |
					visited := OrderedCollection new.
					self
						assert: (subject anySatisfy: 
									[:e |
									visited add: e.
									visited size = k]).
					self assert: (subject asArray copyFrom: 1 to: k) equals: visited asArray]]!

testCount
	| none all odd |
	all := [:each | true].
	none := [:each | false].
	odd := [:each | each asInteger odd].
	0 to: 5
		do: 
			[:i |
			| elems subject |
			elems := (1 to: i) collect: [:c | self assimilate: c].
			subject := self newCollection: elems.
			self assert: (subject count: all) equals: i.
			self assert: (subject count: none) equals: 0.
			self assert: (subject count: odd) equals: (i + 1) // 2]!

testDistinct
	| result |
	#(#() #($a) #($a $a) #($a $b) #($a $b $a) #($a $b $c $a $e)) do: 
			[:array |
			| testSubject |
			testSubject := self newCollection: array.
			result := testSubject distinct.
			self assert: testSubject species = result species.
			self assert: testSubject asSet size = result size.
			self assert: (result noDifference: testSubject asSet).
			(result class conformsToProtocol: #sequencedReadableCollection)
				ifTrue: 
					["Order should be preserved"
					self assert: testSubject asSet asSortedCollection asArray = result asArray]]!

testFold
	| result |
	#(#($c) #($c $e) #($e $c) #($c $b $e) #($e $b $c) #($b $e $c) #($b $c $e)) do: 
			[:array |
			| expected testSubject |
			testSubject := self newCollection: array.
			result := testSubject fold: [:max :each | each max: max].
			expected := testSubject asArray asSortedCollection last.
			self assert: result = expected].
	self should: [(self newCollection: #()) fold: [:a :b | a max b]] raise: Error.
	1 to: 100
		do: 
			[:i |
			result := (1 to: i) fold: [:product :each | product * each].
			self assert: result = i factorial]! !
!DolphinCollectionTest categoriesFor: #assimilate:!private!unit tests! !
!DolphinCollectionTest categoriesFor: #assimilateElements:!helpers!private! !
!DolphinCollectionTest categoriesFor: #newCollection:!helpers!private! !
!DolphinCollectionTest categoriesFor: #testAllSatisfy!public! !
!DolphinCollectionTest categoriesFor: #testAnyone!public!unit tests! !
!DolphinCollectionTest categoriesFor: #testAnySatisfy!public! !
!DolphinCollectionTest categoriesFor: #testCount!public! !
!DolphinCollectionTest categoriesFor: #testDistinct!public!unit tests! !
!DolphinCollectionTest categoriesFor: #testFold!public!unit tests! !

!DolphinCollectionTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!DolphinCollectionTest class categoriesFor: #isAbstract!public!Testing! !

