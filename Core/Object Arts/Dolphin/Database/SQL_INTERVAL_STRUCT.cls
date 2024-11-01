"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #SQL_INTERVAL_STRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_interval_sign _OffsetOf_interval_type BodyClasses MinutesPerDay SecondsPerDay SQL_IS_DAY SQL_IS_DAY_TO_HOUR SQL_IS_DAY_TO_MINUTE SQL_IS_DAY_TO_SECOND SQL_IS_HOUR SQL_IS_HOUR_TO_MINUTE SQL_IS_HOUR_TO_SECOND SQL_IS_MINUTE SQL_IS_MINUTE_TO_SECOND SQL_IS_MONTH SQL_IS_SECOND SQL_IS_YEAR SQL_IS_YEAR_TO_MONTH'
	poolDictionaries: 'ODBCCTypes'
	classInstanceVariableNames: ''!

SQL_INTERVAL_STRUCT guid: (GUID fromString: '{e4ec1ff8-4415-44ae-891b-ba3bb6cae2b2}')!

SQL_INTERVAL_STRUCT isAbstract: true!

SQL_INTERVAL_STRUCT addClassConstant: '_OffsetOf_interval_sign' value: 16r4!
SQL_INTERVAL_STRUCT addClassConstant: '_OffsetOf_interval_type' value: 16r0!
SQL_INTERVAL_STRUCT addClassConstant: 'BodyClasses' value: #(SQL_YEARS_STRUCT SQL_MONTHS_STRUCT SQL_DAYS_STRUCT SQL_HOURS_STRUCT SQL_MINUTES_STRUCT SQL_SECONDS_STRUCT SQL_YEARS_TO_MONTHS_STRUCT SQL_DAYS_TO_HOURS_STRUCT SQL_DAYS_TO_MINUTES_STRUCT SQL_DAY_SECOND_STRUCT SQL_HOURS_TO_MINUTES_STRUCT SQL_HOURS_TO_SECONDS_STRUCT SQL_MINUTES_TO_SECONDS_STRUCT)!
SQL_INTERVAL_STRUCT addClassConstant: 'MinutesPerDay' value: 16r5A0!
SQL_INTERVAL_STRUCT addClassConstant: 'SecondsPerDay' value: 16r15180!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_DAY' value: 16r3!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_DAY_TO_HOUR' value: 16r8!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_DAY_TO_MINUTE' value: 16r9!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_DAY_TO_SECOND' value: 16rA!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_HOUR' value: 16r4!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_HOUR_TO_MINUTE' value: 16rB!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_HOUR_TO_SECOND' value: 16rC!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_MINUTE' value: 16r5!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_MINUTE_TO_SECOND' value: 16rD!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_MONTH' value: 16r2!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_SECOND' value: 16r6!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_YEAR' value: 16r1!
SQL_INTERVAL_STRUCT addClassConstant: 'SQL_IS_YEAR_TO_MONTH' value: 16r7!

SQL_INTERVAL_STRUCT comment: 'SQL_INTERVAL_STRUCT is a representation of the same named Win32 ODBC structure.

This structure supports the INTERVAL data type which is supported by Oracle, though not by its ODBC driver, and Mimer SQL (which does have ODBC support). Intervals are not supported by SQL Server at the time of writing.

SQL_INTERVAL_STRUCT represents two incompatible types of intervals - DAYS TO SECOND (and subsets), and YEAR TO MONTH. These are represented as a discriminated union, although really the design would be better with two distinct structures as there is really no benefit in common representation. 

The concrete subclass SQL_DAY_SECOND_STRUCT, a Dolphin invention as it does not exist in ODBC, supports the DAY TO SECOND intervals, and maps to/from Smalltalk `Duration`s reasonably elegantly. 

The concrete subclass SQL_YEAR_MONTH_STRUCT, also a Dolphin invention that does not exist in ODBC, supports YEAR TO MONTH intervals. These have no corresponding representation in the base class library.'!

!SQL_INTERVAL_STRUCT categoriesForClass!Unclassified! !

!SQL_INTERVAL_STRUCT methodsFor!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^100 + self interval_type!

errorWrongIntervalType
	self error: 'Interval type mismatch'!

