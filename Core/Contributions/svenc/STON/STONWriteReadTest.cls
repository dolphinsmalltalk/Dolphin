﻿"Filed out from Dolphin Smalltalk 7"!

TestCase subclass: #STONWriteReadTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
STONWriteReadTest guid: (GUID fromString: '{8084b7c8-9c64-46ad-a994-4ca3445bcee8}')!
STONWriteReadTest comment: 'STONWriteReadTests test serialization followed by materialization.'!
!STONWriteReadTest categoriesForClass!STON-Tests-Writer! !
!STONWriteReadTest methodsFor!

environment
	^ Smalltalk globals!

materialize: string
	^ STON reader 
		on: string readStream;
		next!

serialize: anObject
	^ String streamContents: [ :stream |
		STON writer 
			on: stream;
			prettyPrint: Processor activeProcess debugger notNil;
			nextPut: anObject ]

!

serializeAndMaterialize: object
	| serialization materialization |
	serialization := self serialize: object.
	materialization := self materialize: serialization.
	self assert: object equals: materialization
	!

serializeAndMaterializeJsonMode: object
	| serialization materialization |
	serialization := self serializeJson: object.
	materialization := self materialize: serialization.
	self assert: object equals: materialization
!

serializeJson: anObject
	^ String streamContents: [ :stream |
		STON jsonWriter 
			on: stream;
			nextPut: anObject ]!

testAssociations
	| associations |
	associations := OrderedCollection new.
	1 to: 10 do: [ :each |
		associations add: each -> each printString ].
	self serializeAndMaterialize: associations!

testCharacters
	| characters |
	characters := STON listClass withAll: ($a to: $z), ($A to: $Z).
	self serializeAndMaterialize: characters!

testClasses
	| classes |
	classes := STON listClass withAll: { Point. Integer. Object }.
	self serializeAndMaterialize: classes.
	classes := STON listClass withAll: { Point class. Integer class. Object class }.
	self serializeAndMaterialize: classes.
	classes := STON listClass withAll: { Class. Metaclass. Class class. Point class class }.
	self serializeAndMaterialize: classes.!

