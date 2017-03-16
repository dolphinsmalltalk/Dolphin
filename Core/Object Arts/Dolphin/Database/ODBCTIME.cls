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
	"Answer the receiver's hour field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes wordAtOffset: 0)!

hour: anObject
	"Set the receiver's hour field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes wordAtOffset: 0 put: anObject!

minute
	"Answer the receiver's minute field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes wordAtOffset: 2)!

minute: anObject
	"Set the receiver's minute field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes wordAtOffset: 2 put: anObject!

second
	"Answer the receiver's second field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes wordAtOffset: 4)!

second: anObject
	"Set the receiver's second field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes wordAtOffset: 4 put: anObject! !
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
! !
!ODBCTIME class categoriesFor: #defineFields!initializing!public! !
!ODBCTIME class categoriesFor: #fromTime:!instance creation!public! !

