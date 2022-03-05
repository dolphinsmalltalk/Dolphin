"Filed out from Dolphin Smalltalk"!

MainTestCase subclass: #DateAndTimeANSITest
	instanceVariableNames: 'd19970426t8 savedLocale'
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DateAndTimeANSITest guid: (GUID fromString: '{f6ad86cf-3057-4561-b434-61d09e62c2d4}')!
DateAndTimeANSITest comment: ''!
!DateAndTimeANSITest categoriesForClass!Unclassified! !
!DateAndTimeANSITest methodsFor!

canonicalObject
	^DateAndTime year: 2000 month: 3 day: 16 hour: 16 minute: 49 second: 43!

protocol
	^#'DateAndTime'!

setUp
	super setUp.
	savedLocale := Locale userDefault.
	"The tests of month and day names, etc, are expecting US English names and abbreviations"
	Locale userDefault: (Locale lcid: 1033).
	d19970426t8 := DateAndTime
		year: 1997 month: 4 day: 26
		hour: 8 minute: 0 second: 0.!

tearDown
	savedLocale ifNotNil: [Locale userDefault: savedLocale. savedLocale := nil].
	super tearDown!

testXaddOp
	" <DateAndTime>#+ "
	#'Date and Time'.
	self value: [d19970426t8
				+ (Duration days: 1 hours: 0 minutes: 0 seconds: 1)]
		should: [:r | r = (DateAndTime year: 1997 month: 4 day: 27
							hour: 8 minute: 0 second: 1)]
		conformTo: #'DateAndTime' selector: #'+'.

	self value: [d19970426t8
				+ (Duration days: -1 hours: 0 minutes: 0 seconds: -1)]
		should: [:r | r = (DateAndTime year: 1997 month: 4 day: 25
							hour: 7 minute: 59 second: 59)]
		conformTo: #'DateAndTime' selector: #'+'.!

testXasLocal
	" <DateAndTime>#asLocal "
	#'Date and Time'.
#todo. "??? I'm not sure how to test. ???"
	self value: [d19970426t8 asLocal] should: [:r | true]
		conformTo: #'DateAndTime' selector: #'asLocal'.!

testXasUTC
	" <DateAndTime>#asUTC "
	#'Date and Time'.
#todo. "??? I'm not sure how to test. ???"
	self value: [d19970426t8 asUTC]
		should: [:r | "Invariant:" r offset = Duration zero]
		conformTo: #'DateAndTime' selector: #'asUTC'.!

testXbetweenXandX
	" <magnitude>#between:and: "
	#'Date and Time'.!

testXdayOfMonth
	" <DateAndTime>#dayOfMonth "
	#'Date and Time'.
	self value: [d19970426t8 dayOfMonth] should: [:r | r = 26]
		conformTo: #'DateAndTime' selector: #'dayOfMonth'.!

testXdayOfWeek
	" <DateAndTime>#dayOfWeek "
	#'Date and Time'.
	self value: [d19970426t8 dayOfWeek] should: [:r | r = 7]
		conformTo: #'DateAndTime' selector: #'dayOfWeek'.!

testXdayOfWeekAbbreviation
	" <DateAndTime>#dayOfWeekAbbreviation "
	#'Date and Time'.
	self value: [d19970426t8 dayOfWeekAbbreviation]
		should: [:r | r asString = 'Sat']
		conformTo: #'DateAndTime' selector: #'dayOfWeekAbbreviation'.!

testXdayOfWeekName
	" <DateAndTime>#dayOfWeekName "
	#'Date and Time'.
	self value: [d19970426t8 dayOfWeekName] should: [:r | r asString = 'Saturday']
		conformTo: #'DateAndTime' selector: #'dayOfWeekName'.!

testXdayOfYear
	" <DateAndTime>#dayOfYear "
	#'Date and Time'.
	self value: [d19970426t8 dayOfYear] should: [:r | r = 116]
		conformTo: #'DateAndTime' selector: #'dayOfYear'.!

