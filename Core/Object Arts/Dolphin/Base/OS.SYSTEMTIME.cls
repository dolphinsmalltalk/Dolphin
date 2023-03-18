"Filed out from Dolphin Smalltalk"!

OS.Win32Structure
	subclass: #'OS.SYSTEMTIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_OffsetOf_wDay' -> 16r6.
			'_OffsetOf_wDayOfWeek' -> 16r4.
			'_OffsetOf_wHour' -> 16r8.
			'_OffsetOf_wMilliseconds' -> 16rE.
			'_OffsetOf_wMinute' -> 16rA.
			'_OffsetOf_wMonth' -> 16r2.
			'_OffsetOf_wSecond' -> 16rC.
			'_OffsetOf_wYear' -> 16r0.
			'_SYSTEMTIME_Size' -> 16r10
		}!
OS.SYSTEMTIME guid: (Core.GUID fromString: '{87b4c612-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.SYSTEMTIME comment: ''!
!OS.SYSTEMTIME categoriesForClass!Win32-Structs! !
!OS.SYSTEMTIME methodsFor!

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

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see."

	aPuttableStream locale displayDateTime: self on: aPuttableStream!

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

	^bytes uint16AtOffset: _OffsetOf_wDay!

wDay: anInteger
	"Set the receiver's 'wDay' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wDay put: anInteger!

wDayOfWeek
	"Answer the <Integer> value of the receiver's 'wDayOfWeek' field."

	^bytes uint16AtOffset: _OffsetOf_wDayOfWeek!

wDayOfWeek: anInteger
	"Set the receiver's 'wDayOfWeek' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wDayOfWeek put: anInteger!

wHour
	"Answer the <Integer> value of the receiver's 'wHour' field."

	^bytes uint16AtOffset: _OffsetOf_wHour!

wHour: anInteger
	"Set the receiver's 'wHour' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wHour put: anInteger!

wMilliseconds
	"Answer the <Integer> value of the receiver's 'wMilliseconds' field."

	^bytes uint16AtOffset: _OffsetOf_wMilliseconds!

wMilliseconds: anInteger
	"Set the receiver's 'wMilliseconds' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wMilliseconds put: anInteger!

wMinute
	"Answer the <Integer> value of the receiver's 'wMinute' field."

	^bytes uint16AtOffset: _OffsetOf_wMinute!

wMinute: anInteger
	"Set the receiver's 'wMinute' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wMinute put: anInteger!

wMonth
	"Answer the <Integer> value of the receiver's 'wMonth' field."

	^bytes uint16AtOffset: _OffsetOf_wMonth!

wMonth: anInteger
	"Set the receiver's 'wMonth' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wMonth put: anInteger!

wSecond
	"Answer the <Integer> value of the receiver's 'wSecond' field."

	^bytes uint16AtOffset: _OffsetOf_wSecond!

wSecond: anInteger
	"Set the receiver's 'wSecond' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wSecond put: anInteger!

wYear
	"Answer the <Integer> value of the receiver's 'wYear' field."

	^bytes uint16AtOffset: _OffsetOf_wYear!

wYear: anInteger
	"Set the receiver's 'wYear' field to the value of the argument, anInteger"

	bytes uint16AtOffset: _OffsetOf_wYear put: anInteger!

year
	^self wYear! !
!OS.SYSTEMTIME categoriesForMethods!
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

!OS.SYSTEMTIME class methodsFor!

byteSize
	^_SYSTEMTIME_Size!

day: day month: month year: year
	"Private - Answer a new instance of the receiver for the specified day, month, and year."

	^self new wDay: day; wMonth: month; wYear: year!

defineFields
	"Define the fields of the Win32 SYSTEMTIME structure

		SYSTEMTIME compileDefinition
	"

	self
		defineField: #wYear type: UInt16Field new;
		defineField: #wMonth type: UInt16Field new;
		defineField: #wDayOfWeek type: UInt16Field new;
		defineField: #wDay type: UInt16Field new;
		defineField: #wHour type: UInt16Field new;
		defineField: #wMinute type: UInt16Field new;
		defineField: #wSecond type: UInt16Field new;
		defineField: #wMilliseconds type: UInt16Field new!

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
	Kernel32 getLocalTime: answer.
	^answer!

nowUTC
	"Answer the current time in UTC"

	| answer |
	answer := self new.
	Kernel32 getSystemTime: answer.
	^answer! !
!OS.SYSTEMTIME class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
day:month:year:!instance creation!private! !
defineFields!public!template definition! !
fromFILETIME:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
now!instance creation!private! !
nowUTC!instance creation!public! !
!

