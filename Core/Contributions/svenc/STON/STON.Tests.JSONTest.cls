﻿"Filed out from Dolphin Smalltalk"!

STON.Tests.STONTestCase
	subclass: #'STON.Tests.JSONTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

STON.Tests.JSONTest guid: (Core.GUID fromString: '{437baf49-fca6-405c-9fb7-18b0c8f89f50}')!

STON.Tests.JSONTest comment: 'STONJSONTests contains unit tests for the JSON functionality available in STON.'!

!STON.Tests.JSONTest categoriesForClass!STON-Tests-Facade! !

!STON.Tests.JSONTest methodsFor!

hasOrderedDictionary

	^self orderedDictionaryClass notNil!

orderedDictionaryClass

	^#{Core.OrderedDictionary} valueOrNil!

testBooleans
	self assert: (JSON toString: true) equals: 'true'.
	self assert: (JSON toString: false) equals: 'false'.
	self assert: (JSON fromString: 'true') equals: true.
	self assert: (JSON fromString: 'false') equals: false!

testCircular
	"Circular datastructures cannot be encoded using JSON"

	self should: 
			[| foo |
			foo := {'foo' -> 'dummy'} asDictionary.
			foo at: 'bar' put: foo.
			JSON toString: foo]
		raise: WriterError!

testFloats
	self assert: (JSON toString: 1.0) equals: '1.0'.
	self assert: (JSON toString: 0.0) equals: '0.0'.
	self assert: (JSON toString: -1.0) equals: '-1.0'.
	self assert: (JSON toString: -1.23456e-6) equals: '-1.23456e-6'.
	self assert: ((JSON fromString: '1.0') closeTo: 1.0).
	self assert: ((JSON fromString: '0.0') closeTo: 0.0).
	self assert: ((JSON fromString: '-1.0') closeTo: -1.0).
	self assert: ((JSON fromString: '-1.23456e-6') closeTo: -1.23456e-6)!

testIntegers
	self assert: (JSON toString: 1) equals: '1'.
	self assert: (JSON toString: 0) equals: '0'.
	self assert: (JSON toString: -1) equals: '-1'.
	self assert: (JSON toString: 1234567890) equals: '1234567890'.
	self assert: (JSON fromString: '1') equals: 1.
	self assert: (JSON fromString: '0') equals: 0.
	self assert: (JSON fromString: '-1') equals: -1.
	self assert: (JSON fromString: '1234567890') equals: 1234567890!

testLists
	self assert: (JSON toString: #(1 2 3)) equals: '[1,2,3]'.
	self assert: (JSON toString: #(1 -2 true 3 nil)) equals: '[1,-2,true,3,null]'.
	self assert: (JSON toString: #(1 #(2) 3)) equals: '[1,[2],3]'.
	self assert: (JSON toString: #()) equals: '[]'.
	self assert: (JSON fromString: '[]') equals: #().
	self assert: (JSON fromString: '[1,2,3]') equals: #(1 2 3).
	self assert: (JSON fromString: '[1,-2,true,3,null]') equals: #(1 -2 true 3 nil).
	self assert: (JSON fromString: '[1,[2],3]') equals: #(1 #(2) 3)!

testMaps
	self assert: (JSON toString: {'temperature' -> 37} asDictionary) equals: '{"temperature":37}'.
	self assert: (JSON toString: Dictionary new) equals: '{}'.
	self assert: (JSON fromString: '{"temperature":37}') equals: {'temperature' -> 37} asDictionary.
	self assert: (JSON fromString: '{}') equals: Dictionary new!

testNull
	self assert: (JSON toString: nil) equals: 'null'.
	self assert: (JSON fromString: 'null') equals: nil!

testOrderedDictionary
	<skipUnless: #hasOrderedDictionary>
	| odictClass odict json dict |
	odictClass := self orderedDictionaryClass.
	odict := odictClass withAll: { 'a' -> 42. 'b' -> 1. 'aa' -> 4. 'c' -> 23 }.

	"assert that the order is not equal in the dictionary hash table"
	self deny: odict asArray equals: (Dictionary withAll: odict associations) asArray.

	"ordered presevered when encoding:"
	json := JSON toString: odict.
	self assert: json equals: '{"a":42,"b":1,"aa":4,"c":23}'.

	"lost when decoding because gets loaded into a normal Dictionary"
	dict := JSON fromString: json.
	self assert: dict class equals: Dictionary.
	self assert: dict asSet equals: odict asSet.
	self deny: dict asArray equals: odict asArray!

testShared
	"Structure sharing cannot be encoded using JSON"

	self should: 
			[| foo |
			foo := {'foo' -> 'dummy'} asDictionary.
			JSON toString: {foo. foo}]
		raise: WriterError!

testStrings
	self assert: (JSON toString: 'string') equals: '"string"'.
	self assert: (JSON toString: '') equals: '""'.
	self assert: (JSON toString: 'élèves français') equals: '"élèves français"'.
	self assert: (JSON toString: String crlf) equals: '"\r\n"'.
	self assert: (JSON fromString: '"string"') equals: 'string'.
	self assert: (JSON fromString: '""') equals: ''.
	self assert: (JSON fromString: '"élèves français"') equals: 'élèves français'.
	self assert: (JSON fromString: '"\u212B \"Angstrom Symbol\""')
		equals: 8491 asCharacter asString , ' "Angstrom Symbol"'!

testUnknown
	"Only Array for lists and Dictionary for maps are allowed for JSON encoding,
	any other Smalltalk object cannot be encoded (following the specs).
	Even considering all collections to be lists won't work because the type 
	is then lost when decoding"

	self should: [JSON toString: 1 @ 2] raise: WriterError.
	self should: [JSON toString: #(1 2 3) asOrderedCollection] raise: WriterError! !

!STON.Tests.JSONTest categoriesForMethods!
hasOrderedDictionary!helpers!private! !
orderedDictionaryClass!helpers!private! !
testBooleans!public!tests! !
testCircular!public!tests! !
testFloats!public!tests! !
testIntegers!public!tests! !
testLists!public!tests! !
testMaps!public!tests! !
testNull!public!tests! !
testOrderedDictionary!public!tests! !
testShared!public!tests! !
testStrings!public!tests! !
testUnknown!public!tests! !
!

