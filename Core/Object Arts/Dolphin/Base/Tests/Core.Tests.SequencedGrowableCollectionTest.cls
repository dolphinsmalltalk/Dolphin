"Filed out from Dolphin Smalltalk 7"!

Core.Tests.SequenceableCollectionTest subclass: #'Core.Tests.SequencedGrowableCollectionTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SequencedGrowableCollectionTest guid: (Core.GUID fromString: '{7c5c4663-14ac-4420-85af-2c2644e54463}')!
Core.Tests.SequencedGrowableCollectionTest isNonInstantiable: true!
Core.Tests.SequencedGrowableCollectionTest comment: ''!
!Core.Tests.SequencedGrowableCollectionTest categoriesForClass!Unclassified! !
!Core.Tests.SequencedGrowableCollectionTest methodsFor!

testAddAllFirst
	| sequence |
	0 to: 6
		do: 
			[:each |
			| elems |
			sequence := self newCollection: #().
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence equals: (self newCollection: elems).
			sequence size > 1
				ifTrue: 
					[sequence removeFirst.
					elems := (2 to: each) asArray].
			sequence addAllFirst: #().
			self assert: sequence size equals: elems size.
			self assert: sequence equals: (self newCollection: elems)].
	0 to: 6
		do: 
			[:each |
			| elems topped |
			sequence := self newCollection: #(1).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence equals: (self newCollection: elems , #(1)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence equals: topped].
	0 to: 6
		do: 
			[:each |
			| elems topped |
			sequence := self newCollection: #(1 2).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence equals: (self newCollection: elems , #(1 2)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence equals: topped].
	0 to: 6
		do: 
			[:each |
			| elems topped |
			sequence := self newCollection: #(1 2 3).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence equals: (self newCollection: elems , #(1 2 3)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence equals: topped]!

testAddAllFirst2
	| sequence |
	sequence := self newCollection: #(1 2 3).
	sequence removeFirst.
	self assert: sequence equals: (self newCollection: #(2 3)).
	sequence addAllFirst: #(1).
	self assert: sequence equals: (self newCollection: #(1 2 3)).
	sequence
		removeFirst;
		removeFirst.
	self assert: sequence equals: (self newCollection: #(3)).
	sequence addAllFirst: #(2).
	self assert: sequence equals: (self newCollection: #(2 3)).
	sequence addAllFirst: #(1).
	self assert: sequence equals: (self newCollection: #(1 2 3)).
	sequence
		removeFirst;
		removeFirst.
	self assert: sequence equals: (self newCollection: #(3)).
	sequence addAllFirst: #(1 2).
	self assert: sequence equals: (self newCollection: #(1 2 3)).
	sequence
		removeFirst;
		removeFirst.
	self assert: sequence equals: (self newCollection: #(3)).
	sequence addAllFirst: #(0 1 2).
	self assert: sequence equals: (self newCollection: #(0 1 2 3))!

testAddAllLast
	| sequence |
	0 to: 6
		do: 
			[:each |
			| elems |
			sequence := self newCollection: #().
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence equals: (self newCollection: elems).
			sequence size > 1
				ifTrue: 
					[sequence removeFirst.
					elems := (2 to: each) asArray].
			sequence addAllLast: #().
			self assert: sequence equals: (self newCollection: elems)].
	0 to: 6
		do: 
			[:each |
			| elems |
			sequence := self newCollection: #(1).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence equals: (self newCollection: #(1) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence equals: (self newCollection: elems)].
	0 to: 6
		do: 
			[:each |
			| elems |
			sequence := self newCollection: #(1 2).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence equals: (self newCollection: #(1 2) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence equals: (self newCollection: #(2) , elems)].
	0 to: 6
		do: 
			[:each |
			| elems |
			sequence := self newCollection: #(1 2 3).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence equals: (self newCollection: #(1 2 3) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence equals: (self newCollection: #(2 3) , elems)]!

testAddFirst
	| subject interval |
	subject := self collectionClass new.
	interval := 1 to: 30.
	"Collection may have to grow a few times"
	interval do: [:each | subject addFirst: each].
	self assert: subject asArray equals: interval reverse!

testCopyWithoutIndex
	super testCopyWithoutIndex.
	"Also test that the copying works if there is some space up front."
	#(#(#($a $b) 1 #()) #(#($a $b $c) 1 #($c)) #(#($a $b $c) 2 #($b))) do: 
			[:each |
			| subject |
			subject := (self newCollection: each first)
						removeFirst;
						yourself.
			self assert: (subject copyWithoutIndex: each second) equals: (self newCollection: each third)]! !
!Core.Tests.SequencedGrowableCollectionTest categoriesFor: #testAddAllFirst!public!unit tests! !
!Core.Tests.SequencedGrowableCollectionTest categoriesFor: #testAddAllFirst2!public!unit tests! !
!Core.Tests.SequencedGrowableCollectionTest categoriesFor: #testAddAllLast!public!unit tests! !
!Core.Tests.SequencedGrowableCollectionTest categoriesFor: #testAddFirst!public!unit tests! !
!Core.Tests.SequencedGrowableCollectionTest categoriesFor: #testCopyWithoutIndex!public!unit tests! !

