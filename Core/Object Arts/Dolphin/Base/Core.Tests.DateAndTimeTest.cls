"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #'Core.Tests.DateAndTimeTest'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Core.Tests.DateAndTimeTest guid: (Core.GUID fromString: '{833a97bb-3e1a-4dcb-a1db-181457c09c0f}')!
Core.Tests.DateAndTimeTest comment: ''!
!Core.Tests.DateAndTimeTest categoriesForClass!Unclassified! !
!Core.Tests.DateAndTimeTest methodsFor!

canonicalInstance
	^DateAndTime
		year: 2000
		month: 2
		day: 29
		hour: 12
		minute: 59
		second: 59 + (666666666 / 1000000000)
		offset: -12.5 hours!

julianEpoch
	"Noon, November 24, 4714 BC"

	^DateAndTime
		year: -4713
		month: 11
		day: 24
		hour: 12
		minute: 0
		second: 0
		offset: 0 hours!

testAddDuration
	| subject epochSeconds |
	subject := DateAndTime
				year: 1970
				day: 1
				offset: 0 hours.
	epochSeconds := subject asSeconds.
	"Sanity check"
	self assert: epochSeconds equals: 2177452800.
	self assert: subject + 60 seconds
		equals: (DateAndTime
				year: 1970
				day: 1
				hour: 0
				minute: 1
				second: 0
				offset: 0 hours).
	self assert: subject + -43 seconds
		equals: (DateAndTime
				year: 1969
				month: 12
				day: 31
				hour: 23
				minute: 59
				second: 17
				offset: 0 hours).
	self assert: (DateAndTime
				year: 2000
				month: 2
				day: 28) + 1 days
		equals: (DateAndTime
				year: 2000
				month: 2
				day: 29).
	self assert: (DateAndTime
				year: 2000
				month: 2
				day: 28) + 2 days
		equals: (DateAndTime
				year: 2000
				month: 3
				day: 1).
	self assert: (DateAndTime
				year: 2000
				month: 3
				day: 1) + -1 days
		equals: (DateAndTime
				year: 2000
				month: 2
				day: 29)!

testAsDate
	| subject |
	subject := self canonicalInstance.
	"Note that the offset is ignored - the date is not adjusted to local time"
	self assert: subject asDate
		equals: (Date
				newDay: 29
				monthIndex: 2
				year: 2000)!

testAsSeconds
	"For compatibility with traditional Smalltalk Dates, we use the same epoch as the base for asSeconds, i.e. 1st Jan 1901"

	| subject date |
	subject := DateAndTime
				year: 1901
				month: 1
				day: 1
				offset: Duration zero.
	self assert: subject asSeconds equals: 0.
	subject := DateAndTime
				year: 1901
				month: 1
				day: 1
				offset: 1 hours.
	self assert: subject asSeconds equals: -3600.

	"Check for the same epoch as Date>>asSeconds"
	subject := DateAndTime fromString: '2019-04-13T09:42:43.634+00:00'.
	date := Date
				year: 2019
				month: 04
				day: 13.
	self assert: subject asSeconds truncated - date asSeconds equals: subject seconds truncated.
	self assert: (DateAndTime
				year: 1970
				day: 1
				offset: 0 hours) asSeconds
		equals: 2177452800!

testAsSYSTEMTIME
	| subject actual |
	subject := self canonicalInstance.
	actual := subject asSYSTEMTIME.
	self assert: actual wYear equals: 2000.
	self assert: actual wMonth equals: 2.
	self assert: actual wDay equals: 29.
	self assert: actual wDayOfWeek equals: 3-1.
	self assert: actual wHour equals: 12.
	self assert: actual wMinute equals: 59.
	self assert: actual wSecond equals: 59.
	"Milliseconds are truncated to avoid rounding to 1000 and creating an invalid SYSTEMTIME"
	self assert: actual wMilliseconds equals: 666!

