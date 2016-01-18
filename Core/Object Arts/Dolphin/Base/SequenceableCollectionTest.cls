"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SequenceableCollectionTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequenceableCollectionTest guid: (GUID fromString: '{4C32DBCC-4044-442B-95D9-D6E8AD2396CF}')!
SequenceableCollectionTest comment: 'SUnitBrowser openOnTestCase: self'!
!SequenceableCollectionTest categoriesForClass!Unclassified! !
!SequenceableCollectionTest methodsFor!

assimilate: aSmallInteger 
	^aSmallInteger!

assimilateElements: aCollection 
	^aCollection asArray collect: [:each | self assimilate: each]!

byteArrayForSequence: aCollection
	| answer |
	answer := ByteArray new: aCollection size.
	1 to: aCollection size do: [:each | answer at: each put: (aCollection at: each) asInteger].
	^answer!

collectionClass
	^self subclassResponsibility!

newCollection: aCollection
	^self collectionClass withAll: (self assimilateElements: aCollection)!

newCopy: aCollection
	^self newCollection: aCollection!

newNumericArray: anInteger 
	^self newCollection: (1 to: anInteger)!

newUnsortedCollection: aCollection
	^self unsortedCollectionClass withAll: (self assimilateElements: aCollection)!

testAsByteArray
	| sequence |
	sequence := #().
	self assert: (self newCollection: sequence) asByteArray = (self byteArrayForSequence: sequence).
	sequence := #(65).
	self assert: (self newCollection: sequence) asByteArray = (self byteArrayForSequence: sequence).
	sequence := #(65 66).
	self assert: (self newCollection: sequence) asByteArray = (self byteArrayForSequence: sequence).
	sequence := #(65 66 67).
	self assert: (self newCollection: sequence) asByteArray = (self byteArrayForSequence: sequence).
	sequence := #(65 66 67 68).
	self assert: (self newCollection: sequence) asByteArray = (self byteArrayForSequence: sequence).
!

