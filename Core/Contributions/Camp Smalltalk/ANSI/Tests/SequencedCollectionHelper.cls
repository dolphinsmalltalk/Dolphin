"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #SequencedCollectionHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SequencedCollectionHelper guid: (GUID fromString: '{f1389837-c349-4a42-82d3-c77cc0a1add2}')!

SequencedCollectionHelper comment: ''!

!SequencedCollectionHelper categoriesForClass!Unclassified! !

!SequencedCollectionHelper methodsFor!

object
	^testCase canonicalObject copy!

object: anObject!

testXatAllPutX
	" <sequencedCollection>#atAllPut: "
	| sequencedCollection putValue |
	#'Collection'.
	sequencedCollection := self object.
	putValue := (self object isKindOf: ByteArray)
		ifTrue: [9]
		ifFalse: [$a].
	self
		value: [sequencedCollection atAllPut: putValue]
		should: 
			[:result | 
			(sequencedCollection
				detect: [:each | each ~= putValue ]
				ifNone: [nil]) isNil]
		conformTo: #sequencedCollection
		selector: #atAllPut:.
	testCase conformanceOfPutElementOnXatAllPutX: 'ABC'.!

testXatAllXputX
	" <sequencedCollection>#atAll:put: "
	| putValue indices sequencedCollection |
	#'Collection'.
	sequencedCollection := self object.
	indices := #(1 2 3).
	putValue := (self object isKindOf: ByteArray)
		ifTrue: [9]
		ifFalse: [$a].
	self
		value: 
			[sequencedCollection 
				atAll: indices 
				put: putValue]
		should: [:result | 
			(indices 
				detect: [:each | (sequencedCollection at: each) ~= putValue]
				ifNone: [nil]) isNil]
		conformTo: #sequencedCollection
		selector: #atAll:put:.
	testCase conformanceOfPutElementOnXatAllXputX: 'ABC'.
	self
		should: 
			[sequencedCollection 
				atAll: #($a #bee 'See') 
				put: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				atAll:#(0 1) 
				put: putValue]
		raise: TestResult error.
	self 
		should: 
			[sequencedCollection 
				atAll: (Array 
					with: 1 
					with: sequencedCollection size + 1)
				put: putValue]
		raise: TestResult error!

testXatXputX
	" <sequencedCollection>#at:put: "
	| sequencedCollection putValue |
	#'Collection'.
	sequencedCollection := self object.
	putValue := (self object isKindOf: ByteArray)
		ifTrue: [9]
		ifFalse: [$a].
	self 
		value: 
			[sequencedCollection 
				at: 1 
				put: putValue]
		should: [:result | (result = putValue) & ((sequencedCollection at: 1) = putValue)]
		conformTo: #sequencedCollection
		selector: #at:put:.
	testCase conformanceOfPutElementOnXatXputX: 'ABC'.
	self 
		should: 
			[sequencedCollection 
				at: -1 
				put: putValue]
		raise: TestResult error.
	self 
		should: 
			[sequencedCollection 
				at: sequencedCollection size + 1
				put: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				at: 0
				put: putValue]
		raise: TestResult error.!

testXreplaceFromXtoXwithObjectX
	" <sequencedCollection>#replaceFrom:to:withObject: "

	| sequencedCollection putValue |
	#Collection.
	sequencedCollection := self object.
	putValue := (self object isKindOf: ByteArray) ifTrue: [9] ifFalse: [$a].
	self
		value: 
			[sequencedCollection
				replaceFrom: 2
				to: 3
				withObject: putValue]
		should: [:result | (sequencedCollection at: 2) = putValue & ((sequencedCollection at: 3) = putValue)]
		conformTo: #sequencedCollection
		selector: #replaceFrom:to:withObject:.
	self should: 
			[sequencedCollection
				replaceFrom: 0
				to: 1
				withObject: putValue]
		raise: TestResult error.
	"Traditionally it is not an error for start or stop to be outside bounds if the interval is empty. Since an objective of the standards committee was not to make traditional implementations automatically non-compliant, this is assumed to be an error of omission from the standard, so this test is modified to specify a non-empty interval."
	self isStrict
		ifTrue: 
			[self should: 
					[sequencedCollection
						replaceFrom: sequencedCollection size + 1
						to: 1
						withObject: putValue]
				raise: TestResult error.
			self should: 
					[sequencedCollection
						replaceFrom: 0
						to: 1
						withObject: putValue]
				raise: TestResult error]
		ifFalse: 
			[self should: 
					[sequencedCollection
						replaceFrom: sequencedCollection size + 1
						to: sequencedCollection size + 1
						withObject: putValue]
				raise: TestResult error.
			self should: 
					[sequencedCollection
						replaceFrom: 0
						to: 0
						withObject: putValue]
				raise: TestResult error].
	self should: 
			[sequencedCollection
				replaceFrom: 1
				to: sequencedCollection size + 1
				withObject: putValue]
		raise: TestResult error!

