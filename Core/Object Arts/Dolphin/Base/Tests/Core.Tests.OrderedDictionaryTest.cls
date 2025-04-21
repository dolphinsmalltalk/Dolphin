"Filed out from Dolphin Smalltalk"!

Core.Tests.AbstractDictionaryTest
	subclass: #'Core.Tests.OrderedDictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.OrderedDictionaryTest guid: (Core.GUID fromString: '{2185c58e-373e-4169-a315-6603d34dbc1c}')!

Core.Tests.OrderedDictionaryTest comment: ''!

!Core.Tests.OrderedDictionaryTest categoriesForClass!CollectionsTests-Sequenceable! !

!Core.Tests.OrderedDictionaryTest methodsFor!

collectionClass
	^OrderedDictionary!

newEmpty
	^self collectionClass new!

testAssociations
	| subject actual expected |
	subject := self newCollection: (1 to: 5).
	expected := (1 to: 5) collect: [:i | subject newAssociation: (self makeKey: i) value: (self assimilate: i)].
	actual := subject associations.
	self assert: actual class identicalTo: Array.
	self assert: actual sort equals: expected sort!

testAssociationsDo
	| subject actual expected |
	subject := self newEmpty.
	subject associationsDo: [:assoc | self fail: 'empty collection should not be enumerated'].
	expected := Set new.
	(1 to: 5) do: 
			[:each |
			| key value |
			key := self makeKey: each.
			value := self assimilate: each.
			expected add: (subject associationClass key: key value: value value).
			subject at: key put: value].
	actual := Set new.
	subject associationsDo: [:each | actual add: each].
	self assert: actual equals: expected!

testCompact
	| subject |
	subject := self newEmpty.
	1 to: 3 do: [:ea | subject at: ea put: nil].
	subject removeKey: 2.
	self assert: 2 equals: ((subject instVarNamed: #order) count: [:ea | ea notNil])!

testCompare
	| dictOne dictTwo subject |
	subject := self newEmpty.
	subject
		at: #a put: 5;
		at: #b put: 4.
	self assert: subject equals: subject.
	dictOne := OrderedDictionary with: #a -> 5 with: #b -> 4.
	dictTwo := OrderedDictionary with: #a -> 5 with: #b -> 4.
	self assert: dictOne equals: dictTwo.
	dictOne := OrderedDictionary with: #a -> 5 with: #b -> 4.
	dictTwo := OrderedDictionary with: 'a' -> 5 with: 'b' -> 4.
	self assert: dictOne equals: dictTwo.
	dictOne := OrderedDictionary with: #a -> 5 with: #b -> 4.
	dictTwo := OrderedDictionary with: #b -> 4 with: #a -> 5.
	self deny: dictOne equals: dictTwo!

testCopy
	| copy subject |
	subject := self newEmpty.
	1 to: 3 do: [:i | subject at: i printString put: i].
	copy := subject copy.
	self assert: subject keys equals: copy keys.
	copy at: 4 put: nil.
	self assert: subject keys size < copy keys size!

testGrow
	| subject |
	subject := self newEmpty.
	self
		assert: 3 equals: subject basicSize;
		assert: subject basicSize equals: (subject instVarNamed: #order) size.
	1 to: subject basicSize do: [:each | subject at: each put: 'value-' , each printString].
	self
		assert: subject basicSize > 3;
		assert: subject basicSize equals: (subject instVarNamed: #order) size!

testOrder
	| subject |
	subject := self newCollection: (1 to: 10).
	self assert: subject keys equals: (1 to: 10).
	subject removeKey: 5.
	self assert: subject keys equals: #(1 2 3 4 6 7 8 9 10).
	subject at: 5 put: '5b'.
	self assert: subject keys equals: #(1 2 3 4 6 7 8 9 10 5)!

testOverflow
	"Check whether repeated additions of the same alternating keys causes an error."

	| subject |
	subject := self newEmpty.
	self shouldnt: [20 timesRepeat: 
					[subject
						at: 1 put: nil;
						removeKey: 1]]
		raise: Error!

testOverwriteValue
	"First write wins wrt. order in the dictionary."

	| subject |
	subject := self newCollection: (1 to: 5).
	self assert: subject values equals: (1 to: 5).
	subject at: 3 put: '3b'.
	self assert: subject keys equals: (1 to: 5).
	self assert: subject values equals: #(1 2 '3b' 4 5)
! !

!Core.Tests.OrderedDictionaryTest categoriesForMethods!
collectionClass!public! !
newEmpty!public! !
testAssociations!public! !
testAssociationsDo!public! !
testCompact!public! !
testCompare!public! !
testCopy!public! !
testGrow!public! !
testOrder!public! !
testOverflow!public! !
testOverwriteValue!public! !
!

