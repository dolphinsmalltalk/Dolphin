"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'Core.Tests.DurationTest'
	instanceVariableNames: 'savedLocale'
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Tests.DurationTest guid: (Core.GUID fromString: '{3cf86074-481f-4b92-b7ed-6c9cbbe394df}')!

Core.Tests.DurationTest comment: ''!

!Core.Tests.DurationTest methodsFor!

setUp
	super setUp.
	savedLocale := Locale userDefault!

shouldRaiseInvalidFormat: aNiladicValuable
	self should: aNiladicValuable raise: InvalidFormat matching: [:ex | ex tag == Duration]!

tearDown
	savedLocale
		ifNotNil: 
			[Locale userDefault: savedLocale.
			savedLocale := nil].
	super tearDown!

testAbs
	self deny: 1.5 seconds equals: -1.5 seconds.
	self assert: 1.5 seconds abs equals: 1.5 seconds.
	self assert: -1.5 seconds abs equals: 1.5 seconds.
	self assert: -1 nanoseconds abs equals: 1 nanoseconds!

testAdd
	| subject |
	subject := 1.5 seconds.
	self assert: subject + subject isKindOf: Duration.
	self assert: subject + subject equals: 3 seconds.
	self assert: subject + -1 seconds equals: 0.5 seconds.
	self assert: -1 milliseconds + subject equals: 1499 milliseconds!

testAsMicroseconds
	self assert: 1231569 microseconds asMicroseconds equals: 1231569.
	self assert: (1 seconds + 1 nanoseconds) asMicroseconds equals: (1000000001/1000)!

testAsMilliseconds
	self assert: 12315 milliseconds asMilliseconds equals: 12315.
	self assert: 1231569 microseconds asMilliseconds equals: 1231569 / 1000!

testAsSeconds
	"Note that to be Ansi compliant this should return the total number of seconds, including any fractional part."

	self assert: 3625 milliseconds asSeconds equals: 29 / 8.
	self assert: -3625 milliseconds asSeconds equals: -29 / 8.
	self assert: (Duration nanoseconds: 1000000000) asSeconds equals: 1!

testDays
	self assert: 1.5 days days identicalTo: 1.
	self assert: (Duration
				days: 1
				hours: 23
				minutes: 59
				seconds: 59.999999999) days
		equals: 1.
	self assert: (1 days - 1 nanoseconds) days equals: 0!

testDaysHoursMinutesSeconds
	| subject |
	subject := Duration
				days: 2
				hours: -2
				minutes: 3
				seconds: -4.75.
	self assert: subject asSeconds equals: 663101 / 4.
	self assert: subject
		equals: (Duration
				days: 1
				hours: 22
				minutes: 2
				seconds: 55.25)!

testDivide
	| subject |
	subject := 1.5 seconds.
	self assert: subject / 0.5 seconds equals: 3.
	self assert: subject / 0.5 equals: 3 seconds
!

testEquals
	self assert: 1 microseconds equals: 1000 nanoseconds.
	self assert: 1 milliseconds equals: 1000 microseconds.
	self assert: 1 seconds equals: 1000 milliseconds.
	self assert: 1 minutes equals: 60 seconds.
	self assert: 1 hours equals: 60 minutes.
	self assert: 1 days equals: 24 hours.
	self deny: 1 seconds equals: 1.
	self assert: 0 seconds equals: 0 minutes.
	self deny: 0 seconds equals: 0.
	self deny: 15 seconds equals: Object new!

testFromSeconds
	| subject |
	subject := Duration seconds: 3600.
	self assert: subject asSeconds identicalTo: 3600.
	"We can actually represent unlimited precision"
	subject := Duration seconds: 1 / 1000000000000.
	self assert: subject asSeconds equals: 1e-12!