testXreplaceFromXtoXwithX
	" <sequencedCollection>#replaceFrom:to:with: "
	| sequencedCollection putValue |
	#'Collection'.
	sequencedCollection := self object.
	putValue := (self object isKindOf: ByteArray)
		ifTrue: [#(9 8)]
		ifFalse: [#($b $a)].
	self
		value: [sequencedCollection replaceFrom: 2 to: 3 with: putValue]
		should: 
			[:result | 
			((sequencedCollection at: 2) = (putValue at: 1))
			& ((sequencedCollection at: 3) = (putValue at: 2))]
		conformTo: #sequencedCollection
		selector: #replaceFrom:to:with:.
	self
		should: 
			[sequencedCollection 
				replaceFrom: 0 
				to: 1 
				with: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				replaceFrom: sequencedCollection size + 1 
				to: 1 
				with: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				replaceFrom: 1 
				to: 0 
				with: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				replaceFrom: 1 
				to: sequencedCollection size + 1 
				with: putValue]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				replaceFrom:1
				to: 2
				with: #(1 2 3 5)]
		raise: TestResult error.
	self
		should: 
			[sequencedCollection 
				replaceFrom:1
				to: 3
				with: #(1)]
		raise: TestResult error!

testXreplaceFromXtoXwithXstartingAtX
	" <sequencedCollection>#replaceFrom:to:with:startingAt: "

	| sequencedCollection putValue |
	#Collection.
	sequencedCollection := self object.
	putValue := (self object isKindOf: ByteArray) ifTrue: [#(9 8 7)] ifFalse: [#($c $b $a)].
	self
		value: 
			[sequencedCollection
				replaceFrom: 1
				to: 2
				with: putValue
				startingAt: 2]
		should: 
			[:result |
			(sequencedCollection at: 1) = (putValue at: 2) & ((sequencedCollection at: 2) = (putValue at: 3))]
		conformTo: #sequencedCollection
		selector: #replaceFrom:to:with:startingAt:.
	self should: 
			[sequencedCollection
				replaceFrom: 0
				to: 1
				with: putValue
				startingAt: 2]
		raise: TestResult error.
	"As for replaceFrom:to:withObject:, traditionally implementations do not raise an error for out of bounds start/stop if the interval is empty. This can be useful in practice too."
	self isStrict
		ifTrue: 
			[self should: 
					[sequencedCollection
						replaceFrom: sequencedCollection size + 1
						to: 1
						with: putValue
						startingAt: 2]
				raise: TestResult error.
			self should: 
					[sequencedCollection
						replaceFrom: 0
						to: 1
						with: putValue
						startingAt: 2]
				raise: TestResult error]
		ifFalse: 
			[self should: 
					[sequencedCollection
						replaceFrom: sequencedCollection size + 1
						to: sequencedCollection size + 1
						with: putValue
						startingAt: 2]
				raise: TestResult error.
			self should: 
					[sequencedCollection
						replaceFrom: 0
						to: 0
						with: putValue
						startingAt: 2]
				raise: TestResult error].
	self should: 
			[sequencedCollection
				replaceFrom: 1
				to: sequencedCollection size + 1
				with: putValue
				startingAt: 2]
		raise: TestResult error.
	self should: 
			[sequencedCollection
				replaceFrom: 1
				to: 2
				with: #(1 2 3 5)
				startingAt: 4]
		raise: TestResult error.
	self should: 
			[sequencedCollection
				replaceFrom: 1
				to: 3
				with: #(1 2)
				startingAt: 0]
		raise: TestResult error.
	self should: 
			[sequencedCollection
				replaceFrom: 1
				to: 3
				with: #(1 2)
				startingAt: 3]
		raise: TestResult error! !

!SequencedCollectionHelper categoriesForMethods!
object!public! !
object:!public! !
testXatAllPutX!public! !
testXatAllXputX!public! !
testXatXputX!public! !
testXreplaceFromXtoXwithObjectX!public! !
testXreplaceFromXtoXwithX!public! !
testXreplaceFromXtoXwithXstartingAtX!public! !
!

