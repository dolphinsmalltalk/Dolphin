"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ODBCTIMESTAMP
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_day _OffsetOf_fraction _OffsetOf_hour _OffsetOf_minute _OffsetOf_month _OffsetOf_second _OffsetOf_year'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

ODBCTIMESTAMP guid: (GUID fromString: '{87b4c599-026e-11d3-9fd7-00a0cc3e4a32}')!

ODBCTIMESTAMP addClassConstant: '_OffsetOf_day' value: 16r4!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_fraction' value: 16rC!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_hour' value: 16r6!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_minute' value: 16r8!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_month' value: 16r2!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_second' value: 16rA!
ODBCTIMESTAMP addClassConstant: '_OffsetOf_year' value: 16r0!

ODBCTIMESTAMP comment: 'ODBCTIMESTAMP is a representation of the same named Win32 ODBC structure.

The fraction field is the number of billionths of a second, i.e. a value of 1,000,000 is one millisecond.'!

!ODBCTIMESTAMP categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !

!ODBCTIMESTAMP methodsFor!

asDateAndTime
	"Answers a DateAndTime which represents the receiver."

	^DateAndTime year: self year month: self month day: self day hour: self hour minute: self minute second: self second + (self fraction / 1e9)!

dateAndTime: aDateAndTime
	"Set the receiver's field values from the <DateAndTime> argument."

	^aDateAndTime dayMonthYearDo: 
			[:d :m :y |
			self
				day: d;
				month: m;
				year: y;
				hour: aDateAndTime hour;
				minute: aDateAndTime minute;
				second: aDateAndTime second truncated;
				fraction: aDateAndTime nanosecond truncated]!

day
	"Answer the <Integer> value of the receiver's 'day' field."

	^bytes wordAtOffset: _OffsetOf_day!

day: anInteger
	"Set the receiver's 'day' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_day put: anInteger!

fraction
	"Answer the <Integer> value of the receiver's 'fraction' field."

	^bytes dwordAtOffset: _OffsetOf_fraction!

fraction: anInteger
	"Set the receiver's 'fraction' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_fraction put: anInteger!

hour
	"Answer the <Integer> value of the receiver's 'hour' field."

	^bytes wordAtOffset: _OffsetOf_hour!

hour: anInteger
	"Set the receiver's 'hour' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_hour put: anInteger!

milliseconds
	"Answer the number of whole milliseconds in the fraction part of
	the receiver."

	^self fraction // 1000000!

minute
	"Answer the <Integer> value of the receiver's 'minute' field."

	^bytes wordAtOffset: _OffsetOf_minute!

minute: anInteger
	"Set the receiver's 'minute' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_minute put: anInteger!

month
	"Answer the <Integer> value of the receiver's 'month' field."

	^bytes wordAtOffset: _OffsetOf_month!

month: anInteger
	"Set the receiver's 'month' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_month put: anInteger!

second
	"Answer the <Integer> value of the receiver's 'second' field."

	^bytes wordAtOffset: _OffsetOf_second!

second: anInteger
	"Set the receiver's 'second' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_second put: anInteger!

year
	"Answer the <Integer> value of the receiver's 'year' field."

	^bytes swordAtOffset: _OffsetOf_year!

year: anInteger
	"Set the receiver's 'year' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_year put: anInteger! !

!ODBCTIMESTAMP categoriesForMethods!
asDateAndTime!converting!public! !
dateAndTime:!accessing!public! !
day!**compiled accessors**!public! !
day:!**compiled accessors**!public! !
fraction!**compiled accessors**!public! !
fraction:!**compiled accessors**!public! !
hour!**compiled accessors**!public! !
hour:!**compiled accessors**!public! !
milliseconds!accessing!public! !
minute!**compiled accessors**!public! !
minute:!**compiled accessors**!public! !
month!**compiled accessors**!public! !
month:!**compiled accessors**!public! !
second!**compiled accessors**!public! !
second:!**compiled accessors**!public! !
year!**compiled accessors**!public! !
year:!**compiled accessors**!public! !
!

!ODBCTIMESTAMP class methodsFor!

defineFields
	"Define the fields of the ODBC TIMESTAMP structure
		self compileDefinition

	typedef struct tagTIMESTAMP_STRUCT
	{
		SQLSMALLINT    year;
		SQLUSMALLINT   month;
		SQLUSMALLINT   day;
		SQLUSMALLINT   hour;
		SQLUSMALLINT   minute;
		SQLUSMALLINT   second;
		SQLUINTEGER    fraction;
	} TIMESTAMP_STRUCT;"

	self
		defineField: #year type: SWORDField new;
		defineField: #month type: WORDField new;
		defineField: #day type: WORDField new;
		defineField: #hour type: WORDField new;
		defineField: #minute type: WORDField new;
		defineField: #second type: WORDField new;
		defineField: #fraction type: DWORDField new!

fromDateAndTime: aDateAndTime
	"Answer an instance of the receiver representing the same local time as the <DateAndTime> argument."

	^self new
		dateAndTime: aDateAndTime;
		yourself!

getFieldNames
	^#(#year #month #day #hour #minute #second #fraction)! !

!ODBCTIMESTAMP class categoriesForMethods!
defineFields!public!template definition! !
fromDateAndTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

