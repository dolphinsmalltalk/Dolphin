"Filed out from Dolphin Smalltalk"!

Core.Tests.CollectionTest
	subclass: #'Core.Tests.AbstractDictionaryTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.AbstractDictionaryTest guid: (Core.GUID fromString: '{5d8b76ad-dcc1-44ff-8a2a-cf5e50c4b434}')!
Core.Tests.AbstractDictionaryTest isNonInstantiable: true!
Core.Tests.AbstractDictionaryTest comment: ''!
!Core.Tests.AbstractDictionaryTest methodsFor!

assertCommutativelyEqual: aDictionary other: anotherDictionary
	self assert: aDictionary equals: anotherDictionary.
	self assert: anotherDictionary equals: aDictionary!

checkValidity: aDictionary 
	#todo.	"Import the Dictionary>>checkValidity method from StrongTalk"
	aDictionary	"checkValidity"!

collectionClass
	self subclassResponsibility!

denyCommutativelyEqual: aDictionary other: anotherDictionary
	self deny: aDictionary equals: anotherDictionary.
	self deny: anotherDictionary equals: aDictionary!

key3Value
	^$g!

makeKey: anObject
	^anObject asInteger!

newCollection: anArray
	| testSubject |
	testSubject := self newEmpty.
	anArray do: [:each | testSubject at: (self makeKey: each) put: (self assimilate: each)].
	^testSubject!

newDictionary
	| dictionary |
	dictionary := self newEmpty.
	dictionary at: #key put: (self assimilate: 1).
	^dictionary!

newEmpty
	^self collectionClass new!

