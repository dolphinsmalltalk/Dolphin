"Filed out from Dolphin Smalltalk"!

OS.Win32Error
	subclass: #'OS.Win32Fault'
	instanceVariableNames: 'exceptionRecord'
	classVariableNames: 'ExceptionNames'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
OS.Win32Fault guid: (Core.GUID fromString: '{3b2fccea-10b3-4da2-9932-179927f451a2}')!
OS.Win32Fault comment: ''!
!OS.Win32Fault categoriesForClass!System-Exception Handling! !
!OS.Win32Fault methodsFor!

_descriptionArguments
	"Answer the arguments to be substitued into the receiver's Win32 description format String."

	^super _descriptionArguments , {self exceptionName. self exceptionAddress. self moduleFileName}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%4 at IP 0x%5!!X!! (%6)'!

exceptionAddress
	"Answer the code address at which the exception occurred."

	^exceptionRecord ExceptionAddress!

exceptionCode
	"Answer the <integer> Win32 exception code associated with the receiver."

	^exceptionRecord ExceptionCode!

exceptionName
	"Answer the <readableString> name of the Win32 exception code associated with the receiver."

	^ExceptionNames
		at: self exceptionCode ifAbsent: [self exceptionCode hex]!

exceptionRecord
	"Answer an <EXCEPTION_RECORD> detailing the original Win32 structured exception."

	^exceptionRecord!

exceptionRecord: anEXCEPTION_RECORD
	"Private - Set the EXCEPTION_RECORD from the Win32 exception."

	exceptionRecord := anEXCEPTION_RECORD.
	self tag: (self tagFromExceptionCode: anEXCEPTION_RECORD ExceptionCode)
!

initialize
	"Override the superclass implementation as we don't need to do any initialization."
!

moduleFileName
	"Answer the name of the DLL/EXE in which code was being executed when the exception occurred (i.e. the originating module)."

	^exceptionRecord moduleFileName!

tagFromExceptionCode: anInteger
	"Private - Answer the HRESULT tag for the receiver from the Win32 exception
	code, anInteger."

	^HRESULT ntStatusCode: anInteger! !
!OS.Win32Fault categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
exceptionAddress!accessing!public! !
exceptionCode!accessing!public! !
exceptionName!accessing!public! !
exceptionRecord!accessing!public! !
exceptionRecord:!accessing!private! !
initialize!initializing!public! !
moduleFileName!accessing!public! !
tagFromExceptionCode:!accessing!private! !
!

!OS.Win32Fault class methodsFor!

initialize
	"Private - Initialize the receiver's class variables.
		self initialize
	"

	ExceptionNames := LookupTable new.
	ExceptionNames
		at: 16rC0000005 put: (HRESULT fromInteger: ERROR_NOACCESS) displayString;
		at: 16r80000002 put: (ExceptionNames at: 16rC0000005);
		at: 16rC0000017 put: (HRESULT fromInteger: 8) displayString;
		at: 16rC000008C put: 'Array subscript out of bounds';
		at: 16rC0000092 put: 'Floating point stack underflow/overflow';
		at: 16rC0000095 put: (HRESULT fromInteger: 534) displayString;
		at: 16rC0000096 put: 'Priviledged instruction';
		at: 16rC0000006 put: (HRESULT fromInteger: 999) displayString;
		at: 16rC000001D put: 'Illegal instruction';
		at: 16rC0000026 put: 'Invalid disposition';
		at: 16rC0000008 put: (HRESULT fromInteger: 6) displayString;
		shrink!

signal: messageText with: anEXCEPTION_RECORD
	"Raise a new instance of the receiver, representing an invalid attempt to access
	the memory at the location, anAddress."

	^self new 
		exceptionRecord: anEXCEPTION_RECORD;
		signal! !
!OS.Win32Fault class categoriesForMethods!
initialize!development!initializing!private! !
signal:with:!instance creation!public! !
!

