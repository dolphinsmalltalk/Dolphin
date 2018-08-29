"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #DateAndTime
	instanceVariableNames: 'seconds timeZoneOffset fieldValues'
	classVariableNames: 'DayOfMonth DayOfWeek Hour Minute Month Second Year'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
DateAndTime guid: (GUID fromString: '{87b4c653-026e-11d3-9fd7-00a0cc3e4a32}')!
DateAndTime comment: 'See [DolphinImageFolder]/Idb/Documentation for details

(C) 2005 Ian Bartholomew
ian@idb.me.uk
Public Domain Freeware'!
!DateAndTime categoriesForClass!IDB Goodies!Magnitude-General! !
!DateAndTime methodsFor!

- operand 
	"Answer a <DateAndTime>, or a <Duration> that is the result of subtracting the 
	<DateAndTime>, or <Duration>, argument from the receiver.
	If the argument is a <DateAndTime>, then answer a <Duration> whose value
	is the period of time between the argument and the receiver. The answer may be
	a negative <Duration> if the argument is prior to the receiver in time."

	^operand subtractFromDateAndTime: self!

+ operand 
	"Answer the result of adding the <Duration> argument, operand to
	the receiver. More specifically: Answer a <DateAndTime> that represents 
	the UTC time that is the <Duration> argument, operand, after the receiver, 
	and whose local time is the same as the receiver's. If the argument is a negative
	<Duration>, then the result is a <DateAndTime> prior to the receiver."

	^self class seconds: seconds + operand asSeconds offset: self offset!

< operand 
	"Answer whether the receiver is less than the <DateAndTime> argument, operand,
	i.e. answer whether the receiver is prior to UTC time represented by the argument."

	^self asSecondsUTC < operand asSecondsUTC	"Equivalent to -
	^self offset = operand offset
		ifTrue: [self < operand]
		ifFalse: [self asUTC < operand asUTC]"!

