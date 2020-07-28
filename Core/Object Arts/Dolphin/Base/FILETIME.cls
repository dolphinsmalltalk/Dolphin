"Filed out from Dolphin Smalltalk 7"!

Win32Structure subclass: #FILETIME
	instanceVariableNames: ''
	classVariableNames: 'UnixEpoch'
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {
		'_OffsetOf_dwHighDateTime' -> 16r4.
		'_OffsetOf_dwLowDateTime' -> 16r0
	}!
FILETIME guid: (GUID fromString: '{87b4c5f1-026e-11d3-9fd7-00a0cc3e4a32}')!
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

displayOn: aPuttableStream
	"Append to the <puttableStream> first argument a String whose characters are a representation of the receiver that an end-user might want to see."

	self asSYSTEMTIME displayOn: aPuttableStream!

integerValue: anInteger 
	"Set the number of 100-nanosecond intervals the receiver represents since the
	FILETIME epoch."

	bytes qwordAtOffset: 0 put: anInteger! !
!FILETIME categoriesFor: #asFILETIME!converting!public! !
!FILETIME categoriesFor: #asInteger!converting!public! !
!FILETIME categoriesFor: #asLocalTime!converting!public! !
!FILETIME categoriesFor: #asSYSTEMTIME!converting!public! !
!FILETIME categoriesFor: #asUTC!converting!public! !
!FILETIME categoriesFor: #basicAsSYSTEMTIME!converting!public! !
!FILETIME categoriesFor: #displayOn:!printing!public! !
!FILETIME categoriesFor: #integerValue:!accessing!public! !

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
!FILETIME class categoriesFor: #defineFields!public!template definition! !
!FILETIME class categoriesFor: #fromInteger:!instance creation!public! !
!FILETIME class categoriesFor: #fromLocalTime:!instance creation!public! !
!FILETIME class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!FILETIME class categoriesFor: #fromUnixTime:!instance creation!public! !
!FILETIME class categoriesFor: #getFieldNames!**compiled accessors**!constants!private! !
!FILETIME class categoriesFor: #initialize!development!initializing!private! !
!FILETIME class categoriesFor: #now!instance creation!public! !

