"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #SequencedContractibleCollectionHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SequencedContractibleCollectionHelper guid: (GUID fromString: '{02547c3f-e6c4-4b52-ae26-394eee3a484b}')!
SequencedContractibleCollectionHelper comment: ''!
!SequencedContractibleCollectionHelper categoriesForClass!Unclassified! !
!SequencedContractibleCollectionHelper methodsFor!

object
	^testCase canonicalObject!

object: anObject!

testXremoveAtIndexX
	" <sequencedCollection>#removeAtIndex: "
	| sequencedCollection getValue getValue2 |
	#'Collection'.
	sequencedCollection := self object.
	getValue := sequencedCollection at: 1.
	getValue2 := sequencedCollection at: 2.
	self 
		value: [sequencedCollection removeAtIndex: 1]
		should: [ :result | result = getValue and: [ (sequencedCollection at: 1) = getValue2] ]
		conformTo: #sequencedContractibleCollection
		selector: #removeAtIndex:.
	self
		should: [sequencedCollection removeAtIndex: 0]
		raise: TestResult error.
	self
		should: [sequencedCollection removeAtIndex: sequencedCollection size + 1]
		raise: TestResult error.!

testXremoveFirst
	" <sequencedCollection>#removeFirst "
	| sequencedCollection getValue getValue2 originalLength |
	#'Collection'.
	sequencedCollection := self object.
	getValue := sequencedCollection at: 1.
	getValue2 := sequencedCollection at: 2.
	originalLength := sequencedCollection size.
	self 
		value: [sequencedCollection removeFirst]
		should: [ :result | result = getValue and: [ ((sequencedCollection at: 1) = getValue2) and: [ sequencedCollection size = (originalLength - 1) ] ] ]
		conformTo: #sequencedContractibleCollection
		selector: #removeFirst.!

testXremoveLast
	" <sequencedCollection>#removeLast "
	| sequencedCollection getValue getValue2 originalLength |
	#'Collection'.
	sequencedCollection := self object.
	originalLength := sequencedCollection size.
	getValue := sequencedCollection at: originalLength.
	getValue2 := sequencedCollection at: originalLength - 1.
	self 
		value: [sequencedCollection removeLast]
		should: [ :result | result = getValue and: [ ((sequencedCollection at: (originalLength - 1)) = getValue2) and: [ sequencedCollection size = (originalLength - 1) ] ] ]
		conformTo: #sequencedContractibleCollection
		selector: #removeLast.! !
!SequencedContractibleCollectionHelper categoriesForMethods!
object!public! !
object:!public! !
testXremoveAtIndexX!public! !
testXremoveFirst!public! !
testXremoveLast!public! !
!

