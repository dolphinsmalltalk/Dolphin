"Filed out from Dolphin Smalltalk"!

OS.Win32Error
	subclass: #'Net.SocketError'
	instanceVariableNames: ''
	classVariableNames: 'ErrorClasses'
	imports: #(#{OS.WinSocketConstants} #{OS.WinSocketErrors})
	classInstanceVariableNames: ''
	classConstants: {}!

Net.SocketError guid: (Core.GUID fromString: '{87b4c560-026e-11d3-9fd7-00a0cc3e4a32}')!

Net.SocketError comment: 'This exception signals that a general Socket error has occurred. The actual error can be identified using #statusCode and its textual description is available using #osErrorMessage.'!

!Net.SocketError categoriesForClass!Windows Sockets! !

!Net.SocketError methodsFor!

errorAsString
	"Answer a String representation of the error code."

	#deprecated. "6.0"
	^self osErrorMessage!

errorCode
	#deprecated. "6.0"
	^self statusCode! !

!Net.SocketError categoriesForMethods!
errorAsString!displaying!public! !
errorCode!accessing!public! !
!

!Net.SocketError class methodsFor!

basicSignalWith: anInteger 
	^self new signalWith: (HRESULT win32Error: anInteger)!

errorCode
	^Ws2_32 wsaGetLastError!

initialize
	ErrorClasses := LookupTable new.
	!

signal
	"Raise a new instance of the receiver containing the error code of the last socket error."

	self signalWith: self errorCode!

signalWith: anInteger 
	"Raise a new instance of the receiver containing the <integer> WSA
	error code parameter."

	^(ErrorClasses at: anInteger ifAbsent: [self]) basicSignalWith: anInteger
! !

!Net.SocketError class categoriesForMethods!
basicSignalWith:!instance creation!private! !
errorCode!enquiries!private! !
initialize!public! !
signal!instance creation!public! !
signalWith:!instance creation!public! !
!

