"Filed out from Dolphin Smalltalk 7"!

ExternalStructure subclass: #ODBCDATE
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBCDATE guid: (GUID fromString: '{87b4c597-026e-11d3-9fd7-00a0cc3e4a32}')!
ODBCDATE comment: 'ODBCDATE is a representation of the same named Win32 ODBC structure.'!
!ODBCDATE categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!ODBCDATE methodsFor!

asDate
	"Answers a Date which represents the receiver."

	^Date
		newDay: self day
		monthIndex: self month
		year: self year!

day
	"Answer the receiver's day field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes wordAtOffset: 4)!

day: anObject
	"Set the receiver's day field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes wordAtOffset: 4 put: anObject!

month
	"Answer the receiver's month field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes wordAtOffset: 2)!

month: anObject
	"Set the receiver's month field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes wordAtOffset: 2 put: anObject!

year
	"Answer the receiver's year field as a Smalltalk object.
	Automatically generated get method - do not modify"

	^(bytes swordAtOffset: 0)!

year: anObject
	"Set the receiver's year field to the value of anObject.
	Automatically generated set method - do not modify"

	bytes swordAtOffset: 0 put: anObject! !
!ODBCDATE categoriesFor: #asDate!converting!public! !
!ODBCDATE categoriesFor: #day!**compiled accessors**!public! !
!ODBCDATE categoriesFor: #day:!**compiled accessors**!public! !
!ODBCDATE categoriesFor: #month!**compiled accessors**!public! !
!ODBCDATE categoriesFor: #month:!**compiled accessors**!public! !
!ODBCDATE categoriesFor: #year!**compiled accessors**!public! !
!ODBCDATE categoriesFor: #year:!**compiled accessors**!public! !

!ODBCDATE class methodsFor!

defineFields
	"typedef struct tagDATE_STRUCT
	{
		SWORD year;
		UWORD month;
		UWORD day;
	} DATE_STRUCT;"

	self
		defineField: #year type: SWORDField new;
		defineField: #month type: WORDField new;
		defineField: #day type: WORDField new
!

fromDate: aDate
	"Answer an instance of the receiver with the details of aDate."

	^self new
		day: aDate dayOfMonth;
		month: aDate monthIndex;
		year: aDate year;
		yourself
! !
!ODBCDATE class categoriesFor: #defineFields!constants!public! !
!ODBCDATE class categoriesFor: #fromDate:!instance creation!public! !

