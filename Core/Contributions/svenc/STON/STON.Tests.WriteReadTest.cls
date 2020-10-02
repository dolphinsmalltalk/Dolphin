"Filed out from Dolphin Smalltalk 7"!

STON.Tests.STONTestCase subclass: #'STON.Tests.WriteReadTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.WriteReadTest guid: (Core.GUID fromString: '{8084b7c8-9c64-46ad-a994-4ca3445bcee8}')!
STON.Tests.WriteReadTest comment: 'STONWriteReadTests test serialization followed by materialization.'!
!STON.Tests.WriteReadTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.WriteReadTest methodsFor!

environment
	^Smalltalk globals!

serializeAndMaterialize: object
	| serialization materialization |
	serialization := self serialize: object.
	materialization := self materialize: serialization.
	self assert: materialization equals: object.
	^materialization
	!

serializeAndMaterializeJsonMode: object
	| serialization materialization |
	serialization := self serializeJson: object.
	materialization := self materialize: serialization.
	self assert: object equals: materialization
!

serializeJson: anObject
	^String streamContents: 
			[:stream |
			STON jsonWriter
				on: stream;
				nextPut: anObject]!

testAssociations
	| associations |
	associations := OrderedCollection new.
	1 to: 10 do: [ :each |
		associations add: each -> each printString ].
	self serializeAndMaterialize: associations!

testCharacters
	| characters |
	characters := STON listClass withAll: ($a to: $z) , ($A to: $Z).
	self serializeAndMaterialize: characters!

testClasses
	| classes |
	classes := STON listClass withAll: {Point. Integer. Object}.
	self serializeAndMaterialize: classes.
	classes := STON listClass withAll: {Point class. Integer class. Object class}.
	self serializeAndMaterialize: classes.
	classes := STON listClass withAll: {Class. Metaclass. Class class. Point class class}.
	self serializeAndMaterialize: classes!

