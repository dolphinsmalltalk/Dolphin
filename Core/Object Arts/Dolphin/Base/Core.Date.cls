"Filed out from Dolphin Smalltalk"!

Core.Magnitude
	subclass: #'Core.Date'
	instanceVariableNames: 'days'
	classVariableNames: 'DaysInMonth DaysUntilMonth DefaultLongPicture YearPivot'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

Core.Date guid: (Core.GUID fromString: '{87b4c652-026e-11d3-9fd7-00a0cc3e4a32}')!

Core.Date comment: '`Date` is a class whose instances represent days of the year. The base date (day 0) is 1st January 1901.

Instance Variables:
	days				`<integer>`. Days since 1st Jan 1901

Class Variables:
	DefaultLongPicture	`<boolean>`. Controls whether or not the Date prints by default using the locale''s long or short representations.
	DaysUntilMonth		`Array` of the cumulative count of days in the year to the start of the month with the corresponding index.
	YearPivot			`<integer>`. Pivot year for 2 digit years. See #yearPivot
	DaysInMonth		`Array` with elements representing the number of days in the month with the corresponding index.

'!

!Core.Date categoriesForClass!Magnitude-General! !

!Core.Date methodsFor!

< aDate 
	"Answer whether the receiver precedes the argument, aDate"

	^self asDays < aDate asDays!

= aDate 
	"Answer whether the receiver is the same data as the argument, aDate"

	^self species == aDate species and: [self asDays = aDate asDays]!

addDays: dayCount
	"Answer a new Date that is dayCount days after the receiver."

	^self class fromDays: self asDays + dayCount!

addMonths: monthCount
	"Answer a new Date that is monthCount months before/after the receiver (monthCount can be negative).
	If the receiver's current day is not valid in the destination month and year, then the day is truncated:
	i.e. 31 Jan becomes 30 Mar if 2 months added."

	^self addMonths: monthCount desiredDay: 0!

