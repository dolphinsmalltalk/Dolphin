"Filed out from Dolphin Smalltalk 7"!

TestCaseHelper subclass: #AbstractDictionaryHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
AbstractDictionaryHelper guid: (GUID fromString: '{231d61aa-01c6-4120-b38f-813d3790f479}')!
AbstractDictionaryHelper comment: ''!
!AbstractDictionaryHelper categoriesForClass!Unclassified! !
!AbstractDictionaryHelper methodsFor!

emptyObject
	^testCase emptyCanonicalObject!

object
	^testCase canonicalObject!

object: anObject!

testXaddAllX
	" <abstractDictionary>#addAll: "

	| abstractDictionary canonicalObject |
	#Collection.

	abstractDictionary := self emptyObject.
	canonicalObject := self object.
	self value: [abstractDictionary addAll: canonicalObject]
		should: [:r | r keysDo: [:key | (r at: key) = (canonicalObject at: key)]]
		conformTo: #abstractDictionary
		selector: #addAll:!

testXatX
	" <abstractDictionary>#at: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject at: 1]
		should: [:r | r  == 11]
		conformTo: #abstractDictionary
		selector: #at:!

testXatXifAbsentPutX
	" <abstractDictionary>#at:ifAbsentPut: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject at: 3 ifAbsentPut: 99]
		should: [:r | r = 33]
		conformTo: #abstractDictionary
		selector: #at:ifAbsentPut:.
	self value: [canonicalObject at: 7 ifAbsentPut: 99]
		should: [:r | r = 99]
		conformTo: #abstractDictionary
		selector: #at:ifAbsentPut:.
	self value: [canonicalObject at: 17 ifAbsentPut: nil]
		should: [:r | r = nil]
		conformTo: #abstractDictionary
		selector: #at:ifAbsentPut:!

testXatXifAbsentX
	" <abstractDictionary>#at:ifAbsent: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject at: 3 ifAbsent: 99]
		should: [:r | r = 33]
		conformTo: #abstractDictionary
		selector: #at:ifAbsent:.
	self value: [canonicalObject at: 7 ifAbsent: 99]
		should: [:r | r = 99]
		conformTo: #abstractDictionary
		selector: #at:ifAbsent:!

testXatXputX
	" <abstractDictionary>#at:put: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject at: 3 put: 99]
		should: [:r | r = 99]
		conformTo: #abstractDictionary
		selector: #at:put:.
	self value: [canonicalObject at: 7 put: 7]
		should: [:r | r = 7]
		conformTo: #abstractDictionary
		selector: #at:put:!

testXcollectX
	" <abstractDictionary>#collect: (Return Values: <RECEIVER>)"

	"standard says that collect: returns an object of the same type as the receiver,
	which would be either a Dictionary or an IdentityDictionary.  Most Smalltalks
	return an OrderedCollection"

	| canonicalObject |
	#Collection.
	canonicalObject := self  object.
	self value: [canonicalObject collect: [:each | each * 2]]
		should: [:r || ok |
		    ok := r size = canonicalObject size.
		    r keysDo: [:each | ok := ok and: [ (r at: each) = ((canonicalObject at: each) * 2)]].
		    ok
		]
		conformTo: #abstractDictionary
		selector: #collect:.
	self should: [canonicalObject collect: [:each | each , '2']]
		raise: TestResult error!

testXincludesKeyX
	" <abstractDictionary>#includesKey: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject includesKey: 1]
		should: [:r | true]
		conformTo: #abstractDictionary
		selector: #includesKey:!

testXkeyAtValueX
	" <abstractDictionary>#keyAtValue "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject keyAtValue: 22]
		should: [:r | r = 2]
		conformTo: #abstractDictionary
		selector: #keyAtValue:.
	"The ANSI standard is ambiguous on the behaviour here. The 5.7.2.8 synopsis says 'Answer nil if no such key is found.', but the description says 'The result is undefined if the receiver does not contain an element equivalent to value.'. It is likely that the synopsis is wrong, since the standard implementation in Smalltalk has long been to throw an error here, especially as there is a keyAtValue:ifAbsent: message in the protocol."
	"self value: [canonicalObject keyAtValue: 666]
		should: [:r | r = nil]
		conformTo: #abstractDictionary
		selector: #keyAtValue:"
	self should: [canonicalObject keyAtValue: 666]
		raise: Error!

testXkeyAtValueXifAbsentX
	" <abstractDictionary>#keyAtValue:ifAbsent: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject keyAtValue: 22 ifAbsent: [nil]]
		should: [:r | r = 2]
		conformTo: #abstractDictionary
		selector: #keyAtValue:ifAbsent:.
	self value: [canonicalObject keyAtValue: 666 ifAbsent: [nil]]
		should: [:r | r = nil]
		conformTo: #abstractDictionary
		selector: #keyAtValue:ifAbsent:!

testXkeys
	" <abstractDictionary>#keys "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject keys]
		should: [:r | r size = canonicalObject size]
		conformTo: #abstractDictionary
		selector: #keys!

testXkeysAndValuesDoX
	" <abstractDictionary>#keysAndValuesDo: "

	| canonicalObject sum |
	#Collection.
	canonicalObject := self object.
	sum := 0.
	self
		value: [canonicalObject keysAndValuesDo: [:key :value | sum := sum + key + value]]
		should: [:r | sum = 120]
		conformTo: #abstractDictionary
		selector: #keysAndValuesDo:.
	self should: [canonicalObject keysAndValuesDo: [:key :value | key , 'a']]
		raise: TestResult error!

