"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #SQL_TIMESTAMP_STRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_day _OffsetOf_fraction _OffsetOf_hour _OffsetOf_minute _OffsetOf_month _OffsetOf_second _OffsetOf_year'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SQL_TIMESTAMP_STRUCT guid: (GUID fromString: '{87b4c599-026e-11d3-9fd7-00a0cc3e4a32}')!

SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_day' value: 16r4!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_fraction' value: 16rC!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_hour' value: 16r6!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_minute' value: 16r8!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_month' value: 16r2!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_second' value: 16rA!
SQL_TIMESTAMP_STRUCT addClassConstant: '_OffsetOf_year' value: 16r0!

SQL_TIMESTAMP_STRUCT comment: 'SQL_TIMESTAMP_STRUCT is a representation of the same named Win32 ODBC structure.

The fraction field is the number of billionths of a second, i.e. a value of 1,000,000 is one millisecond.'!

!SQL_TIMESTAMP_STRUCT categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !

!SQL_TIMESTAMP_STRUCT methodsFor!

asDateAndTime
	"Answers a DateAndTime which represents the receiver."

	^self value!

dbConvert: anObject for: aDBField
	"Convert the argument to a local <DateAndTime> for marshalling to SQL_C_TYPE_TIMESTAMP representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asDateAndTime asLocal!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^ODBCCTypes.SQL_C_TIMESTAMP!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_TYPE_TIMESTAMP representation of the 1st argument, which must yield a <DateAndTime> when sent #asDateAndTime. Note that a local time (not UTC) will be stored as expected for the column type."

	self value: (self dbConvert: anObject for: aDBField) scale: aDBField scale.
	aDBField length: self byteSize!

milliseconds
	"Answer the number of whole milliseconds in the fraction part of
	the receiver."

	^(bytes dwordAtOffset: _OffsetOf_fraction) // 1000000!

value
	"Answers a local <DateAndTime> which represents the receiver."

	^DateAndTime
		year: (bytes swordAtOffset: _OffsetOf_year)
		month: (bytes wordAtOffset: _OffsetOf_month)
		day: (bytes wordAtOffset: _OffsetOf_day)
		hour: (bytes wordAtOffset: _OffsetOf_hour)
		minute: (bytes wordAtOffset: _OffsetOf_minute)
		second: (bytes wordAtOffset: _OffsetOf_second) + ((bytes dwordAtOffset: _OffsetOf_fraction) / 1e9)!

value: aDateAndTime scale: anInteger
	"Set the receiver's field values from the <DateAndTime> argument."

	aDateAndTime dayMonthYearDo: 
			[:d :m :y |
			bytes
				wordAtOffset: _OffsetOf_day put: d;
				wordAtOffset: _OffsetOf_month put: m;
				swordAtOffset: _OffsetOf_year put: y].
	bytes
		wordAtOffset: _OffsetOf_hour put: aDateAndTime hour;
		wordAtOffset: _OffsetOf_minute put: aDateAndTime minute;
		wordAtOffset: _OffsetOf_second put: aDateAndTime second truncated;
		dwordAtOffset: _OffsetOf_fraction
			put: (anInteger == 0 ifTrue: [0] ifFalse: [aDateAndTime nanosecond truncateTo: (9 - anInteger) exp10])!

valueClass
	^DateAndTime! !

!SQL_TIMESTAMP_STRUCT categoriesForMethods!
asDateAndTime!converting!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
milliseconds!accessing!public! !
value!converting!public! !
value:scale:!accessing!public! !
valueClass!constants!public! !
!

!SQL_TIMESTAMP_STRUCT class methodsFor!

defineFields
	"Define the fields of the ODBC TIMESTAMP structure
		self compileDefinition
self fullyCompileDefinition
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
		beUncompiled;
		defineField: #year type: SWORDField filler;
		defineField: #month type: WORDField filler;
		defineField: #day type: WORDField filler;
		defineField: #hour type: WORDField filler;
		defineField: #minute type: WORDField filler;
		defineField: #second type: WORDField filler;
		defineField: #fraction type: DWORDField filler!

fromDateAndTime: aDateAndTime
	"Answer an instance of the receiver representing the same local time as the <DateAndTime> argument."

	^self newBuffer
		value: aDateAndTime scale: 7;
		yourself!

getFieldNames
	^#()! !

!SQL_TIMESTAMP_STRUCT class categoriesForMethods!
defineFields!public!template definition! !
fromDateAndTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

