"Filed out from Dolphin Smalltalk 7"!

SequencedGrowableCollectionTest subclass: #OrderedCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OrderedCollectionTest guid: (GUID fromString: '{c951706f-236d-4671-b849-626652dda25e}')!
OrderedCollectionTest comment: ''!
!OrderedCollectionTest categoriesForClass!Unclassified! !
!OrderedCollectionTest methodsFor!

collectionClass
	^OrderedCollection!

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
			self assert: enum asArray = collection asArray.
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

testSetSize
	| o capacity o2 o3 o4 o5 |
	o := OrderedCollection new.
	capacity := o basicSize.
	"Initially empty, lastIndex = 0, firstIndex = 1"
	o setSize: 1.
	self assert: (o at: 1) isNil.
	self assert: (o at: 1 put: 1) = 1.
	self assert: o size = 1.
	self assert: o basicSize = capacity.
	self assert: o asArray = #(1).

	"Existing size (no change)"
	o setSize: 1.
	self assert: (o at: 1) = 1.
	self assert: o size = 1.
	self assert: o basicSize = capacity.
	self assert: o asArray = #(1).

	"Add 1"
	o setSize: 2.
	self assert: (o at: 2) isNil.
	self assert: (o at: 2 put: 2) = 2.
	self assert: o asArray = #(1 2).
	self assert: o size = 2.
	self assert: o basicSize = capacity.

	"Remove first so firstIndex ~= 1"
	o removeAtIndex: 1.
	self assert: (o basicAt: 1) isNil.
	self assert: (o size = 1).
	self assert: (o basicSize = capacity).
	self assert: (o at: 1) = 2.
	o at: 1 put: 1.
	"No change"
	o setSize: 1.
	self assert: (o basicAt: 1) isNil.
	self assert: (o size = 1).
	self assert: (o basicSize = capacity).
	self assert: (o at: 1) = 1.

	"Resize to 2 again, firstIndex = 2, lastIndex = 3"
	o setSize: 2.
	self assert: (o basicAt: 3) isNil.
	self assert: (o at: 2) isNil.
	self assert: (o at: 2 put: 2) = 2.
	self assert: o asArray = #(1 2).
	self assert: o size = 2.
	self assert: o basicSize = capacity.

	"Resize down again, firstIndex=2, lastIndex=2"
	o setSize: 1.
	self assert: (o basicAt: 1) isNil.
	self assert: (o basicAt: 3) isNil.
	self should: [o at: 2] raise: BoundsError.
	self assert: o size = 1.
	self assert: o basicSize = capacity.
	self assert: o asArray = #(1).

	"Boundary condition - size to existing capacity-1 (cos firstIndex=2)"
	o setSize: capacity-1.
	1 to: capacity-1 do: [:each | self assert: (o at: each put: each) = each].
	self assert: o asArray = (1 to: capacity-1) asArray.
	self assert: o size = (capacity-1).
	self assert: o basicSize = capacity.

	"Lose more than one element"
	o setSize: capacity - 3.
	self assert: o size = (capacity - 3).
	self assert: o basicSize = capacity.
	self assert: (o basicAt: 1) isNil.
	self assert: (o basicAt: capacity) isNil.
	self assert: (o basicAt: capacity - 1) isNil.
	self assert: o asArray = (1 to: capacity - 3) asArray.

	o2 := o copy.
	o3 := o copy.
	o4 := o copy.

	"Size to capacity, causing elems to be shifted down because first slot empty"
	o setSize: capacity.
	self assert: (o at: capacity) isNil.
	self assert: o size = capacity.
	self assert: o basicSize = capacity.
	1 to: capacity do: [:each | self assert: (o at: each put: each) = each].
	self assert: o asArray = (1 to: capacity) asArray.

	"Size one beyond existing capacity with firstIndex = 2 (downshift not sufficient so must grow)"
	o2 setSize: capacity+1.
	self assert: (o2 at: capacity+1) isNil.
	self assert: o2 size = (capacity+1).
	self assert: o2 basicSize >= (capacity+1).
	1 to: capacity+1 do: [:each | self assert: (o2 at: each put: each) = each].
	self assert: o2 asArray = (1 to: capacity+1) asArray.

	o3 removeAtIndex: 1.
	"o3 now has two free slots, and one element"
	self assert: o3 size = 1.
	o3 at: 1 put: 1.
	o5 := o3 copy.
	o3 setSize: 2.
	self assert: o3 size = 2.
	self assert: o3 basicSize = capacity.
	self assert: (o3 basicAt: 1) isNil.
	self assert: (o3 basicAt: 2) isNil.
	self assert: (o3 basicAt: 3) = 1.
	self assert: (o3 at: 1) = 1.
	self assert: (o3 basicAt: 4) isNil.
	self assert: (o3 at: 2) isNil.
	o3 at: 2 put: 2.

	o5 := o3 copy.

	"Size o3 to capacity, shifting elems down 2 positions"
	o3 setSize: capacity.
	self assert: (o3 at: capacity) isNil.
	self assert: o3 size = capacity.
	self assert: o3 basicSize = capacity.
	self assert: (o3 beginsWith: #(1 2)).
	self assert: (o3 basicAt: 1) = 1.
	self assert: (o3 basicAt: 2) = 2.
	self assert: (o3 basicAt: 3) isNil.
	self assert: (o3 basicAt: 4) isNil.
	self assert: (o3 basicAt: 5) isNil.
	1 to: capacity do: [:each | self assert: (o at: each put: each) = each].
	self assert: o asArray = (1 to: capacity) asArray.

	"Size one beyond existing capacity with firstIndex = 3, lastIndex = 4(downshift not sufficient so must grow)"
	o5 setSize: capacity+1.
	self assert: (o5 at: capacity+1) isNil.
	self assert: o5 size = (capacity+1).
	self assert: o5 basicSize >= (capacity+1).
	1 to: capacity+1 do: [:each | self assert: (o5 at: each put: each) = each].
	self assert: o5 asArray = (1 to: capacity+1) asArray.

	"Size one beyond existing capacity with firstIndex = 1"
	o setSize: capacity + 1.
	self assert: (o at: capacity + 1) isNil.
	self assert: o size = (capacity + 1).
	self assert: o basicSize > capacity.
	1 to: capacity + 1 do: [:each | self assert: (o at: each put: each) = each].
	self assert: o asArray = (1 to: capacity + 1) asArray.!

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
				= (self collectionClass withAll: ((self collectionClass new)
								addLast: 1;
								addLast: 2;
								addLast: 3;
								addLast: 4;
								addLast: 5;
								addLast: 6;
								addLast: 7;
								yourself)).
	self assert: (oc at: 1) = 1.
	self assert: oc size = 7.
	self assert: (oc at: 7 ifAbsent: [nil]) = 7.
	self assert: (oc at: 0 ifAbsent: [nil]) = nil.
	self assert: (oc at: 8 ifAbsent: [nil]) = nil.
	self assert: (oc indexOf: 3 ifAbsent: [nil]) = 3.
	oc
		remove: 3;
		removeAtIndex: 3;
		removeAtIndex: 5;
		removeAtIndex: 1;
		remove: 2.
	self 
		assert: oc = ((self collectionClass new)
						addLast: 5;
						addLast: 6;
						yourself).
	oc
		addFirst: 4;
		addLast: 7;
		removeAtIndex: 2;
		removeAtIndex: 2.
	self 
		assert: oc = ((self collectionClass new)
						addLast: 4;
						addLast: 7;
						yourself).
	oc
		removeAtIndex: 1;
		removeAtIndex: 1.
	self assert: oc size = 0.
	self assert: (oc remove: 2 ifAbsent: [nil]) = nil.
	oc := oc
				add: 2;
				add: 1;
				add: 2;
				add: 2;
				add: 3;
				add: 2;
				copyWithout: 2.
	self assert: oc = ((self collectionClass new)
						addLast: 1;
						addLast: 3;
						yourself)! !
!OrderedCollectionTest categoriesFor: #collectionClass!constants!private! !
!OrderedCollectionTest categoriesFor: #testFirst2!public!unit tests! !
!OrderedCollectionTest categoriesFor: #testFromToKeysAndValuesDo3!public!unit tests! !
!OrderedCollectionTest categoriesFor: #testLast2!public!unit tests! !
!OrderedCollectionTest categoriesFor: #testSetSize!public!unit tests! !
!OrderedCollectionTest categoriesFor: #testStrongTalkTests!public!testing! !