testAsSYSTEMTIMEInvalidMilliseconds
	"#1045 - wMillisecond must never be 1000, even if that is what the millisecond value we have would round to"

	| subject actual |
	subject := DateAndTime
				year: 2000
				day: 1
				hour: 0
				minute: 0
				second: 599995 / 10000.
	actual := subject asSYSTEMTIME.
	self assert: actual wSecond equals: 59.
	self assert: actual wMilliseconds equals: 999!

testAsTime
	"Offset is ignored - the date is not adjusted to local time"

	self assert: self canonicalInstance asTime
		equals: (Time fromSeconds: (12 * 60 + 59) * 60 + 59 + (666666666 / 1000000000))!

testAsUnixTime
	| subject |
	subject := DateAndTime fromString: '2019-04-12T18:49:17+00:00'.
	self assert: subject asUnixTime truncated equals: 1555094957!

testAsUTC
	| subject |
	subject := self canonicalInstance.
	"Offset is ignored - the date is not adjusted to local time"
	self assert: subject asUTC
		equals: (DateAndTime
				year: 2000
				month: 3
				day: 01
				hour: 01
				minute: 29
				second: 59 + (666666666 / 1000000000)
				offset: 0 hours)!

testDayOfMonth
	self assert: self canonicalInstance dayOfMonth equals: 29!

testDayOfWeek
	"It was a Tuesday"

	self assert: self canonicalInstance dayOfWeek equals: 3!

testDayOfWeekAbbreviation
	| dayName |
	"It was a Tuesday"
	dayName := Locale default dayOfWeekAbbreviation: 3.
	self assert: self canonicalInstance dayOfWeekAbbreviation equals: dayName!

testDayOfWeekName
	| dayName |
	"It was a Tuesday"
	dayName := Locale default dayOfWeekName: 3.
	self assert: self canonicalInstance dayOfWeekName equals: dayName!

testDayOfYear
	self assert: self canonicalInstance dayOfYear equals: 31 + 29!

testFromString
	| fromString fromStringNoOffset |
	fromString := DateAndTime fromString: '-1199-01-05T20:33:14.321-05:00'.
	self assert: fromString printString equals: '-1199-01-05T20:33:14.321-05:00'.

	"if no offset is provided, the local offset should be used"
	fromStringNoOffset := DateAndTime fromString: '-1199-01-05T20:33:14.321'.
	self assert: fromStringNoOffset offset equals: Locale timeZoneInformation offset.
	self assert: (DateAndTime fromString: self canonicalInstance printString)
		equals: self canonicalInstance.

	"We also allow the ISO 8601 'Z' offset format, for UTC"
	fromString := DateAndTime fromString: '-1199-01-05T20:33:14.321Z'.
	self assert: fromString printString equals: '-1199-01-05T20:33:14.321+00:00'.

	"Fractional seconds down to nanoseconds"
	fromString := DateAndTime fromString: '2019-04-19T15:33:37.067259812+12:45'.
	self assert: fromString
		equals: (DateAndTime
				year: 2019
				month: 4
				day: 19
				hour: 15
				minute: 33
				second: 37 + (067259812 / 1e9)
				offset: 12 hours + 45 minutes).
	fromString := DateAndTime fromString: '2020-02-29T11:21:57.1902598-12:00'.
	self assert: fromString
		equals: (DateAndTime
				year: 2020
				month: 2
				day: 29
				hour: 11
				minute: 21
				second: 57 + (190259800 / 1e9)
				offset: -12 hours)!

testFromSYSTEMTIME
	| ts sysTime |
	sysTime := OS.SYSTEMTIME now.
	ts := DateAndTime fromSYSTEMTIME: sysTime.
	self assert: ts dayOfMonth equals: sysTime wDay.
	self assert: ts month equals: sysTime wMonth.
	self assert: ts year equals: sysTime wYear.
	self assert: ts hour equals: sysTime wHour.
	self assert: ts minute equals: sysTime wMinute.
	self assert: ts second truncated equals: sysTime wSecond.
	self assert: ts second fractionPart * 1000 equals: sysTime wMilliseconds!

testHour
	0 to: 23
		do: 
			[:each |
			self
				assert: (DateAndTime
						year: 2000
						day: 60
						hour: each
						minute: 59
						second: 59) hour
				equals: each]!

