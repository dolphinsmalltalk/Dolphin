"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.CollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.CollectionTest guid: (Core.GUID fromString: '{c0608062-bc41-43cf-aefc-c89e6b500e6d}')!
Core.Tests.CollectionTest isNonInstantiable: true!
Core.Tests.CollectionTest comment: ''!
!Core.Tests.CollectionTest categoriesForClass!Unclassified! !
!Core.Tests.CollectionTest methodsFor!

assimilate: anObject
	^anObject!

assimilateElements: aCollection 
	^aCollection asArray collect: [:each | self assimilate: each]!

collectionClass
	^self subclassResponsibility!

newCollection: aCollection
	^self collectionClass withAll: (self assimilateElements: aCollection)!

shouldnt: aNiladicBlock implement: aSymbol
	self
		should: aNiladicBlock
		raise: Error
		matching: 
			[:ex |
			ex description
				= ('<1p> should not implement <2p>' expandMacrosWith: self collectionClass with: aSymbol)]!

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
			self assert: visited asSet equals: elems asSet.
			"Fail on first, middle, last"
			elems keysAndValuesDo: 
					[:k :c |
					visited := OrderedCollection new.
					self
						deny: (subject allSatisfy: 
									[:e |
									visited add: e.
									visited size < k]).
					self assert: visited asArray equals: (subject asArray copyFrom: 1 to: k)]]!

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
			self assert: visited asSet equals: elems asSet.
			"Find a match on first, middle, last"
			elems keysAndValuesDo: 
					[:k :c |
					visited := OrderedCollection new.
					self
						assert: (subject anySatisfy: 
									[:e |
									visited add: e.
									visited size = k]).
					self assert: visited asArray equals: (subject asArray copyFrom: 1 to: k)]]!

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
			self assert: testSubject asSet size equals: result size.
			self assert: (result noDifference: testSubject asSet).
			(result class conformsToProtocol: #sequencedReadableCollection)
				ifTrue: 
					["Order should be preserved"
					self assert: testSubject asSet asSortedCollection asArray equals: result asArray]]!

testFold
	| result |
	#(#($c) #($c $e) #($e $c) #($c $b $e) #($e $b $c) #($b $e $c) #($b $c $e)) do: 
			[:array |
			| expected testSubject |
			testSubject := self newCollection: array.
			result := testSubject fold: [:max :each | each max: max].
			expected := testSubject asArray asSortedCollection last.
			self assert: result equals: expected].
	self should: [(self newCollection: #()) fold: [:a :b | a max b]] raise: Error.
	1 to: 100
		do: 
			[:i |
			result := (1 to: i) fold: [:product :each | product * each].
			self assert: result equals: i factorial]! !
!Core.Tests.CollectionTest categoriesFor: #assimilate:!private!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #assimilateElements:!helpers!private! !
!Core.Tests.CollectionTest categoriesFor: #collectionClass!constants!private! !
!Core.Tests.CollectionTest categoriesFor: #newCollection:!helpers!private! !
!Core.Tests.CollectionTest categoriesFor: #shouldnt:implement:!helpers!private! !
!Core.Tests.CollectionTest categoriesFor: #testAllSatisfy!public!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #testAnyone!public!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #testAnySatisfy!public!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #testCount!public!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #testDistinct!public!unit tests! !
!Core.Tests.CollectionTest categoriesFor: #testFold!public!unit tests! !

