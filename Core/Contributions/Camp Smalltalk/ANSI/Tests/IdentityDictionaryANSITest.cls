"Filed out from Dolphin Smalltalk 7"!

MainTestCase subclass: #IdentityDictionaryANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
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
!IdentityDictionaryANSITest categoriesFor: #canonicalObject!public! !
!IdentityDictionaryANSITest categoriesFor: #emptyCanonicalObject!public! !
!IdentityDictionaryANSITest categoriesFor: #protocol!public! !
!IdentityDictionaryANSITest categoriesFor: #testXaddAllX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXallSatisfyX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXanySatisfyX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasArray!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasBag!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasByteArray!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasOrderedCollection!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasSet!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasSortedCollection!public! !
!IdentityDictionaryANSITest categoriesFor: #testXasSortedCollectionX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXatX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXatXifAbsentPutX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXatXifAbsentX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXatXputX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXcollectX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXdetect!public! !
!IdentityDictionaryANSITest categoriesFor: #testXdetectXifNoneX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXdoX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXdoXseparatedByX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXincludesKeyX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXincludesX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXinjectXintoX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXisEmpty!public! !
!IdentityDictionaryANSITest categoriesFor: #testXnotEmpty!public! !
!IdentityDictionaryANSITest categoriesFor: #testXoccurrencesOfX!public! !
!IdentityDictionaryANSITest categoriesFor: #testXrehash!public! !
!IdentityDictionaryANSITest categoriesFor: #testXsize!public! !