testFromString
	self assert: (Duration fromString: '0:00:00:00') equals: 0 seconds.
	self assert: (Duration fromString: '0:00:00:00.0') equals: 0 seconds.
	self assert: (Duration fromString: '-0:00:00:00.0') equals: 0 seconds.
	self assert: (Duration fromString: '1:00:00:00') equals: 1 days.
	self assert: (Duration fromString: '-123:00:00:00') equals: -123 days.
	self assert: (Duration fromString: '0:01:00:00') equals: 1 hours.
	self assert: (Duration fromString: '0:23:00:00') equals: 23 hours.
	self assert: (Duration fromString: '0:00:01:00') equals: 1 minutes.
	self assert: (Duration fromString: '0:00:59:00') equals: 59 minutes.
	self assert: (Duration fromString: '0:00:00:01') equals: 1 seconds.
	self assert: (Duration fromString: '0:00:00:59.0') equals: 59 seconds.
	self assert: (Duration fromString: '-1:00:00:00') equals: -1 days.
	self assert: (Duration fromString: '-123:00:00:00') equals: -123 days.
	self assert: (Duration fromString: '-0:01:00:00') equals: -1 hours.
	self assert: (Duration fromString: '-0:23:00:00') equals: -23 hours.
	self assert: (Duration fromString: '-0:00:01:00') equals: -1 minutes.
	self assert: (Duration fromString: '-0:00:59:00') equals: -59 minutes.
	self assert: (Duration fromString: '-0:00:00:01') equals: -1 seconds.
	self assert: (Duration fromString: '-0:00:00:59') equals: -59 seconds.
	self assert: (Duration fromString: '-0:00:00:00.1') equals: -100 milliseconds.
	1 to: 9
		do: 
			[:i |
			| string |
			string := String writeStream
						nextPutAll: '0:00:00:00.';
						next: i - 1 put: $0;
						nextPut: $1;
						contents.
			self assert: (Duration fromString: string) equals: (Duration nanoseconds: (9 - i) exp10)].
	self assert: (Duration fromString: '1:02:03:04.000000005')
		equals: 1 days + 2 hours + 3 minutes + 4 seconds + 5 nanoseconds!

testGreaterThan
	"Note that to be Ansi compliant this should return the total number of seconds, including any fractional part."
	self assert: 1 nanoseconds > 0 seconds.
	self deny: 1 nanoseconds > 1 nanoseconds.
	self deny: 1 nanoseconds > 2 nanoseconds.
	self assert: 3 nanoseconds > 2 nanoseconds.
	self assert: 1 nanoseconds > -1 seconds!

testHash
	self assert: 1 microseconds hash equals: 1000 nanoseconds hash.
	self assert: 1 milliseconds hash equals: 1000 microseconds hash.
	self assert: 1 seconds hash equals: 1000 milliseconds hash.
	self assert: 1 minutes hash equals: 60 seconds hash.
	self assert: 1 hours hash equals: 60 minutes hash.
	self assert: 1 days hash equals: 24 hours hash.
	self assert: 1 seconds hash equals: 1 hash.
	self assert: 0 seconds hash equals: 0 minutes hash.
	self assert: 0 seconds hash equals: 0 hash.
	self deny: 15 seconds hash equals: (15 seconds + 1 nanoseconds) hash!

testHours
	self assert: 1.5 days hours identicalTo: 12.
	self
		assert: (Duration
				days: 1
				hours: 23
				minutes: 59
				seconds: 59.999999999) hours
		equals: 23.
	self assert: (-24 * 3600 + 1) seconds hours equals: -23.
	self assert: (1 hours - 1 nanoseconds) hours equals: 0.
	self assert: -1 nanoseconds hours equals: 0!

testHoursMinutes
	| subject |
	subject := Duration hours: 2 minutes: 3.
	self assert: subject asSeconds equals: (2 * 60 + 3) * 60!