= comparand 
	"Answer whether the argument is a <DateAndTime> representing the same UTC
	time as the receiver. The local times of the receiver and the operand are ignored."

	^self species == comparand species 
		and: [self asSecondsUTC = comparand asSecondsUTC	"Equivalent to -
	^self asUTC = operand asUTC"]!

> operand 
	"Answer whether the receiver is greater than the <DateAndTime> argument, operand,
	i.e. answer whether the receiver is after the UTC time represented by the argument."

	^self asSecondsUTC > operand asSecondsUTC	"Equivalent to -
	^self offset = operand offset
		ifTrue: [self > operand]
		ifFalse: [self asUTC > operand asUTC]"!

asLocal
	"Answer a <DateAndTime> that represents the same UTC time as the receiver,
	but in the local time specified by the implementation."

	^self class seconds: self asSecondsUTC + self class defaultOffset asSeconds
		offset: self class defaultOffset	"Equivalent to -
	^self asUTC offset: self class defaultOffset"!

asSeconds
	"Answer the receiver as the number of seconds (includion fractional part) since 00:00 1/1/1.
	Always answers an Integer of Fraction"

	^seconds!

asSecondsUTC
	"Answer the receiver as the number of seconds (includion fractional part) since 00:00 1/1/1
	but corrected to UTC. Always answers an Integer of Fraction"

	^seconds + timeZoneOffset asSeconds negated!

asUTC
	"Answer a <DateAndTime> that represents the same absolute time as the receiver
	but in the local time UTC."

	^self class seconds: self asSecondsUTC offset: Duration zero!

dayOfMonth
	"Answer an <integer> between 1 and 31, inclusive, representing the day 
	of the month in the local time of the receiver, which includes the receiver."

	^self decodeRataDie at: DayOfMonth!

dayOfWeek
	"Answer an <integer> between 1 and 7, inclusive, representing the day 
	of the week in the local time of the receiver, which includes the receiver.
	Sunday is 1, Monday 2, and so on."

	^self decodeRataDie at: DayOfWeek!

dayOfWeekAbbreviation
	"Answer a <readableString> which is the abbreviated  name of the day of 
	the week in the local time of the receiver, which includes the receiver.
	(idb) api needs mon=1 through to sun=7 (sigh)"

	^Locale default nameOfDay: (#(7 1 2 3 4 5 6) at: self dayOfWeek) abbrev: true!

dayOfWeekName
	"Answer a <readableString> which is the name of the day of the week in 
	the local time of the receiver, which includes the receiver.
	(idb) api needs mon=1 through to sun=7 (sigh)"

	^Locale default nameOfDay: (#(7 1 2 3 4 5 6) at: self dayOfWeek) abbrev: false!

dayOfYear
	"Answer an <integer> between 1 and 366, inclusive, representing the day 
	of the year in the local time of the receiver, which includes the receiver."

	^(self class daysToMonth: self month forYear: self year) + self dayOfMonth!

decodeRataDie
	"Decode the seconds count of the receiver to y/m/d/h/m/s and cache 
	in the fieldValues instVar. Only do this once as D&T are immutable.
	See http://www.capecod.net/~pbaum/date/date0.htm"

	| date time z h a b c dayOfMonth month year |
	fieldValues isNil ifFalse: [^fieldValues].
	fieldValues := Array new: 7.
	date := seconds // ##(24 * 60 * 60).
	time := seconds \\ ##(24 * 60 * 60).
	z := date + 306.
	h := 100 * z - 25.
	a := (h / 3652425) floor.
	b := a - (a / 4) floor.
	year := ((100 * b + h) / 36525) floor.
	c := b + z - (365 * year) - (year / 4) floor.
	month := ((5 * c + 456) / 153) truncated.
	dayOfMonth := c - ((153 * month - 457) / 5) truncated.
	month > 12 
		ifTrue: 
			[year := year + 1.
			month := month - 12].
	fieldValues
		at: Year put: year;
		at: Month put: month;
		at: DayOfMonth put: dayOfMonth;
		at: Hour put: (time rem: ##(24 * 60 * 60)) // ##(60 * 60);
		at: Minute put: (time rem: ##(60 * 60)) // 60;
		at: Second put: (time rem: 60);
		at: DayOfWeek put: date \\ 7 + 1.
	^fieldValues!

hash
	"Answer the SmallInteger hash value for the receiver. Use asUTC because
	#= uses this and the answers must correspond"

	^self asSecondsUTC hash!

hour
	"Answer an <integer> between 0 and 23, inclusive, representing the hour
	of the day in the local time of the receiver. This may be in either the 12 or 24 hour clock."

	^self hour24!

hour12
	"Answer an <integer> between 1 and 12, inclusive, representing the hour
	of the day in the 12-hour clock of the local time of the receiver."

	| hour12 |
	(hour12 := self hour \\ 12) = 0 ifTrue: [^12].
	^hour12!

hour24
	"Answer an <integer> between 0 and 23, inclusive, representing the hour
	of the day in the 24-hour clock of the local time of the receiver."

	^self decodeRataDie at: Hour!

isLeapYear
	"Answer whether the local time year which includes the receiver is a leap year."

	^self class isLeapYear: self year!

meridianAbbreviation
	"Answer a <readableString> which is the abbreviated name of the half
	of the day in the local time of the receiver, which includes the receiver."

	^self hour < 12 ifTrue: [Locale default amDesignator] ifFalse: [Locale default pmDesignator]!

minute
	"Answer an <integer> between 0 and 59, inclusive, representing the minute
	of the hour in the local time of the receiver."

	^self decodeRataDie at: Minute!

month
	"Answer an <integer> between 1 and 12, inclusive, representing the month
	of the year in the local time of the receiver."

	^self decodeRataDie at: Month!

monthAbbreviation
	"Answer a <readableString> which is the abbreviated  name of the month of 
	the year in the local time of the receiver, which includes the receiver."

	^Locale default nameOfMonth: self month abbrev: true!

monthName
	"Answer a <readableString> which is the name of the month of  the 
	year in the local time of the receiver, which includes the receiver."

	^Locale default nameOfMonth: self month abbrev: false!

offset
	"Answer a <Duration> which is the difference between the local time
	of the receiver, and UTC at the time of the receiver."

	^timeZoneOffset!

offset: aDuration 
	"Answer a <DateAndTime> equivalent to the receiver, but with its
	local time offset from UTC by the <Duration>, offset.
	(idb) to +13 as there is a TZ at +13 (Tonga)

	x := DateAndTime now.   --> 2001-07-20T22:31:14.467+01:00
	y := x offset: (Duration hours: -5).  --> 2001-07-20T16:31:14.467-05:0
	x = y --> true

	Is that right????"

	self assert: 
			[aDuration >= ##(Duration 
						days: 0
						hours: -12
						minutes: 0
						seconds: 0) 
				& (aDuration <= ##(Duration 
								days: 0
								hours: 13
								minutes: 0
								seconds: 0))].
	^DateAndTime seconds: self asSecondsUTC + aDuration asSeconds offset: aDuration!

printOn: target 
	"Append a default string representation of the receiver to the <readableStream>.
	The string written to target will represent the UTC time of the receiver offset from
	UTC by the offset of the receiver. All dates are in the astronomical Gregorian
	calendar. The result will be of the format:
		-YYYY-MM-DDThh:mm:ss.s+ZZ:zz:z
	where the z's specify the offset from UTC. e.g. 8:33:14.321 PM EST Jan 5, 1200 B.C.
	would be:
		-1199-01-05T20:33:14.321-05:00"

	target
		nextPut: (self year < 0 ifTrue: [$-] ifFalse: [Character space]);
		nextPutAll: ('%04d' sprintfWith: self year abs);
		nextPutAll: ('-%02d' sprintfWith: self month);
		nextPutAll: ('-%02d' sprintfWith: self dayOfMonth);
		nextPutAll: ('T%02d' sprintfWith: self hour24);
		nextPutAll: (':%02d' sprintfWith: self minute).
	target nextPut: $:.
	self second abs < 10 ifTrue: [target nextPut: $0].
	self second fractionPart isZero 
		ifTrue: [target print: self second]
		ifFalse: 
			[| s |
			s := String writeStream.
			self second abs asFloat printOn: s decimalPlaces: 6.
			target nextPutAll: s contents trimZeros].
	target
		nextPut: (self offset positive ifTrue: [$+] ifFalse: [$-]);
		nextPutAll: ('%02d' sprintfWith: self offset hours abs);
		nextPutAll: (':%02d' sprintfWith: self offset minutes abs).
	self offset seconds isZero 
		ifFalse: 
			[target nextPut: $:.
			self offset seconds fractionPart isZero 
				ifTrue: [target print: self offset seconds]
				ifFalse: [target print: (self offset seconds abs asFloat roundTo: 1.0e-002)]]!

second
	"Answer a <number> in the range 0 <= s < 60, representing the second
	of the minute of the local time of the receiver, including any fractional part."

	^self decodeRataDie at: Second!

setSeconds: aNumber offset: aDuration 
	"Initialize the receiver with the appropriate values"

	seconds := aNumber.
	timeZoneOffset := aDuration!

subtractFromDateAndTime: aDateAndTime 
	"Part of a double dispatch for <DateAndTime> subtraction. 
	Answers a <Duration> representing the argument subtracted from the receiver.

	NB.This operation does not match the selector as the selector is fixed (part of a 
	double dispatch) and the operation is done this way to avoid extra calculations 
	that would be needed to comply with ANSI if performed in the order specified 
	by the selector"

	^Duration seconds: aDateAndTime asSecondsUTC - self asSecondsUTC!

timeZoneAbbreviation
	"Answer a <readableString> which is the abbreviated  name of the month of 
	the time zone of the local time of the receiver.
	(idb) This isn't right but I can't see how you can decide which TimeZone information
	this method should answer. One offset can refer to different TZ descriptions?"

	^(String writeStream)
		nextPutAll: 'GMT ';
		nextPut: (self offset positive ifTrue: [$+] ifFalse: [$-]);
		print: (self offset asSeconds abs / 3600 roundTo: 1.0e-002);
		contents!

timeZoneName
	"Answer a <readableString> which is the name of the month of 
	the time zone of the local time of the receiver.
	(idb) see comment in #timeZone"

	^self timeZoneAbbreviation!

year
	"Answer an <integer> representing the year of the local time which
	includes the receiver."

	^self decodeRataDie at: Year! !
!DateAndTime categoriesFor: #-!arithmetic!public! !
!DateAndTime categoriesFor: #+!arithmetic!public! !
!DateAndTime categoriesFor: #<!comparing!public! !
!DateAndTime categoriesFor: #=!comparing!public! !
!DateAndTime categoriesFor: #>!comparing!public! !
!DateAndTime categoriesFor: #asLocal!comparing!public! !
!DateAndTime categoriesFor: #asSeconds!accessing!public! !
!DateAndTime categoriesFor: #asSecondsUTC!accessing!public! !
!DateAndTime categoriesFor: #asUTC!converting!public! !
!DateAndTime categoriesFor: #dayOfMonth!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeek!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeekAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #dayOfWeekName!accessing!public! !
!DateAndTime categoriesFor: #dayOfYear!accessing!public! !
!DateAndTime categoriesFor: #decodeRataDie!converting!public! !
!DateAndTime categoriesFor: #hash!comparing!public! !
!DateAndTime categoriesFor: #hour!accessing!public! !
!DateAndTime categoriesFor: #hour12!accessing!public! !
!DateAndTime categoriesFor: #hour24!accessing!public! !
!DateAndTime categoriesFor: #isLeapYear!public!testing! !
!DateAndTime categoriesFor: #meridianAbbreviation!constants!public! !
!DateAndTime categoriesFor: #minute!accessing!public! !
!DateAndTime categoriesFor: #month!accessing!public! !
!DateAndTime categoriesFor: #monthAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #monthName!accessing!public! !
!DateAndTime categoriesFor: #offset!accessing!public! !
!DateAndTime categoriesFor: #offset:!converting!public! !
!DateAndTime categoriesFor: #printOn:!printing!public! !
!DateAndTime categoriesFor: #second!accessing!public! !
!DateAndTime categoriesFor: #setSeconds:offset:!initializing!public! !
!DateAndTime categoriesFor: #subtractFromDateAndTime:!arithmetic!double dispatch!public! !
!DateAndTime categoriesFor: #timeZoneAbbreviation!accessing!public! !
!DateAndTime categoriesFor: #timeZoneName!accessing!public! !
!DateAndTime categoriesFor: #year!accessing!public! !

DateAndTime methodProtocol: #DateAndTime attributes: #(#ansi #readOnly) selectors: #(#- #~~ #~= #+ #< #<= #= #== #> #>= #asLocal #asUTC #between:and: #class #copy #dayOfMonth #dayOfWeek #dayOfWeekAbbreviation #dayOfWeekName #dayOfYear #doesNotUnderstand: #error: #hash #hour #hour12 #hour24 #identityHash #isKindOf: #isLeapYear #isMemberOf: #isNil #max: #meridianAbbreviation #min: #minute #month #monthAbbreviation #monthName #notNil #offset #offset: #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #second #timeZoneAbbreviation #timeZoneName #year #yourself)!

!DateAndTime class methodsFor!

clockPrecision
	"Answer a <Duration> such that after that period of time passes, #now is guaranteed
	to answer a different <DateAndTime>. Ideally this should be the minimum such duration.
	(idb) The #now method on my box (Win2000) answers with a 10mS precision.  If we assume
	that the current machine talkes less than 10 mS to execute #now (reasonable?) then the 
	minimum clockPrecision of #now is 10mS

	Test using the following. Use a Bag to see how many of each occurs (About 1%
	are above 10mS on my box (GC?))
	diff := Set new.
		current := SYSTEMTIME now wMilliseconds.
		1000000 timesRepeat: [
			now := SYSTEMTIME now wMilliseconds.
			now = current
				ifFalse: [
					now > current ifTrue: [diff add: now - current].
					current := now]].
			diff asSortedCollection first / 1000"

	^Duration seconds: 1 / 100!

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

defaultOffset
	"Answer the offset (TimeZone) set for the current machine"

	| tzi current offset |
	tzi := TIME_ZONE_INFORMATION new.
	current := KernelLibrary default getTimeZoneInformation: tzi.
	offset := tzi bias.
	current = 1 ifTrue: [offset := offset + tzi standardBias].
	current = 2 ifTrue: [offset := offset + tzi daylightBias].	"offset = the change in minutes to go from LOCAL time to UTC time"
	^(Duration seconds: offset * 60) negated!

encodeRataDieYear: year day: dayOfYear 
	"Encode dayOfYear in year into an Integer representing the number of days
	since 1/1/1 (= day 1). Will answer a negative Integer for earlier dates.
	See http://www.capecod.net/~pbaum/date/date0.htm"

	^(self 
		encodeRataDieYear: year
		month: 1
		day: 1) + dayOfYear - 1!

encodeRataDieYear: year month: month day: dayOfMonth 
	"Encode day in month in year into an Integer representing the number of days
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

	#DtTmX.	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	^InvalidFormat signalWith: self!

fromDate: aDate time: aTime 
	"Answers a new instance of DateAndTime initialized from aDate and aTime.
	NB: The offset defaults to the machines current time zone"

	^self 
		year: aDate year
		month: aDate monthIndex
		day: aDate dayOfMonth
		hour: aTime hours
		minute: aTime minutes
		second: aTime seconds!

fromString: aString 
	"Answer a new <DateAndTime> constructed from aString <String> in the Reg. Ex. format:
		[- ]YYYY-MM-DDThh:mm:ss(.ss*)?[-+]ZZ:zz(:zz*)?.
which represents a local date and time."

	#DtTmX.	"2001/07/18 Harmon, R. Added for <DateAndTimeExtra factory>."
	^self readFrom: (ReadStream on: aString)!

fromSYSTEMTIME: aSYSTEMTIME offset: offset 
	"Answer a <DateAndTime> from SYSTEMTIME in local time."

	#DtTmX.	"2001/07/18 Harmon, R. Added for <DateAndTimeExtra factory>."
	^self 
		year: aSYSTEMTIME wYear
		month: aSYSTEMTIME wMonth
		day: aSYSTEMTIME wDay
		hour: aSYSTEMTIME wHour
		minute: aSYSTEMTIME wMinute
		second: aSYSTEMTIME wSecond + (aSYSTEMTIME wMilliseconds / 1000)
		offset: offset!

fromTimeStamp: aTimeStamp 
	"Answers a new instance of DateAndTime initialized from aTimeStamp
	NB: The offset defaults to the machines current time zone"

	^self fromDate: aTimeStamp date time: aTimeStamp time!

icon
	"Answers an Icon that can be used to represent this class"

	^TimeStamp icon!

initialize
	" Set up the offsets into the cache instVar fieldValues
	DateAndTime initialize  "

	Year := 1.
	Month := 2.
	DayOfMonth := 3.
	Hour := 4.
	Minute := 5.
	Second := 6.
	DayOfWeek := 7!

isLeapYear: year 
	"Answer true if year is a leap year"

	^year \\ 400 = 0 or: [year \\ 4 = 0 and: [year \\ 100 ~= 0]]!

now
	"Answer the current <DateAndTime> in local time. The new offset
	(TimeZone) is set to the value set bu #defaultOffset"

	^self fromSYSTEMTIME: SYSTEMTIME now offset: self defaultOffset!

readDateFrom: aStream 
	"Private - Answers yyyy, mm, and dd list read from aStream <gettableStream> in the Reg. Ex. format: YYYY-MM-DD.  Signal an error if not in specified format."

	| dd mm yyyy pos |
	#DtTmX.	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	pos := aStream position.
	yyyy := Integer readFrom: aStream radix: 10.
	pos + 4 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $-) ifFalse: [self errorInvalidFormat].
	pos := aStream position.
	mm := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $-) ifFalse: [self errorInvalidFormat].
	pos := aStream position.
	dd := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	^Array 
		with: yyyy
		with: mm
		with: dd!

readFrom: aStream 
	"Answers a new instance of the receiver read from aStream <gettableStream> in the Reg. Ex. format:
		[- ]YYYY-MM-DDThh:mm:ss(.ss*)?[-+]ZZ:zz(:zz*)?."

	| aYMD aHMS negativeDate offset newDT |
	#DtTmX.	"2001/07/18 Harmon, R. Added for <DateAndTimeExtra factory>."
	aStream skipWhile: [:c | c isWhitespace].
	negativeDate := aStream peekFor: $-.
	aYMD := self readDateFrom: aStream.
	(aStream peekFor: $T) ifFalse: [self errorInvalidFormat].
	aHMS := self readTimeFrom: aStream.
	aStream peekFor: $+.
	offset := Duration readOffsetFrom: aStream.
	newDT := self 
				year: (aYMD at: 1)
				month: (aYMD at: 2)
				day: (aYMD at: 3)
				hour: (aHMS at: 1)
				minute: (aHMS at: 2)
				second: (aHMS at: 3)
				offset: offset.
	negativeDate ifFalse: [^newDT].
	^self zero - newDT!

readTimeFrom: aStream 
	"Private - Answers hh, mm, and ss list read from aStream <gettableStream> in the Reg. Ex. format: hh:mm:ss(.ss*)?.  Signal an error if not in specified format."

	| hh mm ss pos |
	#DtTmX.	"2001/07/18 Harmon, R. Added for DateAndTimeExtra support."
	pos := aStream position.
	hh := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $:) ifFalse: [self errorInvalidFormat].
	pos := aStream position.
	mm := Integer readFrom: aStream radix: 10.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	(aStream peekFor: $:) ifFalse: [self errorInvalidFormat].
	pos := aStream position.
	ss := Number readFrom: aStream.
	pos + 2 = aStream position ifFalse: [self errorInvalidFormat].
	^Array 
		with: hh
		with: mm
		with: ss!

