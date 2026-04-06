"Filed out from Dolphin Smalltalk"!

OS.Win32Error
	subclass: #'Net.SocketError'
	instanceVariableNames: ''
	classVariableNames: 'ErrorClasses'
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {
			'WSA_E_CANCELLED' -> 16r277F.
			'WSA_E_NO_MORE' -> 16r277E.
			'WSAEACCES' -> 16r271D.
			'WSAEADDRINUSE' -> 16r2740.
			'WSAEADDRNOTAVAIL' -> 16r2741.
			'WSAEAFNOSUPPORT' -> 16r273F.
			'WSAEALREADY' -> 16r2735.
			'WSAEBADF' -> 16r2719.
			'WSAECANCELLED' -> 16r2777.
			'WSAECONNABORTED' -> 16r2745.
			'WSAECONNREFUSED' -> 16r274D.
			'WSAECONNRESET' -> 16r2746.
			'WSAEDESTADDRREQ' -> 16r2737.
			'WSAEDISCON' -> 16r2775.
			'WSAEDQUOT' -> 16r2755.
			'WSAEFAULT' -> 16r271E.
			'WSAEHOSTDOWN' -> 16r2750.
			'WSAEHOSTUNREACH' -> 16r2751.
			'WSAEINPROGRESS' -> 16r2734.
			'WSAEINTR' -> 16r2714.
			'WSAEINVAL' -> 16r2726.
			'WSAEINVALIDPROCTABLE' -> 16r2778.
			'WSAEINVALIDPROVIDER' -> 16r2779.
			'WSAEISCONN' -> 16r2748.
			'WSAELOOP' -> 16r274E.
			'WSAEMFILE' -> 16r2728.
			'WSAEMSGSIZE' -> 16r2738.
			'WSAENAMETOOLONG' -> 16r274F.
			'WSAENETDOWN' -> 16r2742.
			'WSAENETRESET' -> 16r2744.
			'WSAENETUNREACH' -> 16r2743.
			'WSAENOBUFS' -> 16r2747.
			'WSAENOMORE' -> 16r2776.
			'WSAENOPROTOOPT' -> 16r273A.
			'WSAENOTCONN' -> 16r2749.
			'WSAENOTEMPTY' -> 16r2752.
			'WSAENOTSOCK' -> 16r2736.
			'WSAEOPNOTSUPP' -> 16r273D.
			'WSAEPFNOSUPPORT' -> 16r273E.
			'WSAEPROCLIM' -> 16r2753.
			'WSAEPROTONOSUPPORT' -> 16r273B.
			'WSAEPROTOTYPE' -> 16r2739.
			'WSAEPROVIDERFAILEDINIT' -> 16r277A.
			'WSAEREFUSED' -> 16r2780.
			'WSAEREMOTE' -> 16r2757.
			'WSAESHUTDOWN' -> 16r274A.
			'WSAESOCKTNOSUPPORT' -> 16r273C.
			'WSAESTALE' -> 16r2756.
			'WSAETIMEDOUT' -> 16r274C.
			'WSAETOOMANYREFS' -> 16r274B.
			'WSAEUSERS' -> 16r2754.
			'WSAEWOULDBLOCK' -> 16r2733.
			'WSAHOST_NOT_FOUND' -> 16r2AF9.
			'WSANO_DATA' -> 16r2AFC.
			'WSANO_RECOVERY' -> 16r2AFB.
			'WSANOTINITIALISED' -> 16r276D.
			'WSASERVICE_NOT_FOUND' -> 16r277C.
			'WSASYSCALLFAILURE' -> 16r277B.
			'WSASYSNOTREADY' -> 16r276B.
			'WSATRY_AGAIN' -> 16r2AFA.
			'WSATYPE_NOT_FOUND' -> 16r277D.
			'WSAVERNOTSUPPORTED' -> 16r276C
		}!

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