testHour12
	self
		assert: (DateAndTime
				year: 2000
				day: 60
				hour: 0
				minute: 59
				second: 59) hour12
		equals: 12.
	1 to: 12
		do: 
			[:each |
			self
				assert: (DateAndTime
						year: 2000
						day: 60
						hour: each
						minute: 59
						second: 59) hour12
				equals: each].
	13 to: 23
		do: 
			[:each |
			self
				assert: (DateAndTime
						year: 2000
						day: 60
						hour: each
						minute: 59
						second: 59) hour12
				equals: each - 12]!

testHour24
	0 to: 23
		do: 
			[:each |
			self
				assert: (DateAndTime
						year: 2000
						day: 60
						hour: each
						minute: 59
						second: 59) hour24
				equals: each]!

testIsLeapYear
	self assert: self canonicalInstance isLeapYear.
	self assert: (DateAndTime
				year: 0
				month: 1
				day: 1) isLeapYear.
	self deny: (DateAndTime
				year: 2001
				month: 1
				day: 1) isLeapYear.
	self assert: (DateAndTime
				year: 2004
				month: 1
				day: 1) isLeapYear.
	self deny: (DateAndTime
				year: 2100
				month: 1
				day: 1) isLeapYear!

testJulianDate
	"see https://en.wikipedia.org/wiki/Julian_day."

	| subject |
	self assert: self julianEpoch julianDate equals: 0.
	subject := (DateAndTime
				year: 2013
				month: 1
				day: 1
				hour: 00
				minute: 30
				second: 0
				offset: 0 hours) julianDate
				roundTo: 1e-6.
	self assert: subject equals: 2456293520833 / 1e6!

testJulianDayNumber
	"see https://en.wikipedia.org/wiki/Julian_day."

	| subject |
	subject := self julianEpoch.
	self assert: subject julianDayNumber equals: 0.

	"On the day this test was written, the wikipedia page example was for 00:34, Friday, April 12, 2019 (UTC)"
	subject := DateAndTime fromString: '2019-04-12T00:34:00+00:00'.
	self assert: subject julianDayNumber equals: 2458585.

	"Julian days start at noon, so verify the correct pivot is used"
	subject := DateAndTime
				year: 2000
				day: 1
				hour: 12
				minute: 0
				second: 0
				offset: Duration zero.
	self assert: subject julianDayNumber equals: 2451545.
	self assert: (subject - 1 nanoseconds) julianDayNumber equals: 2451544.
	self assert: (subject + 12 hours) julianDayNumber equals: 2451545.
	self assert: (subject + 24 hours) julianDayNumber equals: 2451546.
	self assert: (subject + 24 hours - 1 nanoseconds) julianDayNumber equals: 2451545.

	"Noon on the Unix epoch is JDN 2440588"
	self
		assert: ((DateAndTime
				year: 1970
				day: 1
				offset: 0 hours) + 12 hours) julianDayNumber
		equals: 2440588.

	"An example at 2pm local time at UTC+2"
	subject := DateAndTime
				year: 2011
				month: 7
				day: 29
				hour: 14
				minute: 0
				second: 0
				offset: 2 hours.
	self assert: subject julianDayNumber equals: 2455772.
	self assert: (subject - 1 nanoseconds) julianDayNumber equals: 2455771!

testLilianDayNumber
	"see https://en.wikipedia.org/wiki/Lilian_date."

	| subject |
	"On the day this page was written, the wikipedia page example was for 00:34, Friday, April 12, 2019 (UTC)"
	subject := DateAndTime fromString: '2019-04-12T00:34:00+00:00'.
	self assert: subject lilianDayNumber equals: 159426.
	subject := DateAndTime
				year: 1582
				month: 10
				day: 15
				offset: Duration zero.
	self assert: subject lilianDayNumber equals: 1!

testMeridianAbbreviation
	self assert: self canonicalInstance meridianAbbreviation equals: Locale default pmDesignator.
	self assert: (self canonicalInstance - 12 hours) meridianAbbreviation
		equals: Locale default amDesignator!

