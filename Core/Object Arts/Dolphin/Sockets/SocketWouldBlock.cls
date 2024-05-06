"Filed out from Dolphin Smalltalk"!

SocketError subclass: #SocketWouldBlock
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: ''
	classInstanceVariableNames: ''!

SocketWouldBlock guid: (GUID fromString: '{87b4c56c-026e-11d3-9fd7-00a0cc3e4a32}')!

SocketWouldBlock comment: 'This exception signals that a WinSock function call has been made that would normally cause a Socket to block the current thread. In the old asynchronous Sockets Connection package this was intercepted internally by the Socket to block the current Smalltalk process by waiting on a semaphore. It is no longer used in the new Dolphin Sockets package, and so should be considered deprecated.'!

!SocketWouldBlock categoriesForClass!Windows Sockets! !

!SocketWouldBlock class methodsFor!

errorCode
	^WSAEWOULDBLOCK!

initialize
	ErrorClasses at: self errorCode put: self!

uninitialize
	ErrorClasses removeKey: self errorCode ifAbsent: []! !

!SocketWouldBlock class categoriesForMethods!
errorCode!constants!private! !
initialize!initializing!public! !
uninitialize!class hierarchy-removing!public! !
!