testHumanReadablePrintString
	self assert: -2.1 days humanReadablePrintString equals: '-2.1 days'.
	self assert: 2 days humanReadablePrintString equals: '2 days'.
	self assert: 1.5 days humanReadablePrintString equals: '36 hours'.
	self assert: (2 days - 1 nanoseconds) humanReadablePrintString equals: '48 hours'.
	self assert: 2.505 days humanReadablePrintString equals: '2.51 days'.
	self assert: 2 hours humanReadablePrintString equals: '2 hours'.
	self assert: 1.5 hours humanReadablePrintString equals: '90 minutes'.
	self assert: (2 hours - 15 seconds) humanReadablePrintString equals: '119.75 minutes'.
	self assert: 2.505 hours humanReadablePrintString equals: '2.51 hours'.
	self assert: 119.99 minutes humanReadablePrintString equals: '119.99 minutes'.
	self assert: 119.999 minutes humanReadablePrintString equals: '120 minutes'.
	self assert: 2 minutes humanReadablePrintString equals: '2 minutes'.
	self assert: (2 minutes - 1 nanoseconds) humanReadablePrintString equals: '120 s'.
	self assert: 1 seconds humanReadablePrintString equals: '1 s'.
	self assert: 1000 milliseconds humanReadablePrintString equals: '1 s'.
	self assert: (1 seconds - 1 nanoseconds) humanReadablePrintString equals: '1000 ms'.
	self assert: 1000 microseconds humanReadablePrintString equals: '1 ms'.
	self assert: (1 milliseconds - 1 nanoseconds) humanReadablePrintString equals: '1000 µs'.
	self assert: (1 microseconds - 1 nanoseconds) humanReadablePrintString equals: '999 ns'.
	self assert: 1 nanoseconds humanReadablePrintString equals: '1 ns'.
	self assert: (9 / 10) nanoseconds humanReadablePrintString equals: '0 s'.
	self assert: 0 days humanReadablePrintString equals: '0 s'!

testISO8601ParsingBasic
	self assert: (Duration fromString: 'P2D') equals: 2 days.
	self assert: (Duration fromString: '-P1D') equals: -24 hours.
	self assert: (Duration fromString: 'PT23H') equals: 23 hours.
	self assert: (Duration fromString: 'PT36H') equals: 1 days + 12 hours.
	self assert: (Duration fromString: 'PT59M') equals: 59 minutes.
	self assert: (Duration fromString: 'PT123S') equals: 123 seconds.
	self assert: (Duration fromString: 'P4DT12H30M5S')
		equals: 4 days + 12 hours + 30 minutes + 5 seconds.
	self assert: (Duration fromString: '-P3DT18H') equals: -3.75 days.
	"There is no Dolphin imposed limit, within the bounds of memory, on the size of individual time elements. Such Durations are unlikely to be interchangeable with other systems, however."
	self assert: (Duration fromString: 100 factorial days asString) equals: 100 factorial days!

testISO8601ParsingExtraInput
	"Invalid IS08601 - Extraneous input at end"

	{ 'PDT1S2'. 1 seconds. 'P4D🐬'. 4 days. 'P0.75DS'. 0.75 days } pairsDo: 
			[:string :expected |
			| stream actual |
			self shouldRaiseInvalidFormat: [Duration fromString: string].
			stream := string readStream.
			actual := Duration readFrom: stream.
			self assert: actual equals: expected.
			self assert: stream next equals: string asArray last.
			self assert: stream atEnd]!

testISO8601ParsingFractions
	"Decimal point an be full stop or comma. Fraction is only allowed on the smallest (last) component, although can be fractional days, hours, minutes or seconds. There is no practical limit on the precision as Dolphin will use fractional arithmetic, but the likelihood is that any other system with which the ISO8601 values are interchanged will impose a limit. The standard states that the systems need to agree a limit. When printing Durations in ISO8601 format we limit the fraction to 9 decimal places (i.e. nanoseconds), which is a reasonable maximum precision. Equally we allow unbounded values for any of the elements."

	self
		assert: (Duration fromString: 'PT59.123456789S')
		closeTo: 59.123456789 seconds
		precision: 1 nanoseconds.
	self assert: (Duration fromString: 'P1DT2H3M4.1S')
		equals: 1 days + 2 hours + 3 minutes + 4.1 seconds.
	self assert: (Duration fromString: 'PT1,0S') equals: 1 seconds.
	self assert: (Duration fromString: '-P0,5D') equals: -12 hours.
	self assert: (Duration fromString: 'PT0.5H') equals: 30 minutes.
	self assert: (Duration fromString: 'PT0.000000001S') equals: 1 nanoseconds.
	self assert: (Duration fromString: 'PT1M0.0S') equals: 1 minutes.
	self assert: (Duration fromString: 'PT1H0,0M') equals: 1 hours!

