"Filed out from Dolphin Smalltalk 7"!

SequenceableCollectionTest subclass: #SequencedGrowableCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedGrowableCollectionTest guid: (GUID fromString: '{7c5c4663-14ac-4420-85af-2c2644e54463}')!
SequencedGrowableCollectionTest comment: ''!
!SequencedGrowableCollectionTest categoriesForClass!Unclassified! !
!SequencedGrowableCollectionTest methodsFor!

testAddAllFirst
	| sequence |
	0 to: 6
		do: 
			[:each | 
			| elems |
			sequence := self newCollection: #().
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence = (self newCollection: elems).
			sequence size > 1 
				ifTrue: 
					[sequence removeFirst.
					elems := (2 to: each) asArray].
			sequence addAllFirst: #().
			self assert: sequence size = elems size.
			self assert: sequence = (self newCollection: elems)].
	0 to: 6
		do: 
			[:each | 
			| elems topped |
			sequence := self newCollection: #(1).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence = (self newCollection: elems , #(1)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence = topped].
	0 to: 6
		do: 
			[:each | 
			| elems topped |
			sequence := self newCollection: #(1 2).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence = (self newCollection: elems , #(1 2)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence = topped].
	0 to: 6
		do: 
			[:each | 
			| elems topped |
			sequence := self newCollection: #(1 2 3).
			elems := (1 to: each) asArray.
			sequence addAllFirst: elems.
			self assert: sequence = (self newCollection: elems , #(1 2 3)).
			topped := sequence copyFrom: 2.
			sequence removeFirst.
			sequence addAllFirst: #().
			self assert: sequence = topped].
!

testAddAllFirst2
	| sequence |
	sequence := self newCollection: #(1 2 3).
	sequence removeFirst.
	self assert: sequence = (self newCollection: #(2 3)).
	sequence addAllFirst: #(1).
	self assert: sequence = (self newCollection: #(1 2 3)).
	sequence removeFirst; removeFirst.
	self assert: sequence = (self newCollection: #(3)).
	sequence addAllFirst: #(2).
	self assert: sequence = (self newCollection: #(2 3)).
	sequence addAllFirst: #(1).
	self assert: sequence = (self newCollection: #(1 2 3)).
	sequence removeFirst; removeFirst.
	self assert: sequence = (self newCollection: #(3)).
	sequence addAllFirst: #(1 2).
	self assert: sequence = (self newCollection: #(1 2 3)).
	sequence removeFirst; removeFirst.
	self assert: sequence = (self newCollection: #(3)).
	sequence addAllFirst: #(0 1 2).
	self assert: sequence = (self newCollection: #(0 1 2 3)).
!

testAddAllLast
	| sequence |
	0 to: 6
		do: 
			[:each | 
			| elems |
			sequence := self newCollection: #().
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence = (self newCollection: elems).
			sequence size > 1 
				ifTrue: 
					[sequence removeFirst.
					elems := (2 to: each) asArray].
			sequence addAllLast: #().
			self assert: sequence = (self newCollection: elems)].
	0 to: 6
		do: 
			[:each | 
			| elems |
			sequence := self newCollection: #(1).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence = (self newCollection: #(1) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence = (self newCollection: elems)].
	0 to: 6
		do: 
			[:each | 
			| elems |
			sequence := self newCollection: #(1 2).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence = (self newCollection: #(1 2) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence = (self newCollection: #(2) , elems)].
	0 to: 6
		do: 
			[:each | 
			| elems |
			sequence := self newCollection: #(1 2 3).
			elems := (1 to: each) asArray.
			sequence addAllLast: elems.
			self assert: sequence = (self newCollection: #(1 2 3) , elems).
			sequence removeFirst.
			sequence addAllLast: #().
			self assert: sequence = (self newCollection: #(2 3) , elems)]! !
!SequencedGrowableCollectionTest categoriesFor: #testAddAllFirst!public!unit tests! !
!SequencedGrowableCollectionTest categoriesFor: #testAddAllFirst2!public!unit tests! !
!SequencedGrowableCollectionTest categoriesFor: #testAddAllLast!public!unit tests! !

!SequencedGrowableCollectionTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!SequencedGrowableCollectionTest class categoriesFor: #isAbstract!public!Testing! !

