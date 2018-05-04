"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ODBCTIMESTAMP
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBCTIMESTAMP guid: (GUID fromString: '{87b4c599-026e-11d3-9fd7-00a0cc3e4a32}')!
ODBCTIMESTAMP comment: 'ODBCTIMESTAMP is a representation of the same named Win32 ODBC structure.

The fraction field is the number of billionths of a second, i.e. a value of 1,000,000 is one millisecond.'!
!ODBCTIMESTAMP categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!ODBCTIMESTAMP methodsFor!

asTimeStamp
	"Answers a TimeStamp which represents the receiver."

	| date time |
	date := Date
		newDay: self day
		monthIndex: self month
		year: self year.

	time := Time fromMilliseconds: ((self hour * 60 + self minute) * 60 + self second) * 1000
							+ self milliseconds.

	^TimeStamp date: date time: time
!

day
	"Answer the receiver's day field as a Smalltalk object."

	^(bytes wordAtOffset: 4)!

day: anObject
	"Set the receiver's day field to the value of anObject."

	bytes wordAtOffset: 4 put: anObject!

fraction
	"Answer the receiver's fraction field as a Smalltalk object."

	^(bytes dwordAtOffset: 12)!

fraction: anObject
	"Set the receiver's fraction field to the value of anObject."

	bytes dwordAtOffset: 12 put: anObject!

hour
	"Answer the receiver's hour field as a Smalltalk object."

	^(bytes wordAtOffset: 6)!

hour: anObject
	"Set the receiver's hour field to the value of anObject."

	bytes wordAtOffset: 6 put: anObject!

milliseconds
	"Answer the number of whole milliseconds in the fraction part of
	the receiver."

	^self fraction // 1000000!

minute
	"Answer the receiver's minute field as a Smalltalk object."

	^(bytes wordAtOffset: 8)!

minute: anObject
	"Set the receiver's minute field to the value of anObject."

	bytes wordAtOffset: 8 put: anObject!

month
	"Answer the receiver's month field as a Smalltalk object."

	^(bytes wordAtOffset: 2)!

month: anObject
	"Set the receiver's month field to the value of anObject."

	bytes wordAtOffset: 2 put: anObject!

second
	"Answer the receiver's second field as a Smalltalk object."

	^(bytes wordAtOffset: 10)!

second: anObject
	"Set the receiver's second field to the value of anObject."

	bytes wordAtOffset: 10 put: anObject!

year
	"Answer the receiver's year field as a Smalltalk object."

	^(bytes swordAtOffset: 0)!

year: anObject
	"Set the receiver's year field to the value of anObject."

	bytes swordAtOffset: 0 put: anObject! !
!ODBCTIMESTAMP categoriesFor: #asTimeStamp!converting!public! !
!ODBCTIMESTAMP categoriesFor: #day!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #day:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #fraction!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #fraction:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #hour!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #hour:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #milliseconds!accessing!public! !
!ODBCTIMESTAMP categoriesFor: #minute!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #minute:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #month!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #month:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #second!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #second:!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #year!**compiled accessors**!public! !
!ODBCTIMESTAMP categoriesFor: #year:!**compiled accessors**!public! !

!ODBCTIMESTAMP class methodsFor!

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
		defineField: #year type: SWORDField new;
		defineField: #month type: WORDField new;
		defineField: #day type: WORDField new;
		defineField: #hour type: WORDField new;
		defineField: #minute type: WORDField new;
		defineField: #second type: WORDField new;
		defineField: #fraction type: DWORDField new!

fromTimeStamp: aTimeStamp
	"Answer an instance of the receiver with the details of aTimeStamp."

	| date time |
	date := aTimeStamp date.
	time := aTimeStamp time.

	^self new
		day: date dayOfMonth;
		month: date monthIndex;
		year: date year;
		hour: time hours;
		minute: time minutes;
		second: time seconds;
		fraction: (time asMilliseconds \\ 1000) * 1000000;
		yourself
! !
!ODBCTIMESTAMP class categoriesFor: #defineFields!initializing!public! !
!ODBCTIMESTAMP class categoriesFor: #fromTimeStamp:!instance creation!public! !