testXequalityOp
	" <DateAndTime>#="
	"Changed 2000/06/23 Harmon, R. Needs Daylight Savings Fix."
	| d19970426t8CST d19970426t7MST d19970426t7CST tmp1 tmp2 |
	#'Date and Time'.
	d19970426t8CST := DateAndTime year: 1997 month: 4 day: 26
								hour: 8 minute: 0 second: 0.
	"1997-04-26T08:00:00-06:00 CST"
	self	value: [d19970426t8 = d19970426t8CST]
		should: [:r | r & (d19970426t8 hash = d19970426t8CST hash)]
		conformTo: #DateAndTime selector: #=.

	d19970426t8CST := DateAndTime year: 1997 month: 4 day: 26
								hour: 8 minute: 0 second: 0.
	"1997-04-26T08:00:00-06:00 CST"
	tmp1 := DateAndTime year: 1996 month: 4 day: 26
						hour: 5 minute: 59 second: 50
						offset: (Duration seconds: -10).
	tmp2 := DateAndTime year: 1996 month: 4 day: 26
						hour: 6 minute: 0 second: 10
						offset: (Duration seconds: 10).
	self	value: [tmp1 = tmp2]
		should: [:r | r & (tmp1 hash = tmp2 hash)]
		conformTo: #DateAndTime selector: #=.

	d19970426t7MST := DateAndTime year: 1997 month: 4 day: 26
							hour: 7 minute: 0 second: 0
							offset: (Duration days: 0 hours: -7
									minutes: 0 seconds: 0).
	"1997-04-26T07:00:00-07:00 MST"
#todo.">>>Fails because d19970426t7MST is Daylight Savings not Standard.
	self	value: [d19970426t8 = d19970426t7MST]
		should: [:r | r & (d19970426t8 hash = d19970426t7MST hash)]
		conformTo: #DateAndTime selector: #=.
<<<"
	d19970426t7CST := DateAndTime year: 1996 month: 4 day: 27
								hour: 7 minute: 0 second: 0.
	"1997-04-26T07:00:00-07:00 MST"
	self value: [d19970426t8 = d19970426t7CST]
		shouldnt: [:r | r & (d19970426t8 hash = d19970426t7CST hash)]
		conformTo: #DateAndTime selector: #=!

testXgreaterThanOp
	" <DateAndTime>#> "
	#'Date and Time'.
	self value: [(DateAndTime year: 1997 month: 4 day: 27
					hour: 8 minute: 0 second: 1) > d19970426t8]
		should: [:r | r] conformTo: #'DateAndTime' selector: #'>'.
	self value: [(DateAndTime year: 2000 month: 4 day: 27
				hour: 8 minute: 0 second: 0) > d19970426t8]
		should: [:r | r] conformTo: #'DateAndTime' selector: #'>'.

	self value: [(DateAndTime year: 1996 month: 4 day: 27
				hour: 7 minute: 0 second: 0) > d19970426t8]
		shouldnt: [:r | r] conformTo: #'DateAndTime' selector: #'>'.!

testXgreaterThanOrEqualToOp
	" <magnitude>#>= "
	#'Date and Time'.!

testXhour
	" <DateAndTime>#hour "
	#'Date and Time'.
	self value: [d19970426t8 hour] should: [:r | r = 8]
		conformTo: #'DateAndTime' selector: #'hour'.!

testXhour12
	" <DateAndTime>#hour12 "
	#'Date and Time'.
	self value: [d19970426t8 hour12] should: [:r | r = 8]
		conformTo: #'DateAndTime' selector: #'hour12'.!

testXhour24
	" <DateAndTime>#hour24 "
	#'Date and Time'.
	self value: [d19970426t8 hour24] should: [:r | r = 8]
		conformTo: #'DateAndTime' selector: #'hour24'.!

testXisLeapYear
	" <DateAndTime>#isLeapYear "
	#'Date and Time'.
	self value: [d19970426t8 isLeapYear] shouldnt: [:r | r]
		conformTo: #'DateAndTime' selector: #'isLeapYear'.

	self value: [(DateAndTime year: 1996 month: 2 day: 1
				hour: 0 minute: 0 second: 0 ) isLeapYear]
		should: [:r | r]
		conformTo: #'DateAndTime' selector: #'isLeapYear'.!

testXlessThanOp
	" <DateAndTime>#< "
	#'Date and Time'.
	self value: [d19970426t8 < (DateAndTime year: 1997 month: 4 day: 27
							hour: 8 minute: 0 second: 1)]
		should: [:r | r] conformTo: #'DateAndTime' selector: #'<'.
	self value: [d19970426t8 < (DateAndTime year: 2000 month: 4 day: 27
							hour: 8 minute: 0 second: 0)]
		should: [:r | r] conformTo: #'DateAndTime' selector: #'<'.

	self value: [d19970426t8 < (DateAndTime year: 1996 month: 4 day: 27
							hour: 7 minute: 0 second: 0)]
		shouldnt: [:r | r] conformTo: #'DateAndTime' selector: #'<'.!

testXlessThanOrEqualToOp
	" <magnitude>#<= "
	#'Date and Time'.!

testXmaxX
	" <magnitude>#max: "
	#'Date and Time'.!

