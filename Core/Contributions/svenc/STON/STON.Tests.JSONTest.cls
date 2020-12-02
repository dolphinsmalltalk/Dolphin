"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #STONJSONTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
STONJSONTest guid: (GUID fromString: '{437baf49-fca6-405c-9fb7-18b0c8f89f50}')!
STONJSONTest comment: 'STONJSONTests contains unit tests for the JSON functionality available in STON.'!
!STONJSONTest categoriesForClass!STON-Tests-Facade! !
!STONJSONTest methodsFor!

testBooleans
	self assert: (STONJSON toString: true) equals: 'true'.
	self assert: (STONJSON toString: false) equals: 'false'.
	self assert: (STONJSON fromString: 'true') equals: true.
	self assert: (STONJSON fromString: 'false') equals: false.!

testCircular
	"Circular datastructures cannot be encoded using JSON"
	self
		should: [ | foo |
			foo := { 'foo'->'dummy' } asDictionary.
			foo at: 'bar' put: foo.
			STONJSON toString: foo ]
		raise: STONWriterError!

testFloats
	self assert: (STONJSON toString: 1.0) equals: '1.0'.
	self assert: (STONJSON toString: 0.0) equals: '0.0'.
	self assert: (STONJSON toString: -1.0) equals: '-1.0'.
	self assert: (STONJSON toString: -1.23456e-6) equals: '-1.23456e-6'.
	self assert: ((STONJSON fromString: '1.0') closeTo: 1.0).
	self assert: ((STONJSON fromString: '0.0') closeTo: 0.0).
	self assert: ((STONJSON fromString: '-1.0') closeTo: -1.0).
	self assert: ((STONJSON fromString: '-1.23456e-6') closeTo: -1.23456e-6).!

testIntegers
	self assert: (STONJSON toString: 1) equals: '1'.
	self assert: (STONJSON toString: 0) equals: '0'.
	self assert: (STONJSON toString: -1) equals: '-1'.
	self assert: (STONJSON toString: 1234567890) equals: '1234567890'.
	self assert: (STONJSON fromString: '1') equals: 1.
	self assert: (STONJSON fromString: '0') equals: 0.
	self assert: (STONJSON fromString: '-1') equals: -1.
	self assert: (STONJSON fromString: '1234567890') equals: 1234567890.!

testLists
	self assert: (STONJSON toString: #(1 2 3)) equals: '[1,2,3]'.
	self assert: (STONJSON toString: #(1 -2 true 3 nil)) equals: '[1,-2,true,3,null]'.
	self assert: (STONJSON toString: #(1 (2) 3)) equals: '[1,[2],3]'.
	self assert: (STONJSON toString: #()) equals: '[]'.
	self assert: (STONJSON fromString: '[]') equals: #().
	self assert: (STONJSON fromString: '[1,2,3]') equals: #(1 2 3).
	self assert: (STONJSON fromString: '[1,-2,true,3,null]') equals: #(1 -2 true 3 nil).
	self assert: (STONJSON fromString: '[1,[2],3]') equals: #(1 (2) 3).!

testMaps
	self assert: (STONJSON toString: { 'temperature'->37 } asDictionary) equals: '{"temperature":37}'.
	self assert: (STONJSON toString: Dictionary new) equals: '{}'.
	self assert: (STONJSON fromString: '{"temperature":37}') equals: { 'temperature'->37 } asDictionary.
	self assert: (STONJSON fromString: '{}') equals: Dictionary new.!

testNull
	self assert: (STONJSON toString: nil) equals: 'null'.
	self assert: (STONJSON fromString: 'null') equals: nil.!

testOrderedDictionary
	| odictClass odict json dict |
	odictClass := Smalltalk at: #OrderedDictionary ifAbsent: [ ^ self skip ].

	odict := odictClass newFrom: {('a' -> 42) . ('b' -> 1) . ('aa' -> 4) . ('c' -> 23)}.

	"assert that the order is not equal in the dictionary hash table"
	self
		assertCollection: odict asArray hasSameElements: odict dictionary asArray;
		deny: odict asArray equals: odict dictionary asArray.

	"ordered presevered when encoding:"
	json := STONJSON toString: odict.
	self assert: json equals: '{"a":42,"b":1,"aa":4,"c":23}'.

	"lost when decoding"
	dict := STONJSON fromString: json.

	self
		assertCollection: dict asArray hasSameElements: odict asArray;
		assert: dict equals: odict dictionary;
		deny: dict asArray equals: odict asArray!

testShared
	"Structure sharing cannot be encoded using JSON"
	self
		should: [ | foo |
			foo := { 'foo'->'dummy' } asDictionary.
			STONJSON toString: { foo. foo } ]
		raise: STONWriterError!

testStrings
	self assert: (STONJSON toString: 'string') equals: '"string"'.
	self assert: (STONJSON toString: '') equals: '""'.
	self assert: (STONJSON toString: 'élèves français') equals: '"élèves français"'.
	self assert: (STONJSON toString: String crlf) equals: '"\r\n"'.
	self assert: (STONJSON fromString: '"string"') equals: 'string'.
	self assert: (STONJSON fromString: '""') equals: ''.
	self assert: (STONJSON fromString: '"élèves français"') equals: 'élèves français'.
	self 
		assert: (STONJSON fromString: '"\u212B \"Angstrom Symbol\""') 
		equals: 8491 asCharacter asString, ' "Angstrom Symbol"'.!

testUnknown
	"Only Array for lists and Dictionary for maps are allowed for JSON encoding,
	any other Smalltalk object cannot be encoded (following the specs).
	Even considering all collections to be lists won't work because the type 
	is then lost when decoding"
	
	self should: [ STONJSON toString: 1@2 ] raise: STONWriterError.
	self should: [ STONJSON toString: #(1 2 3) asOrderedCollection ] raise: STONWriterError.! !
!STONJSONTest categoriesFor: #testBooleans!public!tests! !
!STONJSONTest categoriesFor: #testCircular!public!tests! !
!STONJSONTest categoriesFor: #testFloats!public!tests! !
!STONJSONTest categoriesFor: #testIntegers!public!tests! !
!STONJSONTest categoriesFor: #testLists!public!tests! !
!STONJSONTest categoriesFor: #testMaps!public!tests! !
!STONJSONTest categoriesFor: #testNull!public!tests! !
!STONJSONTest categoriesFor: #testOrderedDictionary!public!tests! !
!STONJSONTest categoriesFor: #testShared!public!tests! !
!STONJSONTest categoriesFor: #testStrings!public!tests! !
!STONJSONTest categoriesFor: #testUnknown!public!tests! !

