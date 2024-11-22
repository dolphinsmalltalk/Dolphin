"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.SQL_TIMESTAMP_STRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_day' -> 16r4.
			'_OffsetOf_fraction' -> 16rC.
			'_OffsetOf_hour' -> 16r6.
			'_OffsetOf_minute' -> 16r8.
			'_OffsetOf_month' -> 16r2.
			'_OffsetOf_second' -> 16rA.
			'_OffsetOf_year' -> 16r0.
			'_SQL_TIMESTAMP_STRUCT_Size' -> 16r10
		}!

OS.SQL_TIMESTAMP_STRUCT guid: (Core.GUID fromString: '{87b4c599-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.SQL_TIMESTAMP_STRUCT comment: 'SQL_TIMESTAMP_STRUCT is a representation of the same named Win32 ODBC structure.

The fraction field is the number of billionths of a second, i.e. a value of 1,000,000 is one millisecond.'!

!OS.SQL_TIMESTAMP_STRUCT categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !

!OS.SQL_TIMESTAMP_STRUCT methodsFor!

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

	self value: (self dbConvert: anObject for: aDBField) scale: aDBField scale ?? 0.
	aDBField length: self byteSize!

milliseconds
	"Answer the number of whole milliseconds in the fraction part of
	the receiver."

	^(bytes uint32AtOffset: _OffsetOf_fraction) // 1000000!

value
	"Answers a local <DateAndTime> which represents the receiver."

	^DateAndTime
		year: (bytes int16AtOffset: _OffsetOf_year)
		month: (bytes uint16AtOffset: _OffsetOf_month)
		day: (bytes uint16AtOffset: _OffsetOf_day)
		hour: (bytes uint16AtOffset: _OffsetOf_hour)
		minute: (bytes uint16AtOffset: _OffsetOf_minute)
		second: (bytes uint16AtOffset: _OffsetOf_second) + ((bytes uint32AtOffset: _OffsetOf_fraction) / 1e9)!

value: aDateAndTime scale: anInteger
	"Set the receiver's field values from the <DateAndTime> argument."

	aDateAndTime dayMonthYearDo: 
			[:d :m :y |
			bytes
				uint16AtOffset: _OffsetOf_day put: d;
				uint16AtOffset: _OffsetOf_month put: m;
				int16AtOffset: _OffsetOf_year put: y].
	bytes
		uint16AtOffset: _OffsetOf_hour put: aDateAndTime hour;
		uint16AtOffset: _OffsetOf_minute put: aDateAndTime minute;
		uint16AtOffset: _OffsetOf_second put: aDateAndTime second truncated;
		uint32AtOffset: _OffsetOf_fraction
			put: (anInteger == 0 ifTrue: [0] ifFalse: [aDateAndTime nanosecond truncateTo: (9 - anInteger) exp10])!

valueClass
	^DateAndTime! !

!OS.SQL_TIMESTAMP_STRUCT categoriesForMethods!
asDateAndTime!converting!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
milliseconds!accessing!public! !
value!converting!public! !
value:scale:!accessing!public! !
valueClass!constants!public! !
!

!OS.SQL_TIMESTAMP_STRUCT class methodsFor!

byteSize
	^_SQL_TIMESTAMP_STRUCT_Size!

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
		beUncompiled;
		defineField: #year type: Int16Field readOnly;
		defineField: #month type: UInt16Field readOnly;
		defineField: #day type: UInt16Field readOnly;
		defineField: #hour type: UInt16Field readOnly;
		defineField: #minute type: UInt16Field readOnly;
		defineField: #second type: UInt16Field readOnly;
		defineField: #fraction type: UInt32Field readOnly!

fromDateAndTime: aDateAndTime
	"Answer an instance of the receiver representing the same local time as the <DateAndTime> argument."

	^self newBuffer
		value: aDateAndTime scale: 7;
		yourself!

getFieldNames
	^#(#year #month #day #hour #minute #second #fraction)! !

!OS.SQL_TIMESTAMP_STRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromDateAndTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