testCollections
	| collections |
	collections := STON listClass withAll: {#(1 2 3).
						OrderedCollection withAll: #(1 2 3).
						Set withAll: #(1 2 3).
						Bag withAll: #(1 2 2 3).
						Dictionary new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						#[1 2 3].
						#(1 2 3) asIntegerArray.
						#(1 2 3) asFloatArray}.
	self serializeAndMaterialize: collections!

testCollectionsStructured
	| collections one two |
	one := 1 @ 2.
	two := 2 @ 3.
	collections := STON listClass withAll: {Bag withAll: {one. two. one. two. one}.
						Set withAll: {one. two. one. two. one}.
						OrderedCollection withAll: {one. two. one. two. one}}.
	self serializeAndMaterialize: collections!

testColors
	| colors |
	colors := STON listClass
				withAll: {Color red. Color red copy setAlpha: 0.4. Color red lighter lighter}.
	self serializeAndMaterialize: colors!

testCustomAssociations
	| associations |
	associations := OrderedCollection new.
	associations add: #foo->100.
	associations add: (TestAssociation key: #foo value:100).
	self serializeAndMaterialize: associations!

testDatesAndTimes
	| datesAndTimes |
	datesAndTimes := STON listClass withAll: {Time now. Date today. DateAndTime now}.
	self serializeAndMaterialize: datesAndTimes!

testDomainObject
	| object objects |
	object := TestDomainObject dummy.
	self serializeAndMaterialize: object.
	objects := STON listClass
				streamContents: [:stream | 10 timesRepeat: [stream nextPut: TestDomainObject dummy]].
	self serializeAndMaterialize: objects.
	objects := STON mapClass new.
	10 timesRepeat: 
			[| newObject |
			newObject := TestDomainObject dummy.
			objects at: newObject integer put: newObject].
	self serializeAndMaterialize: objects!

testEmpty
	| empty |
	empty := STON listClass new.
	self serializeAndMaterialize: empty.
	empty := STON mapClass new.
	self serializeAndMaterialize: empty!

testFloats
	| floats serialization materialization |
	floats := STON listClass withAll: ((-10 to: 10) collect: [:each | each * Float pi]).
	serialization := self serialize: floats.
	materialization := self materialize: serialization.
	self assert: floats size equals: materialization size.
	1 to: floats size
		do: 
			[:index |
			| float |
			float := floats at: index.
			"Use #closeTo: instead of #= to increase portability"
			self assert: (float closeTo: (materialization at: index))]!

testFractions
	| fractions |
	fractions := STON listClass withAll: (-2 / 3 to: 2 / 3 by: 1 / 3).
	self serializeAndMaterialize: fractions!

testIdentityCollections
	| collections |
	collections := STON listClass withAll: {IdentitySet withAll: #(1 2 3).
						IdentityDictionary new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						IdentityBag withAll: {#A. #B. #A. #B. #A}}.
	self serializeAndMaterialize: collections!

testIntervals
	| intervals |
	intervals := STON listClass withAll: {1 to: 10. 1 to: 10 by: 2. 100 to: 50 by: -5}.
	self serializeAndMaterialize: intervals!

testJsonMode
	| object |
	object := STON listClass withAll: {Float pi.
						'Hello World'.
						true.
						nil.
						STON listClass withAll: #(1 2 3) asByteArray.
						STON mapClass new
							at: 'x' put: 1;
							at: 'y' put: 2;
							yourself}.
	self serializeAndMaterializeJsonMode: object!

testOrderedDictionary
	"OrderedDictionary is special because it does not inherit from Dictionary.
	It might also not exist in some dialects, where this test could be skipped."

	| dictionaries orderedDictionaryClass orderedIdentityDictionaryClass |
	orderedDictionaryClass := #{OrderedDictionary} valueOrNil ?? Dictionary.
	orderedIdentityDictionaryClass := #{OrderedIdentityDictionary} valueOrNil ?? IdentityDictionary.
	dictionaries := STON listClass
				withAll: {orderedDictionaryClass new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						orderedDictionaryClass new
							at: #a put: 1;
							at: #b put: -2;
							at: #c put: 0;
							yourself.
						orderedDictionaryClass new.
						orderedIdentityDictionaryClass new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						orderedIdentityDictionaryClass new
							at: #a put: 1;
							at: #b put: -2;
							at: #c put: 0;
							yourself.
						orderedIdentityDictionaryClass new}.
	self serializeAndMaterialize: dictionaries!

testPrimitives
	| primitives |
	primitives := STON listClass withAll: {true. false. nil}.
	self serializeAndMaterialize: primitives!

testSmallDictionary
	"SmallDictionary is special because it does not inherit from Dictionary.
	It might also not exist in some dialects, where this test could be skipped."

	| dictionaries smallDictionaryClass |
	smallDictionaryClass := #{SmallDictionary} valueOrNil ?? Dictionary.
	dictionaries := STON listClass
				withAll: {smallDictionaryClass new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						smallDictionaryClass new
							at: 1 put: 1;
							at: 2 put: 2;
							yourself.
						smallDictionaryClass new}.
	self serializeAndMaterialize: dictionaries!

testSmallIntegers
	| integers |
	integers := STON listClass withAll: (-10 to: 10).
	self serializeAndMaterialize: integers!

testSortedCollections
	| collections materialized |
	collections := STON listClass withAll: {SortedCollection new.
						SortedCollection new: 0.
						#(5 3 7 2 1 4 10 9 8 6) asSortedCollection.
						#(5 3 7 2 1 4 10 9 8 6) asSortedCollection: [:a :b | a < b].
						#(5 3 7 2 1 4 10 9 8 6) asSortedCollection: [:a :b | a > b].
						#('****' '*' '*****' '**' '***') asSortedCollection: [:a :b | a size < b size].
						#('****' '*' '*****' '**' '***') asSortedCollection: [:a :b | a size > b size].
						(#(nil 5 3 7 2 1 4 10 nil 9 8 6)
							asSortedCollection: [:a :b | a isNil or: [b notNil and: [a < b]]])
							removeFirst;
							yourself.
						(#(5 3 7 2 1 4 10 nil 9 8 nil 6)
							asSortedCollection: [:a :b | a isNil or: [b notNil and: [a > b]]])
							removeLast;
							yourself}.
	materialized := self serializeAndMaterialize: collections.
	"Verify the sort algo was restored correctly."
	materialized do: 
			[:each |
			| before sorted |
			before := each asArray.
			sorted := each reSort asArray.
			self assert: before equals: sorted]!

testSpecialCharacters
	| primitives |
	primitives := STON listClass withAll: {String withAll: {Character tab. Character lf. Character cr}.
						String withAll: {$'. $". $\. $/}.
						'élèves français'.
						'Düsseldorf Königsallee'.
						#dolphin.
						#(1 10 20 30 127 140 150 160 200 255) asByteArray asString}.	"Modified non-standard collect and conversion."
	self serializeAndMaterialize: primitives!

testStrings
	| strings |
	strings := Collection allSubclasses collect: [:each | each name asString].
	self serializeAndMaterialize: strings.
	strings := {'foo'.
				'Foo BAR'.
				''.
				'	\\'''.
				'élève en Français'.
				String with: (Character codePoint: 12354)}.	"HIRAGANA LETTER A"
	self serializeAndMaterialize: strings!

testSymbols
	| symbols |
	self serializeAndMaterialize: #(#bytes #'').
	symbols := Collection allSubclasses collect: [:each | each name].
	self serializeAndMaterialize: symbols!

testUser
	| user users |
	user := STONTestUser dummy.
	self serializeAndMaterialize: user.
	users := STON listClass
				streamContents: [:stream | 10 timesRepeat: [stream nextPut: STONTestUser dummy]].
	self serializeAndMaterialize: users.
	users := STON mapClass new.
	10 timesRepeat: 
			[| newUser |
			newUser := STONTestUser dummy.
			users at: newUser username put: newUser].
	self serializeAndMaterialize: users!

testUser2
	| user users |
	user := STONTestUser2 dummy.
	self serializeAndMaterialize: user.
	users := STON listClass
				streamContents: [:stream | 10 timesRepeat: [stream nextPut: STONTestUser2 dummy]].
	self serializeAndMaterialize: users.
	users := STON mapClass new.
	10 timesRepeat: 
			[| newUser |
			newUser := STONTestUser2 dummy.
			users at: newUser username put: newUser].
	self serializeAndMaterialize: users!

testUUIDs
	| uuids |
	uuids := STON listClass withAll: {UUID new. UUID new. UUID nilUUID}.
	self serializeAndMaterialize: uuids! !
!STON.Tests.WriteReadTest categoriesFor: #environment!private! !
!STON.Tests.WriteReadTest categoriesFor: #serializeAndMaterialize:!private! !
!STON.Tests.WriteReadTest categoriesFor: #serializeAndMaterializeJsonMode:!private! !
!STON.Tests.WriteReadTest categoriesFor: #serializeJson:!private! !
!STON.Tests.WriteReadTest categoriesFor: #testAssociations!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testCharacters!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testClasses!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testCollections!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testCollectionsStructured!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testColors!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testCustomAssociations!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testDatesAndTimes!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testDomainObject!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testEmpty!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testFloats!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testFractions!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testIdentityCollections!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testIntervals!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testJsonMode!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testOrderedDictionary!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testPrimitives!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testSmallDictionary!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testSmallIntegers!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testSortedCollections!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testSpecialCharacters!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testStrings!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testSymbols!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testUser!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testUser2!public!tests! !
!STON.Tests.WriteReadTest categoriesFor: #testUUIDs!public!tests! !

