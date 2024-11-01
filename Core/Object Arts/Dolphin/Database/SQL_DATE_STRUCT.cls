"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #SQL_DATE_STRUCT
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_ODBCDATE_Size' -> 16r6.
			'_OffsetOf_day' -> 16r4.
			'_OffsetOf_month' -> 16r2.
			'_OffsetOf_year' -> 16r0.
			'_SQL_DATE_STRUCT_Size' -> 16r6
		}!

SQL_DATE_STRUCT guid: (Core.GUID fromString: '{87b4c597-026e-11d3-9fd7-00a0cc3e4a32}')!

SQL_DATE_STRUCT comment: 'SQL_DATE_STRUCT is a representation of the same named Win32 ODBC structure.'!

!SQL_DATE_STRUCT categoriesForClass!External-Data-Structured-ODBC!ODBC Interface! !

!SQL_DATE_STRUCT methodsFor!

asDate
	"Answers a Date which represents the receiver."

	^self value!

date: aDate
	"Set the receiver's fields from the <Date> argument."

	#deprecated.
	self value: aDate!

dbConvert: anObject for: aDBField
	"Convert the argument to a <Date> for marshalling to SQL_C_TYPE_DATE representation in the <DBField> 2nd argument. Throw an error if this is not possible."

	^anObject asDate!

dbInterchangeType
	"Answer the ODBC 'C' type to be used as the target (or transfer) type used for interchange of data with the ODBC driver for fields marshalled by the receiver."

	^ODBCCTypes.SQL_C_DATE!

value
	"Answers a Date which represents the receiver."

	^Date
		newDay: (bytes wordAtOffset: _OffsetOf_day)
		monthIndex: (bytes wordAtOffset: _OffsetOf_month)
		year: (bytes swordAtOffset: _OffsetOf_year)!

value: aDate
	"Set the receiver's fields from the <Date> argument."

	aDate dayMonthYearDo: 
			[:d :m :y |
			bytes
				wordAtOffset: _OffsetOf_day put: d;
				wordAtOffset: _OffsetOf_month put: m;
				swordAtOffset: _OffsetOf_year put: y]!

valueClass
	^Date! !

!SQL_DATE_STRUCT categoriesForMethods!
asDate!converting!public! !
date:!accessing!public! !
dbConvert:for:!operations!public! !
dbInterchangeType!constants!public! !
value!converting!public! !
value:!accessing!public! !
valueClass!constants!public! !
!

!SQL_DATE_STRUCT class methodsFor!

defineFields
	"
		self compileDefinition

	typedef struct tagDATE_STRUCT
	{
		SWORD year;
		UWORD month;
		UWORD day;
	} DATE_STRUCT;"

	self
		beUncompiled;
		defineField: #year type: Int16Field new;
		defineField: #month type: UInt16Field new;
		defineField: #day type: UInt16Field new!

fromDate: aDate
	"Answer an instance of the receiver with the details of aDate."

	^self new
		date: aDate;
		yourself!

getFieldNames
	^#(#year #month #day)! !

!SQL_DATE_STRUCT class categoriesForMethods!
defineFields!public!template definition! !
fromDate:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
!