seconds: aNumber offset: aDuration 
	"Answer a new <DateAndTime> representing aNumber of seconds since 1/1/1. aNumber
	may be negative in which case the answer will be a <DateAndTime> prior to 1/1/1. 
	This method is private as it is for internal use only"

	^self new setSeconds: aNumber asRestrictedFraction offset: aDuration!

year: year day: dayOfYear hour: hour minute: minute second: second 
	"Answer a <DateAndTime> which is the <number> second, of the <integer>
	minute, of the <integer> hour, of the <integer> day of the year, dayOfYear, of the
	<integer> year, of the astronomical Gregorian calendar in implementation defined 
	local time, where
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 366,
		and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation
	the result is the least <DateAndTime> that conforms to the given parameters."

	^self 
		year: year
		day: dayOfYear
		hour: hour
		minute: minute
		second: second
		offset: self defaultOffset!

year: year day: dayOfYear hour: hour minute: minute second: second offset: offset 
	"Answer a <DateAndTime> which is the <number> second, of the <integer>
	minute, of the <integer> hour, of the <integer> day of the year, dayOfYear, of the
	<integer> year, of the astronomical Gregorian calendar offset from UTC by the
	<Duration> offset, where 
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 366,
		and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation
	the result is the least <DateAndTime> that conforms to the given parameters."

	self assert: [dayOfYear >= 1 & (dayOfYear <= 366)].
	self assert: [hour >= 0 & (hour <= 23)].
	self assert: [minute >= 0 & (minute <= 59)].
	self assert: [second >= 0 & (second < 60)].
	^self new 
		setSeconds: (((self encodeRataDieYear: year day: dayOfYear) * 24 + hour) * 60 + minute) * 60 
				+ second asRestrictedFraction
		offset: offset!

