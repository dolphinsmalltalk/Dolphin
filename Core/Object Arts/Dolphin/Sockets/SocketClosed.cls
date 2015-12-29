"Filed out from Dolphin Smalltalk X6.1"!

SocketError subclass: #SocketClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SocketClosed guid: (GUID fromString: '{87B4C56A-026E-11D3-9FD7-00A0CC3E4A32}')!
SocketClosed comment: 'This exception signals that a remote Socket has been closed.'!
!SocketClosed categoriesForClass!Windows Sockets! !
!SocketClosed class methodsFor!

errorCode
	^WSAECONNRESET!

errorCodes
	^Array 
		with: self errorCode
		with: WSAECONNABORTED
		with: WSAEDISCON!

initialize
	self errorCodes do: [:each | ErrorClasses at: each put: self]!

uninitialize
	self errorCodes do: [:each | ErrorClasses removeKey: each ifAbsent: []]! !
!SocketClosed class categoriesFor: #errorCode!constants!private! !
!SocketClosed class categoriesFor: #errorCodes!constants!private! !
!SocketClosed class categoriesFor: #initialize!initializing!public! !
!SocketClosed class categoriesFor: #uninitialize!class hierarchy-removing!public! !

