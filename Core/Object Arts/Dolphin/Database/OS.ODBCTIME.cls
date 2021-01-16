"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.ODBCTIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_hour' -> 16r0.
		'_OffsetOf_minute' -> 16r2.
		'_OffsetOf_second' -> 16r4
	}!
OS.ODBCTIME guid: (Core.GUID fromString: '{87b4c598-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.ODBCTIME comment: 'ODBCTIME is a representation of the same named Win32 ODBC structure.'!
!OS.ODBCTIME categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!OS.ODBCTIME methodsFor!

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
!OS.ODBCTIME categoriesFor: #asTime!converting!public! !
!OS.ODBCTIME categoriesFor: #hour!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #hour:!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #minute!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #minute:!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #second!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #second:!**compiled accessors**!public! !
!OS.ODBCTIME categoriesFor: #time:!accessing!public! !

!OS.ODBCTIME class methodsFor!

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
!OS.ODBCTIME class categoriesFor: #defineFields!public!template definition! !
!OS.ODBCTIME class categoriesFor: #fromTime:!instance creation!public! !
!OS.ODBCTIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

