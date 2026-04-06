"Filed out from Dolphin Smalltalk"!

Core.Tests.DolphinTest
	subclass: #'OS.Tests.FILETIMETest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Tests.FILETIMETest guid: (Core.GUID fromString: '{60160261-ed86-485b-834c-ef305dad3be9}')!

OS.Tests.FILETIMETest comment: ''!

!OS.Tests.FILETIMETest methodsFor!

assertFromIntegerInvertible: anInteger
	self assert: (FILETIME fromInteger: anInteger) asInteger equals: (anInteger bitAnd: 2 ** 64 - 1)!

testComparing
	| examples |
	examples := {
				FILETIME fromInteger: FILETIME.SmalltalkEpoch.
				FILETIME fromInteger: FILETIME.SmalltalkEpoch - 1.
				FILETIME fromInteger: FILETIME.SmalltalkEpoch + 1.
				FILETIME fromInteger: 134138194971234567.
				FILETIME maximum.
				FILETIME minimum
			}.
	1 to: examples size
		do: 
			[:i |
			1 to: examples size
				do: 
					[:j |
					| ft2 ft1 |
					ft1 := examples at: i.
					ft2 := examples at: j.
					i == j
						ifTrue: 
							[self assert: ft1 equals: ft2.
							self assert: ft2 equals: ft1.
							self assert: ft1 hash equals: ft2 hash]
						ifFalse: 
							[self deny: ft1 equals: ft2.
							self deny: ft2 equals: ft1.
							self deny: ft1 hash equals: ft2 hash]]]!

testDateAndTimeConversions
	| epoch subject expected |
	epoch := DateAndTime
				year: 1601
				day: 1
				offset: 0 seconds.
	subject := FILETIME new.
	self assert: subject printString equals: 'a FILETIME( 1601-01-01T00:00:00+00:00)'.
	self assert: subject asDateAndTime equals: epoch.
	self assert:  (FILETIME fromDateAndTime: epoch) equals: subject.
	"Some boundary conditions"
	subject := FILETIME new value: FILETIME.SmalltalkEpoch.
	expected := DateAndTime fromString: '1901-01-01T00:00:00Z'.
	self assert: subject asDateAndTime equals: expected.
	self assert:  (FILETIME fromDateAndTime: expected) equals: subject.
	subject := FILETIME maximum.
	expected := DateAndTime
				rataDie: 11259588
				seconds: 100854775807 / 1e7
				offsetSeconds: 0.
	self assert: subject asDateAndTime equals: expected.
	self assert: (FILETIME fromDateAndTime: expected) equals: subject.
	"We are only checking here for TZ issues, so use a fairly coarse comparison."
	subject := FILETIME now.
	expected := DateAndTime now.
	self assert: expected - subject asDateAndTime < 1 minutes!

testDisplayString
	| now |
	now := DateAndTime now.
	"displayString should always be in local time"
	self assert: (FILETIME fromDateAndTime: now) displayString equals: now displayString.
	self assert: (LocalFILETIME fromDateAndTime: now) displayString equals: now displayString!

testFromDateAndTimeLocal
	| subject dt local |
	subject := FILETIME fromDateAndTime: (DateAndTime
						year: 1601
						day: 1
						offset: 0 seconds).
	self assert: subject asInteger equals: 0.
	dt := DateAndTime utcSeconds: 3199117153 offsetSeconds: 3600.
	subject := FILETIME fromDateAndTime: dt.
	self assert: subject asInteger equals: 126661379530000000.
	local := LocalFILETIME fromDateAndTime: dt.
	self assert: local asUTC equals: subject!

