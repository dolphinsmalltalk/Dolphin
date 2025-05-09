﻿"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.SQL_TIME_STRUCT'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_hour' -> 16r0.
			'_OffsetOf_minute' -> 16r2.
			'_OffsetOf_second' -> 16r4.
			'_SQL_TIME_STRUCT_Size' -> 16r6
		}!

OS.SQL_TIME_STRUCT guid: (Core.GUID fromString: '{87b4c598-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.SQL_TIME_STRUCT comment: 'SQL_TIME_STRUCT is a representation of the same named Win32 ODBC structure.'!

!OS.SQL_TIME_STRUCT categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !

!OS.SQL_TIME_STRUCT methodsFor!

asTime
	"Answers a Time which represents the receiver."

	^self value!

dbConvert: anObject for: aDBField
	"Convert the argument to a <Time> for marshalling to SQL_C_TYPE_TIME representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asTime!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^ODBCCTypes.SQL_C_TIME!

time: aTime
	"Set the receiver's fields from the <Time> argument."

	#deprecated.
	self value: aTime!

value
	"Answers a Time which represents the receiver."

	^Time
		fromSeconds: ((bytes uint16AtOffset: _OffsetOf_hour) * 60 + (bytes uint16AtOffset: _OffsetOf_minute))
				* 60 + (bytes uint16AtOffset: _OffsetOf_second)!

value: aTime
	"Set the receiver's fields from the <Time> argument."

	bytes
		uint16AtOffset: _OffsetOf_hour put: aTime hour;
		uint16AtOffset: _OffsetOf_minute put: aTime minute;
		uint16AtOffset: _OffsetOf_second put: aTime second truncated!

valueClass
	^Time! !

!OS.SQL_TIME_STRUCT categoriesForMethods!
asTime!converting!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
time:!accessing!public! !
value!converting!public! !
value:!accessing!public! !
valueClass!constants!public! !
!

!OS.SQL_TIME_STRUCT class methodsFor!

byteSize
	^_SQL_TIME_STRUCT_Size!

defineFields
	"
		self compileDefinition

	typedef struct tagTIME_STRUCT
	{
		SQLUSMALLINT   hour;
		SQLUSMALLINT   minute;
		SQLUSMALLINT   second;
	} TIME_STRUCT;"

	self
		defineField: #hour type: UInt16Field uncompiled;
		defineField: #minute type: UInt16Field uncompiled;
		defineField: #second type: UInt16Field uncompiled!

fromTime: aTime
	"Answer an instance of the receiver with the details of aTime."

	^self new
		time: aTime;
		yourself!

getFieldNames
	^#(#hour #minute #second)! !

!OS.SQL_TIME_STRUCT class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