testCollections
	| collections |
	collections := STON listClass withAll: {
		#(1 2 3).
		OrderedCollection withAll: #(1 2 3).
		Set withAll: #(1 2 3).
		Bag withAll: #(1 2 2 3).
		Dictionary new at: 1 put: 1; at: 2 put: 2; yourself.
		#[1 2 3].
		#(1 2 3) asIntegerArray.
		#(1 2 3) asFloatArray }.
	self serializeAndMaterialize: collections!

testCollectionsStructured
	| collections one two |
	one := 1@2.
	two := 2@3.
	collections := STON listClass withAll: {
	 	Bag withAll: { one. two. one. two. one }.
	 	Set withAll: { one. two. one. two. one }.
	 	OrderedCollection withAll: { one. two. one. two. one }.
	}.
	self serializeAndMaterialize: collections!

testColors
	| colors |
	colors := STON listClass withAll: { 
		Color red.
		Color red copy setAlpha: 0.4.
		Color red lighter lighter }.
	self serializeAndMaterialize: colors
!

testCustomAssociations
	| associations |
	associations := OrderedCollection new.
	associations add: #foo->100.
	associations add: (STONTestAssociation key: #foo value:100).
	self serializeAndMaterialize: associations!

testDatesAndTimes
	| datesAndTimes |
	datesAndTimes := STON listClass withAll: { 
		Time now. 
		Date today. 
		DateAndTime now }.
	self serializeAndMaterialize: datesAndTimes
!

testDomainObject
	| object objects |
	object := STONTestDomainObject dummy.
	self serializeAndMaterialize: object.
	objects := STON listClass streamContents: [ :stream |
		10 timesRepeat: [ stream nextPut: STONTestDomainObject dummy ] ].
	self serializeAndMaterialize: objects.
	objects := STON mapClass new.
	10 timesRepeat: [ | newObject |
		newObject := STONTestDomainObject dummy.
		objects at: newObject integer put: newObject ].
	self serializeAndMaterialize: objects.!

testEmpty
	| empty |
	empty := STON listClass new.
	self serializeAndMaterialize: empty.
	empty := STON mapClass new.
	self serializeAndMaterialize: empty.!

testFloats
	| floats serialization materialization |
	floats := STON listClass withAll: ((-10 to: 10) collect: [ :each | each * Float pi ]).
	serialization := self serialize: floats.
	materialization := self materialize: serialization.
	self assert: floats size equals: materialization size.
	1 to: floats size do: [ :index | 
		| float |
		float := floats at: index.
		"Use #closeTo: instead of #= to increase portability"
		self assert: (float closeTo: (materialization at: index)) ]!

testFractions
	| fractions |
	fractions := STON listClass withAll: (-2/3 to: 2/3 by: 1/3).
	self serializeAndMaterialize: fractions!

testIdentityCollections
	| collections |
	collections := STON listClass withAll: {
		IdentitySet withAll: #(1 2 3).
		IdentityDictionary new at: 1 put: 1; at: 2 put: 2; yourself.
		IdentityBag withAll: { #A. #B. #A. #B. #A } }.
	self serializeAndMaterialize: collections!

testIntervals
	| intervals |
	intervals := STON listClass withAll: { 
		1 to: 10.
		1 to: 10 by: 2.
		100 to: 50 by: -5 }.
	self serializeAndMaterialize: intervals!

testJsonMode
	| object |
	object := STON listClass withAll: {
		Float pi.
		'Hello World'.
		true.
		nil.
		STON listClass withAll: #( 1 2 3) asByteArray.
		STON mapClass new 
			at: 'x' put: 1; 
			at: 'y' put: 2; 
			yourself 
	}.
	self serializeAndMaterializeJsonMode: object
!

testOrderedDictionary
	"OrderedDictionary is special because it does not inherit from Dictionary.
	It might also not exist in some dialects, where this test could be skipped."
	
	| dictionaries orderedDictionaryClass orderedIdentityDictionaryClass |
	orderedDictionaryClass := Smalltalk at: #OrderedDictionary ifAbsent: [ Dictionary ].
	orderedIdentityDictionaryClass := Smalltalk at: #OrderedIdentityDictionary ifAbsent: [ IdentityDictionary ].
	dictionaries := STON listClass withAll: {
		orderedDictionaryClass new at: 1 put: 1; at: 2 put: 2; yourself.
		orderedDictionaryClass new at: #a put: 1; at: #b put: -2; at: #c put: 0; yourself.
		orderedDictionaryClass new.
		orderedIdentityDictionaryClass new at: 1 put: 1; at: 2 put: 2; yourself.
		orderedIdentityDictionaryClass new at: #a put: 1; at: #b put: -2; at: #c put: 0; yourself.
		orderedIdentityDictionaryClass new }.
	self serializeAndMaterialize: dictionaries!

testPrimitives
	| primitives |
	primitives := STON listClass withAll: { true. false. nil }.
	self serializeAndMaterialize: primitives!

testSmallDictionary
	"SmallDictionary is special because it does not inherit from Dictionary.
	It might also not exist in some dialects, where this test could be skipped."
	
	| dictionaries smallDictionaryClass |
	smallDictionaryClass := Smalltalk at: #SmallDictionary ifAbsent: [ Dictionary ].
	dictionaries := STON listClass withAll: {
		smallDictionaryClass new at: 1 put: 1; at: 2 put: 2; yourself.
		smallDictionaryClass new at: 1 put: 1; at: 2 put: 2; yourself.
		smallDictionaryClass new }.
	self serializeAndMaterialize: dictionaries!

testSmallIntegers
	| integers |
	integers := STON listClass withAll: (-10 to: 10).
	self serializeAndMaterialize: integers!

testSpecialCharacters
	| primitives |
	primitives := STON listClass withAll: { 
		String withAll: { Character tab. Character lf. Character cr }.
		String withAll: { $'. $". $\. $/ }.
		'élèves français'.
		'Düsseldorf Königsallee'.
		#dolphin. "Modified non-standard collect and conversion."
		#(1 10 20 30 127 140 150 160 200 255) asByteArray asString }.
	self serializeAndMaterialize: primitives!

testStrings
	| strings |
	strings := Collection allSubclasses 
		collect: [ :each | each name asString ].
	self serializeAndMaterialize: strings.
	strings := { 
		'foo'. 'Foo BAR'. ''. '	\\'''. 
		'élève en Français'. 
		String with: (Character codePoint: 12354) "HIRAGANA LETTER A" }.
	self serializeAndMaterialize: strings.!

testSymbols
	| symbols |
	self serializeAndMaterialize: #( #bytes #'' ).
	symbols := Collection allSubclasses collect: [ :each | each name ].
	self serializeAndMaterialize: symbols
!

testUser
	| user users |
	user := STONTestUser dummy.
	self serializeAndMaterialize: user.
	users := STON listClass streamContents: [ :stream |
		10 timesRepeat: [ stream nextPut: STONTestUser dummy ] ].
	self serializeAndMaterialize: users.
	users := STON mapClass new.
	10 timesRepeat: [ | newUser |
		newUser := STONTestUser dummy.
		users at: newUser username put: newUser ].
	self serializeAndMaterialize: users.!

testUser2
	| user users |
	user := STONTestUser2 dummy.
	self serializeAndMaterialize: user.
	users := STON listClass streamContents: [ :stream |
		10 timesRepeat: [ stream nextPut: STONTestUser2 dummy ] ].
	self serializeAndMaterialize: users.
	users := STON mapClass new.
	10 timesRepeat: [ | newUser |
		newUser := STONTestUser2 dummy.
		users at: newUser username put: newUser ].
	self serializeAndMaterialize: users.!

testUUIDs
	| uuids |
	uuids := STON listClass withAll: { 
		UUID new.
		UUID new.
		UUID nilUUID }.
	self serializeAndMaterialize: uuids! !
!STONWriteReadTest categoriesFor: #environment!private! !
!STONWriteReadTest categoriesFor: #materialize:!private! !
!STONWriteReadTest categoriesFor: #serialize:!private! !
!STONWriteReadTest categoriesFor: #serializeAndMaterialize:!private! !
!STONWriteReadTest categoriesFor: #serializeAndMaterializeJsonMode:!private! !
!STONWriteReadTest categoriesFor: #serializeJson:!private! !
!STONWriteReadTest categoriesFor: #testAssociations!public!tests! !
!STONWriteReadTest categoriesFor: #testCharacters!public!tests! !
!STONWriteReadTest categoriesFor: #testClasses!public!tests! !
!STONWriteReadTest categoriesFor: #testCollections!public!tests! !
!STONWriteReadTest categoriesFor: #testCollectionsStructured!public!tests! !
!STONWriteReadTest categoriesFor: #testColors!public!tests! !
!STONWriteReadTest categoriesFor: #testCustomAssociations!public!tests! !
!STONWriteReadTest categoriesFor: #testDatesAndTimes!public!tests! !
!STONWriteReadTest categoriesFor: #testDomainObject!public!tests! !
!STONWriteReadTest categoriesFor: #testEmpty!public!tests! !
!STONWriteReadTest categoriesFor: #testFloats!public!tests! !
!STONWriteReadTest categoriesFor: #testFractions!public!tests! !
!STONWriteReadTest categoriesFor: #testIdentityCollections!public!tests! !
!STONWriteReadTest categoriesFor: #testIntervals!public!tests! !
!STONWriteReadTest categoriesFor: #testJsonMode!public!tests! !
!STONWriteReadTest categoriesFor: #testOrderedDictionary!public!tests! !
!STONWriteReadTest categoriesFor: #testPrimitives!public!tests! !
!STONWriteReadTest categoriesFor: #testSmallDictionary!public!tests! !
!STONWriteReadTest categoriesFor: #testSmallIntegers!public!tests! !
!STONWriteReadTest categoriesFor: #testSpecialCharacters!public!tests! !
!STONWriteReadTest categoriesFor: #testStrings!public!tests! !
!STONWriteReadTest categoriesFor: #testSymbols!public!tests! !
!STONWriteReadTest categoriesFor: #testUser!public!tests! !
!STONWriteReadTest categoriesFor: #testUser2!public!tests! !
!STONWriteReadTest categoriesFor: #testUUIDs!public!tests! !