testISO8601ParsingIncomplete
	"Invalid IS08601 - Incomplete"

	#('P' 'PT' 'P1' 'T' '1S' 'P2DT' 'P1D2')
		do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingInvalidQualifiers
	"Invalid IS08601 - Invalid components"

	#('P4Q' 'PT4D' 'P4T') do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingMisplacedFractions
	"Invalid IS08601 - Only the last component can have fractional amount"

	#('P0.5DT1S' 'PT0.5H1S' 'PT0.0H0.1S')
		do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingNegativeElements
	"Invalid IS08601 - The elements must be positive"

	#('P-1D' '-PT-1S') do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingRepeatedElements
	"Invalid IS08601 - Repeated components"

	#('PT3M4M' 'PT3H2M5H') do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingUnsupported
	"Valid ISO8601, but not supported by Duration"

	#('P3Y' 'P2W' 'P4M' 'P3Y6M4DT12H30M5S' 'P0,5Y' 'P0003-06-04T12:30:05')
		do: [:each | self shouldRaiseInvalidFormat: [Duration fromString: each]]!

testISO8601ParsingZeroes
	"Zeroes"

	#('P0D' 'P0DT0H0M0.0S' 'P0DT0S' 'PT0,0H' 'PT0M' 'PT0S' 'PT0.0S') do: 
			[:each |
			self assert: (Duration fromString: each) equals: 0 seconds.
			self assert: (Duration fromString: '-' , each) equals: 0 seconds].

	"Zero leading or trailing components are allowed and effectively ignored."
	#('P0DT0H0M1S' 'P0DT1S' 'PT0H0M1S' 'PT0M1S') do: 
			[:each |
			self assert: (Duration fromString: each) equals: 1 seconds.
			self assert: (Duration fromString: '-' , each) equals: -1 seconds].
	self assert: (Duration fromString: '-P4DT0H0M0S') equals: -4 days.
	self assert: (Duration fromString: 'P0DT30M0S') equals: 30 minutes!

testISO8601Printing
	self assert: 2 days asString equals: 'P2D'.
	self assert: 24 hours asString equals: 'P1D'.
	self assert: 23 hours asString equals: 'PT23H'.
	self assert: 36 hours asString equals: 'P1DT12H'.
	self assert: 59 minutes asString equals: 'PT59M'.
	self assert: 0 seconds asString equals: 'PT0S'.
	self assert: -1 seconds asString equals: '-PT1S'.
	self assert: (4 days + 12 hours + 30 minutes + 5 seconds) asString equals: 'P4DT12H30M5S'.
	self assert: -3.75 days asString equals: '-P3DT18H'.
	{ Locale named: 'en-GB'. Locale named: 'fr-FR' } do: 
			[:each |
			| decimalSeparator |
			Locale userDefault: each.
			decimalSeparator := each decimalSeparator.
			self assert: 59.1234567891 seconds asString equals: 'PT59<s>123456789S' << decimalSeparator.
			self assert: (1 days + 2 hours + 3 minutes + 4.1 seconds) asString
				equals: 'P1DT2H3M4<s>1S' << decimalSeparator.
			self assert: 1 nanoseconds asUtf16String equals: 'PT0<s>000000001S' << decimalSeparator].
	"Note that we truncate the fractional seconds to nanoseconds when printing, although internally the precision is unlimited."
	self assert: (123456789654321 / 1e15) seconds asString equals: 'PT0,123456789S'!

testLessThan
	| subject |
	subject := 1.5 seconds.
	self deny: subject < subject.
	self assert: subject < 1500000001 nanoseconds.
	self deny: subject < ((1500000000-1) nanoseconds).
	self deny: subject < -1 minutes.
	self deny: 1 nanoseconds < 0 seconds.
	self deny: 1 nanoseconds < 1 nanoseconds.
	self assert: 1 nanoseconds < 2 nanoseconds.
	self deny: 3 nanoseconds < 2 nanoseconds.
	self deny: 1 nanoseconds < -1 seconds.
	self assert: -1 days < 0 seconds!

testMilliseconds
	self assert: 12315 milliseconds milliseconds equals: 315.
	self assert: 1001569 microseconds milliseconds equals: 1569 / 1000!

testMinutes
	self assert: 1.5 hours minutes identicalTo: 30.
	self
		assert: (Duration
				days: 1
				hours: 23
				minutes: 59
				seconds: 59.999999999) minutes
		equals: 59.
	self assert: (-24 * 3600 + 1) seconds minutes equals: -59.
	self assert: (1 minutes - 1 nanoseconds) minutes equals: 0.
	self assert: -1 nanoseconds minutes equals: 0!