year: year month: month day: dayOfMonth hour: hour minute: minute second: second 
	"Answer a <DateAndTime> which is the <number> second, of the <integer>
	minute, of the <integer> hour, of the <integer> day, dayOfMonth, of the
	<integer> month, of the <integer> year, of the astronomical Gregorian 
	calendar in local time, where 
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 31,
		1 <= month <= 12, and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation
	the result is the least <DateAndTime> that conforms to the given parameters."

	^self 
		year: year
		month: month
		day: dayOfMonth
		hour: hour
		minute: minute
		second: second
		offset: self defaultOffset!

year: year month: month day: dayOfMonth hour: hour minute: minute second: second offset: offset 
	"Answer a <DateAndTime> which is the <number> second, of the <integer>
	minute, of the <integer> hour, of the <integer> day, dayOfMonth, of the
	<integer> month, of the <integer> year, of the astronomical Gregorian calendar 
	offset from UTC by the <Duration> offset, where 
		0 <= second < 60, 0 <= minute <= 59, 0 <= hour <= 23, 1 <= day <= 31,
		1 <= month <= 12, and year can be any <integer>. 
	If the specified time does not exist in the local time defined by the implementation
	the result is the least <DateAndTime> that conforms to the given parameters."

	self assert: [month >= 1 & (month <= 12)].
	self assert: [dayOfMonth >= 1 & (month <= 31)].
	self assert: [hour >= 0 & (hour <= 23)].
	self assert: [minute >= 0 & (minute <= 59)].
	self assert: [second >= 0 & (second < 60)].
	self assert: [(self daysInMonth: month forYear: year) >= dayOfMonth].
	^self new 
		setSeconds: (((self 
				encodeRataDieYear: year
				month: month
				day: dayOfMonth) * 24 
				+ hour) * 60 
				+ minute) * 60 
				+ second asRestrictedFraction
		offset: offset! !