testXkeysDoX
	" <abstractDictionary>#keysDo: "

	| sum canonicalObject |
	#Collection.
	canonicalObject := self object.
	sum := 0.
	self value: [canonicalObject keysDo: [:key | sum := sum + key]]
		should: [:r | sum = 10]
		conformTo: #abstractDictionary
		selector: #keysDo:.
	self should: [canonicalObject keysDo: [:key | key , 'a']]
		raise: TestResult error!

testXrejectX
	" <abstractDictionary>#reject: (Return Values: <RECEIVER>)"

	"standard says that reject: returns an object of the same type as the receiver,
	which would be either a Dictionary or an IdentityDictionary.  Most Smalltalks
	return an OrderedCollection"

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject reject: [:each | each > 0]]
		should: [:r | r isEmpty]
		conformTo: #abstractDictionary
		selector: #reject:.
	self should: [canonicalObject reject: [:each | each * '2']]
		raise: TestResult error!

testXremoveAllKeysifAbsentX
	" <abstractDictionary>#removeAllKeys: "

	| canonicalObject keys sum |
	#Collection.
	canonicalObject := self object.
	sum := 0.
	keys := #(111 222).
	self value: 
			[canonicalObject removeAllKeys: keys ifAbsent: [:key | sum := sum + key]]
		should: [:r | sum = 333]
		conformTo: #abstractDictionary
		selector: #removeAllKeys:ifAbsent:.
	sum := 0.
	keys := #($a $b).
	self should: 
			[canonicalObject removeAllKeys: keys ifAbsent: [:key | sum := sum + key]]
		raise: TestResult error!

testXremoveAllKeysX
	" <abstractDictionary>#removeAllKeys: "

	| canonicalObject keys |
	#Collection.
	canonicalObject := self object.
	keys := canonicalObject keys.
	self value: [canonicalObject removeAllKeys: keys]
		should: [:r | r isEmpty]
		conformTo: #abstractDictionary
		selector: #removeAllKeys:!

testXremoveKeyX
	" <abstractDictionary>#removeKey: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject removeKey: 2]
		should: [:r | r = 22]
		conformTo: #abstractDictionary
		selector: #removeKey:!

testXremoveKeyXifAbsentX
	" <abstractDictionary>#removeKey:ifAbsent: "

	| canonicalObject |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject removeKey: 2 ifAbsent: [nil]]
		should: [:r | r = 22]
		conformTo: #abstractDictionary
		selector: #removeKey:ifAbsent:.
	canonicalObject := self object.
	self value: [canonicalObject removeKey: 666 ifAbsent: [nil]]
		should: [:r | r isNil]
		conformTo: #abstractDictionary
		selector: #removeKey:ifAbsent:!

testXselectX
	" <abstractDictionary>#select: (Return Values: <RECEIVER>)"

	"standard says that select: returns an object of the same type as the receiver,
	which would be either a Dictionary or an IdentityDictionary.  Most Smalltalks
	return an OrderedCollection"

	| canonicalObject |
	#Collection.
	canonicalObject := self  object.
	self value: [canonicalObject select: [:each | each < 0]]
		should: [:r | r isEmpty]
	conformTo: #abstractDictionary
		selector: #select:.
	self should: [canonicalObject select: [:each | each , '2']]
		raise: TestResult error!

testXvalues
	" <abstractDictionary>#values"

	| canonicalObject checkSum |
	#Collection.
	canonicalObject := self object.
	self value: [canonicalObject values]
		should: 
			[:r | 
			checkSum := r inject: 0 into: [:sum :each | sum + each].
			checkSum = 110]
		conformTo: #abstractDictionary
		selector: #values.! !
!AbstractDictionaryHelper categoriesFor: #emptyObject!public! !
!AbstractDictionaryHelper categoriesFor: #object!public! !
!AbstractDictionaryHelper categoriesFor: #object:!public! !
!AbstractDictionaryHelper categoriesFor: #testXaddAllX!public! !
!AbstractDictionaryHelper categoriesFor: #testXatX!public! !
!AbstractDictionaryHelper categoriesFor: #testXatXifAbsentPutX!public! !
!AbstractDictionaryHelper categoriesFor: #testXatXifAbsentX!public! !
!AbstractDictionaryHelper categoriesFor: #testXatXputX!public! !
!AbstractDictionaryHelper categoriesFor: #testXcollectX!public! !
!AbstractDictionaryHelper categoriesFor: #testXincludesKeyX!public! !
!AbstractDictionaryHelper categoriesFor: #testXkeyAtValueX!public! !
!AbstractDictionaryHelper categoriesFor: #testXkeyAtValueXifAbsentX!public! !
!AbstractDictionaryHelper categoriesFor: #testXkeys!public! !
!AbstractDictionaryHelper categoriesFor: #testXkeysAndValuesDoX!public! !
!AbstractDictionaryHelper categoriesFor: #testXkeysDoX!public! !
!AbstractDictionaryHelper categoriesFor: #testXrejectX!public! !
!AbstractDictionaryHelper categoriesFor: #testXremoveAllKeysifAbsentX!public! !
!AbstractDictionaryHelper categoriesFor: #testXremoveAllKeysX!public! !
!AbstractDictionaryHelper categoriesFor: #testXremoveKeyX!public! !
!AbstractDictionaryHelper categoriesFor: #testXremoveKeyXifAbsentX!public! !
!AbstractDictionaryHelper categoriesFor: #testXselectX!public! !
!AbstractDictionaryHelper categoriesFor: #testXvalues!public! !

