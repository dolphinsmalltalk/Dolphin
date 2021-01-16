"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.SortAlgorithmTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.SortAlgorithmTest guid: (Core.GUID fromString: '{50fde7dc-5db4-4eda-9ee2-61882b8ee3e5}')!
Core.Tests.SortAlgorithmTest isNonInstantiable: true!
Core.Tests.SortAlgorithmTest comment: ''!
!Core.Tests.SortAlgorithmTest categoriesForClass!Unclassified! !
!Core.Tests.SortAlgorithmTest methodsFor!

add: aCollection sortBlock: block
	| duration sorted comp collection |
	collection := aCollection asArray.
	comp := 0.
	sorted := SortedCollection
				sortAlgorithm: (self algorithmToTest newSortBlock: 
							[:a :b |
							comp := comp + 1.
							block value: a value: b]).
	duration := [1 to: (collection size min: 5000) do: [:i | sorted add: (collection at: i)]] timeToRun.
	collection size > 500
		ifTrue: 
			[Transcript
				print: comp;
				nextPutAll: ' comparisons required to add ';
				print: sorted size;
				nextPutAll: ' objects to a SortedCollection taking ';
				display: duration;
				cr;
				flush].
	self assertSorted: sorted!

algorithmToTest
	^self subclassResponsibility!

assertSorted: sorted 
	"Private - Asssert that each element of the collection is in the correct sequence relative to its successor"

	| block |
	block := sorted sortBlock.
	self assertSorted: sorted by: block!

assertSorted: sorted by: block 
	1 to: sorted size - 1
		by: 2
		do: 
			[:i | 
			| a b prior |
			prior := block value: (a := sorted at: i) value: (b := sorted at: i + 1).
			self assert: (prior or: [prior == (block value: b value: a)])]!

bigStringSort
	| sorted |
	sorted := self sort: Symbol allSubinstances sortBlock: SortedCollection defaultSortBlock.
	"Now invert it"
	sorted := self sort: sorted sortBlock: [:a :b | a >= b]!

integerSortSize
	^2000!

newAscending: anInteger
	| s |
	s := SortedCollection new: anInteger.
	s algorithm: self algorithmToTest new.
	^s!

newDescending: anInteger
	| s |
	s := SortedCollection new: anInteger.
	s algorithm: (self algorithmToTest sortBlock: [:a :b | a >= b]).
	^s!

partialSort: source using: algorithm
	1 to: source size
		do: 
			[:i |
			i to: source size
				do: 
					[:j |
					| array sorted |
					array := source asArray copy.
					algorithm
						sort: array
						from: i
						to: j.
					self assert: (source copyFrom: 1 to: i - 1) equals: (array copyFrom: 1 to: i - 1).
					self assert: (source copyFrom: j + 1) equals: (array copyFrom: j + 1).
					sorted := array copyFrom: i to: j.
					self assertSorted: sorted by: algorithm sortBlock]]!

sort: aCollection sortBlock: block
	| sorted |
	sorted := aCollection asSortedCollectionUsing: (self algorithmToTest newSortBlock: block).
	self assertSorted: sorted.
	self add: aCollection sortBlock: block.
	^sorted!

sortMagnitudes: collection
	self sort: collection sortBlock: SortedCollection defaultSortBlock.	"<= comparison"
	"< comparison"
	self sort: collection sortBlock: [:a :b | a < b].
	"> comparison for descending order"
	self sort: collection sortBlock: [:a :b | a > b].
	">= comparison for descending order"
	^self sort: collection sortBlock: [:a :b | a >= b]!

testAdd
	| s |
	s := self newAscending: 3.
	s add: #a.
	self assert: s size equals: 1.
	self assertSorted: s.
	s add: #b.
	self assert: s size equals: 2.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	s add: #c.
	self assert: s size equals: 3.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	s remove: #a.
	self assert: s size equals: 2.
	self assertSorted: s.
	self assert: (s at: 1) equals: #b.
	self assert: (s at: 2) equals: #c.
	s add: #a.
	self assert: s size equals: 3.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	s remove: #b.
	self assert: s size equals: 2.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #c.
	s add: #b.
	self assert: s size equals: 3.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	s remove: #c.
	self assert: s size equals: 2.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	s add: #c.
	self assert: s size equals: 3.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.

	"Addition will cause it to grow at end"
	s add: #d.
	self assert: s size equals: 4.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	self assert: (s at: 4) equals: #d.

	"Grow in middle"
	s := (self newAscending: 3)
				addAll: #(#a #c #d);
				yourself.
	s add: #b.
	self assert: s size equals: 4.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	self assert: (s at: 4) equals: #d.

	"Grow from start"
	s := (self newAscending: 3)
				addAll: #(#b #c #d);
				yourself.
	s add: #a.
	self assert: s size equals: 4.
	self assertSorted: s.
	self assert: (s at: 1) equals: #a.
	self assert: (s at: 2) equals: #b.
	self assert: (s at: 3) equals: #c.
	self assert: (s at: 4) equals: #d!

