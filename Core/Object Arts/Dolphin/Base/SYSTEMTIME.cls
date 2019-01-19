"Filed out from Dolphin Smalltalk 7"!

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

asFILETIME
	"Answer a FILETIME corresponding to the receiver."

	^FILETIME fromSYSTEMTIME: self!

asTimeStamp
	"Answer a TimeStamp corresponding to the receiver."

	^TimeStamp fromSYSTEMTIME: self!

displayOn: aStream
	"Append a displayable representation of the receiver to aStream.
	Use the same display format as the system does, e.g. in Explorer, which is
	date followed by time separated by a space."

	| lc |
	lc := Locale default.
	aStream 
		nextPutAll: (lc printSysDate: self format: nil flags: 0);
		space;
		nextPutAll: (lc printTime: self format: nil flags: 0)
!

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

	bytes wordAtOffset: _OffsetOf_wYear put: anInteger! !
!SYSTEMTIME categoriesFor: #asFILETIME!converting!public! !
!SYSTEMTIME categoriesFor: #asTimeStamp!converting!public! !
!SYSTEMTIME categoriesFor: #displayOn:!displaying!public! !
!SYSTEMTIME categoriesFor: #wDay!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wDay:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wDayOfWeek!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wDayOfWeek:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wHour!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wHour:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMilliseconds!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMilliseconds:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMinute!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMinute:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMonth!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wMonth:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wSecond!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wSecond:!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wYear!**compiled accessors**!public! !
!SYSTEMTIME categoriesFor: #wYear:!**compiled accessors**!public! !

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
!SYSTEMTIME class categoriesFor: #day:month:year:!instance creation!private! !
!SYSTEMTIME class categoriesFor: #defineFields!initializing!public! !
!SYSTEMTIME class categoriesFor: #fromFILETIME:!instance creation!public! !
!SYSTEMTIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!SYSTEMTIME class categoriesFor: #now!instance creation!private! !
!SYSTEMTIME class categoriesFor: #nowUTC!instance creation!public! !

