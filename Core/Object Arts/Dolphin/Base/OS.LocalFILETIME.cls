"Filed out from Dolphin Smalltalk"!

OS.FILETIME
	subclass: #'OS.LocalFILETIME'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.LocalFILETIME guid: (Core.GUID fromString: '{87b4c623-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.LocalFILETIME comment: 'LocalFILETIME is an ExternalStructure class to represent the Win32 FILETIMEs that are in local time, as opposed to the usual UTC of normal FILETIMEs. See <FILETIME> for further details.'!

!OS.LocalFILETIME categoriesForClass!External-Data-Structured-Win32! !

!OS.LocalFILETIME methodsFor!

asLocalTime
	"Answer the receiver in local time (which it is already)."

	^self!

asSYSTEMTIME
	"Answer the receiver converted to a SYSTEMTIME."

	^self basicAsSYSTEMTIME!

asUTC
	"Answer the receiver as a UTC FILETIME."

	^FILETIME fromLocalTime: self!

displayOn: aPuttableStream
	"Append to the <puttableStream> argument a String whose characters are a representation of the receiver that an end-user might want to see. This will be in local time."

	| offset |
	offset := self offsetSeconds.
	(DateAndTime utcSeconds: self localSeconds - offset offset: offset) displayOn: aPuttableStream!

offsetSeconds
	"Answer the <number> of seconds this <FILETIME> is offset from UTC. It is assumed that the receiver expresses a time in the current platform timezone."

	^Locale timeZoneInformation offsetSeconds! !

!OS.LocalFILETIME categoriesForMethods!
asLocalTime!converting!public! !
asSYSTEMTIME!converting!public! !
asUTC!converting!public! !
displayOn:!printing!public! !
offsetSeconds!converting!public! !
!

!OS.LocalFILETIME class methodsFor!

fromDateAndTime: aDateAndTime
	^(FILETIME fromDateAndTime: aDateAndTime) asLocalTime!

fromSYSTEMTIME: aSYSTEMTIME
	"Answer a file time from the specified SYSTEMTIME (assumed to be in local time)."

	| answer |
	answer := self new.
	(Kernel32 systemTimeToFileTime: aSYSTEMTIME lpFileTime: answer) ifFalse: [^Kernel32 systemError].
	^answer!

now
	"Answer the current LocalFILETIME.
	Use the OLELibrary function if it is available.

		LocalFILETIME now
	"

	| answer |
	answer := self new.
	Kernel32 getSystemTimePreciseAsFileTime: answer.
	"We can get away with passing in the same buffer for output as the input"
	(Kernel32 fileTimeToLocalTime: answer lpLocalFileTime: answer) ifFalse: [Kernel32 systemError].
	^answer! !

!OS.LocalFILETIME class categoriesForMethods!
fromDateAndTime:!public! !
fromSYSTEMTIME:!instance creation!public! !
now!instance creation!public! !
!