testMultiply
	| subject |
	subject := 1.5 seconds.
	self assert: subject * 40 isKindOf: Duration.
	self assert: subject * 40 equals: 1 minutes.
	self assert: subject * 1.5 equals: 2.25 seconds.
	self should: [subject * subject] raise: MessageNotUnderstood!

testNegated
	self assert: 1 nanoseconds negated equals: -1 nanoseconds.
	self assert: -1 nanoseconds negated equals: 1 nanoseconds!

testNegative
	self deny: 1 nanoseconds negative.
	self assert: -1 nanoseconds negative!

testNumberDays
	| subject |
	subject := 2 days.
	self assert: subject asSeconds equals: 48 * 3600.
	subject := 1.5 days.
	self assert: subject asSeconds equals: 36 * 3600.
	"Can be negative"
	subject := -365 days.
	self assert: subject asSeconds equals: -24*3600*365.
	"1 nanosecond"
	subject := (1 / (1000000000 * 24 * 3600)) days.
	self assert: subject asSeconds equals: 1 / 1000000000!

testNumberHours
	| subject |
	subject := 2 hours.
	self assert: subject asSeconds equals: 2 * 3600.
	subject := 1.5 hours.
	self assert: subject asSeconds equals: 3 * 1800.
	self assert: 24 hours equals: 1 days.
	"1 nanosecond"
	subject := (1 / (1000000000 * 3600)) hours.
	self assert: subject asSeconds equals: 1 / 1000000000!

testNumberMicroseconds
	| subject |
	subject := 999 microseconds.
	self assert: subject asSeconds equals: 999/1e6.
	subject := 1.5 microseconds.
	self assert: subject asSeconds equals: 15/1e7.
	self assert: 1000 microseconds equals: 1 milliseconds.
	"1 nanosecond"
	subject := (1 / 1000) microseconds.
	self assert: subject asSeconds equals: 1 / 1000000000!

testNumberMilliseconds
	| subject |
	subject := 999 milliseconds.
	self assert: subject asSeconds equals: 999/1000.
	subject := 1.5 milliseconds.
	self assert: subject asSeconds equals: 15/10000.
	self assert: 1000 milliseconds equals: 1 seconds.
	"1 nanosecond"
	subject := (1 / 1000000) milliseconds.
	self assert: subject asSeconds equals: 1 / 1000000000!

testNumberMinutes
	| subject |
	subject := 59 minutes.
	self assert: subject asSeconds equals: 59 * 60.
	subject := 1.5 minutes.
	self assert: subject asSeconds equals: 3 * 30.
	self assert: 60 minutes equals: 1 hours.
	"1 nanosecond"
	subject := (1 / (1000000000 * 60)) minutes.
	self assert: subject asSeconds equals: 1 / 1000000000!

testNumberNanoseconds
	| subject |
	subject := 999 nanoseconds.
	self assert: subject asSeconds equals: 999/1e9.
	subject := 1.5 nanoseconds.
	self assert: subject asSeconds equals: 15/1e10.
	self assert: 1000 nanoseconds equals: 1 microseconds.
	"1 nanosecond"
	subject := 1 nanoseconds .
	self assert: subject asSeconds equals: 1 / 1000000000.
	self assert: subject nanoseconds equals: 1.
	"Or even less"
	subject := 1e-3 nanoseconds.
	self assert: subject asSeconds equals: 1e-12!

testNumberSeconds
	| subject |
	subject := 59 seconds.
	self assert: subject asSeconds equals: 59.
	subject := 1.5 seconds.
	self assert: subject asSeconds equals: 3 / 2.
	self assert: 60 seconds equals: 1 minutes.
	"1 nanosecond"
	subject := (1 / 1000000000) seconds.
	self assert: subject asSeconds equals: 1 / 1000000000.
	self assert: subject asNanoseconds equals: 1!

testPositive
	self assert: 1 nanoseconds positive.
	self deny: -1 nanoseconds positive!

