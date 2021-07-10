"Filed out from Dolphin Smalltalk"!

SequencedReadableCollectionTest subclass: #OrderedCollectionANSITest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
OrderedCollectionANSITest guid: (GUID fromString: '{6c9b7f37-1d66-46d9-89d1-5422c0657a28}')!
OrderedCollectionANSITest comment: ''!
!OrderedCollectionANSITest categoriesForClass!Unclassified! !
!OrderedCollectionANSITest methodsFor!

canonicalElement

	^self canonicalObject at: 2!

canonicalObject
	^OrderedCollection with: 1 with: 2 with: 3 with: 4!

emptyCollection

	^self canonicalObject class new!

protocol
	^#OrderedCollection!

testXaddAllFirstX
	" <OrderedCollection>#addAllFirst: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAllFirst: #(111 222)]
		should:[:result | result = #(111 222) and: [(orderedCollection at: 1) = 111 and: [(orderedCollection at: 2) = 222]]]
		conformTo: #OrderedCollection
		selector: #addAllFirst:!

testXaddAllLastX
	" <OrderedCollection>#addAllLast: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAllLast: #(111 222)]
		should:[:result | result = #(111 222) and: [(orderedCollection at: orderedCollection size - 1) = 111 and: [(orderedCollection last) = 222]]]
		conformTo: #OrderedCollection
		selector: #addAllLast:!

testXaddAllXafterIndexX
	" <OrderedCollection>#addAll:afterIndex: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAll: #(111 222) afterIndex: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(111 222) afterIndex: -1]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(333 444) afterIndex: 1 ]
		should: [:result | ((orderedCollection at: 2) = 333) and: [(orderedCollection at: 3) = 444] ]
		conformTo: #OrderedCollection
		selector: #addAll:afterIndex:.
	self
		value: [orderedCollection addAll: #(555 666)  afterIndex: 4]
		should: [:result | ((orderedCollection at: 5) = 555) and: [(orderedCollection at: 6) = 666]]
		conformTo: #OrderedCollection
		selector: #addAll:afterIndex:.
	self
		value: [orderedCollection addAll: #(777 888) afterIndex: 0]
		should: [:result | ((orderedCollection first) = 777) and: [( orderedCollection at: 2) = 888]]
		conformTo: #OrderedCollection
		selector: #addAll:afterIndex:!

testXaddAllXafterX
	" <OrderedCollection>#addAll:after: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAll: #(111 222) after: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(333 444) after: 1]
		should: [:result | ((orderedCollection at: 2) = 333) and: [(orderedCollection at: 3) = 444]]
		conformTo: #OrderedCollection
		selector: #addAll:after:.
	self
		value: [orderedCollection addAll: #(555 666)  after: 4]
		should: [:result | ((orderedCollection at: orderedCollection size - 1) = 555) and: [(orderedCollection last) = 666]]
		conformTo: #OrderedCollection
		selector: #addAll:after:.
	self
		value: [orderedCollection addAll: #(777 888) after: 555]
		should: [:result | ((orderedCollection at: orderedCollection size - 2) = 777) and: [( orderedCollection at: orderedCollection size - 1) = 888]]
		conformTo: #OrderedCollection
		selector: #addAll:after:!

testXaddAllXbeforeIndexX
	" <OrderedCollection>#addAll:beforeIndex: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAll: #(111 222) beforeIndex: 6]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(111 222) beforeIndex: 0]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(222 333) beforeIndex: 1]
		should: [:result | (orderedCollection first) = 222 and: [(orderedCollection at: 2) = 333] ]
		conformTo: #OrderedCollection
		selector: #addAll:beforeIndex:.
	self
		value: [orderedCollection addAll: #(444 555) beforeIndex: 4]
		should: [:result | (orderedCollection at: 4) = 444 and: [(orderedCollection at: 5) = 555] ]
		conformTo: #OrderedCollection
		selector: #addAll:beforeIndex:.!

testXaddAllXbeforeX
	" <OrderedCollection>#addAll:before: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addAll: #(111 222) before: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection addAll: #(222 333) before: 1]
		should: [:result | (orderedCollection first) = 222 and: [(orderedCollection at: 2) = 333] ]
		conformTo: #OrderedCollection
		selector: #addAll:before:.
	self
		value: [orderedCollection addAll: #(444 555) before: 4]
		should: [:result | (orderedCollection at: orderedCollection size - 2) = 444 and: [(orderedCollection at: orderedCollection size - 1) = 555] ]
		conformTo: #OrderedCollection
		selector: #addAll:before:.
	self
		value: [orderedCollection addAll: #(666 777) before: 555]
		should: [:result | (orderedCollection at: orderedCollection size - 3) = 666 and: [(orderedCollection at: orderedCollection size - 2) = 777] ]
		conformTo: #OrderedCollection
		selector: #addAll:before:!

testXaddFirstX
	" <OrderedCollection>#addFirst: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addFirst: 111]
		should:[:result | result = 111and: [(orderedCollection at: 1) = 111]]
		conformTo: #OrderedCollection
		selector: #addFirst:!

testXaddLastX
	" <OrderedCollection>#addLast: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection addLast: 111]
		should:[:result | result = 111and: [(orderedCollection last) = 111]]
		conformTo: #OrderedCollection
		selector: #addLast:!

testXaddX
	" <OrderedCollection>#add: "
	| orderedCollection sampleValue |
	#'Collection'.
	
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection add: 777]	
		should: [:result | 
			orderedCollection do: [ :each | sampleValue := each].
			sampleValue = 777]
		conformTo: #OrderedCollection
		selector: #add:!

testXaddXafterIndexX
	" <OrderedCollection>#add:afterIndex: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection add: 555 afterIndex: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 666 afterIndex: -1]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 777 afterIndex: 0]
		should: [:result | (result = 777) and: [(orderedCollection first) = 777]]
		conformTo: #OrderedCollection
		selector: #add:afterIndex:.
	self
		value: [orderedCollection add: 888 afterIndex: 5]
		should: [:result | (result = 888) and: [(orderedCollection last) = 888]]
		conformTo: #OrderedCollection
		selector: #add:afterIndex:.
	self
		value: [orderedCollection add: 999 afterIndex: 1]
		should: [:result | (result = 999) and: [(orderedCollection at: 2) = 999]]
		conformTo: #OrderedCollection
		selector: #add:afterIndex:!

testXaddXafterX
	" <OrderedCollection>#add:after: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection add: 777 after: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 777 after: 1]
		should: [:result | (result = 777) and: [(orderedCollection at: 2) = 777]]
		conformTo: #OrderedCollection
		selector: #add:after:.
	self
		value: [orderedCollection add: 888 after: 4]
		should: [:result | (result = 888) and: [(orderedCollection last) = 888]]
		conformTo: #OrderedCollection
		selector: #add:after:.
	self
		value: [orderedCollection add: 999 after: 777]
		should: [:result | (result = 999) and: [(orderedCollection at: 3) = 999]]
		conformTo: #OrderedCollection
		selector: #add:after:!

testXaddXbeforeIndexX
	" <OrderedCollection>#add:beforeIndex: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection add: 555 beforeIndex: 6]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 666 beforeIndex: 0]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 666 beforeIndex: -1]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 777 beforeIndex: 1]
		should: [:result | (result = 777) and: [(orderedCollection first) = 777]]
		conformTo: #OrderedCollection
		selector: #add:beforeIndex:.
	self
		value: [orderedCollection add: 888 beforeIndex: 6]
		should: [:result | (result = 888) and: [(orderedCollection last) = 888]]
		conformTo: #OrderedCollection
		selector: #add:beforeIndex:.
	self
		value: [orderedCollection add: 999 beforeIndex: 2]
		should: [:result | (result = 999) and: [(orderedCollection at: 2) = 999]]
		conformTo: #OrderedCollection
		selector: #add:beforeIndex:!

testXaddXbeforeX
	" <OrderedCollection>#add:before: "
	| orderedCollection |
	#'Collection'.
	orderedCollection := self canonicalObject.
	self
		value: [orderedCollection add: 777 before: 5]	
		shouldRaise: TestResult error.
	self
		value: [orderedCollection add: 777 before: 1]
		should: [:result | (result = 777) and: [(orderedCollection first) = 777]]
		conformTo: #OrderedCollection
		selector: #add:before:.
	self
		value: [orderedCollection add: 888 before: 4]
		should: [:result | (result = 888) and: [(orderedCollection at: 5) = 888]]
		conformTo: #OrderedCollection
		selector: #add:before:.
	self
		value: [orderedCollection add: 999 before: 888]
		should: [:result | (result = 999) and: [(orderedCollection at: 5) = 999]]
		conformTo: #OrderedCollection
		selector: #add:before:! !
!OrderedCollectionANSITest categoriesForMethods!
canonicalElement!public! !
canonicalObject!public! !
emptyCollection!public! !
protocol!public! !
testXaddAllFirstX!public! !
testXaddAllLastX!public! !
testXaddAllXafterIndexX!public! !
testXaddAllXafterX!public! !
testXaddAllXbeforeIndexX!public! !
testXaddAllXbeforeX!public! !
testXaddFirstX!public! !
testXaddLastX!public! !
testXaddX!public! !
testXaddXafterIndexX!public! !
testXaddXafterX!public! !
testXaddXbeforeIndexX!public! !
testXaddXbeforeX!public! !
!

!OrderedCollectionANSITest class methodsFor!

helperClassesDo: aBlock
	super helperClassesDo: aBlock.
	aBlock value: ExtensibleCollectionHelper.
	aBlock value: SequencedContractibleCollectionHelper.
	aBlock value: SequencedReadableCollectionHelper.
	aBlock value: SequencedCollectionHelper.! !
!OrderedCollectionANSITest class categoriesForMethods!
helperClassesDo:!public! !
!

