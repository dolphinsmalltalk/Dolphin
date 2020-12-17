"Filed out from Dolphin Smalltalk 7"!

DolphinTest subclass: #SocketErrorTest
	instanceVariableNames: ''
	classVariableNames: ''
	poolDictionaries: 'WinSocketErrors'
	classInstanceVariableNames: ''
	classConstants: {}!
SocketErrorTest guid: (GUID fromString: '{a421a921-77e2-485a-b403-fc20d4c13a43}')!
SocketErrorTest comment: ''!
!SocketErrorTest categoriesForClass!Unclassified! !
!SocketErrorTest methodsFor!

testSocketClosed
	self should: [SocketError signalWith: WSAECONNRESET] raise: SocketClosed!

testSocketWaitCancelled
	self should: [SocketError signalWith: WSAEINTR] raise: SocketWaitCancelled!

testSocketWouldBlock
	self should: [SocketError signalWith: WSAEWOULDBLOCK] raise: SocketWouldBlock! !
!SocketErrorTest categoriesFor: #testSocketClosed!public!unit tests! !
!SocketErrorTest categoriesFor: #testSocketWaitCancelled!public!unit tests! !
!SocketErrorTest categoriesFor: #testSocketWouldBlock!public!unit tests! !

