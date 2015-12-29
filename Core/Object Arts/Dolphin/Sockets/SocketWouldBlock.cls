"Filed out from Dolphin Smalltalk X6"!

SocketError subclass: #SocketWouldBlock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!
SocketWouldBlock guid: (GUID fromString: '{87B4C56C-026E-11D3-9FD7-00A0CC3E4A32}')!
SocketWouldBlock comment: 'This exception signals that a WinSock function call has been made that would normally cause a Socket to block the current thread. In the old asynchronous Sockets Connection package this was intercepted internally by the Socket to block the current Smalltalk process by waiting on a semaphore. It is no longer used in the new Dolphin Sockets package, and so should be considered deprecated.'!
!SocketWouldBlock categoriesForClass!Windows Sockets! !
!SocketWouldBlock class methodsFor!

errorCode
	^WSAEWOULDBLOCK!

initialize
	ErrorClasses at: self errorCode put: self!

uninitialize
	ErrorClasses removeKey: self errorCode ifAbsent: []! !
!SocketWouldBlock class categoriesFor: #errorCode!constants!private! !
!SocketWouldBlock class categoriesFor: #initialize!initializing!public! !
!SocketWouldBlock class categoriesFor: #uninitialize!class hierarchy-removing!public! !

