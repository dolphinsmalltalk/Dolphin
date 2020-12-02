"Filed out from Dolphin Smalltalk 7"!

FILETIME subclass: #LocalFILETIME
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
LocalFILETIME guid: (GUID fromString: '{87b4c623-026e-11d3-9fd7-00a0cc3e4a32}')!
LocalFILETIME comment: 'LocalFILETIME is an ExternalStructure class to represent the Win32 FILETIMEs that are in local time, as opposed to the usual UTC of normal FILETIMEs. See <FILETIME> for further details.'!
!LocalFILETIME categoriesForClass!External-Data-Structured-Win32! !
!LocalFILETIME methodsFor!

asLocalTime
	"Answer the receiver in local time (which it is already)."

	^self!

asSYSTEMTIME
	"Answer the receiver converted to a SYSTEMTIME."

	^self basicAsSYSTEMTIME!

asUTC
	"Answer the receiver as a UTC FILETIME."

	^FILETIME fromLocalTime: self
! !
!LocalFILETIME categoriesFor: #asLocalTime!converting!public! !
!LocalFILETIME categoriesFor: #asSYSTEMTIME!converting!public! !
!LocalFILETIME categoriesFor: #asUTC!converting!public! !

!LocalFILETIME class methodsFor!

fromSYSTEMTIME: aSYSTEMTIME
	"Answer a file time from the specified SYSTEMTIME (assumed to be in
	local time)."

	| answer |
	answer := self new.
	(KernelLibrary default systemTimeToFileTime: aSYSTEMTIME lpFileTime: answer) 
		ifFalse: [^KernelLibrary default systemError].
	^answer!

now
	"Answer the current LocalFILETIME.
	Use the OLELibrary function if it is available.

		LocalFILETIME now
	"

	| lib answer |
	lib := KernelLibrary default.
	answer := LocalFILETIME new.
	lib getSystemTimePreciseAsFileTime: answer.
	"We can get away with passing in the same buffer for output as the input"
	(lib fileTimeToLocalTime: answer lpLocalFileTime: answer) ifFalse: [lib systemError].
	^answer! !
!LocalFILETIME class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!LocalFILETIME class categoriesFor: #now!instance creation!public! !

