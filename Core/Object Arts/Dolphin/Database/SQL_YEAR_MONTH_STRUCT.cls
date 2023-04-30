﻿"Filed out from Dolphin Smalltalk"!

SQL_INTERVAL_STRUCT subclass: #SQL_YEAR_MONTH_STRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_fiiller3 _OffsetOf_filler1 _OffsetOf_filler2 _OffsetOf_month _OffsetOf_year'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SQL_YEAR_MONTH_STRUCT guid: (GUID fromString: '{7035b2b3-b254-4c8c-af2b-ce487a9fe29f}')!

SQL_YEAR_MONTH_STRUCT addClassConstant: '_OffsetOf_fiiller3' value: 16r18!
SQL_YEAR_MONTH_STRUCT addClassConstant: '_OffsetOf_filler1' value: 16r10!
SQL_YEAR_MONTH_STRUCT addClassConstant: '_OffsetOf_filler2' value: 16r14!
SQL_YEAR_MONTH_STRUCT addClassConstant: '_OffsetOf_month' value: 16rC!
SQL_YEAR_MONTH_STRUCT addClassConstant: '_OffsetOf_year' value: 16r8!

SQL_YEAR_MONTH_STRUCT comment: ''!

!SQL_YEAR_MONTH_STRUCT categoriesForClass!External-Data-Structured! !

!SQL_YEAR_MONTH_STRUCT methodsFor!

= anExternalStructure
	self == anExternalStructure ifTrue: [^true].
	self species == anExternalStructure species ifFalse: [^false].
	(self isNull or: [anExternalStructure isNull]) ifTrue: [^self isNull == anExternalStructure isNull].
	^self totalMonths = anExternalStructure totalMonths!

hash
	^self species hash + self totalMonths hash!

isYearMonth
	^true!

month
	"Answer the <Integer> value of the receiver's 'month' field."

	^bytes dwordAtOffset: _OffsetOf_month!

month: anInteger
	"Set the receiver's 'month' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_month put: anInteger!

months
	"Answer an <integer> in the range [-11, 11], inclusive, which is the number of whole months represented by the receiver after complete years have been removed."

	^self totalMonths rem: 12!

totalMonths
	"Answer the <integer> number of whole months in the interval described by the receiver."

	^(((##((Array new: 13 withAll: [:interval | interval errorWrongIntervalType])
		at: SQL_IS_YEAR put: [:interval | interval year * 12];
		at: SQL_IS_MONTH put: [:interval | interval month];
		at: SQL_IS_YEAR_TO_MONTH put: [:interval | interval year * 12 + interval month];
		yourself) lookup: self interval_type)
		ifNil: [[:interval | 0]]) value: self)
		* self sign!

totalMonths: aNumber
	"Set the <Number> of months in the interval described by the receiver."

	(##((Array new: 13 withAll: [:interval | interval errorWrongIntervalType])
		at: SQL_IS_YEAR put: [:interval :months | interval year: months // 12];
		at: SQL_IS_MONTH put: [:interval :months | interval month: months truncated];
		at: SQL_IS_YEAR_TO_MONTH
			put: 
				[:interval :months |
				interval
					year: months // 12;
					month: (months \\ 12) truncated];
		yourself) at: self interval_type)
		value: self
		value: aNumber abs.
	self sign: aNumber sign!

totalYears
	"Answer the <Number> of years in the interval described by the receiver. Will include a fractional part if the interval includes part years, i.e. (SQL_INTERVAL_STRUCT years: 2 months: 6) years = 2.5, or (SQL_INTERVAL_STRUCT months: 15) years = 1.25"

	^self totalMonths / 12!

totalYears: aNumber
	"Set the <Number> of years in the interval described by the receiver. If the argument includes a fractional part then the resulting interval may include part years if it is of YEAR TO MONTH or MONTH type."

	self totalMonths: aNumber * 12!

value
	^self copy!

value: aSQL_YEAR_MONTH_STRUCT
	self totalMonths: aSQL_YEAR_MONTH_STRUCT totalMonths!

year
	"Answer the <Integer> value of the receiver's 'year' field."

	^bytes dwordAtOffset: _OffsetOf_year!

year: anInteger
	"Set the receiver's 'year' field to the value of the argument, anInteger"

	bytes dwordAtOffset: _OffsetOf_year put: anInteger!

years
	"Answer the <Integer> number of whole years in the interval described by the receiver. Any fractional part is truncated."

	^self totalMonths quo: 12! !

!SQL_YEAR_MONTH_STRUCT categoriesForMethods!
=!comparing!public! !
hash!comparing!public! !
isYearMonth!public!testing! !
month!**compiled accessors**!public! !
month:!**compiled accessors**!public! !
months!accessing!public! !
totalMonths!accessing!public! !
totalMonths:!accessing!public! !
totalYears!accessing!public! !
totalYears:!accessing!public! !
value!accessing!public! !
value:!accessing!public! !
year!**compiled accessors**!public! !
year:!**compiled accessors**!public! !
years!accessing!public! !
!

!SQL_YEAR_MONTH_STRUCT class methodsFor!

dbInterchangeType: anInteger
	^self newBuffer
		interval_type: anInteger - 100;
		yourself!

defineFields
	"
		self compileDefinition

	typedef struct tagSQL_YEAR_MONTH
	{
		SQLUINTEGER		year;
		SQLUINTEGER		month;
	} SQL_YEAR_MONTH_STRUCT;"

	super defineFields.
	self
		defineField: #year type: DWORDField new;
		defineField: #month type: DWORDField new;
		defineField: #filler1 type: DWORDField filler;
		defineField: #filler2 type: DWORDField filler;
		defineField: #fiiller3 type: DWORDField filler!

getFieldNames
	^#(#interval_type #interval_sign #year #month)! !

!SQL_YEAR_MONTH_STRUCT class categoriesForMethods!
dbInterchangeType:!instance creation!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!
