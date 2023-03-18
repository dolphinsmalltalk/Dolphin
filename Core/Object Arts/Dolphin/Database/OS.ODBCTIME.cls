"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.ODBCTIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ODBCTIME_Size' -> 16r6.
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

	^bytes uint16AtOffset: _OffsetOf_hour!

hour: anInteger
	"Set the receiver's 'hour' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_hour put: anInteger!

minute
	"Answer the <Integer> value of the receiver's 'minute' field."

	^bytes uint16AtOffset: _OffsetOf_minute!

minute: anInteger
	"Set the receiver's 'minute' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_minute put: anInteger!

second
	"Answer the <Integer> value of the receiver's 'second' field."

	^bytes uint16AtOffset: _OffsetOf_second!

second: anInteger
	"Set the receiver's 'second' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_second put: anInteger!

time: aTime
	"Set the receiver's fields from the <Time> argument."

	self
		hour: aTime hour;
		minute: aTime minute;
		second: aTime second truncated "ODBCTIME doesn't support fractional seconds"! !
!OS.ODBCTIME categoriesForMethods!
asTime!converting!public! !
hour!**compiled accessors**!public! !
hour:!**compiled accessors**!public! !
minute!**compiled accessors**!public! !
minute:!**compiled accessors**!public! !
second!**compiled accessors**!public! !
second:!**compiled accessors**!public! !
time:!accessing!public! !
!

!OS.ODBCTIME class methodsFor!

byteSize
	^_ODBCTIME_Size!

defineFields
	"typedef struct tagTIME_STRUCT
	{
		SQLUSMALLINT   hour;
		SQLUSMALLINT   minute;
		SQLUSMALLINT   second;
	} TIME_STRUCT;"

	self
		defineField: #hour type: UInt16Field new;
		defineField: #minute type: UInt16Field new;
		defineField: #second type: UInt16Field new
!

fromTime: aTime
	"Answer an instance of the receiver with the details of aTime."

	^self new
		time: aTime;
		yourself!

getFieldNames
	^#(#hour #minute #second)! !
!OS.ODBCTIME class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