getValidFields
	^##((Array new: 13)
		at: SQL_IS_YEAR put: #(#sign #year);
		at: SQL_IS_MONTH put: #(#sign #month);
		at: SQL_IS_DAY put: #(#sign #day);
		at: SQL_IS_HOUR put: #(#sign #hour);
		at: SQL_IS_MINUTE put: #(#sign #minute);
		at: SQL_IS_SECOND put: #(#sign #second #fraction);
		at: SQL_IS_YEAR_TO_MONTH put: #(#sign #year #month);
		at: SQL_IS_DAY_TO_HOUR put: #(#sign #day #hour);
		at: SQL_IS_DAY_TO_MINUTE put: #(#sign #day #hour #minute);
		at: SQL_IS_DAY_TO_SECOND put: #(#sign #day #hour #minute #second #fraction);
		at: SQL_IS_HOUR_TO_MINUTE put: #(#sign #hour #minute);
		at: SQL_IS_HOUR_TO_SECOND put: #(#sign #hour #minute #second #fraction);
		at: SQL_IS_MINUTE_TO_SECOND put: #(#sign #minute #second #fraction);
		yourself) at: self interval_type!

interval_sign
	"Answer the <Integer> value of the receiver's 'interval_sign' field."

	^bytes swordAtOffset: _OffsetOf_interval_sign!

interval_type
	"Answer the <Integer> value of the receiver's 'interval_type' field."

	^bytes sdwordAtOffset: _OffsetOf_interval_type!

interval_type: anInteger
	"Set the receiver's 'interval_type' field to the value of the argument, anInteger"

	bytes sdwordAtOffset: _OffsetOf_interval_type put: anInteger!

isYearMonth
	"Answer whether the receiver describes a years to months interval (as opposed to days to seconds)."

	^false!

sign
	"Answer the sign of the interval; -1 if negative, 1 if positive."

	^1 + ((bytes swordAtOffset: _OffsetOf_interval_sign) * -2)!

sign: anInteger
	"Answer the sign of the interval; -1 if negative, 1 if positive."

	bytes swordAtOffset: _OffsetOf_interval_sign put: (1 - anInteger bitShift: -1)! !

!SQL_INTERVAL_STRUCT categoriesForMethods!
dbInterchangeType!constants!public! !
errorWrongIntervalType!error handling!private! !
getValidFields!accessing!private! !
interval_sign!**compiled accessors**!public! !
interval_type!**compiled accessors**!public! !
interval_type:!**compiled accessors**!public! !
isYearMonth!public!testing! !
sign!accessing!public! !
sign:!accessing!public! !
!

!SQL_INTERVAL_STRUCT class methodsFor!

days: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_DAY representation of the <Number> of days in the argument. Any fractional days are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_DAY)
		duration: (Duration days: aNumber);
		yourself!

days: daysNumber hours: hoursNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_DAY_TO_HOUR representation of the <Number> of total number of days, and hours in the arguments. Any fractional hours are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_DAY_TO_HOUR)
		duration: (Duration hours: daysNumber * 24 + hoursNumber);
		yourself!

days: daysNumber hours: hoursNumber minutes: minutesNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_DAY_TO_SECOND representation of the <Number> of total number of days, hours, and minutes in the arguments. Any fractional minutes are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_DAY_TO_MINUTE)
		duration: (Duration
					days: daysNumber
					hours: hoursNumber
					minutes: minutesNumber
					seconds: 0);
		yourself!

days: daysNumber hours: hoursNumber minutes: minutesNumber seconds: secondsNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_DAY_TO_SECOND representation equivalent to the <Number> of total number of days, hours, minutes and seconds in the arguments."

	^(self dbInterchangeType: SQL_C_INTERVAL_DAY_TO_SECOND)
		duration: (Duration
					days: daysNumber
					hours: hoursNumber
					minutes: minutesNumber
					seconds: secondsNumber);
		yourself!

dbInterchangeType: anInteger
	| type |
	type := anInteger - 100.
	^(##((Array new: 13 withAll: SQL_DAY_SECOND_STRUCT)
		at: SQL_IS_YEAR put: SQL_YEAR_MONTH_STRUCT;
		at: SQL_IS_MONTH put: SQL_YEAR_MONTH_STRUCT;
		at: SQL_IS_YEAR_TO_MONTH put: SQL_YEAR_MONTH_STRUCT;
		yourself) at: anInteger - 100)
		newBuffer
		interval_type: type;
		yourself!

dbNewForColumn: aDBColAttr
	^self dbInterchangeType: aDBColAttr type!