addMonths: monthCount desiredDay: desiredDay 
	"Answer a new Date that is monthCount months before/after the receiver (monthCount can be negative). If the receiver's 
	current day is not valid in the destination month and year, then the day is truncated. i.e. 31 Jan becomes 30 Mar if 2 
	months added. If desiredDay is non-zero then this day is set (this allows the caller to retain a particular day number 
	even should it be truncated by intermediate arithmetic operations."

	^self dayMonthYearDo:  
			[:dd :mm :yy | 
			| dayOfMonth daysInMonth monthIndex year |
			monthIndex := mm + monthCount.
			year := yy.
			[monthIndex < 1] whileTrue: 
					[monthIndex := monthIndex + 12.
					year := year - 1].
			[monthIndex > 12] whileTrue: 
					[monthIndex := monthIndex - 12.
					year := year + 1].
			dayOfMonth := desiredDay == 0 ifTrue: [dd] ifFalse: [desiredDay].
			daysInMonth := self class daysInMonthIndex: monthIndex forYear: year.
			dayOfMonth := dayOfMonth min: daysInMonth.
			self class 
				newDay: dayOfMonth
				monthIndex: monthIndex
				year: year]!

addYears: yearCount
	"Answer a new Date that is yearCount years before/after the receiver (yearCount can be negative). If the receiver's 
	current day is not valid in the destination month and year, then the day is truncated. i.e. 31 Jan becomes 30 Mar
	if 2 months added."

	^self addYears: yearCount desiredDay: 0!

addYears: yearCount desiredDay: desiredDay 
	"Answer a new Date that is yearCount years before/after the receiver (yearCount can be negative). 
	If the receiver's current day is not valid in the destination month and year, then the day is truncated:
	 i.e. 31 Jan becomes 30 Mar if 2 months added. If desiredDay is non-zero then this day is set (this allows
	the caller to retain a particular day number even should it be truncated by intermediate arithmetic operations."

	^self dayMonthYearDo:  
			[ :dd :mm :yy | 
			| dayOfMonth year daysInMonth |
			year := yy + yearCount.
			dayOfMonth := desiredDay == 0 ifTrue: [dd] ifFalse: [desiredDay].
			daysInMonth := self class daysInMonthIndex: mm forYear: year.
			dayOfMonth := dayOfMonth min: daysInMonth.
			self class 
				newDay: dayOfMonth
				monthIndex: mm
				year: year]!

asDate
	^self!

asDateAndTime
	"Answer a new <DateAndTime> representing the midnight, local time, on the same date as the receiver."

	^DateAndTime year: self year day: self dayOfYear!

asDays
	"Answer the number of days since 1901 which the receiver represents. As Dolphin dates are
	stored in this format internally, this is a simple accessor."

	^days!

asFloat
	"Answer the OLEDATE representation of the receiver."

	^self asParameter asFloat!

asMilliseconds
	"Answer the number of milliseconds between a Time on January 1, 1901, and the same time in 
	the receiver's day (this will probably be a LargeInteger). Can be used to perform 
	arithmetic with Dates and Times."

	^self asSeconds * 1000!

asParameter
	"Answer the receiver in external system representation for passing to an external function call."

	^self asSYSTEMTIME!

asSeconds
	"Answer the number of seconds between a Time on January 1, 1901, and the same time in the receiver's
	day (this could well be a LargeInteger). Can be used to perform arithmetic with Dates and
	Times."

	^self asDays * Duration.SecondsPerDay
!

asSYSTEMTIME
	"Answer a <SYSTEMTIME > representing midnight at the start of the same date as the receiver."

	| struct |
	struct := OS.SYSTEMTIME new.
	self dayMonthYearDo: 
			[:dd :mm :yy |
			struct
				wYear: yy;
				wMonth: mm;
				wDay: dd].
	^struct!

asTime
	^Time fromSeconds: 0!

asTimeStamp
	^self asDateAndTime asTimeStamp
!

asVariant
	"Answer the VARIANT representation of the receiver (a VT_DATE)."

	^self asSYSTEMTIME asVariant!

day
	"Answer the day of the year represented by the receiver."

	^self dayOfYear!

dayMonthYearDo: aTriadicValuable
	"Evaluate the triadic valuable argument passing it the day, month, and year of the date
	represented by the receiver, answering the result."

	| year dayOfYear monthIndex |
	year := self year.
	dayOfYear := self class day: self asDays inYear: year.
	monthIndex := self class monthIndexOfDay: dayOfYear inYear: year.
	^aTriadicValuable
		value: dayOfYear - (self class daysUntilMonth: monthIndex inYear: year)
		value: monthIndex
		value: year!

dayOfMonth
	"Answer the day of the month represented by the receiver."

	^self dayMonthYearDo: [:d :m :y | d]!

dayOfWeek
	"Answer the day of the year represented by the receiver."

	^self asDays + 2 \\ 7 + 1!

dayOfYear
	"Answer the day of the year represented by the receiver."

	^self class day: self asDays inYear: self year!

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream locale displayDate: self on: aPuttableStream!

firstDayOfMonth
	"Answer the julian day number of the first day of the receiver's month in the receiver's year."

	^self firstDayOfMonthIndex: self month!

firstDayOfMonthIndex: monthIndex
	"Private - Answer the julian day number of the first day of the given month at
	monthIndex in the receiver's year."

	^(DaysUntilMonth at: monthIndex) + (monthIndex > 2 ifTrue: [self isLeapYear] ifFalse: [0]) + 1!

hash
	"Answer the SmallInteger hash value for the receiver"

	^self asDays hash!

isLeapYear
	^self class leapYear: self year!

month
	"Answer the one-based index of the month represented by the receiver; 1 for January, 2 for February, and so on."

	| year dayOfYear |
	year := self year.
	dayOfYear := self class day: self asDays inYear: year.
	^self class monthIndexOfDay: dayOfYear inYear: year!

monthName
	"Answer a <readableString>, which is the locale specific name of the month of this date."

	^Locale default monthName: self month!

monthsSince: aDate
	"Answer the number of elapsed months Since the receiver and aDate.
	This methods adjusts correctly (for all cases I've tried) for part years
	and for part months, i.e. 28th Jan to 28th Feb is considered to be one month, 
	as is 29th Jan to 28th Feb, but 29th March to 28th April is 0 months. It correctly
	accounts for leap years."
	
	| calMonths |
	self dayMonthYearDo: [:d1 :m1 :y1 |
		aDate dayMonthYearDo: [ :d2 :m2 :y2 |
			calMonths := (y1 - y2) * 12 + (m1 - m2).
			calMonths == 0 ifFalse: [
				"Adjust for part months, but take account of the length of the month so that
				29, Jan to 28, Feb is one month, but 29 Jun to 28 Jul is not."
				calMonths > 0
					ifTrue: [
						(d1 < d2 and: [ d1 < (self class daysInMonthIndex: m1 forYear: y1) ])
							ifTrue: [ calMonths := calMonths - 1 ]]
					ifFalse: [
						(d2 < d1 and: [ d2 < (self class daysInMonthIndex: m2 forYear: y2) ])
							ifTrue: [ calMonths := calMonths + 1 ]]]]].
	^calMonths
!

printOn: aStream
	"Append a default string representation of the receiver to aStream."

	self printOn: aStream longPicture: DefaultLongPicture!

printOn: aStream format: aString
	"Append a short textual description of the receiver to the <puttableStream> argument, aStream. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>dateFormat method comment, e.g. 'dd/MM/yyyy', formats to, for example, 27/11/2001). If the format argument is nil then the receiver is printed to the stream in the currently configured format of the stream's <Locale> (see Locale>>#dateFormat). See also: https://docs.microsoft.com/en-gb/windows/desktop/Intl/day--month--year--and-era-format-pictures"

	aStream locale
		printDate: self
		on: aStream
		format: aString!

printOn: aStream longPicture: aBoolean
	"Append an string representation of the receiver to aStream in default locale long/short formats depending on aBoolean."

	| locale |
	locale := Locale default.
	locale
		printDate: self
		on: aStream
		format: (aBoolean ifTrue: [locale longDateFormat] ifFalse: [locale dateFormat])!

printStringFormat: aString
	"Answer a short textual description of the receiver. The format is defined by the <readableString> argument, aString, the format characters of which are as described in the Locale>>#dateFormat method comment.
	Settings from the default locale are used."

	| stream |
	stream := String writeStream: aString size.
	self printOn: stream format: aString.
	^stream grabContents!

seconds
	"Answer the <number> of seconds past midnight in the local time of the receiver.
	Dates always represent midnight local time, so answer 0."

	^0!

setDays: dayCount
	"Private - Initialize the receiver to be dayCount days after January 1, 1901"

	days := dayCount
!

storeOn: aStream
	"Append to the <puttableStream> argument, target, an expression which when evaluated will answer a <Date> equivalent to the receiver."

	aStream
		nextPut: $(;
		print: self class;
		space;
		display: #fromDays:;
		space;
		print: self asDays;
		nextPut: $)!

subtractDate: aDate
	"Answer the difference in days between the receiver and aData, as an Integer"

	^self asDays - aDate asDays
!

subtractDays: dayCount
	"Answer a new Date that is dayCount days before the receiver."

	^self class fromDays: self asDays - dayCount
!

year
	"Answer the year represented by the receiver."

	| temp q400 r400 q100 r100 q4 r4 |
	"Number of days since start of year 1600"
	temp := self asDays + ##(301*365+(301//4)-(301//100)+(301//400)).
	"Number of 400 year periods."
	q400 := temp // ##(400*365+(400//4)-(400//100)+(400//400)).
	r400 := temp \\ ##(400*365+(400//4)-(400//100)+(400//400)).
	"Number of remaining centuries"
	q100 := r400 // ##(100*365+(100//4)-(100//100)+(100//400)).
	r100 := r400 \\ ##(100*365+(100//4)-(100//100)+(100//400)).
	"Number of remaining leap year cycles"
	q4 := r100 // ##(4*365+(4//4)-(4//100)+(4//400)).
	r4 := r100 \\ ##(4*365+(4//4)-(4//100)+(4//400)).
	^(q400*400) + (q100*100) + (q4*4) + (r4//365)+1600!

yearsSince: aDate
	"Answer the number of actual elapsed years since aDate."
	
	^(self monthsSince: aDate) // 12!

yyyymmdd
	"Format the date in ISO 8601 standard YYYY-MM-DD, e.g. '2019-02-27'.
		Date today yyyymmdd.
	"

	| stream |
	stream := String writeStream: 10.
	stream locale: Locale invariant.
	self printOn: stream format: 'yyyy-MM-dd'.
	^stream grabContents! !

!Core.Date categoriesForMethods!
<!comparing!public! !
=!comparing!public! !
addDays:!arithmetic!public! !
addMonths:!arithmetic!public! !
addMonths:desiredDay:!arithmetic!public! !
addYears:!arithmetic!public! !
addYears:desiredDay:!arithmetic!public! !
asDate!converting!public! !
asDateAndTime!converting!public! !
asDays!converting!public! !
asFloat!converting!public! !
asMilliseconds!converting!public! !
asParameter!converting!public! !
asSeconds!converting!public! !
asSYSTEMTIME!converting!public! !
asTime!converting!public! !
asTimeStamp!converting!public! !
asVariant!converting!public! !
day!accessing!public! !
dayMonthYearDo:!accessing!public! !
dayOfMonth!accessing!public! !
dayOfWeek!accessing!public! !
dayOfYear!accessing!public! !
displayOn:!printing!public! !
firstDayOfMonth!operations!public! !
firstDayOfMonthIndex:!operations!private! !
hash!comparing!public! !
isLeapYear!public!testing! !
month!accessing!public! !
monthName!accessing!public! !
monthsSince:!arithmetic!public! !
printOn:!printing!public! !
printOn:format:!printing!public! !
printOn:longPicture:!printing!public! !
printStringFormat:!printing!public! !
seconds!accessing!public! !
setDays:!accessing!private! !
storeOn:!printing!public! !
subtractDate:!arithmetic!public! !
subtractDays:!arithmetic!public! !
year!accessing!public! !
yearsSince:!arithmetic!public! !
yyyymmdd!accessing!public! !
!

Core.Date methodProtocol: #date attributes: #(#readOnly) selectors: #(#asSeconds #dayOfMonth #dayOfWeek #dayOfYear #month #year)!

!Core.Date class methodsFor!

dateOrderFromFormat: aFormatString
	"Private - Answers a String giving the component order in aFormatString (e.g. 'DMY' or 'MDY')"
	
	^aFormatString asUppercase copyWithoutDuplicates select: [:each | each isLetter]!

day: daysSinceBase inYear: anInteger
	"Private - Answer the julian day index of the argument, daysSinceBase, in the year, anInteger."

	"Day 0 is 1 Jan in base year, so we add 1"
	^daysSinceBase - (self yearAsDays: anInteger) + 1!

daysInMonth: monthName forYear: yearInteger
	"Answer the number of days in the month whose name is, monthName, in the year, yearInteger"

	^self daysInMonthIndex: (self indexOfMonth: monthName) forYear: yearInteger!

daysInMonthIndex: monthIndex forYear: yearInteger
	"Private - Answer the number of days in the month whose index is, monthIndex,
	in the year, yearInteger"

	| days |
	days := DaysInMonth at: monthIndex.
	monthIndex == 2 ifTrue: [ days := days + (self leapYear: yearInteger) ].
	^days
!

daysInYear: yearInteger
	"Answer the number of days in the year, yearInteger."

	^365 + (self leapYear: yearInteger)
!

daysUntilMonth: monthIndex inYear: yearInteger
	"Private - Answer the number of days in year, yearInteger, which elapse before the
	first day of the month whose index (1..12), is monthIndex."

	| days |
	days := DaysUntilMonth at: monthIndex.
	monthIndex > 2 ifTrue: [ days := days + (self leapYear: yearInteger) ].
	^days!

defaultLongFormat
	"Answer the default long date format."

	^Locale default longDateFormat!

defaultLongPicture: aBoolean
	"Private - Set whether the default printing for dates uses long or short pictures."

	DefaultLongPicture := aBoolean!

defaultShortFormat
	"Answer the default short date format."

	^Locale default dateFormat!

defaultYearPivot
	"Answer the default year pivot to use when converting date strings with 2 digit years."

	^Locale default lastTwoDigitYear \\ 100 + 1!

errorInvalidFormat
	"Private - Raise an error that some attempt to create an instance of the receiver failed
	because the some input was in the wrong format."

	^InvalidFormat signalWith: self!

fromDays: dayCount 
	"Answer a new instance of the receiver that is dayCount days from (before or after depending on 
	the sign of dayCount) January 1, 1901."

	<primitive: 157>
	^(self basicNew)
		setDays: dayCount;
		yourself!

fromSeconds: aNumber
	"Answer a new instance of the receiver that incorporates the second which is the specified <number> of seconds after the Smalltalk epoch."

	^self fromDays: aNumber // Duration.SecondsPerDay!

fromString: aString
	"Answer an instance of the receiver constructed from the string,
	aString, using the default conversion format."

	| stream answer |
	stream := aString readStream.
	answer := self readFrom: stream.
	stream atEnd ifFalse: [^self errorInvalidFormat].
	^answer
!

fromString: aString format: aFormatStringOrNil
	"Answer an instance of the receiver constructed from the string,
	aString, using aFormatStringOrNil."

	^self readFrom: aString readStream format: aFormatStringOrNil!

fromSYSTEMTIME: aSYSTEMTIME
	"Private - Answer a new instance of the receiver instantiated from the argument, aSYSTEMTIME."
	
	^self newDay: aSYSTEMTIME wDay monthIndex: aSYSTEMTIME wMonth year: aSYSTEMTIME wYear!

indexOfMonth: aString
	"Answer the 1-based <integer> index in a year (i.e. 1..12) of the month named by the <String> argument, asString, which is expected to be the full locale specific name of a month, or its abbreviated form, in upper or lower case."

	^Locale default indexOfMonth: aString!

initialize
	"Private - Initialize the class variables of the receiver

	Evaluate me to initialize:
		Date initialize
	"

	self defaultLongPicture: true.

	"Days indices are for non-leap years"
	DaysInMonth := #(31 28 31 30 31 30 31 31 30 31 30 31).
	DaysUntilMonth := #(0 31 59 90 120 151 181 212 243 273 304 334 ).!

leapYear: yearInteger
	"Answer 1 if, yearInteger, is a leap year, otherwise answer 0. The Royal
	Observatory in Greenwich assure us that a year is a leap year if it is 
	divisible by 4, but not by 100, unless by 400, e.g: 1896 was a leap year, 
	but 1900 was not, but 2000 will be."

	^(yearInteger \\ 4 ~= 0 or: [yearInteger \\ 100 == 0 and: [yearInteger \\ 400 ~= 0]])
		ifTrue: [ 0 ]
		ifFalse: [ 1 ]!

longFormats
	"Answer a collection of the long date formats for the user locale.
	This list could be used, for example, to populate a drop-down."

	^Locale default longDateFormats!

monthAbbreviation: monthIndex
	"Answer a localised abbreviated String name for the month whose index is the argument, monthIndex, where January 
	is month 1, and December is month 12."

	^Locale default monthAbbreviation: monthIndex!

monthIndexOfDay: dayInteger inYear: yearInteger 
	"Private - Answer the index of the month of the specified julian day number in the specified year."

	| leap |
	leap := self leapYear: yearInteger.
	1 to: 12
		do: 
			[:monthIndex | 
			| daysUntil |
			daysUntil := (DaysUntilMonth at: monthIndex) 
						+ (monthIndex > 2 ifTrue: [leap] ifFalse: [0]).
			daysUntil >= dayInteger ifTrue: [^monthIndex - 1]].
	^12!

new
	"Answer an instance of the receiver representing the current system date."

	^self today!

newDay: day month: monthName year: year
	"Answer a new instance of the receiver that is the <integer> day numbered, day, 
	of the <readableString> month named, monthName in the <integer> year, year."

	^self newDay: day monthIndex: (self indexOfMonth: monthName) year: year!

newDay: day monthIndex: month year: year
	"Answer a new instance of the receiver that is the <integer> day numbered, 
	day, of the <integer> month index (1..12), monthIndex in the year, 
	<integer> year, year."

	^self
		year: year
		month: month
		day: day!

newDay: day monthNumber: month year: year
	"For compatibility with VisualWorks..."

	^self newDay: day monthIndex: month year: year!

newDay: dayCount year: yearInteger
	"Answer a new instance of the receiver that is the day numbered, day, of the year, yearInteger"

	^self fromDays: dayCount + (self yearAsDays: yearInteger) - 1
!

readDayFrom: aStream
	"Private - Answer a day index read from aStream"

	aStream peek isDigit
		ifTrue: 
			[| day |
			day := Integer readFrom: aStream radix: 10.
			((1 to: 31) includes: day) ifTrue: [^day]].
	^self errorInvalidFormat!

readFrom: aStream
	"Answers an new instance of the receiver read from aStream with a format determined
	by the current locale"
	
	^self readFrom: aStream format: nil!

readFrom: aStream format: aFormatStringOrNil 
	"Answers a new instance of the receiver read from aStream according to aFormatString"

	| dd mm yy dateOrder format |
	format := aFormatStringOrNil ifNil: [self defaultShortFormat].
	dateOrder := self dateOrderFromFormat: format.
	dateOrder do: 
			[:each | 
			aStream skipWhile: [:c | c isAlphaNumeric not].
			aStream atEnd ifTrue: [self errorInvalidFormat].
			each = $D ifTrue: [dd := self readDayFrom: aStream].
			each = $M ifTrue: [mm := self readMonthFrom: aStream].
			each = $Y ifTrue: [yy := self readYearFrom: aStream]].
	((1 to: (self daysInMonthIndex: mm forYear: yy)) includes: dd) ifFalse: [self errorInvalidFormat].
	^self 
		newDay: dd
		monthIndex: mm
		year: yy!

readMonthFrom: aStream
	"Private - Answer a month index read from aStream. The stream may be positioned at,
	either a month number or a month name"

	aStream peek isDigit
		ifTrue: 
			[| month |
			month := Integer readFrom: aStream radix: 10.
			((1 to: 12) includes: month) ifFalse: [self errorInvalidFormat].
			^month].
	1 to: 12
		do: 
			[:mm |
			| shortName |
			shortName := (self monthAbbreviation: mm) copyWithout: $..
			(shortName skipOver: aStream ignoreCase: true)
				ifTrue: 
					[aStream skipWhile: [:c | c isLetter].
					^mm]].
	^self errorInvalidFormat!

readYearFrom: aStream
	"Private - Answer a year read from aStream"

	aStream peek isDigit
		ifTrue: 
			[| yy |
			yy := Integer readFrom: aStream radix: 10.
			yy < 100
				ifTrue: 
					[| offset |
					"Two digit date"
					offset := Date today year roundTo: 100.
					yy >= self yearPivot ifTrue: [offset := offset - 100].
					yy := yy + offset].
			^yy].
	^self errorInvalidFormat!

shortFormats
	"Private - Answer a collection of the short date formats for the user locale."

	^Locale default shortDateFormats!

today
	"Answer an instance of the receiver representing the current system date."

	^DateAndTime now dayMonthYearDo: 
			[:d :m :y |
			self
				newDay: d
				monthIndex: m
				year: y]!

tomorrow
	^self today addDays: 1!

year: yearInteger month: monthInteger day: dayInteger
	"Answer a new instance of the receiver that is the <integer> day numbered, dayInteger, of the <integer> month index (1..12), monthInteger in the year, <integer> year, yearInteger."

	^self newDay: dayInteger + (self daysUntilMonth: monthInteger inYear: yearInteger) year: yearInteger!

yearAsDays: yearInteger
	"Private - Answer the number of days between January 1, 1901 and
	the first day of the year, yearInteger"
	
	| year |
	year := yearInteger - 1901.
	^year * 365
		+ (year // 4)
		- (year // 100)
		+ (year + ##(1901-1601) // 400)!

yearPivot
	"Answers the pivot point for two digit years. Years greater or equal to this will be assumed to be
	in the 20th century. Years less than the pivot will be assumed to be in the 21st century"

	^YearPivot ifNil: [self defaultYearPivot]!

yearPivot: anInteger
	"Sets the pivot point for two digit years to be anInteger. 
	Years greater or equal to this will be assumed to be in the current century. 
	Years less than the pivot will be assumed to be in the next century"

	YearPivot := anInteger!

yesterday
	^self today subtractDays: 1! !

!Core.Date class categoriesForMethods!
dateOrderFromFormat:!helpers!private! !
day:inYear:!enquiries!private! !
daysInMonth:forYear:!enquiries!public! !
daysInMonthIndex:forYear:!enquiries!private! !
daysInYear:!enquiries!public! !
daysUntilMonth:inYear:!enquiries!private! !
defaultLongFormat!enquiries!public! !
defaultLongPicture:!printing!private! !
defaultShortFormat!enquiries!public! !
defaultYearPivot!constants!public! !
errorInvalidFormat!exceptions!private! !
fromDays:!instance creation!public! !
fromSeconds:!instance creation!public! !
fromString:!instance creation!public! !
fromString:format:!instance creation!public! !
fromSYSTEMTIME:!instance creation!private! !
indexOfMonth:!enquiries!public! !
initialize!development!initializing!private! !
leapYear:!operations!public! !
longFormats!enquiries!public! !
monthAbbreviation:!enquiries!public! !
monthIndexOfDay:inYear:!enquiries!private! !
new!instance creation!public! !
newDay:month:year:!instance creation!public! !
newDay:monthIndex:year:!instance creation!public! !
newDay:monthNumber:year:!instance creation!public! !
newDay:year:!instance creation!public! !
readDayFrom:!helpers!private! !
readFrom:!instance creation!public! !
readFrom:format:!instance creation!public! !
readMonthFrom:!helpers!private! !
readYearFrom:!helpers!private! !
shortFormats!enquiries!private! !
today!instance creation!public! !
tomorrow!instance creation!public! !
year:month:day:!instance creation!public! !
yearAsDays:!converting!private! !
yearPivot!accessing!public! !
yearPivot:!accessing!not an aspect!public! !
yesterday!instance creation!public! !
!