testPrintString
	self assert: (Duration seconds: 24 * 3600 + 1) printString equals: '1:00:00:01'.
	self assert: (9 hours + 9 minutes + 9 seconds) printString equals: '0:09:09:09'.
	self assert: -1 nanoseconds printString equals: '-0:00:00:00.000000001'.
	self assert: ((Duration seconds: 24 * 3600) - 1 nanoseconds) printString
		equals: '0:23:59:59.999999999'.
	self assert: 9100 milliseconds printString equals: '0:00:00:09.1'.
	self assert: 42.5 milliseconds printString equals: '0:00:00:00.0425'.
	"There should not be any trailing zeroes on any fractional part"
	self assert: 1 seconds printString equals: '0:00:00:01'.
	self assert: 1 milliseconds printString equals: '0:00:00:00.001'.
	self assert: 1 microseconds printString equals: '0:00:00:00.000001'.
	0 to: 8
		do: 
			[:i |
			| nanos expected |
			nanos := 10 raisedToInteger: i.
			expected := String writeStream.
			expected nextPutAll: '0:00:00:00.'.
			8 - i timesRepeat: [expected nextPut: $0].
			expected nextPut: $1.
			expected := expected contents.
			self assert: nanos nanoseconds printString equals: expected]!

testSpaceships
	{{1 nanoseconds. 0 seconds. 1}.
		{0 nanoseconds. 1 nanoseconds. -1}.
		{1 nanoseconds. 1 nanoseconds. 0}.
		{1 nanoseconds. 2 nanoseconds. -1}.
		{3 nanoseconds. 2 nanoseconds. 1}.
		{1 nanoseconds. -1 seconds. 1}} do: 
				[:each |
				self assert: each first <=> each second equals: each third.
				self assert: each first <==> each second equals: each third.
				self assert: each second <=> each first equals: each third negated.
				self assert: each second <==> each first equals: each third negated]!

testStoreOn
	| stored collection |
	collection := OrderedCollection new
				add: 1 nanoseconds;
				add: 1 microseconds;
				add: 1 milliseconds;
				add: 1 seconds;
				add: 1 days;
				add: 364 days + 23 hours + 59 minutes + 59.999999999 seconds.
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection!

testSubtract
	| subject |
	subject := 1.5 seconds.
	self assert: subject - subject equals: 0 seconds.
	subject := 1.5 hours.
	self assert: subject - -1800 seconds  equals: 2 hours! !

!Core.Tests.DurationTest categoriesForMethods!
setUp!public!running! !
shouldRaiseInvalidFormat:!helpers!private! !
tearDown!public!running! !
testAbs!public!unit tests! !
testAdd!public!unit tests! !
testAsMicroseconds!public!unit tests! !
testAsMilliseconds!public!unit tests! !
testAsSeconds!public!unit tests! !
testDays!public!unit tests! !
testDaysHoursMinutesSeconds!public!unit tests! !
testDivide!public!unit tests! !
testEquals!public!unit tests! !
testFromSeconds!public!unit tests! !
testFromString!public!unit tests! !
testGreaterThan!public!unit tests! !
testHash!public!unit tests! !
testHours!public!unit tests! !
testHoursMinutes!public!unit tests! !
testHumanReadablePrintString!public!unit tests! !
testISO8601ParsingBasic!public!unit tests! !
testISO8601ParsingExtraInput!public!unit tests! !
testISO8601ParsingFractions!public!unit tests! !
testISO8601ParsingIncomplete!public!unit tests! !
testISO8601ParsingInvalidQualifiers!public!unit tests! !
testISO8601ParsingMisplacedFractions!public!unit tests! !
testISO8601ParsingNegativeElements!public!unit tests! !
testISO8601ParsingRepeatedElements!public!unit tests! !
testISO8601ParsingUnsupported!public!unit tests! !
testISO8601ParsingZeroes!public!unit tests! !
testISO8601Printing!public!unit tests! !
testLessThan!public!unit tests! !
testMilliseconds!public!unit tests! !
testMinutes!public!unit tests! !
testMultiply!public!unit tests! !
testNegated!public!unit tests! !
testNegative!public!unit tests! !
testNumberDays!public!unit tests! !
testNumberHours!public!unit tests! !
testNumberMicroseconds!public!unit tests! !
testNumberMilliseconds!public!unit tests! !
testNumberMinutes!public!unit tests! !
testNumberNanoseconds!public!unit tests! !
testNumberSeconds!public!unit tests! !
testPositive!public!unit tests! !
testPrintString!public!unit tests! !
testSpaceships!public!unit tests! !
testStoreOn!public!testing! !
testSubtract!public!unit tests! !
!

