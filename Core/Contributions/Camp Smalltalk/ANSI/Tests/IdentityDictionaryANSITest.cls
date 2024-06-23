"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #IdentityDictionaryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

IdentityDictionaryANSITest guid: (GUID fromString: '{b497af9a-b6af-4e23-ab74-d84e8e429b83}')!

IdentityDictionaryANSITest comment: ''!

!IdentityDictionaryANSITest categoriesForClass!Unclassified! !

!IdentityDictionaryANSITest methodsFor!

canonicalObject
	^IdentityDictionary new at: 1 put: 11; at: 2 put: 22; at:3 put: 33; at:4 put: 44; yourself!

emptyCanonicalObject
	^IdentityDictionary new!

protocol
	^#'IdentityDictionary'!

testXaddAllX
	" <abstractDictionary>#addAll: "
	#'Collection'.!

testXallSatisfyX
	" <collection>#allSatisfy: "
	#'Collection'.!

testXanySatisfyX
	" <collection>#anySatisfy: "
	#'Collection'.!

testXasArray
	" <collection>#asArray "
	#'Collection'.!

testXasBag
	" <collection>#asBag "
	#'Collection'.!

testXasByteArray
	" <collection>#asByteArray "
	#'Collection'.!

testXasOrderedCollection
	" <collection>#asOrderedCollection "
	#'Collection'.!

testXasSet
	" <collection>#asSet "
	#'Collection'.!

testXasSortedCollection
	" <collection>#asSortedCollection "
	#'Collection'.!

testXasSortedCollectionX
	" <collection>#asSortedCollection: "
	#'Collection'.!

testXatX
	" <abstractDictionary>#at: "
	#'Collection'.!

testXatXifAbsentPutX
	" <abstractDictionary>#at:ifAbsentPut: "
	#'Collection'.!

testXatXifAbsentX
	" <abstractDictionary>#at:ifAbsent: "
	#'Collection'.!

testXatXputX
	" <abstractDictionary>#at:put: "
	#'Collection'.!

testXcollectX
	" <abstractDictionary>#collect: (Return Values: <RECEIVER>)"
	#'Collection'.!

testXdetect
	" <collection>#detect: "
	#'Collection'.!

testXdetectXifNoneX
	" <collection>#detect:ifNone: "
	#'Collection'.!

testXdoX
	" <collection>#do: "
	#'Collection'.!

testXdoXseparatedByX
	" <collection>#do:separatedBy: "
	#'Collection'.!

testXincludesKeyX
	" <abstractDictionary>#includesKey: "
	#'Collection'.!

testXincludesX
	" <collection>#includes: "
	#'Collection'.!

testXinjectXintoX
	" <collection>#inject:into: "
	#'Collection'.!

testXisEmpty
	" <collection>#isEmpty "
	#'Collection'.!

testXnotEmpty
	" <collection>#notEmpty "
	#'Collection'.!

testXoccurrencesOfX
	" <collection>#occurrencesOf: "
	#'Collection'.!

testXrehash
	" <collection>#rehash "
	#'Collection'.!

testXsize
	" <collection>#size "
	#'Collection'.! !

!IdentityDictionaryANSITest categoriesForMethods!
canonicalObject!public! !
emptyCanonicalObject!public! !
protocol!public! !
testXaddAllX!public! !
testXallSatisfyX!public! !
testXanySatisfyX!public! !
testXasArray!public! !
testXasBag!public! !
testXasByteArray!public! !
testXasOrderedCollection!public! !
testXasSet!public! !
testXasSortedCollection!public! !
testXasSortedCollectionX!public! !
testXatX!public! !
testXatXifAbsentPutX!public! !
testXatXifAbsentX!public! !
testXatXputX!public! !
testXcollectX!public! !
testXdetect!public! !
testXdetectXifNoneX!public! !
testXdoX!public! !
testXdoXseparatedByX!public! !
testXincludesKeyX!public! !
testXincludesX!public! !
testXinjectXintoX!public! !
testXisEmpty!public! !
testXnotEmpty!public! !
testXoccurrencesOfX!public! !
testXrehash!public! !
testXsize!public! !
!

