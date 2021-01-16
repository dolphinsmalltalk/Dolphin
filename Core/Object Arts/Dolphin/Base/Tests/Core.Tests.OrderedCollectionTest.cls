"Filed out from Dolphin Smalltalk 7"!

Core.Tests.SequencedGrowableCollectionTest subclass: #'Core.Tests.OrderedCollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.OrderedCollectionTest guid: (Core.GUID fromString: '{c951706f-236d-4671-b849-626652dda25e}')!
Core.Tests.OrderedCollectionTest comment: ''!
!Core.Tests.OrderedCollectionTest categoriesForClass!Unclassified! !
!Core.Tests.OrderedCollectionTest methodsFor!

collectionClass
	^OrderedCollection!

newCollection: aCollection
	"Create a test subject that has a firstIndex that is not 1, as this then causes inherited tests to excercise the OrderedCollection offsetting logic."

	| subject |
	subject := aCollection size == 0
				ifTrue: [self collectionClass withAll: #($1)]
				ifFalse: 
					[subject := self collectionClass withAll: (self assimilateElements: aCollection).
					subject := self collectionClass withAll: (Array with: subject first) , subject].
	subject removeFirst.
	^subject!

testFindFirst2
	| subject |
	subject := self collectionClass withAll: (1 to: 4).
	subject removeFirst.
	self assert: (subject findFirst: [:each | each = 2]) equals: 1.
	self assert: (subject findFirst: [:each | each = 3]) equals: 2.
	self assert: (subject findFirst: [:each | each = 4]) equals: 3.
	self assert: (subject findFirst: [:each | each = 1]) equals: 0.
	subject removeLast.
	self assert: (subject findFirst: [:each | each = 2]) equals: 1.
	self assert: (subject findFirst: [:each | each = 3]) equals: 2.
	self assert: (subject findFirst: [:each | each = 4]) equals: 0.
	self assert: (subject findFirst: [:each | each = 1]) equals: 0.
	subject removeFirst.
	self assert: (subject findFirst: [:each | each = 2]) equals: 0.
	self assert: (subject findFirst: [:each | each = 3]) equals: 1.
	self assert: (subject findFirst: [:each | each = 4]) equals: 0.
	self assert: (subject findFirst: [:each | each = 1]) equals: 0!

testFirst2
	| subject |
	subject := self collectionClass withAll: (1 to: 4).
	subject removeLast.
	self assert: subject first equals: 1.
	subject removeFirst.
	self assert: subject first equals: 2.
	subject removeFirst.
	self assert: subject first equals: 3.
	subject removeFirst.
	self
		should: [subject first]
		raise: BoundsError
		matching: [:ex | ex tag = 1]!

testFromToKeysAndValuesDo3
	"We also need to test that the enumeration raises bounds errors correctly when the 
	indices are within the capacity of the collection, but outside the logical bounds."

	#(#() #(65) #(65 66) #(65 66 67) #(65 66 67 68)) do: 
			[:sequence |
			| enum collection |
			collection := self collectionClass new: (sequence size + 1) * 2.
			collection add: 1.
			collection addAll: sequence.
			collection add: 9999.
			collection
				removeFirst;
				removeLast.
			self assert: (collection instVarNamed: 'firstIndex') > 1.
			self assert: (collection instVarNamed: 'lastIndex') <= collection basicSize.
			enum := OrderedCollection new.
			collection
				from: 1
				to: sequence size
				keysAndValuesDo: [:i :each | enum add: each].
			self assert: enum asArray equals: collection asArray.
			self should: 
					[collection
						from: 0
						to: sequence size
						keysAndValuesDo: [:i :each | enum add: each]]
				raise: BoundsError.
			self should: 
					[collection
						from: 1
						to: sequence size + 1
						keysAndValuesDo: [:i :each | enum add: each]]
				raise: BoundsError]!

testLast2
	| subject |
	subject := self collectionClass withAll: (1 to: 4).
	subject removeFirst.
	self assert: subject last equals: 4.
	subject removeLast.
	self assert: subject last equals: 3.
	subject removeLast.
	self assert: subject last equals: 2.
	subject removeLast.
	self
		should: [subject last]
		raise: BoundsError
		matching: [:ex | ex tag = 0]!

testResize
	| subject |
	super testResize.
	subject := self newCollection: #($a $b $c $d $e $f).
	subject removeFirst.
	subject removeLast.
	subject resize: 5.
	self assert: subject equals: (self newCollection: #($b $c $d $e nil)).
	subject resize: 10.
	self assert: subject equals: (self newCollection: #($b $c $d $e nil nil nil nil nil nil)).
	subject resize: 4.
	self assert: subject equals: (self newCollection: #($b $c $d $e)).
	subject resize: 2.
	self assert: subject equals: (self newCollection: #($b $c)).
	subject resize: 1.
	self assert: subject equals: (self newCollection: #($b))!

testSetSize
	| o capacity o2 o3 o5 |
	o := OrderedCollection new.
	capacity := o basicSize.
	"Initially empty, lastIndex = 0, firstIndex = 1"
	o setSize: 1.
	self assertIsNil: (o at: 1).
	self assert: (o at: 1 put: 1) equals: 1.
	self assert: o size equals: 1.
	self assert: o basicSize equals: capacity.
	self assert: o asArray equals: #(1).

	"Existing size (no change)"
	o setSize: 1.
	self assert: (o at: 1) equals: 1.
	self assert: o size equals: 1.
	self assert: o basicSize equals: capacity.
	self assert: o asArray equals: #(1).

	"Add 1"
	o setSize: 2.
	self assertIsNil: (o at: 2).
	self assert: (o at: 2 put: 2) equals: 2.
	self assert: o asArray equals: #(1 2).
	self assert: o size equals: 2.
	self assert: o basicSize equals: capacity.

	"Remove first so firstIndex ~= 1"
	o removeAtIndex: 1.
	self assertIsNil: (o basicAt: 1).
	self assert: o size equals: 1.
	self assert: o basicSize equals: capacity.
	self assert: (o at: 1) equals: 2.
	o at: 1 put: 1.
	"No change"
	o setSize: 1.
	self assertIsNil: (o basicAt: 1).
	self assert: o size equals: 1.
	self assert: o basicSize equals: capacity.
	self assert: (o at: 1) equals: 1.

	"Resize to 2 again, firstIndex = 2, lastIndex = 3"
	o setSize: 2.
	self assertIsNil: (o basicAt: 3).
	self assertIsNil: (o at: 2).
	self assert: (o at: 2 put: 2) equals: 2.
	self assert: o asArray equals: #(1 2).
	self assert: o size equals: 2.
	self assert: o basicSize equals: capacity.

	"Resize down again, firstIndex=2, lastIndex=2"
	o setSize: 1.
	self assertIsNil: (o basicAt: 1).
	self assertIsNil: (o basicAt: 3).
	self should: [o at: 2] raise: BoundsError.
	self assert: o size equals: 1.
	self assert: o basicSize equals: capacity.
	self assert: o asArray equals: #(1).

	"Boundary condition - size to existing capacity-1 (cos firstIndex=2)"
	o setSize: capacity - 1.
	1 to: capacity - 1 do: [:each | self assert: (o at: each put: each) equals: each].
	self assert: o asArray equals: (1 to: capacity - 1) asArray.
	self assert: o size equals: capacity - 1.
	self assert: o basicSize equals: capacity.

	"Lose more than one element"
	o setSize: capacity - 3.
	self assert: o size equals: capacity - 3.
	self assert: o basicSize equals: capacity.
	self assertIsNil: (o basicAt: 1).
	self assertIsNil: (o basicAt: capacity).
	self assertIsNil: (o basicAt: capacity - 1).
	self assert: o asArray equals: (1 to: capacity - 3) asArray.
	o2 := o copy.
	o3 := o copy.

	"Size to capacity, causing elems to be shifted down because first slot empty"
	o setSize: capacity.
	self assertIsNil: (o at: capacity).
	self assert: o size equals: capacity.
	self assert: o basicSize equals: capacity.
	1 to: capacity do: [:each | self assert: (o at: each put: each) equals: each].
	self assert: o asArray equals: (1 to: capacity) asArray.

	"Size one beyond existing capacity with firstIndex = 2 (downshift not sufficient so must grow)"
	o2 setSize: capacity + 1.
	self assertIsNil: (o2 at: capacity + 1).
	self assert: o2 size equals: capacity + 1.
	self assert: o2 basicSize >= (capacity + 1).
	1 to: capacity + 1 do: [:each | self assert: (o2 at: each put: each) equals: each].
	self assert: o2 asArray equals: (1 to: capacity + 1) asArray.
	o3 removeAtIndex: 1.
	"o3 now has two free slots, and one element"
	self assert: o3 size equals: 1.
	o3 at: 1 put: 1.
	o5 := o3 copy.
	o3 setSize: 2.
	self assert: o3 size equals: 2.
	self assert: o3 basicSize equals: capacity.
	self assertIsNil: (o3 basicAt: 1).
	self assertIsNil: (o3 basicAt: 2).
	self assert: (o3 basicAt: 3) equals: 1.
	self assert: (o3 at: 1) equals: 1.
	self assertIsNil: (o3 basicAt: 4).
	self assertIsNil: (o3 at: 2).
	o3 at: 2 put: 2.
	o5 := o3 copy.

	"Size o3 to capacity, shifting elems down 2 positions"
	o3 setSize: capacity.
	self assertIsNil: (o3 at: capacity).
	self assert: o3 size equals: capacity.
	self assert: o3 basicSize equals: capacity.
	self assert: (o3 beginsWith: #(1 2)).
	self assert: (o3 basicAt: 1) equals: 1.
	self assert: (o3 basicAt: 2) equals: 2.
	self assertIsNil: (o3 basicAt: 3).
	self assertIsNil: (o3 basicAt: 4).
	self assertIsNil: (o3 basicAt: 5).
	1 to: capacity do: [:each | self assert: (o at: each put: each) equals: each].
	self assert: o asArray equals: (1 to: capacity) asArray.

	"Size one beyond existing capacity with firstIndex = 3, lastIndex = 4(downshift not sufficient so must grow)"
	o5 setSize: capacity + 1.
	self assertIsNil: (o5 at: capacity + 1).
	self assert: o5 size equals: capacity + 1.
	self assert: o5 basicSize >= (capacity + 1).
	1 to: capacity + 1 do: [:each | self assert: (o5 at: each put: each) equals: each].
	self assert: o5 asArray equals: (1 to: capacity + 1) asArray.

	"Size one beyond existing capacity with firstIndex = 1"
	o setSize: capacity + 1.
	self assertIsNil: (o at: capacity + 1).
	self assert: o size equals: capacity + 1.
	self assert: o basicSize > capacity.
	1 to: capacity + 1 do: [:each | self assert: (o at: each put: each) equals: each].
	self assert: o asArray equals: (1 to: capacity + 1) asArray!

testStrongTalkTests
	"Tests from Strongtalks OrderedCollection class>>test method.

	Minor modifications have been made due to selector differences. Also Dolphin has no
	equivalent of #removeEvery:, so I've used #copyWithout:, even though this is not an internal
	remove."

	"Set behavior of this class is tested by Set test."

	| oc |
	oc := self collectionClass new: 3.
	oc
		addLast: 3;
		addLast: 4;
		addFirst: 2;
		addFirst: 1;
		addLast: 5;
		addLast: 6;
		addLast: 7.
	"%todo: Use #(1 2 3 4 5 6 7) as withAll: arg below when literals arrays work"
	self assert: oc
		equals: (self collectionClass withAll: (self collectionClass new
						addLast: 1;
						addLast: 2;
						addLast: 3;
						addLast: 4;
						addLast: 5;
						addLast: 6;
						addLast: 7;
						yourself)).
	self assert: (oc at: 1) equals: 1.
	self assert: oc size equals: 7.
	self assert: (oc at: 7 ifAbsent: [nil]) equals: 7.
	self assert: (oc at: 0 ifAbsent: [nil]) equals: nil.
	self assert: (oc at: 8 ifAbsent: [nil]) equals: nil.
	self assert: (oc indexOf: 3 ifAbsent: [nil]) equals: 3.
	oc
		remove: 3;
		removeAtIndex: 3;
		removeAtIndex: 5;
		removeAtIndex: 1;
		remove: 2.
	self assert: oc
		equals: (self collectionClass new
				addLast: 5;
				addLast: 6;
				yourself).
	oc
		addFirst: 4;
		addLast: 7;
		removeAtIndex: 2;
		removeAtIndex: 2.
	self assert: oc
		equals: (self collectionClass new
				addLast: 4;
				addLast: 7;
				yourself).
	oc
		removeAtIndex: 1;
		removeAtIndex: 1.
	self assert: oc size equals: 0.
	self assert: (oc remove: 2 ifAbsent: [nil]) equals: nil.
	oc := oc
				add: 2;
				add: 1;
				add: 2;
				add: 2;
				add: 3;
				add: 2;
				copyWithout: 2.
	self assert: oc
		equals: (self collectionClass new
				addLast: 1;
				addLast: 3;
				yourself)! !
!Core.Tests.OrderedCollectionTest categoriesFor: #collectionClass!constants!private! !
!Core.Tests.OrderedCollectionTest categoriesFor: #newCollection:!helpers!private! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testFindFirst2!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testFirst2!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testFromToKeysAndValuesDo3!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testLast2!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testResize!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testSetSize!public!unit tests! !
!Core.Tests.OrderedCollectionTest categoriesFor: #testStrongTalkTests!public!testing! !

