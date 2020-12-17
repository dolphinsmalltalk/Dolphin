"Filed out from Dolphin Smalltalk 7"!

Net.SocketError subclass: #'Net.SocketClosed'
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #()
	classInstanceVariableNames: ''
	classConstants: {}!
Net.SocketClosed guid: (Core.GUID fromString: '{87b4c56a-026e-11d3-9fd7-00a0cc3e4a32}')!
Net.SocketClosed comment: 'This exception signals that a remote Socket has been closed.'!
!Net.SocketClosed categoriesForClass!Windows Sockets! !
!Net.SocketClosed class methodsFor!

errorCode
	^WSAECONNRESET!

errorCodes
	^{self errorCode. WSAECONNABORTED. WSAEDISCON}!

initialize
	self errorCodes do: [:each | ErrorClasses at: each put: self]!

uninitialize
	self errorCodes do: [:each | ErrorClasses removeKey: each ifAbsent: []]! !
!Net.SocketClosed class categoriesFor: #errorCode!constants!private! !
!Net.SocketClosed class categoriesFor: #errorCodes!constants!private! !
!Net.SocketClosed class categoriesFor: #initialize!initializing!public! !
!Net.SocketClosed class categoriesFor: #uninitialize!class hierarchy-removing!public! !

