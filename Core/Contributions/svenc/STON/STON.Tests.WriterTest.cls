"Filed out from Dolphin Smalltalk 7"!

STON.Tests.STONTestCase subclass: #'STON.Tests.WriterTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
STON.Tests.WriterTest guid: (Core.GUID fromString: '{c786d815-b405-4113-a350-3ee3370c7879}')!
STON.Tests.WriterTest comment: ''!
!STON.Tests.WriterTest categoriesForClass!STON-Tests-Writer! !
!STON.Tests.WriterTest methodsFor!

serialize: anObject
	^String streamContents: 
			[:stream |
			STON writer
				on: stream;
				nextPut: anObject]!

serializeAsciiOnly: anObject
	^String streamContents: 
			[:stream |
			STON writer
				on: stream;
				asciiOnly: true;
				nextPut: anObject]!

serializeJson: anObject
	^String streamContents: 
			[:stream |
			STON jsonWriter
				on: stream;
				nextPut: anObject]!

serializePretty: anObject
	^String streamContents: 
			[:stream |
			STON writer
				on: stream;
				prettyPrint: true;
				nextPut: anObject]!

testAssociation
	self assert: (self serialize: 'foo' -> 1) equals: '''foo'':1'.
	self assert: (self serialize: #bar -> 2) equals: '#bar:2'.
	self assert: (self serialize: 'foo bar' -> #ok) equals: '''foo bar'':#ok'.
	self assert: (self serialize: 123 -> 456) equals: '123:456'!

