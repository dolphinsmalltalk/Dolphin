"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #DictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DictionaryTest guid: (GUID fromString: '{733B8918-1913-46DF-995E-67541BD596AA}')!
DictionaryTest comment: ''!
!DictionaryTest categoriesForClass!Unclassified! !
!DictionaryTest methodsFor!

checkValidity: aDictionary 
	#todo.	"Import the Dictionary>>checkValidity method from StrongTalk"
	aDictionary	"checkValidity"!

collectionClass
	^Dictionary!

newDictionary
	| dictionary |
	dictionary := self newEmpty.
	dictionary at: #key put: 1.
	^dictionary!

newEmpty
	^self collectionClass new!

testAtIfAbsent
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: #key ifAbsent: [2]) == 1.
	self assert: (dictionary at: #value ifAbsent: [2]) == 2!

testAtIfAbsentPut
	| dictionary initialSize |
	dictionary := self newDictionary.
	initialSize := dictionary size.
	self assert: (dictionary at: #key ifAbsentPut: [2]) == 1.
	self assert: dictionary size == initialSize.
	self assert: (dictionary at: #value ifAbsentPut: [2]) == 2.
	self assert: dictionary size == (initialSize+1).
	self assert: (dictionary at: #value ifAbsentPut: [3]) == 2.
	self assert: dictionary size == (initialSize+1).
!

testAtIfAbsentPutModifyingCollection
	"Test at:ifAbsentPut: when modifying the collection in the block"

	| dictionary test keys |
	dictionary := self newEmpty.
	"First test keys that collide: For this test to work they must collide, so verify that"
	self assert: (dictionary findKeyOrNil: 'a') == (dictionary findKeyOrNil: 'd').
	dictionary at: 'a'
		ifAbsentPut: 
			[dictionary at: 'd' put: 4.
			1].
	self assert: dictionary size = 2.
	self assert: (dictionary at: 'd') == 4.
	self assert: (dictionary at: 'a') == 1.
	"Another test, this time attempting to create duplicate key entries"
	dictionary := self newEmpty.
	test := dictionary.
	test at: 'a'
		ifAbsentPut: 
			[test
				at: 'b' put: 2;
				at: 'c' put: 3;
				at: 'a' put: 10].
	keys := OrderedCollection new.
	test keysDo: [:each | keys addLast: each].
	self assert: keys asSortedCollection asArray = #('a' 'b' 'c')!

testCyclicRefPrinting
	| dictionary |
	dictionary := self newEmpty.
	(dictionary class == PoolConstantsDictionary) ifTrue: [^self].
	dictionary at: dictionary put: dictionary.
	self assert: 0 < (dictionary debugPrintString indexOfSubCollection: '... a cyclic ref to ' startingAt: 1)!

testDeepCopy
	"#2066"

	| dict copy any |
	dict := self newDictionary.
	1 to: 5 do: [:i | dict at: (Character value: $A asciiValue + i) put: i].
	any := dict keys.
	any do: [:each | self assert: (dict includesKey: each)].
	copy := dict deepCopy.
	self assertIs: copy deepCopyOf: dict.
	any := copy keys.
	any do: [:each | self assert: (copy includesKey: each)]!

testIncludesKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary includesKey: #key).
	self deny: (dictionary includesKey: #value).
	self deny: (dictionary includesKey: nil).

!

testRemoveKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary removeKey: #key) == 1.
	self should: [dictionary removeKey: #key] raise: NotFoundError! !
!DictionaryTest categoriesFor: #checkValidity:!benchmarking!private! !
!DictionaryTest categoriesFor: #collectionClass!helpers!private! !
!DictionaryTest categoriesFor: #newDictionary!private!unit tests! !
!DictionaryTest categoriesFor: #newEmpty!helpers!public! !
!DictionaryTest categoriesFor: #testAtIfAbsent!public!unit tests! !
!DictionaryTest categoriesFor: #testAtIfAbsentPut!public!unit tests! !
!DictionaryTest categoriesFor: #testAtIfAbsentPutModifyingCollection!public!unit tests! !
!DictionaryTest categoriesFor: #testCyclicRefPrinting!public! !
!DictionaryTest categoriesFor: #testDeepCopy!public!unit tests! !
!DictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!DictionaryTest categoriesFor: #testRemoveKey!public!unit tests! !

