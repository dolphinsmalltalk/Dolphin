"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #CollectionHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

CollectionHelper guid: (GUID fromString: '{4c586cba-e91f-4bc1-8324-8301fdb92c4c}')!

CollectionHelper comment: ''!

!CollectionHelper categoriesForClass!Unclassified! !

!CollectionHelper methodsFor!

canonicalElement
	^testCase canonicalElement!

emptyCollection
	^testCase emptyCollection!

limitedElementTypes

	^testCase limitedElementTypes!

object
	^testCase canonicalObject!

object: anObject!

returnTypeHasLimitedElementTypes

	^testCase returnTypeHasLimitedElementTypes!

testXallSatisfyX
	" <collection>#allSatisfy: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				allSatisfy:
					[:each |
					true]]
		should:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'allSatisfy:'.

	self
		value:
			[self canonicalObject
				allSatisfy:
					[:each |
					false]]
		shouldnt:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'allSatisfy:'.

	self
		value:
			[(self canonicalObject
				reject:
					[:each |
					each = self canonicalElement])
				allSatisfy:
					[:each |
					each ~= self canonicalElement]]
		should:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'allSatisfy:'.

	self
		value:
			[self emptyCollection
				allSatisfy:
					[:each |
					true]]
		should:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'allSatisfy:'.

	"self
		value:
			[self canonicalObject
				allSatisfy:
					[:each |
					nil]]
		shouldRaise: TestResult error"!

testXanySatisfyX
	" <collection>#anySatisfy: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				anySatisfy:
					[:each |
					each = self canonicalElement]]
		should:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'anySatisfy:'.

	self
		value:
			[self canonicalObject
				anySatisfy:
					[:each |
					false]]
		shouldnt:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'anySatisfy:'.

	self
		value:
			[(self canonicalObject
				reject:
					[:each |
					each = self canonicalElement])
				anySatisfy:
					[:each |
					each = self canonicalElement]]
		shouldnt:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'anySatisfy:'!

testXasArray
	" <collection>#asArray "
	#'Collection'.
	self assertSend: #asArray!

testXasBag
	" <collection>#asBag "
	#'Collection'.
	self assertSend: #asBag!

testXasByteArray
	" <collection>#asByteArray "
	#'Collection'.
	self assertSend: #asByteArray!

testXasOrderedCollection
	" <collection>#asOrderedCollection "
	#'Collection'.
	self assertSend: #asOrderedCollection!

testXasSet
	" <collection>#asSet "
	#'Collection'.
	self assertSend: #asSet!

testXasSortedCollection
	" <collection>#asSortedCollection "
	#'Collection'.
	self assertSend: #asSortedCollection!

testXasSortedCollectionX
	" <collection>#asSortedCollection: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				asSortedCollection:
					[:a :b |
					b < a]]
		should:
			[:result |
			result size = self canonicalObject size]
		conformTo: #'collection'
		selector: #'asSortedCollection:'.

	self
		value:
			[self emptyCollection
				asSortedCollection:
					[:a :b |
					b < a]]
		should:
			[:result |
			result size = self emptyCollection size]
		conformTo: #'collection'
		selector: #'asSortedCollection:'.

	"Test a garbage message for any parameter passed into the block."
	self
		value:
			[self canonicalObject
				asSortedCollection:
					[:a :b |
					a gobbledegook]]
		shouldRaise: TestResult error!

testXcollectX
	" <collection>#collect: (Return Values: <RECEIVER>)"
	#'Collection'.

	self
		value:
			[self canonicalObject
				collect:
					[:each |
					each ]]
		should:
			[:result |
			result size = self canonicalObject size]
		conformTo: #'collection'
		selector: #'collect:'.

	"Test empty class."
	self
		value:
			[self emptyCollection
				collect:
					[:each |
					true]]
		should:
			[:result |	
			result isEmpty]
		conformTo: #'collection'
		selector: #'collect:'.

	self returnTypeHasLimitedElementTypes
		ifTrue:
			[self
				value:
					[self canonicalObject
						collect:
							[:each |
							self limitedElementTypes]]
				shouldRaise: TestResult error].

	self
		value:
			[self canonicalObject
				collect:
					[:each |
					each gobbledegook]]
		shouldRaise: TestResult error.!

