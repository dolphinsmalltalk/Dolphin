"Filed out from Dolphin Smalltalk 7"!

STON.Tests.STONTestCase subclass: #'STON.Tests.JSONTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.JSONTest guid: (Core.GUID fromString: '{437baf49-fca6-405c-9fb7-18b0c8f89f50}')!
STON.Tests.JSONTest comment: 'STONJSONTests contains unit tests for the JSON functionality available in STON.'!
!STON.Tests.JSONTest categoriesForClass!STON-Tests-Facade! !
!STON.Tests.JSONTest methodsFor!

testBooleans
	self assert: (STON.JSON toString: true) equals: 'true'.
	self assert: (STON.JSON toString: false) equals: 'false'.
	self assert: (STON.JSON fromString: 'true') equals: true.
	self assert: (STON.JSON fromString: 'false') equals: false!

testCircular
	"Circular datastructures cannot be encoded using JSON"

	self should: 
			[| foo |
			foo := {'foo' -> 'dummy'} asDictionary.
			foo at: 'bar' put: foo.
			STON.JSON toString: foo]
		raise: STON.WriterError!

testFloats
	self assert: (STON.JSON toString: 1.0) equals: '1.0'.
	self assert: (STON.JSON toString: 0.0) equals: '0.0'.
	self assert: (STON.JSON toString: -1.0) equals: '-1.0'.
	self assert: (STON.JSON toString: -1.23456e-6) equals: '-1.23456e-6'.
	self assert: ((STON.JSON fromString: '1.0') closeTo: 1.0).
	self assert: ((STON.JSON fromString: '0.0') closeTo: 0.0).
	self assert: ((STON.JSON fromString: '-1.0') closeTo: -1.0).
	self assert: ((STON.JSON fromString: '-1.23456e-6') closeTo: -1.23456e-6)!

testIntegers
	self assert: (STON.JSON toString: 1) equals: '1'.
	self assert: (STON.JSON toString: 0) equals: '0'.
	self assert: (STON.JSON toString: -1) equals: '-1'.
	self assert: (STON.JSON toString: 1234567890) equals: '1234567890'.
	self assert: (STON.JSON fromString: '1') equals: 1.
	self assert: (STON.JSON fromString: '0') equals: 0.
	self assert: (STON.JSON fromString: '-1') equals: -1.
	self assert: (STON.JSON fromString: '1234567890') equals: 1234567890!

testLists
	self assert: (STON.JSON toString: #(1 2 3)) equals: '[1,2,3]'.
	self assert: (STON.JSON toString: #(1 -2 true 3 nil)) equals: '[1,-2,true,3,null]'.
	self assert: (STON.JSON toString: #(1 #(2) 3)) equals: '[1,[2],3]'.
	self assert: (STON.JSON toString: #()) equals: '[]'.
	self assert: (STON.JSON fromString: '[]') equals: #().
	self assert: (STON.JSON fromString: '[1,2,3]') equals: #(1 2 3).
	self assert: (STON.JSON fromString: '[1,-2,true,3,null]') equals: #(1 -2 true 3 nil).
	self assert: (STON.JSON fromString: '[1,[2],3]') equals: #(1 #(2) 3)!

testMaps
	self assert: (STON.JSON toString: {'temperature' -> 37} asDictionary) equals: '{"temperature":37}'.
	self assert: (STON.JSON toString: Dictionary new) equals: '{}'.
	self assert: (STON.JSON fromString: '{"temperature":37}') equals: {'temperature' -> 37} asDictionary.
	self assert: (STON.JSON fromString: '{}') equals: Dictionary new!

testNull
	self assert: (STON.JSON toString: nil) equals: 'null'.
	self assert: (STON.JSON fromString: 'null') equals: nil!

testOrderedDictionary
	| odictClass odict json dict |
	odictClass := Smalltalk at: #OrderedDictionary ifAbsent: [^self skip].
	odict := odictClass newFrom: {'a' -> 42. 'b' -> 1. 'aa' -> 4. 'c' -> 23}.

	"assert that the order is not equal in the dictionary hash table"
	self
		assertCollection: odict asArray hasSameElements: odict dictionary asArray;
		deny: odict asArray equals: odict dictionary asArray.

	"ordered presevered when encoding:"
	json := STON.JSON toString: odict.
	self assert: json equals: '{"a":42,"b":1,"aa":4,"c":23}'.

	"lost when decoding"
	dict := STON.JSON fromString: json.
	self
		assertCollection: dict asArray hasSameElements: odict asArray;
		assert: dict equals: odict dictionary;
		deny: dict asArray equals: odict asArray!

testShared
	"Structure sharing cannot be encoded using JSON"

	self should: 
			[| foo |
			foo := {'foo' -> 'dummy'} asDictionary.
			STON.JSON toString: {foo. foo}]
		raise: STON.WriterError!

testStrings
	self assert: (STON.JSON toString: 'string') equals: '"string"'.
	self assert: (STON.JSON toString: '') equals: '""'.
	self assert: (STON.JSON toString: 'élèves français') equals: '"élèves français"'.
	self assert: (STON.JSON toString: String crlf) equals: '"\r\n"'.
	self assert: (STON.JSON fromString: '"string"') equals: 'string'.
	self assert: (STON.JSON fromString: '""') equals: ''.
	self assert: (STON.JSON fromString: '"élèves français"') equals: 'élèves français'.
	self assert: (STON.JSON fromString: '"\u212B \"Angstrom Symbol\""')
		equals: 8491 asCharacter asString , ' "Angstrom Symbol"'!

testUnknown
	"Only Array for lists and Dictionary for maps are allowed for JSON encoding,
	any other Smalltalk object cannot be encoded (following the specs).
	Even considering all collections to be lists won't work because the type 
	is then lost when decoding"

	self should: [STON.JSON toString: 1 @ 2] raise: STON.WriterError.
	self should: [STON.JSON toString: #(1 2 3) asOrderedCollection] raise: STON.WriterError! !
!STON.Tests.JSONTest categoriesFor: #testBooleans!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testCircular!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testFloats!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testIntegers!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testLists!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testMaps!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testNull!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testOrderedDictionary!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testShared!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testStrings!public!tests! !
!STON.Tests.JSONTest categoriesFor: #testUnknown!public!tests! !