testXmeridianAbbreviation
	" <DateAndTime>#meridianAbbreviation "
	#'Date and Time'.
	self value: [d19970426t8 meridianAbbreviation] should: [:r | r asString = 'AM']
		conformTo: #'DateAndTime' selector: #'meridianAbbreviation'.

	self value: [(DateAndTime year: 1996 month: 2 day: 1
				hour: 12 minute: 0 second: 0 ) meridianAbbreviation]
		should: [:r | r asString = 'PM']
		conformTo: #'DateAndTime' selector: #'meridianAbbreviation'.!

testXminute
	" <DateAndTime>#minute "
	#'Date and Time'.
	self value: [d19970426t8 minute] should: [:r | r = 0]
		conformTo: #'DateAndTime' selector: #'minute'.!

testXminX
	" <magnitude>#min: "
	#'Date and Time'.!

testXmonth
	" <DateAndTime>#month "
	#'Date and Time'.
	self value: [d19970426t8 month] should: [:r | r = 4]
		conformTo: #'DateAndTime' selector: #'month'.!

testXmonthAbbreviation
	" <DateAndTime>#monthAbbreviation "
	#'Date and Time'.
	self value: [d19970426t8 monthAbbreviation] should: [:r | r asString = 'Apr']
		conformTo: #'DateAndTime' selector: #'monthAbbreviation'.!

testXmonthName
	" <DateAndTime>#monthName "
	#'Date and Time'.
	self value: [d19970426t8 monthName] should: [:r | r asString = 'April']
		conformTo: #'DateAndTime' selector: #'monthName'.!

testXoffset
	" <DateAndTime>#offset "
	| d19970426t8Tmp off123 |
	#'Date and Time'.
	off123 := Duration days: 0 hours: 1 minutes: 2 seconds: 3.
	d19970426t8Tmp := DateAndTime year: 1997 month: 4 day: 26
						hour: 0 minute: 0 second: 0 offset: off123.
	self value: [d19970426t8Tmp offset] should: [:r | r = off123]
		conformTo: #'DateAndTime' selector: #'offset'.!

testXoffsetX
	" <DateAndTime>#offset: "
	| d19970426t08Tmp off123 |
	#'Date and Time'.
#todo. "??? Add int, flt, frac offset: tests. ???"
	off123 := Duration days: 0 hours: 1 minutes: 2 seconds: 3.
	d19970426t08Tmp := DateAndTime year: 1997 month: 4 day: 26
				hour: 0 minute: 0 second: 0 offset: (Duration zero).
	self value: [(d19970426t08Tmp offset: off123)]
		should: [:r | r = (DateAndTime year: 1997 month: 4 day: 26
						hour: 1 minute: 2 second: 3 offset: off123)]
		conformTo: #'DateAndTime' selector: #'offset:'.
	"Invariant:"
	self should: [(d19970426t08Tmp offset: off123) offset = off123].!

testXprintString
	" <DateAndTime>#printString "
	#'Date and Time'.
	self value: [(DateAndTime year: 1997 month: 4 day: 26
				hour: 1 minute: 2 second: 3
				offset: (Duration days: 0 hours: 1 minutes: 2 seconds: 3) 			) printString]
		should: [:r | r = ' 1997-04-26T01:02:03+01:02:3']
		conformTo: #'DateAndTime' selector: #'printString'.

	"Example: 8:33:14.321 PM EST January 5, 1200 B.C. 
		'-1199-01-05T20:33:14.321-05:00'
		8:33:14.321 PM -> 20:33:14.321 24 hour"
#'testAnom'. "??? '  0701-01-05T20:33:14-05:00' wrong--not neg.
		-> '-1199-01-05T20:33:14-05:00'
	self value: [(DateAndTime year: -1199 month: 1 day: 5
				hour: 20 minute: 33 second: 14
				offset: (Duration hours: -5 ??EST??)) printString]
		should: [:r | r = '-1199-01-05T20:33:14.321-05:00']
		conformTo: #'DateAndTime' selector: #'printString'.
???"
	"Example: 12 midnight UTC January 1,  2001 A.D. 
			' 2001-01-01T00:00:00+00:00'"
	self value: [(DateAndTime year: 2001 month: 1 day: 1
				hour: 0 minute: 0 second: 0
				offset: Duration zero) printString]
		should: [:r | r = ' 2001-01-01T00:00:00+00:00']
		conformTo: #'DateAndTime' selector: #'printString'.!

testXsecond
	" <DateAndTime>#second "
	#'Date and Time'.
	self value: [d19970426t8 second] should: [:r | r = 0]
		conformTo: #'DateAndTime' selector: #'second'.!

