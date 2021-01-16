"Filed out from Dolphin Smalltalk 7"!

Core.Tests.SequenceableCollectionTest subclass: #'Core.Tests.IntervalTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.IntervalTest guid: (Core.GUID fromString: '{73485185-925f-48a9-bdf0-df459c5acb25}')!
Core.Tests.IntervalTest comment: ''!
!Core.Tests.IntervalTest categoriesForClass!Unclassified! !
!Core.Tests.IntervalTest methodsFor!

assimilate: anObject 
	^anObject asInteger!

assimilateResultElement: anObject
	^anObject!

collectionClass
	^Array!

newCollection: anArray
	| start interval |
	anArray isEmpty ifTrue: [^1 to: 0].
	start := anArray first asInteger.
	anArray size = 1 ifTrue: [^start to: start].
	interval := start to: anArray last asInteger by: (anArray second asInteger - start max: 1).
	^interval asArray = (anArray asArray collect: [:each | each asInteger])
		ifTrue: [interval]
		ifFalse: [super newCollection: anArray]!

testCollect
	| interval result |
	self assert: ((1 to: 10) collect: [:each | each]) class identicalTo: Array.
	self assert: ((1 to: 0) collect: [:each | each]) isEmpty.
	self assert: ((1 to: 1) collect: [:each | each]) equals: #(1).
	self assert: ((1 to: 2) collect: [:each | each]) equals: #(1 2).
	self assert: ((1 to: 3) collect: [:each | each]) equals: #(1 2 3).
	self assert: ((1 to: 0 by: 2) collect: [:each | each]) isEmpty.
	self assert: ((1 to: 1 by: 2) collect: [:each | each]) equals: #(1).
	self assert: ((1 to: 2 by: 2) collect: [:each | each]) equals: #(1).
	self assert: ((1 to: 3 by: 2) collect: [:each | each]) equals: #(1 3).
	self assert: ((1 to: 2 by: -1) collect: [:each | each]) isEmpty.
	self assert: ((1 to: 0 by: -1) collect: [:each | each]) equals: #(1 0).
	self assert: ((1 to: 1 by: -1) collect: [:each | each]) equals: #(1).
	self assert: ((2 to: 1 by: -1) collect: [:each | each]) equals: #(2 1).
	self assert: ((3 to: 1 by: -1) collect: [:each | each]) equals: #(3 2 1).
	self assert: ((1 to: 2 by: -2) collect: [:each | each]) isEmpty.
	self assert: ((1 to: 0 by: -2) collect: [:each | each]) equals: #(1).
	self assert: ((1 to: 1 by: -2) collect: [:each | each]) equals: #(1).
	self assert: ((2 to: 1 by: -2) collect: [:each | each]) equals: #(2).
	self assert: ((3 to: 1 by: -2) collect: [:each | each]) equals: #(3 1).
	interval := 120.0 to: 135.0 by: 0.3.
	result := interval collect: [:each | each].
	self assert: interval size equals: result size.
	self assert: interval first equals: result first.
	self assert: interval last equals: result last.
	self assert: (result allSatisfy: [:each | each isKindOf: Float]).
	self assert: interval asArray equals: result!

