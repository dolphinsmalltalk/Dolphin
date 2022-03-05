"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #SYSTEMTIME
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_wDay _OffsetOf_wDayOfWeek _OffsetOf_wHour _OffsetOf_wMilliseconds _OffsetOf_wMinute _OffsetOf_wMonth _OffsetOf_wSecond _OffsetOf_wYear'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SYSTEMTIME guid: (GUID fromString: '{87b4c612-026e-11d3-9fd7-00a0cc3e4a32}')!
SYSTEMTIME addClassConstant: '_OffsetOf_wDay' value: 16r6!
SYSTEMTIME addClassConstant: '_OffsetOf_wDayOfWeek' value: 16r4!
SYSTEMTIME addClassConstant: '_OffsetOf_wHour' value: 16r8!
SYSTEMTIME addClassConstant: '_OffsetOf_wMilliseconds' value: 16rE!
SYSTEMTIME addClassConstant: '_OffsetOf_wMinute' value: 16rA!
SYSTEMTIME addClassConstant: '_OffsetOf_wMonth' value: 16r2!
SYSTEMTIME addClassConstant: '_OffsetOf_wSecond' value: 16rC!
SYSTEMTIME addClassConstant: '_OffsetOf_wYear' value: 16r0!
SYSTEMTIME comment: ''!
!SYSTEMTIME categoriesForClass!Win32-Structs! !
!SYSTEMTIME methodsFor!

asDateAndTime
	"Answer a <DateAndTime> corresponding to the receiver."

	^DateAndTime fromSYSTEMTIME: self!

asFILETIME
	"Answer a FILETIME corresponding to the receiver."

	^FILETIME fromSYSTEMTIME: self!

asSYSTEMTIME
	^self!

dayOfMonth
	^self wDay!

dayOfWeek
	^self wDayOfWeek + 1!

displayOn: aStream
	"Append a displayable representation of the receiver to aStream."

	Locale default displayDateTime: self on: aStream!

hour
	^self wHour!

hour12
	"Answer an <integer> between 1 and 12, inclusive, representing the hour of the day in the 12-hour clock of the local time of the receiver."

	^self wHour - 1 \\ 12 + 1!

hour24
	^self wHour!

minute
	^self wMinute!

month
	^self wMonth!

second
	^self wSecond + (self wMilliseconds / 1000)!

wDay
	"Answer the <Integer> value of the receiver's 'wDay' field."

	^bytes wordAtOffset: _OffsetOf_wDay!

wDay: anInteger
	"Set the receiver's 'wDay' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wDay put: anInteger!

wDayOfWeek
	"Answer the <Integer> value of the receiver's 'wDayOfWeek' field."

	^bytes wordAtOffset: _OffsetOf_wDayOfWeek!

wDayOfWeek: anInteger
	"Set the receiver's 'wDayOfWeek' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wDayOfWeek put: anInteger!

wHour
	"Answer the <Integer> value of the receiver's 'wHour' field."

	^bytes wordAtOffset: _OffsetOf_wHour!

wHour: anInteger
	"Set the receiver's 'wHour' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wHour put: anInteger!

wMilliseconds
	"Answer the <Integer> value of the receiver's 'wMilliseconds' field."

	^bytes wordAtOffset: _OffsetOf_wMilliseconds!

wMilliseconds: anInteger
	"Set the receiver's 'wMilliseconds' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wMilliseconds put: anInteger!

wMinute
	"Answer the <Integer> value of the receiver's 'wMinute' field."

	^bytes wordAtOffset: _OffsetOf_wMinute!

wMinute: anInteger
	"Set the receiver's 'wMinute' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wMinute put: anInteger!

wMonth
	"Answer the <Integer> value of the receiver's 'wMonth' field."

	^bytes wordAtOffset: _OffsetOf_wMonth!

wMonth: anInteger
	"Set the receiver's 'wMonth' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wMonth put: anInteger!

wSecond
	"Answer the <Integer> value of the receiver's 'wSecond' field."

	^bytes wordAtOffset: _OffsetOf_wSecond!

wSecond: anInteger
	"Set the receiver's 'wSecond' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wSecond put: anInteger!

wYear
	"Answer the <Integer> value of the receiver's 'wYear' field."

	^bytes wordAtOffset: _OffsetOf_wYear!

wYear: anInteger
	"Set the receiver's 'wYear' field to the value of the argument, anInteger"

	bytes wordAtOffset: _OffsetOf_wYear put: anInteger!

year
	^self wYear! !
!SYSTEMTIME categoriesForMethods!
asDateAndTime!converting!public! !
asFILETIME!converting!public! !
asSYSTEMTIME!public! !
dayOfMonth!accessing!public! !
dayOfWeek!accessing!public! !
displayOn:!displaying!public! !
hour!accessing!public! !
hour12!accessing!public! !
hour24!accessing!public! !
minute!accessing!public! !
month!accessing!public! !
second!accessing!public! !
wDay!**compiled accessors**!public! !
wDay:!**compiled accessors**!public! !
wDayOfWeek!**compiled accessors**!public! !
wDayOfWeek:!**compiled accessors**!public! !
wHour!**compiled accessors**!public! !
wHour:!**compiled accessors**!public! !
wMilliseconds!**compiled accessors**!public! !
wMilliseconds:!**compiled accessors**!public! !
wMinute!**compiled accessors**!public! !
wMinute:!**compiled accessors**!public! !
wMonth!**compiled accessors**!public! !
wMonth:!**compiled accessors**!public! !
wSecond!**compiled accessors**!public! !
wSecond:!**compiled accessors**!public! !
wYear!**compiled accessors**!public! !
wYear:!**compiled accessors**!public! !
year!accessing!public! !
!

!SYSTEMTIME class methodsFor!

day: day month: month year: year
	"Private - Answer a new instance of the receiver for the specified day, month, and year."

	^self new wDay: day; wMonth: month; wYear: year!

defineFields
	"Define the fields of the Win32 SYSTEMTIME structure

		SYSTEMTIME compileDefinition
	"

	self defineField: #wYear type: WORDField new;
		defineField: #wMonth type: WORDField new;
		defineField: #wDayOfWeek type: WORDField new;
		defineField: #wDay type: WORDField new;
		defineField: #wHour type: WORDField new;
		defineField: #wMinute type: WORDField new;
		defineField: #wSecond type: WORDField new;
		defineField: #wMilliseconds type: WORDField new	!

fromFILETIME: aFILETIME
	"Answer a new instance of the receiver instantiated from aFILETIME (which may be
	in local or UTC form).
	We double dispatch this back to the argument, aFILETIME, so that it can perform
	conversion from UTC if necessary."

	^aFILETIME asSYSTEMTIME!

getFieldNames
	^#(#wYear #wMonth #wDayOfWeek #wDay #wHour #wMinute #wSecond #wMilliseconds)!

now
	"Private - Answer the current Windows local time"
	
	| answer |
	answer := self new.
	KernelLibrary default getLocalTime: answer.
	^answer!

nowUTC
	"Answer the current time in UTC"

	| answer |
	answer := self new.
	KernelLibrary default getSystemTime: answer.
	^answer! !
!SYSTEMTIME class categoriesForMethods!
day:month:year:!instance creation!private! !
defineFields!public!template definition! !
fromFILETIME:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
now!instance creation!private! !
nowUTC!instance creation!public! !
!