testAdd
	| subject assoc2 |
	subject := self newDictionary.
	assoc2 := subject newAssociation: #key2 value: (self assimilate: 2).
	self assert: (subject add: assoc2) identicalTo: assoc2.
	self assert: (subject associationAt: #key2) equals: assoc2.
	assoc2 := subject newAssociation: #key value: (self assimilate: 3).
	self assert: (subject add: assoc2) identicalTo: assoc2.
	self assert: (subject associationAt: #key) equals: assoc2!

testAllKeysAndValuesSatisfy
	| dictionary visited |
	dictionary := self newDictionary.
	dictionary at: #key2 put: (self assimilate: 2).
	visited := OrderedCollection new.
	self
		assert: (dictionary allKeysAndValuesSatisfy: 
					[:eachKey :eachValue |
					visited add: eachKey -> eachValue value.
					true]).
	self assert: visited asSortedArray equals: { #key -> 1. #key2 -> 2 }.
	visited := OrderedCollection new.
	self
		deny: (dictionary allKeysAndValuesSatisfy: 
					[:eachKey :eachValue |
					visited add: eachKey -> eachValue.
					false]).
	self assert: (dictionary associations includes: visited single).
	dictionary removeAll.
	self assert: (dictionary allKeysAndValuesSatisfy: [:each | self assert: false])!

testAllKeysSatisfy
	| dictionary keys |
	dictionary := self newDictionary.
	dictionary at: #key2 put: (self assimilate: 2).
	keys := OrderedCollection new.
	self assert: (dictionary allKeysSatisfy: 
					[:each |
					keys add: each.
					true]).
	self assert: keys asSortedArray equals: #(#key #key2).
	keys := OrderedCollection new.
	self deny: (dictionary allKeysSatisfy: 
					[:each |
					keys add: each.
					false]).
	self assert: (dictionary keys includes: keys single).
	dictionary removeAll.
	self assert: (dictionary allKeysSatisfy: [:each | self assert: false])!

testAnyKeysAndValuesSatisfy
	| dictionary visited |
	dictionary := self newDictionary.
	dictionary at: #key2 put: (self assimilate: 2).
	dictionary at: #key3 put: (self assimilate: 3).
	visited := OrderedCollection new.
	self
		assert: (dictionary anyKeysAndValuesSatisfy: 
					[:eachKey :eachValue |
					visited add: eachKey -> eachValue value.
					visited size = 2]).
	self assert: visited asArray equals: (dictionary associations copyFrom: 1 to: 2).
	dictionary removeAll.
	self deny: (dictionary anyKeysAndValuesSatisfy: [:each | self assert: false])!

testAnyKeysSatisfy
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary anyKeysSatisfy: [:each | each isSymbol]).
	self deny: (dictionary anyKeysSatisfy: [:each | each isInteger]).
	dictionary removeAll.
	self deny: (dictionary anyKeysSatisfy: [:each | self assert: false])!

testAssociations
	| subject actual expected |
	subject := self newEmpty.
	self assert: subject associations equals: #().
	expected := OrderedCollection new.
	(1 to: 5) do: 
			[:each |
			| key value |
			key := self makeKey: each.
			value := self assimilate: each.
			expected add: (subject associationClass key: key value: value value).
			subject at: key put: value].
	expected := expected asArray.
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

testAtIfAbsent
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary at: #key ifAbsent: 2) identicalTo: 1.
	self assert: (dictionary at: #value ifAbsent: 2) identicalTo: 2!

testAtIfAbsentPut
	| dictionary initialSize |
	dictionary := self newDictionary.
	initialSize := dictionary size.
	self assert: (dictionary at: #key ifAbsentPut: [2]) identicalTo: 1.
	self assert: dictionary size identicalTo: initialSize.
	self assert: (dictionary at: #value ifAbsentPut: [2]) identicalTo: 2.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: #value ifAbsentPut: [3]) identicalTo: 2.
	self assert: dictionary size identicalTo: initialSize + 1!

testAtIfAbsentPutClean
	| dictionary initialSize |
	dictionary := self newDictionary.
	initialSize := dictionary size.
	self assert: (dictionary at: #key ifAbsentPutClean: [2]) identicalTo: 1.
	self assert: dictionary size identicalTo: initialSize.
	self assert: (dictionary at: #value ifAbsentPutClean: [2]) identicalTo: 2.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: #value ifAbsentPutClean: [3]) identicalTo: 2.
	self assert: dictionary size identicalTo: initialSize + 1!

testAtIfAbsentPutModifyingCollection
	"Test at:ifAbsentPut: when modifying the collection in the block"

	| keys key3 key1 key2 dictionary value1 value3 |
	dictionary := self newEmpty.
	key1 := self makeKey: $a.

	"For this test to work the first and third keys must collide, so ensure that"
	key3 := self makeKey: self key3Value.
	self assert: (dictionary findKeyOrNil: key3) equals: (dictionary findKeyOrNil: key1).
	key2 := self makeKey: $b.
	self deny: key3 equals: key2.
	value3 := self assimilate: 4.
	value1 := self assimilate: 1.
	dictionary at: key1
		ifAbsentPut: 
			[dictionary at: key3 put: value3.
			value1].
	self assert: dictionary size equals: 2.
	self assert: (dictionary at: key3) value identicalTo: value3 value.
	self assert: (dictionary at: key1) value identicalTo: value1 value.
	"Another test, this time attempting to create duplicate key entries"
	dictionary := self newEmpty.
	dictionary at: key1
		ifAbsentPut: 
			[dictionary
				at: key3 put: (self assimilate: 2);
				at: key2 put: (self assimilate: 3);
				at: key1 put: (self assimilate: 10)].
	keys := OrderedCollection new.
	dictionary keysDo: [:each | keys addLast: each].
	self assert: keys asSortedCollection asArray equals: {key1. key2. key3}!

testAtIfAbsentPutValue
	| initialSize x dictionary |
	dictionary := self newDictionary.
	initialSize := dictionary size.
	x := self assimilate: Object new.
	self assert: (dictionary at: #key ifAbsentPutValue: x) value identicalTo: 1.
	self assert: dictionary size identicalTo: initialSize.
	self assert: (dictionary at: #value ifAbsentPutValue: x) value identicalTo: x value.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: #value ifAbsentPutValue: x) value identicalTo: x value.
	self assert: dictionary size identicalTo: initialSize + 1.
	self assert: (dictionary at: #value ifAbsentPutValue: 3) value identicalTo: x value.
	self assert: dictionary size identicalTo: initialSize + 1!

testCopyWith
	#(#() #($a) #($a $c) #($a $b) #($a $b $d)) do: 
			[:array |
			| subject actual expected |
			subject := self newCollection: array.
			actual := subject copyWith: (self makeKey: $c) -> (self assimilate: $c).
			expected := self newCollection: array , #($c).
			self assert: actual equals: expected]!

testCyclicRefPrinting
	| dictionary |
	dictionary := self newDictionary.
	dictionary at: dictionary put: (self assimilate: dictionary).
	self
		assert: 0 < (dictionary debugPrintString indexOfSubCollection: '... a cyclic ref to ' startingAt: 1)!

testDeepCopy
	"#2066"

	| copy any dictionary |
	dictionary := self newEmpty.
	1 to: 5 do: [:i | dictionary at: (Character value: $A codePoint + i) put: (self assimilate: i)].
	any := dictionary keys.
	any do: [:each | self assert: (dictionary includesKey: each)].
	copy := dictionary deepCopy.
	self assertIs: copy deepCopyOf: dictionary.
	any := copy keys.
	any do: [:each | self assert: (copy includesKey: each)]!

testEquals
	|  dict1 dict2|
	dict1 := self newEmpty.
	"Identical"
	self assert: dict1 equals: dict1.
	dict2 := self newEmpty.
	"Both empty"
	self assertCommutativelyEqual: dict1 other: dict2.
	"Equal key and value (one pair)"
	dict1 := self newDictionary.
	dict2 := self newDictionary.
	self assertCommutativelyEqual: dict1 other: dict2.
	"Extra {key,value} in one Dictionary - not equal"
	dict2 at: 'key2' put: (self assimilate: 'value2' copy).
	self denyCommutativelyEqual: dict1 other: dict2.
	"Equal keys and values (two pairs)"
	dict1 at: 'key2' put: (self assimilate: 'value2' copy).
	self assertCommutativelyEqual: dict1 other: dict2.
	"Value differs"
	dict1 at: 'key3' put: (self assimilate: 'value3' copy).
	dict2 at: 'key3' put: (self assimilate: 'value3a' copy).
	self denyCommutativelyEqual: dict1 other: dict2.
	"Key differs"
	dict2 removeKey: 'key3'.
	dict2 at: 'key4' put: (self assimilate: 'value3' copy).
	self denyCommutativelyEqual: dict1 other: dict2

	"Dictionaries and LookupTables are equal if they have the same elements"!

testIncludesKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary includesKey: #key).
	self deny: (dictionary includesKey: #value).
	self deny: (dictionary includesKey: nil)!

testIsSelfEvaluating
	| subject |
	self newCollection: {1}.
	self assert: self newEmpty isSelfEvaluating.
	self assert: (self newCollection: {1}) isSelfEvaluating.
	self assert: (self newCollection: {1. $b}) isSelfEvaluating.
	subject := self newDictionary.
	subject at: #key put: (self assimilate: Object new).
	self deny: subject isSelfEvaluating.
	subject at: #key put: (self assimilate: subject).
	self deny: subject isSelfEvaluating!

testNilKey
	| dictionary |
	dictionary := self newEmpty.
	self should: [dictionary at: nil put: 1] raise: Error.
	self should: [dictionary at: nil ifAbsentPut: [1]] raise: Error!

testPrintString
	| dictionaryClass subject key key2 |
	dictionaryClass := self collectionClass.
	subject := self newEmpty.
	self assert: subject printString equals: '<1p> new' << dictionaryClass.
	key := self makeKey: $o.
	subject at: key put: (self assimilate: 1).
	self assert: subject printString
		equals: '(<1p> with: <2p> -> <3p>)' << {dictionaryClass. key. subject at: key}.
	subject := self newCollection: #($a $b $c $d $e).
	self assert: subject printString
		equals: '(<1p> withAll: <2p>)' << {dictionaryClass. subject associations sort}.
	key := self makeKey: 1.
	subject := dictionaryClass new
				at: key put: (self assimilate: Object);
				yourself.
	self assert: subject printString
		equals: '(<1p> with: <2p> -> <3p>)' << {dictionaryClass. key. subject at: key}.
	"Multiple elements"
	key2 := self makeKey: 2.
	subject at: key2 put: (self assimilate: Association).
	self assert: subject printString
		equals: '(<1p> withAll: {<2p> -> <3p>. <4p> -> <5p>})' << {dictionaryClass. key. subject at: key. key2. subject at: key2}.
	"Non-evaluable"
	subject := dictionaryClass new
				at: key put: (self assimilate: Object new);
				yourself.
	self assert: subject printString
		equals: '<2?an:a> <1p>(<3p> -> <4p>)'
				<< {dictionaryClass. dictionaryClass shortName first isVowel. key. subject at: key}.

!

testRemoveAssociationAt
	| dictionary removed |
	dictionary := self newDictionary.
	removed := dictionary removeAssociationAt: #key.
	self assert: removed isKindOf: dictionary associationClass.
	self assert: removed key identicalTo: #key.
	self assert: removed value value equals: 1.
	self should: [dictionary removeAssociationAt: #key] raise: NotFoundError!

testRemoveKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary removeKey: #key) value identicalTo: 1.
	self should: [dictionary removeKey: #key] raise: NotFoundError!

testStrongTalkTests
	"These are the StrongTalk tests from Dictionary class>>test."

	| d new oc |
	
	[d := self collectionClass new.
	(d respondsTo: #removeAssociation:ifAbsent:) ifFalse: [^self].
	d at: #this put: #that.
	self assert: (d at: #this) equals: #that.
	new := false.
	d at: #this
		ifAbsentPut: 
			[new := true.
			#that].
	self checkValidity: d.
	self assert: new not.
	d at: #hi
		ifAbsentPut: 
			[new := true.
			#there].
	self checkValidity: d.
	self assert: new.
	oc := OrderedCollection new.
	d keysAndValuesDo: [:k :v | oc add: (d associationClass key: k value: v)].
	self assert: (oc size = 2 and: [oc noDifference: d associations]).
	d add: #hi -> #mom.
	self checkValidity: d.
	self assert: (d associationAt: #hi) value equals: #mom.
	self assert: (d includesAssociation: #hi -> #mom).
	self assert: (d includesAssociation: #yo -> #momma) not.
	self checkValidity: (d copy
				at: #hi put: #there;
				yourself).
	self checkValidity: d.
	self assert: (d at: #hi) equals: #mom.
	new := false.
	d removeAssociation: #this -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: (d includesKey: #this) not & new not.
	d removeAssociation: #bubba -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: new]
			on: UI.ConfirmationRequiredWarning
			do: [:ex | ex refuse]! !
!Core.Tests.AbstractDictionaryTest categoriesForMethods!
assertCommutativelyEqual:other:!helpers!private! !
checkValidity:!benchmarking!private! !
collectionClass!helpers!private! !
denyCommutativelyEqual:other:!helpers!private! !
key3Value!private! !
makeKey:!helpers!private! !
newCollection:!helpers!private! !
newDictionary!private!unit tests! !
newEmpty!helpers!public! !
testAdd!public!unit tests! !
testAllKeysAndValuesSatisfy!public!unit tests! !
testAllKeysSatisfy!public!unit tests! !
testAnyKeysAndValuesSatisfy!public!unit tests! !
testAnyKeysSatisfy!public!unit tests! !
testAssociations!public!unit tests! !
testAssociationsDo!public!unit tests! !
testAtIfAbsent!public!unit tests! !
testAtIfAbsentPut!public!unit tests! !
testAtIfAbsentPutClean!public!unit tests! !
testAtIfAbsentPutModifyingCollection!public!unit tests! !
testAtIfAbsentPutValue!public!unit tests! !
testCopyWith!public!unit tests! !
testCyclicRefPrinting!public! !
testDeepCopy!public!unit tests! !
testEquals!public!unit tests! !
testIncludesKey!public!unit tests! !
testIsSelfEvaluating!public!unit tests! !
testNilKey!public!unit tests! !
testPrintString!public!unit tests! !
testRemoveAssociationAt!public!unit tests! !
testRemoveKey!public!unit tests! !
testStrongTalkTests!benchmarking!public! !
!

