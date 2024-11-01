"Filed out from Dolphin Smalltalk"!

SQL_TIME_STRUCT subclass: #DBTIME2
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_fraction'
	poolDictionaries: ''
	classInstanceVariableNames: ''!

DBTIME2 guid: (GUID fromString: '{e6ec3d86-d568-4feb-b360-0fd8d8232c97}')!

DBTIME2 addClassConstant: '_OffsetOf_fraction' value: 16r8!

DBTIME2 comment: ''!

!DBTIME2 categoriesForClass!External-Data-Structured-ODBC! !

!DBTIME2 methodsFor!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^ODBCCTypes.SQL_C_SS_TIME2!

dbMarshal: anObject into: aDBField
	"Populate the receiver, as buffer of the <DBField> 2nd argument, with the SQL_C_SS_TIME2 representation of the 1st argument, which must yield a <Time> when sent #asTime. The fractional seconds of the <Time> will be truncated to the scale of the column."

	self value: (self dbConvert: anObject for: aDBField) scale: aDBField scale.
	aDBField length: self byteSize!

value
	"Answers a Time which represents the receiver."

	^Time
		hours: (bytes wordAtOffset: _OffsetOf_hour)
		minutes: (bytes wordAtOffset: _OffsetOf_minute)
		seconds: (bytes wordAtOffset: _OffsetOf_second) + ((bytes dwordAtOffset: _OffsetOf_fraction) / 1e9)!

value: aTime scale: anInteger
	"Set the receiver's fields from the <Time> argument."

	bytes
		wordAtOffset: _OffsetOf_hour put: aTime hour;
		wordAtOffset: _OffsetOf_minute put: aTime minute;
		wordAtOffset: _OffsetOf_second put: aTime second truncated;
		dwordAtOffset: _OffsetOf_fraction
			put: (anInteger == 0 ifTrue: [0] ifFalse: [aTime nanosecond truncateTo: (9 - anInteger) exp10])! !

!DBTIME2 categoriesForMethods!
dbInterchangeType!constants!public! !
dbMarshal:into:!operations!public! !
value!converting!public! !
value:scale:!accessing!public! !
!

!DBTIME2 class methodsFor!

defineFields
	"
		self compileDefinition

	typedef struct tagDBTIME2
	{
		USHORT hour;
		USHORT minute;
		USHORT second;
		ULONG fraction;
	} 	DBTIME2;"

	super defineFields.
	self defineField: #fraction type: DWORDField uncompiled!

getFieldNames
	^#(#hour #minute #second #fraction)! !

!DBTIME2 class categoriesForMethods!
defineFields!public!template definition! !
getFieldNames!**compiled accessors**!constants!private! !
!

