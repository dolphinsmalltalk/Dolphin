"Filed out from Dolphin Smalltalk"!

TestCaseHelper subclass: #ExtensibleCollectionHelper
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ExtensibleCollectionHelper guid: (GUID fromString: '{4277b0f5-244b-4767-abde-76dd79922d8e}')!

ExtensibleCollectionHelper comment: ''!

!ExtensibleCollectionHelper categoriesForClass!Unclassified! !

!ExtensibleCollectionHelper methodsFor!

object
	^testCase canonicalObject!

object: anObject!

testXaddAllX
	" <extensibleCollection>#addAll: "
	| extensibleCollection addCollection compareCollection |
	#'Collection'.
	extensibleCollection := self object.
	self
		value: [extensibleCollection addAll: #(666 777)]	
		should: [:result | (extensibleCollection includes: 777) and: [extensibleCollection includes: 666]]
		conformTo: #extensibleCollection
		selector: #addAll:.
	addCollection := OrderedCollection with: 555 with: 444.
	extensibleCollection := self object.
	compareCollection := self object.
	self should: [(addCollection do: [:each | extensibleCollection add: each]) = (compareCollection addAll: addCollection)]!

testXaddX
	" <extensibleCollection>#add: "
	| extensibleCollection |
	#'Collection'.
	extensibleCollection := self object.
	self
		value: [ extensibleCollection add: 777 ]	
		should: [:result | extensibleCollection includes: 777]
		conformTo: #extensibleCollection
		selector: #add:!

testXremoveAllX
	" <extensibleCollection>#removeAll: "
	| extensibleCollection removeAll |
	#'Collection'.

	extensibleCollection := self object.
	removeAll := self object.
	self
		value: [ 	extensibleCollection removeAll: removeAll]	
		should: [:result | extensibleCollection isEmpty ]
		conformTo: #extensibleCollection
		selector: #removeAll:!

testXremoveX
	" <extensibleCollection>#remove: "
	| extensibleCollection sampleValue |
	#'Collection'.

	extensibleCollection := self object.
	extensibleCollection do: [ :each | sampleValue := each].
	self
		value: [ extensibleCollection remove: sampleValue ]	
		should: [:result | (extensibleCollection includes: sampleValue) not ]
		conformTo: #extensibleCollection
		selector: #remove:!

testXremoveXifAbsentX
	" <extensibleCollection>#remove:ifAbsent: "
	| extensibleCollection sampleValue |
	#'Collection'.
	
	extensibleCollection := self object.
	extensibleCollection do: [ :each | sampleValue := each].
	self
		value: [ extensibleCollection remove: sampleValue ifAbsent: [#foo]]	
		should: [:result | result = sampleValue ]
		conformTo: #extensibleCollection
		selector: #remove:ifAbsent:.
	self
		value: [ extensibleCollection remove: sampleValue ifAbsent: [#foo]]	
		should: [:result | result = #foo ]
		conformTo: #extensibleCollection
		selector: #remove:ifAbsent:! !

!ExtensibleCollectionHelper categoriesForMethods!
object!public! !
object:!public! !
testXaddAllX!public! !
testXaddX!public! !
testXremoveAllX!public! !
testXremoveX!public! !
testXremoveXifAbsentX!public! !
!

