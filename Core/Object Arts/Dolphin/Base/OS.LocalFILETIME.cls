"Filed out from Dolphin Smalltalk 7"!

OS.FILETIME subclass: #'OS.LocalFILETIME'
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

	^FILETIME fromLocalTime: self! !
!OS.LocalFILETIME categoriesFor: #asLocalTime!converting!public! !
!OS.LocalFILETIME categoriesFor: #asSYSTEMTIME!converting!public! !
!OS.LocalFILETIME categoriesFor: #asUTC!converting!public! !

!OS.LocalFILETIME class methodsFor!

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
!OS.LocalFILETIME class categoriesFor: #fromSYSTEMTIME:!instance creation!public! !
!OS.LocalFILETIME class categoriesFor: #now!instance creation!public! !

