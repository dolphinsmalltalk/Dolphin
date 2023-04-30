﻿"Filed out from Dolphin Smalltalk"!

SQL_TIMESTAMP_STRUCT subclass: #SQL_SS_TIMESTAMPOFFSET_STRUCT
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_timezone_hour _OffsetOf_timezone_minute'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SQL_SS_TIMESTAMPOFFSET_STRUCT guid: (GUID fromString: '{50763637-4fb0-4add-8ba9-dc5b146de8e7}')!

SQL_SS_TIMESTAMPOFFSET_STRUCT addClassConstant: '_OffsetOf_timezone_hour' value: 16r10!
SQL_SS_TIMESTAMPOFFSET_STRUCT addClassConstant: '_OffsetOf_timezone_minute' value: 16r12!

SQL_SS_TIMESTAMPOFFSET_STRUCT comment: ''!

!SQL_SS_TIMESTAMPOFFSET_STRUCT categoriesForClass!External-Data-Structured-ODBC! !

!SQL_SS_TIMESTAMPOFFSET_STRUCT methodsFor!

dbConvert: anObject for: aDBField
	"Convert the argument to a <DateAndTime> for marshalling to SQL_C_SS_TIMESTAMPOFFSET representation in the <DBField> 2nd argument. Note that the timezone offset is retained (i.e. not converted to a local time). Throw an error if this is not possible."

	^anObject asDateAndTime!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^ODBCCTypes.SQL_C_SS_TIMESTAMPOFFSET!

value
	"Answers a local <DateAndTime> which represents the receiver."

	^DateAndTime
		year: (bytes swordAtOffset: _OffsetOf_year)
		month: (bytes wordAtOffset: _OffsetOf_month)
		day: (bytes wordAtOffset: _OffsetOf_day)
		hour: (bytes wordAtOffset: _OffsetOf_hour)
		minute: (bytes wordAtOffset: _OffsetOf_minute)
		second: (bytes wordAtOffset: _OffsetOf_second) + ((bytes dwordAtOffset: _OffsetOf_fraction) / 1e9)
		offset: (bytes swordAtOffset: _OffsetOf_timezone_hour) hours
				+ (bytes swordAtOffset: _OffsetOf_timezone_minute) minutes!

value: aDateAndTime scale: anInteger
	"Set the receiver's fields from the <Time> argument."

	| offset |
	super value: aDateAndTime scale: anInteger.
	offset := aDateAndTime offset.
	bytes
		swordAtOffset: _OffsetOf_timezone_hour put: offset hours;
		swordAtOffset: _OffsetOf_timezone_minute put: offset minutes! !

!SQL_SS_TIMESTAMPOFFSET_STRUCT categoriesForMethods!
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
value!converting!public! !
value:scale:!accessing!public! !
!

!SQL_SS_TIMESTAMPOFFSET_STRUCT class methodsFor!

defineFields
	"
		self compileDefinition

	typedef struct tagSS_TIMESTAMPOFFSET_STRUCT
	{
		SQLSMALLINT    year;
		SQLUSMALLINT   month;
		SQLUSMALLINT   day;
		SQLUSMALLINT   hour;
		SQLUSMALLINT   minute;
		SQLUSMALLINT   second;
		SQLUINTEGER    fraction;
		SQLSMALLINT    timezone_hour;
		SQLSMALLINT    timezone_minute;
	} SQL_SS_TIMESTAMPOFFSET_STRUCT;"

	super defineFields.
	self
		defineField: #timezone_hour type: SWORDField uncompiled;
		defineField: #timezone_minute type: SWORDField uncompiled!

getFieldNames
	^#(#year #month #day #hour #minute #second #fraction #timezone_hour #timezone_minute)! !

!SQL_SS_TIMESTAMPOFFSET_STRUCT class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!
