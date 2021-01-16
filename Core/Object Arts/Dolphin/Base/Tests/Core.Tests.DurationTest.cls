"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.DurationTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DurationTest guid: (Core.GUID fromString: '{3cf86074-481f-4b92-b7ed-6c9cbbe394df}')!
Core.Tests.DurationTest comment: ''!
!Core.Tests.DurationTest categoriesForClass!Unclassified! !
!Core.Tests.DurationTest methodsFor!

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
!Core.Tests.DurationTest categoriesFor: #testAbs!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testAdd!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testAsMicroseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testAsMilliseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testAsSeconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testDays!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testDaysHoursMinutesSeconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testDivide!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testEquals!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testFromSeconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testFromString!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testGreaterThan!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testHash!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testHours!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testLessThan!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testMilliseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testMinutes!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testMultiply!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNegated!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNegative!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberDays!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberHours!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberMicroseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberMilliseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberMinutes!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberNanoseconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testNumberSeconds!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testPositive!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testPrintString!public!unit tests! !
!Core.Tests.DurationTest categoriesFor: #testStoreOn!public!testing! !
!Core.Tests.DurationTest categoriesFor: #testSubtract!public!unit tests! !

