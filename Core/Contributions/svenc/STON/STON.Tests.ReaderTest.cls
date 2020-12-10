"Filed out from Dolphin Smalltalk 7"!

STON.Tests.STONTestCase subclass: #'STON.Tests.ReaderTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.ReaderTest guid: (Core.GUID fromString: '{6a0fdc02-84d9-4344-8b1e-55e345843ec9}')!
STON.Tests.ReaderTest comment: 'STONReaderTests test materialization.
'!
!STON.Tests.ReaderTest categoriesForClass!STON-Tests-Reader! !
!STON.Tests.ReaderTest methodsFor!

testAssociation
	self assert: (self materialize: '''foo'':1') equals: 'foo' -> 1.
	self assert: (self materialize: '#bar:2') equals: #bar -> 2.
	self assert: (self materialize: '''foo bar'':#ok') equals: 'foo bar' -> #ok.
	self assert: (self materialize: '123:456') equals: 123 -> 456.

	self assert: (self materialize: '''foo'' : 1') equals: 'foo' -> 1.
	self assert: (self materialize: '#bar : 2') equals: #bar -> 2.
	self assert: (self materialize: '''foo bar'' : #ok') equals: 'foo bar' -> #ok.
	self assert: (self materialize: '123 : -456') equals: 123 -> -456.

	self assert: (self materialize: '#foo : 1 : 2') equals: #foo -> (1 -> 2)
!

testBag
	self assert: (self materialize: 'Bag{#a:2,#b:3}') equals: (Bag withAll: #(#a #a #b #b #b)).
	self assert: (self materialize: 'Bag{}') equals: Bag new!

testBoolean
	self assert: (self materialize: 'true') equals: true.
	self assert: (self materialize: 'false') equals: false!

testByteArray
	self assert: (self materialize: 'ByteArray[''010203'']') equals: #(1 2 3) asByteArray
!

testCharacter
	self assert: (self materialize: 'Character[''A'']') identicalTo: $A!

testClass
	self assert: (self materialize: 'Class[#Point]') equals: Point!

testClassWithUnderscore
	| cls data reader |
	cls := Object newAnonymousSubclass.
	cls setName: #A_B_C123AnonClass environment: nil.
	data := STON toString: cls new.
	reader := Reader on: data readStream.
	(reader instVarNamed: #classes) at: cls name put: cls.
	self assert: reader next class equals: cls!

testColor
	self 
		assert: (self materialize: 'Color[#red]')
		equals: Color red.
	self 
		assert: (self materialize: 'Color{#red:1.0,#green:0.0,#blue:0.0,#alpha:0.4}')
		equals: (Color red copy setAlpha: 0.4).
	self 
		assert: (self materialize: 'Color{#red:1.0,#green:0.061,#blue:0.061,#alpha:1.0}')
		equals: Color red lighter lighter.!

testConvertingNewLines
	| input result output |
	input := '''line ending with CR' , String cr , 'line ending with LF' , String lf
				, 'line ending with CRLF' , String crlf
				, ''''.
	output := 'line ending with CR' , String crlf , 'line ending with LF' , String crlf
				, 'line ending with CRLF' , String crlf.
	result := (STON reader on: input readStream)
				newLine: String crlf;
				convertNewLines: true;
				next.
	self assert: result equals: output.
	output := 'line ending with CR' , String cr , 'line ending with LF' , String cr
				, 'line ending with CRLF' , String cr.
	result := (STON reader on: input readStream)
				newLine: String cr;
				convertNewLines: true;
				next.
	self assert: result equals: output!

testDate
	| date |
	date := (Date
				year: 2012
				month: 1
				day: 1) translateToUTC.
	self assert: (self materialize: 'Date[''2012-01-01Z'']') equals: date.
	self assert: (self materialize: 'Date[''2012-01-01+00:00'']') equals: date.
	date := (Date
				year: 2012
				month: 1
				day: 1) translateTo: 1 hour.
	self assert: (self materialize: 'Date[''2012-01-01+01:00'']') equals: date.
	"a missing timezone offset results in the local timezone offset being used,
	this is never written by STON, but matches the first implementation for backwards compatibility"
	date := Date
				year: 2012
				month: 1
				day: 1.
	self assert: (self materialize: 'Date[''2012-01-01'']') equals: date!

testDateAndTime
	| dateAndTime |
	dateAndTime := DateAndTime
				year: 2012
				month: 1
				day: 1
				hour: 6
				minute: 30
				second: 15
				offset: 1 hour.
	self assert: (self materialize: 'DateAndTime[''2012-01-01T06:30:15+01:00'']') equals: dateAndTime!

testDeepStructure
	| holder deepest structure writer ston reader result |
	"Create a deep nested structure so that the deepest element is a reference back to a top level holder."
	holder := Array with: 42.
	deepest := Array with: holder.
	structure := deepest.
	"Modified from original as this causes a stack overflow in Dolphin with depth 1024. There is no obvious reason to make this test go so deep anyway since there it makes no difference to the code paths."
	1 * 512 timesRepeat: [structure := Array with: structure].
	structure := Array with: holder with: structure.
	writer := STON writer optimizeForLargeStructures.
	ston := String streamContents: [:out | (writer on: out) nextPut: structure].
	"After reading, the second pass will have to go down the structure to resolve the reference - not with DolphinSTONReader it won't."
	reader := STON reader optimizeForLargeStructures.
	result := (reader on: ston readStream) next.
	self assert: result equals: structure!

testDictionary
	| collection |
	collection := STON mapClass new
				at: 1 put: 1;
				at: 2 put: 2;
				yourself.
	self assert: (self materialize: '{1:1,2:2}') equals: collection.
	self assert: (self materialize: '{}') equals: STON mapClass new!

testDictionaryWithComplexKeys
	| collection reader |
	collection := STON mapClass new
				at: true put: 1;
				at: #(#foo) put: 2;
				yourself.
	"allowing complex map keys used to be optional, now it is always the default"
	reader := Reader on: '{true:1,[#foo]:2}' readStream.
	self assert: reader next equals: collection!

testDictionaryWithIndirectReferenceKeys
	| keysCollection dictionary ston object |
	keysCollection := OrderedCollection
				streamContents: [:out | 10 timesRepeat: [out nextPut: UUID new]].
	dictionary := Dictionary new.
	keysCollection doWithIndex: [:each :index | dictionary at: (Array with: each) put: index].
	object := Array with: keysCollection with: dictionary.
	ston := STON toStringPretty: object.
	object := (STON reader on: ston readStream) next.
	object first
		doWithIndex: [:each :index | self assert: (object second at: (Array with: each)) equals: index].
	self assert: object second isHealthy!

testDictionaryWithReferenceKeys
	| keysCollection dictionary ston object |
	keysCollection := OrderedCollection
				streamContents: [:out | 10 timesRepeat: [out nextPut: UUID new]].
	dictionary := Dictionary new.
	keysCollection doWithIndex: [:each :index | dictionary at: each put: index].
	object := Array with: keysCollection with: dictionary.
	ston := STON toStringPretty: object.
	object := (STON reader on: ston readStream) next.
	object first doWithIndex: [:each :index | self assert: (object second at: each) equals: index].
	self assert: object second isHealthy!

testError
	#('foo' '{foo:}' '{foo,}' '[1,]' '+1' ']' '#' '' '  ' '	' 'nul' 'tru' 'fals')
		do: [:each | self should: [self materialize: each] raise: ReaderError]!

testFloat
	self assert: ((self materialize: '1.5') closeTo: 1.5).
	self assert: ((self materialize: '-1.5') closeTo: -1.5).
	self assert: (self materialize: '0.0') isZero.
	self assert: (Float pi closeTo: (self materialize: '3.14149')).
	self assert: (1 / 3 closeTo: (self materialize: '0.333333')).
	self assert: ((self materialize: '1.0e100') closeTo: (10 raisedTo: 100)).
	self assert: ((self materialize: '1.0e-100') closeTo: (10 raisedTo: -100)).
	self assert: ((self materialize: '-1.0e-100') closeTo: (10 raisedTo: -100) negated)!

testFraction
	self assert: (self materialize: '1/3') equals: 1/3.
	self assert: (self materialize: '-1/3') equals: -1/3.
	self assert: (self materialize: '100/11') equals: 100/11.
!

testIdentityDictionary
	| collection |
	collection := IdentityDictionary new
				at: 1 put: 1;
				at: 2 put: 2;
				yourself.
	self assert: (self materialize: 'IdentityDictionary{1:1,2:2}') equals: collection.
	self assert: (self materialize: 'IdentityDictionary{}') equals: IdentityDictionary new!

testIllegalCharacterEscapes
	self should: [STON fromString: '''\a'''] raise: ReaderError.
	self should: [STON fromString: '''\u'''] raise: ReaderError.
	self should: [STON fromString: '''\u00'''] raise: ReaderError.
	self should: [STON fromString: '''\u000'''] raise: ReaderError.
	self should: [STON fromString: '''\*'''] raise: ReaderError!

testInteger
	self assert: (self materialize: '1') equals: 1.
	self assert: (self materialize: '-1') equals: -1.
	self assert: (self materialize: '0') equals: 0.
	self assert: (self materialize: '1234567890') equals: 1234567890.
	self assert: (self materialize: '-1234567890') equals: -1234567890!

testJsonString
	"Allow double quotes for backwards JSON compatibility"

	| string |
	self assert: (self materialize: '"foo"') equals: 'foo'.
	self assert: (self materialize: '"FOO"') equals: 'FOO'.
	self assert: (self materialize: '"\u00E9l\u00E8ve en Fran\u00E7ais"') equals: 'élève en Français'.
	string := String withAll: {$".
						$'.
						$\.
						Character tab.
						Character cr.
						Character lf.
						Character newPage.
						Character backspace}.
	self assert: (self materialize: '"\"\''\\\t\r\n\f\b"') equals: string!

testList
	self assert: STON listClass equals: Array.
	self assert: (self materialize: '[1,2,3]')
		equals: (STON listClass
				with: 1
				with: 2
				with: 3).
	self assert: (self materialize: '[]') equals: STON listClass new!

testMap
	self assert: (self materialize: '{#foo:1}')
		equals: (STON mapClass new
				at: #foo put: 1;
				yourself).
	self assert: (self materialize: '{}') equals: STON mapClass new!

testMetaclass
	self assert: (self materialize: 'Metaclass[#Point]') equals: Point class!

testMultiple
	| reader |
	reader := STON reader on: '123 -123 nil #foo true [ 0 ] false { #one : 1 }' readStream.
	self deny: reader atEnd.
	self assert: reader next equals: 123.
	self assert: reader next equals: -123.
	self assert: reader next equals: nil.
	self assert: reader next equals: #foo.
	self assert: reader next equals: true.
	self assert: reader next equals: {0}.
	self assert: reader next equals: false.
	self assert: reader next equals: (Dictionary with: #one -> 1).
	self assert: reader atEnd!

testNewSymbol
	| n notASymbol shouldBeSymbol |
	"Find a name that has not yet been interned"
	n := 0.
	[Symbol hasInterned: (notASymbol := 'notASymbol' , n printString) ifTrue: [:symbol | symbol]]
		whileTrue: [n := n + 1].
	"Parsing the new, not yet interned name should create a new Symbol"
	shouldBeSymbol := self materialize: '#' , notASymbol.
	self assert: (shouldBeSymbol isSymbol and: [notASymbol = shouldBeSymbol asString])!

testNil
	self assert: (self materialize: 'nil') isNil!

testNonBMPCharacterDecoding
	"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

	| string object |
	string := String with: 16r1D11E asCharacter.	"MUSICAL SYMBOL G CLEF"
	object := STON fromString: '''\uD834\uDD1E'''.
	self assert: object equals: string!

testNull
	self assert: (self materialize: 'null') isNil!

testObject
	self assert: (self materialize: 'Point[1,2]') equals: 1 @ 2.
	self assert: (self materialize: 'Point[1.5,-0.5]') equals: 1.5 @ -0.5!

testOrderedCollection
	| collection |
	collection := OrderedCollection with: 1 with: 2 with: 3.
	self assert: (self materialize: 'OrderedCollection[1,2,3]') equals: collection.
	self assert: (self materialize: 'OrderedCollection[]') equals: OrderedCollection new!

testPoint
	self assert: (self materialize: 'Point[1,2]') equals: 1 @ 2!

testReferenceCycle
	| array |
	array := self materialize: '[1,@1]'.
	self assert: array class equals: STON listClass.
	self assert: array size equals: 2.
	self assert: array first equals: 1.
	self assert: array second identicalTo: array!

testReferenceSharing
	| one array |
	one := {#one}.
	array := self materialize: '[[#one],@2,@2]'.
	self assert: array
		equals: (STON listClass
				with: one
				with: one
				with: one).
	self assert: array first identicalTo: array second.
	self assert: array first identicalTo: array third!

testScaledDecimal
	self assert: (self materialize: '1/3s2') equals: 1/3s2.
	self assert: (self materialize: '-1/3s2') equals: -1/3s2.
	self assert: (self materialize: '1/3s10') equals: 1/3s10.
	self assert: (self materialize: '-1/3s10') equals: -1/3s10.
!

testSetWithIndirectReferenceElements
	| elementsCollection set ston object |
	elementsCollection := OrderedCollection
				streamContents: [:out | 10 timesRepeat: [out nextPut: UUID new]].
	set := Set withAll: (elementsCollection collect: [:each | Array with: each]).
	object := Array with: elementsCollection with: set.
	ston := STON toStringPretty: object.
	object := STON fromString: ston.	" readStream"
	object first do: [:each | self assert: (object second includes: (Array with: each))].
	self assert: object second isHealthy!

testSetWithReferenceElements
	| elementsCollection set ston object |
	elementsCollection := OrderedCollection
				streamContents: [:out | 10 timesRepeat: [out nextPut: UUID new]].
	set := Set withAll: elementsCollection.
	object := Array with: elementsCollection with: set.
	ston := STON toStringPretty: object.
	object := STON fromString: ston.	"readStream"
	object first do: [:each | self assert: (object second includes: each)].
	self assert: object second isHealthy!

testStreaming
	| reader |
	reader := STON reader on: '1 2 3 4 5 6 7 8 9 10' readStream.
	self
		assert: (Array streamContents: [:stream | [reader atEnd] whileFalse: [stream nextPut: reader next]])
				sum
		equals: #(1 2 3 4 5 6 7 8 9 10) sum!

testString
	| string |
	self assert: (self materialize: '''foo''') equals: 'foo'.
	self assert: (self materialize: '''FOO''') equals: 'FOO'.
	self assert: (self materialize: '''\u00E9l\u00E8ve en Fran\u00E7ais''')
		equals: 'élève en Français'.
	string := String withAll: {$".
						$'.
						$\.
						$/.
						Character tab.
						Character cr.
						Character lf.
						Character newPage.
						Character backspace}.
	self assert: (self materialize: '''\"\''\\\/\t\r\n\f\b''') equals: string!

testSymbol
	self assert: (self materialize: '#''foo''') equals: #foo.
	self assert: (self materialize: '#foo') equals: #foo!

testTime
	| time |
	time := Time
				hour: 6
				minute: 30
				second: 15.
	self assert: (self materialize: 'Time[''06:30:15'']') equals: time.
	time := Time
				hour: 6
				minute: 30
				second: 15
				nanoSecond: 123.
	self assert: (self materialize: 'Time[''06:30:15.000000123'']') equals: time!

testUnknownClasses
	| input object |
	input := 'FooBar { #foo : 1, #bar : true }'.
	self should: [self materialize: input] raise: ReaderError.
	object := STON reader
				acceptUnknownClasses: true;
				on: input readStream;
				next.
	self assert: object class equals: STON mapClass.
	self assert: (object at: #foo) equals: 1.
	self assert: (object at: #bar).
	self assert: (object at: STON classNameKey) equals: #FooBar!

testUser
	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self assert: (self
				materialize: 'STON.Tests.STONTestUser{#username:''john@foo.com'',#password:''secret1'',#enabled:true}')
		equals: user!

testUser2
	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self assert: (self
				materialize: 'STON.Tests.STONTestUser2{#username:''john@foo.com'',#password:''secret1'',#enabled:true}')
		equals: user!

testWhitespace
	| whitespace |
	whitespace := {Character space. Character tab. Character cr. Character lf}.
	self assert: (self materialize: whitespace , '123') equals: 123!

testWideSymbol
	self assert: (self materialize: '#''яблоко''') equals: #'яблоко'.
	self assert: (self materialize: '#яблоко') equals: #'яблоко'! !
!STON.Tests.ReaderTest categoriesFor: #testAssociation!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testBag!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testBoolean!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testByteArray!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testCharacter!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testClass!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testClassWithUnderscore!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testColor!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testConvertingNewLines!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDate!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDateAndTime!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDeepStructure!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDictionary!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDictionaryWithComplexKeys!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDictionaryWithIndirectReferenceKeys!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testDictionaryWithReferenceKeys!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testError!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testFloat!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testFraction!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testIdentityDictionary!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testIllegalCharacterEscapes!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testInteger!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testJsonString!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testList!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testMap!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testMetaclass!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testMultiple!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testNewSymbol!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testNil!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testNonBMPCharacterDecoding!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testNull!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testObject!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testOrderedCollection!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testPoint!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testReferenceCycle!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testReferenceSharing!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testScaledDecimal!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testSetWithIndirectReferenceElements!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testSetWithReferenceElements!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testStreaming!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testString!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testSymbol!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testTime!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testUnknownClasses!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testUser!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testUser2!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testWhitespace!public!tests! !
!STON.Tests.ReaderTest categoriesFor: #testWideSymbol!public!tests! !

