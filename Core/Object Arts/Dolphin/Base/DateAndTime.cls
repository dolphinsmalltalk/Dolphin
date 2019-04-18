"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #DateAndTime
	instanceVariableNames: 'rataDie seconds offset'
	classVariableNames: 'FiletimeEpochSeconds JulianDayOffset LilianDayOffset SmalltalkEpochRD UnixEpoch'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DateAndTime guid: (GUID fromString: '{87b4c653-026e-11d3-9fd7-00a0cc3e4a32}')!
DateAndTime addClassConstant: 'FiletimeEpochSeconds' value: -16r234474600!
DateAndTime addClassConstant: 'LilianDayOffset' value: -16r8D0C7!
DateAndTime addClassConstant: 'SmalltalkEpochRD' value: 16rA96C9!
DateAndTime comment: '`DateAndTime` is an implementation of the ANSI Smalltalk protocols `<DateAndTime>` (instance side) and `<DateAndTime factory>` (class side).

*Derived from original work copyright © 2005 Ian Bartholomew, with additions by Richard Harmon, however the internal representation has been changed.*

## Examples
```
	now := DateAndTime now.
	utc := now asUTC.
	now = utc. "true - may be different time zone, but same absolute point in time"
	now - utc
```

## Instance Variables:
  `rataDie`			`<integer>` count of days based on an epoch of 1st Jan 0001 (Rata Die).
  `seconds`		`<rational>` number of seconds since beginning of the day in local time (i.e. at the time zone `offset`)
  `offset`			`<Duration>` that is the offset from UTC of the local time of the `DateAndTime`

## Class Variables

  `SmalltalkEpochRD`	`<integer>` Rata Die of the traditional Smalltalk epoch (1st Jan 1901)'!
!DateAndTime categoriesForClass!IDB Goodies!Magnitude-General! !
!DateAndTime methodsFor!

- operand 
	"Answer a <DateAndTime>, or a <Duration> that is the result of subtracting the <DateAndTime>, or <Duration>, argument from the receiver.
	If the argument is a <DateAndTime>, then answer a <Duration> whose value is the period of time between the argument and the receiver. 
	The answer may be a negative <Duration> if the argument is prior to the receiver in time."

	^operand subtractFromDateAndTime: self!

+ operand
	"Answer the result of adding the <Duration> argument, operand to the receiver. More specifically: Answer a <DateAndTime> that represents the UTC time that is the <Duration> argument, operand, after the receiver, and whose local time is the same as the receiver's. If the argument is a negative <Duration>, then the result is a <DateAndTime> prior to the receiver."

	^self class utcSeconds: self asSeconds + operand asSeconds offset: self offset!

< operand 
	"Answer whether the receiver is less than the <DateAndTime> argument, operand, i.e. answer whether the receiver is prior to UTC time represented by the argument."

	^self asSeconds < operand asSeconds!

= comparand
	"Answer whether the argument is a <DateAndTime> representing the same UTC time as the receiver. In other words, a pair of DateAndTimes can be equal if they represent the same absolute point in time, even if their time zone offsets are different."

	^self species == comparand species and: [self asSeconds = comparand asSeconds]!

asDate
	"Answer a <Date> representing the date of the receiver. The <Date> will be that at the receiver's offset, so:
		- if a date in the local timezone is needed, send #asLocal first (i.e. `dateAndTime asLocal asDate`)
		- if a UTC date is needed, send #asUTC first (i.e. `dateAndTime asUTC asDate`)."

	^self dayMonthYearDo: 
			[:d :m :y |
			Date
				newDay: d
				monthIndex: m
				year: y]!

asLocal
	"Answer a <DateAndTime> that represents the same UTC time as the receiver, but in the local time of the host OS."

	^self offset: self class localOffset!

asParameter
	"Answer the receiver in a form suitable for passing to a Windows API, in this case a <SYSTEMTIME>.
	Note that <SYSTEMTIME> can represent only a limited range of possible <DateAndTime>s, and the offset is ignored, so convert to the desired timezone first."

	| secs |
	secs := self second.
	^self dayMonthYearDo: 
			[:d :m :y |
			SYSTEMTIME new
				wYear: y;
				wMonth: m;
				wDay: d;
				wDayOfWeek: self dayOfWeek - 1;
				wHour: self hour24;
				wMinute: self minute;
				wSecond: secs truncated;
				wMilliseconds: (secs fractionPart * 1000) rounded;
				yourself]!

asSeconds
	"Answer a <rational> that is the number of seconds (including fractional part) that the receiver is past the traditional Smalltalk Epoch (i.e. 1901-01-01T00:00:00+00:00).
	Note that this is a UTC value, and is likely to be a <LargeInteger>, or a <Fraction> with <LargeInteger> numerator (and possibly denominator)."

	"In the original IDB DateAndTime, this method returned local-time seconds since the Rata Die epoch, but for compatibility with the traditional Smalltalk Date/Time classes (and Squeak/Pharo) this has been changed to return UTC seconds past the traditional Smalltalk epoch (01/01/1901)."

	^self localSeconds - offset asSeconds!

