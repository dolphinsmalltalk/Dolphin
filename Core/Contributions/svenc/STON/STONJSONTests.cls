"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #STONJSONTests
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONJSONTests guid: (GUID fromString: '{437baf49-fca6-405c-9fb7-18b0c8f89f50}')!
STONJSONTests comment: 'STONJSONTests contains unit tests for the JSON functionality available in STON.'!
!STONJSONTests categoriesForClass!STON-Tests-Base! !
!STONJSONTests methodsFor!

testBooleans
	self assert: (STONJSON toString: true) equals: 'true'.
	self assert: (STONJSON toString: false) equals: 'false'.
	self assert: (STONJSON fromString: 'true') equals: true.
	self assert: (STONJSON fromString: 'false') equals: false.!

testCircular
	"Circular datastructures cannot be encoded using JSON"
	self
		should: [ | foo |
			foo :=Dictionary withAll: { 'foo'->'dummy' }.
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
	self assert: (STONJSON toString: (Dictionary withAll: { 'temperature'->37 })) equals: '{"temperature":37}'.
	self assert: (STONJSON toString: Dictionary new) equals: '{}'.
	self assert: (STONJSON fromString: '{"temperature":37}') equals: (Dictionary withAll: { 'temperature'->37 }).
	self assert: (STONJSON fromString: '{}') equals: Dictionary new.!

testNull
	self assert: (STONJSON toString: nil) equals: 'null'.
	self assert: (STONJSON fromString: 'null') equals: nil.!

testShared
	"Structure sharing cannot be encoded using JSON"
	self
		should: [ | foo |
			foo := (Dictionary withAll: { 'foo'->'dummy' }).
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
!STONJSONTests categoriesFor: #testBooleans!public!tests! !
!STONJSONTests categoriesFor: #testCircular!public!tests! !
!STONJSONTests categoriesFor: #testFloats!public!tests! !
!STONJSONTests categoriesFor: #testIntegers!public!tests! !
!STONJSONTests categoriesFor: #testLists!public!tests! !
!STONJSONTests categoriesFor: #testMaps!public!tests! !
!STONJSONTests categoriesFor: #testNull!public!tests! !
!STONJSONTests categoriesFor: #testShared!public!tests! !
!STONJSONTests categoriesFor: #testStrings!public!tests! !
!STONJSONTests categoriesFor: #testUnknown!public!tests! !