testMidnight
	self assert: self canonicalInstance midnight
		equals: (DateAndTime
				year: 2000
				month: 2
				day: 29
				hour: 0
				minute: 0
				second: 0
				offset: -12.5 hours)!

testMinute
	self assert: self canonicalInstance minute equals: 59!

testMonth
	self assert: self canonicalInstance month equals: 2!

testMonthAbbreviation
	self assert: self canonicalInstance monthAbbreviation equals: (Locale default monthAbbreviation: 2)!

testMonthName
	self assert: self canonicalInstance monthName equals: (Locale default monthName: 2)!

testNowUtc
	| now nowUtc |
	now := DateAndTime now.
	nowUtc := DateAndTime nowUTC.
	self assert: nowUtc offset equals: 0 hours.
	self assert: (nowUtc - now) seconds abs < 1!

testOffset
	self assert: self canonicalInstance offset equals: (12 * 60 + 30) minutes negated!

testOffsetBy
	| subject1 subject2 |
	"An early start in London"
	subject1 := DateAndTime
				year: 1966
				month: 6
				day: 7
				hour: 4
				minute: 30
				second: 10
				offset: 0 hours.
	"Which is late at night on the preceding day on the east coast of the USA"
	subject2 := subject1 offset: -5 hours.
	self assert: subject2 equals: (DateAndTime fromString: '1966-06-06T23:30:10-05:00').
	"Late at night in London"
	subject1 := DateAndTime
				year: 1966
				month: 6
				day: 7
				hour: 23
				minute: 59
				second: 59
				offset: 0 hours.
	"Is early the next morning in India"
	subject2 := subject1 offset: 5.5 hours.
	self assert: subject2 equals: (DateAndTime fromString: '1966-06-08T05:29:59+05:30')!

testPrintOn
	| subject |
	self assert: self canonicalInstance printString equals: ' 2000-02-29T12:59:59.666666666-12:30'.
	self
		assert: (DateAndTime
				year: -1
				day: 1
				hour: 1
				minute: 1
				second: 1
				offset: 1 hours) printString
		equals: '-0001-01-01T01:01:01+01:00'.
	self
		assert: (DateAndTime
				year: -1
				day: 59
				hour: 23
				minute: 35
				second: 0
				offset: 13 hours) printString
		equals: '-0001-02-28T23:35:00+13:00'.

	"ANSI examples"
	subject := DateAndTime
				year: -1199
				month: 1
				day: 5
				hour: 20
				minute: 33
				second: (14 seconds + 321 milliseconds) asSeconds
				offset: -5 hours.
	self assert: subject printString equals: '-1199-01-05T20:33:14.321-05:00'.
	subject := DateAndTime
				year: 2001
				day: 1
				offset: 0 hours.
	self assert: subject printString equals: ' 2001-01-01T00:00:00+00:00'!

testRataDie
	self assert: (DateAndTime
				year: 1
				month: 1
				day: 1) rataDie equals: 1.
	"ISO year 0 is actually year 1 BC"
	self assert: (DateAndTime
				year: 0
				month: 1
				day: 1) rataDie equals: -365.
	self assert: (DateAndTime
				year: 0
				month: 12
				day: 31) rataDie equals: 0.
	"A routine example in a leap year, but before the end of feb"
	self assert: (DateAndTime
				year: 2010
				month: 2
				day: 25) rataDie equals: 733828!

testSecond
	self assert: self canonicalInstance second equals: 59 + (666666666/1000000000)!