testXsubtractOp
	" <DateAndTime>#- "
	#'Date and Time'.
	"If operand is a <DateAndTime>, answer a <Duration>."
	self value: [d19970426t8 - (DateAndTime year: 1997 month: 4 day: 26
								hour: 7 minute: 0 second: 0)]
		should: [:r | (r isKindOf: Duration)
				& (r = (Duration days: 0 hours: 1 minutes: 0 seconds: 0))]
		conformTo: #'DateAndTime' selector: #'-'.
	self value: [d19970426t8 - (DateAndTime year: 1998 month: 4 day: 26
									hour: 7 minute: 0 second: 0)]
		should: [:r | (r isKindOf: Duration)
			& (r = (Duration days: -364 hours: -23 minutes: 0 seconds: 0))]
		conformTo: #'DateAndTime' selector: #'-'.
	"If operand is a <Duration>, answer a new <DateAndTime>"
	self value: [d19970426t8 - (Duration days: 1 hours: 0
		minutes: 0 seconds: 1)]
		should: [:r | (r isKindOf: DateAndTime)
					& (r = (DateAndTime year: 1997 month: 4 day: 25
							hour: 7 minute: 59 second: 59))]
		conformTo: #'DateAndTime' selector: #'-'.
	self value: [d19970426t8 - (Duration days: -1 hours: 0
		minutes: 0 seconds: -1)]
		should: [:r | (r isKindOf: DateAndTime)
					& (r = (DateAndTime year: 1997 month: 4 day: 27
							hour: 8 minute: 0 second: 1))]
		conformTo: #'DateAndTime' selector: #'-'.!

testXtimeZoneAbbreviation
	" <DateAndTime>#timeZoneAbbreviation "
	"Changed 2000/06/23 Harmon, R. Needs Daylight Savings Fix."
	| offTmp |
	#'Date and Time'.
#'testAnom'.">>>
	offTmp := Duration days: 0 hours: -5 minutes: 0 seconds: 0.

	self value: [(d19970426t8 offset: offTmp) timeZoneAbbreviation]
		should: [:r | r = 'EST']
		conformTo: #'DateAndTime' selector: #'timeZoneAbbreviation'.
<<<"

#todo.">>>Fails because d19970426t7MST is Daylight Savings not Standard.
	offTmp := Duration days: 0 hours: -6 minutes: 0 seconds: 0.
	self value: [(d19970426t8 offset: offTmp) timeZoneAbbreviation]
		should: [:r | r = 'CST']
		conformTo: #'DateAndTime' selector: #'timeZoneAbbreviation'.
<<<"!

testXtimeZoneName
	" <DateAndTime>#timeZoneName "
	"Changed 2000/06/23 Harmon, R. Needs Daylight Savings Fix."
	| offTmp |
	#'Date and Time'.
#'testAnom'.">>>
	offTmp := Duration days: 0 hours: -5 minutes: 0 seconds: 0.
	self value: [(d19970426t8 offset: offTmp) timeZoneName]
		should: [:r | r = 'EST']
		conformTo: #'DateAndTime' selector: #'timeZoneName'.
<<<"

#todo.">>>Fails because d19970426t7MST is Daylight Savings not Standard.
	offTmp := Duration days: 0 hours: -6 minutes: 0 seconds: 0.
	self value: [(d19970426t8 offset: offTmp) timeZoneName]
		should: [:r | r = 'Central Standard Time']
		conformTo: #'DateAndTime' selector: #'timeZoneName'.
<<<"!

testXyear
	" <DateAndTime>#year "
	#'Date and Time'.
	self value: [d19970426t8 year] should: [:r | r = 1997]
		conformTo: #'DateAndTime' selector: #'year'.! !
!DateAndTimeANSITest categoriesForMethods!
canonicalObject!public! !
protocol!public! !
setUp!private!running! !
tearDown!private!running! !
testXaddOp!public! !
testXasLocal!public! !
testXasUTC!public! !
testXbetweenXandX!public! !
testXdayOfMonth!public! !
testXdayOfWeek!public! !
testXdayOfWeekAbbreviation!public! !
testXdayOfWeekName!public! !
testXdayOfYear!public! !
testXequalityOp!public! !
testXgreaterThanOp!public! !
testXgreaterThanOrEqualToOp!public! !
testXhour!public! !
testXhour12!public! !
testXhour24!public! !
testXisLeapYear!public! !
testXlessThanOp!public! !
testXlessThanOrEqualToOp!public! !
testXmaxX!public! !
testXmeridianAbbreviation!public! !
testXminute!public! !
testXminX!public! !
testXmonth!public! !
testXmonthAbbreviation!public! !
testXmonthName!public! !
testXoffset!public! !
testXoffsetX!public! !
testXprintString!public! !
testXsecond!public! !
testXsubtractOp!public! !
testXtimeZoneAbbreviation!public! !
testXtimeZoneName!public! !
testXyear!public! !
!

