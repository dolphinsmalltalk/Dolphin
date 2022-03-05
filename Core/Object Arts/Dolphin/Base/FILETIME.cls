"Filed out from Dolphin Smalltalk"!

Win32Structure subclass: #FILETIME
	instanceVariableNames: ''
	classVariableNames: '_OffsetOf_dwHighDateTime _OffsetOf_dwLowDateTime UnixEpoch'
	poolDictionaries: ''
	classInstanceVariableNames: ''!
FILETIME guid: (GUID fromString: '{87b4c5f1-026e-11d3-9fd7-00a0cc3e4a32}')!
FILETIME addClassConstant: '_OffsetOf_dwHighDateTime' value: 16r4!
FILETIME addClassConstant: '_OffsetOf_dwLowDateTime' value: 16r0!
FILETIME comment: 'FILETIME is an ExternalStructure class to represent the Win32 FILETIME structure.

A FILETIME is a 64-bit integer count of the number of 100 nanosecond intervals since 01:00:00, 01 January 1601 UTC (i.e. not local time).

FILETIMEs are typically used to mark file creation/modification/access times with very high accurracy in a time zone independent manner.'!
!FILETIME categoriesForClass!External-Data-Structured-Win32! !
!FILETIME methodsFor!

asFILETIME
	"Answer the receiver as a FILETIME (which it is already)."

	^self!

asInteger
	"Answer a 64-bit integer specifying the number of 100 nanosecond intervals since the
	FILETIME epoch (01:00:00, 01 January 1601 UTC)."

	^bytes qwordAtOffset: 0!

asLocalTime
	"Answer the receiver converted to a local time (from UTC).
	N.B. There is no way of knowing if the receiver is already in local time
	(though this will always be the case for FILETIMEs provided by the OS)."

	| lib answer |
	answer := LocalFILETIME new.
	lib := KernelLibrary default.
	(lib fileTimeToLocalTime: self lpLocalFileTime: answer) ifFalse: [lib systemError].
	^answer!

asSYSTEMTIME
	"Answer the receiver converted to a SYSTEMTIME (first of
	all converting to local time)."

	"Implementation Note: Reproduce a little code to avoid
	creating a circular dependency on the subclass."

	| local |
	local := self class new.
	(KernelLibrary default fileTimeToLocalTime: self lpLocalFileTime: local) 
		ifFalse: [^KernelLibrary default systemError].
	^local basicAsSYSTEMTIME!

asUTC
	"Answer the receiver as a UTC FILETIME (which it is already)."

	^self!

basicAsSYSTEMTIME
	"Private - Answer the receiver converted to a <SYSTEMTIME>."

	| lib answer |
	answer := SYSTEMTIME new.
	lib := KernelLibrary default.
	(lib fileTimeToSystemTime: self lpSystemTime: answer) ifFalse: [lib systemError].
	^answer!

displayOn: aStream 
	"Append a textual representation of the receiver to aStream, suitable for an end user."

	aStream display: self asSYSTEMTIME!

integerValue: anInteger 
	"Set the number of 100-nanosecond intervals the receiver represents since the
	FILETIME epoch."

	bytes qwordAtOffset: 0 put: anInteger! !
!FILETIME categoriesForMethods!
asFILETIME!converting!public! !
asInteger!converting!public! !
asLocalTime!converting!public! !
asSYSTEMTIME!converting!public! !
asUTC!converting!public! !
basicAsSYSTEMTIME!converting!public! !
displayOn:!printing!public! !
integerValue:!accessing!public! !
!

!FILETIME class methodsFor!

defineFields
	"Define the fields of the Win32 FILETIME structure.

		typedef struct _FILETIME 
			DWORD dwLowDateTime;
			DWORD dwHighDateTime;
		 FILETIME, *PFILETIME, *LPFILETIME;

		FILETIME compileDefinition
	"

	self
		defineField: #dwLowDateTime type: DWORDField filler;
		defineField: #dwHighDateTime type: DWORDField filler!

fromInteger: anInteger 
	"Answer an instance of the receiver for the specified <integer> number
	of 100 nanosecond intervals since 01:00:00, 01 January 1601."

	^self new integerValue: anInteger!

fromLocalTime: aLocalFILETIME 
	"Answer a UTC file time from the specified local file time."

	| answer |
	answer := self new.
	(KernelLibrary default localFileTimeToFileTime: aLocalFILETIME lpFileTime: answer) 
		ifFalse: [^KernelLibrary default systemError].
	^answer!

fromSYSTEMTIME: aSYSTEMTIME 
	"Answer a file time from the specified SYSTEMTIME (assumed to be in
	local time)."

	^(LocalFILETIME fromSYSTEMTIME: aSYSTEMTIME) asUTC!

fromUnixTime: time_t 
	"Answer a file time from the specified time_t, where the argument is the number
	of seconds elapsed since midnight (00:00:00), January 1, 1970, coordinated
	universal time."

	^self fromInteger: UnixEpoch + (time_t * 10000000)!

getFieldNames
	^#()!

initialize
	"Private - Initialize the receiver's class variables.
		FILETIME initialize
	"

	| baseFiletime |
	baseFiletime := (SYSTEMTIME 
				day: 1
				month: 1
				year: 1970) asFILETIME.
	UnixEpoch := baseFiletime bytes qwordAtOffset: 0!

now
	"Answer the current FILETIME. 
		FILETIME now
	"

	| answer |
	answer := self new.
	"Note that avoiding GetSystemTimePreciseAsFileTime is deliberate, as the less precise value from GetSystemTimeAsFileTime is that used to update file write times, etc."
	KernelLibrary default getSystemTimeAsFileTime: answer.
	^answer! !
!FILETIME class categoriesForMethods!
defineFields!public!template definition! !
fromInteger:!instance creation!public! !
fromLocalTime:!instance creation!public! !
fromSYSTEMTIME:!instance creation!public! !
fromUnixTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
now!instance creation!public! !
!