testStbConvertFrom
	"Test upgrade from the original IDB DateAndTime representation to the day number and seconds representation."

	{#(#'!!STL' 4 721670 ##(Smalltalk.DateAndTime) 524806 ##(Smalltalk.Fraction) 8 31845933559313 1001 524550 ##(Smalltalk.Duration) 7201 34 7 4039 9 51 19 37 434 38627 1001 11).
		DateAndTime
			year: 2019
			month: 4
			day: 25
			hour: 9
			minute: 18
			second: 38626 / 1000
			offset: 1 hours.
		#(#'!!STL' 4 721670 ##(Smalltalk.DateAndTime) 524806 ##(Smalltalk.Fraction) 8 63087551939999999 2000001 524550 ##(Smalltalk.Duration) 7201 34 7 4001 5 59 47 117 434 119999999 2000001 7).
		DateAndTime
			year: 2000
			month: 2
			day: 29
			hour: 23
			minute: 58
			second: 59999999 / 1e6
			offset: 1 hours.
		#(#'!!STL' 4 721670 ##(Smalltalk.DateAndTime) 524806 ##(Smalltalk.Fraction) 8 -47566200000001 2000001 524550 ##(Smalltalk.Duration) -57599 34 7 -1 13 59 23 19 434 119999999 2000001 7).
		DateAndTime
			year: -1
			month: 6
			day: 29
			hour: 11
			minute: 9
			second: 59999999 / 1e6
			offset: -8 hours.
		#(#'!!STL' 4 721670 ##(Smalltalk.DateAndTime) 172801 524550 ##(Smalltalk.Duration) 1 8 #(1 1 1 0 0 0 2)).
		DateAndTime
			year: 1
			day: 1
			offset: Duration zero.
		#(#'!!STL' 4 721670 ##(Smalltalk.DateAndTime) 8 59958230400 524550 ##(Smalltalk.Duration) 1 8 #(1901 1 1 0 0 0 3)).
		DateAndTime
			year: 1901
			day: 1
			offset: Duration zero} pairsDo: 
				[:stl :expected |
				| actual |
				actual := Object fromLiteralStoreArray: stl.
				self assert: actual equals: expected]!

testStbConvertFrom0
	"Test upgrade from version 0.
	The stored instances I have do not have a Duration instance for seconds (JGF)"

	"Create a ByteArray from 96fc6fa776aff7f8e76246917a28cda0195e27be (24 April 2019)
	
	| ts date time dat |
	ts := TimeStamp current.
	date := ts date.
	time := ts time.
	time seconds class == Fraction ifFalse: [self error: 'wrong class!!'].
	dat := DateAndTime
		year: date year 
		month: date month 
		day: date dayOfMonth 
		hour: time hour 
		minute: time minute 
		second: time second.
	dat binaryStoreBytes.
	 "

	| bytes dat string |
	bytes := #[33 83 84 66 32 52 32 6 3 11 0 68 97 116 101 65 110 100 84 105 109 101 131 127 22 0 6 2 8 0 70 114 97 99 116 105 111 110 183 217 116 4 209 7 0 0 33 59 255 255].	"Obtained from the code above"
	dat := DateAndTime fromBinaryStoreBytes: bytes.
	string := dat printString.
	self assert: string = ' 2019-06-07T10:23:03.387-07:00'	"What is with the leading space?"!

testStoreOn
	| now stored collection |
	now := DateAndTime now.
	collection := OrderedCollection with: now with: self canonicalInstance.
	stored := collection storeString.
	self assert: (Compiler evaluate: stored) equals: collection!

testToday
	| today subject |
	today := Date today.
	subject := DateAndTime today.
	self assert: subject year equals: today year.
	self assert: subject month equals: today month.
	self assert: subject dayOfMonth equals: today dayOfMonth.
	self assert: subject hour equals: 0.
	self assert: subject minute equals: 0.
	self assert: subject second equals: 0.
	self assert: subject offset equals: Locale timeZoneInformation offset!

testYearMonthDay
	| subject offset expected suffix |
	self should: 
			[DateAndTime
				year: 2004
				month: 13
				day: 1]
		raise: InvalidArgumentError.
	self should: 
			[DateAndTime
				year: 2004
				month: 2
				day: 30]
		raise: InvalidArgumentError.
	"1900 was not a leap year (divisible by 4, but not by 100, and not by 400)"
	self should: 
			[DateAndTime
				year: 1900
				month: 2
				day: 29]
		raise: InvalidArgumentError.
	offset := Locale timeZoneInformation offset.
	suffix := offset printStringFormat: '+hh:mm'.
	#(1904 2000 2004 2400) do: 
			[:each |
			subject := DateAndTime
						year: each
						month: 2
						day: 29.
			self assert: subject isLeapYear.
			self assert: subject offset equals: offset.
			expected := ' ' , each printString , '-02-29T00:00:00' , suffix.
			self assert: subject printString equals: expected]!

