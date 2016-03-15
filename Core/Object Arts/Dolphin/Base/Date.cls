"Filed out from Dolphin Smalltalk 7"!

Magnitude subclass: #Date
	instanceVariableNames: 'days '
	classVariableNames: 'DaysInMonth DaysUntilMonth DefaultLongPicture YearPivot'
	poolDictionaries: 'Win32Constants'
	classInstanceVariableNames: ''!
Date guid: (GUID fromString: '{87B4C652-026E-11D3-9FD7-00A0CC3E4A32}')!
Date comment: 'Date is the class whose instances represent days of the year. The base date (day 0) is 1st January 1901.

Instance Variables:
	days				<integer>. Days since 1st Jan 1901

Class Variables:
	DefaultLongPicture	<boolean>. Controls whether or not the Date prints by default using the locale''s long or short representations.
	DaysUntilMonth		<Array>
	YearPivot			<integer>. Pivot year for 2 digit years. See #yearPivot
	DaysInMonth		<Array>

'!
!Date categoriesForClass!Magnitude-General! !
!Date methodsFor!

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

	^self evaluateYYMMDD: 
			[:yy :mm :dd | 
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

	^self evaluateYYMMDD: 
			[:yy :mm :dd | 
			| dayOfMonth year daysInMonth |
			year := yy + yearCount.
			dayOfMonth := desiredDay == 0 ifTrue: [dd] ifFalse: [desiredDay].
			daysInMonth := self class daysInMonthIndex: mm forYear: year.
			dayOfMonth := dayOfMonth min: daysInMonth.
			self class 
				newDay: dayOfMonth
				monthIndex: mm
				year: year]!

asDays
	"Answer the number of days since 1901 which the receiver represents. As Dolphin dates are
	stored in this format internally, this is a simple accessor."

	^days!

asMilliseconds
	"Answer the number of milliseconds between a Time on January 1, 1901, and the same time in 
	the receiver's day (this will probably be a LargeInteger). Can be used to perform 
	arithmetic with Dates and Times."

	^self asSeconds * 1000!

asParameter
	"Answer the receiver in external system representation for passing to an external function call."

	| struct |
	struct := SYSTEMTIME new.
	self evaluateYYMMDD: 
			[:yy :mm :dd | 
			struct
				wYear: yy;
				wMonth: mm;
				wDay: dd].
	^struct!

asSeconds
	"Answer the number of seconds between a Time on January 1, 1901, and the same time in the receiver's
	day (this could well be a LargeInteger). Can be used to perform arithmetic with Dates and
	Times."

	^self asDays * ##(24*60*60)
!

asTimeStamp
	"Answer the receiver as <TimeStamp>."

	^TimeStamp date: self
!

day
	"Answer the day of the year represented by the receiver."

	^self class day: self asDays inYear: self year!

dayOfMonth
	"Answer the day of the month represented by the receiver."

	| year julianDay monthIndex |
	year := self year.
	julianDay := self class day: self asDays inYear: self year.
	monthIndex := self class monthIndexOfDay: julianDay inYear: year.
	^julianDay - (self class daysUntilMonth: monthIndex inYear: year)!

evaluateYYMMDD: aTriadicValuable 
	"Evaluate the the triadic valuable argument passing it the day, month, and year of the date
	represented by the receiver, answering the result."

	| year julianDay monthIndex |
	year := self year.
	julianDay := self class day: self asDays inYear: year.
	monthIndex := self class monthIndexOfDay: julianDay inYear: year.
	^aTriadicValuable 
		value: year
		value: monthIndex
		value: julianDay - (self class daysUntilMonth: monthIndex inYear: year)!

firstDayOfMonth
	"Answer the julian day number of the first day of the receiver's month in the receiver's year."

	^self firstDayOfMonthIndex: self monthIndex!

firstDayOfMonthIndex: monthIndex 
	"Private - Answer the julian day number of the first day of the given month at
	monthIndex in the receiver's year."

	^(DaysUntilMonth at: monthIndex)
		+ (monthIndex > 2
				ifTrue: [self class leapYear: self year]
				ifFalse: [0])
		+ 1
!

hash
	"Answer the SmallInteger hash value for the receiver"

	^self asDays hash!

monthIndex
	"Answer the one-based index of the month represented by the receiver; 1 for January, 2 for
	February, and so on."

	| year julianDay |
	year := self year.
	julianDay := self class day: self asDays inYear: year.
	^self class monthIndexOfDay: julianDay inYear: year!

monthName
	"Answer the name of the month represented by the receiver (as a Symbol)."

	^self class nameOfMonth: self monthIndex!

monthsSince: aDate
	"Answer the number of elapsed months Since the receiver and aDate.
	This methods adjusts correctly (for all cases I've tried) for part years
	and for part months, i.e. 28th Jan to 28th Feb is considered to be one month, 
	as is 29th Jan to 28th Feb, but 29th March to 28th April is 0 months. It correctly
	accounts for leap years."
	
	| calMonths |
	self evaluateYYMMDD: [ :y1 :m1 :d1 |
		aDate evaluateYYMMDD: [ :y2 :m2 :d2 |
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
	"Append a short textual description of the receiver to the <puttableStream> argument,
	aStream. The format is defined by the <readableString> argument, aString, the format 
	characters of which are as described in the Control Panel help for Windows Regional 
	Options/Date settings (e.g. dd/MM/yyyy, formats to, for example, 27/11/2001). If the
	format argument is nil then the receiver is printed to the stream in the currently
	configured default format of the host OS."

	self 
		printOn: aStream
		locale: Locale default
		flags: 0
		format: aString!

printOn: aStream locale: locale flags: dwFlags format: aStringOrNil
	"Private - Append a locale specific string representation of the receiver to aStream, using the specified
	format String (the default is used if it is nil). The format is as described in the Control Panel help 	
	for Windows Regional Options/Date 	settings (e.g. dd/MM/yyyy, formats to, for example, 27/11/2001)."

	aStream nextPutAll: (locale 
				printDate: self
				format: aStringOrNil
				flags: dwFlags)!

printOn: aStream locale: locale format: aStringOrNil
	"Private - Append a locale specific string representation of the receiver to aStream, using the specified
	format String (the default is used if it is nil). The format is as described in the Control Panel help for
	Windows regional Time settings (e.g. hh:mm tt, formats to, for example, 10:15 pm)."

	self printOn: aStream locale: locale flags: 0 format: aStringOrNil!

printOn: aStream longPicture: aBoolean
	"Private - Append an string representation of the receiver to aStream in default locale long/short
	formats depending on aBoolean."

	self 
		printOn: aStream 
		locale: Locale default 
		flags: (aBoolean ifTrue: [DATE_LONGDATE] ifFalse: [DATE_SHORTDATE])
		format: nil!

setDays: dayCount
	"Private - Initialize the receiver to be dayCount days after January 1, 1901"

	days := dayCount
!

storeOn: aStream 
	"Append to the <puttableStream> argument, target, an expression which when 
	evaluated will answer a collection similar to the receiver."

	"Use a format which is locale invariant."

	aStream 
		nextPut: $(;
		nextPutAll: self class name;
		nextPutAll: ' fromDays: ';
		print: days;
		nextPutAll: ' "';
		print: self;
		nextPutAll: '")'!

subtractDate: aDate
	"Answer the difference in days between the receiver and aData, as an Integer"

	^self asDays - aDate asDays
!

subtractDays: dayCount
	"Answer a new Date that is dayCount days before the receiver."

	^self class fromDays: self asDays - dayCount
!

weekday
	"Answer the day of the week represented by the receiver."

	^self class nameOfDay: self weekdayIndex!

weekdayIndex
	"Answer the index of the receiver's day of the week (1..7)"

	^(self asDays + 1) \\ 7 + 1!

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
	
	^(self monthsSince: aDate) // 12! !
!Date categoriesFor: #<!comparing!public! !
!Date categoriesFor: #=!comparing!public! !
!Date categoriesFor: #addDays:!arithmetic!public! !
!Date categoriesFor: #addMonths:!arithmetic!public! !
!Date categoriesFor: #addMonths:desiredDay:!arithmetic!public! !
!Date categoriesFor: #addYears:!arithmetic!public! !
!Date categoriesFor: #addYears:desiredDay:!arithmetic!public! !
!Date categoriesFor: #asDays!converting!public! !
!Date categoriesFor: #asMilliseconds!converting!public! !
!Date categoriesFor: #asParameter!converting!public! !
!Date categoriesFor: #asSeconds!converting!public! !
!Date categoriesFor: #asTimeStamp!converting!public! !
!Date categoriesFor: #day!accessing!public! !
!Date categoriesFor: #dayOfMonth!accessing!public! !
!Date categoriesFor: #evaluateYYMMDD:!helpers!public! !
!Date categoriesFor: #firstDayOfMonth!operations!public! !
!Date categoriesFor: #firstDayOfMonthIndex:!operations!private! !
!Date categoriesFor: #hash!comparing!public! !
!Date categoriesFor: #monthIndex!accessing!public! !
!Date categoriesFor: #monthName!accessing!public! !
!Date categoriesFor: #monthsSince:!arithmetic!public! !
!Date categoriesFor: #printOn:!printing!public! !
!Date categoriesFor: #printOn:format:!printing!public! !
!Date categoriesFor: #printOn:locale:flags:format:!printing!private! !
!Date categoriesFor: #printOn:locale:format:!printing!private! !
!Date categoriesFor: #printOn:longPicture:!printing!private! !
!Date categoriesFor: #setDays:!accessing!private! !
!Date categoriesFor: #storeOn:!printing!public! !
!Date categoriesFor: #subtractDate:!arithmetic!public! !
!Date categoriesFor: #subtractDays:!arithmetic!public! !
!Date categoriesFor: #weekday!accessing!public! !
!Date categoriesFor: #weekdayIndex!accessing!public! !
!Date categoriesFor: #year!accessing!public! !
!Date categoriesFor: #yearsSince:!arithmetic!public! !

!Date class methodsFor!

dateAndTimeNow 
	"Answer an Array whose first element is the current local Date and whose
	second element is the current local Time."

	^Time dateAndTimeNow!

dateOrderFromFormat: aFormatString
	"Private - Answers a String giving the component order in aFormatString (e.g. 'DMY' or 'MDY')"
	
	^aFormatString asUppercase copyWithoutDuplicates select: [:each | each isLetter]!

day: daysSinceBase inYear: anInteger
	"Private - Answer the julian day index of the argument, daysSinceBase, in the year, anInteger."

	"Day 0 is 1 Jan in base year, so we add 1"
	^daysSinceBase - (self yearAsDays: anInteger) + 1!

dayOfWeek: dayName
	"Answer the index in a week, 1, 2, 3, ..., 7, of the day named by the argument, dayName."

	^Locale default dayNames at: dayName asLowercase!

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

	^30!

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

fromSeconds: anInteger 
	"Answer a new instance of the receiver that incorporates the second which is anInteger
	seconds after the epoch."

	"Implementation Note: Ensure that SmallInteger arithmetic is used to perform the calculation
	when possible."

	^self fromDays: (anInteger bitShift: -7) // ##(60 * 60 * 24 bitShift: -7)!

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

icon
	"Answers an Icon that can be used to represent this class"

	^##(self) defaultIcon!

indexOfMonth: monthName
	"Answer the index in a year (1 .. 12) of the month named by the argument, 
	monthName, where monthName is the full locale specific name, or its abbreviated form,
	in upper or lower case."

	^Locale default monthNames at: monthName asLowercase!

initialize
	"Private - Initialize the class variables of the receiver

	Evaluate me to initialize:
		Date initialize
	"

	self defaultLongPicture: true.
	self yearPivot: self defaultYearPivot.

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

nameOfDay: dayIndex
	"Answer a String that is the localised name of the day whose index is the argument, dayIndex, 
	where Monday is 1 and Sunday is 7."

	^Locale default nameOfDay: dayIndex abbrev: false!

nameOfMonth: monthIndex
	"Answer a localised String name for the month whose index is the argument, monthIndex, where 
	January is month 1, and December is month 12."

	^Locale default nameOfMonth: monthIndex abbrev: false!

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

	^self newDay: day + (self daysUntilMonth: month inYear: year) year: year!

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
			shortName := (self shortNameOfMonth: mm) copyWithout: $..
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
					["Two digit date"

					| offset |
					offset := Date today year roundTo: 100.
					yy >= self yearPivot ifTrue: [offset := offset - 100].
					yy := yy + offset].
			^yy].
	^self errorInvalidFormat!

shortFormats
	"Private - Answer a collection of the short date formats for the user locale."

	^Locale default shortDateFormats!

shortNameOfDay: dayIndex
	"Answer a String that is the localised name of the day whose index is the argument, dayIndex, where Monday is 1 
	and Sunday is 7."

	^Locale default nameOfDay: dayIndex abbrev: true!

shortNameOfMonth: monthIndex
	"Answer a localised abbreviated String name for the month whose index is the argument, monthIndex, where January 
	is month 1, and December is month 12."

	^Locale default nameOfMonth: monthIndex abbrev: true!

today
	"Answer an instance of the receiver representing the current system date."

	^self fromSYSTEMTIME: SYSTEMTIME now!

tomorrow
	^self today addDays: 1!

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
	in the current century. Years less than the pivot will be assumed to be in the next century"

	^YearPivot!

yearPivot: anInteger
	"Sets the pivot point for two digit years to be anInteger. 
	Years greater or equal to this will be assumed to be in the current century. 
	Years less than the pivot will be assumed to be in the next century"

	YearPivot := anInteger!

yesterday
	^self today subtractDays: 1! !
!Date class categoriesFor: #dateAndTimeNow!enquiries!public! !
!Date class categoriesFor: #dateOrderFromFormat:!helpers!private! !
!Date class categoriesFor: #day:inYear:!enquiries!private! !
!Date class categoriesFor: #dayOfWeek:!mapping!public! !
!Date class categoriesFor: #daysInMonth:forYear:!enquiries!public! !
!Date class categoriesFor: #daysInMonthIndex:forYear:!enquiries!private! !
!Date class categoriesFor: #daysInYear:!enquiries!public! !
!Date class categoriesFor: #daysUntilMonth:inYear:!enquiries!private! !
!Date class categoriesFor: #defaultLongFormat!enquiries!public! !
!Date class categoriesFor: #defaultLongPicture:!printing!private! !
!Date class categoriesFor: #defaultShortFormat!enquiries!public! !
!Date class categoriesFor: #defaultYearPivot!constants!public! !
!Date class categoriesFor: #errorInvalidFormat!exceptions!private! !
!Date class categoriesFor: #fromDays:!instance creation!public! !
!Date class categoriesFor: #fromSeconds:!instance creation!public! !
!Date class categoriesFor: #fromString:!instance creation!public! !
!Date class categoriesFor: #fromString:format:!instance creation!public! !
!Date class categoriesFor: #fromSYSTEMTIME:!instance creation!private! !
!Date class categoriesFor: #icon!constants!public! !
!Date class categoriesFor: #indexOfMonth:!mapping!public! !
!Date class categoriesFor: #initialize!development!initializing!private! !
!Date class categoriesFor: #leapYear:!operations!public! !
!Date class categoriesFor: #longFormats!enquiries!public! !
!Date class categoriesFor: #monthIndexOfDay:inYear:!mapping!private! !
!Date class categoriesFor: #nameOfDay:!mapping!public! !
!Date class categoriesFor: #nameOfMonth:!mapping!public! !
!Date class categoriesFor: #new!instance creation!public! !
!Date class categoriesFor: #newDay:month:year:!instance creation!public! !
!Date class categoriesFor: #newDay:monthIndex:year:!instance creation!public! !
!Date class categoriesFor: #newDay:monthNumber:year:!instance creation!public! !
!Date class categoriesFor: #newDay:year:!instance creation!public! !
!Date class categoriesFor: #readDayFrom:!helpers!private! !
!Date class categoriesFor: #readFrom:!instance creation!public! !
!Date class categoriesFor: #readFrom:format:!instance creation!public! !
!Date class categoriesFor: #readMonthFrom:!helpers!private! !
!Date class categoriesFor: #readYearFrom:!helpers!private! !
!Date class categoriesFor: #shortFormats!enquiries!private! !
!Date class categoriesFor: #shortNameOfDay:!mapping!public! !
!Date class categoriesFor: #shortNameOfMonth:!mapping!public! !
!Date class categoriesFor: #today!instance creation!public! !
!Date class categoriesFor: #tomorrow!public! !
!Date class categoriesFor: #yearAsDays:!converting!private! !
!Date class categoriesFor: #yearPivot!accessing!public! !
!Date class categoriesFor: #yearPivot:!accessing!public! !
!Date class categoriesFor: #yesterday!instance creation!public! !

