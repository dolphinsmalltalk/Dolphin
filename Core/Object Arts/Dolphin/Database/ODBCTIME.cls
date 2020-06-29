"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ODBCTIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hour' -> 16r0.
		'_OffsetOf_minute' -> 16r2.
		'_OffsetOf_second' -> 16r4
	}!
ODBCTIME guid: (GUID fromString: '{87b4c598-026e-11d3-9fd7-00a0cc3e4a32}')!
ODBCTIME comment: 'ODBCTIME is a representation of the same named Win32 ODBC structure.'!
!ODBCTIME categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!ODBCTIME methodsFor!

asTime
	"Answers a Time which represents the receiver."

	^Time fromSeconds: ((self hour * 60 + self minute) * 60 + self second)!

hour
	"Answer the <Integer> value of the receiver's 'hour' field."

	^bytes wordAtOffset: _OffsetOf_hour!

hour: anInteger
	"Set the receiver's 'hour' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_hour put: anInteger!

minute
	"Answer the <Integer> value of the receiver's 'minute' field."

	^bytes wordAtOffset: _OffsetOf_minute!

minute: anInteger
	"Set the receiver's 'minute' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_minute put: anInteger!

second
	"Answer the <Integer> value of the receiver's 'second' field."

	^bytes wordAtOffset: _OffsetOf_second!

second: anInteger
	"Set the receiver's 'second' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_second put: anInteger!

time: aTime
	"Set the receiver's fields from the <Time> argument."

	self
		hour: aTime hour;
		minute: aTime minute;
		second: aTime second! !
!ODBCTIME categoriesFor: #asTime!converting!public! !
!ODBCTIME categoriesFor: #hour!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #hour:!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #minute!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #minute:!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #second!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #second:!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #time:!accessing!public! !

!ODBCTIME class methodsFor!

defineFields
	"typedef struct tagTIME_STRUCT
	{
		SQLUSMALLINT   hour;
		SQLUSMALLINT   minute;
		SQLUSMALLINT   second;
	} TIME_STRUCT;"

	self
		defineField: #hour type: WORDField new;
		defineField: #minute type: WORDField new;
		defineField: #second type: WORDField new
!

fromTime: aTime
	"Answer an instance of the receiver with the details of aTime."

	^self new
		time: aTime;
		yourself!

getFieldNames
	^#(#hour #minute #second)! !
!ODBCTIME class categoriesFor: #defineFields!public!template definition! !
!ODBCTIME class categoriesFor: #fromTime:!instance creation!public! !
!ODBCTIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