testFromInteger
	self assertFromIntegerInvertible: 126661379535479952.
	self assertFromIntegerInvertible: 0.
	self assertFromIntegerInvertible: SmallInteger maximum.
	self assertFromIntegerInvertible: 2 ** 32 - 1.
	self assertFromIntegerInvertible: 2 ** 32.
	self assertFromIntegerInvertible: 2 ** 32 + 1.
	self assertFromIntegerInvertible: FILETIME.MaxValue.
	self should: [FILETIME fromInteger: FILETIME.MaxValue+1] raise: InvalidArgumentError.
	self should: [FILETIME fromInteger: -1] raise: InvalidArgumentError.
	self should: [FILETIME fromInteger: 2 ** 64] raise: InvalidArgumentError!

testFromUnixTime
	| subject |
	subject := FILETIME fromUnixTime: 3.
	self assert: subject printString equals: 'a FILETIME( 1970-01-01T00:00:03+00:00)'!

testPrintString
	| now |
	now := DateAndTime now.
	self assert: (FILETIME fromDateAndTime: now) printString equals: 'a FILETIME(<1p>)' << now asUTC.
	self assert: (LocalFILETIME fromDateAndTime: now) printString equals: 'a LocalFILETIME(<1p>)' << now!

testSystemTimeConversions
	| subject sysTime dt |
	dt := (DateAndTime fromString: '2020-02-29T11:01:02.125Z') - Locale timeZoneInformation offset.
	"Note that in Dolphin we assume SYSTEMTIMEs are local time by default"
	sysTime := SYSTEMTIME new
				wYear: 2020;
				wMonth: 2;
				wDay: 29;
				wDayOfWeek: 6;
				wHour: 11;
				wMinute: 1;
				wSecond: 2;
				wMilliseconds: 125;
				yourself.
	self assert: dt asSYSTEMTIME equals: sysTime.
	subject := FILETIME fromSYSTEMTIME: sysTime.
	self assert: subject asDateAndTime equals: dt.
	self assert: subject asSYSTEMTIME equals: sysTime.
	subject := LocalFILETIME fromSYSTEMTIME: sysTime.
	self assert: subject asDateAndTime equals: dt.
	self assert: subject asSYSTEMTIME equals: sysTime.
	"Out of range cases"
	subject := FILETIME new value: 16r7FFFFFFFFFFFFFFF.
	self should: [subject asSYSTEMTIME] raise: Error.
	{
		SYSTEMTIME new
			wYear: 30828;
			wMonth: 9;
			wDay: 14;
			wDayOfWeek: 4;
			wHour: 2;
			wMinute: 48;
			wSecond: 5;
			wMilliseconds: 477;
			yourself.
		SYSTEMTIME new
			wYear: 1600;
			wMonth: 12;
			wDay: 31;
			wHour: 23;
			wMinute: 59;
			wSecond: 59;
			wMilliseconds: 999;
			yourself
	} do: 
				[:each |
				self
					should: [FILETIME fromSYSTEMTIME: each]
					raise: HRESULTError
					matching: [:ex | ex statusCode = Win32Error.ERROR_INVALID_PARAMETER]].

	"Actual max system time"
	subject := FILETIME fromInteger: 16r7FFF35F4F06C58F0 - (Locale timeZoneInformation offsetSeconds * 1e9).
	sysTime := subject asSYSTEMTIME.
	self assert: (FILETIME fromSYSTEMTIME: sysTime) equals: subject.
	subject value: subject value - 100 nanoseconds.
	"FileTimeToSystemTime truncates to milliseconds, not rounds"
	self assert: subject value - subject asSYSTEMTIME asDateAndTime equals: 999900 nanoseconds! !

!OS.Tests.FILETIMETest categoriesForMethods!
assertFromIntegerInvertible:!helpers!private! !
testComparing!public!unit tests! !
testDateAndTimeConversions!public!unit tests! !
testDisplayString!public!unit tests! !
testFromDateAndTimeLocal!public!unit tests! !
testFromInteger!public!unit tests! !
testFromUnixTime!public!unit tests! !
testPrintString!public!unit tests! !
testSystemTimeConversions!public!unit tests! !
!