testBag
	self assert: (self serialize: (Bag withAll: #(#a #a))) equals: 'Bag{#a:2}'.
	self assert: (self serialize: Bag new) equals: 'Bag{}'!

testBoolean
	self assert: (self serialize: true) equals: 'true'.
	self assert: (self serialize: false) equals: 'false'!

testByteArray
	self assert: (self serialize: #(1 2 3) asByteArray) equals: 'ByteArray[''010203'']'!

testClass
	self assert: (self serialize: Point) equals: 'Class[#Point]'!

testColor
	self 
		assert: (self serialize: Color red) 
		equals: 'Color[#red]'.
	self 
		assert: (self serialize: (Color red copy setAlpha: 0.4)) 
		equals: 'Color{#red:1.0,#green:0.0,#blue:0.0,#alpha:0.4}'.
	"This test is sensitive to the precision of the representation. As Color's in Dolphin have only 255 distinct values for each of the primary colours, rounding error gives a different result."
	self 
		assert: (self serialize: Color red lighter lighter) 
		equals: 'Color{#red:1.0,#green:0.063,#blue:0.063,#alpha:1.0}' "'Color{#red:1.0,#green:0.061,#blue:0.061,#alpha:1.0}'."
!

testCustomNewline
	| output |
	output := String streamContents: 
					[:out |
					(STON writer on: out)
						newLine: String lf;
						prettyPrint: true;
						nextPut: #(1)].
	#dolphin.	"withCRs does not behave in a portable manner"
	self assert: output equals: ('[\	1\]' withCRs copyWithout: Character cr)	"replaceAll: Character cr with: Character lf"!

testDate
	| date |
	self skip.	"Dolphin's legacy Dates do not support TZ offset."
	date := (Date
				year: 2012
				month: 1
				day: 1) translateToUTC.
	self assert: (self serialize: date) equals: 'Date[''2012-01-01Z'']'.
	date := (Date
				year: 2012
				month: 1
				day: 1) translateTo: 1 hour.
	self assert: (self serialize: date) equals: 'Date[''2012-01-01+01:00'']'!

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
	self assert: (self serialize: dateAndTime) equals: 'DateAndTime[''2012-01-01T06:30:15+01:00'']'!

testDictionary
	| collection |
	collection := STON mapClass new
				at: 1 put: 1;
				at: 2 put: 2;
				yourself.
	self assert: (self serialize: collection) equals: '{1:1,2:2}'.
	self assert: (self serialize: STON mapClass new) equals: '{}'!

testDictionaryWithComplexKeys
	| collection |
	collection := STON mapClass new
				at: true put: 1;
				at: #(#foo) put: 2;
				yourself.
	self assert: (#('{true:1,[#foo]:2}' '{[#foo]:2,true:1}') includes: (self serialize: collection))!

testDoubleQuotedString
	| string |
	self assert: (self serializeJson: 'foo') equals: '"foo"'.
	self assert: (self serializeJson: 'FOO') equals: '"FOO"'.
	self assert: (self serializeJson: 'élève en Français') equals: '"élève en Français"'.
	string := String withAll: {$".
						$'.
						$\.
						$/.
						Character tab.
						Character cr.
						Character lf.
						Character newPage.
						Character backspace}.
	"Note that in JSON mode, double quotes get escaped, and single quotes not"
	self assert: (self serializeJson: string) equals: '"\"''\\/\t\r\n\f\b"'!

testEmptyArrayPretty
	self assert: (self serializePretty: STON listClass new) equals: '[ ]'!

testEmptyDictionaryPretty
	self assert: (self serializePretty: STON mapClass new) equals: '{ }'!

testFloat
	self assert: (self serialize: 1.5) equals: '1.5'.
	self assert: (self serialize: 0.0) equals: '0.0'.
	self assert: (self serialize: -1.5) equals: '-1.5'.
	self assert: ((self serialize: Float pi) beginsWith: '3.14159').
	self assert: ((self serialize: (1 / 3) asFloat) beginsWith: '0.333').
	self assert: (self serialize: (10 raisedTo: 100) asFloat) equals: '1.0e100'.
	self assert: (self serialize: (10 raisedTo: -50) asFloat) equals: '1.0e-50'.
	self assert: (self serialize: (10 raisedTo: -50) asFloat negated) equals: '-1.0e-50'!

testFraction
	self assert: (self serialize: 1/3) equals: '1/3'.
	self assert: (self serialize: -1/3) equals: '-1/3'.
	self assert: (self serialize: 10/100) equals: '1/10'.
	self assert: (self serialize: 100/10) equals: '10'.
	self assert: (self serialize: 123/123) equals: '1'.
	self assert: (self serialize: 100/11) equals: '100/11'.!

testIdentityDictionary
	| collection |
	collection := IdentityDictionary new
				at: 1 put: 1;
				at: 2 put: 2;
				yourself.
	self assert: (self serialize: collection) equals: 'IdentityDictionary{1:1,2:2}'.
	self assert: (self serialize: IdentityDictionary new) equals: 'IdentityDictionary{}'!

testInteger
	self assert: (self serialize: 1) equals: '1'.
	self assert: (self serialize: 0) equals: '0'.
	self assert: (self serialize: -1) equals: '-1'.
	self assert: (self serialize: 1234567890) equals: '1234567890'.
	self assert: (self serialize: -1234567890) equals: '-1234567890'!

testIsSimpleSymbol
	self assert: (STON writer isSimpleSymbol: #foo).
	self assert: (STON writer isSimpleSymbol: #az).
	self assert: (STON writer isSimpleSymbol: #AZ).
	self assert: (STON writer isSimpleSymbol: #N0123456789).
	self assert: (STON writer isSimpleSymbol: #foo123).
	self assert: (STON writer isSimpleSymbol: #'Foo/Bar').
	self assert: (STON writer isSimpleSymbol: #'Foo.Bar').
	self assert: (STON writer isSimpleSymbol: #'Foo-Bar').
	self assert: (STON writer isSimpleSymbol: #Foo_Bar).
	self assert: (STON writer isSimpleSymbol: #foo).
	self deny: (STON writer isSimpleSymbol: #'#^&$%')!

testKeepingNewLines
	| input result output |
	input := 'line ending with CR' , String cr , 'line ending with LF' , String lf
				, 'line ending with CRLF' , String crlf.
	output := '''line ending with CR' , String crlf , 'line ending with LF' , String crlf
				, 'line ending with CRLF' , String crlf
				, ''''.
	result := String streamContents: 
					[:out |
					(STON writer on: out)
						newLine: String crlf;
						keepNewLines: true;
						nextPut: input].
	self assert: result equals: output.
	output := '''line ending with CR' , String cr , 'line ending with LF' , String cr
				, 'line ending with CRLF' , String cr
				, ''''.
	result := String streamContents: 
					[:out |
					(STON writer on: out)
						newLine: String cr;
						keepNewLines: true;
						nextPut: input].
	self assert: result equals: output!

testList
	self assert: (self serialize: (STON listClass withAll: #(1 2 3))) equals: '[1,2,3]'.
	self assert: (self serialize: STON listClass new) equals: '[]'.
	self assert: (self serialize: (STON listClass withAll: {1. -1. 0. #foo. 'a b c'. true. false. nil}))
		equals: '[1,-1,0,#foo,''a b c'',true,false,nil]'!

testMap
	| map serialized |
	(map := STON mapClass new)
		at: #foo put: 1;
		at: #bar put: 2.
	#dolphin.	"Test should not assume any ordering of pairs"
	serialized := self serialize: map.
	self assert: (serialized = '{#foo:1,#bar:2}' or: [serialized = '{#bar:2,#foo:1}']).
	self assert: (self serialize: STON mapClass new) equals: '{}'.
	map removeAll.
	map at: 'foo bar' put: #ok.
	self assert: (self serialize: map) equals: '{''foo bar'':#ok}'.
	map removeAll.
	map at: 123 put: 456.
	self assert: (self serialize: map) equals: '{123:456}'!

testMetaclass
	self assert: (self serialize: Point class) equals: 'Metaclass[#Point]'!

testNil
	self assert: (self serialize: nil) equals: 'nil'!

testNonBMPCharacterEncoding
	"Characters not in the Basic Multilingual Plane are encoded as a UTF-16 surrogate pair"

	| string json |
	string := String with: 16r1D11E asCharacter.	"MUSICAL SYMBOL G CLEF"
	json := String streamContents: 
					[:out |
					(STON writer on: out)
						asciiOnly: true;
						nextPut: string].
	self assert: json equals: '''\uD834\uDD1E'''!

testNull
	self assert: (self serializeJson: nil) equals: 'null'!

testOrderedCollection
	| collection |
	collection := OrderedCollection with: 1 with: 2 with: 3.
	self assert: (self serialize: collection) equals: 'OrderedCollection[1,2,3]'.
	self assert: (self serialize: OrderedCollection new) equals: 'OrderedCollection[]'!

testPoint
	self assert: (self serialize: 1 @ 2) equals: 'Point[1,2]'!

testReferenceCycle
	| array |
	array := STON listClass with: 1 with: nil.
	array at: 2 put: array.
	self assert: (self serialize: array) equals: '[1,@1]'!

testReferenceSharing
	| array one |
	one := {#one}.
	array := STON listClass
				with: one
				with: one
				with: one.
	self assert: (self serialize: array) equals: '[[#one],@2,@2]'!

testReferenceSharingError
	| serializer array one |
	serializer := 
			[:object |
			String streamContents: 
					[:stream |
					STON writer
						on: stream;
						referencePolicy: #error;
						nextPut: object]].
	one := {#one}.
	array := STON listClass
				with: one
				with: one
				with: one.
	self should: [(serializer value: array) = '[[#one],[#one],[#one]]'] raise: WriterError!

testReferenceSharingIgnore
	| serializer array one |
	serializer := 
			[:object |
			String streamContents: 
					[:stream |
					STON writer
						on: stream;
						referencePolicy: #ignore;
						nextPut: object]].
	one := {#one}.
	array := STON listClass
				with: one
				with: one
				with: one.
	self assert: (serializer value: array) equals: '[[#one],[#one],[#one]]'!

testRestrictedClassesInJsonMode
	self should: [self serializeJson: 1 @ 2] raise: WriterError.
	self should: [self serializeJson: #foo -> 100] raise: WriterError.
	self should: [self serializeJson: STONTestUser dummy] raise: WriterError!

testScaledDecimal
	self assert: (self serialize: 1/3s2) equals: '1/3s2'.
	self assert: (self serialize: -1/3s2) equals: '-1/3s2'.
	self assert: (self serialize: 1/3s10) equals: '1/3s10'.
	self assert: (self serialize: -1/3s10) equals: '-1/3s10'.!

testString
	| string |
	self assert: (self serialize: 'foo') equals: '''foo'''.
	self assert: (self serialize: 'FOO') equals: '''FOO'''.
	self assert: (self serializeAsciiOnly: 'élève en Français')
		equals: '''\u00E9l\u00E8ve en Fran\u00E7ais'''.
	self assert: (self serialize: 'élève en Français') equals: '''élève en Français'''.
	string := String withAll: {$".
						$'.
						$\.
						$/.
						Character tab.
						Character cr.
						Character lf.
						Character newPage.
						Character backspace}.
	self assert: (self serialize: string) equals: '''"\''\\/\t\r\n\f\b'''!

testSymbol
	self assert: (self serialize: #foo) equals: '#foo'.
	self assert: (self serialize: #FOO) equals: '#FOO'.
	self assert: (self serialize: #bytes) equals: '#bytes'.
	self assert: (self serialize: #'foo.bar') equals: '#foo.bar'.
	self assert: (self serialize: #'foo-bar') equals: '#foo-bar'.
	self assert: (self serialize: #foo_bar) equals: '#foo_bar'.
	self assert: (self serialize: #'foo/bar') equals: '#foo/bar'.
	self assert: (self serialize: #'foo bar') equals: '#''foo bar'''.
	self assert: (self serialize: #foo123) equals: '#foo123'!

testSymbolAsString
	self assert: (self serializeJson: #foo) equals: '"foo"'.
	self assert: (self serializeJson: #FOO) equals: '"FOO"'!

testTime
	| time |
	time := Time
				hour: 6
				minute: 30
				second: 15.
	self assert: (self serialize: time) equals: 'Time[''06:30:15'']'.
	time := Time
				hour: 6
				minute: 30
				second: 15
				nanoSecond: 123.
	self assert: (self serialize: time) equals: 'Time[''06:30:15.000000123'']'!

testUser
	| user |
	(user := STONTestUser new)
		username: 'john@foo.com';
		password: 'secret1'.
	self assert: (self serialize: user)
		equals: 'TestUser{#username:''john@foo.com'',#password:''secret1'',#enabled:true}'!

testUser2
	| user |
	(user := STONTestUser2 new)
		username: 'john@foo.com';
		password: 'secret1'.
	self assert: (self serialize: user)
		equals: 'TestUser2{#username:''john@foo.com'',#password:''secret1'',#enabled:true}'!

testUser3Nil
	| user |
	user := STONTestUser3 new.
	self assert: (self serialize: user) equals: 'TestUser3{#username:nil,#password:nil,#enabled:true}'!

testUserNil
	| user |
	user := STONTestUser new.
	self assert: (self serialize: user) equals: 'TestUser{#enabled:true}'! !
!STON.Tests.WriterTest categoriesFor: #serialize:!private! !
!STON.Tests.WriterTest categoriesFor: #serializeAsciiOnly:!private! !
!STON.Tests.WriterTest categoriesFor: #serializeJson:!private! !
!STON.Tests.WriterTest categoriesFor: #serializePretty:!private! !
!STON.Tests.WriterTest categoriesFor: #testAssociation!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testBag!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testBoolean!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testByteArray!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testClass!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testColor!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testCustomNewline!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testDate!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testDateAndTime!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testDictionary!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testDictionaryWithComplexKeys!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testDoubleQuotedString!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testEmptyArrayPretty!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testEmptyDictionaryPretty!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testFloat!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testFraction!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testIdentityDictionary!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testInteger!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testIsSimpleSymbol!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testKeepingNewLines!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testList!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testMap!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testMetaclass!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testNil!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testNonBMPCharacterEncoding!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testNull!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testOrderedCollection!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testPoint!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testReferenceCycle!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testReferenceSharing!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testReferenceSharingError!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testReferenceSharingIgnore!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testRestrictedClassesInJsonMode!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testScaledDecimal!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testString!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testSymbol!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testSymbolAsString!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testTime!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testUser!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testUser2!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testUser3Nil!public!tests! !
!STON.Tests.WriterTest categoriesFor: #testUserNil!public!tests! !

