"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ODBCTIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBCTIME guid: (GUID fromString: '{87b4c598-026e-11d3-9fd7-00a0cc3e4a32}')!
ODBCTIME comment: 'ODBCTIME is a representation of the same named Win32 ODBC structure.'!
!ODBCTIME categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!ODBCTIME methodsFor!

asTime
	"Answers a Time which represents the receiver."

	^Time fromSeconds: ((self hour * 60 + self minute) * 60 + self second)!

hour
	"Answer the <Integer> value of the receiver's 'hour' field."

	^bytes wordAtOffset: 0!

hour: anInteger
	"Set the receiver's 'hour' field to the value of the argument, anInteger"

	bytes wordAtOffset: 0 put: anInteger!

minute
	"Answer the <Integer> value of the receiver's 'minute' field."

	^bytes wordAtOffset: ##(self offsetOf: #minute)!

minute: anInteger
	"Set the receiver's 'minute' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #minute) put: anInteger!

second
	"Answer the <Integer> value of the receiver's 'second' field."

	^bytes wordAtOffset: ##(self offsetOf: #second)!

second: anInteger
	"Set the receiver's 'second' field to the value of the argument, anInteger"

	bytes wordAtOffset: ##(self offsetOf: #second) put: anInteger! !
!ODBCTIME categoriesFor: #asTime!converting!public! !
!ODBCTIME categoriesFor: #hour!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #hour:!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #minute!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #minute:!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #second!**compiled accessors**!public! !
!ODBCTIME categoriesFor: #second:!**compiled accessors**!public! !

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
		hour: aTime hours;
		minute: aTime minutes;
		second: aTime seconds;
		yourself
!

getFieldNames
	^#(#hour #minute #second)! !
!ODBCTIME class categoriesFor: #defineFields!initializing!public! !
!ODBCTIME class categoriesFor: #fromTime:!instance creation!public! !
!ODBCTIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