!DateAndTime class categoriesFor: #clockPrecision!constants!public! !
!DateAndTime class categoriesFor: #daysInMonth:forYear:!enquiries!public! !
!DateAndTime class categoriesFor: #daysToMonth:forYear:!enquiries!public! !
!DateAndTime class categoriesFor: #defaultOffset!enquiries!public! !
!DateAndTime class categoriesFor: #encodeRataDieYear:day:!instance creation!operations!public! !
!DateAndTime class categoriesFor: #encodeRataDieYear:month:day:!instance creation!operations!public! !
!DateAndTime class categoriesFor: #errorInvalidFormat!exceptions!public! !
!DateAndTime class categoriesFor: #fromDate:time:!instance creation!public! !
!DateAndTime class categoriesFor: #fromString:!instance creation!public! !
!DateAndTime class categoriesFor: #fromSYSTEMTIME:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #fromTimeStamp:!instance creation!public! !
!DateAndTime class categoriesFor: #icon!constants!public! !
!DateAndTime class categoriesFor: #initialize!initializing!public! !
!DateAndTime class categoriesFor: #isLeapYear:!public!testing! !
!DateAndTime class categoriesFor: #now!instance creation!public! !
!DateAndTime class categoriesFor: #readDateFrom:!helpers!public! !
!DateAndTime class categoriesFor: #readFrom:!instance creation!public! !
!DateAndTime class categoriesFor: #readTimeFrom:!helpers!public! !
!DateAndTime class categoriesFor: #seconds:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #year:day:hour:minute:second:!instance creation!public! !
!DateAndTime class categoriesFor: #year:day:hour:minute:second:offset:!instance creation!public! !
!DateAndTime class categoriesFor: #year:month:day:hour:minute:second:!instance creation!public! !
!DateAndTime class categoriesFor: #year:month:day:hour:minute:second:offset:!instance creation!public! !

DateAndTime class methodProtocol: #'DateAndTime factory' attributes: #(#ansi #readOnly) selectors: #(#~~ #~= #= #== #class #clockPrecision #copy #doesNotUnderstand: #error: #hash #identityHash #isKindOf: #isMemberOf: #isNil #notNil #now #perform: #perform:with: #perform:with:with: #perform:with:with:with: #perform:withArguments: #printOn: #printString #respondsTo: #year:day:hour:minute:second: #year:day:hour:minute:second:offset: #year:month:day:hour:minute:second: #year:month:day:hour:minute:second:offset: #yourself)!