defineFields
	"
		self compileDefinition

	typedef struct tagSQL_INTERVAL_STRUCT
	{
		SQLINTERVAL		interval_type;
		SQLSMALLINT		interval_sign;
		union {
			SQL_YEAR_MONTH_STRUCT		year_month;
			SQL_DAY_SECOND_STRUCT		day_second;
		} intval;

	} SQL_INTERVAL_STRUCT;"

	self
		defineField: #interval_type type: SDWORDField new;
		defineField: #interval_sign type: SWORDField readOnly!

hours: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_HOUR representation of the <Number> of hours in the argument. Any fractional hours are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_HOUR)
		duration: (Duration hours: aNumber);
		yourself!

hours: hoursNumber minutes: minutesNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_HOUR_TO_MINUTE representation of the <Number> of total number of hours and minutes in the arguments. Any fractional minutes are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_HOUR_TO_MINUTE)
		duration: (Duration hours: hoursNumber minutes: minutesNumber);
		yourself!

hours: hoursNumber minutes: minutesNumber seconds: secondsNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_HOUR_TO_SECOND representation of the <Number> of total number of hours, minutes and seconds in the arguments."

	^(self dbInterchangeType: SQL_C_INTERVAL_HOUR_TO_SECOND)
		duration: (Duration
					hours: hoursNumber
					minutes: minutesNumber
					seconds: secondsNumber);
		yourself!

initialize
	self addClassConstant: 'MinutesPerDay' value: 24 * 60.
	self addClassConstant: 'SecondsPerDay' value: 24 * 60 * 60!

minutes: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_MINUTE representation of the <Number> of minutes in the argument. Any fractional minutes are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_MINUTE)
		duration: (Duration minutes: aNumber);
		yourself!

minutes: minutesNumber seconds: secondsNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_MINUTE_TO_SECOND representation of the <Number> of total number of minutes and seconds in the arguments."

	^(self dbInterchangeType: SQL_C_INTERVAL_MINUTE_TO_SECOND)
		duration: (Duration minutes: minutesNumber seconds: secondsNumber);
		yourself!

months: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_MONTH representation of the <Number> of months in the argument. Any fractional number of months are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_MONTH)
		totalMonths: aNumber;
		yourself!

nameOfType: anInteger
	^#('SQL_IS_YEAR' 'SQL_IS_MONTH ' 'SQL_IS_DAY ' 'SQL_IS_HOUR ' 'SQL_IS_MINUTE ' 'SQL_IS_SECOND ' 'SQL_IS_YEAR_TO_MONTH ' 'SQL_IS_DAY_TO_HOUR ' 'SQL_IS_DAY_TO_MINUTE ' 'SQL_IS_DAY_TO_SECOND ' 'SQL_IS_HOUR_TO_MINUTE ' 'SQL_IS_HOUR_TO_SECOND ' 'SQL_IS_MINUTE_TO_SECOND')
		at: anInteger!

seconds: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_SECOND representation of the <Number> of seconds in the argument."

	^(self dbInterchangeType: SQL_C_INTERVAL_SECOND)
		duration: (Duration seconds: aNumber);
		yourself!

years: aNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_YEAR representation of the <Number> of years in the argument. Any fractional years are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_YEAR)
		totalMonths: aNumber * 12;
		yourself!

years: yearsNumber months: monthsNumber
	"Answer a new instance of the receiver which is a SQL_C_INTERVAL_YEAR_TO_MONTH representation of the <Number> of total number of years and months in the arguments. Any fractional months are lost."

	^(self dbInterchangeType: SQL_C_INTERVAL_YEAR_TO_MONTH)
		totalMonths: yearsNumber * 12 + monthsNumber;
		yourself! !

!SQL_INTERVAL_STRUCT class categoriesForMethods!
days:!instance creation!public! !
days:hours:!instance creation!public! !
days:hours:minutes:!instance creation!public! !
days:hours:minutes:seconds:!instance creation!public! !
dbInterchangeType:!instance creation!public! !
dbNewForColumn:!instance creation!public! !
defineFields!public!template definition! !
hours:!instance creation!public! !
hours:minutes:!instance creation!public! !
hours:minutes:seconds:!instance creation!public! !
initialize!class initialization!public! !
minutes:!instance creation!public! !
minutes:seconds:!instance creation!public! !
months:!instance creation!public! !
nameOfType:!enquiries!public! !
seconds:!instance creation!public! !
years:!instance creation!public! !
years:months:!instance creation!public! !
!