testBeginsWith
	"Test SequenceableCollection>>beginsWith:"

	| sequence one two oneTwo empty |
	one := self newCollection: #($1).
	two := self newCollection: #($2).
	empty := self newCollection: #().
	sequence := empty.
	self assert: (sequence beginsWith: empty).
	self assert: (sequence beginsWith: one) not.
	oneTwo := self newCollection: #($1 $2).
	self assert: (sequence beginsWith: oneTwo) not.
	sequence := one copy.
	self assert: (sequence beginsWith: empty).
	self assert: (sequence beginsWith: one).
	self assert: (sequence beginsWith: two) not.
	self assert: (sequence beginsWith: oneTwo) not.
	self assert: (sequence beginsWith: #($2 $3)) not.
	sequence := oneTwo copy.
	self assert: (sequence beginsWith: empty).
	self assert: (sequence beginsWith: one).
	self assert: (sequence beginsWith: two) not.
	self assert: (sequence beginsWith: oneTwo).
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($2 $1))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($2 $1 $3))) not.
	sequence := self newCollection: #($1 $2 $3 $4 $5).
	self assert: (sequence beginsWith: one).
	self assert: (sequence beginsWith: two) not.
	self assert: (sequence beginsWith: oneTwo).
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($2 $1))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3))).
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($3 $1 $2))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $3 $2))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $4))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3 $4))).
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($4 $1 $2 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $4 $2 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $4 $3))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3 $5))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3 $4 $5))).
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($5 $1 $2 $3 $4))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $5 $2 $3 $4))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $5 $3 $4))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3 $5 $4))) not.
	self assert: (sequence beginsWith: (self newUnsortedCollection: #($1 $2 $3 $4 $5 $6))) not!

testBinarySearch
	| searchee lessThan |
	lessThan := [:x :y | x < y].
	searchee := self newCollection: 'abcdefghijklmnopqrstuvwxyz'.
	(searchee respondsTo: #binarySearchFor:using:) 
		ifFalse: 
			["Binary search method introduced in D6"
			^self].
	self assert: (searchee binarySearchFor: (searchee at: 1) using: lessThan) = 1.
	self assert: (searchee binarySearchFor: (searchee at: 8) using: lessThan) = 8.
	self assert: (searchee binarySearchFor: (searchee at: 26) using: lessThan) = 26!

testCopyFromTo
	| source empty |
	source := self newCollection: #().
	empty := self newCopy: #().
	self should: [source copyFrom: -2 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: 0] raise: BoundsError.
	self should: [source copyFrom: 0 to: 0] raise: BoundsError.
	self assert: (source copyFrom: 1 to: 0) = empty.
	self should: [source copyFrom: 1 to: 1] raise: BoundsError.
	self should: [source copyFrom: 1 to: 2] raise: BoundsError.
	self should: [source copyFrom: 1 to: 3] raise: BoundsError.
	self should: [source copyFrom: 2 to: 2] raise: BoundsError.
	self should: [source copyFrom: 2 to: 3] raise: BoundsError.
	self should: [source copyFrom: 2 to: 4] raise: BoundsError.

	source := self newCollection: #($1).
	self should: [source copyFrom: -2 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: 0] raise: BoundsError.
	self should: [source copyFrom: 0 to: 0] raise: BoundsError.
	self assert: (source copyFrom: 1 to: 0) = empty.
	self assert: (source copyFrom: 1 to: 1) = (self newCopy: source).
	self should: [source copyFrom: 1 to: 2] raise: BoundsError.
	self should: [source copyFrom: 1 to: 3] raise: BoundsError.
	self should: [source copyFrom: 2 to: 2] raise: BoundsError.
	self should: [source copyFrom: 2 to: 3] raise: BoundsError.
	self should: [source copyFrom: 2 to: 4] raise: BoundsError.

	source := self newCollection: #($1 $2).
	self should: [source copyFrom: -2 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: 0] raise: BoundsError.
	self should: [source copyFrom: 0 to: 0] raise: BoundsError.
	self assert: (source copyFrom: 1 to: 0) = empty.
	self assert: (source copyFrom: 1 to: 1) = (self newCopy: #($1)).
	self assert: (source copyFrom: 1 to: 2) = (self newCopy: source).
	self should: [source copyFrom: 1 to: 3] raise: BoundsError.
	self assert: (source copyFrom: 2 to: 2) = (self newCopy: #($2)).
	self should: [source copyFrom: 2 to: 3] raise: BoundsError.
	self should: [source copyFrom: 2 to: 4] raise: BoundsError.

	source := self newCollection: #($1 $2 $3).
	self should: [source copyFrom: -2 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: 0] raise: BoundsError.
	self should: [source copyFrom: 0 to: 0] raise: BoundsError.
	self assert: (source copyFrom: 1 to: 0) = empty.
	self assert: (source copyFrom: 1 to: 1) = (self newCopy: #($1)).
	self assert: (source copyFrom: 1 to: 2) = (self newCopy: #($1 $2)).
	self assert: (source copyFrom: 1 to: 3) = (self newCopy: source).
	self assert: (source copyFrom: 2 to: 2) = (self newCopy: #($2)).
	self assert: (source copyFrom: 2 to: 3) = (self newCopy: #($2 $3)).
	self assert: (source copyFrom: 3 to: 3) = (self newCopy: #($3)).
	self should: [source copyFrom: 2 to: 4] raise: BoundsError.

	source := self newCollection: #($1 $2 $3 $4).
	self should: [source copyFrom: -2 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: -1] raise: BoundsError.
	self should: [source copyFrom: -1 to: 0] raise: BoundsError.
	self should: [source copyFrom: 0 to: 0] raise: BoundsError.
	self assert: (source copyFrom: 1 to: 0) = empty.
	self assert: (source copyFrom: 1 to: 1) = (self newCopy: #($1)).
	self assert: (source copyFrom: 1 to: 2) = (self newCopy: #($1 $2)).
	self assert: (source copyFrom: 1 to: 3) = (self newCopy: #($1 $2 $3)).
	self assert: (source copyFrom: 1 to: 4) = (self newCopy: source).
	self assert: (source copyFrom: 2 to: 2) = (self newCopy: #($2)).
	self assert: (source copyFrom: 2 to: 3) = (self newCopy: #($2 $3)).
	self assert: (source copyFrom: 2 to: 4) = (self newCopy: #($2 $3 $4)).
	self assert: (source copyFrom: 3 to: 3) = (self newCopy: #($3)).
	self assert: (source copyFrom: 4 to: 4) = (self newCopy: #($4)).
	self should: [source copyFrom: 4 to: 5] raise: BoundsError.


!

testEndsWith
	"Test SequenceableCollection>>endsWith:"

	| sequence |
	sequence := self newCollection: #().
	self assert: (sequence endsWith: (self newUnsortedCollection: #())).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2))) not.
	sequence := self newCollection: #($1).
	self assert: (sequence endsWith: (self newUnsortedCollection: #())).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2 $3))) not.
	sequence := self newCollection: #($1 $2).
	self assert: (sequence endsWith: (self newUnsortedCollection: #())).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2 $1))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $3))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2 $3))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2 $1 $3))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2 $4))) not.
	sequence := self newCollection: #($1 $2 $3).
	self assert: (sequence endsWith: (self newUnsortedCollection: #())).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($3))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2 $3))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($2 $1))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2 $3))).
	self assert: (sequence endsWith: (self newUnsortedCollection: #($3 $1 $2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $3 $2))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2 $4))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($1 $2 $3 $4))) not.
	self assert: (sequence endsWith: (self newUnsortedCollection: #($4 $1 $2 $3))) not!

testFirst
	| first |
	self should: [(self newCollection: #()) first] raise: BoundsError.
	first := (self newCollection: #(49)) at: 1.
	self assert: (self newCollection: #(49)) first = first.
	self assert: (self newCollection: #(49 50)) first = first!

testFirstColon
	| empty one two three |
	empty := self newCollection: #().
	self assert: (empty first: 0) = (self newCopy: empty).
	self should: [empty first: 1] raise: BoundsError.
	self should: [empty first: 2] raise: BoundsError.
	self should: [empty first: -1] raise: Error.
	one := self newCollection: #($1).
	self assert: (one first: 0) = (self newCopy: empty).
	self assert: (one first: 1) = (self newCopy: one).
	self should: [one first: 2] raise: BoundsError.
	self should: [one first: -1] raise: Error.
	two := self newCollection: #($1 $2).
	self assert: (two first: 0) = (self newCopy: empty).
	self assert: (two first: 1) = (self newCopy: one).
	self assert: (two first: 2) = (self newCopy: two).
	self should: [two first: 3] raise: BoundsError.
	self should: [one first: -1] raise: Error.
	three := self newCollection: #($1 $2 $3).
	self assert: (three first: 0) = (self newCopy: empty).
	self assert: (three first: 1) = (self newCopy: one).
	self assert: (three first: 2) = (self newCopy: two).
	self assert: (three first: 3) = (self newCopy: three).
	self should: [two first: 4] raise: BoundsError.
	self should: [one first: -1] raise: Error.
!

testFromToKeysAndValuesDo
	"Empty array"

	| array pairs |
	array := self newNumericArray: 0.
	pairs := OrderedCollection new.
	#(#(1 0)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(0 -1) #(-1 0) #(0 1) #(1 1) #(2 2) #(2 1) #(3 2)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue]]
				raise: BoundsError.
			self assert: pairs isEmpty].
	"Array of 1 element"
	array := self newNumericArray: 1.
	#(#(1 0) #(2 1)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue].
			self assert: pairs isEmpty].
	#(#(1 1)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: 1
				to: 1
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> i printString].
			self assert: pairs asArray = expected].
	#(#(1 2) #(2 2) #(3 2)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError].
	pairs := OrderedCollection new.
	"Array of two elements"
	array := self newNumericArray: 2.
	#(#(1 0) #(2 1) #(3 2)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> i printString].
			self assert: pairs asArray = expected].
	#(#(1 3) #(2 3) #(3 3)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError].
	"Array of three elements"
	pairs := OrderedCollection new.
	array := self newNumericArray: 3.
	#(#(1 0) #(2 1) #(3 2) #(4 3)) do: 
			[:each | 
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			self assert: pairs isEmpty].
	#(#(1 1) #(1 2) #(2 2) #(1 3) #(2 3) #(3 3)) do: 
			[:each | 
			| expected |
			pairs := OrderedCollection new.
			array 
				from: each first
				to: each last
				keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString].
			expected := (each first to: each last) collect: [:i | i -> i printString].
			self assert: pairs asArray = expected].
	#(#(1 4) #(2 4) #(3 4) #(4 4)) do: 
			[:each | 
			self should: 
					[array 
						from: each first
						to: each last
						keysAndValuesDo: [:eachKey :eachValue | pairs addLast: eachKey -> eachValue displayString]]
				raise: BoundsError]!

testFromToKeysAndValuesDo2
	#(#() #(65) #(65 66) #(65 66 67) #(65 66 67 68)) do: 
			[:sequence | 
			| enum collection |
			enum := OrderedCollection new.
			collection := self newCollection: sequence.
			"Deliberate enumeration over an empty interval - should be valid"
			collection 
				from: sequence size + 1
				to: sequence size
				keysAndValuesDo: [:i :each | enum add: each].
			self assert: enum isEmpty.
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

testIncludes
	| searchee |
	searchee := self newCollection: 'abc'.
	self assert: (searchee includes: (self assimilate: $a)).
	self assert: (searchee includes: (self assimilate: $b)).
	self assert: (searchee includes: (self assimilate: $c)).
	self deny: (searchee includes: (self assimilate: $A)).
	self deny: (searchee includes: (self assimilate: $d)).
	self deny: (searchee includes: Object new)!

testIncludesAnyOf
	| searchee |
	searchee := self newCollection: 'abcdefgabcdef'.
	self assert: (searchee includesAnyOf: (self newCollection: 'a')).
	self assert: (searchee includesAnyOf: (self newCollection: 'bc')).
	self assert: (searchee includesAnyOf: (self newCollection: 'ez')).
	self deny: (searchee includesAnyOf: (self newCollection: '')).
	self deny: (searchee includesAnyOf: (self newCollection: 'z')).
	self deny: (searchee includesAnyOf: (self newCollection: 'xyz')).
	searchee := self newCollection: ''.
	self deny: (searchee includesAnyOf: (self newCollection: '')).
	self deny: (searchee includesAnyOf: (self newCollection: 'a')).
	self deny: (searchee includesAnyOf: (self newCollection: 'ab')).
	"#715"
	searchee := self collectionClass new: 10.
	self deny: (searchee includesAnyOf: (self newCollection: 'a')).
	searchee := (self collectionClass new: 1), (self newCollection: 'abc').
	self assert: (searchee includesAnyOf: (self newCollection: 'b')).!

testIndexOfAnyOfStartingAt
	| searchee db bd de a d abc offset |
	db := self newCollection: 'db'.
	a := self newCollection: 'a'.
	d := self newCollection: 'd'.
	abc := self newCollection: 'abc'.
	searchee := self newCollection: ''.
	self assert: (searchee indexOfAnyOf: searchee startingAt: 1) = 0.
	self assert: (searchee indexOfAnyOf: a startingAt: 1) = 0.
	self assert: (searchee indexOfAnyOf: db startingAt: 1) = 0.
	searchee := abc.
	self assert: (searchee indexOfAnyOf: db startingAt: 1) = 2.
	self assert: (searchee indexOfAnyOf: db startingAt: 2) = 2.
	self assert: (searchee indexOfAnyOf: db startingAt: 3) = 0.
	bd := self newCollection: 'bd'.
	self assert: (searchee indexOfAnyOf: bd startingAt: 1) = 2.
	de := self newCollection: 'de'.
	self assert: (searchee indexOfAnyOf: de startingAt: 1) = 0.
	searchee := self newCollection: (String new: 1).
	searchee isSymbol 
		ifFalse: 
			[self assert: (searchee indexOfAnyOf: searchee startingAt: 1) = 1.
			self assert: (searchee indexOfAnyOf: a startingAt: 1) = 0.
			self assert: (searchee indexOfAnyOf: db startingAt: 1) = 0].
	searchee := abc , (self newCollection: (String new: 1)).
	offset := searchee first == Character null ifTrue: [1] ifFalse: [0].

	self assert: (searchee indexOfAnyOf: db startingAt: 1) = (2+offset).
	self assert: (searchee indexOfAnyOf: a startingAt: 1) = (1+offset).
	self assert: (searchee indexOfAnyOf: de startingAt: 1) = 0!

testLast
	self should: [(self newCollection: #()) last] raise: BoundsError.
	self assert: (self newCollection: #(49)) last = (self assimilate: 49).
	self assert: (self newCollection: #(49 50)) last = (self assimilate: 50).
	self assert: (self newCollection: #(49 50 51)) last = (self assimilate: 51)!

testLastColon
	| empty one two three |
	empty := self newCollection: #().
	self assert: (empty last: 0) = (self newCopy: empty).
	self should: [empty last: 1] raise: BoundsError.
	self should: [empty last: 2] raise: BoundsError.
	self should: [empty last: -1] raise: Error.
	one := self newCollection: #($2).
	self assert: (one last: 0) = (self newCopy: empty).
	self assert: (one last: 1) = (self newCopy: one).
	self should: [one last: 2] raise: BoundsError.
	self should: [one last: -1] raise: Error.
	two := self newCollection: #($1 $2).
	self assert: (two last: 0) = (self newCopy: empty).
	self assert: (two last: 1) = (self newCopy: #($2)).
	self assert: (two last: 2) = (self newCopy: two).
	self should: [two last: 3] raise: BoundsError.
	self should: [one last: -1] raise: Error.
	three := self newCollection: #($1 $2 $3).
	self assert: (three last: 0) = (self newCopy: empty).
	self assert: (three last: 1) = (self newCopy: #($3)).
	self assert: (three last: 2) = (self newCopy: #($2 $3)).
	self assert: (three last: 3) = (self newCopy: three).
	self should: [two last: 4] raise: BoundsError.
	self should: [one last: -1] raise: Error.
!

testReplaceFromToWithStartingAt
	| a |
	a := self newCollection: #($1 $2 $3 $4 $5).
	a 
		replaceFrom: 2
		to: 4
		with: (self newCollection: #($a $b $c $d $e))
		startingAt: 2.
	self assert: a = (self newCollection: #($1 $b $c $d $5)).
	a := self newCollection: #($1 $2 $3 $4 $5).
	a 
		replaceFrom: 2
		to: 4
		with: a
		startingAt: 3.
	self assert: a = (self newCollection: #($1 $3 $4 $5 $5)).
	a := self newCollection: #($1 $2 $3 $4 $5).
	a 
		replaceFrom: 2
		to: 4
		with: a
		startingAt: 1.
	self assert: a = (self newCollection: #($1 $1 $2 $3 $5))

!

unsortedCollectionClass
	^self collectionClass! !
!SequenceableCollectionTest categoriesFor: #assimilate:!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #assimilateElements:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #byteArrayForSequence:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #collectionClass!helpers!private! !
!SequenceableCollectionTest categoriesFor: #newCollection:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #newCopy:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #newNumericArray:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #newUnsortedCollection:!helpers!private! !
!SequenceableCollectionTest categoriesFor: #testAsByteArray!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testBeginsWith!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testBinarySearch!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testCopyFromTo!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testEndsWith!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testFirst!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testFirstColon!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testFromToKeysAndValuesDo!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testFromToKeysAndValuesDo2!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testIncludes!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testIncludesAnyOf!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testIndexOfAnyOfStartingAt!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testLast!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testLastColon!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #testReplaceFromToWithStartingAt!public!unit tests! !
!SequenceableCollectionTest categoriesFor: #unsortedCollectionClass!public!unit tests! !

!SequenceableCollectionTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!SequenceableCollectionTest class categoriesFor: #isAbstract!public!Testing! !

