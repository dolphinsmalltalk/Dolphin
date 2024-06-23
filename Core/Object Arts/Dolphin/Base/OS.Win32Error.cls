"Filed out from Dolphin Smalltalk"!

OS.HRESULTError
	subclass: #'OS.Win32Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!

OS.Win32Error guid: (Core.GUID fromString: '{87b4c565-026e-11d3-9fd7-00a0cc3e4a32}')!

OS.Win32Error comment: ''!

!OS.Win32Error categoriesForClass!System-Exception Handling! !

!OS.Win32Error methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^{self statusCode. self messageText. self osErrorMessage}!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%2 (16r%1!!X!!: %3)'!

initialize
	"Private - Initialize the receiver's instance variables.
	Set the details to be the last error code reported
	by a system library (i.e. that retried by KernelLibrary>>getLastError)."

	self tag: (HRESULT status: Kernel32 getLastError facility: FACILITY_WIN32)! !

!OS.Win32Error categoriesForMethods!
_descriptionArguments!displaying!public! !
_descriptionFormat!displaying!public! !
initialize!initializing!private! !
!

!OS.Win32Error class methodsFor!

signal: aString with: anInteger
	"Raise a new instance of the receiver, with the <readableString> error message, aString, and <integer> Win32 error code, anInteger, initiating a search for an ExceptionHandler prepared to handle instances of the receiver. This method will not return to its sender, unless the new instance is resumable, and the handler which catches it directs that it should be resumed."

	^(self fromHRESULT: (HRESULT win32Error: anInteger))
		messageText: aString;
		signal! !

!OS.Win32Error class categoriesForMethods!
signal:with:!instance creation!public! !
!

