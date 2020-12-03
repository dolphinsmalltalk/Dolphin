"Filed out from Dolphin Smalltalk 7"!

OS.Win32Structure subclass: #'OS.SYSTEMTIME'
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
		'_OffsetOf_wYear' -> 16r0
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
!OS.SYSTEMTIME categoriesFor: #asDateAndTime!converting!public! !
!OS.SYSTEMTIME categoriesFor: #asFILETIME!converting!public! !
!OS.SYSTEMTIME categoriesFor: #asSYSTEMTIME!public! !
!OS.SYSTEMTIME categoriesFor: #dayOfMonth!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #dayOfWeek!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #displayOn:!displaying!public! !
!OS.SYSTEMTIME categoriesFor: #hour!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #hour12!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #hour24!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #minute!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #month!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #second!accessing!public! !
!OS.SYSTEMTIME categoriesFor: #wDay!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wDay:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wDayOfWeek!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wDayOfWeek:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wHour!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wHour:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMilliseconds!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMilliseconds:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMinute!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMinute:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMonth!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wMonth:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wSecond!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wSecond:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wYear!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #wYear:!**compiled accessors**!public! !
!OS.SYSTEMTIME categoriesFor: #year!accessing!public! !

!OS.SYSTEMTIME class methodsFor!

day: day month: month year: year
	"Private - Answer a new instance of the receiver for the specified day, month, and year."

	^self new wDay: day; wMonth: month; wYear: year!

defineFields
	"Define the fields of the Win32 SYSTEMTIME structure

		SYSTEMTIME compileDefinition
	"

	self
		defineField: #wYear type: WORDField new;
		defineField: #wMonth type: WORDField new;
		defineField: #wDayOfWeek type: WORDField new;
		defineField: #wDay type: WORDField new;
		defineField: #wHour type: WORDField new;
		defineField: #wMinute type: WORDField new;
		defineField: #wSecond type: WORDField new;
		defineField: #wMilliseconds type: WORDField new!

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
!OS.SYSTEMTIME class categoriesFor: #day:month:year:!instance creation!private! !
!OS.SYSTEMTIME class categoriesFor: #defineFields!public!template definition! !
!OS.SYSTEMTIME class categoriesFor: #fromFILETIME:!instance creation!public! !
!OS.SYSTEMTIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!OS.SYSTEMTIME class categoriesFor: #now!instance creation!private! !
!OS.SYSTEMTIME class categoriesFor: #nowUTC!instance creation!public! !

