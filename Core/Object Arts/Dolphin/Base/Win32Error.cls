"Filed out from Dolphin Smalltalk X6"!

HRESULTError subclass: #Win32Error
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
Win32Error guid: (GUID fromString: '{87B4C565-026E-11D3-9FD7-00A0CC3E4A32}')!
Win32Error comment: ''!
!Win32Error categoriesForClass!System-Exception Handling! !
!Win32Error methodsFor!

_descriptionArguments
	"Answer the arguments to be substituted into the receiver's Win32 description format String."

	^Array 
		with: self statusCode 
		with: self messageText 
		with: self osErrorMessage
!

_descriptionFormat
	"Answer the Win32 format String to be used to format the description for the receiver."

	^'%2 (16r%1!!X!!: %3)'!

initialize
	"Private - Initialize the receiver's instance variables.
	Set the details to be the last error code reported
	by a system library (i.e. that retried by KernelLibrary>>getLastError)."

	self tag: (HRESULT status: KernelLibrary default getLastError facility: FACILITY_WIN32)! !
!Win32Error categoriesFor: #_descriptionArguments!displaying!public! !
!Win32Error categoriesFor: #_descriptionFormat!displaying!public! !
!Win32Error categoriesFor: #initialize!initializing!private! !

!Win32Error class methodsFor!

signal: messageText with: anInteger 
	"Raise a new instance of the receiver, with the error message, msg, initiating a search for an 
	ExceptionHandler prepared to handle instances of the receiver. This method will not return to its 
	sender, unless the new instance is resumable, and the handler which catches it directs that it 
	should be resumed."

	self signalHRESULT: (HRESULT win32Error: anInteger)! !
!Win32Error class categoriesFor: #signal:with:!instance creation!public! !