testXdetectX
	" <collection>#detect: "

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					each = self canonicalElement]]
		should:
			[:result |
			result = self canonicalElement]
		conformTo: #'collection'
		selector: #'detect:'.

	"Test empty class.  What is the appropriate behavior for sending detect: to an empty collection?  Both VA and VW raise element
	not found errors."
	self
		value:
			[self emptyCollection
				detect:
					[:each |
					true]]
		shouldRaise: TestResult error.

	"self
		value:
			[self canonicalObject
				detect:
					[:each |
					nil]]
		shouldRaise: TestResult error."

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					false]]
		shouldRaise: TestResult error.

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					each gobbledegook]]
		shouldRaise: TestResult error!

testXdetectXifNoneX
	" <collection>#detect:ifNone: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					each = self canonicalElement]
				ifNone:
					[nil]]
		should:
			[:result |
			result = self canonicalElement]
		conformTo: #'collection'
		selector: #'detect:ifNone:'.

	"Test empty class.  What is the appropriate behavior for sending detect: to an empty collection?  Both VA and VW raise element
	not found errors."
	self
		value:
			[self emptyCollection
				detect:
					[:each |
					true]
				ifNone:
					[#NotFound]]
		should:
			[:result |
			result == #NotFound]
		conformTo: #collection
		selector: #'detect:ifNone:'.

	"self
		value:
			[self canonicalObject
				detect:
					[:each |
					nil]
				ifNone:
					[nil]]
		shouldRaise: TestResult error."

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					false]
				ifNone:
					[#NotFound]]
		should:
			[:result |
			result == #NotFound]
		conformTo: #'collection'
		selector: #'detect:ifNone:'.

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					each gobbledegook]
				ifNone:
					[]]
		shouldRaise: TestResult error.

	self
		value:
			[self canonicalObject
				detect:
					[:each |
					false]
				ifNone:
					[self gobbledegook]]
		shouldRaise: TestResult error.!

testXdoX
	" <sequencedReadableCollection>#do: "
	#'Collection'.


	self
		value:
			[self canonicalObject
				do:
					[:each |]]
		should:
			[:result |
			"The ANSI Standard states that the return is UNSPECIFIED.  So, any return is valid."
			true]
		conformTo: #'collection'
		selector: #'do:'.

	self
		value:
			[self emptyCollection
				do:
					[:each |]]
		should:
			[:result |
			"The ANSI Standard states that the return is UNSPECIFIED.  So, any return is valid."
			true]
		conformTo: #'collection'
		selector: #'do:'.

	"Send message that causes an error in the do: loop."
	self
		value:
			[self canonicalObject
				do:
					[:each |
					each gobbledegook]]
		shouldRaise: TestResult error.!

testXdoXseparatedByX
	" <collection>#do:separatedBy: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				do:
					[:each |]
				separatedBy:
					[]]
		should:
			[:result |
			"The ANSI Standard states that the return is UNSPECIFIED.  So, any return is valid."
			true]
		conformTo: #'collection'
		selector: #'do:separatedBy:'.

	"Send message that causes an error in the do: loop."
	self
		value:
			[self canonicalObject
				do:
					[:each |
					each gobbledegook]
				separatedBy:
					[]]
		shouldRaise: TestResult error.

	"Send message that causes an error in the separatedBy: loop."
	self
		value:
			[self canonicalObject
				do:
					[:each |]
				separatedBy:
					[self gobbledegook]]
		shouldRaise: TestResult error.

	self
		value:
			[self emptyCollection
				do:
					[:each |]
				separatedBy:
					[]]
		should:
			[:result |
			"The ANSI Standard states that the return is UNSPECIFIED.  So, any return is valid."
			true]
		conformTo: #'collection'
		selector: #'do:separatedBy:'.!

testXincludesX
	" <collection>#includes: "
	#'Collection'.

	self
		value:
			[self canonicalObject includes: self canonicalElement]
		should:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'includes:'.

	self
		value:
			[self canonicalObject includes: 'Zornfindel']
		shouldnt:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'includes:'.

	self
		value:
			[self emptyCollection includes: 'Zornfindel']
		shouldnt:
			[:result |
			result]
		conformTo: #'collection'
		selector: #'includes:'!

testXinjectXintoX
	" <collection>#inject:into: "
	#'Collection'.

	self
		value:
			[self canonicalObject
				inject: 1
				into:
					[:value :each |
					(each printString at: 1) asInteger * value]]
		should:
			[:result |
			result > 0]
		conformTo: #'collection'
		selector: #'inject:into:'.

	self
		value:
			[self emptyCollection
				inject: 1
				into:
					[:value :each |
					(each printString at: 1) asInteger * value]]
		should:
			[:result |
			result > 0]
		conformTo: #'collection'
		selector: #'inject:into:'!

testXisEmpty
	" <collection>#isEmpty "
	#'Collection'.
	self assertSend: #isEmpty!

testXnotEmpty
	" <collection>#notEmpty "
	#'Collection'.
	self assertSend: #notEmpty!

testXoccurrencesOfX
	" <collection>#occurrencesOf: "
	#'Collection'.

	self
		value:
			[self canonicalObject occurrencesOf: self canonicalElement]
		should:
			[:result |
			result = 1]
		conformTo: #'collection'
		selector: #'occurrencesOf:'.

	self
		value:
			[self canonicalObject occurrencesOf: 'Zornfindel']
		should:
			[:result |
			result = 0]
		conformTo: #'collection'
		selector: #'occurrencesOf:'.

	self
		value:
			[self emptyCollection occurrencesOf: 'Zornfindel']
		should:
			[:result |
			result = 0]
		conformTo: #'collection'
		selector: #'occurrencesOf:'!

testXrehash
	" <collection>#rehash "
	#'Collection'.
	self assertSend: #rehash!

testXrejectX
	" <collection>#reject: (Return Values: <RECEIVER>)"
	#'Collection'.

	self
		value:
			[self canonicalObject
				reject:
					[:each |
					each = self canonicalElement]]
		should:
			[:result |
			(result includes: self canonicalElement) not]
		conformTo: #'collection'
		selector: #'reject:'.

	"Test empty class."
	self
		value:
			[self emptyCollection
				reject:
					[:each |
					true]]
		should:
			[:result |	
			result isEmpty]
		conformTo: #'collection'
		selector: #'reject:'.

	"self
		value:
			[self canonicalObject
				reject:
					[:each |
					nil]]
	shouldRaise: TestResult error"

	self
		value:
			[self canonicalObject
				reject:
					[:each |
					each gobbledegook]]
		shouldRaise: TestResult error!

testXselectX
	" <collection>#select: (Return Values: <RECEIVER>)"
	#'Collection'.

	self
		value:
			[self canonicalObject
				select:
					[:each |
					each ~= self canonicalElement]]
		should:
			[:result |
			(result includes: self canonicalElement) not]
		conformTo: #'collection'
		selector: #'select:'.

	"Test empty class."
	self
		value:
			[self emptyCollection
				select:
					[:each |
					true]]
		should:
			[:result |	
			result isEmpty]
		conformTo: #'collection'
		selector: #'select:'.

	"self
		value:
			[self canonicalObject
				select:
					[:each |
					nil]]
	shouldRaise: TestResult error."

	self
		value:
			[self canonicalObject
				select:
					[:each |
					each gobbledegook]]
		shouldRaise: TestResult error!

testXsize
	" <collection>#size "
	#'Collection'.
	self assertSend: #size! !

!CollectionHelper categoriesForMethods!
canonicalElement!public! !
emptyCollection!public! !
limitedElementTypes!public! !
object!public! !
object:!public! !
returnTypeHasLimitedElementTypes!public! !
testXallSatisfyX!public! !
testXanySatisfyX!public! !
testXasArray!public! !
testXasBag!public! !
testXasByteArray!public! !
testXasOrderedCollection!public! !
testXasSet!public! !
testXasSortedCollection!public! !
testXasSortedCollectionX!public! !
testXcollectX!public! !
testXdetectX!public! !
testXdetectXifNoneX!public! !
testXdoX!public! !
testXdoXseparatedByX!public! !
testXincludesX!public! !
testXinjectXintoX!public! !
testXisEmpty!public! !
testXnotEmpty!public! !
testXoccurrencesOfX!public! !
testXrehash!public! !
testXrejectX!public! !
testXselectX!public! !
testXsize!public! !
!

!CollectionHelper class methodsFor!

initialize
	"CollectionHelper  initialize"
	super initialize! !

!CollectionHelper class categoriesForMethods!
initialize!public! !
!

