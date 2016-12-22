"Filed out from Dolphin Smalltalk 7"!

DolphinCollectionTest subclass: #AbstractDictionaryTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
AbstractDictionaryTest guid: (GUID fromString: '{5D8B76AD-DCC1-44FF-8A2A-CF5E50C4B434}')!
AbstractDictionaryTest comment: ''!
!AbstractDictionaryTest categoriesForClass!Unclassified! !
!AbstractDictionaryTest methodsFor!

assertCommutativelyEqual: aDictionary other: anotherDictionary
	self assert: aDictionary equals: anotherDictionary.
	self assert: anotherDictionary equals: aDictionary!

checkValidity: aDictionary 
	#todo.	"Import the Dictionary>>checkValidity method from StrongTalk"
	aDictionary	"checkValidity"!

collectionClass
	self subclassResponsibility!

denyCommutativelyEqual: aDictionary other: anotherDictionary
	self deny: aDictionary = anotherDictionary.
	self deny: anotherDictionary = aDictionary!

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

	| keys key3 key1 key2 dictionary |
	dictionary := self newEmpty.
	key1 := self makeKey: $a.
	key3 := self makeKey: (Character codePoint: $a codePoint + dictionary basicSize).
	key2 := self makeKey: $b.
	self assert: key3 ~= key2.
	"For this test to work the first and third keys must collide, so verify that"
	self assert: (dictionary findKeyOrNil: key1) equals: (dictionary findKeyOrNil: key3).
	dictionary at: key1
		ifAbsentPut: 
			[dictionary at: key3 put: 4.
			1].
	self assert: dictionary size = 2.
	self assert: (dictionary at: key3) == 4.
	self assert: (dictionary at: key1) == 1.
	"Another test, this time attempting to create duplicate key entries"
	dictionary := self newEmpty.
	dictionary at: key1
		ifAbsentPut: 
			[dictionary
				at: key3 put: 2;
				at: key2 put: 3;
				at: key1 put: 10].
	keys := OrderedCollection new.
	dictionary keysDo: [:each | keys addLast: each].
	self
		assert: keys asSortedCollection asArray = (Array
						with: key1
						with: key2
						with: key3)!

testAtIfAbsentPutValue
	| initialSize x dictionary |
	dictionary := self newDictionary.
	initialSize := dictionary size.
	x := Object new.
	self assert: (dictionary at: #key ifAbsentPutValue: x) == 1.
	self assert: dictionary size == initialSize.
	self assert: (dictionary at: #value ifAbsentPutValue: x) == x.
	self assert: dictionary size == (initialSize + 1).
	self assert: (dictionary at: #value ifAbsentPutValue: x) == x.
	self assert: dictionary size == (initialSize + 1).
	self assert: (dictionary at: #value ifAbsentPutValue: 3) == x.
	self assert: dictionary size == (initialSize + 1)!

testCyclicRefPrinting
	| dictionary |
	dictionary := self newDictionary.
	dictionary class == PoolConstantsDictionary ifTrue: [^self].
	dictionary at: dictionary put: dictionary.
	self
		assert: 0 < (dictionary debugPrintString indexOfSubCollection: '... a cyclic ref to ' startingAt: 1)!

testDeepCopy
	"#2066"

	| copy any dictionary |
	dictionary := self newDictionary.
	1 to: 5 do: [:i | dictionary at: (Character value: $A asciiValue + i) put: i].
	"Ensure that the hashed collection is the standard capacity for size of contents as the assertIs:deepCopyOf: method expects
	the basic size of the two objects to be the same (which is not relevant for hashed collections)."
	dictionary shrink.
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
	dict2 at: 'key2' put: 'value2' copy.
	self denyCommutativelyEqual: dict1 other: dict2.
	"Equal keys and values (two pairs)"
	dict1 at: 'key2' put: 'value2' copy.
	self assertCommutativelyEqual: dict1 other: dict2.
	"Value differs"
	dict1 at: 'key3' put: 'value3' copy.
	dict2 at: 'key3' put: 'value3a' copy.
	self denyCommutativelyEqual: dict1 other: dict2.
	"Key differs"
	dict2 removeKey: 'key3'.
	dict2 at: 'key4' put: 'value3' copy.
	self denyCommutativelyEqual: dict1 other: dict2

	"Dictionaries and LookupTables are equal if they have the same elements"!

testIncludesKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary includesKey: #key).
	self deny: (dictionary includesKey: #value).
	self deny: (dictionary includesKey: nil)!

testNilKey
	| dictionary |
	dictionary := self newEmpty.
	self should: [dictionary at: nil put: 1] raise: Error.
	self should: [dictionary at: nil ifAbsentPut: [1]] raise: Error!

testRemoveKey
	| dictionary |
	dictionary := self newDictionary.
	self assert: (dictionary removeKey: #key) == 1.
	self should: [dictionary removeKey: #key] raise: NotFoundError!

testStrongTalkTests
	"These are the StrongTalk tests from Dictionary class>>test."

	| d new oc |
	
	[d := self collectionClass new.
	(d respondsTo: #removeAssociation:ifAbsent:) ifFalse: [^self].
	d at: #this put: #that.
	self assert: (d at: #this) = #that.
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
	self assert: (d associationAt: #hi) value = #mom.
	self assert: (d includesAssociation: #hi -> #mom).
	self assert: (d includesAssociation: #yo -> #momma) not.
	self checkValidity: ((d copy)
				at: #hi put: #there;
				yourself).
	self checkValidity: d.
	self assert: (d at: #hi) = #mom.
	new := false.
	d removeAssociation: #this -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: (d includesKey: #this) not & new not.
	d removeAssociation: #bubba -> #that ifAbsent: [new := true].
	self checkValidity: d.
	self assert: new]
			on: ConfirmationRequiredWarning
			do: [:ex | ex refuse]! !
!AbstractDictionaryTest categoriesFor: #assertCommutativelyEqual:other:!helpers!private! !
!AbstractDictionaryTest categoriesFor: #checkValidity:!benchmarking!private! !
!AbstractDictionaryTest categoriesFor: #collectionClass!helpers!private! !
!AbstractDictionaryTest categoriesFor: #denyCommutativelyEqual:other:!helpers!private! !
!AbstractDictionaryTest categoriesFor: #makeKey:!helpers!private! !
!AbstractDictionaryTest categoriesFor: #newCollection:!helpers!private! !
!AbstractDictionaryTest categoriesFor: #newDictionary!private!unit tests! !
!AbstractDictionaryTest categoriesFor: #newEmpty!helpers!public! !
!AbstractDictionaryTest categoriesFor: #testAtIfAbsent!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testAtIfAbsentPut!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testAtIfAbsentPutModifyingCollection!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testAtIfAbsentPutValue!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testCyclicRefPrinting!public! !
!AbstractDictionaryTest categoriesFor: #testDeepCopy!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testEquals!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testIncludesKey!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testNilKey!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testRemoveKey!public!unit tests! !
!AbstractDictionaryTest categoriesFor: #testStrongTalkTests!benchmarking!public! !

!AbstractDictionaryTest class methodsFor!

isAbstract
	"Override to true if a TestCase subclass is Abstract and should not have
	TestCase instances built from it"

	^self == ##(self)! !
!AbstractDictionaryTest class categoriesFor: #isAbstract!public!Testing! !

