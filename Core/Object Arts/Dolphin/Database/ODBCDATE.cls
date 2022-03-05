"Filed out from Dolphin Smalltalk"!

ExternalStructure subclass: #ODBCDATE
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_day _OffsetOf_month _OffsetOf_year'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
ODBCDATE guid: (GUID fromString: '{87b4c597-026e-11d3-9fd7-00a0cc3e4a32}')!
ODBCDATE addClassConstant: '_OffsetOf_day' value: 16r4!
ODBCDATE addClassConstant: '_OffsetOf_month' value: 16r2!
ODBCDATE addClassConstant: '_OffsetOf_year' value: 16r0!
ODBCDATE comment: 'ODBCDATE is a representation of the same named Win32 ODBC structure.'!
!ODBCDATE categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!ODBCDATE methodsFor!

asDate
	"Answers a Date which represents the receiver."

	^Date
		newDay: self day
		monthIndex: self month
		year: self year!

date: aDate
	"Set the receiver's fields from the <Date> argument."

	^aDate dayMonthYearDo: 
			[:d :m :y |
			self
				day: d;
				month: m;
				year: y]!

day
	"Answer the <Integer> value of the receiver's 'day' field."

	^bytes wordAtOffset: _OffsetOf_day!

day: anInteger
	"Set the receiver's 'day' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_day put: anInteger!

month
	"Answer the <Integer> value of the receiver's 'month' field."

	^bytes wordAtOffset: _OffsetOf_month!

month: anInteger
	"Set the receiver's 'month' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_month put: anInteger!

year
	"Answer the <Integer> value of the receiver's 'year' field."

	^bytes swordAtOffset: _OffsetOf_year!

year: anInteger
	"Set the receiver's 'year' field to the value of the argument, anInteger"

	bytes swordAtOffset: _OffsetOf_year put: anInteger! !
!ODBCDATE categoriesForMethods!
asDate!converting!public! !
date:!accessing!public! !
day!**compiled accessors**!public! !
day:!**compiled accessors**!public! !
month!**compiled accessors**!public! !
month:!**compiled accessors**!public! !
year!**compiled accessors**!public! !
year:!**compiled accessors**!public! !
!

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
		date: aDate;
		yourself!

getFieldNames
	^#(#year #month #day)! !
!ODBCDATE class categoriesForMethods!
defineFields!public!template definition! !
fromDate:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

