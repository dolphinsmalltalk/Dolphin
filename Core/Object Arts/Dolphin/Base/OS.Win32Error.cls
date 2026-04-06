"Filed out from Dolphin Smalltalk"!

OS.HRESULTError
	subclass: #'OS.Win32Error'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'ERROR_ACCESS_DENIED' -> 16r5.
			'ERROR_ALREADY_EXISTS' -> 16rB7.
			'ERROR_FILE_EXISTS' -> 16r50.
			'ERROR_FILE_NOT_FOUND' -> 16r2.
			'ERROR_HANDLE_EOF' -> 16r26.
			'ERROR_INSUFFICIENT_BUFFER' -> 16r7A.
			'ERROR_INVALID_DATA' -> 16rD.
			'ERROR_INVALID_HANDLE' -> 16r6.
			'ERROR_INVALID_NAME' -> 16r7B.
			'ERROR_INVALID_PARAMETER' -> 16r57.
			'ERROR_INVALID_WINDOW_HANDLE' -> 16r578.
			'ERROR_MOD_NOT_FOUND' -> 16r7E.
			'ERROR_MORE_DATA' -> 16rEA.
			'ERROR_MR_MID_NOT_FOUND' -> 16r13D.
			'ERROR_NO_MORE_FILES' -> 16r12.
			'ERROR_NO_MORE_ITEMS' -> 16r103.
			'ERROR_NOACCESS' -> 16r3E6.
			'ERROR_NOT_READY' -> 16r15.
			'ERROR_OPERATION_ABORTED' -> 16r3E3.
			'ERROR_PATH_NOT_FOUND' -> 16r3.
			'ERROR_PROC_NOT_FOUND' -> 16r7F.
			'ERROR_SHARING_VIOLATION' -> 16r20.
			'ERROR_STACK_OVERFLOW' -> 16r3E9.
			'ERROR_SUCCESS' -> 16r0.
			'NO_ERROR' -> 16r0.
			'RO_E_CLOSED' -> -16r7FFFFFED.
			'RPC_S_INVALID_STRING_UUID' -> 16r6A9
		}!

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

	^(self fromHRESULT: (HRESULT status: anInteger facility: FACILITY_WIN32))
		messageText: aString;
		signal! !

!OS.Win32Error class categoriesForMethods!
signal:with:!instance creation!public! !
!

