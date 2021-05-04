"Filed out from Dolphin Smalltalk 7"!

Core.Tests.DolphinTest subclass: #SocketErrorTest
	instanceVariableNames: ''
	classVariableNames: ''
	imports: #(#{OS.WinSocketErrors})
	classInstanceVariableNames: ''
	classConstants: {}!
SocketErrorTest guid: (Core.GUID fromString: '{a421a921-77e2-485a-b403-fc20d4c13a43}')!
SocketErrorTest comment: ''!
!SocketErrorTest categoriesForClass!Unclassified! !
!SocketErrorTest methodsFor!

testSocketClosed
	self should: [SocketError signalWith: WSAECONNRESET] raise: SocketClosed!

testSocketWaitCancelled
	self should: [SocketError signalWith: WSAEINTR] raise: SocketWaitCancelled! !
!SocketErrorTest categoriesFor: #testSocketClosed!public!unit tests! !
!SocketErrorTest categoriesFor: #testSocketWaitCancelled!public!unit tests! !