testYearMonthDayHourMinuteSecondOffset
	| subject1 subject2 |
	subject1 := DateAndTime
				year: 2019
				month: 4
				day: 1
				hour: 12
				minute: 15
				second: 31
				offset: 0 hours.
	subject2 := DateAndTime
				year: 2019
				month: 4
				day: 1
				hour: 12
				minute: 15
				second: 31
				offset: 2 hours.

	"In their respective local times, the DTs represent the same time point."
	self assert: subject1 seconds equals: subject2 seconds.
	self assert: subject1 year equals: subject2 year.
	self assert: subject1 month equals: subject2 month.
	self assert: subject1 day equals: subject2 day.
	self assert: subject1 hour equals: subject2 hour.
	self assert: subject1 minute equals: subject2 minute.
	self assert: subject1 second equals: subject2 second.

	"However they are really different time points."
	self deny: subject1 equals: subject2.
	self deny: subject1 asSeconds equals: subject2 asSeconds!

testYearMonthDayHourMinuteSecondOffsetErrors
	| subject1 subject2 |
	#(#(2019 13 1 12 15 31 0) #(2019 2 29 12 15 31 0) #(2000 1 1 24 59 59 0) #(2000 1 1 23 60 59 0) #(2000 1 1 23 59 60 0) #(2000 1 1 23 59 59 24))
		do: 
			[:each |
			self should: 
					[DateAndTime
						year: each first
						month: each second
						day: each third
						hour: each fourth
						minute: each fifth
						second: each sixth
						offset: (each at: 7) hours]
				raise: InvalidArgumentError].
	subject1 := DateAndTime
				year: 2019
				month: 4
				day: 1
				hour: 12
				minute: 15
				second: 31
				offset: 0 hours.
	subject2 := DateAndTime
				year: 2019
				month: 4
				day: 1
				hour: 12
				minute: 15
				second: 31
				offset: 2 hours.

	"In their respective local times, the DTs represent the same time point."
	self assert: subject1 seconds equals: subject2 seconds.
	self assert: subject1 year equals: subject2 year.
	self assert: subject1 month equals: subject2 month.
	self assert: subject1 day equals: subject2 day.
	self assert: subject1 hour equals: subject2 hour.
	self assert: subject1 minute equals: subject2 minute.
	self assert: subject1 second equals: subject2 second.

	"However they are really different time points."
	self deny: subject1 equals: subject2.
	self deny: subject1 asSeconds equals: subject2 asSeconds! !
!Core.Tests.DateAndTimeTest categoriesFor: #canonicalInstance!constants!private! !
!Core.Tests.DateAndTimeTest categoriesFor: #julianEpoch!constants!private! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAddDuration!public! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsDate!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsSeconds!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsSYSTEMTIME!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsSYSTEMTIMEInvalidMilliseconds!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsTime!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsUnixTime!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testAsUTC!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testDayOfMonth!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testDayOfWeek!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testDayOfWeekAbbreviation!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testDayOfWeekName!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testDayOfYear!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testFromString!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testFromSYSTEMTIME!public! !
!Core.Tests.DateAndTimeTest categoriesFor: #testHour!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testHour12!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testHour24!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testIsLeapYear!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testJulianDate!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testJulianDayNumber!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testLilianDayNumber!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMeridianAbbreviation!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMidnight!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMinute!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMonth!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMonthAbbreviation!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testMonthName!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testNowUtc!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testOffset!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testOffsetBy!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testPrintOn!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testRataDie!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testSecond!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testStbConvertFrom!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testStbConvertFrom0!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testStoreOn!public!testing! !
!Core.Tests.DateAndTimeTest categoriesFor: #testToday!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testYearMonthDay!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testYearMonthDayHourMinuteSecondOffset!public!unit tests! !
!Core.Tests.DateAndTimeTest categoriesFor: #testYearMonthDayHourMinuteSecondOffsetErrors!public!unit tests! !