testDefault
	| sorted |
	sorted := (SortedCollection sortAlgorithm: self algorithmToTest new)
				addAll: (100 to: 1 by: -1);
				yourself.
	self assertSorted: sorted!

testExtremeSortBlocks
	"This is a worst case ..."

	self sort: (1 to: self integerSortSize) sortBlock: [:a :b | true].
	self sort: (1 to: self integerSortSize) sortBlock: [:a :b | false]!

testIncludes
	"Thanks to John Brant for these tests which were posted to the newsgroup as 
	part of a thread about using a binary-search to implement #includes:"

	| sorted selectorCounts |
	selectorCounts := Dictionary new.
	Collection withAllSubclassesDo: 
			[:each |
			each selectors do: [:sel | selectorCounts at: sel put: (selectorCounts at: sel ifAbsent: [0]) + 1]].
	sorted := self sort: selectorCounts associations sortBlock: [:a :b | a value < b value].

	"Sort getting at lot of duplicates (i.e. there will be a sequence of equal values)"
	self assert: (sorted includes: (selectorCounts associationAt: #printOn:)).

	"Ordering by partial keys"
	sorted := self sort: #('aaa' 'abb' 'acc') sortBlock: [:a :b | a first < b first].
	self assert: (sorted includes: 'aaa').

	"And again"
	sorted := self sort: #('aa' 'ab' 'ac' 'ba' 'bb' 'bc') sortBlock: [:a :b | a first < b first].
	sorted do: [:each | self assert: (sorted includes: each)].
	self assert: ('abc' asSortedCollection includes: 3) not!

testPartialSort
	| r algorithm |
	algorithm := self algorithmToTest new.
	self partialSort: (19 to: 1 by: -1) using: algorithm.
	r := Random new.
	#(1 2 3 4 5 7 10 11 13 17 19 23 29 30 53)
		do: [:each | self partialSort: (r next: each) using: algorithm]!

testRandomSort
	"Varying numbers of elements, some duplicates."

	| r |
	r := Random new.
	1 to: 200
		do: 
			[:i |
			| collection |
			collection := (r next: i) collect: [:e | (e * i) rounded].
			self sortMagnitudes: collection]!

testSortIntegers
	"This collection can blow up a quick sort partitioning algorithm that does not check bounds correctly."

	| collection |
	collection := #(138 150 55 99 131 119 43 130 149 138 5 109 30 135 44 14 11 131 147 65 104 3 141 93 93 5 19 90 133 78 136 44 11 14 140 3 125 76 23 58 130 26 101 138 39 12 11 64 121 62 80 122 78 48 93 105 22 13 79 151 147 77 149 46 41 53 136 20 66 110 128 96 3 65 128 79 137 9 129 5 135 144 19 62 3 113 6 135 96 59 34 45 61 14 103 125 29 79 48 45 47 139 64 145 23 147 82 81 110 63 64 86 38 59 72 152 132 9 88 107 42 41 53 141 70 61 84 86 137 145 125 147 91 46 146 140 111 56 104 18 87 16 56 120 8 101 109 19 101 60 71 98 76 75 125).
	self sortMagnitudes: collection.
	collection := self integerSortSize to: 1 by: -1.
	self sortMagnitudes: collection.
	collection := 1 to: self integerSortSize.
	self sortMagnitudes: collection! !
!Core.Tests.SortAlgorithmTest categoriesFor: #add:sortBlock:!helpers!private! !
!Core.Tests.SortAlgorithmTest categoriesFor: #algorithmToTest!private!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #assertSorted:!helpers!private! !
!Core.Tests.SortAlgorithmTest categoriesFor: #assertSorted:by:!helpers!private! !
!Core.Tests.SortAlgorithmTest categoriesFor: #bigStringSort!private!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #integerSortSize!constants!private! !
!Core.Tests.SortAlgorithmTest categoriesFor: #newAscending:!private!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #newDescending:!private!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #partialSort:using:!private!testing! !
!Core.Tests.SortAlgorithmTest categoriesFor: #sort:sortBlock:!helpers!private! !
!Core.Tests.SortAlgorithmTest categoriesFor: #sortMagnitudes:!private!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testAdd!public!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testDefault!public!testing! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testExtremeSortBlocks!public!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testIncludes!public!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testPartialSort!public!testing! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testRandomSort!public!unit tests! !
!Core.Tests.SortAlgorithmTest categoriesFor: #testSortIntegers!public!unit tests! !