asTime
	"Answer a <Time> representing the local time of the receiver. The <Time> will be that at the receiver's offset, so:
		- if a time in the local timezone is needed and the DateAndTime, send #asLocal first (i.e. `dateAndTime asLocal asTime`)
		- if a UTC time is needed, send #asUTC first (i.e. `dateAndTime asUTC asTime`)."

	^Time fromMilliseconds: (((self hour24 * 60 + self minute) * 60 + self second) * 1000) rounded!

asUnixTime
	"Answer the a <rational> representing the number of seconds past 00:00h, 01-Jan-1970 (the Unix epoch)."

	^self asSeconds - 2177452800!

asUTC
	"Answer a <DateAndTime> that represents the same absolute time as the receiver but in Co-ordinated Universal Time (UTC)."

	^self offset: Duration.Zero!

day
	"For compatibility - equivalent to #dayOfMonth"

	^self dayOfMonth!

dayMonthYearDo: aBlock
	| z h a b year c month day |
	z := rataDie + 306.
	h := 100 * z - 25.
	a := h // 3652425.
	b := a - (a // 4).
	year := (100 * b + h) // 36525.
	c := b + z - (365 * year) - (year // 4).
	month := 5 * c + 456 quo: 153.
	day := c - (153 * month - 457 quo: 5).
	month > 12
		ifTrue: 
			[year := year + 1.
			month := month - 12].
	^aBlock
		value: day
		value: month
		value: year!

dayOfMonth
	"Answer an <integer> between 1 and 31, inclusive, representing the day of the month in the local time of the receiver, which includes the receiver."

	^self dayMonthYearDo: [:d :m :y | d]!

dayOfWeek
	"Answer an <integer> between 1 and 7, inclusive, representing the day  of the week in the local time of the receiver, which includes the receiver.
	Sunday is 1, Monday 2, and so on."

	^rataDie \\ 7 + 1!

dayOfWeekAbbreviation
	"Answer a <readableString> which is the abbreviated name of the day of the week, in the local time of the receiver, that includes the receiver."

	^Locale default dayOfWeekAbbreviation: self dayOfWeek!

dayOfWeekName
	"Answer a <readableString> which is the name of the day of the week, in the local time of the receiver, that includes the receiver."

	^Locale default dayOfWeekName: self dayOfWeek!

dayOfYear
	"Answer an <integer> in the range [1, 366], representing the day of the year in the local time of the receiver, that includes the receiver."

	^self dayMonthYearDo: [:d :m :y | (self class daysToMonth: m forYear: y) + d]!

displayOn: aWriteStream 
	"Append,to the <puttableStream> argument, a <String> whose characters are a representation of the receiver as a user would want to see it.
	The format used is that defined by Windows for the current user locale (the same as used in the Windows file exporer)."

	Locale default displayDateTime: self on: aWriteStream!

hash
	"Answer the SmallInteger hash value for the receiver."

	"Given that a pair of DateAndTimes representing the same UTC time, regardless of offset, are considered equal, then the hash of a DateAndTime must also be independent of offset. Recall that #asSeconds returns the number of seconds since 00:00h 01-Jan-1901 UTC."

	^self asSeconds hash!

hour
	"Answer an <integer> in the range [0, 24), representing the hour of the day in the local time of the receiver."

	^self hour24!

hour12
	"Answer an <integer> in the range [1, 12], representing the hour of the day in the 12-hour clock of the local time of the receiver."

	^self hour24 - 1 \\ 12 + 1!

hour24
	"Answer an <integer> in the range [0, 24), representing the hour of the day in the 24-hour clock of the local time of the receiver."

	^seconds // Duration.SecondsPerHour!

isLeapYear
	"Answer whether the local time year which includes the receiver is a leap year."

	^self class isLeapYear: self year!

julianDate
	"Answer the receiver's Julian Date (see https://en.wikipedia.org/wiki/Julian_day).
		String streamContents: [:s | DateAndTime nowUTC julianDate asFloat printOn: s decimalPlaces: 5]
	"

	| jd |
	jd := (self asUTC + JulianDayOffset).
	^jd rataDie + (jd seconds / Duration.SecondsPerDay)!

julianDayNumber
	"Answer the receiver's Julian Day Number, Note that this is the JDN, not the CJDN, so rotates at noon UTC, or in other words 'The Julian Day Number (JDN) is the integer assigned to a whole solar day in the Julian day count starting from noon Universal time' (see https://en.wikipedia.org/wiki/Julian_day)."

	^(self asUTC + JulianDayOffset) rataDie!

lilianDayNumber
	"Answer the receiver's Lilian Day Number (see https://en.wikipedia.org/wiki/Lilian_date)."

	"We must convert from Rata Die - see https://en.wikipedia.org/wiki/Rata_Die"

	^self rataDie + LilianDayOffset!

localSeconds
	"Answer a <rational> that is the number of seconds (including fractional part) that the receiver is past the traditional Smalltalk Epoch (i.e. 1901-01-01T00:00:00+00:00) in local time.
	Note that is likely to be a <LargeInteger>, or a <Fraction> with <LargeInteger> numerator (and possibly denominator)."

	^(rataDie - SmalltalkEpochRD) * Duration.SecondsPerDay + seconds!

meridianAbbreviation
	"Answer a <readableString> which is the abbreviated name of the half of the day in the local time of the receiver, which includes the receiver."

	^self hour24 < 12 ifTrue: [Locale default amDesignator] ifFalse: [Locale default pmDesignator]!

midnight
	"Answer a new <DateAndTime> representing 00:00h at the start of the receiver's day."

	^self dayMonthYearDo: 
			[:d :m :y |
			DateAndTime
				year: y
				month: m
				day: d
				offset: offset]!

minute
	"Answer an <integer> in the range [0,60), representing the minute of the hour in the local time of the receiver."

	^seconds // 60 \\ 60!

month
	"Answer an <integer> between 1 and 12, inclusive, representing the month of the year in the local time of the receiver."

	^self dayMonthYearDo: [:d :m :y | m]!

monthAbbreviation
	"Answer a <readableString> which is the abbreviated name of the month of the year in the local time of the receiver, which includes the receiver."

	^Locale default monthAbbreviation: self month!

monthName
	"Answer a <readableString> which is the name of the month of the year in the local time of the receiver, which includes the receiver."

	^Locale default monthName: self month!

nanosecond
	"Answer a <rational> in the range [0,1000000000), representing the nanosecond of the second of the local time of the receiver, including any fractional part."

	^seconds fractionPart * 1e9!

offset
	"Answer a <Duration> which is the difference between the local time of the receiver and UTC, at the time of the receiver."

	^offset!

offset: aDuration
	"Answer a <DateAndTime> equivalent to the receiver, but with its local time offset from UTC by the <Duration>, offset."

	^aDuration asSeconds == offset asSeconds
		ifTrue: [self]
		ifFalse: 
			[self class validateOffset: aDuration.
			DateAndTime utcSeconds: self asSeconds offset: aDuration]!

printOn: aStream
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. This will be in the format as defined in ANSI Smalltalk for the DateAndTime>>printString message (5.8.1.24). See #printOn:withLeadingSpace: for a description of this format."

	self printOn: aStream withLeadingSpace: true!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. The format is defined by the <readableString> argument, aString, the format characters of which are as described Locale>>#dateFormat and Locale>>#timeFormat methods. If the format argument is nil then the receiver is printed to the stream in the currently configured default date and time formats of the host OS."

	Locale default printDateTime: self on: aStream format: aString
!

printOn: aWriteStream withLeadingSpace: aBoolean
	"Append a default string representation of the receiver to the <puttableStream>, aWriteStream.
	The string that is written will represent be expressed in the the local time of the receiver, including the offset from UTC. All dates are in the astronomical Gregorian calendar. 
	The result will be of the format:
		-YYYY-MM-DDThh:mm:ss.s+ZZ:zz:z
	where the z's specify the offset from UTC. e.g. 8:33:14.321 PM EST Jan 5, 1200 B.C.
	should be:
		-1199-01-05T20:33:14.321-05:00
	Try it:
		(DateAndTime fromString: '-1199-01-05T20:33:14.321-05:00')
	"

	| offsetFormat |
	(aBoolean and: [rataDie >= 0]) ifTrue: [aWriteStream space].
	offsetFormat := '+hh:mm'.
	"It doesn't really make sense to have TZ offsets with seconds components, but the ANSI spec allows this and expects the printed format to include seconds and even fractions of a second."
	offset seconds = 0 ifFalse: [offsetFormat := offsetFormat, ':sfffffffff'].
	Locale invariant
		printDateTime: self
			on: aWriteStream
			format: 'yyyy\-MM\-dd\THH:mm:ssfffffffff';
		printDuration: offset
			on: aWriteStream
			format: offsetFormat!

printStringFormat: aString
	"Answer a short textual description of the receiver in a format is defined by the <readableString> argument, aString, the format characters of which are as described Locale>>#dateFormat and Locale>>#timeFormat methods. If the format argument is nil then the receiver is printed in the currently configured default date and time formats of the host OS."

	^String streamContents: [:s | Locale default printDateTime: self on: s format: aString]
!

rataDie
	"Answer the Rata Die day number, which is a count of days where 1 represents 1st Jan 1 (AD) 00:00h."

	^rataDie!

second
	"Answer a <rational> in the range [0, 60), representing the second of the minute of the local time of the receiver, including any fractional part."

	^seconds \\ 60!

seconds
	"Answer the number of seconds past midnight in the local time of the receiver."

	^seconds!

setRataDie: anInteger seconds: aNumber offset: aDuration
	rataDie := anInteger.
	seconds := aNumber.
	offset := aDuration.
	^self!

subtractFromDateAndTime: aDateAndTime 
	"Private - Part of a double dispatch for <DateAndTime> subtraction. 
	Answers a <Duration> representing the argument subtracted from the receiver."

	^Duration seconds: aDateAndTime asSeconds - self asSeconds!

timeZoneAbbreviation
	"Answer a <readableString> that is the abbreviated name in the default locale of the time zone of the receiver."

	"It seems to be an error in the standard to have included a method that cannot be implemented satisfactorily given that the information provided when creating instances of DateAndTime does not specify time zone information other than as an offset from UTC. There are typically many potential time zones associated with any particular offset. Consequently we always answer the offset prefixed with UTC, e.g. 'UTC-08:00'"

	| stream answer |
	answer := String new: 9.
	stream := answer writeStream.
	stream nextPutAll: 'UTC'.
	Locale default
		printDuration: self offset
		on: stream
		format: '+hh:mm'.
	^answer
	"
DateAndTime now timeZoneAbbreviation
"!

timeZoneName
	"Answer a <readableString> that is the name in the default locale of the time zone of the receiver."

	"It seems to be an error in the standard to have included a method that cannot be implemented satisfactorily given that the information provided when creating instances of DateAndTime does not specify time zone information other than as an offset from UTC. There are typically many potential time zones associated with any particular offset, especially when daylight saving time is taken into consideration. Consequently we only answer an actual time zone name when the offset is the same as the local time, in which case we answer the local time zone name. Otherwise we answer the offset prefixed with UTC, e.g. 'UTC-08:00'"

	| tzi |
	tzi := Locale timeZoneInformation.
	tzi offset = self offset ifTrue: [^tzi currentName].
	^self timeZoneAbbreviation!

year
	"Answer an <integer> representing the year of the local time which includes the receiver."

	^self dayMonthYearDo: [:d :m :y | y]! !
!DateAndTime categoriesFor: #-!arithmetic!public! !
!DateAndTime categoriesFor: #+!arithmetic!public! !
!DateAndTime categoriesFor: #<!comparing!public! !
!DateAndTime categoriesFor: #=!comparing!public! !
!DateAndTime categoriesFor: #asDate!converting!public! !
!DateAndTime categoriesFor: #asLocal!comparing!public! !
!DateAndTime categoriesFor: #asParameter!converting!public! !
!DateAndTime categoriesFor: #asSeconds!converting!public! !
!DateAndTime categoriesFor: #asTime!converting!public! !
!DateAndTime categoriesFor: #asUnixTime!converting!public! !
!DateAndTime categoriesFor: #asUTC!converting!public! !
!DateAndTime categoriesFor: #day!accessing!public! !
!DateAndTime categoriesFor: #dayMonthYearDo:!helpers!private! !
!DateAndTime categoriesFor: #dayOfMonth!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeek!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeekAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeekName!accessing!public! !
!DateAndTime categoriesFor: #dayOfYear!accessing!public! !
!DateAndTime categoriesFor: #displayOn:!printing!public! !
!DateAndTime categoriesFor: #hash!comparing!public! !
!DateAndTime categoriesFor: #hour!accessing!public! !
!DateAndTime categoriesFor: #hour12!accessing!public! !
!DateAndTime categoriesFor: #hour24!accessing!public! !
!DateAndTime categoriesFor: #isLeapYear!public!testing! !
!DateAndTime categoriesFor: #julianDate!accessing!public! !
!DateAndTime categoriesFor: #julianDayNumber!accessing!public! !
!DateAndTime categoriesFor: #lilianDayNumber!accessing!public! !
!DateAndTime categoriesFor: #localSeconds!converting!public! !
!DateAndTime categoriesFor: #meridianAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #midnight!accessing!public! !
!DateAndTime categoriesFor: #minute!accessing!public! !
!DateAndTime categoriesFor: #month!accessing!public! !
!DateAndTime categoriesFor: #monthAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #monthName!accessing!public! !
!DateAndTime categoriesFor: #nanosecond!accessing!public! !
!DateAndTime categoriesFor: #offset!accessing!public! !
!DateAndTime categoriesFor: #offset:!converting!public! !
!DateAndTime categoriesFor: #printOn:!printing!public! !
!DateAndTime categoriesFor: #printOn:format:!printing!public! !
!DateAndTime categoriesFor: #printOn:withLeadingSpace:!printing!public! !
!DateAndTime categoriesFor: #printStringFormat:!printing!public! !
!DateAndTime categoriesFor: #rataDie!accessing!public! !
!DateAndTime categoriesFor: #second!accessing!public! !
!DateAndTime categoriesFor: #seconds!accessing!public! !
!DateAndTime categoriesFor: #setRataDie:seconds:offset:!initializing!private! !
!DateAndTime categoriesFor: #subtractFromDateAndTime:!arithmetic!double dispatch!private! !
!DateAndTime categoriesFor: #timeZoneAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #timeZoneName!accessing!public! !
!DateAndTime categoriesFor: #year!accessing!public! !

DateAndTime methodProtocol: #DateAndTime attributes: #(#ansi #readOnly) selectors: #(#- #~~ #~= #+ #< #<= #= #== #> #>= #asLocal #asUTC #between:and: #class #copy #dayOfMonth #dayOfWeek #dayOfWeekAbbreviation #dayOfWeekName #dayOfYear #doesNotUnderstand: #error: #hash #hour #hour12 #hour24 #identityHash #isKindOf: #isLeapYear #isMemberOf: #isNil #max: #meridianAbbreviation #min: #minute #month #monthAbbreviation #monthName #notNil #offset #offset: #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #second #timeZoneAbbreviation #timeZoneName #year #yourself)!

!DateAndTime class methodsFor!

clockPrecision
	"Answer a <Duration> such that after that period of time passes, #now is guaranteed
	to answer a different <DateAndTime>."

	^VMLibrary default isWindows8OrGreater
		ifTrue: 
			["MSDN says that the resolution for GetSystemTimePreciseAsFileTime is <1uS. The resolution of FILETIMEs is 100nS"
			1 microseconds]
		ifFalse: 
			["Otherwise, the best we can achieve is the current system clock resolution, which by default is 15.6mS"
			Delay.Resolution microseconds]!

daysInMonth: monthInteger forYear: yearInteger 
	"Answer the number of days in monthInteger for yearInteger. 
	Adjustment is for February in leap years"

	| days |
	days := #(31 28 31 30 31 30 31 31 30 31 30 31) at: monthInteger.
	(monthInteger = 2 and: [self isLeapYear: yearInteger]) ifTrue: [^days + 1].
	^days!

daysToMonth: monthInteger forYear: yearInteger 
	"Answer the number of days preceeding monthInteger for yearInteger. 
	Adjustment is for all months after February in leap years"

	| days |
	days := #(0 31 59 90 120 151 181 212 243 273 304 334) at: monthInteger.
	(monthInteger > 2 and: [self isLeapYear: yearInteger]) ifTrue: [^days + 1].
	^days!

encodeRataDieYear: year month: month day: dayOfMonth 
	"Private - Encode day in month in year into an Integer representing the number of days
	since 1/1/1 (= day 1). Will answer a negative Integer for earlier dates
	See http://www.capecod.net/~pbaum/date/date0.htm"

	| m y |
	m := month.
	y := year.
	m < 3 
		ifTrue: 
			[m := m + 12.
			y := y - 1].
	^dayOfMonth + ((153 * m - 457) // 5) + (365 * y) + (y // 4) - (y // 100) + (y // 400) - 306!

errorInvalidFormat
	"Private - Raise an error that some attempt to create an instance of the receiver failed because the some input was in the wrong format."

	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	^InvalidFormat signalWith: self!

fromDate: aDate time: aTime
	"Answers a new <DateAndTime> initialized from the <Date> and <Time> arguments, assumed to specify a local time."

	^aDate dayMonthYearDo: 
			[:d :m :y |
			self
				year: y
				month: m
				day: d
				hour: aTime hour24
				minute: aTime minute
				second: aTime second]!

fromString: aString 
	"Answer a new <DateAndTime> constructed from aString <String> in the Reg. Ex. format:
		[- ]YYYY-MM-DDThh:mm:ss(.ss*)?[-+]ZZ:zz(:zz*)?.
	which represents a local date and time."

	^self readFrom: aString readStream!

fromSYSTEMTIME: aSYSTEMTIME 
	^self fromSYSTEMTIME: aSYSTEMTIME offset: self localOffset!

fromSYSTEMTIME: aSYSTEMTIME offset: offset 
	"Answer a <DateAndTime> from SYSTEMTIME in local time."

	"2001/07/18 Harmon, R. Added for <DateAndTimeExtra factory>."
	^self 
		year: aSYSTEMTIME wYear
		month: aSYSTEMTIME wMonth
		day: aSYSTEMTIME wDay
		hour: aSYSTEMTIME wHour
		minute: aSYSTEMTIME wMinute
		second: aSYSTEMTIME wSecond + (aSYSTEMTIME wMilliseconds / 1000)
		offset: offset!

initialize
	self addClassConstant: 'SmalltalkEpochRD'
		value: (DateAndTime
				year: 1901
				day: 1
				offset: 0 hours) rataDie.
	self addClassConstant: 'UnixEpoch'
		value: (DateAndTime
				year: 1970
				day: 1
				offset: 0 hours).
	self addClassConstant: 'JulianDayOffset' value: 1721424 days + 12 hours.
	self addClassConstant: 'FiletimeEpochSeconds'
		value: (DateAndTime
				year: 1601
				day: 1
				hour: 0
				minute: 0
				second: 0
				offset: 0 hours) asSeconds.
	self addClassConstant: 'LilianDayOffset'
		value: ((DateAndTime
				year: 1582
				month: 10
				day: 15
				offset: 0 hours) rataDie - 1)
				* -1!

isLeapYear: anInteger
	"Answer true if the specified <integer> year is a leap year."

	^anInteger \\ 400 = 0 or: [anInteger \\ 4 = 0 and: [anInteger \\ 100 ~= 0]]!

localOffset
	"Answer the current local time offset (TimeZone) from the host OS."

	^Locale timeZoneInformation offset!

midnight
	^self now midnight!

now
	"Answer the current <DateAndTime> in local time.
		self now
	"

	| lib utcFileTime localFileTime offset |
	lib := KernelLibrary default.
	utcFileTime := LargeInteger newFixed: 8.
	lib getSystemTimePreciseAsFileTime: utcFileTime yourAddress.
	localFileTime := LargeInteger newFixed: 8.
	(lib fileTimeToLocalTime: utcFileTime yourAddress lpLocalFileTime: localFileTime yourAddress)
		ifFalse: [lib systemError].
	offset := self localOffset.
	^self utcSeconds: FiletimeEpochSeconds + (localFileTime / ##(1e9 / 100) - offset asSeconds)
		offset: offset!

nowUTC
	"Answer the current <DateAndTime> in UTC.
		self nowUTC
	"

	| filetime |
	"Strictly speaking a FILETIME is unsigned, and so could require up to a 12-byte LargeInteger, but we'll be Ok with 8-bytes until about 4pm on 15th May 30600."
	filetime := LargeInteger newFixed: 8.
	"Get the UTC FILETIME - this expresses the number of 100 nanosecond intervals since 00:00h on 1st Jan 1601 UTC"
	KernelLibrary default getSystemTimePreciseAsFileTime: filetime yourAddress.
	^self utcSeconds: FiletimeEpochSeconds + (filetime / ##(1e9 / 100)) offset: Duration.Zero!

readFrom: aStream
	"Answers a new instance of the receiver read from aStream <gettableStream> in the Reg. Ex. format:
		[- ]YYYY-MM-DDThh:mm:ss(.ss*)?[-+]ZZ:zz(:zz*)?."

	| sign yyyy month dd offset hh mm ss |
	aStream skipWhile: [:c | c isWhitespace].
	sign := (aStream peekFor: $-) ifTrue: [-1] ifFalse: [1].
	aStream peek isDigit ifFalse: [^self errorInvalidFormat].
	yyyy := Integer readFrom: aStream radix: 10.
	((yyyy between: 0 and: 9999) and: [(aStream peekFor: $-) and: [aStream peek isDigit]]) ifFalse: [^self errorInvalidFormat].
	month := Integer readFrom: aStream radix: 10.
	((month between: 1 and: 12) and: [(aStream peekFor: $-) and: [aStream peek isDigit]]) ifFalse: [^self errorInvalidFormat].
	dd := Integer readFrom: aStream radix: 10.
	((dd between: 1 and: 31) and: [(aStream peekFor: $T) and: [aStream peek isDigit]]) ifFalse: [^self errorInvalidFormat].
	hh := Integer readFrom: aStream radix: 10.
	((hh between: 0 and: 23) and: [(aStream peekFor: $:) and: [aStream peek isDigit]]) ifFalse: [^self errorInvalidFormat].
	mm := Integer readFrom: aStream radix: 10.
	((mm between: 0 and: 59) and: [(aStream peekFor: $:) and: [aStream peek isDigit]]) ifFalse: [^self errorInvalidFormat].
	ss := Integer readFrom: aStream radix: 10.
	(ss between: 0 and: 59) ifFalse: [^self errorInvalidFormat].
	(aStream peekFor: $.)
		ifTrue: 
			[| ff |
			aStream peek isDigit ifFalse: [^self errorInvalidFormat].
			ff := Integer readFrom: aStream radix: 10.
			ff == 0
				ifFalse: 
					[| scale |
					ff > 999999999 ifTrue: [^self errorInvalidFormat].
					scale := ff decimalDigitLength exp10.
					ss := ss + (ff / scale)]].
	offset := self readOffsetFrom: aStream.
	^self
		year: yyyy * sign
		month: month
		day: dd
		hour: hh
		minute: mm
		second: ss
		offset: offset!

readOffsetFrom: aStream
	| ch |
	ch := aStream peek.
	ch = $Z ifTrue: [^Duration.Zero].
	ch = $+ ifTrue: [aStream next] ifFalse: [ch = $- ifFalse: [^self localOffset]].
	^Duration readFrom: aStream withDays: false!

today
	"Answer a new <DateAndTime> representing midnight local time at the beginning of the current day."

	^self midnight!

tomorrow
	"Answer a new <DateAndTime> representing midnight local time on the next day."

	^self today + 1 days!

utcSeconds: aNumber offset: aDuration
	"Private - Answer a new <DateAndTime> representing aNumber of (UTC) seconds since 1/1/1901 (UTC), but at the time zone offset specified by the <Duration>, aDuration. 
	aNumber may be negative in which case the answer will be a <DateAndTime> prior to 1/1/1901."

	| localSeconds daysSinceEpoch |
	localSeconds := aNumber + aDuration asSeconds.
	daysSinceEpoch := localSeconds // Duration.SecondsPerDay.
	^self new
		setRataDie: daysSinceEpoch + SmalltalkEpochRD
		seconds: localSeconds - (daysSinceEpoch * Duration.SecondsPerDay)
		offset: aDuration!

validateOffset: aDuration
	"In reality there are only a certain number of discrete time zone offsets that are actually valid, however the ANSI standard does not specify any constraints so we limit our validation to checking that the offset is with +1 or -1 days."

	| offsetSeconds |
	offsetSeconds := aDuration asSeconds.
	(offsetSeconds > (0 - Duration.SecondsPerDay) and: [offsetSeconds < Duration.SecondsPerDay])
		ifFalse: 
			[InvalidArgumentError signal: aDuration printString , ' is not a valid time zone offset'
				with: 'offset']!

year: yearInteger day: ordinalDateInteger
	"Answer a new <DateAndTime> representing midnight local time on the specified ordinal date of the specified year."

	^self
		year: yearInteger
		day: ordinalDateInteger
		hour: 0
		minute: 0
		second: 0!

year: year day: dayOfYear hour: hour minute: minute second: second 
	"Answer a <DateAndTime> which is the <number> second, of the <integer> minute, of the <integer> hour, of the <integer> day of the year, dayOfYear, of the <integer> year, of the astronomical Gregorian calendar in implementation defined 
	local time, where
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 366,
		and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation the result is the least <DateAndTime> that conforms to the given parameters."

	^self 
		year: year
		day: dayOfYear
		hour: hour
		minute: minute
		second: second
		offset: self localOffset!

year: year day: dayOfYear hour: hour minute: minute second: second offset: offset
	"Answer a <DateAndTime> which is the <number> second, of the <integer> minute, of the <integer> hour, of the <integer> day of the year, dayOfYear, of the <integer> year, of the astronomical Gregorian calendar offset from UTC by the
	<Duration> offset, where 
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 366,
		and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation the result is the least <DateAndTime> that conforms to the given parameters."

	self assert: [dayOfYear >= 1 & (dayOfYear <= 366)].
	self assert: [hour >= 0 & (hour <= 23)].
	self assert: [minute >= 0 & (minute <= 59)].
	self assert: [second >= 0 & (second < 60)].
	^self new
		setRataDie: ((self
				encodeRataDieYear: year
				month: 1
				day: 1) + dayOfYear - 1)
		seconds: 	((hour * 60) + minute) * 60 + second asTrueFraction
		offset: offset!

year: yearInteger day: ordinalDateInteger offset: aDuration
	^self year: yearInteger day: ordinalDateInteger hour: 0 minute: 0 second: 0 offset: aDuration!

year: yearInteger month: monthInteger day: dayInteger
	"Answer a new <DateAndTime> representing midnight local time on the specified day of the specified month of the specified year."

	^self year: yearInteger month: monthInteger day: dayInteger hour: 0 minute: 0 second: 0!

year: year month: month day: dayOfMonth hour: hour minute: minute second: second 
	"Answer a <DateAndTime> which is the <number> second, of the <integer> minute, of the <integer> hour, of the <integer> day, dayOfMonth, of the
	<integer> month, of the <integer> year, of the astronomical Gregorian calendar in local time, where 
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 31,
		1 <= month <= 12, and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation the result is the least <DateAndTime> that conforms to the given parameters."

	^self 
		year: year
		month: month
		day: dayOfMonth
		hour: hour
		minute: minute
		second: second
		offset: self localOffset!

year: year month: month day: dayOfMonth hour: hour minute: minute second: second offset: offset
	"Answer a <DateAndTime> which is the <number> second, of the <integer> minute, of the <integer> hour, of the <integer> day, dayOfMonth, of the <integer> month, of the <integer> year, of the astronomical Gregorian calendar offset from UTC by the <Duration> offset, where:
		0 <= second < 60, 
		0 <= minute <= 59, 
		0 <= hour <= 23, 
		1 <= day <= DaysInMonthOfYear(month, year)
		1 <= month <= 12,
		year can be any <integer>, and
		-12 hours <= aDuration <= 14 hours.
	If the specified time does not exist in the local time defined by the implementation the result is the least <DateAndTime> that conforms to the given parameters."

	| daysInMonth |
	(month >= 1 and: [month <= 12])
		ifFalse: [^InvalidArgumentError signal: month printString , ' is outside [1, 12]' with: 'month'].
	daysInMonth := self daysInMonth: month forYear: year.
	(dayOfMonth >= 1 and: [dayOfMonth <= daysInMonth])
		ifFalse: 
			[^InvalidArgumentError
				signal: dayOfMonth printString , ' is outside [1, ' , daysInMonth printString , ']'
				with: 'dayOfMonth'].
	(hour >= 0 and: [hour < 24])
		ifFalse: [^InvalidArgumentError signal: hour printString , ' is outside [0, 24)' with: 'hour'].
	(minute >= 0 and: [minute < 60])
		ifFalse: [^InvalidArgumentError signal: minute printString , ' is outside [0, 60)' with: 'minute'].
	(second >= 0 and: [second < 60])
		ifFalse: [^InvalidArgumentError signal: second printString , ' is outside [0, 60)' with: 'second'].
	self validateOffset: offset.
	^self new
		setRataDie: (self
				encodeRataDieYear: year
				month: month
				day: dayOfMonth)
		seconds: ((hour	* 60) + minute) * 60 + second asTrueFraction
		offset: offset!

year: yearInteger month: monthInteger day: dayInteger offset: aDuration
	"Answer a <DateAndTime> which is midnight on the <integer> day, dayInteger, of the <integer> month, monthInteger, of the <integer> year, yearInteger, of the astronomical Gregorian 
	calendar at the <Duration> offset, aDuration, from UTC.
		1 <= dayInteger <= DaysInMonthOfYear(monthInteger, yearInteger)
		1 <= monthInteger <= 12, 
		yearInteger can be any <integer>, positive or negative,
		and -12 hours <= aDuration <= 14 hours."

	^self 
		year: yearInteger
		month: monthInteger
		day: dayInteger
		hour: 0
		minute: 0
		second: 0
		offset: aDuration!

yesterday
	"Answer a new <DateAndTime> representing midnight local time on the previous day."

	^self today - 1 days! !
!DateAndTime class categoriesFor: #clockPrecision!constants!public! !
!DateAndTime class categoriesFor: #daysInMonth:forYear:!enquiries!public! !
!DateAndTime class categoriesFor: #daysToMonth:forYear:!enquiries!public! !
!DateAndTime class categoriesFor: #encodeRataDieYear:month:day:!helpers!private! !
!DateAndTime class categoriesFor: #errorInvalidFormat!exceptions!public! !
!DateAndTime class categoriesFor: #fromDate:time:!instance creation!public! !
!DateAndTime class categoriesFor: #fromString:!instance creation!public! !
!DateAndTime class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!DateAndTime class categoriesFor: #fromSYSTEMTIME:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #initialize!class initialization!public! !
!DateAndTime class categoriesFor: #isLeapYear:!public!testing! !
!DateAndTime class categoriesFor: #localOffset!enquiries!public! !
!DateAndTime class categoriesFor: #midnight!instance creation!public! !
!DateAndTime class categoriesFor: #now!instance creation!public! !
!DateAndTime class categoriesFor: #nowUTC!instance creation!public! !
!DateAndTime class categoriesFor: #readFrom:!instance creation!public! !
!DateAndTime class categoriesFor: #readOffsetFrom:!helpers!private! !
!DateAndTime class categoriesFor: #today!instance creation!public! !
!DateAndTime class categoriesFor: #tomorrow!instance creation!public! !
!DateAndTime class categoriesFor: #utcSeconds:offset:!instance creation!private! !
!DateAndTime class categoriesFor: #validateOffset:!helpers!private! !
!DateAndTime class categoriesFor: #year:day:!instance creation!public! !
!DateAndTime class categoriesFor: #year:day:hour:minute:second:!instance creation!public! !
!DateAndTime class categoriesFor: #year:day:hour:minute:second:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #year:day:offset:!accessing!public! !
!DateAndTime class categoriesFor: #year:month:day:!instance creation!public! !
!DateAndTime class categoriesFor: #year:month:day:hour:minute:second:!instance creation!public! !
!DateAndTime class categoriesFor: #year:month:day:hour:minute:second:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #year:month:day:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #yesterday!instance creation!public! !

DateAndTime class methodProtocol: #'DateAndTime factory' attributes: #(#ansi #readOnly) selectors: #(#~~ #~= #= #== #class #clockPrecision #copy #doesNotUnderstand: #error: #hash #identityHash #isKindOf: #isMemberOf: #isNil #notNil #now #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #year:day:hour:minute:second: #year:day:hour:minute:second:offset: #year:month:day:hour:minute:second: #year:month:day:hour:minute:second:offset: #yourself)!

