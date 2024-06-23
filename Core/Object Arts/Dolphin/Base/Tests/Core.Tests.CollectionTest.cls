"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.CollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.CollectionTest guid: (Core.GUID fromString: '{c0608062-bc41-43cf-aefc-c89e6b500e6d}')!

Core.Tests.CollectionTest isNonInstantiable: true!

Core.Tests.CollectionTest comment: ''!

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
			elems := 1 to: i.
			subject := self newCollection: elems.
			elems := self assimilateElements: elems.
			visited := OrderedCollection new.
			self
				assert: (subject allSatisfy: 
							[:e |
							visited add: e.
							e between: elems first value and: elems last value]).
			self assert: visited asSet equals: (elems collect: [:each | each value]) asSet.
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
	self assert: subject anyOne equals: (self assimilate: $a) value.
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
			elems := 1 to: i.
			subject := self newCollection: elems.
			elems := self assimilateElements: elems.
			visited := OrderedCollection new.
			"None satisfy - whole collection evaluated against predicate"
			self deny: (subject anySatisfy: 
							[:e |
							visited add: e.
							false]).
			self assert: visited asSet equals: (elems collect: [:each | each value]) asSet.
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

testAsArray
	| subject ordered |
	subject := self newCollection: #().
	ordered := subject asArray.
	self assert: ordered equals: #().
	"Test with one, two, more than two elements"
	1 to: 3
		do: 
			[:i |
			| elems expected |
			elems := 1 to: i.
			subject := self newCollection: elems.
			expected := Array new: i.
			subject inject: 1 into: [:j :each | expected at: j put: each. j + 1].
			ordered := subject asArray.
			self assert: ordered equals: expected]!

testAsOrderedCollection
	| subject ordered |
	subject := self newCollection: #().
	ordered := subject asOrderedCollection.
	self assert: ordered equals: OrderedCollection new.
	"Test with one, two, more than two elements"
	1 to: 3
		do: 
			[:i |
			| elems expected |
			elems := 1 to: i.
			subject := self newCollection: elems.
			expected := OrderedCollection new.
			subject do: [:each | expected addLast: each].
			ordered := subject asOrderedCollection.
			self assert: ordered size equals: i.
			self assert: ordered equals: expected]!

testCopyWith
	#(#() #($a) #($a $a) #($a $b) #($a $b $a)) do: 
			[:array |
			| subject actual expected |
			subject := self newCollection: array.
			actual := subject copyWith: (self assimilate: $a).
			expected := self newCollection: array , #($a).
			self assert: actual equals: expected]!

testCopyWithout
	#(#() #($a) #($a $a) #($a $b) #($a $b $a) #($a $b $c $a $e)) do: 
			[:array |
			| subject actual expected |
			subject := self newCollection: array.
			actual := subject copyWithout: (self assimilate: $a) value.
			expected := self newCollection: (array reject: [:each | each = $a]).
			self assert: actual equals: expected]!

testCount
	| none all odd |
	all := [:each | true].
	none := [:each | false].
	odd := [:each | each asInteger odd].
	0 to: 5
		do: 
			[:i |
			| elems subject |
			elems := (1 to: i).
			subject := self newCollection: elems.
			self assert: (subject count: all) equals: i.
			self assert: (subject count: none) equals: 0.
			self assert: (subject count: odd) equals: (i + 1) // 2]!

testDetectIfNone
	| absent |
	absent := Object new.
	#(#() #($a) #($a $b) #($a $b $c $d $e)) do: 
			[:eachCase |
			| subject |
			subject := self newCollection: eachCase.
			eachCase do: 
					[:elem |
					| actualElem |
					actualElem := (self assimilate: elem) value.
					self assert: (subject detect: [:each | each = actualElem] ifNone: [absent]) equals: actualElem.
					actualElem := self assimilate: $f.
					self assert: (subject detect: [:each | each = actualElem] ifNone: [absent]) identicalTo: absent]]!

testDifference
	| empty a aa ab b |
	empty := self newCollection: #().
	a := self newCollection: #($a).
	aa := self newCollection: #($a $a).
	ab := self newCollection: #($a $b).
	b := self newCollection: #($b).
	self assert: (empty difference: empty) equals: empty.
	self assert: (empty difference: a) equals: empty.
	self assert: (empty difference: aa) equals: empty.
	self assert: (a difference: empty) equals: a.
	self assert: (a difference: a) equals: empty.
	self assert: (a difference: aa) equals: empty.
	self assert: (a difference: ab) equals: empty.
	self assert: (a difference: b) equals: a.
	self assert: (aa difference: empty) equals: aa.
	self assert: (aa difference: a) equals: empty.
	self assert: (aa difference: aa) equals: empty.
	self assert: (aa difference: ab) equals: empty.
	self assert: (aa difference: b) equals: aa.
	self assert: (ab difference: empty) equals: ab.
	self assert: (ab difference: a) equals: b.
	self assert: (ab difference: aa) equals: b.
	self assert: (ab difference: ab) equals: empty.
	self assert: (ab difference: b) equals: a!

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

testDoSeparatedBy
	#(#() #($a) #($a $b) #($a $b $c $d $e)) do: 
			[:each |
			| subject enumerated separations |
			subject := self newCollection: each.
			enumerated := OrderedCollection new.
			separations := 0.
			subject do: [:element | enumerated add: element] separatedBy: [separations := separations + 1].
			self assert: enumerated asArray equals: subject asArray.
			self assert: separations equals: (subject size - 1 max: 0)]!

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
			self assert: result equals: i factorial]!

testSingle
	| subject |
	subject := self newCollection: #().
	self should: [subject single] raise: Error.
	subject := self newCollection: #($a).
	self assert: subject single equals: (self assimilate: $a) value.
	subject := self newCollection: #($a $b).
	self should: [subject single] raise: Error!

testStoreOn
	#(#() #($a) #($a $b) #($a $b $a)) do: 
			[:each |
			| subject rehydrated storeString |
			subject := self newCollection: each.
			storeString := subject storeString.
			rehydrated := Compiler evaluate: storeString.
			self assert: rehydrated equals: subject]! !

!Core.Tests.CollectionTest categoriesForMethods!
assimilate:!private!unit tests! !
assimilateElements:!helpers!private! !
collectionClass!constants!private! !
newCollection:!helpers!private! !
shouldnt:implement:!helpers!private! !
testAllSatisfy!public!unit tests! !
testAnyone!public!unit tests! !
testAnySatisfy!public!unit tests! !
testAsArray!public!unit tests! !
testAsOrderedCollection!public!unit tests! !
testCopyWith!public!unit tests! !
testCopyWithout!public!unit tests! !
testCount!public!unit tests! !
testDetectIfNone!public!unit tests! !
testDifference!public!unit tests! !
testDistinct!public!unit tests! !
testDoSeparatedBy!public!unit tests! !
testFold!public!unit tests! !
testSingle!public!unit tests! !
testStoreOn!public!unit tests! !
!

