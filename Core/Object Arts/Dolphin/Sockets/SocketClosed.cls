"Filed out from Dolphin Smalltalk 7"!

SocketError subclass: #SocketClosed
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''
	classConstants: {}!
SocketClosed guid: (GUID fromString: '{87b4c56a-026e-11d3-9fd7-00a0cc3e4a32}')!
SocketClosed comment: 'This exception signals that a remote Socket has been closed.'!
!SocketClosed categoriesForClass!Windows Sockets! !
!SocketClosed class methodsFor!

errorCode
	^WSAECONNRESET!

errorCodes
	^{self errorCode. WSAECONNABORTED. WSAEDISCON}!

initialize
	self errorCodes do: [:each | ErrorClasses at: each put: self]!

uninitialize
	self errorCodes do: [:each | ErrorClasses removeKey: each ifAbsent: []]! !
!SocketClosed class categoriesFor: #errorCode!constants!private! !
!SocketClosed class categoriesFor: #errorCodes!constants!private! !
!SocketClosed class categoriesFor: #initialize!initializing!public! !
!SocketClosed class categoriesFor: #uninitialize!class hierarchy-removing!public! !

