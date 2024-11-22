"Filed out from Dolphin Smalltalk"!

OS.SQL_INTERVAL_STRUCT
	subclass: #'OS.SQL_YEAR_MONTH_STRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_fiiller3' -> 16r18.
			'_OffsetOf_filler1' -> 16r10.
			'_OffsetOf_filler2' -> 16r14.
			'_OffsetOf_month' -> 16rC.
			'_OffsetOf_year' -> 16r8.
			'_SQL_YEAR_MONTH_STRUCT_Size' -> 16r1C
		}!

OS.SQL_YEAR_MONTH_STRUCT guid: (Core.GUID fromString: '{7035b2b3-b254-4c8c-af2b-ce487a9fe29f}')!

OS.SQL_YEAR_MONTH_STRUCT comment: ''!

!OS.SQL_YEAR_MONTH_STRUCT categoriesForClass!External-Data-Structured! !

!OS.SQL_YEAR_MONTH_STRUCT methodsFor!

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

	^bytes uint32AtOffset: _OffsetOf_month!

month: anInteger
	"Set the receiver's 'month' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_month put: anInteger!

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

	^bytes uint32AtOffset: _OffsetOf_year!

year: anInteger
	"Set the receiver's 'year' field to the value of the argument, anInteger"

	bytes uint32AtOffset: _OffsetOf_year put: anInteger!

years
	"Answer the <Integer> number of whole years in the interval described by the receiver. Any fractional part is truncated."

	^self totalMonths quo: 12! !

!OS.SQL_YEAR_MONTH_STRUCT categoriesForMethods!
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

!OS.SQL_YEAR_MONTH_STRUCT class methodsFor!

byteSize
	^_SQL_YEAR_MONTH_STRUCT_Size!

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
		defineField: #year type: UInt32Field new;
		defineField: #month type: UInt32Field new;
		defineField: #filler1 type: UInt32Field filler;
		defineField: #filler2 type: UInt32Field filler;
		defineField: #fiiller3 type: UInt32Field filler!

getFieldNames
	^#(#interval_type #interval_sign #year #month)! !

!OS.SQL_YEAR_MONTH_STRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
dbInterchangeType:!instance creation!public! !
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

