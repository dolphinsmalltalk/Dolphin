"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #SYSTEMTIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SYSTEMTIME guid: (GUID fromString: '{87b4c612-026e-11d3-9fd7-00a0cc3e4a32}')!
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

printOn: aStream
	"Append a debugging representation of the receiver to aStream."

	aStream 
		basicPrint: self;
		nextPut: $(; 
		display: self; 
		nextPut: $)
!

wDay
	"Answer the receiver's wDay field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wDay)!

wDay: anObject 
	"Set the receiver's wDay field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wDay) put: anObject!

wDayOfWeek
	"Answer the receiver's wDayOfWeek field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wDayOfWeek)!

wDayOfWeek: anObject 
	"Set the receiver's wDayOfWeek field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wDayOfWeek) put: anObject!

wHour
	"Answer the receiver's wHour field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wHour)!

wHour: anObject 
	"Set the receiver's wHour field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wHour) put: anObject!

wMilliseconds
	"Answer the receiver's wMilliseconds field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMilliseconds)!

wMilliseconds: anObject 
	"Set the receiver's wMilliseconds field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wMilliseconds) put: anObject!

wMinute
	"Answer the receiver's wMinute field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMinute)!

wMinute: anObject 
	"Set the receiver's wMinute field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wMinute) put: anObject!

wMonth
	"Answer the receiver's wMonth field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wMonth)!

wMonth: anObject 
	"Set the receiver's wMonth field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wMonth) put: anObject!

wSecond
	"Answer the receiver's wSecond field as a Smalltalk object."

	^bytes wordAtOffset: ##(self offsetOf: #wSecond)!

wSecond: anObject 
	"Set the receiver's wSecond field to the value of anObject."

	bytes wordAtOffset: ##(self offsetOf: #wSecond) put: anObject!

wYear
	"Answer the receiver's wYear field as a Smalltalk object."

	^bytes wordAtOffset: 0!

wYear: anObject 
	"Set the receiver's wYear field to the value of anObject."

	bytes wordAtOffset: 0 put: anObject! !
!SYSTEMTIME categoriesFor: #asFILETIME!converting!public! !
!SYSTEMTIME categoriesFor: #asTimeStamp!converting!public! !
!SYSTEMTIME categoriesFor: #displayOn:!displaying!public! !
!SYSTEMTIME categoriesFor: #printOn:!development!printing!public! !
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
!SYSTEMTIME class categoriesFor: #now!instance creation!private! !
!SYSTEMTIME class categoriesFor: #nowUTC!instance creation!public! !

