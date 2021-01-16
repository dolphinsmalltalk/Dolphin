"Filed out from Dolphin Smalltalk 7"!

External.Structure subclass: #'OS.ODBCDATE'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_day' -> 16r4.
		'_OffsetOf_month' -> 16r2.
		'_OffsetOf_year' -> 16r0
	}!
OS.ODBCDATE guid: (Core.GUID fromString: '{87b4c597-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.ODBCDATE comment: 'ODBCDATE is a representation of the same named Win32 ODBC structure.'!
!OS.ODBCDATE categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !
!OS.ODBCDATE methodsFor!

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
!OS.ODBCDATE categoriesFor: #asDate!converting!public! !
!OS.ODBCDATE categoriesFor: #date:!accessing!public! !
!OS.ODBCDATE categoriesFor: #day!**compiled accessors**!public! !
!OS.ODBCDATE categoriesFor: #day:!**compiled accessors**!public! !
!OS.ODBCDATE categoriesFor: #month!**compiled accessors**!public! !
!OS.ODBCDATE categoriesFor: #month:!**compiled accessors**!public! !
!OS.ODBCDATE categoriesFor: #year!**compiled accessors**!public! !
!OS.ODBCDATE categoriesFor: #year:!**compiled accessors**!public! !

!OS.ODBCDATE class methodsFor!

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
!OS.ODBCDATE class categoriesFor: #defineFields!public!template definition! !
!OS.ODBCDATE class categoriesFor: #fromDate:!instance creation!public! !
!OS.ODBCDATE class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !

