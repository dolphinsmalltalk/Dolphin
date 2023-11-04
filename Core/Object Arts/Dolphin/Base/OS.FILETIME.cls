"Filed out from Dolphin Smalltalk"!

External.Structure
	subclass: #'OS.FILETIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'_FILETIME_Size' -> 16r8.
			'_OffsetOf_dwHighDateTime' -> 16r4.
			'_OffsetOf_dwLowDateTime' -> 16r0.
			'SmalltalkEpoch' -> 16r150560D76A70000.
			'UnixEpoch' -> 16r19DB1DED53E8000
		}!
OS.FILETIME guid: (Core.GUID fromString: '{87b4c5f1-026e-11d3-9fd7-00a0cc3e4a32}')!
OS.FILETIME comment: 'FILETIME is an ExternalStructure class to represent the Win32 FILETIME structure.

A FILETIME is a 64-bit integer count of the number of 100 nanosecond intervals since 01:00:00, 01 January 1601 UTC (i.e. not local time).

FILETIMEs are typically used to mark file creation/modification/access times with very high accurracy in a time zone independent manner.'!
!OS.FILETIME categoriesForClass!External-Data-Structured-Win32! !
!OS.FILETIME methodsFor!

asDateAndTime
	"A Windows FILETIME expresses the number of 100nS intervals that have elapsed since 1601-01-01T00:00:00+00:00

		(DateAndTime year: 1601 day: 1 offset: 0 seconds) asSeconds = -9467020800
	"

	| offset |
	offset := self offsetSeconds.
	^DateAndTime utcSeconds: self localSeconds - offset offset: offset!

asFILETIME
	"Answer the receiver as a FILETIME (which it is already)."

	^self!

asInteger
	"Answer a 64-bit integer specifying the number of 100 nanosecond intervals since the
	FILETIME epoch (01:00:00, 01 January 1601 UTC)."

	^bytes uint64AtOffset: 0!

asLocalTime
	"Answer the receiver converted to a local time (from UTC).
	N.B. There is no way of knowing if the receiver is already in local time
	(though this will always be the case for FILETIMEs provided by the OS)."

	| answer |
	answer := LocalFILETIME new.
	(Kernel32 fileTimeToLocalTime: self lpLocalFileTime: answer) ifFalse: [Kernel32 systemError].
	^answer!

asSeconds
	"Answer a <rational> that is the number of seconds (including fractional part) that the receiver is past the traditional Smalltalk Epoch (i.e. 1901-01-01T00:00:00+00:00).
	Note that this is a UTC value, and is likely to be a <LargeInteger>, or a <Fraction> with <LargeInteger> numerator (and possibly denominator)."

	^self localSeconds - self offsetSeconds!

asSYSTEMTIME
	"Answer the receiver converted to a SYSTEMTIME (first of
	all converting to local time)."

	"Implementation Note: Reproduce a little code to avoid
	creating a circular dependency on the subclass."

	| local |
	local := self class new.
	(Kernel32 fileTimeToLocalTime: self lpLocalFileTime: local) ifFalse: [^Kernel32 systemError].
	^local basicAsSYSTEMTIME!

asUTC
	"Answer the receiver as a UTC FILETIME (which it is already)."

	^self!

basicAsSYSTEMTIME
	"Private - Answer the receiver converted to a <SYSTEMTIME>."

	| answer |
	answer := SYSTEMTIME new.
	(Kernel32 fileTimeToSystemTime: self lpSystemTime: answer) ifFalse: [Kernel32 systemError].
	^answer!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see. This will be in local time."

	self asDateAndTime displayOn: aPuttableStream!

integerValue: anInteger 
	"Set the number of 100-nanosecond intervals the receiver represents since the
	FILETIME epoch."

	bytes uint64AtOffset: 0 put: anInteger!

localSeconds
	"Answer a <rational> that is the number of seconds (including fractional part) that the receiver is past the traditional Smalltalk Epoch (i.e. 1901-01-01T00:00:00+00:00) in local time.
	Note that is likely to be a <LargeInteger>, or a <Fraction> with <LargeInteger> numerator (and possibly denominator)."

	^(self asInteger - SmalltalkEpoch) / 1e7!

offsetSeconds
	"Answer the <number> of seconds this <FILETIME> is offset from UTC."

	^0! !
!OS.FILETIME categoriesForMethods!
asDateAndTime!converting!public! !
asFILETIME!converting!public! !
asInteger!converting!public! !
asLocalTime!converting!public! !
asSeconds!converting!public! !
asSYSTEMTIME!converting!public! !
asUTC!converting!public! !
basicAsSYSTEMTIME!converting!public! !
displayOn:!printing!public! !
integerValue:!accessing!public! !
localSeconds!converting!public! !
offsetSeconds!converting!public! !
!

!OS.FILETIME class methodsFor!

byteSize
	^_FILETIME_Size!

defineFields
	"Define the fields of the Win32 FILETIME structure.

		typedef struct _FILETIME 
			DWORD dwLowDateTime;
			DWORD dwHighDateTime;
		 FILETIME, *PFILETIME, *LPFILETIME;

		FILETIME compileDefinition
	"

	self
		defineField: #dwLowDateTime type: UInt32Field filler;
		defineField: #dwHighDateTime type: UInt32Field filler!

fromDateAndTime: aDateAndTime
	"Answer a <FILETIME> equivalent to the specified <DateAndTime>"

	^self fromInteger: (SmalltalkEpoch + (aDateAndTime asSeconds * 1e7)) truncated!

fromInteger: anInteger 
	"Answer an instance of the receiver for the specified <integer> number
	of 100 nanosecond intervals since 01:00:00, 01 January 1601."

	^self new integerValue: anInteger!

fromLocalTime: aLocalFILETIME
	"Answer a UTC file time from the specified local file time."

	| answer |
	answer := self new.
	(Kernel32 localFileTimeToFileTime: aLocalFILETIME lpFileTime: answer)
		ifFalse: [^Kernel32 systemError].
	^answer!

fromSYSTEMTIME: aSYSTEMTIME
	"Answer a file time from the specified SYSTEMTIME (assumed to be in local time)."

	| answer localTime |
	localTime := ByteArray newFixed: _FILETIME_Size.
	(Kernel32 systemTimeToFileTime: aSYSTEMTIME lpFileTime: localTime) ifFalse: [^Kernel32 systemError].
	answer := self newBuffer.
	(Kernel32 localFileTimeToFileTime: localTime lpFileTime: answer) ifFalse: [^Kernel32 systemError].
	^answer!

fromUnixTime: time_t 
	"Answer a file time from the specified time_t, where the argument is the number
	of seconds elapsed since midnight (00:00:00), January 1, 1970, coordinated
	universal time."

	^self fromInteger: UnixEpoch + (time_t * 1e7)!

getFieldNames
	^#()!

initialize
	"Private - Initialize the receiver's class variables.
		FILETIME initialize
	"

	| filetimeEpoch |
	filetimeEpoch := (DateAndTime year: 1601 day: 1 offset: 0 seconds) asSeconds.
	self addClassConstant: 'UnixEpoch'
		value: (0 - filetimeEpoch + (DateAndTime year: 1970 day: 1 offset: 0 seconds) asSeconds) * 1e7.
	self addClassConstant: 'SmalltalkEpoch' value: (0 - filetimeEpoch) * 1e7!

now
	"Answer the current FILETIME. 
		FILETIME now
	"

	| answer |
	answer := self new.
	"Note that avoiding GetSystemTimePreciseAsFileTime is deliberate, as the less precise value from GetSystemTimeAsFileTime is that used to update file write times, etc."
	Kernel32 getSystemTimeAsFileTime: answer.
	^answer! !
!OS.FILETIME class categoriesForMethods!
byteSize!**compiled accessors**!constants!public! !
defineFields!public!template definition! !
fromDateAndTime:!instance creation!public! !
fromInteger:!instance creation!public! !
fromLocalTime:!instance creation!public! !
fromSYSTEMTIME:!instance creation!public! !
fromUnixTime:!instance creation!public! !
getFieldNames!**compiled accessors**!constants!private! !
initialize!development!initializing!private! !
now!instance creation!public! !
!