testEquals
	self shouldnt: 
			[self assert: (3 to: 5) equals: #(3 4 5).
			self deny: (3 to: 5) equals: #(3 5).
			self deny: (3 to: 5) equals: #().
			self assert: #(3 4 5) equals: (3 to: 5).
			self deny: #(3 5) equals: (3 to: 5).
			self deny: #() equals: (3 to: 5)]
		raise: MessageNotUnderstood!

testEquals2
	self assert: (3 to: 5) equals: #(3 4 5).
	self deny: (3 to: 5) equals: #(3 5).
	self deny: (3 to: 5) equals: #().
	self assert: #(3 4 5) equals: (3 to: 5).
	self deny: #(3 5) equals: (3 to: 5).
	self deny: #() equals: (3 to: 5)!

testEquals3
	self assert: (3 to: 5 by: 2) first equals: (3 to: 6 by: 2) first.
	self assert: (3 to: 5 by: 2) last equals: (3 to: 6 by: 2) last.
	"Not sure about this one - if behaving a collection then the assertion is correct."
	self assert: (3 to: 5 by: 2) equals: (3 to: 6 by: 2)!

testEquals4
	self assert: (3 to: 5 by: 2) equals: #(3 5).
	self deny: (3 to: 5 by: 2) equals: #(3 4 5).
	self deny: (3 to: 5 by: 2) equals: #().
	self assert: #(3 5) equals: (3 to: 5 by: 2).
	self deny: #(3 4 5) equals: (3 to: 5 by: 2).
	self deny: #() equals: (3 to: 5 by: 2)!

testEquals5
	self assert: (3 to: 5 by: 2) equals: #(3 5).
	self deny: (3 to: 5 by: 2) equals: #(3 4 5).
	self deny: (3 to: 5 by: 2) equals: #().
	self assert: #(3 5) equals: (3 to: 5 by: 2).
	self deny: #(3 4 5) equals: (3 to: 5 by: 2).
	self deny: #() equals: (3 to: 5 by: 2)!

testEquals6
	self assert: (1 to: 0) equals: #().
	self assert: (1 to: -1) equals: #().
	self assert: (1 to: 0) equals: (1 to: -1).
	self deny: (1 to: 0 by: -1) equals: (1 to: 0).
	self deny: (1 to: 0 by: 3) equals: (1 to: 0 by: 2).
	self assert: (0 to: 1 by: -1) equals: (0 to: 2 by: -1)!

testFromToBy
	| interval interval2 originalMethod testMethod |
	interval := Interval
				from: 5
				to: 25
				by: 5.
	self assert: interval asArray equals: #(5 10 15 20 25).
	originalMethod := Interval class compiledMethodAt: #from:to:by:.
	testMethod := originalMethod copy.
	"Sanity check"
	self deny: testMethod == originalMethod.
	testMethod extraIndex: 0.
	"Invoke the method directly so we don't need to install it."
	interval2 := testMethod value: Interval withArguments: #(5 25 5).
	self assert: interval2 equals: interval!

testIncludes
	| interval float |
	self assert: ((1 to: 1) includes: 1).
	self deny: ((1 to: 2) includes: 0).
	interval := 1 to: 2 by: -1.
	0 to: 3 do: [:each | self deny: (interval includes: each)].
	interval := 1 to: 1 by: -1.
	self assert: (interval includes: 1).
	self deny: (interval includes: 0).
	self deny: (interval includes: 2).
	self assert: ((1 to: 2) includes: 1).
	self assert: ((2 to: 1 by: -1) includes: 1).
	self assert: ((1 to: 2) includes: 2).
	self assert: ((2 to: 1 by: -1) includes: 2).
	self deny: ((1 to: 2) includes: 3).
	self deny: ((2 to: 1 by: -1) includes: 3).
	#(1 3 5 7 9) do: 
			[:each |
			self assert: ((1 to: 10 by: 2) asArray includes: each).
			self deny: ((10 to: 1 by: -2) asArray includes: each).
			self assert: ((11 to: 0 by: -2) asArray includes: each)].
	self deny: ((11 to: 0 by: -2) includes: 0).
	self deny: ((1 to: 10 by: 2) includes: 10).
	interval := 10 to: 1 by: -2.
	self assert: (interval includes: 10).
	self deny: (interval includes: 1).
	float := 1.999999999999999999999999.
	self assert: (interval includes: float) equals: (interval asArray includes: float).
	#(0 2 4 6 8 10) do: [:each | self deny: ((1 to: 10 by: 2) asArray includes: each)].

	"Because of precision error, this will be false - Intervals frankly don't work well for Floats"
	interval := 1.2 to: 2.3 by: 0.15.
	self assert: (interval includes: 2.1) equals: (interval asArray includes: 2.1).
	interval := 1.0e-002 to: 1.0 by: 1.0e-002.
	self assert: (interval includes: 0.1) equals: (interval asArray includes: 0.1).
	"Empty interval"
	self deny: ((1 to: 0) includes: 1).
	"Floats in integer intervals"
	self deny: ((1 to: 2) includes: 1.5).
	"Non-numbers"
	self deny: ((1 to: 2) includes: 'a').
	self assert: ((-10 to: 10 by: 0.25) includes: 0.24)
		equals: ((-10 to: 10 by: 0.25) asArray includes: 0.24).
	self assert: ((-10 to: 10 by: 0.25) includes: 0.25)
		equals: ((-10 to: 10 by: 0.25) asArray includes: 0.25).
	self assert: ((-10 to: 10 by: 0.25) includes: 0.26)
		equals: ((-10 to: 10 by: 0.25) asArray includes: 0.26).
	self assert: ((-10 to: 10 by: 0.25) includes: 0 @ 0)
		equals: ((-10 to: 10 by: 0.25) asArray includes: 0 @ 0).
	self assert: ((0 to: 100 by: 0.333333) includes: 75.33329999999999)
		equals: ((0 to: 100 by: 0.333333) asArray includes: 75.33329999999999).
	self assert: ((1 to: 0) includes: 1) equals: ((1 to: 0) asArray includes: 1).
	self assert: ((1 to: 2) includes: 1.5) equals: ((1 to: 2) asArray includes: 1.5).
	interval := 0 to: 100 by: (1 / 3) asFloat.
	self assert: (interval reject: [:n | interval includes: n]) isEmpty.
	interval := 0 to: -100 by: (1 / 3) asFloat negated.
	self assert: (interval reject: [:n | interval includes: n]) isEmpty!

testIsEmpty
	self assert: (1 to: 0) isEmpty.
	self deny: (1 to: 1) isEmpty.
	self deny: (1 to: 2) isEmpty.
	self assert: (-11 to: -55 by: 11) isEmpty.
!

testPrintString
	self assert: (1 to: 0) printString equals: '(1 to: 0)'.
	self assert: (1 to: 10 by: 1) printString equals: '(1 to: 10)'.
	self assert: (1 to: 10 by: 2) printString equals: '(1 to: 10 by: 2)'.
	self assert: (1 to: 1.5 by: 0.5) printString equals: '(1 to: 1.5 by: 0.5)'!

testReplaceFromToWithStartingAt
	self should: [super testReplaceFromToWithStartingAt] raise: Error!

testResize
	self should: [super testResize] raise: Error matching: [:ex | ex description contains: 'not indexable']!

testStoreOn
	"#1379"

	#(##(1 to: 0) ##(1 to: 0 by: -1) ##(1 to: 10 by: 1) ##(1 to: 10 by: 2) ##(1 to: 1.5 by: 0.5)) do: 
			[:each |
			| expr copy |
			expr := each storeString.
			copy := Compiler evaluate: expr.
			self assert: copy equals: each]! !
!Core.Tests.IntervalTest categoriesFor: #assimilate:!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #assimilateResultElement:!helpers!private! !
!Core.Tests.IntervalTest categoriesFor: #collectionClass!helpers!private! !
!Core.Tests.IntervalTest categoriesFor: #newCollection:!private!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testCollect!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testEquals!public!testing! !
!Core.Tests.IntervalTest categoriesFor: #testEquals2!public!testing! !
!Core.Tests.IntervalTest categoriesFor: #testEquals3!public!testing! !
!Core.Tests.IntervalTest categoriesFor: #testEquals4!public!testing! !
!Core.Tests.IntervalTest categoriesFor: #testEquals5!public!testing! !
!Core.Tests.IntervalTest categoriesFor: #testEquals6!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testFromToBy!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testIncludes!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testIsEmpty!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testPrintString!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testReplaceFromToWithStartingAt!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testResize!public!unit tests! !
!Core.Tests.IntervalTest categoriesFor: #testStoreOn!public!unit tests! !

